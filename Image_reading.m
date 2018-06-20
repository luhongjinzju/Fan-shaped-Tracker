% ����������ļ�·������ȡͼƬ��ͬʱ��ͼƬ������������
function Image_out = Image_reading(File_path,image_name_s)

Files = dir(strcat(File_path,'*.tif'));% ͼ��洢·��
image_length = length(Files);

if length(image_name_s) > 5
    
    image_name = strcat(image_name_s,'000'); 
    image_name = strcat(image_name,num2str(1)); 
    image_name = strcat(image_name,'.tif');
    I = imread(strcat(File_path,image_name));     [m,n] = size(I); % ͼ��ߴ�
    Image_out = zeros(m,n,image_length);

    for i = 1:10
        % ��ȡԭʼͼ��
        image_name = strcat(image_name_s,'000'); 
        image_name = strcat(image_name,num2str(i-1)); 
        image_name = strcat(image_name,'.tif');
        I = imread(strcat(File_path,image_name)); 
        Image_out(:,:,i) = I;
    end
    if image_length > 100
        for i = 11:100
            % ��ȡԭʼͼ��
            image_name = strcat(image_name_s,'00'); 
            image_name = strcat(image_name,num2str(i-1)); 
            image_name = strcat(image_name,'.tif');
            I = imread(strcat(File_path,image_name)); 
            Image_out(:,:,i) = I;
        end
        for i = 101:image_length
            % ��ȡԭʼͼ��
            image_name = strcat(image_name_s,'0'); 
            image_name = strcat(image_name,num2str(i-1)); 
            image_name = strcat(image_name,'.tif');
            I = imread(strcat(File_path,image_name)); 
            Image_out(:,:,i) = I;
        end    
    else
        for i = 11:image_length
            % ��ȡԭʼͼ��
            image_name = strcat(image_name_s,'0'); 
            image_name = strcat(image_name,num2str(i-1)); 
            image_name = strcat(image_name,'.tif');
            I = imread(strcat(File_path,image_name)); 
            Image_out(:,:,i) = I;
        end
    end
else
    image_name = strcat(image_name_s,num2str(1)); image_name = strcat(image_name,'.tif');
    I = imread(strcat(File_path,image_name));     [m,n] = size(I); % ͼ��ߴ�
    Image_out = zeros(m,n,image_length);

    for i = 1:image_length
        % ��ȡԭʼͼ��
        image_name = strcat(image_name_s,num2str(i)); image_name = strcat(image_name,'.tif');
        I = imread(strcat(File_path,image_name)); 
        Image_out(:,:,i) = I;
    end
end

