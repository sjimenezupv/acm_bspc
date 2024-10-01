
%clear all;
%clc;


%% Generate the structs according to the input folder
F = 'D:/GitHub/acm_bspc/data/';

%% Gender folder
%  ''        -->  both sexes data folder
% 'SEX/MEN'   --> men   data folder
% 'SEX/WOMEN' --> women data folder
%  (Comment/Uncomment as needed)
GENDER = '';
%GENDER = 'SEX/MEN/';
%GENDER = 'SEX/WOMEN/';

% Full path to data folders 
DIRS = { ...
     [F, 'PACIENTS.biV/', GENDER], ...
     [F, 'PACIENTS.LV/',  GENDER],  ...
     [F, 'CONTROLS.ACM/', GENDER], ...
};


% Class string for each class
DIR_CLASS_STR = { ...
    'PACIENTS.biV', ...
    'PACIENTS.LV',  ...
    'CONTROLS.ACM', ...
};

% Class identifier
DIR_CLASS_ID = [ ...    
    1, ...
    2, ...
    6, ...
];


% Initialize the global variables
NUM_ECG_DIR_INFO = length(DIRS);
ECG_DIR_INFO_DB  = cell(NUM_ECG_DIR_INFO, 1);
TOTAL_ECG_FILES  = 0;

for i = 1 : NUM_ECG_DIR_INFO
    ECG_DIR_INFO               = {};
    ECG_DIR_INFO.DIR           = strrep( char( strjoin( string(DIRS{i}) )), ' ', '');
    ECG_DIR_INFO.CLASS_STR     = DIR_CLASS_STR{i};
    ECG_DIR_INFO.CLASS         = DIR_CLASS_ID(i);
    ECG_DIR_INFO.AFFECTED      = DIR_CLASS_ID(i) < 5 ;
    [ECG_DIR_INFO.files, ECG_DIR_INFO.NUM_FILES] = getFilesList(DIRS{i}, '.xml');
    
    ECG_DIR_INFO_DB{i} = ECG_DIR_INFO;
    TOTAL_ECG_FILES    = TOTAL_ECG_FILES + ECG_DIR_INFO.NUM_FILES;
end

clear CLASES CLASES_STR DIRS ECG_DIR_INFO i



%% Struct Initialization
ECGS = cell(TOTAL_ECG_FILES, 1);
idx  = 1;


for i = 1 : NUM_ECG_DIR_INFO
    
    DIR_INFO = ECG_DIR_INFO_DB{i};
    
    for j = 1 : DIR_INFO.NUM_FILES

        % Get the file name & id
        file_name = [DIR_INFO.DIR, DIR_INFO.files(j).name];
        [~,   id] = fileparts(file_name);

        % Initialize struct
        Sx = {};
        
		% Read the ECG-XML file
        [ Sx.Y, Sx.Fs, ~, years, sex ] = readPhilipsXML(file_name);
		
        % Fill the fields
        Sx.Y(end-499:end, :) = [];            % Remove the calibration line
        Sx.Y                 = Sx.Y .* 0.005; % Convert to mV (La-Fe Hospital XML file resolution)
        Sx.Info.FileId       = id;
        Sx.Info.PatientId    = id;
        Sx.Info.PatientAge   = years;
        Sx.Info.PatientSex   = sex;
        Sx.file_name         = file_name;
        Sx.id                = id;
        Sx.class_str         = DIR_INFO.CLASS_STR;
        Sx.class             = DIR_INFO.CLASS;
        Sx.Affected          = DIR_INFO.AFFECTED;
        
        % Artifacted signal in V1
        if (strcmp(Sx.id, '1708683')==1)
            Sx.Y(1:1900, 7) = 0; % Remove the artifact
        end
        
        % Signal Filtering
        Sx.YFiltered = Filter_ACM(Sx.Y, Sx.Fs);
        
        % Add the struct to DB
        ECGS{idx} = Sx;
        idx       = idx+1;
    end
    
end


%% Init Table
Id        = cell(TOTAL_ECG_FILES, 1);
FileId    = cell(TOTAL_ECG_FILES, 1);
PatientId = cell(TOTAL_ECG_FILES, 1);
Years     = cell(TOTAL_ECG_FILES, 1);
Sex       = cell(TOTAL_ECG_FILES, 1);
class_str = cell(TOTAL_ECG_FILES, 1);
class     = cell(TOTAL_ECG_FILES, 1);
Affected  = cell(TOTAL_ECG_FILES, 1);

for i = 1 : TOTAL_ECG_FILES        
    Sx           = ECGS{i};
    Id{i}        = Sx.id;
    FileId{i}    = Sx.Info.FileId;
    PatientId{i} = Sx.Info.PatientId;
    Years{i}     = Sx.Info.PatientAge;
    Sex{i}       = Sx.Info.PatientSex;
    class_str{i} = Sx.class_str;
    class{i}     = Sx.class;
    Affected{i}  = Sx.Affected;
end


%% Create the data-table
ACM_T = table(         ...
            Id,        ...
            FileId,    ...
            PatientId, ...
            Years,     ...
            Sex,       ...
            class_str, ...
            class,     ...
            Affected   ...
);


%% Print Info DB
fprintf('Idx\tId\tAge\tSex\tClassStr\tClass\tAffected\n');
for i = 1 : TOTAL_ECG_FILES    
    
    Sx        = ECGS{i};
    id        = Sx.id;
    age       = Sx.Info.PatientAge;
    sex       = Sx.Info.PatientSex;
    classStr  = Sx.class_str;
    class     = Sx.class;
    affected  = Sx.Affected;
    
    fprintf('%3d\t%s\t%d\t%s\t%-12s\t%d\t%d\n', i, id, age, sex, classStr, class, affected);
end
