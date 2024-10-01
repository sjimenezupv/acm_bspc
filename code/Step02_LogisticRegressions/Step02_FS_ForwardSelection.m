
% Number of variables
[~, ncols] = size(TFeatures);
NF        = ncols-2;

warning('off');

% Initial model
BEST_I = [];
BEST_G = -1.0;
stop   = false;
BEST_I_ITER = [];

% Main backward-elimination loop
while ~stop    
    
    IND_TRAIN_COPY = BEST_I_ITER;
    BEST_G_ITER    = -1.0;
    
    % Get the best index to be removed
    for ii = 1 : NF
       
        % Check that not contains the index           
        if sum(IND_TRAIN_COPY == ii) == 0 
           % Add the ii column
           IND_TRAIN = [IND_TRAIN_COPY, ii];
           Step80_ACM_Leav1Out;

           if g > BEST_G_ITER
               BEST_G_ITER = g;
               BEST_I_ITER = IND_TRAIN;
           end
       end
    end
    
    if BEST_G_ITER > BEST_G        
       BEST_G = BEST_G_ITER;
       BEST_I = BEST_I_ITER;
       fprintf('Iteration Best Improvement: G=%.4f\n', BEST_G);
    else
        stop = true;
        fprintf('STOP >>> Iteration Not Improved results\n');
    end
    
end


%% Final model
fprintf('\n\n¡¡¡¡¡¡¡ >>>>> Best Forward-Adding Results <<<<< !!!!!!\n');
IND_TRAIN = BEST_I;
Step80_ACM_Leav1Out;

warning('on');
