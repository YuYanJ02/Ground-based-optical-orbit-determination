%PLOT_OD_ERROR_COMPARE 对比四组定轨结果的位置/速度误差（scatter）
%
% 依赖 main_try.m 导出的 res_*.mat，表变量 res 含：
%   Time_UTC, PositionError_km, VelocityError_mps

clear; clc;

scriptDir = fileparts(mfilename('fullpath'));
datasets = {
    '2025_10_4',   'res_2025_10_4.mat';
    '2025_10_3',   'res_2025_10_3.mat';
    '2025_10_P13', 'res_2025_10_P13.mat';
    '2025_10_I52', 'res_2025_10_I52.mat';
};

nSet = size(datasets, 1);
% 鲜艳红 / 蓝 / 黑 / 绿（四组顺序对应 datasets）
colors = [
    1.00, 0.00, 0.00;   % red      -> 2025_10_4
    0.00, 0.45, 1.00;   % blue     -> 2025_10_3
    0.00, 0.00, 0.00;   % black    -> 2025_10_P13
    0.00, 0.78, 0.00;   % green    -> 2025_10_I52
];
edgeColors = colors;    % 与填充同色，保持鲜艳
markers = {'o', 's', '^', 'd'};
markerSize = 16;
faceAlpha = 1.0;
lineWidth = 0.8;

loaded = cell(nSet, 1);
for i = 1:nSet
    matPath = fullfile(scriptDir, datasets{i, 2});
    if ~isfile(matPath)
        error('未找到文件: %s\n请先运行 main_try 并 save 对应 res 文件。', matPath);
    end
    S = load(matPath, 'res');
    if ~istable(S.res)
        error('文件 %s 中变量 res 应为 table。', matPath);
    end
    requiredVars = {'Time_UTC', 'PositionError_km', 'VelocityError_mps'};
    if ~all(ismember(requiredVars, S.res.Properties.VariableNames))
        error('文件 %s 中 res 缺少列: Time_UTC / PositionError_km / VelocityError_mps', matPath);
    end
    loaded{i} = S.res;
    fprintf('已加载 %s (%d 点)\n', datasets{i, 1}, height(S.res));
end

%% 位置误差
figure('Color', 'w', 'Position', [80, 80, 960, 420]);
hold on;
for i = 1:nSet
    res = loaded{i};
    scatter(res.Time_UTC, res.PositionError_km, markerSize, ...
        'Marker', markers{i}, ...
        'MarkerFaceColor', colors(i, :), ...
        'MarkerEdgeColor', edgeColors(i, :), ...
        'MarkerFaceAlpha', faceAlpha, ...
        'LineWidth', lineWidth);
end
hold off;
xtickformat('MMM dd');
% xtickangle(45);
xlabel('时间 [UTC]', 'FontName', 'Times New Roman', 'FontSize', 14);
ylabel('位置误差 [km]', 'FontName', 'Times New Roman', 'FontSize', 14);
legend('长弧多站（703、I52、U74、P13）','短弧多站（703、I52、U74）','长弧单站（P13）','短弧单站（I52）', ...
    'FontName', 'Times New Roman', 'FontSize', 11, 'Box', 'off');
style_paper_axes(gca);

% 导出论文图（可选）：
% exportgraphics(gcf, 'position_error.pdf', 'ContentType', 'vector', 'Resolution', 600);

%% 速度误差
figure('Color', 'w', 'Position', [100, 100, 960, 420]);
hold on;
for i = 1:nSet
    res = loaded{i};
    scatter(res.Time_UTC, res.VelocityError_mps, markerSize, ...
        'Marker', markers{i}, ...
        'MarkerFaceColor', colors(i, :), ...
        'MarkerEdgeColor', edgeColors(i, :), ...
        'MarkerFaceAlpha', faceAlpha, ...
        'LineWidth', lineWidth);
end
hold off;
xtickformat('MMM dd');
% xtickangle(45);
xlabel('时间 [UTC]', 'FontName', 'Times New Roman', 'FontSize', 14);
ylabel('速度误差 [m/s]', 'FontName', 'Times New Roman', 'FontSize', 14);
legend('长弧多站（703、I52、U74、P13）','短弧多站（703、I52、U74）','长弧单站（P13）','短弧单站（I52）', ...
    'FontName', 'Times New Roman', 'FontSize', 11, 'Box', 'off');
style_paper_axes(gca);

% 导出论文图（可选）：
% exportgraphics(gcf, 'velocity_error.pdf', 'ContentType', 'vector', 'Resolution', 600);

% 图例请自行添加，四组顺序与 colors / markers 一致：
%   1: 2025_10_4 红   2: 2025_10_3 蓝   3: 2025_10_P13 黑   4: 2025_10_I52 绿

function style_paper_axes(ax)
    % 论文常用坐标轴：外刻线 + 主次刻度 + 浅网格
    if nargin < 1 || isempty(ax)
        ax = gca;
    end
    set(ax, ...
        'Box', 'on', ...
        'LineWidth', 1.0, ...
        'TickDir', 'in', ...
        'TickLength', [0.018, 0.030], ...
        'XMinorTick', 'on', ...
        'YMinorTick', 'on', ...
        'Layer', 'top', ...
        'FontName', 'Times New Roman', ...
        'FontSize', 12, ...
        'GridLineStyle', ':', ...
        'GridAlpha', 0.40);
    grid(ax, 'on');
end
