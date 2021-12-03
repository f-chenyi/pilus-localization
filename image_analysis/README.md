## Image analysis

The python scripts are used for computing typical cluster size:
	
-	[main_cluster_size] and	[sim_cluster_size] are the main 
	scripts to analyze cluster size from experimental images
	and simulation images, respectively.
	
-	[aux_io] contains functions that parse keyboard inputs
	for downstream analysis. 
	
-	[aux_img] contains functions that process input images,
	including contrast-adjusting, denoising, binarization,
	and coarse-graining

-	[aux_corr] contains functions that computed 2D and radial
	correlation functions.

-	[aux_fit] contains functions that fit data to exponential
	decay and extract correlation length. 


Analysis outputs are stored under ./stat_output/:

-	cluster/: cluster-size analysis of the experimental data

-	sim_cluster/: cluster-size analysis of the simulations


The matlab script [sumdata] collects all the analyses results,
and write them into a summary excel file.
