function [ qrs ] = getRawQRS( ecg, window, windowStep )
%GETRAWQRS Obtain an initial QRS mask using the minima of the ECG signal

    N   = length(ecg);
    qrs = zeros(N, 1);
    
    iIni = 1;
    iFin = window;
    
    if isRWavePositive( ecg, window, windowStep ) == true
        fun = @max;
    else
        fun = @min;
    end
    
    while iFin <= N
        
        % Get and analyze the signal segment
        [~, ind] = fun(ecg(iIni:iFin));
        
        % Set the mark
        qrs(iIni+ind-1) = 1;

        % Move forward to the end-condition
        iIni = iIni + windowStep;
        iFin = iFin + windowStep;

        if iIni < N && iFin > N
            iFin = N;
        end
    end
    
    % Filter those that do not exceed a reasonable threshold
    qrs_values = ecg(qrs==1);
    umbral     = mean(abs(qrs_values)) / 3;    
    qrs(abs(ecg) < umbral) = 0;

end

