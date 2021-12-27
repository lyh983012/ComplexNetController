function [ Alist, Blist, task ] = gen_AB_complex(param)

task = 'complex eg network control,8 nodes'
K = param.K;                                     % number of time steps
N = param.N;                                        % number of nodes in net
M = param.M;                                        % number of extern sources
alpha = param.alpha;                                % rate of evolve energy:total energy
tf = param.tf;                                     % total time
tlist= param.t_list;

Alist = zeros(N,N*K); 
Blist = zeros(N,M*K);
[A, B_list]=Network_complex();
for i = 1:K
    Alist(1:N,(i-1)*N+1:i*N) = A;
    Blist(1:N,(i-1)*M+1:i*M) = B_list(:,M*i-1:M*i);
end


