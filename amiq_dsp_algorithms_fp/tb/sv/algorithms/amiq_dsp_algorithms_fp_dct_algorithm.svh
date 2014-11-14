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
 * MODULE:    amiq_dsp_algorithms_fp_dct_algorithm.svh
 * PROJECT:      amiq_dsp_algorithms_fp
 *
 * Description: Implementation of dct algorithm
 *******************************************************************************/

`ifndef __amiq_dsp_algorithms_fp_dct_algorithm
    `define __amiq_dsp_algorithms_fp_dct_algorithm

// Implementation of dct algorithm
class amiq_dsp_algorithms_fp_dct_algorithm extends amiq_dsp_algorithms_fp_base_algorithm;
    // Factory registration of amiq_dsp_algorithms_fp_dct_algorithm
    `uvm_object_utils(amiq_dsp_algorithms_fp_dct_algorithm)

    /* Constructor for amiq_dsp_algorithms_fp_dct_algorithm
     * @param name   : instance name for amiq_dsp_algorithms_fp_dct_algorithm object
     */
    function new(string name = "amiq_dsp_algorithms_fp_dct_algorithm");
        super.new(name);

        // Initialize the type for the current algorithm
        algorithm_name = DCT;
    endfunction

    /* Compute the discrete cosine transform of real_part using fixed point numbers
     * @param data_input  : list of values to compute the discrete cosine transform on
     * @param nof_items   : nof_items to compute the discrete cosine transform
     * f@param p_dct_results : stores the results obtained after applying the DCT algorithm using fixed point numbers
     */
    function void dct_algorithm_fp(bit [`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] data_input[], int unsigned nof_items, ref bit [`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] fp_dct_results[]);
        // Scale factor for the first term - should be = sqrt(1/N)
        var bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] scale_factor_0;

        // Scale factor for other terms - should be = sqrt(2/N)
        var bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] scale_factor_1;

        // Create the results arrays
        fp_dct_results = new[`AMIQ_DSP_ALGORITHMS_FP_NOF_POINTS];

        // Initialize the scale factors
        scale_factor_0 = realtobit($sqrt(bittoreal(realtobit(1.0))/nof_items));
        scale_factor_1 = realtobit($sqrt(bittoreal(realtobit(2.0))/nof_items));

        //Initialize the result array
        fp_dct_results = new[`AMIQ_DSP_ALGORITHMS_FP_NOF_POINTS];

        /* DCT algorithm
         * X[k] = scale_factor * sum(x[n] * cos((pi * (2 * n + 1) * k)/( 2 * N)), n = 0 : nof_items - 1, k = 0 : nof_items - 1
         * scale_factor = sqrt(1/N) if k = 0
         * scale_factor = sqrt(2/N) if k = 1 : nof_items - 1
         */
        for(int unsigned index = 0; index < nof_items; index ++)
        begin
            for(int unsigned data_index = 0; data_index < nof_items; data_index++)
            begin
                // Stores the cosine coefficient
                var bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] cos_arg = realtobit($cos(((2 * data_index + 1) * index * bittoreal(realtobit(`AMIQ_DSP_ALGORITHMS_FP_PI_VALUE))) / (2 * nof_items)));

                fp_dct_results[index] = realtobit(bittoreal(fp_dct_results[index]) + data_input[data_index] * bittoreal(cos_arg));
            end

            if(index == 0)
            begin
                fp_dct_results[index] = realtobit(bittoreal(fp_dct_results[index]) * bittoreal(scale_factor_0));
            end else begin
                fp_dct_results[index] = realtobit(bittoreal(fp_dct_results[index]) * bittoreal(scale_factor_1));
            end
        end
    endfunction
endclass

`endif
