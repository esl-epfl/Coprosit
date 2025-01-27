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
// Based on: FPU Subsystem Decoder
// Contributor: Moritz Imfeld <moimfeld@student.eth.ch>
//
// Author: David Mallasén <dmallase@ucm.es>
// Description: Coprosit decoder module.

module coprosit_decoder (
  input  logic [31:0]            instr_i,
  output coprosit_pkg::decoder_t decoder_o
);

  always_comb begin

    decoder_o.prau_op = prau_pkg::NONE;
    decoder_o.use_copro = 1'b1;

    decoder_o.op_select[0] = coprosit_pkg::None;
    decoder_o.op_select[1] = coprosit_pkg::None;

    decoder_o.is_store = 1'b0;
    decoder_o.is_load  = 1'b0;

    decoder_o.rd_is_pos = 1'b1;

    unique casez (instr_i)
      // Posit load and store instructions
      coprosit_instr_pkg::PLW: begin
        decoder_o.is_load = 1'b1;
        decoder_o.use_copro = 1'b0;
      end
      coprosit_instr_pkg::PSW: begin
        decoder_o.is_store = 1'b1;
        decoder_o.op_select[1] = coprosit_pkg::RegB;
        decoder_o.use_copro = 1'b0;
        decoder_o.rd_is_pos = 1'b0;
      end

      // Posit computational instructions
      coprosit_instr_pkg::PADD_S: begin
        decoder_o.prau_op = prau_pkg::PADD;
        decoder_o.op_select[0] = coprosit_pkg::RegA;
        decoder_o.op_select[1] = coprosit_pkg::RegB;
      end
      coprosit_instr_pkg::PSUB_S: begin
        decoder_o.prau_op = prau_pkg::PSUB;
        decoder_o.op_select[0] = coprosit_pkg::RegA;
        decoder_o.op_select[1] = coprosit_pkg::RegB;
      end
      coprosit_instr_pkg::PMUL_S: begin
        decoder_o.prau_op = prau_pkg::PMUL;
        decoder_o.op_select[0] = coprosit_pkg::RegA;
        decoder_o.op_select[1] = coprosit_pkg::RegB;
      end
      coprosit_instr_pkg::PDIV_S: begin
        decoder_o.prau_op = prau_pkg::PDIV;
        decoder_o.op_select[0] = coprosit_pkg::RegA;
        decoder_o.op_select[1] = coprosit_pkg::RegB;
      end
      coprosit_instr_pkg::PMIN_S: begin
        decoder_o.prau_op = prau_pkg::PMIN;
        decoder_o.op_select[0] = coprosit_pkg::RegA;
        decoder_o.op_select[1] = coprosit_pkg::RegB;
      end
      coprosit_instr_pkg::PMAX_S: begin
        decoder_o.prau_op = prau_pkg::PMAX;
        decoder_o.op_select[0] = coprosit_pkg::RegA;
        decoder_o.op_select[1] = coprosit_pkg::RegB;
      end
      coprosit_instr_pkg::PSQRT_S: begin
        decoder_o.prau_op = prau_pkg::PSQRT;
        decoder_o.op_select[0] = coprosit_pkg::RegA;
      end

      // Posit quire instructions
      coprosit_instr_pkg::QMADD_S: begin
        decoder_o.prau_op = prau_pkg::QMADD;
        decoder_o.op_select[0] = coprosit_pkg::RegA;
        decoder_o.op_select[1] = coprosit_pkg::RegB;
        decoder_o.rd_is_pos = 1'b0;
      end
      coprosit_instr_pkg::QMSUB_S: begin
        decoder_o.prau_op = prau_pkg::QMSUB;
        decoder_o.op_select[0] = coprosit_pkg::RegA;
        decoder_o.op_select[1] = coprosit_pkg::RegB;
        decoder_o.rd_is_pos = 1'b0;
      end
      coprosit_instr_pkg::QCLR_S: begin
        decoder_o.prau_op = prau_pkg::QCLR;
        decoder_o.rd_is_pos = 1'b0;
      end
      coprosit_instr_pkg::QNEG_S: begin
        decoder_o.prau_op = prau_pkg::QNEG;
        decoder_o.rd_is_pos = 1'b0;
      end
      coprosit_instr_pkg::QROUND_S: begin
        decoder_o.prau_op = prau_pkg::QROUND;
        decoder_o.op_select[0] = coprosit_pkg::RegA;
      end

      // Posit conversion instructions
      coprosit_instr_pkg::PCVT_W_S: begin
        decoder_o.prau_op = prau_pkg::PCVT_P2I;
        decoder_o.op_select[0] = coprosit_pkg::RegA;
        decoder_o.rd_is_pos = 1'b0;
      end
      coprosit_instr_pkg::PCVT_WU_S: begin
        decoder_o.prau_op = prau_pkg::PCVT_P2U;
        decoder_o.op_select[0] = coprosit_pkg::RegA;
        decoder_o.rd_is_pos = 1'b0;
      end
      coprosit_instr_pkg::PCVT_L_S: begin
        decoder_o.prau_op = prau_pkg::PCVT_P2L;
        decoder_o.op_select[0] = coprosit_pkg::RegA;
        decoder_o.rd_is_pos = 1'b0;
      end
      coprosit_instr_pkg::PCVT_LU_S: begin
        decoder_o.prau_op = prau_pkg::PCVT_P2U;
        decoder_o.op_select[0] = coprosit_pkg::RegA;
        decoder_o.rd_is_pos = 1'b0;
      end
      coprosit_instr_pkg::PCVT_S_W: begin
        decoder_o.prau_op = prau_pkg::PCVT_I2P;
        decoder_o.op_select[0] = coprosit_pkg::CPU;
      end
      coprosit_instr_pkg::PCVT_S_WU: begin
        decoder_o.prau_op = prau_pkg::PCVT_U2P;
        decoder_o.op_select[0] = coprosit_pkg::CPU;
      end
      coprosit_instr_pkg::PCVT_S_L: begin
        decoder_o.prau_op = prau_pkg::PCVT_L2P;
        decoder_o.op_select[0] = coprosit_pkg::CPU;
      end
      coprosit_instr_pkg::PCVT_S_LU: begin
        decoder_o.prau_op = prau_pkg::PCVT_LU2P;
        decoder_o.op_select[0] = coprosit_pkg::CPU;
      end

      // Posit move instructions
      coprosit_instr_pkg::PSGNJ_S: begin
        decoder_o.prau_op = prau_pkg::PSGNJ;
        decoder_o.op_select[0] = coprosit_pkg::RegA;
        decoder_o.op_select[1] = coprosit_pkg::RegB;
      end
      coprosit_instr_pkg::PSGNJN_S: begin
        decoder_o.prau_op = prau_pkg::PSGNJN;
        decoder_o.op_select[0] = coprosit_pkg::RegA;
        decoder_o.op_select[1] = coprosit_pkg::RegB;
      end
      coprosit_instr_pkg::PSGNJX_S: begin
        decoder_o.prau_op = prau_pkg::PSGNJX;
        decoder_o.op_select[0] = coprosit_pkg::RegA;
        decoder_o.op_select[1] = coprosit_pkg::RegB;
      end
      coprosit_instr_pkg::PMV_X_W: begin
        decoder_o.prau_op = prau_pkg::PMV_P2X;
        decoder_o.op_select[0] = coprosit_pkg::RegA;
        decoder_o.rd_is_pos = 1'b0;
      end
      coprosit_instr_pkg::PMV_W_X: begin
        decoder_o.prau_op = prau_pkg::PMV_X2P;
        decoder_o.op_select[0] = coprosit_pkg::CPU;
      end

      // Posit compare instructions
      coprosit_instr_pkg::PEQ_S: begin
        decoder_o.prau_op = prau_pkg::PEQ;
        decoder_o.op_select[0] = coprosit_pkg::RegA;
        decoder_o.op_select[1] = coprosit_pkg::RegB;
        decoder_o.rd_is_pos = 1'b0;
      end
      coprosit_instr_pkg::PLT_S: begin
        decoder_o.prau_op = prau_pkg::PLT;
        decoder_o.op_select[0] = coprosit_pkg::RegA;
        decoder_o.op_select[1] = coprosit_pkg::RegB;
        decoder_o.rd_is_pos = 1'b0;
      end
      coprosit_instr_pkg::PLE_S: begin
        decoder_o.prau_op = prau_pkg::PLE;
        decoder_o.op_select[0] = coprosit_pkg::RegA;
        decoder_o.op_select[1] = coprosit_pkg::RegB;
        decoder_o.rd_is_pos = 1'b0;
      end

      default: begin
        decoder_o.use_copro = 1'b0;
        decoder_o.rd_is_pos = 1'b0;
      end
    endcase
  end

endmodule  // coprosit_decoder
