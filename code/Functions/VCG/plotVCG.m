function [ G ] = plotVCG( VCG )
%PLOTVCG Plotea un VCG

    S = getVCG_Features( VCG, true );
    fprintf('S=%f  R2=%f  D1=%f\n', S(1), S(2), S(3));
    

    G = figure;
    plot3(VCG(:, 1), VCG(:, 2), VCG(:, 3))    
    legend('Inverse Dower X')
    xlabel ('samples (ms)');
    ylabel ('Amplitude');
    
end

