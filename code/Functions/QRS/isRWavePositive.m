function [ result ] = isRWavePositive( ecg, window, windowStep )
%ISRWAVEPOSITIVE Returns a value indicating whether the R wave is positive
% or not for the given signal.

    N   = length(ecg);    
        
    avgMin  = 0;
    avgMax  = 0;
    cont    = 0;
    iIni    = 1;
    iFin    = window;
    
    % We calculate the average value of the Minimums and the Maximums
    while iFin <= N
        
        % Get and analyze the signal segment
        senyal = ecg(iIni:iFin);
        avgMax = avgMax + max(senyal);
        avgMin = avgMin + min(senyal);
        cont   = cont + 1;

        % Move forward to the end-condition
        iIni = iIni + windowStep;
        iFin = iFin + windowStep;

        if iIni < N && iFin > N
            iFin = N;
        end
    end
    
    if cont > 0
        avgMax = avgMax / cont; 
        avgMin = avgMin / cont; 
    else
        error('Signal too small for that window segment.');
    end
    
    
    % Set a threshold that both minima and maxima must exceed.
    umbralMax = avgMax / 3;
    umbralMin = avgMin / 3;
    
    
    % Make another pass, taking these thresholds into account
    avgMin        = 0;
    avgMax        = 0;    
    iIni          = 1;
    iFin          = window;
    
    while iFin <= N
        
        % Get and analyze the signal segment
        senyal = ecg(iIni:iFin);
        ma     = max(senyal);
        mi     = min(senyal);
        
        if ma >= umbralMax && abs(ma) >= abs(mi)
            avgMax = avgMax + ma;        
        elseif mi <= umbralMin && abs(mi) >= abs(ma)
            avgMin = avgMin + mi;
        else
            cont = cont - 1;
        end

        % Move forward to the end condition
        iIni = iIni + windowStep;
        iFin = iFin + windowStep;

        if iIni < N && iFin > N
            iFin = N;
        end
    end
    
    % Average with only those that have exceeded the threshold
    if cont > 0
        avgMax = avgMax / cont;
        avgMin = avgMin / cont;
    else
        error('It is not possible that any R-wave never exceed the threshold');
    end
    
    
    % The largest average in amplitude of the values indicates the sign of the R wave
    if abs(avgMax) >= abs(avgMin)
        result = true;
    else
        result = false;
    end

end