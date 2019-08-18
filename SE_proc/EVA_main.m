function EVA_main(InputPar)

if exist('evawave','dir') ~=7
    copy_file
end

ResultFolder = InputPar.runName;
FinNos = dir('evawave\noy');
NoiseName={};MagdB={};
for i =3:length(FinNos)
    NoiseName{i-2} = FinNos(i).name;
end
FinMag = dir(['evawave\noy\',NoiseName{1}]);
for i =3:length(FinMag)
    MagdB{i-2} = FinMag(i).name;
end

indir1 = 'evawave\cln';%  clean data
outdir = ['eva_result\',ResultFolder];%  results
mkdir(outdir)

MeanFileName = ['mean_'];
fid = fopen(sprintf('%s%s%s.txt',outdir,filesep,MeanFileName),'wb');
fprintf(fid,'%20s:\t%8s\t%8s\t%8s\t%8s\n','EVALUATED METHODS','PESQ','SDI','STOI','SSNRI');

for i = 1:length(NoiseName)
    for j = 1:length(MagdB)
        indir2 = ['evawave\noy\',NoiseName{i},filesep,MagdB{j}];% noisy data
        indir3 = ['evawave\enh\',NoiseName{i},filesep,MagdB{j}];% enhanced data
        Result = EVA_Mean(indir1,indir2,indir3);
        InFileName = [NoiseName{i},'_',MagdB{j}];

        mean_pesq=Result.mean_pesq;
        mean_stoi=Result.mean_stoi;
        mean_sdi=Result.mean_sdi;
        mean_ssnr=Result.mean_ssnr;

        fprintf(fid,'%20s:\t%f\t%f\t%f\t%f\n',InFileName,mean_pesq,mean_sdi,mean_stoi,mean_ssnr);     
    end
end
fclose(fid);
delete 'cln.wav'
delete 'enh.wav'
delete '_pesq_results.txt'
delete '_pesq_itu_results.txt'

end

function  Result = EVA_Mean(indir1,indir2,indir3)
if  indir1(end) == filesep
    indir1=indir1(1:(end-1));
end
if  indir2(end) == filesep
    indir2=indir2(1:(end-1));
end
if  indir3(end) == filesep
    indir3=indir3(1:(end-1));
end

filelist_1=dir(indir1);
filelist_2=dir(indir2);
filelist_3=dir(indir3);
filelist_len=length(filelist_1);

for k=3:filelist_len      
        CleanDataFile=fullfile(indir1, filelist_1(k).name);
        NoisyDataFile=fullfile(indir2, filelist_2(k).name);
        EnhadDataFile=fullfile(indir3, filelist_3(k).name);
        
        [TCleanData,~]=audioread(CleanDataFile);
        [TNoisyData,~]=audioread(NoisyDataFile);
        [TEnhadData,fe]=audioread(EnhadDataFile);
       
        minimum_points=min([length(TCleanData),length(TNoisyData),length(TEnhadData)]);
        Idx=1:minimum_points;
        
        CleanData=TCleanData(Idx);
        NoisyData=TNoisyData(Idx);
        EnhadData=TEnhadData(Idx);

        len=256;
        stoi_scor(k-2) = stoi(CleanData, EnhadData, fe); 
        sdi(k-2)=compute_sdi(CleanData,EnhadData);
        ssnr_dB(k-2)=ssnr(EnhadData,NoisyData,CleanData,256);
        copyfile(CleanDataFile,'cln.wav');
        copyfile(EnhadDataFile,'enh.wav');
        [~,strout]=system('SE_proc\pesq.exe +16000 cln.wav enh.wav');
        c=strfind(strout,'Prediction : PESQ_MOS = ');
        pesq_mos(k-2)=str2double(strout(c+23:c+28));

end
    Result.mean_sdi=mean(sdi);
    Result.mean_ssnr=mean(ssnr_dB);
    Result.mean_pesq=mean(pesq_mos);
    Result.mean_stoi=mean(stoi_scor);
end

function copy_file

lia = dir('outwav/**/*.wav');
for i = 1:length(lia)
    lia_split1 = split(lia(i).folder,'outwav\');
    lia_split2 = split(lia_split1(2),'\test\');        
    EnhPthSour = fullfile(lia(i).folder,lia(i).name);
    EnhPthDest = char(fullfile('evawave\enh',lia_split2(1),lia(i).name));
    
    ClnPthSour = char(fullfile('clean\test',lia_split2(2),lia(i).name));
    ClnPthDest = char(fullfile('evawave\cln',lia(i).name));
    
    NoyPthSour =  char(fullfile('Testing\noisy',lia_split1(2),lia(i).name));
    NoyPthDest = char(fullfile('evawave\noy',lia_split2(1),lia(i).name));
   
    if exist(fileparts(EnhPthDest),'dir') ~= 7
        mkdir(fileparts(EnhPthDest));
    end
    copyfile(EnhPthSour,EnhPthDest);

    if exist(fileparts(ClnPthDest),'dir') ~= 7
        mkdir(fileparts(ClnPthDest));
    end
    if exist(ClnPthDest) == 0
        copyfile(ClnPthSour,ClnPthDest);
    end
    
    if exist(fileparts(NoyPthDest),'dir') ~= 7
        mkdir(fileparts(NoyPthDest));
    end
    copyfile(NoyPthSour,NoyPthDest);
end

end
