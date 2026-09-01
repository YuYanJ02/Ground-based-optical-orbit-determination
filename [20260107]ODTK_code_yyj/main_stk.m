function [Target,Moon,Earth] = main_stk(ephemerisFile)
% 输入ODTK生成的星历文件
% 输出状态参数


%% 场景
try
    uiApplication = actxserver('STK12.application');
    uiApplication.Visible = 1;
    root = uiApplication.Personality2;
    root.UnitPreferences.Item('DateFormat').SetCurrentUnit('UTCG');
    disp('已启动新的STK实例并连接成功！');
catch 
    error('STK连接失败');
end
root.NewScenario('Scen');

% 配置主卫星（导入ODTK的星历文件）
SatLeader = root.CurrentScenario.Children.New('eSatellite', 'SatLeader');
SatLeader.SetPropagatorType('ePropagatorStkExternal');
%ephemerisFile = 'D:\keyan\ODTK\Ephemeris\Sat_Satellite1_Fil_20251128_203251.e'; % 指定.e文件路径
externalProp = SatLeader.Propagator;
externalProp.Filename = ephemerisFile;
SatLeader.Propagator.Propagate;

startTime = SatLeader.Propagator.StartTime;
stopTime = SatLeader.Propagator.StopTime;
fprintf('时间范围：%s 至 %s\n', startTime, stopTime);
root.CurrentScenario.StartTime = startTime;
root.CurrentScenario.StopTime = stopTime;
root.CurrentScenario.Epoch = startTime;
disp(['场景时间已设置：开始时间 ', startTime, '，结束时间 ', stopTime]);


% Astrogator配置伴飞卫星
SatFollower = root.CurrentScenario.Children.New('eSatellite', 'SatFollower');
SatFollower.SetPropagatorType('ePropagatorAstrogator');
driver = SatFollower.Propagator;
driver.MainSequence.RemoveAll();
follow = driver.MainSequence.Insert('eVASegmentTypeFollow', 'Follow', '-');
follow.Leader.BindTo('Satellite/SatLeader');
follow.SeparationConditions.RemoveAll();

follow.SeparationConditions.Item('Duration').Properties.Trip = 3600*2400;
follow.SeparationConditions.Item('Duration').Properties.Trip = 3600*2400;
propagate = driver.MainSequence.Insert('eVASegmentTypePropagate', 'Propagate', '-');
propagate.PropagatorName = 'Earth HPOP Default v10';
propagate.StoppingConditions.Item('Duration').Properties.Trip = 3600*2400;
driver.RunMCS;
% root.SaveScenarioAs('D:\keyan\projects\OD\[20260107]ODTK_code_yyj\STK\stk_scen');
TarDP = SatFollower.DataProviders.Item('Astrogator Values');
results = TarDP.Group.Item('Cartesian Elems').Exec(startTime,stopTime,10);
%t = cell2mat(results.DataSets.GetDataSetByName('Time').GetValues);
x = cell2mat(results.DataSets.GetDataSetByName('X').GetValues);
y = cell2mat(results.DataSets.GetDataSetByName('Y').GetValues);
z = cell2mat(results.DataSets.GetDataSetByName('Z').GetValues);
vx = cell2mat(results.DataSets.GetDataSetByName('Vx').GetValues);
vy = cell2mat(results.DataSets.GetDataSetByName('Vy').GetValues);
vz = cell2mat(results.DataSets.GetDataSetByName('Vz').GetValues);
Target = [x y z vx vy vz];


% 配置月球
PltMoon = root.CurrentScenario.Children.New('ePlanet', 'Moon');
PltMoon.CommonTasks.SetPositionSourceCentralBody('Moon', 'eEphemJPLDE');
MoonPosDP = PltMoon.DataProviders.Item('Cartesian Position').Group.Item('J2000').Exec(startTime, stopTime, 60);
x = cell2mat(MoonPosDP.DataSets.GetDataSetByName('x').GetValues);
y = cell2mat(MoonPosDP.DataSets.GetDataSetByName('y').GetValues);
z = cell2mat(MoonPosDP.DataSets.GetDataSetByName('z').GetValues);
Moon = [x y z];

% 配置地球
PltEarth = root.CurrentScenario.Children.New('ePlanet', 'Earth');
PltEarth.CommonTasks.SetPositionSourceCentralBody('Earth', 'eEphemJPLDE');
MoonPosDP = PltEarth.DataProviders.Item('Cartesian Position').Group.Item('J2000').Exec(startTime, stopTime, 60);
x = cell2mat(MoonPosDP.DataSets.GetDataSetByName('x').GetValues);
y = cell2mat(MoonPosDP.DataSets.GetDataSetByName('y').GetValues);
z = cell2mat(MoonPosDP.DataSets.GetDataSetByName('z').GetValues);
Earth = [x y z];



% % 可视化
% figure;hold on;
% plot3(Target(:,1),Target(:,2),Target(:,3),'b-', 'LineWidth', 1.5);
% xlabel('X[km]', 'FontName', 'Times New Roman', 'FontSize', 6);
% ylabel('Y[km]', 'FontName', 'Times New Roman', 'FontSize', 6);
% zlabel('Z[km]', 'FontName', 'Times New Roman', 'FontSize', 6);
% plot3(0, 0,0, 'bo', 'MarkerSize', 20, 'MarkerFaceColor', 'black');
% plot3(Moon(:,1),Moon(:,2),Moon(:,3),'r-', 'LineWidth', 1.5);
% axis equal;view(3);


end