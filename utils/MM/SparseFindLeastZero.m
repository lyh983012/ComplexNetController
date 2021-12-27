function [ row,column,DofG,flag] = SparseFindLeastZero( DofG  )
%DofGΪ�ڽӾ���0Ϊ���ӣ�1Ϊ�����ӣ���row,column�ֱ���Ԫ�����ٵ�������������꣬TrimDofGΪɾ�����и��к���ڽӾ���0Ϊ���ӣ�1Ϊ�����ӣ�,flag��Ѱ����ֹ��־
%rowpast��columnpast��һ�ε�row��column����ʼʱΪ0,0

%% �������
numV1 = size(DofG,1);   %����ͼV1�������
numV2 = size(DofG,2);   %����ͼV2�������
% numZeroTemp1 = sparse(1,numV1);
numZeroTemp1 = ones(1,numV1);   %��¼������Ԫ�صĸ���
numZeroTemp2 = ones(1,numV2);   %��¼������Ԫ�صĸ���
% numZeroTemp2 = sparse(1,numV2);
flag = 0;

%% Ѱ�Ұ�����Ԫ�������Ǹ��л����У���ѡ������һ����Ԫ��
for i = 1 : 1 : numV1   %����ѭ�����ж�����Ԫ�����ٵ��Ǹ���
    %numZeroTemp1(i) = size(find(DofG(i,:) == 0),2);     %Ѱ��DofG��i����ֵΪ0��Ԫ������
    numZeroTemp1(i) = nnz(DofG(i,:));            %Ѱ��DofG��i����ֵΪ0��Ԫ������ 
    if numZeroTemp1(i) == 0
        numZeroTemp1(i) = inf;
    end
end
% numZeroTemp1 = sparse(1,1:numV1,numZeroTemp1,1,numV1);
for j = 1 : 1 : numV2   %����ѭ�����ж�����Ԫ�����ٵ��Ǹ���
    numZeroTemp2(j) = nnz(DofG(:,j));            %Ѱ��DofG��j����ֵΪ0��Ԫ������
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
else if (min(numZeroTemp1) < min(numZeroTemp2))     %����Ԫ����СֵС������Ԫ����Сֵ
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
        
%         [~ ,row] =  min(numZeroTemp1);              %row�ǵõ���Ԫ�����ٵ��к�
%         [~ ,column] = min(DofG(row,:));             %column�ǵõ������е�һ����Ԫ��
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

%% �Ը���Ԫ����Ϊ��׼�������к�����ֱ�ߣ���ֱ�߸��ǵ��к��б�ɾ��
DofG(row,:) = [];   %ɾ������
DofG(:,column) = [];    %ɾ������
% if (row >= rowpast()) row = row + 1;
% if (column >= columnpast) column = column + 1;
% TrimDofG = DofG;
end


end



