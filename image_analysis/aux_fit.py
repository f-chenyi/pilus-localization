# ### Load packages

import sys
import os
import numpy as np
import scipy.io as sio
from scipy import optimize



def zero_intercept_linear(x,a):
    return -x/a

def fit_expdecay(x,y,Y_CUTOFF=0.05):
    x_array = x[y>Y_CUTOFF]
    y_array = y[y>Y_CUTOFF]
    popt_fit, pcov_fit = optimize.curve_fit(zero_intercept_linear, x_array,np.log(y_array), p0=[5])
    return popt_fit[0]


#a = fit_expdecay(var_rad, corr_avg)
#print(a)
#
#
## In[210]:
#
#
#if _SAVE_OUTPUT:
#    sio.savemat(fpath_output + "summary.mat",
#                {'corr_xy': corr_mat,
#                 'delx':    delx * COARSEN_LEN,
#                 'dely':    dely * COARSEN_LEN,
#                 'delr':    var_rad * COARSEN_LEN,
#                 'corr_r_avg': corr_avg,
#                 'corr_r_std': corr_std,
#                 'size':  a * COARSEN_LEN,
#                 'rho_avg': np.sum((img_bin > 0).astype('float')) / np.sum((img_bin > -1).astype('float'))})
#
#
## In[ ]:
#
#
#

