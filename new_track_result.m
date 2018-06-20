function [track_out,track_line] = new_track_result(track_out,track_line,image_number,dis_range,angle_range)
[m,n]= size(track_out);
for i = 1:length(track_line)
    xt = track_line{i,1};
    yt = track_line{i,2};
    xt(find(xt <= 0)) = [];
    yt(find(yt <= 0)) = [];
    if length(xt) == 1
        P_all = []; P_num = [];
        for j = 1:m
            x = track_out{j,1};
            y = track_out{j,2};
            % 找出在当前帧图像被判断为终止的轨迹线
            if length(x) == image_number 
                % 找出轨迹线长度大于等于 2 的
                if sum(x>0) >= 3
                    % 跳过最后一个点（可以理解为修正方向）再找一次
                    [x1_t,y1_t,~,~,label] = find_different_points(x,y);
                    if label == 0
                        [a,b] = find(x == x1_t & y == y1_t);
                        x_1 = x(1:b(end)); y_1 = y(1:b(end));
                        [x1_t,y1_t,x2_t,y2_t,~] = find_different_points(x_1,y_1);
                        dis = sqrt((x2_t - xt)^2 + (y2_t - yt)^2);
                        if dis <= dis_range
                            theta = calculate_theta_1(x1_t, x2_t, xt, y1_t, y2_t, yt);
                            if theta <= angle_range
                                P = calculate_P(dis_range, angle_range, dis, theta);
                                P_all(1,end+1) = P;
                                P_num(1,end+1) = j;
                            end
                        end
                    end
                end
            end
        end
        if length(P_all) > 0
            [a,b] = find(P_all == max(P_all)); 
            if P_all(b(1)) > 0
                x = track_out{P_num(b(1)),1}; x(end) = xt;
                y = track_out{P_num(b(1)),2}; y(end) = yt;
                track_out{P_num(b(1)),1} = [-1]; 
                track_out{P_num(b(1)),2} = [-1]; 
            end
        end
    end
end

track_out_new = [];
for j = 1:m
    x = track_out{j,1};
    y = track_out{j,2};
    if x(1) >= 0
        track_out_new{end+1, 1} = x;
        track_out_new{end,   2} = y;
    end
end
track_out = track_out_new;