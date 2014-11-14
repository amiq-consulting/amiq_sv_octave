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
 * MODULE:       amiq_dsp_algorithms_fp_import_functions.svh
 * PROJECT:      amiq_dsp_algorithms_fp
 *
 * Description:  Forward declaration for all functions imported from DPI-C
 *******************************************************************************/
 
`ifndef __amiq_dsp_algorithms_fp_import_functions
    `define __amiq_dsp_algorithms_fp_import_functions

/* Import the round function from C it returns the round value for a real number
 * @param value_to_round : input real value to round
 * @return the rounded value for a real number
 */
import "DPI-C" function real round(real value_to_round);

/* Compute in fixed-point SystemC fft function
 * @param sv_data_input_real      : input real part of data to compute fft
 * @param sv_data_input_imaginary : input imaginary part of data to compute fft
 * @return data_output_real       : the real part of result of fft algorithm
 * @return data_output_imaginary  : the imaginary part of result of fft algorithm
 */
import "DPI-C" function void compute_fft_fp(input bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] sv_data_input_real[], input bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] sv_data_input_imaginary[], output bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] data_output_real[`AMIQ_DSP_ALGORITHMS_FP_NOF_POINTS], output bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] data_output_imaginary[`AMIQ_DSP_ALGORITHMS_FP_NOF_POINTS]);

/* Compute in fixed-point SystemC discrete cosine transform for data_input
 * @param data_input      : input data to compute dct on
 * @param data_input_size : specifies the size of data_input
 * @return data_output    : result after computing dct on data_input
 */
import "DPI-C" function void compute_dct_fp(input bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] data_input[], input int data_input_size, output bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] data_output[`AMIQ_DSP_ALGORITHMS_FP_NOF_POINTS]);

/* Compute in fixed-point SystemC convolution for in_data_x and in_data_h
 * @param in_data_x : input data1 to compute convolution on
 * @param in_data_h : input data2 to compute convolution on
 * @param in_data_x_size : specifies the size of in_data_x
 * @param in_data_h_size : specifies the size of in_data_h
 * @return data_output : result after computing convolution on data_input
 */
import "DPI-C" function void compute_conv_fp(input bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] in_data_x[], input bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] in_data_h[], input int in_data_x_size, input int in_data_h_size, output bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] data_output[2 * `AMIQ_DSP_ALGORITHMS_FP_NOF_POINTS - 1]);

/* Compute in fixed-point SystemC fir function for data_input using the coef elements as coefficients
 * @param data_input : input data to compute fir on
 * @param coef       : input coefficients used to compute fir
 * @param length     : specifies the size of data_input
 * @param filter_length : specifies the size of coef
 * @return data_output    : result after computing fir on data_input
 */
import "DPI-C" function void compute_fir_fp(input bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] data_input[], input bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] coef[], input int length, input int filter_length, output bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] data_output[`AMIQ_DSP_ALGORITHMS_FP_NOF_POINTS]);

`endif
