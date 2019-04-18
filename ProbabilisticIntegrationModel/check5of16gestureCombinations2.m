%
% 2011/01/13
% check selected 3 directories made by S2Hmodel.m whether they have impossible
% gestures to perform
%
% LINK
% makeGestureCombinationList
%
% NOTES
% - this program is based on S2Hmodel.m and check5of16gestureCombinations.m
% - check5of16gestures.m is for 8192 gesture combinations and only checked
% moras which have /n/ while check5of16gestureCombinations.m is for 3
% gesture combinations and checked any consonants
%
% HISTORY
% 2011/01/13 modified so that it can used for every consonant
%
% AUTHOR
% Aki Kunikoshi (D2)
% yemaozi88@gmail.com
%

clc, clear all, fclose('all');


%% definition
% gesture and speech for convert model
dirH = 'C:\research\gesture\transitionAmong16of28\dgvs';

% input speech
consonant = ['b', 'm', 'n', 'p', 'r'];
vowel = ['a', 'i', 'u', 'e', 'o'];

% the directory for the output files
dirOut = 'C:\research\ProbabilisticIntegrationModel\5of16gestureCombinations_ERRV20_ERRC20_thres5';
dirDefault = 'C:\research\gesture\transitionAmong16of28\default';

% the pass file list which made by check5of16gestureCombinations.m
passListFile = [dirOut '\passList_ERRV20_ERRC20_thres5'];


ERRV = 20;   % error for acceptable range of vowel gestures
ERRC = 20;   % error for acceptable range of consonant gestures
thres = 5;   % threshold for error rate of consonant gestures


%% choose 5 gestures among 16 gestures
ges = [1, 2, 4, 7, 8, 9, 11, 13, 14, 15, 16, 21, 22, 25, 27, 28];
[dgvMean, gestureCombinationList] = make16gestureCombinationList(dirH);
P = gestureCombinationList;
Pnum = size(P, 1);  % the number of all permutations

load(passListFile);
for nP = passList';  % the number of the permutation

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
        dirOutSub   = [dirOut '/' a '-' i '-' u '-' e '-' o];
        dirSynDgv   = [dirOutSub '/synDgv'];
        %dirOutJoint = [dirOutSub '/joint'];
    else
        dirOutSub   = [dirOut '\' a '-' i '-' u '-' e '-' o];
        dirSynDgv   = [dirOutSub '\synDgv'];
        %dirOutJoint = [dirOutSub '\joint'];
    end
    

%% check gestures
    [offset, dgv2deg] = loadHand3Ddefault(dirDefault);

% log
if ismac == 1
    fname_log = [dirOutSub '/gestureCheck2_ERRV' num2str(ERRV) '_ERRC' num2str(ERRC) '_thres' num2str(thres) '.txt'];
else
    fname_log = [dirOutSub '\gestureCheck2_ERRV' num2str(ERRV) '_ERRC' num2str(ERRC) '_thres' num2str(thres) '.txt'];
end

flog  = fopen(fname_log, 'wt');
%clear fname_log

fprintf(flog, '< Gesture Check >\n');
fprintf(flog, 'nP - %d\n', nP);
fprintf(flog, 'Error for acceptable range of vowel gestures : %d\n', ERRV);
fprintf(flog, 'Error for acceptable range of consonant gestures : %d\n', ERRC);
fprintf(flog, 'Threshold for error rate of consonant gestures : %d\n\n', thres);


%% load gesture data
    % vowels
    
    dirSynDgvAA = [dirSynDgv '\aa.dgv'];
    dirSynDgvII = [dirSynDgv '\ii.dgv'];
    dirSynDgvUU = [dirSynDgv '\uu.dgv'];
    dirSynDgvEE = [dirSynDgv '\ee.dgv'];
    dirSynDgvOO = [dirSynDgv '\oo.dgv'];
    
    AA = loadBin(dirSynDgvAA, 'uchar', 26);
    II = loadBin(dirSynDgvII, 'uchar', 26);
    UU = loadBin(dirSynDgvUU, 'uchar', 26);
    EE = loadBin(dirSynDgvEE, 'uchar', 26);
    OO = loadBin(dirSynDgvOO, 'uchar', 26);

    [degAA, errAA, fmaxAA] = checkDgvMovableRange(AA, offset, dgv2deg, ERRV);
    [degII, errII, fmaxII] = checkDgvMovableRange(II, offset, dgv2deg, ERRV);
    [degUU, errUU, fmaxUU] = checkDgvMovableRange(UU, offset, dgv2deg, ERRV);
    [degEE, errEE, fmaxEE] = checkDgvMovableRange(EE, offset, dgv2deg, ERRV);
    [degOO, errOO, fmaxOO] = checkDgvMovableRange(OO, offset, dgv2deg, ERRV);


% log

fprintf(flog, 'Error rate for vowels [%%]\n');
fprintf(flog, 'aa - %d [frames] :\t', fmaxAA);
for ii = 1:5
    fprintf(flog, '%6.2f\t', errAA(1, ii));
end
fprintf(flog, '\n');

fprintf(flog, 'ii - %d [frames] :\t', fmaxII);
for ii = 1:5
    fprintf(flog, '%6.2f\t', errII(1, ii));
end
fprintf(flog, '\n');

fprintf(flog, 'uu - %d [frames] :\t', fmaxUU);
for ii = 1:5
    fprintf(flog, '%6.2f\t', errUU(1, ii));
end
fprintf(flog, '\n');

fprintf(flog, 'ee - %d [frames] :\t', fmaxEE);
for ii = 1:5
    fprintf(flog, '%6.2f\t', errEE(1, ii));
end
fprintf(flog, '\n');

fprintf(flog, 'oo - %d [frames] :\t', fmaxOO);
for ii = 1:5
    fprintf(flog, '%6.2f\t', errOO(1, ii));
end
fprintf(flog, '\n\n');

    errV = [errAA; errII; errUU; errEE; errOO];
    fmaxV = [fmaxAA; fmaxII; fmaxUU; fmaxEE; fmaxOO];
    
    clear degAA degII degUU degEE degOO
    clear errAA errII errUU errEE errOO
    clear fmaxAA fmaxII fmaxUU fmaxEE fmaxOO


%% load gesture data
    % consonant
% log
fprintf(flog, 'Error rate for consonants [%%]\n');
    for nC = 1:5 % for consonant
        for nV = 1:5
            mora = sprintf('%s%s', consonant(nC), vowel(nV));
            disp([num2str(nP) '-' mora]);
% log
fprintf(flog, '%s :\t', mora);
            if ismac == 1
                filename = [dirSynDgv '/' mora '.dgv'];
            else
                filename = [dirSynDgv '\' mora '.dgv'];
            end
            
            CC = loadBin(filename, 'uchar', 26);
            [degCC, errCC, fmaxCC] = checkDgvMovableRange(CC, offset, dgv2deg, ERRV);
% log
for ii = 1:5
    fprintf(flog, '%6.2f\t', errCC(1, ii));
end
fprintf(flog, '\n');
            
        end % nV
    end % nC
    clear mora filename input
    clear degCC errCC fmaxCC
    
   fclose(flog);
end

clear a i u e o
clear dirSynDgvAA dirSynDgvII dirSynDgvUU dirSynDgvEE dirSynDgvOO
clear dirOut dirOutSub dirSynDgv dirOutJoint dirDefault