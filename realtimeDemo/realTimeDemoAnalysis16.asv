%
% 2011/09/13
% realTimeDemoAnalysis.m analysis paths in the gesture space
% generated data by combineDgvCMV.m is used
%
% LINK
% loadBinPCA.m
%
% NOTES
% joint vectors for GMM training:
%   vowels + consonants obtained by S2H
%
% AUTHOR
% Aki Kunikoshi (D3)
% yemaozi88@gmail.com
%

%% definition
clear all, fclose all, clc

dirH = 'K:\!gesture\transitionAmong16of28\dgvs\1';
firstSynDgv = 'K:\H2Swith16deg_0243\S2H\synDgv_withPCA\16of18';
firstSynDgv_consonants1 = 'K:\H2Swith16deg_0243\S2H\synDgv_withPCA\16of18';
firstSynDgv_consonants2 = 'K:\H2Swith16deg_0243\S2H\synDgv_withPCA\static_real';
EigenParamDirH = 'K:\!gesture\transitionAmong16of28\EigenParam16\all';

[EVecH, EValH, uH] = loadEigenParam(EigenParamDirH);
clear EigenParamDirH

% sample num = 0243
a = '28';
i = '02';
u = '01';
e = '09';
o = '25';

fAA  = loadBinPCA([firstSynDgv '\aa.dgv'], 'uchar', 26, EVecH, uH, 16);
fII  = loadBinPCA([firstSynDgv '\ii.dgv'], 'uchar', 26, EVecH, uH, 16);
fUU  = loadBinPCA([firstSynDgv '\uu.dgv'], 'uchar', 26, EVecH, uH, 16);
fEE  = loadBinPCA([firstSynDgv '\ee.dgv'], 'uchar', 26, EVecH, uH, 16);
fOO  = loadBinPCA([firstSynDgv '\oo.dgv'], 'uchar', 26, EVecH, uH, 16);

fNA1  = loadBinPCA([firstSynDgv_consonants1 '\na.dgv'], 'uchar', 26, EVecH, uH, 16);
fNI1  = loadBinPCA([firstSynDgv_consonants1 '\ni.dgv'], 'uchar', 26, EVecH, uH, 16);
fNU1  = loadBinPCA([firstSynDgv_consonants1 '\nu.dgv'], 'uchar', 26, EVecH, uH, 16);
fNE1  = loadBinPCA([firstSynDgv_consonants1 '\ne.dgv'], 'uchar', 26, EVecH, uH, 16);
fNO1  = loadBinPCA([firstSynDgv_consonants1 '\no.dgv'], 'uchar', 26, EVecH, uH, 16);

fNA2  = loadBinPCA([firstSynDgv_consonants2 '\na.dgv'], 'uchar', 26, EVecH, uH, 16);
fNI2  = loadBinPCA([firstSynDgv_consonants2 '\ni.dgv'], 'uchar', 26, EVecH, uH, 16);
fNU2  = loadBinPCA([firstSynDgv_consonants2 '\nu.dgv'], 'uchar', 26, EVecH, uH, 16);
fNE2  = loadBinPCA([firstSynDgv_consonants2 '\ne.dgv'], 'uchar', 26, EVecH, uH, 16);
fNO2  = loadBinPCA([firstSynDgv_consonants2 '\no.dgv'], 'uchar', 26, EVecH, uH, 16);


hold on    
    plot(fAA(:, 1), fAA(:, 2), 'm');
    plot(fII(:, 1), fII(:, 2), 'm');
    plot(fUU(:, 1), fUU(:, 2), 'm');
    plot(fEE(:, 1), fEE(:, 2), 'm');
    plot(fOO(:, 1), fOO(:, 2), 'm');
    
%     plot(fNA1(:, 1), fNA1(:, 2), 'r');
%     plot(fNI1(:, 1), fNI1(:, 2), 'm');
%     plot(fNU1(:, 1), fNU1(:, 2), 'g');
%     plot(fNE1(:, 1), fNE1(:, 2), 'b');
%     plot(fNO1(:, 1), fNO1(:, 2), 'k');

    plot(fNA2(:, 1), fNA2(:, 2), 'b');
    plot(fNI2(:, 1), fNI2(:, 2), 'm');
    plot(fNU2(:, 1), fNU2(:, 2), 'g');
    plot(fNE2(:, 1), fNE2(:, 2), 'b');
    plot(fNO2(:, 1), fNO2(:, 2), 'k');
hold off