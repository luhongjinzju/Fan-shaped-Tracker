function [point_candidate, x1, y1, track_line, x2, y2] = tracking_step_2_1(point_candidate, x1, y1, x2, y2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% step 2　%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 寻找 x1 中和 x2 只有一个匹配点的信息
track_len = 0; label_t = 1;
while label_t > 0
    label_t = 0;
    for i = 1:length(x1)
        x = point_candidate{i,1};
        y = point_candidate{i,2};
        x_p = []; y_p = [];
        for j = 1:length(x)
            xc = x(j); yc = y(j);
            label = 0;
            for h = 1:length(x1)
                if h ~= i
                    xp = point_candidate{h,1};
                    yp = point_candidate{h,2};
                    [a,b] = find(xp == xc & yp == yc);
                    if length(a) > 0 
                        label = 1;
                        break;
                    end
                end
            end
            if label == 0
                x_p(end+1) = xc; y_p(end+1) = yc;
            end
        end
        if length(x_p) == 1 & length(x) == 1
            label_t = 1;
            track_len = track_len +1;
            track_line{track_len,1} = [x1(i), x_p];
            track_line{track_len,2} = [y1(i), y_p];
            x1(i) = -1; y1(i) = -1;
            [a,b] = find(x2 == x_p & y2 == y_p);
            x2(a(1)) = []; y2(a(1)) = [];
            point_candidate{i,1} = [-1];
            point_candidate{i,2} = [-1];
        end
    end
    % 更新数据：point_candidate；（x1，y1）；（x2，y2）
    xc = 0; yc = 0;
    [point_candidate, x1, y1] = new_compare_data(point_candidate, x1, y1);
end