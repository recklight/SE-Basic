# SE-Basic
SpeechEnhancementLeaningBasic

SE-basic是一以Matlab為主要架構，且使用Keras建構神經網路而設計的語音增強程式。
SE-basic結合了Matlab資料處理與分析的專長與Keras建構神經網路的簡易性；
SE-basic適合經常使用Matlab、但初次涉略Keras的人。

## 注意:
1.使用本範例前，需先在電腦系統上安裝tensorflow CPU版本或是GPU版本，若安裝GPU版本則需另外安裝相對應的CUDA版本，本範例是以GPU版本講述。
2.本範例使用訓練資料為TIMIT資料庫，因避免涉及法律問題及相關問題故不提供。

## 本實驗環境:
```
System: Windows10
CPU: Intel i9-9900K
GPU: GTX 1080 ti
RAM: 32GB (建議使用16GB以上)
```
## 使用方法:
1.安裝python 3.6 版本

2.安裝CUDA10.0-windows10與cudnn-10.0-windows-v7.4.1.5.

3.下載SE-Basic至指定路徑: 
```
git clone https://github.com/recklight/SE-Basic.git
```

4.安裝所需 Packages:
```
pip install -r requirements.txt
```

4.運行 make_dir.sh

5.開啟Matlab，將Currnt Folder移至 SE-Basic目錄下， 運行All_Proc_Matlab_Python.m

```
cd SE-Basic
matlab
```

6.評估語音指標結果將顯示在路徑 ./eva_result:

![image](https://github.com/recklight/SE-basic/blob/master/result.png)
