function [ M] = generalFindOneMaxMatch( D)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if ~issparse(D)
    %% ��ʼ������
    numV1 = size(D,1);   %����ͼV1�������
    numV2 = size(D,2);   %����ͼV2�������
    M = zeros(numV1,numV2);     %ƥ�����
    flag = 0;       %��ֹ��־
    counter = 0;    %������
    rowFake = zeros(1,numV1);   %α�к�
    columnFake = zeros(1,numV2);        %α�к�
    
    %% ��������
    while(flag ~= 1 && counter < min(numV1,numV2))
        counter = counter + 1;  %ÿ����һ��Ѱ�ң���������1
        [rowFake(counter),columnFake(counter),D,flag] = FindLeastZero(D);
    end
    % counter = counter -1;
    
    % [row,column] = ArrangeIndex(rowFake,columnFake,counter);        %����α�кź�α�к�
    for i = counter : -1 : 2
        for j = 1 : 1 : i-1
            if rowFake(i) >= rowFake(i-j)
                rowFake(i) = rowFake(i) + 1;
            end
            if columnFake(i) >= columnFake(i-j)
                columnFake(i) = columnFake(i) + 1;
            end
        end
    end
    
    row = rowFake(1:counter);
    column = columnFake(1:counter);
    row = row(row > 0);
    column = column(column > 0);
    
    for i = 1 : 1 : size(row,2)
        M(row(i),column(i)) = 1;
    end
else
    NumNode = size(D,1);
    flag = 0;
    counter = 0;
    rowFake = zeros(1,NumNode);   %α�к�
    columnFake = zeros(1,NumNode);        %α�к�
    while(flag ~= 1&& counter < NumNode)
        counter = counter + 1 ;
        [rowFake(counter),columnFake(counter),D,flag] = SparseFindLeastZero(D);
%         disp(num2str(counter));
    end
    for i = counter : -1 : 2
        for j = 1 : 1 : i-1
            if rowFake(i) >= rowFake(i-j)
                rowFake(i) = rowFake(i) + 1;
            end
            if columnFake(i) >= columnFake(i-j)
                columnFake(i) = columnFake(i) + 1;
            end
        end
    end
    
    row = rowFake(1:counter);
    column = columnFake(1:counter);
    clear rowFake
    clear columnFake
    row = row(row > 0);
    column = column(column > 0);
    
    M = sparse(row,column,1,NumNode,NumNode);
    
end

end

