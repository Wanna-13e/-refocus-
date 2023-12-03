function [output_image] = refocus(LF_image,height_LF,width_LF,window_side,alpha)
% LF_image格式为double，output——image格式为double，为运算格式方便，此代码中所有图片格式为double
%   refocus函数对图像进行重聚焦
stereo_diff = (window_side-1)/2; %单位偏移位置的最大值
window_size =window_side.*window_side;%大像素对应的小像素数量
width = width_LF/window_side;%大像素的宽
height = height_LF/window_side;%大像素的高

res_image = zeros(height,width,3);%重聚焦后的图像，double
for x=1:height
    for y=1:width %大循环，重聚焦s'的大像素进行遍历
        output_color_R =0;%三通道
        output_color_G =0;
        output_color_B =0;
        for u = -stereo_diff:stereo_diff %u，v为单位偏移位置
            for v = -stereo_diff:stereo_diff %小循环，对单位大像素中的小像素遍历
                x_ind = u*(1-1/alpha) + x;%根据公式，实际像面s上x的坐标 坐标：x+u(1-1/alpha)
                y_ind = v*(1-1/alpha) + y;%根据公式，实际像面s上y的坐标 坐标：y+u(1-1/alpha)
                %向上取整
                x_ceil = ceil(x_ind);
                y_ceil = ceil(y_ind);
                %进行边界判定，对于对应s像面两个大像素点之间的光，计算二维权重
                x_1 = bound_coor(x_ceil  ,height );
                y_1 = bound_coor(y_ceil  ,width);
                x_2 = bound_coor(x_ceil+1,height );
                y_2 = bound_coor(y_ceil+1,width);
                %使用二维线性插值，越近权重越大
                x_1_w   = x_ceil-x_ind       ;
                x_2_w   = 1 - x_1_w                ;
                y_1_w   = y_ceil-y_ind      ;
                y_2_w   = 1-y_1_w                  ;

                %光场图像上小像素点的位置
                x_1_index = 1+u+stereo_diff + (x_1-1)*window_side   ;
                y_1_index = 1+v+stereo_diff + (y_1-1)*window_side   ;
                x_2_index = 1+u+stereo_diff + (x_2-1)*window_side   ;
                y_2_index = 1+v+stereo_diff + (y_2-1)*window_side   ;

                %计算线性插值之后的值
                interp_color_R = y_1_w.*x_1_w.*LF_image(x_1_index,y_1_index,1)+...
                                 y_2_w.*x_1_w.*LF_image(x_1_index,y_2_index,1)+... 
                                 y_1_w.*x_2_w.*LF_image(x_2_index,y_1_index,1)+...
                                 y_2_w.*x_2_w.*LF_image(x_2_index,y_2_index,1);
                interp_color_G = y_1_w.*x_1_w.*LF_image(x_1_index,y_1_index,2)+...  
                                 y_2_w.*x_1_w.*LF_image(x_1_index,y_2_index,2)+...
                                 y_1_w.*x_2_w.*LF_image(x_2_index,y_1_index,2)+...
                                 y_2_w.*x_2_w.*LF_image(x_2_index,y_2_index,2);
                interp_color_B = y_1_w.*x_1_w.*LF_image(x_1_index,y_1_index,3)+...
                                 y_2_w.*x_1_w.*LF_image(x_1_index,y_2_index,3)+...
                                 y_1_w.*x_2_w.*LF_image(x_2_index,y_1_index,3)+...
                                 y_2_w.*x_2_w.*LF_image(x_2_index,y_2_index,3);

                %计算单通道的值
                output_color_R = interp_color_R + output_color_R;
                output_color_G = interp_color_G + output_color_G;
                output_color_B = interp_color_B + output_color_B;

            end
        end
        %对相应通道的值取平均
        res_image(x,y,1)=output_color_R/window_size;
        res_image(x,y,2)=output_color_G/window_size;
        res_image(x,y,3)=output_color_B/window_size;
    end
end
output_image = res_image;
