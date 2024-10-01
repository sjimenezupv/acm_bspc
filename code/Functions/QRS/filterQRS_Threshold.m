function [ qrs ] = filterQRS_Threshold( ecg, qrs )
%FILTERQRS_THRESHOLD Filter QRS complexes that do not exceed 20% of the mean

    qrs_values  = ecg(qrs==1);
    qrs_indices = find(qrs==1);
    qrs_mean    = abs(mean(qrs_values));
    umbral      = qrs_mean - (abs(qrs_mean * 0.8));
    END         = length(qrs_indices); 
    for i = 1 : END
        index = qrs_indices(i);
        v     = abs(ecg(index));
        if v < umbral
            qrs(index) = 0;
        end
    end

end

