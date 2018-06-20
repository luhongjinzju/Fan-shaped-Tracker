function track_line_new = line_refine_2_1(track_line, dis_range, angle_range,w)

%% 补连可能断裂了的轨迹线
[m,n] = size(track_line);
for gap_label = 3
    gap_label
    label_t = 1;
    while label_t > 0
        label_t = 0;
        for i = 1:m
            x0 = track_line{i,1}; y0 = track_line{i,2};
            [a0,b0] = find(x0 > 0 & y0 > 0);
            if length(a0) > 0
                for j = 1:m
                    label = 0;
                    if i ~= j
                        x1 = track_line{j,1}; y1 = track_line{j,2};
                        [a1,b1] = find(x1 > 0 & y1 > 0);
                        if length(a1) > 0
                            if b0(1) > b1(end) & (abs(b0(1) - b1(end)) <= gap_label) % (x0,y0) 可能可以插在(x1,y1)后面
                                label = 1;
                                if length(b0) == 1
                                    x_t_2 = [x0(b0(1)) x0(b0(1))]; 
                                    y_t_2 = [y0(b0(1)) y0(b0(1))];
                                else
                                    x_t_2 = [x0(b0(1)) x0(b0(2))];
                                    y_t_2 = [y0(b0(1)) y0(b0(2))];
                                end
                                if length(b1) == 1
                                    x_t_1 = [x1(b1(end)) x1(b1(end))];
                                    y_t_1 = [y1(b1(end)) y1(b1(end))];
                                else
                                    x_t_1 = [x1(b1(end-1)) x1(b1(end))];
                                    y_t_1 = [y1(b1(end-1)) y1(b1(end))];
                                end
                                
                            else
                                if b0(end) < b1(1) & (abs(b0(end) - b1(1)) < 5) % (x0,y0) 可能可以插在(x1,y1)前面
                                    label = 2;
                                    if length(b0) == 1
                                        x_t_1 = [x0(b0(end))   x0(b0(end))]; 
                                        y_t_1 = [y0(b0(end))   y0(b0(end))];
                                    else
                                        x_t_1 = [x0(b0(end-1)) x0(b0(end))];
                                        y_t_1 = [y0(b0(end-1)) y0(b0(end))];
                                    end
                                    if length(b1) == 1
                                        x_t_2 = [x1(b1(1)) x1(b1(1))];
                                        y_t_2 = [y1(b1(1)) y1(b1(1))];
                                    else
                                        x_t_2 = [x1(b1(1)) x1(b1(2))];
                                        y_t_2 = [y1(b1(1)) y1(b1(2))];
                                    end
                                end
                            end
                            if label > 0
                                x_t = [x_t_1 x_t_2];
                                y_t = [y_t_1 y_t_2];  
                                dis = sqrt((x_t(2) - x_t(3))^2 + (y_t(2) - y_t(3))^2);           
                                if dis <= dis_range
                                    theta0 = calculate_theta_1(x_t(1), x_t(2), x_t(3), y_t(1), y_t(2), y_t(3));
                                    theta1 = calculate_theta_1(x_t(2), x_t(3), x_t(4), y_t(2), y_t(3), y_t(4));
                                    if theta0 <= angle_range || theta1 <= angle_range
                                        x0(b1) = x1(b1);      y0(b1) = y1(b1);
                                        if label == 1
                                            dtx = (x0(b0(1)) - x1(b1(end)))/(b0(1) - b1(end));
                                            dty = (y0(b0(1)) - y1(b1(end)))/(b0(1) - b1(end));
                                            for k = b1(end)+1 : b0(1)-1
                                                x0(k) = dtx * (k - b1(end)) + x1(b1(end));
                                                y0(k) = dty * (k - b1(end)) + y1(b1(end));
                                            end
                                        else
                                            dtx = (x1(b1(1)) - x0(b0(end)))/(b1(1) - b0(end));
                                            dty = (y1(b1(1)) - y0(b0(end)))/(b1(1) - b0(end));
                                            for k = b0(end)+1 : b1(1)-1
                                                x0(k) = dtx * (k - b0(end)) + x0(b0(end));
                                                y0(k) = dty * (k - b0(end)) + y0(b0(end));
                                            end
                                        end
                                        label_t = 1;
                                        track_line{i,1} = x0; track_line{i,2} = y0;
                                        track_line{j,1} = [-1]; track_line{j,2} = [-1];
                                    end
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
        m
    end
end

