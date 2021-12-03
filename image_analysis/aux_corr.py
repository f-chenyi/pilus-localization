import sys
import os
import numpy as np



# 2d correlation
def xy_corr(img, L, zero_mean=True):

    [dcol, drow] = np.meshgrid(np.linspace(-L,L,2*L+1),
                               np.linspace(-L,L,2*L+1))
    output = np.zeros(np.shape(drow))
#     img  = img.astype('float')
    img  = (img > 0).astype('float')
    if zero_mean:
        img = img - np.mean(img)
    ncc  = np.sum(img**2)

    for i in range(np.shape(drow)[0]):
        for j in range(np.shape(drow)[1]):
            dy = drow[i,j].astype('int')
            dx = dcol[i,j].astype('int')
            output[i,j] = np.sum( img*np.roll(img,(dy,dx),axis=(0,1)) ) / ncc

    return output, dcol, drow



# radial correlation function
def rad_corr(delx, dely, corr_mat, COARSE_RANGE):
    delr     = np.sqrt(delx**2+dely**2)
    var_rad  = np.linspace(0,COARSE_RANGE-1,COARSE_RANGE)
    var_dr   = var_rad[1] - var_rad[0]
    corr_avg = np.zeros_like(var_rad)
    corr_std = np.zeros_like(var_rad)

    for i in range(len(var_rad)):
        range_i = np.logical_and( delr <= (var_rad[i]+var_dr/2),
                                  delr >  (var_rad[i]-var_dr/2) )
        corr_avg[i] = np.mean(corr_mat[range_i])
        corr_std[i] = np.std(corr_mat[range_i])
    
    return var_rad, corr_avg, corr_std
