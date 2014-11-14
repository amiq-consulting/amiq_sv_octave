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
 * MODULE:       amiq_hello_world_tb_top.sv
 * PROJECT:      amiq_hello_world
 * Description:  Hello world testbench module
 *******************************************************************************/
 
// Hello world testbench module
module amiq_hello_world_tb_top;
    // Import UVM package
    import uvm_pkg::*;
    
    // Import Hello World package
    import amiq_hello_world_pkg::*;

    // Include UVM macros file
    `include "uvm_macros.svh"
    
    // Instance of hello world component
    amiq_hello_world hw_top;

    initial begin
        // Create the hello world component
        hw_top = amiq_hello_world::type_id::create("hello_world_top", uvm_root::get());
        
        // Start to run test
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
