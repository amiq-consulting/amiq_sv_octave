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
 * NAME:        amiq_hello_world.svh
 * PROJECT:     amiq_hello_world
 * Description: Hello world environment
 *******************************************************************************/

`ifndef __amiq_hello_world_env
    `define __amiq_hello_world_env

// Hello world environment
class amiq_hello_world extends uvm_component;

    // Factory registration for amiq_hello_world
    `uvm_component_utils(amiq_hello_world)

    /* Constructor for amiq_hello_world
     * @param name   : instance name for amiq_hello_world object
     * @param parent : hierarchical parent for amiq_hello_world
     */
    function new(string name = "amiq_hello_world", uvm_component parent);
        super.new(name, parent);
    endfunction

    /* Build phase method used to instantiate components
     * @param phase : the phase scheduled for build_phase method
     */
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    /* Initialize Octave interpreter
     * @param phase : the phase scheduled for run_phase method
     */
    virtual task run_phase(uvm_phase phase);
        // Raise an objection to end the hello world example
        phase.raise_objection(this);

        `uvm_info("AMIQ_HELLO_WORLD_ENV", "Started hello world example", UVM_HIGH);

        // Initialize Octave interpreter
        initialize_octave();

        // Start hello world example
        sv_hello_world();

        // Drop an objection to end the hello world example
        phase.drop_objection(this);
    endtask

    // A simple hello world example – SV function
    function void sv_hello_world();
        `uvm_info("AMIQ_HELLO_WORLD", "Hello world from SV file", UVM_NONE);

        // Call hello world from C
        c_hello_world();
    endfunction
endclass

`endif
