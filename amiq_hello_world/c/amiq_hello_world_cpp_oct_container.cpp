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
 * NAME:         amiq_hello_world_cpp_oct_container.cpp
 * PROJECT:      amiq_hello_world
 * Description:  C++ layer
 *******************************************************************************/

#ifndef __amiq_hello_world_cpp_oct_container
#define __amiq_hello_world_cpp_oct_container

#include "amiq_hello_world_local_octave.h"
#include <octave/octave.h>
#include <octave/oct.h>
#include <octave/parse.h>

#include "amiq_hello_world_sv_oct_bridge.h"

// Add custom path of .m files to octave path
void initialize_octave_fct() {
	// Will hold the path for m file
	char path[100];

	// Input parameters list for addpath function
	octave_value_list oct_in_list;

	// Get the absolute path for the current file
	strncpy(path, __FILE__,
			strlen(__FILE__) - strlen(AMIQ_HELLO_WORLD_FILENAME));
	path[strlen(__FILE__) - strlen(AMIQ_HELLO_WORLD_FILENAME)] = '\0';

	// Compute the absolute path for all m files
	strcpy(path, strcat(dirname(path), "/octave/"));

	// Add .m path to octave
	oct_in_list(0) = path;
	feval("addpath", oct_in_list, 1);
}

// Initialize the Octave interpreter
void initialize_octave_cpp() {

	// Declare a string vector used to pass arguments to octave_main function
	string_vector argv(2);

	// Set the first argument to "embedded"
	argv(0) = "embedded";

	// Set verbosity to quiet
	argv(1) = "-q";

	// Initialize Octave interpreter
	octave_main(2, argv.c_str_vec(), 1);

	// Add custom path to Octave
	initialize_octave_fct();
}

// Hello world example - C++ function
void cpp_hello_world() {
	cout << "[AMIQ_HELLO_WORLD] Hello world from C++ file" << endl;

	// Input parameters list for octave custom function
	octave_value_list oct_in_list;

	// Call hello world from Octave
	feval("amiq_hello_world", oct_in_list, 1);
}

#endif
