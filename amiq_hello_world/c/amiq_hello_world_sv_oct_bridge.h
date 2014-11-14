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
 * NAME:         amiq_hello_world_sv_oct_bridge.h
 * PROJECT:      amiq_hello_world
 * Description:  Header file for all C++ and C functions for sv <-> octave bridge
 *******************************************************************************/

#ifndef __amiq_hello_world_sv_oct_bridge
#define __amiq_hello_world_sv_oct_bridge

#include <stdio.h>
#include <iostream>
#include <math.h>
#include <svdpi.h>
#include <err.h>
#include <string.h>
#include <libgen.h>

// Workaround to get access to .m files
#ifndef AMIQ_HELLO_WORLD_FILENAME
#define AMIQ_HELLO_WORLD_FILENAME (strrchr(__FILE__, '/') ? strrchr(__FILE__, '/') + 1 : __FILE__)
#endif

using namespace std;

// Add custom path of .m files to octave path
void initialize_octave_fct();

// Initialize the octave API
void initialize_octave_cpp();

// Hello world example - C++ function
void cpp_hello_world();

extern "C" {
// Wrapper over initialize_octave_cpp. This is called from SV
void initialize_octave();

// Hello world example - C function
void c_hello_world();
}

#endif
