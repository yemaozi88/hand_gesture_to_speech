%
% 2011/09/29
% simple version of Hand-to-Speech model
%
% LINKS
% loadBin, loadBinDir, makeJoint, trainGMM, gmmvc, spkmodel_vc2
% makeGestureCombinationList
%
% NOTE
% this program is based on H2Smodel.m
%
% AUTHOR
% Aki Kunikoshi (D3)
% yemaozi88@gmail.com
%

clear all, fclose all, clc;

%% definition
%dirIn = 'J:\H2Swith16deg_0243\S2H\synDgv_noPCA\16of18\vowels_1of8';
dirIn = 'J:\H2Swith16deg_0243\!speech\synDgvCheck_1of8\consonants';
dirOut = 'J:\H2Swith16deg_0243\realTimeSystem\synDgv2_1of8_withDelta_withPCA';
EigenParamDir = 'J:\!gesture\transitionAmong16of28\EigenParam16\1';

% speaker model
%load('J:\H2Swith16deg_0243\!speech\spkModel_diag_1of8\spkModel_mix512_obj.mat');
load('J:\H2Swith16deg_0243\!speech\spkModel_withDelta_diag_1of8\spkModel_mix512_obj');
objSpeakerModel = obj;

% joint model
%load('J:\H2Swith16deg_0243\joint\H2Smodel_full_noPCA\H2Smodel_mix8_obj');
%load('J:\H2Swith16deg_0243\joint\H2Smodel_full_withPCA\H2Smodel_mix8_obj');
%load('J:\H2Swith16deg_0243\joint\H2Smodel_full_withDelta_noPCA\H2Smodel_mix16_obj');
%load('J:\H2Swith16deg_0243\joint\H2Smodel_full_withDelta_withPCA\H2Smodel_mix16_obj');
load('J:\H2Swith16deg_0243\realTimeSystem\S2Hmodel2_full_withDelta_withPCA\S2Hmodel_mix16_obj.mat');

% probabilistic integration model
alpha = 0.6; % weight factor for speaker model
it = 3; % number or iteration
updatemethod = 1; %0- using target responsibility 1- using joint responsibility    
FRAME_SHIFT = 8; % assumed frame shift length [ms]

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


%% conversion: speech files corresponds to vowels
%vowel = ['a', 'i', 'u', 'e', 'o'];
% for nV1 = 1:5
%     for nV2 = 1:5
%         mora = sprintf('%s%s', vowel(nV1), vowel(nV2));
%         disp(mora)
% 
%         filenameH_ = sprintf('filenameH = [''%s%s'' %s ''-'' %s ''.dgvs''];', dirH, del, vowel(nV1), vowel(nV2));
%         eval(filenameH_);
%         %disp(filenameH)
%         clear filenameH_
% 
% %        mora = 'ai2';
% %        filenameH = 'K:\!gesture\transitionAmong16of28\dgvs\2\28-02.dgvs';
% 
%         input = loadBin(filenameH, 'uchar', 26);
%         input = input(5:22, :); % 18 x frameNum
%         input = input(1:16, :); % 16 x frameNum
% 
%         % PCA
%         input = PCA_Trans(input', EVec, Eu, 16);
%         input = input';
% 
%         scep  = gmmvc(input, obj);
%         clear input
% 
%         
%         % write out scep and wav files
%         
%         frameScep  = size(scep, 2);
%         fname_scep = [dirOut del mora '.scep'];
%         fname_wav  = [dirOut del mora '.wav'];
% 
%         fod = fopen(fname_scep, 'wb');
%         j = 1;
%         while j < frameScep + 1
%             fwrite(fod, scep(:, j), 'float');
%             j = j + 1;
%         end
%         fclose(fod);
%         
%         scep2wav(scep, fname_wav, 'suzuki');
% 
%         clear fname_scep fname_wav
%     end % nV2
% end % nV1

%% conversion: all files in a directory
dirlist = dir([dirIn del '*.dgv']);
dirlength = length(dirlist);

% for interpolation
index = [0, 1];
interpStep = 0:1:FRAME_SHIFT-1;
interpStep = interpStep./FRAME_SHIFT-1;

for ii = 1:dirlength
    % except ".", "..", "DS_Store"
    if length(dirlist(ii).name) > 3
        filename = strrep(dirlist(ii).name, '.dgv', '');
        filename = 'ai';
        disp(filename)

        finFea  = [dirIn del filename '.dgv'];
        foutScep = [dirOut del filename '.scep'];
        foutWav = [dirOut del filename '.wav'];
        logfile = [dirOut del filename '.log'];

        feaIn = loadBin(finFea, 'uchar', 26);
        feaIn = feaIn(5:22, :);
        feaIn = feaIn(1:16, :);
        feaIn_ = feaIn;

        % interpolation
        dimFeaIn = size(feaIn_, 1);
        frameFeaIn_ = size(feaIn_, 2);
        frameFeaIn  = 8*(frameFeaIn_-1);
        feaIn = zeros(dimFeaIn, frameFeaIn);
        clear dimFeaIn
        for jj = 1:frameFeaIn_-1;
            jj = 28;
            gap = [feaIn_(:, jj), feaIn_(:, jj+1)];
            interpGap = spline(index, gap, interpStep);
            feaIn(:, (jj-1)*8+1:(jj-1)*8+8) = interpGap;
        end
        clear feaIn_ gap
        
        feaIn = adddelta(feaIn);
                
        % perform PCA
        feaIn_ = feaIn';
        feaIn_ = PCA_Trans(feaIn_, EVec, Eu);
        feaIn = feaIn_';
        
        %feaIn = adddelta(feaIn);

%        scep_ = gmmvc(feaIn, obj);
%        scep_ = spkmodel_vc2(feaIn, obj, objSpeakerModel, alpha, it, updatemethod, logfile);
%         %dgv_ = gmmvc_delta(feaIn, obj, it);
%        scep_ = spkmodel_vc_delta(feaIn, obj, objSpeakerModel, alpha, it, updatemethod);
 
       scep_ = scep_{1, it};

        % interpolation
%         dimScep = size(scep_, 1);
%         frameScep_ = size(scep_, 2);
%         frameScep  = 8*(frameScep_-1);
%         scep = zeros(dimScep, frameScep);
%         clear dimScep
%         for jj = 1:frameScep_-1;
%             gap = [scep_(:, jj), scep_(:, jj+1)];
%             interpGap = spline(index, gap, interpStep);
%             scep(:, (jj-1)*8+1:(jj-1)*8+8) = interpGap;
%         end
%         %clear scep_ gap

        % output scep
        fod = fopen(foutScep, 'wb');
        for jj = 1:frameScep
            fwrite(fod, scep(:, jj), 'float');
        end
        fclose(fod);
     
        scep2wav(scep, foutWav, 'suzuki');
    end % if
end % ii