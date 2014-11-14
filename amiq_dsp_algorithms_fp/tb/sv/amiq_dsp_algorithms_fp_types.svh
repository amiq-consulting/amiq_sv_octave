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
 * MODULE:       amiq_dsp_algorithms_fp_types.svh
 * PROJECT:      amiq_dsp_algorithms_fp
 *
 * Description:  Definitions of specific types used in algorithms' environment
 *******************************************************************************/

`ifndef __amiq_dsp_algorithms_fp_types
    `define __amiq_dsp_algorithms_fp_types

// Define algorithm type
typedef enum bit [2: 0]{BASE = 0, FFT = 1, DCT = 2, CONVOLUTION = 3, FIR = 4} amiq_dsp_algorithms_fp_type;

`endif
