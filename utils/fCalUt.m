function [ ut_param ] = fCalUt(topo_param, xf)
    % ****************************************
    % fCalUt:生成Ut所需的隐变量
    % 输入:
    %   @xf:网络末态
    %   @topo_param:拓扑结构数据包
    % 输出:
    %   @ut_param:Ut所需的隐变量
    % ****************************************  
    addpath(genpath(pwd))
    A = topo_param.A;
    B_list = topo_param.B_list;
    K = topo_param.K;                                        % number of time steps
    N = topo_param.N;                                        % number of nodes in net
    M = topo_param.M;                                        % number of extern sources
    alpha = topo_param.alpha;                                % rate of evolve energy:total energy
    t_list= topo_param.t_list;

    ut_param = struct();

    epsilon_list = [];
    eta_list = [];
    x0 = zeros(N,1);

    lagrange_unopt_result = fCalG(topo_param);      
    ut_param.G = lagrange_unopt_result.G;
    ut_param.U_list = lagrange_unopt_result.U_list;
    ut_param.V_list = lagrange_unopt_result.V_list;
    ut_param.J_list = lagrange_unopt_result.J_list;
    ut_param.K_list = lagrange_unopt_result.K_list;   
    ut_param.H_list = lagrange_unopt_result.H_list;

    %% pre - find a solution
    lambda=linsolve(ut_param.G,xf)' ;                    
    lambda_list=reshape(1*(lambda),N,K);          % ????????

    %% cal_epsilon,eta and lambda

    x_list=[];
    lambda_list_final=[];
    x_list=[x_list x0];
    for i=1:1:K
        t0=t_list(i);
        t1=t_list(i+1);
        A_i=A;
        B_i=B_list(:,(i-1)*M+1:i*M);
        E1=fEt(A_i,B_i,alpha,0);
        y1=[x_list(:,i)',lambda_list(:,i)']';
        y2=E1^-1*y1;
        epsilon=y2(1:N,:);
        eta=y2(N+1:2*N,:);
        E2=fEt(A_i,B_i,alpha,t1-t0);
        y2=[epsilon',eta']';
        y1=E2*y2;
        x_list=[x_list y1(1:N,1)];
        lambda_list_final=[lambda_list_final y1(N+1:N*2,1)];
        epsilon_list=[epsilon_list epsilon];
        eta_list=[eta_list eta];
    end

    % this function add 3 more var into param
    ut_param.epsilon_list = epsilon_list;
    ut_param.eta_list = eta_list;
    ut_param.lambda_list = lambda_list;

    end

