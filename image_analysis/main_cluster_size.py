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






# ### Set up input/output directories

'''
One-time processing: rename all the input files with the same format "CE000rep0_000.tif"
'''
# _path    = "stat_input/vortexed/"
# _filelist= os.listdir(_path)
# for _filename in _filelist:
#     os.rename(_path+_filename, _path+_filename.replace("vortexed",""))


# define parameter dictionary
param = {
    "strain":  "pilT",
    "Nbio":    3,
    "Ntech":   5,
    "savedat": False
}
# input from keyboard
keyboardinput = sys.argv[1::]
aux_io.parse_input(param,keyboardinput)

# io parameters
fpath_input  = "stat_input/cluster/"
fpath_output = fpath_input.replace("input","output")
fname_var    = "%srep%d_%03d"
fmt_input    = ".tif"
fmt_output   = ".mat"

strain       = aux_io.Genotype_to_StrainName(param["strain"])
_SAVE_OUTPUT = bool(param["savedat"])

if _SAVE_OUTPUT:
    if not os.path.exists(fpath_output):
        os.makedirs(fpath_output)








#rep = 1
#idd = 1
tmp_array = np.zeros( [int(param["Nbio"]),int(param["Ntech"])] )

for rep in range(1,int(param["Nbio"]+1)):
    
    for idd in range(1,int(param["Ntech"]+1)):

        # (1) image loading and preprocessing
        img      = cv2.imread(fpath_input + fname_var%(strain,rep,idd)  + fmt_input,
                              cv2.IMREAD_UNCHANGED)
        img_gray = aux_img.imadjust(img)
        img_gray = 255-img_gray
        img_gray = img_gray.astype(np.uint8)
        
        if _SAVE_OUTPUT:
            cv2.imwrite(fpath_output + fname_var%(strain,rep,idd) + ".png",img_gray)

        # (1a) adaptive thresholding
        img_bin = cv2.adaptiveThreshold(img_gray, 255,
                 cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY, aux_img.FILTER_WIDTH, 0)

        # (1b) remove salt and pepper noise
        img_bin = cv2.morphologyEx(img_bin, cv2.MORPH_OPEN,
                np.ones((aux_img.FILTER_OPEN, aux_img.FILTER_OPEN), dtype=int))
        img_bin = cv2.morphologyEx(img_bin, cv2.MORPH_CLOSE,
                np.ones((aux_img.FILTER_CLOSE, aux_img.FILTER_CLOSE), dtype=int))

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

        print("rep = %d, id = %d: %.4f"%(rep,idd,a*aux_img.COARSEN_LEN))
        tmp_array[rep-1,idd-1]=a*aux_img.COARSEN_LEN
        
        # (4) save analysis results
        if _SAVE_OUTPUT:
            sio.savemat(fpath_output + fname_var%(strain,rep,idd)  + fmt_output,
                        {'corr_xy': corr_mat,
                         'delx':    delx * aux_img.COARSEN_LEN,
                         'dely':    dely * aux_img.COARSEN_LEN,
                         'delr':    var_rad * aux_img.COARSEN_LEN,
                         'corr_r_avg': corr_avg,
                         'corr_r_std': corr_std,
                         'corr_len':  a * aux_img.COARSEN_LEN,
                         'rho_avg': np.sum((img_bin > 0).astype('float')) / np.sum((img_bin > -1).astype('float'))})


tmp_array = np.mean(tmp_array,axis=1)
print("average cluster size = %.2f pixel"%np.mean(tmp_array))
print("std cluster size = %.2f pixel"%np.std(tmp_array))
