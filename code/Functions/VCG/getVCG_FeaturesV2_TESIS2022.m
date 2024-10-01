function [ S ] = getVCG_FeaturesV2_TESIS2022( vcg, debug_flag )

    if nargin < 2
        debug_flag = false;
    end

    % Get the length of the vcg
    [n, ~] = size(vcg);   
        
    % Phi vector
    phi = zeros(1, n-2);
    
    % Do the whole circle? (a point is missing)
    for i = 2 : n-1
        
        v1 = vcg(i-1, :)';
        v2 = vcg(i,   :)';
        v3 = vcg(i+1, :)';
        
        z1 = v2 - v1;
        z2 = v3 - v2;
        
        nz1 = norm(z1);
        nz2 = norm(z2);
        
        phi(i) = acos( (z1'* z2) / ( nz1 * nz2 ));
        
    end    
    
    SF = (2*pi) / sum(phi); % S parameter
    
    x = vcg(:, 1);
    y = vcg(:, 2);    
    z = vcg(:, 3);
    
    [R2x, D1x, D2x] = getValues(x, [y, z], false);
    [R2y, D1y, D2y] = getValues(y, [x, z], false);
    [R2z, D1z, D2z] = getValues(z, [x, y], false);
    
    [ ~, idx ] = max([R2x, R2y, R2z]);
    
    M = [R2x, D1x, D2x; ...
         R2y, D1y, D2y; ...
         R2z, D1z, D2z];
    
     S = M(idx, :);
     S = [S, SF];
     
     if debug_flag
         if idx == 1
             getValues(x, [y, z], true);
         elseif idx == 2
             getValues(y, [x, z], true);
         elseif idx == 3             
             getValues(z, [x, y], true);
         end
     end
     
     
     
     Vn = sqrt((x .^ 2) + (y .^ 2) + (z .^ 2));
     Vn(Vn < 0.25) = [];
     if isempty(Vn)
         warning('Empty Vn');
         rt = 0.0;
     else
        rt = max(Vn) ./ mean(Vn);    
     end
     
     S = [S, rt];
end

function [R2, D1, D2] = getValues(y, X, debug_flag)

    X = [ones(length(y), 1), X];
    [b, ~, ~, ~, stats] = regress(y, X);    
    R2 = stats(1); % R2 parameter
    %stats

    n = length(y);
    
    yhat = b(1) + b(2)*X(:, 2) + b(3)*X(:, 3);
    D    = sqrt(sum((y-yhat).^2)); % Distance
    D1   = D / n;                  % Distance (average)   (D1)
    D2   = (power(D, 1/n)-1)*1000; % Distance (geometric) (D2)

    
    
    
    if debug_flag == true
        plot_vcg(y, X(:, 2), X(:, 3), b);
    end    
    
end

function plot_vcg(x, y, z, b)
    
    figure;
    subplot (1, 2, 1);
    plot_aux(x, y, z, b);
    title('VCG(QRS) (View 1)', 'Interpreter', 'Latex', 'FontSize', 14);
    view([136.01 14.36]);
    %view(3);
    
    subplot (1, 2, 2);
    plot_aux(x, y, z, b); 
    az = 0; el = 0; view([0 0 1]);
    title('(View 2)', 'Interpreter', 'Latex', 'FontSize', 14); % x, y    
    
    set(gcf, 'Position', [100, 100, 800, 350]);

end

function plot_aux(x, y, z, b)

    % the dependent variable is 'x'

    hold on;
    line(x, y, z, 'LineWidth', 1.5, 'Color', 'b');
    hold on;
    yfit = linspace(min(y), max(y), 15);
    zfit = linspace(min(z), max(z), 15);
    [YFIT, ZFIT] = meshgrid(yfit, zfit);
    XFIT = b(1) + b(2)*YFIT + b(3)*ZFIT;
    
    surf(XFIT, YFIT, ZFIT, 'facecolor', 'red', 'facealpha', 0.7, 'EdgeColor', 'none');
    
    % PLOT AXIS
    xa = [min(x) max(x)];
    ya = [min(y) max(y)];
    za = [min(z) max(z)];
    p0 = [0, 0];
    lw = 1;
    line(xa, p0, p0, 'Color','k', 'LineWidth', lw); 
    line(p0, ya, p0, 'Color','k', 'LineWidth', lw);
    line(p0, p0, za, 'Color','k', 'LineWidth', lw);
    
    fs = 14;
    xlabel('X', 'Interpreter', 'Latex', 'FontSize', fs);
    ylabel('Y', 'Interpreter', 'Latex', 'FontSize', fs);
    zlabel('Z', 'Interpreter', 'Latex', 'FontSize', fs);
    view(50, 10)
    grid
    hold off

end
