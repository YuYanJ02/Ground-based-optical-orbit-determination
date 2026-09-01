clear ;clc;
%% 读取文件
READ_MPC80('DROB_20251026_27.txt','MPC80_DROB_20251026_27.txt')
[targets,stations,mag,time,ra_deg,dec_deg,station_per_obs,~] = MPC2TDM('MPC80_DROB_20251026_27.txt', 'TDM_DROB_20251026_27.tdm');
t_obs = time(:);
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
% 观测噪声敏感度（蒙特卡洛仿真），系统偏差为0
WhiteNoiseSigmaLevels = 0.5:0.5:3; % 噪声标准差水平（角秒）
NmcPerSigma = 100;
NSigma = length(WhiteNoiseSigmaLevels);
Nrun = NSigma * NmcPerSigma;
Rsigma = nan(Nrun,1);
Isigma = nan(Nrun,1);
Csigma = nan(Nrun,1);
RMSE = nan(Nrun,1);
RunSigma = nan(Nrun,1);
Converged = false(Nrun,1);


StaNum = length(stations);
trakSys = odtk.application.createObj(odtk.scenario{0}, 'TrackingSystem', 'trakSys');
for StaIdx = 1:StaNum
    StaId = stations{StaIdx};
    [Lon,Lat] = GetStationCoordinates(StaId); % 获取测站位置
    
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
    
    % 测量值
    RA_BiasSigma = 0; 
    RA_WhiteNoiseSigma = WhiteNoiseSigmaLevels(1);
    Dec_BiasSigma = 0;
    Dec_WhiteNoiseSigma = WhiteNoiseSigmaLevels(1);
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

% 修改输出文件名
% 修改输出文件名
prop_name = 'TestScenario';
Filter_Ground.Output.DataArchive.Filename = ['D:\keyan\projects\Ground-based_Optical-Observation_OD\[20260315]code\[20260107]ODTK_code_yyj\ODTK\' , prop_name , '.filrun'];
Filter_Ground.Output.SmootherData.Generate = 1;








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


%% 对测量白噪声标准差Monte Carlo
facility = odtk.TestScenario.TrackingSystem.trakSys.Facility;
iRun = 0;
for iSigma = 1:NSigma
curSigmaArcsec = WhiteNoiseSigmaLevels(iSigma);
    for iMC = 1:NmcPerSigma
        iRun = iRun + 1;
        RunSigma(iRun) = curSigmaArcsec;
        % LonDelta = randn();
        % LatDelta = randn();
        LonDelta = 0; % 暂不考虑测站位置误差
        LatDelta = 0;
        for StaIdx = 1:StaNum
            StaId = stations{StaIdx};
            [Lon,Lat] = GetStationCoordinates(StaId); % 获取测站位置
            pos = facility.(StaId).Position.ToGeodetic();
            pos.Lat.Set(Lat+LatDelta, 'deg');
            pos.Lon.Set(Lon+LonDelta, 'deg');
            pos.Alt.Set(1000, 'm');
            facility.(StaId).Position.Assign(pos);
        
            % 每次蒙特卡洛都更新该测站角度噪声
            facility.(StaId).MeasurementStatistics.clear();
            facility.(StaId).MeasurementStatistics.InsertByName('Right Ascension');
            facility.(StaId).MeasurementStatistics.InsertByName('Declination');
            RA = facility.(StaId).MeasurementStatistics{0};
            RA.Type.BiasSigma.Set(0, 'arcSec');
            RA.Type.WhiteNoiseSigma.Set(curSigmaArcsec, 'arcSec');
            Dec = facility.(StaId).MeasurementStatistics{1};
            Dec.Type.BiasSigma.Set(0, 'arcSec');
            Dec.Type.WhiteNoiseSigma.Set(curSigmaArcsec, 'arcSec');
        end
    
    
    % 算法准备
    tol_rho_km = 300;        % |Δrho| 小于此则停止迭代 (km)
    max_rho_iter = 50;       % 最大迭代次数
    rho_relax = 0.5;        % rho ← relax*rho_new + (1-relax)*rho_old，减小振荡；1 表示全用新值
    sta_alt_m = 1000;        % 与 Facility 椭球高一致
    delta_rho = 10000;       % LS失败直接更新地心距的幅值
    search_range_km = [100000;400000;10000];     % 短弧距离搜索范围及步长
    nObs = length(ra_deg);
    LsRun = false;
    tracklet = 'L';          % 长短弧标识
    
    % 长短弧判断
    if tracklet == 'L'
        rho_nom_km = 40000;      % 若是长弧'L'则不搜索距离，设地心距初值 (km)：LEO≈6778，GEO≈42164，深空可更大
    else
        % 若是短弧'S'则利用短弧残差角搜索方法搜索最优距离
        [best_rho, best_state] = range_residual_search(ra_deg, dec_deg, (1:nObs).', station_per_obs, t_obs, search_range_km, sta_alt_m);
        if isnan(best_rho)
            rho_nom_km = 40000; % 距离搜索失败时回退到保守初值
        else
            IOD_Ground.Method.Range1Estimate.Set(best_rho , 'km');
            IOD_Ground.Method.Range3Estimate.Set(best_rho , 'km');
            rho_nom_km = best_rho;
        end
    end
    
    % 基于三重积的IOD定轨+LS
    for rho_iter = 1:max_rho_iter 
        I_wrong = zeros(nObs, 3);
        I_geoc = zeros(nObs, 3);
    
        % 测站坐标转换至地心坐标
        for iiobs = 1:nObs
            I_wrong(iiobs,1) = cosd(dec_deg(iiobs)) * cosd(ra_deg(iiobs));
            I_wrong(iiobs,2) = cosd(dec_deg(iiobs)) * sind(ra_deg(iiobs));
            I_wrong(iiobs,3) = sind(dec_deg(iiobs));
            code = station_per_obs{iiobs};
            if iscell(code)
                code = code{1};
            end
            code = upper(strtrim(char(string(code))));
            [Lon, Lat] = GetStationCoordinates(code);
            if isnan(Lon) || isnan(Lat)
                I_geoc(iiobs,:) = I_wrong(iiobs,:);
                if rho_iter == 1
                    warning('站点 %s 无坐标，历元 %d 无法作测站→地心转换，退化为误用方向', code, iiobs);
                end
            else
                % 转换为地心角度向量
                I_geoc(iiobs,:) = topo_j2000_radec_to_geocentric_unit(ra_deg(iiobs), dec_deg(iiobs), Lat, Lon, sta_alt_m, t_obs(iiobs), rho_nom_km).';
            end
        end
    
        nComb = nObs * (nObs - 1) * (nObs - 2) / 6;
        V = zeros(nComb, 5);
        count = 0;
    
        % 遍历观测组合寻找最大三重积
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
        [Vmax_wrong, ~] = max(V(:,4));
        [Vmax, VmaxIdx] = max(V(:,5));
        fprintf('[rho_iter=%d, rho=%.1f km] 三重积：误作地心=%.6g，测站→地心修正后=%.6g\n', rho_iter, rho_nom_km, Vmax_wrong, Vmax);
    
        % 根据三重积结果选择IOD的输入测量值
        IOD_Ground.Method.SelectedMeasurements.clear();
        Mea1 = IOD_Ground.Method.SelectedMeasurements.Choices{V(VmaxIdx,1)-1};
        Mea2 = IOD_Ground.Method.SelectedMeasurements.Choices{V(VmaxIdx,2)-1};
        Mea3 = IOD_Ground.Method.SelectedMeasurements.Choices{V(VmaxIdx,3)-1};
        IOD_Ground.Method.SelectedMeasurements.Insert(Mea1);
        IOD_Ground.Method.SelectedMeasurements.Insert(Mea2);
        IOD_Ground.Method.SelectedMeasurements.Insert(Mea3);
        fprintf('已选择 %d 个测量数据 (rho_iter=%d)\n', IOD_Ground.Method.SelectedMeasurements.Count, rho_iter);
        IOD_Ground.go();
        kep = IOD_Ground.Output.OrbitState.ToKeplerian();
        a_IOD = kep.SemiMajorAxis.GetIn("km");
    
        % 如果IOD失败则增加地心距
        if a_IOD == 0
            warning('IOD 失败于 rho 迭代第 %d 轮', rho_iter);
            rho_nom_km = rho_nom_km + delta_rho; 
            continue;
        end
        fprintf('IOD 定轨成功 (rho_iter=%d)，a=%.1f km\n', rho_iter, a_IOD);
        IOD_Ground.transfer();
    
        % 如果IOD成功就进行LS
        LS_Ground.Stages.clear();
        ls_newElem = LS_Ground.Stages.NewElem();
        LS_Ground.Stages.push_back(ls_newElem);
        ls_temp = LS_Ground.Stages{0};
        StartTime = extractTimeString(IOD_Ground.Method.SelectedMeasurements.Choices{0});
        StopTime = extractTimeString(IOD_Ground.Method.SelectedMeasurements.Choices{MeaNum-1});
        % StartTime = extractTimeString(Mea1);
        % StopTime = extractTimeString(Mea3);
        ls_temp.MaxIterations = 40;
        ls_temp.StartTime.Set(StartTime , 'UTCG');
        ls_temp.StopTime.Set(StopTime , 'UTCG');
        LS_Ground.go();
        % EphemerisFileName = LS_Ground.Output.STKEphemeris.Files{0}.Filename;
        LsRun = LS_Ground.RunResults.RunSuccess;
    
        % 若LS失败则增加地心距
        if LsRun
            fprintf('最小二乘定轨成功 (rho_iter=%d)\n', rho_iter);
            cart = LS_Ground.Output.OrbitState.ToCartesian();
        else
            warning('LS 未成功 (rho_iter=%d)，加大地心距');
            cart = IOD_Ground.Output.OrbitState.ToCartesian();
            rho_nom_km = rho_nom_km + delta_rho;
            continue;
        end
       
        % 如果LS成功则根据最小二乘的结果更新地心距
        rx = cart.XPosition.GetIn("km");
        ry = cart.YPosition.GetIn("km");
        rz = cart.ZPosition.GetIn("km");
        rho_new = sqrt(rx^2 + ry^2 + rz^2);
        drho = abs(rho_new - rho_nom_km);
        fprintf('rho 迭代：|r|=%.1f km，|ρ_new−ρ_old|=%.1f km\n', rho_new, drho);
       
        % 更新地心距
        rho_next = rho_relax * rho_new + (1 - rho_relax) * rho_nom_km;
    
        % 迭代收敛判断
        if drho < tol_rho_km
            fprintf('名义地心距 rho 已收敛（阈值 %g km）\n', tol_rho_km);
            rho_nom_km = rho_next;
            break;
        end
        rho_nom_km = rho_next;
    end
    
    
    
    % 生成星历文件.e并导入STK
    if ~LsRun || LS_Ground.Output.STKEphemeris.Files.count == 0
        Rsigma(iRun) = nan;
        Isigma(iRun) = nan;
        Csigma(iRun) = nan;
        RMSE(iRun) = nan;
        Converged(iRun) = false;
        fprintf('[Sigma=%.2f arcsec] MC %d/%d: LS未收敛，跳过误差计算\n', ...
            curSigmaArcsec, iMC, NmcPerSigma);
        continue;
    end
     Rsigma(iRun) = LS_Ground.Output.OrbitUncertainty.R_sigma.GetIn("km");
        Isigma(iRun) = LS_Ground.Output.OrbitUncertainty.I_sigma.GetIn("km");
        Csigma(iRun) = LS_Ground.Output.OrbitUncertainty.C_sigma.GetIn("km");
    EphemerisFileName = LS_Ground.Output.STKEphemeris.Files{0}.Filename;
    [dis,t,Sun,Moon,Target,Target_real] = main_stk_dis(EphemerisFileName);
    
    
    
    % 总体位置 RMSE（考虑所有分量）
    totalSquaredErrors = dis.^2;         % 每个点的误差平方和（欧氏距离平方）
    totalRmse = sqrt(mean(totalSquaredErrors));     % 总体 RMSE
    fprintf('RMSE = %.4f\n', totalRmse/1000);
    
    RMSE(iRun) = totalRmse/1000;
    Converged(iRun) = LsRun == 1 && isfinite(RMSE(iRun));
    fprintf('[Sigma=%.2f arcsec] MC %d/%d: RMSE=%.3f km, Converged=%d\n', ...
        curSigmaArcsec, iMC, NmcPerSigma, RMSE(iRun), Converged(iRun));
    end
end


%% 统计输出
% 按噪声水平统计：位置误差均值、标准差、收敛率
SigmaArcsec = WhiteNoiseSigmaLevels(:);
PosErrMean_km = nan(NSigma,1);
PosErrStd_km = nan(NSigma,1);
ConvergenceRate = nan(NSigma,1);
RsigMean_km = nan(NSigma,1);
IsigMean_km = nan(NSigma,1);
CsigMean_km = nan(NSigma,1);

for iSigma = 1:NSigma
    idx = RunSigma == WhiteNoiseSigmaLevels(iSigma);
    PosErrMean_km(iSigma) = mean(RMSE(idx), 'omitnan');
    PosErrStd_km(iSigma) = std(RMSE(idx), 'omitnan');
    ConvergenceRate(iSigma) = mean(Converged(idx));
    RsigMean_km(iSigma) = mean(Rsigma(idx), 'omitnan');
    IsigMean_km(iSigma) = mean(Isigma(idx), 'omitnan');
    CsigMean_km(iSigma) = mean(Csigma(idx), 'omitnan');
end

MCStats = table(SigmaArcsec, PosErrMean_km, PosErrStd_km, ConvergenceRate, ...
    RsigMean_km, IsigMean_km, CsigMean_km);
disp(MCStats);
writetable(MCStats, 'MonteCarlo_Noise_Stats.csv');

% 每次运行明细记录（补充 Rsigma/Isigma/Csigma）
MCDetail = table(RunSigma, RMSE, Rsigma, Isigma, Csigma, Converged, ...
    'VariableNames', {'SigmaArcsec','RMSE_km','Rsigma_km','Isigma_km','Csigma_km','Converged'});
writetable(MCDetail, 'MonteCarlo_WhiteNoise_Detail.csv');

save('myVariables.mat', 'RunSigma', 'RMSE', 'Rsigma', 'Isigma', 'Csigma', 'Converged');
save('RMSE.mat',  'RMSE' );
save('Rsigma.mat',  'Rsigma' );
save('Isigma.mat',  'Isigma' );
save('Csigma.mat',  'Csigma' );
myVariables
load('myVariables.mat');
load('RMSE.mat');
load('Rsigma.mat');
load('Isigma.mat');
load('Csigma.mat');

%% 可视化
Tsigma = sqrt(Rsigma.^2+Isigma.^2+Csigma.^2);
figure('Position', [100, 100, 800, 500]);

% 绘制RMSE累积均值
RMSE_mean = cumsum(RMSE) ./ (1:length(RMSE))';
figure;
plot(1:length(RMSE), RMSE_mean, 'b-', 'LineWidth', 1.5);
hold on;
yline(mean(RMSE), 'r--', 'Final Mean', 'LineWidth', 1.2);
xlabel('Number of Samples','FontName', 'Times New Roman', 'FontSize', 15);
ylabel('RMSE \sigma Mean [km]','FontName', 'Times New Roman', 'FontSize', 15);
grid on;


% 绘制协方差累积均值
Rsigma_mean = cumsum(Rsigma) ./ (1:length(Rsigma))';
Isigma_mean = cumsum(Isigma) ./ (1:length(Isigma))';
Csigma_mean = cumsum(Csigma) ./ (1:length(Csigma))';
Tsigma_mean = cumsum(Tsigma) ./ (1:length(Tsigma))';
figure;

% 子图 1
subplot(2,2,1);
plot(1:length(Rsigma), Rsigma_mean, 'b-', 'LineWidth', 1.5);
hold on;
yline(mean(Rsigma), 'r--', 'Final Mean', 'LineWidth', 1.2);
xlabel('Number of Samples', 'FontName', 'Times New Roman', 'FontSize', 10);
ylabel('Radial \sigma Mean [km]', 'FontName', 'Times New Roman', 'FontSize', 10);
grid on;

% 子图 2
subplot(2,2,2);
plot(1:length(Isigma), Isigma_mean, 'b-', 'LineWidth', 1.5);
hold on;
yline(mean(Isigma), 'r--', 'Final Mean', 'LineWidth', 1.2);
xlabel('Number of Samples', 'FontName', 'Times New Roman', 'FontSize', 10);
ylabel('In-track \sigma Mean [km]', 'FontName', 'Times New Roman', 'FontSize', 10);
grid on;

% 子图 3
subplot(2,2,3);
plot(1:length(Csigma), Csigma_mean, 'b-', 'LineWidth', 1.5);
hold on;
yline(mean(Csigma), 'r--', 'Final Mean', 'LineWidth', 1.2);
xlabel('Number of Samples', 'FontName', 'Times New Roman', 'FontSize', 10);
ylabel('Cross-track \sigma Mean [km]', 'FontName', 'Times New Roman', 'FontSize', 10);
grid on;

% 子图 4
subplot(2,2,4);
plot(1:length(Tsigma), Tsigma_mean, 'b-', 'LineWidth', 1.5);
hold on;
yline(mean(Tsigma), 'r--', 'Final Mean', 'LineWidth', 1.2);
xlabel('Number of Samples', 'FontName', 'Times New Roman', 'FontSize', 10);
ylabel('Total \sigma Mean [km]', 'FontName', 'Times New Roman', 'FontSize', 10);
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