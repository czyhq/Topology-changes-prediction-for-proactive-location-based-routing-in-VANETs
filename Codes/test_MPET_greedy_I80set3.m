%% Clear previous variables and load data
clear all;
close all;
load I80set3.mat

%% Define variables
timestamp = 0:0.2:300; %time stamp containing more than 2 cars
len_timestamp = length(timestamp); %X axis: 1593
danger_timeout = 0.2; %This variable is used to set the minimum LET threshold; if LET is lower than this, a new path discovery should be started
stability_coef = 10; %Stability coefficient to adjust the 'sensitivity' of the Stability Function

%Variables for transmission characteristics 
R = 65;
a = 1;  %physical environment parameter and is chosen to be 1
C = 1000;

%PathAvailability variables
PathAvailability1 = zeros(1,len_timestamp);
PathAvailability1LET = zeros(1,len_timestamp);

%Source and Destination nodes variables
src_dest_store = [1 36]; %Stores the carID of the source and destination nodes
prevS = -10;   %initilize the previous source
prevD = -10;   %initilize the previous destination

%Sum counters variables
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
    counter1 = 0;
    counter1LET = 0;

    
    %% Choose source and destination nodes from a table
    [source,destination,scar,dcar] = src_dest_I80set3NGSIM_find(timer,carN); %Find the source and destination nodes for NGSIM data

    %% Calculate the Link Expiration Time of the links between the nodes of the network    
    NumOfCars = length(carN);
    LET = zeros(NumOfCars); %Matrix to store Link Expiration Time
    DISTANCE = zeros(NumOfCars); %Matrix to store distances between nodes
    STABILITY = zeros(NumOfCars); %Matrix to store Stability Function S=1-exp(-LET/stability_coef)
    
    %Calculate the Link Expiration Time between all nodes considered at a certain time stamp
    for z = 1:NumOfCars-1 %Node I
        for zz = (z+1):NumOfCars %Node J            
            nodeI = af(z);
            nodeJ = af(zz);
            vel_i = Rundata(nodeI,5); %Vi
            vel_j = Rundata(nodeJ,5); %Vj
            theta_i = Rundata(nodeI,8); % theta_i in rad unit
            theta_j = Rundata(nodeJ,8); % theta_j in rad unit
            x_i = Net(z,1);
            y_i = Net(z,2);
            x_j = Net(zz,1);
            y_j = Net(zz,2);
            
            % construct the terms of the estimated life time root equation
            termA = vel_i*cos(theta_i) - vel_j*cos(theta_j); % a
            termB = x_i - x_j; % b
            termC = vel_i*sin(theta_i) - vel_j*sin(theta_j); % c
            termD = y_i - y_j; % d
            
            if (termA^2 + termC^2)==0   %To prevent a 'divide by zero' error in the LET calculation
                error = 0.01;           %Introduces a small error but ensure LET is sufficiently large to reflect the stable link
            else
                error = 0;
            end
            
            %Calculate Link Expiration Time (LET) according to the paper cited in the report
            LET(z,zz) = (-(termA*termB + termC*termD) + sqrt((termA^2 + termC^2)*R^2 - (termA*termD - termB*termC)^2))/(termA^2 + termC^2 + error);
          
            %Calculate the distance between the nodes; if out of range, LET = 0;
            distance_squared = (x_i - x_j)^2 + (y_i - y_j)^2;  %Calculate the squared distance between nodes
            DISTANCE(z,zz) = sqrt(distance_squared); %distance between any 2 nodes
            DISTANCE(zz,z) = DISTANCE(z,zz);
            
            if distance_squared > R^2   %If distance squared is larger than R^2(transmission distance)
                LET(z,zz) = 0;   %LET = 0, so that stability is also 0 (ie. disconnected nodes)
            end
            
            STABILITY(z,zz) = 1-exp(-LET(z,zz)/stability_coef); %Calculate the Stability Function
            STABILITY(zz,z) = STABILITY(z,zz); %Assume graph is undirected; hence, matrix will be symmetric across the diagonal
            
        end
    end

    %% Maximum Path Expiration Time (MPET) algorithm    
    if scar~=prevS || dcar~=prevD || Av1 == 0 %Condition when source or destination nodes change or when nodes remain but no available path from previous time stamp
        
        [Path1, Av1] = MaxPathExpTime(source,destination,Net,STABILITY); %Use the greedy MPET algorithm to calculate the path, cost and availability
        Path1 = carN(Path1); %Translate path nodes into Rundata.mat carIDs
        
        if Av1 == 1 %when the path is available
            counter1 = 1;
        elseif Av1 == 0 %when the path is unavailable
           counter1 = 0;
        end
        
    else % this is the case when Av==1 AND the nodes remain the same as last time stamp
        
        Av1 = validity_check(Path1,DISTANCE,R,carN); %check if the path is still available
        
        if Av1 == 1
            counter1 = 1; %when the path is available
        else
            counter1 = 0; %when the path is not valid any more
        end
    end
    
    
    %% Maximum Path Expiration Time with LET (MPET w LET) algorithm   
    if scar~=prevS || dcar~=prevD || Av1LET==0 %Condition when source or destination nodes change or when nodes remain but no available path from previous time stamp
        
        [Path1LET, Av1LET] = MaxPathExpTime(source,destination,Net,STABILITY);%Use MPET algorithm to calculate the path, cost and availability

        if Av1LET == 1
            counter1LET =  1;     %when the path is available
            Path1LET = carN(Path1LET); %Translate to Rundata.mat carID
            
            %Calculate the Path Expiration Time
            Dt = zeros(length(Path1LET)-1,1); % n rows 1 column
            for z = 1:length(Path1LET)-1 % Path1LET contains each node on the path from source to destination, so node couple pair number is len-1
                [nd1row nd1col] = find(carN == Path1LET(z));
                [nd2row nd2col] = find(carN == Path1LET(z+1));
                vel_i = Rundata(af(nd1col),5); %Vi
                vel_j = Rundata(af(nd2col),5); %Vj
                theta_i = Rundata(af(nd1col),8); % theta_i in rad unit
                theta_j = Rundata(af(nd2col),8); % theta_j in rad unit
                x_i = Net(nd1col,1);
                y_i = Net(nd1col,2);
                x_j = Net(nd2col,1);
                y_j = Net(nd2col,2);
                
                % construct the terms of the estimated life time root equation
                termA = vel_i*cos(theta_i) - vel_j*cos(theta_j); % a
                termB = x_i - x_j; % b
                termC = vel_i*sin(theta_i) - vel_j*sin(theta_j); % c
                termD = y_i - y_j; % d
                
                if (termA^2 + termC^2)==0   %To prevent a 'divide by zero' error in the LET calculation
                    error = 0.01;           %Introduces a small error but ensure LET is sufficiently large to reflect the stable link
                else
                    error = 0;
                end
                Dt(z) = (-(termA*termB + termC*termD) + sqrt((termA^2 + termC^2)*R^2 - (termA*termD - termB*termC)^2))/(termA^2 + termC^2 + error);
            end
                
                Dtmin = min(Dt); % Dt is chosen to be the smallest one from all links of a path                
                if Dtmin < danger_timeout
                    Av1LET = 0; %Clear path availability flag to indicate path could be unavailable by next timestamp - initiate new path discovery
                end
            
        elseif Av1LET == 0
            counter1LET = 0;
        end
        
    else %This is the case when AvLET==1 AND the source and destination nodes remain the same as last time stamp
        
        Av1LET = validity_check(Path1LET,DISTANCE,R,carN); % Check if the path is still valid
        
        if Av1LET == 0
            counter1LET =  0; 
            
        elseif Av1LET == 1
            counter1LET =  1;
            
            %Calculate the updated Path Expiration Time
            Dt = zeros(length(Path1LET)-1,1);
            for z = 1:length(Path1LET)-1 % Path1LET contains each node on the path from source to destination, so node couple pair number is len-1
                [nd1row nd1col] = find(carN == Path1LET(z));
                [nd2row nd2col] = find(carN == Path1LET(z+1));
                vel_i = Rundata(af(nd1col),5); %Vi
                vel_j = Rundata(af(nd2col),5); %Vj
                theta_i = Rundata(af(nd1col),8); % theta_i in rad unit
                theta_j = Rundata(af(nd2col),8); % theta_j in rad unit
                x_i = Net(nd1col,1);
                y_i = Net(nd1col,2);
                x_j = Net(nd2col,1);
                y_j = Net(nd2col,2);
                
                % construct the terms of the estimated life time root equation
                termA = vel_i*cos(theta_i) - vel_j*cos(theta_j); % a
                termB = x_i - x_j; % b
                termC = vel_i*sin(theta_i) - vel_j*sin(theta_j); % c
                termD = y_i - y_j; % d
                
                if (termA^2 + termC^2)==0   %To prevent a 'divide by zero' error in the LET calculation
                    error = 0.01;           %Introduces a small error but ensure LET is sufficiently large to reflect the stable link
                else
                    error = 0;
                end
                % The predicted time a link will stay connected: Dt
                Dt(z) = (-(termA*termB + termC*termD) + sqrt((termA^2 + termC^2)*R^2 - (termA*termD - termB*termC)^2))/(termA^2 + termC^2);
            end
            
            Dtmin = min(Dt); % Dt is chosen to be the smallest one from all links of a path
            
            if Dtmin < danger_timeout
                Av1LET = 0; %Clear path availability flag to indicate path could be unavailable by next timestamp
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

