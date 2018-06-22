% (x,y) �켣�����е����ꣻ(xc,yc) ��ѡ������
function P = xc_yc_line2who(dis_range, angle_range,x,y,xc,yc,x3,y3)
x(find(y <= 0)) = []; y(find(y <= 0)) = [];
y(find(x <= 0)) = []; x(find(x <= 0)) = [];
% x11 = x(end-1) ; x22 = x(end);
[x11,y11,x22,y22,~] = find_different_points(x,y);
[theta, dis, ~, ~] = calculate_theta_all(dis_range, angle_range, x11,x22,xc,y11,y22,yc);
P_pn_1 = calculate_P(dis_range, angle_range, dis, theta);

% �켣��ǰ��һ�����    
[~,b] = find(x(1:end-1) ~= x(end));
if length(b) > 0
    xt = x(1:b(end)); yt = y(1:b(end));
    [x11,y11,x22,y22,~] = find_different_points(xt,yt);
    [theta, dis, ~, ~] = calculate_theta_all(dis_range, angle_range, x11,x22,xc,y11,y22,yc);
    P_pn_2 = calculate_P(dis_range, angle_range, dis, theta);
else
    P_pn_2 = -20;
end

% �켣�����һ����� (xc,yc) ��ѡ�� �Լ� x3 ��ɵļн�
[~, ~, x3t, y3t] = calculate_theta_all(dis_range, angle_range, x(end),xc,x3,y(end),yc,y3);
if length(x3t) == 0 
    P_pn_1 = P_pn_1 - 20;
else
    [~,max_p] = find_max_P_1(dis_range,angle_range,x(end),y(end),xc,yc,x3t,y3t);
    P_pn_1 = P_pn_1 + max_p;
end

% �켣��ǰ��һ������ (xc,yc) ��ѡ�� �Լ� x3 ��ɵļн�
if length(b) > 0
    [~, ~, x3t, y3t] = calculate_theta_all(dis_range, angle_range, x22,xc,x3,y22,yc,y3);
    if length(x3t) == 0 
        P_pn_2 = P_pn_2-20;
    else
        [~,max_p] = find_max_P_1(dis_range,angle_range,x22,y22,xc,yc,x3t,y3t);
        P_pn_2 = P_pn_2 + max_p;
    end
else
    P_pn_2 = P_pn_2-20;
end

% ѡ����С�ļн�
if P_pn_1 < P_pn_2
    P = P_pn_2/2;
else
    P = P_pn_1/2;
end