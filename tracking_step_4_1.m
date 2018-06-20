function [track_out,track_line] = tracking_step_4_1(dis_range, angle_range, x1,y1,x2,y2,x3,y3, track_out,track_line,point_candidate)
%% 追踪算法分步调试:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% step 4　%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 寻找 x1 和 x2 相互之间都有多个匹配点的信息
while length(x1)
    point_num = 1;
    x = point_candidate{point_num,1};
    y = point_candidate{point_num,2};
    if length(x) == 0
        track_out{end + 1, 1} = [x1(point_num) -1];
        track_out{end, 2} = [y1(point_num) -1];
        x1(1) = -1; 
        y1(1) = -1;
        [point_candidate, x1, y1] = new_compare_data(point_candidate, x1, y1);
    else
        xc = x(1); yc = y(1);
        [group_p, point_candidate_t] = same_group(xc, yc, point_candidate, point_num, x1);
        if length(group_p) == 0
             track_line{end+1,1} = [x1(point_num), xc];
             track_line{end,2}   = [y1(point_num), yc];
             x1(point_num) = [-1];
             y1(point_num) = [-1];
             [a,b] = find(x2 == xc & y2 == yc);
             x2(a(1)) = []; y2(a(1)) = [];
             [point_candidate, x1, y1] = new_compare_data(point_candidate, x1, y1);
        else
            [theta_all, dis_all, x3t, y3t] = calculate_theta_all(dis_range, angle_range, x1(point_num),xc,x3,y1(point_num),yc,y3);
            P = calculate_P(dis_range, angle_range, dis_all, theta_all);
            x33 = x3; y33 = y3;
            if max(P) < 0
                P_1 = -20;
            else
                P_1 = max(P);
                [a,b] = find(P == max(P));
                [a1,b1] = find(x33 == x3t(a(1)) & y33 == y3t(a(1)));
                x33(a1(1)) = []; y33(a1(1)) = [];
            end
            max_P_0 = [];
            for i = 1:length(group_p)
                x = point_candidate_t{i,1};
                y = point_candidate_t{i,2};
                [label_1,max_p] = find_max_P_1(dis_range,angle_range,x1(group_p(i)),y1(group_p(i)),x,y,x33,y33);
                max_P_0(i) = (max_p + P_1)/2;
            end
            max_P_1 = []; 
            for i = 1:length(group_p)
                [theta_all, dis_all, x3t, y3t] = calculate_theta_all(dis_range, angle_range, x1(group_p(i)),xc,x3,y1(group_p(i)),yc,y3);
                P = calculate_P(dis_range, angle_range, dis_all, theta_all);
                x33 = x3; y33 = y3;
                if max(P) < 0
                    P_2 = -20;
                else
                    P_2 = max(P);
                    [a,b] = find(P == max(P));
                    [a1,b1] = find(x33 == x3t(a(1)) & y33 == y3t(a(1)));
                    x33(a1(1)) = []; y33(a1(1)) = [];
                end
                x = point_candidate_t{point_num,1}; x = x(2:end);
                y = point_candidate_t{point_num,2}; y = y(2:end);
                [label_1,max_p] = find_max_P_1(dis_range,angle_range,x1(point_num),y1(point_num),x,y,x33,y33);
                max_P_1(i) = (max_p + P_2)/2;
            end       
            [a,b] = find(max_P_1 > max_P_0);
            if length(a) == 0
                track_line{end+1,1} = [x1(point_num), xc];
                track_line{end,2}   = [y1(point_num), yc];
                x1(point_num) = [-1];
                y1(point_num) = [-1];
                [a,b] = find(x2 == xc & y2 == yc);
                x2(a(1)) = []; y2(a(1)) = [];
                [point_candidate, x1, y1] = new_compare_data(point_candidate, x1, y1);
                [point_candidate, x1, y1, track_out] = new_candidate_data(point_candidate, x1, y1, xc, yc,track_out);
            else
                [a,b] = find(max_P_1 == max(max_P_1));
                group_p = group_p(a(1));
                track_line{end+1,1} = [x1(group_p(1)), xc];
                track_line{end,2}   = [y1(group_p(1)), yc];
                x1(group_p(1)) = [-1];
                y1(group_p(1)) = [-1];
                [a,b] = find(x2 == xc & y2 == yc);
                x2(a(1)) = []; y2(a(1)) = [];
                [point_candidate, x1, y1] = new_compare_data(point_candidate, x1, y1);
                [point_candidate, x1, y1, track_out] = new_candidate_data(point_candidate, x1, y1, xc, yc,track_out);
            end
        end
    end
end
%% 追踪算法分步调试:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% step 5　%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while length(x2)
    track_line{end+1,1} = [0 x2(1)];
    track_line{end,  2} = [0 y2(1)];
    x2(1) = [];y2(1) = [];
end
