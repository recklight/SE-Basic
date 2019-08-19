# SE-basic
SpeechEnhancementLeaningBasic

SE-basic為一專門為具備Matlab基礎的同學設計的語音增強學習程式。
SE-basic結合Matlab與Keras，特點是對於以往使用Matlab的同學更容易上手，而使用Keras能夠快速的學習如何建立模型以及訓練模型。

## 使用方法:
1.需先在電腦系統上安裝tensorflow CPU版本或是GPU版本，若安裝GPU版本則需另外安裝相對應的CUDA版本，安裝教學將於SE-Keras講述。

2.下載SE-basic: 
```
git clone https://github.com/recklight/SE-basic.git
```

3.安裝所需 Python packages:
```
pip install -r requirements.txt
```

4.開啟matlab，將Currnt Folder移至 ../SE-basic 後運行主程式:

```
All_Proc_Matlab_Python.m
```

5.評估語音指標結果將顯示在 SE-basic\eva_result 下:

![image](https://github.com/recklight/SE-basic/blob/master/result.png)
