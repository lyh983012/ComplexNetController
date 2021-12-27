function [ Net,NetData ] = Net_Consecutive( NetData )
%把网络变为连续编号
%NetData为输入的Edge List
%Net为输出的连续编号的邻接矩阵，NetData为输出的Edge List
NumNode = size(unique(NetData),1);
if NumNode < 4000
    Net = zeros(NumNode,NumNode);
    notlonely = unique(NetData);
    lonely = [];
    if size(notlonely,1) ~= max(NetData(:))
        for i = 1 : 1 : max(NetData(:))
            if isempty(find(notlonely == i))
                lonely = [lonely i];
            end
        end
        lonely = sort(lonely,'descend');
        while (~isempty(lonely))
            for i = 1 : 1 : size(NetData,1)
                if NetData(i,1) > lonely(1)
                    NetData(i,1) = NetData(i,1)-1;
                end
                if NetData(i,2) > lonely(1)
                    NetData(i,2) = NetData(i,2)-1;
                end
            end
            lonely(1)=[];
        end
        
        
    end
        if max(NetData(:))~= size(notlonely,1)
            disp('wrong');
        end
        for i = 1 : 1 : size(NetData,1)
            Net(NetData(i,2),NetData(i,1)) =1 ;
        end
    
else
    notlonely = unique(NetData);
    lonely = [];
    if size(notlonely,1) ~= max(NetData(:))
        for i = 1 : 1 : max(NetData(:))
            if isempty(find(notlonely == i))
                lonely = [lonely i];
            end
        end
        lonely = sort(lonely,'descend');
        while (~isempty(lonely))
            for i = 1 : 1 : size(NetData,1)
                if NetData(i,1) > lonely(1)
                    NetData(i,1) = NetData(i,1)-1;
                end
                if NetData(i,2) > lonely(1)
                    NetData(i,2) = NetData(i,2)-1;
                end
            end
            lonely(1)=[];
        end
        
        
    end
    if max(NetData(:))~= size(notlonely,1)
        disp('wrong');
    end
    Net = sparse(NetData(:,2),NetData(:,1),1,NumNode,NumNode);
    
    
    
%     Net = sparse(NumNode,NumNode);
%     for i =1 : 1 : size(NetData,1)
%         Net(NetData(i,2),NetData(i,1))=1;
%     end
    
    
    
end

end

