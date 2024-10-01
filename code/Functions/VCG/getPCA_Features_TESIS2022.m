function [ C1, C2 ] = getPCA_Features_TESIS2022( Y )
%GETPCA_FEATURES Get the PCA features
    
    [~, ~, EigV] = pca(Y');    
    
    C1 = sum(EigV(4:8))/sum(EigV(1:8));
    C2 = sum(EigV(3))  /sum(EigV(1:2));

end

