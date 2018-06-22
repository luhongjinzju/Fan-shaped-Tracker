function [track_out,track_line,track_line_new,point_candidate,x1,y1,x2,y2] = tracking_step_3_2_1(dis_range, angle_range,track_out, track_line,track_line_new,x1,y1,x2,y2,x3,y3,point_candidate)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% step 3��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ѱ���� x2 ֻ��һ��ƥ���� x1
% Ѱ�� ��x1(i)��y1(i)�� ����һ֡�еĺ�ѡ��ֻ��һ����� ��x1(i)��y1(i)��
% (xc,yc) �ǣ�x1(point_num)��y1(point_num)����Ӧ�ģ�x2��y2���е����Ψһ�ĺ�ѡ��
% ���ȿ������й켣�ߺ� (xc,yc) �Ĺ�ϵ
% label =1 ˵�� x1 ���������ĵ㣬label = 0 ˵�� x1 ��û�з���Ҫ��ĵ���
[xc, yc, point_num, label] = find_data_1(x1, point_candidate);
while(label == 1)
    % step 1: �Ȱ�(xc,yc)�ָ�point_num����켣�ߣ��ȼ��㣨x1(end-1)��x1(end)��xc��;�ټ��㣨x1��xc��x3��
    xt = track_line{point_num,1}; 
    yt = track_line{point_num,2}; 
    P_pn = xc_yc_line2who(dis_range, angle_range,xt,yt,xc,yc,x3,y3);

    % step 2:�ٰ�(xc,yc)�ָ� group_p �еĹ켣�ߣ������㣨x_group_p(end-1)��x_group_p(end)��xc��;�ټ��㣨x_group_p(end)��xc��x3��
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
        % ���ݸ��ʽ��������(xc,yc) ���������ĸ��켣�߸���
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
            % ��(xc,yc) ������켣�߸���ʱ
            % Ҳ��˵����Ҫ��� point_num ����켣���е� (xc,yc) �����ѡ����
            % ͬʱ�� (xc,yc) �����ѡ��ָ� group_p �и��������Ǹ�
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
