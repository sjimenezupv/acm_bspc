function [cm, sens, esp, vpp, vpn, rvp, rvn, g, acc, ic_1, ic_2, IC] = ...
    myconfusion(y, y_hat)
    
    % Confusion matrix
    %cm = crosstab(~y, ~y_hat);
    
    y_hat(isnan(y_hat)) = 0;
    
     % Para demostrar que esta función está bien
     yy = ~y;
     yh = ~y_hat;    
     aux = yy+yh;    
     vp = sum(aux==0);
     vn = sum(aux==2);    
     fp = sum(yy==1 & yh==0);
     fn = sum(yy==0 & yh==1);
     
     cm = [vp, fp; fn, vn];


    %%% CONFUSION MATRIX VALUES %%%%%
    sens = cm(1,1)/(cm(1,1)+cm(2,1));
    esp  = cm(2,2)/(cm(2,2)+cm(1,2));

    vpp = cm(1,1)/(cm(1,1)+cm(1,2));
    vpn = cm(2,2)/(cm(2,2)+cm(2,1));

    % Positive and negative likelihood ratio
    rvp = sens/(1 - esp);
    rvn = (1 - sens)/esp;
    
    g = sqrt(sens*esp);
    
    % accuracy
    NNN = sum(sum(cm));
    ACIERTOS = cm(1,1) + cm(2,2);
    acc=ACIERTOS/NNN;
    IC = 1.96*sqrt(acc*(1-acc))/sqrt(NNN);
    ic_1 = acc-IC;
    ic_2 = acc+IC;
    
end

