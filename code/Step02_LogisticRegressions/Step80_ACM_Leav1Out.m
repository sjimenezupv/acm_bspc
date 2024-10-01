
% TFeatures var must exist 
% Last two columns must be 'class' and 'class_str'
% RowNames must be set


MY_DATA = table2array(TFeatures(:, 1:end-2));
CLASS   = table2array(TFeatures(:, end-1));

if iscell(MY_DATA), MY_DATA = cell2mat(MY_DATA); end
if iscell(CLASS),   CLASS   = cell2mat(CLASS);   end
CLASS_TRAIN = CLASS;


HEADERS = TFeatures.Properties.VariableNames;


DATA_CASOS = MY_DATA(CLASS==1, :);
DATA_CTRLS = MY_DATA(CLASS==0, :);


PatientNames_CASOS     = TFeatures.Properties.RowNames(CLASS==1);
PatientNames_CONTROLES = TFeatures.Properties.RowNames(CLASS==0);

NUM_CASOS     = sum(CLASS==1);
NUM_CONTROLES = sum(CLASS==0);

constant_flag = 'off';
num_folds     = length(CLASS);

%%
yh     = zeros(num_folds, 1);
cihat  = zeros(num_folds, 1);

opts = statset('glmfit');
opts.MaxIter = 200; % default value for glmfit is 200.


for i = 1 : num_folds

    DATA_TRAIN       = MY_DATA(:, IND_TRAIN);
    DATA_TEST        = DATA_TRAIN(i, :);
    DATA_TRAIN(i, :) = [];
        
    CLASS_TRAIN = CLASS;
    CLASS_TEST  = CLASS(i);
    CLASS_TRAIN(i) = [];
    
    % Train
    [b, dev, stats] = glmfit(DATA_TRAIN, CLASS_TRAIN, 'binomial', 'link', 'logit', 'constant', constant_flag, 'options', opts);
    y_hat           = glmval(b, DATA_TRAIN,  'logit', 'constant', constant_flag);    
    [~, ~, T]       = perfcurve(CLASS_TRAIN, y_hat, 1);
    
    % Search for the best sen*esp relationship
    umbral = getBestThreshold(T, y_hat, CLASS_TRAIN);

    % Test
    yh(i)    = glmval(b, DATA_TEST,  'logit', 'constant', constant_flag);    
    cihat(i) = yh(i) >= umbral;

end


[~, ~, ~, auc] = perfcurve(CLASS, yh, 1);    
[~, sen, esp, ~, ~, ~, ~, g, acc, ~, ~, ic] = myconfusion(CLASS, cihat);

fprintf('L-1-OUT [G, SEN, ESP, AUC, ACC, IC]=[%.4f, %.4f, %.4f, %.4f, %.4f, %.4f] IDX = [', g, sen, esp, auc, acc, ic);
for i = 1 : length(IND_TRAIN)
    if i < length(IND_TRAIN)
        fprintf('%2d, ', IND_TRAIN(i));
    else
        fprintf('%2d] \n ', IND_TRAIN(i));
    end
end
