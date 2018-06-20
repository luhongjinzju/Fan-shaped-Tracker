function [x1,y1,x2,y2,label] = find_different_points(x,y)
% label = 0: 表示在矩阵x 和 y 中能找到和最后一个点坐标不同的点（也就是能在坐标序列x，y 中找到最近的一个和x(end),y(end)不同的点）
% label = 1: 表示在矩阵x 和 y 中只有一个不同位置的点

label = 0;

xt = x(find(x > 0));   yt = y(find(y > 0));
x2 = xt(end);          y2 = yt(end);

if length(xt) == 1
    label = 1;
    x1 = xt(end);   y1 = yt(end);
else
    for k = length(xt)-1 : -1 : 1
        x1 = xt(k);   y1 = yt(k);
        if (x1 ~= x2 || y1 ~= y2) 
            break;
        end
    end
    if x1 == x2 & y1 == y2
        label = 1;
    end
end