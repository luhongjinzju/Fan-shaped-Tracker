function my_movie2(file_size,images,track_out,fps,startFrame,endFrame,s_n) %% ��Ƶ����     
% I = images(:,:,1);
% [m,n] = size(I);
% I_out = zeros(m,n);
% [mm,nn] = size(track_out);
color_data = zeros(length(track_out),3);
for i = 1:length(track_out)
    color_data(i,1:3) = [rand(1),rand(1),rand(1)];
end
%% ��Ƶ����
for i = 1:file_size
    I1 = images(:,:,i);
    figure;imshow(I1,[]);hold on
    for j = 1:length(track_out)       
        x = track_out{j,1};
        y = track_out{j,2};
        if length(x) >= i
            if x(i) > 0
                x_out = x(1:i);
                y_out = y(1:i);
                x_out(find(y_out <= 0)) = []; y_out(find(y_out <= 0)) = [];
                y_out(find(x_out <= 0)) = []; x_out(find(x_out <= 0)) = [];
                plot(y_out,x_out,'-','color',color_data(j,:),'LineWidth',1);
            end
        end
    end
%             resultfile = 'F:/JLH/tracking/׷��/tracking_results/';
%             resultfile = strcat(resultfile,num2str(s_n)); 
    resultfile = strcat(num2str(s_n),'\');
    resultfile = strcat(resultfile,num2str(i));

    saveas(gcf,strcat(resultfile,'.tif'));    
    close all;
end



%         framesPath = 'F:\JLH\tracking\׷��\tracking_results\';%ͼ����������·����ͬʱҪ��֤ͼ���С��ͬ  
%         framesPath = strcat(framesPath,num2str(s_n)); 
        framesPath = strcat(num2str(s_n),'\');
        videoName = strcat('sample_',num2str(s_n));
        videoName = strcat(videoName,'.avi');%��ʾ��Ҫ��������Ƶ�ļ�������  
       
        if(exist('videoName','file'))  
            delete videoName.avi  
        end  

        %������Ƶ�Ĳ����趨  
        aviobj=VideoWriter(videoName);  %����һ��avi��Ƶ�ļ����󣬿�ʼʱ��Ϊ��  
        aviobj.FrameRate=fps;  

        open(aviobj);%Open file for writing video data  
        %����ͼƬ  
        for i=startFrame:endFrame  
        %     fileName=sprintf('%d',i);    %�����ļ������� �������ļ�����0001.jpg 0002.jpg ....  
            fileName = strcat(num2str(i),'.tif');
            frames=imread([framesPath,fileName]);  
            writeVideo(aviobj,frames);  
        end  
        close(aviobj);% �رմ�����Ƶ  
 