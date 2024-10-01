% Utility script

y  = ACM_T.Years;
s  = ACM_T.Sex;
cl = ACM_T.Affected;
n  = length(y);

age   = zeros(n, 1);
c     = zeros(n, 1);
c_str = cell(n-1, 1);

for i = 1 : n
    age(i) = y{i};
    c(i)   = cl{i};
end

cage = c;
cage(isnan(age)) = [];
age(isnan(age))  = [];

fprintf('Age(+): %.1f +- %.1f \n', mean(age(cage==1)), std(age(cage==1)));
fprintf('Age(-): %.1f +- %.1f \n', mean(age(cage==0)), std(age(cage==0)));

f_mal_acm = strcmp(s(c==1), 'Male')  ==1;
f_mal_ctr = strcmp(s(c==0), 'Male')  ==1;
f_fem_acm = strcmp(s(c==1), 'Female')==1;
f_fem_ctr = strcmp(s(c==0), 'Female')==1;

fprintf('Age male(+): %.1f +- %.1f \n', mean(age(f_mal_acm)), std(age(f_mal_acm)));
fprintf('Age male(-): %.1f +- %.1f \n', mean(age(f_mal_ctr)), std(age(f_mal_ctr)));
fprintf('Age fem (+): %.1f +- %.1f \n', mean(age(f_fem_acm)), std(age(f_fem_acm)));
fprintf('Age fem (-): %.1f +- %.1f \n', mean(age(f_fem_ctr)), std(age(f_fem_ctr)));

np      = sum(c == 1);
nn      = sum(c == 0);
np_male = sum(strcmp(s(c==1), 'Male')  ==1);
np_fema = sum(strcmp(s(c==1), 'Female')==1);
nn_male = sum(strcmp(s(c==0), 'Male')  ==1);
nn_fema = sum(strcmp(s(c==0), 'Female')==1);

fprintf('Male(+): %d/%d (%%%f)\n', np_male, np, (np_male/np)*100);
fprintf('Male(-): %d/%d (%%%f)\n', nn_male, nn, (nn_male/nn)*100);
fprintf('Fema(+): %d/%d (%%%f)\n', np_fema, np, (np_fema/np)*100);
fprintf('Fema(-): %d/%d (%%%f)\n', nn_fema, nn, (nn_fema/nn)*100);



for i = 1 : n-1
    if cage(i) == 0
        c_str{i} = 'Control';
    else
        c_str{i} = 'ACM';
    end
end


units       = '';
lblFontSize = 16;
titFontSize = 16;


% Plot Individual
h = figure(1); 
set(h, 'DefaultTextFontSize', lblFontSize);
bh = boxplot(age, c_str)
set(gca,'FontSize',12);
bp = gca;
bp.XAxis.TickLabelInterpreter = 'latex';
grid
title('Age', 'FontSize', titFontSize, 'Interpreter', 'latex');
