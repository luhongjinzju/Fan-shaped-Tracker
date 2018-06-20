function [point_candidate, track_line, x1, y1] = new_data(point_candidate, track_line, x1, y1)
 k = 0;
 point_candidate_t = [];
 track_line_t = [];
 for i = 1:length(x1)
     if x1(i) > 0 
         k = k + 1;
         point_candidate_t{k,1} = point_candidate{i,1};
         point_candidate_t{k,2} = point_candidate{i,2};
         track_line_t{k,1} = track_line{i,1};
         track_line_t{k,2} = track_line{i,2};
     end
 end
 
 point_candidate = point_candidate_t;
 track_line = track_line_t;
 x1(find(x1<0)) = []; 
 y1(find(y1<0)) = [];

