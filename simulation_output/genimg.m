function genimg(INPUT_LIST,Nrep)

close all
clc

fpath = 'squeeze/';
fname = 'Patch_%d_Box_%d/App_%.1f_Rc_%.1f/Rep_%03d/Out.xyz';
fout  = 'Patch_%d_Box_%d/App_%.1f_Rc_%.1f/Rep_%03d/img_bin.mat';

R = 5;
N = 2048;
 
for i = 1:numel(INPUT_LIST)
    
    param = strain(INPUT_LIST{i});
    
    for rep = 1:Nrep
        
        fprintf('Generating images for %s rep %d...\n',INPUT_LIST{i},rep);
        
        fdir = [fpath sprintf(fname,param.Patch,param.Box,...
                               param.App,param.Rc,rep)];
                           
         xyz = readxyz(fdir);
         I   = xy2img(xyz(:,1),xyz(:,2), R, param.Box, N);
         
         save([fpath sprintf(fout,param.Patch,param.Box,...
                               param.App,param.Rc,rep)],'I');
    end
    
end