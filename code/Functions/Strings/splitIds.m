function [ table ] = splitIds( ids, delimiter )

    if nargin < 2
        delimiter = '.';
    end
    
    NI  = length(ids); % #ids
    NG  = 0;           % #groups
    
    
    % 1. Count the one with more groups
    for i = 1 : NI
        aux = length(strsplit(ids{i}, delimiter));
        if aux > NG
            NG = aux;
        end
    end
    
    % 2. Create the table
    table = cell(NI, NG);
    
    % 3. Fill the table
    for i = 1 : NI
        aux = strsplit(ids{i}, delimiter);
        for j = 1 : length(aux)
            table{i, j} = aux{j};
        end
    end

end

