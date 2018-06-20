function track_line_new = line_refine_1_1(track_line, dis_range, angle_range)

%% É¾³ıÈßÓàµÄ¹ì¼£Ïß
[m,n] = size(track_line);
% track_line_0 = track_line;
label = 1;
while label > 0
    label = 0;
    for i = 1:m
%         i
        x0 = track_line{i,1}; y0 = track_line{i,2};
        if length(x0) > 1
            for j = 1:m
                if i ~= j 
                    x1 = track_line{j,1}; y1 = track_line{j,2};
                    if length(x1) > 1
                        [a0,b0] = find(x0 > 0 & y0 > 0);
                        [a1,b1] = find(x1 > 0 & y1 > 0);
                        if b0(1) >= b1(1) & b0(end) <= b1(end)
                            x_t_0 = x0(b0); y_t_0 = x0(b0);
                            x_t_1 = x1(b0); y_t_1 = x1(b0);
                            dis = mean(sqrt((x_t_0 - x_t_1).^2 + (y_t_0 - y_t_1).^2));
                            if dis <= 1
                                label = 1;
                                track_line{i,1} = [-1];
                                track_line{i,2} = [-1];
                            end
                        end
                    end
                end
            end
        end
    end
    track_line_new = [];
    for i = 1:m
        x = track_line{i,1};
        y = track_line{i,2};
        if length(x) == 1 & x(1) == -1
            ;
        else
            track_line_new{end+1, 1} = x;
            track_line_new{end,   2} = y;
        end
    end
    track_line = track_line_new;
    [m,n] = size(track_line);
%    m
%    k= k+1
end

