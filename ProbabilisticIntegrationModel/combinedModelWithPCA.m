%
% 2011/02/20
% S2H-H2S combined system
% gesture data is performed PCA
%
% LINK
% makeGestureCombinationList.m
%
% NOTES
% this program is for the directories which made by S2Hmodel.m
%
% HISTORY
% 2011/02/27 modified so that nP is treated as str
% 2011/02/22 add conversion parts
%
% AUTHOR
% Aki Kunikoshi (D2)
% yemaozi88@gmail.com
%

clc, clear all, fclose('all');


%% definition
% gesture/speaker model
%dirInModel = 'C:\research\ProbabilisticIntegrationModel\S2H-H2S_distortion';
%dirGesture = 'C:\research\_gesture\transitionAmong16of28\dgvs\1';
dirInModel = 'C:\research\ProbabilisticIntegrationModel\distortion';
GgNum = 64;

% gesture and speech for convert model
dirH = 'C:\research\_gesture\transitionAmong16of28\dgvs';
dirS = 'C:\research\_speech\Japanese5vowels\isolated\suzuki\16k\scep18';
%CgNum = 8;
MIX = 8;

% the directory for the output files
dirOut = 'C:\research\ProbabilisticIntegrationModel\8190combinations';

% input speech
dirConsonant_ = 'C:\research\_speech\JapaneseConsonants';
consonant = ['b', 'm', 'n', 'p', 'r'];
vowel = ['a', 'i', 'u', 'e', 'o'];
nSmax = 1; % the number of data set

% eigen parameters
EigenParamDir = 'C:\research\_gesture\transitionAmong16of28\EigenParam\1';

% Saito's method
alpha = 1; % weight factor for speaker model
it = 3; % number or iteration
updatemethod = 1; %0- using target responsibility 1- using joint responsibility

ENR = 2.5; % the energy of synthesized speech
SAMPLING_FREQ = 1; % assumed sampling frequency of DataGlove

% cepstralDistance
cepstralDistancefile = 'C:\research\ProbabilisticIntegrationModel\distortion\cepstralDistortionWithPCA\cepstralDistortionWithPCA_l.csv';

%modeGesture = 1;    % 0: calculate GMM; 1: load GMM
%modeS2H = 1;        % 0: calculate GMM; 1: conversion;


%% Gesture model / Speaker model
% according to the preliminary test, the optimal mixture number is 64
% covariance of objGestureModel is diagonal
if ismac == 1
    %load([dirInModel '/objGestureModel-' num2str(GgNum) '_withPCA']);
    load([dirInModel '/objGestureModel-32_withPCA']);
    load([dirInModel '/objSpeakerModel-' num2str(GgNum)]);        
    %load([dirOutSub '/objS2Hmodel']);
else
    %load([dirInModel '\objGestureModel-' num2str(GgNum) '_withPCA']);
    load([dirInModel '\objGestureModel-32_withPCA']);
    load([dirInModel '\objSpeakerModel-' num2str(GgNum)]);        
    %load([dirOutSub '\objS2Hmodel']);
end


%% PCA parameters
[EVec, EVal, Eu] = loadEigenParam(EigenParamDir);


%% choose 5 gestures among 16 gestures
ges = [1, 2, 4, 7, 8, 9, 11, 13, 14, 15, 16, 21, 22, 25, 27, 28];
[dgvMean, gestureCombinationList] = make16gestureCombinationList(dirH);
P = gestureCombinationList;
Pnum = size(P, 1);  % the number of all permutations

fcepDis = fopen(cepstralDistancefile, 'wt');

for nP = 701:1000;  % the number of the permutation
tic    
    % set vowel gestures
    
    a = P(nP, 1);
    if a < 10
        a = num2str(a);
        a = ['0' a];
    else
        a = num2str(a);
    end

    i = P(nP, 2);
    if i < 10
        i = num2str(i);
        i = ['0' i];
    else
        i = num2str(i);
    end

    u = P(nP, 3);
    if u < 10
        u = num2str(u);
        u = ['0' u];
    else
        u = num2str(u);
    end

    e = P(nP, 4);
    if e < 10
        e = num2str(e);
        e = ['0' e];
    else
        e = num2str(e);
    end

    o = P(nP, 5);
    if o < 10
        o = num2str(o);
        o = ['0' o];
    else
        o = num2str(o);
    end

    %% nP: num 2 str
    if nP < 10
        nPstr = ['000' num2str(nP)];
    elseif nP < 100
        nPstr = ['00' num2str(nP)];
    elseif nP < 1000
        nPstr = ['0' num2str(nP)];
    else
        nPstr = num2str(nP);
    end
    disp(nPstr)

    
%% directory processing
    if ismac == 1
        dirOutSub             = [dirOut '/' num2str(nPstr)];
        dirOutSynDgv          = [dirOutSub '/synDgvWithPCA'];
        dirOutSynScep         = [dirOutSub '/synScepWithPCA'];
%        dirOutJoint           = [dirOutSub '/joint'];
%        dirOutReducedJoint    = [dirOutSub '/reducedJoint'];
%        dirOutReducedJointLog = [dirOutReducedJoint '\log'];
    else
        dirOutSub             = [dirOut '\' num2str(nPstr)];
        dirOutSynDgv          = [dirOutSub '\synDgvWithPCA'];
        dirOutSynScep         = [dirOutSub '\synScepWithPCA'];
%        dirOutJoint           = [dirOutSub '\joint'];
%        dirOutReducedJoint    = [dirOutSub '\reducedJoint'];
%        dirOutReducedJointLog = [dirOutReducedJoint '\log'];
    end    
    mkdir(dirOutSynDgv);
    mkdir(dirOutSynScep);
%    mkdir(dirOutJoint);
%    mkdir(dirOutReducedJoint);
%    mkdir(dirOutReducedJointLog);
    

%% log
if ismac == 1
    fname_log = [dirOutSub '/logWithPCA.txt'];
else
    fname_log = [dirOutSub '\logWithPCA.txt'];
end

flog  = fopen(fname_log, 'wt');

fprintf(flog, '< Gestures for the five Japanese vowels >\n');
%fprintf(flog, 'List No: nP - %d\t', nP);
fprintf(flog, 'nP - %d\n', nP);

fprintf(flog, 'a: %s\n', a);
fprintf(flog, 'i: %s\n', i);
fprintf(flog, 'u: %s\n', u);
fprintf(flog, 'e: %s\n', e);
fprintf(flog, 'o: %s\n', o);
fprintf(flog, '\n');

disp(['Gesture Design: ' num2str(nP)]);
disp(['a:' a ' i:' i ' u:' u ' e:' e ' o:' o]);


    %% load files
    totalFrameJ = 0;
    totalFrameK = 0;
    Y = [];
    for nH = 1:1; % the number of dgvs data set
        nS = nH;
        %for nS = 1:2; % the number of scep data set  

%         if ismac == 1
%             %dirOutJointSub        = [dirOutJoint '/H' num2str(nH) 'S' num2str(nS)];
%             dirOutReducedJointSub  = [dirOutReducedJoint '/H' num2str(nH) 'S' num2str(nS)];
%         else
%             %dirOutJointSub        = [dirOutJoint '\H' num2str(nH) 'S' num2str(nS)];
%             dirOutReducedJointSub  = [dirOutReducedJoint '\H' num2str(nH) 'S' num2str(nS)];
%         end
%         %mkdir(dirOutJointSub);
%         mkdir(dirOutReducedJointSub);

        for nV1 = 1:5 % the first vowel of a transition in training data
            for nV2 = 1:5 % the second vowel of a transition in training data

% log
fprintf(flog, '%s%s:\t', vowel(nV1), vowel(nV2));

                % load gesture data
                if ismac == 1
                    filenameH_ = sprintf('filenameH = [''%s/'' ''%d'' ''/'' %s ''-'' %s ''.dgvs''];', dirH, nH, vowel(nV1), vowel(nV2));
                else
                    filenameH_ = sprintf('filenameH = [''%s\\'' ''%d'' ''\\'' %s ''-'' %s ''.dgvs''];', dirH, nH, vowel(nV1), vowel(nV2));
                end

                eval(filenameH_);
                %disp(filenameH)
                H = loadBin(filenameH, 'uchar', 26);
                frameH = size(H, 2);
                clear filenameH_

                % load speech data
                if ismac == 1
                    filenameS = [dirS '/' num2str(nS) '/' vowel(nV1) vowel(nV2) '.scep'];
                else
                    filenameS = [dirS '\' num2str(nS) '\' vowel(nV1) vowel(nV2) '.scep'];
                end
                %disp(filenameS)
                S = loadBin(filenameS, 'float', 19);
                frameS = size(S, 2);

% log
fprintf(flog, 'gesture - %4d\t', frameH);
fprintf(flog, 'speech - %4d\t', frameS);
%disp(['gesture: ' num2str(frameH) ' [frame]'])
%disp(['speech: ' num2str(frameS) ' [frame]'])

                % make augmented vector
                %disp([vowel(nV1) vowel(nV2) ': gesture-' num2str(nH) '; speech-' num2str(nS)])
                J = makeJoint(H, S, 1);
                frameJ = size(J, 2);
                totalFrameJ = totalFrameJ + frameJ;

                % S2H joint vector
                % threshold is 0.011 so that the total number of vectors is
                % about 1/5 of original ones
                [K, frameK, ratio] = reduceJoint(J, 0.011, 1);
                totalFrameK = totalFrameK + frameK;

                Y = [Y, K];
                
                % save augmented vector
%                 if ismac == 1
%                     fname_joint = [dirOutReducedJointSub '/' vowel(nV1) vowel(nV2) '_' num2str(nH) num2str(nS) '.joint'];
%                 else
%                     fname_joint = [dirOutReducedJointSub '\' vowel(nV1) vowel(nV2) '_' num2str(nH) num2str(nS) '.joint'];
%                 end
%                 fjoint = fopen(fname_joint, 'wb');
%                 for ii = 1:frameK
%                     fwrite(fjoint, K(:, ii), 'float');
%                 end
%                 fclose(fjoint);

% log
fprintf(flog, 'joint - %4d\t', frameJ);
fprintf(flog, 'reduced joint - %4d(%4.2f[%%])\n', frameK, ratio);

                %clear fname_joint fjoint frameJ ii;
                clear J frameJ;
                clear K frameK ratio ii;

            end % nV2
        end % nV1
% log
fprintf(flog, '\n');

        %end % nS
    end % nH
%log
fprintf(flog, 'total frame number in all joint vectors: %4d\n', totalFrameJ);
fprintf(flog, 'total frame number in all reduced joint vectors: %4d(%.2f[%%])\n', totalFrameK, totalFrameK/totalFrameJ*100);
fclose(flog);

    clear totalFrameJ totalFrameK
    clear filenameH filenameS
    clear frameH frameS
    clear nV1 nV2 nH nS
    clear H S J


%% perform PCA
    Yscep = Y(1:18, :);
    Ydgv  = Y(19:36, :)';

    YdgvPCA = PCA_Trans(Ydgv, EVec, Eu, 18);
    YdgvPCA = YdgvPCA';

    Y = [Yscep; YdgvPCA];
    %clear Yscep Ydgv YdgvPCA


%% calculate GMM
    Y = Y';
    % according to the preliminary test, the optimal mixture number is
    %  8 for H1S1
    % 32 for H1S1+H2S2 (reduced)
    objS2HmodelWithPCA = trainGMM(Y, MIX, 0);
    %clear Y
    if ismac == 1
        save([dirOutSub '/objS2HmodelWithPCA'], 'objS2HmodelWithPCA');
    else
        save([dirOutSub '\objS2HmodelWithPCA'], 'objS2HmodelWithPCA');
    end

%     elseif modeS2H == 1
%             if ismac == 1
%                 load([dirOutSub '/objS2HmodelWithPCA']);
%             else
%                 load([dirOutSub '\objS2HmodelWithPCA']);
%             end
%     end % modelS2H


%% load gesture model and convert model
%     if ismac == 1
%         load([dirInModel '/objGestureModel-' num2str(GgNum)]);
%         load([dirInModel '/objSpeakerModel-' num2str(GgNum)]);        
%         load([dirOutSub '/objS2Hmodel']);
%     else
%         load([dirInModel '\objGestureModel-' num2str(GgNum)]);
%         load([dirInModel '\objSpeakerModel-' num2str(GgNum)]);        
%         load([dirOutSub '\objS2Hmodel']);
%     end


%% conversion
    CD = zeros(30, nSmax); % Cepstral Distortion for vowels + consonants
    for nS = 1:nSmax; % the number of speech data set
%disp(['--- dataset ' num2str(nS) ' ---'])
        for nC = 0:5
            for nV = 1:5
            %for nV = 1
                if nC == 0 % vowels
                    mora = sprintf('%s%s', vowel(nV), vowel(nV));
                    if ismac == 1
                        fname_scepIn = [dirS '/' num2str(nS) '/' mora '.scep'];
                    else
                        fname_scepIn = [dirS '\' num2str(nS) '\' mora '.scep'];
                    end
                else
                    mora = sprintf('%s%s', consonant(nC), vowel(nV));
                    if ismac == 1
                        fname_scepIn = [dirConsonant_ '/' consonant(nC) '/suzuki/16k/scep18/' num2str(nS) '/' mora '.scep'];
                    else
                        fname_scepIn = [dirConsonant_ '\' consonant(nC) '\suzuki\16k\scep18\' num2str(nS) '\' mora '.scep'];
                    end
                end
            % S2H
                if ismac == 1
                    fname_dgvSyn    = [dirOutSynDgv '/' mora num2str(nS) '.dgv'];
                    fname_dgvLog    = [dirOutSynDgv '/' mora num2str(nS) '.txt'];
                    fname_scepSyn   = [dirOutSynScep '/' mora num2str(nS) '.scep'];
                    fname_scepLog   = [dirOutSynScep '/' mora num2str(nS) '.txt'];
                    fname_wav       = [dirOutSynScep '/' mora num2str(nS) '.wav'];
                else
                    fname_dgvSyn    = [dirOutSynDgv '\' mora num2str(nS) '.dgv'];
                    fname_dgvLog    = [dirOutSynDgv '\' mora num2str(nS) '.txt'];
                    fname_scepSyn   = [dirOutSynScep '\' mora num2str(nS) '.scep'];
                    fname_scepLog   = [dirOutSynScep '\' mora num2str(nS) '.txt'];
                    fname_wav       = [dirOutSynScep '\' mora num2str(nS) '.wav'];
                end

                input = loadBin(fname_scepIn, 'float', 19);
                input = input(2:19, :); % remove energy
                dgv_ = spkmodel_vc2(input, objS2HmodelWithPCA, objGestureModelWithPCA, alpha, it, updatemethod, fname_dgvLog);
                % dgv_ holds all results at every step
                dgv_ = dgv_{1, it}; % dgv_ is PCAed dgv
                dgvPCA = dgv_;

                % perform invPCA
                dgv_ = dgv_';
                dgv_ = PCA_TransInv(dgv_, EVec, Eu);
                dgv_ = dgv_';

                dgv  = conv2dgv(dgv_, SAMPLING_FREQ);
                frameDgv = size(dgv, 2);

                fout = fopen(fname_dgvSyn, 'wb');
                for ii = 1:frameDgv
                    fwrite(fout, dgv(:, ii), 'uchar');
                end
                fclose(fout);
                clear input dgv dgv_ frameDgv
 
            % H2S
%                 dgv = dgv(5:22, :); % remove energy
                scep_ = spkmodel_vc2_(dgvPCA, objS2HmodelWithPCA, objSpeakerModel, alpha, it, updatemethod, fname_scepLog);
                % scep_ holds all results at every step
                scep_ = scep_{1, it};
                scep  = conv2scep(scep_, ENR);
                %scep  = smoothScep(scep, 19, 30);
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
%disp('H2S completed');
 
            % cepstral distortion
                NMmean = distortion2(fname_scepIn, fname_scepSyn);
%                 if nC == 0 % vowels
%                     CD(nV, nS) = NMmean;
%                 else
%                     CD(nV+5, nS) = NMmean;
%                 end
                CD(nV + nC*5, nS) = NMmean;
                
disp([mora ': ' num2str(NMmean)]);
            end % nV
        end %nC
    end % nS

    %CDmean = mean(CD')'; % 30 x 1
    CDmean = CD;
    CDmax = size(CDmean, 1);
    
    fprintf(fcepDis, '%d,%s,%s,%s,%s,%s,', nP, a, i, u, e, o);
    for ii = 1:CDmax
        fprintf(fcepDis, '%f,', CDmean(ii, 1));
    end
    fprintf(fcepDis, '\n');
toc
end % nP
 
fclose(fcepDis);