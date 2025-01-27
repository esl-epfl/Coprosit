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
// Description: Quire operations.

module prau_quire
  import prau_pkg::*;
#(
  parameter int unsigned XLEN = 64
) (
  input  logic clk_i,
  input  logic rst_ni,

  input  logic [XLEN-1:0] operand_a_i,
  input  logic [XLEN-1:0] operand_b_i,

  input  prau_op_e operator_i,

  input  logic input_hs_i,
  input  logic out_valid_i,

  output logic [XLEN-1:0] result_o
);

  poslen_t   qmadd_a;
  poslen_t   qmadd_b;
  quirelen_t qmadd_c;

  quirelen_t qmadd_result;

  quirelen_t quire_q, quire_d;

  quirelen_t conv_quire;
  poslen_t   conv_pos;

  // ================
  // Quire operations
  // ================

  always_comb begin : quire_ops
    quire_d = quire_q;

    unique case (operator_i)
      QCLR:         quire_d = '0 ;
      QNEG:         quire_d = input_hs_i ? ~quire_q + {{QUIRELEN - 1{1'b0}}, 1'b1} : quire_q;
      QMADD, QMSUB: quire_d = out_valid_i ? qmadd_result : quire_q;
      default:      ;
    endcase
  end

  always_comb begin : qmac_ops
    qmadd_a = '0;
    qmadd_b = '0;
    qmadd_c = '0;

    unique case (operator_i)
      QMADD: begin
        qmadd_a = operand_a_i;
        qmadd_b = operand_b_i;
        qmadd_c = quire_q;
      end
      QMSUB: begin
        qmadd_a = operand_a_i;
        qmadd_b = ~operand_b_i + {{POSLEN-1{1'b0}}, 1'b1};
        qmadd_c = quire_q;
      end
      default: ;
    endcase
  end

  PositMAC prau_mac_i (
    .clk(clk_i),
    .A(qmadd_a),
    .B(qmadd_b),
    .C(qmadd_c),
    .R(qmadd_result)
  );

  // ===========
  // Quire round
  // ===========

  assign conv_quire = (operator_i == QROUND) ? quire_q : '0;

  Quire2Posit prau_q2p (
    .clk(clk_i),
    .X(conv_quire),
    .R(conv_pos)
  );

  // =============
  // Result output
  // =============

  assign result_o = (operator_i == QROUND) ? {{XLEN - POSLEN{1'b0}}, conv_pos} : '0;

  // ==============
  // Quire register
  // ==============

  always_ff @(posedge clk_i or negedge rst_ni) begin : quire_reg
    if (~rst_ni) begin
      quire_q <= '0;
    end else begin
      quire_q <= quire_d;
    end
  end

endmodule
