% Utility script

for i = 1 : length(ECGS)    

    Sx        = ECGS{i};
    id        = Sx.id;
    class_str = Sx.class_str;
    yf        = Sx.YFiltered;
    
    % Get the t-wave figure
    [ t_mask, t_indices, t_values, diff_qt_ms, tareas ] = getTWave( yf(:, 12), Fs, 100, 300, true );
    
	% Common variables
    lblFSz = 16;
    interp = 'latex';
    hFig   = figure(2);
    w      = 900;
    h      = 600;
    set(hFig, 'Position', [100 100 w h]);

	% Save the figure
    set(gca,'TickLabelInterpreter','latex');
    outf = ['D:/GitHub/acm_bspc/results/twave.', class_str, '.', id, '.png'];
    print(outf, '-dpng', '-r600');

end