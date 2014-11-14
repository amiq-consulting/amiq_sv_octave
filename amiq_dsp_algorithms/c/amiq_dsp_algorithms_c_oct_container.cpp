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
 * NAME:        amiq_dsp_algorithms_c_oct_container.cpp
 * PROJECT:     amiq_dsp_algorithms
 * Description: C++ layer
 *******************************************************************************/

#ifndef __amiq_dsp_algorithms_c_oct_container
#define __amiq_dsp_algorithms_c_oct_container

#include "amiq_dsp_algorithms_local_octave.h"
#include "amiq_dsp_algorithms_sv_oct_bridge.h"

#include <octave/oct.h>
#include <octave/parse.h>
#include <libgen.h>


// Add custom path of .m files to octave path
void initialize_octave_fct() {
	// Will hold the path for m file
	char path[100];

	// Input parameters list for addpath function
	octave_value_list oct_in_list;

	// Output parameters list of octave addpath function
	octave_value_list oct_out_list;

	// Get the absolute path for the current file
	strncpy(path, __FILE__, strlen(__FILE__) - strlen(AMIQ_DSP_ALGORITHMS_FILENAME));
	path[strlen(__FILE__) - strlen(AMIQ_DSP_ALGORITHMS_FILENAME)] = '\0';

	// Compute the absolute path for all m files
	strcpy(path, strcat(dirname(path), "/octave/"));

	// Add .m path to octave
	oct_in_list(0) = path;
	oct_out_list = feval("addpath", oct_in_list, 1);
}

// Initialize the Octave interpreter
void initialize_octave_cpp() {

	// Declare a string vector used to pass arguments to octave_main function
	string_vector argv(2);

	// Set the first argument to "embedded"
	argv(0) = "embedded";

	// Set verbosity to quiet
	argv(1) = "-q";

	// Initialize Octave interpreter
	octave_main(2, argv.c_str_vec(), 1);

	// Add custom path to Octave
	initialize_octave_fct();
}

/* Compute FFT on input data using Octave API
 * @param data_input_real_to_oct : input real part of data to compute FFT on
 * @param data_input_imaginary_to_oct : input imaginary part of data to compute FFT on
 * @param data_output_real : the real part of result of FFT algorithm
 * @param data_output_imaginary : the imaginary part of result of FFT algorithm
 */
void compute_fft_oct(int *data_input_real_to_oct,
		int *data_input_imaginary_to_oct, double *data_output_real,
		double *data_output_imaginary) {

	// Input message to Octave as a list of integers
	RowVector oct_input_data(AMIQ_DSP_ALGORITHMS_NOF_POINTS);

	// Output message as a list of integers
	ComplexMatrix oct_output_data(2, AMIQ_DSP_ALGORITHMS_NOF_POINTS);

	// Input parameters list for octave FFT function
	octave_value_list oct_in_list;

	// Output parameters list of octave FFT function
	octave_value_list oct_out_list;

	// Copy msg_to_oct into the oct_v_msg
	for (int i = 0; i < AMIQ_DSP_ALGORITHMS_NOF_POINTS; i++) {
		oct_input_data(i) = data_input_real_to_oct[i];
	}

	// Copy octave vector message and size to the octave input list
	oct_in_list(0) = octave_value(oct_input_data);

	// Compute results using FFT Octave function
	oct_out_list = feval("fft", oct_in_list, 1);

	// Copy computed FFT to oct_output_data
	oct_output_data = oct_out_list(0).complex_matrix_value();

	// Forward computed hash tag to DPI-C as a list of bytes
	for (int i = 0; i < AMIQ_DSP_ALGORITHMS_NOF_POINTS; i++) {
		data_output_real[i] = oct_output_data(i).real();
		data_output_imaginary[i] = oct_output_data(i).imag();
	}
}
/* Compute DCT on data_input using Octave API
 * @param data_input : input data to compute DCT on
 * @param data_input_size: specifies the size of data_input
 * @param data_output_real_to_oct : result of DCT algorithm
 */
void compute_dct_oct(int *data_input, int data_input_size,
		double *data_output_real_to_oct) {

	// Input message to Octave as a list of integers
	RowVector oct_input_data(data_input_size);

	// Output message as a list of integers
	Matrix oct_output_data(1, data_input_size);

	// Input parameters list for octave custom function
	octave_value_list oct_in_list;

	// Output parameters list of octave custom function
	octave_value_list oct_out_list;

	// Copy data_input into the oct_input_data
	for (int i = 0; i < data_input_size; i++) {
		oct_input_data(i) = data_input[i];
	}

	// Copy octave vector message and size to the octave input list
	oct_in_list(0) = octave_value(oct_input_data);
	oct_in_list(1) = octave_value(data_input_size);

	// Compute DCT using dct octave function
	oct_out_list = feval("dct", oct_in_list, 1);

	// Copy computed DCT to oct_output_data
	oct_output_data = oct_out_list(0).matrix_value();

	// Forward computed hash tag to DPI-C as a list of bytes
	for (int i = 0; i < data_input_size; i++) {
		data_output_real_to_oct[i] = oct_output_data(0, i);
	}
}

/* Compute in Octave Convolution for data_input1 and data_input2
 * @param data_input1 : input data1 to compute Convolution on
 * @param data_input2 : input data2 to compute Convolution on
 * @param data_input_size1 : specifies the size of data_input1
 * @param data_input_size2 : specifies the size of data_input2
 * @param data_output : result after computing Convolution on data_input
 */
void compute_conv_oct(int *data_input1, int *data_input2, int input_data_size1,
		int input_data_size2, int *data_output_to_oct) {

	// Input message1 to Octave as a list of integers
	RowVector oct_input_data1(input_data_size1);

	// Input message2 to Octave as a list of integers
	RowVector oct_input_data2(input_data_size2);

	// Will store the output size
	int output_size = input_data_size1 + input_data_size2 - 1;

	// Output message as a list of integers
	Matrix oct_output_data(1, output_size);

	// Input parameters list for octave custom function
	octave_value_list oct_in_list;

	// Index used to go through arrays (data1, data2 and data_output)
	int index = 0;

	// Copy data_input1 into the oct_input_data1
	for (index = 0; index < input_data_size1; index++) {
		oct_input_data1(index) = data_input1[index];
	}

	// Copy data_input2 into the oct_input_data2
	for (index = 0; index < input_data_size2; index++) {
		oct_input_data2(index) = data_input2[index];
	}

	// Copy octave vector message and size to the octave input list
	oct_in_list(0) = octave_value(oct_input_data1);
	oct_in_list(1) = octave_value(oct_input_data2);

	// Copy computed conv to oct_output_data
	oct_output_data = feval("conv", oct_in_list, 1)(0).matrix_value();

	// Forward computed hash tag to DPI-C as a list of bytes
	for (index = 0; index < output_size; index++) {
		data_output_to_oct[index] = oct_output_data(0, index);
	}
}

/* Compute in Octave FIR function for data_input using the coef elements as coefficients
 * @param data_input : input data to compute FIR on
 * @param coef       : input coefficients used to compute FIR
 * @param data_input_size : specifies the size of data_input
 * @param data_output    : result after computing FIR on data_input
 */
void compute_fir_oct(int *data_input, int *coef, int input_data_size,
		int *output_data){

	// Input message to Octave as a list of integers
	RowVector oct_input_data(input_data_size);

	// Input coef to Octave as a list of integers
	RowVector oct_coef(input_data_size);

	// Output message as a list of integers
	Matrix oct_output_data(1, input_data_size);

	// Input parameters list for octave custom function
	octave_value_list oct_in_list;

	// Output parameters list of octave custom function
	octave_value_list oct_out_list;

	// Copy data_input into the oct_input_data
	for (int i = 0; i < input_data_size; i++) {
		oct_input_data(i) = data_input[i];
		oct_coef(i) = coef[i];
	}

	// Copy octave vector message and size to the octave input list
	oct_in_list(0) = octave_value(oct_input_data);
	oct_in_list(1) = octave_value(1);
	oct_in_list(2) = octave_value(oct_coef);

	// Compute FIR using filter octave function
	oct_out_list = feval("filter", oct_in_list, 1);

	// Copy computed FIR to oct_output_data
	oct_output_data = oct_out_list(0).matrix_value();

	// Forward computed hash tag to DPI-C as a list of bytes
	for (int i = 0; i < input_data_size; i++) {
		output_data[i] = oct_output_data(0, i);
	}
}


#endif
