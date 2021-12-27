function [ figure1 ] = fDrawMovie( y ,name)
    % 绘制动图demo的函数
    % 此函数仅用于8node 网络映射为4个二维小球运动的演示
    % 其中4个网络节点上的值代表横坐标，另外四个节点代表纵坐标

    figure1 = figure();
    vidObj = VideoWriter(strcat('result/movie_',name),'MPEG-4');
    open(vidObj);
    cla
    fmat=moviein(840);
    scale = 4;
    axes1 = axes('Parent',figure1,'Position',[0.13 0.11 0.775 0.815]);
    axis([-50 50 -50 50])
    set(axes1,'FontSize',16,'FontWeight','bold','LineWidth',2,'XGrid','on',...
        'YGrid','on');
    box(axes1,'on');
    
    % 绘制终点
    hold on 
    scatter(y(1,840),y(2,840),120,'b','MarkerEdgeColor',[0 0 0],'Marker','o');
    scatter(y(3,840),y(4,840),120,'b','MarkerEdgeColor',[0 0 0],'Marker','o');
    scatter(y(5,840),y(6,840),120,'b','MarkerEdgeColor',[0 0 0],'Marker','o');
    scatter(y(7,840),y(8,840),120,'b','MarkerEdgeColor',[0 0 0],'Marker','o');
    r=10*sqrt(2); 
    rho = ones(1,201)*r;
    theta=0:pi/100:2*pi;
    polar(theta,rho,'--r')

    % 降采样绘制轨迹变化过程
    for i =1:1:length(y)/scale+20
        if i <length(y)/scale
            fScat(y(1,i*scale), y(2,i*scale), y(3,i*scale), y(4,i*scale), ...
                y(5,i*scale), y(6,i*scale), y(7,i*scale), y(8,i*scale),...
                60,'b',figure1);
        else
            fScat(y(1,840), y(2,840), y(3,840), y(4,840), ...
                y(5,840), y(6,840), y(7,840), y(8,840),...
                120,'b',figure1);
        end
        if i > 1 && i < length(y)/scale+1
            hold on 
            plot([y(1,i*scale),y(1,i*scale-scale)], [y(2,i*scale), y(2,i*scale-scale)],'LineWidth',2,'Color',[0.20392157137394 0.301960796117783 0.494117647409439]);
            hold on 
            plot([y(3,i*scale),y(3,i*scale-scale)], [y(4,i*scale), y(4,i*scale-scale)],'LineWidth',2,'Color',[1 0 0]);
            hold on 
            plot([y(5,i*scale),y(5,i*scale-scale)], [y(6,i*scale), y(6,i*scale-scale)],'LineWidth',2,'Color',[0.23137255012989 0.443137258291245 0.337254911661148]);
            hold on 
            plot([y(7,i*scale),y(7,i*scale-scale)], [y(8,i*scale), y(8,i*scale-scale)],'LineWidth',2,'Color',[0 0 1]);
        end
        writeVideo(vidObj,getframe);

end

