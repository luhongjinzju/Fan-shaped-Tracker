function [xt_1, yt_1] = rectangle_intensity(dis_range,theta_range,x1_t,y1_t,x2_t,y2_t,I,w,track_line,line_num,j,xx,yy)
x = track_line{(line_num(j)),1};
y = track_line{(line_num(j)),2};
x1 = x(end);  y1 = y(end);

xx(find(yy <= 0 )) = []; yy(find(yy <= 0 )) = [];
yy(find(xx <= 0 )) = []; xx(find(xx <= 0 )) = []; 
% figure;imshow(I,[]);hold on
% plot(y1,x1,'r*');
% plot(y2_t,x2_t,'r*');

[m,n] = size(I);

if x1 < x2_t
    x_p = [x1, x2_t]; y_p = [y1, y2_t];
    p = polyfit(x_p,y_p,1);
    x = max(0,x_p(1)-w) : 0.1 : min(x_p(2)+w,m); 
    y = p(1)*x + p(2);
    x(find(y<=0)) = []; y(find(y<=0)) = [];
    x(find(y>n)) = []; y(find(y>n)) = [];
end
if x1 > x2_t
    x_p = [x2_t, x1]; y_p = [y2_t, y1];
    p = polyfit(x_p,y_p,1);
    x = max(0,x_p(1)-w) : 0.1 : min(x_p(2)+w,m); 
    y = p(1)*x + p(2); 
    x(find(y<=0)) = []; y(find(y<=0)) = [];
    x(find(y>n)) = []; y(find(y>n)) = [];
end
if x1 == x2_t
    y = max(1,min(y1,y2_t)-w):1:min(n,max(y1,y2_t)+w);
    x = ones(1,length(y)) * x1;
end
% 确定矩形采样区域
x_top = max(1,floor(min(x))); x_bottom = min(m,round(max(x))); 
if x_bottom - x_top < w
    delta = (w - (x_bottom - x_top))/2;
    x_top = max(1,floor(x_top-delta));
    x_bottom = min(m,round(x_bottom+delta));
end
y_left = max(1,floor(min(y))); y_right = min(n,round(max(y)));
if y_right - y_left < w
    delta = (w - (y_right - y_left))/2;
    y_left = max(1,floor(y_left-delta));
    y_right = min(n,round(y_right+delta));
end
% plot([y_left,y_right,y_right,y_left,y_left],[x_top,x_top,x_bottom,x_bottom,x_top],'g-');
% hold off;

max_intensity = [];
if x_bottom - x_top >= y_right - y_left
    for i = x_top : x_bottom
        intensity = I(i,y_left:y_right);
        max_intensity(end+1) = max(intensity);
    end
    diff_intensity = diff(max_intensity);
%     figure;plot(max_intensity,'r*-'); hold on; grid on; title('max_intensity'); hold off
%     figure;plot(diff_intensity,'g*-'); hold on; grid on; title('diff_intensity');hold off
    turn = 0; turn_num = [];
    diff_star = diff_intensity(1);
    for i = 2:length(diff_intensity)
        if diff_star*diff_intensity(i) < 0 
            turn_num(end+1) = i;
            turn = turn + 1;
            diff_star = diff_intensity(i);
        end
    end
    xt_1 = [];yt_1 = [];
    if turn > 1 % 说明至少有两个转折点，所以至少两个波峰(波峰，波谷，波峰，波谷，波峰...)
        % 取出波峰对应的坐标
        for i = 1:length(turn_num)
            if max_intensity(turn_num(i)) >= max_intensity(turn_num(i)-1) & max_intensity(turn_num(i)) >= max_intensity(turn_num(i)+1)
                xt_1(end+1) = x_top + turn_num(i)-1;
                intensity = I(xt_1(end),y_left:y_right);
                [~,b] = find(intensity == max(intensity));
                yt_1(end+1) = y_left + b(1)-1;
            end
        end
        % 检验这些坐标点代表的目标光斑是否已经被检测出来了。
    else
        if turn == 1
            if max_intensity(turn_num(1)) >= max_intensity(turn_num(1)-1) & max_intensity(turn_num(1)) >= max_intensity(turn_num(1)+1)
                xt_1 = x_top + turn_num(1)-1;
                intensity = I(xt_1(1),y_left:y_right);
                [~,b] = find(intensity == max(intensity));
                yt_1 = y_left + b(1)-1;
            else
                xt_1 = [x_top,  x_bottom];
                intensity = I(xt_1(1),y_left:y_right);
                [~,b] = find(intensity == max(intensity));
                yt_1(1) = y_left + b(1)-1;
                intensity = I(xt_1(2),y_left:y_right);
                [~,b] = find(intensity == max(intensity));
                yt_1(2) = y_left + b(1)-1;
            end
        else
            if max_intensity(1) >= max_intensity(end)
                xt_1 = x_top;
            else
                xt_1 = x_bottom;
            end
            intensity = I(xt_1(1),y_left:y_right);
            [~,b] = find(intensity == max(intensity));
            yt_1 = y_left + b(1)-1;
        end
    end        
else
    for i = y_left:y_right
        intensity = I(x_top:x_bottom,i);
        max_intensity(end+1) = max(intensity);
    end
    diff_intensity = diff(max_intensity);
%     figure;plot(max_intensity,'r*-'); hold on; grid on; title('max_intensity'); hold off
%     figure;plot(diff_intensity,'g*-'); hold on; grid on; title('diff_intensity');hold off
    turn = 0; turn_num = [];
    diff_star = diff_intensity(1);
    for i = 2:length(diff_intensity)
        if diff_star*diff_intensity(i) < 0 
            turn_num(end+1) = i;
            turn = turn + 1;
            diff_star = diff_intensity(i);
        end
    end
    xt_1 = [];yt_1 = [];
    if turn > 1 % 说明至少有两个转折点，所以至少两个波峰(波峰，波谷，波峰，波谷，波峰...)
        % 取出波峰对应的坐标
        for i = 1:length(turn_num)
            if max_intensity(turn_num(i)) >= max_intensity(turn_num(i)-1) & max_intensity(turn_num(i)) >= max_intensity(turn_num(i)+1)
                yt_1(end+1) = y_left + turn_num(i)-1;
                intensity = I(x_top:x_bottom,yt_1(end));
                [a,~] = find(intensity == max(intensity));
                xt_1(end+1) = x_top + a(1)-1;
            end
        end
        % 检验这些坐标点代表的目标光斑是否已经被检测出来了。
    else
        if turn == 1
            if max_intensity(turn_num(1)) >= max_intensity(turn_num(1)-1) & max_intensity(turn_num(1)) >= max_intensity(turn_num(1)+1)
                yt_1 = y_left + turn_num(1)-1;
                intensity = I(x_top:x_bottom,yt_1);
                [a,~] = find(intensity == max(intensity));
                xt_1 = x_top + a(1)-1;
            else
                yt_1 = [y_left,  y_right];
                intensity = I(x_top:x_bottom,yt_1(1));
                [a,~] = find(intensity == max(intensity));
                xt_1(1) = x_top + a(1)-1;
                intensity = I(x_top:x_bottom,yt_1(2));
                [a,~] = find(intensity == max(intensity));
                xt_1(2) = x_top + a(1)-1;
            end
        else
            if max_intensity(1) >= max_intensity(end)
                yt_1 = y_left;
            else
                yt_1 = y_right;
            end
            intensity = I(x_top:x_bottom,yt_1(1));
            [a,~] = find(intensity == max(intensity));
            xt_1 = x_top + a(1)-1;
        end
    end     
end

%% 波峰候选点优化（根据剩余的 xt_1 的点情况进行点补偿）
% 删除被当前轨迹线末端占用的点
if length(xt_1) > 0
    dis = sqrt((xt_1 - x1).^2 + (yt_1 - y1).^2);
    [~,a] = sort(dis);
    xt_1 = xt_1(a); yt_1 = yt_1(a);
    xt_1(1) = []; yt_1(1) = [];
end
% 删除 xt_1 中不可能是这根 track_out 轨迹线的候选点的点
if length(xt_1) > 0 
%     xx(find(yy <= 0 )) = []; yy(find(yy <= 0 )) = [];
%     yy(find(xx <= 0 )) = []; xx(find(xx <= 0 )) = []; 
    for i = 1:length(xt_1)
        [max_p, label_1] = find_max_P_2(dis_range,45,xx(round(length(xx)/2)),yy(round(length(xx)/2)),x2_t,y2_t,xt_1(i),yt_1(i));
        if max_p < 0 
            xt_1(i) = -1; yt_1(i) = -1;
        end
    end
    xt_1(find(xt_1 <= 0)) = [];
    yt_1(find(yt_1 <= 0)) = [];
end
% 删除那些已被别的轨迹线末端占用的点
if length(xt_1) > 1
    for i = 1:length(line_num)
        if i ~= j
            if length(xt_1) > 0
                x = track_line{(line_num(i)),1};
                y = track_line{(line_num(i)),2};
                dis = sqrt((xt_1 - x(end)).^2 + (yt_1 - y(end)).^2);
                [dis,a] = sort(dis);
                if dis(1) <= 1
                    xt_1 = xt_1(a); yt_1 = yt_1(a);
                    xt_1(1) = []; yt_1(1) = [];
                end
            end
        end
    end
end

%% 根据剩余的 xt_1 的个数来进行点补偿
% (x2_t,y2_t) 是这根 track_out 轨迹线的最后一个点
if length(xt_1) > 0 
    [max_p, label_1] = find_max_P_2(dis_range,theta_range,xx(round(length(xx)/2)),yy(round(length(xx)/2)),x2_t,y2_t,xt_1,yt_1);
    xt_1 = xt_1(label_1); yt_1 = yt_1(label_1);
else   % 没有合适的波峰值了，考虑这根 track_out 轨迹线在该帧图像上的灰度值灰度值分布情况
    intensity = [];
    for i = 1:length(xx)
        intensity(i) = I(xx(i), yy(i));
    end
    [a,b] = find(intensity(end) > intensity(1:end-1));
    ratio = length(a)/length(xx);
    if ratio > 0.6
%         ratio_1 = I(xx(end),yy(end))/I(x1,y1);
%         ratio_2 = I(x1,y1)/I(xx(end),yy(end));
%         if ratio_2 >= 0.65 || ratio_1 >= 0.65
%             xt_1 = x1; yt_1 = y1;
%         else
            xt_1 = xx(end); yt_1 = yy(end);
%         end
    end
end
% 
% % (x2_t, y2_t) 是这根 track_out 轨迹线的最后一个点
% % (xt_1, yt_1) 是根据波峰情况筛选出的可能的候选点坐标
% if  length(xt_1) == 1
%     ratio_1 = I(x2_t,y2_t)/I(xt_1,yt_1);
%     ratio_2 = I(xt_1,yt_1)/I(x2_t,y2_t);
%     if ratio_1 < 0.5 || ratio_2 < 0.5
%         ;
%     else
%         dis = sqrt((xt_1 - x2_t)^2 + (yt_1 - y2_t)^2);
%         theta = calculate_theta_1(x1_t, x2_t, xt_1, y1_t, y2_t, yt_1);
%         P = calculate_P(dis_range, angle_range, dis, theta);
%         if P < 0 
%             xt_1 = x2_t;
%             yt_1 = y2_t;
%         end
%     end
% end
% 



