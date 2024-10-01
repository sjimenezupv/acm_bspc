function [ M, nsamples, nvars ] = AssertMatrixSize( M )
%ASSERTMATRIXSIZE Ensures that matrix size will be Rows=Samples, Columns=Variables or signal-channels
%
% INPUTS
%    M: Matrix or Vector data
%
% OUTPUTS
%   M:        Matrix or Vector in format Rows=Samples, Columns=Variables or signal-channels
%   nsamples: Number of samples                      (ROWS)
%   nvars:    Número de variables or signal-channels (COLUMNS)

    [nsamples, nvars] = size(M);
    if nsamples < nvars
        M = M';
        [nsamples, nvars] = size(M);
    end

end

