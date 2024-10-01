function createDir( dir_path )
%CREATEDIR Create the spedified folder

    if exist(dir_path, 'dir') ~= 7
        mkdir(dir_path);
    end

end

