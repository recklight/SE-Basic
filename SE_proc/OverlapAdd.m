function sig=OverlapAdd(X,yphase,windowLen,ShiftLen)

[FreqRes FrameNum]=size(X);

Spec=X.*exp(j*yphase);

if mod(windowLen,2) %if FreqResol is odd
    Spec=[Spec;flipud(conj(Spec(2:end,:)))];
else
    Spec=[Spec;flipud(conj(Spec(2:end-1,:)))];        
end
sig=zeros((FrameNum-1)*ShiftLen+windowLen,1);
for i=1:FrameNum
    start=(i-1)*ShiftLen+1;    
    spec=Spec(:,i);
    sig(start:start+windowLen-1)=sig(start:start+windowLen-1)+real(ifft(spec,windowLen));       
end
return