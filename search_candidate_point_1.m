function [point_candidate, track_out, x1,y1] = search_candidate_point_1(dis_range, angle_range,x1,y1,x2,y2,x3,y3,track_out)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% step 1��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
point_candidate = [];
for i = 1:length(x1)
    x = x1(i); y = y1(i);
    dis = sqrt((x2 - x).^2 + (y2 - y).^2);
    [a,b] = find(dis <= dis_range);
    if length(a) > 0
        % �����ҵ�������һ֡�о������Ҫ��ĵ�
        xt = x2(a); yt = y2(a);
        % �������֡�е������㹹�ɵļнǷ���Ҫ��ĵ�
        for j = 1:length(xt)
            [theta_all, dis_all, x3t, y3t] = calculate_theta_all(dis_range, angle_range, x,xt(j),x3,y,yt(j),y3);
            if length(x3t) == 0
                xt(j) = -1; 
                yt(j) = -1;
            end
        end
        xt(find(xt < 0)) = [];
        yt(find(yt < 0)) = [];
        if length(xt) > 0
            %�������ͽǶȶ�����Ҫ������к�ѡ��
            point_candidate{end+1,1} = xt;
            point_candidate{end,  2} = yt;
        else
            % �������֡�в����ڷ���Ҫ��ĵ㣬�켣����ֹ����һ������ֹ�ģ�
            track_out{end+1, 1} = [x -1];
            track_out{end,   2} = [y -1];
            x1(i) = -1; y1(i) = -1;
        end
    else
        % ˵����һ֡��û�о������Ҫ��ĵ�
        track_out{end+1, 1} = [x -1];
        track_out{end,   2} = [y -1];
        x1(i) = -1; y1(i) = -1;
    end
end
x1(find(x1<0)) = []; y1(find(y1<0)) = [];