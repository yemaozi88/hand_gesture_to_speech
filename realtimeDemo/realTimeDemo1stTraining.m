%
% 2011/08/24
% realTimeDemo.m calculates GMM parameters for the 1st step H2S
% 2nd training by realTimeDemo2ndTraining.m is needed later
%
% AUTHOR
% Aki Kunikoshi (D3)
% yemaozi88@gmail.com
%

clear all, clc, fclose('all');


%% definition
% 1: make joint vectors - vowels
% 2: make joint vectors - consonants
% 3: train GMM - 1st H2S
% 4: train GMM - 2nd H2S
TYPE = 4;

% the place where 'research' folder is located
RESEARCH = 'J:';
del = '\';

% eigen parameters
% EigenParamDirH = 'J:\!gesture\transitionAmong16of28\EigenParam\1';
% [EVecH, EValH, EuH] = loadEigenParam(EigenParamDirH);
% clear EigenParamDirH

if TYPE == 1 % make joint vectors - vowels
    % gesture and speech for convert model
    dirH  = 'K:\!gesture\transitionAmong16of28\dgvs';
    dirSv = 'K:\!speech\Japanese5vowels\isolated\suzuki\16k\scep16';
    dataSet  = 1;
    dirJoint = 'K:\H2Swith16deg_0243\joint\jointS2H_11';
elseif TYPE == 2 % make joint vectors - consonants
    dirSynDgvCheck = 'J:\H2SwithDelta\demoSample\0243\synDgvCheck';
    dirConsonants = 'J:\!speech\JapaneseConsonants';
    dirSynDgv = 'J:\H2SwithDelta\demoSample\0243\synDgv';
    
    load('J:\H2SwithDelta\withConsonants\objWithoutDelta\objGestureModel-64_withPCA');
    load('J:\H2SwithDelta\demoSample\0243\objS2HjointModel-4');
    alpha = 1; % weight factor for speaker model
    it = 5; % number or iteration
    updatemethod = 1; %0- using target responsibility 1- using joint responsibility    
    SAMPLING_FREQ = 1; % assumed sampling frequency of DataGlove

    % check estimated gestures
    dirDgvDefault = 'J:\!gesture\transitionAmong16of28\default';
    [offset, dgv2deg] = loadHand3Ddefault(dirDgvDefault);
    ERR = 30; % acceptable error range[deg]
    errlog = 'J:\H2SwithDelta\demoSample\0243\log\impossible-to-form2.txt';

elseif TYPE == 3 % gmm training - preparation
    dirTrain = 'J:\H2SwithDelta\demoSample\0243\jointHS_11';
    dirObj   = 'J:\H2SwithDelta\demoSample\0243'; 
    % the number of mixtures
    gNum = 4;
elseif TYPE == 4 % gmm training - H2S
    %dirJointVowels = 'J:\H2SwithDelta\demoSample\0243\jointHS_11';
    %dirJointConsonants = 'J:\H2SwithDelta\demoSample\0243\synDgv';
    dirJointVowels = 'J:\H2Swith16deg_0243\realTimeSystem\jointH2S_11_1of8';
    dirJointConsonants = 'J:\H2Swith16deg_0243\realTimeSystem\jointN';
    dirOut = 'J:\H2Swith16deg_0243\realTimeSystem\S2Hmodel2_full_withDelta_withPCA';
    %dirTest = [RESEARCH '\H2SwithDelta\demoSample\0243\jointHS_22_noDelta'];
    EigenParamDir = 'J:\!gesture\transitionAmong16of28\EigenParam16\1';
    gNum = 16;
elseif TYPE == 5 % output GMM
    
end % TYPE
clear RESEARCH

vowel = ['a', 'i', 'u', 'e', 'o'];
consonant = ['m', 'n', 'r'];
transition = ['c', 'm'];

del = '\';

% sample num = 0243
a = '28';
i = '02';
%i = '07';
u = '01';
e = '09';
%e = '21';
o = '25';
%o = '15';


%% make joint vectors for vowels
if TYPE == 1
    disp('----- make joint vectors (vowels) -----')
% log
fname_log = [dirJoint del 'frameNum.txt'];
 
flog  = fopen(fname_log, 'wt');

fprintf(flog, 'a: %s\t', a);
fprintf(flog, 'i: %s\t', i);
fprintf(flog, 'u: %s\t', u);
fprintf(flog, 'e: %s\t', e);
fprintf(flog, 'o: %s\t', o);
fprintf(flog, '\n');

    % load files
    Jnum = 0;

    %for nH = 1:1; % the number of dgvs data set
    nH = dataSet;
        nS = nH;
% log
fprintf(flog, 'dataset: Hand %d, Speech %d\n', nH, nS);
 
        for nV1 = 1:5 % the first vowel of a transition in training data
            for nV2 = 1:5 % the second vowel of a transition in training data

% log
fprintf(flog, '%s%s:\t', vowel(nV1), vowel(nV2));
disp([vowel(nV1) vowel(nV2)])

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
                    filenameS = [dirSv '/' num2str(nS) '/' vowel(nV1) vowel(nV2) '.scep'];
                else
                    filenameS = [dirSv '\' num2str(nS) '\' vowel(nV1) vowel(nV2) '.scep'];
                end
                %disp(filenameS)
                S = loadBin(filenameS, 'float', 17);
                frameS = size(S, 2);
                clear filenameS

% log
fprintf(flog, 'gesture,%4d\t', frameH);
fprintf(flog, 'speech,%4d\t', frameS);
%disp(['gesture: ' num2str(frameH) ' [frame]'])
%disp(['speech: ' num2str(frameS) ' [frame]'])
                clear frameH frameS
                
                % make augmented vector
                %   with scep0, speech->gesture
                J = makeJoint(H, S, 1, 1);
                frameJ = size(J, 2);
                Jnum = Jnum + frameJ;

                % save augmented vector
                if ismac == 1
                    fname_joint = [dirJoint '/' vowel(nV1) vowel(nV2) '.joint'];
                else
                    fname_joint = [dirJoint '\' vowel(nV1) vowel(nV2) '.joint'];
                end

                fjoint = fopen(fname_joint, 'wb');
                for ii = 1:frameJ
                    fwrite(fjoint, J(:, ii), 'float');
%                     fwrite(fjoint, J(1:16, ii), 'float');
%                     fwrite(fjoint, J(19:34, ii), 'float');
                end
                fclose(fjoint);
% log
fprintf(flog, 'joint,%4d\n', frameJ);
                clear fname_joint fjoint frameJ ii;

            end % nV2
        end % nV1
    %end % nH and nS
    %clear nV1 nV2 nH nS
    %clear H S J
    
    fprintf(flog, '\ntotal frame number in all joint vectors: %d\n', Jnum);
    fclose(flog);
    clear flog

    
%% make joint vectors for consonants
elseif TYPE == 2
    clear a i u e o
    disp('----- make joint vectors (consonants) -----')
    
    ferrlog  = fopen(errlog, 'wt');
    fprintf(ferrlog, 'Acceptable error range of consonant gestures : %d\n', ERR);

    for nC = 1:3
        for nV = 1:5
            for nT = 1:2
                for nS = 1:5
                    mora = [consonant(nC) vowel(nV) '-' transition(nT)];
                    %filenameH = [dirSynDgvCheck '\' mora '.dgv'];
                    filenameS = [dirConsonants '\' consonant(nC) '-cmv\scep18\' num2str(nS) '\' mora '.scep'];
                    foutJoint = [dirSynDgv '\' mora num2str(nS) '.joint'];
                    foutSynDgv = [dirSynDgv '\' mora num2str(nS) '.dgv'];
                    logfile = [dirSynDgv '\' mora num2str(nS) '.txt'];
                    disp(mora)
                    
                    % load files
                    %H = loadBin(filenameH, 'uchar', 26);
                    %H = H(5:22, :);
                    S = loadBin(filenameS, 'float', 19);
                    S = S(1:18, :);
                    
                    % mapping
                    dgvPCA = spkmodel_vc2(S, obj, objGestureModelWithPCA, alpha, it, updatemethod, logfile);
                    dgvPCA = dgvPCA{1, it};

                    % perform invPCA
                    dgvPCA = dgvPCA';
                    dgv_ = PCA_TransInv(dgvPCA, EVecH, EuH);
                    dgv_ = dgv_';

                    dgv  = conv2dgv(dgv_, SAMPLING_FREQ);
                    clear dgvPCA dgv_                    
                    
                    % check movable range
                    [deg, err, fmax] = checkDgvMovableRange(dgv, offset, dgv2deg, ERR);
                    fprintf(ferrlog, '%s\t%6.2f\t%6.2f\t%6.2f\t%6.2f\t%6.2f\n', ... 
                        mora, err(1), err(2), err(3), err(4), err(5));

                    clear deg err fmax
        
                    % output synDgv
                    frameDgv = size(dgv, 2);
                    foutDgv = fopen(foutSynDgv, 'wb');
                    for ii = 1:frameDgv
                        fwrite(foutDgv, dgv(:, ii), 'uchar');
                    end
                    fclose(foutDgv);
                    
                    % output joint
                    fJoint = fopen(foutJoint, 'wb');
                    for ii = 1:frameDgv
                        fwrite(fJoint, dgv(5:22, ii), 'float');
                        fwrite(fJoint, S(:, ii), 'float');
                    end
                    fclose(fJoint);
                    clear fJoint
                end % nS
            end % nT
        end % nV
    end % nC
    fclose(ferrlog);
    
    
%% GMM training - 1st H2S
elseif TYPE == 3
disp('----- train GMM -----')
 
    Y = loadBinDir(dirTrain, 'float', 72);

    % perform PCA
    YH = Y(1:18, :)';
    YS = Y(37:54, :)';
    YHpca = PCA_Trans(YH, EVecH, EuH, 18);
    Y = [YHpca, YS];
    clear YH YHpca YS

    obj = trainGMM(Y, gNum, 0); % 0 - full, 1 - diagonal

    if ismac == 1
        fOut = [dirObj '/objH2SjointModel-' num2str(gNum)];
    else
        fOut = [dirObj '\objH2SjointModel-' num2str(gNum)];
    end
    save(fOut, 'obj');
    clear Y fOut

    
%% GMM training - 2nd H2S
elseif TYPE == 4
    clear a i u e o
    clear vowel consonant transition
    clear TYPE
    
    % load Eigen parameters
    [EVec, EVal, u] = loadEigenParam(EigenParamDir);
    clear EigenParamDir

    % 2nd GMM training 
    % - generated data
    %Yv = loadBinDir('J:\realtimeDemo\v6\0243\2ndTrain_byGeneratedData\jointHS_11_vowels', 'float', 36);
    %Yc = loadBinDir('F:\H2SwithDelta\2ndTrain_byGeneratedData\jointHS_consonants', 'float', 36);
%     Y = [Yv, Yc];

    % - recorded data
%    Y = loadBinDir('F:\H2SwithDelta\2ndTrain_byRecordedData\jointHS', 'float', 36);

%   % 1st GMM training
    % vowel
    YV = loadBinDir(dirJointVowels, 'float', 32);
%    YV = [YV(1:18, :); YV(37:54, :)];

    % consonant
    YC = [];
    for jj = 1:10
        jjStr = num2str(jj);
        dirlist = dir([dirJointConsonants del jjStr del '*.joint']);
        dirlength = length(dirlist);
        for ii = 1:dirlength
            % except ".", "..", "DS_Store"
            if length(dirlist(ii).name) > 3
                filename = dirlist(ii).name;
                %filename = strrep(dirlist(ii).name, '.joint', '');
                %disp([jjStr '-' filename]);
                YC_ = loadBin([dirJointConsonants del jjStr del filename], 'float', 32);
                YC = [YC, YC_];
            end
        end % ii
    end % jj
    clear YC_ ii jj jjStr
    clear dirJointConsonants dirJointVowels dirlength dirlist filename
     
    Y = [YV, YC];
    clear YV YC
    
%     % PCA for Y
%     YH = Y(1:18, :);
%     YS = Y(19:36, :);
    YH = Y(1:16, :);
    YS = Y(17:32, :);
    YHpca = PCA_Trans(YH', EVec, u, 16);
    %Y = [YHpca'; YS];
    Y = [YS; YHpca'];
    Y = adddelta(Y);
    Y = Y';
    clear YH YHpca YS
    
    disp(' data loaded');
    % test data
%    U = loadBinDir('F:\H2SwithDelta\2ndTrain_byGeneratedData\jointHS_22_vowels', 'float', 36);
%    U = U';
    
    % PCA for U
%     UH = U(1:18, :)';
%     US = U(19:36, :)';
%     UHpca = PCA_Trans(UH, EVecH, EuH, 18);
%     U = [UHpca, US];
%     clear UH UHpca US

    clear EVal EVec u

%     ML = zeros(6, 1);
%     for g = 1:6;
%         gNum = 2^(g-1);
%         disp(gNum)
       obj = trainGMM(Y, gNum, 0); % 0 - full, 1 - diagonal
%         %[xCovArr, xMeanArr, WArr, gNum] = ConvertMatlabGMM(obj);
%  
       fOut = [dirOut del 'S2Hmodel_mix' num2str(gNum) '_obj'];
%             fML  = [dirOut '\ML'];
       save(fOut, 'obj');
% %         load(fOut);
%         
%         L_ = pdf(obj, U);
%         L  = log(max(L_)); % maximum likelihood
%         ML(g, 1) = L;
%         save(fML, 'ML');
%     end % g
end