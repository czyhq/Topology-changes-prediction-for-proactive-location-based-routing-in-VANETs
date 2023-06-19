function [i1,i2,src,dest] = src_dest_I80set1NGSIM_find(t,cn)
if t < 111.0 % block 1
    
    if  t < 10.2
        src = 1;
        dest = 36;
        
    elseif t > 10 && t < 20.4
        src = 11;
        dest = 54;
        
    elseif t > 20.2 && t < 30.6
        src = 4;
        dest = 74;
        
    elseif t > 30.4 && t < 40.8
        src = 5;
        dest = 90;
        
    elseif t > 40.6 && t < 51.0
        src = 2;
        dest = 122;
        
    elseif t > 50.8 && t < 60.0
        src = 5;
        dest = 141;
        
    elseif t > 59.8 && t < 70.2
        src = 7;
        dest = 163;
        
    elseif t > 70 && t < 80.4
        src = 13;
        dest = 200;
        
    elseif t > 80.2 && t < 90.6
        src = 15;
        dest = 234;
        
    elseif t > 90.4 && t < 100.8
        src = 41;
        dest = 315;
        
    elseif t > 100.6 && t < 111.0
        src = 50;
        dest = 329;
        
    end
    
%% block 2    
elseif t > 110.8 && t < 213.0 
    
    if  t < 121.2
        src = 122;
        dest = 376;
        
    elseif t > 121.0 && t < 131.4
        src = 164;
        dest = 409;
        
    elseif t > 131.2 && t < 141.6
        src = 189;
        dest = 420;
        
    elseif t > 141.4 && t < 151.8
        src = 222;
        dest = 459;
        
    elseif t > 151.6 && t < 162.0
        src = 279;
        dest = 488;
        
    elseif t > 161.8 && t < 172.2
        src = 334;
        dest = 521;
        
    elseif t > 172.0 && t < 182.4
        src = 360;
        dest = 561;
        
    elseif t > 182.2 && t < 192.6
        src = 392;
        dest = 603;
        
    elseif t > 192.4 && t < 202.8
        src = 411;
        dest = 654;
        
    elseif t > 202.6 && t < 213.0
        src = 445;
        dest = 702;
        
    end
%% block 3
else
    if  t < 223.2
        src = 475;
        dest = 754;
        
    elseif t > 223.0 && t < 233.4
        src = 504;
        dest = 818;
        
    elseif t > 233.2 && t < 243.6
        src = 559;
        dest = 844;
        
    elseif t > 243.4 && t < 253.8
        src = 587;
        dest = 868;
        
    elseif t > 253.6 && t < 264
        src = 664;
        dest = 905;
        
    elseif t > 263.8 && t < 274.2
        src = 721;
        dest = 937;
        
    elseif t > 274 && t < 284.4
        src = 746;
        dest = 998;
        
    elseif t > 284.2 && t < 294.6
        src = 772;
        dest = 1037;
        
    elseif t > 294.4
        src = 842;
        dest = 1092;
        
    end

end
    
     i1 = find(cn==src);
     i2 = find(cn==dest);