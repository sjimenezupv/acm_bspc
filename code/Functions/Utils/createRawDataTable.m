function [ T ] = createRawDataTable( DATA, DATA_COL_NAMES, RowIds )
%CREATERAWDATATABLE Creates a raw datatable


    % Local variables
    [N_SAMPLES, N_COLS] = size(DATA);
    [N_COLNAMES]        = length(DATA_COL_NAMES);
    [N_ROWIDS]          = length(RowIds);
    
    % Test for Errors
    if N_SAMPLES ~= N_ROWIDS
        error('createRawDataTable :: N_SAMPLES ~= N_ROWIDS');
    end
    if N_COLS ~= N_COLNAMES
        error('createRawDataTable :: N_COLS ~= N_COLNAMES');
    end
    
    % Table with ids splitted by groups
    TableIds = splitIds(RowIds);
    
    % #columns for the Ids groups
    [~, N_IDS]   = size(TableIds);
    
    % #columns total
    NC = N_IDS+N_COLS;
    
    % Datatable
    TABLE = cell(N_SAMPLES, NC);
    
    % Fill groups' name
    IDS_COL_NAMES    = cell(N_IDS, 1);
    IDS_COL_NAMES{1} = 'ID';
    for i = 2 : N_IDS
        IDS_COL_NAMES{i} = strcat('G', num2str(i-1));
    end
    
    
    % Cell containing all the columns' names
    COL_NAMES = joinCellArrays( IDS_COL_NAMES, DATA_COL_NAMES );
    
    % Fill datatable
    for r = 1 : N_SAMPLES
        for c = 1 : N_IDS
            TABLE{r, c} = TableIds{r, c};            
        end
        
        idx = N_IDS+1;
        for c = 1 : N_COLS            
            TABLE{r, idx} = DATA(r, c);
            idx = idx+1;
        end
    end
    
    % Create output datatable
    T = cell2table(TABLE, 'VariableNames', COL_NAMES, 'RowNames', RowIds);
end

