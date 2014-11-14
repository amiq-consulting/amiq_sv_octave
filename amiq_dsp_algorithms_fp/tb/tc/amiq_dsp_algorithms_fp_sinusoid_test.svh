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
 * MODULE:       amiq_dsp_algorithms_fp_sinusoid_test.svh
 * PROJECT:      amiq_dsp_algorithms_fp
 *
 * Description:  The test in which a sinusoid is driven
 *******************************************************************************/

`ifndef __amiq_dsp_algorithms_fp_sinusoid_test
   `define  __amiq_dsp_algorithms_fp_sinusoid_test

// The test in which a sinusoid is driven
class amiq_dsp_algorithms_fp_sinusoid_test extends amiq_dsp_algorithms_fp_base_test;
    // Factory registration for amiq_dsp_algorithms_fp_sinusoid_test
    `uvm_component_utils(amiq_dsp_algorithms_fp_sinusoid_test)

    /* Constructor for amiq_dsp_algorithms_fp_sinusoid_test
     * @param name : instance name for amiq_dsp_algorithms_fp_sinusoid_test object
     * @param parent : hierarchical parent for amiq_dsp_algorithms_fp_sinusoid_test object
     */
    function new(string name="amiq_dsp_algorithms_fp_sinusoid_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    /* Set the default sequence for VE
     * @param phase : the phase scheduled for build_phase method
     */
    function void build_phase(uvm_phase phase);
        // Register amiq_dsp_algorithms_fp_tx_agt_simple_seq sequence for input agent with a particular phase using config_db
        uvm_config_db#(uvm_object_wrapper)::set(this, "*tx_sequencer.run_phase", "default_sequence", amiq_dsp_algorithms_fp_tx_agt_sinusoid_seq::type_id::get());

        super.build_phase(phase);
        
        // Configure the test name accordingly
        set_config_string("*env_config", "test_name", "amiq_dsp_algorithms_fp_sinusoid_test");
    endfunction
endclass

`endif