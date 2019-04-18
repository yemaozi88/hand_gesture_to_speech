%
% 2011/09/28
% simple version of Speech to Hand model
%
% LINKS
% loadBin, loadBinDir, makeJoint, trainGMM, gmmvc, spkmodel_vc2
% makeGestureCombinationList
%
% NOTE
% this program is based on S2Hmodel.m
%
% HISTORY
% 2011/11/01 added delta part
%
% AUTHOR
% Aki Kunikoshi (D3)
% yemaozi88@gmail.com
%

clear all, fclose all, clc;

%% definition
%for nn = 1:10
%    nnStr = num2str(nn);

%dirIn = ['J:\!speech\JapaneseConsonants\n-cmv\scep16\' nnStr];
%dirIn = ['J:\!speech\JapaneseConsonants\n\suzuki\16k\scep16\' nnStr];
%dirOut = ['J:\H2Swith16deg_0243\realTimeSystem\n\' nnStr];
dirIn = 'J:\H2Swith16deg_0243\!speech\synDgvCheck_1of8\consonants';
dirOut = 'J:\H2Swith16deg_0243\realTimeSystem\synDgv2_1of8_withDelta_withPCA';
EigenParamDir = 'J:\!gesture\transitionAmong16of28\EigenParam16\1';

% gesture model
%load('J:\H2Swith16deg_0243\!gesture\gestureModel_diag_noPCA\transitionAmong16of28_1\gestureModel_mix128_obj');
%load('J:\H2Swith16deg_0243\!gesture\gestureModel_diag_withPCA\transitionAmong16of28_1\gestureModel_mix64_obj');
%load('J:\H2Swith16deg_0243\!gesture\gestureModelwithDelta_diag_noPCA\transitionAmong16of28_1\gestureModel_mix128_obj.mat');
load('J:\H2Swith16deg_0243\!gesture\gestureModelwithDelta_diag_withPCA\gestureModel_mix128_obj');
objGestureModel = obj;

% joint model
%load('J:\H2Swith16deg_0243\joint\S2Hmodel_full_noPCA\S2Hmodel_mix8_obj');
%load('J:\H2Swith16deg_0243\joint\S2Hmodel_full_withPCA\jointModel_mix8_obj');
%load('J:\H2Swith16deg_0243\joint\S2Hmodel_full_withDelta_noPCA\S2Hmodel_mix16_obj.mat');
%load('J:\H2Swith16deg_0243\joint\S2Hmodel_full_withDelta_withPCA\S2Hmodel_mix16_obj');
load('J:\H2Swith16deg_0243\realTimeSystem\S2Hmodel2_full_withDelta_withPCA\S2Hmodel_mix16_obj.mat');
%obj = objS2Hmodel;

% probabilistic integration model
alpha = 1; % weight factor for speaker model
it = 5; % number or iteration
updatemethod = 1; %0- using target responsibility 1- using joint responsibility    
SAMPLING_FREQ = 8; % assumed sampling frequency of DataGlove

% check estimated gestures
dirDgvDefault = 'J:\!gesture\transitionAmong16of28\default';
ERR = 30; % acceptable error range[deg]
thres = 10; % error / all frames

% vowel = ['a', 'i', 'u', 'e', 'o'];
del = '\';

% sample num = 0243
% a = '28';
% i = '02';
% u = '01';
% e = '09';
% o = '25';


%% load Eigen parameters
[EVec, EVal, Eu] = loadEigenParam(EigenParamDir);
clear EigenParamDir


%% error log 
% [offset, dgv2deg] = loadHand3Ddefault(dirDgvDefault);
% clear dirDgvDefault
% 
% % log file for impossible-to-form range
% fname_errlog = [dirOut del 'impossible-to-form.log'];
% ferrlog  = fopen(fname_errlog, 'wt');
% clear fname_errlog
% fprintf(ferrlog, 'Acceptable error range of consonant gestures : %d\n', ERR);


%% directory processing
dirlist = dir([dirIn del '*.*']);
dirlength = length(dirlist);

totalErrNum = 0;
% for alpha = -2:0.1:2
%     alphaStr = num2str(alpha);
%     disp(['-----' alphaStr '-----'])
for ii = 1:dirlength
    % except ".", "..", "DS_Store"
    if length(dirlist(ii).name) > 3        
        filename = strrep(dirlist(ii).name, '.scep', '');
        %filename = 'ai';
        disp(filename)
        filename = 'ma';
        
        finFea  = [dirIn del filename '.scep'];
        foutDgv = [dirOut del filename '.dgv'];
        logfile = [dirOut del filename '.log'];
%         foutDgv = [dirOut del filename '_alpha' alphaStr '.dgv'];
%         logfile = [dirOut del filename '_alpha' alphaStr '.log'];
        
%         feaIn = loadBin(finFea, 'float', 19);
%         feaIn = feaIn(1:18, :);
        feaIn = loadBin(finFea, 'float', 17);
        feaIn = feaIn(1:16, :);
        feaIn = adddelta(feaIn);
        
        %dgv_ = gmmvc(feaIn, obj);
        %dgv_ = spkmodel_vc2(feaIn, obj, objGestureModel, alpha, it, updatemethod, logfile);
        %dgv_ = gmmvc_delta(feaIn, obj, it);
        dgv_ = spkmodel_vc_delta(feaIn, obj, objGestureModel, alpha, it, updatemethod);

        dgv_ = dgv_{1, it};
        dgv_ = dgv_(1:16, :);

        % perform invPCA
        dgv_ = dgv_';
        dgv_ = PCA_TransInv(dgv_, EVec, Eu);
        dgv_ = dgv_';
        
        fmax = size(dgv_, 2);       
        tmp  = repmat([170; 75], 1, fmax);
        dgv_ = [dgv_; tmp];
        clear fmax tmp
        dgv  = conv2dgv(dgv_, SAMPLING_FREQ);
        %clear dgv_
 
%         % check movable range
%         [deg, err, fmax] = checkDgvMovableRange(dgv, offset, dgv2deg, ERR);
%         fprintf(ferrlog, '%s\t%6.2f\t%6.2f\t%6.2f\t%6.2f\t%6.2f\n', ... 
%             filename, err(1), err(2), err(3), err(4), err(5));
%          
%         errNum = 0;
%         for ii = 1:5
%             if err(ii) > thres
%                 errNum = errNum + 1;
%             end
%         end
%         totalErrNum = totalErrNum + errNum;
%         clear deg err fmax errNum
        
        % output synDgv
        frameDgv = size(dgv, 2);
        fout = fopen(foutDgv, 'wb');
        for ii = 1:frameDgv-2
            fwrite(fout, dgv(:, ii), 'uchar');
        end
        fclose(fout);
        
    end
end % ii
%end % nn

%end % alpha
% fclose(ferrlog);
% clear ferrlog