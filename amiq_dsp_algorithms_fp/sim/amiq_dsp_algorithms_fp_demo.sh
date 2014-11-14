#!/bin/bash
#########################################################################################
# (C) Copyright 2014 AMIQ Consulting
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# NAME:      amiq_dsp_algorithms_fp_demo.sh
# PROJECT:   amiq_dsp_algorithms_fp
# 
# Description:  Script example to compile and run simulation with different simulators
# Usage:
#     -sim[ulator] { irun | vlog } : sets the desired simulator to compile and run simulations
#                                         valid values: - irun : used to compile and run simulations with irun simulator
#                                                       - vlog : used to compile with vlog simulator and run simulations with vsim simulator
#     -t[est] <name>  : sets the desired test
#     -s[eed] <value> : sets the simulation seed
#     -opt {yes | no} : run with optimizations or not
#     -gui {yes | no} : open the user interface
#     -h[elp]         : display the usage for the current script
#     -clean          : clean current directory
# Example of using : ./amiq_dsp_algorithms_fp_demo.sh -t amiq_dsp_algorithms_fp_simple_test -s 1 -sim irun -opt no -gui yes
##########################################################################################

##########################################################################################
#  Setting the variables
##########################################################################################

# Setting the SCRIPT_DIR variable used to find out where the script is stored
SCRIPT_DIR=`dirname $0`
export SCRIPT_DIR=`cd ${SCRIPT_DIR}&& pwd`

# Setting the PROJ_HOME variable used to find out where the current project is stored
export PROJ_HOME=`cd ${SCRIPT_DIR}/../ && pwd`

# Set variables with default value
simulator=""
UVM_HOME=""
test_file="amiq_dsp_algorithms_fp_base_test"
sv_seed=1
top_file=amiq_dsp_algorithms_fp_tb_top

OPT="no"
EXTRA=""
UI="no"
GUI=""


##########################################################################################
#  Methods
##########################################################################################

#  Clean current directory
clean() {
    rm \
        -rf \
        ${SCRIPT_DIR}/INCA_* \
        ${SCRIPT_DIR}/cov_work \
        ${SCRIPT_DIR}/DVEfiles \
        ${SCRIPT_DIR}/csrc \
        ${SCRIPT_DIR}/work \
        ${SCRIPT_DIR}/octave-core \
        ${SCRIPT_DIR}/irun.key \
        ${SCRIPT_DIR}/waves.shm \
        ${SCRIPT_DIR}/simvision*.diag \
        ${SCRIPT_DIR}/*simvision \
        ${SCRIPT_DIR}/*log \
        ${SCRIPT_DIR}/*.so \
        ${SCRIPT_DIR}/*.o \
        ${SCRIPT_DIR}/*.err \
        ${SCRIPT_DIR}/simv* \
        ${SCRIPT_DIR}/dpi_types.h \
        ${SCRIPT_DIR}/*.wlf \
        ${SCRIPT_DIR}/transcript \
        ${SCRIPT_DIR}/vc_hdrs.h \
        ${SCRIPT_DIR}/*.vpd \
        ${SCRIPT_DIR}/*.key \
        ${SCRIPT_DIR}/*.date \
        ${SCRIPT_DIR}/.simvision \
        ${SCRIPT_DIR}/*uvm*
        
exit
}


# Display the usage parameters
help() {
    echo "Usage:  amiq_dsp_algorithms_fp_demo.sh [-t[est] <name>]"
    echo "                                       [-s[eed] <value>]"
    echo "                                       [-opt[imization] { no | yes} ]"
    echo "                                       [-gui            { no | yes} ]"
    echo "                                        -sim[ulator]    { irun | vlog }"
    echo ""
    echo "        amiq_dsp_algorithms_fp_demo.sh  -h[elp]"
    echo ""
    echo "        amiq_dsp_algorithms_fp_demo.sh  -clean"
    
exit
}

# Compile and run with irun simulator
irun_simulation() {

   # Compile and run using libcpp-oct.so
   irun \
       -64bit \
       -dpi \
       -I${PROJ_HOME}/c/ \
       +incdir+${PROJ_HOME}/tb \
       +incdir+${PROJ_HOME}/tb/sv \
       +incdir+${PROJ_HOME}/tb/sv/algorithms \
       +incdir+${PROJ_HOME}/tb/sv/tx_agent \
       +incdir+${PROJ_HOME}/tb/tc \
       +incdir+${PROJ_HOME}/tb/top \
       -sysc \
       -g \
       ${PROJ_HOME}/c/*.cpp \
       -sv \
       -uvm \
       ${PROJ_HOME}/tb/sv/amiq_dsp_algorithms_fp_common_pkg.sv \
       ${PROJ_HOME}/tb/sv/tx_agent/amiq_dsp_algorithms_fp_tx_pkg.sv \
       ${PROJ_HOME}/tb/sv/algorithms/amiq_dsp_algorithms_fp_pkg.sv \
       ${PROJ_HOME}/tb/sv/amiq_dsp_algorithms_fp_env_pkg.sv \
       ${PROJ_HOME}/tb/tc/amiq_dsp_algorithms_fp_test_pkg.sv \
       ${PROJ_HOME}/tb/top/${top_file}.sv \
       +UVM_NO_RELNOTES \
       +define+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR \
       +UVM_VERBOSITY=UVM_LOW \
       +UVM_TESTNAME=${test_file} \
       -message \
       -coverage all \
       -covoverwrite \
       -timescale 100ps/1ps \
       -svseed ${sv_seed} \
       -top ${top_file} \
       ${EXTRA} \
       ${GUI}
}

# Compile with vlog simulator and run with vsim simulator
questa_simulation() {

    #Remove the old library
    rm -rf work

    #Create the working library
    vlib work

    #Compile design files
    vlog -sv \
         -mfcu \
         -dpiheader dpi_types.h \
         +incdir+${UVM_HOME}/../verilog_src/uvm-1.1/src \
         +incdir+${UVM_HOME}/uvm_pkg \
         +incdir+${UVM_HOME}/questa_uvm_pkg \
         +incdir+${UVM_HOME} \
         +incdir+${PROJ_HOME}/tb \
         +incdir+${PROJ_HOME}/tb/sv \
         +incdir+${PROJ_HOME}/tb/sv/algorithms \
         +incdir+${PROJ_HOME}/tb/sv/tx_agent \
         +incdir+${PROJ_HOME}/tb/tc \
         +incdir+${PROJ_HOME}/tb/top \
         ${PROJ_HOME}/tb/sv/amiq_dsp_algorithms_fp_common_pkg.sv \
         ${PROJ_HOME}/tb/sv/tx_agent/amiq_dsp_algorithms_fp_tx_pkg.sv \
         ${PROJ_HOME}/tb/sv/algorithms/amiq_dsp_algorithms_fp_pkg.sv \
         ${PROJ_HOME}/tb/sv/amiq_dsp_algorithms_fp_env_pkg.sv \
         ${PROJ_HOME}/tb/tc/amiq_dsp_algorithms_fp_test_pkg.sv \
         ${PROJ_HOME}/tb/top/${top_file}.sv \
         ${EXTRA}

              

    sccom \
       -64 \
       -DSC_INCLUDE_DYNAMIC_PROCESSES \
       -DQUESTA \
       -work work \
       -I${UVM_HOME}/../include/systemc \
       -I${PROJ_HOME}/c \
        ${PROJ_HOME}/c/*.cpp \


    sccom \
       -64 \
       -link \
       -DSC_INCLUDE_DYNAMIC_PROCESSES \
       -lib work

    #Load and run simulation
    vsim \
        ${EXTRA} \
        ${top_file} \
        -lib work \
        -sv_lib ${SCRIPT_DIR}/work/_sc/linux_x86_64_gcc-4.5.0/systemc \
        -sv_seed ${sv_seed} \
        +UVM_TESTNAME=${test_file} \
        ${GUI} \
        -do "set SolveArrayResizeMax 0;run -all"
}


# Compile and run with the proper simulator
start_simulation() {
    if [ ${simulator} == irun ]
        then
            UVM_HOME=`ncroot`/tools/uvm
            
            if [ ${OPT} == no ]
            then
                EXTRA="-linedebug -access +rwc +define+SIM_IRUN_NO_OPT"
            else
                EXTRA="+define+SIM_IRUN_OPT"
            fi
            
            if [ ${UI} == no ]
            then
                GUI="-exit"
            else
                GUI="-gui"
            fi
            
            irun_simulation
            
        elif [ ${simulator} == vlog ]
        then
            UVM_HOME=${MTI_HOME}/uvm-1.1d
            
            if [ ${OPT} == no ]
            then
                EXTRA="+define+SIM_QUESTA_NO_OPT -novopt"
            else
                EXTRA="+define+SIM_QUESTA_OPT"
            fi
            
            if [ ${UI} == no ]
            then
                GUI="-c "
            else
                GUI=""
            fi
            
            questa_simulation
    fi
}

##########################################################################################
#  Extract options
##########################################################################################

while [ $# -gt 0 ]; do
   case `echo $1 | tr "[A-Z]" "[a-z]"` in
      -h|-help)
                 help
                 ;;
      -sim|-simulator)
                 simulator=$2
                 ;;
      -s|-seed)
                 sv_seed=$2
                 ;;
      -t|-test)
                 test_file=$2
                 ;;
      -clean)
                 clean
                 ;;
      -opt)
                 OPT=$2
                 ;;
      -gui)
                 UI=$2
    esac
    shift
done

start_simulation
