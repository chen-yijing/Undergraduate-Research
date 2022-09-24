clc;
clear;

filename = 'C:\Users\yijing\Documents\MATLAB\20220919\test2_temp4envi';
temp_filename = "C:\Users\yijing\Documents\MATLAB\20220919\test2_temp4envi_blackbody.txt";
pm1 = multibandread(filename, [240,320,2361],'double',0,'bsq','ieee-le');
profile = readmatrix(temp_filename);
profile = profile(:,2);     %%profile是儲存黑體溫度變化的陣列
% index = [1:3000];
a_correction=zeros(240,320,2361);

for i=1:2361
    a_correction(:,:,i)=pm1(:,:,i)-profile(i,1)+25;
end
multibandwrite(a_correction,'test2_temp4envi_corrected_temp','bsq');



% finalfixed = zeros(240,320,3000);
% fixed = pm1(:,:,1);
% for i = 2600:2700
%     moving = pm1(:,:,i);
%     %moving = rgb2gray(moving);
%     [optimizer,metric] = imregconfig('Multimodal');
%     registered = imregister(moving,fixed,'affine',optimizer,metric);
%     finalfixed(:,:,i) = registered;
%     disp(i);
% end
% multibandwrite(finalfixed,'fixed_image','bsq');

% coordinates_input = [55 46];

%整張影像的profile 240*320
% pixels = size(pm1,1)*size(pm1,2);       %%pixel=240*320   
% bands =size(pm1,3);     %%bands=3000
% pt1_reshape = reshape(pm1,[pixels,bands]);      %%把原本pm1是240*320*3000儲存方式reshape成76800*3000





% for i = 1:size(pm1,1)
%     for j=1:size(pm1,2)
%        a_correction(i,j,:) = squeeze(pm1(i,j,:))-profile+25;
%     end
% end
% test_aftercorrection = reshape(a_correction,[240,320,3000]);


% original spectral profile
%for i =1:pixels      %%for迴圈跑pt1_reshape的每個pixel點
%     a(:,i) = squeeze(pt1_reshape(i,:));
%     a_correction(i,:) = pt1_reshape(i,:)-profile'+25;      %%原本溫度-黑體溫度變化+黑體設置溫度25=實際溫度變化
% end
% aftercorrection = reshape(a_correction,[240,320,3000]);

% for i =1:bands
%     b(i,1) = mean(a(i,:));
%     b_correction(i,1) = mean(a_correction(i,:));
%     disp("num= "+i);
% end

% figure;
% %%校正溫度前 原圖
% subplot(2,1,1),plot(b),title("original temperature profile");       %%b當y軸
% %%拿黑體溫度校正完後
% subplot(2,1,2),plot(b_correction),title("after correct temperature profile");   %%b_correction當y軸
% 
% figure;
% while true
%     subplot(3,2,2),plot(squeeze(pm1(round(coordinates_input(2)),round(coordinates_input(1)),:)));   
%     %%3*2的大小的2位置作圖，input那個點上的溫度變化
%     subplot(3,2,4),plot(profile);   
%     %%3*2的4位置作圖，黑體溫度變化取線
%     subplot(3,2,6),plot(index,squeeze(pm1(round(coordinates_input(2)),round(coordinates_input(1)),:))-profile+25);
%     %%3*2的6位置作圖，點上原本溫度-黑體溫度變化+黑體設置溫度25=實際溫度變化
%     subplot(3,2,[1,3,5]),imshow(pm1(:,:,1),[]);     %%show出手的圖
%     coordinates_input = ginput(1);      %%讀入input座標
% end
% % close(h);
