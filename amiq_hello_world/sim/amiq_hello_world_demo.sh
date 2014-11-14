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
# NAME:      amiq_hello_world_demo.sh
# PROJECT:   amiq_hello_world
# Description:  Script example to compile and run simulation with different simulators
#
# Usage:
#     -sim[ulator] { irun | vlog | vcs} : sets the desired simulator to compile and run simulations
#                                         valid values: - irun : used to compile and run simulations with irun simulator
#                                                       - vlog : used to compile with vlog simulator and run simulations with vsim simulator
#                                                       - vcs  : used to compile and run simulations with vcs simulator
#     -gui {yes | no} : open the user interface
#     -h[elp]         : display the usage for the current script
#     -clean          : clean current directory
# Example of using : ./amiq_hello_world_demo.sh -sim irun -gui yes
##########################################################################################

##########################################################################################
#  Setting the variables
##########################################################################################

# Setting the SCRIPT_DIR_AMIQ_HELLO_WORLD variable used to find out where the script is stored
SCRIPT_DIR_AMIQ_HELLO_WORLD=`dirname $0`
export SCRIPT_DIR_AMIQ_HELLO_WORLD=`cd ${SCRIPT_DIR_AMIQ_HELLO_WORLD}&& pwd`

# Setting the PROJ_HOME_AMIQ_HELLO_WORLD variable used to find out where the current project is stored
export PROJ_HOME_AMIQ_HELLO_WORLD=`cd ${SCRIPT_DIR_AMIQ_HELLO_WORLD}/../ && pwd`

# Setting the LIB_DIR_AMIQ_HELLO_WORLD variable used to find out where the shared library is stored
export LIB_DIR_AMIQ_HELLO_WORLD=${PROJ_HOME_AMIQ_HELLO_WORLD}/sim

# Set variables with default value
simulator=""
UVM_HOME=""
sv_seed=1
top_file=amiq_hello_world_tb_top

UI="no"
GUI=""


##########################################################################################
#  Methods
##########################################################################################

#  Clean current directory
clean() {
    rm \
        -rf \
        ${LIB_DIR_AMIQ_HELLO_WORLD}/INCA_* \
        ${LIB_DIR_AMIQ_HELLO_WORLD}/cov_work \
        ${LIB_DIR_AMIQ_HELLO_WORLD}/DVEfiles \
        ${LIB_DIR_AMIQ_HELLO_WORLD}/csrc \
        ${LIB_DIR_AMIQ_HELLO_WORLD}/work \
        ${LIB_DIR_AMIQ_HELLO_WORLD}/octave-core \
        ${LIB_DIR_AMIQ_HELLO_WORLD}/irun.key \
        ${LIB_DIR_AMIQ_HELLO_WORLD}/waves.shm \
        ${LIB_DIR_AMIQ_HELLO_WORLD}/simvision*.diag \
        ${LIB_DIR_AMIQ_HELLO_WORLD}/*simvision \
        ${LIB_DIR_AMIQ_HELLO_WORLD}/*log \
        ${LIB_DIR_AMIQ_HELLO_WORLD}/*.so \
        ${LIB_DIR_AMIQ_HELLO_WORLD}/*.o \
        ${LIB_DIR_AMIQ_HELLO_WORLD}/*.err \
        ${LIB_DIR_AMIQ_HELLO_WORLD}/simv* \
        ${LIB_DIR_AMIQ_HELLO_WORLD}/dpi_types.h \
        ${LIB_DIR_AMIQ_HELLO_WORLD}/*.wlf \
        ${LIB_DIR_AMIQ_HELLO_WORLD}/transcript \
        ${LIB_DIR_AMIQ_HELLO_WORLD}/vc_hdrs.h \
        ${LIB_DIR_AMIQ_HELLO_WORLD}/*.vpd \
        ${LIB_DIR_AMIQ_HELLO_WORLD}/*.key \
        ${LIB_DIR_AMIQ_HELLO_WORLD}/*.date \
        ${LIB_DIR_AMIQ_HELLO_WORLD}/.simvision \
        ${LIB_DIR_AMIQ_HELLO_WORLD}/*uvm*
        
exit
}


# Display the usage parameters
help() {
    echo "Usage:  amiq_hello_world_demo.sh [-gui            { no | yes} ]"
    echo "                                  -sim[ulator]    { irun | vlog | vcs}"
    echo ""
    echo "        amiq_hello_world_demo.sh  -h[elp]"
    echo ""
    echo "        amiq_hello_world_demo.sh  -clean"
    
exit
}

# Compile and run with irun simulator
irun_simulation() {

    # Create shared C++&&OCTAVE library (libcpp-oct.so)
    g++ \
        -Wall \
        -m64 \
        -I${PROJ_HOME_AMIQ_HELLO_WORLD}/octave \
        -I${PROJ_HOME_AMIQ_HELLO_WORLD}/c \
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
        -o libcpp_oct.so \
        ${PROJ_HOME_AMIQ_HELLO_WORLD}/c/amiq_hello_world_cpp_oct_container.cpp


   # Compile and run using libcpp-oct.so
   irun \
       -64bit \
       -dpi \
       -I${PROJ_HOME_AMIQ_HELLO_WORLD}/c/ \
       -L${SCRIPT_DIR_AMIQ_HELLO_WORLD} \
       +incdir+${PROJ_HOME_AMIQ_HELLO_WORLD}/tb \
       +incdir+${PROJ_HOME_AMIQ_HELLO_WORLD}/tb/sv \
       +incdir+${PROJ_HOME_AMIQ_HELLO_WORLD}/tb/top \
       -lcpp_oct \
       -cpost "${PROJ_HOME_AMIQ_HELLO_WORLD}/c/amiq_hello_world_cpp_c_container.cpp" \
       -end \
       -sv \
       -uvm \
       ${PROJ_HOME_AMIQ_HELLO_WORLD}/tb/sv/amiq_hello_world_pkg.sv \
       ${PROJ_HOME_AMIQ_HELLO_WORLD}/tb/top/amiq_hello_world_tb_top.sv \
       +UVM_NO_RELNOTES \
       +define+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR \
       +UVM_VERBOSITY=UVM_LOW \
       -message \
       -coverage all \
       -covoverwrite \
       -timescale 100ps/1ps \
       -svseed ${sv_seed} \
       -top ${top_file} \
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
         +incdir+${PROJ_HOME_AMIQ_HELLO_WORLD}/tb \
         +incdir+${PROJ_HOME_AMIQ_HELLO_WORLD}/tb/sv \
         +incdir+${PROJ_HOME_AMIQ_HELLO_WORLD}/tb/top \
         ${PROJ_HOME_AMIQ_HELLO_WORLD}/tb/sv/amiq_hello_world_pkg.sv \
         ${PROJ_HOME_AMIQ_HELLO_WORLD}/tb/top/amiq_hello_world_tb_top.sv


    # Create shared C++&&OCTAVE library (libcpp_oct.so)
    g++ \
       -Wall \
       -m64 \
       -I${PROJ_HOME_AMIQ_HELLO_WORLD}/octave \
       -I${PROJ_HOME_AMIQ_HELLO_WORLD}/c \
       -I${MTI_HOME}/include/systemc \
       -I${MTI_HOME}/include/ \
       -I/usr/include/octave-3.4.3/octave/.. \
       -I/usr/include/octave-3.4.3/octave \
       -I/usr/include/freetype2 \
       -L/usr/lib64/octave/3.4.3 \
       -L/usr/lib64 \
       -L/usr/lib64/atlas \
       -L/usr/lib/gcc/x86_64-redhat-linux/4.4.6 \
       -L${MTI_HOME}/include/ \
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
       -o libcpp_oct.so \
       ${PROJ_HOME_AMIQ_HELLO_WORLD}/c/*.cpp 
              

    #Load and run simulation
    vsim \
        ${top_file} \
        -lib work \
        -sv_lib ${LIB_DIR_AMIQ_HELLO_WORLD}/libcpp_oct \
        -sv_seed ${sv_seed} \
        ${GUI} \
        -do "run -all"
}

vcs_simulator() {
    
    # Create shared C++&&OCTAVE library (libcpp-oct.so)
    g++ \
       -Wall \
       -m64 \
       -I${PROJ_HOME_AMIQ_HELLO_WORLD}/c \
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
       -o libcpp_oct.so \
       ${PROJ_HOME_AMIQ_HELLO_WORLD}/c/amiq_hello_world_cpp_oct_container.cpp

       
    # Compile and run using libcpp_oct.so
    vcs \
        -full64 \
        -sverilog \
        -ntb_opts uvm \
        +incdir+${UVM_HOME} \
        +incdir+${PROJ_HOME_AMIQ_HELLO_WORLD}/tb \
        +incdir+${PROJ_HOME_AMIQ_HELLO_WORLD}/tb/sv \
        +incdir+${PROJ_HOME_AMIQ_HELLO_WORLD}/tb/sv/top \
        +vc+abstract+allhdrs+list \
        +v2k \
        ${LIB_DIR_AMIQ_HELLO_WORLD}/libcpp_oct.so \
        ${PROJ_HOME_AMIQ_HELLO_WORLD}/c/amiq_hello_world_cpp_c_container.cpp \
        ${PROJ_HOME_AMIQ_HELLO_WORLD}/tb/sv/amiq_hello_world_pkg.sv \
        ${PROJ_HOME_AMIQ_HELLO_WORLD}/tb/top/amiq_hello_world_tb_top.sv \
        +UVM_VERBOSITY=UVM_LOW \
        -top ${top_file} \
        -timescale=1ns/1ps \
        +ntb_random_seed_automatic \
        +ntb_random_seed=${sv_seed} \
        ${GUI}
}

# Compile and run with the proper simulator
start_simulation() {
    if [ ${simulator} == irun ]
        then
            UVM_HOME=`ncroot`/tools/uvm
            
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
            
            if [ ${UI} == no ]
            then
                GUI="-c "
            else
                GUI=""
            fi
            
            questa_simulation
        else
            UVM_HOME=${VCS_HOME}/etc/uvm
            
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
      -clean)
                 clean
                 ;;
      -gui)
                 UI=$2
    esac
    shift
done

start_simulation
