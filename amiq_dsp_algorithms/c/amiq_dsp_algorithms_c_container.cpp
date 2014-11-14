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
 * NAME:        amiq_dsp_algorithms_c_container.cpp
 * PROJECT:     amiq_dsp_algorithms
 * Description: DPI-C layer
 *******************************************************************************/

#ifndef __amiq_dsp_algorithms_c_container
#define __amiq_dsp_algorithms_c_container

#include "amiq_dsp_algorithms_sv_oct_bridge.h"

extern "C" {

// Wrapper over initialize_octave_cpp. This is called from SV
void initialize_octave() {
	initialize_octave_cpp();
}

/* Compute FFT on input data
 * @param data_input_real : input real part of data to compute FFT
 * @param data_input_imaginary : input imaginary part of data to compute FFT
 * @param data_output_real : the real part of result of FFT algorithm
 * @param data_output_imaginary : the imaginary part of result of FFT algorithm
 */
void compute_fft(const svOpenArrayHandle data_input_real,
		const svOpenArrayHandle data_input_imaginary,
		double data_output_real[AMIQ_DSP_ALGORITHMS_NOF_POINTS],
		double data_output_imaginary[AMIQ_DSP_ALGORITHMS_NOF_POINTS]) {

	// Will hold the real data input samples
	int *data_input_real_to_oct;

	// Will hold the imaginary data input samples
	int *data_input_imaginary_to_oct;

	// Will hold the real data output samples
	double *data_output_real_to_oct;

	// Will hold the imaginary data output samples
	double *data_output_imaginary_to_oct;

	// Create the output arrays
	data_output_real_to_oct = new double[AMIQ_DSP_ALGORITHMS_NOF_POINTS];
	data_output_imaginary_to_oct = new double[AMIQ_DSP_ALGORITHMS_NOF_POINTS];

	// Initialize inputs array
	// Store the input values
	data_input_real_to_oct = (int *) svGetArrayPtr(data_input_real);
	data_input_imaginary_to_oct = (int *) svGetArrayPtr(data_input_imaginary);

	// Initialize output arrays
	for (int i = 0; i < AMIQ_DSP_ALGORITHMS_NOF_POINTS; i++) {
		data_output_real_to_oct[i] = 0;
		data_output_imaginary_to_oct[i] = 0;
	}

	// Call to C++ function compute_fft_oct, that in turn will call the Octave one
	compute_fft_oct(data_input_real_to_oct, data_input_imaginary_to_oct,
			data_output_real_to_oct, data_output_imaginary_to_oct);

	// Copy the computed results into the output arrays
	for (int i = 0; i < AMIQ_DSP_ALGORITHMS_NOF_POINTS; i++) {
		data_output_real[i] = data_output_real_to_oct[i];
		data_output_imaginary[i] = data_output_imaginary_to_oct[i];
	}
}

/* Compute DCT for data_input
 * @param data_input : input data to compute DCT on
 * @param data_input_size: specifies the size of data_input
 * @param data_output : result after computing DCT on data_input
 */
void compute_dct(const svOpenArrayHandle data_input, int data_input_size,
		double data_output[AMIQ_DSP_ALGORITHMS_NOF_POINTS]) {

	// Will hold the data input samples
	int *data_input_to_oct;

	// Will hold the real data input samples
	double *data_output_real_to_oct;

	// Initialize inputs array
	// Store the input values
	data_input_to_oct = (int *) svGetArrayPtr(data_input);

	// Create the output array
	data_output_real_to_oct = new double[data_input_size];

	// Initialize output arrays
	for (int i = 0; i < AMIQ_DSP_ALGORITHMS_NOF_POINTS; i++) {
		data_output_real_to_oct[i] = 0;
	}

	// Call to C++ function compute_dct_oct, that in turn will call the Octave one
	compute_dct_oct(data_input_to_oct, data_input_size,
			data_output_real_to_oct);

	// Copy the computed results into the output arrays
	for (int i = 0; i < data_input_size; i++) {
		data_output[i] = data_output_real_to_oct[i];
	}
}

/* Compute in Octave Convolution for data_input1 and data_input2
 * @param data_input1 : input data1 to compute Convolution on
 * @param data_input2 : input data2 to compute Convolution on
 * @param data_input_size1 : specifies the size of data_input1
 * @param data_input_size2 : specifies the size of data_input2
 * @param data_output : result after computing Convolution on data_input
 */
void compute_conv(const svOpenArrayHandle data_input1,
		const svOpenArrayHandle data_input2, int input_data_size1,
		int input_data_size2, const svOpenArrayHandle data_output) {

	// Will hold the data input1 samples
	int *data_input_to_oct1;

	// Will hold the data input2 samples
	int *data_input_to_oct2;

	// Will hold the data output samples
	int *data_output_to_oct;

	// Initialize inputs array
	// Store the input values
	data_input_to_oct1 = (int *) svGetArrayPtr(data_input1);
	data_input_to_oct2 = (int *) svGetArrayPtr(data_input2);
	data_output_to_oct = (int *) svGetArrayPtr(data_output);

	// Call to C++ function compute_conv_oct, that in turn will call the Octave one
	compute_conv_oct(data_input_to_oct1, data_input_to_oct2, input_data_size1,
			input_data_size2, data_output_to_oct);
}

/* Compute in Octave FIR function for data_input using the coef elements as coefficients
 * @param data_input : input data to compute FIR on
 * @param coef       : input coefficients used to compute FIR
 * @param data_input_size : specifies the size of data_input
 * @param data_output    : result after computing FIR on data_input
 */
void compute_fir(const svOpenArrayHandle data_input,
		const svOpenArrayHandle coef, int data_input_size,
		const svOpenArrayHandle data_output) {

	// Will hold the data input samples
	int *data_input_to_oct;

	// Will hold the coef samples
	int *coef_to_oct;

	// Will hold the data output samples
	int *data_output_to_oct;

	// Initialize inputs array
	// Store the input values
	data_input_to_oct = (int *) svGetArrayPtr(data_input);
	coef_to_oct = (int *) svGetArrayPtr(coef);
	data_output_to_oct = (int *) svGetArrayPtr(data_output);

	// Call to C++ function compute_fir_oct, that in turn will call the Octave one
	compute_fir_oct(data_input_to_oct, coef_to_oct, data_input_size,
			data_output_to_oct);
}
}

#endif
