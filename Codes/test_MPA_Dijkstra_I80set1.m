%% Clear previous variables and load data
clear all;
close all;
load I80set1.mat

tic

%% Define variables
timestamp = 0:0.2:300; %time stamp containing more than 2 cars
len_timestamp = length(timestamp); %X axis: 1593
danger_timeout = 0.2; %This variable is used to set the minimum LET threshold; if LET is lower than this, a new path discovery should be started
stability_coef = 10; %Stability coefficient to adjust the 'sensitivity' of the Stability Function
vel_threshold = 0.5; %Relative velocity threshold which is used to set the minimum relative velocity between nodes to avoid overestimating LA

%Variables for transmission characteristics 
R = 65;
% a = 1;  %physical environment parameter and is chosen to be 1
% C = 1000;

%PathAvailability variables
PathAvailability1 = zeros(1,len_timestamp);
PathAvailability1LET = zeros(1,len_timestamp);

src_dest_store = [1 36]; %Stores the carID of the source and destination nodes
prevS = -10;   %initialize the previous source
prevD = -10;   %initialize the previous destination

% sum counters initialise
countersum1 = 0;
countersum1LET = 0;

Ts = 1; %Timestamp variable

%% Main simulation body
for timer = timestamp
    
    [af bf]=find(abs(Rundata(:,1)-timer)<0.01); %Find a timestamp value
    %Note that variables af and bf are row and column indices respectively of the cars at a certain value of timestamp
    
    %Read the carIDs of all the cars considered at a certain time stamp
    for ii=1:length(af)
        carN(ii) = Rundata(af(ii),2); %Variable carN contains the carIDs of the cars considered at a certain time stamp
    end
    
    %Read the x-y coordinates of the cars considered at a certain timestamp
    %Variable Net is a matrix netlist of x-y coordinates of the cars
    for ii=1:length(af)
        Net(ii,1) = Rundata(af(ii),3);
        Net(ii,2) = Rundata(af(ii),4);
    end    
    
    %Initialise counters
    counter1 = 1;
    counter1LET = 1;
    
    %% Choose source and destination nodes from a table
    [source,destination,scar,dcar] = src_dest_I80set1NGSIM_find(timer,carN); %Find the source and destination nodes for NGSIM data
    
    %% Calculate the Link Expiration Time of the links between the nodes of the network    
    NumOfCars = length(carN);
    LA = zeros(NumOfCars); %Matrix to store Link Expiration Time
    DISTANCE = zeros(NumOfCars); %Matrix to store distances between nodes
    COST = zeros(NumOfCars); %Matrix to store Cost Function C=1/(1-exp(-LET/stability_coef)) - inverse of stability function in greedy algorithm

    %Calculate the Link Expiration Time between all nodes considered at a certain time stamp
    for z = 1:NumOfCars-1 %Node I
        for zz = (z+1):NumOfCars %Node J            
            nodeI = af(z);
            nodeJ = af(zz);
            vel_i = Rundata(nodeI,5); %Vi
            vel_j = Rundata(nodeJ,5); %Vj
            x_i = Net(z,1);
            y_i = Net(z,2);
            x_j = Net(zz,1);
            y_j = Net(zz,2);
            
            relative_vel = abs(vel_i - vel_j); % denominator: relative velocity
            
            if relative_vel < vel_threshold   %To prevent a 'divide by zero' error or an overestimation in the link-affinity calculation
                relative_vel = vel_threshold;
            end
            
            %Calculate the distance between the nodes; if out of range, LA = 0;
            nodes_distance = sqrt((x_i - x_j)^2 + (y_i - y_j)^2);  %Calculate the squared distance between nodes
            DISTANCE(z,zz) = nodes_distance; %distance between any 2 nodes
            DISTANCE(zz,z) = nodes_distance;
            
            if nodes_distance > R   %If distance is larger than R(transmission distance)
                LA(z,zz) = 0;   %LA = 0, so that stability is also 0 (ie. disconnected nodes)
            else
                LA(z,zz) = ((R - nodes_distance)/relative_vel); %Calculate the Link Affinity
            end
            
            COST(z,zz) = 1/(1-exp(-LA(z,zz)/stability_coef)); %Calculate the Cost Function which is the inverse of the stability function
            COST(zz,z) = COST(z,zz); %Assume graph is undirected, hence matrix is symmetric across the diagonal         
        end
    end

    %% Maximum Path Expiration Time (MPET) algorithm    
    if scar~=prevS || dcar~=prevD || Av == 0 %Condition when source or destination nodes change or when nodes remain but no available path from previous time stamp

        [Cost1 Path1] = dijkstra(COST, source, destination); %Solve lowest cost (shortest path) problem using Dijkstra's algorithm
        
        Path1 = carN(Path1); %Translate to Rundata.mat carID
        
        if Cost1 ~= Inf %when the path is available
            counter1 = 1; 
            Av = 1; %set availability flag for next time stamp
            
        else %when the path is unavailable
            Av = 0; %clear availability flag for next time stamp to search for a path again
            counter1 = 0;            
        end
        
    else % this is the case when Av==1 AND the nodes remain the same as last time stamp
        
        Av = validity_check(Path1,DISTANCE,R,carN); % check if the path is still available        
        
        if Av == 1 %when the path is available
            counter1 = 1;

        elseif Av == 0 %when the path is not valid any more
            counter1 = 0;
        end
    end    
    
    %% Maximum Path Expiration Time with LET (MPET w LET) algorithm 
    if scar~=prevS || dcar~=prevD || Av1LET==0 %Condition when source or destination nodes change or when nodes remain but no available path from previous time stamp

        [Cost1LET Path1LET] = dijkstra(COST, source, destination); %Solve lowest cost (shortest path) problem using Dijkstra's algorithm

        if Cost1LET ~= Inf %If the path search is successful (ie. a route exist between source and destination nodes)
            counter1LET =  1; %add when the path is available
            Av1LET = 1; %Set path availability flag to indicate path is available                            
            Path1LET = carN(Path1LET); %Translate path nodes into Rundata.mat carID
                
            %Calculate the Link Expiration Time
            Dt = zeros(length(Path1LET)-1,1);
            for z = 1:length(Path1LET)-1 % Path1LET contains each node on the path from source to destination, so number of node couple pairs is len-1
                [nd1row nd1col] = find(carN == Path1LET(z));
                [nd2row nd2col] = find(carN == Path1LET(z+1));
                vel_i = Rundata(af(nd1col),5); %Vi
                vel_j = Rundata(af(nd2col),5); %Vj
                x_i = Net(nd1col,1);
                y_i = Net(nd1col,2);
                x_j = Net(nd2col,1);
                y_j = Net(nd2col,2);
                relative_vel = abs(vel_i - vel_j); % denominator: relative velocity
            
                if relative_vel < vel_threshold   %To prevent a 'divide by zero' error or an overestimation in the link-affinity calculation
                    relative_vel = vel_threshold;
                end
                
                %Calculate the distance between the nodes
                nodes_distance = sqrt((x_i - x_j)^2 + (y_i - y_j)^2);
                
                Dt(z) = ((R - nodes_distance)/relative_vel); %Calculate the Link Affinity
            end
                    
            Dtmin = min(Dt); % Dt is chosen to be the smallest one from all links of a path
            
            if Dtmin < danger_timeout
                Av1LET = 0; %Clear path availability flag to indicate path could be unavailable by next timestamp
            end
            
        elseif Cost1LET == Inf %If the path search is unsuccessful (ie. no route exist between source and destination nodes)
            Av1LET = 0; %Clear path availability flag to indicate path is unavailable
            counter1LET = 0;        
        end
        
    else %This is the case when Av==1 AND the nodes remain the same as last time stamp
        
        Av1LET = validity_check(Path1LET,DISTANCE,R,carN); % check if the path is still valid
        
        if Av1LET == 0 %If path is not available anymore
            counter1LET = 0;
          
        elseif Av1LET == 1 %If path is available, update LET estimation
            
            counter1LET = 1; %add when the path is available
            
            %Calculate the updated Link Expiration Time
            Dt = zeros(length(Path1LET)-1,1);
            for z = 1:length(Path1LET)-1 %Path1LET contains each node on the path from source to destination, so node couple pair number is len-1
                [nd1row nd1col] = find(carN == Path1LET(z));
                [nd2row nd2col] = find(carN == Path1LET(z+1));
                vel_i = Rundata(af(nd1col),5); %Vi
                vel_j = Rundata(af(nd2col),5); %Vj
                x_i = Net(nd1col,1);
                y_i = Net(nd1col,2);
                x_j = Net(nd2col,1);
                y_j = Net(nd2col,2);
                
                relative_vel = abs(vel_i - vel_j); % denominator: relative velocity
            
                if relative_vel < vel_threshold   %To prevent a 'divide by zero' error or an overestimation in the link-affinity calculation
                    relative_vel = vel_threshold;
                end
                
                %Calculate the distance between the nodes
                nodes_distance = sqrt((x_i - x_j)^2 + (y_i - y_j)^2);

                Dt(z) = ((R - nodes_distance)/relative_vel); %Calculate the Link Affinity
            end
            
            Dtmin = min(Dt); % Dt is chosen to be the smallest one from all links of a path
            
            if Dtmin < danger_timeout
                Av1LET = 0; %Clear path availability flag to indicate path is unavailable by next timestamp
            end
        end        
    end
    
    %% Calculate performance statistics
    
    % MPET algorithm
    PathAvailability1(1,Ts) = counter1;
    countersum1 = countersum1 + counter1; % sum counter
    
    %MPET with LET algorithm
    PathAvailability1LET(1,Ts) = counter1LET;
    countersum1LET = countersum1LET + counter1LET; % sum counter
    
    % Configure variables for next timestamp iteration
    Ts = Ts + 1;
    clear Net carN;
    prevS = scar;  %replace the previous source and destination with current source and destination
    prevD = dcar;
    
    if src_dest_store(end,1) ~= scar || src_dest_store(end,2) ~= dcar
        src_dest_store = [src_dest_store; prevS prevD;];
    end    
end

%% Calculate performance metrics
mmte1 = MTTEcal(PathAvailability1, length(timestamp));
mmte1LET = MTTEcal(PathAvailability1LET, length(timestamp));
disp ([mmte1 mmte1LET]);

PercentAvail = (sum(PathAvailability1)/length(PathAvailability1))*100;
PercentAvailLET = (sum(PathAvailability1LET)/length(PathAvailability1LET))*100;
disp ([PercentAvail PercentAvailLET]);
toc
