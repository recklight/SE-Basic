function [InpDim,OutDim]=Train_Feature_Extraction(InputPar)

MyCleanList=GetFileNames(InputPar.TrRefList);
MyNoisyList=GetFileNames(InputPar.TrInpList);

Ws   = InputPar.Ws;

CleanData=[];NoisyData=[];

copyToPath='.';

SelPerSent=130;

filenum=length(MyNoisyList);

for i=1:filenum
    x=audioread(MyCleanList{i});
    TmpFea=[];TmpFea=FeatureExtract(x,InputPar);    
    ClnPowSpec=[];ClnPowSpec=log10(TmpFea);
    
    x=audioread(MyNoisyList{i});
    TmpFea=[];TmpFea=FeatureExtract(x,InputPar);    
    NoyPowSpec=[];NoyPowSpec=log10(TmpFea);    
    
    if size(TmpFea,2) >= SelPerSent
        sel=randperm(size(TmpFea,2),SelPerSent);
        CleanData=[CleanData;ClnPowSpec(:,sel)'];
        NoisyData=[NoisyData;NoyPowSpec(:,sel)'];
    else
        CleanData=[CleanData;ClnPowSpec'];
        NoisyData=[NoisyData;NoyPowSpec'];
    end
    
end

outdata=[];indata=[];
outdata=CleanData;
OutDim=size(outdata,2);
save(sprintf('%s/ClTrInData',copyToPath),'outdata','-v7.3');
clear outdata CleanData TmpFea

NoisyData=MakePatchesFromX(NoisyData',Ws)';
NoyInfo=RenewedMV(NoisyData);
NoyMVInfo.Mean=NoyInfo.Mean;
NoyMVInfo.Vari=NoyInfo.Vari;
runName=sprintf('%s/%s_INFO.mat',copyToPath,InputPar.runName);
save(runName,'NoyMVInfo');
clear NoyMVInfo

indata=MVNormalized(NoisyData);
InpDim=size(indata,2);

save(sprintf('%s/NyTrInData',copyToPath),'indata','-v7.3');

end


function OutMat=MVNormalized(InpMat)
OutMat=zeros(size(InpMat));

Avrg=mean(InpMat);
Vari=std(InpMat);

OutMat=bsxfun(@rdivide, bsxfun(@minus, InpMat,Avrg), Vari);

end

function MVInfo=RenewedMV(InpMat)
MVInfo.Mean=mean(InpMat);
MVInfo.Vari=std(InpMat);

end
