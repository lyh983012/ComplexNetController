function [ M] = generalFindOneMaxMatch( D)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if ~issparse(D)
    %% 初始化变量
    numV1 = size(D,1);   %二分图V1集点个数
    numV2 = size(D,2);   %二分图V2集点个数
    M = zeros(numV1,numV2);     %匹配矩阵
    flag = 0;       %终止标志
    counter = 0;    %计数器
    rowFake = zeros(1,numV1);   %伪行号
    columnFake = zeros(1,numV2);        %伪列号
    
    %% 函数主体
    while(flag ~= 1 && counter < min(numV1,numV2))
        counter = counter + 1;  %每进行一次寻找，计数器加1
        [rowFake(counter),columnFake(counter),D,flag] = FindLeastZero(D);
    end
    % counter = counter -1;
    
    % [row,column] = ArrangeIndex(rowFake,columnFake,counter);        %修正伪行号和伪列号
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
    rowFake = zeros(1,NumNode);   %伪行号
    columnFake = zeros(1,NumNode);        %伪列号
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

