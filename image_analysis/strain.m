function nm = strain(genotype)
okargs =   {  'pilT',     ...
              'fimVpilT',   ...
              'comPpilT',      ...
              'fimVcomPpilT'
              };
pname = genotype;
k = find(strcmpi(pname, okargs));
if isempty(k)
    error('strain: invalid genotype...');
else
    switch k
        case 1
            nm  = 'CE317';
        case 2
            nm  = 'CE724';
        case 3
            nm  = 'CE851';
        case 4
            nm  = 'CE1000';
    end
end