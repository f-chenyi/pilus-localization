## Simulation Output

End-point atom positions are stored under 
  
    ./squeeze/

as .xyz files. Five replicates are simulated for each set
of parameters.

The end-point positions are used to create simulation "images"
so that the same image analysis (see README.md of ../image_analysis/)
can be applied to both experimental and simulation data. 
This is done by the folloing matlab scripts:

- [genimg] is the main function to batch process the
	simulation data, which calls the other auxiliary functions.

- [strain] converts genotype (e.g., pilT) to corresponding
	simulation parameters.

- [readxyz] reads .xyz files and output a list of coordinates
	for all the cells.
  
-  [xy2img] generates 2D binary images for the simulated cells
	(cell region = 1, void = 0)
