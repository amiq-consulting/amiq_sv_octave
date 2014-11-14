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
 * MODULE:       amiq_dsp_algorithms_fp_tx_seqr.svh
 * PROJECT:      amiq_dsp_algorithms_fp
 *
 * Description:  TX agent sequencer
 *******************************************************************************/

`ifndef __amiq_dsp_algorithms_fp_tx_seqr
    `define __amiq_dsp_algorithms_fp_tx_seqr

// TX agent sequencer
class amiq_dsp_algorithms_fp_tx_seqr extends uvm_sequencer#(amiq_dsp_algorithms_fp_item);
    // Factory registration of amiq_dsp_algorithms_fp_tx_seqr
    `uvm_component_utils(amiq_dsp_algorithms_fp_tx_seqr)

    /* Constructor for amiq_dsp_algorithms_fp_tx_seqr
     * @param name   : instance name for amiq_dsp_algorithms_fp_tx_seqr object
     * @param parent : hierarchical parent for amiq_dsp_algorithms_fp_tx_seqr
     */
    function new(string name = "amiq_dsp_algorithms_fp_tx_seqr", uvm_component parent);
        super.new(name, parent);
    endfunction

    /* Build phase method used to instantiate components
     * @param phase : the phase scheduled for build_phase method
     */
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction
endclass

`endif
