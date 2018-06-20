function [max_p, label_1] = find_max_P_2(dis_range,angle_range,x1,y1,x2,y2,x,y)
max_p = -20;
label_1 = 0;
for i = 1:length(x)
    theta = calculate_theta_1(x1,x2,x(i),y1,y2,y(i));
    dis = sqrt((x2-x(i))^2 + (y2-y(i))^2);
    P = calculate_P(dis_range, angle_range, dis, theta);
    if P > max_p
        max_p = P;
        label_1 = i;
    end
end