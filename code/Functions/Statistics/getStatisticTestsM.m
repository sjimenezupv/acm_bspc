function [ Stats, PMatrix, MeanMatrix, StdMatrix ] = getStatisticTestsM( Mx, My, alpha )
%GETSTATISTICTESTSM Obtains the basic statistics between each pair of columns in matrices Mx and My
%
% [ Stats, PMatrix, MeanMatrix, StdMatrix ] = getStatisticTestsM( Mx, My, alpha )
% AUTHOR: Santiago Jiménez [sanjiser@upv.es]
%
% Obtains the P-values of the basic statistical tests between each pair
% of columns in matrices Mx and My.
% 
%   INPUTS
%      Mx: Matrix x. (N_samples x NFeatures)
%      My: Matrix y. (M_samples x NFeatures)
%   alpha: Optional. Default=0.05. Significance level alpha for the tests to be considered significant.
%
%   OUTPUTS
%       Stats: Cell array of NFeatures structures with the following fields (one per column)
%         p_kstestX : P-value of the kstest normality test on variable X
%         p_kstestY : P-value of the kstest normality test on variable Y
%         p_litestX : P-value of the lillietest normality test on variable X
%         p_litestY : P-value of the lillietest normality test on variable Y
%         p_ttest2  : P-value of the ttest2 test for differences between two samples on variables (x, y)
%         p_ttest   : P-value of the ttest test for differences between two
%                     samples on variables (x, y) (Only included if samples
%                     x and y are of equal size). Assumes that x and y
%                     are "two matched samples."
%         p_ranksum : P-value of the ranksum test for differences between two samples on variables (x, y)
%         p_chi2    : P-value of the chi^2   test for differences between two samples on variables (x, y)
%         p_anova1  : P-value of the anova1  test for differences between two samples on variables (x, y)
%         h_[test]  : Same as the above values, but with the h variable indicating acceptance or rejection of the hypothesis
%         XMean     : Mean of x
%         YMean     : Mean of y
%         XStd      : Standard deviation of x
%         YStd      : Standard deviation of y
% 
%      PMatrix : Matrix of (NFeatures x [8|9]) with the P-values of the
%                tests ordered as follows in each row:
%                 PVector = [Stats.p_ttest2, 
%                            Stats.p_ranksum,
%                            Stats.p_chi2,
%                            Stats.p_anova1,
%                            Stats.p_kstestX, Stats.p_kstestY,
%                            Stats.p_litestX, Stats.p_litestY,
%                            Stats.p_ttest];
%                 PVector will only contain the value Stats.p_ttest if and only
%                 if samples x and y are of equal size, since it is
%                 a paired test. See getStatisticsTests
%
%      MeanVector : Matrix of (NFeatures x 2) with the mean values
%                   of each vector x and y in each column
%                   MeanVector = [Stats.XMean, Stats.YMean];
%
%      StdVector  : Matrix of (NFeatures x 2) with the standard deviation 
%                   values of each vector x and y
%                   StdVector  = [Stats.XStd, Stats.YStd];


    % Default values
    if nargin < 3
        alpha = 0.05;
    end

    [~, N_F1] = size(Mx);
    [~, N_F2] = size(My);
    
    if N_F1 ~= N_F2
        error('N_FEATURES1 ~= N_FEATURES2');
    end

    %% Var initialization
    Stats      =  cell(N_F1, 1);
    PMatrix    = zeros(N_F1, 8);
    MeanMatrix = zeros(N_F1, 2);
    StdMatrix  = zeros(N_F1, 2);
    
    % For each data column
    for i = 1 : N_F1
        
        % Columns with data
        x = Mx(:, i);
        y = My(:, i);
        
        % Stats
        [ S, PVector, MeanVector, StdVector ] = getStatisticTests( x, y, alpha );
        
        % Append to the struct
        Stats{i}         = S;
        PMatrix(i, :)    = PVector;
        MeanMatrix(i, :) = MeanVector;
        StdMatrix(i, :)  = StdVector;
        
    end

end
