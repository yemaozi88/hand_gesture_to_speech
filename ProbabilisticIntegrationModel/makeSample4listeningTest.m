%
% 2011/04/05
% train GMM, S2H and H2S converters and make samples for the AB test
% A: probabilistic integration model, B: random design
%
% NOTES
% - this program is based on trainGMM4demo.m and combinedModelWithPCA4demo.m
% - PCA is not performed
%
% AUTHOR
% Aki Kunikoshi (D3)
% yemaozi88@gmail.com
%

%clear all, clc, fclose('all');


% %% vowel
% % gesture and speech for convert model
% dirH = 'J:\_gesture\transitionAmong16of28\dgvs';
% dirS = 'J:\_speech\Japanese5vowels\isolated\suzuki\16k\scep18';
% %dirH = '/Volumes/RESEARCH/_gesture/transitionAmong16of28/dgvs';
% %dirS = '/Volumes/RESEARCH/_speech/Japanese5vowels/isolated/suzuki/16k/scep18';
% 
% consonant = ['b', 'm', 'n', 'p', 'r'];
% vowel = ['a', 'i', 'u', 'e', 'o'];
% 
% % the directory for the output files
% %dirOut = '/Volumes/RESEARCH/ProbabilisticIntegrationModel/distortion/bestModel/1113/vowels';
% dirOut = 'J:\ProbabilisticIntegrationModel\distortion\bestModel\1113\vowels';
% 
% % log
% if ismac == 1
%     fname_log = [dirOut '/frameNum.txt'];
% else
%     fname_log = [dirOut '\frameNum.txt'];
% end
 
% % sample num = 1113
% a = '28';
% i = '07';
% u = '01';
% e = '21';
% o = '15';
%  
 
% flog  = fopen(fname_log, 'wt');
% 
% fprintf(flog, 'a: %s\t', a);
% fprintf(flog, 'i: %s\t', i);
% fprintf(flog, 'u: %s\t', u);
% fprintf(flog, 'e: %s\t', e);
% fprintf(flog, 'o: %s\t', o);
% fprintf(flog, '\n');
% 
% 
% %% load files
% Jnum = 0;
% for nH = 1:1; % the number of dgvs data set
%     %for nS = 1:3; % the number of scep data set
%     nS = nH;
% % log
% fprintf(flog, 'dataset: Hand %d, Speech %d\n', nH, nS);
% 
%     for nV1 = 1:5 % the first vowel of a transition in training data
%         for nV2 = 1:5 % the second vowel of a transition in training data
% 
% % log
% fprintf(flog, '%s%s:\t', vowel(nV1), vowel(nV2));
% 
%             % load gesture data
%             if ismac == 1
%                 filenameH_ = sprintf('filenameH = [''%s/'' ''%d'' ''/'' %s ''-'' %s ''.dgvs''];', dirH, nH, vowel(nV1), vowel(nV2));
%             else
%                 filenameH_ = sprintf('filenameH = [''%s\\'' ''%d'' ''\\'' %s ''-'' %s ''.dgvs''];', dirH, nH, vowel(nV1), vowel(nV2));
%             end
% 
%             eval(filenameH_);
%             %disp(filenameH)
%             H = loadBin(filenameH, 'uchar', 26);
%             frameH = size(H, 2);
%             clear filenameH_
% 
%             % load speech data
%             if ismac == 1
%                 filenameS = [dirS '/' num2str(nS) '/' vowel(nV1) vowel(nV2) '.scep'];
%             else
%                 filenameS = [dirS '\' num2str(nS) '\' vowel(nV1) vowel(nV2) '.scep'];
%             end
%             %disp(filenameS)
%             S = loadBin(filenameS, 'float', 19);
%             frameS = size(S, 2);
% 
% % log
% fprintf(flog, 'gesture,%4d\t', frameH);
% fprintf(flog, 'speech,%4d\t', frameS);
% %disp(['gesture: ' num2str(frameH) ' [frame]'])
% %disp(['speech: ' num2str(frameS) ' [frame]'])
% 
%             % make augmented vector
%             %disp([vowel(nV1) vowel(nV2) ': gesture-' num2str(nH) '; speech-' num2str(nS)])
%             J = makeJoint(H, S, 0);
%             frameJ = size(J, 2);
%             Jnum = Jnum + frameJ;
% 
%             % save augmented vector
%             if ismac == 1
%                 fname_joint = [dirOut '/' vowel(nV1) vowel(nV2) '.joint'];
%             else
%                 fname_joint = [dirOut '\' vowel(nV1) vowel(nV2) '.joint'];
%             end
%             fjoint = fopen(fname_joint, 'wb');
%             for ii = 1:frameJ
%                 fwrite(fjoint, J(:, ii), 'float');
%             end
%             fclose(fjoint);
% % log
% fprintf(flog, 'joint,%4d\n', frameJ);
%             clear fname_joint fjoint frameJ ii;
% 
%         end % nV2
%     end % nV1
% end % nH and nS
% 
% fprintf(flog, '\ntotal frame number in all joint vectors: %d\n', Jnum);
% fclose(flog);


%% make joint vectors
% %conventional method
% % definition
% %dirDgvs  = '/Volumes/RESEARCH/ProbabilisticIntegrationModel/distortion/bestModel/1113/conventionalModel/n-cmv';
% %dirScep  = '/Volumes/RESEARCH/ProbabilisticIntegrationModel/distortion/bestModel/scep/n-cmv';
% %dirJoint = '/Volumes/RESEARCH/ProbabilisticIntegrationModel/distortion/bestModel/1113/conventionalModel/joint';
% dirDgvs  = 'J:\ProbabilisticIntegrationModel\distortion\bestModel\1113\conventionalModel\n-cmv';
% dirScep  = 'J:\ProbabilisticIntegrationModel\distortion\bestModel\scep\n-cmv';
% dirJoint = 'J:\ProbabilisticIntegrationModel\distortion\bestModel\1113\conventionalModel\joint';
% dataSet  = 3;
% fname    = 'no-m';
% 
% if ismac == 1
%     fileDgvs  = [dirDgvs '/' num2str(dataSet) '/' fname '.dgvs'];
%     fileScep  = [dirScep '/' num2str(dataSet) '/' fname '.scep'];
%     fileJoint = [dirJoint '/' num2str(dataSet) '/' fname '.joint'];
% else
%     fileDgvs  = [dirDgvs '\' num2str(dataSet) '\' fname '.dgvs'];
%     fileScep  = [dirScep '\' num2str(dataSet) '\' fname '.scep'];
%     fileJoint = [dirJoint '\' num2str(dataSet) '\' fname '.joint'];    
% end
% 
% H = loadBin(fileDgvs, 'uchar', 26);
% S = loadBin(fileScep, 'float', 19);
% 
% 
% % make augmented vectors 
% J = makeJoint(H, S, 0);
% frameJ = size(J, 2);
% disp([fname ': ' num2str(frameJ) '[frames]'])
% 
% % save augmented vectors
% fjoint = fopen(fileJoint, 'wb');
% for ii = 1:frameJ
%     fwrite(fjoint, J(:, ii), 'float');
% end
% fclose(fjoint);


% proposed method
% % S2H
% % gesture/speaker model
% dirInModel = 'J:\ProbabilisticIntegrationModel\distortion';
% %dirInModel = '/Volumes/RESEARCH/ProbabilisticIntegrationModel/distortion';
% 
% % gesture and speech for convert model
% %dirH = 'I:\_gesture\transitionAmong16of28\dgvs';
% %dirS = 'I:\_speech\Japanese5vowels\isolated\suzuki\16k\scep18';
% %dirS =
% %'/Volumes/RESEARCH/ProbabilisticIntegrationModel/distortion/bestModel/scep/n-cmv';
% %dirS = 'J:\ProbabilisticIntegrationModel\distortion\bestModel\scep\n-cmv';
% dirS = 'J:\ProbabilisticIntegrationModel\distortion\bestModel\scep\n';
% 
% % the directory for the output files
% %dirOut = 'I:\ProbabilisticIntegrationModel\distortion';
% %dirOutSynDgv = '/Volumes/RESEARCH/ProbabilisticIntegrationModel/distortion/bestModel/1113/includeNmodel/n-cmv';
% %dirOutSynDgv = 'J:\ProbabilisticIntegrationModel\distortion\bestModel\1113\includeNmodel\n-cmv';
% dirOutSynDgv = 'J:\ProbabilisticIntegrationModel\distortion\bestModel\1113\includeNmodel\test';
% dirOutJoint  = 'J:\ProbabilisticIntegrationModel\distortion\bestModel\1113\includeNmodel\joint';
% %fname_log    = 'J:\ProbabilisticIntegrationModel\distortion\bestModel\1113\includeNmodel\joint\frameNum.txt';
% 
% % input speech
% %dirConsonant_ = 'I:\ProbabilisticIntegrationModel\distortion\scep';
% consonant = ['b', 'm', 'n', 'p', 'r'];
% vowel = ['a', 'i', 'u', 'e', 'o'];
% transition = ['', 'c', 'm', 'v'];
%  
% % eigen parameters
% EigenParamDir = 'J:\_gesture\transitionAmong16of28\EigenParam\1';
% %EigenParamDir = '/Volumes/RESEARCH/_gesture/transitionAmong16of28/EigenParam/1'; 
% 
% % Saito's method
% alpha = 1; % weight factor for speaker model
% it = 3; % number or iteration
% updatemethod = 1; %0- using target responsibility 1- using joint responsibility
% 
% % ENR = 2.5; % the energy of synthesized speech
% SAMPLING_FREQ = 1; % assumed sampling frequency of DataGlove
% 
% 
% %% PCA parameters
% [EVec, EVal, Eu] = loadEigenParam(EigenParamDir);
% 
% 
% %% S2H
% % Gesture model / Speaker model
% % according to the preliminary test, the optimal mixture number is 64
% % covariance of objGestureModel is diagonal
% if ismac == 1
% %    load([dirInModel '/objGestureModel-64']);
%     load([dirInModel '/objGestureModel-32_withPCA.mat']);
%     load([dirInModel '/objSpeakerModel-64']);
% else
% %    load([dirInModel '\objGestureModel-64']);
%     load([dirInModel '\objGestureModel-32_withPCA.mat']);
%     load([dirInModel '\objSpeakerModel-64']);
% end
% 
% % S2Hmodel
% %load('I:\ProbabilisticIntegrationModel\distortion\5840\objS2Hmodel');
% %load('/Volumes/RESEARCH/ProbabilisticIntegrationModel/distortion/bestModel/1113/preliminaryWithPCA/objS2HmodelWithPCA.mat');
% load('J:\ProbabilisticIntegrationModel\distortion\bestModel\1113\preliminaryWithPCA\objS2HmodelWithPCA.mat');
% 
% %flog  = fopen(fname_log, 'wt');
% 
% %for nS = 1:10;
% nS = 1;
% 
% nC = 3; % n
% for nV = 1:5
%     mora  = sprintf('%s%s', consonant(nC), vowel(nV));
%     for nT = 1:1
%         %fname = [mora '-' transition(nT)];
%         fname = mora;
%         if ismac == 1
%             fname_scepIn = [dirS '/' num2str(nS) '/' fname '.scep'];
%             fname_dgvSyn = [dirOutSynDgv '/' num2str(nS) '/' fname '.dgv'];
%             fname_dgvLog = [dirOutSynDgv '/' num2str(nS) '/' fname '.txt'];
%             fname_joint  = [dirOutJoint '/' num2str(nS) '/' fname '.joint'];
%         else
%             fname_scepIn = [dirS '\' num2str(nS) '\' fname '.scep'];
%             fname_dgvSyn = [dirOutSynDgv '\' num2str(nS) '\' fname '.dgv'];
%             fname_dgvLog = [dirOutSynDgv '\' num2str(nS) '\' fname '.txt'];
%             fname_joint  = [dirOutJoint '\' num2str(nS) '\' fname '.joint'];
%         end
%         disp(fname)
% 
%         % S2H conversion
%         input = loadBin(fname_scepIn, 'float', 19);
%         input = input(2:19, :); % remove energy
%         dgv_ = spkmodel_vc2(input, objS2HmodelWithPCA, objGestureModelWithPCA, alpha, it, updatemethod, fname_dgvLog);
%         % dgv_ holds all results at every step
%         dgv_ = dgv_{1, it}; % dgv_ is PCAed dgv
%         dgvPCA = dgv_;
% 
%         % perform invPCA
%         dgv_ = dgv_';
%         dgv_ = PCA_TransInv(dgv_, EVec, Eu);
%         dgv_ = dgv_';
% 
%         dgv  = conv2dgv(dgv_, SAMPLING_FREQ);
%         frameDgv = size(dgv, 2);
%         
%         % write out
%         fout = fopen(fname_dgvSyn, 'wb');
%         for ii = 1:frameDgv
%             fwrite(fout, dgv(:, ii), 'uchar');
%         end
%         fclose(fout);
%         %clear input dgv dgv_ frameDgv
%         
% %         % make augmented vectors
% %         %  gesture: dgv_ (18 x fnum)
% %         %  speech: input (18 x fnum)
% %         %  joint: H -> S;
% %         J = [dgv_; input];
% %         frameJ = size(J, 2);
% %         %disp([fname ': ' num2str(frameJ) '[frames]'])
% %         
% %         % save augmented vectors
% %         fjoint = fopen(fname_joint, 'wb');
% %         for ii = 1:frameJ
% %            fwrite(fjoint, J(:, ii), 'float');
% %         end
% % % log
% % fprintf(flog, '%d,%s,%4d\n', nS, fname, frameJ);
% %         fclose(fjoint);
%     end %nT
% end %nV
% 
% %end %nS
% %fclose(flog);


%% GMM training
%dirJointVowels     = 'J:\ProbabilisticIntegrationModel\distortion\bestModel\1113\vowels';
% conventional
%dirJointConsonant = 'J:\ProbabilisticIntegrationModel\distortion\bestModel\1113\conventionalModel\joint\1';
%dirOut             = 'J:\ProbabilisticIntegrationModel\distortion\bestModel\1113\conventionalModel';
% proposed
%dirJointConsonant_ = 'J:\ProbabilisticIntegrationModel\distortion\bestModel\1113\includeNmodel\joint';
%dirOut             = 'J:\ProbabilisticIntegrationModel\distortion\bestModel\1113\includeNmodel';


%% load data
%V = loadBinDir(dirJointVowels, 'float', 36);

% % conventional
% C = loadBinDir(dirJointConsonant, 'float', 36);
% Y = [V, C];
% clear dirJointConsonant dirJointVowels
% clear V C

% proposed
% C_c = [];
% C_m = [];
% for nn = 1:10
%     if ismac == 1
%         dirJointConsonant = [dirJointConsonant_ '/' num2str(nn)];
%     else
%         dirJointConsonant = [dirJointConsonant_ '\' num2str(nn)];
%     end
%     dirlist_c = dir([dirJointConsonant '/*-c.joint']);
%     dirlist_m = dir([dirJointConsonant '/*-m.joint']);
%     dirlength = length(dirlist_c);
% 
%     for ii = 1:dirlength
%         if ismac == 1
%             fname_c = [dirJointConsonant '/' dirlist_c(ii).name];
%             fname_m = [dirJointConsonant '/' dirlist_m(ii).name];
%         else
%             fname_c = [dirJointConsonant '\' dirlist_c(ii).name];
%             fname_m = [dirJointConsonant '\' dirlist_m(ii).name];
%         end
%         %disp(fname)
%         tmp_c = loadBin(fname_c, 'float', 36);
%         tmp_m = loadBin(fname_m, 'float', 36);
%         C_c = [C_c, tmp_c];
%         C_m = [C_m, tmp_m];
%     end
%     clear dirlist_c dirlist_m dirlength fname_c fname_m
%     clear tmp_c tmp_m ii
% end
% 
% Y = [V, C_c, C_m];
% clear dirJointVowels dirJointConsonant dirJointConsonant_ nn
% clear V C_c C_m
% 
% 
% %% calculate GMM
% Y = Y';
% for MIX = [1, 2, 4, 8, 16, 32, 64, 128]
%     disp(MIX)
%     
% %     % conventional
% %     objH2SmodelConventional = trainGMM(Y, MIX, 0);
% %     %clear Y
% %     if ismac == 1
% %         save([dirOut '/objH2SmodelConventional_mix' num2str(MIX)], 'objH2SmodelConventional');
% %     else
% %         save([dirOut '\objH2SmodelConventional_mix' num2str(MIX)], 'objH2SmodelConventional');
% %     end
%     
%     % proposed
%     objH2SmodelProposed = trainGMM(Y, MIX, 0);
%     %clear Y
%     if ismac == 1
%         save([dirOut '/objH2SmodelProposed_mix' num2str(MIX)], 'objH2SmodelProposed');
%     else
%         save([dirOut '\objH2SmodelProposed_mix' num2str(MIX)], 'objH2SmodelProposed');
%     end
% end % MIX


%% H2S conversion
dirH = 'J:\_gesture\transitionAmong16of28\dgvs\3';
% dirS = 'J:\_speech\Japanese5vowels\isolated\suzuki\16k\scep18';
% %dirH = '/Volumes/RESEARCH/_gesture/transitionAmong16of28/dgvs';
% %dirS = '/Volumes/RESEARCH/_speech/Japanese5vowels/isolated/suzuki/16k/scep18';

load('J:\ProbabilisticIntegrationModel\distortion\bestModel\1113\includeNmodel\objH2SmodelProposed_mix128.mat');

dirIn  = 'J:\ProbabilisticIntegrationModel\distortion\bestModel\1113\includeNmodel\test';
dirOut = 'J:\ProbabilisticIntegrationModel\distortion\bestModel\1113\includeNmodel\mix128';

dirlist = dir(dirIn);
dirlength = length(dirlist);

ii = 1;
while ii < dirlength + 1
	% except ".", "..", "DS_Store"
  	if length(dirlist(ii).name) > 3 
        filename = strrep(dirlist(ii).name,'.dgvs','');
        %disp(filename)
        
        if ismac == 1
            fname_dgvs = [dirIn '/' filename '.dgvs'];
            fname_scep = [dirOut '/' filename '.scep'];        
            fname_wav  = [dirOut '/' filename '.wav'];
        else
            fname_dgvs = [dirIn '\' filename '.dgvs'];
            fname_scep = [dirOut '\' filename '.scep'];        
            fname_wav  = [dirOut '\' filename '.wav'];
        end
        %disp(fname_dgvs)
        %disp(fname_scep)
        %disp(fname_wav)

        X = loadBin(fname_dgvs, 'uchar', 26);
        X = X(5:22, :);
        scep_ = gmmvc(X, objH2SmodelProposed); 
        scep  = conv2scep(scep_, 2.5);
        clear scep_
        
        % write out scep
        frameScep = size(scep, 2);
        fod = fopen(fname_scep, 'wb');
        j = 1;
        while j < frameScep + 1
            fwrite(fod, scep(:, j), 'float');
            j = j + 1;
        end
        fclose(fod);
        
        % write out wav synthesized using scep
        scep2wav(scep, fname_wav, 'suzuki');
    end
    ii = ii + 1;
end % while