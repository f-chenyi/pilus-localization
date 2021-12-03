function c = clr(genotype)
okargs =   {  'pilT',     ...
              'fimVpilT',   ...
              'comPpilT',      ...
              'fimVcomPpilT'
              };
pname = genotype;
k = find(strcmpi(pname, okargs));
if isempty(k)
    error('clr: invalid genotype...');
else
    switch k
        case 1
            c  = [66, 113, 172]/255;
        case 2
            c  = [111, 194, 159]/255;
        case 3
            c  = [181, 131, 62] /255;
        case 4
            c  = [128,  41,  92]/255;
    end
end