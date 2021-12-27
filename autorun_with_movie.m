%% 针对8节点网络设计的可视化视频

index_of_sample  = 10;
rng(index_of_sample)

autorun;
data_unoptimized = load('tmp/unoptimized_trajactory.mat')
y = data_unoptimized.trajactory;
name = 'unoptimized_demo';
fDrawMovie(y,name);
data_unoptimized = load('tmp/optimized_trajactory.mat')
y = data_unoptimized.trajactory;
name = 'optimized_demo';
fDrawMovie(y,name);


