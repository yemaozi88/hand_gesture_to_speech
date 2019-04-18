%
% 2010/12/07
% make Speech to Hand model
% convert synthesized dgv by S2Hmodel.m into scep
%
% LINK
% loadBin, loadBinDir, makeJoint, trainGMM, gmmvc, spkmodel_vc2
% makeGestureCombinationList, TrainConvertModel
%
% HISOTRY
% 2011/01/15 modified so that it can load all the consonants
%
% AUTHOR
% Aki Kunikoshi (D2)
% yemaozi88@gmail.com
%

clear all, clc, fclose('all');
%makeGestureCombinationList;


%% definition
% gesture and speech for convert model
dirH = 'C:\research\gesture\transitionAmong16of28\dgvs';
dirS = 'C:\research\speech\Japanese5vowels\isolated\suzuki\16k\scep18';

consonant = ['b', 'm', 'n', 'p', 'r'];
vowel = ['a', 'i', 'u', 'e', 'o'];

% the directory for the output files
dirOut = 'C:\research\ProbabilisticIntegrationModel\S2H-H2S_ERRV20_ERRC20_thres5_mix32';

% the pass file list which made by check5of16gestureCombinations.m
passListFile = 'C:\research\ProbabilisticIntegrationModel\S2H-H2S_ERRV20_ERRC20_thres5_mix32\passList_ERRV20_ERRC20_thres5';

MIX = 32; % the number of mixture is 32
ENR = 2.5; % the energy of synthesized speech

modeH2S = 0;        % 0: calculate GMM; 1: conversion;


%% choose 5 gestures among 16 gestures
ges = [1, 2, 4, 7, 8, 9, 11, 13, 14, 15, 16, 21, 22, 25, 27, 28];
[dgvMean, gestureCombinationList] = make16gestureCombinationList(dirH);
P = gestureCombinationList;
Pnum = size(P, 1); % the number of all permutations
load(passListFile);

for nP = passList(2:3,:)';  % the number of the permutation
    
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


%% directory processing
    if ismac == 1
        dirOutSub       = [dirOut '/' a '-' i '-' u '-' e '-' o];
        dirOutJoint     = [dirOutSub '/joint_H2S'];
        dirOutMarix     = [dirOutSub '/matrix'];
        dirOutSynScep   = [dirOutSub '/synScep'];
        dirOutSynDgv    = [dirOutSub '/synDgv'];

        dirOutReducedJoint      = [dirOutSub '/reducedJoint_H2S'];
        dirOutReducedJointLog   = [dirOutReducedJoint '/log'];
    else
        dirOutSub       = [dirOut '\' a '-' i '-' u '-' e '-' o];
        dirOutJoint     = [dirOutSub '\joint_H2S'];
        dirOutMatrix    = [dirOutSub '\matrix'];
        dirOutSynScep   = [dirOutSub '\synScep'];
        dirOutSynDgv    = [dirOutSub '\synDgv'];

        dirOutReducedJoint      = [dirOutSub '\reducedJoint_H2S'];
        dirOutReducedJointLog   = [dirOutReducedJoint '\log'];
    end

    if modeH2S == 0
        %mkdir(dirOutSub);
        mkdir(dirOutJoint);
        mkdir(dirOutMatrix);
        mkdir(dirOutSynScep);

        mkdir(dirOutReducedJoint);
        mkdir(dirOutReducedJointLog);

    
%% log
if ismac == 1
    fname_log = [dirOutSub '/log_H2S.txt'];
else
    fname_log = [dirOutSub '\log_H2S.txt'];
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
disp(['a:' a ' i:' i ' u:' u ' e:' e ' o:' o]);


%% load files
% log
fprintf(flog, 'The number of frames\n');

            for nH = 1:2; % the number of dgvs data set
                %for nS = 1:3; % the number of scep data set
                nS = nH;

% log
fprintf(flog, 'dataset: Hand %d, Speech %d\n', nH, nS);

                    if ismac == 1
                        dirOutJointSub  = [dirOutJoint '/H' num2str(nH) 'S' num2str(nS)];
                        dirOutReducedJointSub  = [dirOutReducedJoint '/H' num2str(nH) 'S' num2str(nS)];
                    else
                        dirOutJointSub  = [dirOutJoint '\H' num2str(nH) 'S' num2str(nS)];
                        dirOutReducedJointSub  = [dirOutReducedJoint '\H' num2str(nH) 'S' num2str(nS)];
                    end
                    mkdir(dirOutJointSub);
                    mkdir(dirOutReducedJointSub);

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
                    J = makeJoint(H, S, 0);
                    frameJ = size(J, 2);

                    % save augmented vector
                    if ismac == 1
                        fname_joint = [dirOutJointSub '/' vowel(nV1) vowel(nV2) '_' num2str(nH) num2str(nS) '.joint'];
                    else
                        fname_joint = [dirOutJointSub '\' vowel(nV1) vowel(nV2) '_' num2str(nH) num2str(nS) '.joint'];
                    end
                    fjoint = fopen(fname_joint, 'wb');
                    for ii = 1:frameJ
                        fwrite(fjoint, J(:, ii), 'float');
                    end
                    fclose(fjoint);
% log
fprintf(flog, 'joint - %4d\n', frameJ);
                    clear fname_joint fjoint frameJ ii;

                end % nV2
            end % nV1
% log
fprintf(flog, '\n');

        %end % nS
    end % nH

    reduceJointDir(dirOutSub, 2, 2, 0.011, 1);

    clear filenameH filenameS
    clear frameH frameS
    clear nV1 nV2 nH nS
    clear H S J

        
%% calculate GMM
%    if modeH2S == 0
tic
        % load augmented vector
        Y_H1S1 = loadBinDir([dirOutReducedJoint '\H1S1'], 'float', 36);
        Y_H2S2 = loadBinDir([dirOutReducedJoint '\H2S2'], 'float', 36);
        
        Y = [Y_H1S1, Y_H2S2]; % Y: JNT x frame
        Y = Y'; % Y: frame x JNT
        clear Y_H1S1 Y_H2S2

% log
fprintf(flog, '\ntotal frame number in all joint vectors: %d\n', size(Y, 1));

        % according to the preliminary test, the optimal mixture number is
        %  8 for H1S1
        % 32 for H1S1+H2S2 (reduced)
        objH2Smodel = trainGMM(Y, MIX, 0);
        %clear Y
        if ismac == 1
            save([dirOutSub '/objH2Smodel'], 'objH2Smodel');
        else
            save([dirOutSub '\objH2Smodel'], 'objH2Smodel');
        end
        %rmdir(dirOutJoint, 's');
disp('calculate GMM')
toc
    elseif modeH2S == 1
        if ismac == 1
            load([dirOutSub '/objH2Smodel']);
        else
            load([dirOutSub '\objH2Smodel']);
        end
    end % modeH2S


%         %% this part is based on getGMM_Qiao.m
%         
%         %% definition
%         %NUM = 22; % number of signal from dataglove
%         SNS = 18;
%         DEG = 17; % degree of cepstrum, usually SNS - 1
%         JNT = SNS + DEG + 1; % degree per a joint vector
% 
%         %traing methods and parameters
%         method = 1;
% 
%         %parameters for conversion
%         para.gNum   = MIX; %number of mixtures
%         para.MaxIter = 500; %maximum training iterations
%         para.TolFun = 1e-05;
%         para.RegCov = 1e-04; %regulization of covariance matrix
% 
%         
%         X1_ = Y(1:SNS, :); % source vectors: num of data x SNS
%         X1 = X1_';
%         Y1 = Y(SNS+1:JNT, :)'; % target vectors: num of data x DEG
%         %clear Y
%         
%         Model = TrainConvertModel(X1, Y1, para, method);
%         clear X1 Y1;
% 
%         invxCovArr = zeros(Model.gNum, Model.dX, Model.dX);
%         detxCovArr = zeros(Model.gNum, 1);
%         for q = 1:Model.gNum
%             invxCovArr(q, :, :) = inv(squeeze(Model.xCovArr(q, :, :)));
%             detxCovArr(q, 1)    = det(squeeze(Model.xCovArr(q, :, :)));
%         end
% 
% 
%         %% write out matrix data
%         if ismac == 1
%             save([dirOutSub '/ModelH2Smodel'], 'Model');
%         else
%             save([dirOutSub '\ModelH2Smodel'], 'Model');
%         end
% 
%         fout_WArr = fopen([dirOutMatrix '\WArr.txt'], 'wt');
%         fout_xMeanArr = fopen([dirOutMatrix '\xMeanArr.txt'], 'wt');
%         fout_yMeanArr = fopen([dirOutMatrix '\yMeanArr.txt'], 'wt');
%         fout_xCovArr = fopen([dirOutMatrix '\xCovArr.txt'], 'wt');
%         fout_TinvxCovArr = fopen([dirOutMatrix '\TinvxCovArr.txt'], 'wt');
%         fout_invxCovArr = fopen([dirOutMatrix '\invxCovArr.txt'], 'wt');
%         fout_detxCovArr = fopen([dirOutMatrix '\detxCovArr.txt'], 'wt');
% 
%         fprintf(fout_WArr, '%f\n', Model.WArr);
%         fprintf(fout_xMeanArr, '%f\n', Model.xMeanArr);
%         fprintf(fout_yMeanArr, '%f\n', Model.yMeanArr);
%         fprintf(fout_xCovArr, '%f\n', Model.xCovArr);
%         fprintf(fout_TinvxCovArr, '%f\n', Model.TinvxCovArr);
%         fprintf(fout_invxCovArr, '%f\n', invxCovArr);
%         fprintf(fout_detxCovArr, '%e\n', detxCovArr);
% 
%         fclose(fout_WArr);
%         fclose(fout_xMeanArr);
%         fclose(fout_yMeanArr);
%         fclose(fout_xCovArr);
%         fclose(fout_TinvxCovArr);
%         fclose(fout_invxCovArr);
%         fclose(fout_detxCovArr);


%% conversion for vowels
tic
        for nV = 1:5
            mora = sprintf('%s%s', vowel(nV), vowel(nV));
            disp(mora)
            
            if ismac == 1
                filename  = [dirOutSynDgv '/' mora '.dgv'];
            else
                filename  = [dirOutSynDgv '\' mora '.dgv'];
            end
            
            input = loadBin(filename, 'uchar', 26);
            input = input(5:22, :); % remove energy
            
            scep_ = gmmvc(input, objH2Smodel);
            scep  = conv2scep(scep_, ENR);
            clear scep_
            
            % write out scep
            frameScep = size(scep, 2);
            if ismac == 1
                fname_scep = [dirOutSynScep '/' mora '.scep'];
                fname_wav  = [dirOutSynScep '/' mora '.wav'];
            else
                fname_scep = [dirOutSynScep '\' mora '.scep'];
                fname_wav  = [dirOutSynScep '\' mora '.wav'];
            end
            fod = fopen(fname_scep, 'wb');
            j = 1;
            while j < frameScep + 1
                fwrite(fod, scep(:, j), 'float');
                j = j + 1;
            end
            fclose(fod);
            
            % write out wav synthesized using scep
            scep2wav(scep, fname_wav, 'suzuki');
            
            clear fname_scep fname_wav
        end % nV


%% conversion for consonants
        for nC = 1:5 % for consonant
            for nV = 1:5
                mora = sprintf('%s%s', consonant(nC), vowel(nV));
                disp(mora)

                if ismac == 1
                    filename  = [dirOutSynDgv '/' mora '.dgv'];
                else
                    filename  = [dirOutSynDgv '\' mora '.dgv'];
                end

                input = loadBin(filename, 'uchar', 26);
                input = input(5:22, :); % remove energy

                scep_ = gmmvc(input, objH2Smodel);
                scep  = conv2scep(scep_, ENR);
                clear scep_

                % write out scep
                frameScep = size(scep, 2);
                if ismac == 1
                    fname_scep = [dirOutSynScep '/' mora '.scep'];
                    fname_wav  = [dirOutSynScep '/' mora '.wav'];
                else
                    fname_scep = [dirOutSynScep '\' mora '.scep'];
                    fname_wav  = [dirOutSynScep '\' mora '.wav'];
                end
                fod = fopen(fname_scep, 'wb');
                j = 1;
                while j < frameScep + 1
                    fwrite(fod, scep(:, j), 'float');
                    j = j + 1;
                end
                fclose(fod);

                % write out wav synthesized using scep
                scep2wav(scep, fname_wav, 'suzuki');
                
                clear fname_scep fname_wav
            end % nV
        end % nC
disp('synthesize')
toc

    fclose('all'); % Close all open files
end % nP

%fclose(flog);
clear fname_flog flog