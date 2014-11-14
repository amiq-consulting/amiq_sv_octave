/******************************************************************************
 * (C) Copyright 2014 AMIQ Consulting
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * MODULE:      amiq_dsp_algorithms_tb_top.sv
 * PROJECT:     amiq_dsp_algorithms
 * Description: Testbench module
 *******************************************************************************/
 
`timescale 1ns / 1ps
 
// Testbench module
module amiq_dsp_algorithms_tb_top;

    // Import UVM package
    import uvm_pkg::*;
    
    // Import the algorithms test package
    import amiq_dsp_algorithms_test_pkg::*;

    // Include UVM macros
    `include "uvm_macros.svh"

    // Start test
    initial begin
        run_test();
    end

    // Set printing knobs
    initial begin
        uvm_default_printer.knobs.show_radix = 0;
        uvm_default_printer.knobs.size       = 0;
        uvm_default_printer.knobs.type_name  = 0;
        uvm_default_printer.knobs.indent     = 5;
        uvm_default_printer.knobs.header     = 0;
    end
endmodule
