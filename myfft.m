close all
clear all

samples = 320;
lines = 240;
Fs = 2;   %sampling frequency
T=1/Fs;
%endtime要記得換!!!要被2整除
%0209_pt1:1194  pt2~pt4:1256
%0810 normal2:1144 normal3:1197 normal4_1:1326(比較怪) normal4_2:1195(比較正常)
endtime=1196;

%0209_pt1 下降時間1194
target_filename = 'C:\Users\yijing\Documents\MATLAB\0804&0810實驗室_上臂阻斷\normal4_temp4envi_aligned_corrected_temp';
cv_filename = 'C:\Users\yijing\Documents\MATLAB\0804&0810實驗室_上臂阻斷\normal4_temp4envi_aligned_corrected_temp_microvesselmask';   %%手部分黑白mask

target = multibandread(target_filename, [lines,samples,3000],'double',0,'bsq','ieee-le');
cv_mask = multibandread(cv_filename,[lines,samples,1],'uint8',0,'bsq','ieee-le');

pixelcnt=0;
sum_afterfft_1=0;
sum_afterfft_2=0;
sum_afterfft_3=0;
sum_afterfft_4=0;
cnt=0;
for i=1:lines
    for j=1:samples
        if cv_mask(i,j)==1     %%如果是大/微血管的部分
            n=1024;
            %-mean
            curvetarget=target(i,j,1:endtime);  %把到下降前的曲線數據陣列擷取出來
            curvetarget=squeeze(curvetarget);       %變成二維
            curvetarget=curvetarget';
            curvetarget=curvetarget-mean(curvetarget);
%             curvetarget=detrend(curvetarget,1);
            afterfft=fft(curvetarget,n);
            afterfft=power(afterfft,2);
            afterfft=abs(afterfft);
            sum_afterfft_1=sum_afterfft_1+afterfft;

            %1st order detrend
            curvetarget=target(i,j,1:endtime);  %把到下降前的曲線數據陣列擷取出來
            curvetarget=squeeze(curvetarget);       %變成二維
            curvetarget=curvetarget';
            curvetarget=detrend(curvetarget,1);
            afterfft=fft(curvetarget,n);
            afterfft=power(afterfft,2);
            afterfft=abs(afterfft);
            sum_afterfft_2=sum_afterfft_2+afterfft;

            %2st order detrend
            curvetarget=target(i,j,1:endtime);  %把到下降前的曲線數據陣列擷取出來
            curvetarget=squeeze(curvetarget);       %變成二維
            curvetarget=curvetarget';
            curvetarget=detrend(curvetarget,2);
            afterfft=fft(curvetarget,n);
            afterfft=power(afterfft,2);
            afterfft=abs(afterfft);
            sum_afterfft_3=sum_afterfft_3+afterfft;
            
            %highpass filter
            curvetarget=target(i,j,1:endtime);  %把到下降前的曲線數據陣列擷取出來
            curvetarget=squeeze(curvetarget);       %變成二維
            curvetarget=curvetarget';
            curvetarget = highpass(curvetarget,0.004,Fs);
            afterfft=fft(curvetarget,n);
            afterfft=power(afterfft,2);
            afterfft=abs(afterfft);
            sum_afterfft_4=sum_afterfft_4+afterfft;

            pixelcnt=pixelcnt+1
        end
    end
end
sum_afterfft_1=sum_afterfft_1./pixelcnt;     %取平均
sum_afterfft_2=sum_afterfft_2./pixelcnt; 
sum_afterfft_3=sum_afterfft_3./pixelcnt; 
sum_afterfft_4=sum_afterfft_4./pixelcnt; 

f=(0:1:endtime/2)*Fs/endtime;
f=f';

%-mean處理
sum_afterfft_1=sum_afterfft_1(1:endtime/2+1);
A_adj_1=zeros(endtime/2+1,1);
A_adj_1(1)=sum_afterfft_1(1)/endtime;
A_adj_1(end)=sum_afterfft_1(end)/endtime;
A_adj_1(2:end-1)=2*sum_afterfft_1(2:end-1)/endtime;

figure,
subplot(221);plot(f,A_adj_1),xlim([0.005 0.0095]),xlabel('f(Hz)'),ylabel('power'),title('FFT(0.005-0.0095Hz)')
subplot(222);plot(f,A_adj_1),xlim([0.0095 0.02]),xlabel('f(Hz)'),ylabel('power'),title('FFT(0.0095-0.02Hz)')
subplot(223);plot(f,A_adj_1),xlim([0.02 0.06]),xlabel('f(Hz)'),ylabel('power'),title('FFT(0.02-0.06Hz)')
subplot(224);plot(f,A_adj_1),xlim([0.06 0.2]),xlabel('f(Hz)'),ylabel('power'),title('FFT(0.06-0.2Hz)')

%1st order detrend處理
sum_afterfft_2=sum_afterfft_2(1:endtime/2+1);
A_adj_2=zeros(endtime/2+1,1);
A_adj_2(1)=sum_afterfft_2(1)/endtime;
A_adj_2(end)=sum_afterfft_2(end)/endtime;
A_adj_2(2:end-1)=2*sum_afterfft_2(2:end-1)/endtime;

figure,
subplot(221);plot(f,A_adj_2),xlim([0.005 0.0095]),xlabel('f(Hz)'),ylabel('power'),title('FFT(0.005-0.0095Hz)')
subplot(222);plot(f,A_adj_2),xlim([0.0095 0.02]),xlabel('f(Hz)'),ylabel('power'),title('FFT(0.0095-0.02Hz)')
subplot(223);plot(f,A_adj_2),xlim([0.02 0.06]),xlabel('f(Hz)'),ylabel('power'),title('FFT(0.02-0.06Hz)')
subplot(224);plot(f,A_adj_2),xlim([0.06 0.2]),xlabel('f(Hz)'),ylabel('power'),title('FFT(0.06-0.2Hz)')

%2st order detrend處理
sum_afterfft_3=sum_afterfft_3(1:endtime/2+1);
A_adj_3=zeros(endtime/2+1,1);
A_adj_3(1)=sum_afterfft_3(1)/endtime;
A_adj_3(end)=sum_afterfft_3(end)/endtime;
A_adj_3(2:end-1)=2*sum_afterfft_3(2:end-1)/endtime;

figure,
subplot(221);plot(f,A_adj_3),xlim([0.005 0.0095]),xlabel('f(Hz)'),ylabel('power'),title('FFT(0.005-0.0095Hz)')
subplot(222);plot(f,A_adj_3),xlim([0.0095 0.02]),xlabel('f(Hz)'),ylabel('power'),title('FFT(0.0095-0.02Hz)')
subplot(223);plot(f,A_adj_3),xlim([0.02 0.06]),xlabel('f(Hz)'),ylabel('power'),title('FFT(0.02-0.06Hz)')
subplot(224);plot(f,A_adj_3),xlim([0.06 0.2]),xlabel('f(Hz)'),ylabel('power'),title('FFT(0.06-0.2Hz)')

%highpass filter處理
sum_afterfft_4=sum_afterfft_4(1:endtime/2+1);
A_adj_4=zeros(endtime/2+1,1);
A_adj_4(1)=sum_afterfft_4(1)/endtime;
A_adj_4(end)=sum_afterfft_4(end)/endtime;
A_adj_4(2:end-1)=2*sum_afterfft_4(2:end-1)/endtime;

figure,
subplot(221);plot(f,A_adj_4),xlim([0.005 0.0095]),xlabel('f(Hz)'),ylabel('power'),title('FFT(0.005-0.0095Hz)')
subplot(222);plot(f,A_adj_4),xlim([0.0095 0.02]),xlabel('f(Hz)'),ylabel('power'),title('FFT(0.0095-0.02Hz)')
subplot(223);plot(f,A_adj_4),xlim([0.02 0.06]),xlabel('f(Hz)'),ylabel('power'),title('FFT(0.02-0.06Hz)')
subplot(224);plot(f,A_adj_4),xlim([0.06 0.2]),xlabel('f(Hz)'),ylabel('power'),title('FFT(0.06-0.2Hz)')

%四種detrend處理和在一張
figure,
subplot(221);plot(f(1:102),A_adj_1(1:102)),xlim([0 0.2]),xlabel('f(Hz)'),ylabel('power'),title('FFT(after minus mean)')
subplot(222);plot(f(1:102),A_adj_2(1:102)),xlim([0 0.2]),xlabel('f(Hz)'),ylabel('power'),title('FFT(after 1st order detrend)')
subplot(223);plot(f(1:102),A_adj_3(1:102)),xlim([0 0.2]),xlabel('f(Hz)'),ylabel('power'),title('FFT(after 2nd order detrend)')
subplot(224);plot(f(1:102),A_adj_4(1:102)),xlim([0 0.2]),xlabel('f(Hz)'),ylabel('power'),title('FFT(after highpass filter)')

%頻率段加總
%[0.005 0.0095]=>點3~點4(前後點都含)
%[0.0095 0.002]=>點5~點10
%[0.002 0.006]=>點11~點30
%[0.006 0.2]=>點31~點102
sum_range1_A_adj_1=0;
sum_range2_A_adj_1=0;
sum_range3_A_adj_1=0;
sum_range4_A_adj_1=0;
sum_range1_A_adj_2=0;
sum_range2_A_adj_2=0;
sum_range3_A_adj_2=0;
sum_range4_A_adj_2=0;
sum_range1_A_adj_3=0;
sum_range2_A_adj_3=0;
sum_range3_A_adj_3=0;
sum_range4_A_adj_3=0;
sum_range1_A_adj_4=0;
sum_range2_A_adj_4=0;
sum_range3_A_adj_4=0;
sum_range4_A_adj_4=0;
for i=3:4
    sum_range1_A_adj_1=sum_range1_A_adj_1+A_adj_1(i);
    sum_range1_A_adj_2=sum_range1_A_adj_2+A_adj_2(i);
    sum_range1_A_adj_3=sum_range1_A_adj_3+A_adj_3(i);
    sum_range1_A_adj_4=sum_range1_A_adj_4+A_adj_4(i);
end    
for i=5:10
    sum_range2_A_adj_1=sum_range2_A_adj_1+A_adj_1(i);
    sum_range2_A_adj_2=sum_range2_A_adj_2+A_adj_2(i);
    sum_range2_A_adj_3=sum_range2_A_adj_3+A_adj_3(i);
    sum_range2_A_adj_4=sum_range2_A_adj_4+A_adj_4(i);
end   
for i=11:30
    sum_range3_A_adj_1=sum_range3_A_adj_1+A_adj_1(i);
    sum_range3_A_adj_2=sum_range3_A_adj_2+A_adj_2(i);
    sum_range3_A_adj_3=sum_range3_A_adj_3+A_adj_3(i);
    sum_range3_A_adj_4=sum_range3_A_adj_4+A_adj_4(i);
end   
for i=31:102
    sum_range4_A_adj_1=sum_range4_A_adj_1+A_adj_1(i);
    sum_range4_A_adj_2=sum_range4_A_adj_2+A_adj_2(i);
    sum_range4_A_adj_3=sum_range4_A_adj_3+A_adj_3(i);
    sum_range4_A_adj_4=sum_range4_A_adj_4+A_adj_4(i);
end   

%取平均
%第1種detrend四個頻率段
average_range1_A_adj_1=sum_range1_A_adj_1/2;
average_range2_A_adj_1=sum_range2_A_adj_1/6;
average_range3_A_adj_1=sum_range3_A_adj_1/20;
average_range4_A_adj_1=sum_range4_A_adj_1/72;
%第2種detrend四個頻率段
average_range1_A_adj_2=sum_range1_A_adj_2/2;
average_range2_A_adj_2=sum_range2_A_adj_2/6;
average_range3_A_adj_2=sum_range3_A_adj_2/20;
average_range4_A_adj_2=sum_range4_A_adj_2/72;
%第3種detrend四個頻率段
average_range1_A_adj_3=sum_range1_A_adj_3/2;
average_range2_A_adj_3=sum_range2_A_adj_3/6;
average_range3_A_adj_3=sum_range3_A_adj_3/20;
average_range4_A_adj_3=sum_range4_A_adj_3/72;
%第4種detrend四個頻率段
average_range1_A_adj_4=sum_range1_A_adj_4/2;
average_range2_A_adj_4=sum_range2_A_adj_4/6;
average_range3_A_adj_4=sum_range3_A_adj_4/20;
average_range4_A_adj_4=sum_range4_A_adj_4/72;