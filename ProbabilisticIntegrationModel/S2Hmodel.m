%
% 2010/12/07
% make Speech to Hand model
%
% LINK
% loadBin, loadBinDir, makeJoint, trainGMM, gmmvc, spkmodel_vc2
% makeGestureCombinationList
%
% HISOTRY
% 2011/01/09 modified so that it output joint vectors at every combination
% between gesture data set and speech data set
% 2010/12/22 modified so that it can be used on Mac as well
% 2010/12/21 changed the gesture combination list from Brute Force to the list
% made by makeGestureCombinationList.m
%
% AUTHOR
% Aki Kunikoshi (D2)
% yemaozi88@gmail.com
%

clear all, clc
%makeGestureCombinationList;


%% definition
% gestures for gesture model
%dirGesture = '/Users/kunikoshi/research/gesture/transitionAmong16of28/dgvs/1';
dirGesture = 'C:\research\gesture\transitionAmong16of28\dgvs\1';
dirOutGestureModel = 'C:\research\ProbabilisticIntegrationModel';
GgNum = 64;
% gesture and speech for convert model
%dirH = '/Users/kunikoshi/research/gesture/transitionAmong16of28/dgvs';
dirH = 'C:\research\gesture\transitionAmong16of28\dgvs';
%dirS = '/Users/kunikoshi/research/speech/Japanese5vowels/isolated/suzuki/16k/scep18';
dirS = 'C:\research\speech\Japanese5vowels\isolated\suzuki\16k\scep18';
MIX = 32;
% input speech
%dirConsonant = '/Users/kunikoshi/research/speech/JapaneseConsonants/n/suzuki/16k/scep18/9';
%dirConsonant = 'C:\research\speech\JapaneseConsonants\n\suzuki\16k\scep18\9';
dirConsonant_ = 'C:\research\speech\JapaneseConsonants';
consonant = ['b', 'm', 'n', 'p', 'r'];
vowel = ['a', 'i', 'u', 'e', 'o'];
% the directory for the output files
%dirOut = '/Users/kunikoshi/research/ProbabilisticIntegrationModel';
dirOut = 'C:\research\ProbabilisticIntegrationModel\S2H-H2S_ERRV20_ERRC20_thres5_mix32';

% Saito's method
alpha = 1; % weight factor for speaker model
it = 3; % number or iteration
updatemethod = 1; %0- using target responsibility 1- using joint responsibility

SAMPLING_FREQ = 1; % assumed sampling frequency of DataGlove

modeGesture = 1;    % 0: calculate GMM; 1: load GMM
modeS2H = 1;        % 0: calculate GMM; 1: conversion;


%% Gesture model
% according to the preliminary test, the optimal mixture number is 64
% covariance of objGestureModel is diagonal

% calculate
if modeGesture == 0
    Y = loadBinDir(dirGesture, 'uchar', 26);
    Y = Y(5:22, :)';
    tic
    objGestureModel = trainGMM(Y, GgNum, 1);
    toc
    clear Y

    % save
    if ismac == 1
        save([dirOutGestureModel '/objGestureModel-' num2str(GgNum)], 'objGestureModel');
    else
        save([dirOutGestureModel '\objGestureModel-' num2str(GgNum)], 'objGestureModel');
    end
elseif modeGesture == 1
    % load
    if ismac == 1
        load([dirOutGestureModel '/objGestureModel-' num2str(GgNum)], 'objGestureModel');
    else
        load([dirOutGestureModel '\objGestureModel-' num2str(GgNum)], 'objGestureModel');
    end
end


%% choose 5 gestures among 16 gestures
ges = [1, 2, 4, 7, 8, 9, 11, 13, 14, 15, 16, 21, 22, 25, 27, 28];
% C = nchoosek(ges, 5);   % the list of vowel sets
% Cnum = size(C, 1);      % the number of vowel sets
% for nL = 1:1; % the number of the vowel combination

%     P = perms(C(nL, :));    % the permucation of a vowel set
    [dgvMean, gestureCombinationList] = make16gestureCombinationList(dirH);
    P = gestureCombinationList;
    
    Pnum = size(P, 1); % the number of all permutations
    %load('C:\research\ProbabilisticIntegrationModel\errList2');
    for nP = [4065, 7838, 7859]; % the number of the permutation
        tic
        disp(nP)
        
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
            dirOutJoint     = [dirOutSub '/joint_S2H'];
            dirOutSynDgv    = [dirOutSub '/synDgv'];
            
            dirOutReducedJoint      = [dirOutSub '/reducedJoint_S2H'];
            dirOutReducedJointLog   = [dirOutReducedJoint '/log'];
        else
            dirOutSub       = [dirOut '\' a '-' i '-' u '-' e '-' o];
            dirOutJoint     = [dirOutSub '\joint_S2H'];
            dirOutSynDgv    = [dirOutSub '\synDgv'];
            
            dirOutReducedJoint      = [dirOutSub '\reducedJoint_S2H'];
            dirOutReducedJointLog   = [dirOutReducedJoint '\log'];
        end
       
        if modeS2H == 0
            mkdir(dirOutSub);
            mkdir(dirOutJoint);
            mkdir(dirOutSynDgv);
        
            mkdir(dirOutReducedJoint);
            mkdir(dirOutReducedJointLog);
        
        
%% log
if ismac == 1
    fname_log = [dirOutSub '/log_S2H.txt'];
else
    fname_log = [dirOutSub '\log_S2H.txt'];
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
tic
            for nH = 1:3; % the number of dgvs data set
                for nS = 1:3; % the number of scep data set  

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

        %                 % adjust the number of data
        %                 fmax = size(S, 2);
        %                 N = floor(fmax / size(H, 2));
        %                 Sshort = [];
        %                 for t=1:fmax
        %                     if rem(t, N)==1
        %                         Sshort = [Sshort, S(:, t)];
        %                     end
        %                 end

                        % make augmented vector
                        %disp([vowel(nV1) vowel(nV2) ': gesture-' num2str(nH) '; speech-' num2str(nS)])
                        J = makeJoint(H, S, 1);
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

            end % nS
        end % nH
disp('make joint vector series')
toc

tic
        reduceJointDir(dirOutSub, 3, 3, 0.011, 1);
disp('reduce joint vector size')
toc

        clear filenameH filenameS
        clear frameH frameS
        clear nV1 nV2 nH nS
        clear H S J
        
        
%% calculate GMM
        % load augmented vector
        
        %Y = loadBinDir(dirOutJoint, 'float', 36);
tic
        Y_H1S1 = loadBinDir([dirOutReducedJoint '\H1S1'], 'float', 36);
        Y_H2S2 = loadBinDir([dirOutReducedJoint '\H2S2'], 'float', 36);
  
        Y = [Y_H1S1, Y_H2S2];
        Y = Y';

% log
fprintf(flog, '\ntotal frame number in all joint vectors: %d\n', size(Y, 1));
        
        % according to the preliminary test, the optimal mixture number is
        %  8 for H1S1
        % 32 for H1S1+H2S2 (reduced)
        objS2Hmodel = trainGMM(Y, MIX, 0);
        %clear Y
        if ismac == 1
            save([dirOutSub '/objS2Hmodel'], 'objS2Hmodel');
        else
            save([dirOutSub '\objS2Hmodel'], 'objS2Hmodel');
        end
        %rmdir(dirOutJoint, 's');
disp('calculate GMM')
toc
        
elseif modeS2H == 1
        if ismac == 1
            load([dirOutSub '/objS2Hmodel']);
        else
            load([dirOutSub '\objS2Hmodel']);
        end
end % modelS2H
    
   
%% conversion for vowels
tic
        for nV = 1:5
            mora = sprintf('%s%s', vowel(nV), vowel(nV));
            if ismac == 1
                filename  = [dirS '/1/' mora '.scep'];
            else
                filename  = [dirS '\1\' mora '.scep'];
            end
            
            input = loadBin(filename, 'float', 19);
            input = input(2:19, :); % remove energy
            
            %dgv_ = gmmvc(input, objS2Hmodel);
            dgv_ = spkmodel_vc2(input, objS2Hmodel, objGestureModel, alpha, it, updatemethod);
            % dgv_ holds all results at every step
            dgv_ = dgv_{1, it};
            dgv  = conv2dgv(dgv_, SAMPLING_FREQ);
            frameDgv = size(dgv, 2);

            if ismac == 1
                fname = [dirOutSynDgv '/' mora '.dgv'];
            else
                fname = [dirOutSynDgv '\' mora '.dgv'];
            end
            fout = fopen(fname, 'wb');
            for ii = 1:frameDgv
                fwrite(fout, dgv(:, ii), 'uchar');
            end
            fclose(fout);
        end % nV


%% conversion for consonants
        for nC = 1:5 % for consonant
            for nV = 1:5
                mora = sprintf('%s%s', consonant(nC), vowel(nV));
                if ismac == 1
                    %filename  = [dirConsonant '/' mora '.scep'];
                    filename = [dirConsonant_ '/' consonant(nC) '/suzuki/16k/scep18/1/' mora '.scep'];
                else
                    %filename  = [dirConsonant '\' mora '.scep'];
                    filename = [dirConsonant_ '\' consonant(nC) '\suzuki\16k\scep18\1\' mora '.scep'];
                end

                input = loadBin(filename, 'float', 19);
                input = input(2:19, :); % remove energy

                %dgv_ = gmmvc(input, objS2Hmodel);
                dgv_ = spkmodel_vc2(input, objS2Hmodel, objGestureModel, alpha, it, updatemethod);
                % dgv_ holds all results at every step
                dgv_ = dgv_{1, it};
                dgv  = conv2dgv(dgv_, SAMPLING_FREQ);
                frameDgv = size(dgv, 2);

                if ismac == 1
                    fname = [dirOutSynDgv '/' mora '.dgv'];
                else
                    fname = [dirOutSynDgv '\' mora '.dgv'];
                end

                fout = fopen(fname, 'wb');
                for ii = 1:frameDgv
                    fwrite(fout, dgv(:, ii), 'uchar');
                end
                fclose(fout);
                clear mora filename fname
                clear input dgv_ dgv frameDgv
            end % nV
        end % nC
disp('synthesize')
toc
        
        %fopen('all'); % List all open files
        fclose('all'); % Close all open files
    end % nP

% end % nL
%fclose(flog);
%clear fname_flog flog