function my_movie2(file_size,images,track_out,fps,startFrame,endFrame,s_n) %% 视频制作     
% I = images(:,:,1);
% [m,n] = size(I);
% I_out = zeros(m,n);
% [mm,nn] = size(track_out);
color_data = zeros(length(track_out),3);
for i = 1:length(track_out)
    color_data(i,1:3) = [rand(1),rand(1),rand(1)];
end
%% 视频制作
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
%             resultfile = 'F:/JLH/tracking/追踪/tracking_results/';
%             resultfile = strcat(resultfile,num2str(s_n)); 
    resultfile = strcat(num2str(s_n),'\');
    resultfile = strcat(resultfile,num2str(i));

    saveas(gcf,strcat(resultfile,'.tif'));    
    close all;
end



%         framesPath = 'F:\JLH\tracking\追踪\tracking_results\';%图像序列所在路径，同时要保证图像大小相同  
%         framesPath = strcat(framesPath,num2str(s_n)); 
        framesPath = strcat(num2str(s_n),'\');
        videoName = strcat('sample_',num2str(s_n));
        videoName = strcat(videoName,'.avi');%表示将要创建的视频文件的名字  
       
        if(exist('videoName','file'))  
            delete videoName.avi  
        end  

        %生成视频的参数设定  
        aviobj=VideoWriter(videoName);  %创建一个avi视频文件对象，开始时其为空  
        aviobj.FrameRate=fps;  

        open(aviobj);%Open file for writing video data  
        %读入图片  
        for i=startFrame:endFrame  
        %     fileName=sprintf('%d',i);    %根据文件名而定 我这里文件名是0001.jpg 0002.jpg ....  
            fileName = strcat(num2str(i),'.tif');
            frames=imread([framesPath,fileName]);  
            writeVideo(aviobj,frames);  
        end  
        close(aviobj);% 关闭创建视频  
 