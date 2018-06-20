function [label_1,max_p] = find_max_P_1(dis_range,angle_range,x1,y1,x,y,x3,y3)
label_1 = 0;max_p = -20;
for j = 1:length(x)
    [theta_all, dis_all, x3, y3] = calculate_theta_all(dis_range, angle_range, x1,x(j),x3,y1,y(j),y3);
    P1 = calculate_P(dis_range, angle_range, dis_all, theta_all);
    if max(P1) > max_p
        max_p = max(P1);
        label_1 = j;
    end
end