clear ;clc;
%%
% 主程序
READ_MPC80('CE6_OBS_20251130-20260102.txt','MPC80_CE6_OBS_20251130-20260102.txt')
[targets,stations] = MPC2TDM('MPC80_CE6_OBS_20251130-20260102.txt', 'TDM_CE6_OBS_20251130-20260102.tdm');
file_trace = ['D:\keyan\projects\OD\[20260107]ODTK_code_yyj\','TDM_CE6_OBS_20251130-20260102.tdm'];










%% 开启ODTK
% Make sure ODTK is running with the HTTP server started (default port is 9393)
winopen('MAIN_LaunchODTK-9494-od.cmd')

% -----------------------------------------------------------
%% 连接ODTK
% Add the ODTK API library in the search path
addpath('C:\Program Files\AGI\ODTK 7\CodeSamples\CrossPlatform\ODTK\matlab\lib');
client = Client('localhost', 9494);
odtk = client.Root;
odtkChildCount = odtk.children.count;


%% 创建场景
% ensure new scenario
if odtkChildCount > 0
    % close scenario
    odtk.application.deleteObject("", odtk.scenario{0});
    fprintf("Scenario closed.\n");
end
scenario = odtk.application.createObj(odtk, "Scenario", "TestScenario");
fprintf("Scenario created.\n");

scenario.EarthDefinition.EOPData.Filename = 'C:\ProgramData\AGI\ODTK 7\DynamicEarthData\EOP-All-v1.1.txt';

measurementFiles = scenario.Measurements.Files;
fprintf("Measurement files count: %i\n", measurementFiles.count);
% Clear the list
measurementFiles.clear();
% Add a new item to it
ne = measurementFiles.NewElem();
ne.Enabled = true;
ne.FileName = file_trace;
measurementFiles.push_back(ne);
fprintf("Measurement files count: %i\n", measurementFiles.count);
   


%% 创建卫星
% 定义卫星名称
satName = "yyj";

% 创建卫星并获取引用
mySat = odtk.application.createObj(odtk.scenario{0}, "Satellite", satName);


fprintf('创建卫星: %s\n', satName);

% 设置编号
for satId = 1:length(targets)
    ne = mySat.MeasurementProcessing.TrackingIDAliases.NewElem();
    ne.AliasID = targets{satId};
    mySat.MeasurementProcessing.TrackingIDAliases.push_back(ne);
end

mySat.ForceModel.Gravity.DegreeAndOrder = 70; % 地球非球型
mySat.ForceModel.Gravity.Tides.SolidTides = 'false'; % 固体潮
mySat.ForceModel.Gravity.Tides.OceanTides = 'false'; % 海洋潮
mySat.ForceModel.Drag.Use = 'No'; % 大气
% satellite.ForceModel.Drag.Model.CD = 2.2;
% satellite.ForceModel.Drag.Model.Area.Set(20 , 'm^2');
mySat.ForceModel.SolarPressure.Use = 'No'; % 光压
% satellite.ForceModel.SolarPressure.Model.Cr = 1;
% satellite.ForceModel.SolarPressure.Model.Area.Set(20 , 'm^2');
mySat.ForceModel.Gravity.ThirdBodies.Settings{0}.GMSource = 'JPL DE'; % 三体引力（默认）
mySat.ForceModel.Gravity.ThirdBodies.Settings{1}.GMSource = 'JPL DE';


%% 建立地面测站
StaNum = length(stations);
trakSys = odtk.application.createObj(odtk.scenario{0}, 'TrackingSystem', 'trakSys');
for StaIdx = 1:StaNum
    StaId = stations{StaIdx};
    [Lon,Lat] = GetStationCoordinates(StaId);
    facility = odtk.application.createObj(trakSys, 'Facility', StaId);
    facility.MeasurementProcessing.TrackingID = 100+StaIdx;
    ne = facility.MeasurementProcessing.TrackingIDAliases.NewElem();
    ne.AliasID = StaId;
    facility.MeasurementProcessing.TrackingIDAliases.push_back(ne);
    pos = facility.Position.ToGeodetic();
    pos.Lat.Set(Lat, 'deg');
    pos.Lon.Set(Lon, 'deg');
    pos.Alt.Set(1000, 'm');
    facility.Position.Assign(pos);
    pos = facility.Position.ToGeodetic();
    printGeodeticPos(pos);
    
    % 测量值
    RA_BiasSigma = 20;
    RA_WhiteNoiseSigma = 10;
    Dec_BiasSigma = 20;
    Dec_WhiteNoiseSigma = 10;
    facility.MeasurementStatistics.clear();
    facility.MeasurementStatistics.InsertByName('Right Ascension');
    facility.MeasurementStatistics.InsertByName('Declination');
    RA = facility.MeasurementStatistics{0};
    RA.Type.BiasSigma.Set(RA_BiasSigma, 'arcSec');
    RA.Type.WhiteNoiseSigma.Set(RA_WhiteNoiseSigma, 'arcSec');
    Dec = facility.MeasurementStatistics{1};
    Dec.Type.BiasSigma.Set(Dec_BiasSigma, 'arcSec');
    Dec.Type.WhiteNoiseSigma.Set(Dec_WhiteNoiseSigma, 'arcSec');
    
    facility.OpticalProperties.ReferenceFrame = 'MEME J2000';
    facility.AntennaType = 'Optical';
end










%% 创建最小二乘
% 添加LS
LS_Ground = odtk.application.createObj(odtk.scenario{0}.yyj, 'LeastSquares', 'LS_Ground');
fprintf('LeastSquares "LS_Ground" created.\n');

% 设置测站
LS_Ground.TrackerList.clear();
for StaIdx = 1:StaNum
    StaId = stations{StaIdx};
    TrackerName = ['trakSys.',StaId];
    LS_Ground.TrackerList.Insert(TrackerName);
end

% 测量类型
LS_Ground.MeasTypes.clear();
LS_Ground.MeasTypes.Insert('Right Ascension');
LS_Ground.MeasTypes.Insert('Declination');

LS_Ground.Output.STKEphemeris.DuringProcess.Generate = 'true';









%% 创建滤波器
Filter_Ground = odtk.application.createObj(odtk.scenario{0}, 'Filter', 'Filter1');
fprintf('Filter "Filter_Ground" created.\n');

% 指定卫星
Filter_Ground.SatelliteList.clear();
Filter_Ground.SatelliteList.InsertByName("yyj");

% 设置测站
Filter_Ground.TrackerList.clear();
for StaIdx = 1:StaNum
    StaId = stations{StaIdx};
    TrackerName = ['trakSys.',StaId];
    Filter_Ground.TrackerList.Insert(TrackerName);
end

% 测量类型
Filter_Ground.MeasTypes.clear();
Filter_Ground.MeasTypes.Insert('Right Ascension');
Filter_Ground.MeasTypes.Insert('Declination');

% 不输出平滑器数据
Filter_Ground.Output.SmootherData.Generate = 1;

% 修改输出文件名
prop_name = 'TestScenario';
Filter_Ground.Output.DataArchive.Filename = ['D:\keyan\projects\OD\[20260107]ODTK_code_yyj\ODTK\' , prop_name , '.filrun'];
Filter_Ground.Output.SmootherData.Generate = 1;







%% 创建IOD
% 添加IOD
IOD_Ground = odtk.application.createObj(odtk.scenario{0}.yyj, 'InitialOrbitDetermination', 'IOD_Ground');
fprintf('InitialOrbitDetermination "IOD_Ground" created.\n');


% 测量方法
IOD_Ground.Method.Type = 'GoodingAnglesOnly';

% 设置测站
IOD_Ground.Method.TrackerList.clear();
for StaIdx = 1:StaNum
    StaId = stations{StaIdx};
    TrackerName = ['trakSys.',StaId];
    IOD_Ground.Method.TrackerList.Insert(TrackerName);
end


% 找出最小二乘的最小段

MeaNum = IOD_Ground.Method.SelectedMeasurements.Choices.count;
count_ls = 1;
count = 0;
a_LS(1) = 0;
StartIdx = 0;
EndIdx = 1;
while EndIdx < MeaNum-1
    EndIdx = EndIdx + 1;
    changeorbit = 0;
    for i = StartIdx : EndIdx-2
        for j = i+1 : EndIdx-1 
            IOD_Ground.Method.SelectedMeasurements.clear();
            Mea1 = IOD_Ground.Method.SelectedMeasurements.Choices{i};
            Mea2 = IOD_Ground.Method.SelectedMeasurements.Choices{j};
            Mea3 = IOD_Ground.Method.SelectedMeasurements.Choices{EndIdx};
    
            IOD_Ground.Method.SelectedMeasurements.Insert(Mea1);
            IOD_Ground.Method.SelectedMeasurements.Insert(Mea2);
            IOD_Ground.Method.SelectedMeasurements.Insert(Mea3);
            %IOD_Ground.Method.SelectedMeasurements.Insert('000000  28 Nov 2025 00:45:15.034          K19 RaDec     137.7   20.4')
            %IOD_Ground.Method.SelectedMeasurements.Insert('155945  29 Nov 2025 20:04:20.294          D29 RaDec     140.3   19.5')
            %IOD_Ground.Method.SelectedMeasurements.Insert('242267  30 Nov 2025 20:03:01.757          P13 RaDec     141.9   18.8');
            
            selected_count = IOD_Ground.Method.SelectedMeasurements.Count;
            fprintf('已选择 %d 个测量数据\n', selected_count);
            
            IOD_Ground.go();
            kep = IOD_Ground.Output.OrbitState.ToKeplerian();
            %printKeplerianOrbitState(kep);
            a_IOD = kep.SemiMajorAxis.GetIn("km");
            
    
            if a_IOD ~= 0
                fprintf('IOD定轨成功！\n');
                IOD_Ground.transfer();
               % LS添加一行
                LS_Ground.Stages.clear();
                ls_newElem = LS_Ground.Stages.NewElem();
                LS_Ground.Stages.push_back(ls_newElem);
            
                % 提取
                ls_temp = LS_Ground.Stages{0};
            
                % 修改迭代次数
                StartTime = extractTimeString(Mea1);
                StopTime = extractTimeString(Mea3);
                ls_temp.MaxIterations = 20;
                ls_temp.StartTime.Set(StartTime , 'UTCG');
                ls_temp.StopTime.Set(StopTime , 'UTCG');
                %ls_temp.c.Set('29 Nov 2025 20:04:20.294' , 'UTCG');
                %ls_temp.StopTime.Set('30 Dec 2025 00:04:20.294' , 'UTCG');
            
            
                LS_Ground.go();
                kep = LS_Ground.Output.OrbitState.ToKeplerian();
                cart = LS_Ground.Output.OrbitState.ToCartesian();
                %printKeplerianOrbitState(kep);
                count_ls = count_ls + 1;
                a_LS(count_ls) = kep.SemiMajorAxis.GetIn("km");
                

                %LS_Ground.transfer(); 
                if a_LS(count_ls) ~= a_IOD && a_LS(count_ls) ~= a_LS(count_ls-1) 
                    count = count + 1;
                    r_LS(count,1) = cart.XPosition.GetIn("km");
                    r_LS(count,2) = cart.YPosition.GetIn("km");
                    r_LS(count,3) = cart.ZPosition.GetIn("km");
                    r_LS(count,4) = cart.XVelocity.GetIn("km*sec^-1");
                    r_LS(count,5) = cart.YVelocity.GetIn("km*sec^-1");
                    r_LS(count,6) = cart.ZVelocity.GetIn("km*sec^-1");
                    ObsInterval(count,1) = StartIdx;
                    ObsInterval(count,2) = EndIdx;
                    fprintf('第 %d 次最小二乘定轨成功！\n',count);
                    fprintf('对应第 %d 次到第 %d 次观测数据！\n',StartIdx+1,EndIdx+1);
                    StartIdx = EndIdx + 1;
                    EndIdx = EndIdx + 3;
                    changeorbit = 1;
                    break
                end
            end
        end
        if changeorbit
            break
        end
    end
end


% 在保持收敛的前提下，尝试合并小段以形成尽可能长的单一最小二乘弧段
if count > 1
    MergeStartIdx = 1;
    MergeEndIdx = 2;
    count_merge = 0;
    LS_Ground.CheckForDivergence = 'true';
    while MergeEndIdx <= count
    
        % 以最小二乘解作为初值
        kep = mySat.OrbitState.ToKeplerian();
        a = kep.SemiMajorAxis.GetIn("km");
        cart = mySat.OrbitState.ToCartesian();
        cart.XPosition.Set(num2str(r_LS(MergeStartIdx,1)), 'km');
        cart.YPosition.Set(num2str(r_LS(MergeStartIdx,2)), 'km');
        cart.ZPosition.Set(num2str(r_LS(MergeStartIdx,3)), 'km');
        cart.XVelocity.Set(num2str(r_LS(MergeStartIdx,4)), 'km*sec^-1');
        cart.YVelocity.Set(num2str(r_LS(MergeStartIdx,5)), 'km*sec^-1');
        cart.ZVelocity.Set(num2str(r_LS(MergeStartIdx,5)), 'km*sec^-1');
        %cart = scenario.yyj.OrbitState.Assign(cart);
        LScart = LS_Ground.Output.OrbitState.ToCartesian();
        res0 = LScart.XPosition.GetIn("km");
        Mea1 = IOD_Ground.Method.SelectedMeasurements.Choices{ObsInterval(MergeStartIdx,1)};
        Mea2 = IOD_Ground.Method.SelectedMeasurements.Choices{ObsInterval(MergeEndIdx,2)};
        StartTime = extractTimeString(Mea1);
        StopTime = extractTimeString(Mea2);
        LS_Ground.LeastSquares.Stages.clear();
        ls_newElem = LS_Ground.LeastSquares.Stages.NewElem();
        LS_Ground.LeastSquares.Stages.push_back(ls_newElem);
        ls_temp = LS_Ground.LeastSquares.Stages{0};
        ls_temp.MaxIterations = 20;
        ls_temp.StartTime.Set(StartTime , 'UTCG');
        ls_temp.StopTime.Set(StopTime , 'UTCG');
        LS_Ground.go();
        cart = LS_Ground.Output.OrbitState.ToCartesian();
        res1 = cart.XPosition.GetIn("km");
        if res1 ~= res0
            fprintf('第 %d 段到第 %d 段观测数据合并成功！\n',MergeStartIdx,MergeEndIdx);
            MergeEndIdx = MergeEndIdx + 1;
            if MergeEndIdx == count
                count_merge = count_merge + 1;
                ls_stage(count_merge,1) = MergeStartIdx;
                ls_stage(count_merge,2) = MergeEndIdx;
            end
        else
            count_merge = count_merge + 1;
            if MergeEndIdx - MergeStartIdx > 1
                ls_stage(count_merge,1) = MergeStartIdx;
                ls_stage(count_merge,2) = MergeEndIdx;
            else 
                ls_stage(count_merge,1) = MergeStartIdx;
                ls_stage(count_merge,2) = 0;
            end
            MergeStartIdx = MergeStartIdx + 1;
            MergeEndIdx = MergeEndIdx + 1;
        end
    end
    fprintf('总共分成了 %d 段观测数据\n',count_merge);


    % 合并后的观测弧段进行分段最小二乘
    %if count_merge > 1
        cart = mySat.OrbitState.ToCartesian();
        cart.XPosition.Set(num2str(r_LS(1,1)), 'km');
        cart.YPosition.Set(num2str(r_LS(1,2)), 'km');
        cart.ZPosition.Set(num2str(r_LS(1,3)), 'km');
        cart.XVelocity.Set(num2str(r_LS(1,4)), 'km*sec^-1');
        cart.YVelocity.Set(num2str(r_LS(1,5)), 'km*sec^-1');
        cart.ZVelocity.Set(num2str(r_LS(1,6)), 'km*sec^-1');
    
        LS_Ground.CheckForDivergence = 'false';
        LS_Ground.LeastSquares.Stages.clear();
        for LS_Final_Idx = 1 : count_merge
            Mea1 = IOD_Ground.Method.SelectedMeasurements.Choices{ObsInterval(ls_stage(LS_Final_Idx,1),1)};
            if ls_stage(LS_Final_Idx,2) ~= 0
                Mea2 = IOD_Ground.Method.SelectedMeasurements.Choices{ObsInterval(ls_stage(LS_Final_Idx,2),2)};
                obs_num = ObsInterval(ls_stage(LS_Final_Idx,2),2);
            else
                Mea2 = IOD_Ground.Method.SelectedMeasurements.Choices{ObsInterval(ls_stage(LS_Final_Idx,1),2)};
                obs_num = ObsInterval(ls_stage(LS_Final_Idx,1),2);
            end
            
            StartTime = extractTimeString(Mea1);
            StopTime = extractTimeString(Mea2);
            ls_newElem = LS_Ground.LeastSquares.Stages.NewElem();
            LS_Ground.LeastSquares.Stages.push_back(ls_newElem);
            ls_temp = LS_Ground.LeastSquares.Stages{LS_Final_Idx-1};
            ls_temp.MaxIterations = 20;
            ls_temp.StartTime.Set(StartTime , 'UTCG');
            ls_temp.StopTime.Set(StopTime , 'UTCG');
            ls_temp.InitialEdit = 'true';
            fprintf('第 %d 段观测区间设置为最小二乘完成第 %d 阶段！  ',LS_Final_Idx,LS_Final_Idx);
            fprintf('对应第 %d 次到第 %d  次观测数据！ \n',ObsInterval(ls_stage(LS_Final_Idx,1),1)+1,obs_num+1)
        end
        LS_Ground.go();
    %end

end





%% functions

function printKeplerianOrbitState(os)
    fprintf("Epoch : %s UTCG, Eccentricity: %f, " + ...
            "TrueArgOfLatitude: %f deg, Inclination: %f deg, " + ...
            "RAAN: %f deg, ArgOfPerigee: %f deg rad\n", ...
            os.Epoch.Format("UTCG"), ...
            os.Eccentricity, ...
            os.TrueArgOfLatitude.GetIn("deg"), ...
            os.Inclination.GetIn("deg"), ...
            os.RAAN.GetIn("deg"), ...
            os.ArgOfPerigee.GetIn("rad"));
end

function printGeodeticPos(p)
    fprintf("Lat : %f deg, Lon: %f deg, Alt: %f m\n", ...
        p.Lat.GetIn("deg"), ...
        p.Lon.GetIn("deg"), ...
        p.Alt.GetIn("m"));
end


function timeStr = extractTimeString(measStr)
    % 使用正则表达式匹配时间格式
    % pattern: 匹配"日期 月份 年份 时:分:秒.毫秒"
    pattern = '\d{1,2}\s+[A-Za-z]{3}\s+\d{4}\s+\d{2}:\d{2}:\d{2}\.\d{3}';
    
    % 使用regexp匹配
    match = regexp(measStr, pattern, 'match');
    
    if ~isempty(match)
        % 转换为字符串类型（使用string函数）
        timeStr = string(regexprep(match{1}, '\s+', ' '));
    else
        % 返回空字符串
        timeStr = string('');
        warning('未找到时间字符串: %s', measStr);
    end
end