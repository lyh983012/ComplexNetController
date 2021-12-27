function [ E ] =fCalEForLineSearch(param,ut_param,B_list)
    % ****************************************
    % fCalEForLineSearch:为了梯度下降时线性搜索方便使用的临时能量计算函数
    % 输入:
    %   @ut_param:用于生成ut的参数
    %   @param:拓扑结构数据包
    %   @B_list:暂时的B矩阵序列  
    % 输出:
    %   @E:在该步搜索位置(该Blist下)的能量
    % ****************************************  

    % 主体部分同optimizer中能量计算部分
    lambda_list = ut_param.lambda_list;
    
    A = param.A;
    t_list = param.t_list;
    alpha = param.alpha;
    K=param.K;
    N = param.N;
    M = param.M;
    
    Ut_list=zeros(N,K*N);
    Vt_list=zeros(N,K*N);
    Jt_list=zeros(N,K*N);
    Kt_list=zeros(N,K*N);   
    Ht_list=zeros(N,K*N);
    for i = 1:K
        B = B_list(:,M*(i-1)+1:M*i);
        tT = t_list(i+1) - t_list(i);
        H = [A,-(B*B')/(2*alpha);-2*(1-alpha)*eye(N),-A'];
        expH = expm(tT*H);
        Ki=expH(1:N,N+1:2*N);
        Ji=expH(1:N,1:N);
        Ui=expH(N+1:2*N,1:N);
        Vi=expH(N+1:2*N,N+1:2*N);
        Ut_list(:,1+(i-1)*N:i*N)=Ui;
        Vt_list(:,1+(i-1)*N:i*N)=Vi;
        Jt_list(:,1+(i-1)*N:i*N)=Ji;
        Kt_list(:,1+(i-1)*N:i*N)=Ki;
    end  

    Gamma_1=zeros(K*N,K*N);
    Gamma_2=zeros(K*N,K*N);
    Gamma_3=zeros(K*N,K*N);
    D=zeros(K*N,K*N);
    for i=0:1:K-1
        Gamma_1(1+i*N:(i+1)*N,1+i*N:(i+1)*N)= Kt_list(:,1+i*N:(i+1)*N);
        Gamma_2(1+i*N:(i+1)*N,1+i*N:(i+1)*N)=-Vt_list(:,1+i*N:(i+1)*N)';
              D(1+i*N:(i+1)*N,1+i*N:(i+1)*N)=eye(N);
    end
    for i=0:1:K-2
              D(1+(i+1)*N:(2+i)*N,1+i*N:(i+1)*N)=- Jt_list(1:N,1+(i+1)*N:(i+2)*N);
        Gamma_3(1+(i+1)*N:(2+i)*N,1+i*N:(i+1)*N)= Ut_list(1:N,1+(i+1)*N:(i+2)*N);
        Gamma_2(1+(i+1)*N:(2+i)*N,1+i*N:(i+1)*N)=eye(N);
    end
    Lambda=zeros(N*K,1);
    for i=0:1:K-1
        Lambda(1+i*N:(i+1)*N,1)=lambda_list(:,i+1);
    end
    D_inv=D^-1;
    T = Gamma_2*D_inv*Gamma_1-Gamma_1'*(D_inv)'*Gamma_3*D_inv*Gamma_1;
    E = 1/2*Lambda'*T*Lambda ;
    
end

