function [r, tarea] = isTWaveNegative(ecg, Fs, msROffset, msWindow, plot_flag )
%ISTWAVENEGATIVE Indicates if the T wave is positive for the given ecg.
%
% INPUTS
%
%   ecg:       ecg-lead
%
%   Fs:        Sampling frequency
%
%   msROffset: Offset from the R peak where the window is positioned
%              to search for the T wave, in ms.
%              (Optional)
%
%   msWindow:  Window size to search for the T wave, in ms.
%              (Optional)
%
%   qrs:       R wave mask, used as a reference.  
%              If not provided, it will be recalculated using getQRS.
%              Optional.
%
%   plot_flag: Flag indicando si plotear los  resultados
%              (Optional, default=false)
%

    % Default args
    if nargin < 3; msROffset = 100;   end
    if nargin < 4; msWindow  = 300;   end
    if nargin < 5; plot_flag = false; end
    
    
    [ ~, ~, t_values, ~, tareas ] = ...
        getTWave(ecg, Fs, msROffset, msWindow, plot_flag);
    
    npos = sum(t_values >= 0);
    nneg = sum(t_values <  0);
    
    r = nneg/2 > npos;
    
    if r
        
        %t-values
        mn = mean(t_values);
        st = std(t_values);
        r  = mn+st < -0.05;
        
    end
    
    
    if isempty(tareas)
        tarea = 0;
    else 
        tarea = mean(tareas);
    end   
    

end

