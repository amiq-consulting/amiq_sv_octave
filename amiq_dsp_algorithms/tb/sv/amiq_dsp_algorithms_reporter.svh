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
 * MODULE:      amiq_dsp_algorithms_reporter.svh
 * PROJECT:     amiq_dsp_algorithms
 * Description: Overwrite compose_message from UVM reporter
 *******************************************************************************/

`ifndef __amiq_dsp_algorithms_reporter
    `define __amiq_dsp_algorithms_reporter

// Customize UVM reporter
class amiq_dsp_algorithms_reporter extends uvm_report_server;

    /* Constructs the string to be displayed
     * @param severity : message severity
     * @param name : component name
     * @param id   : report id
     * @param message  : the message to be displayed
     * @param filename : the file where the message should appear
     * @param line     : the line where the message should appear
     */
    virtual function string compose_message(uvm_severity severity,
            string name,
            string id,
            string message,
            string filename,
            int line);

        // Cast the severity in order to show a string
        uvm_severity_type severity_type = uvm_severity_type'(severity);

        // Default display overwrite
        // Example : "UVM_INFO @ 955000 [AMIQ_DSP_ALGORITHMS_SCBD]: [FROM_INPUT] Scoreboard received an item to analyze"
        return $psprintf("%-8s @ %0t [%-7s]: %s",
            severity_type.name(), $time, id, message);
    endfunction
endclass

`endif
