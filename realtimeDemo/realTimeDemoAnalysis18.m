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
firstGeneratedDgvDir = 'K:\H2SwithDelta\0243\synDgv';
synDgvManualDir = 'K:\H2SwithDelta\0243\2ndTrain_byGeneratedData\extractedDgv_manual';
synDgvAutoDir = 'K:\H2SwithDelta\0243\2ndTrain_byGeneratedData\extractedDgv_auto';
generatedConsonantsDir = 'K:\H2SwithDelta\0243\2ndTrain_byGeneratedData\generatedConsonantsDgv_manual';
recordedConsonantsDir = 'K:\H2SwithDelta\0243\2ndTrain_byRecordedData\recordedData\dgvs';
EigenParamDirH = 'K:\!gesture\transitionAmong16of28\EigenParam18\all';


[EVecH, EValH, uH] = loadEigenParam(EigenParamDirH);
clear EigenParamDirH

% sample num = 0243
a = '28';
i = '02';
u = '01';
e = '09';
o = '25';


%% load vowel data
gAA = loadBinPCA([dirH '\' a '-' a '.dgvs'], 'uchar', 26, EVecH, uH, 18);
gAI = loadBinPCA([dirH '\' a '-' i '.dgvs'], 'uchar', 26, EVecH, uH, 18);
gAU = loadBinPCA([dirH '\' a '-' u '.dgvs'], 'uchar', 26, EVecH, uH, 18);
gAE = loadBinPCA([dirH '\' a '-' e '.dgvs'], 'uchar', 26, EVecH, uH, 18);
gAO = loadBinPCA([dirH '\' a '-' o '.dgvs'], 'uchar', 26, EVecH, uH, 18);

gIA = loadBinPCA([dirH '\' i '-' a '.dgvs'], 'uchar', 26, EVecH, uH, 18);
gII = loadBinPCA([dirH '\' i '-' i '.dgvs'], 'uchar', 26, EVecH, uH, 18);
gIU = loadBinPCA([dirH '\' i '-' u '.dgvs'], 'uchar', 26, EVecH, uH, 18);
gIE = loadBinPCA([dirH '\' i '-' e '.dgvs'], 'uchar', 26, EVecH, uH, 18);
gIO = loadBinPCA([dirH '\' i '-' o '.dgvs'], 'uchar', 26, EVecH, uH, 18);

gUA = loadBinPCA([dirH '\' u '-' a '.dgvs'], 'uchar', 26, EVecH, uH, 18);
gUI = loadBinPCA([dirH '\' u '-' i '.dgvs'], 'uchar', 26, EVecH, uH, 18);
gUU = loadBinPCA([dirH '\' u '-' u '.dgvs'], 'uchar', 26, EVecH, uH, 18);
gUE = loadBinPCA([dirH '\' u '-' e '.dgvs'], 'uchar', 26, EVecH, uH, 18);
gUO = loadBinPCA([dirH '\' u '-' o '.dgvs'], 'uchar', 26, EVecH, uH, 18);

gEA = loadBinPCA([dirH '\' e '-' a '.dgvs'], 'uchar', 26, EVecH, uH, 18);
gEI = loadBinPCA([dirH '\' e '-' i '.dgvs'], 'uchar', 26, EVecH, uH, 18);
gEU = loadBinPCA([dirH '\' e '-' u '.dgvs'], 'uchar', 26, EVecH, uH, 18);
gEE = loadBinPCA([dirH '\' e '-' e '.dgvs'], 'uchar', 26, EVecH, uH, 18);
gEO = loadBinPCA([dirH '\' e '-' o '.dgvs'], 'uchar', 26, EVecH, uH, 18);

gOA = loadBinPCA([dirH '\' o '-' a '.dgvs'], 'uchar', 26, EVecH, uH, 18);
gOI = loadBinPCA([dirH '\' o '-' i '.dgvs'], 'uchar', 26, EVecH, uH, 18);
gOU = loadBinPCA([dirH '\' o '-' u '.dgvs'], 'uchar', 26, EVecH, uH, 18);
gOE = loadBinPCA([dirH '\' o '-' e '.dgvs'], 'uchar', 26, EVecH, uH, 18);
gOO = loadBinPCA([dirH '\' o '-' o '.dgvs'], 'uchar', 26, EVecH, uH, 18);

clear a i u e o
clear dirH


%% load generated consonants data
gMA = loadBinPCA([generatedConsonantsDir '\ma.dgv'], 'float', 26, EVecH, uH, 18);
gMI = loadBinPCA([generatedConsonantsDir '\mi.dgv'], 'float', 26, EVecH, uH, 18);
gMU = loadBinPCA([generatedConsonantsDir '\mu.dgv'], 'float', 26, EVecH, uH, 18);
gME = loadBinPCA([generatedConsonantsDir '\me.dgv'], 'float', 26, EVecH, uH, 18);
gMO = loadBinPCA([generatedConsonantsDir '\mo.dgv'], 'float', 26, EVecH, uH, 18);

gNA = loadBinPCA([generatedConsonantsDir '\na.dgv'], 'float', 26, EVecH, uH, 18);
gNI = loadBinPCA([generatedConsonantsDir '\ni.dgv'], 'float', 26, EVecH, uH, 18);
gNU = loadBinPCA([generatedConsonantsDir '\nu.dgv'], 'float', 26, EVecH, uH, 18);
gNE = loadBinPCA([generatedConsonantsDir '\ne.dgv'], 'float', 26, EVecH, uH, 18);
gNO = loadBinPCA([generatedConsonantsDir '\no.dgv'], 'float', 26, EVecH, uH, 18);

gRA = loadBinPCA([generatedConsonantsDir '\ra.dgv'], 'float', 26, EVecH, uH, 18);
gRI = loadBinPCA([generatedConsonantsDir '\ri.dgv'], 'float', 26, EVecH, uH, 18);
gRU = loadBinPCA([generatedConsonantsDir '\ru.dgv'], 'float', 26, EVecH, uH, 18);
gRE = loadBinPCA([generatedConsonantsDir '\re.dgv'], 'float', 26, EVecH, uH, 18);
gRO = loadBinPCA([generatedConsonantsDir '\ro.dgv'], 'float', 26, EVecH, uH, 18);

clear generatedConsonantsDir


%% load recorded vowel data
rAA  = loadBinPCA([recordedConsonantsDir '\aa.dgvs'], 'uchar', 26, EVecH, uH, 18);
rAI  = loadBinPCA([recordedConsonantsDir '\ai.dgvs'], 'uchar', 26, EVecH, uH, 18);
rAU  = loadBinPCA([recordedConsonantsDir '\au.dgvs'], 'uchar', 26, EVecH, uH, 18);
rAE  = loadBinPCA([recordedConsonantsDir '\ae.dgvs'], 'uchar', 26, EVecH, uH, 18);
rAO  = loadBinPCA([recordedConsonantsDir '\ao.dgvs'], 'uchar', 26, EVecH, uH, 18);

rIA  = loadBinPCA([recordedConsonantsDir '\ia.dgvs'], 'uchar', 26, EVecH, uH, 18);
rII  = loadBinPCA([recordedConsonantsDir '\ii.dgvs'], 'uchar', 26, EVecH, uH, 18);
rIU  = loadBinPCA([recordedConsonantsDir '\iu.dgvs'], 'uchar', 26, EVecH, uH, 18);
rIE  = loadBinPCA([recordedConsonantsDir '\ie.dgvs'], 'uchar', 26, EVecH, uH, 18);
rIO  = loadBinPCA([recordedConsonantsDir '\io.dgvs'], 'uchar', 26, EVecH, uH, 18);

rUA  = loadBinPCA([recordedConsonantsDir '\ua.dgvs'], 'uchar', 26, EVecH, uH, 18);
rUI  = loadBinPCA([recordedConsonantsDir '\ui.dgvs'], 'uchar', 26, EVecH, uH, 18);
rUU  = loadBinPCA([recordedConsonantsDir '\uu.dgvs'], 'uchar', 26, EVecH, uH, 18);
rUE  = loadBinPCA([recordedConsonantsDir '\ue.dgvs'], 'uchar', 26, EVecH, uH, 18);
rUO  = loadBinPCA([recordedConsonantsDir '\uo.dgvs'], 'uchar', 26, EVecH, uH, 18);

rEA  = loadBinPCA([recordedConsonantsDir '\ea.dgvs'], 'uchar', 26, EVecH, uH, 18);
rEI  = loadBinPCA([recordedConsonantsDir '\ei.dgvs'], 'uchar', 26, EVecH, uH, 18);
rEU  = loadBinPCA([recordedConsonantsDir '\eu.dgvs'], 'uchar', 26, EVecH, uH, 18);
rEE  = loadBinPCA([recordedConsonantsDir '\ee.dgvs'], 'uchar', 26, EVecH, uH, 18);
rEO  = loadBinPCA([recordedConsonantsDir '\eo.dgvs'], 'uchar', 26, EVecH, uH, 18);

rOA  = loadBinPCA([recordedConsonantsDir '\oa.dgvs'], 'uchar', 26, EVecH, uH, 18);
rOI  = loadBinPCA([recordedConsonantsDir '\oi.dgvs'], 'uchar', 26, EVecH, uH, 18);
rOU  = loadBinPCA([recordedConsonantsDir '\ou.dgvs'], 'uchar', 26, EVecH, uH, 18);
rOE  = loadBinPCA([recordedConsonantsDir '\oe.dgvs'], 'uchar', 26, EVecH, uH, 18);
rOO  = loadBinPCA([recordedConsonantsDir '\oo.dgvs'], 'uchar', 26, EVecH, uH, 18);


%% load recorded consonants data
rMc  = loadBinPCA([recordedConsonantsDir '\m-c.dgvs'], 'uchar', 26, EVecH, uH, 18);
rNc  = loadBinPCA([recordedConsonantsDir '\n-c.dgvs'], 'uchar', 26, EVecH, uH, 18);
rRc1 = loadBinPCA([recordedConsonantsDir '\r-c1.dgvs'], 'uchar', 26, EVecH, uH, 18);
rRc2 = loadBinPCA([recordedConsonantsDir '\r-c2.dgvs'], 'uchar', 26, EVecH, uH, 18);
rRm  = loadBinPCA([recordedConsonantsDir '\r-m.dgvs'], 'uchar', 26, EVecH, uH, 18);

rMA  = loadBinPCA([recordedConsonantsDir '\ma.dgvs'], 'uchar', 26, EVecH, uH, 18);
rMI  = loadBinPCA([recordedConsonantsDir '\mi.dgvs'], 'uchar', 26, EVecH, uH, 18);
rMU  = loadBinPCA([recordedConsonantsDir '\mu.dgvs'], 'uchar', 26, EVecH, uH, 18);
rME  = loadBinPCA([recordedConsonantsDir '\me.dgvs'], 'uchar', 26, EVecH, uH, 18);
rMO  = loadBinPCA([recordedConsonantsDir '\mo.dgvs'], 'uchar', 26, EVecH, uH, 18);

rNA  = loadBinPCA([recordedConsonantsDir '\na.dgvs'], 'uchar', 26, EVecH, uH, 18);
rNI  = loadBinPCA([recordedConsonantsDir '\ni.dgvs'], 'uchar', 26, EVecH, uH, 18);
rNU  = loadBinPCA([recordedConsonantsDir '\nu.dgvs'], 'uchar', 26, EVecH, uH, 18);
rNE  = loadBinPCA([recordedConsonantsDir '\ne.dgvs'], 'uchar', 26, EVecH, uH, 18);
rNO  = loadBinPCA([recordedConsonantsDir '\no.dgvs'], 'uchar', 26, EVecH, uH, 18);

rRA  = loadBinPCA([recordedConsonantsDir '\ra.dgvs'], 'uchar', 26, EVecH, uH, 18);
rRI  = loadBinPCA([recordedConsonantsDir '\ri.dgvs'], 'uchar', 26, EVecH, uH, 18);
rRU  = loadBinPCA([recordedConsonantsDir '\ru.dgvs'], 'uchar', 26, EVecH, uH, 18);
rRE  = loadBinPCA([recordedConsonantsDir '\re.dgvs'], 'uchar', 26, EVecH, uH, 18);
rRO  = loadBinPCA([recordedConsonantsDir '\ro.dgvs'], 'uchar', 26, EVecH, uH, 18);

clear recordedConsonantsDir


%% from the 1st training
fMc  = loadBinPCA([synDgvManualDir '\m-c.dgv'], 'uchar', 26, EVecH, uH, 18);
fMm  = loadBinPCA([synDgvManualDir '\m-m.dgv'], 'uchar', 26, EVecH, uH, 18);
fNc  = loadBinPCA([synDgvManualDir '\n-c.dgv'], 'uchar', 26, EVecH, uH, 18);
fNm  = loadBinPCA([synDgvManualDir '\n-m.dgv'], 'uchar', 26, EVecH, uH, 18);
fRc1 = loadBinPCA([synDgvManualDir '\r-c1.dgv'], 'uchar', 26, EVecH, uH, 18);
fRc2 = loadBinPCA([synDgvManualDir '\r-c1.dgv'], 'uchar', 26, EVecH, uH, 18);

n = 1; % number of dataset
iiStr = num2str(n);    
fMAc = loadBinPCA([firstGeneratedDgvDir '\ma-c' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
fMIc = loadBinPCA([firstGeneratedDgvDir '\mi-c' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
fMUc = loadBinPCA([firstGeneratedDgvDir '\mu-c' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
fMEc = loadBinPCA([firstGeneratedDgvDir '\me-c' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
fMOc = loadBinPCA([firstGeneratedDgvDir '\mo-c' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);

fMAm = loadBinPCA([firstGeneratedDgvDir '\ma-m' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
fMIm = loadBinPCA([firstGeneratedDgvDir '\mi-m' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
fMUm = loadBinPCA([firstGeneratedDgvDir '\mu-m' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
fMEm = loadBinPCA([firstGeneratedDgvDir '\me-m' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
fMOm = loadBinPCA([firstGeneratedDgvDir '\mo-m' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);

fNAc = loadBinPCA([firstGeneratedDgvDir '\na-c' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
fNIc = loadBinPCA([firstGeneratedDgvDir '\ni-c' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
fNUc = loadBinPCA([firstGeneratedDgvDir '\nu-c' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
fNEc = loadBinPCA([firstGeneratedDgvDir '\ne-c' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
fNOc = loadBinPCA([firstGeneratedDgvDir '\no-c' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);

fNAm = loadBinPCA([firstGeneratedDgvDir '\na-m' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
fNIm = loadBinPCA([firstGeneratedDgvDir '\ni-m' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
fNUm = loadBinPCA([firstGeneratedDgvDir '\nu-m' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
fNEm = loadBinPCA([firstGeneratedDgvDir '\ne-m' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
fNOm = loadBinPCA([firstGeneratedDgvDir '\no-m' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);

fRAc = loadBinPCA([firstGeneratedDgvDir '\ra-c' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
fRIc = loadBinPCA([firstGeneratedDgvDir '\ri-c' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
fRUc = loadBinPCA([firstGeneratedDgvDir '\ru-c' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
fREc = loadBinPCA([firstGeneratedDgvDir '\re-c' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
fROc = loadBinPCA([firstGeneratedDgvDir '\ro-c' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);

fRAm = loadBinPCA([firstGeneratedDgvDir '\ra-m' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
fRIm = loadBinPCA([firstGeneratedDgvDir '\ri-m' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
fRUm = loadBinPCA([firstGeneratedDgvDir '\ru-m' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
fREm = loadBinPCA([firstGeneratedDgvDir '\re-m' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
fROm = loadBinPCA([firstGeneratedDgvDir '\ro-m' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);



%% load stable parts of generated dgv with 1st training
sMAc = loadBinPCA([synDgvAutoDir '\ma-c' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
sMIc = loadBinPCA([synDgvAutoDir '\mi-c' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
sMUc = loadBinPCA([synDgvAutoDir '\mu-c' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
sMEc = loadBinPCA([synDgvAutoDir '\me-c' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
sMOc = loadBinPCA([synDgvAutoDir '\mo-c' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);

sNAc = loadBinPCA([synDgvAutoDir '\na-c' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
sNIc = loadBinPCA([synDgvAutoDir '\ni-c' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
sNUc = loadBinPCA([synDgvAutoDir '\nu-c' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
sNEc = loadBinPCA([synDgvAutoDir '\ne-c' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
sNOc = loadBinPCA([synDgvAutoDir '\no-c' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);

sRAc = loadBinPCA([synDgvAutoDir '\ra-c' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
sRIc = loadBinPCA([synDgvAutoDir '\ri-c' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
sRUc = loadBinPCA([synDgvAutoDir '\ru-c' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
sREc = loadBinPCA([synDgvAutoDir '\re-c' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);
sROc = loadBinPCA([synDgvAutoDir '\ro-c' iiStr '.dgv'], 'uchar', 26, EVecH, uH, 18);

sMc  = loadBinPCA([synDgvAutoDir '\m-c.dgv'], 'uchar', 26, EVecH, uH, 18);
sNc  = loadBinPCA([synDgvAutoDir '\n-c.dgv'], 'uchar', 26, EVecH, uH, 18);
sRc  = loadBinPCA([synDgvAutoDir '\r-c.dgv'], 'uchar', 26, EVecH, uH, 18);


%% visualize
if 1
hold on
    % vowels
    plot(gAA(:, 1), gAA(:, 2), 'r.');
    plot(gII(:, 1), gII(:, 2), 'm.');
    plot(gUU(:, 1), gUU(:, 2), 'g.');
    plot(gEE(:, 1), gEE(:, 2), 'b.');
    plot(gOO(:, 1), gOO(:, 2), 'k.');

%     plot(gAI(:, 1), gAI(:, 2), 'm');
%     plot(gAU(:, 1), gAU(:, 2), 'g');
%     plot(gAE(:, 1), gAE(:, 2), 'b');
%     plot(gAO(:, 1), gAO(:, 2), 'k');

%     plot(gIA(:, 1), gIA(:, 2), 'r');
%     plot(gIU(:, 1), gIU(:, 2), 'g');
%     plot(gIE(:, 1), gIE(:, 2), 'b');
%     plot(gIO(:, 1), gIO(:, 2), 'k');

%     plot(gUA(:, 1), gUA(:, 2), 'r');
%     plot(gUI(:, 1), gUI(:, 2), 'm');
%     plot(gUE(:, 1), gUE(:, 2), 'b');
%     plot(gUO(:, 1), gUO(:, 2), 'k');

%     plot(gEA(:, 1), gEA(:, 2), 'r');
%     plot(gEI(:, 1), gEI(:, 2), 'm');
%     plot(gEU(:, 1), gEU(:, 2), 'g');
%     plot(gEO(:, 1), gEO(:, 2), 'k');

%     plot(gOA(:, 1), gOA(:, 2), 'r');
%     plot(gOI(:, 1), gOI(:, 2), 'm');
%     plot(gOU(:, 1), gOU(:, 2), 'g');
%     plot(gOE(:, 1), gOE(:, 2), 'b');

        
    % generated consonants
%     plot(gMA(:, 1), gMA(:, 2), 'b');
     plot(gNA(:, 1), gNA(:, 2), 'r');
%     plot(gRA(:, 1), gRA(:, 2), 'm');
% 
%     plot(gMI(:, 1), gMI(:, 2), 'b');
%     plot(gNI(:, 1), gNI(:, 2), 'g');
%     plot(gRI(:, 1), gRI(:, 2), 'm');
% 
%     plot(gMU(:, 1), gMU(:, 2), 'b');
%     plot(gNU(:, 1), gNU(:, 2), 'g');
%     plot(gRU(:, 1), gRU(:, 2), 'm');
% 
%     plot(gME(:, 1), gME(:, 2), 'b+');
%     plot(gNE(:, 1), gNE(:, 2), 'g+');
%     plot(gRE(:, 1), gRE(:, 2), 'm+');
% 
%     plot(gMO(:, 1), gMO(:, 2), 'b');
%     plot(gNO(:, 1), gNO(:, 2), 'g');
%     plot(gRO(:, 1), gRO(:, 2), 'm');


    % recorded vowels
%     plot(rAA(:, 1), rAA(:, 2), 'r.');
%     plot(rII(:, 1), rII(:, 2), 'm.');
%     plot(rUU(:, 1), rUU(:, 2), 'g.');
%     plot(rEE(:, 1), rEE(:, 2), 'b.');
%     plot(rOO(:, 1), rOO(:, 2), 'k.');

%     plot(rAI(:, 1), rAI(:, 2), 'm');
%     plot(rAU(:, 1), rAU(:, 2), 'g');
%     plot(rAE(:, 1), rAE(:, 2), 'b');
%     plot(rAO(:, 1), rAO(:, 2), 'k');
% 
%     plot(rIA(:, 1), rIA(:, 2), 'r');
%     plot(rIU(:, 1), rIU(:, 2), 'g');
%     plot(rIE(:, 1), rIE(:, 2), 'b');
%     plot(rIO(:, 1), rIO(:, 2), 'k');
% 
%     plot(rUA(:, 1), rUA(:, 2), 'r');
%     plot(rUI(:, 1), rUI(:, 2), 'm');
%     plot(rUE(:, 1), rUE(:, 2), 'b');
%     plot(rUO(:, 1), rUO(:, 2), 'k');
% 
%     plot(rEA(:, 1), rEA(:, 2), 'r');
%     plot(rEI(:, 1), rEI(:, 2), 'm');
%     plot(rEU(:, 1), rEU(:, 2), 'g');
%     plot(rEO(:, 1), rEO(:, 2), 'k');
% 
%     plot(rOA(:, 1), rOA(:, 2), 'r');
%     plot(rOI(:, 1), rOI(:, 2), 'm');
%     plot(rOU(:, 1), rOU(:, 2), 'g');
%     plot(rOE(:, 1), rOE(:, 2), 'b');
    
    % recorded consonants
%     plot(rMc(:, 1), rMc(:, 2), 'r+');
%     plot(rNc(:, 1), rNc(:, 2), 'b+');
%     plot(rRc1(:, 1), rRc1(:, 2), 'm+');
%     plot(rRc2(:, 1), rRc2(:, 2), 'm+');
%     plot(rRm(:, 1), rRm(:, 2), 'k+');    
    
%      plot(rMA(:, 1), rMA(:, 2), 'r');
      plot(rNA(:, 1), rNA(:, 2), 'b');
%      plot(rRA(:, 1), rRA(:, 2), 'm');
% 
%     plot(rMI(:, 1), rMI(:, 2), 'r');
%     plot(rNI(:, 1), rNI(:, 2), 'b');
%     plot(rRI(:, 1), rRI(:, 2), 'm');
% 
%     plot(rMU(:, 1), rMU(:, 2), 'r');
%     plot(rNU(:, 1), rNU(:, 2), 'b');
%     plot(rRU(:, 1), rRU(:, 2), 'm');
% 
%     plot(rME(:, 1), rME(:, 2), 'r');
%     plot(rNE(:, 1), rNE(:, 2), 'b');
%     plot(rRE(:, 1), rRE(:, 2), 'm');
% 
%     plot(rMO(:, 1), rMO(:, 2), 'r');
%     plot(rNO(:, 1), rNO(:, 2), 'b');
%     plot(rRO(:, 1), rRO(:, 2), 'm');

    % from thet 1st training
%     plot(sMAc(:, 1), sMAc(:, 2), 'r');
%     plot(sMIc(:, 1), sMIc(:, 2), 'm');
%     plot(sMUc(:, 1), sMUc(:, 2), 'g');
%     plot(sMEc(:, 1), sMEc(:, 2), 'b');
%     plot(sMOc(:, 1), sMOc(:, 2), 'k');

%     plot(sNAc(:, 1), sNAc(:, 2), 'r');
%     plot(sNIc(:, 1), sNIc(:, 2), 'm');
%     plot(sNUc(:, 1), sNUc(:, 2), 'g');
%     plot(sNEc(:, 1), sNEc(:, 2), 'b');
%     plot(sNOc(:, 1), sNOc(:, 2), 'k');

%     plot(sRc(:, 1), sRc(:, 2), 'c');
%     
%     plot(sRAc(:, 1), sRAc(:, 2), 'c');
%     plot(sRIc(:, 1), sRIc(:, 2), 'm');
%     plot(sRUc(:, 1), sRUc(:, 2), 'g');
%     plot(sREc(:, 1), sREc(:, 2), 'b');
%     plot(sROc(:, 1), sROc(:, 2), 'k');

%     plot(sMc(:, 1), sMc(:, 2), 'r');
%     plot(sNc(:, 1), sNc(:, 2), 'b');
%     plot(sRc(:, 1), sRc(:, 2), 'm');
    
%     plot(fNc(:, 1), fNc(:, 2), 'b');
%     plot(fNm(:, 1), fNm(:, 2), 'b');
%     plot(fRc1(:, 1), fRc1(:, 2), 'm');
%     plot(fRc2(:, 1), fRc2(:, 2), 'm');

%     plot(fMAc(:, 1), fMAc(:, 2), 'r');
%     plot(fMIc(:, 1), fMIc(:, 2), 'm');
%     plot(fMUc(:, 1), fMUc(:, 2), 'g');
%     plot(fMEc(:, 1), fMEc(:, 2), 'b');
%     plot(fMOc(:, 1), fMOc(:, 2), 'k');
 
%     plot(fMAm(:, 1), fMAm(:, 2), 'r');
%     plot(fMIm(:, 1), fMIm(:, 2), 'm');
%     plot(fMUm(:, 1), fMUm(:, 2), 'g');
%     plot(fMEm(:, 1), fMEm(:, 2), 'b');
%     plot(fMOm(:, 1), fMOm(:, 2), 'k');

     plot(fNAc(:, 1), fNAc(:, 2), 'm');
%     plot(fNIc(:, 1), fNIc(:, 2), 'm');
%     plot(fNUc(:, 1), fNUc(:, 2), 'g');
%     plot(fNEc(:, 1), fNEc(:, 2), 'b');
%     plot(fNOc(:, 1), fNOc(:, 2), 'k');

%     for ii = 1:2
%        fNIm(:, ii) = medfilt1(fNIm(:, ii), 5);
%     end
     plot(fNAm(:, 1), fNAm(:, 2), 'm');
%     plot(fNIm(:, 1), fNIm(:, 2), 'm');
%     plot(fNUm(:, 1), fNUm(:, 2), 'g');
%     plot(fNEm(:, 1), fNEm(:, 2), 'b');
%     plot(fNOm(:, 1), fNOm(:, 2), 'r');

%     plot(fRAm(:, 1), fRAm(:, 2), 'r');
%     plot(fRIm(:, 1), fRIm(:, 2), 'm');
%     plot(fRUm(:, 1), fRUm(:, 2), 'g');
%     plot(fREm(:, 1), fREm(:, 2), 'b');
%     plot(fROm(:, 1), fROm(:, 2), 'k');
hold off
end

if 0
%hold on
    %plot3(gAA(:, 1), gAA(:, 2), gAA(:, 3), 'r.');
    %plot3(gII(:, 1), gII(:, 2), gII(:, 3), 'm.');
    %plot3(gUU(:, 1), gUU(:, 2), gUU(:, 3), 'g.');
    %plot3(gEE(:, 1), gEE(:, 2), gEE(:, 3), 'b.');
    %plot3(gOO(:, 1), gOO(:, 2), gOO(:, 3), 'k.');
    
    plot3(fRAm(:, 1), fRAm(:, 2), fRAm(:, 3), 'k.');
    
%hold off
end