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
 * NAME:         amiq_dsp_algorithms_fp_functions.cpp
 * PROJECT:      amiq_dsp_algorithms_fp
 * Description:  Algorithms implemented in SystemC using fixed point implementation
 *******************************************************************************/

#ifndef __amiq_dsp_algorithms_fp_functions
#define __amiq_dsp_algorithms_fp_functions

#include "amiq_dsp_algorithms_fp_bridge.h"

/* Compute fast Fourier transform for input_data_real and input_data_imaginary using radix-16 algorithm using fixed point numbers
 * @param input_data_real : input real part of data to compute fft on
 * @param input_data_imaginary : input imaginary part of data to compute fft on
 * @param real_part : real part of results after computing fft
 * @param imaginary_part : imaginary part of results after computing fft
 */
void fft_algorithm_fp(int *input_data_real, int *input_data_imaginary,
		amiq_dsp_algorithms_fp_type *real_part,
		amiq_dsp_algorithms_fp_type *imaginary_part) {
	/* FFT radix-16 algorithm
	 * X[k] = X[16 * r + s] = sum(w16(m * r) * w256(m * s) * sum(x[16 * l + m] * w16(s * l))), r = 0 : 15, s = 0 : 15, m = 0 : 15, l = 0 : 15
	 * w16(m * r) = e^((-i * 2 * pi * m * r) / 16)) = cos ((-1) * (2 * pi * m * r) / 16) + i * sin ((-1) * (2 * pi * m * r) / 16)
	 * w256(m * s) = e^((-i * 2 * pi * m * s) / 256)) = cos ((-1) * (2 * pi * m * s) / 16) + i * sin ((-1) * (2 * pi * m * s) / 256)
	 * w16(s * l) = e^((-i * 2 * pi * s * l) / 16)) = cos ((-1) * (2 * pi * s * l) / 16) + i * sin ((-1) * (2 * pi * s * l) / 16)
	 */

	// Stores the result of the first sum for the real part of the result
	amiq_dsp_algorithms_fp_type m_sum_real = 0;

	// Stores the result of the first sum for the imaginary part of the result
	amiq_dsp_algorithms_fp_type m_sum_img = 0;

	// Stores the result of the second sum for the real part of the result
	amiq_dsp_algorithms_fp_type l_sum_real = 0;

	// Stores the result of the second sum for the imaginary part of the result
	amiq_dsp_algorithms_fp_type l_sum_img = 0;

	// Stores the PI value into
	amiq_dsp_algorithms_fp_type pi_value = AMIQ_DSP_ALGORITHMS_FP_PI_VALUE;

	for (unsigned int s_index = 0; s_index < 16; s_index++) {
		for (unsigned int r_index = 0; r_index < 16; r_index++) {
			// Initialize with 0 the sum
			m_sum_real = 0;
			m_sum_img = 0;

			for (int unsigned m_index = 0; m_index < 16; m_index++) {
				// Stores the cosine argument for w16(m * r) coefficient
				amiq_dsp_algorithms_fp_type cos_arg_1 = cos(
						(-1) * (2 * pi_value * m_index * r_index) / 16);

				// Stores the cosine argument for w256(m * s) coefficient
				amiq_dsp_algorithms_fp_type cos_arg_2 = cos(
						(-1) * (2 * pi_value * m_index * s_index) / 256);

				// Stores the sine argument for w16(m * r) coefficient
				amiq_dsp_algorithms_fp_type sin_arg_1 = sin(
						(-1) * (2 * pi_value * m_index * r_index) / 16);

				// Stores the cosine argument for w256(m * s) coefficient
				amiq_dsp_algorithms_fp_type sin_arg_2 = sin(
						(-1) * (2 * pi_value * m_index * s_index) / 256);

				// Compute the coefficient for the second sum divided in real part and imaginary part
				m_sum_real = cos_arg_1 * cos_arg_2 - sin_arg_1 * sin_arg_2;
				m_sum_img = cos_arg_1 * sin_arg_2 + sin_arg_1 * cos_arg_2;

				// Initialize with 0 the sum
				l_sum_real = 0;
				l_sum_img = 0;

				for (unsigned int l_index = 0; l_index < 16; l_index++) {
					// Stores the cosine argument for w16(s * l) coefficient
					amiq_dsp_algorithms_fp_type cos_arg = cos(
							(-1) * (2 * pi_value * l_index * s_index) / 16);

					// Stores the sine argument for w16(s * l) coefficient
					amiq_dsp_algorithms_fp_type sin_arg = sin(
							(-1) * (2 * pi_value * l_index * s_index) / 16);

					// Compute the sum divided into real part and imaginary part
					l_sum_real = l_sum_real
							+ input_data_real[16 * l_index + m_index] * cos_arg;
					l_sum_img = l_sum_img
							+ input_data_real[16 * l_index + m_index] * sin_arg;
				}

				// Stores the sum for real part of data
				amiq_dsp_algorithms_fp_type real_sum = m_sum_real * l_sum_real
						- m_sum_img * l_sum_img;

				// Stores the sum for imaginary part of data
				amiq_dsp_algorithms_fp_type imaginary_sum = m_sum_real
						* l_sum_img + m_sum_img * l_sum_real;

				// Compute the x[16 * r + s] element divided into real part and imaginary part
				real_part[16 * r_index + s_index] = real_part[16 * r_index
						+ s_index] + real_sum;
				imaginary_part[16 * r_index + s_index] = imaginary_part[16
						* r_index + s_index] + imaginary_sum;
			}
		}
	}
}

/* Compute the discrete cosine transform of real_part using fixed point numbers
 * @param data_input   : list of values to compute the discrete cosine transform on
 * @param nof_items    : nof_items to compute the discrete cosine transform
 * @param dct_results : the results after computing the dct algorithm on data_input
 */
void dct_algorithm_fp(int *data_input, unsigned int nof_items,
		amiq_dsp_algorithms_fp_type *dct_results) {

	amiq_dsp_algorithms_fp_type pi_value = AMIQ_DSP_ALGORITHMS_FP_PI_VALUE;

	// Scale factor for the first term - should be = sqrt(1/N)
	amiq_dsp_algorithms_fp_type scale_factor_0;

	// Scale factor for other terms - should be = sqrt(2/N)
	amiq_dsp_algorithms_fp_type scale_factor_1;

	// Initialize the scale factors
	scale_factor_0 = sqrt(1.0 / nof_items);
	scale_factor_1 = sqrt(2.0 / nof_items);

	/* DCT algorithm
	 * X[k] = scale_factor * sum(x[n] * cos((pi * (2 * n + 1) * k)/( 2 * N)), n = 0 : nof_items - 1, k = 0 : nof_items - 1
	 * scale_factor = sqrt(1/N) if k = 0
	 * scale_factor = sqrt(2/N) if k = 1 : nof_items - 1
	 */
	for (unsigned int index = 0; index < nof_items; index++) {
		for (unsigned int data_index = 0; data_index < nof_items;
				data_index++) {

			// Stores the cosine coefficient
			amiq_dsp_algorithms_fp_type cos_arg = cos(
					((2 * data_index + 1) * index * pi_value)
							/ (2 * nof_items));

			dct_results[index] = dct_results[index]
					+ data_input[data_index] * cos_arg;
		}

		if (index == 0) {
			dct_results[index] = dct_results[index] * scale_factor_0;
		} else {
			dct_results[index] = dct_results[index] * scale_factor_1;
		}
	}
}

/* Compute a fir for data_input and coef using fixed point numbers
 * @param data_input : list of values to compute a fir on
 * @param coef : list of impulse response at the i'th instant for 0 < i <  N
 * @param length : nof_items to compute fir
 * @param filter_length : nof_items to compute fir
 * @param fir_data_output : stores the results after computing fir algorithm
 */
void fir_algorithm_fp(int *data_input, int *coef, int length, int filter_length,
		amiq_dsp_algorithms_fp_type *out_data) {

	/* FIR algorithm
	 * X[n] = sum(coef[k] * x[n - k]), [n] = size(data_input), k = 1:n
	 */

	// Stores the shifted signal
	int *signal;

	// Create and initialize the signal array
	signal = new int[length];
	for (int i = 0; i < length; i++) {
		signal[i] = 0;
	}

	for (int i = 0; i < filter_length; i++) {
		// Shift element in order to compute fir on
		for (unsigned int k = length - 1; k > 0; k--) {
			signal[k] = signal[k - 1];
		}

		// Get the first element of the signal used to compute fir on
		signal[0] = data_input[i];

		for (int k = 0; k < length; k++) {
			// Multiply data on coefficients with accumulation
			out_data[i] = out_data[i] + coef[k] * signal[k];
		}
	}
}

/* Compute the linear convolution for two signals using fixed point numbers
 * @param in_data_x : the first signal
 * @param in_data_h : the second signal
 * @param in_data_x_size : the size for the first signal
 * @param in_data_h_size : the size for the second signal
 * @param conv_out_data : the results of convolution between in_data_x and in_data_h
 */
void conv_algorithm_fp(amiq_dsp_algorithms_fp_type *in_data_x,
		amiq_dsp_algorithms_fp_type *in_data_h_to_sc, int in_data_x_size,
		int in_data_h_size, amiq_dsp_algorithms_fp_type *conv_out_data) {

	/* Convolution algorithm
	 * X[n] = sum(f[m] * g[n - m]), m = 0 : N - 1
	 */
	// Stores the current index of the current item which is computed
	int current_index = 0;

	// Stores the current index of the item computed
	int crt_index = 0;

	// Stores the start index use to compute convolution
	amiq_dsp_algorithms_fp_type start_index =
			(current_index - in_data_h_size + 1 > 0) ?
					(current_index - in_data_h_size + 1) : 0;

	// Stores the end index use to compute convolution
	amiq_dsp_algorithms_fp_type finish_index =
			(current_index > in_data_x_size) ? in_data_x_size : current_index;

	// Verify if the the first signal has more elements than the second one
	if (in_data_x_size < in_data_h_size) {
		err(1,
				"AMIQ_LINEAR_CONV_SC_ERR: The first signal should have more elements than the second one(for fixed point algorithm)");
	}

	// Calculate the convolution until start_index reaches the size of the first signal
	while (start_index < in_data_x_size) {
		// Increase the crt_index
		crt_index = crt_index + 1;

		// Initialize the new element with 0
		conv_out_data[crt_index - 1] = 0;

		for (unsigned int idx = start_index; idx < finish_index; idx++) {
			// Stores the multiplication between in_data_x[idx] and in_data_h[fp_conv_results.size() - 1 - idx]
			amiq_dsp_algorithms_fp_type mul = in_data_x[idx]
					* in_data_h_to_sc[crt_index - 1 - idx];

			// Stores the addition of mul_result and fp_conv_results[fp_conv_results.size() - 1]
			amiq_dsp_algorithms_fp_type add = mul
					+ conv_out_data[crt_index - 1];

			// Assign the proper value for conv_out_data
			conv_out_data[crt_index - 1] = add;

		}

		// Increase the current_index
		current_index = current_index + 1;

		// Compute the start index
		start_index =
				(current_index - in_data_h_size + 1 > 0) ?
						(current_index - in_data_h_size + 1) : 0;

		// Compute the finish index
		finish_index =
				(current_index > in_data_x_size) ?
						in_data_x_size : current_index;
	}
}

/* Transform the elements of an array from fixed point data type to svBitVecVal data type
 * transformed_elements : stores the elements casted
 * elements_to_be_transformed : stores the elements to be casted
 * data_size : stores the size of the arrays
 */
void convert_fixed_point_2_svBitVecVal(svBitVecVal *transformed_elements,
		amiq_dsp_algorithms_fp_type *elements_to_be_transformed,
		unsigned int data_size) {

	// Transform each element from elements_to_be_transformed array
	for (unsigned int index = 0; index < data_size; index++) {
		// Introduce at first the decimal part of the numbers
		for (unsigned int bit_index = 0;
				bit_index < AMIQ_DSP_ALGORITHMS_FP_INTEGER_BITS + 1;
				bit_index++) {

			// Shift left one bit
			transformed_elements[index] = transformed_elements[index] << 1;

			// Add the new bit into current element
			transformed_elements[index] = transformed_elements[index]
					| elements_to_be_transformed[index].get_bit(
							AMIQ_DSP_ALGORITHMS_FP_INTEGER_BITS - bit_index);

		}

		// Introduce the fractional part of the numbers
		for (unsigned int bit_index = 1;
				bit_index <= AMIQ_DSP_ALGORITHMS_FP_FRACTIONAL_BITS;
				bit_index++) {

			// Shift left one bit
			transformed_elements[index] = transformed_elements[index] << 1;

			// Add the new bit into current element
			transformed_elements[index] = transformed_elements[index]
					| elements_to_be_transformed[index].get_bit(-bit_index);
		}
	}
}

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
		svBitVecVal data_output_imaginary[AMIQ_DSP_ALGORITHMS_FP_NOF_POINTS]) {

	// Will hold the real data input samples
	int *data_input_real_to_oct;

	// Will hold the imaginary data input samples
	int *data_input_imaginary_to_oct;

	// Will hold the real data output samples
	amiq_dsp_algorithms_fp_type *data_output_real_to_sc;

	// Will hold the imaginary data output samples
	amiq_dsp_algorithms_fp_type *data_output_imaginary_to_sc;

	// Create the arrays which stores the results
	data_output_real_to_sc =
			new amiq_dsp_algorithms_fp_type[AMIQ_DSP_ALGORITHMS_FP_NOF_POINTS];
	data_output_imaginary_to_sc =
			new amiq_dsp_algorithms_fp_type[AMIQ_DSP_ALGORITHMS_FP_NOF_POINTS];

	// Initialize inputs array
	// Store the input values
	data_input_real_to_oct = (int *) svGetArrayPtr(data_input_real);
	data_input_imaginary_to_oct = (int *) svGetArrayPtr(data_input_imaginary);

	// Compute fft in SystemC using fixed point numbers
	fft_algorithm_fp(data_input_real_to_oct, data_input_imaginary_to_oct,
			data_output_real_to_sc, data_output_imaginary_to_sc);

	// Transform the results from fixed point to svBitVecVal
	convert_fixed_point_2_svBitVecVal(data_output_real, data_output_real_to_sc,
			AMIQ_DSP_ALGORITHMS_FP_NOF_POINTS);

	// Transform the results from fixed point to svBitVecVal
	convert_fixed_point_2_svBitVecVal(data_output_imaginary,
			data_output_imaginary_to_sc, AMIQ_DSP_ALGORITHMS_FP_NOF_POINTS);
}

/* Compute in fixed-point SystemC discrete cosine transform for data_input
 * @param data_input      : input data to compute dct on
 * @param data_input_size : specifies the size of data_input
 * @param data_output     : result after computing dct on data_input
 */
void compute_dct_fp(const svOpenArrayHandle data_input, int data_input_size,
		svBitVecVal data_output[AMIQ_DSP_ALGORITHMS_FP_NOF_POINTS]) {

	// Will hold the data input samples
	int *data_input_to_sc;

	// Will hold the real data input samples
	amiq_dsp_algorithms_fp_type *data_output_real_to_sc;

	// Initialize inputs array
	// Store the input values
	data_input_to_sc = (int *) svGetArrayPtr(data_input);

	// Create the output array
	data_output_real_to_sc = new amiq_dsp_algorithms_fp_type[data_input_size];

	// Call to SystemC function fixed_point_dct_algorithm
	dct_algorithm_fp(data_input_to_sc, data_input_size, data_output_real_to_sc);

	// Transform the results from fixed point to svBitVecVal
	convert_fixed_point_2_svBitVecVal(data_output, data_output_real_to_sc,
			AMIQ_DSP_ALGORITHMS_FP_NOF_POINTS);

}

/* Compute in fixed-point SystemC fir function for data_input using the coef elements as coefficients
 * @param data_input : input data to compute fir on
 * @param coef       : input coefficients used to compute fir
 * @param length     : specifies the size of data_input
 * @param filter_length : specifies the size of coef
 * @return data_output    : result after computing fir on data_input
 */
void compute_fir_fp(const svOpenArrayHandle data_input,
		const svOpenArrayHandle coef, int length, int filter_length,
		svBitVecVal data_output[AMIQ_DSP_ALGORITHMS_FP_NOF_POINTS]) {

	// Will hold the data input1 samples
	int *input_samples_to_sc;

	// Will hold the data input2 samples
	int *coeff_to_sc;

	// Will hold the data output samples
	amiq_dsp_algorithms_fp_type *out_data;

	// Initialize inputs array
	// Store the input values
	input_samples_to_sc = (int *) svGetArrayPtr(data_input);
	coeff_to_sc = (int *) svGetArrayPtr(coef);
	out_data = new amiq_dsp_algorithms_fp_type[filter_length];

	// Call SystemC fixed_point_fir_algorithm_sc function
	fir_algorithm_fp(input_samples_to_sc, coeff_to_sc, length, filter_length,
			out_data);

	// Transform the results from fixed point to svBitVecVal
	convert_fixed_point_2_svBitVecVal(data_output, out_data,
			AMIQ_DSP_ALGORITHMS_FP_NOF_POINTS);
}

/* Compute in fixed-point SystemC convolution for in_data_x and in_data_h
 * @param in_data_x : input data1 to compute convolution on
 * @param in_data_h : input data2 to compute convolution on
 * @param in_data_x_size : specifies the size of in_data_x
 * @param in_data_h_size : specifies the size of in_data_h
 * @param data_output : result after computing convolution on data_input
 */
void compute_conv_fp(const svOpenArrayHandle in_data_x,
		const svOpenArrayHandle in_data_h, int in_data_x_size,
		int in_data_h_size,
		svBitVecVal data_output[5 * AMIQ_DSP_ALGORITHMS_FP_NOF_POINTS - 1]) {

	// Will hold the data input1 samples
	amiq_dsp_algorithms_fp_type *in_data_x_to_sc;

	// Will hold the data input2 samples
	amiq_dsp_algorithms_fp_type *in_data_h_to_sc;

	// Will hold the data output samples
	amiq_dsp_algorithms_fp_type *out_data;

	// Create inputs array
	in_data_x_to_sc = new amiq_dsp_algorithms_fp_type[in_data_x_size
			+ in_data_h_size - 1];
	in_data_h_to_sc = new amiq_dsp_algorithms_fp_type[in_data_x_size
			+ in_data_h_size - 1];

	// Create output array
	out_data = new amiq_dsp_algorithms_fp_type[in_data_x_size + in_data_h_size
			- 1];

	// Copy input elements from in_data_x to in_data_x_to_sc
	for (int index = 0; index < in_data_x_size; index++) {
		int *a = (int *) svGetArrElemPtr1(in_data_x, index);
		in_data_x_to_sc[index] = *a;
	}

	// Copy input elements from in_data_h to in_data_h_to_sc
	for (int index = 0; index < in_data_h_size; index++) {
		int *a = (int *) svGetArrElemPtr1(in_data_h, index);
		in_data_h_to_sc[index] = *a;
	}

	// Call SystemC fixed_point_conv_algorithm_sc function
	conv_algorithm_fp(in_data_x_to_sc, in_data_h_to_sc, in_data_x_size,
			in_data_h_size, out_data);

	// Transform the results from fixed point to svBitVecVal
	convert_fixed_point_2_svBitVecVal(data_output, out_data,
			in_data_x_size + in_data_h_size - 1);
}
}

#endif
