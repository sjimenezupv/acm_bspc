
close all;
G1 = figure;

for i = 1 : TOTAL_ECG_FILES    
    
    Sx = ECGS{i};
    fprintf('%d\t%s \n', i, Sx.id);    
    
    Y  = Sx.YFiltered;
    plot12Leads( Y, Sx.Fs, Sx.id, G1 );
    pause;
    
end