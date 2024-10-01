
% Number of variables
[~, ncols] = size(TFeatures);
NF         = ncols-2;

warning('off');

% Initial model
BEST_I = [];
BEST_G = -1.0;

% Main backward-elimination loop
for iii = NF
    
    v = 1:NF;
    
    for jjj = 1 : NF
        C = nchoosek(v, jjj);
        
        [nn, mm] = size(C);
        
        for KKK = 1 : nn
    
            IND_TRAIN = C(KKK, :);
            Step80_ACM_Leav1Out;

            if g > BEST_G
               BEST_G = g;
               BEST_I = IND_TRAIN;
               fprintf('Iteration Best Improvement: G=%.4f\n', BEST_G);
            end
        end
    end
end
    


%% Final model
fprintf('\n\n¡¡¡¡¡¡¡ >>>>> Best ALL Results <<<<< !!!!!!\n');
IND_TRAIN = BEST_I;
Step80_ACM_Leav1Out;

warning('on');
