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
// Description: Coprosit ALU to perform posit compare and min/max operations.
//   This would not be needed if the host CPU adapts its ALU to recognize
//   these posit instructions, as they can reuse two's complement integer
//   hardware.

module coprosit_alu
  import prau_pkg::*;
#(
  parameter int unsigned XLEN = 64
) (
  input  logic clk_i,
  input  logic rst_ni,

  // Input signals
  input  poslen_t  operand_a_i,
  input  poslen_t  operand_b_i,
  input  prau_op_e operator_i,

  // Handshakes
  input  logic input_hs,
  input  logic output_hs,

  // Output signals
  output logic [XLEN-1:0] result_o
);

  poslen_t operand_a;
  poslen_t operand_b;
  prau_op_e operator;

  logic less;
  logic equal;

  // ===========
  // Comparisons
  // ===========

  always_comb begin
    less = ($signed({operand_a[POSLEN-1], operand_a}) <
            $signed({operand_b[POSLEN-1], operand_b}));
    equal = operand_a == operand_b;
  end

  // =======
  // Result
  // =======

  always_comb begin : result_mux
    result_o = '0;

    unique case (operator)
      PEQ: result_o = {{XLEN - 1{1'b0}}, equal};
      PLT: result_o = {{XLEN - 1{1'b0}}, less};
      PLE: result_o = {{XLEN - 1{1'b0}}, less | equal};

      PMIN:
      result_o = less ? {{XLEN - POSLEN{1'b0}}, operand_a} : {{XLEN - POSLEN{1'b0}}, operand_b};
      PMAX:
      result_o = less ? {{XLEN - POSLEN{1'b0}}, operand_b} : {{XLEN - POSLEN{1'b0}}, operand_a};

      default: ;  // default case to suppress unique warning
    endcase
  end

  // =======
  // Control
  // =======

  // FF with handshake enable for input signals
  always_ff @(posedge clk_i or negedge rst_ni) begin : input_reg
    if (~rst_ni) begin
      operand_a <= '0;
      operand_b <= '0;
      operator  <= NONE;
    end else if (input_hs) begin
      operand_a <= operand_a_i;
      operand_b <= operand_b_i;
      operator  <= operator_i;
    end else if (output_hs) begin
      operand_a <= '0;
      operand_b <= '0;
      operator  <= NONE;
    end
  end

endmodule  // coprosit_alu
