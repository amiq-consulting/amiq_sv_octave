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
 * NAME:        amiq_dsp_algorithms_local_octave.h
 * PROJECT:     amiq_dsp_algorithms
 * Description: DPI-C layer
 *******************************************************************************/

#if !defined (octave_octave_h)
#define octave_octave_h 1

#ifdef  __cplusplus
extern "C" {
#endif

/* Initialize the Octave interpreter
 * argc : number of arguments
 * argv : input arguments
 * embedded : embedded option
 */
extern int octave_main(int argc, char **argv, int embedded);

#ifdef  __cplusplus
}
#endif

#endif
