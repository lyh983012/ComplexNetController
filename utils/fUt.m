function y = fUt(t,i,param,ut_param)
    % ****************************************
    % fUt:通过ut数据包和网络拓扑给出任意时间的ut的值
    % 输入:
    %   @t:时间
    %   @i:第i个时间段（用于选择B_k）
    %   @param:第i个时间段    
    %   @ut_param:第i个时间段    
    % 输出:
    %   @y:ut的具体表达式  
    % ****************************************  
    A = param.A;
    B_list = param.B_list;
    epsilon_list = ut_param.epsilon_list;
    eta_list = ut_param.eta_list;
    alpha = param.alpha;
    N = param.N;
    M = param.M;

    Bi=B_list(1:N,(i-1)*M+1:i*M)';
    epsilon=epsilon_list(1:N,i);
    eta=eta_list(1:N,i);
    E_t=fEt(A,B_list(1:N,(i-1)*M+1:i*M),alpha,t);
    y2=[epsilon',eta']';
    y1=E_t*y2;
    lambda=y1(N+1:2*N,1); 
    y=-1/(2*alpha)*Bi*lambda;
    
end