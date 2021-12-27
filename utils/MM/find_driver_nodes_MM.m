% A(ij)=1 if there is an edge from i to j 
% find the driver node of the network
function [D]=find_driver_nodes_MM(A)

G = generalNewBG(A);
MM_mat = generalFindOneMaxMatch(G)%����ƥ�����
if issparse(MM_mat)%����ϡ�����
    MM_mat = full(MM_mat);%ת��Ϊ��ͨ����
end
N = size(MM_mat);%�ܵĽڵ���
Parent_num = sum(MM_mat,2);%�ҳ�ÿ���ڵ�ĸ��ڵ�����ƥ����������
Driver_Nodes = [];
for i=1:N
    if Parent_num(i)==0%û�и��ڵ�ľ���Driver_Nodes
        Driver_Nodes = [Driver_Nodes i];
    end
end
%
D=Driver_Nodes';
end 