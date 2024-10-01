function [ rfrag ] = existsRFragInR(ecg)
% EXISTSRFRAGINR Determine if exist RFrag in the R-wave
%
% INPUT: 
%   ecg : Ecg segment containing a QRS wave
%
% OUTPUT:
%   rfrag: 1-RFrag exist. 0-Not
	
	[maxim, pos1] = max(ecg);
	[minim, pos2] = min(ecg);

	minim=abs(minim);

    if minim > maxim 
        ecg  = -ecg; 
        pos1 = pos2; 
        maxim = minim;
    end
    
    umbral = 0.1 * maxim;
    

	% find the first positive value
	neg = find(ecg(1:pos1) < umbral);
    
    if isempty(neg)
        inicio = 1;
    else
        inicio = neg(end)+1;
    end

	% find the last positive value
	neg = find(ecg(pos1:end) < umbral);
    if isempty(neg)
        fin = length(ecg);
    else
        fin = pos1 + neg(1) - 2; % -2 since matlab is 1-index-based
    end
    

	ecg  = ecg(inicio:fin);
	der1 = diff(ecg);
	der2 = diff(der1);

	pos2    = find(der2<0);
	der2    = der2(pos2(1):pos2(end));
	cambios = length(find(diff(sign(der2))));

    if cambios > 1 
        rfrag = 1; 
    else
        rfrag = 0;
    end
    
end
