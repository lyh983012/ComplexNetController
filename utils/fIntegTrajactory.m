function y = fIntegTrajactory(tau,t,i_s,param,ut_param)
	% ****************************************
    % fIntegTrajactory:积分辅助函数
    % 输入:
    %   @tau:网络末态
    %   @t:拓扑结构数据包
    %   @i_s:时间步索引，也是积分索引
    %   @param:拓扑结构参数  
    %   @ut_param:计算ut所需的参数 
    % 输出:
    %   @y:该步函数值
    % ****************************************  
    A = param.A;
    B_list = param.B_list;
    N = param.N;
    M = param.M;
    B=B_list(1:N,(i_s-1)*M+1:i_s*M);
    y=zeros(N,1);
    y(1:N)=expm(A*(t-tau))*B*fUt(tau,i_s,param,ut_param);
end
