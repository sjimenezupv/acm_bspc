% Utility script

nn = 300;
ders = getLabels12Leads();

iplot = 1;
figure(1)

%for i = 1 : TOTAL_ECG_FILES
for d = 12 : 12
    for i = [7, 22] %[1: TOTAL_ECG_FILES]
    
		if mod(i, 50) == 0, fprintf('%4d', i); end    
    
		Sx = ECGS{i};
		Y  = Sx.YFiltered;
		Fs = Sx.Fs;
    
		Yqrs = zeros(nn, 12);    
    
        
        Yd = Y(:, d);
        [patt, ~, ~, rvalues] = getQRS_Pattern3(Yd, Fs, nn, false);
        Yqrs(:, d) = patt;
        
        % R Fragment
        rf = existsRFragInECG(Yd, Fs);
        
        % T Negative
        tn    = false;
        tarea = 0;
        if (d ==1 || d ==2 || d ==10 || d ==11 || d ==12)
            [tn, tarea] = isTWaveNegative(Yd, Fs);
        end
        if tn == true
            
            i
            Sx
            
            [ ~, t_indices ] = getTWave( Yd, Fs );
            T = getTimeVector(Fs, length(Yd));
            
            subplot(2, 1, iplot);
            iplot = iplot + 1;
            
            plot(T, Yd, 'b-', 'LineWidth', 1.25);
            max_ecg = max(max(Yd)) / 2.0;            
            hold on            
            stem(T(t_indices), ones(1, length(t_indices)) .* max_ecg', 'r-', 'LineWidth', 1.50);
            title(['TNeg(', ders{d}, ')'],    'Interpreter', 'Latex', 'FontSize', 16);
            
            ylabel('mV', 'Interpreter', 'Latex', 'FontSize', 14);
            
            if iplot > 2
                xlabel('Tiempo (s.)', 'Interpreter', 'Latex', 'FontSize', 14);
            end
            
            grid
            hold off;
            
            w = 900;
            h = 600;
            set(gcf, 'Position', [200 200 w h]);
            
            %pause
        end
        
        % Get the QRS Area
        areaqrs = trapz(patt);
        
    end    
end

units = '';
lblFontSize = 16;
titFontSize = 16;
