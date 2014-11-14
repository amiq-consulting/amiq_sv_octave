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
 * MODULE:      amiq_dsp_algorithms_common_pkg.sv
 * PROJECT:     amiq_dsp_algorithms
 * Description: Common package
 *******************************************************************************/

// Common package
package amiq_dsp_algorithms_common_pkg;
    // Import UVM package
    import uvm_pkg::*;

    // Include uvm_macros file
    `include "uvm_macros.svh"

    // Define types
    `include "amiq_dsp_algorithms_types.svh"

    // Defines definitions
    `include "amiq_dsp_algorithms_defines.svh"
endpackage

