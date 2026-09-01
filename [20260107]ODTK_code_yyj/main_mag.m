clear; clc;

% 模型参数（对应 Calculate_Mag.m 中一组 Arhou / adiff / aspec）
para = 0.8;    % 漫反射系数 adiff
arhou = 0.4;   % 有效反射面积 Arhou [m^2]
aspec = 0.2;   % 镜面反射系数

load('data_250625.mat');
load('data_251026.mat');
load('data_250524.mat');

datasets = {plotData_250524, plotData_250625, plotData_251026};
markers = {'x', 'o', 's'};
filled = [false, true, true];
labels = {'2025.05.24', '2025.06.25', '2025.10.26'};

% 汇总实测数据范围
allSun = [];
allDist = [];
allObsMag = [];
for k = 1:numel(datasets)
    d = datasets{k};
    allSun = [allSun; d.sunphase(:)]; %#ok<AGROW>
    allDist = [allDist; d.distance(:)]; %#ok<AGROW>
    allObsMag = [allObsMag; d.magnitude(:)]; %#ok<AGROW>
end

% 在太阳相位-距离平面上用模型星等铺满背景（轴范围略大于实测数据）
nGrid = 250;
padFrac = 0.08;
xMin = min(allSun);
xMax = max(allSun);
yMin = min(allDist);
yMax = max(allDist);
dx = max(xMax - xMin, eps);
dy = max(yMax - yMin, eps);
xLim = [xMin - padFrac * dx, xMax + padFrac * dx];
yLim = [yMin - padFrac * dy, yMax + padFrac * dy];
sunVec = linspace(xLim(1), xLim(2), nGrid);
distVec = linspace(yLim(1), yLim(2), nGrid);
[SUN, DIST] = meshgrid(sunVec, distVec);
MAG_MODEL = modelMagnitude(SUN, DIST, arhou, para, aspec);

% 各实测点对应的模型星等
for k = 1:numel(datasets)
    d = datasets{k};
    datasets{k}.magnitude_model = modelMagnitude(d.sunphase, d.distance, arhou, para, aspec);
    datasets{k}.magnitude_residual = d.magnitude - datasets{k}.magnitude_model;
end
plotData_250524 = datasets{1};
plotData_250625 = datasets{2};
plotData_251026 = datasets{3};

figure('Position', [100, 100, 800, 500]);
pcolor(SUN, DIST, MAG_MODEL);
shading interp;
hold on;
grid on;

% 叠加实测星等散点
hScat = gobjects(numel(datasets), 1);
for k = 1:numel(datasets)
    d = datasets{k};
    if filled(k)
        hScat(k) = scatter(d.sunphase, d.distance, 60, d.magnitude, 'filled', ...
            'Marker', markers{k});
    else
        hScat(k) = scatter(d.sunphase, d.distance, 60, d.magnitude, ...
            'LineWidth', 2.5, 'Marker', markers{k});
    end
end

xlabel('相位角 [deg]', 'Interpreter', 'latex', ...
    'FontName', 'Times New Roman', 'FontSize', 15);
ylabel('距离 [km]', 'Interpreter', 'latex', ...
    'FontName', 'Times New Roman', 'FontSize', 15);

colormap(viridisMap());
magLim = [min([allObsMag; MAG_MODEL(:)], [], 'omitnan'), ...
          max([allObsMag; MAG_MODEL(:)], [], 'omitnan')];
if all(isfinite(magLim)) && magLim(2) > magLim(1)
    caxis(magLim);
end
c = colorbar;
c.Label.String = '星等 [-]';
c.Label.Interpreter = 'latex';
c.Label.FontName = 'Times New Roman';
c.Label.FontSize = 15;

legend(hScat, labels, 'Location', 'best');
% title(sprintf('背景：模型星等 (Arhou=%.1f, a_{diff}=%.1f, a_{spec}=%.1f)；散点：实测', ...
%     arhou, para, aspec), 'FontName', 'Times New Roman', 'FontSize', 13);
hold off;






% 残差与星等、相位关系
% 月相、月球角距与星等关系
figure('Position', [100, 100, 800, 500]);

scatter(plotData_250524.sunphase, plotData_250524.distance, ...
    60, plotData_250524.rms, 'LineWidth', 2.5, ...
    'Marker', 'x', 'DisplayName', '2025.05.24');
hold on;
grid on;

% 第一组数据：圆形标记，颜色来自 magnitude
scatter(plotData_250625.sunphase, plotData_250625.distance, ...
    60, plotData_250625.rms, 'filled', ...
    'Marker', 'o', 'DisplayName', '2025.06.25');
hold on;
grid on;

% 第二组数据：方形标记，颜色来自 magnitude
scatter(plotData_251026.sunphase, plotData_251026.distance, ...
    60, plotData_251026.rms, 'filled', ...
    'Marker', 's', 'DisplayName', '2025.10.26');

% 坐标轴标签
xlabel('相位角 [deg]', 'Interpreter', 'latex','FontName', 'Times New Roman', 'FontSize', 15);
ylabel('距离 [km]', 'Interpreter', 'latex', ...
    'FontName', 'Times New Roman', 'FontSize', 15);

% 颜色条（共用一个，表示星等）
colormap(viridisMap());
c = colorbar;

c.Label.String = '星等 [-]';
c.Label.Interpreter = "latex";
c.Label.FontName = 'Times New Roman';
c.Label.FontSize = 15;

% 添加图例（自动使用 DisplayName 的内容）
legend('Location', 'best');

 









% %% 运行filter并生成报告
% 
% 
%     % 运行Filter
%     LS_Ground.transfer();
%     Filter_Ground.go();
% 
%     % ================================
%     % 清空Products
%     odtk.ProductBuilder.DataProducts.clear();
% 
%     %% -------------------------- 图1 --------------------------
%     % 产品名称
%     product_name = 'Classical Elements';
% 
%     % 新建
%     newElem = odtk.ProductBuilder.DataProducts.NewElem();
%     odtk.ProductBuilder.DataProducts.push_back(newElem);
%     product = odtk.ProductBuilder.DataProducts{odtk.ProductBuilder.DataProducts.count - 1};
% 
%     % 修改名字
%     product.Name.Assign(product_name);
% 
%     % 输入
%     newSrc = product.Inputs.DataSources.NewElem();
%     product.Inputs.DataSources.push_back(newSrc);
%     product.Inputs.DataSources{0}.Filename = ['D:\keyan\projects\OD\[20260107]ODTK_code_yyj\ODTK\' , prop_name , '.filrun'];
%     %     product.Inputs.DataSources{0}.Filename = ['C:\Users\Administrator\Documents\ODTK 7\DataArchive\' , prop_name , '.filrun'];
% 
%     % 输出
%     product.Outputs.Style = 'C:\Program Files\AGI\ODTK 7\ODTK\AppData\Styles\Static\Classical Elements.pyrpt';
%     product.Outputs.Display = 1;
%     product.Outputs.Export.Enabled = 0;
% 
%     % 运行Static Product Builder
%     odtk.ProductBuilder.GenerateProduct(product_name);






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

function M = modelMagnitude(sunphase_deg, distance_km, arhou, adiff, aspec)
%MODELMAGNITUDE 由太阳相位角与距离计算模型视星等（同 Calculate_Mag.m 亮度公式）
    alpha = deg2rad(sunphase_deg);
    pdiff = 2 * (sin(alpha) + (pi - alpha) .* cos(alpha)) / (3 * pi^2);
    fluxTerm = arhou .* (aspec ./ (4 * pi) + adiff .* pdiff) ./ (distance_km.^2 * 1e6);
    M = -26.74 - 2.5 * log10(fluxTerm);
end