function point_position = my_point_detection(Image_data,rth,w,th,detection_method_label)

[m,n,image_len] = size(Image_data); % 图像矩阵规格
point_position = [];
if detection_method_label == 1
    for i = 1:image_len
        I = Image_data(:,:,i); 
        [x,y] = detection_1(I,rth,w,th);
        point_position{i,1} = x;
        point_position{i,2} = y;
    end
end
if detection_method_label == 2
    for i = 1:image_len
        I = Image_data(:,:,i);
        [x,y] = detection_2(I,rth,w,th);
        point_position{i,1} = x;
        point_position{i,2} = y;
    end
end

if length(point_position) == 0
    disp('输入了错误的 detection_method_label！');
    disp('正确的 detection_method_label 只能是 1 或者 2');
end
