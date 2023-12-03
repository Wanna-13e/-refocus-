LF_image=imread('D:\THU\learning\大三上\传感\应用实验D照片\01.bmp'); %读取图像
[height_LF,width_LF,~] = size(LF_image);
LF_image = im2double(LF_image);%类型转换为double，matlab默认使用double进行运算
alpha = 1;%重聚焦参数
window_side = 4;%透镜的尺寸（4x4、6x6、8x8）
out_put_image = refocus(LF_image,height_LF,width_LF,window_side,alpha);
figure,imshow(out_put_image); %显示图像
