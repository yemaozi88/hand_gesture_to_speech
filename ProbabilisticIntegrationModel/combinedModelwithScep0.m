%
% 2011/04/30
% train GMM, S2H and H2S converters
% speech feature is scep 0-17 deg (includes energy)
%
% REMARKS
% this program is based on makeSample4listeningTest.m
%
% AUTHOR
% Aki Kunikoshi (D3)
% yemaozi88@gmail.com
%

clear all, clc, fclose('all');

mode = 3; % 0: make joint vectors; 1:GMM training; 2:S2H; 3:H2S;


%% make joint vectors
if mode == 0
    disp('--- make joint vectors ---')
    
    %% definition
    % gesture and speech for convert model
    dirH = 'J:\!gesture\transitionAmong16of28\dgvs';
    dirS = 'J:\!speech\Japanese5vowels\isolated\suzuki\16k\scep18';
    %dirH = '/Volumes/RESEARCH/_gesture/transitionAmong16of28/dgvs';
    %dirS = '/Volumes/RESEARCH/_speech/Japanese5vowels/isolated/suzuki/16k/scep18';

    % consonant = ['b', 'm', 'n', 'p', 'r'];
    vowel = ['a', 'i', 'u', 'e', 'o'];
 
    % the directory for the output files
    %dirOut = '/Volumes/RESEARCH/ProbabilisticIntegrationModel/distortion/bestModel/1113/vowels';
    dirOut = 'J:\ProbabilisticIntegrationModel\distortionWithScep0\1113\0-17\joint22_SH';

    % log
    if ismac == 1
    fname_log = [dirOut '/log.txt'];
    else
    fname_log = [dirOut '\log.txt'];
    end

    flog  = fopen(fname_log, 'wt');

    % sample num = 1113
    a = '28';
    i = '07';
    u = '01';
    e = '21';
    o = '15';

    fprintf(flog, 'a: %s\t', a);
    fprintf(flog, 'i: %s\t', i);
    fprintf(flog, 'u: %s\t', u);
    fprintf(flog, 'e: %s\t', e);
    fprintf(flog, 'o: %s\t', o);
    fprintf(flog, '\n');
 
    
    %% make joint vectors
    Jnum = 0;
    for nH = 2:2; % the number of dgvs data set
    %for nS = 1:3; % the number of scep data set
    nS = nH;
    % log
    fprintf(flog, 'dataset: Hand %d, Speech %d\n', nH, nS);

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
    fprintf(flog, 'gesture,%4d\t', frameH);
    fprintf(flog, 'speech,%4d\t', frameS);
    %disp(['gesture: ' num2str(frameH) ' [frame]'])
    %disp(['speech: ' num2str(frameS) ' [frame]'])

            % make augmented vector
            %disp([vowel(nV1) vowel(nV2) ': gesture-' num2str(nH) '; speech-' num2str(nS)])
            J = makeJoint(H, S, 1, 1); % with scep0, J = [S, H]
            frameJ = size(J, 2);
            Jnum = Jnum + frameJ;

            % save augmented vector
            if ismac == 1
                fname_joint = [dirOut '/' vowel(nV1) vowel(nV2) '.joint'];
            else
                fname_joint = [dirOut '\' vowel(nV1) vowel(nV2) '.joint'];
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
    end % nH and nS

    fprintf(flog, '\ntotal frame number in all joint vectors: %d\n', Jnum);
    fclose(flog);
    clear flog
    clear H S J Jnum
    clear a i u e o vowel
    clear nH nS nV1 nV2


%% GMM training
elseif mode == 1
    MIX = 32;
    
    disp('--- GMM training ---')
    A = loadBinDir('J:\ProbabilisticIntegrationModel\distortionWithScep0\1113\0-17\reducedJoint11_SH', 'float', 36);
    B = loadBinDir('J:\ProbabilisticIntegrationModel\distortionWithScep0\1113\0-17\reducedJoint22_SH', 'float', 36);
    Y = [A, B];
    Y = Y';
    clear A B
    
    disp(['the number of frames in training data: ' num2str(size(Y, 1))])
    disp(['the number of mixtures: ' num2str(MIX)])
    
    tic
    objS2Hmodel = trainGMM(Y, MIX, 0);
    save('J:\ProbabilisticIntegrationModel\distortionWithScep0\1113\0-17\objS2Hmodel_mix32', 'objS2Hmodel');
    toc
    
    clear Y mode MIX
    

%% S2H
elseif mode == 2
    disp('--- S2H conversion ---')
    
    %% definition
    % gesture/speaker model
    dirInModel = 'J:\ProbabilisticIntegrationModel\distortionWithScep0';
    %dirInModel = '/Volumes/RESEARCH/ProbabilisticIntegrationModel/distortion';

    % S2Hmodel
    load('J:\ProbabilisticIntegrationModel\distortionWithScep0\1113\0-17\objS2Hmodel_mix32');

    %% gesture and speech for convert model
    dirVowels     = 'J:\!speech\Japanese5vowels\isolated\suzuki\16k\scep18\1';
    %dirConsonants = 'J:\!speech\JapaneseConsonants\n\suzuki\16k\scep18\1';
    dirConsonants_ = 'J:\!speech\JapaneseConsonants';

    % the directory for the output files
    dirOutSynDgv = 'J:\ProbabilisticIntegrationModel\distortionWithScep0\1113\0-17\synDgv';

    % % input speech
    % dirConsonant_ = 'I:\ProbabilisticIntegrationModel\distortion\scep';
    vowel = ['a', 'i', 'u', 'e', 'o'];
    consonant = ['b', 'm', 'n', 'p', 'r'];

    % % eigen parameters
    % EigenParamDir = 'I:\_gesture\transitionAmong16of28\EigenParam\1';
    % % %EigenParamDir = '/Volumes/RESEARCH/_gesture/transitionAmong16of28/EigenParam/1'; 

    % Saito's method
    alpha = 1; % weight factor for speaker model
    it = 3; % number or iteration
    updatemethod = 1; %0- using target responsibility 1- using joint responsibility
  
    SAMPLING_FREQ = 1; % assumed sampling frequency of DataGlove
    
    % % PCA parameters
    % [EVec, EVal, Eu] = loadEigenParam(EigenParamDir);


    %% S2H
    % Gesture model
    % according to the preliminary test, the optimal mixture number is 64
    % covariance of objGestureModel is diagonal
    if ismac == 1
        load([dirInModel '/objGestureModel-64']);
    else
        load([dirInModel '\objGestureModel-64']);
    end
    
    nS = 1;
    %for nC = 1:5; % consonant
    nC = 3;
    for nV1 = 1:5 % 0 means consonant
        for nV2 = 1:5
            if nV1 == 0             
                mora  = sprintf('%s%s', consonant(nC), vowel(nV2));
                fname = mora;
                dirConsonants = [dirConsonants_ '\' consonant(nC) '\suzuki\16k\scep18\1'];
                
                if ismac == 1
                    fname_scepIn = [dirConsonants '/' fname '.scep'];
                    fname_dgvSyn = [dirOutSynDgv '/' fname '.dgv'];
                    fname_dgvLog = [dirOutSynDgv '/' fname '.txt'];
                else
                    fname_scepIn = [dirConsonants '\' fname '.scep'];
                    fname_dgvSyn = [dirOutSynDgv '\' fname '.dgv'];
                    fname_dgvLog = [dirOutSynDgv '\' fname '.txt'];
                end
                
            else
                mora  = sprintf('%s%s', vowel(nV1), vowel(nV2));
                fname = mora;
                if ismac == 1
                    fname_scepIn = [dirVowels '/' fname '.scep'];
                    fname_dgvSyn = [dirOutSynDgv '/' fname '.dgv'];
                    fname_dgvLog = [dirOutSynDgv '/' fname '.txt'];
                else
                    fname_scepIn = [dirVowels '\' fname '.scep'];
                    fname_dgvSyn = [dirOutSynDgv '\' fname '.dgv'];
                    fname_dgvLog = [dirOutSynDgv '\' fname '.txt'];
                end
            end
            disp(mora)

            % conversion
            input = loadBin(fname_scepIn, 'float', 19);
            %input = input(2:19, :); % remove energy, scep 1-18
            input = input(1:18, :); % with energy, scep 0-17

            dgv_ = spkmodel_vc2(input, objS2Hmodel, objGestureModel, alpha, it, updatemethod, fname_dgvLog);
            % dgv_ holds all results at every step
            dgv_ = dgv_{1, it};
        %         dgvPCA = dgv_;
        % 
        %         % perform invPCA
        %         dgv_ = dgv_';
        %         dgv_ = PCA_TransInv(dgv_, EVec, Eu);
        %         dgv_ = dgv_';

            dgv  = conv2dgv(dgv_, SAMPLING_FREQ);
            frameDgv = size(dgv, 2);

            % write out
            fout = fopen(fname_dgvSyn, 'wb');
            for ii = 1:frameDgv
                fwrite(fout, dgv(:, ii), 'uchar');
            end
            fclose(fout);
            clear input dgv dgv_ frameDgv
        end % nV2
    end % nV1

    
%% H2S    
elseif mode == 3
    disp('--- H2S conversion ---')
    
    %% definition
    % dirH = 'J:\_gesture\transitionAmong16of28\dgvs\3';
    % % dirS = 'J:\_speech\Japanese5vowels\isolated\suzuki\16k\scep18';
    % % %dirH = '/Volumes/RESEARCH/_gesture/transitionAmong16of28/dgvs';
    % % %dirS = '/Volumes/RESEARCH/_speech/Japanese5vowels/isolated/suzuki/16k/scep18';

    % gesture/speaker model
    dirInModel = 'J:\ProbabilisticIntegrationModel\distortionWithScep0';
    %dirInModel = '/Volumes/RESEARCH/ProbabilisticIntegrationModel/distortion';

    % Speaker model
    % according to the preliminary test, the optimal mixture number is 128
    % covariance of objSpeakerModel is diagonal
    if ismac == 1
        load([dirInModel '/objSpeakerModel-64_scep0-17']);
        %load([dirInModel '/objSpeakerModel-64_scep1-18']);        
    else
        load([dirInModel '\objSpeakerModel-64_scep0-17']);
        %load([dirInModel '/objSpeakerModel-64_scep1-18']);
    end

    % H2Smodel
    load('J:\ProbabilisticIntegrationModel\distortionWithScep0\1113\0-17\objS2Hmodel_mix32');

    % % eigen parameters
    % EigenParamDir = 'I:\_gesture\transitionAmong16of28\EigenParam\1';
    % % %EigenParamDir = '/Volumes/RESEARCH/_gesture/transitionAmong16of28/EigenParam/1'; 

    % Saito's method
    alpha = 1; % weight factor for speaker model
    it = 3; % number or iteration
    updatemethod = 1; %0- using target responsibility 1- using joint responsibility

    ENR = 2.5; % the energy of synthesized speech
     
    dirIn  = 'J:\ProbabilisticIntegrationModel\distortionWithScep0\1113\0-17\synDgv';
    dirOut = 'J:\ProbabilisticIntegrationModel\distortionWithScep0\1113\0-17\synScep';

    
    %% H2S
    dirlist = dir([dirIn '\*.dgv']);
    dirlength = length(dirlist);

    ii = 1;
    while ii < dirlength + 1
        % except ".", "..", "DS_Store"
        if length(dirlist(ii).name) > 3 
            filename = strrep(dirlist(ii).name, '.dgv', '');
            disp(filename)

            if ismac == 1
                fname_dgvs      = [dirIn '/' filename '.dgv'];
                fname_scep      = [dirOut '/' filename '.scep'];
                fname_scepLog   = [dirOut '/' filename '.txt'];
                fname_wav       = [dirOut '/' filename '.wav'];
            else
                fname_dgvs      = [dirIn '\' filename '.dgv'];
                fname_scep      = [dirOut '\' filename '.scep'];
                fname_scepLog   = [dirOut '\' filename '.txt'];
                fname_wav       = [dirOut '\' filename '.wav'];
            end

            input = loadBin(fname_dgvs, 'uchar', 26);
            input = input(5:22, :);

            %scep_ = spkmodel_vc2(input, objH2Smodel, objSpeakerModel, alpha, it, updatemethod, fname_scepLog);
            scep_ = spkmodel_vc2_(input, objS2Hmodel, objSpeakerModel, alpha, it, updatemethod, fname_scepLog);
            %scep_ = gmmvc(input, objH2Smodel);
            % scep_ holds all results at every step
            scep_ = scep_{1, it};
            %scep  = conv2scep(scep_, ENR);
            %scep  = smoothScep(scep, 19, 30);
            scep = scep_;
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
end