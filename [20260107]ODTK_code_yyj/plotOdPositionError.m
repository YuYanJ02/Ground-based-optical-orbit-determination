function fig = plotOdPositionError(t_stk, dis_km, iodIdx, mean_km, fig)
if nargin < 5 || isempty(fig) || ~isvalid(fig)
    fig = figure('Name', 'OD Position Error', 'NumberTitle', 'off', ...
        'Position', [120, 120, 860, 360]);
else
    figure(fig);
end

if iscell(t_stk)
    tt_no_ns = cellfun(@(x) char(x), t_stk, 'UniformOutput', false);
    tt_no_ns = cellfun(@(x) x(1:min(23, numel(x))), tt_no_ns, 'UniformOutput', false);
    t_plot = datetime(tt_no_ns, 'InputFormat', 'dd MMM yyyy HH:mm:ss.SSS', 'Locale', 'en_US');
else
    t_plot = t_stk;
end

clf;
plot(t_plot, dis_km, 'b-', 'LineWidth', 1.2);
grid on;
xtickformat('MMM dd HH:mm');
xlabel('Time [UTC]', 'FontName', 'Times New Roman', 'FontSize', 13);
ylabel('Position Error [km]', 'FontName', 'Times New Roman', 'FontSize', 13);
% title(sprintf('IOD [%d, %d, %d], mean |error| = %.2f km', ...
%     iodIdx(1), iodIdx(2), iodIdx(3), mean_km), ...
%     'FontName', 'Times New Roman', 'FontSize', 13);
drawnow;
end