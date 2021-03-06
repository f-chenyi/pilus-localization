## Installation
Required python packages (suggested version) to run the code:
- python     (3.8.5)
- numpy      (1.19.2)
- scipy      (1.5.2)
- matplotlib (3.3.2)
- opencv     (4.5.3.56)

MATLAB (Mathworks, 2020a) is required to run the .m script and 
open .mat files.


## Analysis pipeline

1. Create a directory "./image_analysis/stat_input/cluster/"
	 and drop the experimental images here. File name should 
	 be formatted as 
   
       "[%s]rep[%d]_[%03d].tif"


2. To analyze the experimental images, run the following 
	 command in Terminal:
	   
	   python -u main_cluster_size.py -strain [X] -Nbio [X] -Ntech [X] -savedat [X]
	
	 where [X] are input parameters. For example,

	   python -u main_cluster_size.py -strain pilT -Nbio 3 -Ntech 5 -savedat 1

	 analyze the ΔpilT strain with 3 biological replicates
	 and 5 technical replicates, and saving the outputs.


3. To analyze the simulation data, go to ./simulation_output/
	 and run the following in the command window in MATLAB:

	   genimg({'pilT','fimVpilT','comPpilT','fimVcomPpilT'},5)

  This will analyze the four simulated strains with 5 replicates,
  and generate binary images of the 2D projections of the simulated cell configurations.
  
4. To analyze the simulation images generated by step 3, go back to 
	  ./image_analysis/ and run the following command in Terminal:

	   python -u sim_cluster_size.py -strain [X] -Ntech [X] -savedat [X]

5. To generate the summary excel file, run in MATLAB:

		sumdata()


## Simulation

Details about the simulation are described [here](https://github.com/f-chenyi/pilus-localization/blob/main/simulation_code/README.md)
