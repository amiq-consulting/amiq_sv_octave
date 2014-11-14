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
 * MODULE:      amiq_dsp_algorithms_scbd.svh
 * PROJECT:     amiq_dsp_algorithms
 * Description: Scoreboard used to compare the results from SystemVerilog with the ones from Octave
 *******************************************************************************/

`ifndef __amiq_dsp_algorithms_scbd
    `define __amiq_dsp_algorithms_scbd

// Define tx driver's analysis import class
`uvm_analysis_imp_decl(_tx_driver)

// Scoreboard used to compare the results from SystemVerilog with the ones from Octave
class amiq_dsp_algorithms_scbd extends uvm_component;
    // Factory registration of amiq_dsp_algorithms_scbd
    `uvm_component_utils(amiq_dsp_algorithms_scbd)

    // Analysis port for getting current transfer from the tx driver
    uvm_analysis_imp_tx_driver  #(amiq_dsp_algorithms_tx_item, amiq_dsp_algorithms_scbd) tx_ap_driver;

    // Tolerance used to compare two real numbers
    real tolerance;

    // FFT algorithm object
    amiq_dsp_algorithms_fft_algorithm fft_algorithm;

    // DCT algorithm object
    amiq_dsp_algorithms_dct_algorithm dct_algorithm;

    // Convolution algorithm object
    amiq_dsp_algorithms_conv_algorithm conv_algorithm;

    // FIR algorithm object
    amiq_dsp_algorithms_fir_algorithm fir_algorithm;


    /* Constructor for amiq_dsp_algorithms_utils
     * @param name   : instance name for amiq_dsp_algorithms_utils object
     * @param parent : hierarchical parent for amiq_dsp_algorithms_utils
     */
    function new(string name = "amiq_dsp_algorithms", uvm_component parent);
        super.new(name, parent);

        // Creates and initialize tx_ap_driver port
        tx_ap_driver  = new("scbd_tx_ap_driver",  this);

        // Initialize tolerance
        tolerance = 0.001;
    endfunction

    /* Build phase method used to instantiate components
     * @param phase : the phase scheduled for build_phase method
     */
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Create and instantiate the fft algorithm object
        fft_algorithm = amiq_dsp_algorithms_fft_algorithm::type_id::create("fft_algorithm_object", this);

        // Create and instantiate the dct algorithm object
        dct_algorithm = amiq_dsp_algorithms_dct_algorithm::type_id::create("dct_algorithm_object", this);

        // Create and instantiate the convolution algorithm object
        conv_algorithm = amiq_dsp_algorithms_conv_algorithm::type_id::create("conv_algorithm_object", this);

        // Create and instantiate the fir algorithm object
        fir_algorithm = amiq_dsp_algorithms_fir_algorithm::type_id::create("fir_algorithm_object", this);
    endfunction

    /* Initialize Octave interpreter
     * @param phase : the phase scheduled for run_phase method
     */
    virtual task run_phase(uvm_phase phase);
        `uvm_info("AMIQ_DSP_ALGORITHMS_SCBD", "Started scoreboard", UVM_HIGH);

        // Initialize Octave interpreter
        initialize_octave();
    endtask

    /* Round a real number to 4 digits for the fractional part
     * @param value_to_round : the value to be rounded
     * @return the value rounded to 4 digits for the fractional part
     */
    function real round_value_to_4_digits(real value_to_round);
        return round($pow(10, 4) * value_to_round) / $pow(10, 4);
    endfunction
    
    /* Print the computed results from System Verilog and Octave
     * @param algorithm : stores the name of the current algorithm
     * @param out_sv_data_real : list of results computed in System Verilog
     * @param out_oct_sc_data_real : list of results computed in Octave 
     * @param array_size : stores the size for both arrays
     */
    function void print_received_values_real(string algorithm, real out_sv_data_real[], real out_oct_sc_data_real[], int array_size);
        for(int unsigned index = 0; index < array_size; index ++) begin
            `uvm_info("AMIQ_DSP_ALGORITHMS_SCBD", $psprintf("[%s] sv_output_data[%0d] = %0f", algorithm, index, out_sv_data_real[index]), UVM_HIGH)
            `uvm_info("AMIQ_DSP_ALGORITHMS_SCBD", $psprintf("[%s] oct/sc_output_data[%0d] = %0f", algorithm, index,  out_oct_sc_data_real[index]), UVM_HIGH)
        end
    endfunction

    /* Print the computed results from System Verilog and Octave
     * @param algorithm : stores the name of the current algorithm
     * @param out_sv_data : list of results computed in System Verilog
     * @param out_oct_sc_data : list of results computed in Octave
     * @param array_size : stores the size for both arrays
     */
    function void print_received_values_int(string algorithm, int out_sv_data[], int out_oct_sc_data[], int array_size);
        for(int unsigned index = 0; index < array_size; index ++) begin
            `uvm_info("AMIQ_DSP_ALGORITHMS_SCBD", $psprintf("[%s] sv_output_data[%0d] = %0d", algorithm, index, out_sv_data[index]), UVM_HIGH)
            `uvm_info("AMIQ_DSP_ALGORITHMS_SCBD", $psprintf("[%s] oct/sc_output_data[%0d] = %0d", algorithm, index,  out_oct_sc_data[index]), UVM_HIGH)
        end
    endfunction

    /* Overwrite the input access port write function
     * @param trans : input transfer to compute the operations on
     */
    virtual function void write_tx_driver (amiq_dsp_algorithms_tx_item trans);
        `uvm_info("AMIQ_DSP_ALGORITHMS_SCBD", $psprintf("[FROM_TX_AGT] Scoreboard received an item from driver to analyze: %s\n", trans.sprint()), UVM_HIGH)

        // Start to compute the FFT algorithm
        compute_fft_function(trans);

        // Start to compute the Convolution algorithm
        compute_convolution_function(trans);

        // Start to compute the DCT algorithm
        compute_dct_function(trans);

        // Start to compute the FIR algorithm
        compute_fir_function(trans);
    endfunction

    /* Compute FFT algorithm in System Verilog and Octave
     * @param trans : transfer used to compute FFT algorithm on
     */
    function void compute_fft_function(amiq_dsp_algorithms_tx_item trans);
        // Real part of results after computing FFT algorithm using Octave
        var real oct_data_real[];

        // Imaginary part of results after computing FFT algorithm using Octave
        var real oct_data_imaginary[];

        // Real part of results after computing FFT algorithm using System Verilog
        var real sv_data_real[];

        // Imaginary part of results after computing FFT algorithm using System Verilog
        var real sv_data_imaginary[];

        // Create arrays for FFT algorithm
        oct_data_real = new[`AMIQ_DSP_ALGORITHMS_NOF_POINTS];
        oct_data_imaginary = new[`AMIQ_DSP_ALGORITHMS_NOF_POINTS];

        // Create the results arrays
        sv_data_real = new[`AMIQ_DSP_ALGORITHMS_NOF_POINTS];
        sv_data_imaginary = new[`AMIQ_DSP_ALGORITHMS_NOF_POINTS];

        // Compute FFT algorithm in Octave
        compute_fft(trans.data_real, trans.data_imaginary, oct_data_real, oct_data_imaginary);

        // Compute FFT algorithm in System Verilog
        fft_algorithm.fft_16_16_algorithm(trans.data_real, trans.data_imaginary, sv_data_real, sv_data_imaginary);

        // SV - Octave
        check_sv_oct_results(sv_data_real, oct_data_real, tolerance, $sformatf("%s_REAL_PART", fft_algorithm.algorithm_name.name()));
        check_sv_oct_results(sv_data_imaginary, oct_data_imaginary, tolerance, $sformatf("%s_IMAGINARY_PART", fft_algorithm.algorithm_name.name()));
    endfunction

    /* Compute Convolution algorithm in System Verilog and Octave
     * @param trans : transfer used to compute Convolution algorithm on
     */
    function void compute_convolution_function(amiq_dsp_algorithms_tx_item trans);
        // Results after computing Convolution algorithm in Octave
        var int oct_conv_results[];

        // Results after computing Convolution algorithm in System Verilog
        var int sv_conv_results[];

        // Create arrays for Convolution algorithm
        oct_conv_results = new[2* `AMIQ_DSP_ALGORITHMS_NOF_POINTS - 1];

        // Compute Convolution algorithm in Octave
        compute_conv(trans.data_x, trans.data_h, trans.data_x.size(), trans.data_h.size(), oct_conv_results);

        // Compute Convolution algorithm in System Verilog
        conv_algorithm.linear_convolution(trans.data_x, trans.data_h, sv_conv_results);

        // SV - Octave
        check_sv_oct_sc_int_results(sv_conv_results, oct_conv_results, conv_algorithm.algorithm_name.name());
    endfunction

    /* Compute DCT algorithm in System Verilog and Octave
     * @param trans : transfer used to compute DCT algorithm on
     */
    function void compute_dct_function(amiq_dsp_algorithms_tx_item trans);
        // Results after computing DCT algorithm in Octave
        var real oct_dct_results[];

        // Results after computing DCT algorithm in System Verilog
        var real sv_dct_results[];

        // Create arrays for storing the DCT results
        oct_dct_results = new[`AMIQ_DSP_ALGORITHMS_NOF_POINTS];
        sv_dct_results = new[`AMIQ_DSP_ALGORITHMS_NOF_POINTS];

        // Compute DCT algorithm in Octave
        compute_dct(trans.data_real, `AMIQ_DSP_ALGORITHMS_NOF_POINTS, oct_dct_results);

        // Compute DCT algorithm in System Verilog
        dct_algorithm.dct_algorithm(trans.data_real, `AMIQ_DSP_ALGORITHMS_NOF_POINTS, sv_dct_results);

        // SV - Octave
        check_sv_oct_results(sv_dct_results, oct_dct_results, tolerance, dct_algorithm.algorithm_name.name());
    endfunction

    /* Compute FIR algorithm in System Verilog and Octave
     * @param trans : transfer used to compute FIR algorithm on
     */
    function void compute_fir_function(amiq_dsp_algorithms_tx_item trans);
        // Results after computing FIR algorithm in Octave
        var int oct_fir_results[];

        // Results after computing FIR algorithm in System Verilog
        var int sv_fir_results[];

        // Create arrays for FIR algorithm
        oct_fir_results = new[`AMIQ_DSP_ALGORITHMS_NOF_POINTS];
        sv_fir_results = new[`AMIQ_DSP_ALGORITHMS_NOF_POINTS];

        // Compute FIR algorithm in Octave
        compute_fir(trans.signal_sample, trans.coef, `AMIQ_DSP_ALGORITHMS_NOF_POINTS, oct_fir_results);

        // Compute FIR algorithm in System Verilog
        fir_algorithm.fir_algorithm(trans.signal_sample, trans.coef, `AMIQ_DSP_ALGORITHMS_NOF_POINTS, `AMIQ_DSP_ALGORITHMS_NOF_POINTS, sv_fir_results);

        // SV - Octave
        check_sv_oct_sc_int_results(sv_fir_results, oct_fir_results, fir_algorithm.algorithm_name.name());
    endfunction
    
    
    /* Check the results computed in System Verilog with the ones computed in Octave using real type and a tolerance
     * @param out_sv_data_real : list of results computed in System Verilog
     * @param oct_data_out_real : list of results computed in Octave
     * @param tolerance : tolerance with which the elements are compared
     * @param algorithm : stores the name of the current algorithm
     */
    function void check_sv_oct_results(real out_sv_data_real[], real oct_data_out_real[], real tolerance, string algorithm);
        // Stores the difference between two real numbers
        var real real_difference = 0;

        `uvm_info("AMIQ_DSP_ALGORITHMS_SCBD", "Checking results (SV vs Octave).", UVM_HIGH);

        // Check that the results list is not empty
        AMIQ_DSP_ALGORITHMS_SCBD_ALG_SIZE_ZERO_ERR : assert(out_sv_data_real.size() > 0) else
            `uvm_error("AMIQ_DSP_ALGORITHMS_SCBD_ALG_SIZE_ZERO_ERR", $sformatf("[%s] Result size should be > 0", algorithm))

        // Check that both list have the same number of elements
        AMIQ_DSP_ALGORITHMS_SCBD_ALG_SIZE_ERR: assert (out_sv_data_real.size() == oct_data_out_real.size()) else
            `uvm_error("AMIQ_DSP_ALGORITHMS_SCBD_ALG_SIZE_ERR", $psprintf("[%s] Found mismatch for size of SV data (%0d) and Octave data(%0d)", algorithm, out_sv_data_real.size(), oct_data_out_real.size()))

        // Print elements
        print_received_values_real(algorithm, out_sv_data_real, oct_data_out_real, out_sv_data_real.size());

        for(int unsigned index = 0; index < out_sv_data_real.size(); index++) begin
            // Round System Verilog result to 4 digits
            out_sv_data_real[index] = round_value_to_4_digits(out_sv_data_real[index]);

            // Round Octave result to 4 digits
            oct_data_out_real[index] = round_value_to_4_digits(oct_data_out_real[index]);

            // Compute the difference between current element from System Verilog with the one from Octave
            real_difference = out_sv_data_real[index] - oct_data_out_real[index];

            // Round difference to 4 digits
            real_difference = round_value_to_4_digits(real_difference);

            `uvm_info("AMIQ_DSP_ALGORITHMS_SCBD", $psprintf("Difference between SV-Octave for index %0d  = %0f", index, real_difference), UVM_HIGH)

            // Make a positive difference if necessary
            if(real_difference < 0) begin
                real_difference = real_difference * (-1);
            end

            // Check that the difference is smaller than tolerance
            AMIQ_DSP_ALGORITHMS_SCBD_DATA_SV_OCTAVE_ERR: assert (real_difference <= tolerance) else
                `uvm_error("AMIQ_DSP_ALGORITHMS_SCBD_DATA_SV_OCTAVE_ERR", $psprintf("[%s] Found mismatch for data for index %0d. Received from SV %0f, received from Octave %0f", algorithm, index, out_sv_data_real[index], oct_data_out_real[index]))
        end
    endfunction

    /* Check the results computed in System Verilog with the ones computed in Octave using integers type
     * @param sv_data_out : list of results computed in System Verilog
     * @param oct_data_out : list of results computed in Octave 
     * @param algorithm : stores the name of the current algorithm
     */
    function void check_sv_oct_sc_int_results(int sv_data_out[], int oct_data_out[], string algorithm);
        // Print computed values
        print_received_values_int(algorithm, sv_data_out, oct_data_out, sv_data_out.size());

        // Check that the results list is not empty
        AMIQ_DSP_ALGORITHMS_SCBD_ALG_SIZE_ZERO_ERR : assert(sv_data_out.size() > 0) else
            `uvm_error("AMIQ_DSP_ALGORITHMS_SCBD_ALG_SIZE_ZERO_ERR", $sformatf("[%s] Result size should be > 0", algorithm))

        // Check that both list have the same number of elements
        AMIQ_DSP_ALGORITHMS_SCBD_ALG_SIZE_ERR: assert (sv_data_out.size() == oct_data_out.size()) else
            `uvm_error("AMIQ_DSP_ALGORITHMS_SCBD_ALG_SIZE_ERR", $psprintf("[%s] Found mismatch for size of SV data (%0d) and Octave data(%0d)", algorithm, sv_data_out.size(), oct_data_out.size()))

        // Check that all elements matches
        for(int unsigned data_index = 0; data_index < sv_data_out.size(); data_index++) begin
            AMIQ_DSP_ALGORITHMS_SCBD_ALG_DATA_ERR: assert (sv_data_out[data_index] == oct_data_out[data_index]) else
                `uvm_error("AMIQ_DSP_ALGORITHMS_SCBD_ALG_DATA_ERR", $psprintf("[%s] Found mismatch for data for index %0d. Received from SV %0d, received from Octave %0d", algorithm, data_index, sv_data_out[data_index], oct_data_out[data_index]))
        end
    endfunction
endclass

`endif
