# ### Load packages

import sys
import os
import numpy as np
import scipy.io as sio

import aux_io
import aux_img
import aux_corr
import aux_fit

try:
    import cv2  # package for imaging analysis
except ModuleNotFoundError:
    print("opencv-python not installed")
    
try:
    from matplotlib import pyplot as plt   # package for visualization
except ModuleNotFoundError:
    print("matplotlib not installed")







    
    
    
    

# define parameter dictionary
param = {
    "strain":  "pilT",
    "Ntech":   5,
    "savedat": False
}
# input from keyboard
keyboardinput = sys.argv[1::]
aux_io.parse_input(param,keyboardinput)

# io parameters
fpath_input  = "../simulation_output/squeeze/"
fpath_output = "stat_output/sim_cluster/"
fname_img    = "Patch_%d_Box_%d/App_%.1f_Rc_%.1f/Rep_%03d/img_bin.mat"

fname_var    = "%srep_%03d"
fmt_output   = ".mat"

strain       = aux_io.Genotype_to_StrainName(param["strain"])
psim         = aux_io.Genotype_to_Parameter(param["strain"])
_SAVE_OUTPUT = bool(param["savedat"])

if _SAVE_OUTPUT:
    if not os.path.exists(fpath_output):
        os.makedirs(fpath_output)









        
        
tmp_array = np.zeros( int(param["Ntech"]) )

for rep in range(1,int(param["Ntech"]+1)):

    # (1) image loading and preprocessing
    mat_data = sio.loadmat(fpath_input + fname_img%(psim["Patch"],psim["Box"],psim["App"],psim["Rc"],rep),
        squeeze_me=True)
    img_bin = (mat_data["I"]*255).astype('uint8')

    # (1c) coarse-graining
    img_bin = aux_img.coarse_grain_img(img_bin, aux_img.COARSEN_LEN)

    # (1d) binarizing
    MAX_REGION = img_bin> 0.01*img_bin.max()
    MIN_REGION = img_bin<=0.01*img_bin.max()
    img_bin[MAX_REGION]=img_bin.max()
    img_bin[MIN_REGION]=0.


    # (2) compute correlation
    COARSE_RANGE = min(aux_img.COARSE_RANGE,min(np.shape(img_bin))//2-1)
    corr_mat, delx, dely = aux_corr.xy_corr(img_bin, COARSE_RANGE, zero_mean=True)
    var_rad, corr_avg, corr_std = aux_corr.rad_corr(delx, dely, corr_mat, COARSE_RANGE)

    plt.errorbar(var_rad, corr_avg, yerr = corr_std)
    plt.ylim([0,1])
    if _SAVE_OUTPUT:
        plt.savefig(fpath_output + "corr.png")



    # (3) fit with exponential
    a = aux_fit.fit_expdecay(var_rad, corr_avg)

    print("rep = %d: %.4f"%(rep,a*aux_img.COARSEN_LEN))
    tmp_array[rep-1]=a*aux_img.COARSEN_LEN
    
    # (4) save analysis results
    if _SAVE_OUTPUT:
        sio.savemat(fpath_output + fname_var%(strain,rep)  + fmt_output,
                    {'corr_xy': corr_mat,
                     'delx':    delx * aux_img.COARSEN_LEN,
                     'dely':    dely * aux_img.COARSEN_LEN,
                     'delr':    var_rad * aux_img.COARSEN_LEN,
                     'corr_r_avg': corr_avg,
                     'corr_r_std': corr_std,
                     'corr_len':  a * aux_img.COARSEN_LEN,
                     'rho_avg': np.sum((img_bin > 0).astype('float')) / np.sum((img_bin > -1).astype('float'))})


print("average cluster size = %.2f pixel"%np.mean(tmp_array))
print("std cluster size = %.2f pixel"%np.std(tmp_array))
