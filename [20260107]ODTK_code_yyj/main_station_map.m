% 地基光学测站分布图（太平洋居中，卫星底图 + 夜半球遮罩）
clear; clc;

%% 测站列表（与论文/观测弧段一致；可按需增删）
stationCodes = {'K19', 'N56', 'O17', 'O46', 'P13', 'D29', 'U74', 'I52', '703'};

% 标签颜色（containers.Map 支持 703 等数字开头代码）
labelColor = containers.Map( ...
    {'K19', 'N56', 'O17', 'O46', 'P13', 'D29', 'U74', 'I52', '703'}, { ...
    [1.00 0.00 1.00], ...
    [1.00 0.10 0.10], ...
    [1.00 0.00 1.00], ...
    [1.00 0.00 1.00], ...
    [0.10 0.35 1.00], ...
    [1.00 0.90 0.10], ...
    [1.00 0.10 0.10], ...
    [1.00 0.00 1.00], ...
    [0.10 0.35 1.00]});

% 标签偏移 [dLat, dLon]（度），避免重叠
labelOffset = containers.Map( ...
    {'K19', 'N56', 'O17', 'O46', 'P13', 'D29', 'U74', 'I52', '703'}, { ...
    [1.5,  2.0], ...
    [1.5, -4.0], ...
    [1.5,  2.5], ...
    [-2.5, 2.0], ...
    [1.5,  2.0], ...
    [1.5,  2.0], ...
    [1.5, -3.5], ...
    [3.2, -5.5], ...   % I52：左上，与 703 错开
    [-2.8,  4.5]});    % 703：右下
% 标签水平对齐（I52/703 近邻时用不同对齐进一步错开）
labelAlign = containers.Map( ...
    {'K19', 'N56', 'O17', 'O46', 'P13', 'D29', 'U74', 'I52', '703'}, { ...
    'left', 'left', 'left', 'left', 'left', 'left', 'left', 'left', 'right'});
nightTime = datetime(2025, 10, 26, 14, 0, 0, 'TimeZone', 'UTC');

%% 读取测站经纬度
nSta = numel(stationCodes);
staLat = zeros(nSta, 1);
staLon = zeros(nSta, 1);
for k = 1:nSta
    code = stationCodes{k};
    [lon, lat] = GetStationCoordinates(code);
    if isnan(lon) || isnan(lat)
        error('未找到测站 %s 坐标，请检查 MPC_Codes.txt', code);
    end
    staLat(k) = lat;
    staLon(k) = lon;
end

%% 绘图
figure('Name', '观测测站分布', 'Color', 'w', 'Position', [80, 80, 1100, 560]);
if ~hasMappingToolbox()
    plotStationMapFallback(staLat, staLon, stationCodes, labelColor, labelOffset, nightTime);
    return
end

gx = geoaxes('Parent', gcf);
gx.MapCenter = [15, 160];               % 太平洋居中
geolimits(gx, [-58, 68], [80, -100]);  % 80E ~ 100W，跨日界线

try
    geobasemap(gx, 'satellite');
catch
    geobasemap(gx, 'landcover');
    warning('satellite 底图不可用，已改用 landcover。');
end
hold(gx, 'on');

% 夜半球（半透明浅蓝）
plotNightHemisphere(gx, nightTime);

% 测站标记：黄色圆点 + 十字
geoscatter(gx, staLat, staLon, 72, [1.0 0.82 0.05], 'filled', ...
    'MarkerEdgeColor', [0.15 0.15 0.15], 'LineWidth', 0.9);
geoscatter(gx, staLat, staLon, 36, [0.15 0.15 0.15], '+', 'LineWidth', 1.1);

% 测站代码
for k = 1:nSta
    code = stationCodes{k};
    off = getMapValue(labelOffset, code, [1.5, 2.0]);
    txtCol = getMapValue(labelColor, code, [0.2 0.2 0.2]);
    dLat = off(1);
    dLon = off(2);
    hAlign = getMapValue(labelAlign, code, 'left');
    text(gx, staLat(k) + dLat, staLon(k) + dLon, code, ...
        'Color', txtCol, ...
        'FontName', 'Times New Roman', ...
        'FontSize', 13, ...
        'FontWeight', 'bold', ...
        'HorizontalAlignment', hAlign, ...
        'VerticalAlignment', 'middle');
end

grid(gx, 'on');
gx.GridLineStyle = '--';
gx.GridColor = [1 1 1];
gx.GridAlpha = 0.55;
gx.FontName = 'Times New Roman';
gx.FontSize = 12;
% title(gx, sprintf('地基光学观测测站分布（夜半球: %s UTC）', ...
%     char(nightTime, 'yyyy-MM-dd HH:mm')), ...
%     'FontName', 'Times New Roman', 'FontSize', 14);
hold(gx, 'off');

fprintf('已绘制 %d 个测站。\n', nSta);

%% 局部函数
function val = getMapValue(mapObj, key, defaultVal)
    key = char(string(key));
    if isKey(mapObj, key)
        val = mapObj(key);
    else
        val = defaultVal;
    end
end

function tf = hasMappingToolbox()
    tf = license('test', 'map_toolbox') && ~isempty(ver('map'));
end

function plotNightHemisphere(gx, t)
    [dec, sunLon] = subsolarPoint(t);
    lons = (-180:1:180)';
    if abs(dec) < 1e-4
        latTerm = zeros(size(lons));
    else
        latTerm = atan(-cosd(lons - sunLon) ./ tand(dec)) * 180 / pi;
    end

    if dec >= 0
        poleLat = -90;   % 太阳在北半球，夜半球含南极
    else
        poleLat = 90;
    end

    latPoly = [latTerm; poleLat; poleLat];
    lonPoly = [lons; lons(end); lons(1)];
    faceColor = [0.45 0.72 0.95];
    faceAlpha = 0.30;

    if exist('geopolyshape', 'file') == 2
        try
            poly = geopolyshape(latPoly, lonPoly);
            geoplot(gx, poly, ...
                'FaceColor', faceColor, ...
                'FaceAlpha', faceAlpha, ...
                'EdgeColor', 'none');
            return;
        catch
        end
    end

    % 回退：半透明散点近似夜半球
    [latG, lonG] = meshgrid(-88:3:88, -180:4:180);
    cosZen = sind(latG) .* sind(dec) + cosd(latG) .* cosd(dec) .* cosd(lonG - sunLon);
    mask = cosZen < 0;
    geoscatter(gx, latG(mask), lonG(mask), 14, faceColor, 'filled', ...
        'MarkerFaceAlpha', faceAlpha, 'MarkerEdgeColor', 'none');
end

function [dec, sunLon] = subsolarPoint(t)
    jd = juliandate(t);
    T = (jd - 2451545.0) / 36525.0;
    mLon = mod(280.46646 + 36000.76983 * T, 360);
    mAnom = mod(357.52911 + 35999.05029 * T, 360);
    mRad = deg2rad(mAnom);
    sunLonEcl = mLon + (1.914602 - 0.004817 * T) * sin(mRad) + ...
        (0.019993 - 0.000101 * T) * sin(2 * mRad);
    eps = 23.439291 - 0.0130042 * T;
    dec = asind(sind(eps) * sind(sunLonEcl));
    gmst = mod(280.46061837 + 360.98564736629 * (jd - 2451545.0), 360);
    sunLon = gmst - sunLonEcl;
    sunLon = mod(sunLon + 180, 360) - 180;
end

function plotStationMapFallback(staLat, staLon, stationCodes, labelColor, labelOffset, nightTime)
    ax = axes('Parent', gcf);
    load coastlines
    plot(ax, coastlon, coastlat, 'Color', [0.35 0.35 0.35]);
    hold(ax, 'on');
    axis(ax, [-180, 180, -60, 70]);
    set(ax, 'YTick', -60:30:60, 'XTick', -180:30:180);
    grid(ax, 'on');

    scatter(ax, staLon, staLat, 70, [1.0 0.82 0.05], 'filled', ...
        'MarkerEdgeColor', [0.15 0.15 0.15]);
    for k = 1:numel(stationCodes)
        code = stationCodes{k};
        off = getMapValue(labelOffset, code, [1.5, 2.0]);
        text(ax, staLon(k) + off(2), staLat(k) + off(1), code, ...
            'Color', getMapValue(labelColor, code, [0.2 0.2 0.2]), ...
            'FontWeight', 'bold', 'FontSize', 12);
    end
    xlabel(ax, '经度 [deg]');
    ylabel(ax, '纬度 [deg]');
    title(ax, sprintf('观测测站分布（无 Mapping Toolbox，UTC %s）', ...
        char(nightTime, 'yyyy-MM-dd HH:mm')));
    hold(ax, 'off');
    warning('未检测到 Mapping Toolbox，已使用简易海岸线底图。');
end
