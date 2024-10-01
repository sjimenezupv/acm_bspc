% Utility script

for i = 1 : length(ECGS)    

    Sx        = ECGS{i};
    id        = Sx.id;
    class_str = Sx.class_str;
    yf        = Sx.YFiltered;
    yo        = CutSignal( Sx.Y, Fs, 0.5, 0.5 );
    t         = getTimeVector(Fs, length(yo(:, 1)));

    % Common variables
    lblFSz = 16;
    interp = 'latex';

	% Plot the filtered vs unfiltered figure
    figure(3);
	
	% Original ECG
    subplot(2, 1, 1);
    cla;        
    plot(t, yo(:, 1), 'b-', 'LineWidth', 1.25);
    grid;
    ylabel('mV', 'Interpreter', interp, 'FontSize', lblFSz);  
    xlabel("Time (s)" + newline + " ", 'Interpreter', interp, 'FontSize', lblFSz);
    title('Original ECG (Lead-I)', 'Interpreter', interp, 'FontSize', lblFSz);

	% Filtered ECG
    subplot(2, 1, 2);
    cla;
    plot(t, yf(:, 1), 'b-', 'LineWidth', 1.25);
    grid;
    ylabel('mV',       'Interpreter', interp, 'FontSize', lblFSz);
    xlabel('Time (s)', 'Interpreter', interp, 'FontSize', lblFSz);
    title('Filtered ECG (Lead-I)', 'Interpreter', interp, 'FontSize', lblFSz);

    hFig = figure(3); w = 900; h = 605; % original h was 600
    set(hFig, 'Position', [100 100 w h]);

	% Save the results
    set(gca,'TickLabelInterpreter','latex');
    outf = ['D:/GitHub/acm_bspc/results/', class_str, '.', id, '.png'];
    print(outf, '-dpng', '-r400');

end