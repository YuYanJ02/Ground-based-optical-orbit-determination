clear; clc; close all
dbstop if error
format longg; format compact
set(0,'defaultAxesFontName', 'TimesSimSun','defaultTextFontName', 'TimesSimSun');
set(0,'defaultAxesFontSize',15,'defaultTextFontSize',15)
set(0,'defaultLineLineWidth',2)

%% =============== 光学观测分析 ================
% 场景 E:\DRO\in_orbit\in_Orbit_Scn\droGroundOptical

% 观测数据
obsFileName =  'D:\keyan\projects\Ground-based_Optical-Observation_OD\[20260315]code\[20260809]zh\DROAB_2024_stellar_aberration.csv';

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
                'D:\keyan\projects\Ground-based_Optical-Observation_OD\[20260315]code\[20260809]zh\toYYJ_groundOptical\DROA_0912A.mdl';
            area = areaA;
        case 'DROB'
            xxChkCurr = xxChk(xxChk(:, 2) == 0,:);
            attCurr = attDROB;
            dro.VO.Model.ModelData.Filename  = ...
                'D:\keyan\projects\Ground-based_Optical-Observation_OD\[20260315]code\[20260809]zh\toYYJ_groundOptical\DROB_0912B.mdl';
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
    thetaSun = atan2d(vecTemp(:,3), vecTemp(:,2));
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
    thetaMoon = atan2d(vecTemp(:,3), vecTemp(:,2));

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
    resTemp(:,3) = resTemp(:,3) + (resTemp(:,3) < 0) * 360;

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


    % [时刻，RA/度， DEC/度， RA误差/角秒， DEC误差/角秒]
    % dRA = mod(ra - resTemp(1, 3) + 180, 360) - 180;
    dRA = ra - resTemp(1, 3);
    dDec = dec - resTemp(1, 4);
    resObs(iiObs, :) = ...
        [resTemp(1,1), ra, dec, mag, ...
        dRA * 3600, dDec * 3600,...
        thetaSun(1), thetaMoon(1), thetaEarth(1), rEarth(1), ...
        sun_Bdy(1,2:4), nadir_Bdy(1,2:4),areaPrj];

   

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


tBJT = datetime(resObs(:,1) + 8/24, 'ConvertFrom', 'juliandate');
obsMonth = month(tBJT);
uniqMonth = unique(obsMonth);
% markerList = {'o', 's', 'd', '^', 'v', '>', '<', 'p', 'x'};
markerList = {'o', 's', 'd', 'p', '^', 'h', 'v', '>', '<', };
R_km = resObs(:,10) / 1e4;
climR = [min(R_km), max(R_km)];
thetaSun = abs(resObs(:,7));

figure
subplot(1, 2, 1)
hold on; grid minor
hMonth = gobjects(length(uniqMonth), 1);
for ii = 1:length(uniqMonth)
    idx = obsMonth == uniqMonth(ii);
    hMonth(ii) = scatter(thetaSun(idx), resObs(idx, 8), 36, R_km(idx), ...
        markerList{mod(ii - 1, length(markerList)) + 1}, 'filled', ...
        'MarkerEdgeColor', 'k', 'LineWidth', 0.3, ...
        'DisplayName', sprintf('%d月', uniqMonth(ii)));
end
xlabel('\theta_{sun} [deg]')
ylabel('\theta_{moon} [deg]')
colormap(parula)
caxis(climR)
c = colorbar;
c.Label.String = '地心距 [10^4 km]';
legend(hMonth, 'Location', 'best', 'Box', 'off')

subplot(1, 2, 2)
hold on; grid minor
for ii = 1:length(uniqMonth)
    idx = obsMonth == uniqMonth(ii);
    scatter(thetaSun(idx), resObs(idx, 9), 56, R_km(idx), ...
        markerList{mod(ii - 1, length(markerList)) + 1}, 'filled', ...
        'MarkerEdgeColor', 'k', 'LineWidth', 0.3);
end
xlabel('\theta_{sun} [deg]')
ylabel('\theta_{earth} [deg]')
colormap(parula)
caxis(climR)
c = colorbar;
c.Label.String = '地心距 [10^4 km]';

set(gcf, "Position", [100, 100, 1200, 400])

figure % sun vs moon
hold on; grid minor
scatter(resObs(:,7),resObs(:,8), ...
    50, resObs(:,1)-resObs(1,1),'filled')

xlabel('\theta_{sun} [deg]')
ylabel('\theta_{moon} [deg]')
colormap("jet")
c = colorbar;
c.Label.String = 'dt [day]';

figure % sun vs mag
hold on; grid minor
scatter(resObs(:,7),resObs(:,4), ...
    30, resObs(:,10)/1e4,'filled')

xlabel('\theta_{sun} [deg]')
ylabel('mag [-]')
colormap("jet")
c = colorbar;
c.Label.String = 'R [1e4 km]';

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



% --- 图2：星等随时间变化（1×3，色标分别为面积/相角/地心距） ---
tStart = dateshift(min(tBJT), 'start', 'month');
tEnd = dateshift(max(tBJT), 'start', 'month');
monthTicks = tStart:calmonths(1):tEnd;
xLimMonth = [dateshift(min(tBJT), 'start', 'month'), ...
    dateshift(max(tBJT), 'end', 'month')];
monthLabels = arrayfun(@(t) sprintf('%d月', month(t)), monthTicks, ...
    'UniformOutput', false);

figure('Color', 'w', 'Position', [100, 100, 1800, 450]);
tl = tiledlayout(1, 3, 'Padding', 'compact', 'TileSpacing', 'compact');

colorData = {areaAll, phaseAngle, R_km};
cbLabels = {'反光面积 [m^2]', '太阳相角 [deg]', '地心距 [10^4 km]'};
cmaps = {@cmapPlasma, @hot, @cmapViridis};

for k = 1:3
    nexttile
    scatter(tBJT, mag, 36, colorData{k}, 'filled', ...
        'MarkerEdgeColor', 'k', 'LineWidth', 0.3);
    colormap(gca, cmaps{k}());
    caxis([min(colorData{k}), max(colorData{k})]);
    cb = colorbar;
    cb.Label.String = cbLabels{k};
    if k == 1
        ylabel('观测星等 [-]');
    end
    ylim([15, 17.5]);
    yticks(15:0.5:17.5);
    xlim(xLimMonth);
    grid on
    grid minor
    ax = gca;
    ax.XAxis.TickValues = monthTicks;
    ax.XAxis.TickLabels = monthLabels;
    ax.XAxis.TickLabelRotation = 0;
end
xlabel(tl, '北京时间 (2024-2025) [BJT]');
