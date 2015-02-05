function [LAI,FAVD,P,Wave,CC] = wave2lai(shotnumber,LGE,LGW)

% LAI = waveform derived LAI
% P = vertical gap probability
% I = vertical intentsity
% shotnumber = waveform number
% LGE = ground elevation file
% LGW = waveform file

[n,m] = size(shotnumber);
for i = 1:n
    sg = find (LGE(:,2) == shotnumber(i,1)); % find shotnumber in LGE
    sw = find (LGW(:,2) == shotnumber(i,1)); % find shotnumber in LGW
    Zg = LGE(sg,6); % Ground elevation
    Zh = LGW(sw,6); % Elevation above sea level at begining of recording (somewhere in the atmosphere)
    Zl = LGW(sw,9); % Elevation above sea level at end of recording (under the ground)
    rh100 = LGE(sg,10); % maximum canopy height from the ground 
    Wave = zeros(2,432); % Nubmer of 30cm bins in each pulse is the same...i.e. 432...or around 129m
    Wave(1,1) = Zh-Zg; % Beginning of Canopy to end of recorded return
    Wave(2,1) = LGW(sw,11); % First Intensity value
    for k = 2:432
        Wave(1,k) = Wave(1,(k-1))-((Zh-Zl)/432); % fill our Wave with Height bins.
        Wave(2,k) = LGW(sw,(k+10)); % Fill our Waveform with Intensity values
    end
    Wave = rot90(Wave); Wave = flipud(Wave); Wave(:,2) = Wave(:,2)-min(Wave(:,2)); % Get from Rows to Columns
    zrange = find(Wave(:,1) < (rh100+0.15) & Wave(:,1) > -2.31); % IDENTIFYER OF ALL INFO IN THE CANOPY, and GROUND RETURN
    
    %%%%% Calculate LAI %%%%% from Ni-Meister 2001: IEEE Trans. Geosc. R.S.
    Wave = Wave(min(zrange):max(zrange),:); % EXTRACT CANOPY & GROUND RETURN ONLY
    Wave(:,3) = cumsum(Wave(:,2)); %Rv ||| I.e. the cumulative vegetation return intensity
    Wave(:,4) = Wave(:,3)/(max(Wave(:,3))); %Rv(z)/Rv(0) ||| I.e. the fraction of vegetation return
    base = find(Wave(:,1) < (2+0.15) & Wave(:,1) > (2-0.15)); % Identify a canopy base BEFORE the ground...here I assume 2m.
    Rg = (max(Wave(:,3)))-(Wave(min(base),3)); %Rg ||| I.E. The full intensity of the Ground Return
    Rg_Rv0 = Rg/(max(Wave(:,3))); %Rg_Rv0 ||| I.E. the fraction of the Ground Return
    rhov_rhog = 0.82; % average from AVIRIS or assumed relationship from Sun&Ranson/GORT/Hyde_etal
    %rhov_rhog = shotnumber(i,2); % or this if relationship known for each pixel
    P = 1-Wave(:,4)*(1/(1+(rhov_rhog*Rg_Rv0))); % FINAL GAP FRACTION !!!!! How much is light is transmitted and returned
    T = P(min(base)); % Transmittance - Need to calculate LAI from Beer Law
    LAI(i,1) = -log(T)/(0.5*1); % Beer Law for calculating LAI. 0.5 is the extinction coefficient, and assume spherical distribution.

    % EXTRA STUFF...NOT NEEDED %%%%%
    %%%%% Canopy Cover (CC) and Foliage Area Volume Density (FAVD) %%%%%
    FAVD = -log(P); %normally should divide by G and clumping factor
    CC = (1/(1+(rhov_rhog*Rg_Rv0))); % Canopy Cover at ground

    %%%%% Visualise pulse if wanted %%%%%
    x = 0:max(Wave(:,2));
    %figure, plot (Wave(:,2),Wave(:,1),'r.', x,min(Wave(:,1)),'r:', x,max(Wave(:,1)),'r:');
    %figure, plot (Wave(:,4),Wave(:,1),'r.');
    i/n;
end


    
    
    
    
    
    
    
    