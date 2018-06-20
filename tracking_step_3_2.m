function [track_out,track_line,track_line_new,point_candidate,x1,y1,x2,y2] = tracking_step_3_2(dis_range, angle_range,track_out, track_line,track_line_new,x1,y1,x2,y2,x3,y3,point_candidate)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% step 3��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ѱ���� x2 ֻ��һ��ƥ���� x1
% Ѱ�� ��x1(i)��y1(i)�� ����һ֡�еĺ�ѡ��ֻ��һ����� ��x1(i)��y1(i)��
% (xc,yc) �ǣ�x1(point_num)��y1(point_num)����Ӧ�ģ�x2��y2���е����Ψһ�ĺ�ѡ��
% label =1 ˵�� x1 ���������ĵ㣬label = 0 ˵�� x1 ��û�з���Ҫ��ĵ���
[xc, yc, point_num, label] = find_data_1(x1, point_candidate);
while(label == 1)
    [theta_all, dis_all, x3t, y3t] = calculate_theta_all(dis_range, angle_range, x1(point_num),xc,x3,y1(point_num),yc,y3);
    if (length(x3t) == 0 )
        % ˵�� xt(end) �� xc һ����һ��
        xt = track_line{point_num,1}; 
        yt = track_line{point_num,2}; 
        track_out{end+1, 1} = [xt -1];
        track_out{end,   2} = [yt -1];
        x1(point_num) = -1; y1(point_num) = -1;
        [point_candidate, track_line, x1, y1] = new_data(point_candidate, track_line, x1, y1);
        [xc, yc, point_num, label] = find_data_1(x1, point_candidate);

    else
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
            [xc, yc, point_num, label] = find_data_1(x1, point_candidate);
        else
            x33 = x3; y33 = y3;
            P = calculate_P(dis_range, angle_range, dis_all, theta_all);
            [a,b] = find(P == max(P));
            [a1,b1] = find(x33 == x3t(a(1)) & y33 == y3t(a(1)));
            x33(a1(1)) = []; y33(a1(1)) = [];
            for i = 1:length(group_p)
                x = point_candidate{group_p(i),1};
                y = point_candidate{group_p(i),2};
                [label_1,max_p] = find_max_P_1(dis_range,angle_range,x1(group_p(i)),y1(group_p(i)),x,y,x3,y3);             
                if label_1 == 0
                    group_p(i) = -1;
                else
                    if x(label_1) ~= xc || y(label_1) ~= yc
                        group_p(i) = -1;
                    end
                end
            end
            k = 0; point_candidate_tt = [];
            for i = 1:length(group_p)
                if group_p(i) > 0
                    k = k + 1;
                    point_candidate_tt{k,1} = point_candidate_t{i,1};
                    point_candidate_tt{k,2} = point_candidate_t{i,2};
                end
            end
            point_candidate_t = point_candidate_tt;
            clear point_candidate_tt;
            group_p(find(group_p < 0)) = [];
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
                [point_candidate, x1, y1, track_out, track_line] = new_candidate_data_2(point_candidate, x1, y1, xc, yc,track_out, track_line);
                [xc, yc, point_num, label] = find_data_1(x1, point_candidate);
            else                              
                max_P_0 = [];
                for i = 1:length(group_p)
                    x = point_candidate_t{i,1};
                    y = point_candidate_t{i,2};
                    [label_1,max_p] = find_max_P_1(dis_range,angle_range,x1(group_p(i)),y1(group_p(i)),x,y,x33,y33);
                    max_P_0(i) = (max_p + max(P))/2;
                end
                max_P_1 = [];
                for i = 1:length(group_p)
                    [theta_all, dis_all, ~, ~] = calculate_theta_all(dis_range, angle_range, x1(group_p(i)),xc,x3,y1(group_p(i)),yc,y3);
                    P = calculate_P(dis_range, angle_range, dis_all, theta_all);
                    max_P_1(i) = (max(P)-20)/2;
                end
                [a,b] = find(max_P_1 > max_P_0);
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
                    % ��(xc,yc) ������켣�߸���ʱ��Ҳ��˵��point_num ����켣���ڽ��ڵ�֡���Ҳ�����ѡ����
                    % ���������Ҫ������ԭ��
                    % 1�����㿿����һ���̶ȣ�ǿ�Ƚ����ĵ㱻©���ˣ�
                    % 2�������ص���ֻ�ܼ���һ�����ˡ�
                    xt = track_line{point_num,1};
                    yt = track_line{point_num,2};
                    track_out{end+1, 1} = [xt -1];
                    track_out{end,   2} = [yt -1];
                    x1(point_num) = -1; y1(point_num) = -1;
                    [point_candidate, track_line, x1, y1] = new_data(point_candidate, track_line, x1, y1);
                    [xc, yc, point_num, label] = find_data_1(x1, point_candidate);
                end
            end
        end        
    end
end

