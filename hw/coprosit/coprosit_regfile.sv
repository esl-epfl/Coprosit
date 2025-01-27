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
// Based on: RISC-V register file
// Engineer: Francesco Conti - f.conti@unibo.it
//
// Author: David Mallasén <dmallase@ucm.es>
// Description: Coprosit posit register file with 32 entries.

module coprosit_regfile #(
  parameter int unsigned DATA_WIDTH     = 32,
  parameter int unsigned NR_READ_PORTS  = 2,
  parameter int unsigned NR_WRITE_PORTS = 1
) (
  // Clock and reset
  input  logic                                      clk_i,
  input  logic                                      rst_ni,
  // Read ports
  input  logic [ NR_READ_PORTS-1:0][           4:0] raddr_i,
  output logic [ NR_READ_PORTS-1:0][DATA_WIDTH-1:0] rdata_o,
  // Write ports
  input  logic [NR_WRITE_PORTS-1:0][           4:0] waddr_i,
  input  logic [NR_WRITE_PORTS-1:0][DATA_WIDTH-1:0] wdata_i,
  input  logic [NR_WRITE_PORTS-1:0]                 we_i
);

  localparam ADDR_WIDTH = 5;
  localparam NUM_WORDS = 2 ** ADDR_WIDTH;

  logic [     NUM_WORDS-1:0][DATA_WIDTH-1:0] mem;
  logic [NR_WRITE_PORTS-1:0][ NUM_WORDS-1:0] we_dec;


  always_comb begin : we_decoder
    for (int unsigned j = 0; j < NR_WRITE_PORTS; j++) begin
      for (int unsigned i = 0; i < NUM_WORDS; i++) begin
        if (waddr_i[j] == i) we_dec[j][i] = we_i[j];
        else we_dec[j][i] = 1'b0;
      end
    end
  end

  always_ff @(posedge clk_i, negedge rst_ni) begin : register_write_behavioral
    if (~rst_ni) begin
      mem <= '{default: '0};
    end else begin
      for (int unsigned j = 0; j < NR_WRITE_PORTS; j++) begin
        for (int unsigned i = 0; i < NUM_WORDS; i++) begin
          if (we_dec[j][i]) begin
            mem[i] <= wdata_i[j];
          end
        end
      end
    end
  end

  for (genvar i = 0; i < NR_READ_PORTS; i++) begin : gen_read_port
    assign rdata_o[i] = mem[raddr_i[i]];
  end

endmodule  // coprosit_regfile
