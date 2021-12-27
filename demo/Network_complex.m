function [A,B_list]=Network_complex()
    %一个手动生成的demo，运行后可以得到给定的A对应的B_list，用于和自动生成做对比
    clc;
    addpath(genpath(pwd))
    A=[0,0,0,0,0,0,1,0;
        0,0,0,1,0,0,0,0;
        0,0,0,0,0,0,0,0;
        0,0,1,0,1,0,1,0;
        1,0,0,0,0,0,0,1;
        0,0,0,1,0,0,0,0;
        0,1,0,0,0,0,0,0;
        0,0,0,0,0,0,0,0];
     
    [P,J]=jordan(A);
        
    D=find_driver_nodes_MM(A);
    fprintf(['>> MM_algorithm_drivings = ',num2str(length(D)),'\n']);
    fprintf(['>> temporal_algorithm_drivings = 2','\n']);
    
    r=real(J(6,6));
    i=imag(J(6,6));
    J(6,6)=r;
    J(6,5)=1;
    J(5,6)=-i^2;
    J(5,5)=r;
    
    r=real(J(7,7));
    i=imag(J(7,7));
    J(8,8)=r;
    J(8,7)=1;
    J(7,8)=-i^2;
    J(7,7)=r;
    
    [P1,J1]=jordan(J);

    S=real(P*P1^-1*J*P1*P^-1);
    P=real(P*P1^-1);

    C1=[1,0,0,0,0,0,0,0; 0,1,0,0,0,0,0,0]';
    C2=[0,0,1,0,0,0,0,0; 0,0,0,1,0,0,0,0]';
    C3=[0,0,0,0,0,1,0,0; 0,0,0,0,0,1,0,0]';
    C4=[0,0,0,0,0,0,1,0; 0,0,0,0,0,0,0,1]';

    K1=expm(J*3)*[C1 J*C1 J^2*C1 J^3*C1 J^4*C1 J^5*C1 J^6*C1 J^7*C1 ];
    K2=expm(J*2)*[C2 J*C2 J^2*C2 J^3*C2 J^4*C2 J^5*C2 J^6*C2 J^7*C2 ];
    K3=expm(J*1)*[C3 J*C3 J^2*C3 J^3*C3 J^4*C3 J^5*C3 J^6*C3 J^7*C3 ];
    K4=[C4 J*C4 J^2*C4 J^3*C4 J^4*C4 J^5*C4 J^6*C4 J^7*C4 ];


    O4=[K1 K2 K3 K4];
    O3=[K1 K2 K3];
    O2=[K1 K2 ];
    O1=[K1 ];
    
    rank(O1);
    rank(O2);
    rank(O3);
    rank(O4);
    
    rank(K1);
    rank(K2);
    rank(K3);
    rank(K4);
    
    B1=P*C1;
    B2=P*C2;
    B3=P*C3;
    B4=P*C4;
    
    M1=expm(A*5)*[B1 A*B1 A^2*B1 A^3*B1 A^4*B1 A^5*B1 A^6*B1 A^7*B1];
    M2=expm(A*4)*[B2 A*B2 A^2*B2 A^3*B2 A^4*B2 A^5*B2 A^6*B2 A^7*B2] ;
    M3=expm(A*3)*[B3 A*B3 A^2*B3 A^3*B3 A^4*B3 A^5*B3 A^6*B3 A^7*B3] ;
    M4=[B4 A*B4 A^2*B4 A^3*B4 A^4*B4 A^5*B4 A^6*B4 A^7*B4] ;
    
    o4=[M1 M2 M3 M4];
    o3=[M1 M2 M3];
    o2=[M1 M2 ];
    o1=[M1 ];
    
    fprintf(['>> after step1, rank = ',num2str(rank(o1)),'\n']);
    fprintf(['>> after step2, rank = ',num2str(rank(o2)),'\n']);  
    fprintf(['>> after step3, rank = ',num2str(rank(o3)),'\n']);   
    fprintf(['>> after step4, rank = ',num2str(rank(o4)),'\n']);   
    
    B_list=[B1 B2 B3 B4 B4 B4 B4 B4];
    
   
end

