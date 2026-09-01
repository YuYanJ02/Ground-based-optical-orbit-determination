function READ_MPC80(input_file,output_file)
    % MPC80解析器
    
    fprintf('开始解析MPC80数据...\n');
    
    % 读取文件
    fid = fopen(input_file, 'r');
    if fid == -1
        error('无法打开文件: %s', input_file);
    end
    
    % 读取所有行
    lines = textscan(fid, '%s', 'Delimiter', '\n', 'Whitespace', '');
    lines = lines{1};
    fclose(fid);
    
    % 提取MPC80格式的数据行
    mpc_lines = extract_mpc80_lines_fixed(lines);
    
    fprintf('找到 %d 行MPC80格式数据\n', length(mpc_lines));
    
    % 解析每行并生成标准格式
    standard_lines = {};
    
    for i = 1:length(mpc_lines)
        parsed_data = parse_line_with_date_fixed(mpc_lines{i});
        if ~isempty(parsed_data)
            standard_line = format_to_mpc80_standard_columns(parsed_data);
            if ~isempty(standard_line)
                standard_lines{end+1} = standard_line;
            else
                fprintf('格式化第 %d 行失败\n', i);
            end
        else
            fprintf('解析第 %d 行失败: %s\n', i, mpc_lines{i}(1:min(50, length(mpc_lines{i}))));
        end
    end
    
    % 写入标准格式文件
    write_standard_mpc80_fixed(standard_lines, output_file);
    
    fprintf('\n处理完成！\n');
    fprintf('成功处理: %d 行\n', length(standard_lines));
    fprintf('标准格式文件: %s\n', output_file);
    
    % 显示详细解析结果
    show_detailed_parsing(standard_lines, mpc_lines);
end

function mpc_lines = extract_mpc80_lines_fixed(all_lines)
    % 提取MPC80格式的数据行
    
    mpc_lines = {};
    
    for i = 1:length(all_lines)
        line = strtrim(all_lines{i});
        
        % 跳过空行
        if isempty(line)
            continue;
        end
        
        % 跳过表格行
        if contains(line, '|') || contains(line, 'permID') || contains(line, 'trkSub')
            continue;
        end
        
        % 检查是否是MPC80格式
        if is_mpc80_line_fixed(line)
            mpc_lines{end+1} = line;
        end
    end
end

function result = is_mpc80_line_fixed(line)
    % 判断是否为MPC80格式行
    
    if length(line) < 40
        result = false;
        return;
    end
    
    
    
    % 必须包含年份
    if ~(contains(line, '2025') || contains(line, '2026'))
        result = false;
        return;
    end
    
    result = true;
end

function parsed = parse_line_with_date_fixed(line)
    % 正确解析包含日期和赤经赤纬的行
    
    parsed = struct(...
        'object_id', '', ...
        'discovery_flag', '', ...
        'station_code', '', ...
        'year', '', ...
        'month', '', ...
        'day', '', ...
        'ra_hour', '', ...
        'ra_min', '', ...
        'ra_sec', '', ...
        'dec_sign', '+', ...
        'dec_deg', '', ...
        'dec_min', '', ...
        'dec_sec', '', ...
        'magnitude', '', ...
        'band', '', ...
        'observer_code', '');
    
    try
        original_line = line;
        
        % 1. 检查发现标志
        id = line(1:7);
        yyj=[id,'*'];
        parsed.object_id = id;
        if contains(line, yyj)
            parsed.discovery_flag = '*';
            line = strrep(line, [id,'*'], [id,' ']);
        end
        
        % 2. 移除目标编号
        line = strrep(line, id, '');
        line = strtrim(line);
        
        % 3. 提取测站代码（年份前的代码）
        year_match = regexp(line, '(20[25][56])', 'once');
        if ~isempty(year_match)
            station_part = line(1:year_match-1);
            parsed.station_code = strtrim(station_part);
            line = line(year_match:end);
        end
        
        % 4. 提取年份、月份、日（这是关键部分）
        % 日期格式: YYYY MM DD.DDDDDD
        % 注意：日的小数部分可能包含赤经的小时部分
        
        % 先提取年份和月份
        year_month_match = regexp(line, '(\d{4})\s+(\d{1,2})\s+(\d{1,2}\.\d+)', 'tokens', 'once');
        
        if ~isempty(year_month_match)
            parsed.year = year_month_match{1};
            parsed.month = year_month_match{2};
            day_with_ra_hour = year_month_match{3}; % 日+小数+赤经小时
            
            % 从行中移除日期部分
            date_str = [parsed.year ' ' parsed.month ' ' day_with_ra_hour];
            line = strrep(line, date_str, '');
            line = strtrim(line);
            
            % 5. 分离日的小数部分和赤经小时
            % 日的小数部分通常有6位，后面跟着赤经小时
            % 例如: "28.03142409" -> 日=28.031424, 赤经小时=09
            
            if contains(day_with_ra_hour, '.')
                dot_pos = strfind(day_with_ra_hour, '.');
                int_part = day_with_ra_hour(1:dot_pos-1); % 日的整数部分
                frac_part = day_with_ra_hour(dot_pos+1:end); % 小数部分+可能的赤经小时
                
                % 假设小数部分有6位，后面是赤经小时
                if length(frac_part) >= 8
                    % 前6位是日的小数部分
                    day_frac = frac_part(1:6);
                    % 后2位是赤经小时
                    parsed.ra_hour = frac_part(7:8);
                    parsed.day = [int_part '.' day_frac];
                else
                    % 如果长度不够，尝试其他方法
                    parsed.day = day_with_ra_hour;
                    % 从剩余行中提取赤经小时
                    ra_hour_match = regexp(line, '^(\d{2})', 'tokens', 'once');
                    if ~isempty(ra_hour_match)
                        parsed.ra_hour = ra_hour_match{1};
                        line = line(3:end);
                    end
                end
            else
                parsed.day = day_with_ra_hour;
            end
        end
        
        % 6. 提取赤经的分钟和秒
        % 现在line应该以赤经的分钟开始
        if ~isempty(parsed.ra_hour)
            % 提取格式: MM SS.sss
            ra_ms_match = regexp(line, '(\d{2})\s+(\d{2}\.\d+)', 'tokens', 'once');
            if ~isempty(ra_ms_match)
                parsed.ra_min = ra_ms_match{1};
                parsed.ra_sec = ra_ms_match{2};
                
                % 移除赤经部分
                ra_str = [parsed.ra_min ' ' parsed.ra_sec];
                line = strrep(line, ra_str, '');
                line = strtrim(line);
            end
        end
        
        % 7. 提取赤纬
        % 查找赤纬符号
        if contains(line, '+')
            dec_sign = '+';
            sign_pos = strfind(line, '+');
        elseif contains(line, '-')
            dec_sign = '-';
            sign_pos = strfind(line, '-');
        else
            % 默认正号
            dec_sign = '+';
            sign_pos = 1;
        end
        
        parsed.dec_sign = dec_sign;
        
        % 提取赤纬的度、分、秒
        if ~isempty(sign_pos)
            dec_part = line(sign_pos:end);
            dec_match = regexp(dec_part, '([+-])(\d{2})\s+(\d{2})\s+(\d{2}\.\d+)', 'tokens', 'once');
            
            if ~isempty(dec_match)
                parsed.dec_sign = dec_match{1};
                parsed.dec_deg = dec_match{2};
                parsed.dec_min = dec_match{3};
                parsed.dec_sec = dec_match{4};
                
                % 移除赤纬部分
                dec_str = [dec_match{1} dec_match{2} ' ' dec_match{3} ' ' dec_match{4}];
                line = strrep(line, dec_str, '');
                line = strtrim(line);
            else
                % 尝试无空格的格式
                dec_match = regexp(dec_part, '([+-])(\d{2})(\d{2})(\d{2}\.\d+)', 'tokens', 'once');
                if ~isempty(dec_match)
                    parsed.dec_sign = dec_match{1};
                    parsed.dec_deg = dec_match{2};
                    parsed.dec_min = dec_match{3};
                    parsed.dec_sec = dec_match{4};
                end
            end
        end
        
        % 8. 提取星等和波段
        % 8. 提取星等和波段
        mag_band_match = regexp(line, '(\d{1,2}\.\d{1,2})\s*([A-Z]{1,2})', 'tokens', 'once');
        
        % 设置默认值
        parsed.magnitude = ' ';
        parsed.band = ' ';
        
        if ~isempty(mag_band_match) && ~isempty(mag_band_match{1}) && ~isempty(mag_band_match{2})
            parsed.magnitude = mag_band_match{1};
            parsed.band = mag_band_match{2};
            
            % 移除星等和波段
            mag_band_str = [mag_band_match{1} mag_band_match{2}];
            line = strrep(line, mag_band_str, '');
            line = strtrim(line);
        end
        
        % 9. 提取观测者代码（最后三个字符）
        % 从行尾提取最后三个字符
        if length(line) >= 3
            obs_match = line(end-2:end);
            
        else
            % 如果行长度不足3，尝试从原始行提取
            if length(original_line) >= 3
                obs_match = original_line(end-2:end);
            else
                obs_match = '';
            end
        end
        
        if ~isempty(obs_match)
            parsed.observer_code = strtrim(obs_match);
            
        end
        
        % 10. 验证解析结果
        if isempty(parsed.ra_hour) || isempty(parsed.ra_min) || isempty(parsed.ra_sec) || ...
           isempty(parsed.dec_deg) || isempty(parsed.dec_min) || isempty(parsed.dec_sec)
            % 尝试备选解析方法
            parsed = parse_alternative_method(original_line);
        end
        
    catch ME
        fprintf('解析行时出错: %s\n', ME.message);
        parsed = [];
    end
end



function standard_line = format_to_mpc80_standard_columns(parsed)
    % 按照MPC80标准列位置格式化
    
    try
        % 检查必要字段
        if isempty(parsed.ra_hour) || isempty(parsed.dec_deg)
            standard_line = '';
            return;
        end
        
        % MPC80标准列定义:
        % 列1-12: 目标编号（如有发现标志带*号）
        % 列13-16: 测站代码
        % 列17-32: 观测时间（年 月 日.小数）
        % 列33-44: 赤经（时 分 秒）
        % 列45-56: 赤纬（±度 分 秒）
        % 列57-65: 星等和波段
        % 列66-80: 备注/观测者代码
        
        % 1. 目标编号（12列）
        if strcmp(parsed.discovery_flag, '*')
            object_field = sprintf('%-12s', [parsed.object_id '*']);
        else
            object_field = sprintf('%-12s', parsed.object_id);
        end
        
        % 2. 测站代码（4列）
        station_field = sprintf('%-4s', parsed.station_code);
        
        % 3. 观测时间（16列：年4列 月2列 日9列）
        year = strtrim(parsed.year);
        month = strtrim(parsed.month);
        day = strtrim(parsed.day);
        
        % 确保日的小数部分有6位
        if contains(day, '.')
            parts = strsplit(day, '.');
            int_part = sprintf('%2s', parts{1});
            dec_part = parts{2};
            if length(dec_part) < 6
                dec_part = [dec_part, repmat('0', 1, 6-length(dec_part))];
            elseif length(dec_part) > 6
                dec_part = dec_part(1:6);
            end
            day_formatted = sprintf('%2s.%6s', int_part, dec_part);
        else
            day_formatted = sprintf('%2s.000000', day);
        end
        
        date_field = sprintf('%4s %2s %9s', year, month, day_formatted);
        
        % 4. 赤经（12列：时2列 分2列 秒7列）
        ra_h = sprintf('%2s', parsed.ra_hour);
        ra_m = sprintf('%2s', parsed.ra_min);
        ra_s = strtrim(parsed.ra_sec);
        
        % 确保秒有2位小数
        if contains(ra_s, '.')
            parts = strsplit(ra_s, '.');
            int_part = sprintf('%2s', parts{1});
            dec_part = parts{2};
            if length(dec_part) < 2
                dec_part = [dec_part, repmat('0', 1, 2-length(dec_part))];
            elseif length(dec_part) > 2
                dec_part = dec_part(1:2);
            end
            ra_s_formatted = sprintf('%2s.%2s', int_part, dec_part);
        else
            ra_s_formatted = sprintf('%2s.00', ra_s);
        end
        
        ra_field = sprintf('%2s %2s %7s', ra_h, ra_m, ra_s_formatted);
        
        % 5. 赤纬（12列：符号1列 度2列 分2列 秒6列）
        dec_d = sprintf('%2s', parsed.dec_deg);
        dec_m = sprintf('%2s', parsed.dec_min);
        dec_s = strtrim(parsed.dec_sec);
        
        % 确保秒有1位小数
        if contains(dec_s, '.')
            parts = strsplit(dec_s, '.');
            int_part = sprintf('%2s', parts{1});
            dec_part = parts{2};
            if length(dec_part) < 1
                dec_part = [dec_part, '0'];
            elseif length(dec_part) > 1
                dec_part = dec_part(1);
            end
            dec_s_formatted = sprintf('%2s.%1s', int_part, dec_part);
        else
            dec_s_formatted = sprintf('%2s.0', dec_s);
        end
        
        dec_field = sprintf('%1s%2s %2s %6s', parsed.dec_sign, dec_d, dec_m, dec_s_formatted);
        
        % 6. 星等和波段（9列：星等5列 波段1列 空格3列）
        mag = strtrim(parsed.magnitude);
        band = strtrim(parsed.band);
        
        % 检查星等和波段是否为空
        if isempty(mag) && isempty(band)
            % 如果都为空，直接创建9个空格的字段
            mag_field = '         ';  % 9个空格
        else
            % 如果有值，按照原逻辑处理
            if contains(mag, '.')
                parts = strsplit(mag, '.');
                int_part = sprintf('%2s', parts{1});
                dec_part = parts{2};
                if length(dec_part) < 1
                    dec_part = [dec_part, '0'];
                elseif length(dec_part) > 1
                    dec_part = dec_part(1);
                end
                mag_formatted = sprintf('%2s.%1s', int_part, dec_part);
            else
                mag_formatted = sprintf('%2s.0', mag);
            end
            
            mag_field = sprintf('%5s %1s   ', mag_formatted, band);
        end
        
        
        
        % 7. 观测者代码（15列）
        if ~isempty(parsed.observer_code)
            obs_field = sprintf('%-15s', parsed.observer_code);
        else
            obs_field = '               ';
        end
        
        % 组合所有字段
        standard_line = [object_field, station_field, date_field, ' ', ...
                         ra_field, ' ', dec_field, mag_field, obs_field];
        
        % 确保总长度为80列
        
        
    catch ME
        fprintf('格式化错误: %s\n', ME.message);
        standard_line = '';
    end
end

function write_standard_mpc80_fixed(lines, filename)
    % 写入标准格式文件
    
    fid = fopen(filename, 'w');
    if fid == -1
        error('无法创建文件: %s', filename);
    end
    
    for i = 1:length(lines)
        fprintf(fid, '%s\n', lines{i});
        
    end
    
    fclose(fid);
end

function show_detailed_parsing(standard_lines, original_lines)
    % 显示详细解析结果
    
    fprintf('\n=== 详细解析结果（前5行）===\n\n');
    
    for i = 1:min(5, length(standard_lines))
        fprintf('原始行 %d: %s\n', i, original_lines{i});
        fprintf('解析行 %d: %s\n', i, standard_lines{i});
        
        % 显示解析的各个字段
        line = standard_lines{i};
        fprintf('  目标编号: [%s]\n', line(1:12));
        fprintf('  测站代码: [%s]\n', line(13:16));
        fprintf('  观测时间: [%s]\n', line(17:32));
        fprintf('      赤经: [%s] (时:%s, 分:%s, 秒:%s)\n', ...
            line(33:44), line(33:34), line(36:37), line(39:44));
        fprintf('      赤纬: [%s] (符号:%s, 度:%s, 分:%s, 秒:%s)\n', ...
            line(45:56), line(45:45), line(46:47), line(49:50), line(52:56));
        fprintf('  星等/波段: [%s] (星等:%s, 波段:%s)\n', ...
            line(57:65), line(57:61), line(63:63));
        fprintf('  观测者代码: [%s]\n', line(66:80));
        fprintf('\n');
    end
    
    % 显示统计信息
    fprintf('=== 解析统计 ===\n');
    fprintf('成功解析行数: %d\n', length(standard_lines));
    
    % 检查赤经赤纬是否相同的问题
    same_ra_dec_count = 0;
    for i = 1:length(standard_lines)
        line = standard_lines{i};
        ra_part = line(33:44);
        dec_part = line(45:56);
        if strcmp(strtrim(ra_part), strtrim(dec_part))
            same_ra_dec_count = same_ra_dec_count + 1;
            if same_ra_dec_count <= 3
                fprintf('警告: 第 %d 行赤经赤纬相同: RA=%s, DEC=%s\n', i, ra_part, dec_part);
            end
        end
    end
    
    if same_ra_dec_count > 0
        fprintf('有 %d 行赤经赤纬相同\n', same_ra_dec_count);
    else
        fprintf('所有行的赤经赤纬都不同（正常）\n');
    end
end




