%
% 2011/02/01
% S2H-H2S combined system
%
% LINK
% makeGestureCombinationList
%
% REMARKS
% this program is for the directories which made by S2Hmodel.m
%
% HISTORY
% 2011/02/03 add vowel part
%
% AUTHOR
% Aki Kunikoshi (D2)
% yemaozi88@gmail.com
%

%clc, clear all, fclose('all');


%% definition
% gesture/speaker model
dirInModel = 'C:\research\ProbabilisticIntegrationModel\S2H-H2S_distortion';
GgNum = 64;

% gesture and speech for convert model
dirH = 'C:\research\gesture\transitionAmong16of28\dgvs';
dirS = 'C:\research\speech\Japanese5vowels\isolated\suzuki\16k\scep18';
%CgNum = 8;

% the directory for the output files
dirOut = 'C:\research\ProbabilisticIntegrationModel\S2H';

% input speech
dirConsonant_ = 'C:\research\speech\JapaneseConsonants';
consonant = ['b', 'm', 'n', 'p', 'r'];
vowel = ['a', 'i', 'u', 'e', 'o'];
nSmax = 1; % the number of data set

% log for all
logfile = 'C:\research\ProbabilisticIntegrationModel\S2H-H2S_distortion\cepstralDistortionS.csv';

% Saito's method
alpha = 1; % weight factor for speaker model
it = 3; % number or iteration
updatemethod = 1; %0- using target responsibility 1- using joint responsibility

ENR = 2.5; % the energy of synthesized speech
SAMPLING_FREQ = 1; % assumed sampling frequency of DataGlove


%% choose 5 gestures among 16 gestures
ges = [1, 2, 4, 7, 8, 9, 11, 13, 14, 15, 16, 21, 22, 25, 27, 28];
[dgvMean, gestureCombinationList] = make16gestureCombinationList(dirH);
P = gestureCombinationList;
Pnum = size(P, 1);  % the number of all permutations

flog = fopen(logfile, 'wt');

for nP = [5907:6000, 7001:Pnum];  % the number of the permutation
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
disp(['Gesture Design: ' num2str(nP)]);
disp(['a:' a ' i:' i ' u:' u ' e:' e ' o:' o]);

    
%% directory processing
    if ismac == 1
        dirOutSub      = [dirOut '/' a '-' i '-' u '-' e '-' o];
        dirOutSynDgv   = [dirOutSub '/synDgv'];
        dirOutSynScep  = [dirOutSub '/synScep'];
    else
        dirOutSub      = [dirOut '\' a '-' i '-' u '-' e '-' o];
        dirOutSynDgv   = [dirOutSub '\synDgv'];
        dirOutSynScep  = [dirOutSub '\synScep'];
    end    
    mkdir([dirOutSynDgv '_2']);
    mkdir(dirOutSynScep);
    % the length of dgv files made by S2Mmodel.m is half of the input scep
    % files. To avoid confusion, synDgv_2 is made and previous files are copied into it. 
    movefile([dirOutSynDgv '\*'], [dirOutSynDgv '_2']);
 

%% load gesture model and convert model
    if ismac == 1
        load([dirInModel '/objGestureModel-' num2str(GgNum)]);
        load([dirInModel '/objSpeakerModel-' num2str(GgNum)]);        
        load([dirOutSub '/objS2Hmodel']);
    else
        load([dirInModel '\objGestureModel-' num2str(GgNum)]);
        load([dirInModel '\objSpeakerModel-' num2str(GgNum)]);        
        load([dirOutSub '\objS2Hmodel']);
    end


%% conversion
    CD = zeros(10, nSmax); % Cepstral Distortion for a, i, u, e, o, na, ni, nu, ne, no
    for nS = 1:nSmax; % the number of speech data set
%disp(['--- dataset ' num2str(nS) ' ---'])
        for nC = [0, 3]
            for nV = 1:5
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
%disp(['--- ' mora num2str(nS) ' ---'])

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
                clear input dgv_
%disp('S2H completed');

            % H2S
                dgv = dgv(5:22, :); % remove energy

                scep_ = spkmodel_vc2_(dgv, objS2Hmodel, objSpeakerModel, alpha, it, updatemethod, fname_scepLog);
                % scep_ holds all results at every step
                scep_ = scep_{1, it};
                scep  = conv2scep(scep_, ENR);
                scep = smoothScep(scep, 19, 30);
                clear dgv scep_

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
                if nC == 0 % vowels
                    CD(nV, nS) = NMmean;
                else
                    CD(nV+5, nS) = NMmean;
                end
%disp(['cepstral distortion: ' num2str(NMmean)]);
disp([mora ': ' num2str(NMmean)]);
            end % nV
        end %nC
    end % nS
    %CDmean = mean(CD')'; % 10 x 1
    CDmean = CD;
    CDmax = size(CDmean, 1);
    
    fprintf(flog, '%d,%s,%s,%s,%s,%s,', nP, a, i, u, e, o);
    for ii = 1:CDmax
        fprintf(flog, '%f,', CDmean(ii, 1));
    end
    fprintf(flog, '\n');
toc
end % nP

fclose(flog);