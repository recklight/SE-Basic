function OutData=Feature2Wave(InpFea,InpFeaPar,InputPar)

OutData=[];

FFT_SIZE  =InputPar.FFT_SIZE;
SampleRate=InputPar.SampleRate;
FrameRate =InputPar.FrameRate;
FrameSize =InputPar.FrameSize; 
OutData=SpectToWave(InpFea,InpFeaPar,FrameSize,FrameRate);


end

function Outdata=SpectToWave(InpSpec,yphase,windowLen,ShiftLen)

yphase =yphase(1:floor(size(yphase,1)/2)+1,:);
Outdata=OverlapAdd(sqrt(InpSpec),yphase,windowLen,ShiftLen);

end
