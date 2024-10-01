function [ th ] = getBestThreshold(ths, y_hat, y)
%UNTITLED Selects the best threshold
%   Looks for the best sqrt(sens*esp) relationship

    % Vars initialization
    best_g  = -1;
    best_th = -1;
    ths = [ths; 0.5];
    n = length(ths);
    
    for i=1 : n
         th = ths(i);
         g_y    = y_hat >= th;
         [~, sens, esp, ~, ~, ~, ~, ~] = myconfusion(y, g_y);

         g = sqrt(sens*esp);

         if(g >= best_g)
             best_g  = g;
             best_th = th;
         end
    end
    th = best_th;
end
