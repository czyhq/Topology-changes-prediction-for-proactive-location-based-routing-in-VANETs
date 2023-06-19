%--------------------------------------------------------------------------------------------
% Maximum Path Expiration Time Algorithm
% author: Xun Yong LEE
%
% Scriptname: MaxPathExpTime
% parameters: source        ---origin node 
%             destination   ---destination node
%             Net           ---netlist of nodes' x-y coordinates:  matrix of size n*2, n is the number of nodes
%             STABILITY     ---connectivity matrix which contains the connections and associated costs between nodes of the network
%                           matrix of size n*n, n is the number of nodes in the network
%
% Description: This algorithm chooses a path with the maximum Path Expiration Time using a greedy criterion.
% A constraint imposed on the greedy criterion is that the candidate node must be located between the source/current node and the destination node.
%--------------------------------------------------------------------------------------------
%%
function [Path, availability] = MaxPathExpTime(source,destination,Net,STABILITY)

Path = [];
Path = [Path,source];  %set the original node
S = source;   % set the current node as the original node 
availability = 1;   % set availability to 1 as pass
Max = 0;
node = 0;

while S ~= destination  %while the current node is not destination
    for i=1:length(Net)
        if STABILITY(i,S) > 0 && i ~= S
            X = sqrt( ( Net(destination,1)-Net(i,1) )^2 + ( Net(destination,2)-Net(i,2) )^2 );  % calculate the distance X from current node to destination
            D = sqrt( ( Net(destination,1)-Net(S,1) )^2 + ( Net(destination,2)-Net(S,2) )^2 );  % calculate the distance D from source node to destination
            if X < D  % this is to make sure i is an intermediate node between S and destination
                tempStability = STABILITY(i,S); %/( D - X );  %calculate the energy spent per unit of progress made
                if tempStability > Max     %try to find the next hop with maximum stability
                    Max = tempStability;   %save the stability value as max
                    node = i;    %save i as node number
                end
            end
        end
    end
    if node == 0   
        availability = 0;   %if there's no nodes then availability is set to 0, broken
        break;
    end
    if node > 0    %if there are nodes and the number of node is smaller than the length of net nodes' coordinate  matrix
        Path = [Path node];  %record the node into path
        S = node;   %set this node as current node
        node = 0;   %reset the original node
        Max = 0;  %reset Min
    end
end
end
