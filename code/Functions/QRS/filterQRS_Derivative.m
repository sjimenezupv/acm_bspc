function [ qrs, qrs_values, qrs_indices ] = filterQRS_Derivative( ecg, qrs, Fs, msOffset )
%FILTERQRS_DERIVADA Filter the QRS complexes that do not meet certain
%                   criteria regarding the derivative.
%
% INPUTS:
%    ecg:      ecg-lead
%    qrs:      Mask (0|1) where 1 indicates presence of R-peak
%    Fs:       Sampling frequency
%
%    msOffset: Window in ms to obtain the maximum derivative with respect to the R peak.
%              Opcional - Default = 50
%

    % Default values
    if nargin < 4
        msOffset  = 50;        
    end

    % Local variables
    qrs_indices = find(qrs==1);    
    derivada    = diff(ecg);
    N           = length(qrs_indices);
    NDER        = length(derivada);
    max_DValues = nan(1, N);
    
    % Number of samples on each side of the R wave
    offset = round(Fs * (msOffset/1000));

   
    % Calculate the maximum absolute derivative around the R waves
    for i = 1 : N
        indexI = qrs_indices(i);
        index1 = indexI - offset;
        index2 = indexI + offset - 1;
        
        if index1 <    1; index1 =    1; end
        if index2 > NDER; index2 = NDER; end        
        
         % Take the derivative segment
        senyal = derivada(index1 : index2);
        
        % Keep the maximum
        max_DValues(i) = max(abs(senyal));
        
    end
    
    
    umbral = nanmean(max_DValues) / 2;
    for i = 1 : N        
        valueD = max_DValues(i);
        
        % Filter all R waves whose maximum derivative
        % does not exceed the threshold.
        if ~isnan(valueD) && valueD < umbral
            indexI = qrs_indices(i);
            qrs(indexI) = 0;
        end        
    end
    
    % Check the first and last R, as they sometimes
    % result in a residual False Positive.
    qrs_values  = ecg(qrs==1);
    qrs_indices = find(qrs==1);
    
    if length(qrs_values) > 1
        
        vFin = qrs_values(end);
        vAnt = qrs_values(end-1);
        
        % It is not normal for the last value to be less than half of the previous one
        if abs(vFin) < abs(vAnt)/2
            qrs(qrs_indices(end)) = 0;  % Mark as no R-peak exist
            qrs_indices(end)      = []; % Remove the last index and value
            qrs_values(end)       = [];
        end        
    end
    
    if length(qrs_values) > 1
        
        v1 = qrs_values(1);
        v2 = qrs_values(2);
        
        % It is not normal for the first value to be less than half of the next one
        if abs(v1) < abs(v2)/2
            qrs(qrs_indices(1)) = 0;  % Mark as no R-peak exist
            qrs_indices(1)      = []; % Remove the last index and value
            qrs_values(1)       = [];
        end        
    end

end

