function [ Alist, Blist, task ] = gen_AB(param)

task = 'Real eg network control,8 nodes'
K = param.K;                                     % number of time steps
N = param.N;                                        % number of nodes in net
M = param.M;                                        % number of extern sources
alpha = param.alpha;                                % rate of evolve energy:total energy
tf = param.tf;                                     % total time
tlist= param.t_list;

Alist = zeros(N,N*K); 
Blist = zeros(N,M*K);
[A, B_list]=Network_real()
for i = 1:K
    Blist(1:N,(i-1)*M+1:i*M) = B_list(:,(i-1)*M+1:i*M);
end

A=[0,0,0,0,1,0,1,0;
         0,0,0,1,0,0,0,0;
         0,0,0,0,0,1,0,0;
         0,0,0,0,0,0,1,0;
         1,0,0,0,0,0,0,1;
         0,0,0,1,0,0,0,0;
         0,0,0,0,0,0,0,0;
         0,1,0,0,0,0,0,0;];

for i = 1:K
    Alist(1:N,(i-1)*N+1:i*N) = A;
end

    for i_s=1:1:K
        B=Blist(1:N,(i_s-1)*M+1:i_s*M);
        B=B/sqrt(trace(B*B'));
        Blist(1:N,(i_s-1)*M+1:i_s*M)=B;          
    end
end



