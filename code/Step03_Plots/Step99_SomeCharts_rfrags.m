% Utility script



% Make figures with patient-samples
nn   = 300;
ders = getLabels12Leads()

iplot = 1;
figure(1)


save_dir = 'D:/GitHub/acm_bspc/results/';

% rfrag I and aVR(4)
for d = [1,4] % 12 : 12
    for i = 1:TOTAL_ECG_FILES %[7, 22]
    
        %if mod(i, 50) == 0, fprintf('%4d', i); end    
    
        Sx = ECGS{i};
        Y  = Sx.YFiltered;
        Fs = Sx.Fs;
    
        Yqrs = zeros(nn, 12);    
        
        Yd = Y(:, d);
        [patt, ~, ~, rvalues] = getQRS_Pattern3(Yd, Fs, nn, false);
        Yqrs(:, d) = patt;        
        
        
        % R Fragment
        rf = existsRFragInECG(Yd, Fs);
        if rf 
            i
            Sx
            
            T = getTimeVector(Fs, nn);
            %subplot(2, 2, iplot);
            %iplot = iplot + 1;
            
            plot(T, patt, 'b-', 'LineWidth', 1.25);
            tit = ['RFrag (Lead-', ders{d}, ')'];
            title (tit,        'Interpreter', 'Latex', 'FontSize', 16);
            ylabel('mV',       'Interpreter', 'Latex', 'FontSize', 14);            
            xlabel('Time (s)', 'Interpreter', 'Latex', 'FontSize', 14);            
            grid;
            
            g2 = figure(1);
            w = 450;
            h = 300;
            set(gcf, 'Position', [200 200 w h]);
            
            fname = [save_dir, 'rfrag.Sxi_', num2str(i), '.lead_', num2str(d), '.png'];
            %print(g2, '-dpng', '-r600', fname);
            close all; % To avoid too many open windows
            
        end      
      
    end    
end


return;

  %% Sxi, di
XX = [ 6, 1; ...
      11 ,1; ...
       6, 4; ...
      10, 4]

g2 = figure(2);
for x = 1:4
    
    i = XX(x, 1);
    d = XX(x, 2)
    
    
    %if mod(i, 50) == 0, fprintf('%4d', i); end    

    Sx = ECGS{i};
    Y  = Sx.YFiltered;
    Fs = Sx.Fs;

    Yqrs = zeros(nn, 12);    

    Yd = Y(:, d);
    [patt, ~, ~, rvalues] = getQRS_Pattern3(Yd, Fs, nn, false);
    Yqrs(:, d) = patt;        


    % RFrag
    rf = existsRFragInECG(Yd, Fs);
    if rf 
        i
        Sx

        T = getTimeVector(Fs, nn);
        subplot(2, 2, x);

        plot(T, patt, 'b-', 'LineWidth', 1.25);
        tit = ['RFrag (Lead-', ders{d}, ') - Patient ', num2str(x)];
        title (tit,        'Interpreter', 'Latex', 'FontSize', 16);
        ylabel('mV',       'Interpreter', 'Latex', 'FontSize', 14);
        
        if x > 2
            xlabel('Time (s)', 'Interpreter', 'Latex', 'FontSize', 14);
        end
        
        grid;
    end     
      
end

g2 = figure(2);
w = 900;
h = 600;
set(gcf, 'Position', [200 200 w h]);

fname = [save_dir, 'rfrag.paper2024.p1Sxi_6.10.11.png'];
print(g2, '-dpng', '-r600', fname);




%%   Sxi, di
XX = [11, 1; ...
      17 ,1; ...
      10, 4; ...
      11, 4]

g2 = figure(2);
for x = 1:4
    
    i = XX(x, 1);
    d = XX(x, 2)
    
    
    %if mod(i, 50) == 0, fprintf('%4d', i); end    

    Sx = ECGS{i};
    Y  = Sx.YFiltrada;
    Fs = Sx.Fs;

    Yqrs = zeros(nn, 12);    

    Yd = Y(:, d);
    [patt, ~, ~, rvalues] = getQRS_Pattern3(Yd, Fs, nn, false);
    Yqrs(:, d) = patt;        


    % RFrag
    rf = existsRFragInECG(Yd, Fs);
    if rf 
        i
        Sx

        T = getTimeVector(Fs, nn);
        subplot(2, 2, x);

        plot(T, patt, 'b-', 'LineWidth', 1.25);
        tit = ['RFrag (Lead-', ders{d}, ') - Patient ', num2str(x)];
        title (tit,        'Interpreter', 'Latex', 'FontSize', 16);
        ylabel('mV',       'Interpreter', 'Latex', 'FontSize', 14);
        
        if x > 2
            xlabel('Time (s)', 'Interpreter', 'Latex', 'FontSize', 14);
        end
        
        grid;
    end     
      
end

g2 = figure(2);
w = 900;
h = 600;
set(gcf, 'Position', [200 200 w h]);

fname = [save_dir, 'rfrag.paper2024.p1Sxi_10.11.17.png'];
print(g2, '-dpng', '-r600', fname);