function [ t_mask, t_indices, t_values, diff_qt_ms, tareas ] = getTWave( ecg, Fs, msROffset, msWindow, plot_flag, qrs )
%GETTWAVE Returns a mask indicating where the T waves are located, 
%         as well as their indices and values.
%
%   INPUTS
%   ecg:       Ecg-lead
%   Fs:        Sampling frequency
%
%   msROffset: Offset from the R peak where the window is positioned
%              to search for the T wave, in ms.
%              (Optional)
%
%   msWindow:  Window size lo look for the t-wave, in ms.
%              (Optional)
%
%   plot_flag: Flag indicating if do some plot
%              (Optional, default=false)
%
%   qrs:       R wave mask, used as a reference.  
%              If not provided, it will be recalculated using getQRS.
%              (Optional)

    % Default args
    if nargin < 3; msROffset = 100;    end
    if nargin < 4; msWindow  = 300;    end
    if nargin < 5; plot_flag = false;  end
    
    [n, m] = size(ecg);
    if m > n
        ecg = ecg';
    end
    
    if nargin < 6
        [qrs, r_indices] = getQRS(ecg, Fs, plot_flag, false);
    else
        r_indices = find(qrs==1);
    end
    
    t_mask = zeros(size(qrs));
    
    % Local variables
    N            = length(r_indices);            % Number of R-waves
    NECG         = length(ecg);                  % ECG length
    offsetR      = round(Fs * (msROffset/1000)); % Offset from the R-wave
    offsetWin    = round(Fs * (msWindow/1000));  % #samples left-righ of the r-wave
    tareas       = zeros(1, N);
    
    for i = 1 : N
        
        r_index = r_indices(i);
        index1  = r_index + offsetR;
        index2  =  index1 + offsetWin - 1;
        
        if index1 > 0 && index2 <= NECG
            
            %senyal = ecg(index1 : index2);
            [ma, mai] = max(ecg(index1 : index2));
            [mi, mii] = min(ecg(index1 : index2));
            tareas(i) = trapz(ecg(index1 : index2));
        
            if(abs(ma) > abs(mi))
                t_mask(r_index + offsetR + mai - 1) = 1;
            else
                t_mask(r_index + offsetR + mii - 1) = 1;
            end
        end
    end
    
    
    t_indices = find(t_mask==1);
    t_values  = ecg(t_indices);
    
    
    %%  QT interval in ms
    r_indices  = r_indices(1:length(t_indices));
    diff_qt_ms = (t_indices - r_indices) ./ Fs;

    %% Plot ??
    if plot_flag == true
        plotQRS(ecg, qrs, Fs);
        
        max_ecg = max(1, max(ecg));
        subplot(3, 1, 1);
        hold on
        T = getTimeVector(Fs, length(ecg));
        stem(T(t_mask==1), t_mask(t_mask==1) .* max_ecg, 'g-');
        hold off;
    end
end