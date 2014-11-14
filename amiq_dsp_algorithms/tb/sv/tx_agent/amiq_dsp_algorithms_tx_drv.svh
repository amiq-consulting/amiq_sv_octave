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
 * MODULE:      amiq_dsp_algorithms_tx_drv.svh
 * PROJECT:     amiq_dsp_algorithms
 * Description: TX agent driver
 *******************************************************************************/

`ifndef __amiq_dsp_algorithms_tx_drv
    `define __amiq_dsp_algorithms_tx_drv

// TX agent driver
class amiq_dsp_algorithms_tx_drv extends uvm_driver#(amiq_dsp_algorithms_tx_item);
    // Factory registration of amiq_dsp_algorithms_tx_drv
    `uvm_component_utils(amiq_dsp_algorithms_tx_drv)

    // Process used in agent drive_item task
    process get_and_drive_item_p;

    // Analysis port for passing current transfer
    uvm_analysis_port #(amiq_dsp_algorithms_tx_item) driver_ap;

    /* Constructor for amiq_dsp_algorithms_tx_drv
     * @param name   : instance name for amiq_dsp_algorithms_tx_drv object
     * @param parent : hierarchical parent for amiq_dsp_algorithms_tx_drv
     */
    function new(string name = "amiq_dsp_algorithms_tx_drv", uvm_component parent);
        super.new(name, parent);

        // Creates the monitor_ap port
        driver_ap      = new("input_drv_ap", this);
    endfunction

    /* Build phase method used to instantiate components
     * @param phase : the phase scheduled for build_phase method
     */
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    /* Run phase method used to drive item
     * @param phase : the phase scheduled for build_phase method
     */
    task run_phase(uvm_phase phase);
        `uvm_info("AMIQ_DSP_ALGORITHMS_DRV_TX_AGT", "Started tx agent's driver", UVM_HIGH);

        get_and_drive_item();
    endtask

    // Get an item from the sequence and drive it on the bus
    protected task get_and_drive_item();
        // Define new item
        amiq_dsp_algorithms_tx_item req;
        
        forever begin
            // Get the sequence item from sequencer
            seq_item_port.get_next_item(req);
            
            // Write the item to a port
            driver_ap.write(req);

            // Indicates to the sequencer that the transaction finished
            seq_item_port.item_done();
        end
    endtask
endclass

`endif
