#!/bin/bash

# build a mixed precision version of lammps for della using the user-intel package

VERSION=4Feb2020
wget https://github.com/lammps/lammps/archive/patch_${VERSION}.tar.gz
tar zxf patch_${VERSION}.tar.gz
cd lammps-patch_${VERSION}
mkdir build
cd build

module purge
module load intel/18.0/64/18.0.3.222 intel-mpi/intel/2018.3/64

cmake3 -D CMAKE_INSTALL_PREFIX=$HOME/.local -D LAMMPS_MACHINE=della -D ENABLE_TESTING=yes \
-D BUILD_MPI=yes -D BUILD_OMP=yes -D CMAKE_CXX_COMPILER=icpc -D CMAKE_BUILD_TYPE=Release \
-D CMAKE_Fortran_COMPILER=/opt/intel/compilers_and_libraries_2018.3.222/linux/bin/intel64/ifort \
-D CMAKE_CXX_FLAGS_RELEASE="-Ofast -axCORE-AVX512 -DNDEBUG" \
-D PKG_USER-OMP=yes -D PKG_MOLECULE=yes -D PKG_RIGID=yes \
-D PKG_KSPACE=yes -D FFT=MKL -D FFT_SINGLE=yes \
-D PKG_MC=yes -D PKG_USER-FEP=yes -D PKG_USER-MISC=yes \
-D PKG_USER-INTEL=yes -D INTEL_ARCH=cpu -D INTEL_LRT_MODE=threads ../cmake

make -j 10
make test
make install
