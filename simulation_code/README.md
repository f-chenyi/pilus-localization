## Installation

Instructions for installing LAMMPS can be found [here](https://github.com/PrincetonUniversity/install_lammps/blob/master/01_installing/ins/della/scripts.md#della-cpu)

LAMMPS(4Feb2020 version) is installed with "lammps_mixed_prec_della.sh".

## Simulation descriptions

Piliated cells are represented as molecules in the simulation, 
each containing a centered spherical atom (R=5; cell body) and
17 surrounding atoms (r=1; pilus). Molecular dynamics simulations 
are performed using LAMMPS. To mimic the experimental procedure,
each simulation consists of two periods, one in which molecules
collide and equilibrate and one in which molecule are squeezed
uniaxially. Simulation files named "Runner[%d].in" in "_equil/In/"
and "_squeeze/In/" are used to simulate the two periods, respectively.

Two key parameters of the simulations are: 
1. whether the "pilus" atoms are localized (Patch=1) or uniformly distributed (Patch=0); and
2. the adhesion strength between "pilus" atoms (denoted by App).

Correspondence between parameter values and experimental strains:

	Patch = 1, App = 8 –– ΔpilT
	Patch = 0, App = 8 –– ΔfimVΔpilT
	Patch = 1, App = 0 –– ΔcomPΔpilT
	Patch = 0, App = 0 –– ΔfimVΔcomPΔpilT

See Methods for more details.

## Running the simulation

Command files named "run-rep[%d].cmd" are used to run the corresponding
simulation files "Runner[%d].in". For example, the following commands
	
	mainpath=$PWD
	cd ./_equil/In/Patch_1_Box_500/App_8.0_Rc_1.0/
	sbatch run-rep1.cmd
	cd $mainpath

runs the first replicate simulation for the ΔpilT strain.

For each replicate, the equilibrating simulation yields an output file
named "Out.restart", which is then moved to simulation folders in "_squeeze"
to seed the squeezing simulation.
