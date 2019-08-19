function All_Proc_Matlab_Python
clear all;clc
addpath(genpath(cd));
%% Add Noise proc
% function AddNoise.m

AddNoise

%% Parameter Setting
%%%% For GLOBAL SETTING
InputPar.SampleRate  =16000;        
InputPar.FFT_SIZE    =512;

%%%% For STFT
InputPar.FrameSize   =512; %32ms per frame
InputPar.FrameRate   =256; %16ms frame shift
InputPar.FeaDim      =InputPar.FrameSize/2+1;

%%%% Parameters for NN training
InputPar.HiddenLayerSizes=[2048 2048 2048];
InputPar.MaxEpoch        =200;

%%%% List prepare
InputPar.TrRefList ='./list/training_clean.list';
InputPar.TrInpList ='./list/training_noisy.list';
InputPar.TsInpList ='./list/testing_noisy.list'; 

InputPar.Ws = 5;
InputPar.runName = ['SE_Learn','_MaxEpoch',num2str(InputPar.MaxEpoch),];

for i=1:length(InputPar.HiddenLayerSizes)
    InputPar.runName=[InputPar.runName,'H',num2str(InputPar.HiddenLayerSizes(i))];
end

%%%%% Training 
[InpDim,OutDim]=Train_Feature_Extraction(InputPar); 
fprintf('Finished feature extraction on Training data.\n');

TaDataPath='./ClTrInData.mat';
SoDataPath='./NyTrInData.mat';

InputPar.Model=InputPar.runName;
CmdName=sprintf('python ./Train16K.py %s %s %s %d %d %d',TaDataPath,SoDataPath,InputPar.runName,InputPar.MaxEpoch,InpDim,OutDim);
system(CmdName);
fprintf('Finished Training.\n');

%%%%%  Testing
Test_Mtlab_Python(InputPar); 

EVA_main(InputPar);


