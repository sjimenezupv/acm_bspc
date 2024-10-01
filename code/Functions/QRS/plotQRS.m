function [G] = plotQRS(ecg, qrs, Fs)
%PLOTQRS Plots an ecg with the given QRS mask

        T = getTimeVector(Fs, length(ecg));        
        qrs_values = ecg(qrs==1);
        qrs_index  = find(qrs==1);
        duraciones = diff(qrs_index) / Fs;
        
        G=figure;        
        
        max_ecg = max(1, max(ecg));
        subplot(3, 1, 1);
        hold on
        stem(T(qrs==1), qrs(qrs==1) .* max_ecg, 'r-');
        plot(T, ecg, 'b-');
        title('ECG');
        xlabel('Time [s]');
        ylabel('ECG');
        grid;
        hold off;
        
        dn = 1; % Number of leads to plot
        subplot(3, 1, 2);
        plot(T(1:end-dn), (diff(ecg, dn)), 'r-');
        title('Derivative(ECG)');
        xlabel('Time (s)');
        ylabel('diff(ECG)');
        grid;
        
                
        subplot(3, 2, 5);
        boxplot(qrs_values);
        title('R values');
        xlabel('R Peak');
        ylabel('Amplitude');
        grid;

        subplot(3, 2, 6);
        boxplot(duraciones); 
        title('R-R Intervals');
        xlabel('R-R');
        ylabel('Time R-R (s)');
        grid;
end

