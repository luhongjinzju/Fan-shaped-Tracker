function [track_out,track_line,track_line_new,point_candidate,x1,y1,x2,y2] = tracking_step_3_2_1(dis_range, angle_range,track_out, track_line,track_line_new,x1,y1,x2,y2,x3,y3,point_candidate)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% step 3　%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 寻找在 x2 只有一个匹配点的 x1
% 寻找 （x1(i)，y1(i)） 在下一帧中的候选点只有一个点的 （x1(i)，y1(i)）
% (xc,yc) 是（x1(point_num)，y1(point_num)）对应的（x2，y2）中的这个唯一的候选点
% 首先考虑已有轨迹线和 (xc,yc) 的关系
% label =1 说明 x1 中有这样的点，label = 0 说明 x1 中没有符合要求的点了
[xc, yc, point_num, label] = find_data_1(x1, point_candidate);
while(label == 1)
    % step 1: 先把(xc,yc)分给point_num这根轨迹线，先计算（x1(end-1)，x1(end)，xc）;再计算（x1，xc，x3）
    xt = track_line{point_num,1}; 
    yt = track_line{point_num,2}; 
    P_pn = xc_yc_line2who(dis_range, angle_range,xt,yt,xc,yc,x3,y3);

    % step 2:再把(xc,yc)分给 group_p 中的轨迹线，并计算（x_group_p(end-1)，x_group_p(end)，xc）;再计算（x_group_p(end)，xc，x3）
    [group_p, ~] = same_group(xc, yc, point_candidate, point_num, x1);
    if length(group_p) == 0
        track_line_new{end+1,1} = [xt, xc];
        track_line_new{end,2}   = [yt, yc];
        x1(point_num) = [-1];
        y1(point_num) = [-1];
        [a,b] = find(x2 == xc & y2 == yc);
        x2(a(1)) = []; y2(a(1)) = [];
        [point_candidate, track_line, x1, y1] = new_data(point_candidate, track_line, x1, y1);
        [xc, yc, point_num, label] = find_data_1(x1, point_candidate);
    else
        P_gp = [];
        for i = 1:length(group_p)
            xt1 = track_line{group_p(i),1}; 
            yt1 = track_line{group_p(i),2};
            P = xc_yc_line2who(dis_range, angle_range,xt1,yt1,xc,yc,x3,y3);
            P_gp(1,i) = P;
        end
        % 根据概率结果分析，(xc,yc) 到底属于哪根轨迹线更好
        [a,b] = find(P_gp > P_pn);
        if length(a) == 0
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
            [xc, yc, point_num, label] = find_data_1(x1, point_candidate);
        else
            % 当(xc,yc) 给其余轨迹线更好时
            % 也就说明需要清除 point_num 这根轨迹线中的 (xc,yc) 这个候选点了
            % 同时把 (xc,yc) 这个候选点分给 group_p 中概率最大的那根
            [a,b] = find(P_gp == max(P_gp));
            xt = track_line{group_p(b(1)),1};
            yt = track_line{group_p(b(1)),2};
            track_line_new{end+1,1} = [xt, xc];
            track_line_new{end,2}   = [yt, yc]; 
            x1(group_p(b(1))) = [-1];
            y1(group_p(b(1))) = [-1];
            [a,b] = find(x2 == xc & y2 == yc);
            x2(a(1)) = []; y2(a(1)) = [];
%             if length(point_candidate{point_num,1}) == 1
%                  xt = track_line{point_num,1};
%                  yt = track_line{point_num,2};
%                  track_out{end+1,1} = [xt, -1];
%                  track_out{end,2}   = [yt, -1];  
%                  x1(point_num) = [-1];
%                  y1(point_num) = [-1];
%             end
            [point_candidate, track_line, x1, y1] = new_data(point_candidate, track_line, x1, y1);
            [point_candidate, x1, y1, track_out, track_line] = new_candidate_data_2(point_candidate, x1, y1, xc, yc,track_out, track_line);
            [xc, yc, point_num, label] = find_data_1(x1, point_candidate); 
        end
    end
end
