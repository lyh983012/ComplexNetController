function [ G ] = generalNewBG( Net )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if issparse(Net)
    NumNode = size(Net,1);
    %     sparseG = sparse(NumNode,NumNode);
    [Row,Column] = find(Net);
    %     for i = 1 : 1 : size(Row,1)
    %         sparseG(Column(i),Row(i)) = 1 ;
    %     end
    G = sparse(Column,Row,-1,NumNode,NumNode);
else
    numNode = size(Net,1);
    G = ones(numNode,numNode);
    for i = 1 : 1 : numNode
        for  j = 1 : 1 : numNode
            if Net(j,i) == 1
                G(i,j) = 0;
            end
        end
    end
end
end

