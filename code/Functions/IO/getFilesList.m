function [ file_list, num_files ] = getFilesList( base_path, ext_filter )
%GETFILESLIST Gets a list of the files contained in the specified directory.
%
% Gets a list of the files contained in the specified directory.
%
% INPUTS
%   base_path:  Input folder path
%   ext_filter: File extension to be listed (Optional)
%
% OUTPUTS
%   file_list: List containing the file paths in the specified folder
%   num_files: Number of files in the output list
%
% AUTHOR
%   Santiago Jiménez-Serrano [sanjiser@i3m.upv.es]
%

    % Default parameters
    filter_on = nargin >= 2;

	% Get the full list
    file_list = dir(base_path);
    
    
    % Remove folders and files that don't fullfill the ext criterion
    i = 1;    
    while i <= length(file_list)
        
        % Remove folders
        if file_list(i).isdir == 1
            file_list(i) = [];
            i = i - 1;
            
        % Remove those without the extension
        elseif filter_on == true		
            if strendswith(file_list(i).name, ext_filter) == 0
                file_list(i) = [];
                i = i - 1;
            end
        end
        
        i = i + 1;
    end
    
    % Set the number of files
    num_files = length(file_list);
end

