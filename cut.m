i=imread('D:\THU\Dexp\4_2!.bmp'); %读取图像

i = im2double(i);
% j=zeros(3032,4000,3);
% for a = 1 : 3032
%     for b = 1: 4000
%         for c = 1:3
%             j(a,b,c)=i(a+3,b,c);
%         end
%     end
% end


j = i(1:end,4:3035,1:end);%裁剪图像
imwrite(j,'01.bmp'); %存储图像
figure,imshow(i); %显示图像
figure,imshow(j); %显示图像