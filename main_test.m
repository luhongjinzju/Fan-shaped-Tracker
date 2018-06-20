clear all
close all
clc

%% ��������
% --------------------------- ͼ��������ز��� --------------------------- %
%     sample_num = textread('sample number.txt');
    SNR_all = [1 1 1 1 2 2 2 2 4 4 4 4 7 7 7 7]; 
    trace_density_all = [100 250 500 1000 100 250 500 1000 100 250 500 1000 100 250 500 1000 ];

% ------------------------------ ������� ------------------------------ %
    detection_method_label = 2; % "2"��ʾ��������˹����ķ�����"1"��ʾ��һ����˹
    rth = 0.1; 
    w = 5;     % ��˹�߰뾶
    th = 0.1;  % �����Ч����̫�ã����Կ����޸��������
% ----------------------------- ׷�ٲ��ֲ��� ----------------------------- %
    dis_range = 5;
    angle_range = 91;

% -------------------------- ������Ƶ���ֲ��� ----------------------------- %
    fps = 5; %֡��
    startFrame = 1; %����һ֡��ʼ  
    endFrame = startFrame+50; %��һ֡����  
    
%% ��ͼ
    for circlenum = 1
%     circlenum = 13;  
    if circlenum <= 4
        th = 0.4;
    else
        if circlenum <= 8
            th = 0.2;
        end
    end
    if circlenum > 8
        detection_method_label = 1; % "2"��ʾ��������˹����ķ�����"1"��ʾ��һ����˹
    end
    for s_n = 1:5
%     s_n = 5
        sample_number = s_n;
        trace_density = trace_density_all(circlenum); 
        SNR = SNR_all(circlenum);
        % ----------------------------- ͼƬ���� ----------------------------- %
        % ͼƬ���ݴ��ھ��� Image_data �У�
        File_path = 'F:\\JLH\\vesicle simulation\\(��ά) ����Ĥ�˶���\\ģ��ͼ�������\\ģ��ͼ��\\'; 
        File_path = strcat(File_path, num2str(trace_density)); File_path = strcat(File_path, '\\SNR=');
        File_path = strcat(File_path, num2str(SNR));          File_path = strcat(File_path, '\\sample_');
        File_path = strcat(File_path, num2str(sample_number));File_path = strcat(File_path, '\\');
        % -------------------- ͼƬ��ȡ���֣�ģ��ͼ���ھ��� image_data �У�
        image_name_s = 'im_';
        Image_data = Image_reading(File_path,image_name_s);
        [m,n,image_len] = size(Image_data);
%% ����
    % ���⣨point_position���Ż���ĵ�������point_position_1����ͨ�ĵ����㷨��
%     [point_position,point_position_1] = my_point_detection(Image_data,rth,w,th,detection_method_label);
%     point_position = point_position_1;
    point_position = my_point_detection(Image_data,rth,w,th,detection_method_label);
    % ��ͼչʾ�����Ч��
%     for i = 8:9
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
%     track_line_new = line_refine_1_1(track_line, dis_range, angle_range);
%     track_line = track_line_new;
    track_line_new = line_refine_2_1(track_line, dis_range, angle_range,w);
    track_line = track_line_new;
%     file_size =  image_len;
%     endFrame = file_size -2;
%     my_movie2(file_size,Image_data, track_line,fps,startFrame,endFrame,s_n);
    
    
    
    %% -------------------------- ����XML �ļ� ----------------------------- %
        tempname = strcat(num2str(circlenum),'_'); 
        tempname = strcat(tempname,num2str(s_n)); 
        tempname = strcat(tempname,'_fs'); 
        xdoc=com.mathworks.xml.XMLUtils.createDocument('root');  
        xroot=xdoc.getDocumentElement;  
        
        type=xdoc.createElement('TrackContestISBI2012');  
        xroot.appendChild(type);  
        type.setAttribute('snr',num2str(SNR)); 
        type.setAttribute('density','low');  
        type.setAttribute('scenario','vesicle');  
        
        for i = 1:length(track_line)
            subNode = xdoc.createElement('particle');
            type.appendChild(subNode);
            
            x = track_line{i,2}; 
            y = track_line{i,1};
            [a,b] = find(x >0 & y >0);
  
            for j = 1:length(b)
                newDetection=xdoc.createElement('detection');%newDetection
                newDetection.setAttribute('t',num2str(b(j)-1));%����Headline����
                newDetection.setAttribute('x',num2str(x(b(j))-1));%����Headline����
                newDetection.setAttribute('y',num2str(y(b(j))-1));%����Headline����
                newDetection.setAttribute('z',num2str(0));%����Headline����
                subNode.appendChild(newDetection);%��newSlide����xRoot��ĩβ
            end
        end       
        xmlwrite(tempname,xdoc);%����XML
    end
    end
    
    
    
    
    
    
    





