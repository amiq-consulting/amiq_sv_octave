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
 * NAME:        amiq_dsp_algorithms_sv_oct_bridge.h
 * PROJECT:     amiq_dsp_algorithms
 * Description: Header file for all C++ and C functions for sv <-> octave bridge
 *******************************************************************************/

#ifndef __amiq_dsp_algorithms_sv_oct_bridge
#define __amiq_dsp_algorithms_sv_oct_bridge

#include <stdio.h>
#include <iostream>
#include <fstream>
#include <math.h>
#include <svdpi.h>
#include <err.h>

#include <string.h>

using namespace std;

// Define number of points in which the function is defined
#ifndef AMIQ_DSP_ALGORITHMS_NOF_POINTS
#define AMIQ_DSP_ALGORITHMS_NOF_POINTS 256
#endif

// Workaround to get access to *.m files
#ifndef AMIQ_DSP_ALGORITHMS_FILENAME
#define AMIQ_DSP_ALGORITHMS_FILENAME (strrchr(__FILE__, '/') ? strrchr(__FILE__, '/') + 1 : __FILE__)
#endif


// Add custom path of .m files to octave path
void initialize_octave_fct();

// Initialize the octave API
void initialize_octave_cpp();

/* Compute FFT on input data using Octave API
 * @param data_input_real_to_oct : input real part of data to compute FFT on
 * @param data_input_imaginary_to_oct : input imaginary part of data to compute FFT on
 * @param data_output_real : the real part of result of FFT algorithm
 * @param data_output_imaginary : the imaginary part of result of FFT algorithm
 */
void compute_fft_oct(int *data_input_real_to_oct,
		int *data_input_imaginary_to_oct, double *data_output_real,
		double *data_output_imaginary);

/* Compute DCT on data_input using Octave API
 * @param data_input : input data to compute DCT on
 * @param data_input_size: specifies the size of data_input
 * @param data_output_real_to_oct : result of DCT algorithm
 */
void compute_dct_oct(int *data_input, int data_input_size,
		double *data_output_real_to_oct);

/* Compute in Octave Convolution for data_input1 and data_input2
 * @param data_input1 : input data1 to compute Convolution on
 * @param data_input2 : input data2 to compute Convolution on
 * @param data_input_size1 : specifies the size of data_input1
 * @param data_input_size2 : specifies the size of data_input2
 * @param data_output : result after computing Convolution on data_input
 */
void compute_conv_oct(int *data_input1, int *data_input2, int input_data_size1,
		int input_data_size2, int *data_output_to_oct);

/* Compute in Octave FIR function for data_input using the coef elements as coefficients
 * @param data_input : input data to compute FIR on
 * @param coef       : input coefficients used to compute FIR
 * @param data_input_size : specifies the size of data_input
 * @param data_output    : result after computing FIR on data_input
 */
void compute_fir_oct(int *data_input, int *coef, int input_data_size,
		int *output_data);

extern "C" {

// Wrapper over initialize_octave_cpp. This is called from SV
void initialize_octave();

/* Compute FFT on input data
 * @param data_input_real : input real part of data to compute FFT
 * @param data_input_imaginary : input imaginary part of data to compute FFT
 * @param data_output_real : the real part of result of FFT algorithm
 * @param data_output_imaginary : the imaginary part of result of FFT algorithm
 */
void compute_fft(const svOpenArrayHandle data_input_real,
		const svOpenArrayHandle data_input_imaginary,
		double data_output_real[AMIQ_DSP_ALGORITHMS_NOF_POINTS],
		double data_output_imaginary[AMIQ_DSP_ALGORITHMS_NOF_POINTS]);

/* Compute DCT for data_input
 * @param data_input : input data to compute DCT on
 * @param data_input_size: specifies the size of data_input
 * @param data_output : result after computing DCT on data_input
 */
void compute_dct(const svOpenArrayHandle data_input, int data_input_size,
		double data_output[AMIQ_DSP_ALGORITHMS_NOF_POINTS]);

/* Compute in Octave Convolution for data_input1 and data_input2
 * @param data_input1 : input data1 to compute Convolution on
 * @param data_input2 : input data2 to compute Convolution on
 * @param data_input_size1 : specifies the size of data_input1
 * @param data_input_size2 : specifies the size of data_input2
 * @param data_output : result after computing Convolution on data_input
 */
void compute_conv(const svOpenArrayHandle data_input1,
		const svOpenArrayHandle data_input2, int input_data_size1,
		int input_data_size2, const svOpenArrayHandle data_output);

/* Compute in Octave FIR function for data_input using the coef elements as coefficients
 * @param data_input : input data to compute FIR on
 * @param coef       : input coefficients used to compute FIR
 * @param data_input_size : specifies the size of data_input
 * @param data_output    : result after computing FIR on data_input
 */
void compute_fir(const svOpenArrayHandle data_input,
		const svOpenArrayHandle coef, int data_input_size,
		const svOpenArrayHandle data_output);
}

#endif
