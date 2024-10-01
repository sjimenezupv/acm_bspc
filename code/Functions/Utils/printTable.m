function printTable( M, table_tit, rowLabels, colLabels, th_up, th_dn, FID, numberFormat, colHdFormat, rowHdFormat )
%PRINTTABLE Prints the values of a matrix in a tabulated format
%   
% INPUTS:
%   M:            Matrix with the values to print
%
%   table_tit:    Title of the table
%                 Optional (Default='')
%
%   rowLabels:    Name for each row 
%                 Optional (Default=empty)
%
%   colLabels:    Name for each column 
%                 Optional (Default=empty)
%
%   umbral_up:    Maximum threshold of the values to print
%                 Optional (Default=Inf)
%
%   umbral_dn:    Minimum threshold of the values to print
%                 Optional (Default=-Inf)
%
%   FID:          File IDentifier, for printing to a file if needed
%                 Optional (Default=1)
%
%   numberFormat: Format of the numbers to print
%                 Optional (Default='%f')



    % Default values
    if nargin < 2; table_tit    =   []; end
    if nargin < 3; rowLabels    =   []; end
    if nargin < 4; colLabels    =   []; end
    if nargin < 5; th_up        =  Inf; end
    if nargin < 6; th_dn        = -Inf; end
    if nargin < 7; FID          =    1; end
    if nargin < 8; numberFormat = '%f\t'; end
    if nargin < 9; colHdFormat  = '%s\t'; end
    if nargin < 10; rowHdFormat = '%s\t'; end    
    
    imprimeTit = true;
    imprimeRHd = true;
    imprimeCHd = true;
    
    % Check empties
    if isempty(table_tit)
        imprimeTit = false;
    end
    if isempty(rowLabels)
        imprimeRHd = false;
    end
    if isempty(colLabels)
        imprimeCHd = false;
    end
    
    if imprimeTit == true
        fprintf(FID, '%s\n', table_tit);
    end
    
    [nrows, ncols] = size(M);
    fmt = numberFormat;
    
    if imprimeRHd == true
        max_rlbl_length = 0;        
        for i = 1 : length(rowLabels)
            if length(rowLabels{i}) > max_rlbl_length
                max_rlbl_length = length(rowLabels{i});
            end
        end
        max_rlbl_length = num2str(max_rlbl_length+4, '%d');
        rowHdFormat     = strcat('%-', max_rlbl_length, 's');
    end
    
    % Print column name
    if imprimeCHd == true        
        if imprimeRHd == true
            ESPACIO = ' ';
            fprintf(FID, rowHdFormat, ESPACIO);
        end        
        for i=1:ncols            
            fprintf(FID, colHdFormat, colLabels{i});
        end
        fprintf(FID, '\n');        
    end
    
    
    % Print data matrix
    str_out = '*';
    for r=1 : nrows
        
        if imprimeRHd == true
            fprintf(FID, rowHdFormat, rowLabels{r});
        end
        
        for c=1 : ncols
            
            value = M(r, c);
            if value >= th_dn && value <= th_up
                fprintf(FID, fmt, value);
            else
                fprintf(FID, '%18s', str_out);
            end
        end
        
        fprintf(FID, '\n');
    end
    fprintf('\n');
    
end