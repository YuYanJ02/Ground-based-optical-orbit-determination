function limiting_magnitude = Calculate_LimitingMagnitude_BZ(aperture, fov, exposure_time)
% 功能：计算望远镜的极限星等
% 输入参数：
%   aperture - 望远镜口径 (米)
%   fov - 视场角 (度)  
%   exposure_time - 曝光时间 (秒)
% 输出参数：
%   limiting_magnitude - 极限星等 (mag)

    %% 参数设置
    % 确定参数
    pixels_number_width = 2038;      % 像素宽度方向数量  
    pixel_size = 5e-6;              % 像元尺寸 (米) 10μm
    energy_concentration = 10e-6;    % 能量集中度 R (米) 10μm
    quantum_efficiency = 0.55;       % 量子效率 @610nm
    dark_current = 23;          % 暗电流 (e-/s/pixel)
    readout_noise = 23;            % 读出噪声 (e-/pixel)
    snr_threshold = 5;               % 信噪比探测阈值
    focal = 0.417;                   % 焦距 m
    
    % 假设参数 
    optical_transmission = 0.4463;      % 光学透过率 T_opt 
    atmospheric_transmission = 1.0;  % 大气透过率 T_atm )
    background_magnitude = 21.5;     % 背景星等 m_sky 

    %% 从信噪比反算极限星等
    
    % 计算像素尺度 (角秒/像素)
    fov_arcsec = fov * 3600;  % 视场转换为角秒
    pixel_scale = fov_arcsec / pixels_number_width;  % 角秒/像素
    
    % 计算分光因子 f 
    sigma = energy_concentration / 1.28;  % σ = R / 1.28
    argument = pixel_size / (2 * sqrt(2) * sigma);
    fraction_factor = erf(argument);  % 分光因子 f
    
    % 计算每个像元的大小（角秒）
    %pixel_scale_rad =  pixel_size * 10e6 / (focal * 1000000) * 206265;
    %pixel_solid_angle = pixel_scale_rad^2;
    pixel_solid_angle = pixel_scale^2;  % A*A
    
    % 定义信噪比函数
    function snr = calculate_snr(test_magnitude)
         
        aperture_cm = aperture * 100;  % 口径转换为cm
        term = pi * (aperture_cm/2)^2 * optical_transmission * ...
                   atmospheric_transmission * quantum_efficiency * ...
                   exposure_time ;
        
        % 计算目标电子数
        N_star = fraction_factor * term * 3.4e6 * 2.512^(-(test_magnitude));
        
        % 计算天光背景电子数
        N_sky = term * pixel_solid_angle * 3.4e6 * 2.512^(-(background_magnitude));
        
        % 计算暗电流和读出噪声
        dark_noise = dark_current * exposure_time;
        readout_noise_term = readout_noise^2;
        
        % 计算信噪比 
        total_noise = N_star + N_sky + dark_noise + readout_noise_term;
        snr = N_star / sqrt(total_noise);
    end

    % 使用二分法搜索极限星等
    mag_low = 3;    % 下限 (亮星)
    mag_high = 30;   % 上限 (暗星)
    tolerance = 0.01; % 收敛容差
    
    for iter = 1:200
        mag_mid = (mag_low + mag_high) / 2;
        snr_mid = calculate_snr(mag_mid);
        
        if abs(snr_mid - snr_threshold) < tolerance
            break;
        elseif snr_mid < snr_threshold
            mag_high = mag_mid;  % 信噪比不足，星等太暗
        else
            mag_low = mag_mid;   % 信噪比足够，星等可更暗
        end
    end
    
    limiting_magnitude = mag_mid;
    
    %% 输出计算结果
    fprintf('=== 极限星等计算报告 ===\n');
    fprintf('输入参数:\n');
    fprintf('  口径: %.1f m\n', aperture);
    fprintf('  视场: %.3f deg\n', fov);
    fprintf('  曝光时间: %.3f s\n', exposure_time);
    fprintf('\n计算参数:\n');
    fprintf('  像素尺度: %.4f arcsec/pixel\n', pixel_scale);
    fprintf('  分光因子 f: %.4f\n', fraction_factor);
    fprintf('  信噪比阈值: %.1f\n', snr_threshold);
    fprintf('\n结果:\n');
    fprintf('  极限星等: %.4f mag\n', limiting_magnitude);
    fprintf('  对应信噪比: %.4f\n', calculate_snr(limiting_magnitude));
end

% 误差函数实现
function y = erf(x)
    % 误差函数近似计算
    y = 2/sqrt(pi) * integral(@(t) exp(-t.^2), 0, x);
end