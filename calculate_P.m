% 三个点的顺序关系(x1, y1)； (x2, y2)； (x3, y3)。
function P = calculate_P(dis_range, angle_range, dis_all, theta_all)
P=[];
[m,n] = size(dis_all);
for i = 1:max(m,n)
    dis = dis_all(i);
    theta = theta_all(i);
    if dis <= dis_range & theta <= angle_range
        P(i,1) = (1-theta*dis^2/(angle_range*dis_range^2))^0.3 * (1-dis/(dis_range+0.0000001))^0.3 * (1-theta/(angle_range+0.0000001))^0.3;
%         P(i,1) = (1-theta*dis^2/(angle_range*dis_range^2))^0.3 * (1-dis/(dis_range+0.0000001))^0.3;
    else
        P(i,1) = -20;
    end
end
    
