%
% 2011/01/05
% check 8192 directories made by S2Hmodel.m
%
% LINK
% makeGestureCombinationList
%
% NOTE
% - this program is based on S2Hmodel.m
%
% HISTORY
% 2011/07/21 modified to check files made by f0generation.m
% 2011/02/18 checked whether combinedModel.m was correctly performed
% 2011/01/05 checked whether they have impossible gesture to perform
%
% AUTHOR
% Aki Kunikoshi (D2)
% yemaozi88@gmail.com
%

clc, clear all, fclose('all');


%% definition
% gesture and speech for convert model
%dirH = 'C:\research\_gesture\transitionAmong16of28\dgvs';
dirH = 'J:\!gesture\transitionAmong16of28\dgvs\1';

% input speech
%consonant = 'n';
%vowel = ['a', 'i', 'u', 'e', 'o'];

dirOut      = 'J:\f0generation\8190combinations_withPCA\0001-2685_2751-4000_8000-8192';
dirDefault  = 'J:\!gesture\transitionAmong16of28\default';

ERRV  = 20;   % error for acceptable range of vowel gestures
ERRC  = 30;   % error for acceptable range of consonant gestures
thres = 10;   % threshold for error rate of consonant gestures


%% choose 5 gestures among 16 gestures
ges = [1, 2, 4, 7, 8, 9, 11, 13, 14, 15, 16, 21, 22, 25, 27, 28];
[dgvMean, gestureCombinationList] = make16gestureCombinationList(dirH);
P = gestureCombinationList;

% load dgv data default values
[offset, dgv2deg] = loadHand3Ddefault(dirDefault);

% % for the files listed in errList
% load('C:\research\ProbabilisticIntegrationModel\errList2');
% errList2 = errList;
% clear errList;

Pnum = size(P, 1);  % the number of all permutations
checkList = [];     % checkList for the existence of the file
% skipList = [];      % list of the files which has not been calculated
% errList = [];       % list of the files which has errors in
passList = [];      % list of the files which pass the gesture check

errNumV = 25;
errNumC = 25;

%for nP = [1:Pnum];  % the number of the permutation
for nP = [1:2685,2751:4000,8000:8190]
    checkList_ = [];
    checkList = [checkList; checkList_];
    %disp(nP)

%     a = P(nP, 1);
%     if a < 10
%         a = num2str(a);
%         a = ['0' a];
%     else
%         a = num2str(a);
%     end
% 
%     i = P(nP, 2);
%     if i < 10
%         i = num2str(i);
%         i = ['0' i];
%     else
%         i = num2str(i);
%     end
% 
%     u = P(nP, 3);
%     if u < 10
%         u = num2str(u);
%         u = ['0' u];
%     else
%         u = num2str(u);
%     end
% 
%     e = P(nP, 4);
%     if e < 10
%         e = num2str(e);
%         e = ['0' e];
%     else
%         e = num2str(e);
%     end
% 
%     o = P(nP, 5);
%     if o < 10
%         o = num2str(o);
%         o = ['0' o];
%     else
%         o = num2str(o);
%     end
    
    
    %% nP: num 2 str
    if nP < 10
        nPstr = ['000' num2str(nP)];
    elseif nP < 100
        nPstr = ['00' num2str(nP)];
    elseif nP < 1000
        nPstr = ['0' num2str(nP)];
    else
        nPstr = num2str(nP);
    end
    disp(nPstr)
    
    
%% directory processing
    if ismac == 1
        %dirOutSub       = [dirOut '/' a '-' i '-' u '-' e '-' o];
        %dirOutSubNew     = [dirOut '/' nPstr];
        dirOutSub = [dirOut '/' nPstr];
        dirSynDgv = [dirOutSub '/synDgv'];
        %dirOutJoint    = [dirOutSub '/joint'];
    else
        %dirOutSub   = [dirOut '\' a '-' i '-' u '-' e '-' o];
        %dirOutSubNew    = [dirOut '\' nPstr];
        dirOutSub = [dirOut '\' nPstr];
        dirSynDgv = [dirOutSub '\synDgv'];
        %dirOutJoint = [dirOutSub '\joint'];
    end
    
    %disp(nP)
    %% check the existence of the directory    
    if exist(dirSynDgv)==0
       checkList = [checkList, nP]; % make list which haven't calculated yet
    end

    %% move files
%     mkdir(dirOutSubNew);
%     movefile([dirOutSub '\*'], [dirOutSubNew]);
%     rmdir(dirOutSub, 's');

    
%% load dgv files
    % vowels
    dirSynDgvAA = [dirSynDgv '\aa.dgv'];
    dirSynDgvII = [dirSynDgv '\ii.dgv'];
    dirSynDgvUU = [dirSynDgv '\uu.dgv'];
    dirSynDgvEE = [dirSynDgv '\ee.dgv'];
    dirSynDgvOO = [dirSynDgv '\oo.dgv'];
    % consonants
    dirSynDgvNA = [dirSynDgv '\na.dgv'];
%     dirSynDgvNI = [dirSynDgv '\ni.dgv'];
%     dirSynDgvNU = [dirSynDgv '\nu.dgv'];
%     dirSynDgvNE = [dirSynDgv '\ne.dgv'];
%     dirSynDgvNO = [dirSynDgv '\no.dgv'];
    dirSynDgvMA = [dirSynDgv '\ma.dgv'];
    dirSynDgvRA = [dirSynDgv '\ra.dgv'];
    dirSynDgvBA = [dirSynDgv '\ba.dgv'];
    dirSynDgvPA = [dirSynDgv '\pa.dgv'];
 
%    %checkList_ = [checkList_, nP];
   
    % when data is wrong, the mean of it would be like errMean
    errMean = repmat(0, 25, 1);
    errMean = [2; errMean];

    % 0: no such file
    % 1: pass
    % 2: wrong data


%% check existance of vowels
    
    if exist(dirSynDgvAA)
        AA = loadBin(dirSynDgvAA, 'uchar', 26);
        if mean(AA')'== errMean
            checkList_ = [checkList_, 2];
        else
            checkList_ = [checkList_, 1];
        end
    else
        checkList_ = [checkList_, 0];
    end

    if exist(dirSynDgvII)
        II = loadBin(dirSynDgvII, 'uchar', 26);
        if mean(II')'== errMean
            checkList_ = [checkList_, 2];
        else
            checkList_ = [checkList_, 1];
        end
    else
        checkList_ = [checkList_, 0];
    end

    if exist(dirSynDgvUU)
        UU = loadBin(dirSynDgvUU, 'uchar', 26);
        if mean(UU')'== errMean
            checkList_ = [checkList_, 2];
        else
            checkList_ = [checkList_, 1];
        end
    else
        checkList_ = [checkList_, 0];
    end

    if exist(dirSynDgvEE)
        EE = loadBin(dirSynDgvEE, 'uchar', 26);
        if mean(EE')'== errMean
            checkList_ = [checkList_, 2];
        else
            checkList_ = [checkList_, 1];
        end
    else
        checkList_ = [checkList_, 0];
    end

    if exist(dirSynDgvOO)
        OO = loadBin(dirSynDgvOO, 'uchar', 26);
        if mean(OO')'== errMean
            checkList_ = [checkList_, 2];
        else
            checkList_ = [checkList_, 1];
        end
    else
        checkList_ = [checkList_, 0];
    end

   
    % consonants
%     
%     if exist(dirSynDgvNA)
%         NA = loadBin(dirSynDgvNA, 'uchar', 26);
%         if mean(NA')'== errMean
%             checkList_ = [checkList_, 2];
%         else
%             checkList_ = [checkList_, 1];
%         end
%     else
%         checkList_ = [checkList_, 0];
%     end
%     
%     if exist(dirSynDgvNI)
%         NI = loadBin(dirSynDgvNI, 'uchar', 26);
%         if mean(NI')'== errMean
%             checkList_ = [checkList_, 2];
%         else
%             checkList_ = [checkList_, 1];
%         end
%     else
%         checkList_ = [checkList_, 0];
%     end
% 
%     if exist(dirSynDgvNU)
%         NU = loadBin(dirSynDgvNU, 'uchar', 26);
%         if mean(NU')'== errMean
%             checkList_ = [checkList_, 2];
%         else
%             checkList_ = [checkList_, 1];
%         end
%     else
%         checkList_ = [checkList_, 0];
%     end
%     
%     if exist(dirSynDgvNE)
%         NE = loadBin(dirSynDgvNE, 'uchar', 26);
%         if mean(NE')'== errMean
%             checkList_ = [checkList_, 2];
%         else
%             checkList_ = [checkList_, 1];
%         end
%     else
%         checkList_ = [checkList_, 0];
%     end
% 
%     if exist(dirSynDgvNO)
%         NO = loadBin(dirSynDgvNO, 'uchar', 26);
%         if mean(NO')'== errMean
%             checkList_ = [checkList_, 2];
%         else
%             checkList_ = [checkList_, 1];
%         end
%     else
%         checkList_ = [checkList_, 0];
%     end
NA = loadBin(dirSynDgvNA, 'uchar', 26);
MA = loadBin(dirSynDgvMA, 'uchar', 26);
RA = loadBin(dirSynDgvRA, 'uchar', 26);
BA = loadBin(dirSynDgvBA, 'uchar', 26);
PA = loadBin(dirSynDgvPA, 'uchar', 26);

    
%% check error and skip
%     if exist(dirSynDgvNO)
%         NO = loadBin(dirSynDgvNO, 'uchar', 26);
%         if mean(NO')'== errMean
%             checkList_ = [checkList_, 2];
%         else
%             checkList_ = [checkList_, 1];
%         end
%     else
%         checkList_ = [checkList_, 0];
%     end
% 
%     if max(checkList_) == min(checkList_) && checkList_(1, 1) == 0
%         skipList = [skipList; nP];    
%     end
% %     if max(checkList_) == min(checkList_) && checkList_(1, 1) == 1
% %         rmdir(dirOutJoint, 's');
% %         movefile(dirOutSub, 'C:\research\ProbabilisticIntegrationModel\ok');
% %     end
%     if max(checkList_) == min(checkList_) && checkList_(1, 1) == 2
%         errList = [errList; nP];    
%     end
% 
%     checkList = [checkList; nP, checkList_];    


%% check gestures

% log
if ismac == 1
    fname_log = [dirOutSub '/gestureCheck_ERRV' num2str(ERRV) '_ERRC' num2str(ERRC) '_thres' num2str(thres) '.txt'];
else
    fname_log = [dirOutSub '\gestureCheck_ERRV' num2str(ERRV) '_ERRC' num2str(ERRC) '_thres' num2str(thres) '.txt'];
end

flog  = fopen(fname_log, 'wt');
%clear fname_log
 
fprintf(flog, '< Gesture Check >\n');
%fprintf(flog, 'List No: nP - %d\t', nP);
fprintf(flog, 'nP - %d\n', nP);
fprintf(flog, 'Error for acceptable range of vowel gestures : %d\n', ERRV);
fprintf(flog, 'Error for acceptable range of consonant gestures : %d\n', ERRC);
fprintf(flog, 'Threshold for error rate of consonant gestures : %d\n\n', thres);


    % vowels

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


    % consonants
     
    [degNA, errNA, fmaxNA] = checkDgvMovableRange(NA, offset, dgv2deg, ERRC);
%     [degNI, errNI, fmaxNI] = checkDgvMovableRange(NI, offset, dgv2deg, ERRC);
%     [degNU, errNU, fmaxNU] = checkDgvMovableRange(NU, offset, dgv2deg, ERRC);
%     [degNE, errNE, fmaxNE] = checkDgvMovableRange(NE, offset, dgv2deg, ERRC);
%     [degNO, errNO, fmaxNO] = checkDgvMovableRange(NO, offset, dgv2deg, ERRC);
    [degMA, errMA, fmaxMA] = checkDgvMovableRange(MA, offset, dgv2deg, ERRC);
    [degRA, errRA, fmaxRA] = checkDgvMovableRange(RA, offset, dgv2deg, ERRC);
    [degBA, errBA, fmaxBA] = checkDgvMovableRange(BA, offset, dgv2deg, ERRC);
    [degPA, errPA, fmaxPA] = checkDgvMovableRange(PA, offset, dgv2deg, ERRC);

% log
 
fprintf(flog, 'Error rate for consonants [%%]\n');
fprintf(flog, 'na - %4d [frames] :\t', fmaxNA);
for ii = 1:5
    fprintf(flog, '%6.2f\t', errNA(1, ii));
end
fprintf(flog, '\n');
% 
% fprintf(flog, 'ni - %4d [frames] :\t', fmaxNI);
% for ii = 1:5
%     fprintf(flog, '%6.2f\t', errNI(1, ii));
% end
% fprintf(flog, '\n');
% 
% fprintf(flog, 'nu - %4d [frames] :\t', fmaxNU);
% for ii = 1:5
%     fprintf(flog, '%6.2f\t', errNU(1, ii));
% end
% fprintf(flog, '\n');
% 
% fprintf(flog, 'ne - %4d [frames] :\t', fmaxNE);
% for ii = 1:5
%     fprintf(flog, '%6.2f\t', errNE(1, ii));
% end
% fprintf(flog, '\n');
% 
% fprintf(flog, 'no - %4d [frames] :\t', fmaxNO);
% for ii = 1:5
%     fprintf(flog, '%6.2f\t', errNO(1, ii));
% end
% fprintf(flog, '\n');

fprintf(flog, 'ma - %4d [frames] :\t', fmaxMA);
for ii = 1:5
    fprintf(flog, '%6.2f\t', errMA(1, ii));
end
fprintf(flog, '\n');

fprintf(flog, 'ra - %4d [frames] :\t', fmaxRA);
for ii = 1:5
    fprintf(flog, '%6.2f\t', errRA(1, ii));
end
fprintf(flog, '\n');

fprintf(flog, 'ba - %4d [frames] :\t', fmaxBA);
for ii = 1:5
    fprintf(flog, '%6.2f\t', errBA(1, ii));
end
fprintf(flog, '\n');

fprintf(flog, 'pa - %4d [frames] :\t', fmaxPA);
for ii = 1:5
    fprintf(flog, '%6.2f\t', errPA(1, ii));
end
fprintf(flog, '\n');


    %if errV == 0 % closed data should make possible gestures
        
        if max(errNA) < thres
            if max(errMA) < thres
                if max(errRA) < thres
                    if max(errBA) < thres
                        if max(errPA) < thres
                            passList = [passList; nP];
                        end
                    end
                end
            end
        end
        
%         errC = [errNA; errNI; errNU; errNE; errNO];
%         fmaxC = [fmaxNA; fmaxNI; fmaxNU; fmaxNE; fmaxNO];
        errC = [errNA; errMA; errRA; errBA; errPA];
        fmaxC = [fmaxNA; fmaxMA; fmaxRA; fmaxBA; fmaxPA];

%         clear degNA degNI degNU degNE degNO
%         clear errNA errNI errNU errNE errNO
%         clear fmaxNA fmaxNI fmaxNU fmaxNE fmaxNO
        clear degNA degMA degRA degBA degPA
        clear errNA errMA errRA errBA errPA
        clear fmaxNA fmaxMA fmaxRA fmaxBA fmaxPA
    %end % errV

    
%% count the number of impossible-to-form parts    
    tmpV = find(errV ~= 0);
    errNumV_ = length(tmpV);
    
    tmpC = find(errC >= 10);
    errNumC_ = length(tmpC);
    
    %disp([num2str(nP) ':' num2str(errNumV_) ', ' num2str(errNumC_)])
    
    if errNumV_ <= errNumV && errNumC_ <= errNumC
        errNumV = errNumV_;
        errNumC = errNumC_;
        nPNum   = nP;
    end
    
    fclose(flog);
end % nP
disp(['the best one is ' num2str(nPNum)])
disp(['the number of errors in vowels: ' num2str(errNumV)])
disp(['the number of errors in consonant: ' num2str(errNumC)])

clear checkList_ errMean
clear a i u e o
clear dirSynDgvAA dirSynDgvII dirSynDgvUU dirSynDgvEE dirSynDgvOO
% clear dirSynDgvNA dirSynDgvNI dirSynDgvNU dirSynDgvNE dirSynDgvNO
clear dirSynDgvNA dirSynDgvMA dirSynDgvRA dirSynDgvBA dirSynDgvPA
clear dirOut dirOutSub dirSynDgv dirOutJoint dirDefault