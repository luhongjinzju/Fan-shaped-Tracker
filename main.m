clear all
close all
clc

%% ��������
% ------------------------------ ������� ------------------------------ %
    detection_method_label = 2; % "2"��ʾ��������˹����ķ�����"1"��ʾ��һ����˹
    rth = 0.1; 
    w = 3;     % ��˹�߰뾶
    th = 0.1;  % �����Ч����̫�ã����Կ����޸��������
% ----------------------------- ׷�ٲ��ֲ��� ----------------------------- %
    dis_range = 3;
    angle_range = 91;

% -------------------------- ������Ƶ���ֲ��� ----------------------------- %
    fps = 5; %֡��
    startFrame = 1; %����һ֡��ʼ  
    endFrame = startFrame+50; %��һ֡����  
    
%% ��ͼ
% PSF = fspecial('gaussian', w, w);
% UNDERPSF = ones(size(PSF));
    [filename, pathname] = uigetfile('*.tif', '��ȡͼƬ�ļ�'); %ѡ��ͼƬ�ļ�
    Files = dir(strcat(pathname,'*.tif'));
    if isequal(filename,0)   %�ж��Ƿ�ѡ��
       msgbox('û��ѡ���κ�ͼƬ');
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
%% ����
    % ���⣨point_position���Ż���ĵ�������point_position_1����ͨ�ĵ����㷨��
%     [point_position,point_position_1] = my_point_detection(Image_data,rth,w,th,detection_method_label);
%     point_position = point_position_1;
    point_position = my_point_detection(Image_data,rth,w,th,detection_method_label);
    % ��ͼչʾ�����Ч��
%     for i = 1:image_len
%     for i = 300:400
%         I = Image_data(:,:,i);
%         figure;imshow(I,[]); hold on
%         x = point_position{i,1};
%         y = point_position{i,2};
%         plot(y,x,'r*');
%     end

%% ׷��
% ----------------------------- ���ݶ�ȡ ----------------------------- %
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
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% step 1��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Ѱ�� x1 ��ÿ�����Ժ� x2 ƥ��ĵ�Ĺ�ϵ��
	[point_candidate, track_out, x1,y1] = search_candidate_point_1(dis_range, angle_range,x1,y1,x2,y2,x3,y3,track_out);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% step 2��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Ѱ�� x1 �к� x2 һһ��Ӧ�ĵ㣬ֱ�����
    [point_candidate, x1, y1, track_line, x2, y2] = tracking_step_2_1(point_candidate, x1, y1, x2, y2);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% step 3��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Ѱ���� x2 ֻ��һ��ƥ���� x1
	[track_out,track_line,point_candidate,x1,y1,x2,y2] = tracking_step_3_1(dis_range, angle_range,track_out, track_line,x1,y1,x2,y2,x3,y3,point_candidate);
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% step 4��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Ѱ�� x1 �� x2 �໥֮�䶼�ж�����Է��������
	[track_out,track_line] = tracking_step_4_1(dis_range, angle_range, x1,y1,x2,y2,x3,y3, track_out,track_line,point_candidate);
	clear x1; clear y1; clear x2; clear y2; clear point_candidate;
    % ǰ��֡ͼ������ƥ�䷽����֮ǰ��һ����Ҳ����˵ÿ���켣�ߵ�ǰ����������ӷ������䡣(���ݸ�����ѡ�񣬶�����֮ǰ�ľ���ͽǶȷ����)
    % �켣�ߵĵ������㿪ʼ�����ӹ켣�ߵ�ͬʱ����Ҫ�����Ƿ񲹵�
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
        
        % step 1: Ѱ�� x1 ��ÿ�����Ժ� x2 ƥ��ĵ�Ĺ�ϵ��
        [point_candidate, track_out, track_line, x1,y1] = search_candidate_point_2(dis_range, angle_range,x2,y2,x3,y3,track_out,track_line);
        % step 2: Ѱ�� x1 �к� x2 һһ��Ӧ�ĵ㣬ֱ�����
        [point_candidate, x1, y1, track_line, track_line_new, x2, y2] = tracking_step_2_2(point_candidate, x1, y1, x2, y2,track_line);
        % step 3: Ѱ���� x2 ֻ��һ��ƥ���� x1
        [track_out,track_line,track_line_new,point_candidate,x1,y1,x2,y2] = tracking_step_3_2(dis_range, angle_range,track_out, track_line,track_line_new,x1,y1,x2,y2,x3,y3,point_candidate);
        % step 4: ��� x1 �к� x2 ֻ�ж��ƥ������Ϣ
        [track_out,track_line] = tracking_step_4_2(dis_range, angle_range, x1,y1,x2,y2,x3,y3, track_out,track_line,point_candidate,track_line_new,image_number);
        clear x1; clear y1; clear x2; clear y2; clear point_candidate; clear track_line_new;
        % ������Щ�ڵ�ǰ֡�й켣��ֻ��һ�������ֹ���߸տ�ʼ�Ĺ켣����Ҫ�������·��䣻
        % ������track_line��ֻ��һ����Ĺ켣�� �� track_out �켣����ƥ�䣨�������һ���㣬�����������˼��
        % ��ˣ�ֻ��ע�켣�߸������� 3�ģ�Ҳ�����л��ỻ�����ҵĹ켣�ߣ�
        [track_out,track_line] = new_track_result_1(track_out,track_line,image_number,dis_range,angle_range);
        
        % �Ե�ǰ֡�����жϺ������ֹ�켣�ߵĹ켣���¼���
        % ��ĳ���켣��ĩ����������ͬ��(label_2 = 0ʱ)�����ڵ���֡ͼ���Ҳ������ʵĺ�ѡ��ʱ����Ҫ���ǵ㲹�䡣
        % ���������Ҫ������ԭ��
        % 1�����㿿����һ���̶ȣ�ǿ�Ƚ����ĵ㱻©���ˣ�
        % 2�������ص���ֻ�ܼ���һ�����ˡ�
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
    
    
    
    
    
    
    
    
    
    
    
    
    





