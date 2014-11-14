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
 * MODULE:       amiq_dsp_algorithms_fp_base_test.svh
 * PROJECT:      amiq_dsp_algorithms_fp
 *
 * Description:  Base test
 *******************************************************************************/

`ifndef __amiq_dsp_algorithms_fp_base_test
    `define __amiq_dsp_algorithms_fp_base_test

// Base test
class amiq_dsp_algorithms_fp_base_test extends uvm_test;
    // Factory registration for amiq_dsp_algorithms_fp_base_test
    `uvm_component_utils(amiq_dsp_algorithms_fp_base_test)

    // algorithms environment instance
    amiq_dsp_algorithms_fp_env algorithms_env;

    /* Constructor for amiq_dsp_algorithms_fp_base_test
     * @param name : instance name for amiq_dsp_algorithms_fp_base_test object
     * @param parent : hierarchical parent for amiq_dsp_algorithms_fp_base_test object
     */
    function new(string name = "amiq_dsp_algorithms_fp_base_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    /* Instantiate components
     * @param phase : the phase scheduled for build_phase method
     */
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Create the algorithm environment
        algorithms_env = amiq_dsp_algorithms_fp_env::type_id::create("algorithms_env", this);
    endfunction

    /* Glue logic for test components
     * @param phase : the phase scheduled for connect_phase method
     */
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction

    // Sets the custom message reporter
    function void start_of_simulation();
        amiq_dsp_algorithms_fp_reporter algorithms_server = new;
        uvm_report_server::set_server(algorithms_server);
    endfunction
endclass

`endif
