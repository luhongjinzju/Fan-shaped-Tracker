function [x1,y1,x2,y2,label] = find_different_points(x,y)
% label = 0: ��ʾ�ھ���x �� y �����ҵ������һ�������겻ͬ�ĵ㣨Ҳ����������������x��y ���ҵ������һ����x(end),y(end)��ͬ�ĵ㣩
% label = 1: ��ʾ�ھ���x �� y ��ֻ��һ����ͬλ�õĵ�

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