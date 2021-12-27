function [A,B_list,param] = fAutoGenerator(N,A,prob)
    % ****************************************
    % fCalBList:生成控制源到网络节点的函数
    % 输入:
    %   @N:标量，网络节点数
    %   @A:mat/false，拓扑矩阵，可选择不输入
    %   @prob:随机生成A时使用的连接概率
    % 输出:
    %   @A:输入的或者随机生成的A矩阵
    %   @B_list:B矩阵序列
    %   @param:优化后的拓扑结构数据包
    % ****************************************  
    % 自动生成控制连接的方法
    param = struct();
    % 判断是随机生成一个还是手动设置的
    if A == 0
        A = rand([N,N]);
        A(A<prob)=0;
        A(A>prob)=1;
        fprintf(['>>>>>> randomly generate A with prob:',num2str((1-prob)*100),'%% for none-0 elements\n']);
    end
    % 子网络过大会影响速度
    if N > 32
        fprintf(['>>>>>> N =',num2str(N),', Distirbuted control is recommended.\n (set param.if_distributed=true)\n']);
    end

   
    B_list = [];
    uplist = [];
    dwlist = [];
    uf = 1;
    df = 1;    
    
    [P,J] = jordan(A);

    J_raw = J;

    % 判断是2控制源的情况还是1控制源的情况
    if sum(sum(abs(imag(J)))) ~= 0
        M = 2;
    else
        M = 1;
    end

    % 寻找若尔当块
    find_block = false;
    for i=2:1:N
        if  J(i-1,i)~=1 % 若尔当块结束的标记
            find_block = true;
        end
        if find_block
            df=i-1;
            uplist=[uplist uf]; % 上index
            dwlist=[dwlist df]; % 下index
            uf=i;
            find_block = false;
        end
        if i == N && find_block == false 
            df = i;
            uplist=[uplist uf]; % 上index
            dwlist=[dwlist df]; % 下index
        end
    end

    new_uplist = [];
    new_dwlist = [];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 重要
    % 如果出现bug，可能是在这一部分
    % 某些版本matlab的jordan()函数可能不会把成对的
    % 复特征值对应的jordan块放在相邻位置
    %%%%%%%%%%%%%%%%%%%%%%%%%%%

    complex_block = [];
    for i=1:1:length(uplist) %?????????
        uf = uplist(i);
        df = dwlist(i);
        J_i = J(uf,uf);
        if imag(J_i)~=0
            complex_block = [complex_block i];
        else
            new_uplist = [new_uplist uf];
            new_dwlist = [new_dwlist df];
        end
    end
    for ci = 1:2:length(complex_block) 
        % 对复共轭若尔当块对，按照实若尔当块生成
        uf1 = uplist(complex_block(ci));
        df1 = dwlist(complex_block(ci));
        uf2 = uplist(complex_block(ci+1));
        df2 = dwlist(complex_block(ci+1));

        new_uplist = [new_uplist uf1];
        new_dwlist = [new_dwlist df2];

        dim = (df1 - uf1 + 1)*2;
        I_2 = eye(2);
        a = real(J(uf1,uf1));
        b = abs(imag(J(uf1,uf1)));
        Z_2 = [a,b;-b,a];
        J_real = zeros(dim,dim);
        for i = 1:2:dim
            J_real(i:i+1,i:i+1) = Z_2;
        end
        for i = 3:2:dim
            J_real(i:i+1,i-2:i-1) = I_2;
        end
        J(uf1:df2,uf1:df2) = J_real;
    end
    if length(complex_block) > 0 
        [P_2,~] = jordan(J);
        P = P / P_2;
    end

    % 根据若尔当块的分布设计B_list
    for i=1:1:length(new_uplist) 
        temp=zeros(N,M);
        uf = new_uplist(i);
        df = new_dwlist(i);

        if uf<N && J(uf+1,uf)~=0
            temp(df-1:df,1:2)=eye(2);
            B_list=[B_list temp];

        else
            temp(df,1)=1;
            B_list=[B_list temp];
        end
    end


    B_list=P*B_list;
    shape=size(B_list);
    K=shape(2)/M;


    n=B_list'*B_list;
    n=diag(n)';


    param.N = N; 
    param.M = M; 
    param.K = K; 

    % 归一化，防止梯度爆炸
    nn=zeros(N,K*M);
    for i =1:1:N
        nn(i,:)=n;
    end

    B_list=B_list./nn;

    shape=size(B_list);
    K=ceil(shape(2)/M);
    B_=zeros(N,K*M);
    B_(:,1:shape(2))=B_list;
    B_list=B_;
    
    if N ==1
        B_list = [1];
        param.N = 1;
        param.M = 1;
        param.K = 1;
    end
   
    fprintf(['>>>>>> M =',num2str(param.M),'\n']);
    fprintf(['>>>>>> K =',num2str(param.K),'\n']);
    if param.M>1
        fprintf(['>>>>>> NaN in B means no connection, use B_list(isnan(B_list))=0;\n']);
    end
    
end


