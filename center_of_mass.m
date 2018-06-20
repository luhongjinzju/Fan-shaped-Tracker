function [x_out, y_out] = center_of_mass(I,x,y,range_ratio,w,m,n)

x_out = 0; y_out = 0;
y_left = max(1, fix(y-range_ratio*w)); y_right  = min(n, fix(y+range_ratio*w));
x_top  = max(1, fix(x-range_ratio*w)); x_bottom = min(m, fix(x+range_ratio*w));
% plot([y_left,y_right,y_right,y_left,y_left],[x_top,x_top,x_bottom,x_bottom,x_top],'g-');
if x_top > x_bottom
    disp('center_of_mass.m 函数中坐标选择有错！');
    pause;
else
    for p = x_top : x_bottom
        x_out = x_out + p * sum(I(p,y_left:y_right));
    end
    x_out = fix(x_out / sum(sum(I(x_top:x_bottom,y_left:y_right))));
%     x_out = x_out / sum(sum(I(x_top:x_bottom,y_left:y_right)));
end
if y_left>y_right
    disp('center_of_mass.m 函数中坐标选择有错！');
    pause;
else
    for p = y_left:y_right
        y_out = y_out + p * sum(I(x_top:x_bottom,p));
    end
    y_out = fix(y_out / sum(sum(I(x_top:x_bottom,y_left:y_right))));
%     y_out = y_out / sum(sum(I(x_top:x_bottom,y_left:y_right)));
end