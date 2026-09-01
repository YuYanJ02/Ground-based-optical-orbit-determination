clear;clc;
close all;
dbstop if error

aux.scen_Name = '\STK\stk_scen.sc';
currentFolder = pwd;
scnLocation = [currentFolder,aux.scen_Name];
uiapp = actxserver('STK12.application');
uiapp.Visible = 1;
root = uiapp.Personality2;
root.LoadScenario (scnLocation);
root.UnitPreferences.Item('DateFormat').SetCurrentUnit('JDate'); % or 'UTCG'
root.Rewind;
currScn = root.CurrentScenario;

%% 整段轨道
leader = currScn.Children.Item('SatLeader');
ephemerisFile = 'D:\keyan\projects\Ground-based_Optical-Observation_OD\[20260315]code\[20260107]ODTK_code_yyj\ephemeris\DROB_20250701_000100_20251205_080000_.oem'; % 替换为你的文件路径
leader.SetPropagatorType('ePropagatorStkExternal');
externalProp = leader.Propagator;
externalProp.Filename = ephemerisFile; % 指定文件

leader.Propagator.Propagate;

startTime = leader.Propagator.StartTime;
stopTime = leader.Propagator.StopTime;
fprintf('时间范围：%s 至 %s\n', startTime, stopTime);
root.CurrentScenario.StartTime = startTime;
root.CurrentScenario.StopTime = stopTime;

observer = currScn.Children.Item('SatFollower');
observer.Propagator.RunMCS;
% driver.ClearDWCGraphics;
T1 = juliandate(2025,10,10,0,0,0); 
T2 = juliandate(2025,11,10,0,0,0);
ObsDP = observer.DataProviders.Item('Astrogator Values');
results = ObsDP.Group.Item('Cartesian Elems').Exec(T1,T2,5);
t = cell2mat(results.DataSets.GetDataSetByName('Time').GetValues);
x = cell2mat(results.DataSets.GetDataSetByName('X').GetValues);
y = cell2mat(results.DataSets.GetDataSetByName('Y').GetValues);
z = cell2mat(results.DataSets.GetDataSetByName('Z').GetValues);
vx = cell2mat(results.DataSets.GetDataSetByName('Vx').GetValues);
vy = cell2mat(results.DataSets.GetDataSetByName('Vy').GetValues);
vz = cell2mat(results.DataSets.GetDataSetByName('Vz').GetValues);
Target = [x y z vx vy vz];
T=t;



%% 观测段轨道
leader = currScn.Children.Item('SatLeader2');
ephemerisFile = 'D:\keyan\projects\Ground-based_Optical-Observation_OD\[20260315]code\[20260107]ODTK_code_yyj\ephemeris\DROB_251025_251028.e'; % 指定.e文件路径
leader.SetPropagatorType('ePropagatorStkExternal');
externalProp = leader.Propagator;
externalProp.Filename = ephemerisFile; % 指定文件

leader.Propagator.Propagate;

startTime = leader.Propagator.StartTime;
stopTime = leader.Propagator.StopTime;
fprintf('时间范围：%s 至 %s\n', startTime, stopTime);


observer = currScn.Children.Item('SatFollower2');
observer.Propagator.RunMCS;
% driver.ClearDWCGraphics;

ObsDP = observer.DataProviders.Item('Astrogator Values');
results = ObsDP.Group.Item('Cartesian Elems').Exec(startTime,stopTime,5);
t = cell2mat(results.DataSets.GetDataSetByName('Time').GetValues);
x = cell2mat(results.DataSets.GetDataSetByName('X').GetValues);
y = cell2mat(results.DataSets.GetDataSetByName('Y').GetValues);
z = cell2mat(results.DataSets.GetDataSetByName('Z').GetValues);
vx = cell2mat(results.DataSets.GetDataSetByName('Vx').GetValues);
vy = cell2mat(results.DataSets.GetDataSetByName('Vy').GetValues);
vz = cell2mat(results.DataSets.GetDataSetByName('Vz').GetValues);
Target_obs = [x y z vx vy vz];
T=t;







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


%%
figure;hold on;
%plot3(Target(:,1),Target(:,2),Target(:,3),'b-', 'LineWidth', 1.5);
scatter3(Target(:,1),Target(:,2),Target(:,3),6, 'filled');
scatter3(Target_obs(:,1),Target_obs(:,2),Target_obs(:,3),6, 'filled');
xlabel('X[km]', 'FontName', 'Times New Roman', 'FontSize', 12);
ylabel('Y[km]', 'FontName', 'Times New Roman', 'FontSize', 12);
zlabel('Z[km]', 'FontName', 'Times New Roman', 'FontSize', 12);
plot3(0, 0,0, 'bo', 'MarkerSize', 20, 'MarkerFaceColor', 'black');
scatter3(Moon(:,1),Moon(:,2),Moon(:,3),6, 'filled');
axis equal;view(3);grid on;

legend('目标轨道','观测段轨道','地球','月球轨道','FontName', 'Times New Roman', 'FontSize', 12, 'Location', 'best');