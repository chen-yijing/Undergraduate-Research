# Undergraduate-Research
專題相關程式檔案與簡單說明
***
## 題目：洗腎患者的循環功能評估方法
***
## 程式建構環境：
Matlab、ENVI
***
## 大致實驗流程：
影像對位、溫度校正、影像強化與重建、訊號去趨勢化、頻譜分析、結果呈現
***
## 詳細說明：
對洗腎患者做上臂動脈阻斷實驗，利用熱像儀錄製成影像，  
實驗總時長25分鐘，0-10分鐘靜置期，10分時進行血壓臂帶的加壓，使其維持在180-200mmHg，進行血流的阻斷，  
維持到15分時進行放氣，血流回復，最後15-25分鐘靜置觀察。  
對影像做處理，主要針對大血管、微血管及皮膚做分析，  
先在時間域的訊號上探討各組織的反應，再轉換到頻率域做進一步分析，並與正常人的數據做比對，希望能找出造成洗腎患者循環功能較差的原因。
***
### 影像對位：
main_matching_file.m  
利用template matching方法進行對位
***
### 溫度校正：
temp_correct.m  
用ENVI取出黑體的平均溫度變化曲線後，對影像進行溫度校正
***
### 影像強化與重建：
TSR.m  
用ENVI調整對比度、熱影像信號重建(thermographic signal reconstruction, TSR)
***
### 訊號去趨勢化、頻譜分析：
myfft.m  
先對信號做去趨勢化，方法有四種：減去平均數、一次detrend去除線性趨勢、二次detrend去除二次趨勢、截止頻率為0.004 Hz的高通濾波器，
之後做快速傅立葉轉換做頻譜分析
***
### 結果呈現：

大致結果會如下圖來呈現

三種組織取前1200幀圖像做完四種detrend及FFT的結果
![image](https://user-images.githubusercontent.com/76909063/192106828-2d90da40-7505-44fc-ba7e-186fca8d9629.png)

三種組織用減去平均溫度的去趨勢後執行FFT的結果，分成四個頻率段
![image](https://user-images.githubusercontent.com/76909063/192106756-f8337efd-538d-489c-a67e-e1b6ad2e9fb1.png)

三種組織用detrend指令，n=1去趨勢化後執行FFT的結果，分成四個頻率段
![image](https://user-images.githubusercontent.com/76909063/192106794-ce96b4e3-ff91-4869-bba9-c08f2963b5c5.png)

三種組織用detrend指令，n=2，去趨勢化後執行FFT的結果，分成四個頻率段
![image](https://user-images.githubusercontent.com/76909063/192106811-6e09edef-c8c5-4e59-b0c2-687e50b7c026.png)

三種組織用highpass指令，截止頻率為0.004 Hz，去趨勢化後執行FFT的結果，分成四個頻率段
![image](https://user-images.githubusercontent.com/76909063/192106818-d14ccd5f-c67b-4ab1-a71b-467a93bc7c4c.png)

四個頻率段對應到的細胞活動如下圖
![image](https://user-images.githubusercontent.com/76909063/192107159-fd7409e2-4bf6-470c-a62d-85fb800d39ab.png)


