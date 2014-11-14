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
 * NAME:         amiq_dsp_algorithms_fp_defines_c.h
 * PROJECT:      amiq_dsp_algorithms_fp
 * Description:  Defines used in C, C++ functions
 *******************************************************************************/

#ifndef __amiq_dsp_algorithms_fp_defines_c
#define __amiq_dsp_algorithms_fp_defines_c

// Define PI value
#ifndef AMIQ_DSP_ALGORITHMS_FP_PI_VALUE
#define AMIQ_DSP_ALGORITHMS_FP_PI_VALUE 3.1415926535898
#endif

// Define the number of bits of decimal part for fixed point numbers
#ifndef AMIQ_DSP_ALGORITHMS_FP_INTEGER_BITS
#define AMIQ_DSP_ALGORITHMS_FP_INTEGER_BITS 10
#endif

// Define the number of bits of fractional part for fixed point numbers
#ifndef AMIQ_DSP_ALGORITHMS_FP_FRACTIONAL_BITS
#define AMIQ_DSP_ALGORITHMS_FP_FRACTIONAL_BITS 5
#endif

// Define number of points in which the function is defined
#ifndef AMIQ_DSP_ALGORITHMS_FP_NOF_POINTS
#define AMIQ_DSP_ALGORITHMS_FP_NOF_POINTS 256
#endif

#endif
