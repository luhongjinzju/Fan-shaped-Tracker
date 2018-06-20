% 三个点的顺序关系(x1, y1)； (x2, y2)； (x3, y3)。
function theta = calculate_theta_1(x1, x2, x3, y1, y2, y3)
a = (x2 - x1).^2 + (y2 - y1).^2;
b = (x3 - x2).^2 + (y3 - y2).^2;
ab = (x2 - x1).* (x3 - x2) + (y2 - y1).* (y3 - y2);
if a == 0
    theta_t = zeros(size(b));
else
    for i = 1:length(b)
        if b(i) == 0
            theta_t(i) = 0;
        else
            d = ab(i)/sqrt(a*b(i));
            theta_t(i) = acosd(d);
        end
    end
end
theta = [];
for i = 1:length(theta_t)
    theta(i,1) = theta_t(i);
end