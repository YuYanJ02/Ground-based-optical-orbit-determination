function aligned_lines = align_astrometry_data(input_text)
% 对齐天体测量数据到标准格式
% 输入: input_text - 字符串或字符串数组，包含原始数据行
% 输出: aligned_lines - 对齐后的字符串数组

    % 将输入转换为字符串数组
    if ischar(input_text)
        lines = strsplit(input_text, '\n');
        lines = lines(~cellfun(@isempty, lines));
    else
        lines = input_text;
    end
    
    aligned_lines = cell(length(lines), 1);
    
    for i = 1:length(lines)
        line = strtrim(lines{i});
        
        % 跳过空行
        if isempty(line)
            aligned_lines{i} = '';
            continue;
        end
        
        % 提取各个字段（使用更灵活的解析方法）
        % 目标编号 (通常7字符，但可能有变化)
        obj_id = extractBefore(line, 8);
        remaining = strtrim(extractAfter(line, 7));
        
        % 提取观测站代码（1-2字符）
        if length(remaining) >= 2 && isletter(remaining(1))
            % 观测站代码以字母开头
            if length(remaining) >= 3 && isletter(remaining(2))
                obs_code = remaining(1:2);
                remaining = strtrim(remaining(3:end));
            else
                obs_code = remaining(1);
                remaining = strtrim(remaining(2:end));
            end
        elseif length(remaining) >= 3 && remaining(1) == '1' && remaining(2) == 'C'
            obs_code = '1C';
            remaining = strtrim(remaining(3:end));
        elseif length(remaining) >= 2 && remaining(1) == 'm' && remaining(2) == 'C'
            obs_code = 'mC';
            remaining = strtrim(remaining(3:end));
        else
            obs_code = remaining(1);
            remaining = strtrim(remaining(2:end));
        end
        
        % 提取日期和时间字段
        % 使用正则表达式提取数字部分
        pattern = '(\d{4})\s+(\d{2})\s+(\d{2}\.\d+)\s+(\d{2})\s+(\d{2})\s+(\d{2}\.\d+)\s+([+-]\d{2})\s+(\d{2})\s+(\d{2}\.\d+)\s+([\d\.]+)?\s*([A-Z]{1,2})?\s*([A-Z0-9]{2,4})?';
        tokens = regexp(remaining, pattern, 'tokens');
        
        if isempty(tokens)
            % 尝试另一种格式
            pattern2 = '(\d{4})\s+(\d{2})\s+(\d{2}\.\d+)\s+(\d{2})\s+(\d{2})\s+(\d{2}\.\d+)\s+([+-]\d{2})\s+(\d{2})\s+(\d{2}\.\d+)';
            tokens = regexp(remaining, pattern2, 'tokens');
        end
        
        if ~isempty(tokens)
            tokens = tokens{1};
            
            year = tokens{1};
            month = tokens{2};
            day = tokens{3};
            ra_h = tokens{4};
            ra_m = tokens{5};
            ra_s = tokens{6};
            dec_sign = tokens{7}(1);
            dec_d = tokens{7}(2:3);
            dec_m = tokens{8};
            dec_s = tokens{9};
            
            % 提取可选字段
            if length(tokens) >= 10
                mag = tokens{10};
            else
                mag = '';
            end
            
            if length(tokens) >= 11
                color_code = tokens{11};
            else
                color_code = '';
            end
            
            if length(tokens) >= 12
                station = tokens{12};
            else
                station = '';
            end
        else
            % 如果无法解析，保持原样
            aligned_lines{i} = line;
            continue;
        end
        
        % 格式化各个字段
        % 目标编号 (7字符，右对齐)
        obj_id_fmt = sprintf('%-7s', obj_id(1:min(7, length(obj_id))));
        
        % 观测站代码 (2字符，右对齐)
        if strcmp(obs_code, 'C') || length(obs_code) == 1
            obs_code_fmt = sprintf('%2s', obs_code);
        else
            obs_code_fmt = obs_code;
        end
        
        % 日期字段 (固定格式)
        day_num = str2double(day);
        if ~isnan(day_num)
            day_fmt = sprintf('%08.5f', day_num);
        else
            day_fmt = sprintf('%8s', day);
        end
        
        % RA秒 (固定格式)
        ra_s_num = str2double(ra_s);
        if ~isnan(ra_s_num)
            ra_s_fmt = sprintf('%05.2f', ra_s_num);
        else
            ra_s_fmt = sprintf('%5s', ra_s);
        end
        
        % Dec秒 (固定格式)
        dec_s_num = str2double(dec_s);
        if ~isnan(dec_s_num)
            dec_s_fmt = sprintf('%05.1f', dec_s_num);
        else
            dec_s_fmt = sprintf('%5s', dec_s);
        end
        
        % 星等
        if isempty(mag)
            mag_fmt = '    ';
        else
            mag_num = str2double(mag);
            if ~isnan(mag_num)
                mag_fmt = sprintf('%4.1f', mag_num);
            else
                mag_fmt = sprintf('%4s', mag);
            end
        end
        
        % 颜色代码
        if isempty(color_code)
            color_fmt = '   ';
        else
            color_fmt = sprintf('%-2s', color_code);
        end
        
        % 站点代码
        if isempty(station)
            station_fmt = '    ';
        else
            station_fmt = sprintf('%-4s', station);
        end
        
        % 构建对齐后的行
        aligned_line = sprintf('%s %s%s %s %s %s %s %s %s %s %s %s%s %s %s %s%s', ...
            obj_id_fmt, obs_code_fmt, year, month, day_fmt, ...
            ra_h, ra_m, ra_s_fmt, dec_sign, dec_d, dec_m, dec_s_fmt, ...
            mag_fmt, color_fmt, station_fmt);
        
        aligned_lines{i} = aligned_line;
    end
end


    input_text = fileread('MPC80_DROB_20250625_O17.txt');
    
    % 或者使用直接输入
    % input_text = `K25U06S     1C  2025 10 26.182770 23 13   17.99 -05 08   34.3         703`;
    
    % 对齐数据
    aligned_data = align_astrometry_data(input_text);
    
    
    % 保存到文件
    fid = fopen('MPC80_DROB_20250625_O17.txt', 'w');
    for i = 1:length(aligned_data)
        fprintf(fid, '%s\n', aligned_data{i});
    end
    fclose(fid);
