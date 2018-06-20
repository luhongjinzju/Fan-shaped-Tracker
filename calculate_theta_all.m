function [theta_all, dis_all, x3, y3] = calculate_theta_all(dis_range, angle_range, x1,x2,x3,y1,y2,y3)

dis = sqrt((x3 - x2).^2 + (y3 - y2).^2);
x3(find(dis > dis_range)) = [];
y3(find(dis > dis_range)) = [];
dis(find(dis > dis_range)) = [];

if length(x3) == 0
    theta_all = 500;
    dis_all = 500;
else
    theta = calculate_theta_1(x1, x2, x3, y1, y2, y3);
    x3(find(theta > angle_range)) = [];
    y3(find(theta > angle_range)) = [];
    dis(find(theta > angle_range)) = [];
    theta(find(theta > angle_range)) = [];
    if length(x3) == 0
        theta_all = 500;
        dis_all = 500;
    else
        theta_all = theta;
        dis_all = dis;
    end
end



    