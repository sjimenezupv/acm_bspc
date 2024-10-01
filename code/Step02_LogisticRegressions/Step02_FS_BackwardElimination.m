
% Number of variables
[~, ncols] = size(TFeatures);
IND_TRAIN = 1:ncols-2;


% Initial model
warning('off');
Step80_ACM_Leav1Out;
BEST_I = IND_TRAIN;
BEST_G = g;
stop   = false;

BEST_I_ITER = IND_TRAIN;



% Main backward-elimination loop
while ~isempty(IND_TRAIN) && ~stop
    
    
    IND_TRAIN_COPY = BEST_I_ITER;
    BEST_G_ITER    = -1.0;
    BEST_I_ITER    = [];
    
    % Get the best index to be removed
    for ii = 1 : length(IND_TRAIN_COPY)
       IND_TRAIN = IND_TRAIN_COPY;
       
       % Remove the ii column
       IND_TRAIN(ii) = []; 
       Step80_ACM_Leav1Out;
       
       if g > BEST_G_ITER
           BEST_G_ITER = g;
           BEST_I_ITER = IND_TRAIN;
       end
    end
    
    if BEST_G - BEST_G_ITER <= 0.01
       BEST_G = BEST_G_ITER;
       BEST_I = BEST_I_ITER;
       fprintf('Iteration Best Improvement: G=%.4f\n', BEST_G);
    else
        stop = true;
        fprintf('STOP >>> Iteration Not Improved results\n');
    end
end


% Initial model
fprintf('\n\n¡¡¡¡¡¡¡ >>>>> Best Backward-Elimination Results <<<<< !!!!!!\n');
IND_TRAIN = BEST_I;
Step80_ACM_Leav1Out;

warning('on');

