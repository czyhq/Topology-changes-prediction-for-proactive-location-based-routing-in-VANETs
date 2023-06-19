function [i1,i2,src,dest] = src_dest_I80set2NGSIM_find(t,cn)
if t < 111.0 % block 1
    
    if  t < 10.2
        src = 293;
        dest = 294;
        
    elseif t > 10 && t < 20.4
        src = 284;
        dest = 343;
        
    elseif t > 20.2 && t < 30.6
        src = 290;
        dest = 356;
        
    elseif t > 30.4 && t < 40.8
        src = 297;
        dest = 444;
        
    elseif t > 40.6 && t < 51.0
        src = 304;
        dest = 456;
        
    elseif t > 50.8 && t < 60.0
        src = 325;
        dest = 456;
        
    elseif t > 59.8 && t < 70.2
        src = 325;
        dest = 547;
        
    elseif t > 70 && t < 80.4
        src = 370;
        dest = 610;
        
    elseif t > 80.2 && t < 90.6
        src = 430;
        dest = 644;
        
    elseif t > 90.4 && t < 100.8
        src = 459;
        dest = 697;
        
    elseif t > 100.6 && t < 111.0
        src = 478;
        dest = 701;
        
    end
    
%% block 2    
elseif t > 110.8 && t < 213.0 
    
    if  t < 121.2
        src = 504;
        dest = 714;
        
    elseif t > 121.0 && t < 131.4
        src = 546;
        dest = 752;
        
    elseif t > 131.2 && t < 141.6
        src = 581;
        dest = 782;
        
    elseif t > 141.4 && t < 151.8
        src = 608;
        dest = 814;
        
    elseif t > 151.6 && t < 162.0
        src = 620;
        dest = 861;
        
    elseif t > 161.8 && t < 172.2
        src = 647;
        dest = 882;
        
    elseif t > 172.0 && t < 182.4
        src = 688;
        dest = 909;
        
    elseif t > 182.2 && t < 192.6
        src = 713;
        dest = 934;
        
    elseif t > 192.4 && t < 202.8
        src = 738;
        dest = 960;
        
    elseif t > 202.6 && t < 213.0
        src = 775;
        dest = 970;
        
    end
%% block 3
else
    if  t < 223.2
        src = 799;
        dest = 995;
        
    elseif t > 223.0 && t < 233.4
        src = 838;
        dest = 1017;
        
    elseif t > 233.2 && t < 243.6
        src = 875;
        dest = 1046;
        
    elseif t > 243.4 && t < 253.8
        src = 900;
        dest = 1057;
        
    elseif t > 253.6 && t < 264
        src = 909;
        dest = 1073;
        
    elseif t > 263.8 && t < 274.2
        src = 925;
        dest = 1102;
        
    elseif t > 274 && t < 284.4
        src = 960;
        dest = 1134;
        
    elseif t > 284.2 && t < 294.6
        src = 974;
        dest = 1173;
        
    elseif t > 294.4
        src = 1008;
        dest = 1209;
        
    end

end
    
     i1 = find(cn==src);
     i2 = find(cn==dest);