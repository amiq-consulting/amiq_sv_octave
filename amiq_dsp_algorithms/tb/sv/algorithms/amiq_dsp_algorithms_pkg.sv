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
 * Description: Algorithms package
 *******************************************************************************/

// Algorithms package
package amiq_dsp_algorithms_pkg;
    // Import uvm package
    import uvm_pkg::*;

    // Import common package
    import amiq_dsp_algorithms_common_pkg::*;

    // Include uvm_macros file
    `include "uvm_macros.svh"

    // Base algorithm class
    `include "amiq_dsp_algorithms_base_algorithm.svh"

    // FFT algorithm class
    `include "amiq_dsp_algorithms_fft_algorithm.svh"

    // DCT algorithm class
    `include "amiq_dsp_algorithms_dct_algorithm.svh"

    // Convolution algorithm class
    `include "amiq_dsp_algorithms_conv_algorithm.svh"

    // FIR algorithm class
    `include "amiq_dsp_algorithms_fir_algorithm.svh"
endpackage
