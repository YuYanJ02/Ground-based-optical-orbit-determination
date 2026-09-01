function [M,phaseAngle,MoonPhaseAngle,MoonExclusion] = Calculate_Mag(SunPos,ObsPos,TarPos,MoonPos)
%% 目标星等计算函数
% 功能：计算多目标瞬时星等
% 输入：输入太阳、观测卫星及目标卫星的状态
% 输出：该几何状态下的目标星等

    % 定义目标类型
    Arhou = [0.3; 0.4;0.5;0.6] ;    % 有效反射面积
    aspec = [0.1;0.2;0.7;0.9];    % 镜面反射系数
    adiff = [0.9;0.8;0.3;0.1];    % 漫反射系数
    R_Earth = 6373;
            
    % 计算相对几何
    Pos_Tar2Obs = TarPos - ObsPos;        
    Dis_Tar2Obs = norm(Pos_Tar2Obs);         

    Pos_Moon2Obs = MoonPos - ObsPos;      
    Dis_Moon2Obs = norm(Pos_Moon2Obs);

    Pos_Sun2Obs = SunPos - ObsPos;        
    Dis_Sun2Obs = norm(Pos_Sun2Obs);

    Pos_Earth2Obs = [0 0 0] - ObsPos;        
    Dis_Earth2Obs = norm(Pos_Earth2Obs);

    Pos_Sun2Tar = SunPos - TarPos;        
    Dis_Sun2Tar = norm(Pos_Sun2Tar);

    Pos_Sun2Moon = SunPos - MoonPos;
    Dis_Sun2Moon = norm(Pos_Sun2Moon);

    Pos_Sun2Earth = SunPos - [0 0 0];
    Dis_Sun2Earth = norm(Pos_Sun2Earth);

    Pos_Tar2Moon = TarPos - MoonPos;
    Dis_Tar2Moon = norm(Pos_Tar2Moon);


    % 计算月球相角
    MoonPhaseAngle = acos(dot(SunPos,MoonPos)./norm(SunPos)./norm(MoonPos))*180/pi;


    % 计算排除角
    SunExclusion = acos(dot(Pos_Sun2Obs,Pos_Tar2Obs)./Dis_Sun2Obs./Dis_Tar2Obs)*180/pi;

    MoonExclusion = acos(dot(Pos_Moon2Obs,Pos_Tar2Obs)./Dis_Moon2Obs./Dis_Tar2Obs)*180/pi;

    % EarthExclusion = abs(acosd(dot(Pos_Earth2Obs,Pos_Tar2Obs)./Dis_Earth2Obs./Dis_Tar2Obs));
    EarthExclusion = 180;
    
  
    % 计算遮挡角
    FaiOcc = asin(R_Earth/Dis_Earth2Obs)*180/pi;
    d1 = dot(Pos_Earth2Obs,Pos_Tar2Obs) ./ Dis_Tar2Obs;

    % 计算光线方位
    AngleSunlight = asin(R_Earth/Dis_Sun2Earth);
    FaiSunEarthTar = acos(dot(Pos_Sun2Tar,Pos_Sun2Earth)./Dis_Sun2Tar./Dis_Sun2Earth);
    d2 = dot(Pos_Sun2Earth,Pos_Sun2Tar) ./ Dis_Sun2Tar;

    % 判定几何条件
    index = (SunExclusion> 30).*(MoonExclusion > 3).*(EarthExclusion > 10).*(EarthExclusion > FaiOcc || d1 > Dis_Tar2Obs).*(FaiSunEarthTar > AngleSunlight || d2 > Dis_Sun2Tar);

    M = zeros(4,1);
    count = 0;
    phaseAngle = acos(dot(Pos_Sun2Tar,-Pos_Tar2Obs) ./ Dis_Sun2Tar ./ Dis_Tar2Obs);
    for i = 1:4

            % 计算视星等
            count = count + 1;
            
            pdiff = 2 * (sin(phaseAngle) + (pi-phaseAngle) .* cos(phaseAngle)) / 3 / pi^2;
            M(count) = (-26.74 - 2.5 * log10(Arhou(i)*(aspec(i)/4/pi + adiff(i)*pdiff) ./ (Dis_Tar2Obs.^2 * 1000^2 ))).*index;
            if M(count)==0
                M(count) = NaN;
            end

    end
            
end
