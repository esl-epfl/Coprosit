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
// Description: Coprosit predecoder package. Contains the description of every
//   instruction that can be offloaded to Coprosit.

package coprosit_predecoder_pkg;

  localparam int unsigned NUM_INSTR = 30;

  // Predecoder internal instruction metadata
  typedef struct packed {
    logic [31:0]  instr;
    logic [31:0]  instr_mask;
    coprosit_pkg::prd_rsp_t prd_rsp;
  } offload_instr_t;

  localparam offload_instr_t OFFLOAD_INSTR[NUM_INSTR] = '{
      // Posit load and store instructions
      '{
          instr: 32'b000000000000_00000_101_00000_0101011,  // PLW
          instr_mask: 32'b000000000000_00000_111_00000_1111111,
          prd_rsp : '{accept : 1'b1, loadstore : 1'b1, writeback : 1'b0, use_gprs : 2'b01}
      },
      '{
          instr: 32'b0000000_00000_00000_110_00000_0101011,  // PSW
          instr_mask: 32'b0000000_00000_00000_111_00000_1111111,
          prd_rsp : '{accept : 1'b1, loadstore : 1'b1, writeback : 1'b0, use_gprs : 2'b01}
      },

      // Posit computational instructions
      '{
          instr: 32'b00000_10_00000_00000_111_00000_0101011,  // PADD_S
          instr_mask: 32'b11111_11_00000_00000_111_00000_1111111,
          prd_rsp : '{accept : 1'b1, loadstore : 1'b0, writeback : 1'b0, use_gprs : 2'b00}
      },
      '{
          instr: 32'b00001_10_00000_00000_111_00000_0101011,  // PSUB_S
          instr_mask: 32'b11111_11_00000_00000_111_00000_1111111,
          prd_rsp : '{accept : 1'b1, loadstore : 1'b0, writeback : 1'b0, use_gprs : 2'b00}
      },
      '{
          instr: 32'b00010_10_00000_00000_111_00000_0101011,  // PMUL_S
          instr_mask: 32'b11111_11_00000_00000_111_00000_1111111,
          prd_rsp : '{accept : 1'b1, loadstore : 1'b0, writeback : 1'b0, use_gprs : 2'b00}
      },
      '{
          instr: 32'b00011_10_00000_00000_111_00000_0101011,  // PDIV_S
          instr_mask: 32'b11111_11_00000_00000_111_00000_1111111,
          prd_rsp : '{accept : 1'b1, loadstore : 1'b0, writeback : 1'b0, use_gprs : 2'b00}
      },
      '{
          instr: 32'b00100_10_00000_00000_111_00000_0101011,  // PMIN_S
          instr_mask: 32'b11111_11_00000_00000_111_00000_1111111,
          prd_rsp : '{accept : 1'b1, loadstore : 1'b0, writeback : 1'b0, use_gprs : 2'b00}
      },
      '{
          instr: 32'b00101_10_00000_00000_111_00000_0101011,  // PMAX_S
          instr_mask: 32'b11111_11_00000_00000_111_00000_1111111,
          prd_rsp : '{accept : 1'b1, loadstore : 1'b0, writeback : 1'b0, use_gprs : 2'b00}
      },
      '{
          instr: 32'b00110_10_00000_00000_111_00000_0101011,  // PSQRT_S
          instr_mask: 32'b11111_11_11111_00000_111_00000_1111111,
          prd_rsp : '{accept : 1'b1, loadstore : 1'b0, writeback : 1'b0, use_gprs : 2'b00}
      },

      // Posit quire instructions
      '{
          instr: 32'b00111_10_00000_00000_111_00000_0101011,  // QMADD_S
          instr_mask: 32'b11111_11_00000_00000_111_11111_1111111,
          prd_rsp : '{accept : 1'b1, loadstore : 1'b0, writeback : 1'b0, use_gprs : 2'b00}
      },
      '{
          instr: 32'b01000_10_00000_00000_111_00000_0101011,  // QMSUB_S
          instr_mask: 32'b11111_11_00000_00000_111_11111_1111111,
          prd_rsp : '{accept : 1'b1, loadstore : 1'b0, writeback : 1'b0, use_gprs : 2'b00}
      },
      '{
          instr: 32'b01001_10_00000_00000_111_00000_0101011,  // QCLR_S
          instr_mask: 32'b11111_11_11111_11111_111_11111_1111111,
          prd_rsp : '{accept : 1'b1, loadstore : 1'b0, writeback : 1'b0, use_gprs : 2'b00}
      },
      '{
          instr: 32'b01010_10_00000_00000_111_00000_0101011,  // QNEG_S
          instr_mask: 32'b11111_11_11111_11111_111_11111_1111111,
          prd_rsp : '{accept : 1'b1, loadstore : 1'b0, writeback : 1'b0, use_gprs : 2'b00}
      },
      '{
          instr: 32'b01011_10_00000_00000_111_00000_0101011,  // QROUND_S
          instr_mask: 32'b11111_11_11111_11111_111_00000_1111111,
          prd_rsp : '{accept : 1'b1, loadstore : 1'b0, writeback : 1'b0, use_gprs : 2'b00}
      },

      // Posit conversion instructions
      '{
          instr: 32'b01100_10_00000_00000_111_00000_0101011,  // PCVT_W_S
          instr_mask: 32'b11111_11_11111_00000_111_00000_1111111,
          prd_rsp : '{accept : 1'b1, loadstore : 1'b0, writeback : 1'b1, use_gprs : 2'b00}
      },
      '{
          instr: 32'b01101_10_00000_00000_111_00000_0101011,  // PCVT_WU_S
          instr_mask: 32'b11111_11_11111_00000_111_00000_1111111,
          prd_rsp : '{accept : 1'b1, loadstore : 1'b0, writeback : 1'b1, use_gprs : 2'b00}
      },
      '{
          instr: 32'b01110_10_00000_00000_111_00000_0101011,  // PCVT_L_S
          instr_mask: 32'b11111_11_11111_00000_111_00000_1111111,
          prd_rsp : '{accept : 1'b1, loadstore : 1'b0, writeback : 1'b1, use_gprs : 2'b00}
      },
      '{
          instr: 32'b01111_10_00000_00000_111_00000_0101011,  // PCVT_LU_S
          instr_mask: 32'b11111_11_11111_00000_111_00000_1111111,
          prd_rsp : '{accept : 1'b1, loadstore : 1'b0, writeback : 1'b1, use_gprs : 2'b00}
      },
      '{
          instr: 32'b10000_10_00000_00000_111_00000_0101011,  // PCVT_S_W
          instr_mask: 32'b11111_11_11111_00000_111_00000_1111111,
          prd_rsp : '{accept : 1'b1, loadstore : 1'b0, writeback : 1'b0, use_gprs : 2'b01}
      },
      '{
          instr: 32'b10001_10_00000_00000_111_00000_0101011,  // PCVT_S_WU
          instr_mask: 32'b11111_11_11111_00000_111_00000_1111111,
          prd_rsp : '{accept : 1'b1, loadstore : 1'b0, writeback : 1'b0, use_gprs : 2'b01}
      },
      '{
          instr: 32'b10010_10_00000_00000_111_00000_0101011,  // PCVT_S_L
          instr_mask: 32'b11111_11_11111_00000_111_00000_1111111,
          prd_rsp : '{accept : 1'b1, loadstore : 1'b0, writeback : 1'b0, use_gprs : 2'b01}
      },
      '{
          instr: 32'b10011_10_00000_00000_111_00000_0101011,  // PCVT_S_LU
          instr_mask: 32'b11111_11_11111_00000_111_00000_1111111,
          prd_rsp : '{accept : 1'b1, loadstore : 1'b0, writeback : 1'b0, use_gprs : 2'b01}
      },

      // Posit move instructions
      '{
          instr: 32'b10100_10_00000_00000_111_00000_0101011,  // PSGNJ_S
          instr_mask: 32'b11111_11_00000_00000_111_00000_1111111,
          prd_rsp : '{accept : 1'b1, loadstore : 1'b0, writeback : 1'b0, use_gprs : 2'b00}
      },
      '{
          instr: 32'b10101_10_00000_00000_111_00000_0101011,  // PSGNJN_S
          instr_mask: 32'b11111_11_00000_00000_111_00000_1111111,
          prd_rsp : '{accept : 1'b1, loadstore : 1'b0, writeback : 1'b0, use_gprs : 2'b00}
      },
      '{
          instr: 32'b10110_10_00000_00000_111_00000_0101011,  // PSGNJX_S
          instr_mask: 32'b11111_11_00000_00000_111_00000_1111111,
          prd_rsp : '{accept : 1'b1, loadstore : 1'b0, writeback : 1'b0, use_gprs : 2'b00}
      },
      '{
          instr: 32'b10111_10_00000_00000_111_00000_0101011,  // PMV_X_W
          instr_mask: 32'b11111_11_11111_00000_111_00000_1111111,
          prd_rsp : '{accept : 1'b1, loadstore : 1'b0, writeback : 1'b1, use_gprs : 2'b00}
      },
      '{
          instr: 32'b11000_10_00000_00000_111_00000_0101011,  // PMV_W_X
          instr_mask: 32'b11111_11_11111_00000_111_00000_1111111,
          prd_rsp : '{accept : 1'b1, loadstore : 1'b0, writeback : 1'b0, use_gprs : 2'b01}
      },

      // Posit compare instructions
      '{
          instr: 32'b11001_10_00000_00000_111_00000_0101011,  // PEQ_S
          instr_mask: 32'b11111_11_00000_00000_111_00000_1111111,
          prd_rsp : '{accept : 1'b1, loadstore : 1'b0, writeback : 1'b1, use_gprs : 2'b00}
      },
      '{
          instr: 32'b11010_10_00000_00000_111_00000_0101011,  // PLT_S
          instr_mask: 32'b11111_11_00000_00000_111_00000_1111111,
          prd_rsp : '{accept : 1'b1, loadstore : 1'b0, writeback : 1'b1, use_gprs : 2'b00}
      },
      '{
          instr: 32'b11011_10_00000_00000_111_00000_0101011,  // PLE_S
          instr_mask: 32'b11111_11_00000_00000_111_00000_1111111,
          prd_rsp : '{accept : 1'b1, loadstore : 1'b0, writeback : 1'b1, use_gprs : 2'b00}
      }
  };

endpackage  // coprosit_predecoder_pkg
