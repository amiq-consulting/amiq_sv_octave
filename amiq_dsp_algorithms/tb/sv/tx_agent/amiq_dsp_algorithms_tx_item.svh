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
 * MODULE:      amiq_dsp_algorithms_tx_item.svh
 * PROJECT:     amiq_dsp_algorithms
 * Description: Generic transfer item, it contains all data for all DSP algorithms
 *******************************************************************************/

`ifndef __amiq_dsp_algorithms_tx_item
    `define __amiq_dsp_algorithms_tx_item

// Generic transfer item
class amiq_dsp_algorithms_tx_item extends uvm_sequence_item;

    // {{{ For FFT algorithm
    // List of real data samples - it must contain `AMIQ_DSP_ALGORITHMS_NOF_POINTS real data samples
    rand int data_real[];

    // List of imaginary data samples - it must contain `AMIQ_DSP_ALGORITHMS_NOF_POINTS imaginary data samples
    rand int data_imaginary[];

    // Constrain the size of signals used in FFT algorithm
    constraint data_fft_c {
        data_real.size() == `AMIQ_DSP_ALGORITHMS_NOF_POINTS;
        data_imaginary.size() == `AMIQ_DSP_ALGORITHMS_NOF_POINTS;

        foreach(data_real[index]) data_real[index] inside {[0: `AMIQ_DSP_ALGORITHMS_MAX_VALUE]};
        foreach(data_imaginary[index]) data_imaginary[index] inside {[0: `AMIQ_DSP_ALGORITHMS_MAX_VALUE]};
    }
    // }}}


    // {{{ For CONVOLUTION algorithm
    // List of first signal used in convolution algorithm
    rand int data_x[];

    // List of second signal used in convolution algorithm
    rand int data_h[];

    // Constrain the size of signals used in convolution algorithm
    constraint data_convolution_c {
        solve data_x before data_h;
        data_x.size() == `AMIQ_DSP_ALGORITHMS_NOF_POINTS;
        data_h.size() == `AMIQ_DSP_ALGORITHMS_NOF_POINTS;

        foreach(data_x[index]) data_x[index] inside {[0: `AMIQ_DSP_ALGORITHMS_MAX_VALUE]};
        foreach(data_x[index]) data_h[index] inside {[0: `AMIQ_DSP_ALGORITHMS_MAX_VALUE]};
    }
    // }}}

    // {{{ For FIR algorithm
    // List of FIR coefficients
    rand int coef[];

    // List of signal samples
    rand int signal_sample[];

    // Constrain the size of signal and coefficients used in fir algorithm
    constraint data_fir_c {
        solve signal_sample before coef;
        signal_sample.size() == `AMIQ_DSP_ALGORITHMS_NOF_POINTS;
        coef.size() == `AMIQ_DSP_ALGORITHMS_NOF_POINTS;

        foreach(signal_sample[index]) signal_sample[index] inside {[0: `AMIQ_DSP_ALGORITHMS_MAX_VALUE]};
        foreach(coef[index]) coef[index] inside {[0: `AMIQ_DSP_ALGORITHMS_MAX_VALUE]};
    }
    // }}}

    // {{{ For SINUSOID function
    // Indicates that the current item is a sinusoid or not
    rand bit is_a_sinusoid;

    // Indicates the maximum value for the sinusoid
    rand int peak;

    // Indicates the sinusoid step
    rand int unsigned step;

    // Indicates the start value for the sinusoid
    rand int start_value;

    // Constrain the sinusoid
    constraint sinusoid_c {
        solve peak before step;
        // Peak should be between `AMIQ_DSP_ALGORITHMS_MIN_PEAK_VALUE and `AMIQ_DSP_ALGORITHMS_MAX_PEAK_VALUE
        peak inside {[`AMIQ_DSP_ALGORITHMS_MIN_PEAK_VALUE : `AMIQ_DSP_ALGORITHMS_MAX_PEAK_VALUE]};

        // step should be between 0 and `AMIQ_DSP_ALGORITHMS_MAX_STEP_VALUE
        step <= `AMIQ_DSP_ALGORITHMS_MAX_STEP_VALUE;

        // Start value should be between 0 and `AMIQ_DSP_ALGORITHMS_SINUSOID_MAX_START_VALUE
        start_value <= `AMIQ_DSP_ALGORITHMS_SINUSOID_MAX_START_VALUE;
    }

    /* Compute a sinusoid
     * @param peak : the peak of sinusoid
     * @param step : sinusoid's step
     * @param data : it stores the data computed
     * @param start_value : sinusoid start value
     * @return sinusoid data as a list of integers
     */
    function void sinusoid(int peak, int unsigned step, ref int data[], int start_value);
        // Direction of sinusoid
        bit direction = 1;

        // Check that the step is higher than peak
        if (step > peak)
            `uvm_fatal("amiq_dsp_algorithms_tx_item_SINUSOID_ERR", $sformatf("The step value should be higher than peak value. step = %0d, peak = %0d", step, peak))

        // Initialize the first value of data with start value
        data[0] = start_value;

        // Compute the rest of data elements
        for (int i = 1; i < data.size(); i++) begin
            if (direction) begin
                // If the direction is 1, to the next item will be added the step as long as the sum will be smaller than peak
                if ((data[i - 1] + step) <= peak) begin
                    data[i] = data[i - 1] + step;
                end else begin
                    data[i] = peak - (data[i - 1] + step - peak);

                    // Change direction because it reaches the peak
                    direction = !direction;
                end
            end else begin
                // If the direction is 0, to the next item will be decreased with step as long as the sum will be higher than the smallest value
                if ((data[i - 1] - step) >= (0 - peak)) begin
                    data[i] = data[i - 1] - step;
                end else begin
                    data[i] = (0 - peak) + (data[i - 1] - step + peak);

                    // Change direction because it reaches the smallest value
                    direction = !direction;
                end
            end
        end
    endfunction

    // Overwriting the post_randomize method for sinusoid item
    function void post_randomize();
        // It stores the computed sinusoid data
        int data[];

        if (is_a_sinusoid) begin
            // It the item is a sinusoid compute the data and truncated it
            data = new[`AMIQ_DSP_ALGORITHMS_NOF_POINTS];
            sinusoid(peak, step , data,  start_value);
        end
    endfunction
    // }}}

    // Factory registration of amiq_dsp_algorithms_tx_item
    `uvm_object_utils_begin(amiq_dsp_algorithms_tx_item)
        `uvm_field_array_int(data_real, UVM_DEFAULT)
        `uvm_field_array_int(data_imaginary, UVM_DEFAULT)
        `uvm_field_int(is_a_sinusoid, UVM_DEFAULT)
        `uvm_field_int(peak, UVM_DEFAULT)
        `uvm_field_int(step, UVM_DEFAULT)
        `uvm_field_int(start_value, UVM_DEFAULT)
        `uvm_field_array_int(data_x, UVM_DEFAULT)
        `uvm_field_array_int(data_h, UVM_DEFAULT)
        `uvm_field_array_int(signal_sample, UVM_DEFAULT)
        `uvm_field_array_int(coef, UVM_DEFAULT)
    `uvm_object_utils_end

    /* Constructor for amiq_dsp_algorithms_tx_item objects
     * @param name : instance name of amiq_dsp_algorithms_tx_item object
     */
    function new(string name="amiq_dsp_algorithms_tx_item");
        super.new(name);
    endfunction

    /* Overwriting of copy method
     * @return a copy of the calling transaction
     */
    function amiq_dsp_algorithms_tx_item copy();
        // Declaration of a new item
        amiq_dsp_algorithms_tx_item dummy;

        // Form the new item with values from the current item
        $cast(dummy, this.clone());

        // Return the new item
        return dummy;
    endfunction
endclass

`endif
