function [point_candidate, x1, y1] = new_compare_data(point_candidate, x1, y1)
 k = 0;
 point_candidate_t = [];
 
 for i = 1:length(x1)
     if x1(i) > 0 
         k = k + 1;
         point_candidate_t{k,1} = point_candidate{i,1};
         point_candidate_t{k,2} = point_candidate{i,2};
     end
 end
 
 point_candidate = point_candidate_t;

 x1(find(x1<0)) = []; y1(find(y1<0)) = [];

