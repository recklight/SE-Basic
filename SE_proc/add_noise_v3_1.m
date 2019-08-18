function outfilename=add_noise_v3_1(InpPath,NoiseInpPath,OutDir,NoiseOutDir,SNR,INDICATOR)

if nargin == 5; INDICATOR='ts'; end;

trtsThres=1;

[~,nfilenamek] = fileparts(NoiseInpPath);

switch lower(INDICATOR)
    case 'ts'
        [noise_data,nFs]=audioread(NoiseInpPath);
        noise_points=length(noise_data);
        if trtsThres==1
            from_pt=1;
        else
            from_pt=ceil((1-trtsThres)*noise_points);
        end
        noise_data_tp=noise_data(from_pt:end);
    case 'tr'
        [noise_data,nFs]=audioread(NoiseInpPath);
        noise_points=length(noise_data);
        noise_data_tp=noise_data(1:floor(trtsThres*noise_points));
end
noise_data=[];noise_data=noise_data_tp;noise_points=length(noise_data);

% read source file begin%
[speech_data,Fs]=audioread(InpPath);
speech_points=length(speech_data);
speech_data=speech_data-mean(speech_data);
% read source file end%

if nFs ~= Fs
    fprintf('Error! Different sampling rate for noise and speech. %s/%s\n',filenamek,nfilenamek);
    return;
end

if noise_points-speech_points < 0
    noise_data=noise_data_tp;
    for i=1:(floor(speech_points/noise_points)-1);
        noise_data=[noise_data;noise_data_tp];
    end
    noise_data(end+1:end+mod(speech_points,noise_points))=noise_data(1:mod(speech_points,noise_points));  
    noise_points=length(noise_data);
end
from_point=randperm(noise_points-speech_points+1,1);
to_point=from_point+speech_points-1;

noise_data_tmp=zeros(size(noise_data(from_point:to_point)));
noise_data_tmp=sqrt(var(speech_data)/(10^(SNR/10)))*noise_data(from_point:to_point)/std(noise_data(from_point:to_point));
out_speech_data=speech_data+noise_data_tmp;

audiowrite(OutDir,out_speech_data,Fs);
audiowrite(NoiseOutDir,noise_data_tmp,Fs);

end