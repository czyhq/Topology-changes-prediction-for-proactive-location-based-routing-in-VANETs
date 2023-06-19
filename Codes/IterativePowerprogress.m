
%Scriptname:  Iterative Power Progress algorithm
%parameters:  source  -----current node 
%             destination --------destination node
%             Net ---------net nodes' coordinate  matrix:n*2, n is the number of nodes

%%
function [Path,Cost,availability] = IterativePowerprogress(source,destination,Net,Link)

Path = [];
Path = [Path,source];  %set the original node
Cost = 0;  %set cost to zero
%
S = source;  % set the current node as the original node 
node = S;
availability = 1;   % set availability to 1 as pass
%
suitable_node = [];
Min = Inf;

while S ~= destination  %while S is not the destination node then 
    for i=1:length(Net)
        if Link(i,S) < Inf && i ~= S
            X = sqrt( ( Net(destination,1)-Net(i,1) )^2 + ( Net(destination,2)-Net(i,2) )^2 );  % calculate the distance between the current node and destination
            D = sqrt( ( Net(destination,1)-Net(S,1) )^2 + ( Net(destination,2)-Net(S,2) )^2 );   % calculate the distance between the original node and destination
            if X < D   
                Energy = Link(i,S)/( D - X );    % %calculate the energy spent per unit of progress made
                suitable_node = [suitable_node,i];  %record this node into the suitable node set
                if Energy < Min      %try to find the minimum energy needed node
                    Min = Energy;  %save the energy as min
                    node = i;   %save i as node number
                end
            end
        end
    end
    if node == 0
        availability = 0;   %if there's no nodes then availability is set to 0, broken
        break;
    end
    
    %find M node
    while 1
        mm_node = node;   %save the minimum energy required node as mm_node
        M = Link(S,node);   %calculate the energy required from S to the node || M is Es-n
        for i = suitable_node  %for loop in the suitable node set
            if Link(i,node) < Inf  
                total_link = Link(S,i) + Link(i,node);  %calulate the minimum sum of energy required for S to the S&node common neighbor i and node to i
                % total_link = Es-a + Ea-n
                if total_link < M   %if it is smaller than the energy required from S to the node
                    M = total_link;   %then save this energy required as M
                    node = i;   %save this common neighbor i as node
                end

            end
        end
        if node == mm_node  %stop while 1 loop
            break;
        end
    end
    %add path node and cost
    if node > 0   %if there are nodes and the number of node is smaller than the length of net nodes' coordinate  matrix
        Path = [Path node];  %record the node into path
        Cost = Cost + Link(node,S);  %calculate accumulated cost
        S = node;   %set this node as current node
        node = 0;   %reset the original node
        Min = Inf; %reset Min
        suitable_node = [];  %reset the suitable node set
    end
end

end