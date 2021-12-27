function [P,J,N,M,T_k,A_list,B_list] = gen_AB_rw( dataname,M2)
vpa(128);
addpath(genpath(pwd))
A_list=[];
B=[];
M=M2;
jordanname=strcat('DataSet_2177_nodes/dataset',dataname);
if exist(jordanname,'file')
    load(jordanname);
else
    [P,J]=jordan(A);
    save(jordanname);
end

N=30;
uplist=[];
dwlist=[];
uf=1;
df=1;

for i=1:1:N-1
    if J(i,i)==J(i+1,i+1) && J(i,i+1)==1
        df=i+1;
    end
    if  J(i,i+1)~=1
        uplist=[uplist uf];
        dwlist=[dwlist df];
        uf=i+1;
        df=i+1;
    end
end

uplist=[uplist uf];
dwlist=[dwlist df];
            
for i=1:1:length(uplist)
    temp=zeros(N,1);
    uf=uplist(i);
    df=dwlist(i);
    if uf==df
        temp(uf)=1;
        B=[B temp];
        temp=zeros(N,1);
    elseif J(uf)==0
        temp(uf:df)=1;
        B=[B temp];
        temp=zeros(N,1);
    else
        temp(uf)=1;
         B=[B temp];
        temp=zeros(N,1);
    end
end

if sum(temp~=0)
    B=[B temp];
end

B_list=P*B;

n=B_list'*B_list;
n=diag(n)';

shape=size(B);
T_k=shape(2);
nn=zeros(N,T_k);

for i =1:1:N
    nn(i,:)=n;
end
B_list=B_list./nn;

shape=size(B_list);
T_k=ceil(shape(2)/M);
B_=zeros(N,T_k*M);
B_(:,1:shape(2))=B_list;
B_list=B_;

for i =1:1:T_k
    A_list=[A_list A];
end
Blist=B_list;
Alist=A_list;
save('data.mat')





