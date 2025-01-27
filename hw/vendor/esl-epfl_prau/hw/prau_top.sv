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
// Description: Posit and quiRe Arithmetic Unit top-level module

module prau_top
  import prau_pkg::*;
#(
  parameter int unsigned XLEN  = 64,
  parameter type         tag_t = logic
) (
  input  logic clk_i,
  input  logic rst_ni,

  // Input signals
  input  logic [XLEN-1:0] operand_a_i,
  input  logic [XLEN-1:0] operand_b_i,
  input  prau_op_e operator_i,
  input  tag_t     tag_i,

  // Handshakes
  input  logic in_valid_i,
  output logic in_ready_o,
  output logic out_valid_o,
  input  logic out_ready_i,

  // Output signals
  output tag_t            tag_o,
  output logic [XLEN-1:0] result_o
);

  logic [XLEN-1:0] operand_a;
  logic [XLEN-1:0] operand_b;
  prau_op_e operator;

  logic [XLEN-1:0] quire_result, comp_result, conv_result;
  poslen_t sgnj_result, pmv_result;

  // ================
  // Quire operations
  // ================

  if (QUIRE_PRESENT) begin : gen_prau_quire
    prau_quire #(
      .XLEN(XLEN)
    ) prau_quire_i (
      .clk_i(clk_i),
      .rst_ni(rst_ni),
      .operand_a_i(operand_a),
      .operand_b_i(operand_b),
      .operator_i(operator),
      .input_hs_i(input_hs),
      .out_valid_i(out_valid_o),
      .result_o(quire_result)
    );
  end

  // ========================
  // Computational operations
  // ========================

  prau_comp #(
    .XLEN(XLEN)
  ) prau_comp_i (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .operand_a_i(operand_a),
    .operand_b_i(operand_b),
    .operator_i(operator),
    .result_o(comp_result)
  );

  // =====================
  // Conversion operations
  // =====================

  prau_conv #(
    .XLEN(XLEN)
  ) prau_conv_i (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .operand_i(operand_a),
    .operator_i(operator),
    .result_o(conv_result)
  );

  // ==============================
  // Move/sign-injection operations
  // ==============================

  logic move_flip;  // Flip the sign of the move operations

  always_comb begin : move_ops
    move_flip  = 1'b0;
    pmv_result = '0;

    unique case (operator)
      PSGNJ: begin
        if (operand_a[POSLEN-1] != operand_b[POSLEN-1]) begin
          move_flip = 1'b1;
        end
      end
      PSGNJN: begin
        if (operand_a[POSLEN-1] == operand_b[POSLEN-1]) begin
          move_flip = 1'b1;
        end
      end
      PSGNJX: begin
        if (operand_b[POSLEN-1]) begin  // sgn(a) ^ sgn(b) != sgn(a) <=> sgn(b)
          move_flip = 1'b1;
        end
      end
      PMV_P2X, PMV_X2P: begin
        pmv_result = operand_a[POSLEN-1:0];
      end
      default: ;
    endcase
  end

  assign sgnj_result = move_flip ? ~operand_a[POSLEN-1:0] + {{POSLEN - 1{1'b0}}, 1'b1} :
                                    operand_a[POSLEN-1:0];

  // =============
  // Result output
  // =============

  always_comb begin : result_mux
    result_o = '0;

    unique case (operator)
      // Quire result
      QROUND: result_o = quire_result;
      // Computational result
      PADD, PSUB, PMUL, PDIV, PSQRT: result_o = comp_result;
      // Conversion result
      PCVT_P2I, PCVT_P2U, PCVT_P2L, PCVT_P2LU, PCVT_I2P, PCVT_U2P, PCVT_L2P, PCVT_LU2P:
      result_o = conv_result;
      // Move/sign-injection result
      PSGNJ, PSGNJN, PSGNJX: result_o = {{XLEN - POSLEN{1'b0}}, sgnj_result};
      PMV_P2X, PMV_X2P: result_o = {{XLEN - POSLEN{pmv_result[POSLEN-1]}}, pmv_result};
      default: ;
    endcase
  end

  // =======
  // Control
  // =======

  logic       instr_in_flight;
  logic       input_hs;
  logic       output_hs;
  logic [3:0] latency_d, latency_q;

  // Handshake signals
  assign input_hs  = in_valid_i & in_ready_o;
  assign output_hs = out_valid_o & out_ready_i;

  // Instruction in flight calculation
  // If both input_hs and output_hs are set, the input_hs has priority
  // and instr_in_flight stays set as there is a new instruction
  always_ff @(posedge clk_i or negedge rst_ni) begin : instr_in_flight_reg
    if (~rst_ni) begin
      instr_in_flight <= 1'b0;
    end else if (input_hs) begin
      instr_in_flight <= 1'b1;
    end else if (output_hs) begin
      instr_in_flight <= 1'b0;
    end
  end

  // Input ready when there is no instruction in flight. The input is
  // also ready when the output handshake is set (shortcut one cycle).
  assign in_ready_o = ~instr_in_flight | output_hs;

  // Output valid when there is an instruction in flight and the current
  // instruction is finished
  assign out_valid_o = instr_in_flight & (latency_q == 0);

  // FF with handshake enable for input signals
  always_ff @(posedge clk_i or negedge rst_ni) begin : input_reg
    if (~rst_ni) begin
      operand_a <= '0;
      operand_b <= '0;
      operator  <= NONE;
      tag_o     <= '0;
    end else if (input_hs) begin
      operand_a <= operand_a_i;
      operand_b <= operand_b_i;
      operator  <= operator_i;
      tag_o     <= tag_i;
    end else if (output_hs) begin
      operand_a <= '0;
      operand_b <= '0;
      operator  <= NONE;
      tag_o     <= '0;
    end
  end

  // Latency calculation
  always_comb begin : set_latency
    unique case (operator_i)
      PADD, PSUB:   latency_d = PADD_LATENCY;
      PMUL:         latency_d = PMUL_LATENCY;
      PDIV:         latency_d = PDIV_LATENCY;
      PSQRT:        latency_d = PSQRT_LATENCY;
      QROUND:       latency_d = QROUND_LATENCY;
      QMADD, QMSUB: latency_d = QMADD_LATENCY;
      default:      latency_d = 4'b0000;
    endcase
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin : latency_reg
    if (~rst_ni) begin
      latency_q <= 0;
    end else if (input_hs) begin
      latency_q <= latency_d;
    end else if (latency_q > 0) begin
      latency_q <= latency_q - 1;
    end
  end

endmodule
