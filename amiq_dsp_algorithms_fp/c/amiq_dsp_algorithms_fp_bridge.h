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
 * NAME:         amiq_dsp_algorithms_fp_bridge.h
 * PROJECT:      amiq_dsp_algorithms_fp
 * Description:  Header file for all C++ and C functions for sv <-> sc bridge
 *******************************************************************************/

#ifndef __amiq_dsp_algorithms_fp_sv_sc_bridge
#define __amiq_dsp_algorithms_fp_sv_sc_bridge

#define SC_INCLUDE_FX

#include <stdio.h>
#include <iostream>
#include <math.h>
#include <svdpi.h>
#include <systemc.h>
#include <err.h>

#include "amiq_dsp_algorithms_fp_defines.h"

using namespace std;


#ifndef __amiq_dsp_algorithms_fp_type
#define __amiq_dsp_algorithms_fp_type
// Define amiq_dsp_algorithms_fp_fixed_point_type type used for fixed point numbers
typedef sc_fixed<
		AMIQ_DSP_ALGORITHMS_FP_INTEGER_BITS
				+ AMIQ_DSP_ALGORITHMS_FP_FRACTIONAL_BITS + 1,
		AMIQ_DSP_ALGORITHMS_FP_INTEGER_BITS + 1, SC_TRN_ZERO, SC_SAT_ZERO> amiq_dsp_algorithms_fp_type;
#endif

/* Compute fast Fourier transform for input_data_real and input_data_imaginary using radix-16 algorithm using fixed point numbers
 * @param input_data_real : input real part of data to compute fft on
 * @param input_data_imaginary : input imaginary part of data to compute fft on
 * @param real_part : real part of results after computing fft
 * @param imaginary_part : imaginary part of results after computing fft
 */
void fft_algorithm_fp(int *input_data_real, int *input_data_imaginary,
		amiq_dsp_algorithms_fp_type *real_part,
		amiq_dsp_algorithms_fp_type *imaginary_part);

/* Compute the discrete cosine transform of real_part using fixed point numbers
 * @param data_input   : list of values to compute the discrete cosine transform on
 * @param nof_items    : nof_items to compute the discrete cosine transform
 * @param dct_results : the results after computing the dct algorithm on data_input
 */
void dct_algorithm_fp(int *data_input, unsigned int nof_items,
		amiq_dsp_algorithms_fp_type *dct_results);

/* Compute a fir for data_input and coef using fixed point numbers
 * @param data_input : list of values to compute a fir on
 * @param coef : list of impulse response at the i'th instant for 0 < i <  N
 * @param length : nof_items to compute fir
 * @param filter_length : nof_items to compute fir
 * @param fir_data_output : stores the results after computing fir algorithm
 */
void fir_algorithm_fp(int *data_input, int *coef, int length, int filter_length,
		amiq_dsp_algorithms_fp_type *out_data);

/* Compute the linear convolution for two signals using fixed point numbers
 * @param in_data_x : the first signal
 * @param in_data_h : the second signal
 * @param in_data_x_size : the size for the first signal
 * @param in_data_h_size : the size for the second signal
 * @param conv_out_data : the results of convolution between in_data_x and in_data_h
 */
void conv_algorithm_fp(amiq_dsp_algorithms_fp_type *in_data_x,
		amiq_dsp_algorithms_fp_type *in_data_h_to_sc, int in_data_x_size,
		int in_data_h_size, amiq_dsp_algorithms_fp_type *conv_out_data);

/* Transform the elements of an array from fixed point data type to svBitVecVal data type
 * transformed_elements : stores the elements casted
 * elements_to_be_transformed : stores the elements to be casted
 * data_size : stores the size of the arrays
 */
void convert_fixed_point_2_svBitVecVal(svBitVecVal *transformed_elements,
		amiq_dsp_algorithms_fp_type *elements_to_be_transformed,
		unsigned int data_size);

extern "C" {

/* Compute in fixed-point SystemC fft function using fixed point numbers
 * @param data_input_real      : input real part of data to compute fft
 * @param data_input_imaginary : input imaginary part of data to compute fft
 * @param data_output_real       : the real part of result of fft algorithm
 * @param data_output_imaginary  : the imaginary part of result of fft algorithm
 */
void compute_fft_fp(const svOpenArrayHandle data_input_real,
		const svOpenArrayHandle data_input_imaginary,
		svBitVecVal data_output_real[AMIQ_DSP_ALGORITHMS_FP_NOF_POINTS],
		svBitVecVal data_output_imaginary[AMIQ_DSP_ALGORITHMS_FP_NOF_POINTS]);

/* Compute in fixed-point SystemC discrete cosine transform for data_input
 * @param data_input      : input data to compute dct on
 * @param data_input_size : specifies the size of data_input
 * @param data_output     : result after computing dct on data_input
 */
void compute_dct_fp(const svOpenArrayHandle data_input, int data_input_size,
		svBitVecVal data_output[AMIQ_DSP_ALGORITHMS_FP_NOF_POINTS]);

/* Compute in fixed-point SystemC fir function for data_input using the coef elements as coefficients
 * @param data_input : input data to compute fir on
 * @param coef       : input coefficients used to compute fir
 * @param length     : specifies the size of data_input
 * @param filter_length : specifies the size of coef
 * @return data_output    : result after computing fir on data_input
 */
void compute_fir_fp(const svOpenArrayHandle data_input,
		const svOpenArrayHandle coef, int length, int filter_length,
		svBitVecVal data_output[AMIQ_DSP_ALGORITHMS_FP_NOF_POINTS]);

/* Compute in fixed-point SystemC Convolution for in_data_x and in_data_h
 * @param in_data_x : input data1 to compute Convolution on
 * @param in_data_h : input data2 to compute Convolution on
 * @param in_data_x_size : specifies the size of in_data_x
 * @param in_data_h_size : specifies the size of in_data_h
 * @param data_output : result after computing Convolution on data_input
 */
void compute_conv_fp(const svOpenArrayHandle in_data_x,
		const svOpenArrayHandle in_data_h, int in_data_x_size,
		int in_data_h_size,
		svBitVecVal data_output[2 * AMIQ_DSP_ALGORITHMS_FP_NOF_POINTS - 1]);
}

#endif
