function  [ fnameXLS, T1 ] = doStatisticAnalysis( DATA, FEATURE_NAMES, SAMPLE_NAMES, VARS_GROUP1, VARS_GROUP2, OUT_DIR, SheetName, alpha )
%DOSTATISTICANALYSIS Performs an statistical analysis
% 
% [ fnameXLS ] = doStatisticAnalysis( DATA, FEATURE_NAMES, SAMPLE_NAMES, VARS_GROUP1, VARS_GROUP2, DIR_FIG, SheetName, alpha )
% AUTHOR: Santiago Jiménez [sanjiser@upv.es] 
%
%  Performs an statistical analysis
% 
%   INPUTS
%
%     DATA:          Input data matrix
%
%     FEATURE_NAMES: Cell with the names for the Columns/Features
%
%     SAMPLE_NAMES:  Cell with the names for the rows in the form
%                    [GROUP1].[GROUP2].[GROUP3]...
%
%     VARS_GROUP1:   Variables for the 1st analysis dimension.
%                    It could be empty ([]) if we want an unidimensional
%                    analysis with VARS_GROUP2 variables.
%
%     VARS_GROUP2:   Variables for the 2nd analysis dimension.
%
%     OUT_DIR:       Output folder.
%
%     SheetName:     Excel Sheet name. (Optional, default='S1')
%                    alpha: Alpha significance value for statistical tests. 
%                    (Optional, default=0.05).
% 
% OUTPUTS
%          fnameXLS: Path to the generated XLSX file
%

    % Default parameters
    if nargin < 7, SheetName = 'S1'; end
    if nargin < 8, alpha    = 0.05;  end
    
    % Do not show warnings
    warning('off', 'all');

    % Sort data: Necessary in pair-tests
    [ DATA, SAMPLE_NAMES ] = sortDataByRowIds( DATA, SAMPLE_NAMES );
    
    % File names
    fname    = [OUT_DIR, 'stats.txt'];
    fnameXLS = [OUT_DIR, 'StatsAnalisis.xlsx'];
    
    % Open file
    fid = fopen(fname, 'w');
    
    % Auxiliar variables
    [NUM_SAMPLES, NUM_FEATURES] = size(DATA);    
    NUM_VARS_G1                 = length(VARS_GROUP1);
    NUM_VARS_G2                 = length(VARS_GROUP2);
    
    if NUM_VARS_G1 == 0
        NUM_VARS_G1 = 1;
        VARS_GROUP1 = {'VALUES'};
        flag_agrupa1 = false;
    else
        flag_agrupa1 = true;
    end    
    
    % Debug
    fprintf('=================== STATISTICAL ANALYSIS ==============\n\n');    

    % Write stats header
    fprintf(fid, '%-20s \t %-20s \t %-20s \t %-9s \t %-9s \t %-9s \t %-9s \t %-9s \t %-9s \t %-9s \t %-9s \t %-9s \t %-9s \t %-9s \t %-9s \t %-9s\n', ...
        'VarName',             ...
        'G1',        'G2',     ...
        'AVG_G1',    'STD_G1', ...
        'AVG_G2',    'STD_G2', ...
        'PTTEST2',   'PRANKSUM',  'PCHI2',      'PANOVA1', ...
        'PKSTESTG1', 'PKSTESTG2', 'PLILTESTG1', 'PLILTESTG2', ...
        'PTTEST');

    % for each Features...
    for k = 1 : NUM_FEATURES


        % Debugging...
        fprintf(1, 'Analizing Feature [%2d/%2d] - %s \n', k, NUM_FEATURES, FEATURE_NAMES{k} );
        

        % For each 1st level group
        % Generate the vector with values and classes for 2nd level
        for i = 1 : NUM_VARS_G1

            % Filter data belonging to this group
            if flag_agrupa1
                [ ~, mask_idx ] = getMaskStrCellContainsStr( SAMPLE_NAMES, VARS_GROUP1{i} );
            else
                mask_idx   = 1:NUM_SAMPLES; % Todos los datos
            end

            % Values and name of the Group1 samples
            sampleNamesAux = SAMPLE_NAMES(mask_idx);
            values         = DATA(mask_idx, k); % k-column

            % Size for this group
            nSamplesAux    = length(sampleNamesAux);    
            groupClass     = zeros(nSamplesAux, 1);
            
            % Group name
            if flag_agrupa1, str = [FEATURE_NAMES{k}, '.', VARS_GROUP1{i} ];
            else             str = [FEATURE_NAMES{k}];  end

            % Indicate to which 2nd level group belongs each sample of the 1st level group
            for j = 1 : NUM_VARS_G2
                [ ~, mi ]      = getMaskStrCellContainsStr( sampleNamesAux, VARS_GROUP2{j} );
                groupClass(mi) = j;
            end

            % Filter NaNs
            filtro             = find(isnan(values));        
            values(filtro)     = [];
            groupClass(filtro) = [];


            % Generate the statistics
            [ Stats, ClassPairs ] = getStatisticTestsMultiClass( values, groupClass, alpha );           


            for j = 1 : length(Stats)
                
                % If it exist statistical significance among one variable
                if Stats{j}.ExistenDifSignificativas == true
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % Variable names
                    strG1 = VARS_GROUP2{ClassPairs(j, 1)};
                    strG2 = VARS_GROUP2{ClassPairs(j, 2)};

                    % statistic tests results
                    fprintf(fid, '%-20s \t %-20s \t %-20s \t %8.4f\t %8.4f\t %8.4f\t %8.4f\t %8.7f\t %8.7f \t %8.7f\t %8.7f\t %8.7f\t %8.7f\t %8.7f\t %8.7f', ...
                            str, strG1, strG2,             ...
                            Stats{j}.XMean, Stats{j}.XStd, ...
                            Stats{j}.YMean, Stats{j}.YStd, ...                    
                            Stats{j}.p_ttest2,             ...
                            Stats{j}.p_ranksum,            ...
                            Stats{j}.p_chi2,               ...
                            Stats{j}.p_anova1,             ...
                            Stats{j}.p_kstestX,            ...
                            Stats{j}.p_kstestY,            ... 
                            Stats{j}.p_litestX,            ... 
                            Stats{j}.p_litestY             ... 
                            );
                        
                    if isfield(Stats{j}, 'p_ttest')
                        fprintf(fid, '\t %8.4f', Stats{j}.p_ttest);
                    else 
                        fprintf(fid, '\t %8.4f', NaN);
                    end
                    fprintf(fid, '\n');
                end
            end
        end


    end

    
    % Close auxiliar file
    fclose(fid);



    %% Generate/Append XLS file with the results  %%%%%%%%%%%%%%%%%%%%%%%%%
    %XlsCheckIfOpen(fnameXLS, 'close');
    XlsClose();    
    T0 = createRawDataTable( DATA, FEATURE_NAMES, SAMPLE_NAMES );
    T1 = readtable(fname, 'Delimiter', '\t');
    writetable(T0, fnameXLS, 'FileType', 'spreadsheet', 'Sheet', [SheetName, '_DATA'], 'WriteRowNames', true);
    writetable(T1, fnameXLS, 'FileType', 'spreadsheet', 'Sheet', [SheetName, '_STATS']); 
    XlsDeleteDefaultSheets( fnameXLS );
    %XlsCheckIfOpen(fnameXLS, 'close');
    XlsClose();
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Debugging, Print in console the Anova results
    fprintf('\nSTATISTICS MULTICOMPARE ANALYSIS [%s]', SheetName); 
    type(fname);
    
    % Remove the auxiliar files
    %delete(fname);
    fprintf('==========================================================\n');
    
    warning('on', 'all');
end

