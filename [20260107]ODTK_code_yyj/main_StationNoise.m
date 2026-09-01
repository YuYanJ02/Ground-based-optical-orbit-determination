clear ;clc;
%% 读取文件
READ_MPC80('DROB_20251026_27.txt','MPC80_DROB_20251026_27.txt')
[targets,stations,mag,time,ra_deg,dec_deg,station_per_obs,~] = MPC2TDM('MPC80_DROB_20251026_27.txt', 'TDM_DROB_20251026_27.tdm');
t = time(:);
ra_deg = ra_deg(:);
dec_deg = dec_deg(:);
file_trace = ['D:\keyan\projects\Ground-based_Optical-Observation_OD\[20260315]code\[20260107]ODTK_code_yyj\','TDM_DROB_20251026_27.tdm'];




%% 开启ODTK
% Make sure ODTK is running with the HTTP server started (default port is 9393)
winopen('MAIN_LaunchODTK-9494-od.cmd')


%% 连接ODTK
% Add the ODTK API library in the search path
addpath('C:\Program Files\AGI\ODTK 7\CodeSamples\CrossPlatform\ODTK\matlab\lib');
client = Client('localhost', 9494);
odtk = client.Root;
odtkChildCount = odtk.children.count;


%% 配置场景
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
   


%% 配置卫星
satName = "yyj";
mySat = odtk.application.createObj(odtk.scenario{0}, "Satellite", satName);
fprintf('创建卫星: %s\n', satName);

% 设置追踪编号
for satId = 1:length(targets)
    ne = mySat.MeasurementProcessing.TrackingIDAliases.NewElem();
    ne.AliasID = targets{satId};
    mySat.MeasurementProcessing.TrackingIDAliases.push_back(ne);
end

% 设置力学模型
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





%% 配置地面测站
% 大地测量模型误差：各测站经纬独立 N(0, sigma^2)，观测 TDM 不变
% 仅 ODTK Facility 使用扰动坐标；MATLAB 三重积/测站→地心转换仍用名义坐标（与 main_try 一致）
sigma_station_arcsec = 10;   % 经纬扰动标准差 [arcsec]
sigma_lon_deg = sigma_station_arcsec / 3600;
sigma_lat_deg = sigma_station_arcsec / 3600;
Nmc = 200;
Rsigma = nan(Nmc, 1);
Isigma = nan(Nmc, 1);
Csigma = nan(Nmc, 1);
RMSE = nan(Nmc, 1);
Converged = false(Nmc, 1);

StaNum = length(stations);
StaLonNom = nan(StaNum, 1);
StaLatNom = nan(StaNum, 1);
trakSys = odtk.application.createObj(odtk.scenario{0}, 'TrackingSystem', 'trakSys');
for StaIdx = 1:StaNum
    StaId = stations{StaIdx};
    [Lon, Lat] = GetStationCoordinates(StaId);
    StaLonNom(StaIdx) = Lon;
    StaLatNom(StaIdx) = Lat;

    facility = odtk.application.createObj(trakSys, 'Facility', StaId);
    facility.MeasurementProcessing.TrackingID = 100+StaIdx;
    ne = facility.MeasurementProcessing.TrackingIDAliases.NewElem();
    ne.AliasID = StaId; % 测站编号
    facility.MeasurementProcessing.TrackingIDAliases.push_back(ne);
    pos = facility.Position.ToGeodetic();
    pos.Lat.Set(Lat, 'deg');
    pos.Lon.Set(Lon, 'deg');
    pos.Alt.Set(1000, 'm');
    facility.Position.Assign(pos);
    pos = facility.Position.ToGeodetic();
    printGeodeticPos(pos);
    
    % 测量值：与 main_try 一致设 1 arcsec，便于对比（纯评站址误差时可改为 0）
    meas_sigma_arcsec = 1;
    RA_BiasSigma = meas_sigma_arcsec;
    RA_WhiteNoiseSigma = meas_sigma_arcsec;
    Dec_BiasSigma = meas_sigma_arcsec;
    Dec_WhiteNoiseSigma = meas_sigma_arcsec;
    facility.MeasurementStatistics.clear();
    facility.MeasurementStatistics.InsertByName('Right Ascension');
    facility.MeasurementStatistics.InsertByName('Declination');
    RA = facility.MeasurementStatistics{0};
    RA.Type.BiasSigma.Set(RA_BiasSigma, 'arcSec');
    RA.Type.WhiteNoiseSigma.Set(RA_WhiteNoiseSigma, 'arcSec');
    Dec = facility.MeasurementStatistics{1};
    Dec.Type.BiasSigma.Set(Dec_BiasSigma, 'arcSec');
    Dec.Type.WhiteNoiseSigma.Set(Dec_WhiteNoiseSigma, 'arcSec');
    % 
    % 观测属性
    facility.OpticalProperties.ReferenceFrame = 'MEME J2000';
    facility.AntennaType = 'Optical';
end





%% 配置最小二乘
LS_Ground = odtk.application.createObj(odtk.scenario{0}.yyj, 'LeastSquares', 'LS_Ground');
fprintf('LeastSquares "LS_Ground" created.\n');

% 添加测站
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

LS_Ground.Output.STKEphemeris.Covariance = 'true';

LS_Ground.CombineMeasUncertainty = 'true';



%% 配置滤波器
Filter_Ground = odtk.application.createObj(odtk.scenario{0}, 'Filter', 'Filter1');
fprintf('Filter "Filter_Ground" created.\n');

% 指定卫星
Filter_Ground.SatelliteList.clear();
Filter_Ground.SatelliteList.InsertByName("yyj");

% 添加测站
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

% % 修改输出文件名
% prop_name = 'TestScenario';
% Filter_Ground.Output.DataArchive.Filename = ['D:\keyan\projects\OD\[20260107]ODTK_code_yyj\ODTK\' , prop_name , '.filrun'];
% Filter_Ground.Output.SmootherData.Generate = 1;







%% 配置IOD
IOD_Ground = odtk.application.createObj(odtk.scenario{0}.yyj, 'InitialOrbitDetermination', 'IOD_Ground');
fprintf('InitialOrbitDetermination "IOD_Ground" created.\n');

IOD_Ground.Method.Type = 'GoodingAnglesOnly';% 测量方法

% 添加测站
IOD_Ground.Method.TrackerList.clear();
for StaIdx = 1:StaNum
    StaId = stations{StaIdx};
    TrackerName = ['trakSys.',StaId];
    IOD_Ground.Method.TrackerList.Insert(TrackerName);
end
MeaNum = IOD_Ground.Method.SelectedMeasurements.Choices.count; % 获取观测数据总数

%ls_temp.c.Set('29 Nov 2025 20:04:20.294' , 'UTCG');
%ls_temp.StopTime.Set('30 Dec 2025 00:04:20.294' , 'UTCG');


%% 大地测量模型误差 Monte Carlo（定轨算法与 main_try.m 一致）
facility = odtk.TestScenario.TrackingSystem.trakSys.Facility;
tol_rho_km = 300;
max_rho_iter = 50;
rho_relax = 0.5;
sta_alt_m = 1000;
delta_rho = 5000;
search_range_km = [10000; 400000; 10000];
nObs = length(ra_deg);
tracklet = 'L';

for iMC = 1:Nmc
    StaLonPert = sigma_lon_deg * randn(StaNum, 1);
    StaLatPert = sigma_lat_deg * randn(StaNum, 1);

    % 每轮 MC 先恢复名义站址；IOD 全程用名义站址，仅 LS 用扰动站址
    assign_all_facilities_geodetic(facility, stations, StaLonNom, StaLatNom, sta_alt_m);

    if tracklet == 'L'
        rho_nom_km = 40000;
    else
        [best_rho, ~] = range_residual_search(ra_deg, dec_deg, (1:nObs).', station_per_obs, t, search_range_km, sta_alt_m);
        if isnan(best_rho)
            rho_nom_km = 40000;
        else
            IOD_Ground.Method.Range1Estimate.Set(best_rho, 'km');
            IOD_Ground.Method.Range3Estimate.Set(best_rho, 'km');
            rho_nom_km = best_rho;
        end
    end

    LsRun = false;
    for rho_iter = 1:max_rho_iter
        I_wrong = zeros(nObs, 3);
        I_geoc = zeros(nObs, 3);
        for iiobs = 1:nObs
            I_wrong(iiobs,1) = cosd(dec_deg(iiobs)) * cosd(ra_deg(iiobs));
            I_wrong(iiobs,2) = cosd(dec_deg(iiobs)) * sind(ra_deg(iiobs));
            I_wrong(iiobs,3) = sind(dec_deg(iiobs));
            [Lon_i, Lat_i] = nominal_station_coords(station_per_obs{iiobs}, stations, ...
                StaLonNom, StaLatNom);
            if isnan(Lon_i) || isnan(Lat_i)
                I_geoc(iiobs,:) = I_wrong(iiobs,:);
            else
                I_geoc(iiobs,:) = topo_j2000_radec_to_geocentric_unit(ra_deg(iiobs), dec_deg(iiobs), ...
                    Lat_i, Lon_i, sta_alt_m, t(iiobs), rho_nom_km).';
            end
        end

        nComb = nObs * (nObs - 1) * (nObs - 2) / 6;
        V = zeros(nComb, 5);
        count = 0;
        for ii = 1:nObs - 2
            for jj = ii + 1:nObs - 1
                for kk = jj + 1:nObs
                    count = count + 1;
                    V(count,1) = ii;
                    V(count,2) = jj;
                    V(count,3) = kk;
                    V(count,4) = abs(dot(I_wrong(ii,:), cross(I_wrong(jj,:), I_wrong(kk,:))));
                    V(count,5) = abs(dot(I_geoc(ii,:), cross(I_geoc(jj,:), I_geoc(kk,:))));
                end
            end
        end
        [~, VmaxIdx] = max(V(:,5));

        if tracklet == 'S'
            IOD_Ground.Method.Range1Estimate.Set(rho_nom_km, 'km');
            IOD_Ground.Method.Range3Estimate.Set(rho_nom_km, 'km');
        end

        IOD_Ground.Method.SelectedMeasurements.clear();
        Mea1 = IOD_Ground.Method.SelectedMeasurements.Choices{V(VmaxIdx,1)-1};
        Mea2 = IOD_Ground.Method.SelectedMeasurements.Choices{V(VmaxIdx,2)-1};
        Mea3 = IOD_Ground.Method.SelectedMeasurements.Choices{V(VmaxIdx,3)-1};
        IOD_Ground.Method.SelectedMeasurements.Insert(Mea1);
        IOD_Ground.Method.SelectedMeasurements.Insert(Mea2);
        IOD_Ground.Method.SelectedMeasurements.Insert(Mea3);
        IOD_Ground.go();
        kep = IOD_Ground.Output.OrbitState.ToKeplerian();
        a_IOD = kep.SemiMajorAxis.GetIn("km");
        if a_IOD == 0
            rho_nom_km = rho_nom_km + delta_rho;
            continue;
        end
        IOD_Ground.transfer();

        % 仅 LS 阶段施加大地测量扰动（1″ 只影响测量模型，不应改变 IOD 初轨）
        assign_all_facilities_geodetic(facility, stations, ...
            StaLonNom + StaLonPert, StaLatNom + StaLatPert, sta_alt_m);

        LS_Ground.Stages.clear();
        ls_newElem = LS_Ground.Stages.NewElem();
        LS_Ground.Stages.push_back(ls_newElem);
        ls_temp = LS_Ground.Stages{0};
        StartTime = extractTimeString(IOD_Ground.Method.SelectedMeasurements.Choices{0});
        StopTime = extractTimeString(IOD_Ground.Method.SelectedMeasurements.Choices{MeaNum-1});
        ls_temp.MaxIterations = 40;
        ls_temp.StartTime.Set(StartTime , 'UTCG');
        ls_temp.StopTime.Set(StopTime , 'UTCG');
        LS_Ground.go();
        LsRun = LS_Ground.RunResults.RunSuccess;
        if ~LsRun
            assign_all_facilities_geodetic(facility, stations, StaLonNom, StaLatNom, sta_alt_m);
            rho_nom_km = rho_nom_km + delta_rho;
            continue;
        end

        cart = LS_Ground.Output.OrbitState.ToCartesian();
        rx = cart.XPosition.GetIn("km");
        ry = cart.YPosition.GetIn("km");
        rz = cart.ZPosition.GetIn("km");
        rho_new = sqrt(rx^2 + ry^2 + rz^2);
        drho = abs(rho_new - rho_nom_km);
        rho_next = rho_relax * rho_new + (1 - rho_relax) * rho_nom_km;
        assign_all_facilities_geodetic(facility, stations, StaLonNom, StaLatNom, sta_alt_m);
        if drho < tol_rho_km
            rho_nom_km = rho_next;
            break;
        end
        rho_nom_km = rho_next;
    end

    if ~LsRun || LS_Ground.Output.STKEphemeris.Files.count == 0
        Converged(iMC) = false;
        fprintf('[MC %d/%d] LS未收敛\n', iMC, Nmc);
        continue;
    end
EphemerisFileName = LS_Ground.Output.STKEphemeris.Files{0}.Filename;
    Rsigma(iMC) = LS_Ground.Output.OrbitUncertainty.R_sigma.GetIn("km");
    Isigma(iMC) = LS_Ground.Output.OrbitUncertainty.I_sigma.GetIn("km");
    Csigma(iMC) = LS_Ground.Output.OrbitUncertainty.C_sigma.GetIn("km");
    % EphemerisFileName = LS_Ground.Output.STKEphemeris.Files{0}.Filename;
    [dis, ~, ~, ~, ~, target_real] = main_stk_dis(EphemerisFileName);
    totalNum = length(target_real);
    dis = dis(1:totalNum);
    RMSE(iMC) = position_rmse_km(dis);
    Converged(iMC) = true;
    fprintf('[MC %d/%d] RMSE=%.3f km (mean|dis|=%.3f km), R/I/C=%.3f/%.3f/%.3f km\n', ...
        iMC, Nmc, RMSE(iMC), mean(abs(dis), 'omitnan')/1000, ...
        Rsigma(iMC), Isigma(iMC), Csigma(iMC));
end

Tsigma = sqrt(Rsigma.^2 + Isigma.^2 + Csigma.^2);
MCDetail = table((1:Nmc).', RMSE, Rsigma, Isigma, Csigma, Tsigma, Converged, ...
    'VariableNames', {'Sample','RMSE_km','Rsigma_km','Isigma_km','Csigma_km','Tsigma_km','Converged'});
writetable(MCDetail, 'MonteCarlo_StationGeodesy_Detail.csv');
fprintf('收敛率: %.1f%% (%d/%d)\n', 100 * mean(Converged), sum(Converged), Nmc);

%% 累积均值随样本数变化
RMSE_mean = nan(Nmc, 1);
Rsigma_mean = nan(Nmc, 1);
Isigma_mean = nan(Nmc, 1);
Csigma_mean = nan(Nmc, 1);
Tsigma_mean = nan(Nmc, 1);
for k = 1:Nmc
    RMSE_mean(k) = mean(RMSE(1:k), 'omitnan');
    Rsigma_mean(k) = mean(Rsigma(1:k), 'omitnan');
    Isigma_mean(k) = mean(Isigma(1:k), 'omitnan');
    Csigma_mean(k) = mean(Csigma(1:k), 'omitnan');
    Tsigma_mean(k) = mean(Tsigma(1:k), 'omitnan');
end

cnFont = 'Microsoft YaHei';

figure('Position', [100, 100, 900, 380]);
plot(1:Nmc, RMSE_mean, 'b-', 'LineWidth', 1.5);
hold on;
yline(mean(RMSE, 'omitnan'), 'r--',  'LineWidth', 1.2, 'LabelHorizontalAlignment', 'left');
xlabel('样本数[-]', 'FontName', cnFont, 'FontSize', 14);
ylabel('位置RMSE累积均值 [km]', 'FontName', cnFont, 'FontSize', 14);
% title(sprintf('大地测量模型误差：测站位置标准差 \\sigma = %g 角秒', sigma_station_arcsec), ...
%     'FontName', cnFont, 'FontSize', 14);
set(gca, 'FontName', cnFont, 'FontSize', 12);
grid on;

figure('Position', [120, 120, 960, 720]);
% sgtitle(sprintf('RIC 轨道不确定度累积均值（\\sigma_{station} = %g 角秒）', sigma_station_arcsec), ...
%     'FontName', cnFont, 'FontSize', 14);

subplot(2, 2, 1);
plot(1:Nmc, Rsigma_mean, 'b-', 'LineWidth', 1.5);
hold on;
yline(mean(Rsigma, 'omitnan'), 'r--',  'LineWidth', 1.2, 'LabelHorizontalAlignment', 'left');
xlabel('样本数[-]', 'FontName', cnFont, 'FontSize', 12);
ylabel('径向 \sigma 累积均值 [km]', 'FontName', cnFont, 'FontSize', 12);
% title('R_{\sigma}', 'FontName', cnFont, 'FontSize', 12);
set(gca, 'FontName', cnFont, 'FontSize', 11);
grid on;

subplot(2, 2, 2);
plot(1:Nmc, Isigma_mean, 'b-', 'LineWidth', 1.5);
hold on;
yline(mean(Isigma, 'omitnan'), 'r--',  'LineWidth', 1.2, 'LabelHorizontalAlignment', 'left');
xlabel('样本数[-]', 'FontName', cnFont, 'FontSize', 12);
ylabel('迹向 \sigma 累积均值 [km]', 'FontName', cnFont, 'FontSize', 12);
% title('I_{\sigma}', 'FontName', cnFont, 'FontSize', 12);
set(gca, 'FontName', cnFont, 'FontSize', 11);
grid on;

subplot(2, 2, 3);
plot(1:Nmc, Csigma_mean, 'b-', 'LineWidth', 1.5);
hold on;
yline(mean(Csigma, 'omitnan'), 'r--',  'LineWidth', 1.2, 'LabelHorizontalAlignment', 'left');
xlabel('样本数[-]', 'FontName', cnFont, 'FontSize', 12);
ylabel('法向 \sigma 累积均值 [km]', 'FontName', cnFont, 'FontSize', 12);
% title('C_{\sigma}', 'FontName', cnFont, 'FontSize', 12);
set(gca, 'FontName', cnFont, 'FontSize', 11);
grid on;

subplot(2, 2, 4);
plot(1:Nmc, Tsigma_mean, 'b-', 'LineWidth', 1.5);
hold on;
yline(mean(Tsigma, 'omitnan'), 'r--',  'LineWidth', 1.2, 'LabelHorizontalAlignment', 'left');
xlabel('样本数[-]', 'FontName', cnFont, 'FontSize', 12);
ylabel('总 \sigma 累积均值 [km]', 'FontName', cnFont, 'FontSize', 12);
% title('\sigma_{RIC}', 'FontName', cnFont, 'FontSize', 12);
set(gca, 'FontName', cnFont, 'FontSize', 11);
grid on;





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


function assign_all_facilities_geodetic(facility, stations, lon_deg, lat_deg, alt_m)
    for StaIdx = 1:length(stations)
        StaId = stations{StaIdx};
        pos = facility.(StaId).Position.ToGeodetic();
        pos.Lat.Set(lat_deg(StaIdx), 'deg');
        pos.Lon.Set(lon_deg(StaIdx), 'deg');
        pos.Alt.Set(alt_m, 'm');
        facility.(StaId).Position.Assign(pos);
    end
end

function [lon_deg, lat_deg] = nominal_station_coords(code, stations, lon_nom, lat_nom)
    if iscell(code)
        code = code{1};
    end
    code = upper(strtrim(char(string(code))));
    idx = find(strcmpi(strtrim(stations), code), 1);
    if isempty(idx)
        [lon_deg, lat_deg] = GetStationCoordinates(code);
        return;
    end
    lon_deg = lon_nom(idx);
    lat_deg = lat_nom(idx);
end

function rmse_km = position_rmse_km(dis)
    % main_stk_dis 返回的 dis 单位为 m（与 main_try 中 dis/1000 作图一致）
    rmse_km = sqrt(mean(dis(:).^2, 'omitnan')) / 1000;
end

function timeStr = extractTimeString(measStr)
    % 使用正则表达式匹配时间格式
    % pattern: 匹配"日期 月份 年份 时:分:秒.毫秒"
    pattern = '\d{1,2}\s+[A-Za-z]{3}\s+\d{4}\s+\d{2}:\d{2}:\d{2}\.\d{3}';
    match = regexp(measStr, pattern, 'match');
    if ~isempty(match)
        timeStr = string(regexprep(match{1}, '\s+', ' '));
    else
        timeStr = string('');
        warning('未找到时间字符串: %s', measStr);
    end
end