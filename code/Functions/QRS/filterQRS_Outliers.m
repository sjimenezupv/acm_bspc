function [ qrs, qrs_values, qrs_indices ] = filterQRS_Outliers( ecg, qrs, Fs )
%FILTERQRS_OUTLIERS Filter the QRS complexes from an ECG until there are no outliers left in the group of QRS complexes
    

    %%%%%%% WARNING, THIS CAUSES DOING NOTHING!. Previous value = 4
    max_iter     = 0;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Local variables
    num_outliers = 1;
    k            = 0;
    N            = length(ecg);
    
    % 30 seconds window
    num_secs = 30;
    win      = round(num_secs * Fs);
    
    while num_outliers > 0 && k < max_iter
        
        qrs_indices = find(qrs==1);
        
        idx_outliers = [];
        win_ini = 1;
        win_fin = win;
        
        % Check for outliers in segments of NUM_SECS seconds
        while win_ini <= N
            
            if win_fin > N
                win_fin = N;
            end
            
            aux = qrs_indices;
            aux(aux<win_ini) = [];
            aux(aux>win_fin) = [];
            
            qrs_values  = ecg(aux);
            
            [umbral_up, umbral_down] = getOutliersThreshold(qrs_values, 4);
            
            % R indexes
            aux = find(qrs_values < umbral_down | qrs_values > umbral_up);
            
            % Center them again in their location
            %aux = aux + win_ini - 1;
            
            % Append those index to the outliers
            idx_outliers = [idx_outliers; aux];
            
            % Move forward the window
            win_ini = win_ini + win;
            win_fin = win_fin + win;
        end
        
        
        % Convert to the actual indices in the ECG
        idx_qrs = qrs_indices(idx_outliers);
        
        % Count the total number of outliers
        num_outliers = length(idx_outliers);
        
        % If outliers exist
        if num_outliers > 0
            % Remove them from the QRS
            qrs(idx_qrs) = 0;
        end
        
        % Minimum convergence criterion
        k = k + 1; 
    end
    
    if nargout > 1; qrs_values  = ecg(qrs==1);  end    
    if nargout > 2; qrs_indices = find(qrs==1); end

end

