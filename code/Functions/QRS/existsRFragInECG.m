function [ rfrag ] = existsRFragInECG( ecg, Fs, R_indices, debug_flag )
%EXISTSRFRAGINECG Determine if there is RFrag in at least half of the R-peaks
%
% INPUT: 
%  ecg         : Ecg segment
%  Fs          : Sampling frequency
%  qrs_indices : R-peaks indexes (Optional)
%  debug_flag  : Flag indicating if perform some debug
%
% OUTPUT:
%  rfrag       : 1-RFrag exists. 0-RFrag DOES NOT exists


    % Default parameters
    if nargin < 3
        [ ~, R_indices, ] = getQRS( ecg, Fs );
    end
    
    if nargin < 4
        debug_flag = false;
    end

    % Local variables
    msOffset     = 80;    
    NECG         = length(ecg);   
    totqrs       = 0;
    num_mellados = 0;
    
     % Number of samples at each R-peak side
    offset = round(Fs * (msOffset/1000));



    for i = 1 : length(R_indices)

        index1 = R_indices(i) - offset;
        index2 = R_indices(i) + offset - 1;

        if index1 > 0 && index2 <= NECG
            
            senyal       = ecg(index1 : index2);
            rfrag        = existsRFragInR(senyal);
            num_mellados = num_mellados + rfrag;
            totqrs       = totqrs + 1;  
        end  
    end

    % At least half of the R-peaks must be RFrag
    if num_mellados >= totqrs / 2
        rfrag = true;
    else
        rfrag = false;
    end


    if debug_flag == true
        plot(ecg);
        grid;
        if rfrag == true
            title('YES');
        else
            title('NO');
        end
        pause;
    end
    
end

