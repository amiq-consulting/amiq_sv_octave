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
 * MODULE:      amiq_dsp_algorithms_tx_agt.svh
 * PROJECT:     amiq_dsp_algorithms
 * Description: TX agent definition
 *******************************************************************************/

`ifndef __amiq_dsp_algorithms_tx_agt
    `define __amiq_dsp_algorithms_tx_agt

// TX agent definition
class amiq_dsp_algorithms_tx_agt extends uvm_agent;
    // Factory registration of amiq_dsp_algorithms_tx_agt
    `uvm_component_utils(amiq_dsp_algorithms_tx_agt)

    // TX driver
    amiq_dsp_algorithms_tx_drv tx_driver;

    // TX sequencer
    amiq_dsp_algorithms_tx_seqr tx_sequencer;

    /* Constructor for amiq_dsp_algorithms_tx_agt
     * @param name   : instance name for amiq_dsp_algorithms_tx_agt object
     * @param parent : hierarchical parent for amiq_dsp_algorithms_tx_agt
     */
    function new(string name = "amiq_dsp_algorithms_tx_agt", uvm_component parent);
        super.new(name, parent);
    endfunction

    /* Build phase method used to instantiate components
     * @param phase : the phase scheduled for build_phase method
     */
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Create the driver and sequencer instances only if the current agent is ACTIVE
        if(get_is_active()) begin
            // Create the driver instance
            tx_driver = amiq_dsp_algorithms_tx_drv::type_id::create("tx_driver", this);

            // Create the sequencer instance
            tx_sequencer = amiq_dsp_algorithms_tx_seqr::type_id::create("tx_sequencer", this);
        end
    endfunction

    /* Glue logic for environment components
     * @paramphase : the phase scheduled for connect_phase method
     */
    function void connect_phase(uvm_phase phase);
        // Connect the agent driver with the agent sequencer if the current agent is ACTIVE
        if(get_is_active()) begin
            tx_driver.seq_item_port.connect(tx_sequencer.seq_item_export);
        end
    endfunction
endclass

`endif
