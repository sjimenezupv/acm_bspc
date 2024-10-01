function [ G ] = plot12Leads( Y, Fs, tit, G, R_Indices )
%PLOT12DERIV Plot the 12-leads ECG matrix


    derivs = { ...
        '{\emph{I}}',   '{\emph{II}}',  '{\emph{III}}', ...
        '{\emph{aVR}}', '{\emph{aVL}}', '{\emph{aVF}}', ...
        '{\emph{V1}}',  '{\emph{V2}}',  '{\emph{V3}}', ...
        '{\emph{V4}}',  '{\emph{V5}}',  '{\emph{V6}}' };

    if nargin > 3 && G ~= 0
        figure(G);
    else
        G = figure;
    end
    
    if nargin < 5
        rt = [];
    else
        rt = R_Indices ./ Fs;
        ot = ones(size(rt));
    end
        
    
    [NumSamples, NumChannels] = size(Y);
    if iscell(Y) == 0 && NumChannels > NumSamples
        Y = Y';
        [NumSamples, NumChannels] = size(Y);
    elseif iscell(Y) == 1
        NumChannels = max(size(Y));
    end    
    
    [ num_rows, num_cols ] = getBestSubplotSize( NumChannels );
    

    
    clf;
    for i = 1 : NumChannels
        subplot(num_rows, num_cols, i);        
        hold on;
        
        if iscell(Y) == 0
            T = getTimeVector(Fs, NumSamples);
            plot(T, Y(:, i), 'b-', 'LineWidth', 1.1);
            grid;
            
            if ~isempty(rt)
                mx = max(Y(R_Indices, i));
                mi = min(Y(R_Indices, i));
                if abs(mi) > abs(mx)
                    mx = mi;
                end
                stem(rt, ot .* mx, 'r-');
            end
        else
            T = getTimeVector(Fs, length(Y{i}));
            plot(T, Y{i}, 'b-', 'LineWidth', 1.1);
            grid;
            
            if ~isempty(rt)
                mx  = max(Y{i});
                mi = min(Y{i});
                if abs(mi) > abs(mx)
                    mx = mi;
                end
                stem(rt, ot .* mx, 'r-');
            end
        end
        hold off;
        
        if i <= length(derivs)
            title(derivs{i}, 'FontSize', 13, 'Interpreter', 'latex');
        end
        
    end
    
    % Borramos el título si tenemos que plotear en una gráfica anterior
    if nargin > 3
        delete(findall(gcf,'Tag','somethingUnique'))
    end
    
    % Ponemos el título
    if nargin > 2
            annotation('textbox',             [0 0.9 1 0.1], ...
                       'String',              tit, ...
                       'EdgeColor',           'none', ...
                       'HorizontalAlignment', 'center', ...
                       'Interpreter',         'none', ...
                       'Tag',                 'somethingUnique');
    end


end

