function sumdata(INPUT_LIST)

Ntech = 5;
Nbio  = 3;

fpath_exp = 'stat_output/cluster/';
fpath_sim = 'stat_output/sim_cluster/';
fname_exp = '%srep%d_%03d.mat';
fname_sim = '%srep_%03d.mat';
VarName = 'corr_len';

tab_exp = table('Size',[Nbio*numel(INPUT_LIST),8],...
                'VariableTypes',{'categorical','double','double','double','double','double','double','double'},...
                'VariableNames',{'Strain','Rep1','Rep2','Rep3','Rep4','Rep5','Mean','Std'});

tab_sim = table('Size',[numel(INPUT_LIST),8],...
                'VariableTypes',{'categorical','double','double','double','double','double','double','double'},...
                'VariableNames',{'Strain','Rep1','Rep2','Rep3','Rep4','Rep5','Mean','Std'});

row_exp = 1;
row_sim = 1;

for i = 1:numel(INPUT_LIST)
    
    strain_nm = strain( INPUT_LIST{i} );
    
    % read anaysis results of experimental data
    for j = 1:Nbio
        
        tab_exp(row_exp,1) =  {[INPUT_LIST{i} sprintf('_rep%d',j)]};
        
        for k = 1:Ntech
            
            tmp = load([fpath_exp  sprintf(fname_exp,strain_nm,j,k)]);
            tab_exp.(sprintf('Rep%d',k))(row_exp) = tmp.(VarName);
            
        end
        tab_exp.Mean(row_exp) = mean( table2array(tab_exp(row_exp,1+[1:Ntech])) );
        tab_exp.Std(row_exp)  = std( table2array(tab_exp(row_exp,1+[1:Ntech])), 1 );
        row_exp = row_exp+1;
        
    end
    
    % read anaysis results of simulation data
    tab_sim(row_sim,1) =  {INPUT_LIST{i}};
    for k = 1:Ntech
        tmp = load([fpath_sim  sprintf(fname_sim,strain_nm,k)]);
        tab_sim.(sprintf('Rep%d',k))(row_sim) = tmp.(VarName);
    end
    tab_sim.Mean(row_sim) = mean( table2array(tab_sim(row_sim,1+[1:Ntech])) );
    tab_sim.Std(row_sim)  = std( table2array(tab_sim(row_sim,1+[1:Ntech])), 1 );
    row_sim = row_sim+1;
    
end

writetable(tab_exp,'stat_output/cluster_size.xlsx','FileType','spreadsheet','Sheet','Experiment');
writetable(tab_sim,'stat_output/cluster_size.xlsx','FileType','spreadsheet','Sheet','Simulation');
