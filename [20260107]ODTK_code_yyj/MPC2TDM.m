

function [targets,stations,mag,time,ra_deg,dec_deg,station_per_obs,target_per_obs] = MPC2TDM(input_file, output_file)
    % MPC80格式数据转换为CCSDS TDM格式（符合CCSDS 503.0-B-2标准）
    
    % 读取MPC80数据
    fid = fopen(input_file, 'r');
    lines = textscan(fid, '%s', 'Delimiter', '\n');
    fclose(fid);
    lines = lines{1};
    
    % 收集所有观测数据
    observations = {};
    earliest_time = Inf;
    latest_time = -Inf;
    
    % 处理每条观测记录
    for i = 1:length(lines)
        line = strtrim(lines{i});
        if isempty(line), continue; end
        
        % 解析MPC80格式
        parts = strsplit(line);
        
        if length(parts) >= 11  % 最小长度：目标编号到赤纬秒共11个字段
            target_id = parts{1};
            
            % 提取年份
            obs_type_year = parts{3};
            year_str = obs_type_year(1:end);
            year = str2double(year_str);
          
            month = str2double(parts{4});
            day_frac = str2double(parts{5});
            
            % 赤经
            ra_h = str2double(parts{6});
            ra_m = str2double(parts{7});
            ra_s = str2double(parts{8});
            ra_deg = (ra_h + ra_m/60 + ra_s/3600) * 15;
            
            % 赤纬
            dec_str = parts{9};
            dec_d = abs(str2double(dec_str));
            dec_m = str2double(parts{10});
            dec_s = str2double(parts{11});
            dec_deg = (dec_d + dec_m/60 + dec_s/3600);
            if dec_str(1) == '-'
                dec_deg = -dec_deg;
            end
            
            % 星等和波段（可能不存在）
            mag = NaN;
            band = '';
            station_code = '';
            
            % 检查星等是否存在
            if length(parts) >= 12
                possible_mag = str2double(parts{12});
                if ~isnan(possible_mag)
                    mag = possible_mag;
                    
                    if length(parts) >= 13
                        if length(parts{13}) <= 2 && all(isletter(parts{13}))
                            band = parts{13};
                            
                            if length(parts) >= 14
                                station_code = parts{14};
                            end
                        else
                            station_code = parts{13};
                        end
                    end
                else
                    station_code = parts{12};
                end
            end
            
            % 如果还没有找到观测站代码，检查最后一个部分
            if isempty(station_code)
                for j = length(parts):-1:1
                    % 检查是否符合观测站代码格式
                    if (~isempty(regexp(parts{j}, '[A-Za-z]\d+', 'once')) || ...
                        ~isempty(regexp(parts{j}, '\d{3}', 'once'))) && ...
                       length(parts{j}) <= 4  % 通常观测站代码不超过4个字符
                        station_code = parts{j};
                        break;
                    end
                end
            end
            
            % 如果仍然没有找到，使用默认值
            if isempty(station_code)
                station_code = 'UNKN';
            end
            
            % 转换时间
            iso_time = mpc_time_to_iso(year, month, day_frac);
            
            % 转换时间戳为数值格式用于比较
            try
                time_num = posixtime(datetime(iso_time, 'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss.SSSSSS'));
                
                earliest_time = min(earliest_time, time_num);
                latest_time = max(latest_time, time_num);
            catch
                if isinf(earliest_time)
                    earliest_time = posixtime(datetime(now, 'ConvertFrom', 'datenum'));
                    latest_time = earliest_time;
                end
            end
            
            % 保存观测数据
            obs.time = iso_time;
            obs.ra_deg = ra_deg;
            obs.dec_deg = dec_deg;
            obs.mag = mag;
            obs.band = band;
            obs.station = station_code;
            obs.target = target_id(1:7);
            
            observations{end+1} = obs;
        end
    end
    
    if isempty(observations)
        error('没有找到有效的观测数据');
    end

    % 按 UTC 时间排序（全文件时间序列）
    nObs = length(observations);
    time_nums = nan(nObs, 1);
    for i = 1:nObs
        try
            time_nums(i) = posixtime(datetime(observations{i}.time, 'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss.SSSSSS'));
        catch
            time_nums(i) = inf;
        end
    end
    [~, ord] = sort(time_nums);
    observations = observations(ord);

    mag = {};
    time = {};
    ra_deg = zeros(nObs, 1);
    dec_deg = zeros(nObs, 1);
    station_per_obs = cell(nObs, 1);
    target_per_obs = cell(nObs, 1);
    for i = 1:length(observations)
        obs = observations{i};
        if obs.mag <= 30
            mag{end+1} = obs.mag;
        else
            mag{end+1} = nan;
        end
        time{end+1} = obs.time;
        ra_deg(i) = obs.ra_deg;
        dec_deg(i) = obs.dec_deg;
        station_per_obs{i} = obs.station;
        target_per_obs{i} = obs.target;
    end
time = datetime(time, 'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss.SSSSSS');
    % 按观测站分组（使用元胞数组，避免字段名问题）
    stations = {};
    station_data = {};  % 元胞数组，每个元素是对应站点的观测数据列表
    
    for i = 1:length(observations)
        obs = observations{i};
        station = obs.station;
        
        % 查找站点是否已存在
        station_idx = find(strcmp(stations, station));
        
        if isempty(station_idx)
            % 新站点
            stations{end+1} = station;
            station_data{end+1} = {obs};  % 创建新的观测列表
        else
            % 已有站点，添加到对应列表
            station_data{station_idx}{end+1} = obs;
        end
    end

        targets = {};
    target_data = {};  % 元胞数组，每个元素是对应站点的观测数据列表
    
    for i = 1:length(observations)
        obs = observations{i};
        target = obs.target;
        
        % 查找站点是否已存在
        station_idx = find(strcmp(targets, target));
        
        if isempty(station_idx)
            % 新站点
            targets{end+1} = target(1:7);
            target_data{end+1} = {obs};  % 创建新的观测列表
        else
            % 已有站点，添加到对应列表
            target_data{station_idx}{end+1} = obs;
        end
    end
    
    % 创建TDM文件
    fid_tdm = fopen(output_file, 'w');
    
    % TDM头部
    fprintf(fid_tdm, 'CCSDS_TDM_VERS = 2.0\r\n');
    fprintf(fid_tdm, 'CREATION_DATE = %s\r\n', datestr(now, 'yyyy-mm-ddTHH:MM:SS.FFF'));
    fprintf(fid_tdm, 'ORIGINATOR = MPC80_TO_TDM\r\n');
    fprintf(fid_tdm, 'COMMENT Generated from MPC80 optical observations\r\n');
    fprintf(fid_tdm, '\r\n');
    
    % 为每个观测站创建一个段
    for s = 1:length(stations)
        station = stations{s};
        obs_list = station_data{s};
        
        % 计算该观测站的时间范围
        station_earliest = Inf;
        station_latest = -Inf;
        for i = 1:length(obs_list)
            obs = obs_list{i};
            time_num = posixtime(datetime(obs.time, 'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss.SSSSSS'));
            station_earliest = min(station_earliest, time_num);
            station_latest = max(station_latest, time_num);
        end
        
        start_dt = datetime(station_earliest, 'ConvertFrom', 'posixtime', 'Format', 'yyyy-MM-dd''T''HH:mm:ss.SSSSSS');
        stop_dt = datetime(station_latest, 'ConvertFrom', 'posixtime', 'Format', 'yyyy-MM-dd''T''HH:mm:ss.SSSSSS');
        
        % META段开始
        fprintf(fid_tdm, 'META_START\r\n');
        
        % 元数据部分
        fprintf(fid_tdm, 'TIME_SYSTEM = UTC\r\n');
        fprintf(fid_tdm, 'START_TIME = %s\r\n', char(start_dt));
        fprintf(fid_tdm, 'STOP_TIME = %s\r\n', char(stop_dt));
        fprintf(fid_tdm, 'PARTICIPANT_1 = %s\r\n', station);
        fprintf(fid_tdm, 'PARTICIPANT_2 = %s\r\n', obs_list{1}.target);
        fprintf(fid_tdm, 'MODE = SEQUENTIAL\r\n');
        fprintf(fid_tdm, 'PATH = 2,1\r\n');
        fprintf(fid_tdm, 'ANGLE_TYPE = RADEC\r\n');
        fprintf(fid_tdm, 'REFERENCE_FRAME = EMEJ2000\r\n');
        fprintf(fid_tdm, 'DATA_QUALITY = VALIDATED\r\n');
        fprintf(fid_tdm, 'META_STOP\r\n');
        fprintf(fid_tdm, '\r\n');
        
        % DATA段开始
        fprintf(fid_tdm, 'DATA_START\r\n');
        
        % 写入该观测站的所有数据
        for i = 1:length(obs_list)
            obs = obs_list{i};
            
            % 添加星等信息到注释
            if ~isnan(obs.mag) && ~isempty(obs.band)
                fprintf(fid_tdm, 'COMMENT Mag=%.1f, Band=%s\r\n', obs.mag, obs.band);
            elseif ~isnan(obs.mag)
                fprintf(fid_tdm, 'COMMENT Mag=%.1f\r\n', obs.mag);
            elseif ~isempty(obs.band)
                fprintf(fid_tdm, 'COMMENT Band=%s\r\n', obs.band);
            end
            
            % 写入角度数据
            fprintf(fid_tdm, 'ANGLE_1 = %s %.8f\r\n', obs.time, obs.ra_deg);
            fprintf(fid_tdm, 'ANGLE_2 = %s %.8f\r\n', obs.time, obs.dec_deg);
        end
        
        fprintf(fid_tdm, 'DATA_STOP\r\n');
        fprintf(fid_tdm, '\r\n');
    end
    
    fclose(fid_tdm);
    
    fprintf('转换完成！\n');
    fprintf('生成文件: %s\n', output_file);
    fprintf('总观测数量: %d\n', length(observations));
    fprintf('观测站数量: %d\n', length(stations));
    fprintf('观测站列表: %s\n', strjoin(stations, ', '));


    plot_observations_over_time(observations);
end

function iso_time = mpc_time_to_iso(year, month, day_fraction)
    % 将MPC时间转换为ISO 8601格式
    day = floor(day_fraction);
    fraction = day_fraction - day;
    
    total_seconds = fraction * 86400;
    hours = floor(total_seconds / 3600);
    minutes = floor(mod(total_seconds, 3600) / 60);
    seconds = mod(total_seconds, 60);
    
    % 格式化为ISO 8601，保留6位小数
    iso_time = sprintf('%04d-%02d-%02dT%02d:%02d:%09.6f', ...
                       year, month, day, hours, minutes, seconds);
end


function plot_observations_over_time(observations)
    % 观测随时间分布：左轴赤经(蓝)、右轴赤纬(红)；测站分区灰色阴影；测站用不同 marker

    nObs = length(observations);
    times = NaT(nObs, 1);
    ra_values = zeros(nObs, 1);
    dec_values = zeros(nObs, 1);
    station_codes = strings(nObs, 1);

    for i = 1:nObs
        obs = observations{i};
        times(i) = datetime(obs.time, 'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss.SSSSSS');
        ra_values(i) = obs.ra_deg;
        dec_values(i) = obs.dec_deg;
        station_codes(i) = string(strtrim(obs.station));
    end

    stations = unique(station_codes, 'stable');
    nSta = numel(stations);
    markers = station_markers(nSta);
    [plotTimes, tMeta] = visual_time_compress_last_station(times, station_codes, stations);

    colorRa = [0.00, 0.45, 1.00];
    colorDec = [1.00, 0.00, 0.00];
    bandColors = station_band_colors(nSta);

    ra_span = max(ra_values) - min(ra_values);
    dec_span = max(dec_values) - min(dec_values);
    ra_pad = max(0.05 * ra_span, 0.1);
    dec_pad = max(0.05 * dec_span, 0.1);
    ylimRa = [min(ra_values) - ra_pad, max(ra_values) + ra_pad];
    ylimDec = [min(dec_values) - dec_pad, max(dec_values) + dec_pad];

    figure('Color', 'w', 'Position', [80, 80, 980, 460]);
    ax = gca;
    hold(ax, 'on');

    % 测站观测时段：各测站独立灰度阴影 + 边界线 + 标注
    yyaxis(ax, 'left');
    ylim(ax, ylimRa);
    bandLegH = gobjects(nSta, 1);
    for s = 1:nSta
        idx = station_codes == stations(s);
        x1 = min(plotTimes(idx));
        x2 = max(plotTimes(idx));
        edgeColor = max(bandColors(s, :) * 0.55, 0);
        bandLegH(s) = patch(ax, [x1, x2, x2, x1], [ylimRa(1), ylimRa(1), ylimRa(2), ylimRa(2)], ...
            bandColors(s, :), 'FaceAlpha', 0.72, 'EdgeColor', edgeColor, ...
            'LineWidth', 1.0, 'LineStyle', '--');
    end

    if tMeta.compressed
        xBreak = tMeta.gapStart + (tMeta.gapEnd - tMeta.gapStart) / 2;
        plot(ax, [xBreak, xBreak], ylimRa, 'Color', [0.35, 0.35, 0.35], ...
            'LineStyle', '--', 'LineWidth', 1.2, 'HandleVisibility', 'off');
        text(ax, xBreak, ylimRa(2) - 0.03 * (ylimRa(2) - ylimRa(1)), '//', ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', ...
            'FontName', 'Times New Roman', 'FontSize', 12, 'Color', [0.25, 0.25, 0.25]);
    end

    % 左轴：赤经（蓝），测站区分 marker
    for s = 1:nSta
        idx = station_codes == stations(s);
        scatter(ax, plotTimes(idx), ra_values(idx), 32, ...
            'Marker', markers{s}, ...
            'MarkerFaceColor', colorRa, ...
            'MarkerEdgeColor', colorRa, ...
            'LineWidth', 0.8, ...
            'HandleVisibility', 'off');
    end
    ylabel(ax, '赤纬 [deg]', 'FontName', 'Times New Roman', 'FontSize', 14, 'Color', colorRa);
    ax.YColor = colorRa;

    % 右轴：赤纬（红），同一测站沿用相同 marker
    yyaxis(ax, 'right');
    ylim(ax, ylimDec);
    for s = 1:nSta
        idx = station_codes == stations(s);
        scatter(ax, plotTimes(idx), dec_values(idx), 32, ...
            'Marker', markers{s}, ...
            'MarkerFaceColor', colorDec, ...
            'MarkerEdgeColor', colorDec, ...
            'LineWidth', 0.8, ...
            'HandleVisibility', 'off');
    end
    ylabel(ax, '赤经 [deg]', 'FontName', 'Times New Roman', 'FontSize', 14, 'Color', colorDec);
    ax.YColor = colorDec;

    yyaxis(ax, 'left');
    xlabel(ax, '时间 [UTC]', 'FontName', 'Times New Roman', 'FontSize', 14);
    apply_uniform_visual_xticks(ax, plotTimes, tMeta);
    style_obs_axes(ax);

    % 图例：RA / Dec + 各测站阴影区
    yyaxis(ax, 'left');
    legH = scatter(ax, NaN, NaN, 40, 'o', 'MarkerFaceColor', colorRa, 'MarkerEdgeColor', colorRa);
    legL = {'赤纬'};
    yyaxis(ax, 'right');
    legH(2) = scatter(ax, NaN, NaN, 40, 'o', 'MarkerFaceColor', colorDec, 'MarkerEdgeColor', colorDec);
    legL{2} = '赤经';
    for s = 1:nSta
        legH(end + 1) = bandLegH(s); %#ok<AGROW>
        legL{end + 1} = char(stations(s)); %#ok<AGROW>
    end
    yyaxis(ax, 'left');
    legend(ax, legH, legL, 'Location', 'best', 'FontName', 'Times New Roman', ...
        'FontSize', 11, 'Box', 'off');
end

function bandColors = station_band_colors(nSta)
    % 每个测站一种灰度（由浅到深，避免仅两种交替难以区分）
    levels = linspace(0.94, 0.62, max(nSta, 2));
    levels = levels(1:nSta);
    bandColors = repmat(levels(:), 1, 3);
end

function [plotTimes, meta] = visual_time_compress_last_station(times, station_codes, stations)
    % 最后一站弧段过长时在 x 方向压缩；前面各站保持真实时间
    plotTimes = times;
    meta.compressed = false;

    if numel(stations) < 2
        return;
    end

    isLast = station_codes == stations(end);
    isEarly = ~isLast;
    if ~any(isLast) || ~any(isEarly)
        return;
    end

    tEarly2 = max(times(isEarly));
    earlySpan = tEarly2 - min(times(isEarly));
    if earlySpan <= seconds(0)
        earlySpan = hours(6);
    end

    tLast1 = min(times(isLast));
    tLast2 = max(times(isLast));
    lastSpan = tLast2 - tLast1;
    if lastSpan <= seconds(0) || lastSpan <= earlySpan * 1.5
        return;
    end

    gap = earlySpan * 0.06;
    visualLastSpan = earlySpan * 0.90;
    meta.compressed = true;
    meta.tLast1 = tLast1;
    meta.tLast2 = tLast2;
    meta.gapStart = tEarly2;
    meta.gapEnd = tEarly2 + gap;
    meta.scale = visualLastSpan / lastSpan;

    plotTimes(isLast) = meta.gapEnd + (times(isLast) - tLast1) * meta.scale;
end

function apply_uniform_visual_xticks(ax, plotTimes, meta)
    % 在压缩后的视觉坐标上均匀布刻度，标签反算为真实 UTC
    nTicks = 8;
    tMin = min(plotTimes);
    tMax = max(plotTimes);
    tickPos = linspace_datetime(tMin, tMax, nTicks);

    if ~meta.compressed
        xticks(ax, tickPos);
        xtickformat(ax, 'MMM dd');
        return;
    end

    tickLab = cell(nTicks, 1);
    for k = 1:nTicks
        tAct = visual_to_actual_time(tickPos(k), meta);
        if isnat(tAct)
            tickLab{k} = '';
        else
            tickLab{k} = char(datetime(tAct, 'Format', 'MMM dd'));
        end
    end
    xticks(ax, tickPos);
    xticklabels(ax, tickLab);
end

function tActual = visual_to_actual_time(tVis, meta)
    if tVis <= meta.gapStart
        tActual = tVis;
    elseif tVis < meta.gapEnd
        tActual = NaT;
    else
        tActual = meta.tLast1 + (tVis - meta.gapEnd) / meta.scale;
    end
end

function tOut = linspace_datetime(t1, t2, n)
    if n <= 1
        tOut = t1;
        return;
    end
    frac = linspace(0, 1, n)';
    tOut = t1 + (t2 - t1) .* frac;
end

function markers = station_markers(nSta)
    baseMarkers = {'o', 's', '^', 'd', 'v', '>', '<', 'p', 'h', '*'};
    markers = baseMarkers(mod(0:nSta - 1, numel(baseMarkers)) + 1);
end

function style_obs_axes(ax)
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
