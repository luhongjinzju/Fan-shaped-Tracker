function [track_out,track_line] = tracking_step_4_2(dis_range, angle_range, x1,y1,x2,y2,x3,y3, track_out,track_line,point_candidate,track_line_new,image_number)
%% 追踪算法分步调试:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% step 4　%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 寻找 x1 和 x2 相互之间都有多个匹配点的信息
while length(x1)
    point_num = 1;
    x = point_candidate{point_num,1};
    y = point_candidate{point_num,2};
    if length(x) == 0
        % 当某根轨迹线末端有两个不同点，且在紧邻的下一帧图中找不到合适的候选点时，需要考虑点补充。
        % 这种情况主要有两个原因：
        % 1：两点靠近到一定程度，强度较弱的点被漏检了；
        % 2：两点重叠，只能检测出一个点了。
        xt = track_line{point_num,1};
        yt = track_line{point_num,2};
        track_out{end+1, 1} = [xt -1];
        track_out{end,   2} = [yt -1];
        x1(1) = -1; 
        y1(1) = -1;
        [point_candidate, track_line, x1, y1] = new_data(point_candidate, track_line, x1, y1);
    else
        xc = x(1); yc = y(1);
        [group_p, point_candidate_t] = same_group(xc, yc, point_candidate, point_num, x1);
        if length(group_p) == 0
            xt = track_line{point_num,1};
            yt = track_line{point_num,2};
            track_line_new{end+1,1} = [xt, xc];
            track_line_new{end,2}   = [yt, yc];
            x1(point_num) = [-1];
            y1(point_num) = [-1];
            [a,b] = find(x2 == xc & y2 == yc);
            x2(a(1)) = []; y2(a(1)) = [];
            [point_candidate, track_line, x1, y1] = new_data(point_candidate, track_line, x1, y1);
        else
            x_t = track_line{point_num,1}; y_t = track_line{point_num,2};
            [x1_t,y1_t,x2_t,y2_t,label] = find_different_points(x_t,y_t);
            if label == 0 % 说明轨迹末端有两个不同的点
                theta = calculate_theta_1(x1_t, x2_t, xc, y1_t, y2_t, yc);
                dis = sqrt((x2_t - xc)^2 + (y2_t - yc)^2);
                P_1 = calculate_P(dis_range, angle_range, dis, theta);
                max_P_0 = [];
                for i = 1:length(group_p)
                    x_t = track_line{group_p(i),1}; 
                    y_t = track_line{group_p(i),2};
                    [x1_t,y1_t,x2_t,y2_t,label] = find_different_points(x_t,y_t);
                    x = point_candidate_t{i,1};
                    y = point_candidate_t{i,2};
                    if label == 0
                        [max_p, label_1] = find_max_P_2(dis_range,angle_range,x1_t,y1_t,x2_t,y2_t,x,y);
                    else
                        [label_1,max_p] = find_max_P_1(dis_range,angle_range,x1_t,y1_t,x,y,x3,y3);
                    end    
                     max_P_0(i) = (max_p + P_1)/2;
                end
                max_P_1 = [];
                x_t = track_line{point_num,1}; y_t = track_line{point_num,2};
                [x1_t,y1_t,x2_t,y2_t,label] = find_different_points(x_t,y_t);
                x = point_candidate{point_num,1}; x = x(2:end);
                y = point_candidate{point_num,2}; y = y(2:end);
                [max_p, label_1] = find_max_P_2(dis_range,angle_range,x1_t,y1_t,x2_t,y2_t,x,y);
                for i = 1:length(group_p)
                    x_t = track_line{group_p(i),1}; 
                    y_t = track_line{group_p(i),2};
                    [x1_t,y1_t,x2_t,y2_t,label] = find_different_points(x_t,y_t);
                    if label == 0
                        theta = calculate_theta_1(x1_t, x2_t, xc, y1_t, y2_t, yc);
                        dis = sqrt((x2_t - xc)^2 + (y2_t - yc)^2);
                        P_2 = calculate_P(dis_range, angle_range, dis, theta);
                    else
                        [P_2, label_1] = find_max_P_2(dis_range,angle_range,x1_t,y1_t,xc,yc,x3,y3);
                    end
                    max_P_1(i) = (max_p + P_2)/2;
                end
            else % 说明轨迹线末端只有一个点
                max_P_0 = [];
                [theta_all, dis_all, x3t, y3t] = calculate_theta_all(dis_range, angle_range, x1_t,xc,x3,y1_t,yc,y3);              
                x33 = x3; y33 = y3;
                if length(x3t) == 0
                    P_1 = -20;
                else
                    P = calculate_P(dis_range, angle_range, dis_all, theta_all);
                    P_1 = max(P);
                    [a,b] = find(P == max(P));
                    [a1,b1] = find(x33 == x3t(a(1)) & y33 == y3t(a(1)));
                    x33(a1(1)) = []; y33(a1(1)) = [];
                end
                for i = 1:length(group_p)
                    x_t = track_line{group_p(i),1}; x = point_candidate_t{i,1};
                    y_t = track_line{group_p(i),2}; y = point_candidate_t{i,2};
                    [x1_t,y1_t,x2_t,y2_t,label] = find_different_points(x_t,y_t);
                    if label == 0
                        [P_2, label_1] = find_max_P_2(dis_range,angle_range,x1_t,y1_t,x2_t,y2_t,x,y);
                    else
                        [label_1,P_2] = find_max_P_1(dis_range,angle_range,x1_t,y1_t,x,y,x33,y33);
                    end
                    max_P_0(i) = (P_1 + P_2)/2;
                end
                max_P_1 = []; 
                x_t = track_line{point_num,1}; y_t = track_line{point_num,2};
                [x1_t,y1_t,x2_t,y2_t,label] = find_different_points(x_t,y_t);
                x = point_candidate{point_num,1}; x = x(2:end);
                y = point_candidate{point_num,2}; y = y(2:end);
                [label_1,max_p] = find_max_P_1(dis_range,angle_range,x1_t,y1_t,x,y,x3,y3);
                x33 = x3; y33 = y3;
                if max_p >= 0
                    [theta_all, dis_all, x3t, y3t] = calculate_theta_all(dis_range, angle_range, x1_t,x(label_1),x3,y1_t,y(label_1),y3);  
                    P = calculate_P(dis_range, angle_range, dis_all, theta_all);
                    [a,b] = find(P == max_p);
                    [a1,b1] = find(x33 == x3t(a(1)) & y33 == y3t(a(1)));
                    x33(a1(1)) = []; y33(a1(1)) = [];
                else
                    max_p = -20;
                end
                for i = 1:length(group_p)
                    x_t = track_line{group_p(i),1}; 
                    y_t = track_line{group_p(i),2}; 
                    [x1_t,y1_t,x2_t,y2_t,label] = find_different_points(x_t,y_t);
                    if label == 0
                        theta = calculate_theta_1(x1_t, x2_t, xc, y1_t, y2_t, yc);
                        dis = sqrt((x2_t - xc)^2 + (y2_t - yc)^2);
                        P_2 = calculate_P(dis_range, angle_range, dis, theta);
                    else
                        [label_1,P_2] = find_max_P_1(dis_range,angle_range,x1_t,y1_t,xc,yc,x33,y33);
                    end
                    max_P_1(i) = (max_p + P_2)/2;
                end
            end
            % 存数及更新数据
            [a,b] = find(max_P_1 > max_P_0);
            if length(a) == 0 || length(group_p) == 0
                xt = track_line{point_num,1};
                yt = track_line{point_num,2};
                track_line_new{end+1,1} = [xt, xc];
                track_line_new{end,2}   = [yt, yc];
                x1(point_num) = [-1];
                y1(point_num) = [-1];
                [a,b] = find(x2 == xc & y2 == yc);
                x2(a(1)) = []; y2(a(1)) = [];
                [point_candidate, track_line, x1, y1] = new_data(point_candidate, track_line, x1, y1);
                [point_candidate, x1, y1, track_out, track_line] = new_candidate_data_2(point_candidate, x1, y1, xc, yc,track_out, track_line);
            else
                [a,b] = find(max_P_1 == max(max_P_1));
                group_p = group_p(a(1));
                xt = track_line{group_p(1),1};
                yt = track_line{group_p(1),2};
                track_line_new{end+1,1} = [xt, xc];
                track_line_new{end,2}   = [yt, yc];
                x1(group_p(1)) = [-1];
                y1(group_p(1)) = [-1];
                [a,b] = find(x2 == xc & y2 == yc);
                x2(a(1)) = []; y2(a(1)) = [];
                [point_candidate, track_line, x1, y1] = new_data(point_candidate, track_line, x1, y1);
                [point_candidate, x1, y1, track_out, track_line] = new_candidate_data_2(point_candidate, x1, y1, xc, yc,track_out, track_line);
            end
            
        end
    end
end
%% 追踪算法分步调试:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% step 5　%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while length(x2)
    track_line_new{end+1,1} = [zeros(1,image_number-1) x2(1)];
    track_line_new{end,  2} = [zeros(1,image_number-1) y2(1)];
    x2(1) = [];
    y2(1) = [];
end
track_line = track_line_new;
