% A(ij)=1 if there is an edge from i to j 
% find the driver node of the network
function [D]=find_driver_nodes_MM(A)

G = generalNewBG(A);
MM_mat = generalFindOneMaxMatch(G)%生成匹配矩阵
if issparse(MM_mat)%若是稀疏矩阵
    MM_mat = full(MM_mat);%转换为普通矩阵
end
N = size(MM_mat);%总的节点数
Parent_num = sum(MM_mat,2);%找出每个节点的父节点数，匹配矩阵按行求和
Driver_Nodes = [];
for i=1:N
    if Parent_num(i)==0%没有父节点的就是Driver_Nodes
        Driver_Nodes = [Driver_Nodes i];
    end
end
%
D=Driver_Nodes';
end 