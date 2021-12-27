function [ row,column,DofG,flag] = SparseFindLeastZero( DofG  )
%DofG为邻接矩阵（0为连接，1为不连接），row,column分别零元素最少的行坐标和列坐标，TrimDofG为删除该行该列后的邻接矩阵（0为连接，1为不连接）,flag是寻找终止标志
%rowpast，columnpast上一次的row和column，初始时为0,0

%% 定义变量
numV1 = size(DofG,1);   %二分图V1集点个数
numV2 = size(DofG,2);   %二分图V2集点个数
% numZeroTemp1 = sparse(1,numV1);
numZeroTemp1 = ones(1,numV1);   %记录行中零元素的个数
numZeroTemp2 = ones(1,numV2);   %记录列中零元素的个数
% numZeroTemp2 = sparse(1,numV2);
flag = 0;

%% 寻找包含零元素最少那个行或者列，并选择其中一个零元素
for i = 1 : 1 : numV1   %进入循环，判断行零元素最少的那个零
    %numZeroTemp1(i) = size(find(DofG(i,:) == 0),2);     %寻找DofG第i行中值为0的元素坐标
    numZeroTemp1(i) = nnz(DofG(i,:));            %寻找DofG第i行中值为0的元素坐标 
    if numZeroTemp1(i) == 0
        numZeroTemp1(i) = inf;
    end
end
% numZeroTemp1 = sparse(1,1:numV1,numZeroTemp1,1,numV1);
for j = 1 : 1 : numV2   %进入循环，判断列零元素最少的那个零
    numZeroTemp2(j) = nnz(DofG(:,j));            %寻找DofG第j列中值为0的元素坐标
    if numZeroTemp2(j) == 0
        numZeroTemp2(j) =inf;
    end
end
% numZeroTemp2 = sparse(1,1:numV2,numZeroTemp2,1,numV2);

% numZeroTemp1(numZeroTemp1 == 0) = inf;
% numZeroTemp2(numZeroTemp2 == 0) = inf;

if min(numZeroTemp1) == inf
    flag = 1;
%     TrimDofG = DofG;
    row = 0;
    column = 0;
else if (min(numZeroTemp1) < min(numZeroTemp2))     %行零元素最小值小于列零元素最小值
        [~,tempRow] = find(numZeroTemp1 == min(numZeroTemp1));
        for i = 1 : 1 : size(tempRow,2)
            
            [~,tempColumn] = find(DofG(tempRow(i),:) ~= 0);
            numZeroTemp112 = zeros(1,size(tempColumn,2));
            for j = 1 : 1 : size(tempColumn,2)
                numZeroTemp112(j) = numZeroTemp2(tempColumn(j));
            end
            numZeroTemp11(i) = min(numZeroTemp112);
            [~,LOCATE ] = min(numZeroTemp112);
            numZeroTempLocate1(i) = tempColumn(LOCATE);
        end
        [~,rowLOCATE] = min(numZeroTemp11);
        row = tempRow(rowLOCATE);
        column = numZeroTempLocate1(rowLOCATE);
        
%         [~ ,row] =  min(numZeroTemp1);              %row是得到零元素最少的行号
%         [~ ,column] = min(DofG(row,:));             %column是得到该行中第一个零元素
    else if (min(numZeroTemp1) > min(numZeroTemp2))
%             [~ ,column] = min(numZeroTemp2);
%             [~ ,row] = min(DofG(:,column));
            [~,tempColumn] = find(numZeroTemp2 == min(numZeroTemp2));
            for j = 1 : 1 : size(tempColumn,2)
                
                [tempRow,~] = find(DofG(:,tempColumn(j)) ~= 0);
                tempRow = tempRow';
                numZeroTemp221 = zeros(1,size(tempRow,2));
                for i = 1 : 1 : size(tempRow,2)
                    numZeroTemp221(i) = numZeroTemp1(tempRow(i));
                end
                numZeroTemp22(j) = min(numZeroTemp221);
                [~,LOCATE ] = min(numZeroTemp221);
                numZeroTempLocate2(j) = tempRow(LOCATE);
            end
            [~,columnLOCATE] = min(numZeroTemp22);
            column= tempColumn(columnLOCATE);
            row = numZeroTempLocate2(columnLOCATE);
            
            
            
            
            
        else 
            [~,tempRow] = find(numZeroTemp1 == min(numZeroTemp1));
            for i = 1 : 1 : size(tempRow,2)
                
                [~,tempColumn] = find(DofG(tempRow(i),:) ~= 0);
                numZeroTemp112 = zeros(1,size(tempColumn,2));
                for j = 1 : 1 : size(tempColumn,2)
                    numZeroTemp112(j) = numZeroTemp2(tempColumn(j));
                end
                numZeroTemp11(i) = min(numZeroTemp112);
                [~,LOCATE ] = min(numZeroTemp112);
                numZeroTempLocate1(i) = tempColumn(LOCATE);
            end
             resultRow = min(numZeroTemp11);
             [~,rowLOCATE] = min(numZeroTemp11);
             rowRow = tempRow(rowLOCATE);
             columnRow = numZeroTempLocate1(rowLOCATE);
            
            [~,tempColumn] = find(numZeroTemp2 == min(numZeroTemp2));
            for j = 1 : 1 : size(tempColumn,2)
                
                [tempRow,~] = find(DofG(:,tempColumn(j)) ~= 0);
                tempRow = tempRow';
                numZeroTemp221 = zeros(1,size(tempRow,2));
                for i = 1 : 1 : size(tempRow,2)
                    numZeroTemp221(i) = numZeroTemp1(tempRow(i));
                end
                numZeroTemp22(j) = min(numZeroTemp221);
                [~,LOCATE ] = min(numZeroTemp221);
                numZeroTempLocate2(j) = tempRow(LOCATE);
            end
            resultColumn = min(numZeroTemp22);
            [~,columnLOCATE] = min(numZeroTemp22);
            columnColumn= tempColumn(columnLOCATE);
            rowColumn = numZeroTempLocate2(columnLOCATE);
            
            if resultRow <= resultColumn
                row =rowRow;
                column = columnRow;
            else 
                row =rowColumn;
                column = columnColumn;
            end
        end
             
           
    end

%% 以该零元素作为基准，沿着行和列作直线，该直线覆盖的行和列被删除
DofG(row,:) = [];   %删除该行
DofG(:,column) = [];    %删除该列
% if (row >= rowpast()) row = row + 1;
% if (column >= columnpast) column = column + 1;
% TrimDofG = DofG;
end


end



