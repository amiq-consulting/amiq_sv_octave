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
 * MODULE:      amiq_dsp_algorithms_tx_seq_lib.svh
 * PROJECT:     amiq_dsp_algorithms
 * Description: TX agent sequence library
 *******************************************************************************/

`ifndef __amiq_dsp_algorithms_tx_seq_lib
    `define __amiq_dsp_algorithms_tx_seq_lib

// TX agent base sequence
class amiq_dsp_algorithms_tx_agt_base_seq extends uvm_sequence#(amiq_dsp_algorithms_tx_item);
    // Factory registration of amiq_dsp_algorithms_tx_agt_base_seq
    `uvm_object_param_utils(amiq_dsp_algorithms_tx_agt_base_seq)
    
    // Define amiq_dsp_algorithms_tx_seqr as a p_sequencer
    `uvm_declare_p_sequencer(amiq_dsp_algorithms_tx_seqr)

    // Number of transfers to be executed by the sequencer
    rand int unsigned nof_transfers;

    // Sequence item
    amiq_dsp_algorithms_tx_item seq_item;

    /* Constructor for amiq_dsp_algorithms_tx_agt_base_seq
     * @param name : instance name for amiq_dsp_algorithms_tx_agt_base_seq object
     */
    function new(string name = "amiq_dsp_algorithms_tx_agt_base_seq");
        super.new(name);
    endfunction
    
    // Defines the pre_body behavior - raise an objection for sequencer
    virtual task pre_body();
        uvm_test_done.raise_objection(p_sequencer, "", 1);
        `uvm_info("AMIQ_DSP_ALGORITHMS_SEQ", "Raised objection test done" , UVM_HIGH);
    endtask

    // Defines the post_body behavior - drop an objection for sequencer
    virtual task post_body();
        uvm_test_done.drop_objection(p_sequencer, "", 1);
        `uvm_info("AMIQ_DSP_ALGORITHMS_SEQ", "Dropped objection test done" , UVM_HIGH);
    endtask
endclass
    
// TX agent simple sequence
class amiq_dsp_algorithms_tx_agt_simple_seq extends amiq_dsp_algorithms_tx_agt_base_seq;
    // Factory registration of amiq_dsp_algorithms_tx_agt_simple_seq
    `uvm_object_utils(amiq_dsp_algorithms_tx_agt_simple_seq)

    // Constrain the number of transfers to a value
    constraint nof_transfers_c {
        nof_transfers <= `AMIQ_DSP_ALGORITHMS_MAX_NOF_TRANSFERS;
    }

    /* Constructor for amiq_dsp_algorithms_tx_agt_simple_seq
     * @param name : instance name for amiq_dsp_algorithms_tx_agt_simple_seq object
     */
    function new(string name = "amiq_dsp_algorithms_tx_agt_simple_seq");
        super.new(name);
    endfunction

    // Defines the sequence behavior
    virtual task body();
        for(int i = 0; i < nof_transfers; i = i + 1) begin
            `uvm_do(seq_item)
        end
    endtask
endclass

// TX agent sinusoid sequence
class amiq_dsp_algorithms_tx_agt_sinusoid_seq extends amiq_dsp_algorithms_tx_agt_base_seq;
    // Factory registration of amiq_dsp_algorithms_tx_agt_sinusoid_seq
    `uvm_object_utils(amiq_dsp_algorithms_tx_agt_sinusoid_seq)

    // Constrain the number of transfers to a value
    constraint nof_transfers_c {
        nof_transfers <= `AMIQ_DSP_ALGORITHMS_MAX_NOF_TRANSFERS;
    }

    /* Constructor for amiq_dsp_algorithms_tx_agt_sinusoid_seq
     * @param name : instance name for amiq_dsp_algorithms_tx_agt_sinusoid_seq object
     */
    function new(string name = "amiq_dsp_algorithms_tx_agt_sinusoid_seq");
        super.new(name);
    endfunction

    // Defines the sequence behavior
    virtual task body();
        for(int i = 0; i < nof_transfers; i = i + 1) begin
           `uvm_do_with(seq_item, {
                seq_item.is_a_sinusoid == 1;
                seq_item.start_value == 0;
                })
        end
    endtask
endclass

`endif
