function [ fnameStatsXLS, fnameAnovaXLS ] = doAnalysis(DATA, FEATURE_NAMES, SAMPLE_NAMES, VARS_GROUP1, VARS_GROUP2, OUT_DIR, SheetName, plot_flag, alpha)
%DOANALYSIS Performs a complete Statistical Analysis and ANOVA grouping data.
%
% [ fnameStatsXLS, fnameAnovaXLS ] = doAnalysis( DATA, FEATURE_NAMES, SAMPLE_NAMES, VARS_GROUP1, VARS_GROUP2, DIR_FIG, SheetName, plot_flag, alpha ) 
% AUTHOR: Santiago Jiménez [sanjiser@upv.es] 
%
%  Performs a complete Statistical Analysis and ANOVA, grouping the data from the rows of the DATA matrix.
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
    
    % 1 - Statistical analysis
    fnameStatsXLS =             ...
        doStatisticAnalysis(    ...
                 DATA,          ...
                 FEATURE_NAMES, ...
                 SAMPLE_NAMES,  ...
                 VARS_GROUP1,   ...
                 VARS_GROUP2,   ...
                 OUT_DIR,       ...
                 SheetName,     ...
                 alpha);
                 
    % 2 - Anova analysis
    fnameAnovaXLS =             ...
        doAnovaAnalysis(        ...
                 DATA,          ...
                 FEATURE_NAMES, ...
                 SAMPLE_NAMES,  ...
                 VARS_GROUP1,   ...
                 VARS_GROUP2,   ...
                 OUT_DIR,       ...
                 SheetName,     ...
                 plot_flag,     ...
                 alpha);
    

end

