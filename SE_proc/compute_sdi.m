function sd=compute_sdi(cleanFile,enhdFile)

x = cleanFile;
xh = enhdFile;

% Idx=find(x.^2>0.008);
% newx=x(Idx);
% newxh=xh(Idx);
% sd=mean((newx-newxh).^2)/mean((newx).^2) ;% SDI

xx=zeros(length(xh),1);
for i=1:length(xh)
  xx(i)=x(i);
end
sd=mean((xx-xh).^2)/mean(xx.^2) ;% SDI

end
