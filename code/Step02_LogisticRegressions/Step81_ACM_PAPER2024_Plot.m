
% TFeatures var must exist 
% Last two columns must be 'class' and 'class_str'
% RowNames must be set


MY_DATA = table2array(TFeatures(:, 1:end-2));
CLASS   = table2array(TFeatures(:, end-1));

if iscell(MY_DATA), MY_DATA = cell2mat(MY_DATA); end
if iscell(CLASS),   CLASS   = cell2mat(CLASS);   end


%IND_TRAIN = [ 2,  4, 17, 25, 26];             % BE-ALL
IND_TRAIN = [ 4, 26, 23, 17, 22,  1,  5,  3];  % FS-ALL
%IND_TRAIN = [ 5, 6];                          % FS - WOMEN
%IND_TRAIN = [ 3,  4,  8,  9];                 % BE - WOMEN
%IND_TRAIN = [15,  9];                         % FS-MEN
%IND_TRAIN = [ 1, 12, 14]                      %BE-MEN
%IND_TRAIN = [ 1,  2,  3,  8]                  % FUERZA-BRUTA WOMEN


CLASS_TRAIN = CLASS;

%VERBOSE = true;
HEADERS = TFeatures.Properties.VariableNames;

DATA_CASOS = MY_DATA(CLASS==1, :);
DATA_CTRLS = MY_DATA(CLASS==0, :);


PatientNames_CASOS     = TFeatures.Properties.RowNames(CLASS==1);
PatientNames_CONTROLES = TFeatures.Properties.RowNames(CLASS==0);

NUM_CASOS     = sum(CLASS==1);
NUM_CONTROLES = sum(CLASS==0);

constant_flag = 'off';

DATA_TRAIN      = MY_DATA(:, IND_TRAIN);
[b, dev, stats] = glmfit(DATA_TRAIN, CLASS_TRAIN, 'binomial', 'link', 'logit', 'constant', constant_flag);

y_hat = glmval(b, DATA_TRAIN,  'logit',    'constant', constant_flag);
y_sc  = glmval(b, DATA_TRAIN,  'identity', 'constant', constant_flag);

% ROC Y THRESHOLD DETERMINATION WITH THE TRAINING SET
[~, ~, T, AUC] = perfcurve(CLASS_TRAIN, y_hat, 1);

% Search the best sens*spec relationship
umbral = getBestThreshold(T, y_hat, CLASS_TRAIN);    
g_tr = y_hat >= umbral;    
[cm, sens, esp, vpp, vpn, rvp, rvn, g] = myconfusion(CLASS_TRAIN, g_tr);

CT0 = CLASS_TRAIN == 0;
CT1 = CLASS_TRAIN == 1;

VERBOSE = true;
if  VERBOSE == false
    return;
end

%%
fprintf('\n THRESHOLD \t\t\t %f \n AUC \t\t\t\t %f \n SENSITIVITY \t\t %f \n SPECIFICITY \t\t %f \n G(sqrt(SEN*SPE)) \t %f \n\n', umbral, AUC, sens, esp, g);
ic = 1.96 .* stats.se;
MM = [               ...
	stats.beta,      ...
	stats.beta - ic, ...
	stats.beta + ic, ...
	stats.p,         ...
	stats.t,         ...
	stats.se];

VarNamesAux = HEADERS(IND_TRAIN);

col_hd = {'beta', 'beta_inf', 'beta_sup', 'p', 't', 'se'};
row_hd = cell(length(VarNamesAux)+1, 1);
for i = 0 : length(VarNamesAux)
    if i == 0 
        if strcmp(constant_flag, 'on') == 1
            row_hd{i+1} = '(b0)';
        end
    else
        kk = i;
        if strcmp(constant_flag, 'on') == 1
            kk = kk + 1;
        end
        row_hd{kk} = ['(b', num2str(i),')-', VarNamesAux{i}];
    end
end


printTable(MM, 'Logistic-Regression Parameters', row_hd, col_hd, Inf, -Inf, 1, '%12.6f', '%12s' );

if false
    printTable(y_hat(CT0), [], [], {'Y_hat(CONTROLS)'}, Inf, -Inf, 1, '%12.6f');
    printTable(y_hat(CT1), [], [], {'Y_hat(PACIENTS)'}, Inf, -Inf, 1, '%12.6f');

    printTable( DATA_CASOS(:, IND_TRAIN), 'PACIENTS', PatientNames_CASOS,     VarNamesAux, Inf, -Inf, 1, '%10.6f' );
    printTable( DATA_CTRLS(:, IND_TRAIN), 'CONTROLS', PatientNames_CONTROLES, VarNamesAux, Inf, -Inf, 1, '%10.6f' );
end




%% Forward Selection
hFig = figure(1);
hold on;

x = -8: 0.1 : 8;
y1 = x;
y2 = x;
y1(~isnan(x)) = 1;
y2(~isnan(x)) = umbral;


scatter(y_sc(CT0), y_hat(CT0), 'bo', 'filled');
scatter(y_sc(CT1), y_hat(CT1), 'r^', 'filled');
plot([-7.7, 7.7], [umbral, umbral], 'k--', 'LineWidth', 2.0);
[hhh, ~] = legend('Control', 'LV-ACM', 'Best threshold', 'Location', 'NorthWest', 'Interpreter', 'Latex', 'FontSize', 12);
xlabel('{\emph{Ln(Odds)}}', 'Interpreter', 'Latex', 'FontSize', 16);
ylabel('\emph{p(LV-ACM Positive)}',            'Interpreter', 'Latex', 'FontSize', 16);
title( '{\textbf{LV-ACM} Risk Score - \emph{Forward-Selection} model}',    'Interpreter', 'Latex', 'FontSize', 17);
grid


 a1 = area(x, y1, 'basevalue', 0, 'FaceColor','y', 'LineStyle', ':');
 a2 = area(x, y2, 'basevalue', 0, 'FaceColor','#4DBEEE', 'LineStyle', ':');
 
 a1.FaceAlpha = 0.1;
 a2.FaceAlpha = 0.1;


hold off;

w = 800;
h = 450;
set(hFig, 'Position', [100 100 w h]);

png_file= [SaveDir, 'REG_LOG.ALLDATA.FS.PAPER2024.V02.png'];
print(1, '-dpng', '-r600', png_file);

