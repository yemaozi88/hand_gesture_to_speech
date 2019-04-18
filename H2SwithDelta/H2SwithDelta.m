%
% 2011/08/15
% train GMM and make H2S converter with delta features 
%
% NOTE
% this program is based on makeSample4listeningTest.m
%
% AUTHOR
% Aki Kunikoshi (D3)
% yemaozi88@gmail.com
%

clear all, clc, fclose('all');


%% definition
% 0: make feature vectors for with delta
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
EigenParamDirH = [RESEARCH '\H2SwithDelta\!dgvd\EigenParam\1'];
EigenParamDirS = [RESEARCH '\H2SwithDelta\!scepd\EigenParam\1'];

    
DELTA = 1; % 0: without delta, 1: with delta

if TYPE == 0 % make feature vectors
    dirOutH = [RESEARCH '\H2SwithDelta\!dgvs'];
    dirOutS = [RESEARCH '\H2SwithDelta\!scep'];
elseif TYPE == 1 % make joint vectors
    dataSet  = 1; 
    dirJoint = [RESEARCH '\H2SwithDelta\withDelta_PCA\joint11_HS'];
elseif TYPE == 2 % gmm training
    dirTrain = [RESEARCH '\H2SwithDelta\withDelta\joint11_HS'];
    dirObj   = [RESEARCH '\H2SwithDelta\withDelta_PCA\gmm_full']; 
    % the number of mixtures
    gNum = 4;
elseif TYPE == 3 % H2S
    load([RESEARCH '\H2SwithDelta\withDelta_PCA\gmm_full\jointModel_mix8_obj']);
    dirIn  = [RESEARCH '\H2SwithDelta\!dgvd\1'];
    dirOut = [RESEARCH '\H2SwithDelta\withDelta_PCA\converted\1'];
elseif TYPE == 4 % PCA
    dirPCAin  = [RESEARCH '\H2SwithDelta\!dgvd\2'];
    dirPCAout = [RESEARCH '\H2SwithDelta\!dgvd\EigenParam'];
end % TYPE

clear RESEARCH


consonant = ['b', 'm', 'n', 'p', 'r'];
vowel = ['a', 'i', 'u', 'e', 'o'];
 
% sample num = 3774
a = '28';
i = '02';
u = '27';
e = '22';
o = '14';

% load EigenParam
[EVecH, EValH, EuH] = loadEigenParam(EigenParamDirH);
[EVecS, EValS, EuS] = loadEigenParam(EigenParamDirS);
clear EigenParamDirH EigenParamDirS
    

%% make feature vectors
if TYPE == 0
    disp('----- make feature vectors -----')
    for nn = 1:1 % the number of dataset
        nH = nn;
        nS = nn;
        for nV1 = 1:5 % the first vowel of a transition in training data
            if nV1 == 0 % consonants
%                 for nC = 1:5
%                     for nV2 = 1:5
%                         mora = [consonant(nC), vowel(nV2)];
%                         disp(mora)
%                         if ismac == 1
%                             filenameS = [dirSc '/' consonant(nC) '/suzuki/16k/scep18/' num2str(nS) '/' mora '.scep'];
%                         else
%                             filenameS = [dirSc '\' consonant(nC) '\suzuki\16k\scep18\' num2str(nS) '\' mora '.scep'];
%                         end
%                     end % nV2
%                 end % nC
            else
                for nV2 = 1:5 % the second vowel of a transition in training data
                    mora = [vowel(nV1) vowel(nV2)];
                    disp(mora)

                    % load gesture data
                    if ismac == 1
                        filenameH_ = sprintf('filenameH = [''%s/'' ''%d'' ''/'' %s ''-'' %s ''.dgvs''];', dirH, nH, vowel(nV1), vowel(nV2));
                        filenameS  = [dirSv '/' num2str(nS) '/' mora '.scep'];

                        if DELTA == 0
                            foutH = [dirOutH '/' num2str(nS) '/' mora '.dgvs'];
                        elseif DELTA == 1
                            foutH = [dirOutH '/' num2str(nS) '/' mora '.dgvd'];
                        else
                            error('variable DELTA should be 0 or 1!');
                        end
                        foutS = [dirOutS '/' num2str(nS) '/' mora '.scepd'];
                    else
                        filenameH_ = sprintf('filenameH = [''%s\\'' ''%d'' ''\\'' %s ''-'' %s ''.dgvs''];', dirH, nH, vowel(nV1), vowel(nV2));
                        filenameS = [dirSv '\' num2str(nS) '\' mora '.scep'];
                        if DELTA == 0
                            foutH = [dirOutH '\' num2str(nS) '\' mora '.dgvs'];
                        elseif DELTA == 1
                            foutH = [dirOutH '\' num2str(nS) '\' mora '.dgvd'];
                        else
                            error('variable DELTA should be 0 or 1!');
                        end
                        foutS = [dirOutS '\' num2str(nS) '\' mora '.scepd'];
                    end

                    eval(filenameH_);
                    clear filenameH_

                    disp(foutH)
                    disp(foutS)
                    
                    if DELTA == 0
                        copyfile(filenameH, foutH);
                    elseif DELTA == 1
                        addDelta2(filenameH, 18, 'dgv', foutH);
                        addDelta2(filenameS, 18, 'scep', foutS);
                    end
                end % nV2
            end

            clear filenameH filenameS
            clear foutH foutS
        end % nV1
        clear nV1 nV2 mora
    end % nn
    clear nH nS

    
%% make joint vectors from dgv and scep
elseif TYPE == 1
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
                J = makeJointWithDelta(H, S, 0, 0);
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
    %Y = Y';
    Ydgv  = Y(1:36, :)';
    Yscep = Y(37:72, :)';

    YdgvPCA  = PCA_Trans(Ydgv, EVecH, EuH, 36);
    YscepPCA = PCA_Trans(Yscep, EVecS, EuS, 36);

    Y = [YdgvPCA, YscepPCA];
    Y(:, 70:72) = Y(:, 70:72) * 10; % covariance got too small...
    clear Ydgv Yscep YdgvPCA YscepPCA
    clear EVecH EValH EuH
    clear EVecS EValS EuS
    
    obj = trainGMM(Y, gNum, 0); % 0 - full, 1 - diagonal
    
    if ismac == 1
        fOut = [dirObj '/jointModel_mix' num2str(gNum) '_obj'];
    else
        fOut = [dirObj '\jointModel_mix' num2str(gNum) '_obj'];
    end
    save(fOut, 'obj');
    clear dirObj fOut
    toc
%% H2S
elseif TYPE == 3
    clear a i u e o
    disp('----- H2S -----')
    
    dirlist = dir([dirIn '\*.*']);
    dirlength = length(dirlist);

    for ii = 1:dirlength
        % except ".", "..", "DS_Store"
        if length(dirlist(ii).name) > 3
            if DELTA == 0
                filename = strrep(dirlist(ii).name, '.dgvs', '');
            elseif DELTA == 1
                filename = strrep(dirlist(ii).name, '.dgvd', '');
            else
                error('DELTA should be 0 or 1!')
            end
            disp(filename)
            
            if ismac == 1
            else
                if DELTA == 0
                    finFea  = [dirIn '\' filename '.dgvs'];
                    foutFea = [dirOut '\' filename '.scep'];
                    feaIn = loadBin(finFea, 'uchar', 26);
                    
                    feaIn = feaIn(5:22, :);
                    fmax = size(feaIn, 2);
                    
                    feaOut = gmmMapping(feaIn, obj);
                elseif DELTA == 1
                    finFea  = [dirIn '\' filename '.dgvd'];
                    foutFea = [dirOut '\' filename '.scep'];
                    feaIn = loadBin(finFea, 'float', 36);
                    
                    % the first and the last deltas are wrong
                    fmax = size(feaIn, 2);
                    feaIn(:, fmax) = [];
                    feaIn(:, 1) = [];
                    fmax = fmax - 2;
                    
                    % mapping
                    %it = 1;
                    %feaOut = gmmvc_delta(feaIn, obj, it);
                    %feaOut = feaOut{1, it};

                    feaInPCA = PCA_Trans(feaIn', EVecH, EuH, 36);
                    feaIn = feaInPCA';
                    clear feaInPCA
                    
                    feaOut = gmmMappingWithDelta2(feaIn, obj);

                    % perform invPCA
                    feaOut = feaOut';
                    feaOut = PCA_TransInv(feaOut, EVecS, EuS);
                    feaOut = feaOut(:, 1:18)';
                    
                    % halven the data
%                     feaOut_ = [];
%                     for ii = 1:fmax
%                         if rem(ii, 2) == 0
%                             feaOut_ = [feaOut_, feaOut(:, ii)];
%                         end
%                     end
%                     feaOut = feaOut_;
%                     clear feaOut_
                end
            end

            % add energy
            fmax   = size(feaOut, 2);
            energy = repmat(-4.0, 1, fmax);
            feaOut = [energy; feaOut];

            % write out feature
            fFea = fopen(foutFea, 'wb');
            for t = 1:fmax
                fwrite(fFea, feaOut(:, t), 'float');
            end
            clear t
            fclose(fFea);

            % convert scep into wav
            foutWav = [dirOut '\' filename '.wav'];
            scep2wav(feaOut, foutWav, 'suzuki');
        end
    end % ii
%% PCA
elseif TYPE == 4
    X = loadBinDir(dirPCAin, 'float', 36);
    fmax = size(X, 2);
%     Y = [];
%     for ii = 1:fmax
%         disp(ii)
%         if rem(ii, 10) == 1
%             Y = [Y, X(:, ii)];
%         end % rem
%     end % ii
%     clear X ii
    getEigenParam(X', dirPCAout);
end % TYPE