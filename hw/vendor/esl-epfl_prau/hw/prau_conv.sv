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
// Description: Posit to/from integer conversion operations.

module prau_conv
  import prau_pkg::*;
#(
  parameter int unsigned XLEN = 64
) (
  input  logic clk_i,
  input  logic rst_ni,

  input  logic [XLEN-1:0] operand_i,

  input  prau_op_e operator_i,

  output logic [XLEN-1:0] result_o
);

  logic [31:0] conv32int;
  logic [63:0] conv64int;
  poslen_t convp_int;
  poslen_t convp_long;

  logic [31:0] conv_p2i_o;
  logic [31:0] conv_p2u_o;
  logic [63:0] conv_p2l_o;
  logic [63:0] conv_p2lu_o;
  poslen_t conv_i2p_o;
  poslen_t conv_u2p_o;
  poslen_t conv_l2p_o;
  poslen_t conv_lu2p_o;

  // ===========================
  // Posit - Integer conversions
  // ===========================

  always_comb begin : int_conv_ops
    convp_int = '0;
    conv32int = '0;

    unique case (operator_i)
      PCVT_P2I, PCVT_P2U: begin
        convp_int = operand_i[POSLEN-1:0];
      end
      PCVT_I2P, PCVT_U2P: begin
        conv32int = operand_i[31:0];
      end
      default: ;
    endcase
  end

  if (XLEN >= 64) begin : gen_long_conv_ops
    always_comb begin : long_conv_ops
      convp_long = '0;
      conv64int  = '0;

      unique case (operator_i)
        PCVT_P2L, PCVT_P2LU: begin
          convp_long = operand_i[POSLEN-1:0];
        end
        PCVT_L2P, PCVT_LU2P: begin
          conv64int = operand_i[63:0];
        end
        default: ;
      endcase
    end
  end


  Posit2Int prau_p2i (
    .clk(clk_i),
    .X(convp_int),
    .R(conv_p2i_o)
  );

  Posit2UInt prau_p2u (
    .clk(clk_i),
    .X(convp_int),
    .R(conv_p2u_o)
  );

  Int2Posit prau_i2p (
    .clk(clk_i),
    .X(conv32int),
    .R(conv_i2p_o)
  );

  UInt2Posit prau_u2p (
    .clk(clk_i),
    .X(conv32int),
    .R(conv_u2p_o)
  );

  if (XLEN >= 64) begin : gen_long_conv
    Long2Posit prau_l2p (
      .clk(clk_i),
      .X(conv64int),
      .R(conv_l2p_o)
    );

    Posit2Long prau_p2l (
      .clk(clk_i),
      .X(convp_long),
      .R(conv_p2l_o)
    );

    Posit2ULong prau_p2lu (
      .clk(clk_i),
      .X(convp_long),
      .R(conv_p2lu_o)
    );

    ULong2Posit prau_lu2p (
      .clk(clk_i),
      .X(conv64int),
      .R(conv_lu2p_o)
    );
  end

  // =============
  // Result output
  // =============

  always_comb begin : result_mux
    result_o = '0;

    unique case (operator_i)
      PCVT_P2I:  result_o = {{XLEN - 32{conv_p2i_o[31]}}, conv_p2i_o};
      PCVT_P2U:  result_o = {{XLEN - 32{conv_p2u_o[31]}}, conv_p2u_o};
      PCVT_P2L:  result_o = conv_p2l_o;
      PCVT_P2LU: result_o = conv_p2lu_o;
      PCVT_I2P:  result_o = {{XLEN - POSLEN{1'b0}}, conv_i2p_o};
      PCVT_U2P:  result_o = {{XLEN - POSLEN{1'b0}}, conv_u2p_o};
      PCVT_L2P:  result_o = {{XLEN - POSLEN{1'b0}}, conv_l2p_o};
      PCVT_LU2P: result_o = {{XLEN - POSLEN{1'b0}}, conv_lu2p_o};
      default:   ;
    endcase
  end

endmodule
