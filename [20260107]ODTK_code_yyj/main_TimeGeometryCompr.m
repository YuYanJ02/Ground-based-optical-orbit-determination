% 时间跨度 × LOS 条件数 — 定轨精度着色（收敛点）+ 未收敛灰色叉号
clear; clc;

%% 加载 TPAll
if ~isfile('TPAll.mat')
    error('未找到 TPAll.mat，请先运行 main_TP.m 生成合并结果。');
end
load('TPAll.mat', 'TPAll');

%% 按 rho_nom_km 重算 LOS 条件数（写入 TPAll.LOSCond，定轨结果等其余列不变）
rho_nom_km = 380000;   % [km]
sta_alt_m = 1000;
mpcFile = 'MPC80_DROB_20251026_27.txt';
tdmFile = 'TDM_DROB_20251026_27.tdm';
[~, ~, ~, t, ra_deg, dec_deg, station_per_obs, ~] = MPC2TDM(mpcFile, tdmFile);
t_obs = datetime(t(:));
ra_deg = ra_deg(:);
dec_deg = dec_deg(:);
nObs = numel(ra_deg);

if max(TPAll.Idx3) > nObs
    error('TPAll 索引超出观测历元数量，请检查数据一致性。');
end

I_geoc = zeros(nObs, 3);
for iiobs = 1:nObs
    code = station_per_obs{iiobs};
    if iscell(code)
        code = code{1};
    end
    code = upper(strtrim(char(string(code))));
    [Lon, Lat] = GetStationCoordinates(code);
    if isnan(Lon) || isnan(Lat)
        I_geoc(iiobs, :) = [cosd(dec_deg(iiobs)) * cosd(ra_deg(iiobs)), ...
                              cosd(dec_deg(iiobs)) * sind(ra_deg(iiobs)), ...
                              sind(dec_deg(iiobs))];
    else
        I_geoc(iiobs, :) = topo_j2000_radec_to_geocentric_unit(ra_deg(iiobs), dec_deg(iiobs), ...
            Lat, Lon, sta_alt_m, t_obs(iiobs), rho_nom_km).';
    end
end

oldKappa = NaN;
if ismember('LOSCond', TPAll.Properties.VariableNames)
    oldKappa = median(TPAll.LOSCond);
elseif ismember('TripleProduct', TPAll.Properties.VariableNames)
    oldKappa = median(TPAll.TripleProduct);
end
TPAll.LOSCond = losCondFromGeoc(I_geoc, TPAll.Idx1, TPAll.Idx2, TPAll.Idx3);
TPAll.rho_nom_km = repmat(rho_nom_km, height(TPAll), 1);
TPAll.TimeSpan_h = hours(t_obs(TPAll.Idx3) - t_obs(TPAll.Idx1));

fprintf('LOS 条件数已按 rho_nom = %.0f km 重算（旧 med=%.4g -> 新 med=%.4g）\n', ...
    rho_nom_km, oldKappa, median(TPAll.LOSCond));
save('TPAll.mat', 'TPAll', 'rho_nom_km');

%% 绘图：横轴时间跨度，纵轴 LOS 条件数；收敛点按误差着色，未收敛点灰色叉号
fontArgs = {'FontName', 'Times New Roman', 'FontSize', 14};
convMask = TPAll.Converged == 1 & TPAll.MeanDis_km > 0;
failMask = ~convMask;

fprintf('TPAll 共 %d 组，收敛 %d 组，未收敛 %d 组。\n', ...
    height(TPAll), sum(convMask), sum(failMask));

% 三个时间跨度簇的汇总统计（供 Fig1 子图与 Fig2 复用）
goodErr_km = 50;
gap_h = 8;   % 相邻时间跨度簇的最小间隔 [h]
bandId = assignTimeBands(TPAll.TimeSpan_h, gap_h);
nBand = max(bandId);
tsMedian = zeros(nBand, 1);
nSample = zeros(nBand, 1);
convRateBand = zeros(nBand, 1);
goodRateBand = zeros(nBand, 1);
for b = 1:nBand
    mBand = bandId == b;
    convBand = TPAll.Converged(mBand) == 1 & TPAll.MeanDis_km(mBand) > 0;
    goodBand = convBand & TPAll.MeanDis_km(mBand) < goodErr_km;
    tsMedian(b) = median(TPAll.TimeSpan_h(mBand));
    nSample(b) = sum(mBand);
    convRateBand(b) = mean(convBand);
    goodRateBand(b) = mean(goodBand);
end

cmapPlasma = plasmaMap();
fig1 = figure('Name', '时间跨度-几何发散度-定轨精度', 'Color', 'w', ...
    'Position', [80, 80, 900, 820]);

% 上：散点图（约占 62% 高度）
ax1 = subplot(2, 1, 1);
hold(ax1, 'on');

% 未收敛：灰色叉号（置于底层）
hFail = scatter(ax1, TPAll.TimeSpan_h(failMask), TPAll.LOSCond(failMask), 28, ...
    [0.55 0.55 0.55], 'x', 'LineWidth', 1.1);

% 收敛：标量 CData + flat，与 colorbar 联动
errConv = TPAll.MeanDis_km(convMask);
hConv = scatter(ax1, TPAll.TimeSpan_h(convMask), TPAll.LOSCond(convMask), 40, ...
    errConv, 'filled', 'MarkerFaceColor', 'flat', 'MarkerFaceAlpha', 0.85);

set(ax1, 'YScale', 'log', fontArgs{:});
xlabel(ax1, 'IOD 三点时间跨度 [h]', fontArgs{:});
ylabel(ax1, '$\kappa(L)$ [-]', 'Interpreter', 'latex', fontArgs{:});
grid(ax1, 'on');

if ~isempty(errConv)
    errMin = min(errConv);
    errMax = max(errConv);
    caxis(ax1, [errMin, errMax]);
end
colormap(ax1, cmapPlasma);
cb = colorbar(ax1, 'Location', 'eastoutside');
cb.Label.String = '定轨位置误差 [km]';
cb.Label.FontName = 'Times New Roman';
cb.Label.FontSize = 14;
applyColorbarMap(cb, ax1, cmapPlasma);

legend(ax1, [hFail, hConv], {'未收敛', '已收敛'}, 'Location', 'northwest');
hold(ax1, 'off');

% 下：三个时间簇柱状图（等间距排列，横轴标签为时间）
ax2 = subplot(2, 1, 2);
xBar = tsMedian(:);
barData = [convRateBand, goodRateBand];
hBar = bar(ax2, 1:nBand, barData, 0.58, 'grouped');
hBar(1).FaceColor = [0.20 0.45 0.75];
hBar(2).FaceColor = [0.85 0.33 0.10];
set(ax2, fontArgs{:});
xLabels = cell(nBand, 1);
for b = 1:nBand
    xLabels{b} = sprintf('%.1f h', xBar(b));
end
set(ax2, 'XTick', 1:nBand, 'XTickLabel', xLabels, 'TickLabelInterpreter', 'none');
ylabel(ax2, '比率 [-]', fontArgs{:});
xlabel(ax2, 'IOD 三点时间跨度 [h]', fontArgs{:});
ylim(ax2, [0 1.05]);
xlim(ax2, [0.45, nBand + 0.55]);
dxText = 0.15;
grid(ax2, 'on');
legend(ax2, {'收敛率', sprintf('准确率 (< %.0f km)', goodErr_km)}, ...
    'Location', 'northeast', 'FontName', 'Times New Roman', 'FontSize', 12);
for b = 1:nBand
    text(ax2, b - dxText, convRateBand(b) + 0.03, sprintf('%.1f%%', 100 * convRateBand(b)), ...
        'HorizontalAlignment', 'center', 'FontName', 'Times New Roman', 'FontSize', 11);
    text(ax2, b + dxText, goodRateBand(b) + 0.03, sprintf('%.1f%%', 100 * goodRateBand(b)), ...
        'HorizontalAlignment', 'center', 'FontName', 'Times New Roman', 'FontSize', 11);
end

% 调整上下子图高度比例（上宽下窄，柱状图区更紧凑）
pos1 = get(ax1, 'Position');
pos2 = get(ax2, 'Position');
pos1(2) = 0.46;
pos1(4) = 0.50;
pos2(2) = 0.11;
pos2(4) = 0.22;
set(ax1, 'Position', pos1);
set(ax2, 'Position', pos2);

%% 各时间跨度带内：LOS 条件数分位 — 收敛率曲线（独立 Fig2）
nGeomBin = 8;
bandSummary = zeros(nBand, 4);   % [ts中位, n总, n收敛, 收敛率]

fprintf('\n===== 各时间跨度带内 LOS 条件数分位收敛率 =====\n');
fig2 = figure('Name', '分带LOS条件数收敛率');
tiledlayout(nBand, 1, 'Padding', 'compact', 'TileSpacing', 'compact');
colorConv = [0.20 0.45 0.75];   % 与 Fig1 柱状图收敛率一致
colorGood = [0.85 0.33 0.10];   % 与 Fig1 柱状图准确率一致

for b = 1:nBand
    mBand = bandId == b;
    tsBand = TPAll.TimeSpan_h(mBand);
    kappaBand = TPAll.LOSCond(mBand);
    convBand = TPAll.Converged(mBand) == 1 & TPAll.MeanDis_km(mBand) > 0;
    goodBand = convBand & TPAll.MeanDis_km(mBand) < goodErr_km;

    bandSummary(b, 1) = median(tsBand);
    bandSummary(b, 2) = sum(mBand);
    bandSummary(b, 3) = sum(convBand);
    bandSummary(b, 4) = bandSummary(b, 3) / bandSummary(b, 2);

    [kappaCenter, convRate, goodRate, nPerBin] = geomBinConvergenceRate( ...
        kappaBand, convBand, goodBand, nGeomBin);

    nexttile;
    yyaxis left
    plot(kappaCenter, convRate, 'o-', 'LineWidth', 2, 'MarkerSize', 7, ...
        'Color', colorConv, 'MarkerFaceColor', colorConv);
    ylabel('收敛率 [-]', fontArgs{:});
    ylim([0 1.05]);
    yyaxis right
    plot(kappaCenter, goodRate, 's--', 'LineWidth', 1.8, 'MarkerSize', 7, ...
        'Color', colorGood);
    ylabel(sprintf('准确率 (< %.0f km)', goodErr_km), fontArgs{:});
    ylim([0 1.05]);
    axTile = gca;
    axTile.YAxis(1).Color = colorConv;
    axTile.YAxis(2).Color = colorGood;
    set(gca, 'XScale', 'log', fontArgs{:});
    xlabel('$\kappa(L)$ [-]', 'Interpreter', 'latex', fontArgs{:});
    grid on;
    title(sprintf('时间跨度：%.1f h（中位）', ...
        bandSummary(b, 1)));
    legend({'收敛率', '准确率'}, 'Location', 'southeast');

    fprintf('\n--- 带 %d：时间跨度中位 %.2f h，样本 %d，总收敛率 %.1f%% ---\n', ...
        b, bandSummary(b, 1), bandSummary(b, 2), 100 * bandSummary(b, 4));
    fprintf('  κ箱   κ中心        n样本  收敛率   准确率\n');
    for k = 1:nGeomBin
        fprintf('  %-4d   %-12.4g  %-6d  %.3f    %.3f\n', ...
            k, kappaCenter(k), nPerBin(k), convRate(k), goodRate(k));
    end
end

% sgtitle('各时间跨度带内：随 LOS 条件数变化收敛率与准确初轨率变化', fontArgs{:});

%% 局部函数
function applyColorbarMap(cb, ax, cmap)
% 兼容不同 MATLAB 版本，强制 colorbar 使用指定 colormap
    colormap(ax, cmap);
    if isprop(ax, 'Colormap')
        ax.Colormap = cmap;
    end
    if isprop(cb, 'Colormap')
        cb.Colormap = cmap;
    end
    drawnow limitrate;
end

function bandId = assignTimeBands(timeSpan_h, gap_h)
    timeSpan_h = timeSpan_h(:);
    u = sort(unique(timeSpan_h));
    grp = ones(size(u));
    g = 1;
    for i = 2:numel(u)
        if u(i) - u(i - 1) > gap_h
            g = g + 1;
        end
        grp(i) = g;
    end
    [~, loc] = ismember(timeSpan_h, u);
    bandId = grp(loc);
end

function [geomCenter, convRate, goodRate, nPerBin] = geomBinConvergenceRate(geom, convMask, goodMask, nBin)
    geom = geom(:);
    convMask = convMask(:);
    goodMask = goodMask(:);
    n = numel(geom);
    nBin = min(nBin, n);

    [~, sortOrd] = sort(geom, 'ascend');
    binId = zeros(n, 1);
    edges = round(linspace(1, n + 1, nBin + 1));
    for b = 1:nBin
        binId(sortOrd(edges(b):(edges(b + 1) - 1))) = b;
    end

    geomCenter = zeros(nBin, 1);
    convRate = zeros(nBin, 1);
    goodRate = zeros(nBin, 1);
    nPerBin = zeros(nBin, 1);
    for b = 1:nBin
        m = binId == b;
        nPerBin(b) = sum(m);
        convRate(b) = mean(convMask(m));
        goodRate(b) = mean(goodMask(m));
        geomCenter(b) = mean(geom(m));
    end
end

function kappa = losCondFromGeoc(I_geoc, idx1, idx2, idx3)
%LOSCONDFROMGEOC 三条地心单位视线组成的 LOS 矩阵 2-范数条件数
    idx1 = idx1(:);
    idx2 = idx2(:);
    idx3 = idx3(:);
    n = numel(idx1);
    kappa = zeros(n, 1);
    for k = 1:n
        L1 = I_geoc(idx1(k), :).';
        L2 = I_geoc(idx2(k), :).';
        L3 = I_geoc(idx3(k), :).';
        L = [L1, L2, L3];
        kappa(k) = cond(L, 2);
    end
end

function kappa = losCondFromRaDec(alpha_rad, delta_rad)
%LOSCONDFROMRADEC 由赤经赤纬（弧度）计算 LOS 条件数
    L1 = [cos(delta_rad(1)) * cos(alpha_rad(1)); ...
          cos(delta_rad(1)) * sin(alpha_rad(1)); ...
          sin(delta_rad(1))];
    L2 = [cos(delta_rad(2)) * cos(alpha_rad(2)); ...
          cos(delta_rad(2)) * sin(alpha_rad(2)); ...
          sin(delta_rad(2))];
    L3 = [cos(delta_rad(3)) * cos(alpha_rad(3)); ...
          cos(delta_rad(3)) * sin(alpha_rad(3)); ...
          sin(delta_rad(3))];
    kappa = cond([L1, L2, L3], 2);
end
