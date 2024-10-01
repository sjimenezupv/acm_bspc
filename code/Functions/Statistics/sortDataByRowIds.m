function [ M, RowIds ] = sortDataByRowIds( M, RowIds )
%SORTDATABYROWIDS Sorts the M matrix according to the specified Row Identifiders
%
% [ M ] = sortDataByRowIds( M, RowIds )
% AUTHOR: Santiago Jiménez [sanjiser@upv.es]
%
% Sorts the M matrix according to the specified Row Identifiders
%
% INPUTS
%  M:      Data Matrix
%  RowIds: Samples identifiers
%
% OUTPUTS
%  M:      M Matrix with sorted rows alphabetically according to RowIds.
%  RowIds: Row identifiers sorted alphabetically


    % Check that the #rows in M is equal than RowIds
    [NF, ~] = size(M);
    L       = length(RowIds);    
    if NF ~= L
        error('M has no the same length than RowIds');
    end
    
    % Sort
    [RowIds, I] = sort(RowIds);
    M           = M(I, :);

end

