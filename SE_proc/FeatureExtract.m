function [OutFea,Others]=FeatureExtract(InpData,InputPar)

OutFea=[];Others=[];
if size(InpData,2) ~= 1;InpData=InpData';end

FFT_SIZE  =InputPar.FFT_SIZE;
SampleRate=InputPar.SampleRate;
FrameRate =InputPar.FrameRate;
FrameSize =InputPar.FrameSize;   
[OutFea,Others] = STFT(InpData,FrameSize,FrameRate,FFT_SIZE, 2); % Others=phase;

end

function [MagSpec,yphase] = STFT(InpData,FrameLength,FrameRate,FFT_SIZE, flag)

Len      =length(InpData);
FrameNum =ceil((Len-FrameLength)/FrameRate+1);
MagSpec  =zeros(FFT_SIZE/2+1,FrameNum); %For Odd sample
yphase   =zeros(FFT_SIZE,FrameNum);
wind     =hamming(FrameLength);
i        =1;
for t = 1:FrameRate:Len-FrameLength
    x_seg          = wind.*InpData(t:(t+FrameLength-1));%plus hamming
    fftspectrum    = fft(x_seg,FFT_SIZE);
    yphase(:,i)    = angle(fftspectrum)';
    MagSpec(:,i)   = abs(fftspectrum(1:FFT_SIZE/2+1,1))'; %For Odd sample
    i              = i+1;
end
if (t+FrameLength-1) < Len
    start_pt =(t+FrameLength);
    missingp =FrameLength-(Len-t-FrameLength+1);
    x_seg           = wind.*[InpData(start_pt:end);InpData(end-1:-1:end-missingp,1)];
    fftspectrum     = fft(x_seg,FFT_SIZE);
    yphase(:,i)     = angle(fftspectrum)';
    MagSpec(:,i)    = abs(fftspectrum(1:FFT_SIZE/2+1,1))'; %For Odd sample
end

if flag==2
    MagSpec  =MagSpec.^2;
elseif flag==1
    return;
else
    MagSpec =fftspectrum(1:FFT_SIZE/2+1,:); %For Odd sample
end
end