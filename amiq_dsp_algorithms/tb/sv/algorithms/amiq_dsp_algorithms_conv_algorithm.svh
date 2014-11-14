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
 * MODULE:      amiq_dsp_algorithms_conv_algorithm.svh
 * PROJECT:     amiq_dsp_algorithms
 * Description: Implementation of convolution algorithm
 *******************************************************************************/

`ifndef __amiq_dsp_algorithms_conv_algorithm
    `define __amiq_dsp_algorithms_conv_algorithm

// Implementation of convolution algorithm
class amiq_dsp_algorithms_conv_algorithm extends amiq_dsp_algorithms_base_algorithm;
    // Factory registration of amiq_dsp_algorithms_conv_algorithm
    `uvm_object_utils(amiq_dsp_algorithms_conv_algorithm)

    /* Constructor for amiq_dsp_algorithms_conv_algorithm
     * @param name   : instance name for amiq_dsp_algorithms_conv_algorithm object
     */
    function new(string name = "amiq_dsp_algorithms_conv_algorithm");
        super.new(name);

        // Initialize the type for the current algorithm
        algorithm_name = CONVOLUTION;
    endfunction

    /* Compute the linear convolution for two signals
     * @param in_data_x : the first signal
     * @param in_data_h : the second signal
     * @param conv_results : stores the results obtained after applying the Convolution algorithm
     */
    function void linear_convolution (int in_data_x[], int in_data_h[], ref int conv_results[]);
        /* Convolution algorithm
         * X[n] = sum(f[m] * g[n - m]), m = 0 : N - 1
         */
        // Stores the current index of the current item which is computed
        var int current_index = 0;

        // Stores the start index use to compute convolution
        var int start_index = (current_index - in_data_h.size() + 1 > 0) ? (current_index - in_data_h.size() + 1) : 0;

        // Stores the end index use to compute convolution
        var int finish_index = (current_index > in_data_x.size()) ? in_data_x.size() : current_index;

        // Verify if the the first signal has more elements than the second one
        if (in_data_x.size() < in_data_h.size()) begin
            `uvm_fatal("AMIQ_ALGORITHM_LINEAR_CONVOLUTION_ERR", $sformatf("The first signal should have more elements than the second one (first signal siez: %0d < second signal size: %0d)", in_data_x.size(), in_data_h.size()))
        end

        // Verify that the output array has no element
        if (conv_results.size() != 0) begin
            conv_results = new[0];
        end

        // Calculate the convolution until start_index reaches the size of the first signal
        while (start_index < in_data_x.size()) begin

            // Create a new element for conv_results and initialize it
            conv_results = new[conv_results.size() + 1](conv_results);
            conv_results[conv_results.size() - 1] = 0;

            for(int unsigned idx = start_index; idx <= finish_index; idx++) begin
                conv_results[conv_results.size() - 1] = conv_results[conv_results.size() - 1] + in_data_x[idx] * in_data_h[conv_results.size() - 1 - idx];
            end

            // Increase the current_index
            current_index = current_index + 1;

            // Compute the start index
            start_index = (current_index - in_data_h.size() + 1 > 0) ? (current_index - in_data_h.size() + 1) : 0;

            // Compute the finish index
            finish_index = (current_index > in_data_x.size()) ? in_data_x.size() : current_index;
        end
    endfunction
endclass

`endif
