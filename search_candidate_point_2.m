function [point_candidate, track_out, track_line, x1,y1] = search_candidate_point_2(dis_range, angle_range,x2,y2,x3,y3,track_out,track_line)

point_candidate = []; x1 = []; y1 = [];
% for i = 1:length(track_line)
for i = 1:length(track_line)
    x = track_line{i,1}; y = track_line{i,2};
    [a,b] = find(x > 0);
    x_t = x(b); y_t = y(b);
    [x1_t,y1_t,x2_t,y2_t,label_1] = find_different_points(x_t,y_t);
    if label_1 == 0
        [~, ~, x2t_1, y2t_1] = calculate_theta_all(dis_range, angle_range, x1_t,x2_t,x2,y1_t,y2_t,y2);
        [a,b] = find(x_t == x1_t & y_t == y1_t);  
        x_t = x_t(1:b(end)); y_t = y_t(1:b(end));
        [x1_t,y1_t,x2_t,y2_t,label_2] = find_different_points(x_t,y_t);
        if label_2 == 0 
            [~, ~, x2t_2, y2t_2] = calculate_theta_all(dis_range, angle_range, x1_t,x2_t,x2,y1_t,y2_t,y2);
        else
            [point_candidate_t, track_out, x1_1,~] = search_candidate_point_1(dis_range, angle_range,x_t(end),y_t(end),x2,y2,x3,y3,track_out);
            if length(x1_1) == 0
                x2t_2 = []; y2t_2 = [];
            else
                x2t_2 = point_candidate_t{1,1};
                y2t_2 = point_candidate_t{1,2};
            end
        end
        
        if length(x2t_1) == 0 & length(x2t_2) == 0
            track_out{end+1,1} = [x, -1];
            track_out{end,  2} = [y, -1];
            track_line{i,1} = -1;
            track_line{i,2} = -1;
        else
            x1(end+1,1) = x(end);     y1(end+1,1) = y(end);
            x_o = x2t_1; y_o = y2t_1;
            for j = 1:length(x2t_2)
                [a,b] = find(x2t_1 == x2t_2(j) & y2t_1 == y2t_2(j));
                if length(a) == 0 
                    x_o(end+1) = x2t_2(j);
                    y_o(end+1) = y2t_2(j);
                end
            end
            point_candidate{end+1, 1} = x_o;
            point_candidate{end,   2} = y_o;
        end
        
    else
        [point_candidate_t, track_out, x1_1,~] = search_candidate_point_1(dis_range, angle_range,x(end),y(end),x2,y2,x3,y3,track_out);
        if length(x1_1) == 0
            track_out{end+1,1} = [x, -1];
            track_out{end,  2} = [y, -1];
            track_line{i,1} = -1;
            track_line{i,2} = -1;
        else
            x1(end+1,1) = x(end);     y1(end+1,1) = y(end);
            point_candidate{end+1, 1} = point_candidate_t{1,1};
            point_candidate{end,   2} = point_candidate_t{1,2};
        end
    end
end

%% ¸üĞÂ track_line
track_line_t = [];
for i = 1:length(track_line)
    x = track_line{i,1};
    if x(1) > -1
        track_line_t{end+1, 1} = track_line{i,1};
        track_line_t{end,   2} = track_line{i,2};
    end
end
track_line = track_line_t; 