
function scat(X1, Y1, X2, Y2, X3, Y3, X4, Y4, S1, C1,figure1)
%  视频生成散点图辅助函数
%  X1:  scatter x
%  Y1:  scatter y
%  S1:  scatter s
%  C1:  scatter c
%  X2:  scatter x
%  Y2:  scatter y
%  X3:  scatter x
%  Y3:  scatter y
%  X4:  scatter x
%  Y4:  scatter y
%  用于画轨迹图


% polar currently does not support code generation, enter 'doc polar' for correct input syntax
% polar(...);

% Create scatter
scatter(X1,Y1,S1,C1,...
    'MarkerFaceColor',[0.20392157137394 0.301960796117783 0.494117647409439],...
    'MarkerEdgeColor',[0.20392157137394 0.301960796117783 0.494117647409439]);

% Create scatter
scatter(X2,Y2,S1,C1,'MarkerEdgeColor',[1 0 0],'Marker','*');

% Create scatter
scatter(X3,Y3,S1,C1,...
    'MarkerFaceColor',[0.23137255012989 0.443137258291245 0.337254911661148],...
    'MarkerEdgeColor','none',...
    'Marker','square');

% Create scatter
scatter(X4,Y4,S1,C1,'MarkerFaceColor',[0 0 1],'Marker','diamond');
end

