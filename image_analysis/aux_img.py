import numpy as np

# imaging analysis parameters
FILTER_WIDTH = 21  # pixel
FILTER_OPEN  = 7   # pixel
FILTER_CLOSE = 4   # pixel
COARSEN_LEN  = 10  # pixel
COARSE_RANGE = 50  # coarse-grained pixel




# matlab equivalent of imadjust
# adjust contrast of the cells

def imadjust(x,a=None,b=None,c=None,d=None,gamma=1):
    # Default unit8 images
    x = x.astype(np.float)
    if a==None or b==None or c==None or d==None:
        a = np.amin(x)
        b = np.amax(x)
        c = 0
        d = 255
    y = (((x - a) / (b - a)) ** gamma) * (d - c) + c
    
    return y.astype(np.uint8)



def coarse_grain_img(pop_density, coarseness):
    
    n0 = pop_density.shape[0] // coarseness
    n1 = pop_density.shape[1] // coarseness
    pop_density = pop_density[0:n0*coarseness,0:n1*coarseness].astype('float')
    
    temp = pop_density.reshape((n0, coarseness,
                                n1, coarseness))
    coarse_pop_density = np.sum(temp, axis=(1,3)) / coarseness / coarseness
    
    return coarse_pop_density

