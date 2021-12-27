function [ data ] = fCalG(param)
    % ****************************************
    % fCalG:计算G矩阵，用于解拉格朗日问题
    % 输入:
    %   @param:拓扑结构数据包  
    % 输出:
    %   @data:H矩阵中分块的JKUV以及以K序列构成的G矩阵
    % ****************************************  
    
    data = struct();
    data.G=[];
    data.U_list=[];
    data.V_list=[];
    data.J_list=[];
    data.K_list=[];   
    data.H_list=[];
    
    A = param.A;
    Blist = param.B_list;
    K = param.K;                                     % number of time steps
    N = param.N;                                        % number of nodes in net
    M = param.M;                                        % number of extern sources
    alpha = param.alpha;                                % rate of evolve energy:total energy
    tf = param.tf;                                     % total time
    t_list= param.t_list;

    for i = 1:K
        B = Blist(:,M*(i-1)+1:M*i);
        tT = t_list(i+1) - t_list(i);
        H = [A,-(B*B')/(2*alpha);-2*(1-alpha)*eye(N),-A'];
        expH = expm(tT*H);
        Ki=expH(1:N,N+1:2*N);
        Ji=expH(1:N,1:N);
        Ui=expH(N+1:2*N,1:N);
        Vi=expH(N+1:2*N,N+1:2*N);
        data.U_list=[data.U_list Ui];
        data.V_list=[data.V_list Vi];
        data.J_list=[data.J_list Ji];
        data.K_list=[data.K_list Ki];
        data.H_list=[data.H_list H];
        if(length(data.G)>0)
            data.G=Ji*data.G;
        end
        data.G=[data.G Ki];
    end
end

