function [ Y ] = CutSignal( Y, Fs, startSecsToCut, endSecsToCut )
%CUTSIGNAL Remove the initial and final seconds in the input signal
%
% INPUTS
%   Y:              Vector o Matrix containing the signals
%   Fs:             Sampling frequency
%   startSecsToCut: Seconds to remove from the beginning of the signal
%   endSecsToCut:   Seconds to remove from the final of the signal (Default = 0)
%
% OUTPUTS
%   Y:              Cropped vector or data matrix


    % Default parameters
    if nargin < 4, endSecsToCut = 0; end

	% Ensure matrix size
    [ Y, numsamples, ~ ] = AssertMatrixSize( Y );
    
    
    samplesStart = int32(Fs*startSecsToCut);
    samplesEnd   = int32(Fs*endSecsToCut);
    
    % Cut from the beginning
    if samplesStart > numsamples
        samplesStart = numsamples;
    end    
    if samplesStart > 0
        Y(1:samplesStart, :) = [];
        numsamples = numsamples - samplesStart;
    end
    
    % Cut from the final point
    if samplesEnd > numsamples
        samplesEnd = numsamples;
    end
    if samplesEnd > 0
        Y(numsamples-samplesEnd+1:numsamples, :) = [];
    end

end



