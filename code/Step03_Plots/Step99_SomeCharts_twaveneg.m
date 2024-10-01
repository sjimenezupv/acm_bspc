% Utility script



% rfrag I and aVR(4)

nn = 300;
ders = getLabels12Leads();
iplot = 1;
figure(1)


save_dir = 'D:/GitHub/acm_bspc/results/';

for d = 12 : 12
    for i = 1:TOTAL_ECG_FILES %[7, 22]
    
        %if mod(i, 50) == 0, fprintf('%4d', i); end    
    
        Sx = ECGS{i};
        Y  = Sx.YFiltered;
        Fs = Sx.Fs;
    
        Yqrs = zeros(nn, 12);    
        
        Yd = Y(:, d);
        [patt, ~, ~, rvalues] = getQRS_Pattern3(Yd, Fs, nn, false);
        Yqrs(:, d) = patt;
        
        
        % T Negative
        tn    = false;
        if (d ==1 || d ==2 || d ==10 || d ==11 || d == 12)
            [tn, ~] = isTWaveNegative(Yd, Fs);
        end
        
        if tn == true
            
            i
            Sx
            
            [ ~, t_indices ] = getTWave( Yd, Fs );
            T = getTimeVector(Fs, length(Yd));
            
            figure(1)
            plot(T, Yd, 'b-', 'LineWidth', 1.25);
            max_ecg = max(max(Yd)) / 2.0;            
            hold on            
            stem(T(t_indices), ones(1, length(t_indices)) .* max_ecg', 'r-', 'LineWidth', 1.50);
            title(['TNeg(Lead-', ders{d}, ') - Patient 1'],    'Interpreter', 'Latex', 'FontSize', 16);            
            ylabel('mV',                      'Interpreter', 'Latex', 'FontSize', 14);
            xlabel('Time (s)', 'Interpreter', 'Latex', 'FontSize', 14);            
            
            grid
            hold off;
            
            g2 = figure(1)
            w = 900;
            h = 300;
            set(gcf, 'Position', [200 200 w h]);
            
            fname = [save_dir, 'twave.p1.Sxi_', num2str(i), '.lead_', num2str(d), '.png'];
            print(g2, '-dpng', '-r600', fname);
            close all; % Para no saturar la máquina abriendo demasiados plots
            
            
        end        
    end    
end


return;
%%




g2 = figure(2);
iplot = 1;

%for i = 1 : TOTAL_ECG_FILES
for d = 12 : 12
    for i = [12,37]% 1:TOTAL_ECG_FILES %[7, 22]
    
        %if mod(i, 50) == 0, fprintf('%4d', i); end    
    
        Sx = ECGS{i};
        Y  = Sx.YFiltered;
        Fs = Sx.Fs;
    
        Yqrs = zeros(nn, 12);    
        
        Yd = Y(:, d);
        [patt, ~, ~, rvalues] = getQRS_Pattern3(Yd, Fs, nn, false);
        Yqrs(:, d) = patt;
        
        
        % T Negative
        tn    = false;        
        if (d ==1 || d ==2 || d ==10 || d ==11 || d ==12)
            [tn, ~] = isTWaveNegative(Yd, Fs);
        end
        
        if tn == true
            
            i
            Sx
            
            [ ~, t_indices ] = getTWave( Yd, Fs );
            T = getTimeVector(Fs, length(Yd));
            
            subplot(2, 1, iplot);
            
            
            plot(T, Yd, 'b-', 'LineWidth', 1.25);
            max_ecg = max(max(Yd)) / 2.0;            
            hold on            
            stem(T(t_indices), ones(1, length(t_indices)) .* max_ecg', 'r-', 'LineWidth', 1.50);           
            
            
            title(['TNeg (Lead-', ders{d}, ') - Patient ', num2str(iplot)],    'Interpreter', 'Latex', 'FontSize', 16);            
            ylabel('mV',                      'Interpreter', 'Latex', 'FontSize', 14);
            
            if iplot > 1
                xlabel('Time (s)', 'Interpreter', 'Latex', 'FontSize', 14);
            end
            
            iplot = iplot + 1;
            
            grid
            hold off;
            
            w = 900;
            h = 600;
            set(gcf, 'Position', [200 200 w h]);
            
            if iplot > 2
                fname = [save_dir, 'twave.neg.paper2024.p1Sxi_12.p2Sxi_37.png'];
                print(g2, '-dpng', '-r600', fname);
            end
            
        end        
    end    
end


