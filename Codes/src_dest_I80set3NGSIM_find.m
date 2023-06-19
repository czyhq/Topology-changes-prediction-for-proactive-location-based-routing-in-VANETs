function [i1,i2,src,dest] = src_dest_I80set3NGSIM_find(t,cn)
if t < 111.0 % block 1
    
    if  t < 10.2
        src = 5;
        dest = 12;
        
    elseif t > 10 && t < 20.4
        src = 5;
        dest = 22;
        
    elseif t > 20.2 && t < 30.6
        src = 10;
        dest = 29;
        
    elseif t > 30.4 && t < 40.8
        src = 12;
        dest = 50;
        
    elseif t > 40.6 && t < 51.0
        src = 6;
        dest = 39;
        
    elseif t > 50.8 && t < 60.0
        src = 3;
        dest = 69;
        
    elseif t > 59.8 && t < 70.2
        src = 8;
        dest = 96;
        
    elseif t > 70 && t < 80.4
        src = 11;
        dest = 138;
        
    elseif t > 80.2 && t < 90.6
        src = 21;
        dest = 166;
        
    elseif t > 90.4 && t < 100.8
        src = 9;
        dest = 195;
        
    elseif t > 100.6 && t < 111.0
        src = 13;
        dest = 235;
        
    end
    
%% block 2    
elseif t > 110.8 && t < 213.0 
    
    if  t < 121.2
        src = 12;
        dest = 246;
        
    elseif t > 121.0 && t < 131.4
        src = 19;
        dest = 286;
        
    elseif t > 131.2 && t < 141.6
        src = 21;
        dest = 293;
        
    elseif t > 141.4 && t < 151.8
        src = 22;
        dest = 325;
        
    elseif t > 151.6 && t < 162.0
        src = 37;
        dest = 368;
        
    elseif t > 161.8 && t < 172.2
        src = 52;
        dest = 403;
        
    elseif t > 172.0 && t < 182.4
        src = 87;
        dest = 410;
        
    elseif t > 182.2 && t < 192.6
        src = 126;
        dest = 434;
        
    elseif t > 192.4 && t < 202.8
        src = 183;
        dest = 459;
        
    elseif t > 202.6 && t < 213.0
        src = 227;
        dest = 492;
        
    end
%% block 3
else
    if  t < 223.2
        src = 249;
        dest = 506;
        
    elseif t > 223.0 && t < 233.4
        src = 294;
        dest = 570;
        
    elseif t > 233.2 && t < 243.6
        src = 326;
        dest = 596;
        
    elseif t > 243.4 && t < 253.8
        src = 355;
        dest = 614;
        
    elseif t > 253.6 && t < 264
        src = 377;
        dest = 654;
        
    elseif t > 263.8 && t < 274.2
        src = 422;
        dest = 679;
        
    elseif t > 274 && t < 284.4
        src = 452;
        dest = 708;
        
    elseif t > 284.2 && t < 294.6
        src = 484;
        dest = 769;
        
    elseif t > 294.4
        src = 510;
        dest = 791;
        
    end

end
    
     i1 = find(cn==src);
     i2 = find(cn==dest);