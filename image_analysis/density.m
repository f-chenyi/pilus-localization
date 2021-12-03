function density(INPUT_LIST, Nbio, Ntech)
close all
clc

fpath = 'stat_output/sclabel/';
fname = '%srep%d_%03d.txt';
fbio  = '%srep%d_proc.mat';
fstr  = '%s_stat.mat';

% loop over strains 
for i = 1:numel(INPUT_LIST)
    
    STRAIN_NAME = strain( INPUT_LIST{i} ) ;
    stat_array  = zeros(Nbio, 2); 
    % loop over biological replicates
    for rep = 1:Nbio
        
        area_array = [];
        dens_array = [];
        
        % loop over technical replicates
        for id = 1:Ntech
            
            lbl = load([fpath sprintf(fname,STRAIN_NAME,rep,id)]);
            [area_, density_] = seg(lbl);
            
            area_array = [area_array; area_];
            dens_array = [dens_array; density_];

        end
        save([fpath sprintf(fbio,STRAIN_NAME,rep)],'area_array','dens_array');
        
        weight_array = area_array / sum(area_array,'all');
        dens_avg = sum( weight_array.* dens_array );
        dens_std = sqrt( sum( weight_array.*(dens_array-dens_avg).^2 ) );
        stat_array(rep,:) = [dens_avg, dens_std];
    end
    save([fpath sprintf(fstr,STRAIN_NAME)],'stat_array');
    
end

clc

fprintf('========= Summary of cell-density statistics =========\n')
for i = 1:numel(INPUT_LIST)
    STRAIN_NAME = strain( INPUT_LIST{i} ) ;
    load([fpath sprintf(fstr,STRAIN_NAME)],'stat_array');
    fprintf('%s: %.4f ± %.4f\n',...
            INPUT_LIST{i}, mean(stat_array(:,1)), std(stat_array(:,1),1))
end
% figure;
% for i=1:numel(STRAIN_LIST); bar_color(i,:)=color_strain(STRAIN_LIST{i});end
% plt_bar_error(1:numel(STRAIN_LIST),density_data(:,1),density_data(:,2), bar_color, ...
%               {'Linewidth',2,'FaceColor','none'},{'Linewidth',1.5})
% set(gca,'Linewidth',1.5, 'color', 'none', 'Fontsize', 22,...
%         'TickDir','out','TickLength',[0.02 0.02],'box','off',...
%         'xlim',[0.3 4.7], 'ylim', [0 0.8],...
%         'xtick',[], 'ytick',[0:0.2:0.8])
%     
% set(gcf,'Position',[0 0 300 340])

