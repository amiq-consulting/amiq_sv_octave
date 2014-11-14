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
 * MODULE:       amiq_dsp_algorithms_fp_fir_algorithm.svh
 * PROJECT:      amiq_dsp_algorithms_fp
 *
 * Description:  Implementation of FIR algorithm
 *******************************************************************************/

`ifndef __amiq_dsp_algorithms_fp_fir_algorithm
    `define __amiq_dsp_algorithms_fp_fir_algorithm

// Implementation of FIR algorithm
class amiq_dsp_algorithms_fp_fir_algorithm extends amiq_dsp_algorithms_fp_base_algorithm;
    // Factory registration for amiq_dsp_algorithms_fp_fir_algorithm
    `uvm_object_utils(amiq_dsp_algorithms_fp_fir_algorithm)

    /* Constructor for amiq_dsp_algorithms_fp_fir_algorithm
     * @param name   : instance name for amiq_dsp_algorithms_fp_fir_algorithm object
     */
    function new(string name = "amiq_dsp_algorithms_fp_fir_algorithm");
        super.new(name);

        // Initialize the type for the current algorithm
        algorithm_name = FIR;
    endfunction

    /* Compute a fir for data_input and coef using fixed point numbers
     * @param data_input : list of values to compute a fir on
     * @param coef : list of impulse response at the i'th instant for 0 < i <  N
     * @param length : nof_items to compute fir
     * @param filter_length : nof_items to compute fir
     * @param fp_fir_results : stores the results obtained after applying the FIR algorithm using fixed point numbers
     */
    function void fir_algorithm_fp(bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] data_input[], bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] coef[], int unsigned length, int unsigned filter_length, ref bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] fp_fir_results[]);
        /* FIR algorithm
         * X[n] = sum(coef[k] * x[n - k]), [n] = size(data_input), k = 1:n
         */
        // Stores the shifted signal
        var bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] signal[];

        // Create the signal array
        signal = new [length];

        //Initialize the result array
        fp_fir_results = new[`AMIQ_DSP_ALGORITHMS_FP_NOF_POINTS];

        for (int unsigned  i = 0; i < filter_length; i++) begin
            // Shift element in order to compute fir on
            for (int unsigned k = length - 1; k > 0; k--) begin
                signal[k] = signal[k - 1];
            end

            // Get the first element of the signal used to compute fir on
            signal[0] = data_input[i];

            for (int unsigned k = 0; k < length; k++) begin
                // Stores the result of the multiplication between coef[k] and signal[k]
                bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] multiplication_result = multiplication(coef[k], signal[k]);

                // Multiply data on coefficients with accumulation
                fp_fir_results[i] = addition(fp_fir_results[i], multiplication_result);

                // Convert the current item to fixed point
                fp_fir_results[i] = convert_to_fixed_point(fp_fir_results[i]);
            end
        end
    endfunction
endclass

`endif
