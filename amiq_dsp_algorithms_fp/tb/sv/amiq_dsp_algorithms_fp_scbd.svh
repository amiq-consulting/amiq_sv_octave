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
 * MODULE:       amiq_dsp_algorithms_fp_scbd.svh
 * PROJECT:      amiq_dsp_algorithms_fp
 *
 * Description:  Scoreboard used to compare the results from SystemVerilog with the ones from SystemC
 *******************************************************************************/

`ifndef __amiq_dsp_algorithms_fp_scbd
    `define __amiq_dsp_algorithms_fp_scbd

// Define tx driver's analysis import class
`uvm_analysis_imp_decl(_tx_driver)

// Scoreboard used to compare the results from SystemVerilog with the ones from SystemC
class amiq_dsp_algorithms_fp_scbd extends uvm_component;
    // Factory registration of amiq_dsp_algorithms_fp_scbd
    `uvm_component_utils(amiq_dsp_algorithms_fp_scbd)

    // Analysis port for getting current transfer from the tx driver
    uvm_analysis_imp_tx_driver  #(amiq_dsp_algorithms_fp_item, amiq_dsp_algorithms_fp_scbd) tx_ap_driver;

    // FFT algorithm object
    amiq_dsp_algorithms_fp_fft_algorithm fft_algorithm;

    // DCT algorithm object
    amiq_dsp_algorithms_fp_dct_algorithm dct_algorithm;

    // Convolution algorithm object
    amiq_dsp_algorithms_fp_conv_algorithm conv_algorithm;

    // FIR algorithm object
    amiq_dsp_algorithms_fp_fir_algorithm fir_algorithm;

    /* Constructor for amiq_dsp_algorithms_fp_utils
     * @param name   : instance name for amiq_dsp_algorithms_fp_utils object
     * @param parent : hierarchical parent for amiq_dsp_algorithms_fp_utils
     */
    function new(string name = "amiq_dsp_algorithms_fp", uvm_component parent);
        super.new(name, parent);

        // Creates and initialize tx_ap_driver port
        tx_ap_driver  = new("scbd_tx_ap_driver",  this);
    endfunction

    /* Build phase method used to instantiate components
     * @param phase : the phase scheduled for build_phase method
     */
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Create and instantiate the fft algorithm object
        fft_algorithm = amiq_dsp_algorithms_fp_fft_algorithm::type_id::create("fft_algorithm_object", this);

        // Create and instantiate the dct algorithm object
        dct_algorithm = amiq_dsp_algorithms_fp_dct_algorithm::type_id::create("dct_algorithm_object", this);

        // Create and instantiate the convolution algorithm object
        conv_algorithm = amiq_dsp_algorithms_fp_conv_algorithm::type_id::create("conv_algorithm_object", this);

        // Create and instantiate the fir algorithm object
        fir_algorithm = amiq_dsp_algorithms_fp_fir_algorithm::type_id::create("fir_algorithm_object", this);

        // configure the number of function for fft algorithm object
        set_config_int("*fft_algorithm_object", "nof_functions", 4);
    endfunction

    /* Overwrite the input access port write function
     * @param trans : input transfer to compute the operations on
     */
    virtual function void write_tx_driver (amiq_dsp_algorithms_fp_item trans);
        `uvm_info("AMIQ_DSP_ALGORITHMS_FP_SCBD", $psprintf("[FROM_TX_AGT] Scoreboard received an item from driver to analyze: %s\n", trans.sprint()), UVM_HIGH)

        // Start to compute the FFT algorithm
        compute_fft_function(trans);

        // Start to compute the Convolution algorithm
        compute_convolution_function(trans);

        // Start to compute the DCT algorithm
        compute_dct_function(trans);

        // Start to compute the FIR algorithm
        compute_fir_function(trans);
    endfunction

    /* Compute FFT algorithm in System Verilog and SystemC
     * @param trans : transfer used to compute FFT algorithm on
     */
    function void compute_fft_function(amiq_dsp_algorithms_fp_item trans);
        // Real part of results after computing FFT algorithm using SystemC using fixed-point numbers
        var bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] fp_sc_data_real[];

        // Imaginary part of results after computing FFT algorithm using SystemC using fixed-point numbers
        var bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] fp_sc_data_imaginary[];

        // Real part of results after computing FFT algorithm using System Verilog using fixed-point numbers
        var bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] fp_sv_data_real[];

        // Imaginary part of results after computing FFT algorithm using System Verilog using fixed-point numbers
        var bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] fp_sv_data_imaginary[];

        // Create arrays for FFT algorithm
        fp_sc_data_real = new[`AMIQ_DSP_ALGORITHMS_FP_NOF_POINTS];
        fp_sc_data_imaginary = new[`AMIQ_DSP_ALGORITHMS_FP_NOF_POINTS];

        // Compute FFT algorithm in SystemC using fixed point numbers
        compute_fft_fp(trans.data_real, trans.data_imaginary, fp_sc_data_real, fp_sc_data_imaginary);

        // Compute FFT algorithm in SystemVerilog using fixed point numbers
        fft_algorithm.fft_algorithm_fp(trans.data_real, trans.data_imaginary, fp_sv_data_real, fp_sv_data_imaginary);

        // SV - SC fixed point
        check_fp_results(fp_sv_data_real, fp_sc_data_real, $sformatf("%s_REAL_FP", fft_algorithm.algorithm_name.name()));
        check_fp_results(fp_sv_data_imaginary, fp_sc_data_imaginary, $sformatf("%s_IMAGINARY_FP", fft_algorithm.algorithm_name.name()));
    endfunction

    /* Compute Convolution algorithm in System Verilog and SystemC
     * @param trans : transfer used to compute Convolution algorithm on
     */
    function void compute_convolution_function(amiq_dsp_algorithms_fp_item trans);
        // Results after computing Convolution algorithm in SystemC using fixed point numbers
        var bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] fp_sc_conv_results[];

        // Results after computing Convolution algorithm in System Verilog using fixed point numbers
        var bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] fp_sv_conv_results[];

        // Create arrays for Convolution algorithm
        fp_sc_conv_results = new[2 * `AMIQ_DSP_ALGORITHMS_FP_NOF_POINTS - 1];

        // Compute Convolution algorithm in SystemC using fixed point numbers
        compute_conv_fp(trans.data_x, trans.data_h, trans.data_x.size(), trans.data_h.size(), fp_sc_conv_results);

        // Compute Convolution algorithm in System Verilog using fixed point numbers
        conv_algorithm.linear_convolution_fp(trans.data_x, trans.data_h, fp_sv_conv_results);

        // SV- SC fixed point
        check_fp_results(fp_sv_conv_results, fp_sc_conv_results, $sformatf("%s_FP", conv_algorithm.algorithm_name.name()));
    endfunction

    /* Compute DCT algorithm in System Verilog and SystemC
     * @param trans : transfer used to compute DCT algorithm on
     */
    function void compute_dct_function(amiq_dsp_algorithms_fp_item trans);
        // Results after computing DCT algorithm in SystemC using fixed point numbers
        var bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] fp_sc_dct_results[];

        // Results after computing DCT algorithm in System Verilog using fixed point numbers
        var bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] fp_sv_dct_results[];

        // Create arrays for DCT algorithm
        fp_sc_dct_results = new[`AMIQ_DSP_ALGORITHMS_FP_NOF_POINTS];

        // Compute DCT algorithm in SystemC using fixed point data type
        compute_dct_fp(trans.data_real,  trans.data_real.size(), fp_sc_dct_results);

        // Compute DCT algorithm in System Verilog using fixed point data type
        dct_algorithm.dct_algorithm_fp(trans.data_real, trans.data_real.size(), fp_sv_dct_results);

        // SV- SC fixed point
        check_fp_results(fp_sv_dct_results, fp_sc_dct_results, $sformatf("%s_FP", dct_algorithm.algorithm_name.name()));
    endfunction

    /* Compute FIR algorithm in System Verilog and SystemC
     * @param trans : transfer used to compute FIR algorithm on
     */
    function void compute_fir_function(amiq_dsp_algorithms_fp_item trans);
        // Results after computing FIR algorithm in SystemC using fixed point numbers
        var bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] fp_sc_fir_results[];

        // Results after computing FIR algorithm in System Verilog using fixed point numbers
        var bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] fp_sv_fir_results[];

        // Create arrays for FIR algorithm
        fp_sc_fir_results = new[`AMIQ_DSP_ALGORITHMS_FP_NOF_POINTS];

        // Compute FIR algorithm in SystemC using fixed point data type
        compute_fir_fp(trans.signal_sample, trans.coef, trans.signal_sample.size(), trans.coef.size(), fp_sc_fir_results);

        // Compute FIR algorithm in System Verilog using fixed point data type
        fir_algorithm.fir_algorithm_fp(trans.signal_sample, trans.coef, trans.signal_sample.size(), trans.coef.size(), fp_sv_fir_results);

        // SV- SC fixed point
        check_fp_results(fp_sv_fir_results, fp_sc_fir_results, $sformatf("%s_FP", fir_algorithm.algorithm_name.name()));
    endfunction

    /* Transform negative numbers from 2's complement to Sign-and-magnitude representation
     * @param data_out: contains the list of elements to be transformed
     */
    function void transform_negative_numbers(ref bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] data_out[]);
        // Transform each element from current list
        foreach(data_out[index])
        begin
            // Check that the element is negative
            if(data_out[index][`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1] == 1)
            begin
                // Negate all bits
                data_out[index] = ~data_out[index];
                // Add on 1
                data_out[index] = data_out[index] + 1;
                // Put 1 on most significative bit
                data_out[index][`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1] = 1;
            end
        end
    endfunction

    /* Print the computed results from System Verilog and SystemC
     * @param algorithm : stores the name of the current algorithm
     * @param out_sv_data : list of results computed in System Verilog
     * @param out_sc_data : list of results computed in SystemC
     * @param array_size : stores the size for both arrays
     */
    function void print_fp_values(string algorithm, bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] out_sv_data[], bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] out_sc_data[], int array_size);
        for(int unsigned index = 0; index < array_size; index ++)
        begin
            `uvm_info("AMIQ_DSP_ALGORITHMS_FP_SCBD", $psprintf("[%s] sv_output_data[%0d] = %0d", algorithm, index, out_sv_data[index]), UVM_HIGH)
            `uvm_info("AMIQ_DSP_ALGORITHMS_FP_SCBD", $psprintf("[%s] sc_output_data[%0d] = %0d", algorithm, index,  out_sc_data[index]), UVM_HIGH)
        end
    endfunction

    /* Check the results computed in System Verilog with the ones computed in SystemC using fixed point data type
     * @param sv_data_out : list of results computed in System Verilog
     * @param sc_data_out : list of results computed in SystemC
     * @param algorithm : stores the name of the current algorithm
     */
    function void check_fp_results(bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] sv_data_out[], bit[`AMIQ_DSP_ALGORITHMS_FP_NOF_BITS - 1: 0] sc_data_out[], string algorithm);
        // In SystemC the negative numbers are represented in 2's complement and transform them accordingly
        transform_negative_numbers(sc_data_out);

        // Print computed values
        print_fp_values(algorithm, sv_data_out, sc_data_out, sv_data_out.size());

        // Check that the results list is not empty
        AMIQ_DSP_ALGORITHMS_FP_SCBD_ALG_SIZE_ZERO_ERR : assert(sv_data_out.size() > 0) else
            `uvm_error("AMIQ_DSP_ALGORITHMS_FP_SCBD_ALG_SIZE_ZERO_ERR", $sformatf("[%s] Result size should be > 0", algorithm))

        // Check that both list have the same number of elements
        AMIQ_DSP_ALGORITHMS_FP_SCBD_ALG_SIZE_ERR: assert (sv_data_out.size() == sc_data_out.size()) else
            `uvm_error("AMIQ_DSP_ALGORITHMS_FP_SCBD_ALG_SIZE_ERR", $psprintf("[%s] Found mismatch for size of SV data (%0d) and OCT/SystemC data(%0d)", algorithm, sv_data_out.size(), sc_data_out.size()))

        // Check that all elements matches
        for(int unsigned data_index = 0; data_index < sv_data_out.size(); data_index++)
        begin
            AMIQ_DSP_ALGORITHMS_FP_SCBD_ALG_DATA_ERR: assert (fir_algorithm.bittoreal(sv_data_out[data_index]) == fir_algorithm.bittoreal(sc_data_out[data_index])) else
                `uvm_error("AMIQ_DSP_ALGORITHMS_FP_SCBD_ALG_DATA_ERR", $psprintf("[%s] Found mismatch for data for index %0d. Received from SV %0b, received from SystemC %0b", algorithm, data_index, sv_data_out[data_index], sc_data_out[data_index]))
        end
    endfunction
endclass

`endif
