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
  * MODULE:       amiq_dsp_algorithms_fp_base_algorithm.svh
  * PROJECT:      amiq_dsp_algorithms_fp
  *
  * Description:  Base class of algorithms
  *******************************************************************************/

 `ifndef __amiq_dsp_algorithms_fp_base_algorithm
    `define __amiq_dsp_algorithms_fp_base_algorithm

// Base class of algorithms
class amiq_dsp_algorithms_fp_base_algorithm extends uvm_object;

    // Stores the type of the algorithm
    amiq_dsp_algorithms_fp_type algorithm_name;

    // Factory registration for amiq_dsp_algorithms_fp_base_algorithm
    `uvm_object_utils(amiq_dsp_algorithms_fp_base_algorithm)

    /* Constructor for amiq_dsp_algorithms_fp_base_algorithm
     * @param name   : instance name for amiq_dsp_algorithms_fp_base_algorithm object
     */
    function new(string name = "amiq_dsp_algorithms_fp_base_algorithm");
        super.new(name);
    endfunction

    /* Multiply two fixed point numbers, the result will be saturated
     * @param number1 : it stores the first number to be multiplied
     * @param number2 : it stores the second number to be multiplied
     * @return the result of multiplication between two numbers or 0 if the result should be saturated
     */
    virtual function bit [`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] multiplication(bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] number1, bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1 :0] number2);
        // Verify that the first or second number is higher that 2^`AMIQ_ALGORITHMS_INTEGER_BITS and saturate the result in this case
        if(number1 >= $pow(2, `AMIQ_DSP_ALGORITHMS_FP_INTEGER_BITS) || number2 >= $pow(2, `AMIQ_DSP_ALGORITHMS_FP_INTEGER_BITS)) begin
            multiplication = 0;
        end else begin
            // Multiply the two numbers and store the result into a variable with double number of total bits
            var bit[2 * `AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] result = number1[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 2: 0] * number2[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 2: 0];

            // Verify that the result should be saturated and return zero in this case
            if(result >= $pow(2, `AMIQ_DSP_ALGORITHMS_FP_INTEGER_BITS))
            begin
                multiplication = 0;
            end else begin
                // Return the result of multiplication
                multiplication = result[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 2: 0];

                // Verify if the result should be negative or positive
                if(number1[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1] == 1 || number2[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1] == 1) begin
                    multiplication[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1] = 1;
                end else if((number1[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1] == 1 && number2[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1] == 1) || (number1[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1] == 1 && number2[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1] == 1)) begin
                    multiplication[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1] = 0;
                end
            end
        end
    endfunction

    /* Add two fixed point numbers, the result will be saturated
     * @param number1 : it stores the first number to be added
     * @param number2 : it stores the second number to be added
     * @return the result of addition between two numbers or 0 if the result should be saturated
     */
    virtual function bit [`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1:0] addition(bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] number1, bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] number2);
        // Stores the sign of the addition
        var bit sign = 0;

        // Stores the result of addition
        var bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS: 0] result;

        // Verify that the first or second number is higher that 2^`AMIQ_ALGORITHMS_INTEGER_BITS and saturate the result in this case
        if(number1 >= $pow(2, `AMIQ_DSP_ALGORITHMS_FP_INTEGER_BITS) || number2 >= $pow(2, `AMIQ_DSP_ALGORITHMS_FP_INTEGER_BITS)) begin
            addition = 0;
        end else begin
            /* Decide if the following situation
             * 1. if number1 < 0 and number2 >= 0
             *  1.1 if |number1| > |number2| result = (|number1| - |number2|) * (-1)
             *  1.2 if |number1| < |number2| result = (|number2| - |number1|)
             * 2. if number1 >= 0 and number2 < 0
             *  2.1 if |number1| > |number2| result = (|number1| - |number2|)
             *  2.2 if |number1| < |number2| result = (|number2| - |number1|) * (-1)
             * 3. if number1 >= 0 and number2 >= 0 result = (|number1| + |number2|)
             * 4. if number1 < 0 and number2 < 0 result = (|number1| + |number2|) * (-1)
             */
            if(number1[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1] == 1 && number2[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1] == 0) begin
                if(number1[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 2: 0] > number2[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 2: 0]) begin
                    result = number1[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 2: 0] - number2[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 2: 0];
                    sign = 1;
                end else begin
                    result = number2[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 2: 0] - number1[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 2: 0];
                    sign = 0;
                end
            end else if(number1[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1] == 0 && number2[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1] == 1) begin
                if(number2[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 2: 0] > number1[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 2: 0]) begin
                    result = number2[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 2: 0] - number1[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 2: 0];
                    sign = 1;
                end else begin
                    result = number1[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 2: 0] - number2[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 2: 0];
                    sign = 0;
                end
            end else begin
                // Add the two numbers and store the result into a variable with 21 bits
                result = number1[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 2: 0] + number2[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 2: 0];
                sign = number1[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1];
            end

            // Verify that the result should be saturated and return zero in this case
            if(result >= $pow(2, `AMIQ_DSP_ALGORITHMS_FP_INTEGER_BITS)) begin
                addition = 0;
            end else begin
                // Return the result of addition
                addition = {sign,result[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 2: 0]};
            end
        end
    endfunction


    /* Convert a number to a fixed point number
     * @param number_to_convert : it stores the number to be saturated
     * @return 0 if the number should be saturated or the converted input number if it should not be saturated
     */
    virtual function bit [`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] convert_to_fixed_point(bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] number_to_fix);
        // Check that the number should be saturated or not
        if(number_to_fix >= $pow(2, `AMIQ_DSP_ALGORITHMS_FP_INTEGER_BITS)) begin
            convert_to_fixed_point = 0;
        end else begin
            // Transform number to fixed point using realtobit() function
            convert_to_fixed_point = realtobit(number_to_fix);
        end
    endfunction

    /* Convert a real number into a fixed point number
     * @param real_number_to_bit : it stores the real number to be converted
     * @return fixed point number after conversion
     */
    virtual function bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] realtobit(real real_number_to_bit);
        // Stores the decimal part of the number
        var int realtoint;

        // Stores the decimal part of the number
        var int p;

        // Stores the sign
        var bit sign = 0;

        // Compute the decimal part using rounding operation accordingly
        if(real_number_to_bit >= 0) begin
            realtoint = $floor(real_number_to_bit);
        end else begin
            realtoint = $floor(real_number_to_bit * (-1));

            // Compute the sign of the number
            sign = 1;
        end

        p = realtoint;

        // Calculates the negative number
        if(sign)
            realtoint = realtoint *(-1);

        // Verify if the number should be saturated, if not return de computed number, else return 0
        if(p >= $pow(2, `AMIQ_DSP_ALGORITHMS_FP_INTEGER_BITS)) begin
            realtobit = 0;
        end else begin
            if({p[`AMIQ_DSP_ALGORITHMS_FP_INTEGER_BITS - 1 : 0], fixedpoint(real_number_to_bit - realtoint)} != 0)
            begin
                // Return the number formed as : {sign, decimal_part, fractional_part}
                realtobit = {sign, p[`AMIQ_DSP_ALGORITHMS_FP_INTEGER_BITS - 1 : 0], fixedpoint(real_number_to_bit - realtoint)};
            end else begin
                realtobit = 0;
            end
        end
    endfunction

    /* Convert a fixed point number into a real number
     * @param bit_number_to_real : it stores the fixed point number to be converted
     * @return real number after conversion
     */
    virtual function real bittoreal(bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1:0] bit_number_to_real);
        // Form the real number from decimal part
        bittoreal = bit_number_to_real[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 2 : `AMIQ_DSP_ALGORITHMS_FP_FRACTIONAL_BITS];

        // Add to real number the fractional part
        bittoreal = bittoreal + fixedpoint_inverted(bit_number_to_real[`AMIQ_DSP_ALGORITHMS_FP_FRACTIONAL_BITS - 1 : 0]);

        // If necessary add a negative sign to real number
        if((bit_number_to_real[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1]) && (bit_number_to_real[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 2 : 0] != 0)) begin
            bittoreal = bittoreal * (-1);
        end
    endfunction

    /* Compute the fractional part of a fixed point number from a real number
     * @param real_number_to_fixed_point : fractional part as a real number
     * @return the fractional part as a bit array
     */
    virtual function bit[`AMIQ_DSP_ALGORITHMS_FP_FRACTIONAL_BITS - 1: 0] fixedpoint(real real_number_to_fixed_point);
        // Transform the real number from a negative number to a positive one
        if(real_number_to_fixed_point < 0)
            real_number_to_fixed_point = real_number_to_fixed_point * (-1);

        // Convert from real to binary the fractional part
        for(int unsigned bit_index = 0; bit_index < `AMIQ_DSP_ALGORITHMS_FP_FRACTIONAL_BITS ; bit_index++)
        begin
            // Multiply the decimal fraction with 2 in order to find out the binary digit
            if(real_number_to_fixed_point * 2 >= 1)
            begin
                // Retain the binary digit
                fixedpoint[`AMIQ_DSP_ALGORITHMS_FP_FRACTIONAL_BITS - bit_index - 1] = 1;

                // Compute the next decimal fraction by multiply with 2 and subtracting 1
                real_number_to_fixed_point = real_number_to_fixed_point * 2 - 1;
            end else begin
                // Retain the binary digit
                fixedpoint[`AMIQ_DSP_ALGORITHMS_FP_FRACTIONAL_BITS - bit_index - 1] = 0;

                // Compute the next decimal fraction by multiply with 2
                real_number_to_fixed_point = real_number_to_fixed_point * 2;
            end
        end
    endfunction

    /* Compute the fractional part of a real number from the fractional part of a fixed point number
     * @param fixedpoint_number_to_real : fractional part as an array of bit
     * @return the fractional part as real number
     */
    virtual function real fixedpoint_inverted(bit [`AMIQ_DSP_ALGORITHMS_FP_FRACTIONAL_BITS - 1: 0] fixedpoint_number_to_real);
        // Initialize the number with 0
        fixedpoint_inverted = 0;

        for(int unsigned bit_index = 0; bit_index < `AMIQ_DSP_ALGORITHMS_FP_FRACTIONAL_BITS ; bit_index++)
        begin
            // Compute the power of 2 used to convert from binary to decimal
            var int power = bit_index - `AMIQ_DSP_ALGORITHMS_FP_FRACTIONAL_BITS;

            // Add to the current fractional part the number computed with a power of 2
            fixedpoint_inverted = fixedpoint_inverted + fixedpoint_number_to_real[bit_index] * $pow(2, power);
        end
    endfunction
endclass

`endif
