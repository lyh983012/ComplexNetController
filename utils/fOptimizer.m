function [ topo_param ] = fOptimizer(topo_param,train_param,xf)
    % ****************************************
    % fOptimizer:?????????
    % ??????:
    %   @xf:N*1?????????????????????
    %   @topo_param:?????????????????????????????????
    %   @train_param:????????????????????????  
    % ??????:
    %   @topo_param:?????????????????????????????????????????????
    % ****************************************  

    B_list = topo_param.B_list;
    K = topo_param.K;            % ????????????K
    N = topo_param.N;            % ?????????N
    M = topo_param.M;            % ????????????M
    tf = topo_param.tf;          % ?????????T

    %% step 1. ?????????????????????
    preci=train_param.preci;%??????????????????
    linesearch=train_param.linesearch;%??????????????????
    mt=train_param.mt;
    nt=train_param.nt;
    beta1 = train_param.beta1;
    beta2 = train_param.beta2;
    epsilon=train_param.epsilon; 
    % B???????????????????????????
    alpha_x0 =train_param.alpha_x0;
    % ?????????????????????????????????????????????
    dL_alpha0=train_param.dL_alpha0;
    % ??????????????????
    max_iteration=train_param.max_iteration;

    %% step2 . ?????????????????????
    E_list=[]; 
    S=1; %???????????????
    E_min=0;
    EI=zeros(N,N*K);
    EI(:,N*(K-1)+1:N*K)=eye(N);
    df=zeros(N*M*K,1);
    dh=zeros(N,N*M*K);
    dB_list=zeros(N,M,K);
    Gamma_1=zeros(K*N,K*N);
    Gamma_2=zeros(K*N,K*N);
    Gamma_3=zeros(K*N,K*N);
    D=zeros(K*N,K*N);
    Lambda=zeros(N*K,1);

    %% step3. ????????????????????????
    while S<max_iteration
        
        S=S+1;
        %____________step3.0???????????????????????????????????????_____________________________
        ut_param  = fCalUt(topo_param, xf);
        lambda_list = ut_param.lambda_list;
        for i=0:1:K-1
            Lambda(1+i*N:(i+1)*N,1)=lambda_list(:,i+1);
        end

        % ?????????????????????????????????????????????????????????????????????????????????UVJK???????????????????????????H
        U_list = ut_param.U_list;
        V_list = ut_param.V_list;
        J_list = ut_param.J_list;
        K_list = ut_param.K_list;   
        H_list = ut_param.H_list;

        for i=0:1:K-1
            Gamma_1(1+i*N:(i+1)*N,1+i*N:(i+1)*N)=  K_list(:,1+i*N:(i+1)*N);
            Gamma_2(1+i*N:(i+1)*N,1+i*N:(i+1)*N)=-V_list(:,1+i*N:(i+1)*N)';
            D(1+i*N:(i+1)*N,1+i*N:(i+1)*N)=eye(N);
        end
        for i=0:1:K-2
            D(1+(i+1)*N:(2+i)*N,1+i*N:(i+1)*N)=- J_list(1:N,1+(i+1)*N:(i+2)*N);
            Gamma_3(1+(i+1)*N:(2+i)*N,1+i*N:(i+1)*N)= U_list(1:N,1+(i+1)*N:(i+2)*N);
            Gamma_2(1+(i+1)*N:(2+i)*N,1+i*N:(i+1)*N)=eye(N);
        end
        D_inv=eye(N*K)/D;
        T = Gamma_2*D_inv*Gamma_1-Gamma_1'*(D_inv)'*Gamma_3*D_inv*Gamma_1;
        Dc = EI*D_inv*Gamma_1;
        E = 1/2*Lambda'*T*Lambda;
        
        if S==2
            E_min=E;
        end
        E_list=[E_list E];
        
        %_____________________step3.1??????????????????????????????____________________
        for T_i=1:1:K
            for j_s=1:1:M
                for i_s=1:1:N
                    dHBij=quadv(@(it)fIntegH(it,i_s,j_s,T_i,topo_param,H_list),0,tf/K,train_param.int_preci);
                    dJkBij=dHBij(1:N,1:N);
                    dKkBij=dHBij(1:N,1+N:2*N);
                    dUkBij=dHBij(1+N:2*N,1:N);
                    dVkBij=dHBij(1+N:2*N,1+N:2*N);%t=k,dJKUV/dBijk
                    dGamma1_Bkij=zeros(K*N,K*N);
                    dGamma2_Bkij=zeros(K*N,K*N);
                    dGamma3_Bkij=zeros(K*N,K*N);
                    dD_Bkij=zeros(K*N,K*N);
                    dGamma1_Bkij(1+(T_i-1)*N:N+(T_i-1)*N,1+(T_i-1)*N:N+(T_i-1)*N)=-dKkBij;
                    dGamma2_Bkij(1+(T_i-1)*N:N+(T_i-1)*N,1+(T_i-1)*N:N+(T_i-1)*N)=-dVkBij';%????E??Bij??????
                    if T_i<K
                        dD_Bkij(1+T_i*N:N+T_i*N,1+(T_i-1)*N:N+(T_i-1)*N)=dJkBij;
                        dGamma3_Bkij(1+T_i*N:N+T_i*N,1+(T_i-1)*N:N+(T_i-1)*N)=dUkBij;
                    end
                    dD_inv_Bkij=-D_inv*dD_Bkij*D_inv;
                    dT=dGamma2_Bkij*D_inv*Gamma_1+...
                        Gamma_2*dD_inv_Bkij*Gamma_1+...
                        Gamma_2*D_inv*dGamma1_Bkij-...
                        dGamma1_Bkij'*(D_inv)'*Gamma_3*D_inv*Gamma_1-...
                        Gamma_1'*(dD_inv_Bkij)'*Gamma_3*D_inv*Gamma_1-...
                        Gamma_1'*(D_inv)'*dGamma3_Bkij*D_inv*Gamma_1-...
                        Gamma_1'*(D_inv)'*Gamma_3*dD_inv_Bkij*Gamma_1-...
                        Gamma_1'*(D_inv)'*Gamma_3*D_inv*dGamma1_Bkij;
                    dE_Bkij=1/2*Lambda'*dT*Lambda;
                    dB_list(i_s,j_s,T_i)=dE_Bkij;
                    %_________calculate dh/dBijk
                    dh_Bkij=EI*(dD_inv_Bkij*Gamma_1+D_inv*dGamma1_Bkij)*Lambda;
                    dh(:,i_s+(j_s-1)*N+(T_i-1)*N*M)=dh_Bkij;
                    df(i_s+(j_s-1)*N+(T_i-1)*N*M,:)=dE_Bkij;
                end
            end
        end
        
        if mod(S,2)==1    %step3.2??????????????????
            grad = df;
            dc = dh;
            dcons = dh;

            for i=1:1:8
                for j=1:1:i-1
                    dh(i,:)=dh(i,:)-(dh(i,:)*dc(j,:)')/(dc(j,:)*dc(j,:)')*dc(j,:);
                end
                dc(i,:)=dh(i,:)/sqrt(trace(dh(i,:)*dh(i,:)'));
            end
            

            for i=1:1:8
                project=(dc(i,:)*grad)/(dc(i,:)*dc(i,:)')*dc(i,:);
                grad=grad-project';
            end
            x=reshape(B_list,N*M*K,1);
            
            % ADAM?????????
            grad=grad/sqrt(trace(grad*grad'));
            alpha_x=alpha_x0*(1-beta2^S)/(1-beta1^S);
            count=1;
            min=E;
            for i =1:1:preci
                x_=x - alpha_x*i * (linesearch/preci) *grad;
                E_t = fCalEForLineSearch(topo_param,ut_param,reshape(x_,N,M*K));
                if E_t<min
                    min=E_t;
                    count=i;
                end
            end
            grad=alpha_x*(count)/(preci)*(grad);
            mt=grad*(1-beta1)+beta1*mt;
            nt=grad'*grad*(1-beta2)+beta2*nt;
            m_t=mt/(1-beta1^S);
            n_t=nt/(1-beta2^S);
            dx = alpha_x*m_t/(sqrt(n_t) + epsilon);
            x = reshape(x-dx,N,M*K);
            
            % ??????B_list
            B_list =reshape(x,N,M*K);
            for i_s=1:1:K
                B=B_list(1:N,(i_s-1)*M+1:i_s*M);
                B=B/sqrt(trace(B*B'));
                B_list(1:N,(i_s-1)*M+1:i_s*M)=B;
            end
            topo_param.B_list = B_list;
            
        else % step3.3???????????????????????????????????????
            h=Dc*Lambda-xf;
            Lambda=Lambda-linsolve(Dc,h);
            % update lambda_list
            for i=0:1:K-1
                lambda_list(:,i+1) = Lambda(1+i*N:(i+1)*N,1);
            end
            ut_param.lambda_list = lambda_list;
            if E>0 && E<E_min
                E_min=E;
                topo_param.E_min = E_min;
            end
        end
        figure(3);
        semilogy(E_list);%show the imidiate result
        drawnow;
        h = Dc*Lambda-xf;
        fprintf('>> Mean ERROR_xt: %12.8f  ||  Min Energy: %12.8f  ||  Iteration: %d/%d\n'...
         ,sum(h)/length(h),E_min,S,max_iteration)
    end

    saveas(gcf, strcat('result/E_opt.png'));


    end

