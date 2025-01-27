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
// Author: David Mallasén <dmallase@ucm.es>
// Description: Coprosit execution stage. This wraps the PRAU and the ALU
//   into a single module.

module coprosit_ex_stage #(
  parameter int unsigned XLEN = 64,
  parameter type         tag_t = logic
) (
  input  logic clk_i,
  input  logic rst_ni,

  // Input signals
  input  logic [XLEN-1:0]    operand_a_i,
  input  logic [XLEN-1:0]    operand_b_i,
  input  prau_pkg::prau_op_e operator_i,
  input  tag_t               tag_i,

  // Handshakes
  input  logic in_valid_i,
  output logic in_ready_o,
  output logic out_valid_o,
  input  logic out_ready_i,

  // Output signals
  output tag_t            tag_o,
  output logic [XLEN-1:0] result_o
);

  // Handshakes
  logic prau_in_ready;
  logic prau_out_valid;
  logic input_hs;
  logic output_hs;

  // Data signals
  logic [XLEN-1:0] prau_result;
  logic [XLEN-1:0] alu_result;

  // Register signals
  prau_pkg::prau_op_e operator_q;

  assign input_hs = in_valid_i & in_ready_o;
  assign output_hs = out_valid_o & out_ready_i;

  assign in_ready_o = prau_in_ready;  // The ALU is always ready
  assign out_valid_o = prau_out_valid;

  // =====================
  // Posit Arithmetic Unit
  // =====================

  prau_top #(
    .XLEN(XLEN),
    .tag_t(tag_t)
  ) prau_top_i (
    .clk_i(clk_i),
    .rst_ni(rst_ni),

    .operand_a_i(operand_a_i),
    .operand_b_i(operand_b_i),
    .operator_i(operator_i),
    .tag_i(tag_i),

    .in_valid_i(in_valid_i),
    .in_ready_o(prau_in_ready),
    .out_valid_o(prau_out_valid),
    .out_ready_i(out_ready_i),

    .tag_o(tag_o),
    .result_o(prau_result)
  );

  // =========
  // Posit ALU
  // =========

  coprosit_alu #(
    .XLEN(XLEN)
  ) coprosit_alu_i (
    .clk_i(clk_i),
    .rst_ni(rst_ni),

    .operand_a_i(operand_a_i[prau_pkg::POSLEN-1:0]),
    .operand_b_i(operand_b_i[prau_pkg::POSLEN-1:0]),
    .operator_i(operator_i),

    .input_hs(input_hs),
    .output_hs(output_hs),

    .result_o(alu_result)
  );

  // =============
  // Result output
  // =============

  always_comb begin
    if (operator_q inside {prau_pkg::PEQ, prau_pkg::PLT, prau_pkg::PLE, prau_pkg::PMIN,
                           prau_pkg::PMAX}) begin
      result_o = alu_result;
    end else begin
      result_o = prau_result;
    end
  end

  // =========
  // Registers
  // =========

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      operator_q <= prau_pkg::NONE;
    end else if (input_hs) begin
      operator_q <= operator_i;
    end else if (output_hs) begin
      operator_q <= prau_pkg::NONE;
    end
  end

endmodule  // coprosit_ex_stage
