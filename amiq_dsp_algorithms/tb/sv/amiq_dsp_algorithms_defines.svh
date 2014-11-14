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
 * MODULE:      amiq_dsp_algorithms_defines.svh
 * PROJECT:     amiq_dsp_algorithms
 * Description: Defines definitions
 *******************************************************************************/

`ifndef __amiq_dsp_algorithms_defines
    `define __amiq_dsp_algorithms_defines
    
// Define maximum value for transfers to be driven into a simulation
`ifndef AMIQ_DSP_ALGORITHMS_MAX_NOF_TRANSFERS
    `define AMIQ_DSP_ALGORITHMS_MAX_NOF_TRANSFERS 100
`endif
    
    
// Define number of points in which the function is defined
`ifndef AMIQ_DSP_ALGORITHMS_NOF_POINTS
    `define AMIQ_DSP_ALGORITHMS_NOF_POINTS 256
`endif

// Define PI value
`ifndef AMIQ_DSP_ALGORITHMS_PI_VALUE
    `define AMIQ_DSP_ALGORITHMS_PI_VALUE 3.1415926535898
`endif

// Define the maximum value for numbers for algorithms - upper numbers can lead to saturation and strange results will be obtained
`ifndef AMIQ_DSP_ALGORITHMS_MAX_VALUE
    `define AMIQ_DSP_ALGORITHMS_MAX_VALUE 5000
`endif

// Define the minimum peak value used to form a sinusoid
`ifndef AMIQ_DSP_ALGORITHMS_MIN_PEAK_VALUE
    `define AMIQ_DSP_ALGORITHMS_MIN_PEAK_VALUE 5
`endif

// Define the maximum peak value used to form a sinusoid
`ifndef AMIQ_DSP_ALGORITHMS_MAX_PEAK_VALUE
    `define AMIQ_DSP_ALGORITHMS_MAX_PEAK_VALUE 10
`endif

// Define the maximum step value used to form a sinusoid
`ifndef AMIQ_DSP_ALGORITHMS_MAX_STEP_VALUE
    `define AMIQ_DSP_ALGORITHMS_MAX_STEP_VALUE 3
`endif

// Define the maximum start value for sinusoid
`ifndef AMIQ_DSP_ALGORITHMS_SINUSOID_MAX_START_VALUE
    `define AMIQ_DSP_ALGORITHMS_SINUSOID_MAX_START_VALUE 10
`endif

`endif
