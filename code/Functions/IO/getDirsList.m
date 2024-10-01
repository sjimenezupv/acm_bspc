function [ dir_list, num_dirs ] = getDirsList( base_path )
%GETDIRSLIST Gets a list of folders within the specified folder


	% Get all the files and folders
    dir_list = dir(base_path);
    
    % Remove folders '.', '..', and those that aren't folders
    i = 1;    
    while i <= length(dir_list)
        if strcmp(dir_list(i).name, '.')  == 1 || ...
           strcmp(dir_list(i).name, '..') == 1 || ...
           dir_list(i).isdir              == 0
            dir_list(i) = [];
            i = i - 1;
        end
        i = i + 1;
    end
    
	% Set the number of output folders
    num_dirs = length(dir_list);
	
end

