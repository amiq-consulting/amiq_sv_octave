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
 * MODULE:      amiq_dsp_algorithms_pkg.sv
 * PROJECT:     amiq_dsp_algorithms
 * Description: Environment package
 *******************************************************************************/

// Environment package
package amiq_dsp_algorithms_env_pkg;
    // Import UVM package
    import uvm_pkg::*;

    // Import common package
    import amiq_dsp_algorithms_common_pkg::*;

    // Import tx agent package
    import amiq_dsp_algorithms_tx_pkg::*;

    // Import algorithms package
    import amiq_dsp_algorithms_pkg::*;

    // Include uvm_macros file
    `include "uvm_macros.svh"

    // Custom reporter overwrites compose massage function
    `include "amiq_dsp_algorithms_reporter.svh"
    
    // Forward declaration for DPI-C functions
    `include "amiq_dsp_algorithms_import_functions.svh"

    // Scoreboard used to compare the results from SystemVerilog with the ones from Octave/SystemC
    `include "amiq_dsp_algorithms_scbd.svh"

    // Custom environment
    `include "amiq_dsp_algorithms_env.svh"
endpackage
