function [ Stats, ClassPairs ] = getStatisticTestsMultiClass( v, class, alpha )
%GETSTATISTICTESTSMULTICLASS Performs statistical tests grouping by the class of each sample
%
% [ Stats, ClassPairs ] = getStatisticTestsMultiClass( v, class, alpha )
% AUTHOR: Santiago Jiménez [sanjiser@upv.es]
%
% 
% Creates all possible combinations between the number of classes present
% in class. From there, it performs statistical tests comparing the 
% values of each class with each class combination.
%
%   INPUTS
%     v:     Vector containing the values
%     class: Vector containing the class of each sample
%     alpha: Significance level alpha for the tests to be considered significant.
%            Optional. Default=0.05.
% 
% OUTPUTS
%   Stats:      Cell array that contains, in each element, the statistical tests from
%               comparing the values in v from Class Ci vs Class Cj. See
%               getStatisticTests.
%
%   ClassPairs: Matrix of size [NCombinations x 2] with the pairs of
%               Classes [Ci, Cj] from the statistical tests performed.
%


    % Default parameters
    if nargin < 3, alpha = 0.05; end

    % Auxiliar variables
    CLASES = sort(unique(class)); % classes    
    NC     = length(CLASES);      % #classes
    
    % Get total number of combinations
    NCOMB = sum(1:NC-1);
    
    % Test for errors
    if NCOMB < 1
        error('ncombinations < 1');
    end
    
    % Init structs
    Stats      =  cell(NCOMB, 1);
    ClassPairs = zeros(NCOMB, 2);
    k          = 1;
    
    % For each pair [Ci, Cj] / i~=j
    for i = 1 : NC
        
        % Values for class Ci --> x
        ci = CLASES(i);
        x  = v(class==ci);
        
        for j = i + 1 : NC
            
            % Values for class Cj --> y
            cj = CLASES(j);
            y  = v(class==cj);
            
            % Get the stats
            try
                Stats{k} = getStatisticTests( x, y, alpha );
            catch err
                 fprintf('ERROR: getStatisticTestsMultiClass (GROUP %d VS %d) \n', ci, cj);
                 err
                 Stats{k} = getStatisticTests([1:10]', [1:10]'); % ( rand(10, 1), rand(10, 1) );
             end
            
            % Pair-Matrix [Ci, Cj]
            ClassPairs(k, 1) = ci;
            ClassPairs(k, 2) = cj;
            
            % Increment auxiliar index
            k = k + 1;
        end
    end

end

