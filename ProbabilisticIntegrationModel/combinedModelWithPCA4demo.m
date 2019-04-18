%
% 2011/03/03
% S2H-H2S combined system without PCA
% this program will make samples for demo
%
% LINK
% makeGestureCombinationList
%
% REMARKS
% - this program is for the quasi-optimal design
% - GMM is trained using trainGMM4demo.m
%
% HISTORY
% 2011/04/04 
% this program is modified for the listening test for INTERSPEECH 2011
% however that samples were cannot be used for the listening test
% 2011/03/03 this program is written to make samples for SP2011-03
%
% AUTHOR
% Aki Kunikoshi (D2)
% yemaozi88@gmail.com
%

clc, clear all, fclose('all');


%% definition
% gesture/speaker model
dirInModel = 'I:\ProbabilisticIntegrationModel\distortion';

% gesture and speech for convert model
%dirH = 'I:\_gesture\transitionAmong16of28\dgvs';
%dirS = 'I:\_speech\Japanese5vowels\isolated\suzuki\16k\scep18';
% %CgNum = 8;
% MIX = 8;
 
% the directory for the output files
dirOut = 'I:\ProbabilisticIntegrationModel\distortion';
 
% input speech
%dirConsonant_ = 'I:\ProbabilisticIntegrationModel\distortion\scep';
%consonant = ['b', 'm', 'n', 'p', 'r'];
%vowel = ['a', 'i', 'u', 'e', 'o'];
%transition = ['c', 'm', 'v'];
 
% eigen parameters
%EigenParamDir = 'I:\_gesture\transitionAmong16of28\EigenParam\1';
 
% Saito's method
alpha = 1; % weight factor for speaker model
it = 3; % number or iteration
updatemethod = 1; %0- using target responsibility 1- using joint responsibility

% ENR = 2.5; % the energy of synthesized speech
SAMPLING_FREQ = 1; % assumed sampling frequency of DataGlove


%% PCA parameters
%[EVec, EVal, Eu] = loadEigenParam(EigenParamDir);


%% S2H
% Gesture model / Speaker model
% according to the preliminary test, the optimal mixture number is 64
% covariance of objGestureModel is diagonal
if ismac == 1
    %load([dirInModel '/objGestureModel-' num2str(GgNum) '_withPCA']);
    %load([dirInModel '/objGestureModel-32_withPCA']);
    load([dirInModel '/objGestureModel-64']);        
    load([dirInModel '/objSpeakerModel-64']);
else
    %load([dirInModel '\objGestureModel-' num2str(GgNum) '_withPCA']);
    %load([dirInModel '\objGestureModel-32_withPCA']);
    load([dirInModel '\objGestureModel-64']);
    load([dirInModel '\objSpeakerModel-64']);
end

% S2Hmodel
load('I:\ProbabilisticIntegrationModel\distortion\5840\objS2Hmodel');

dirOutSynDgv    = 'J:\16k\synDgv';
dirOutSynScep   = 'J:\16k\synScep';

fname_          = 'onnawayayoimonnomaeniiru_slow';
fname_scepIn    = ['J:\16k\scep\' fname_ '.scep'];
fname_dgvSyn    = [dirOutSynDgv '\' fname_ '.dgv'];
fname_dgvLog    = [dirOutSynDgv '\' fname_ '.txt'];

fname_scepLog   = [dirOutSynScep '\' fname_ '.txt'];
fname_scepSyn   = [dirOutSynScep '\' fname_ '.scep'];
fname_wav       = [dirOutSynScep '\' fname_ '.wav'];

input = loadBin(fname_scepIn, 'float', 19);
input = input(2:19, :); % remove energy
dgv_ = spkmodel_vc2(input, objS2Hmodel, objGestureModel, alpha, it, updatemethod, fname_dgvLog);

% dgv_ holds all results at every step
dgv_ = dgv_{1, it};
dgv  = conv2dgv(dgv_, SAMPLING_FREQ);
frameDgv = size(dgv, 2);
 
fout = fopen(fname_dgvSyn, 'wb');
for ii = 1:frameDgv
    fwrite(fout, dgv(:, ii), 'uchar');
end
fclose(fout);
X = dgv;
clear input dgv dgv_
clear frameDgv ii

                
%% H2S conversion
load('I:\ProbabilisticIntegrationModel\distortion\5840\joint\obj\jointModel_mix32_obj');
% fname = 'I:\16k\synDgv\nannano_slow.dgv';
%X = loadBin(fname, 'uchar', 26);
X = X(5:22, :);
scep_ = gmmvc(X, obj); 
scep  = conv2scep(scep_, 2.5);
clear scep_

% write out scep
frameScep = size(scep, 2);
fod = fopen(fname_scepSyn, 'wb');
j = 1;
while j < frameScep + 1
    fwrite(fod, scep(:, j), 'float');
    j = j + 1;
end
fclose(fod);

% write out wav synthesized using scep
scep2wav(scep, fname_wav, 'suzuki');