%
% 2011/08/19
% train GMM and make H2S converter with delta features, including consonants 
% energy (scep0) is used for training/mapping
%
% NOTE
% this program is based on H2SwithDelta.m
%
% AUTHOR
% Aki Kunikoshi (D3)
% yemaozi88@gmail.com
%

clear all, clc, fclose('all');


%% definition
% 1: make joint vectors
% 2: train GMM
% 3: H2S
% 4: PCA
TYPE = 3;

% the place where 'research' folder is located
RESEARCH = 'J:';

% vowel
% gesture and speech for convert model
dirH  = [RESEARCH '\!gesture\transitionAmong16of28\dgvs'];
dirSv = [RESEARCH '\!speech\Japanese5vowels\isolated\suzuki\16k\scep18'];
dirSc = [RESEARCH '\!speech\JapaneseConsonants'];

% eigen parameters
EigenParamDirH = 'J:\!gesture\transitionAmong16of28\EigenParam\1';
[EVecH, EValH, EuH] = loadEigenParam(EigenParamDirH);
clear EigenParamDirH

if TYPE == 1 % make joint vectors
    dataSet  = 2; 
    dirJoint = [RESEARCH '\H2SwithDelta\withConsonanats\jointSH_22'];
elseif TYPE == 2 % gmm training
    dirTrain = [RESEARCH '\H2SwithDelta\withConsonanats\objWithDelta\jointSH_11'];
    dirObj   = [RESEARCH '\H2SwithDelta\withConsonanats\objWithoutDelta']; 
    % the number of mixtures
    gNum = 16;
elseif TYPE == 3 % S2H with probabilistic integration model
    load('J:\H2SwithDelta\withConsonants\objWithoutDelta\objGestureModel-64_withPCA');
    load('J:\H2SwithDelta\withConsonants\objWithoutDelta\objS2HjointModel-16');
    dirIn  = dirSv;
    dirOut = 'J:\H2SwithDelta\withConsonants\synDgv\vowels';
    %dirIn_  = 'J:\!speech\JapaneseConsonants';
    %dirOut_ = 'J:\H2SwithDelta\withConsonants\synDgv';

    % Saito's method
    alpha = 1; % weight factor for speaker model
    it = 5; % number or iteration
    updatemethod = 1; %0- using target responsibility 1- using joint responsibility
    
    SAMPLING_FREQ = 1; % assumed sampling frequency of DataGlove
end % TYPE
clear RESEARCH

vowel = ['a', 'i', 'u', 'e', 'o'];
 
% sample num = 3774
a = '28';
i = '02';
u = '27';
e = '22';
o = '14';


%% make joint vectors from dgv and scep
if TYPE == 1
    disp('----- make joint vectors -----')
% log
if ismac == 1
    fname_log = [dirJoint '/frameNum.txt'];
else
    fname_log = [dirJoint '\frameNum.txt'];
end
 
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
                S = loadBin(filenameS, 'float', 19);
                frameS = size(S, 2);
                clear filenameS

% log
fprintf(flog, 'gesture,%4d\t', frameH);
fprintf(flog, 'speech,%4d\t', frameS);
%disp(['gesture: ' num2str(frameH) ' [frame]'])
%disp(['speech: ' num2str(frameS) ' [frame]'])
                clear frameH frameS
                
                % make augmented vector
                %   without Scep, gesture->speech
                %J = makeJoint(H, S, 0, 0);
                J = makeJointWithDelta(H, S, 1, 1);
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
                end
                fclose(fjoint);
% log
fprintf(flog, 'joint,%4d\n', frameJ);
                clear fname_joint fjoint frameJ ii;

            end % nV2
        end % nV1
    %end % nH and nS
    clear nV1 nV2 nH nS
    clear H S J
    
    fprintf(flog, '\ntotal frame number in all joint vectors: %d\n', Jnum);
    fclose(flog);
    clear flog
%% train GMM
elseif TYPE == 2
    tic
    clear dirH dirSc dirSv
    disp('----- train GMM -----')
    
    Y = loadBinDir(dirTrain, 'float', 72);
    
    YS = Y(1:18, :)';
    YH = Y(37:54, :)';
    YHpca = PCA_Trans(YH, EVecH, EuH, 18);
    Y = [YS, YHpca];
    clear YH YHpca YS
    
    %Y = Y';
    %Ydgv  = Y(1:36, :)';
    %Yscep = Y(37:72, :)';

    %YdgvPCA  = PCA_Trans(Ydgv, EVecH, EuH, 36);
    %YscepPCA = PCA_Trans(Yscep, EVecS, EuS, 36);

    %Y = [YdgvPCA, Yscep];
    %clear Ydgv Yscep YdgvPCA YscepPCA
    %clear EVecH EValH EuH
    %clear EVecS EValS EuS
    
    obj = trainGMM(Y, gNum, 0); % 0 - full, 1 - diagonal
    
    if ismac == 1
        fOut = [dirObj '/jointModel_mix' num2str(gNum) '_obj'];
    else
        fOut = [dirObj '\jointModel_mix' num2str(gNum) '_obj'];
    end
    save(fOut, 'obj');
    clear dirObj fOut
    toc
%% S2H
elseif TYPE == 3
    clear a i u e o
    disp('----- S2H -----')

%for consonant = ['b', 'm', 'n', 'r'];
    %dirIn  = [dirIn_ '\' consonant '\suzuki\16k\scep18\'];
    %dirOut = [dirOut_ '\' consonant];
    
    %dirIn  = [dirIn_ '\' consonant '-cmv\scep18'];
    %dirOut = [dirOut_ '\' consonant '-cmv'];

for dataSet = 1:5;
    dsStr = num2str(dataSet); 

    if ismac == 1
        %dirInSub  = [dirSv '/' dsStr];
        dirInSub  = [dirIn '/' dsStr];
        dirOutSub = [dirOut '/' dsStr];

        dirlist = dir([dirInSub '/*.*']);
    else
        %dirInSub  = [dirSv '\' dsStr];
        dirInSub  = [dirIn '\' dsStr];
        dirOutSub = [dirOut '\' dsStr];

        dirlist = dir([dirInSub '\*.*']);
    end
    
    dirlength = length(dirlist);

    for ii = 1:dirlength
        % except ".", "..", "DS_Store"
        if length(dirlist(ii).name) > 3
            filename = strrep(dirlist(ii).name, '.scep', '');
            disp([filename ' - ' dsStr])
            
            if ismac == 1
                finFea  = [dirInSub '/' filename '.scep'];
                foutDgv = [dirOutSub '/' filename '.dgv'];
                logfile = [dirOutSub '/' filename '.log'];
            else
                finFea  = [dirInSub '\' filename '.scep'];
                foutDgv = [dirOutSub '\' filename '.dgv'];
                logfile = [dirOutSub '\' filename '.log'];
            end

            feaIn = loadBin(finFea, 'float', 19);
            feaIn = feaIn(1:18, :);
            
            % mapping
            dgvPCA = spkmodel_vc2(feaIn, obj, objGestureModelWithPCA, alpha, it, updatemethod, logfile);
            dgvPCA = dgvPCA{1, it};
            
            % perform invPCA
            dgvPCA = dgvPCA';
            dgv_ = PCA_TransInv(dgvPCA, EVecH, EuH);
            dgv_ = dgv_';
            
            dgv  = conv2dgv(dgv_, SAMPLING_FREQ);
            clear dgvPCA dgv_

            frameDgv = size(dgv, 2);
            fout = fopen(foutDgv, 'wb');
            for ii = 1:frameDgv
                fwrite(fout, dgv(:, ii), 'uchar');
            end
            fclose(fout);
        end
    end % ii
    
end % dataSet
%end % consonant

end % TYPE