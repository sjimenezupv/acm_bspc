function [ Stats ] = doCaseCtrlAnalysis( DATA_CASOS, DATA_CTRLS, HEADERS, FIGURES_DIR, alpha )
%DOCASECTRLANALYSIS Performs a Case vs Control Statistical Analysis
% 
% [ Stats ] = doCaseCtrlAnalysis( DATA_CASOS, DATA_CTRLS, HEADERS, FIGURES_DIR, alpha )
% AUTHOR: Santiago Jiménez [sanjiser@upv.es]
%
% Performs a Case vs Control Statistical Analysis
%
% INPUTS
%   DATA_CASOS:  Matrix containing the data of the Cases.
%   DATA_CTRLS:  Matrix containing the data of the Controls.
%   HEADERS:     Names of the columns/Features/Characteristics.
%   FIGURES_DIR: Directory to save the figures (Optional).
%   alpha:       Significance level alpha for the tests to be considered significant. 
%                Optional. Default=0.05. 
%
% OUTPUTS
%   Stats: Struct containing the statistics of the input data.

%

    % Default input parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    plot_flag = nargin >= 4 && ~isempty(FIGURES_DIR);
    if nargin < 5, alpha = 0.05; end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Local variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [N_CASOS, N_F1] = size(DATA_CASOS);
    [N_CTRLS, N_F2] = size(DATA_CTRLS);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fprintf('\n============= Cases VS Controls Analysis ================');
    printHeader(N_CASOS, N_CTRLS, N_F1);
    
    if N_F1 ~= N_F2
        error('N_FEATURES1 ~= N_FEATURES2');
    end
    
    Stats = getStatisticTestsM( DATA_CASOS, DATA_CTRLS, alpha );    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %% Summary of vars statistical significant %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    print_flag = true;    
    for i = 1 : N_F1
        if Stats{i}.p_ttest2 < alpha
            printTestHeader('ttest2', alpha, print_flag);
            fprintf('%25s \t %.10f \n', HEADERS{i}, Stats{i}.p_ttest2);
            print_flag = false;
        end
    end

    print_flag = true;
    for i = 1 : N_F1
        if Stats{i}.p_ranksum < alpha
            printTestHeader('ranksum', alpha, print_flag)
            fprintf('%25s \t %.10f \n', HEADERS{i}, Stats{i}.p_ranksum);
            print_flag = false;
        end
    end    
    
    print_flag = true;
    for i = 1 : N_F1
        if Stats{i}.p_chi2 < alpha
            printTestHeader('chi^2', alpha, print_flag);
            fprintf('%25s \t %.10f \n', HEADERS{i}, Stats{i}.p_chi2);
            print_flag = false;
        end
    end
    
    print_flag = true;
    for i = 1 : N_F1
        if Stats{i}.p_anova1 < alpha
            printTestHeader('anova1', alpha, print_flag);
            fprintf('%25s \t %.10f \n', HEADERS{i}, Stats{i}.p_anova1);
            print_flag = false;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %% Summary normal variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    print_flag = true;
    for i = 1 : N_F1
        if Stats{i}.p_kstestX > alpha || Stats{i}.p_kstestY > alpha
            printNormalTestHeader('kstest', alpha, print_flag);
            fprintf('%25s \t %.4f \t %.4f \n', HEADERS{i}, Stats{i}.p_kstestX, Stats{i}.p_kstestY);
            print_flag = false;
        end
    end
    
    print_flag = true;
    for i = 1 : N_F1
        if Stats{i}.p_litestX > alpha || Stats{i}.p_litestY > alpha
            printNormalTestHeader('lillietest', alpha, print_flag);
            fprintf('%25s \t %.4f \t %.4f \n', HEADERS{i}, Stats{i}.p_litestX, Stats{i}.p_litestY);
            print_flag = false;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %% Avg & Std %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    if plot_flag
        class       = [zeros(N_CASOS, 1)+1; zeros(N_CTRLS, 1)+2];
        G           = figure;
    end
    
    fprintf('\nAvg ± Std         \tCASES            \tCONTROLS     \t p-ttest2     \t p-ranksum     \t p-chi2      \t p-anova1 \n');
    for i = 1 : N_F1
        
        fprintf('%-20s  %-8.5f±%7.5f \t %-8.5f±%7.5f \t %.10f \t %.10f \t %.10f \t %.10f \n', ...
                            HEADERS{i}, ...
                            Stats{i}.XMean, Stats{i}.XStd, ...
                            Stats{i}.YMean, Stats{i}.YStd, ...
                            Stats{i}.p_ttest2,             ...
                            Stats{i}.p_ranksum,            ...
                            Stats{i}.p_chi2,               ...
                            Stats{i}.p_anova1              ...
                            );
        
        
        if plot_flag
            data = [DATA_CASOS(:, i); DATA_CTRLS(:, i)];
            figure(G);
            boxplot(data, class, 'labels', {'CASES', 'CONTROLS'});
            title([HEADERS{i}], 'Interpreter', 'none');
            grid;
            saveas(G, [FIGURES_DIR, 'XBP_', HEADERS{i}, '.png'], 'png');
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %% Final Info %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    printHeader(N_CASOS, N_CTRLS, N_F1);
    fprintf('==========================================================\n');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

%% Funciones Auxliares %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function printTestHeader(strTestName, alpha, print_flag)
    if print_flag
        fprintf('\nDiffs (%s, P<%f)\n', strTestName, alpha);
        fprintf('                 Variable \t p-value\n');
    end
end

function printNormalTestHeader(strTestName, alpha, print_flag)
    if print_flag
        fprintf('\nNormal (%s, P>%f)\n', strTestName, alpha);
        fprintf('                 Variable \t p-value-cases \t p-values-ctrls\n');
    end
end

function printHeader(N_CASOS, N_CTRLS, N_F)
    fprintf('\n');
    fprintf('#CASES    = %d\n', N_CASOS);
    fprintf('#CONTROLS = %d\n', N_CTRLS);
    fprintf('#FEATURES = %d\n', N_F);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
