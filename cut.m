i=imread('D:\THU\Dexp\6_3!.bmp'); %读取图像

j = i(1:end,2:3997,1:end);%裁剪图像

imwrite(j,'6_02_3036_3996.bmp'); %存储图像

figure,imshow(i); %显示图像
figure,imshow(j); %显示图像