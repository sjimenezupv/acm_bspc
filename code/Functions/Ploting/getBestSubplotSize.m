function [ num_rows, num_cols ] = getBestSubplotSize( num_plots )
%GETBESTSUBPLOTSIZE Gets the best size for the subplot matrix,
%given the number of subplots to be drawn.
%   INPUTS
%      num_plots: Number of plots we want to draw in the same matrix
%
%   OUTPUTS
%       num_rows: Optimal number of rows for subplot
%       num_cols: Optimal number of columns for subplot

    if num_plots < 1
        num_rows = 0;
        num_cols = 0;
        return;
    end
    
    num_rows = ceil(sqrt(double(num_plots)));
    num_cols = num_rows;
    while num_rows * (num_cols-1) >= num_plots
        num_cols = num_cols - 1;
    end   
    
end

