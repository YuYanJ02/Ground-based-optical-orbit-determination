function [RelOmega,RelDis] = Calculate_RelOmega(Obs,Tar)
%% 相对线角速度计算函数
% 功能：计算瞬时相对线角速度
% 输入：输入观测卫星及目标卫星的运动状态和相机参数
% 输出：该运动状态下的相对线角速度

% 计算相对线角速度
RelPos = Obs(1:3) - Tar(1:3);
RelDis = norm(RelPos);
RelVel = Obs(4:6) - Tar(4:6);
RelVel_line = sin( acos(dot(RelVel , RelPos)/ norm(RelPos)/norm(RelVel))) * norm(RelVel);
RelOmega = RelVel_line/ norm(RelPos) * 206265 ;

end