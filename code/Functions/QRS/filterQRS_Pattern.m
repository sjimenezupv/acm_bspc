function [ qrs, qrs_values, qrs_indices ] = filterQRS_Pattern( ecg, qrs, Fs, msOffset, th_c )
%FILTERQRS_PATTERN Filters QRS complexes that do not match the average pattern
%
% The idea is to keep only the QRS complexes that have an average
% correlation factor with all the others greater than a threshold
%
% INPUTS:
%    ecg:      ecg-lead
%    qrs:      Mask (0|1) where 1 indicates presence of R-peak
%    Fs:       Sampling frequency
%
%    msOffset: Window in ms to extract the QRS signal segment and compare
%              it with the others.
%              (Optional, Default = 100)
%
%    th_c:     Average correlation threshold between patterns.
%              (Optional, Default = 0.75)

    % Default parameters
    if nargin < 4
        msOffset  = 100;        
    end
    
    % Average correlation threshold
    if nargin < 5
        th_c = 0.6;
    end

    qrs_indices = find(qrs==1);
    N           = length(qrs_indices);
    NECG        = length(ecg);
    
    % Number of samples on each side of the R-wave
    offset      = round(Fs * (msOffset/1000));
    
    % for each QRS
    for i = 1 : N        

        indexI = qrs_indices(i);
        index1 = indexI - offset;
        index2 = indexI + offset - 1;
        
        if index1 > 0 && index2 <= NECG
            
            % Take the signal segment
            senyal1 = ecg(index1 : index2);
            numcomp = 0;
            sumcorr = 0;
            
            window = 3;
            
            for j = i-window : i+window
            
                if j < 1, continue, end
                if j > N, continue, end
                
                indexJ = qrs_indices(j);
                
                % If it is not the same QRS
                if j~=i && qrs(indexJ) == 1                    
                    
                    index1 = indexJ - offset;
                    index2 = indexJ + offset - 1;
                    
                    if index1 > 0 && index2 <= NECG
                        
                        % Take the 2nd signal segment and correlate
                        senyal2 = ecg(index1 : index2); 
                        c       = corr2(senyal1, senyal2);
                        if c > 0.2
                            sumcorr = sumcorr + c;
                            numcomp = numcomp + 1;
                        end
                        
                    end
                end
            end
            
            
            if numcomp > 0
                
                % Calculate the average correlation factor
                avgcorr = sumcorr / numcomp;
                
                % If it does not exceed the threshold, remove the R mark
                if avgcorr < th_c
                    qrs(indexI) = 0;
                end
                
            end
        end        
    end
    
    if nargout > 1; qrs_values  = ecg(qrs==1);  end    
    if nargout > 2; qrs_indices = find(qrs==1); end

end

