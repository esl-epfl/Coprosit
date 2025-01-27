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
// Description: PRAU parameters and definitions

package prau_pkg;

  localparam int unsigned POSLEN = `PARAM_POSLEN;
  localparam int unsigned QUIRELEN = 16 * POSLEN;

  typedef logic [POSLEN-1:0] poslen_t;
  typedef logic [QUIRELEN-1:0] quirelen_t;

  localparam int unsigned POS_LOG_MULT = `PARAM_POS_LOG_MULT;
  localparam int unsigned POS_LOG_DIV = `PARAM_POS_LOG_DIV;
  localparam int unsigned POS_LOG_SQRT = `PARAM_POS_LOG_SQRT;
  localparam int unsigned QUIRE_PRESENT = `PARAM_QUIRE_PRESENT;

  // Define unit latencies
  localparam logic [3:0] PADD_LATENCY = POSLEN == 8  ? 4'b0000 :
                                        POSLEN == 16 ? 4'b0000 :
                                        POSLEN == 32 ? 4'b0001 :
                                        POSLEN == 64 ? 4'b0001 :
                                        4'b0000;
  localparam logic [3:0] PMUL_LATENCY = POSLEN == 8  ? (POS_LOG_MULT ? 4'b0000 : 4'b0000) :
                                        POSLEN == 16 ? (POS_LOG_MULT ? 4'b0000 : 4'b0000) :
                                        POSLEN == 32 ? (POS_LOG_MULT ? 4'b0001 : 4'b0001) :
                                        POSLEN == 64 ? (POS_LOG_MULT ? 4'b0001 : 4'b0001) :
                                        4'b0000;
  localparam logic [3:0] PDIV_LATENCY = POSLEN == 8  ? (POS_LOG_DIV ? 4'b0000 : 4'b0001) :
                                        POSLEN == 16 ? (POS_LOG_DIV ? 4'b0000 : 4'b0010) :
                                        POSLEN == 32 ? (POS_LOG_DIV ? 4'b0001 : 4'b0100) :
                                        POSLEN == 64 ? (POS_LOG_DIV ? 4'b0001 : 4'b1010) :
                                        4'b0000;
  localparam logic [3:0] PSQRT_LATENCY = POSLEN == 8  ? (POS_LOG_SQRT ? 4'b0000 : 4'b0001) :
                                         POSLEN == 16 ? (POS_LOG_SQRT ? 4'b0000 : 4'b0010) :
                                         POSLEN == 32 ? (POS_LOG_SQRT ? 4'b0001 : 4'b0101) :
                                         POSLEN == 64 ? (POS_LOG_SQRT ? 4'b0001 : 4'b1101) :
                                         4'b0000;
  localparam logic [3:0] QROUND_LATENCY = POSLEN == 8  ? 4'b0000 :
                                          POSLEN == 16 ? 4'b0000 :
                                          POSLEN == 32 ? 4'b0001 :
                                          POSLEN == 64 ? 4'b0001 :
                                          4'b0000;
  localparam logic [3:0] QMADD_LATENCY = POSLEN == 8  ? 4'b0001 :
                                         POSLEN == 16 ? 4'b0001 :
                                         POSLEN == 32 ? 4'b0010 :
                                         POSLEN == 64 ? 4'b0011 :
                                         4'b0000;

  localparam int unsigned NUM_POS_OPERATIONS = 31;
  localparam int unsigned POS_OPERATION_BITS = $clog2(NUM_POS_OPERATIONS);

  typedef enum logic [POS_OPERATION_BITS-1:0] {
    // No operation
    NONE,
    // Posit Load and Store Instructions
    PLW,
    PSW,
    // Posit Computational Instructions
    PADD,
    PSUB,
    PMUL,
    PDIV,
    PMIN,
    PMAX,
    PSQRT,
    // Posit Quire Instructions
    QMADD,
    QMSUB,
    QCLR,
    QNEG,
    QROUND,
    // Posit Conversion Instructions
    PCVT_P2I,
    PCVT_P2U,
    PCVT_P2L,
    PCVT_P2LU,
    PCVT_I2P,
    PCVT_U2P,
    PCVT_L2P,
    PCVT_LU2P,
    // Posit Move Instructions
    PSGNJ,
    PSGNJN,
    PSGNJX,
    PMV_P2X,
    PMV_X2P,
    // Posit Compare Instructions
    PEQ,
    PLT,
    PLE
  } prau_op_e;

endpackage  // prau_pkg
