function [ Stats, PVector, MeanVector, StdVector ] = getStatisticTests( x, y, alpha )
%GETSTATISTICTESTS % Gets the P-values from the basic statistical tests between two vectors
%
% [ Stats, PVector, MeanVector, StdVector ] = getStatisticTests( x, y, alpha )
%  AUTHOR: Santiago Jiménez [sanjiser@upv.es]
%
% Gets the P-values from the basic statistical tests between two vectors
%
%   INPUTS
%       x: Vector 1
%       y: Vector 2
%   alpha: Significance level alpha for the stat-tests
%          to be considered statistical significative.
%          Optional. Default=0.05
%
%   OUTPUTS
%       Stats: Struct containing the next fields
%         p_kstestX : p-value of the kstest normality test (variable X)
%         p_kstestY : p-value of the kstest normality test (variable Y)
%         p_litestX : p-value of the lillietest normality test (variable X)
%         p_litestY : p-value of the lillietest normality test (variable Y)
%         p_ttest2  : P-value of the ttest2 test for differences between two samples on variables (x, y)
%         p_ttest   : P-value of the ttest test for differences between two
%                     samples on variables (x, y) (Only included if x and y 
%                     have the same size). Assumes that x and y are "two matched samples."
%         p_ranksum : P-value of the ranksum test for differences between two samples on variables (x, y)
%         p_chi2    : P-value of the chi^2 test for differences between two samples on variables (x, y)
%         p_anova1  : P-value of the anova1 test for differences between two samples on variables (x, y)
%         h_[test]  : Same as the above values, but with the h variable indicating acceptance or rejection of the hypothesis
%         XMean     : Mean of x
%         YMean     : Mean of y
%         XStd      : Standard deviation of x
%         YStd      : Standard deviation of y
% 
%         PVector : Vector with the P-values of the tests ordered as follows
%                    PVector = [Stats.p_ttest2, 
%                               Stats.p_ranksum,
%                               Stats.p_chi2,
%                               Stats.p_anova1,
%                               Stats.p_kstestX, Stats.p_kstestY,
%                               Stats.p_litestX, Stats.p_litestY,
%                               Stats.p_ttest];
%                 PVector will only contain the value Stats.p_ttest if and only 
%                 if the x and y samples have the same size, since it is a paired test.
%
%         MeanVector : Vector with the mean values of each vector x and y
%                      MeanVector = [Stats.XMean, Stats.YMean];
%
%         StdVector  : Vector with the standard deviation values of each vector x and y
%                      StdVector  = [Stats.XStd, Stats.YStd];


    if nargin < 3, alpha = 0.05; end

    warning('off', 'all');
    
    Stats = [];
    
    x(isnan(x)) = [];
    y(isnan(y)) = [];
    
    % Means
    Stats.XMean = mean(x);
    Stats.YMean = mean(y);
    
    % Std
    Stats.XStd = std(x);
    Stats.YStd = std(y);

    % Normal
    [Stats.h_kstestX, Stats.p_kstestX] = kstest(zscore(x));
    [Stats.h_kstestY, Stats.p_kstestY] = kstest(zscore(y));

    [Stats.h_litestX, Stats.p_litestX] = getLillietest(x);
    [Stats.h_litestY, Stats.p_litestY] = getLillietest(y);


    % Diffs among distributions
    [Stats.p_ranksum, Stats.h_ranksum] = ranksum(x, y);
    [Stats.h_ttest2,  Stats.p_ttest2]  = ttest2(x, y);
    
    % T-test Paired (only for equals size samples)
    if length(x) == length(y)
        [Stats.h_ttest, Stats.p_ttest] = ttest(x, y);
    end

    % Chi^2 test
    dt    = [x; y];
    class = [zeros(length(x), 1); ones(length(y), 1)];
    [~, ~, Stats.p_chi2] = crosstab(dt, class);
    
    
    
    % One-Way Anova
    Stats.p_anova1 = anova1(dt, class, 'off');
    
    PVector = [Stats.p_ttest2,                   ...
               Stats.p_ranksum,                  ...
               Stats.p_chi2,                     ...
               Stats.p_anova1,                   ...
               Stats.p_kstestX, Stats.p_kstestY, ...
               Stats.p_litestX, Stats.p_litestY];
           
   MeanVector = [Stats.XMean, Stats.YMean];
   StdVector  = [Stats.XStd, Stats.YStd];
   
   
   
    % if Stats.p_ttest2  < alpha || ...
    %    Stats.p_ranksum < alpha || ...
    %    Stats.p_chi2    < alpha || ...
    %    Stats.p_anova1  < alpha 
    if Stats.p_ttest2  < alpha
        Stats.ExistenDifSignificativas = true;       
    else
        Stats.ExistenDifSignificativas = false;
    end   

    warning('on', 'all');
end

function [h, p] = getLillietest(x)

    try
        [h, p] = lillietest(x);
    catch %err
        %fprintf('ERROR: getStatisticTests::getLillietest(x) \nx=\n');
        %disp(x);
        %err
        h = 0;
        p = 0.5;        
    end

end

