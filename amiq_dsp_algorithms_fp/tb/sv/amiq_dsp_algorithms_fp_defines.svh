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
 * MODULE:       amiq_dsp_algorithms_fp_defines.svh
 * PROJECT:      amiq_dsp_algorithms_fp
 *
 * Description:  Defines definitions
 *******************************************************************************/

`ifndef __amiq_dsp_algorithms_fp_defines
    `define __amiq_dsp_algorithms_fp_defines

// Define number of points in which the function is defined
`ifndef AMIQ_DSP_ALGORITHMS_FP_NOF_POINTS
    `define AMIQ_DSP_ALGORITHMS_FP_NOF_POINTS 256
`endif

// Define PI value
`ifndef AMIQ_DSP_ALGORITHMS_FP_PI_VALUE
    `define AMIQ_DSP_ALGORITHMS_FP_PI_VALUE 3.1415926535898
`endif

// Define the number of bits of decimal part for fixed point numbers
`ifndef AMIQ_DSP_ALGORITHMS_FP_INTEGER_BITS
    `define AMIQ_DSP_ALGORITHMS_FP_INTEGER_BITS 10
`endif

// Define the number of bits of fractional part for fixed point numbers
`ifndef AMIQ_DSP_ALGORITHMS_FP_FRACTIONAL_BITS
    `define AMIQ_DSP_ALGORITHMS_FP_FRACTIONAL_BITS 5
`endif

// Define the total number of bits for fixed point numbers
`ifndef AMIQ_DSP_ALGORITHMS_FP_NOF_BITS
    `define AMIQ_DSP_ALGORITHMS_FP_NOF_BITS `AMIQ_DSP_ALGORITHMS_FP_INTEGER_BITS + `AMIQ_DSP_ALGORITHMS_FP_FRACTIONAL_BITS + 1
`endif

// Define maximum value for transfers to be driven into a simulation
`ifndef AMIQ_DSP_ALGORITHMS_FP_MAX_NOF_TRANSFERS
    `define AMIQ_DSP_ALGORITHMS_FP_MAX_NOF_TRANSFERS 100
`endif

`endif
