% Ѱ�ҹ켣�߿����ཻ���Ӷ�Ӱ����Ŀ��켣����һ������ĺ�ѡ�켣��
function line_num = line_candidate(dis_range, angle_range,track_line,x1_t, x2_t,y1_t, y2_t)
line_num = [];
for i = 1:length(track_line)
    x = track_line{i,1};
    y = track_line{i,2};
    [a,b] = find(x>0);
    if length(a) > 3
        dis = sqrt((x(end) - x2_t)^2 + (y(end) - y2_t)^2);
        if dis <= 2*dis_range
%             theta = calculate_theta_1(x1_t, x2_t, x(end), y1_t, y2_t, y(end));
%             if theta <= angle_range
                line_num(end+1) = i;
%             end
        end
    end
end