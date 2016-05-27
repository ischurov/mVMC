#!/bin/bash
if [ -z ${1} ] || [ ${1} = "help" ]; then
    echo ""
    echo "Usage:"
    echo "./HPhiconfig.sh system_name"
    echo " system_name should be chosen from below:"
    echo "     sekirei : ISSP system-B"
    echo "     jupiter : "
    echo "     kashiwa : "
    echo "         kei : "
    echo "         sol : "
    echo "       reims : "
    echo ""
else
    if [ ${1} = "sekirei" ]; then
        cat > src/make.sys <<EOF
CC = mpicc
LIB = -L\$(MKLROOT)/lib/intel64 -lmkl_scalapack_lp64 -lmkl_intel_lp64 -lmkl_intel_thread -lmkl_core -lmkl_blacs_sgimpt_lp64 -openmp -lpthread -lm
CFLAGS = -O3 -no-prec-div -xHost -qopenmp -Wno-unknown-pragmas
REPORT = -qopt-report-phase=openmp -qopt-report-phase=par
OPTION = -D_mpi_use
CP = cp -f -v
AR = ar rv
FORT = ifort
FFLAGS = -O3 -implicitnone -xSSE2
SMFTFLAGS = -O3 -no-ansi-alias -xSSE2 -DMEXP=19937 -DHAVE_SSE2
EOF
    elif [ ${1} = "jupiter" ]; then
        cat > src/make.sys <<EOF
CC      = mpicc
LIB = -lmkl_intel_lp64 -lmkl_intel_thread -lmkl_core -lguide -lpthread -lm -openmp
CFLAGS = -O3 -no-prec-div -xP -Wno-unknown-pragmas
REPORT = -vec-report1
OPTION = -D_mpi_use -D_lapack
CP = cp -f -v
AR = ar rv
FORT = ifort
FFLAGS = -O3 -implicitnone
SMFTFLAGS = -O3 -no-ansi-alias -DMEXP=19937
EOF
    elif [ ${1} = "kashiwa" ]; then
        cat > src/make.sys <<EOF
CC = icc -lmpi
LIB = -L \$(MKLROOT)/lib/intel64 -lmkl_scalapack_lp64\ -lmkl_intel_lp64 -lmkl_intel_thread -lmkl_core\ -lmkl_blacs_sgimpt_lp64 -openmp -lpthread -lm
CFLAGS = -O3 -no-prec-div -xHost -openmp -Wno-unknown-pragmas
REPORT = -openmp-report1 -vec-report=1
OPTION = -D_mpi_use
CP = cp -f -v
AR = ar rv
FORT = ifort
FFLAGS = -O3 -implicitnone -xSSE2
SMFTFLAGS = -O3 -no-ansi-alias -xSSE2 -DMEXP=19937 -DHAVE_SSE2
EOF
    elif [ ${1} = "kei" ]; then
        cat > src/make.sys <<EOF
FC = mpifrtpx
CC = mpifccpx
LIB = -SCALAPACK -SSL2BLAMP
CFLAGS = -Kfast,parallel,ocl,openmp
REPORT = -Koptmsg=2
OPTION = -D_mpi_use
CP = cp -f -v
AR = ar rv
FORT = frtpx
FFLAGS = -Kfast,ocl,auto,optmsg=2 -AT
SMFTFLAGS = -Kfast,ocl,nomemalias -DMEXP=19937
EOF
    elif [ ${1} = "reims" ]; then
        cat > src/make.sys <<EOF
CC = mpicc
LIB = -L \$(MKLROOT)/lib/intel64 -lmkl_scalapack_lp64 -lmkl_intel_lp64 -lmkl_intel_thread -lmkl_core -lmkl_blacs_intelmpi_lp64 -openmp -lpthread -lm
CFLAGS = -O3 -no-prec-div -xSSE2 -openmp -Wno-unknown-pragmas
REPORT = -openmp-report1 -vec-report=1
OPTION = -D_mpi_use
CP = cp -f -v
AR = ar rv
FORT = ifort
FFLAGS = -O3 -implicitnone -xSSE2
SMFTFLAGS = -O3 -no-ansi-alias -xSSE2 -DMEXP=19937 -DHAVE_SSE2
EOF
    elif [ ${1} = "sol" ]; then
        cat > src/make.sys <<EOF
CC = mpicc
LIB = -L \$(MKLROOT)/lib/intel64 -lmkl_scalapack_lp64 -lmkl_intel_lp64 -lmkl_intel_thread -lmkl_core -lmkl_blacs_openmpi_lp64 -openmp -lpthread -lm
CFLAGS = -O3 -no-prec-div -xHost -openmp -Wno-unknown-pragmas
REPORT = -openmp-report1 -vec-report=1
OPTION = -D_mpi_use
CP = cp -f -v
AR = ar rv
FORT = ifort
FFLAGS = -O3 -implicitnone -xSSE2
SMFTFLAGS = -O3 -no-ansi-alias -xSSE2 -DMEXP=19937 -DHAVE_SSE2
EOF
    elif [ ${1} == "manual" ]; then
echo " C compiler ?"
read CC
echo " LAPACK option ?"
read LAPACK_FLAGS
echo " Other compilation flags ?"
read FLAGS
        cat > src/make.sys <<EOF
CC = ${CC}
CP = cp -f -v
AR = ar rv
EOF
    else
        echo ""
        echo "Unsupported system. Please type"
        echo "./HPhiconfig.sh help"
        echo ""
        exit
    fi

    echo "cat src/make.sys"
    cat src/make.sys

    echo
    echo "HPhiconfig DONE"
    echo

    cat > makefile <<EOF
help:
	@echo ""
	@echo "Usage :"
	@echo "make <entry>"
	@echo ""
	@echo "<entry> is chosen from below"
	@echo "      mvmc : Build simulator mVMC in src/"
	@echo "     clean : Remove all generated files excepting makefile"
	@echo " veryclean : Remove all generated files including makefile"
	@echo ""

mvmc:
	cd src;make -f makefile_src

clean:
	cd src; make -f makefile_src clean

veryclean:
	make clean
	rm -f src/make.sys makefile
EOF
fi