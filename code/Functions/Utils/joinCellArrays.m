function [ V ] = joinCellArrays( V1, V2 )
%JOINCELLARRAYS Join Cell Arrays


    NV1 = length(V1);
    NV2 = length(V2);
    N   = NV1+NV2;    
    V   = cell(N, 1);

    for i = 1 : NV1
        V{i} = V1{i};
    end
    
    idx = NV1+1;
    for i = 1 : NV2
        V{idx} = V2{i};
        idx    = idx+1;
    end

end

