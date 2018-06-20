function [point_candidate, x1, y1, track_out] = new_candidate_data(point_candidate, x1, y1, xc, yc,track_out)
for i = 1:length(x1)
    x = point_candidate{i,1};
    y = point_candidate{i,2};
    [a,b] = find(x == xc & y == yc);
    if length(a) > 0
        x(a(1)) = [];
        y(a(1)) = [];
        point_candidate{i,1} = x;
        point_candidate{i,2} = y;
    end
end

for i = 1:length(x1)
    x = point_candidate{i,1};
    if length(x) == 0
        track_out{end+1, 1} = [x1(i) -1];
        track_out{end,   2} = [y1(i) -1];
        x1(i) = -1;
        y1(i) = -1;
    end
end

[point_candidate, x1, y1] = new_compare_data(point_candidate, x1, y1);