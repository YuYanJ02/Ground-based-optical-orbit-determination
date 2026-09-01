clear; clc; close all
dbstop if error
format longg; format compact
set(0,'defaultAxesFontName', 'TimesSimSun','defaultTextFontName', 'TimesSimSun');
set(0,'defaultAxesFontSize',15,'defaultTextFontSize',15)
set(0,'defaultLineLineWidth',2)

%% =============== 光学观测分析 ================
% 场景 E:\DRO\in_orbit\in_Orbit_Scn\droGroundOptical

% 观测数据
obsFileName =  'D:\documents\keyan\projects\Ground-based_Optical-Observation_OD\[20260315]code\toYYJ\DROAB_2024_stellar_aberration.csv';

%% ================= 载入观测数据 ==================

opts = delimitedTextImportOptions("NumVariables", 8);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["sat", "time", "ra", "dec", "mag", "site_code", "ra_aberration", "dec_aberration"];
opts.VariableTypes = ["string", "datetime", "string", "string", "double", "string", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["sat", "ra", "dec", "site_code"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["sat", "ra", "dec", "site_code"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "time", "InputFormat", "yyyy-MM-dd'T'HH:mm:ss.SSS");

% Import the data
dataOptical = readtable(obsFileName, opts);


%% Clear temporary variables
clear opts

%%  ================= 读取星历初值 =================
ReadEph;  % 得到 satODList;

%%  ================= 读取姿态 =================
ReadAtt;
attDROA = [];
attDROB = [];

%%   ================= 表面积 =================
% A 1.09*1.01*1.22
% B 0.85*1.01*1.22
areaA = [
    1 0 0 1.01*1.22
    -1 0 0 1.01*1.22
    0 1 0 1.09*1.22
    0 -1 0 1.09*1.22
    0 0 1 1.09*1.01
    0 0 -1 1.09*1.01
    ];
areaB = [
    1 0 0 1.01*1.22
    -1 0 0 1.01*1.22
    0 1 0 0.85*1.22
    0 -1 0 0.85*1.22
    0 0 1 0.85*1.01
    0 0 -1 0.85*1.01
    ];



for iiAtt = 1:size(Attitude, 1)
    temp = table2cell(Attitude(iiAtt, :));

    tAttTemp = juliandate(temp{1}); % JD UTC
    if isnan(tAttTemp)
        continue;
    end
    qTemp = str2num(temp{2});
    eZ =  temp{6};
    attDROA(iiAtt, :) = [tAttTemp, qTemp, eZ];

    tAttTemp = juliandate(temp{9}); % JD UTC
    if isnan(tAttTemp)
        continue;
    end
    qTemp = str2num(temp{10});
    eZ =  temp{14};
    attDROB(iiAtt, :) = [tAttTemp, qTemp, eZ];
end

% 1 = DROA, 0 = DROB
for iiObs = 1:size(satODList, 1)
    xxChk(iiObs, :) = [satODList{iiObs}.orb(1), satODList{iiObs}.ObjName == 'DROA'];
end

dryMass =  [262.77 198.56];

%%  ================= 载入  =================
uiApplication = actxGetRunningServer('STK12.application');
uiApplication.Visible = 1;
root = uiApplication.Personality2;
root.UnitPreferences.Item('DateFormat').SetCurrentUnit('JDate');
currScn = root.CurrentScenario;


dro = currScn.Children.Item('DRO_Test');

for iiObs = 1:size(dataOptical,1)  

    temp = table2cell(dataOptical(iiObs, :));
    satName = temp{1};
    tObs = juliandate(temp{2}); % UTC to jd
    tObsStrUTC = root.ConversionUtility.ConvertDate("JDate", 'UTCG', ...
        num2str(tObs, '%.8f'));
    tObsStrBJT = root.ConversionUtility.ConvertDate("JDate", 'UTCG', ...
        num2str(tObs+1/3, '%.8f'));

    disp(['BJT ', tObsStrBJT,', Mag ',num2str(temp{5})])

     switch satName
        case 'DROB'
            1;
            continue;
    end

    ra = str2num(temp{3});
    ra = sum(ra.*[1/24 1/1440 1/86400]*360);
    decSgn = str2num(temp{4});
    if decSgn(1)<0
        1;
    end
    dec = sum(abs(decSgn).* [1 1/60 1/3600]);
    dec = sign(decSgn(1))*dec;
    mag = temp{5};
    fac = currScn.Children.Item(temp{6});

    % 找到最近的初值，并且预报
    switch satName
        case 'DROA'
            xxChkCurr = xxChk(xxChk(:, 2) == 1,:);
            attCurr = attDROA;
            dro.VO.Model.ModelData.Filename  = ...
                'D:\documents\keyan\projects\Ground-based_Optical-Observation_OD\[20260315]code\toYYJ_groundOptical\DROA_0912A.mdl';
            area = areaA;
        case 'DROB'
            xxChkCurr = xxChk(xxChk(:, 2) == 0,:);
            attCurr = attDROB;
            dro.VO.Model.ModelData.Filename  = ...
                'D:\documents\keyan\projects\Ground-based_Optical-Observation_OD\[20260315]code\toYYJ_groundOptical\DROB_0912B.mdl';
            area = areaB;
    end

    idxEph = find(xxChkCurr(:,1)<tObs,1,'last');
    if isempty(idxEph)
        continue;
    end
    idxAtt = find(attCurr(:,1)<tObs,1,'last');
    if isempty(idxAtt)
        continue;
    end

    [~, idxEph] = min(vecnorm([xxChk(:,1)-xxChkCurr(idxEph),...
        xxChk(:,2)-(satName == 'DROA')],2,2));

    xxOD = satODList{idxEph}.orb;
    fullMass = satODList{idxEph}.satPara.mass;
    srpArea = satODList{idxEph}.satPara.SRP_area;
    srpCr = satODList{idxEph}.satPara.SRP_cr;

    MSC = dro.Propagator.MainSequence;
    MSC.Item('Ics').OrbitEpoch = xxOD(1);
    MSC.Item('Ics').Element.X = xxOD(2);
    MSC.Item('Ics').Element.Y = xxOD(3);
    MSC.Item('Ics').Element.Z = xxOD(4);
    MSC.Item('Ics').Element.Vx = xxOD(5);
    MSC.Item('Ics').Element.Vy = xxOD(6);
    MSC.Item('Ics').Element.Vz = xxOD(7);
    MSC.Item('Ics').SpacecraftParameters.DryMass = dryMass(1);
    MSC.Item('Ics').SpacecraftParameters.SolarRadiationPressureArea = srpArea(1);
    MSC.Item('Ics').SpacecraftParameters.Cr = srpCr(1);
    if satName == 'DROA'
        MSC.Item('Ics').FuelTank.FuelMass = fullMass(1)-dryMass(1);
    else
        MSC.Item('Ics').FuelTank.FuelMass = fullMass(1)-dryMass(2);
    end

    % 配置默认姿态
    cmd = ['SetAttitude ',...
        '*/Satellite/',dro.InstanceName,...
        ' Profile NadirSun '...
        '"',num2str(xxOD(1)),'"'
        ];
    root.ExecuteCommand(cmd);

    % 修改配置姿态
    tAtt1 = attCurr(idxAtt,1);
    attName =  'InertFix';
    para = attCurr(idxAtt, 2:5);

    tAttStartUTCG =  root.ConversionUtility.ConvertDate("JDate", 'UTCG', ...
        num2str(tAtt1, '%.8f'));
    cmd = ['AttitudeSegment ',...
        '*/Satellite/', dro.InstanceName,...
        '      Add    Profile ', attName, ' ',...
        '"', tAttStartUTCG, '"',...
        '  InertFix ',...
        '    ', 'Quat',...
        '    ',num2str(para)
        ];
    root.ExecuteCommand(cmd);

    dro.Propagator.RunMCS;

    % 计算位置
    rptDP = dro.DataProviders.Item('Vector Choose Axes')...
        .Group.Item('Position');
    rptElems = {'Time';'x';'y';'z';'Magnitude'};

    rptDP.PreData = 'CentralBody/Earth SER';
    dataSets = ...
        rptDP.ExecElements(tObs, tObs+60/86400, ...
        60, rptElems).DataSets;
    vecTemp = [cell2mat(dataSets.GetDataSetByName('Time').GetValues), ...
        cell2mat(dataSets.GetDataSetByName('x').GetValues), ...
        cell2mat(dataSets.GetDataSetByName('y').GetValues), ...
        cell2mat(dataSets.GetDataSetByName('z').GetValues),...
        cell2mat(dataSets.GetDataSetByName('Magnitude').GetValues)];
    % 日距角：地心处太阳方向与卫星方向夹角（SER 系 x 轴沿地心指向太阳）
    thetaSun = acosd(-vecTemp(:,2) ./ vecTemp(:,5));
    rEarth = vecTemp(:,5);

    rptDP.PreData = 'CentralBody/Earth EMR';
    dataSets = ...
        rptDP.ExecElements(tObs, tObs+60/86400, ...
        60, rptElems).DataSets;
    vecTemp = [cell2mat(dataSets.GetDataSetByName('Time').GetValues), ...
        cell2mat(dataSets.GetDataSetByName('x').GetValues), ...
        cell2mat(dataSets.GetDataSetByName('y').GetValues), ...
        cell2mat(dataSets.GetDataSetByName('z').GetValues),...
        cell2mat(dataSets.GetDataSetByName('Magnitude').GetValues)];
    % 月球角距：地心处月球方向与卫星方向夹角（EMR 系 x 轴沿地心指向月球）
    thetaMoon = acosd(vecTemp(:,2) ./ vecTemp(:,5));

    rptDP.PreData = 'CentralBody/Earth ICRF';
    dataSets = ...
        rptDP.ExecElements(tObs, tObs+60/86400, ...
        60, rptElems).DataSets;
    vecTemp = [cell2mat(dataSets.GetDataSetByName('Time').GetValues), ...
        cell2mat(dataSets.GetDataSetByName('x').GetValues), ...
        cell2mat(dataSets.GetDataSetByName('y').GetValues), ...
        cell2mat(dataSets.GetDataSetByName('z').GetValues),...
        cell2mat(dataSets.GetDataSetByName('Magnitude').GetValues)];
    thetaEarth = asind(vecTemp(:,4)./vecTemp(:,5));

    % 计算access
    access = fac.GetAccessToObject(dro);
    access.Advanced.AberrationType = 'eAberrationNone';
    access.Advanced.SignalSenseOfClockHost  = 'eIvReceive';
    access.Advanced.ClockHost   = 'eIvBase';
    access.ComputeAccess;

    rptDp = access.DataProviders.Item('Vectors(ICRF)').Group.Item('From-To-RelPos');
    rptElems = {'Time';'Magnitude';'RightAscension';'Declination'};
    dataSets = ...
        rptDp.ExecElements(tObs, tObs+60/86400, ...
        60, rptElems).DataSets;
    resTemp = [cell2mat(dataSets.GetDataSetByName('Time').GetValues), ...
        cell2mat(dataSets.GetDataSetByName('Magnitude').GetValues), ...
        cell2mat(dataSets.GetDataSetByName('RightAscension').GetValues), ...
        cell2mat(dataSets.GetDataSetByName('Declination').GetValues)];
    resTemp(:,3)=(resTemp(:,3)<360)*360+resTemp(:,3);

    % 本体系太阳矢量和地心矢量
    rptDP = dro.DataProviders.Item('Vectors(Body)');
    rptElems = {'Time';'x/Magnitude';'y/Magnitude';'z/Magnitude'};

    vectorName = 'Sun';
    dataSets = ...
        rptDP.Group.Item(vectorName).ExecElements(tObs, tObs+60/86400, ...
        60, rptElems).DataSets;
    vecTemp = [cell2mat(dataSets.GetDataSetByName('Time').GetValues), ...
        cell2mat(dataSets.GetDataSetByName('x/Magnitude').GetValues), ...
        cell2mat(dataSets.GetDataSetByName('y/Magnitude').GetValues), ...
        cell2mat(dataSets.GetDataSetByName('z/Magnitude').GetValues)];
    sun_Bdy = vecTemp;

    vectorName = 'Nadir(Centric)';
    dataSets = ...
        rptDP.Group.Item(vectorName).ExecElements(tObs, tObs+60/86400, ...
        60, rptElems).DataSets;
    vecTemp = [cell2mat(dataSets.GetDataSetByName('Time').GetValues), ...
        cell2mat(dataSets.GetDataSetByName('x/Magnitude').GetValues), ...
        cell2mat(dataSets.GetDataSetByName('y/Magnitude').GetValues), ...
        cell2mat(dataSets.GetDataSetByName('z/Magnitude').GetValues)];
    nadir_Bdy = vecTemp;

    cmd = ['SetAnimation * CurrentTime "', tObsStrUTC,' "'];
    root.ExecuteCommand(cmd);

    % 投影面积，    % norm and area
    areaPrj = [];
    for jj = 1:6
        sun_norm = dot(sun_Bdy(1,2:4),area(jj,1:3));
        nadir_norm =  dot(nadir_Bdy(1,2:4),area(jj,1:3));
        areaPrj(jj) = (sun_norm>0)*(nadir_norm>0)...
            *abs(sun_norm*nadir_norm*area(jj,4));
    end
       areaPrj = areaPrj/((rEarth(1)/384400)^2);

     if areaPrj(6)>areaPrj(2)
        1;
    else
        2;
     end


    % [时刻，RA/度， DEC/度， RA误差/角秒， DEC误差/角秒， ... ，四元数 q1-q4]
    resObs(iiObs, :) = ...
        [resTemp(1,1), ra, dec, mag, ...
        (ra-resTemp(1,3))*3600, (dec-resTemp(1,4))*3600,...
        thetaSun(1), thetaMoon(1), thetaEarth(1), rEarth(1), ...
        sun_Bdy(1,2:4), nadir_Bdy(1,2:4), areaPrj, para];

   

end


%%
resObs(resObs(:,1) ==0, :) = [];

close all
figure
subplot(2,1,1)
hold on; grid minor
plot(datetime(resObs(:,1)+8/24, 'ConvertFrom','juliandate'), ...
    resObs(:,4),'x')
ylabel('Mag [-]')
subplot(2,1,2)
hold on; grid minor
plot(datetime(resObs(:,1)+8/24, 'ConvertFrom','juliandate'), ...
    resObs(:,5),'x')
plot(datetime(resObs(:,1)+8/24, 'ConvertFrom','juliandate'), ...
    resObs(:,6),'x')
legend('RA', 'DEC')
ylabel('Err [arcsec]')
xlabel('Time [BJT]')
set(gcf, "Position",[100,100,1100,600])


obsTimeBJT = datetime(resObs(:,1) + 8/24, 'ConvertFrom', 'juliandate');
obsMonth = dateshift(obsTimeBJT, 'start', 'month');
[monthList, ~, monthIdx] = unique(obsMonth);
monthMarkers = {'h', 'd', '^', 'v', 'p', 'o', 's'};
monthLabels = cellstr(datestr(monthList, 'yyyy-mm'));
cDataR = resObs(:,10) / 1e4;
cLimR = [min(cDataR), max(cDataR)];
xTicksSun = (floor(min(resObs(:,7)) / 20) * 20) : 20 : (ceil(max(resObs(:,7)) / 20) * 20);

figure
subplot(1,2,1)
hold on; grid minor
hMonth = gobjects(numel(monthList), 1);
for kMonth = 1:numel(monthList)
    idx = monthIdx == kMonth;
    hMonth(kMonth) = scatter(resObs(idx,7), resObs(idx,9), 60, cDataR(idx), ...
        'filled', 'Marker', monthMarkers{mod(kMonth - 1, numel(monthMarkers)) + 1}, ...
        'MarkerEdgeColor', 'k', 'LineWidth', 0.8);
end
colormap("parula")
caxis(cLimR)
xticks(xTicksSun)
xlim([xTicksSun(1), xTicksSun(end)])
xlabel('日距角 [deg]', 'Interpreter', 'latex','FontName', 'Times New Roman');
ylabel('地心纬度 [deg]', 'Interpreter', 'latex','FontName', 'Times New Roman');
c = colorbar;
c.Label.String = '地心距 [10^4 km]';
legend(hMonth, monthLabels, 'Location', 'best')

subplot(1,2,2)
hold on; grid minor
for kMonth = 1:numel(monthList)
    idx = monthIdx == kMonth;
    scatter(resObs(idx,7), resObs(idx,8), 60, cDataR(idx), ...
        'filled', 'Marker', monthMarkers{mod(kMonth - 1, numel(monthMarkers)) + 1}, ...
        'MarkerEdgeColor', 'k', 'LineWidth', 0.8);
end
colormap("parula")
caxis(cLimR)
xticks(xTicksSun)
xlim([xTicksSun(1), xTicksSun(end)])
xlabel('日距角 [deg]', 'Interpreter', 'latex','FontName', 'Times New Roman');
ylabel('月球角距 [deg]', 'Interpreter', 'latex','FontName', 'Times New Roman');
c = colorbar;
c.Label.String = '地心距 [10^4 km]';
legend(hMonth, monthLabels, 'Location', 'best')

set(gcf, "Position",[100,100,1400,400])

figure % sun vs moon
hold on; grid minor
scatter(resObs(:,7),resObs(:,8), ...
    30, resObs(:,1)-resObs(1,1),'filled')

xlabel('$\varepsilon_{\mathrm{sun}}$ [deg]', 'Interpreter', 'latex')
ylabel('$\Delta\theta_{\mathrm{moon}}$ [deg]', 'Interpreter', 'latex')
colormap("jet")
c = colorbar;
c.Label.String = 'dt [day]';

figure % sun vs mag
hold on; grid minor
scatter(resObs(:,7),resObs(:,4), ...
    30, resObs(:,10)/1e4,'filled')

xlabel('$\varepsilon_{\mathrm{sun}}$ [deg]', 'Interpreter', 'latex')
ylabel('mag [-]')
colormap("jet")
c = colorbar;
c.Label.String = 'R [1e4 km]';

% proj vs mag
figure
hold on; grid minor
yyaxis left
plot(datetime(resObs(:,1)+8/24, 'ConvertFrom','juliandate'), ...
    resObs(:,4),'x')
ylabel('Mag [-]')
ylim([15, 17.5])
yyaxis right
plot(datetime(resObs(:,1)+8/24, 'ConvertFrom','juliandate'), ...
    resObs(:,18),'d')
plot(datetime(resObs(:,1)+8/24, 'ConvertFrom','juliandate'), ...
    resObs(:,22),'s')
ylim([0.1, 1])
ylabel('Area [m^2]')

xlabel('Time [BJT]')
set(gcf, "Position",[100,100,1100,600])

figure % proj vs mag
hold on; grid minor
plot(resObs(:,18),resObs(:,4),'o' )
plot(resObs(:,22),resObs(:,4),'s' )
plot(sum(resObs(:,17:22),2),resObs(:,4),'x' )
xlim([0.1, 1.3])
ylim([15, 18])
xlabel('Rel Area [-]')
ylabel('Mag [-]')

legend('-X', '-Z', 'All',Location='best')

set(gcf, "Position",[100,100,1100,600])

%% ================= 姿态变化与星等波动 =================
tBJT = datetime(resObs(:,1) + 8/24, 'ConvertFrom', 'juliandate');
mag = resObs(:,4);
areaAll = sum(resObs(:,17:22), 2);
rEarth = resObs(:,10);
R_km = rEarth / 1e4;

% 太阳相角：卫星处太阳方向与地心方向的夹角
sunVec = resObs(:, 11:13);
nadirVec = resObs(:, 14:16);
phaseAngle = abs(acosd(sum(sunVec .* nadirVec, 2) ./ ...
    (vecnorm(sunVec, 2, 2) .* vecnorm(nadirVec, 2, 2))));

% 投影面积由姿态 + 太阳/地面几何决定，是姿态效应的代理量
mag = mag(:);
areaAll = areaAll(:);
R_km = R_km(:);
valid = ~isnan(mag) & ~isnan(areaAll) & ~isnan(R_km);
C = corrcoef(mag(valid), areaAll(valid));
rMagArea = C(1, 2);
C = corrcoef(mag(valid), R_km(valid));
rMagDist = C(1, 2);
fprintf('\n--- 姿态–星等相关性 ---\n');
fprintf('星等 vs 总投影面积: r = %.3f  (负相关 → 面积大则更亮)\n', rMagArea);
fprintf('星等 vs 地心距:       r = %.3f\n', rMagDist);



% --- 图2：星等 vs 面积/相角/地心距（颜色表示观测时间） ---
obsMonthBJT = dateshift(tBJT, 'start', 'month');
plotMonthList = unique(obsMonthBJT);

yData = {areaAll, phaseAngle, R_km};
yLabels = {'反光面积 [m^2]', '太阳相角 [deg]', '地心距 [10^4 km]'};
yLimManual = {[], [20, 140], []};
tColor = datenum(tBJT);
cLimT = [min(tColor), max(tColor)];
timeCmap = parula(256);

figure('Color', 'w', 'Position', [100, 100, 1800, 450]);
tl = tiledlayout(1, 3, 'Padding', 'compact', 'TileSpacing', 'compact');

for k = 1:3
    nexttile
    hold on
    scatter(mag, yData{k}, 40, tColor, 'filled', ...
        'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
    colormap(gca, timeCmap);
    caxis(cLimT);
    cb = colorbar;
    cb.Label.String = '北京时间 [BJT]';
    cb.Label.FontName = 'TimesSimSun';
    cb.Label.FontSize = 14;
    cb.FontName = 'Times New Roman';
    cb.FontSize = 13;
    nCbTick = min(6, numel(plotMonthList));
    cbTicks = linspace(cLimT(1), cLimT(2), nCbTick);
    cb.Ticks = cbTicks;
    cb.TickLabels = cellstr(datestr(cbTicks, 'yyyy-mm'));
    xlabel('观测星等 [-]');
    ylabel(yLabels{k});
    xlim([15, 17.5]);
    xticks(15:0.5:17.5);
    if isempty(yLimManual{k})
        yPad = 0.05 * range(yData{k});
        ylim([min(yData{k}) - yPad, max(yData{k}) + yPad]);
    else
        ylim(yLimManual{k});
    end
    grid on
    grid minor
    ax = gca;
    ax.FontName = 'Times New Roman';
    ax.Color = [1 1 1];
    hold off
end

%% ================= 四元数与本体系欧拉角 =================
tBJTAtt = datetime(resObs(:,1) + 8/24, 'ConvertFrom', 'juliandate');
quatObs = resObs(:, 23:26);
eulObs = quatStk2EulZYX_deg(quatObs);

% 姿态表更新时刻（参考竖线）
attValid = attDROA(~isnan(attDROA(:,1)) & attDROA(:,1) > 0, :);
attTimeBJT = datetime(attValid(:,1) + 8/24, 'ConvertFrom', 'juliandate');

figure('Color', 'w', 'Position', [100, 100, 1200, 520]);
tlAtt = tiledlayout(2, 1, 'Padding', 'compact', 'TileSpacing', 'compact');

nexttile
hold on; grid on; grid minor
plot(tBJTAtt, quatObs(:,1), 'o', 'MarkerSize', 5, 'DisplayName', 'q_1');
plot(tBJTAtt, quatObs(:,2), 's', 'MarkerSize', 5, 'DisplayName', 'q_2');
plot(tBJTAtt, quatObs(:,3), 'd', 'MarkerSize', 5, 'DisplayName', 'q_3');
plot(tBJTAtt, quatObs(:,4), '^', 'MarkerSize', 5, 'DisplayName', 'q_4');
for kAtt = 1:numel(attTimeBJT)
    xline(attTimeBJT(kAtt), '--', 'Color', [0.5 0.5 0.5], ...
        'HandleVisibility', 'off');
end
ylabel('四元数分量 [-]');
% title('观测时刻姿态四元数（STK: q_4 + q_1 i + q_2 j + q_3 k）');
legend('Location', 'best', 'Box', 'off');
ax = gca;
ax.FontName = 'Times New Roman';

nexttile
hold on; grid on; grid minor
plot(tBJTAtt, eulObs(:,1), 'o', 'MarkerSize', 5, 'DisplayName', '\psi (Z)');
plot(tBJTAtt, eulObs(:,2), 's', 'MarkerSize', 5, 'DisplayName', '\theta (Y)');
plot(tBJTAtt, eulObs(:,3), 'd', 'MarkerSize', 5, 'DisplayName', '\phi (X)');
for kAtt = 1:numel(attTimeBJT)
    xline(attTimeBJT(kAtt), '--', 'Color', [0.5 0.5 0.5], ...
        'HandleVisibility', 'off');
end
ylabel('欧拉角 [deg]');
% title('本体系欧拉角（ZYX，相对惯性系）');
legend('Location', 'best', 'Box', 'off', 'Interpreter', 'tex');
ax = gca;
ax.FontName = 'Times New Roman';

xlabel(tlAtt, '北京时间 [BJT]');

function eulDeg = quatStk2EulZYX_deg(qObs)
%QUATSTK2EULZYX_DEG STK 四元数 [q1 q2 q3 q4] 转 ZYX 欧拉角（度）
    n = size(qObs, 1);
    eulDeg = zeros(n, 3);
    for i = 1:n
        x = qObs(i, 1);
        y = qObs(i, 2);
        z = qObs(i, 3);
        w = qObs(i, 4);
        t2 = max(-1, min(1, -2 * (x * z - w * y)));
        pitch = asin(t2);
        roll = atan2(2 * (y * z + w * x), w^2 - x^2 - y^2 + z^2);
        yaw = atan2(2 * (x * y + w * z), w^2 + x^2 - y^2 - z^2);
        eulDeg(i, :) = rad2deg([yaw, pitch, roll]);
    end
end

