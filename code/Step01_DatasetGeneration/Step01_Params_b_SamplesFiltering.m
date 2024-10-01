
%% Rows filtering

T_ID = [ACM_T.FileId, ACM_T.class, ACM_T.class_str];

PatientId = ACM_T.PatientId;
FileId    = ACM_T.FileId;
class     = cell2mat(ACM_T.class);
class_str = ACM_T.class_str;


%% Copy original table to T2
T2=T;

%% Set the class str
class_str(class==1) = {'biV'};
class_str(class==2) = {'VI'};
class_str(class==6) = {'FAM'}; % ACM relatives not affected


%% We will perform PATIENTS vs CONTROLS study
class(class ~= 6) = 1;
class(class == 6) = 0;
class_str(class==0) = {'Control'}; % ACM relatives not affected
class_str(class==1) = {'ACM'};     % ACM affected (LV, biV)


%% Look for repeated samples
%clc;
myMap = containers.Map();
num_samples = length(class);
filtro      = class > 100000; % Dumb array of falses
for i = 1 : num_samples
   
    fid = FileId{i};
    pid = PatientId{i};
    cid = class_str{i};
    
    if myMap.isKey(pid)
        myMap(pid) = [myMap(pid), cellstr([cid, '-', fid])];
        filtro(i)  = true;
    else
        myMap(pid) = cellstr([cid, '-', fid]);
    end
end


% Print repeated samples
keys = myMap.keys;
for i = 1 : length(keys)
    
    key    = keys{i};
    values = myMap(key);
    
    % Print header
    if i == 1 && length(values) > 1
        fprintf('LIST OF REPEATED AND FILTERED SAMPLES \n');    
        fprintf('hno\tIDECGDig1\n');
    end
    
    % Print repeated samples
    if length(values) > 1
        fprintf('%s ', key);
        for j = 1 : length(values)
            fprintf('\t%s', values{j});
        end
        fprintf('\n');
    end
end
fprintf('#samples= %d \n', length(keys));


%% Filter repeated samples
class(filtro)       = [];
class_str(filtro)   = [];
T2(filtro, :)       = [];
PatientId(filtro)   = [];
FileId(filtro)      = [];