// Copyright 2023 David Mallasén Quintana
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Licensed under the Solderpad Hardware License v 2.1 (the “License”); you
// may not use this file except in compliance with the License, or, at your
// option, the Apache License version 2.0. You may obtain a copy of the
// License at https://solderpad.org/licenses/SHL-2.1/
//
// Unless required by applicable law or agreed to in writing, any work
// distributed under the License is distributed on an “AS IS” BASIS, WITHOUT
// WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
// License for the specific language governing permissions and limitations
// under the License.
//
// Based on: FPU Subsystem Controller
// Contributor: Moritz Imfeld <moimfeld@student.eth.ch>
//
// Author: David Mallasén <dmallase@ucm.es>
// Description: Coprosit controller module.

module coprosit_controller #(
  parameter bit FORWARDING = 1
) (
  // Clock and Reset
  input  logic clk_i,
  input  logic rst_ni,

  // Predecoder
  input  logic [coprosit_pkg::X_NUM_RS-1:0] prd_rsp_use_gprs_i,

  // Issue Interface
  input  logic [coprosit_pkg::X_NUM_RS-1:0] xif_issue_req_rs_valid_i,
  output logic                              xif_issue_ready_o,

  // Commit Interface
  if_xif.coproc_commit xif_commit_if,

  // Input Buffer
  input  logic in_buf_push_ready_i,
  input  logic in_buf_pop_valid_i,
  output logic in_buf_pop_ready_o,

  // Register
  input  logic       rd_is_pos_i,
  input  logic [4:0] ex_out_addr_i,
  input  logic [4:0] posr_wb_addr_i,
  input  logic [4:0] rd_i,
  output logic       posr_we_o,

  // Dependency Check and Forwarding
  input  logic       rd_in_is_pos_i,
  input  logic [4:0] rs1_i,
  input  logic [4:0] rs2_i,
  output logic       dep_rs_o,
  output logic       dep_rd_o,
  output logic                     [coprosit_pkg::X_NUM_RS-1:0] ex_fwd_o,
  output logic                     [coprosit_pkg::X_NUM_RS-1:0] lsu_fwd_o,
  input  coprosit_pkg::op_select_e [coprosit_pkg::X_NUM_RS-1:0] op_select_i,

  // Memory Instruction
  input  logic is_load_i,
  input  logic is_store_i,

  // Memory Request/Repsonse Interface
  output logic xif_mem_valid_o,
  input  logic xif_mem_ready_i,
  output logic xif_mem_req_we_o,
  input  logic [coprosit_pkg::X_ID_WIDTH-1:0] xif_mem_req_id_i,

  // Memory Buffer
  output logic mem_push_valid_o,
  input  logic mem_push_ready_i,
  output logic mem_pop_ready_o,
  input  coprosit_pkg::mem_metadata_t mem_pop_data_i,

  // Memory Result Interface
  input  logic xif_mem_result_valid_i,

  // Execution stage
  input  logic                                use_copro_i,
  output logic                                ex_in_valid_o,
  input  logic                                ex_in_ready_i,
  input  logic [coprosit_pkg::X_ID_WIDTH-1:0] ex_in_id_i,
  input  logic                                ex_out_valid_i,
  output logic                                ex_out_ready_o,

  // Result Interface
  output logic                                xif_result_valid_o,
  input  logic [coprosit_pkg::X_ID_WIDTH-1:0] xif_result_id_i,
  output logic                                result_push_valid_o,
  input  logic                                result_pop_valid_i
);

  // Dependency check and forwarding
  logic [coprosit_pkg::X_NUM_RS-1:0] valid_operands;
  logic dep_rs1;
  logic dep_rs2;

  // Handshakes
  logic ex_in_hs;
  logic ex_out_hs;
  logic x_mem_req_hs;

  // Status signals and scoreboards
  logic instr_inflight;
  logic [31:0] rd_scoreboard_d;
  logic [31:0] rd_scoreboard_q;
  logic [2**coprosit_pkg::X_ID_WIDTH-1:0] commit_scoreboard_d;
  logic [2**coprosit_pkg::X_ID_WIDTH-1:0] commit_scoreboard_q;

  // ===============
  // Issue Interface
  // ===============

  assign xif_issue_ready_o = ((prd_rsp_use_gprs_i[0] & xif_issue_req_rs_valid_i[0])
                              | !prd_rsp_use_gprs_i[0])
                           & ((prd_rsp_use_gprs_i[1] & xif_issue_req_rs_valid_i[1])
                              | !prd_rsp_use_gprs_i[1])
                           & in_buf_push_ready_i;

  // ============
  // Input Buffer
  // ============

  always_comb begin
    in_buf_pop_ready_o = 1'b0;
    // TODO: Add commit interface in case the instruction is killed
    if (ex_in_hs | x_mem_req_hs) begin
      in_buf_pop_ready_o = 1'b1;
    end
  end

  // ===================
  // Posit Register File
  // ===================

  always_comb begin
    posr_we_o = 1'b0;
    if ((ex_out_hs & rd_is_pos_i) | (mem_pop_data_i.we & xif_mem_result_valid_i)) begin
      posr_we_o = 1'b1;
    end
  end

  // ===============================
  // Dependency Check and Forwarding
  // ===============================

  assign dep_rs1   = rd_scoreboard_q[rs1_i] & in_buf_pop_valid_i
                   & (op_select_i[0] == coprosit_pkg::RegA);
  assign dep_rs2   = rd_scoreboard_q[rs2_i] & in_buf_pop_valid_i
                   & (op_select_i[1] == coprosit_pkg::RegB);
  assign dep_rs_o  = (dep_rs1   & ~(ex_fwd_o[0] | lsu_fwd_o[0]))
                   | (dep_rs2   & ~(ex_fwd_o[1] | lsu_fwd_o[1]));
  assign dep_rd_o  = rd_scoreboard_q[rd_i] & rd_in_is_pos_i
                   & ~((ex_out_hs | xif_mem_result_valid_i)
                   & posr_we_o & (posr_wb_addr_i == rd_i));

  always_comb begin
    ex_fwd_o[0] = 1'b0;
    ex_fwd_o[1] = 1'b0;
    lsu_fwd_o[0] = 1'b0;
    lsu_fwd_o[1] = 1'b0;
    if (FORWARDING) begin
      valid_operands[0] = op_select_i[0] == coprosit_pkg::RegA;
      valid_operands[1] = op_select_i[1] == coprosit_pkg::RegB;

      ex_fwd_o[0] = valid_operands[0] & ex_out_hs & rd_is_pos_i & rs1_i == ex_out_addr_i;
      ex_fwd_o[1] = valid_operands[1] & ex_out_hs & rd_is_pos_i & rs2_i == ex_out_addr_i;

      lsu_fwd_o[0] = valid_operands[0] & xif_mem_result_valid_i & mem_pop_data_i.we
                   & rs1_i == mem_pop_data_i.rd;
      lsu_fwd_o[1] = valid_operands[1] & xif_mem_result_valid_i & mem_pop_data_i.we
                   & rs2_i == mem_pop_data_i.rd;
    end
  end

  // ==================================
  // Memory Interface and Memory Buffer
  // ==================================

  assign x_mem_req_hs = xif_mem_valid_o & xif_mem_ready_i;

  assign mem_push_valid_o = x_mem_req_hs;
  assign mem_pop_ready_o = xif_mem_result_valid_i;

  always_comb begin
    xif_mem_valid_o = 1'b0;
    if ((is_load_i | is_store_i) & ~dep_rs_o & ~dep_rd_o & in_buf_pop_valid_i & mem_push_ready_i
        & (commit_scoreboard_q[xif_mem_req_id_i] | commit_scoreboard_d[xif_mem_req_id_i])) begin
      xif_mem_valid_o = 1'b1;
    end
  end

  assign xif_mem_req_we_o = is_store_i;

  // ===============
  // Execution Stage
  // ===============

  // Keep track if there is an in-flight ex_stage instruction. This is
  // used to determine if the next ex_stage instruction can be accepted.
  // It is set when the instruction enters the ex_stage and cleared when
  // the instruction leaves the ex_stage if there is no new instruction
  // entering the ex_stage.
  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      instr_inflight <= 1'b0;
    end else if (ex_in_hs) begin
      instr_inflight <= 1'b1;
    end else if (ex_out_hs) begin
      instr_inflight <= 1'b0;
    end
  end

  assign ex_in_hs = ex_in_valid_o & ex_in_ready_i;
  assign ex_out_hs = ex_out_valid_i & ex_out_ready_o;

  assign ex_out_ready_o = ~xif_mem_result_valid_i;

  assign ex_in_valid_o = use_copro_i & in_buf_pop_valid_i
                          & (commit_scoreboard_q[ex_in_id_i] | commit_scoreboard_d[ex_in_id_i])
                          & ~dep_rs_o & ~dep_rd_o
                          & (ex_out_valid_i | ~instr_inflight);

  // ================
  // Result Interface
  // ================

  assign xif_result_valid_o = ex_out_valid_i | xif_mem_result_valid_i | result_pop_valid_i;
  assign result_push_valid_o = ex_out_hs | xif_mem_result_valid_i;

  // =============================
  // Status Signals and Scoreboard
  // =============================

  // Keep track of which posit registers will be written to
  always_comb begin
    rd_scoreboard_d = rd_scoreboard_q;

    // If ex_stage has its operands and the output is a posit OR we are conducting a valid load operation
    if ((ex_in_hs & rd_in_is_pos_i) | (x_mem_req_hs & is_load_i & in_buf_pop_valid_i)) begin
      rd_scoreboard_d[rd_i] = 1'b1;
    end

    // If the next operation will not write back to the same register as the current one
    if (ex_out_hs & ~(ex_in_hs & posr_wb_addr_i == rd_i)) begin
      rd_scoreboard_d[posr_wb_addr_i] = 1'b0;
    end else if (xif_mem_result_valid_i & mem_pop_data_i.we & ~(ex_in_hs & rd_in_is_pos_i
                & (mem_pop_data_i.rd == rd_i))) begin
      rd_scoreboard_d[mem_pop_data_i.rd] = 1'b0;
    end
  end

  // Commit scoreboard to keep track of which instructions are no longer
  // speculative. This is set by the commit interface and cleared when
  // the result transaction is performed.
  always_comb begin
    commit_scoreboard_d = commit_scoreboard_q;
    if (xif_commit_if.commit_valid & ~xif_commit_if.commit.commit_kill) begin
      commit_scoreboard_d[xif_commit_if.commit.id] = 1'b1;
    end
    if (xif_result_valid_o) begin
      commit_scoreboard_d[xif_result_id_i] = 1'b0;
    end
  end

  always_ff @(posedge clk_i, negedge rst_ni) begin : scoreboard_reg
    if (~rst_ni) begin
      rd_scoreboard_q     <= '0;
      commit_scoreboard_q <= '0;
    end else begin
      rd_scoreboard_q     <= rd_scoreboard_d;
      commit_scoreboard_q <= commit_scoreboard_d;
    end
  end

endmodule  // coprosit_controller
