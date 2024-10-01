function [ ecg_ok ] = Filter_Artifacts( ecg, Fs )
%FILTERARTIFACTS Filter the artifacts that an ECG signal may have.
%
% INPUTS
%   ecg: Input ecg signal: Vector or Matrix
%   Fs:  Sampling frequency
%
% AUTHOR
%   Santiago Jiménez-Serano (sanjiser@i3m.upv.es)
%

	% Assert the matrix sixe
    [ ecg, ~, nchannels ] = AssertMatrixSize( ecg );
	
	% Initialize output matrix
    ecg_ok = zeros(size(ecg));
    
	% Filter artifactcs for each channel
    for i = 1 : nchannels        
		ecg_ok(:, i) = Filter_ArtifactsAux(ecg(:, i), Fs);
    end

end


%% Auxiliar functions
function [ x_ok ] = Filter_ArtifactsAux( x, Fs )

    % Copy the input data
    x_ok = x;
    
    % Filter outliers second by second, both in minimums and maximums
    N_MUESTRAS       = length(x);
    winStep          = int32(Fs/2);
    iIni             = int32(1);
    iFin             = winStep;
    outliers_indexes = [];
    
    % Just in case the signal is shorter than the window
    if iFin > N_MUESTRAS
        iFin = N_MUESTRAS;
    end
    
    mins = [];
    maxs = [];
    
    % Get the maximums and minimums based on a time window
    while iFin <= N_MUESTRAS
        
        if iFin + winStep > N_MUESTRAS
            iFin = N_MUESTRAS;
        end
        
        senyal = x(iIni: iFin);
        
        mins = [mins; min(senyal)];
        maxs = [maxs; max(senyal)];
        
        iIni = iIni + winStep;
        iFin = iFin + winStep;
    end
    
    % Get the thresholds
    median_max  = median(maxs);
    median_min  = median(mins);
    std_max     = std(maxs);    
    std_min     = std(mins);
    
    % We need to know if the R is negative or positive.
    if abs(median_max) > abs(median_min)
        coef_up = 4;
        coef_dn = 5;
    else
        coef_up = 5;
        coef_dn = 4;
    end
    
    
    % 1 - Detect the outliers
    th_up = median_max + (std_max * coef_up);
    th_dn = median_min - (std_min * coef_dn);
    
    ind_up = find(x > th_up);
    ind_dn = find(x < th_dn);
    outliers_indexes = sort([ind_up; ind_dn]);
    
    
    
    % 2 - Set to zero the segments that have very close outliers
    nOutliers = length(outliers_indexes);
    
    % Set to zero the outliers
    if nOutliers >= 1
        x_ok(outliers_indexes) = 0;    
    end
    
    for i = 1 : nOutliers
        index = outliers_indexes(i);
        value = x(index);
        
        signo = sign(value);
        j = index-1;
        while j >= 1 && sign(x(j)) == signo
            x_ok(j) = 0;
            j = j - 1;
        end
        
        
        j = index+1;
        while j <= N_MUESTRAS && sign(x(j)) == signo
            x_ok(j) = 0;
            j = j + 1;
        end
    end
    
    %  Set to zero the segments that have very close outliers
    if nOutliers > 1
        
        min_win = int32(Fs/2);
        for i = 1 : nOutliers-1
            iIni = outliers_indexes(i);
            iFin = outliers_indexes(i+1);
            
            % If they are very close, we set that segment to zero
            if iFin-iIni <= min_win
                x_ok(iIni:iFin) = 0;
            end
        end
        
    end
    

end

