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
  * MODULE:      amiq_dsp_algorithms_base_algorithm.svh
  * PROJECT:     amiq_dsp_algorithms
  * Description: Base class of algorithms
  *******************************************************************************/

 `ifndef __amiq_dsp_algorithms_base_algorithm
    `define __amiq_dsp_algorithms_base_algorithm

// Base class of algorithms
class amiq_dsp_algorithms_base_algorithm extends uvm_object;

    // Stores the type of the algorithm
    amiq_dsp_algorithms_type algorithm_name;

    // Factory registration for amiq_dsp_algorithms_base_algorithm
    `uvm_object_utils(amiq_dsp_algorithms_base_algorithm)

    /* Constructor for amiq_dsp_algorithms_base_algorithm
     * @param name   : instance name for amiq_dsp_algorithms_base_algorithm object
     */
    function new(string name = "amiq_dsp_algorithms_base_algorithm");
        super.new(name);
    endfunction
endclass

`endif
