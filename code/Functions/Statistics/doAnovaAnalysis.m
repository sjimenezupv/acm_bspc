function [ fnameXLS ] = doAnovaAnalysis(DATA, FEATURE_NAMES, SAMPLE_NAMES, VARS_GROUP1, VARS_GROUP2, OUT_DIR, SheetName, plot_flag, alpha)
%DOANOVAANALYSIS Performs an ANOVA Analysis grouping data.
%
% AUTHOR: Santiago Jiménez [sanjiser@upv.es] 
%
%   INPUTS
%     DATA:          Matrix containing all the data.
%     FEATURE_NAMES: Cell array with the names of the columns/features.
%
%     SAMPLE_NAMES:  Cell array with the names of the rows in the form 
%                    [GROUP1].[GROUP2].[GROUP3]...
%
%     VARS_GROUP1:   Variables for the 1st Dimension of the Analysis.
%                    It can be empty ([]) if a unidimensional analysis 
%                    is desired using the VARS_GROUP2 variables.
%
%     VARS_GROUP2:   Variables for the 2nd Dimension of the Analysis.
%
%     OUT_DIR:       Path to the directory where to save Figures and files.
%
%     SheetName:     Name of the Excel Sheet to save the analysis on. 
%                    Optional. Default='S1'.
%
%     plot_flag:     Flag indicating whether to generate and save figures.
%                    Optional. Default=false. 
%
%     alpha:         Significance level alpha for the stat-tests
%                    to be considered statistical significative.
%                    Optional. Default=0.05
% 
% OUTPUTS
%          fnameXLS: Path to the generated XLSX file.



    % Default parameters
    if nargin < 7, SheetName = 'S1';  end
    if nargin < 8, plot_flag = false; end
    if nargin < 9, alpha     = 0.05;  end
    
    % DO NOT show warnings
    warning('off', 'all');
    
    % Default values
    if   plot_flag,  Display_Option = 'on';
    else             Display_Option = 'off';    end
    
    % Data sorting. Needed for paired-tests
    [ DATA, SAMPLE_NAMES ] = sortDataByRowIds( DATA, SAMPLE_NAMES );
    
    % Auxilar data files
    fname1     = [OUT_DIR, 'anovas1.txt'];
    fname2     = [OUT_DIR, 'anovas2.txt'];
    fnameXLS   = [OUT_DIR, 'AnovaAnalisis.xlsx'];
    
    % Open files
    fid1 = fopen(fname1, 'wt');
    fid2 = fopen(fname2, 'wt');
    
    % Auxiliare vars
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
    fprintf('====================== ANOVA Analysis ====================\n\n');    
    

    % Write file headers
    fprintf(fid1, '%-20s \t %-9s \t %-9s\n',                                                   'VarName', 'Anova1(F)', 'Anova1(P)');
    fprintf(fid2, '%-20s \t %-20s \t %-20s \t %-9s \t %-9s \t %-9s \t %-9s \t %-9s \t %-9s\n', 'VarName', 'G1', 'G2', 'AVG_G1', 'AVG_G2', 'IC1', 'MEAN_DIFF', 'IC2', 'P');


    
    % For each Feature/Column
    for k = 1 : NUM_FEATURES

        % Min & max values
        mn =  Inf;
        mx = -Inf;

        % Figures
        if plot_flag
            G1 = figure;
        end

        % Debugging...
        fprintf(1, 'Analizando Feature [%2d/%2d] - %s \n', k, NUM_FEATURES, FEATURE_NAMES{k} );
        
        % Row & column numbers for the subplots
        [nsf, nsc] = getBestSubplotSize( NUM_VARS_G1 );

        % For each 1st level group
        % Generate its value vectors, and second level class level
        for i = 1 : NUM_VARS_G1

            % Filter data belonging to that group
            if flag_agrupa1
                [ ~, mask_idx ] = getMaskStrCellContainsStr( SAMPLE_NAMES, VARS_GROUP1{i} );
            else
                mask_idx = 1:NUM_SAMPLES; % All data
            end

            % Values and Sample Names of the data from Group1
            sampleNamesAux = SAMPLE_NAMES(mask_idx);
            values         = DATA(mask_idx, k); % K-column

            % Group size
            nSamplesAux    = length(sampleNamesAux);    
            groupClass     = zeros(1, nSamplesAux);

            % We indicate which second-level group each sample from
            % the first-level group belongs to
            for j = 1 : NUM_VARS_G2
                [ ~, mi ]      = getMaskStrCellContainsStr( sampleNamesAux, VARS_GROUP2{j} );
                groupClass(mi) = j;
            end

            % NaN filtering
            filtro             = find(isnan(values));        
            values(filtro)     = [];
            groupClass(filtro) = [];

            % Update minimums & maximums
            mn = min([min(values), mn]);
            mx = max([max(values), mx]);

            % Offset to generate the graphs (5% of the mean)
            offset     = abs(mean(values))*0.05;

            % Boxplot generation
            if plot_flag == true
                figure(G1);
                subplot(nsf, nsc, i);
                boxplot(values, groupClass, 'Labels', VARS_GROUP2);
                ylabel(FEATURE_NAMES{k}, 'Interpreter', 'none');
                if flag_agrupa1
                    title(VARS_GROUP1{i}, 'Interpreter', 'none');
                end
                ylim([mn-offset, mx+offset])
                grid;
                set(findobj(gca,'Type','text'),'FontSize', 8)
            end


            % Anova-table generation
            gg = cell(1, length(groupClass));
            for jj = 1 : length(gg)
                gg{jj} = VARS_GROUP2{groupClass(jj)};
            end
            [p, t, stats] = anova1(values, gg, Display_Option);

            % If there are significant differences between any variable...
            if p < alpha


                % Perform the multicompare with the ANOVA statistics
                [c, m, h, nms] = multcompare(stats, 'Display', Display_Option);
                
                % Group-name
                if flag_agrupa1, str = [FEATURE_NAMES{k}, '.', VARS_GROUP1{i}];                    
                else             str = [FEATURE_NAMES{k}];                    end
                
                
                % Plot?
                if plot_flag
                    
                    % filename
                    fname = [OUT_DIR, 'MC.', SheetName, '.', str, '.png'];
                    
                    % Save figure %%%%%%%%%%%%%%%%%%%%%%%%
                    figure(h);
                    title(str, 'Interpreter', 'none');
                    print(h, '-dpng', '-r300', fname)
                end
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Print the exact variables that have significant differences,
                % their means, and the confidence intervals of the
                % mean differences, along with the P-value
                [n, ~] = size(c);
                for kk = 1 : n
                    if c(kk, end) < alpha
                        strG1 = VARS_GROUP2{c(kk, 1)};
                        strG2 = VARS_GROUP2{c(kk, 2)};
                        ic1   = c(kk, 3);
                        icAvg = c(kk, 4);
                        ic2   = c(kk, 5);
                        icP   = c(kk, 6);
                        avgG1 = m(c(kk, 1), 1);
                        avgG2 = m(c(kk, 2), 1);
                        fprintf(fid2, ...
                            '%-20s \t %-20s \t %-20s \t %8.4f\t %8.4f\t %8.4f\t %8.4f\t %8.4f\t %8.4f\n', ...
                            str, strG1, strG2, avgG1, avgG2, ic1, icAvg, ic2, icP);
                    end
                end

                F = t{2, 5};
                P = t{2, 6};
                fprintf(fid1, '%-20s \t %8.4f\t %8.4f\n', str, F, P);
            end
        end

        % All-boxplots
        if plot_flag
            fname = [OUT_DIR, 'BP.', SheetName, '.', FEATURE_NAMES{k}, '.png'];

            figure(G1);
            set(gcf, 'Position', get(0,'Screensize'));
            print(G1, '-dpng', '-r300', fname);
            close all; % Avoid too much windows open problem
        end
        
    end

    
    % Close auxiliar files
    fclose(fid1);
    fclose(fid2);



    %% Generate/Append XLS file with the results
    % XlsCheckIfOpen(fnameXLS, 'close');
    XlsClose();    
    T0 = createRawDataTable( DATA, FEATURE_NAMES, SAMPLE_NAMES );
    T1 = readtable(fname1, 'Delimiter', '\t');
    T2 = readtable(fname2, 'Delimiter', '\t');
    writetable(T0, fnameXLS, 'FileType', 'spreadsheet', 'Sheet', [SheetName, '_DATA'], 'WriteRowNames', true);
    writetable(T1, fnameXLS, 'FileType', 'spreadsheet', 'Sheet', [SheetName, '_ANOVA']);
    writetable(T2, fnameXLS, 'FileType', 'spreadsheet', 'Sheet', [SheetName, '_MULTCOMPARE']); 
    XlsDeleteDefaultSheets( fnameXLS );
    %XlsCheckIfOpen(fnameXLS, 'close');
    XlsClose();
    
    % Debugging: print anova results
    fprintf('\nANOVA ANALYSIS [%s]', SheetName);               type(fname1);    
    fprintf('\nANOVA MULTICOMPARE ANALYSIS [%s]', SheetName);  type(fname2);
    
    % Remove auxiliar files
    delete(fname1);
    delete(fname2);   
    
    fprintf('==========================================================\n');
    
    warning('on','all');

end