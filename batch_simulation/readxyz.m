function cell_xyz = readxyz(fdir)

str   = fileread(fdir);
lines = regexp(str, '\r\n|\r|\n', 'split');
tl    = find(contains(lines,'Atoms. Timestep:'));
il    = tl(end)+1;

cell_xyz = [];
cell_id = 1;
for i = il:numel(lines)
    ichar = lines{i};
    if ~isempty(ichar)
        iarray = sscanf(ichar,'%d %f %f %f');
        if abs(iarray(1)-cell_id)<1e-8
            cell_xyz = [cell_xyz; iarray(2) iarray(3) iarray(4)];
        end
    end
end
