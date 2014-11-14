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
 * MODULE:      amiq_dsp_algorithms_import_functions.svh
 * PROJECT:     amiq_dsp_algorithms
 * Description: Forward declaration for all functions imported from DPI-C
 *******************************************************************************/
 
`ifndef __amiq_dsp_algorithms_import_functions
    `define __amiq_dsp_algorithms_import_functions

// Initialize the octave API
import "DPI-C" function void initialize_octave();

/* Import the round function from C it returns the round value for a real number
 * @param value_to_round : input real value to round
 * @return the rounded value for a real number
 */
import "DPI-C" function real round(real value_to_round);

/* Compute in Octave fft function
 * @param sv_data_input_real      : input real part of data to compute fft
 * @param sv_data_input_imaginary : input imaginary part of data to compute fft
 * @return data_output_real       : the real part of result of fft algorithm
 * @return data_output_imaginary  : the imaginary part of result of fft algorithm
 */
import "DPI-C" function void compute_fft(input int sv_data_input_real[], input int sv_data_input_imaginary[], output real data_output_real[`AMIQ_DSP_ALGORITHMS_NOF_POINTS], output real data_output_imaginary[`AMIQ_DSP_ALGORITHMS_NOF_POINTS]);

/* Compute in Octave discrete cosine transform for data_input
 * @param data_input      : input data to compute dct on
 * @param data_input_size : specifies the size of data_input
 * @return data_output    : result after computing dct on data_input
 */
import "DPI-C" function void compute_dct(input int data_input[], input int data_input_size, output real data_output[`AMIQ_DSP_ALGORITHMS_NOF_POINTS]);

/* Compute in Octave convolution for data_input1 and data_input2
 * @param data_input1 : input data1 to compute convolution on
 * @param data_input2 : input data2 to compute convolution on
 * @param data_input_size1 : specifies the size of data_input1
 * @param data_input_size2 : specifies the size of data_input2
 * @return data_output : result after computing convolution on data_input
 */
import "DPI-C" function void compute_conv(input int data_input1[], input int data_input2[], input int data_input_size1, input int data_input_size2, inout int data_output[]);

/* Compute in Octave fir function for data_input using the coef elements as coefficients
 * @param data_input : input data to compute fir on
 * @param coef       : input coefficients used to compute fir
 * @param data_input_size : specifies the size of data_input
 * @return data_output    : result after computing fir on data_input
 */
import "DPI-C" function void compute_fir(input int data_input[], input int coef[], input int data_input_size, inout int data_output[]);

`endif
