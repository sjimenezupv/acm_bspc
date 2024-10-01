function [ qrs, qrs_indices, qrs_values ] = getQRS( ecg, Fs, plot_flag, debug_flag, max_bpm )
%GETQRS Get a mask indicating where the R-peaks are located in an ECG
    
    % Default args
    if nargin < 3
        plot_flag = false;
    end
    if nargin < 4
        debug_flag = false;
    end
    if nargin < 5
        max_bpm = 210; % Assume a max rithm of 210 bpm in humans
        % (10 beats per second in mice! : 600 bpms)
    end
    
    bpm_ratio = max_bpm/60;
    
    if max_bpm > 210
        fprintf('WARNING: Calculating QRS FOR MICE!\n');
    end


    % Local variables
    windowStep = int32(Fs/bpm_ratio); 
    window     = windowStep;
    
    % 1 - Get minimums/maximums
    [qrs] = getRawQRS(ecg, window, windowStep);
    if debug_flag == true
        plotQRS(ecg, qrs, Fs);    
        title('RAW');
    end    
    
    % 2 - Filter QRS too close
    [qrs] = filterQRS_TooClose( ecg, qrs, windowStep );
    if debug_flag == true
        plotQRS(ecg, qrs, Fs);    
        title('TOO CLOSE');
    end
    
    % 3 - Filter by threshold
    [qrs] = filterQRS_Threshold(ecg, qrs);
    if debug_flag == true
        plotQRS(ecg, qrs, Fs);    
        title('THRESHOLD');
    end
    
    % 4 - Filter until no outliers exist
    [qrs] = filterQRS_Outliers(ecg, qrs, Fs);
    if debug_flag == true
        plotQRS(ecg, qrs, Fs);    
        title('OUTLIERS');
    end
    
    % 5 - Filter QRS that do not fulfill derivatives conditions
    [ qrs ] = filterQRS_Derivative(ecg, qrs, Fs);
    if debug_flag == true
        plotQRS(ecg, qrs, Fs);    
        title('DERIVADA');
    end
    
    % 6 - Filter QRS that do not fulfill the mean-pattern
    if max_bpm < 3000 % Humanos (300 antes)
        [qrs, qrs_values, qrs_indices] = filterQRS_Pattern( ecg, qrs, Fs );
    %else % mice
    %    [qrs, qrs_values, qrs_indices] = filterQRS_Pattern( ecg, qrs, Fs, 10 );
    end
    if debug_flag == true
        plotQRS(ecg, qrs, Fs);    
        title('PATTERN');
    end
        
    % Plot
    if plot_flag == true
        plotQRS(ecg, qrs, Fs);    
    end

end

