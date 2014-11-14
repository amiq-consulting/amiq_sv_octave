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
 * MODULE:      amiq_dsp_algorithms_tx_pkg.sv
 * PROJECT:     amiq_dsp_algorithms
 * Description: TX agent package
 *******************************************************************************/

// TX agent package
package amiq_dsp_algorithms_tx_pkg;
    // Import uvm package
    import uvm_pkg::*;
    
    // Import common package
    import amiq_dsp_algorithms_common_pkg::*;
    
    // Include uvm_macros file
    `include "uvm_macros.svh"
    
    // TX item definition
    `include "amiq_dsp_algorithms_tx_item.svh"
    
    // TX driver definition
    `include "amiq_dsp_algorithms_tx_drv.svh"
    
    // TX sequencer definition
    `include "amiq_dsp_algorithms_tx_seqr.svh"
    
    // TX agent definition
    `include "amiq_dsp_algorithms_tx_agt.svh"
    
    // TX sequence library definition
    `include "amiq_dsp_algorithms_tx_seq_lib.svh"
endpackage