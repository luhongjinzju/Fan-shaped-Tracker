% Ѱ�� ��x1(i)��y1(i)�� ����һ֡�еĺ�ѡ��ֻ��һ����� ��x1(i)��y1(i)��
% (xc,yc) �ǣ�x1(point_num)��y1(point_num)����Ӧ�ģ�x2��y2���е����Ψһ�ĺ�ѡ��
% label =1 ˵�� x1 ���������ĵ㣬label = 0 ˵�� x1 ��û�з���Ҫ��ĵ���
function [xc, yc, point_num, label] = find_data_1(x1, point_candidate)
label = 0; xc = []; yc = []; point_num = [];
if length(x1) >0
    for i = 1:length(x1)
        x = point_candidate{i,1};
        y = point_candidate{i,2};
        if length(x) == 1
            xc = x(1); 
            yc = y(1);         
            point_num = i;
            label = 1;
            break;
        end
    end
else
    xc=0; yc=0; point_num=0; label = 0;
end