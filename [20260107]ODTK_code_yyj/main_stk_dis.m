function [dis,t,Sun,Moon,Target,Target_real] = main_stk_dis(ephemerisFile)
% 输入ODTK生成的星历文件
% 还需提供真实轨道的星历文件
% 输出相对距离

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



%% ODTK结果
% 配置主卫星（导入ODTK的星历文件）
SatLeader = root.CurrentScenario.Children.New('eSatellite', 'SatLeader');
SatLeader.SetPropagatorType('ePropagatorStkExternal');
% ephemerisFile = 'D:\keyan\projects\OD\[20260107]ODTK_code_yyj\ephemeris\DROB_251025_251028.e';
externalProp = SatLeader.Propagator;
externalProp.Filename = ephemerisFile;
SatLeader.Propagator.Propagate;


startTime = SatLeader.Propagator.StartTime;
stopTime = SatLeader.Propagator.StopTime;

fprintf('时间范围：%s 至 %s\n', startTime, stopTime);
root.CurrentScenario.StartTime = startTime;
root.CurrentScenario.StopTime = stopTime;
disp(['场景时间已设置：开始时间 ', startTime, '，结束时间 ', stopTime]);


% Astrogator配置伴飞卫星
SatFollower = root.CurrentScenario.Children.New('eSatellite', 'SatFollower');
SatFollower.SetPropagatorType('ePropagatorAstrogator');
driver = SatFollower.Propagator;
driver.MainSequence.RemoveAll();
follow = driver.MainSequence.Insert('eVASegmentTypeFollow', 'Follow', '-');
follow.Leader.BindTo('Satellite/SatLeader');
follow.SeparationConditions.Item('Duration').Properties.Trip = 3600*2400;
propagate = driver.MainSequence.Insert('eVASegmentTypePropagate', 'Propagate', '-');
propagate.PropagatorName = 'Earth HPOP Default v10';
propagate.StoppingConditions.Item('Duration').Properties.Trip = 3600*2400;
driver.RunMCS;
% root.SaveScenarioAs('D:\keyan\projects\OD\[20260107]ODTK_code_yyj\STK\stk_scen');
TarDP = SatFollower.DataProviders.Item('Astrogator Values');
results = TarDP.Group.Item('Cartesian Elems').Exec(startTime,stopTime,10);
t = cell2mat(results.DataSets.GetDataSetByName('Time').GetValues);
x = cell2mat(results.DataSets.GetDataSetByName('X').GetValues);
y = cell2mat(results.DataSets.GetDataSetByName('Y').GetValues);
z = cell2mat(results.DataSets.GetDataSetByName('Z').GetValues);
vx = cell2mat(results.DataSets.GetDataSetByName('Vx').GetValues);
vy = cell2mat(results.DataSets.GetDataSetByName('Vy').GetValues);
vz = cell2mat(results.DataSets.GetDataSetByName('Vz').GetValues);
Target = [x y z vx vy vz];

% Planet
PltSun = root.CurrentScenario.Children.New('ePlanet', 'Sun');
PltSun.CommonTasks.SetPositionSourceCentralBody('Sun', 'eEphemJPLDE');
SunPosDP = PltSun.DataProviders.Item('Cartesian Position').Group.Item('J2000').Exec(startTime, stopTime, 10);
x = cell2mat(SunPosDP.DataSets.GetDataSetByName('x').GetValues);
y = cell2mat(SunPosDP.DataSets.GetDataSetByName('y').GetValues);
z = cell2mat(SunPosDP.DataSets.GetDataSetByName('z').GetValues);
Sun = [x y z];

PltMoon = root.CurrentScenario.Children.New('ePlanet', 'Moon');
PltMoon.CommonTasks.SetPositionSourceCentralBody('Moon', 'eEphemJPLDE');
MoonPosDP = PltMoon.DataProviders.Item('Cartesian Position').Group.Item('J2000').Exec(startTime, stopTime, 10);
x = cell2mat(MoonPosDP.DataSets.GetDataSetByName('x').GetValues);
y = cell2mat(MoonPosDP.DataSets.GetDataSetByName('y').GetValues);
z = cell2mat(MoonPosDP.DataSets.GetDataSetByName('z').GetValues);
Moon = [x y z];



%% 真实轨道
% 配置主卫星（导入ODTK的星历文件）
SatLeader1 = root.CurrentScenario.Children.New('eSatellite', 'SatLeader1');
SatLeader1.SetPropagatorType('ePropagatorStkExternal');
ephemerisFile = 'D:\documents\keyan\projects\Ground-based_Optical-Observation_OD\[20260315]code\[20260107]ODTK_code_yyj\ephemeris\DROB_251025_251028.e'; % 指定.e文件路径
externalProp = SatLeader1.Propagator;
externalProp.Filename = ephemerisFile;
SatLeader1.Propagator.Propagate;


% Astrogator配置伴飞卫星
SatFollower1 = root.CurrentScenario.Children.New('eSatellite', 'SatFollower1');
SatFollower1.SetPropagatorType('ePropagatorAstrogator');
driver = SatFollower1.Propagator;
driver.MainSequence.RemoveAll();
follow = driver.MainSequence.Insert('eVASegmentTypeFollow', 'Follow', '-');
follow.Leader.BindTo('Satellite/SatLeader1');
follow.SeparationConditions.Item('Duration').Properties.Trip = 3600*2400;
propagate = driver.MainSequence.Insert('eVASegmentTypePropagate', 'Propagate', '-');
propagate.PropagatorName = 'Earth HPOP Default v10';
propagate.StoppingConditions.Item('Duration').Properties.Trip = 3600*2400;
driver.RunMCS;
TarDP1 = SatFollower1.DataProviders.Item('Astrogator Values');
results1 = TarDP1.Group.Item('Cartesian Elems').Exec(startTime,stopTime,10);
%t = cell2mat(results.DataSets.GetDataSetByName('Time').GetValues);
x = cell2mat(results1.DataSets.GetDataSetByName('X').GetValues);
y = cell2mat(results1.DataSets.GetDataSetByName('Y').GetValues);
z = cell2mat(results1.DataSets.GetDataSetByName('Z').GetValues);
vx = cell2mat(results1.DataSets.GetDataSetByName('Vx').GetValues);
vy = cell2mat(results1.DataSets.GetDataSetByName('Vy').GetValues);
vz = cell2mat(results1.DataSets.GetDataSetByName('Vz').GetValues);
Target_real = [x y z vx vy vz];




%% 计算距离


% Analysis Workbench构建向量
vgtSat = SatFollower.Vgt;
centerPtSatFollower = vgtSat.Points.Item('Center');
vgtSat1 = SatFollower1.Vgt;
centerPtSatFollower1 = vgtSat1.Points.Item('Center');
VectFactory = vgtSat.Vectors.Factory;
dis =  VectFactory.CreateDisplacementVector('dis', centerPtSatFollower, centerPtSatFollower1);

% Create a new component through the Component Browser
compBrowser = root.CurrentScenario.ComponentDirectory.GetComponents('eComponentAstrogator').GetFolder('Calculation Objects');
CalObj = compBrowser.GetFolder('Vector');
VM = CalObj.Item('Vector Mag');
newVM = VM.CloneObject;
newVM.Name = 'DIS';
newVM.Vector = 'Satellite/SatFollower dis'; % km

% root.UnitPreferences.Item('DateFormat').SetCurrentUnit('EpSec');
% startTime = SatLeader.Propagator.StartTime;
% stopTime = SatLeader.Propagator.StopTime;
TarDP = SatFollower.DataProviders.Item('Astrogator Values');
results = TarDP.Group.Item('Vector').Exec(startTime,stopTime,10);
dis = cell2mat(results.DataSets.GetDataSetByName('DIS').GetValues);

t = results.DataSets.GetDataSetByName('Time').GetValues;




