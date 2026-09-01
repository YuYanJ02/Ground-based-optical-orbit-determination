clear; clc; close all
dbstop if error
format longg; format compact
set(0,'defaultAxesFontName', 'TimesSimSun','defaultTextFontName', 'TimesSimSun');
set(0,'defaultAxesFontSize',15,'defaultTextFontSize',15)
set(0,'defaultLineLineWidth',2)

%% =============== 光学观测分析 ================
% 场景 E:\DRO\in_orbit\in_Orbit_Scn\droGroundOptical
% 观测误差计算

% 观测数据
obsFileName =  'E:\Matlab\in_orbit\optical\obs\DROB_20250625_O17.txt';
% obsFileName =  'E:\Matlab\in_orbit\optical\obs\DROB_20250717_O49.txt';
eDRO = 'DROB_OEM';


obsFileName =  'E:\Matlab\in_orbit\optical\obs\CE6_OBS_2025NovDec - 1.txt';
% obsFileName =  'E:\Matlab\in_orbit\optical\obs\DROB_20250717_O49.txt';
eDRO = 'CE6_Obs_251130';
eDRO = 'CE6_Bill'; %不准确
eDRO = 'CE6_Obs';
% eDRO = 'CE6';

decTime = 6;


load('MPC_Codes.mat');

%% ================= 载入观测数据 ==================
opts = delimitedTextImportOptions("NumVariables", 13);

% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = " ";

% Specify column names and types
opts.VariableNames = ["ID", "Year", "Month", "Day", "RAH", "RAM", "RAS", "DECH", "DECM", "DECS", "Mag", "V", "O"];
opts.VariableTypes = ["string", "string", "string", "string", "double", "double", "double", "double", "double", "double", "double", "string", "string"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts.ConsecutiveDelimitersRule = "join";
opts.LeadingDelimitersRule = "ignore";

% Specify variable properties
opts = setvaropts(opts, ["ID", "Year", "V", "O"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["ID", "Year", "V", "O"], "EmptyFieldRule", "auto");

% Import the data
data_80c = readtable(obsFileName, opts);

clear opts

eNewFac = 0;
%%  ================= 载入  =================
uiApplication = actxGetRunningServer('STK12.application');
uiApplication.Visible = 1;
root = uiApplication.Personality2;
root.UnitPreferences.Item('DateFormat').SetCurrentUnit('JDate');
currScn = root.CurrentScenario;


dro = currScn.Children.Item(eDRO);

for iiObs = 1:size(data_80c,1)

    temp = table2cell(data_80c(iiObs, :));

    facName = temp{13};
    tObs = char(strcat(temp{2},temp{3},temp{4}));

    % YYYYMMDD.DDD to jd
    len_tObs = length(tObs);
    tObsNum1 = str2double(tObs(2:9));
    tObsNum2 = str2double(tObs(10:len_tObs));
    tObs = juliandate(datetime(tObsNum1,'ConvertFrom','yyyymmdd'))+tObsNum2;




    raO = [temp{5}, temp{6},temp{7}];
    raO = sum(raO.*[1/24 1/1440 1/86400]*360);

    decSgn = [temp{8}, temp{9},temp{10}];
    
    decO = sum(abs(decSgn).* [1 1/60 1/3600]);
    decO = sign(decSgn(1))*decO;

    mag = temp{11};

    try fac = currScn.Children.Item(facName);  
    catch
        for iiFac = 2:size(MPCCodes,1)
            nameTemp = char(MPCCodes{iiFac, 2});
            lon = MPCCodes{iiFac, 3};
            lat = MPCCodes{iiFac, 4};
            alt =  MPCCodes{iiFac, 5}; 
            if strcmp(facName, nameTemp)
                fac = currScn.Children.NewOnCentralBody('ePlace', facName, 'Earth');
                fac.UseTerrain = 0;
                fac.Position.AssignGeodetic(lat, lon, alt/1000);
                eNewFac = 1;
            end
        end
    end
   
   
    % 计算access
    access = fac.GetAccessToObject(dro);
    access.Advanced.AberrationType = 'eAberrationNone';
%     access.Advanced.AberrationType = 'eAberrationTotal';
%     access.Advanced.AberrationType = 'eAberrationAnnual';
%     
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
    resTemp(:,3)=(resTemp(:,3)<0)*360+resTemp(:,3);   


    % [时刻，RA/度， DEC/度， RA误差/角秒， DEC误差/角秒]
    raDecP = resTemp(1,3:4);
    resObs(iiObs, :) = ...
        [resTemp(1,1), raO, decO, mag, ...
        (raO-resTemp(1,3))*3600, (decO-resTemp(1,4))*3600];
    if  abs((raO-resTemp(1,3))*3600)>100
        1;
    end

    access.RemoveAccess;

%     if eNewFac
%         fac.Unload()
%     end
end


%%
close all
figure
hold on; grid minor
plot(datetime(resObs(:,1)+8/24, 'ConvertFrom','juliandate'), ...
    resObs(:,5),'x')
plot(datetime(resObs(:,1)+8/24, 'ConvertFrom','juliandate'), ...
    resObs(:,6),'x')

ylabel('Err [arcsec]')
xlabel('Time [BJT]')
legend('RA', 'DEC')
set(gcf, "Position",[100,100,1100,600])

figure
hold on; grid minor
plot(resObs(:,5), resObs(:,6),'x')
plot(1*cosd(0:1:360), 1*sind(0:1:360),'-')
plot(2*cosd(0:1:360), 2*sind(0:1:360),'-')
plot(3*cosd(0:1:360), 3*sind(0:1:360),'-')
plot(4*cosd(0:1:360), 4*sind(0:1:360),'-')
plot(0,0,'o')
xlabel('err_{RA} [arcsec] O-P')
ylabel('err_{Dec} [arcsec] O-P')
axis equal
% xlim([-1,1]*5)
% ylim([-1,1]*5)


