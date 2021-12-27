%% autorun script

warning off;
addpath(genpath(pwd))

index_of_sample = 1; % task id
task = 'optimized'	 % your task name(optional)
drawx = true;		 % whether visualize the trajactory
showresult = true;   % whether visualize the results

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% a: Topology Network for the coomplex system
% b_list: B_i = B_list(:,M*i:M*(i+1)) as the connection matrices
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% step 1: Generate the Graph (auto or matually)

n = 8;		% network dimension
dis = 1;	% number of subnetwork for distribution control(1 for disable the distribution control)
prob = 0.9;	% connection rate for topology matrix
x_f = [10;10;10;-10;-10;10;-10;-10];% finnal state for all nodes in the network，dinmension=n
example_id = 0;
a = false;% false for randomly generation, or a \in R(n*n)

%%  step 2: Generate the connections

[a,b_list,topo_param] = fCalBList(n,a,dis,prob); % see utils
b_list(isnan(b_list))=0; 						 % clear nan
 
newAxisHandle = fDrawTopology(a) ;

topo_param.alpha = 0.5;         % \alpha = \frac{evolve energy}{total energy} 
topo_param.tf = 8.4;            % total time 
topo_param.t_list = 0:topo_param.tf/topo_param.K:topo_param.tf;
topo_param.preci = 0.0001;
topo_param.x0 = zeros(n,1);
save('tmp/topo_param_unoptimized.mat','topo_param')


%% step 3: Generate inputs u(t)

ut_param  = fCalUt(topo_param,x_f);

G = ut_param.G;
rank_G = rank(ut_param.G);
if rank_G == n
    fprintf(['>> Kalman Rank = ',num2str(rank_G),', G == N, Controllable\n']);
else
    fprintf('>> Runtime ERROR\n');
    clear
end

%% step 4: validate the trajactory 

drawxt = true;
trajactory = fCalTrajactory(topo_param,ut_param,drawxt);
save('tmp/unoptimized_trajactory.mat','trajactory')
fprintf(['>> Designed final satae is ',num2str(x_f'),'\n']);

%% step 5: optimize the control process 优化
train_param = struct();
%linesearch
train_param.preci=100;  %linesearch_steps，线性搜索的步数
train_param.linesearch=10;  %linesearch_K
%record the minimum
train_param.max_iteration=25; %最大迭代次数，精调时可设为数千步
train_param.int_preci = 0.01;

%Adam
train_param.mt=0;
train_param.nt=0;
train_param.beta1 = 0.9;
train_param.beta2 = 0.999;
train_param.epsilon=1e-8;

%optimization rate 
train_param.alpha_x0 =3e-1;
train_param.dL_alpha0=3e-2;

topo_param = fOptimizer(topo_param,train_param,x_f);

fprintf('>> Results are saved in ./result\n');

%% step 6： recalculate 
ut_param  = fCalUt(topo_param,x_f);


trajactory = fCalTrajactory(topo_param,ut_param,drawxt);
save('tmp/optimized_trajactory.mat','trajactory')
save('tmp/topo_param_optimized.mat','topo_param')