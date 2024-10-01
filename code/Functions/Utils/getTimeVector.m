function [ T ] = getTimeVector( Fs, NumSamples )
%GETTIMEVECTOR Get the time-vector according to the input parameters
% 
% INPUT 
%    Fs:         Sampling frequency
%    NumSamples: Number of samples


    %T = (0: 1/Fs: (double(NumSamples)/Fs)-(1/Fs))';  % Index 0-based
    T = (1/Fs: 1/Fs: (double(NumSamples)/Fs))';       % Index 1-based

end

