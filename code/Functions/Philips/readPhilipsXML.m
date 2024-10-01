function [ Y, Fs, ID, years, sex ] = readPhilipsXML( xml_path, save_mat_flag )
%READPHILIPSXML Reads an ECG-file in XML Philips format, saving a copy in .mat format
% 
% INPUTS
%        xml_path:      Path to XML file
%        save_mat_flag: Flag indicating whether to generate the corresponding .mat file
%                       from the XML if it does not exist, for faster subsequent readings.
%                       (Default: true)
%
% OUTPUTS
%       Y : ECG-data matrix (N_SAMPLES X N_CHANELS) with original XML data
%       Fs: Sampling frequency
%       ID: Filename (without extensión nor folder).
%
% AUTHOR
%       Santiago Jiménez-Serrano (sanjiser@i3m.upv.es)
%

    
	% Default parameters
    if nargin < 2
        save_mat_flag = true;
    end

    % File identifier
    [~, ID] = fileparts(xml_path);
    
    % Get the .mat path corresponding to this xml
    mat_path = strrep(xml_path, '.xml', '.mat');
	
	% Check if exist or not the .mat file
    if ~exist(mat_path, 'file')

		% Read the XML file
        % WARNING:
        %   If some error happens, check that your XML file 
        %   DOES NOT contain 'accent marks' or non-ASCII characters
        [Y, Fs, years, sex] = read_ECG_XML(xml_path);

		% Save the .mat file format if needed
        if save_mat_flag == true
            save(mat_path, 'ID', 'Fs', 'Y', 'years', 'sex');
        end
        
    else
	
		% .mat file exists; load it
        S     = load(mat_path);
        Y     = S.Y;
        Fs    = S.Fs;
        years = S.years;
        sex   = S.sex;

    end        

end

