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
// Description: Coprosit Posit Arithmetic Unit package

package coprosit_pkg;

  // Parameters from if_xif
  localparam int X_NUM_RS = 2;  // Number of register file read ports that can be used by the eXtension interface
  localparam int X_ID_WIDTH = 4;  // Identification width for the eXtension interface
  localparam int X_MEM_WIDTH = 32;  // Memory access width for loads/stores via the eXtension interface
  localparam int X_RFR_WIDTH = 32;  // Register file read access width for the eXtension interface
  localparam int X_RFW_WIDTH = 32;  // Register file write access width for the eXtension interface
  localparam logic [31:0] X_MISA = '0;  // MISA extensions implemented on the eXtension interface
  localparam logic [1:0] X_ECS_XS = '0;  // Default value for mstatus.XS
  localparam int X_DUALREAD = 0;  // Dual register file read
  localparam int X_DUALWRITE = 0;  // Dual register file write
  localparam int XLEN = 32;

  typedef enum logic [1:0] {
    None,  // Operand not used
    RegA,  // Operand comes from the first register
    RegB,  // Operand comes from the second register
    CPU    // Operand comes from the CPU
  } op_select_e;

  // ====================
  // Predecoder
  // ====================

  // Predecoder request type
  typedef struct packed {logic [31:0] instr;} prd_req_t;

  // Predecoder response type
  typedef struct packed {
    logic                accept;
    // Instruction is a load or store
    logic                loadstore;
    // Instruction performs a writeback in the core to rd
    logic                writeback;
    // Use integer register file for source operands. To be used with the
    // x_issue_req_t.rs_valid bits
    logic [X_NUM_RS-1:0] use_gprs;
  } prd_rsp_t;

  // ====================
  // Decoder
  // ====================

  // Output information from the decoder
  typedef struct packed {
    prau_pkg::prau_op_e prau_op;
    coprosit_pkg::op_select_e [coprosit_pkg::X_NUM_RS-1:0] op_select;
    logic rd_is_pos;
    logic use_copro;
    logic is_store;
    logic is_load;
  } decoder_t;

  // ====================
  // Input Stream FIFO
  // ====================

  typedef struct packed {
    logic [X_NUM_RS-1:0][X_RFR_WIDTH-1:0] rs;
    logic [31:0]                          instr;
    logic [X_ID_WIDTH-1:0]                id;
    logic [1:0]                           mode;
  } offloaded_data_t;

  // ==============================
  // Memory Instruction Stream FIFO
  // ==============================

  typedef struct packed {
    logic [X_ID_WIDTH-1:0] id;
    logic [4:0]            rd;
    logic                  we;
    logic                  exc;
    logic [5:0]            exccode;
    logic                  dbg;
  } mem_metadata_t;

  // ====================
  // PRAU
  // ====================

  typedef struct packed {
    logic [X_ID_WIDTH-1:0] id;
    logic [4:0]            addr;       // Destination register rd
    logic                  rd_is_pos;
  } prau_tag_t;

  // ====================
  // RESULT
  // ====================

  // From if_xif
  typedef struct packed {
    logic [ X_ID_WIDTH-1:0] id;      // Identification of the offloaded instruction
    logic [X_RFW_WIDTH-1:0] data;    // Register file write data value(s)
    logic [            4:0] rd;      // Register file destination address(es)
    logic [X_RFW_WIDTH/XLEN-1:0] we; // Register file write enable(s)
    logic [5:0]             ecsdata; // Write data value for {mstatus.xs, mstatus.fs, mstatus.vs}
    logic [2:0]             ecswe;   // Write enables for {mstatus.xs, mstatus.fs, mstatus.vs}
    logic                   exc;     // Did the instruction cause a synchronous exception?
    logic [5:0]             exccode; // Exception code
    logic                   err;     // Did the instruction cause a bus error?
    logic                   dbg;     // Did the instruction cause a debug trigger match with ``mcontrol.timing`` = 0?
  } x_result_t;

endpackage  // coprosit_pkg
