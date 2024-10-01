function [ VCG ] = getVCG( ECG, plot_flag )
%GETVCG Get the VCG according to V1-V6, I, II leads
% 
% INPUTS:
%     ECG: 12-lead matrix in standard ordering (I, II, ..., V1, ..., V6)
%     ECG:  8-lead matrix in order (V1-V6, I, II)
%     plot_flag: Opcional (Default false) - Indica si plotear el VCG
%
% OUTPUS: 
%     VCG: 3-D matrix (NumSamples X 3) containing the Vectorcardiogram
%

    % We need V1-V6, I, II
    [n, m] = size(ECG);
    if n > m
        NumChannels = m;
        if NumChannels == 12
            X = ECG(:, [7, 8, 9, 10, 11, 12, 1, 2]);
        elseif NumChannels == 8
            X = ECG;
        else
            error('Can not get VCG without leads V1-V6, I, II');
        end            
    else
        NumChannels = n;
        if NumChannels == 12
            X = ECG([7, 8, 9, 10, 11, 12, 1, 2], :)';
        elseif NumChannels == 8
            X = ECG';
        else
            error('Can not get VCG without leads V1-V6, I, II');
        end
    end
    
    % Although several methods have been proposed for synthesizing the VCG from the 12-lead ECG,
    % the inverse transformation matrix of Dower is the most commonly used [31]. Dower et al. presented
    % a method for deriving the 12-lead ECG from Frank lead VCG [44]. Each ECG lead is calculated as
    % a weighted sum of the VCG leads X, Y and Z using lead-specic coefcients based on the image
    % surface data from the original torso studies by Frank [45]. The transformation operation used to
    % derive the eight independent leads (V1-V6, I and II) of the 12-lead ECG from the VCG leads is
    % given by, s=Dv, where 

%     D = [  
%     -0.515  0.157   -0.917;
%      0.044  0.164   -1.387;
%      0.882  0.098   -1.277;
%      1.213  0.127   -0.601;
%      1.125  0.127   -0.086;
%      0.831  0.076    0.230;
%      0.632 -0.235    0.059;
%      0.235  1.066   -0.132];



    % where s(n)=[V1(n) V2(n) V3(n) V4(n) V5(n) V6(n) I(n) II(n)]^T and v(n)=[X(n) Y (n) Z(n)]^T
    % contain the voltages of the corresponding leads, n denotes sample index and D is called the Dower
    % transformation matrix. From s=Dv, it follows that the VCG leads can be synthesized from the 12-lead
    % ECG by  v(n) = Ts(n);  where T=pinv(D'*D)*D' is called the inverse Dower transformation matrix 
    % and is given by

    T = [ -0.172 -0.074  0.122  0.231 0.239 0.194  0.156 -0.010 ;
           0.057 -0.019 -0.106 -0.022 0.041 0.048 -0.227  0.887 ;
          -0.229 -0.310 -0.246 -0.063 0.055 0.108  0.022  0.102 ];

    % check with    TT=pinv(D'*D)*D';

    % so the inverse Dower transform is :  
    VCG = T*X';
    VCG = VCG';
    
    % Plot?
    if nargin > 1 && plot_flag == true
        plotVCG(VCG);
    end


end

