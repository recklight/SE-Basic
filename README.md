# SE-Basic
SpeechEnhancementLeaningBasic

SE-basic為一專門為具備Matlab基礎的同學設計的語音增強學習程式。
SE-basic結合Matlab與Keras，特點是對於以往使用Matlab的同學更容易上手，而使用Keras能夠快速的學習如何建立模型以及訓練模型。

## 使用方法:
使用本範例前，需先在電腦系統上安裝tensorflow CPU版本或是GPU版本，若安裝GPU版本則需另外安裝相對應的CUDA版本，本範例是以GPU版本講述。

1.安裝python 3.6.7.
2.安裝CUDA10.0-windows10與cudnn-10.0-windows-v7.4.1.5.

3.下載SE-Basic: 
```
cd C:\
git clone https://github.com/recklight/SE-Basic.git
```

4.安裝所需 Packages:
```
pip install -r requirements.txt
```

5.開啟Matlab，將Currnt Folder移至 C:\SE-Basic 後運行All_Proc_Matlab_Python.m:

```
matlab
```

6.評估語音指標結果將顯示在 C:\SE-Basic\eva_result 下:

![image](https://github.com/recklight/SE-basic/blob/master/result.png)
