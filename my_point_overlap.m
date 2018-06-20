function [track_out,track_line] = my_point_overlap(Image_data, dis_range, angle_range,track_out,track_line,image_number,w)
label_circle = 1;
[M,N] = size(track_out);
while label_circle 
    label_circle = 0;
    track_line_p = [];
    for i = 1:M
%     for i = 104
        xx = track_out{i,1};
        yy = track_out{i,2};
        % 找出在当前帧图像被判断为终止的轨迹线
        if length(xx) == image_number 
            % 找出轨迹线长度大于等于 2 的
            if sum(xx>0) >= 3
                I = Image_data(:,:,image_number);
                [x1_t,y1_t,x2_t,y2_t,label] = find_different_points(xx,yy);
                % 寻找轨迹线可能相交，从而影响了目标轨迹线下一个点检测的候选轨迹线
                line_num = line_candidate(dis_range, angle_range,track_line,x1_t, x2_t,y1_t, y2_t); 
                if length(line_num)
                    % 先分析当前帧中，这两个点之间的灰度值情况，判断是漏检还是重合
                    % 用宽为 w 长度为这两点连线的矩形框最大值采样法，然后分析波峰的情况来判断是否漏检
                    % 同时还需要注意这个波峰是否已经被别的轨迹线占用了
                    if length(line_num) == 1 
                        x_line_num = track_line{line_num, 1};
                        y_line_num = track_line{line_num, 2};
                        if x2_t == x_line_num(end) & y2_t == y_line_num(end)
                            xx(end) = x2_t(1); track_line_p{end+1,1} = xx;
                            yy(end) = y2_t(1); track_line_p{end,  2} = yy;
                            track_out{i,1} = -1;
                            track_out{i,2} = -1;
                        else
                            j = 1;
                            [xt_1, yt_1] = rectangle_intensity(dis_range,angle_range,x1_t,y1_t,x2_t,y2_t,I,w,track_line,line_num,j);
                            if length(xt_1) > 0 
                                xx(end) = xt_1(1); track_line_p{end+1,1} = xx;
                                yy(end) = yt_1(1); track_line_p{end,  2} = yy;
                                track_out{i,1} = -1;
                                track_out{i,2} = -1;
                            end
                        end
                    else
                        for j = 1:length(line_num)
                           [xt_1, yt_1] = rectangle_intensity(dis_range,angle_range,x1_t,y1_t,x2_t,y2_t,I,w,track_line,line_num,j);
                           % 如果还有符合要求的波峰点，则清除track_out 中的那根轨迹线.
                           if length(xt_1) > 0 
                               xx(end) = xt_1(1); track_line_p{end+1,1} = xx;
                               yy(end) = yt_1(1); track_line_p{end,  2} = yy;
                               track_out{i,1} = -1;
                               track_out{i,2} = -1;
                               break;
                           end
                        end
                    end
                else
                    % 如果这个方向找不到可以补偿点的情况，考虑跳过最后一个点（可以理解为修正方向）再找一次
                    [a,b] = find(xx == x1_t & yy == y1_t);
                    x_1 = xx(1:b(end)); y_1 = yy(1:b(end));
                    [x1_t,y1_t,x2_t,y2_t,label] = find_different_points(x_1,y_1);
                    line_num = line_candidate(dis_range, angle_range,track_line,x1_t, x2_t,y1_t, y2_t); 
                    if length(line_num)
                        % 先分析当前帧中，这两个点之间的灰度值情况，判断是漏检还是重合
                        % 用宽为 w 长度为这两点连线的矩形框最大值采样法，然后分析波峰的情况来判断是否漏检
                        % 同时还需要注意这个波峰是否已经被别的轨迹线占用了
                        if length(line_num) == 1 
                            x_line_num = track_line{line_num, 1};
                            y_line_num = track_line{line_num, 2};
                            if x2_t == x_line_num(end) & y2_t == y_line_num(end)
                                xx(end) = x2_t(1); track_line_p{end+1,1} = xx;
                                yy(end) = y2_t(1); track_line_p{end,  2} = yy;
                                track_out{i,1} = -1;
                                track_out{i,2} = -1;
                            else
                                j = 1;
                                [xt_1, yt_1] = rectangle_intensity(dis_range,angle_range,x1_t,y1_t,x2_t,y2_t,I,w,track_line,line_num,j);
                                if length(xt_1) > 0 
                                    xx(end) = xt_1(1); track_line_p{end+1,1} = xx;
                                    yy(end) = yt_1(1); track_line_p{end,  2} = yy;
                                    track_out{i,1} = -1;
                                    track_out{i,2} = -1;
                                end
                            end
                        else
                            for j = 1:length(line_num)
                                [xt_1, yt_1] = rectangle_intensity(dis_range,angle_range,x1_t,y1_t,x2_t,y2_t,I,w,track_line,line_num,j);
                                if length(xt_1) > 1
                                    xx(end) = xt_1(1); track_line_p{end+1,1} = xx;
                                    yy(end) = yt_1(1); track_line_p{end,  2} = yy;
                                    track_out{i,1} = -1;
                                    track_out{i,2} = -1;
                                    break;
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    if length(track_line_p)
        label_circle = 1;
        [m,~] = size(track_line_p);
        for i = 1:m
            x = track_line_p{i,1};
            y = track_line_p{i,2};
            track_line{end+1,1} = x;
            track_line{end,  2} = y;
        end
        track_out_new = [];
        [m,~] = size(track_out);
        for i = 1:m
            x = track_out{i,1};
            y = track_out{i,2};
            if x(1) >= 0
                track_out_new{end+1, 1} = x;
                track_out_new{end,   2} = y;
            end
        end
        track_out = track_out_new;
        [M,N] = size(track_out);
        clear track_out_new;
    end
end                    


