function [ qrs ] = filterQRS_TooClose( ecg, qrs, windowStep )
%FILTERQRS_TOOCLOSE Filter QRS too close


    qrs_indices = find(qrs==1);
    END = length(qrs_indices);    
    for i = 1 : END
        
        valueI = abs(ecg(qrs_indices(i)));
        j = i+1;
        while j <= END && qrs_indices(j) - qrs_indices(i) <= windowStep            
            
            valueJ = abs(ecg(qrs_indices(j)));
            if(valueI > valueJ)
                qrs(qrs_indices(j)) = 0;
            else
                qrs(qrs_indices(i)) = 0;
            end
            j = j+1;
        end
    end
end

