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
 * MODULE:      amiq_dsp_algorithms_simple_test.svh
 * PROJECT:     amiq_dsp_algorithms
 * Description: Simple test
 *******************************************************************************/

`ifndef __amiq_dsp_algorithms_simple_test
   `define  __amiq_dsp_algorithms_simple_test

// Simple test
class amiq_dsp_algorithms_simple_test extends amiq_dsp_algorithms_base_test;
    // Factory registration for amiq_dsp_algorithms_simple_test
    `uvm_component_utils(amiq_dsp_algorithms_simple_test)

    /* Constructor for amiq_dsp_algorithms_simple_test
     * @param name : instance name for amiq_dsp_algorithms_simple_test object
     * @param parent : hierarchical parent for amiq_dsp_algorithms_simple_test object
     */
    function new(string name="amiq_dsp_algorithms_simple_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    /* Set the default sequence for VE
     * @param phase : the phase scheduled for build_phase method
     */
    function void build_phase(uvm_phase phase);
        // Register amiq_dsp_algorithms_tx_agt_simple_seq sequence for input agent with a particular phase using config_db
        uvm_config_db#(uvm_object_wrapper)::set(this, "*tx_sequencer.run_phase", "default_sequence", amiq_dsp_algorithms_tx_agt_simple_seq::type_id::get());

        super.build_phase(phase);
    endfunction
endclass

`endif
