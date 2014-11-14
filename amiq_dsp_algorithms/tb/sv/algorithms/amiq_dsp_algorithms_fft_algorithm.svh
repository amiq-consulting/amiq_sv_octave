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
  * MODULE:      amiq_dsp_algorithms_fft_algorithm.svh
  * PROJECT:     amiq_dsp_algorithms
  * Description: Implementation of fft algorithm
  *******************************************************************************/

 `ifndef __amiq_dsp_algorithms_fft_algorithm
    `define __amiq_dsp_algorithms_fft_algorithm

// Implementation of fft algorithm
class amiq_dsp_algorithms_fft_algorithm extends amiq_dsp_algorithms_base_algorithm;
    // Factory registration for amiq_dsp_algorithms_fft_algorithm
    `uvm_object_utils(amiq_dsp_algorithms_fft_algorithm)

    /* Constructor for amiq_dsp_algorithms_fft_algorithm
     * @param name   : instance name for amiq_dsp_algorithms_fft_algorithm object
     */
    function new(string name = "amiq_dsp_algorithms_fft_algorithm");
        super.new(name);

        // Initialize the type for the current algorithm
        algorithm_name = FFT;
    endfunction

    /* Compute fast Fourier transform for input_data_real and input_data_imaginary
     * @param input_data_real : input real part of data to compute fft on
     * @param input_data_imaginary : input imaginary part of data to compute fft on
     * @param real_fft_results : stores the real part of results obtained after applying the FFT algorithm
     * @param imaginary_fft_results : stores the imaginary part of results obtained after applying the FFT algorithm
     */
    function void calculate_fft(int input_data_real[], int input_data_imaginary[], ref real real_fft_results[], ref real imaginary_fft_results[]);
        /* FFT algorithm
         * X[k] = sum(x[n] * e^((-i * 2 * pi * k * n) / 256)), n = 0 : 255, k = 0 : 255
         * X_real_part[k] = sum(x[n] * cos ((-1) * (2 * pi * k * n) / 256),  n = 0 : 255, k = 0 : 255
         * X_imaginary_part[k] = sum(x[n] * sin ((-1) * (2 * pi * k * n) / 256),  n = 0 : 255, k = 0 : 255
         */
        // Compute real part of fft
        for(int unsigned k_index = 0; k_index < `AMIQ_DSP_ALGORITHMS_NOF_POINTS; k_index ++) begin
            for(int unsigned n_index = 0; n_index < `AMIQ_DSP_ALGORITHMS_NOF_POINTS; n_index++) begin
                real_fft_results[k_index] = real_fft_results[k_index] + input_data_real[n_index] * $cos((-1)*(2 * `AMIQ_DSP_ALGORITHMS_PI_VALUE * k_index * n_index) / 256);
            end
        end

        // Compute imaginary part of fft
        for(int unsigned k_index = 0; k_index < `AMIQ_DSP_ALGORITHMS_NOF_POINTS; k_index ++) begin
            for(int unsigned n_index = 0; n_index < `AMIQ_DSP_ALGORITHMS_NOF_POINTS; n_index++) begin
                imaginary_fft_results[k_index] = imaginary_fft_results[k_index] + input_data_real[n_index] * $sin((-1)*(2 * `AMIQ_DSP_ALGORITHMS_PI_VALUE * k_index * n_index) / 256);
            end
        end
    endfunction

    /* Compute fast Fourier transform for input_data_real and input_data_imaginary using radix-16 algorithm
     * @param input_data_real : input real part of data to compute fft on
     * @param input_data_imaginary : input imaginary part of data to compute fft on
     * @param real_fft_results : stores the real part of results obtained after applying the FFT algorithm
     * @param imaginary_fft_results : stores the imaginary part of results obtained after applying the FFT algorithm
     */
    function void fft_16_16_algorithm(int input_data_real[], int input_data_imaginary[], ref real real_fft_results[], ref real imaginary_fft_results[]);
        /* FFT radix-16 algorithm
         * X[k] = X[16 * r + s] = sum(w16(m * r) * w256(m * s) * sum(x[16 * l + m] * w16(s * l))), r = 0 : 15, s = 0 : 15, m = 0 : 15, l = 0 : 15
         * w16(m * r) = e^((-i * 2 * pi * m * r) / 16)) = cos ((-1) * (2 * pi * m * r) / 16) + i * sin ((-1) * (2 * pi * m * r) / 16)
         * w256(m * s) = e^((-i * 2 * pi * m * s) / 256)) = cos ((-1) * (2 * pi * m * s) / 16) + i * sin ((-1) * (2 * pi * m * s) / 256)
         * w16(s * l) = e^((-i * 2 * pi * s * l) / 16)) = cos ((-1) * (2 * pi * s * l) / 16) + i * sin ((-1) * (2 * pi * s * l) / 16)
         */

        // Stores the result of the first sum for the real part of the result
        var real m_sum_real = 0;

        // Stores the result of the first sum for the imaginary part of the result
        var real m_sum_img = 0;

        // Stores the result of the second sum for the real part of the result
        var real l_sum_real = 0;

        // Stores the result of the second sum for the imaginary part of the result
        var real l_sum_img = 0;

        for(int unsigned s_index = 0; s_index < 16; s_index ++) begin
            for(int unsigned r_index = 0; r_index < 16; r_index ++) begin
                // Initialize with 0 the sum
                m_sum_real = 0;
                m_sum_img = 0;

                for(int unsigned m_index = 0; m_index < 16; m_index ++) begin
                    // Stores the cosine argument for w16(m * r) coefficient
                    var real cos_arg_1 = $cos((-1) * (2 * `AMIQ_DSP_ALGORITHMS_PI_VALUE * m_index * r_index) / 16);

                    // Stores the cosine argument for w256(m * s) coefficient
                    var real cos_arg_2 = $cos((-1) * (2 * `AMIQ_DSP_ALGORITHMS_PI_VALUE * m_index * s_index) / 256);

                    // Stores the sine argument for w16(m * r) coefficient
                    var real sin_arg_1 = $sin((-1) * (2 * `AMIQ_DSP_ALGORITHMS_PI_VALUE * m_index * r_index) / 16);

                    // Stores the cosine argument for w256(m * s) coefficient
                    var real sin_arg_2 = $sin((-1) * (2 * `AMIQ_DSP_ALGORITHMS_PI_VALUE * m_index * s_index) / 256);

                    // Compute the coefficient for the second sum divided in real part and imaginary part
                    m_sum_real = cos_arg_1 * cos_arg_2 - sin_arg_1 * sin_arg_2;
                    m_sum_img = cos_arg_1 * sin_arg_2 + sin_arg_1 * cos_arg_2;

                    // Initialize with 0 the sum
                    l_sum_real = 0;
                    l_sum_img = 0;

                    for(int unsigned l_index = 0; l_index < 16; l_index ++) begin
                        // Stores the cosine argument for w16(s * l) coefficient
                        var real cos_arg = $cos((-1) * (2 * `AMIQ_DSP_ALGORITHMS_PI_VALUE * l_index * s_index) / 16);

                        // Stores the sine argument for w16(s * l) coefficient
                        var real sin_arg = $sin((-1) * (2 * `AMIQ_DSP_ALGORITHMS_PI_VALUE * l_index * s_index) / 16);

                        // Compute the sum divided into real part and imaginary part
                        l_sum_real = l_sum_real + input_data_real[16 * l_index + m_index] * cos_arg;
                        l_sum_img = l_sum_img + input_data_real[16 * l_index + m_index] * sin_arg;
                    end

                    // Compute the x[16 * r + s] element divided into real part and imaginary part
                    real_fft_results[16 * r_index + s_index] = real_fft_results[16 * r_index + s_index] + (m_sum_real * l_sum_real - m_sum_img * l_sum_img);
                    imaginary_fft_results[16 * r_index + s_index] = imaginary_fft_results[16 * r_index+s_index] + (m_sum_real * l_sum_img + m_sum_img * l_sum_real);
                end
            end
        end
    endfunction
endclass

`endif
