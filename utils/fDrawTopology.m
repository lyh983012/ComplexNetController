function [ newAxisHandle ] = fDrawTopology( A )
 % 可视化拓扑结构
 % 输入：A，输出：绘图句柄
 bg=biograph(A); 
 set(bg.nodes,'shape','circle','color',[1,1,1],'lineColor',[0,0,0]);
 set(bg,'layoutType','radial');
 bg.showWeights='on';
 set(bg.nodes,'textColor',[0,0,0],'lineWidth',2,'fontsize',9);
 set(bg,'arrowSize',12,'edgeFontSize',9);
 get(bg.nodes,'position');
 set(0, 'ShowHiddenHandles', 'on');
 figure(100);
 myhandle = gcf;
 view(bg);
 bgfig = gcf;
 c = get(bgfig, 'Children');
 newAxisHandle = copyobj(c,myhandle);
 close(bgfig);
 saveas(gcf, strcat('result/network_topology.png'));
 close(gcf);
 delete bgfig

end

