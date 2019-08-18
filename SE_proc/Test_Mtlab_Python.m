function Test_Mtlab_Python(InputPar)

InpSorceList =GetFileNames(InputPar.TsInpList);

Ws   = InputPar.Ws;
DivFilNum=200;

load([InputPar.runName,'_INFO']);


filenum=length(InpSorceList);

FrameCounter=zeros(1,filenum);
NoisyData=[];NoyPar=[];StrInd=1;
for i=1:filenum
    x=audioread(InpSorceList{i});TmpFea=[];
    NoyParmeter=[];[TmpFea,NoyParmeter]=FeatureExtract(x,InputPar);
    FeaDim=size(TmpFea,1);
    
    TmpFea=log10(TmpFea);
    NoyPar=[NoyPar,NoyParmeter];

    FrameCounter(i)=size(TmpFea,2);
    
    NoisyData=[NoisyData,MakePatchesFromX(TmpFea,Ws)];
    if (i ==  filenum) || (mod(i,DivFilNum) == 0)
        NorNoisyData=[];
        NorNoisyData=bsxfun(@rdivide,bsxfun(@minus,NoisyData,NoyMVInfo.Mean'), NoyMVInfo.Vari');
        EnhancedData=PythonCmputDAE(NorNoisyData,InputPar.Model);
        FinalStepSaveData(InpSorceList,[StrInd;i],EnhancedData,NoyPar,FrameCounter,FeaDim,InputPar)
        StrInd=i+1;NoisyData=[];NoyPar=[];
    end
    
    
end

end

function EnhancedData=PythonCmputDAE(InputMat,Model)

EnhancedData=[];TstDataMVN=InputMat;

TsDataPath='./TestDataMVN.mat';ReTsDaPath='./ReconSpectrumPatch.mat';

TstDataMVN=TstDataMVN';
save(TsDataPath,'TstDataMVN','-v7.3');TstDataMVN=[];

CmdName=sprintf('python ./Test16K.py %s %s',TsDataPath,Model);
system(CmdName);

load(ReTsDaPath);
EnhancedData=double(ReconSpectrumPatch');

end

function FinalStepSaveData(WavePth,FilInd,EnhancedData,NoyPar,FrameCounter,FeaDim,InputPar)

FirInd=FilInd(1);LstInd=FilInd(2);
fs=InputPar.SampleRate;
for i=FirInd:LstInd    
    EnhData=[];EnhFeat=[];     
    if FirInd ~= i
        StrPt=sum(FrameCounter(1,FirInd:i-1))+1;
    else
        StrPt=1;
    end
    FinPt=StrPt+FrameCounter(1,i)-1;
    EnhData=EnhancedData(:,StrPt:FinPt);    
    EnhFeat=SpectrumRecoverFromPatch(EnhData,FeaDim);
    EnhFeat=power(10,EnhFeat);
    NoyParameter=[];NoyParameter=NoyPar(:,StrPt:FinPt);
    siga=Feature2Wave(EnhFeat,NoyParameter,InputPar);
    
    PerWaveSplit=split(WavePth{i},'noisy\');
    OutWavePth=fullfile('outwav',char(PerWaveSplit(2)));  
    if exist(fileparts(OutWavePth),'dir') ~= 7
        mkdir(fileparts(OutWavePth));
    end
    audiowrite(OutWavePth,siga,fs);siga=[];
end
end

