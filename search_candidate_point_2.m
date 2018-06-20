function [point_candidate, track_out, track_line, x1,y1] = search_candidate_point_2(dis_range, angle_range,x2,y2,x3,y3,track_out,track_line)

point_candidate = []; x1 = []; y1 = [];
% for i = 1:44
for i = 1:length(track_line)
%     i = i + 1
    x = track_line{i,1}; y = track_line{i,2};
    [a,b] = find(x > 0);
    if length(a) > 1
        [x1_t,y1_t,x2_t,y2_t,label] = find_different_points(x,y);
        [~, ~, x2t, y2t] = calculate_theta_all(dis_range, angle_range, x1_t,x2_t,x2,y1_t,y2_t,y2);
%         x1_t = x(end-1); y1_t = y(end-1);
%         x2_t = x(end);   y2_t = y(end);
        if length(x2t) == 0   
            [x1_t,y1_t,x2_t,y2_t,label] = find_different_points(x(1:end-1),y(1:end-1));
            if label == 1
                 [point_candidate_t, track_out, x1_1,~] = search_candidate_point_1(dis_range, angle_range,x(end),y(end),x2,y2,x3,y3,track_out);
                 if length(x1_1) == 0
                     track_out{end,1} = [x, -1];
                     track_out{end,2} = [y, -1];
                     track_line{i,1} = -1;
                     track_line{i,2} = -1;
                 else
                     x1(end+1,1) = x(end);     y1(end+1,1) = y(end);
                     point_candidate{end+1, 1} = point_candidate_t{1,1};
                     point_candidate{end,   2} = point_candidate_t{1,2};
                 end
            else
                [~, ~, x2t, y2t] = calculate_theta_all(dis_range, angle_range, x1_t,x2_t,x2,y1_t,y2_t,y2);
                if length(x2t) == 0   
                    track_out{end+1,1} = [x, -1];
                    track_out{end,  2} = [y, -1];
                    track_line{i,1} = -1;
                    track_line{i,2} = -1;
                else
                    x1(end+1,1) = x2_t; y1(end+1,1) = y2_t;
                    point_candidate{end+1, 1} = x2t;
                    point_candidate{end,   2} = y2t;
                end
            end
            
            
        else
            x1(end+1,1) = x2_t; y1(end+1,1) = y2_t;
            point_candidate{end+1, 1} = x2t;
            point_candidate{end,   2} = y2t;
        end
    else
        [point_candidate_t, track_out, x1_1,~] = search_candidate_point_1(dis_range, angle_range,x(end),y(end),x2,y2,x3,y3,track_out);
         if length(x1_1) == 0
             track_out{end,1} = [x, -1];
             track_out{end,2} = [y, -1];
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
