% 寻找 （x1(i)，y1(i)） 在下一帧中的候选点只有一个点的 （x1(i)，y1(i)）
% (xc,yc) 是（x1(point_num)，y1(point_num)）对应的（x2，y2）中的这个唯一的候选点
% label =1 说明 x1 中有这样的点，label = 0 说明 x1 中没有符合要求的点了
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