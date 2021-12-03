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
