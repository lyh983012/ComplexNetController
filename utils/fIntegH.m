function y = fIntegH(it,i_s,j_s,T_i,param,H_list)
    % ****************************************
    % fIntegTrajactory:积分辅助函数
    % 输入:
    %   @T_i:时间索引
    %   @it:积分索引
    %   @i_s:时间步索引
    %   @j_s:维度索引
    %   @param:拓扑结构参数  
    %   @H_list:能量二次型矩阵序列 
    % 输出:
    %   @y:该步函数值
    % ****************************************  
    t_list = param.t_list;
    alpha = param.alpha;
    B_list = param.B_list;
    N = param.N;
    M = param.M;
    
    B=B_list(1:N,(T_i-1)*M+1:T_i*M);
    H=H_list(1:2*N,(T_i-1)*2*N+1:T_i*2*N);
    t=t_list(T_i+1)-t_list(T_i);
    Eij = zeros(N,M);
    Eij(i_s,j_s)=1;
    dBB = Eij*B'+B*Eij';
    y=zeros(2*N,2*N);
    dHdB=zeros(2*N,2*N);
    dHdB(1:N,N+1:2*N)=dBB;
    dHdB=dHdB./(2*alpha);
    y(1:2*N,1:2*N)=expm(H*(t-it))*dHdB*expm(H*it);
end
