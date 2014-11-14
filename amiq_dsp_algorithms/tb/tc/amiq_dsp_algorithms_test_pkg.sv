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
 * MODULE:      amiq_dsp_algorithms_test_pkg.sv
 * PROJECT:     amiq_dsp_algorithms
 * Description: Test package
 *******************************************************************************/

// Test package
package amiq_dsp_algorithms_test_pkg;
    // Import uvm package
    import uvm_pkg::*;

    // Import algorithms package
    import amiq_dsp_algorithms_pkg::*;

    // Import agent's package
    import amiq_dsp_algorithms_tx_pkg::*;

    // Import environment package
    import amiq_dsp_algorithms_env_pkg::*;

    // Include uvm_macros file
    `include "uvm_macros.svh"

    // Base test class
    `include "amiq_dsp_algorithms_base_test.svh"

    // Simple test class
    `include "amiq_dsp_algorithms_simple_test.svh"

    // The test in which a sinusoid is driven
    `include "amiq_dsp_algorithms_sinusoid_test.svh"
endpackage