% 按新的名义地心距 rho_nom_km 重算 TPAll.TripleProduct，其余列不变
clear; clc;

rho_nom_km = 380000;   % [km]
sta_alt_m = 1000;

if ~isfile('TPAll.mat')
    error('未找到 TPAll.mat');
end
S = load('TPAll.mat', 'TPAll');
TPAll = S.TPAll;

if ~all(ismember({'Idx1', 'Idx2', 'Idx3', 'TripleProduct'}, TPAll.Properties.VariableNames))
    error('TPAll 缺少 Idx1/Idx2/Idx3/TripleProduct 列');
end

mpcFile = 'MPC80_DROB_20251026_27.txt';
tdmFile = 'TDM_DROB_20251026_27.tdm';
[~, ~, ~, t, ra_deg, dec_deg, station_per_obs, ~] = MPC2TDM(mpcFile, tdmFile);
t_obs = datetime(t(:));
ra_deg = ra_deg(:);
dec_deg = dec_deg(:);
nObs = numel(ra_deg);

if max(TPAll.Idx3) > nObs
    error('TPAll 索引超出观测历元数量');
end

% 预计算各地心单位视线（固定 rho_nom_km）
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

idx1 = TPAll.Idx1;
idx2 = TPAll.Idx2;
idx3 = TPAll.Idx3;
newTP = abs(dot(I_geoc(idx1, :), cross(I_geoc(idx2, :), I_geoc(idx3, :), 2), 2));

fprintf('TripleProduct 更新：rho_nom = %.0f km\n', rho_nom_km);
fprintf('  旧 STP：min=%.4g  med=%.4g  max=%.4g\n', ...
    min(TPAll.TripleProduct), median(TPAll.TripleProduct), max(TPAll.TripleProduct));
fprintf('  新 STP：min=%.4g  med=%.4g  max=%.4g\n', ...
    min(newTP), median(newTP), max(newTP));

TPAll.TripleProduct = newTP;
if ismember('rho_nom_km', TPAll.Properties.VariableNames)
    TPAll.rho_nom_km = repmat(rho_nom_km, height(TPAll), 1);
else
    TPAll.rho_nom_km = repmat(rho_nom_km, height(TPAll), 1);
end

save('TPAll.mat', 'TPAll', 'rho_nom_km');
fprintf('已保存 TPAll.mat（共 %d 组）\n', height(TPAll));
