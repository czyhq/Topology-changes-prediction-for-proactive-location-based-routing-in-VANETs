% This function is used to calculate the mean available time period

function [mmte] = MTTEcal(path_av,L)

ind = find(path_av==1); % all 1 segments to a sum
segsum = 0.2*length(ind); % total availability time
count = 0;
if path_av(1) == 1 %detect the beginning period
    count = count + 1;
end



for i = 1:L-1   
if path_av(i)==0 && path_av(i+1)==1 % detect up-edge
    count = count + 1; % count the number of available period
end   
end
mmte = segsum/count;% sum(Ti)/i