function [group_p, point_candidate_t] = same_group(xc, yc, point_candidate, point_num, x1)
group_p = []; k =0;
for i = 1:length(x1)
    if i~= point_num
        xp = point_candidate{i,1};
        yp = point_candidate{i,2};
        [a,b] = find(xp == xc & yp == yc);
        if length(a) > 0   
            k = k + 1;
            group_p(k) = i;
            xp(a(1)) = [];
            yp(a(1)) = [];
            point_candidate_t{k,1} = xp;
            point_candidate_t{k,2} = yp;
        end
    end
end

if length(group_p) == 0
    point_candidate_t = [];
end