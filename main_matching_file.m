% main file 
close all
clear all
% read Template&target image
lower_template_filename = 'C:\Users\yijing\Documents\MATLAB\testPM0320_pt3\left_template';
upper_template_filename = 'C:\Users\yijing\Documents\MATLAB\testPM0320_pt3\right_template';
target_filename = 'C:\Users\yijing\Documents\MATLAB\testPM0320_pt3\PM0320_pt3_corrected_temp';
lower_temp = multibandread(lower_template_filename, [18,17,3000],'double',0,'bsq','ieee-le');     %右下三角形
upper_temp = multibandread(upper_template_filename, [17,17,3000],'double',0,'bsq','ieee-le');     %左上三角形
target = multibandread(target_filename, [240,320,3000],'double',0,'bsq','ieee-le');

[fixed_lower_j,fixed_lower_i]=template_matching(lower_temp(:,:,1),target(:,:,1));        %第一張fixedpoint固定
[fixed_upper_j,fixed_upper_i]=template_matching(upper_temp(:,:,1),target(:,:,1));

fixedpoints = [fixed_upper_i+7 fixed_upper_j+3;
               fixed_upper_i+13 fixed_upper_j+9;
               fixed_upper_i+8 fixed_upper_j+14;
               fixed_lower_i+11 fixed_lower_j+4;
               fixed_lower_i+14 fixed_lower_j+12;
               fixed_lower_i+5 fixed_lower_j+16];

corrected_pic = zeros(size(target));    %對位好的影像矩陣

for i = 2180:2300
    [lower_j,lower_i]=template_matching(lower_temp(:,:,1),target(:,:,i));        %2~3000 movingpoints
    [upper_j,upper_i]=template_matching(upper_temp(:,:,1),target(:,:,i));
    
%     imshowpair(target(:,:,1),target(:,:,i),'diff')
    
    movingpoints = [upper_i+7 upper_j+3;
                   upper_i+13 upper_j+9;
                   upper_i+8 upper_j+14;
                   lower_i+11 lower_j+4;
                   lower_i+14 lower_j+12;
                   lower_i+5 lower_j+16];
    
    tform = fitgeotrans(movingpoints,fixedpoints,'nonreflectivesimilarity')
    Jregistered = imwarp(target(:,:,i),tform,'OutputView',imref2d(size(target(:,:,1))));
    corrected_pic(:,:,i) = Jregistered;
    disp(i)
%     figure
%     imagesc(corrected_pic(:,:,i))
%     imshowpair(target(:,:,1),Jregistered,'diff')
end
multibandwrite(corrected_pic,'test_0209_pt1_corrected_image','bsq');

% 
% figure,
% subplot(2,2,1),imagesc(pm1(:,:,1));title('Template');
% subplot(2,2,2),imagesc(pm2(:,:,1));title('Target');
% subplot(2,2,3),imagesc(result1);title('Matching Result using tmp');
