load I80set1.mat

total_vel = 0;

%% Calculate the average velocity
NumOfData = length(Rundata);

for i = 1:NumOfData;
    total_vel = total_vel + Rundata(i,5);
end
average_vel = total_vel / NumOfData;
%disp(average_vel);

%% Using average velocity to choose method

if average_vel < 25
    disp('greedy');
    test_MPA_greedy_I80set1;
    
else
    disp('dijkstra');
    test_MPA_Dijkstra_I80set1;
    
end