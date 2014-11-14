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
 * MODULE:      amiq_dsp_algorithms_env.svh
 * PROJECT:     amiq_dsp_algorithms
 * Description: Algorithms custom environment
 *******************************************************************************/

`ifndef __amiq_dsp_algorithms_env
    `define __amiq_dsp_algorithms_env

// Algorithms custom environment
class amiq_dsp_algorithms_env extends uvm_env;

    // Input agent
    amiq_dsp_algorithms_tx_agt tx_agent;

    // Scoreboard
    amiq_dsp_algorithms_scbd scbd;

    // Factory registration for amiq_dsp_algorithms_env
    `uvm_component_utils(amiq_dsp_algorithms_env)

    /* Constructor for amiq_dsp_algorithms_env
     * @param name   : instance name for amiq_dsp_algorithms_env object
     * @param parent : hierarchical parent for amiq_dsp_algorithms_env
     */
    function new(string name = "amiq_dsp_algorithms_env", uvm_component parent);
        super.new(name, parent);
    endfunction

    /* Build phase method used to instantiate components
     * @param phase : the phase scheduled for build_phase method
     */
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Create and instantiate input agent
        tx_agent = amiq_dsp_algorithms_tx_agt::type_id::create("tx_agent", this);

        // Set input agent is_active type
        uvm_config_db#(int)::set(uvm_root::get(), "*tx_agent*", "is_active", UVM_ACTIVE);

        // Create and instantiate scoreboard
        scbd = amiq_dsp_algorithms_scbd::type_id::create("scbd", this);
    endfunction

    // Sets the configuration for uvm_test_done
    virtual function void start_of_simulation();
        super.start_of_simulation();
        `uvm_info("AMIQ_DSP_ALGORITHMS_ENV", "Started simulation", UVM_LOW);

        uvm_test_done.set_drain_time(this, 1ps);
        uvm_test_done.set_report_verbosity_level(UVM_LOW);
    endfunction

    /* Glue logic for environment components
     * @param phase : the phase scheduled for connect_phase method
     */
    function void connect_phase(uvm_phase phase);
        // Connect scoreboard to the agents monitor's analysis ports
        tx_agent.tx_driver.driver_ap.connect(scbd.tx_ap_driver);
    endfunction
endclass

`endif
