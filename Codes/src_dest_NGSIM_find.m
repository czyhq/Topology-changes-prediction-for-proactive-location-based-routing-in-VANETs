function [i1,i2,src,dest] = src_dest_NGSIM_find(t,cn)
if t < 103.6 % block 1
    
if  t < 11.8
    src = 5;
    dest = 9;
    
elseif t > 11.6 && t < 22
    src = 5;
    dest = 12;
    
elseif t > 21.8 && t < 32.2
    src = 2;
    dest = 17;
    
elseif t > 32 && t < 42.4
    src = 1;
    dest = 27;
    
elseif t > 42.2 && t < 52.6
    src = 1;
    dest = 41;
    
elseif t > 52.4 && t < 62.8
    src = 1;
    dest = 62;
    
elseif t > 62.6 && t < 73
    src = 1;
    dest = 93;
    
elseif t > 72.8 && t < 83.2
    src = 2;
    dest = 111;
    
elseif t > 83 && t < 93.4
    src = 26;
    dest = 140;
    
elseif t > 93.2 && t < 103.6
    src = 47;
    dest = 158;
    
end

elseif t > 103.4 && t < 205.6 % block 2

if  t < 113.8
    src = 66;
    dest = 187;
    
elseif t > 113.6 && t < 124
    src = 100;
    dest = 208;
    
elseif t > 123.8 && t < 134.2
    src = 130;
    dest = 233;
    
elseif t > 134 && t < 144.4
    src = 156;
    dest = 255;
    
elseif t > 144.2 && t < 154.6
    src = 184;
    dest = 279;
    
elseif t > 154.4 && t < 164.8
    src = 210;
    dest = 306;
    
elseif t > 164.6 && t < 175
    src = 234;
    dest = 330;
    
elseif t > 174.8 && t < 185.2
    src = 262;
    dest = 364;
    
elseif t > 185 && t < 195.4
    src = 290;
    dest = 387;
    
elseif t > 195.2 && t < 205.6
    src = 290;
    dest = 450;
    
end
else % block 3
if  t < 215.8
    src = 320;
    dest = 477;
    
elseif t > 215.6 && t < 226
    src = 320;
    dest = 484;
    
elseif t > 225.8 && t < 236.2
    src = 350;
    dest = 500;
    
elseif t > 236 && t < 246.4
    src = 350;
    dest = 500;
    
elseif t > 246.2 && t < 256.6
    src = 384;
    dest = 500;
    
elseif t > 256.4 && t < 266.8
    src = 385;
    dest = 500;
    
elseif t > 266.6 && t < 277
    src = 410;
    dest = 500;
    
elseif t > 276.8 && t < 287.2
    src = 430;
    dest = 500;
    
elseif t > 287 && t < 297.4
    src = 463;
    dest = 500;
    
elseif t > 297.2 && t < 307.6
    src = 471;
    dest = 500;

elseif t > 307.4 && t < 317.8
    src = 477;
    dest = 500;
    
elseif t > 317.6 
    src = 495;
    dest = 500;
    
end
    

end % for 3 blocks
    
     i1 = find(cn==src);
     i2 = find(cn==dest);