% 读取文件
filename = 'MPC80_20251130-20260102.txt';
fid = fopen(filename, 'r');

% 初始化存储数组
ra_hours = [];   % 赤经时
ra_mins = [];    % 赤经分
ra_secs = [];    % 赤经秒
dec_degs = [];   % 赤纬度
dec_mins = [];   % 赤纬分
dec_secs = [];   % 赤纬秒
observatory = {}; % 观测站
dates = [];       % 日期（简化）
time_zero_set = false;


% 逐行读取数据
line_count = 0;
while ~feof(fid)
    line = fgetl(fid);
    if isempty(line)
        continue;
    end
    
    line_count = line_count + 1;
    
    % 解析固定格式的数据
    % 格式: 8D9R001*    KB  2025 11 28.031424 09 10   40.24 +20 26   14.8 ...
    % 赤经: 时(09) 分(10) 秒(40.24)
    % 赤纬: 符号和度(+20) 分(26) 秒(14.8)
    
    % 提取关键部分 - 使用文本扫描
    parts = strsplit(strtrim(line));
    
    % 找到赤经赤纬的起始位置（可能有不同数量的空格）
    % 从第5个数字开始可能是日期的小数部分，之后是赤经
    for i = 1:length(parts)
        if contains(parts{i}, '.') && length(parts{i}) > 5
            % 找到日期小数部分，下一个元素是赤经的时
            if i+5 <= length(parts)
                % 提取赤经
                ra_h = str2double(parts{i+1});
                ra_m = str2double(parts{i+2});
                ra_s = str2double(parts{i+3});
                
                % 提取赤纬
                dec_str = parts{i+4};
                dec_sign = 1;
                if dec_str(1) == '-'
                    dec_sign = -1;
                    dec_d = str2double(dec_str(2:end));
                elseif dec_str(1) == '+'
                    dec_d = str2double(dec_str(2:end));
                else
                    dec_d = str2double(dec_str);
                end
                
                dec_m = str2double(parts{i+5});
                dec_s = str2double(parts{i+6});
                
                % 存储数据
                ra_hours(end+1) = ra_h;
                ra_mins(end+1) = ra_m;
                ra_secs(end+1) = ra_s;
                dec_degs(end+1) = dec_d * dec_sign;
                dec_mins(end+1) = dec_m;
                dec_secs(end+1) = dec_s;
                
                % 提取观测站（通常是第二个非空字段）
                if length(parts) >= 2
                    obs = parts{2};
                    % 清理观测站代码
                    obs = strrep(obs, '*', '');
                    observatory{end+1} = obs;
                end
                
                % 提取日期
                year = str2double(parts{3});
                month = str2double(parts{4});
                day_str = parts{5}; % 包含小数部分的日
                day = floor(str2double(day_str)); % 日的整数部分
                day_fraction = str2double(day_str) - day; % 日的小数部分
    
                % 计算当前时间对应的儒略日
                % 简化计算：转换为从某个参考时间开始的秒数
                % 这里我们使用MATLAB的datenum函数，然后转换为秒
                % 注意：datenum返回的是从0000年1月0日开始的日期数
                current_time = datenum(year, month, day, 0, 0, 0) + day_fraction;
    
                % 将时间转换为秒（从0000年1月0日开始）
                current_seconds = current_time * 24 * 3600;
                
                % 如果是第一次读取，设置初始时间
                if ~time_zero_set
                    initial_time = current_seconds;
                    time_zero_set = true;
                    relative_seconds = 0; % 初始时间设为0秒
                else
                    % 计算相对于初始时间的秒数
                    relative_seconds = current_seconds - initial_time;
                end
                dates(end+1) = relative_seconds;
                
                break;
            end
        end
    end
end

fclose(fid);
idex = 1:1:line_count;
% 转换为十进制度数
% 赤经: 时分秒 -> 小时 -> 度 (15度/小时)
ra_hours_total = ra_hours + ra_mins/60 + ra_secs/3600;
ra_deg = ra_hours_total * 15; % 转换为度

% 赤纬: 度分秒 -> 度
dec_deg = dec_degs + sign(dec_degs).*(dec_mins/60 + dec_secs/3600);

fprintf('成功读取 %d 条观测数据\n', length(ra_deg));

% 创建图形
figure('Position', [100, 100, 1200, 800]);

% 子图1: 赤经索引散点图
subplot(2, 2, 1);
scatter(idex, ra_deg, 20, 'filled');
xlabel('观测索引');
ylabel('赤经 (度)');
title('赤经随观测变化');
grid on;



% 子图2: 赤经随时间变化
subplot(2, 2, 2);
if ~isempty(dates)
    scatter(dates, ra_deg, 20, 'filled');
    xlabel('时间 (秒)');
    ylabel('赤经 (度)');
    title('赤经随时间变化');
    grid on;
    
end


% 子图3: 赤纬索引散点图
subplot(2, 2, 3);
scatter(idex, dec_deg, 20, 'filled');
xlabel('观测索引');
ylabel('赤纬 (度)');
title('赤纬随观测变化');
grid on;

% 子图4: 赤纬随时间变化
subplot(2, 2, 4);
if ~isempty(dates)
    scatter(dates, dec_deg, 20, 'filled');
    xlabel('时间 (年)');
    ylabel('赤纬 (度)');
    title('赤纬随时间变化');
    grid on;
    
end



% 设置主标题
sgtitle(sprintf('目标 8D9R001 的观测数据 (共 %d 个观测点)', length(ra_deg)));

% 显示统计信息
fprintf('\n统计信息:\n');
fprintf('赤经范围: %.2f° 到 %.2f°\n', min(ra_deg), max(ra_deg));
fprintf('赤纬范围: %.2f° 到 %.2f°\n', min(dec_deg), max(dec_deg));
if ~isempty(dates)
    fprintf('时间跨度: %.6f 年 (约 %.1f 天)\n', max(dates)-min(dates), (max(dates)-min(dates))*365);
end

