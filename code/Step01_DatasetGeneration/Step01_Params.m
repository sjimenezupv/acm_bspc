clc;


%% Cells initialization

% Features for each lead
NumFeatsLeads =  7;
NumDeriv      = 12;
FeaT_Leads = cell(NumDeriv, NumFeatsLeads);
for i = 1 : NumDeriv
    for j = 1 : NumFeatsLeads
        FeaT_Leads{i, j} = cell(TOTAL_ECG_FILES, 1);
    end
end

% Single ECG features (for 12 leads)
NumFeats = 17;
FeaT = cell(NumFeats);
for j = 1 : NumFeats
    FeaT{j} = cell(TOTAL_ECG_FILES, 1);
end


%% Set debug flag value
debug_flag = false;


%% Get the ECG Features
for i = 1 : TOTAL_ECG_FILES
    
    if mod(i, 50) == 0, fprintf('%4d', i); end    
    
    Sx = ECGS{i};
    Y  = Sx.YFiltered;
    Fs = Sx.Fs;
    
    Yqrs = zeros(100, 12);
    FeaT{16}{i, 1} = 0; % #RFrag
    FeaT{17}{i, 1} = 0; % #TNeg
    
    for d = 1 : 12
        
        Yd = Y(:, d);
                
        [~, midlev] = midcross(Yd, Fs, 'tolerance', 25);        
        [levels]    = statelevels(Yd);
        FeaT_Leads{d, 1}{i, 1} = midlev;
        FeaT_Leads{d, 2}{i, 1} = abs(levels(1)-levels(2));
        
        % R Fragmented
        rf = existsRFragInECG(Yd, Fs);
        FeaT_Leads{d, 3}{i, 1} = double(rf);
        if rf == true % Increment the counter??
            FeaT{16}{i, 1} = FeaT{16}{i, 1} + 1;
        end
        
        % T Negative
        tn    = false;
        tarea = 0;
        if (d ==1 || d ==2 || d ==10 || d ==11 || d ==12)
            [tn, tarea] = isTWaveNegative(Yd, Fs);
        end
        if tn == true % Increment the counter??
            FeaT{17}{i, 1} = FeaT{17}{i, 1} + 1;
        end
        FeaT_Leads{d, 4}{i, 1} = double(tn);
        FeaT_Leads{d, 5}{i, 1} = tarea;
        
        % Get the R amplitude
        [patt, ~, ~, rvalues]  = getQRS_Pattern3(Yd, Fs, 100, false);
        FeaT_Leads{d, 6}{i, 1} = mean(rvalues);
        
        % Save the pattern 
        Yqrs(:, d) = patt;
        
        % Get the QRS Area
        FeaT_Leads{d, 7}{i, 1} = trapz(patt);
        
    end % lead
    
end % file


%% QRS Pattern Features
QRS = cell(1, TOTAL_ECG_FILES);
for i = 1 : TOTAL_ECG_FILES
    
    if mod(i, 50) == 0, fprintf('%4d', i); end    
    
    Sx = ECGS{i};
    Y  = Sx.YFiltered;
    Fs = Sx.Fs;
    
    
    % Get the pattern from R-waves in V5
    IDX_REF  = 11; %% reference-lead index (V5)
    V5       = Y(:, IDX_REF);
    [qrsV5, qrsIndicesV5] = getQRS(V5, Fs, debug_flag, debug_flag);    
    Yqrs = zeros(100, 12);
    for d=1:12 
        Yqrs(:, d) = getQRS_Pattern3( Y(:, d), Fs,  100, debug_flag, qrsV5 ); % Patrones onda R   100-->80
    end
    QRS{i} = Yqrs;
end




%% Grouped Features
for i = 1 : TOTAL_ECG_FILES
    
    if mod(i, 50) == 0, fprintf('%4d', i); end    
    
    Sx   = ECGS{i};
    Y    = Sx.YFiltered;
    Fs   = Sx.Fs;
    Yqrs = QRS{i};

    % VCG Features
    vcg   = getVCG(Y);
    vcgf  = getVCG_FeaturesV2_TESIS2022(vcg);
    vcgR2 = vcgf(1);
    vcgD1 = vcgf(2);
    vcgD2 = vcgf(3);
    vcgS  = vcgf(4);
    vcgRT = vcgf(5);
    %pause;    
    %png_file= [SaveDir, 'VCG/', Sx.class_str, '.', Sx.id, 'VCG.png'];
    %print(1, '-dpng', '-r300', png_file);
    %close all;
    
    % VCG Features (QRS)
    vcgqrs   = getVCG(Yqrs);
    vcgfqrs  = getVCG_FeaturesV2_TESIS2022(vcgqrs);
    vcgqrsR2 = vcgfqrs(1);
    vcgqrsD1 = vcgfqrs(2);
    vcgqrsD2 = vcgfqrs(3)/10;
    vcgqrsS  = vcgfqrs(4);
    vcgqrsRT = vcgfqrs(5);   
    %pause;
    %png_file= [SaveDir, 'VCG/', Sx.class_str, '.', Sx.id, '.VCG.QRS.png'];
    %print(1, '-dpng', '-r300', png_file);
    %close all;    

    
    % PCA Features
    [pcaC1,    pcaC2]    = getPCA_Features_TESIS2022( Y );
    [pcaqrsC1, pcaqrsC2] = getPCA_Features_TESIS2022( Yqrs );
    
    % TWAD (I, II, V4, V5, V6)
    tareas = [ ...
        FeaT_Leads{ 1, 5}{i, 1} , ...
        FeaT_Leads{ 2, 5}{i, 1} , ...
        FeaT_Leads{10, 5}{i, 1} , ...
        FeaT_Leads{11, 5}{i, 1} , ...
        FeaT_Leads{12, 5}{i, 1}];
    
    mx   = max(abs(tareas));
    twad = sum(tareas ./ mx) ./ 5;
    
    % VCG
    FeaT{ 1}{i, 1} = vcgR2;
    FeaT{ 2}{i, 1} = vcgD1;
    FeaT{ 3}{i, 1} = vcgD2;
    FeaT{ 4}{i, 1} = vcgS;
    FeaT{ 5}{i, 1} = vcgRT;
    
    % VCG QRS
    FeaT{ 6}{i, 1} = vcgqrsR2;
    FeaT{ 7}{i, 1} = vcgqrsD1;
    FeaT{ 8}{i, 1} = vcgqrsD2;
    FeaT{ 9}{i, 1} = vcgqrsS;
    FeaT{10}{i, 1} = vcgqrsRT;
    
    % PCA
    FeaT{11}{i, 1} = pcaC1;
    FeaT{12}{i, 1} = pcaC2;
    
    % PCA QRS
    FeaT{13}{i, 1} = pcaqrsC1;
    FeaT{14}{i, 1} = pcaqrsC2;
    
    % TWAD
    FeaT{15}{i, 1} = twad;
    
end
fprintf('\n');

%% Creates a datatable containing the features
idxf = 1;
der_labels = getLabels12Leads();
T     = table();
for i = 1 : NumDeriv
    lbl = der_labels{i};
    for j = 1 : NumFeatsLeads
        T = [T, FeaT_Leads{i, j}];
    end
    T.Properties.VariableNames{idxf} = ['midLevel(', lbl, ')']; T.Properties.VariableUnits{idxf} = 'mV';        idxf = idxf + 1;
    T.Properties.VariableNames{idxf} = ['difLevel(', lbl, ')']; T.Properties.VariableUnits{idxf} = 'mV';        idxf = idxf + 1;
    T.Properties.VariableNames{idxf} = ['RFrag(',    lbl, ')']; T.Properties.VariableUnits{idxf} = 'RFrag';     idxf = idxf + 1;
    T.Properties.VariableNames{idxf} = ['TNeg(',     lbl, ')']; T.Properties.VariableUnits{idxf} = 'TNeg';      idxf = idxf + 1;
    T.Properties.VariableNames{idxf} = ['TArea(',    lbl, ')']; T.Properties.VariableUnits{idxf} = 'Area(mV)';  idxf = idxf + 1;    
    T.Properties.VariableNames{idxf} = ['RAmp(',     lbl, ')']; T.Properties.VariableUnits{idxf} = 'mV';        idxf = idxf + 1;
    T.Properties.VariableNames{idxf} = ['QRSArea(',  lbl, ')']; T.Properties.VariableUnits{idxf} = 'Area(mV)';  idxf = idxf + 1;
end

for j = 1 : NumFeats
    T = [T, FeaT{j}];
end
T.Properties.VariableNames{idxf} = 'R2(VCG)';      T.Properties.VariableUnits{idxf} = 'R2'; idxf = idxf + 1;
T.Properties.VariableNames{idxf} = 'D1(VCG)';      T.Properties.VariableUnits{idxf} = 'D1'; idxf = idxf + 1;
T.Properties.VariableNames{idxf} = 'D2(VCG)';      T.Properties.VariableUnits{idxf} = 'D2'; idxf = idxf + 1;
T.Properties.VariableNames{idxf} = 'S(VCG)';       T.Properties.VariableUnits{idxf} = 'S';  idxf = idxf + 1;
T.Properties.VariableNames{idxf} = 'RT(VCG)';      T.Properties.VariableUnits{idxf} = 'RT'; idxf = idxf + 1;
T.Properties.VariableNames{idxf} = 'R2(VCG(QRS))'; T.Properties.VariableUnits{idxf} = 'R2'; idxf = idxf + 1;
T.Properties.VariableNames{idxf} = 'D1(VCG(QRS))'; T.Properties.VariableUnits{idxf} = 'D1'; idxf = idxf + 1;
T.Properties.VariableNames{idxf} = 'D2(VCG(QRS))'; T.Properties.VariableUnits{idxf} = 'D2'; idxf = idxf + 1;
T.Properties.VariableNames{idxf} = 'S(VCG(QRS))';  T.Properties.VariableUnits{idxf} = 'S';  idxf = idxf + 1;
T.Properties.VariableNames{idxf} = 'RT(VCG(QRS))'; T.Properties.VariableUnits{idxf} = 'RT'; idxf = idxf + 1;
T.Properties.VariableNames{idxf} = 'C1(PCA)';      T.Properties.VariableUnits{idxf} = 'C1'; idxf = idxf + 1;
T.Properties.VariableNames{idxf} = 'C2(PCA)';      T.Properties.VariableUnits{idxf} = 'C2'; idxf = idxf + 1;
T.Properties.VariableNames{idxf} = 'C1(PCA(QRS))'; T.Properties.VariableUnits{idxf} = 'C1'; idxf = idxf + 1;
T.Properties.VariableNames{idxf} = 'C2(PCA(QRS))'; T.Properties.VariableUnits{idxf} = 'C2'; idxf = idxf + 1;
T.Properties.VariableNames{idxf} = 'TWAD';         T.Properties.VariableUnits{idxf} = 'TWAD';     idxf = idxf + 1;
T.Properties.VariableNames{idxf} = 'Num_Rfrag';    T.Properties.VariableUnits{idxf} = 'NumRFrag'; idxf = idxf + 1;
T.Properties.VariableNames{idxf} = 'Num_TNeg';     T.Properties.VariableUnits{idxf} = 'NumTNeg';  idxf = idxf + 1;


%% Statistical Analysis
Step01_Params_a_AnalizeTFeatures_ACM2024;