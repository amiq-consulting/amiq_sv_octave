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
 * MODULE:      amiq_dsp_algorithms_fir_algorithm.svh
 * PROJECT:     amiq_dsp_algorithms
 * Description: Implementation of FIR algorithm
 *******************************************************************************/

`ifndef __amiq_dsp_algorithms_fir_algorithm
    `define __amiq_dsp_algorithms_fir_algorithm

// Implementation of FIR algorithm
class amiq_dsp_algorithms_fir_algorithm extends amiq_dsp_algorithms_base_algorithm;
    // Factory registration for amiq_dsp_algorithms_fir_algorithm
    `uvm_object_utils(amiq_dsp_algorithms_fir_algorithm)

    /* Constructor for amiq_dsp_algorithms_fir_algorithm
     * @param name   : instance name for amiq_dsp_algorithms_fir_algorithm object
     */
    function new(string name = "amiq_dsp_algorithms_fir_algorithm");
        super.new(name);

        // Initialize the type for the current algorithm
        algorithm_name = FIR;
    endfunction

    /* Compute a fir for data_input and coef
     * @param data_input : list of values to compute a fir on
     * @param coef : list of impulse response at the i'th instant for 0 < i <  N
     * @param length : nof_items to compute fir
     * @param filter_length : nof_items to compute fir
     * @param fir_results : stores the results obtained after applying the FIR algorithm
     */
    function void fir_algorithm(int data_input[], int coef[], int unsigned length, int unsigned filter_length, ref int fir_results[]);
        /* FIR algorithm
         * X[n] = sum(coef[k] * x[n - k]), [n] = size(data_input), k = 1:n
         */

        // Stores the shifted signal
        var int signal[];

        // Create the signal array
        signal = new [length];

        //Initialize the result array
        fir_results = new[`AMIQ_DSP_ALGORITHMS_NOF_POINTS];

        for (int unsigned  i = 0; i < filter_length; i++) begin
            // Shift element in order to compute fir on
            for (int unsigned k = length - 1; k > 0; k--) begin
                signal[k] = signal[k - 1];
            end

            // Get the first element of the signal used to compute fir on
            signal[0] = data_input[i];

            for (int unsigned k = 0; k < length; k++) begin
                // Multiply data on coefficients with accumulation
                fir_results[i] = fir_results[i] + coef[k] * signal[k];
            end
        end
    endfunction
endclass

`endif
