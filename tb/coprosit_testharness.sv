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
// Description: Coprosit testharness

module coprosit_testharness (
  // Clock and Reset
  input logic clk_i,
  input logic rst_ni
);

  // eXtension Interface
  if_xif #() ext_if ();

  coprosit #(
    .INPUT_BUFFER_DEPTH(1),
    .FORWARDING(1)
  ) coprosit_i (
    .clk_i(clk_i),
    .rst_ni(rst_ni),

    .xif_compressed_if(ext_if),
    .xif_issue_if(ext_if),
    .xif_commit_if(ext_if),
    .xif_mem_if(ext_if),
    .xif_mem_result_if(ext_if),
    .xif_result_if(ext_if)
  );


endmodule  // coprosit_testharness
