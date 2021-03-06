clear all
close all
clc

%% 参数设置
% ------------------------------ 点检测参数 ------------------------------ %
    detection_method_label = 2; % "2"表示用两个高斯相减的方法，"1"表示用一个高斯
    rth = 0.1; 
    w = 3;     % 高斯斑半径
    th = 0.1;  % 若检测效果不太好，可以考虑修改这个参数
% ----------------------------- 追踪部分参数 ----------------------------- %
    dis_range = 3;
    angle_range = 91;

% -------------------------- 制作视频部分参数 ----------------------------- %
    fps = 5; %帧率
    startFrame = 1; %从哪一帧开始  
    endFrame = startFrame+50; %哪一帧结束  
    
%% 读图
% PSF = fspecial('gaussian', w, w);
% UNDERPSF = ones(size(PSF));
    [filename, pathname] = uigetfile('*.tif', '读取图片文件'); %选择图片文件
    Files = dir(strcat(pathname,'*.tif'));
    if isequal(filename,0)   %判断是否选择
       msgbox('没有选择任何图片');
    else
        strcat(pathname,Files(1).name)
        I = imread(strcat(pathname,Files(1).name));
        [m,n] = size(I);
        Image_data = zeros(m,n,length(Files));
        for i = 1:length(Files)
           I = imread(strcat(pathname,Files(i).name));
%            [J3, P3] = deconvblind(Blurred,INITPSF);
%            [I, P3] = deconvblind(I,UNDERPSF);
           Image_data(:,:,i) = I;
        end
    end
    clear filename; clear pathname; clear Files; clear I; clear i;
    [m,n,image_len] = size(Image_data);
%% 点检测
    % 点检测（point_position：优化后的点检测结果；point_position_1：普通的点检测算法）
%     [point_position,point_position_1] = my_point_detection(Image_data,rth,w,th,detection_method_label);
%     point_position = point_position_1;
    point_position = my_point_detection(Image_data,rth,w,th,detection_method_label);
    % 画图展示点检测的效果
%     for i = 1:image_len
%     for i = 300:400
%         I = Image_data(:,:,i);
%         figure;imshow(I,[]); hold on
%         x = point_position{i,1};
%         y = point_position{i,2};
%         plot(y,x,'r*');
%     end

%% 追踪
% ----------------------------- 数据读取 ----------------------------- %
% 	I_out = zeros(m,n);
	image_number = 1;
	x1 = point_position{image_number,1};
	y1 = point_position{image_number,2};
	image_number = 2;
	x2 = point_position{image_number,1};
	y2 = point_position{image_number,2};
	image_number = 3;
	x3 = point_position{image_number,1};
	y3 = point_position{image_number,2};

    track_out = [];
    track_line = [];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% step 1　%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% 寻找 x1 中每个可以和 x2 匹配的点的关系组
	[point_candidate, track_out, x1,y1] = search_candidate_point_1(dis_range, angle_range,x1,y1,x2,y2,x3,y3,track_out);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% step 2　%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% 寻找 x1 中和 x2 一一对应的点，直接配对
    [point_candidate, x1, y1, track_line, x2, y2] = tracking_step_2_1(point_candidate, x1, y1, x2, y2);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% step 3　%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% 寻找在 x2 只有一个匹配点的 x1
	[track_out,track_line,point_candidate,x1,y1,x2,y2] = tracking_step_3_1(dis_range, angle_range,track_out, track_line,x1,y1,x2,y2,x3,y3,point_candidate);
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% step 4　%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% 寻找 x1 和 x2 相互之间都有多种配对方案的情况
	[track_out,track_line] = tracking_step_4_1(dis_range, angle_range, x1,y1,x2,y2,x3,y3, track_out,track_line,point_candidate);
	clear x1; clear y1; clear x2; clear y2; clear point_candidate;
    % 前三帧图的连接匹配方案和之前的一样，也就是说每根轨迹线的前几个点的连接方案不变。(根据概率来选择，而不是之前的距离和角度分离的)
    % 轨迹线的第三个点开始，连接轨迹线的同时，需要考虑是否补点
%     figure;imshow(Image_data(:,:,image_number-1),[]); hold on
%     for i = 1:length(track_line)
%         x = track_line{i,1};x = x(find(x > 0));
%         y = track_line{i,2};y = y(find(y > 0));
%         plot(y,x,'r*-');
%     end
%     for i = 1:length(track_out)
%         x = track_out{i,1};x = x(find(x > 0));
%         y = track_out{i,2};y = y(find(y > 0));
%         plot(y,x,'r*-');
%         plot(y(end),x(end),'go');
%     end
    for image_number = 3:image_len-1
        image_number
%     for image_number = 3:8
%         image_number = image_number + 1
        x2 = point_position{image_number,1};
        y2 = point_position{image_number,2};
        
        x3 = point_position{image_number+1,1};
        y3 = point_position{image_number+1,2};
        
        % step 1: 寻找 x1 中每个可以和 x2 匹配的点的关系组
        [point_candidate, track_out, track_line, x1,y1] = search_candidate_point_2(dis_range, angle_range,x2,y2,x3,y3,track_out,track_line);
        % step 2: 寻找 x1 中和 x2 一一对应的点，直接配对
        [point_candidate, x1, y1, track_line, track_line_new, x2, y2] = tracking_step_2_2(point_candidate, x1, y1, x2, y2,track_line);
        % step 3: 寻找在 x2 只有一个匹配点的 x1
        [track_out,track_line,track_line_new,point_candidate,x1,y1,x2,y2] = tracking_step_3_2(dis_range, angle_range,track_out, track_line,track_line_new,x1,y1,x2,y2,x3,y3,point_candidate);
        % step 4: 配对 x1 中和 x2 只有多个匹配点的信息
        [track_out,track_line] = tracking_step_4_2(dis_range, angle_range, x1,y1,x2,y2,x3,y3, track_out,track_line,point_candidate,track_line_new,image_number);
        clear x1; clear y1; clear x2; clear y2; clear point_candidate; clear track_line_new;
        % 对于那些在当前帧中轨迹线只有一个点就终止或者刚开始的轨迹线需要考虑重新分配；
        % 方案：track_line中只有一个点的轨迹线 和 track_out 轨迹线重匹配（跳过最后一个点，换个方向的意思）
        % 因此，只关注轨迹线个数大于 3的（也就是有机会换方向找的轨迹线）
        [track_out,track_line] = new_track_result_1(track_out,track_line,image_number,dis_range,angle_range);
        
        % 对当前帧上述判断后归于终止轨迹线的轨迹重新检验
        % 当某根轨迹线末端有两个不同点(label_2 = 0时)，且在第三帧图中找不到合适的候选点时，需要考虑点补充。
        % 这种情况主要有两个原因：
        % 1：两点靠近到一定程度，强度较弱的点被漏检了；
        % 2：两点重叠，只能检测出一个点了。
        [track_out,track_line] = my_point_overlap(Image_data, dis_range, angle_range,track_out,track_line,image_number,w);
    end
%     figure;imshow(Image_data(:,:,image_number-1),[]); hold on
%     for i = 1:length(track_line)
%         x = track_line{i,1};x = x(find(x > 0));
%         y = track_line{i,2};y = y(find(y > 0));
%         plot(y,x,'r*-');
%     end
%     for i = 1:length(track_out)
%         x = track_out{i,1};x = x(find(x > 0));
%         y = track_out{i,2};y = y(find(y > 0));
%         plot(y,x,'r*-');
%         plot(y(end),x(end),'go');
%     end

    
    
    [aa,bb] = size(track_out);
    for i = 1:length(track_out)
        x = track_out{i,1};
        y = track_out{i,2};
        track_line{end+1, 1} = x;
        track_line{end,   2} = y;
    end
    clear track_out;
    file_size =  image_len;
    endFrame = file_size -2;
    s_n = 1;
    my_movie2(file_size,Image_data, track_line,fps,startFrame,endFrame,s_n);
    
    
    
    
    
    
    
    
    
    
    
    
    





