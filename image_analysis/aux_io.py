import numpy as np
import os
import csv


# generic parse input function
def parse_input(dict_o, input_o):
    okargs  = dict_o.keys()
    if np.mod(len(input_o),2) == 1:
        print("Error in parse_input: pv pair not matching!")
        return False
    else:
        Narg_o = int(len(input_o) / 2)
        i = 0
        while i < len(input_o)-1:
            pname = input_o[i].replace('-','')
            try:
                pval = float(input_o[i+1])
            except ValueError:
                pval = input_o[i+1]
            dict_o[pname] = pval
            i += 2
        
        
        

def Genotype_to_StrainName(genotype):
    strain_dict = {"pilT":     "CE317",
                   "fimVpilT": "CE724",
                   "comPpilT": "CE851",
                   "fimVcomPpilT": "CE1000"}
    if genotype not in strain_dict.keys():
        print("NameError(Genotype_to_StrainName): genotype not found!")
        strain = None
    else:
        strain = strain_dict[genotype]
        
    return strain



def Genotype_to_Parameter(genotype):
    strain_dict = {"pilT":         {"Patch":1,"Box":500,"App":8.0,"Rc":1.0},
                   "fimVpilT":     {"Patch":0,"Box":500,"App":8.0,"Rc":1.0},
                   "comPpilT":     {"Patch":1,"Box":500,"App":0.0,"Rc":1.0},
                   "fimVcomPpilT": {"Patch":1,"Box":500,"App":0.0,"Rc":1.0} }
    if genotype not in strain_dict.keys():
        print("NameError(Genotype_to_Parameter): genotype not found!")
        param = None
    else:
        param = strain_dict[genotype]
        
    return param
