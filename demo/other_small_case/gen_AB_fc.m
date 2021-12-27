function [ Alist, Blist ] = gen_AB_fc(param)

K = param.K;                                     % number of time steps
N = param.N;                                        % number of nodes in net
M = param.M;                                        % number of extern sources
alpha = param.alpha;                                % rate of evolve energy:total energy
tf = param.tf;                                     % total time
tlist= param.t_list;

Alist = zeros(N,N*K);
Blist = zeros(N,M*K);

prob = 0.8;

A=[0,0,0,0,1,0,1,0;
0,0,0,1,0,0,0,0;
0,0,0,0,0,1,0,0;
0,0,0,0,0,0,1,0;
1,0,0,0,0,0,0,1;
0,0,0,1,0,0,0,0;
0,0,0,0,0,0,0,0;
0,1,0,0,0,0,0,0;];

C3=[1,1,1,1,0,0,0,0]';
C4=[0,0,0,0,0,0,1,1]';
C2=[0,0,0,0,-1,0,0,0]';
C1=[0,0,0,0,0,2,0,0]';
[P,J]=jordan(A);
B1=P*C1;
B2=P*C2;
B3=P*C3;
B4=P*C4;
B=[B1 B2 B3 B4];

for i = 1:K
    Atemp = A;
    Btemp = B;
    Btemp = Btemp./norm(Btemp,2);
    %Btemp = Btemp/sum(Btemp(:)).*s;
    
    % verify controllability
    testMat = Btemp;
    for j = 1:N-1
        temp = (Atemp^j)*Btemp;
        temp = temp./(norm(temp,2)+0.00001);
        testMat = [testMat, temp];
    end  
    r = rank(testMat);
    
    while r<N
        a=1
    end

    Alist(1:N,(i-1)*N+1:i*N) = Atemp;
    Blist(1:N,(i-1)*M+1:i*M) = Btemp;
end

Alist
Blist

