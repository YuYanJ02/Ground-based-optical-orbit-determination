function eulDeg = quatScalarFirst2ZYX_deg(q)
% STK 四元数 [q1 q2 q3 q4] = [标量 x y z]，转 ZYX 欧拉角 [deg]
q = q / norm(q);
w = q(1); x = q(2); y = q(3); z = q(4);
sinp = 2 * (w * y - z * x);
sinp = max(-1, min(1, sinp));
pitch = asin(sinp);
roll = atan2(2 * (w * x + y * z), 1 - 2 * (x^2 + y^2));
yaw = atan2(2 * (w * z + x * y), 1 - 2 * (y^2 + z^2));
eulDeg = rad2deg([yaw, pitch, roll]);
end