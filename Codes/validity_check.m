% This function is used to check the path availability at every time spot

function[av,pb1,pb2] = validity_check(path,ds,R,carN)
av = 1;
pb1 = -1;
pb2 = -1;

% 1st loop: to translate car IDs in path to Net matrix indice
for j = 1:length(path)
    for k = 1:length(carN)
       if carN(k)==path(j)
           break;
       end
    end
    path(j) = k;
end
% 2nd loop: check if out of radius
for i = 1:length(path)-1
    if ds(path(i),path(i+1)) > R
        av = 0;
        break;
    end
end

pb1 = carN(path(i));
pb2 = carN(path(i+1));