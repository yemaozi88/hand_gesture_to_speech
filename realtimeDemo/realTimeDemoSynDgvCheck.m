%
% 2011/08/23
% realTimeDemoSynDgvCheck.m checks gestures made with S2H system if they are formable
% best design is used for the demonstration of INTERSPEECH 2011
%
% NOTE
% - scep0 is included in features
%
% AUTHOR
% Aki Kunikoshi (D3)
% yemaozi88@gmail.com
%

clear all, fclose all, clc;

%% definition
% the place where 'research' folder is located
RESEARCH = 'K:';

% gesture and speech for convert model
dirH  = [RESEARCH '\!gesture\transitionAmong16of28\dgvs'];
dirSv = [RESEARCH '\!speech\Japanese5vowels\isolated\suzuki\16k\scep18'];
%dirSc = [RESEARCH '\!speech\JapaneseConsonants'];

% make joint vector
dataSet = 1; % dataSet# for joint vectors
dirOut = [RESEARCH '\realtimeDemo\v6\demoSamples'];

% train GMM
gNum = 8; % the number of mixtures

% S2H
%load([RESEARCH '\H2SwithDelta\withConsonants\objWithoutDelta\objGestureModel-64_withPCA']);
load([RESEARCH '\realtimeDemo\v6\demoSamples\objGestureModel-128']);

dirScep4synDgvCheck = [RESEARCH '\H2SwithDelta\!speech\synDgvCheck'];

alpha = 1; % weight factor for speaker model
it = 5; % number or iteration
updatemethod = 1; %0- using target responsibility 1- using joint responsibility    
SAMPLING_FREQ = 1; % assumed sampling frequency of DataGlove

% check estimated gestures
dirDgvDefault = [RESEARCH '\!gesture\transitionAmong16of28\default'];
[offset, dgv2deg] = loadHand3Ddefault(dirDgvDefault);
ERR = 30; % acceptable error range[deg]
thres = 10; % error / all frames

vowel = ['a', 'i', 'u', 'e', 'o'];

% eigen parameters
EigenParamDirH = [RESEARCH '\!gesture\transitionAmong16of28\EigenParam\1'];
[EVecH, EValH, EuH] = loadEigenParam(EigenParamDirH);
clear RESEARCH EigenParamDirH


%% choose 5 gestures among 16 gestures
%ges = [1, 2, 4, 7, 8, 9, 11, 13, 14, 15, 16, 21, 22, 25, 27, 28];
[dgvMean, gestureCombinationList] = make16gestureCombinationList(dirH);
P = gestureCombinationList;
%Pnum = size(P, 1);  % the number of all permutations
clear dgvMean gestureCombinationList

buf_totalErrNum = 1000;
bestDesign = '0000';

%for nP = 1:8190;  % the number of the permutation
for nP = 243:243;
tic
% nP: num 2 str
if nP < 10
    nPstr = ['000' num2str(nP)];
elseif nP < 100
    nPstr = ['00' num2str(nP)];
elseif nP < 1000
    nPstr = ['0' num2str(nP)];
else
    nPstr = num2str(nP);
end

% directory processing
dirOutSub = [dirOut '\' nPstr];
dirJoint  = [dirOutSub '\jointSH_11'];
dirSynDgvCheck = [dirOutSub '\synDgvCheck'];
mkdir(dirOutSub)
mkdir(dirJoint)
mkdir(dirSynDgvCheck)


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
    
disp(['Gesture Design: ' nPstr]);
disp(['a:' a ' i:' i ' u:' u ' e:' e ' o:' o]);


%% make joint vectors
disp('1. making joint vectors... ')
Y = [];
Jnum = 0; % total number of loaded data

nH = dataSet; % the number of dgvs/speech data set
nS = nH;

for nV1 = 1:5 % the first vowel of a transition in training data
    for nV2 = 1:5 % the second vowel of a transition in training data

        %disp([vowel(nV1) vowel(nV2)])

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
        clear filenameH_ filenameH

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
        clear frameH frameS

        % (H, S, scep0, mode)
        %J = makeJointWithDelta(H, S, 1, 1);
        J = makeJoint(H, S, 1, 1);
        frameJ = size(J, 2);
        Y = [Y, J];
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

        clear fname_joint fjoint frameJ ii;
    end % nV2
end % nV1
disp(['total frame number of all joint vectors: ' num2str(Jnum) char(10)]);

clear nV1 nV2 nH nS
clear H S J Jnum


%% GMM training
disp('2. training GMM... ')
 
YS = Y(1:18, :)';
%YH = Y(37:54, :)';
YH = Y(19:34, :)';
Y = [YS, YH];

% PCA
%YHpca = PCA_Trans(YH, EVecH, EuH, 18);
%Y = [YS, YHpca];
%clear YH YHpca YS

obj = trainGMM(Y, gNum, 1); % 0 - full, 1 - diagonal

if ismac == 1
    fOut = [dirOutSub '/objS2HjointModel-' num2str(gNum)];
else
    fOut = [dirOutSub '\objS2HjointModel-' num2str(gNum)];
end
save(fOut, 'obj');
clear Y fOut


%% S2H
disp('3. S2H')

% error log for impossible-to-form range
if ismac == 1
    fname_errlog = [dirOutSub '/impossible-to-form.log'];
else
    fname_errlog = [dirOutSub '/impossible-to-form.log'];
end
ferrlog  = fopen(fname_errlog, 'wt');
fprintf(ferrlog, 'Acceptable error range of consonant gestures : %d\n', ERR);


% directory processing
dirlist = dir([dirScep4synDgvCheck '\*.*']);
dirlength = length(dirlist);

totalErrNum = 0;
for ii = 1:dirlength
    % except ".", "..", "DS_Store"
    if length(dirlist(ii).name) > 3
        filename = strrep(dirlist(ii).name, '.scep', '');

        if ismac == 1
            finFea  = [dirScep4synDgvCheck '/' filename '.scep'];
            foutDgv = [dirSynDgvCheck '/' filename '.dgv'];
            logfile = [dirSynDgvCheck '/' filename '.log'];
        else
            finFea  = [dirScep4synDgvCheck '\' filename '.scep'];
            foutDgv = [dirSynDgvCheck '\' filename '.dgv'];
            logfile = [dirSynDgvCheck '\' filename '.log'];
        end

        feaIn = loadBin(finFea, 'float', 19);
        feaIn = feaIn(1:18, :);

%         % mapping
%         dgvPCA = spkmodel_vc2(feaIn, obj, objGestureModelWithPCA, alpha, it, updatemethod, logfile);
%         dgvPCA = dgvPCA{1, it};
% 
%         % perform invPCA
%         dgvPCA = dgvPCA';
%         dgv_ = PCA_TransInv(dgvPCA, EVecH, EuH);
%         dgv_ = dgv_';

        dgv_ = spkmodel_vc2(feaIn', obj, objGestureModel, alpha, it, updatemethod, logfile);
        fmax = size(dgv_, 2);
        tmp  = repmat([170; 80], 1, fmax);
        dgv_ = [dgv_; tmp];
        clear fmax tmp
        dgv  = conv2dgv(dgv_, SAMPLING_FREQ);
        %clear dgvPCA dgv_

        % check movable range
        [deg, err, fmax] = checkDgvMovableRange(dgv, offset, dgv2deg, ERR);
        fprintf(ferrlog, '%s\t%6.2f\t%6.2f\t%6.2f\t%6.2f\t%6.2f\n', ... 
            filename, err(1), err(2), err(3), err(4), err(5));
        
        errNum = 0;
        for ii = 1:5
            if err(ii) > thres
                errNum = errNum + 1;
            end
        end
        totalErrNum = totalErrNum + errNum;
        clear deg err fmax errNum
        
        % output synDgv
        frameDgv = size(dgv, 2);
        fout = fopen(foutDgv, 'wb');
        for ii = 1:frameDgv
            fwrite(fout, dgv(:, ii), 'uchar');
        end
        fclose(fout);
    end
end % ii
disp('--------------------')
disp(['total error: ' num2str(totalErrNum) char(10)])
fclose(ferrlog);
clear ferrlog

if totalErrNum < buf_totalErrNum
    buf_totalErrNum = totalErrNum;
    bestDesign = nPstr;
end
disp(['best design: ' bestDesign '(error ' num2str(buf_totalErrNum) ' )'])
toc
end % nP