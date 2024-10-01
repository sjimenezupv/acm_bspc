function [ Y ] = Filtra_MCA( Y, Fs, debug_flag )

	% Default arguments
    if nargin < 3
        debug_flag = false;
    end

    %% Check debug
    if debug_flag
        yorig = Y;
    end
    
    
    %% 1. Filter artifacts
    Y = Filter_Artifacts(Y, Fs);

    %% 2. Low-pass filter (70Hz)
    [a, b] = getFilterLP(Fs, 70);
    Y = ApplyFilter(Y, a, b);        
    
    %% 3. Notch filter (50 Hz)
    [a, b] = getFilterNotch(Fs, 50);
    Y = ApplyFilter(Y, a, b);    
    
    %% 4. High-Pass Filter (0.7 Hz)
    [a, b] = getFilterHP(Fs, 0.7);
    Y = ApplyFilter(Y, a, b);    
    
    %% 5. Remove the transient, sacrificing 1 second of signal
    Y = CutSignal(Y, Fs, 0.5, 0.5);
    
    %% 6. Substract the mode to center at zero
    modeY = mode(round(Y*1000)/1000);
    for i=1:12
        Y(:, i) = Y(:, i) - modeY(i);
    end
    
    
    %% Final Debug
    if debug_flag     
        
        yo = CutSignal( yorig, Fs, 0.5, 0.5 );
        t  = getTimeVector(Fs, length(Y(:, 1)));
        
        %% Common variables
        lblFSz = 16;
        interp = 'latex'; % 'none'
        
        figure(3);                
        subplot(2, 1, 1);
        cla;        
        plot(t, yo(:, 1), 'b-', 'LineWidth', 1.25);
        grid;
        ylabel('mV', 'Interpreter', interp, 'FontSize', lblFSz);        
        title('Original ECG (Lead-I)]', 'Interpreter', interp, 'FontSize', lblFSz);
        
        subplot(2, 1, 2);
        cla;
        plot(t, Y(:, 1), 'b-', 'LineWidth', 1.25);
        grid;
        ylabel('mV',       'Interpreter', interp, 'FontSize', lblFSz);
        xlabel('Time (s)', 'Interpreter', interp, 'FontSize', lblFSz);
        title('Filtered ECG (Lead-I)', 'Interpreter', interp, 'FontSize', lblFSz);
        
        hFig = figure(3); w = 900; h = 600;
        set(hFig, 'Position', [100 100 w h]);
        pause;
    end
    
end



%% Auxiliar functions

function [ y ] = ApplyFilter(x, a, b)
	
	[ x, ~, nchannels ] = AssertMatrixSize( x );
    y = zeros(size(x));
    
    for i = 1 : nchannels
        y(:, i) = filtfilt(b, a, x(:, i));
    end
end

function [a, b] = getFilterLP(Fs, Fc)
     Wn = Fc/(Fs*0.5);
    [b, a]  = butter(4, Wn);
end

function [a, b] = getFilterHP(Fs, Fc)    
    Wn = Fc/(Fs*0.5);
    [b, a]  = butter(4, Wn, 'high');
end

function [a, b] = getFilterNotch(Fs, Fc)

    Q  = 10;
    Fn = Fs/2;
    
    W0 = Fc/Fn;
    bw = W0/Q; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %bw = 0.1;
    
    [b, a] = iirnotch(W0, bw);

end