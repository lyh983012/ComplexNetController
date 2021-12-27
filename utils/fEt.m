function E_2n = fEt( A,B,alpha,t )
    % ****************************************
    % 能量计算函数:能量计算辅助函数
    % 输入:
    %   @A:拓扑矩阵
    %   @B:此步骤下的控制源连接矩阵
    %   @alpha:能量比例系数
    %   @t:具体时间
    % 输出:
    %   @E_2n:该时间下能量矩阵值
    % ****************************************  
    [m,n]=size(A);
    N=m;
    H = [A,-(B*B')/(2*alpha);-2*(1-alpha)*eye(N),-A'];
    E_2n = expm(t*H);
end


