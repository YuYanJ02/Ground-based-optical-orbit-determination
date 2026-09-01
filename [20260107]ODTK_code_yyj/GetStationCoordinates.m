function [longitude, latitude, altitude_m] = GetStationCoordinates(code)
% GETSTATIONCOORDINATES 根据 MPC 站点代码提取经纬度与海拔
% 输入参数：
%   code - 站点代码（字符串或数字，如 'K19'、703）
% 输出参数：
%   longitude  - 经度（度，-180~180）
%   latitude   - 纬度（度）
%   altitude_m - 海拔（m，MPC 文件中的 Altitude 字段）

code_str = normalizeStationCode(code);

filename = 'MPC_Codes.txt';
fid = fopen(filename, 'r');
if fid == -1
    error('无法打开文件: %s', filename);
end

longitude = NaN;
latitude = NaN;
altitude_m = NaN;
found = false;

while ~feof(fid)
    line = fgetl(fid);
    if ~ischar(line) || isempty(strtrim(line))
        continue;
    end
    if contains(line, 'Code') && contains(line, 'Longitude')
        continue;
    end

    tokens = regexp(strtrim(line), '\S+', 'match');
    if numel(tokens) < 7
        continue;
    end

    line_code = normalizeStationCode(tokens{2});
    if ~strcmp(line_code, code_str)
        continue;
    end

    lon = str2double(tokens{3});
    lat = str2double(tokens{4});
    alt = str2double(tokens{5});
    if isnan(lon) || isnan(lat)
        continue;
    end

    if lon > 180
        lon = lon - 360;
    end

    longitude = lon;
    latitude = lat;
    altitude_m = alt;
    found = true;
    break;
end

fclose(fid);

if ~found
    warning('未找到站点代码: %s（请检查 MPC_Codes.txt）', code_str);
end
end

function code_str = normalizeStationCode(code)
if isnumeric(code)
    code_str = sprintf('%03d', code);
elseif isstring(code)
    code = char(code);
end

code = upper(strtrim(char(code)));
if isempty(code)
    code_str = '';
    return;
end

if all(isstrprop(code, 'digit'))
    code_str = sprintf('%03d', str2double(code));
else
    code_str = code;
end
end
