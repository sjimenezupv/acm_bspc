%% Filter samples
Step01_Params_b_SamplesFiltering;

%% Local Variables
%SaveDir   = 'D:/GitHub/acm_bspc/results/';
%SheetName = 'PAPER2024_ACM';
%alpha     = 0.01;


%%


% Analysis
VarNames = T2.Properties.VariableNames;
N_Vars   = length(VarNames);

[nr, nc] = getBestSubplotSize(N_Vars);
a        = class;
b        = class_str;
features = [];

close all;

for i = 1 : N_Vars   
    if iscell(T2.(VarNames{i}))
        x = cell2mat(T2.(VarNames{i}));
    else
        x = T2.(VarNames{i});
    end
    features = [features, x];    
end

%% Statistical Analysis
kk ={class_str, {'.'}, FileId};
rowIds = strcat(kk{:, 3}, kk{:, 2}, kk{:, 1});

VARS_GROUP1 = [];
VARS_GROUP2 = unique(class_str);
[ fnameXLS, TStats ] = doStatisticAnalysis( features, VarNames, rowIds, VARS_GROUP1, VARS_GROUP2, SaveDir, SheetName, alpha );


%% Counts the number of samples in each group
for i = 1 : length(VARS_GROUP2)
    vg = VARS_GROUP2{i};
    num_c = sum(strcmp(class_str, vg) == 1);
    fprintf('#%8s: %d \n', vg, num_c);
end
fprintf('# Samples: %d\n', length(class_str));




%% Create Features Table
if isempty(TStats.VarName)
    return;
end

SignificantVars = strtrim(TStats.VarName);
[ TFeatures ]   = getFeaturesTable( T2, SignificantVars, class, class_str, FileId );
save([SaveDir, SheetName, 'TFeatures.mat'], 'TFeatures');


%% Final Boxplots?
return; %%%% UNTIL WE HAVE THE FINAL RESULTS
plotBoxPlots( T2, class_str, SignificantVars, SaveDir, SheetName );
