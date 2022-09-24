% main file 
close all
clear all

samples = 320;
lines = 240;

target_filename = 'C:\Users\yijing\Documents\MATLAB\0804&0810實驗室_上臂阻斷\normal2_temp4envi_aligned2_corrected_temp';  %%對位過影像
arm_mask_filename = 'C:\Users\yijing\Documents\MATLAB\0804&0810實驗室_上臂阻斷\normal2_temp4envi_aligned2_corrected_temp_arm_mask';   %%手部分黑白mask

target = multibandread(target_filename, [lines,samples,3000],'double',0,'bsq','ieee-le');
arm_mask = multibandread(arm_mask_filename,[lines,samples,1],'uint8',0,'bsq','ieee-le');

t50 = 0.5:0.5:50;   %%時間軸(x軸)向量
log_t50 = log(t50);

der1T = zeros(lines,samples,100);     %一階TSR
der2T = zeros(lines,samples,100);     %二階TSR

%背景溫度計算(用第1800張手溫度的平均)
% sumT=0;
% cnt=0;
% for i=1:lines
%     for j=1:samples
%         if arm_mask(i,j)==1     %%如果是手部分
%             sumT=sumT+target(i,j,1900);
%             cnt=cnt+1;
%         end
%     end
% end
% averageT=sumT/cnt;

for i=1:lines
    for j=1:samples
        if arm_mask(i,j)==1     %%如果是手部分

            %一階TSR
            T = target(i,j,1801:1900);
            log_T = log(T);
            p = polyfit(log_t50,log_T,5);  
            p_1dr = polyder(p);
            der1T(i,j,:) = polyval(p_1dr,log_t50).*exp(polyval(p,log_t50));

            %二階TSR
            TT = der1T(i,j,:);
            log_TT = log(TT);
            p = polyfit(log_t50,log_TT,5);
            p_2dr = polyder(p);
            der2T(i,j,:) = polyval(p_2dr,log_t50).*exp(polyval(p,log_t50))+((polyval(p_1dr,log_t50)).^2).*exp(polyval(p,log_t50));   

            %二階上次錯誤少加已改掉
%         else
%             der1T(i,j,:) = averageT;
%             der2T(i,j,:) = averageT;
        end
    end
end
multibandwrite(der1T,'normal2_temp4envi_aligned2_corrected_temp_TSR','bsq');
multibandwrite(der2T,'normal2_temp4envi_aligned2_corrected_temp_TSR_DER2','bsq');


