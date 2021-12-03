function [weight_array, density_array] = seg(label_cell)
% LABEL denotes single cell label

pixeltoum = 10/153;
umi_cell   = unique(label_cell);
area_cell  = zeros(size(umi_cell));

%% Calculate segmentaion area
fprintf('calculating cell area...\n')
for i = 1:numel(umi_cell)
    umi = umi_cell(i);
    area_cell(i) = sum(abs(label_cell-umi)<1e-6,'all');
end

area_cell_avg = mean(area_cell(area_cell<1000));

%% Calculate cell number
fprintf('calculating cell number...\n')

ncell = zeros(size(umi_cell));
for i = 2:numel(umi_cell)
%     umi   = umi_cell(i);
    areai = area_cell(i);
    if areai < 2*area_cell_avg-1
        nci=1;
    else
        nci=round(areai/area_cell_avg);
    end
    ncell(i)=nci;
end

%% Group clusters
fprintf('processing cell clusters...\n')
Gamma  = 1;
gamma  = 50;
muw    = 1;
dt     = 3e-2;
phi0   = label_cell > 0;

phihat = ones(size(phi0));
phierr = 1e6;
minerr = 1e-3;
kk     = 0;
while phierr > minerr
    
    fp = dphihat(phihat, muw, gamma);
    
    phiold = phihat;
    phihat = phiold + dt*Gamma*fp;
    phihat(phihat<phi0) = phi0(phihat<phi0);
    phierr = max(abs(phihat(:)-phiold(:)));
    fprintf('error = %.6f\n',phierr);
    kk = kk + 1;
end
fprintf('finish in %d steps\n',kk)


%% label cluster
fprintf('label cell clusters...\n')

label_cluster = bwlabel(phihat>0.25);
umi_cluster   = unique(label_cluster);
area_cluster  = zeros(size(umi_cluster));
for i = 2:numel(umi_cluster)
    area_cluster(i) = sum(abs(label_cluster-umi_cluster(i))<1e-6,'all');
end

cluster_index = find(area_cluster >  16*area_cell_avg);
weight_array  = zeros(size(cluster_index));
density_array = zeros(size(cluster_index));

for i = 1:numel(cluster_index)
    umi = umi_cluster( cluster_index(i) );
    area_this = area_cluster( cluster_index(i) );
    cell_label_this = label_cell(abs(label_cluster-umi)<1e-6);
    cell_label_this = unique(cell_label_this);
    [~,loc_cell] = ismember(cell_label_this,umi_cell);
    nc_this = sum(ncell(loc_cell));
    fprintf('#cell = %d, density = %f \n',nc_this, nc_this/(area_this*pixeltoum^2));
    weight_array(i)  = (area_this*pixeltoum^2);
    density_array(i) = nc_this/(area_this*pixeltoum^2);
end
weight_array_norm = weight_array / sum(weight_array,'all');
density_avg = sum(weight_array_norm.*density_array);
density_std = sqrt( sum( weight_array_norm.*(density_array-density_avg).^2 ,'all') );
fprintf('mean=%f, std=%f\n',density_avg,density_std)


function f = dphihat(phi, mu, gamma)
[phi_x, phi_y] = grad(phi, 1, 1);
absphi = sqrt(1+phi_x.^2+phi_y.^2);
f  = gamma * div(phi_x./absphi,phi_y./absphi, 1,1) - mu;