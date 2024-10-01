function [ tm ] = convertStrToTime( str )
%CONVERTSTRTOTIME Converts a string in format hh:mm:ss to a datetime object
%   
% INPUTS
%   str: The string in hh:mm:ss format
%
% OUTPUTS
%    tm: A datetime vector with the date set to 01/01/2000 and the time
%        specified in the string str


    yy = 2000;
    mm = 1;
    dd = 1;
        
    s = textscan(str, '%f:%f:%f');

    s1 = s{1};
    s2 = s{2};
    s3 = s{3};

    tm = [yy, mm, dd, s1, s2, s3];


end

