function [A,B_list_dis,topo_param] = fCalBList(N,A,D,prob)
    % ****************************************
    % fCalBList:生成控制源到网络节点的函数
    % 输入:
    %   @N:标量，网络节点数
    %   @A:mat/false，拓扑矩阵，可选择不输入
    %   @D:true/false，选择是否使用分布式算法加速
    % 输出:
    %   @A:输入的或者随机生成的A矩阵
    %   @B_list_dis:分布式控制下的B矩阵列
    %   @topo_param:优化后的拓扑结构数据包
    % ****************************************  
    % 自动生成B矩阵列表，默认以分布式方式进行，M=1时功能与fAutoGenerator相同

    topo_param = struct();
    
    % 如果A是0就以prob为概率生成一个A
    if A == 0
        A = rand([N,N]);
        A(A<prob)=0;
        A(A>prob)=1;
        fprintf(['>>>>>> randomly generate A with prob:',num2str((1-prob)*100),'%% for none-0 elements\n']);
    end
    

    dim = floor(N/D);% 分割自网络的维度
    last = mod(N,D);% 不能整除时最后一个子网络的维度
    
    topo_param.A = A;
    param_list = containers.Map();
    B_list = containers.Map();
    
    for i = 1:1:D %对每个子网络调用自动生成函数
       fprintf(['>>>>>> Sub system:', int2str(i),' \n'])
       A_i = A(1+(i-1)*dim:i*dim,1+(i-1)*dim:i*dim);
       [~,B_i,param_i] = fAutoGenerator(dim,A_i,prob);
       B_i(isnan(B_i))=0;
       param_list(int2str(i)) = param_i;
       B_list(int2str(i)) = B_i;
    end
    if last>0 %如果不被整除，需要进一步细分
       fprintf(['Sub system:', int2str(D+1),' \n'])
       A_i = A(D*dim+1:N,D*dim+1:N);
       [~,B_i,param_i] = fAutoGenerator(N-D*dim,A_i,prob);
       B_i(isnan(B_i))=0;
       D = D+1;
       param_list(int2str(D)) = param_i;
       B_list(int2str(D)) = B_i;
    end
    
    M_list = [];
    K_list = [];
    
    for i = 1:1:D
        M_list = [M_list param_list(int2str(i)).M];
        K_list = [K_list param_list(int2str(i)).K];
    end
    
    M = max(M_list);
    K = max(K_list);
    
    B_list_dis = [];
    
    % 将子网络控制的部分合并为大网络的控制设计
    for tk = 1:1:K
        tmp = zeros(N,M*D);
        for i = 1:1:D-1
            B_i = B_list(int2str(i));
            k_i = param_list(int2str(i)).K;
            M_i = param_list(int2str(i)).M;
            if k_i >= tk 
                tmp(1+(i-1)*dim:i*dim,(i-1)*M_i+1:i*M_i) = B_i(:,(tk-1)*M_i+1:tk*M_i);
            end
        end
        B_d = B_list(int2str(D));
        k_d = param_list(int2str(D)).K;
        M_d = param_list(int2str(D)).M;
        if k_d >= tk 
            tmp((D-1)*dim+1:N,(D-1)*M_d+1:D*M_d) = B_d(:,(tk-1)*M_d+1:tk*M_d);
        end
        B_list_dis = [B_list_dis tmp];
    end    
    topo_param.M = M*D;
    topo_param.K = K;
    topo_param.N = N;
    topo_param.B_list = B_list_dis;
    
    fprintf(['*********************************************\n']);
    fprintf(['>>>>>> For the whole control system \n']);
    fprintf(['>>>>>> distributed M =',num2str(topo_param.M),'\n']);
    fprintf(['>>>>>> distributed K =',num2str(topo_param.K),'\n']);
    fprintf(['*********************************************\n']);
    
end


