function [ patron, qrs, qrs_indices, qrs_values, duraciones, per_descartes, rmse ] = getQRS_Pattern3( ecg, Fs, msOffset, plot_flag, qrs )
%GETQRS_PATTERN Get the pattern for the R-R interval

    % Default args
    if nargin < 3; msOffset  = 100;   end
    if nargin < 4; plot_flag = false; end
    
    [n, m] = size(ecg);
    if m > n
        ecg = ecg';
    end
    
    if nargin < 5
        [qrs, qrs_indices, qrs_values] = getQRS(ecg, Fs, plot_flag, false);
    else
        qrs_indices = find(qrs==1);
        qrs_values  =  ecg(qrs==1);
    end
    
    % Local variables
    N          = length(qrs_indices);         % # of r-waves
    NECG       = length(ecg);                 % ECG length
    duraciones = diff(qrs_indices);           % R-R intervals in number of samples
    offset     = round(Fs * (msOffset/1000)); % #samples right-left of r-wave
    win        = offset * 2;                  % Pattern window size
    patron     = zeros(win, 1);               % Pattern to be returned
    totqrs     = 0;                           % valid #r-waves according to the pattern
    
    
    if plot_flag == true
        T = getTimeVector(Fs, win);
        figure;
        subplot(1, 2, 1);
        hold on;
    end

    
    for i = 1 : N
        
        index1 = qrs_indices(i) - offset;
        index2 = qrs_indices(i) + offset - 1;
        
        if index1 > 0 && index2 <= NECG
            senyal = ecg(index1 : index2);
            patron = patron + senyal;
            totqrs = totqrs + 1;        
        end        
    end
    
    % mean-pattern
    if totqrs > 0
        patron = patron ./ totqrs;
    end
    
    
    
    % Repeat the process, but this time we filter the QRS complexes
    % that DO NOT resemble the pattern, using the correlation factor
    th_c = 0.7; % Correlation threshold
    patron2  = zeros(win, 1);
    totqrs   = 0;
    for i = 1 : N        

        index1 = qrs_indices(i) - offset;
        index2 = qrs_indices(i) + offset - 1;
        
        if index1 > 0 && index2 <= NECG
            
            % Get the signal segment
            senyal = ecg(index1 : index2);
            c      = corr2(patron, senyal);
            
            if c >= th_c
                patron2 = patron2 + senyal;
                totqrs = totqrs + 1;

                if plot_flag == true                    
                    plot(T, senyal, 'b-');
                end
            end        
        end        
    end
    
    % mean-pattern
    if totqrs > 0
        patron = patron2 ./ totqrs;

        % root Mean square error
        rmse = 0;
        for i = 1 : N        

            index1 = qrs_indices(i) - offset;
            index2 = qrs_indices(i) + offset - 1;

            if index1 > 0 && index2 <= NECG

                % Cogemos el trozo de senyal
                senyal = ecg(index1 : index2);
                c      = corr2(patron, senyal);

                if c >= th_c                
                    rmse = rmse + ((senyal-patron).^2);
                end        
            end        
        end

        per_descartes= 1 - (totqrs/N);
        rmse         = sqrt(mean(rmse));  
        
    else
        per_descartes = 1.0;
        rmse          = 10;
    end
    

    
    % Plots
    if plot_flag == true       
        plot(T, patron, 'r-');    
        title('Pattern');
        grid;
        hold off;
        
        if ~isempty(duraciones)
            subplot(2, 2, 2);
            boxplot(duraciones./Fs);
            title('R-R Interval');
            ylabel('Time (s)');
            grid;
        end
        
        subplot(2, 2, 4);
        hold on
        plot(T(1:end-1), diff(patron), 'r-');
        plot(T(1:end-2), diff(diff(patron)), 'b-');
        title('Pattern Derivatives');
        ylabel('Derivative');
        legend('Derivative 1', 'Derivative 2');
        grid;
        hold off
        
    end

end

