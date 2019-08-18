function AddNoise
%% List prepare for AddNoise
BuileFilePth = 'list';
if exist(BuileFilePth,'dir')==0
    mkdir(BuileFilePth);
end

BuileFileNameTr = 'training.txt';
BuileFileNameTs = 'testing.txt';
lib = dir('.\clean\**\*.wav');

fid_tr = fopen(fullfile(BuileFilePth,BuileFileNameTr),'wb');
fid_ts = fopen(fullfile(BuileFilePth,BuileFileNameTs),'wb');
for i = 1:length(lib)
    if ~or(strcmp(lib(i).name,'sa1.wav'), strcmp(lib(i).name,'sa2.wav'))
        lib_split = split(fullfile(lib(i).folder,lib(i).name),'\clean\');
        if findstr(lib(i).folder,'train')
            fprintf(fid_tr,'%s\r\n',char(lib_split(2)));
        else
            fprintf(fid_ts,'%s\r\n',char(lib_split(2)));
        end
    end
end
fclose(fid_tr);
fclose(fid_ts);
%% Training data
TrClnRoot='./clean/';
TrNoyRoot='./Training/';
TrMxNRoot='./Training/mixednoise/';
TrListPth='./list/training.txt';

PtListPth=GetFileNames(TrListPth);
TrClLiPth=cell(length(PtListPth),1);
TrNyLiPth=cell(length(PtListPth),1);
TrNsLiPth=cell(length(PtListPth),1);
NoiseInfo=cell(length(PtListPth),2);

for ListInd=1:length(PtListPth)
    TrClLiPth{ListInd,1}=[TrClnRoot,PtListPth{ListInd}];
    TrNyLiPth{ListInd,1}=[TrNoyRoot,'noisy/',PtListPth{ListInd}];
    TrNsLiPth{ListInd,1}=[TrMxNRoot,PtListPth{ListInd}];
    
        mkdir(fileparts(TrNyLiPth{ListInd,1}));
        mkdir(fileparts(TrNsLiPth{ListInd,1}));
end

TrNosRoot='./Training/noise/';
TrNosSNRi=20:-1:-10;
NosName=dir([TrNosRoot,'**/*.wav']);
for FilNum=1:length(PtListPth)
    NoiseInfo{FilNum,1}=[TrNosRoot,NosName(mod(FilNum-1,length(NosName)-2)+3).name];
    NoiseInfo{FilNum,2}=TrNosSNRi(mod(FilNum-1,length(TrNosSNRi))+1);
end

for FilNum=1:length(PtListPth)
    add_noise_v3_1(TrClLiPth{FilNum,1},NoiseInfo{FilNum,1},TrNyLiPth{FilNum,1},TrNsLiPth{FilNum,1},NoiseInfo{FilNum,2},'tr');
end

%% Testing data
TsClnRoot='./clean/';
TsNoyRoot='./Testing/';
TsMxNRoot='./Testing/mixednoise/';
TsListPth='./list/testing.txt';

TsPtListPth=GetFileNames(TsListPth);
TsClLiPth=cell(length(TsPtListPth),1);
TsNyLiPth=cell(length(TsPtListPth),1);
TsNsLiPth=cell(length(TsPtListPth),1);

for ListInd=1:length(TsPtListPth)
    TsClLiPth{ListInd,1}=[TsClnRoot,TsPtListPth{ListInd}];
end

TsNosRoot='./Testing/noise/';
TsNosSNRi=-5:5:5;
TsNosName=dir(TsNosRoot);
for j=3:length(TsNosName)
    for i=1:length(TsNosSNRi)
        for ListInd=1:length(TsClLiPth)
            if TsNosSNRi(i) >= 0
                TsnoiySNRAbbr=sprintf('%snoisy/%s/%sdB/%s',TsNoyRoot,lower(TsNosName(j).name(1:end-4)),num2str(abs(TsNosSNRi(i))),TsPtListPth{ListInd});
                TsmxnySNRAbbr=sprintf('%s%s/%sdB/%s',TsMxNRoot,lower(TsNosName(j).name(1:end-4)),num2str(abs(TsNosSNRi(i))),TsPtListPth{ListInd});
            else
                TsnoiySNRAbbr=sprintf('%snoisy/%s/n%sdB/%s',TsNoyRoot,lower(TsNosName(j).name(1:end-4)),num2str(abs(TsNosSNRi(i))),TsPtListPth{ListInd});
                TsmxnySNRAbbr=sprintf('%s%s/n%sdB/%s',TsMxNRoot,lower(TsNosName(j).name(1:end-4)),num2str(abs(TsNosSNRi(i))),TsPtListPth{ListInd});
            end
            mkdir(fileparts(TsnoiySNRAbbr));mkdir(fileparts(TsmxnySNRAbbr));
            TsNoisePath=sprintf('%s%s',TsNosRoot,TsNosName(j).name);
            
            add_noise_v3_1(TsClLiPth{ListInd,1},TsNoisePath,TsnoiySNRAbbr,TsmxnySNRAbbr,TsNosSNRi(i),'ts');
        end
    end
end
%% List prepare for SE
BuileFileName = 'list\training_noisy.list';
list = dir ('Training\noisy\**\*.wav');
fid = fopen(BuileFileName,'wb');
for i = 1:length(list)
     if ~or(strcmp(list(i).name,'sa1.wav'), strcmp(list(i).name,'sa2.wav'))
         fprintf(fid,'%s\r\n',[list(i).folder,'\',list(i).name]);
     end
end
fclose(fid);

BuileFileName = 'list\testing_noisy.list';
list = dir ('Testing\noisy\**\*.wav');
fid = fopen(BuileFileName,'wb');
for i = 1:length(list)
     if ~or(strcmp(list(i).name,'sa1.wav'), strcmp(list(i).name,'sa2.wav'))
         fprintf(fid,'%s\r\n',[list(i).folder,'\',list(i).name]);
     end
end
fclose(fid);

BuileFileName = 'list\training_clean.list';
list = dir ('clean\train\**\*.wav');
fid = fopen(BuileFileName,'wb');
for i = 1:length(list)
     if ~or(strcmp(list(i).name,'sa1.wav'), strcmp(list(i).name,'sa2.wav'))
         fprintf(fid,'%s\r\n',[list(i).folder,'\',list(i).name]);
     end
end
fclose(fid);

end