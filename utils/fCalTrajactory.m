function [ trajactory ] = fCalTrajactory(topo_param,ut_param,drawx)
    % ****************************************
    % fCalTrajactory:用于仿真网络控制
    % 输入:
    %   @drawx:是否画图
    %   @topo_param:拓扑结构数据包
    %   @ut_param:用于生成ut的参数  
    % 输出:
    %   @trajactory:轨迹向量
    % ****************************************  
    addpath(genpath(pwd))

    A = topo_param.A;
    B_list = topo_param.B_list;
    K = topo_param.K;            % number of time steps
    N = topo_param.N;            % number of nodes in net
    M = topo_param.M;            % number of extern sources
    t_list= topo_param.t_list;
    tf = topo_param.tf;
    x0 = topo_param.x0;

    J_list = ut_param.J_list;
    K_list = ut_param.K_list;   
    lambda_list = ut_param.lambda_list;

    %% step1. 迭代法判定是否达到目标结果
    x_list=[];
    x_list=[x_list x0];
    for i=1:1:K
        J=J_list(:,1+(i-1)*N:i*N);
        K_m=K_list(:,1+(i-1)*N:i*N);
        x_list=[x_list J*x_list(1:N,i)+K_m*lambda_list(1:N,i)];
    end

    %% step2. 更精确的积分方法判定是否达到目标结果
    xf_list=[x0];
    y=[];
    a=x0;
    for i_s=1:1:K
        B=B_list(:,(i_s-1)*M+1:i_s*M);
        t=t_list(i_s):0.01:t_list(i_s+1);
        for j_s=2:length(t)
            a=expm(A*(t(j_s)-t(j_s-1)))*a+quadv(@(tau)fIntegTrajactory(tau,t(j_s)-t(1),i_s,topo_param,ut_param),t(j_s-1)-t(1),t(j_s)-t(1));
            y=[y a];
        end
        x0=y(:,end);
        xf_list=[xf_list x0];
    end

    % step3. 可视化结果
    if drawx 
        figure
        cla
        plot(0:length(y)/K:length(y),[sign(x_list).*(abs(x_list))]','ko','LineWidth',0.8)
        set(gca,'linewidth',1,'fontsize',15,'fontname','Times');
        hold on
        plot(1:1:length(y),sign(y).*((abs(y))),'LineWidth',1.5)
        xlabel('time/s');
        ylabel('value of each node');
        xlable={};
        i=0;
        for xstick = 0:tf/K:tf
            i=i+1;
            xlable(i)={num2str(xstick)};
        end
        xticks(0:length(y)/K:length(y));
        xticklabels(xlable);
        title(strcat('use  ',int2str(M),' control source'))
        saveas(gcf, strcat('result/simu2.png'));
    end


    fprintf(['>> test1, final state is ',num2str(x_list(:,end)'),'\n']);
    fprintf(['>> test2, final state is ',num2str(xf_list(:,end)'),'\n']);
    trajactory = sign(y).*((abs(y)));

    save('result/trajactory.mat','y')

    end

