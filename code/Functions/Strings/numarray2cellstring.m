function c = numarray2cellstring(a)
%NUMARRAY2CELLSTRING c=numarray2cellstring(a)
%     Converts a numbers array to a cell-strings array.
%
% INPUT
%  a - numbers vector ,e.g. [1 2 3 4.5];
%
% OUTPUT
%  c - cell with string representation of the numbers
%
% EXAMPLE
%  a=[1 2 4 6 -12];
%  c=numarray2cellstring(a);
%  c =
%      '1' '2' '4' '6' '-12'
%

    c={};
    for i=1:length(a)
        c{end+1}=num2str(a(i));
    end
end
