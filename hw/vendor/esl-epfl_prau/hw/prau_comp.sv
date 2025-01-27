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
// Description: Posit computational operations (add, sub, mul, div, sqrt).

module prau_comp
  import prau_pkg::*;
#(
  parameter int unsigned XLEN = 64
) (
  input  logic clk_i,
  input  logic rst_ni,

  input  logic [XLEN-1:0] operand_a_i,
  input  logic [XLEN-1:0] operand_b_i,

  input  prau_op_e operator_i,

  output logic [XLEN-1:0] result_o
);

  poslen_t  add_a;
  poslen_t  add_b;
  poslen_t  mul_a;
  poslen_t  mul_b;
  poslen_t  div_a;
  poslen_t  div_b;
  poslen_t  sqrt_a;

  poslen_t  add_result;
  poslen_t  mul_result;
  poslen_t  div_result;
  poslen_t  sqrt_result;

  logic div_en;
  logic sqrt_en;

  // ==============================
  // Posit computational operations
  // ==============================

  always_comb begin : comp_ops
    add_a  = '0;
    add_b  = '0;
    mul_a  = '0;
    mul_b  = '0;
    div_a  = '0;
    div_b  = '0;
    sqrt_a = '0;
    div_en = 1'b0;
    sqrt_en = 1'b0;

    unique case (operator_i)
      PADD: begin
        add_a = operand_a_i[POSLEN-1:0];
        add_b = operand_b_i[POSLEN-1:0];
      end
      PSUB: begin
        add_a = operand_a_i[POSLEN-1:0];
        add_b = ~operand_b_i[POSLEN-1:0] + {{POSLEN-1{1'b0}}, 1'b1};
      end
      PMUL: begin
        mul_a = operand_a_i[POSLEN-1:0];
        mul_b = operand_b_i[POSLEN-1:0];
      end
      PDIV: begin
        div_a = operand_a_i[POSLEN-1:0];
        div_b = operand_b_i[POSLEN-1:0];
        div_en = 1'b1;
      end
      PSQRT: begin
        sqrt_a = operand_a_i[POSLEN-1:0];
        sqrt_en = 1'b1;
      end
      default: ;  // default case to suppress unique warning
    endcase
  end

  PositAdder prau_add_i (
    .clk(clk_i),
    .X(add_a),
    .Y(add_b),
    .R(add_result)
  );

  if (!POS_LOG_MULT) begin : gen_prau_mul
    PositMult prau_mul_i (
      .clk(clk_i),
      .X(mul_a),
      .Y(mul_b),
      .R(mul_result)
    );
  end else begin : gen_prau_mul_approx
    ApproxPositMult prau_mul_approx_i (
      .clk(clk_i),
      .X(mul_a),
      .Y(mul_b),
      .R(mul_result)
    );
  end

  if (!POS_LOG_DIV) begin : gen_prau_div
    PositDiv pau_div_i (
      .clk(clk_i),
      .en(div_en),
      .X(div_a),
      .Y(div_b),
      .R(div_result)
    );
  end else begin : gen_prau_div_approx
    ApproxPositDiv prau_div_approx_i (
      .clk(clk_i),
      .X(div_a),
      .Y(div_b),
      .R(div_result)
    );
  end

  if (!POS_LOG_SQRT) begin : gen_prau_sqrt
    PositSqrt pau_sqrt_i (
      .clk(clk_i),
      .en(sqrt_en),
      .X(sqrt_a),
      .R(sqrt_result)
    );
  end else begin : gen_prau_sqrt_approx
    ApproxPositSqrt prau_sqrt_approx_i (
      .clk(clk_i),
      .X(sqrt_a),
      .R(sqrt_result)
    );
  end

  // =============
  // Result output
  // =============

  always_comb begin : result_mux
    result_o = '0;

    unique case (operator_i)
      PADD, PSUB: result_o = {{XLEN - POSLEN{1'b0}}, add_result};
      PMUL:       result_o = {{XLEN - POSLEN{1'b0}}, mul_result};
      PDIV:       result_o = {{XLEN - POSLEN{1'b0}}, div_result};
      PSQRT:      result_o = {{XLEN - POSLEN{1'b0}}, sqrt_result};
      default:    ;
    endcase
  end

endmodule
