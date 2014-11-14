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
# NAME:      amiq_dsp_algorithms_demo.sh
# PROJECT:   amiq_dsp_algorithms
# 
# Description:  Script example to compile and run simulation with different simulators
# Usage:
#     -sim[ulator] { irun | vlog | vcs} : sets the desired simulator to compile and run simulations
#                                         valid values: - irun : used to compile and run simulations with irun simulator
#                                                       - vlog : used to compile with vlog simulator and run simulations with vsim simulator
#                                                       - vcs  : used to compile and run simulations with vcs simulator
#     -t[est] <name>  : sets the desired test
#     -s[eed] <value> : sets the simulation seed
#     -opt {yes | no} : run with optimizations or not
#     -gui {yes | no} : open the user interface
#     -h[elp]         : display the usage for the current script
#     -clean          : clean current directory
# Example of using : ./amiq_dsp_algorithms_demo.sh -t amiq_dsp_algorithms_simple_test -s random -sim irun -opt no -gui yes
##########################################################################################

##########################################################################################
#  Setting the variables
##########################################################################################

# Setting the SCRIPT_DIR_AMIQ_DSP_ALGORITHMS variable used to find out where the script is stored
SCRIPT_DIR_AMIQ_DSP_ALGORITHMS=`dirname $0`
export SCRIPT_DIR_AMIQ_DSP_ALGORITHMS=`cd ${SCRIPT_DIR_AMIQ_DSP_ALGORITHMS}&& pwd`

# Setting the PROJ_HOME_AMIQ_DSP_ALGORITHMS variable used to find out where the current project is stored
export PROJ_HOME_AMIQ_DSP_ALGORITHMS=`cd ${SCRIPT_DIR_AMIQ_DSP_ALGORITHMS}/../ && pwd`

# Setting the LIB_DIR_AMIQ_DSP_ALGORITHMS variable used to find out where the shared library is stored
export LIB_DIR_AMIQ_DSP_ALGORITHMS=${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/sim

# Set variables with default value
simulator=""
UVM_HOME=""
test_file="amiq_dsp_algorithms_base_test"
sv_seed=1
top_file=amiq_dsp_algorithms_tb_top

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
        ${LIB_DIR_AMIQ_DSP_ALGORITHMS}/INCA_* \
        ${LIB_DIR_AMIQ_DSP_ALGORITHMS}/cov_work \
        ${LIB_DIR_AMIQ_DSP_ALGORITHMS}/DVEfiles \
        ${LIB_DIR_AMIQ_DSP_ALGORITHMS}/csrc \
        ${LIB_DIR_AMIQ_DSP_ALGORITHMS}/work \
        ${LIB_DIR_AMIQ_DSP_ALGORITHMS}/octave-core \
        ${LIB_DIR_AMIQ_DSP_ALGORITHMS}/irun.key \
        ${LIB_DIR_AMIQ_DSP_ALGORITHMS}/waves.shm \
        ${LIB_DIR_AMIQ_DSP_ALGORITHMS}/simvision*.diag \
        ${LIB_DIR_AMIQ_DSP_ALGORITHMS}/*simvision \
        ${LIB_DIR_AMIQ_DSP_ALGORITHMS}/*log \
        ${LIB_DIR_AMIQ_DSP_ALGORITHMS}/*.so \
        ${LIB_DIR_AMIQ_DSP_ALGORITHMS}/*.o \
        ${LIB_DIR_AMIQ_DSP_ALGORITHMS}/*.err \
        ${LIB_DIR_AMIQ_DSP_ALGORITHMS}/simv* \
        ${LIB_DIR_AMIQ_DSP_ALGORITHMS}/dpi_types.h \
        ${LIB_DIR_AMIQ_DSP_ALGORITHMS}/*.wlf \
        ${LIB_DIR_AMIQ_DSP_ALGORITHMS}/transcript \
        ${LIB_DIR_AMIQ_DSP_ALGORITHMS}/vc_hdrs.h \
        ${LIB_DIR_AMIQ_DSP_ALGORITHMS}/*.vpd \
        ${LIB_DIR_AMIQ_DSP_ALGORITHMS}/*.key \
        ${LIB_DIR_AMIQ_DSP_ALGORITHMS}/*.date \
        ${LIB_DIR_AMIQ_DSP_ALGORITHMS}/.simvision \
        ${LIB_DIR_AMIQ_DSP_ALGORITHMS}/*uvm*
        
exit
}


# Display the usage parameters
help() {
    echo "Usage:  amiq_dsp_algorithms_demo.sh [-t[est] <name>]"
    echo "                                    [-s[eed] <value>]"
    echo "                                    [-opt[imization] { no | yes} ]"
    echo "                                    [-gui            { no | yes} ]"
    echo "                                     -sim[ulator]    { irun | vlog | vcs}"
    echo ""
    echo "        amiq_dsp_algorithms_demo.sh  -h[elp]"
    echo ""
    echo "        amiq_dsp_algorithms_demo.sh  -clean"
    
exit
}

# Compile and run with irun simulator
irun_simulation() {

    # Create shared C++&&OCTAVE library (libcpp-oct.so)
    g++ \
        -Wall \
        -m64 \
        -I${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/c \
        -I/usr/include/octave-3.4.3/octave/.. \
        -I/usr/include/octave-3.4.3/octave \
        -I/usr/include/freetype2 \
        -I${UVM_HOME}/../include/ \
        -L/usr/lib64/octave/3.4.3 \
        -L/usr/lib64 \
        -L/usr/lib64/atlas \
        -L/usr/lib/gcc/x86_64-redhat-linux/4.4.6 \
        -Wl,-rpath \
        -Wl,-rpath=/usr/lib64/octave/3.4.3 \
        -loctinterp \
        -loctave \
        -lcruft \
        -llapack \
        -lf77blas \
        -latlas \
        -lfftw3 \
        -lfftw3f \
        -lreadline \
        -lm \
        -lgfortranbegin \
        -lgfortran \
        -shared \
        -fPIC \
        -o libcpp_oct_irun.so \
        ${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/c/amiq_dsp_algorithms_c_oct_container.cpp 



   # Compile and run using libcpp-oct.so
   irun \
       -64bit \
       -dpi \
       +incdir+${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb \
       +incdir+${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb/sv \
       +incdir+${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb/sv/algorithms \
       +incdir+${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb/sv/tx_agent \
       +incdir+${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb/tc \
       +incdir+${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb/top \
       -L${SCRIPT_DIR_AMIQ_DSP_ALGORITHMS} \
       -lcpp_oct_irun \
       -I${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/c/ \
       -cpost "${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/c/amiq_dsp_algorithms_c_container.cpp" \
       -end \
       -sv \
       -uvm \
       ${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb/sv/amiq_dsp_algorithms_common_pkg.sv \
       ${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb/sv/tx_agent/amiq_dsp_algorithms_tx_pkg.sv \
       ${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb/sv/algorithms/amiq_dsp_algorithms_pkg.sv \
       ${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb/sv/amiq_dsp_algorithms_env_pkg.sv \
       ${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb/tc/amiq_dsp_algorithms_test_pkg.sv \
       ${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb/top/${top_file}.sv \
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
         +incdir+${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb \
         +incdir+${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb/sv \
         +incdir+${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb/sv/algorithms \
         +incdir+${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb/sv/tx_agent \
         +incdir+${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb/tc \
         +incdir+${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb/top \
         ${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb/sv/amiq_dsp_algorithms_common_pkg.sv \
         ${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb/sv/tx_agent/amiq_dsp_algorithms_tx_pkg.sv \
         ${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb/sv/algorithms/amiq_dsp_algorithms_pkg.sv \
         ${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb/sv/amiq_dsp_algorithms_env_pkg.sv \
         ${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb/tc/amiq_dsp_algorithms_test_pkg.sv \
         ${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb/top/${top_file}.sv \
         ${EXTRA}


    # Create shared C++&&OCTAVE library (libcpp_oct.so)
    g++ \
       -Wall \
       -m64 \
       -I${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/c \
       -I${MTI_HOME}/include/ \
       -I/usr/include/octave-3.4.3/octave/.. \
       -I/usr/include/octave-3.4.3/octave \
       -I/usr/include/freetype2 \
       -L/usr/lib64/octave/3.4.3 \
       -L/usr/lib64 \
       -L/usr/lib64/atlas \
       -L/usr/lib/gcc/x86_64-redhat-linux/4.4.6 \
       -Wl,-rpath \
       -Wl,-rpath=/usr/lib64/octave/3.4.3 \
       -loctinterp \
       -loctave \
       -lcruft \
       -llapack \
       -lf77blas \
       -latlas \
       -lfftw3 \
       -lfftw3f \
       -lreadline \
       -lm \
       -lgfortranbegin \
       -lgfortran \
       -shared \
       -fPIC \
       -o libcpp_oct_vlog.so \
       ${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/c/*.cpp
              
    #Load and run simulation
    vsim \
        ${EXTRA} \
        ${top_file} \
        -lib work \
        -sv_lib ${LIB_DIR_AMIQ_DSP_ALGORITHMS}/libcpp_oct_vlog \
        -sv_seed ${sv_seed} \
        +UVM_TESTNAME=${test_file} \
        ${GUI} \
        -do "set SolveArrayResizeMax 0;run -all"
}

vcs_simulator() {
    
    # Create shared C++&&OCTAVE library (libcpp-oct.so)
    g++ \
       -Wall \
       -m64 \
       -I${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/c \
       -I/usr/include/octave-3.4.3/octave/.. \
       -I/usr/include/octave-3.4.3/octave \
       -I/usr/include/freetype2 \
       -I${VCS_HOME}/include/ \
       -L${VCS_HOME}/include/ \
       -L/usr/lib64/octave/3.4.3 \
       -L/usr/lib64 \
       -L/usr/lib64/atlas \
       -L/usr/lib/gcc/x86_64-redhat-linux/4.4.6 \
       -Wl,-rpath \
       -Wl,-rpath=/usr/lib64/octave/3.4.3 \
       -loctinterp \
       -loctave \
       -lcruft \
       -llapack \
       -lf77blas \
       -latlas \
       -lfftw3 \
       -lfftw3f \
       -lreadline \
       -lm \
       -lgfortranbegin \
       -lgfortran \
       -shared \
       -fPIC \
       -o libcpp_oct_vcs.so \
       ${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/c/amiq_dsp_algorithms_c_oct_container.cpp 

       
    # Compile and run using libcpp_oct.so
    vcs \
        -full64 \
        -sverilog \
        -ntb_opts uvm \
        +incdir+${UVM_HOME} \
        +incdir+${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb \
        +incdir+${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb/sv \
        +incdir+${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb/sv/algorithms \
        +incdir+${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb/sv/tx_agent \
        +incdir+${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb/tc \
        +incdir+${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb/top \
        +vc+abstract+allhdrs+list \
        +v2k \
        ${LIB_DIR_AMIQ_DSP_ALGORITHMS}/libcpp_oct_vcs.so \
        -CFLAGS ' -I${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/c ' \
        ${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/c/amiq_dsp_algorithms_c_container.cpp \
        ${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb/sv/amiq_dsp_algorithms_common_pkg.sv \
        ${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb/sv/tx_agent/amiq_dsp_algorithms_tx_pkg.sv \
        ${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb/sv/algorithms/amiq_dsp_algorithms_pkg.sv \
        ${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb/sv/amiq_dsp_algorithms_env_pkg.sv \
        ${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb/tc/amiq_dsp_algorithms_test_pkg.sv \
        ${PROJ_HOME_AMIQ_DSP_ALGORITHMS}/tb/top/${top_file}.sv \
        +UVM_TESTNAME=${test_file} \
        +UVM_VERBOSITY=UVM_LOW \
        -top ${top_file} \
        -timescale=1ns/1ps \
        +ntb_random_seed_automatic \
        +ntb_random_seed=${sv_seed} \
        ${EXTRA} \
        ${GUI}
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
        else
            UVM_HOME=${VCS_HOME}/etc/uvm
            
            if [ ${OPT} == no ]
            then
                EXTRA="-debug_all +define+SIM_VCS_NO_OPT"
            else
                EXTRA="+define+SIM_VCS_OPT"
            fi
            
            if [ ${UI} == no ]
            then
                GUI="-R "
            else
                GUI="-R -gui"
            fi
            
            vcs_simulator
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
