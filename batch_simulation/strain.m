function param = strain(genotype)

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
            param.Patch = 1;
            param.App   = 8;
            param.Rc    = 1;
        case 2
            param.Patch = 0;
            param.App   = 8;
            param.Rc    = 1;
        case 3
            param.Patch = 1;
            param.App   = 0;
            param.Rc    = 1;
        case 4
            param.Patch = 0;
            param.App   = 0;
            param.Rc    = 1;
    end
end
param.Box = 500;

            