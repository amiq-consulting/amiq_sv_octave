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
 * NAME:         amiq_hello_world_c_container.cpp
 * PROJECT:      amiq_hello_world
 * Description:  DPI-C layer
 *******************************************************************************/

#ifndef __amiq_hello_world_c_container
#define __amiq_hello_world_c_container

#include "amiq_hello_world_sv_oct_bridge.h"

extern "C" {

// Wrapper over initialize_octave_cpp. This is called from SV
void initialize_octave() {
	initialize_octave_cpp();
}

// Hello world example - C function
void c_hello_world() {
	printf("[AMIQ_HELLO_WORLD] Hello world from C file\n");

	// Call hello world from C++
	cpp_hello_world();
}
}

#endif
