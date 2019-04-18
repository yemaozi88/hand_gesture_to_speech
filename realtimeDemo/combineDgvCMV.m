%
% 2011/08/27
% combineDgvCMV.m makes ideal dgv data with consonant, transition and vowel data
%
% NOTE
% gestures of consonants and transition parts are obtained with realTimeDemo.m
% and checkGestures.m
%
% AUTHOR
% Aki Kunikoshi (D3)
% yemaozi88@gmail.com
%

clear all, fclose all, clc;

%% test
% original data
% % sample num = 0243
% a = '28';
% i = '02';
% u = '01';
% e = '09';
% o = '25';
dirVowels = 'F:\transitionAmong16of28\dgvs\1';
dirSynDgvManual = 'F:\H2SwithDelta\2ndTrain_byGeneratedData\synDgvManual';

% generated data
dirGeneratedDgv = 'F:\H2SwithDelta\2ndTrain_byGeneratedData\generatedConsonantsDgv';

TYPE = 1; % 0:m/n, 1:r

% load data
if TYPE == 0
    C = loadBin([dirSynDgvManual '\n-c.dgv'], 'uchar', 26);
elseif TYPE == 1
    C1 = loadBin([dirSynDgvManual '\r-c1.dgv'], 'uchar', 26);
    C2 = loadBin([dirSynDgvManual '\r-c2.dgv'], 'uchar', 26);
end    
M = loadBin([dirSynDgvManual '\m-m.dgv'], 'uchar', 26); % n-m, r-m are almost the same to m-m
V = loadBin([dirVowels '\25-25.dgvs'], 'uchar', 26);
% ouput
fnGeneratedDgv = [dirGeneratedDgv '\ro.dgv'];


% number of frames
if TYPE == 0
    nC = 100;
elseif TYPE == 1
    nC1 = 30;
    nC2 = 60;
end
nM = 10;
nV = 70;


%% cut out data
if TYPE == 0
    C = C(:, 11:10+nC);
elseif TYPE == 1
    C1 = C1(:, 11:10+nC1);
    C2 = C2(:, 11:10+nC2-1);
end
M = M(:, 11:10+nM-2);
V = V(:, 11:10+nV);


%% interpolation
index = [0, 1];
interpStep = 0:0.1:1;

% C1toC2
if TYPE == 1
    C1last  = C1(:, nC1);
    C2first = C2(:, 1);
    gap = [C1last, C2first];
    C1toC2 = spline(index, gap, interpStep);
    clear C1lastt C2first
end

% C2M
if TYPE == 0
    Clast = C(:, nC);
elseif TYPE == 1
    Clast = C2(:, nC2-1);
end
Mfirst = M(:, 1);
gap = [Clast, Mfirst];
C2M = spline(index, gap, interpStep);
clear Clast Mfirst

% M2V
Mlast  = M(:, nM-2);
Vfirst = V(:, 1);
gap = [Mlast, Vfirst];
M2V = spline(index, gap, interpStep);
clear Mlast Vfirst

clear gap index interpStep


%% write out
if TYPE == 0
    generatedDgv = [C, C2M, M, M2V, V];
    clear C C2M M M2V V
elseif TYPE == 1
    generatedDgv = [C1, C1toC2, C2M, M, M2V, V];
    clear C1 C1toC2 C2 C2M M M2V V
end

frameDgv = size(generatedDgv, 2);
x = repmat(15, 1, frameDgv);
generatedDgv(1, :) = x;
clear x

fout = fopen(fnGeneratedDgv, 'wb');
for ii = 1:frameDgv
    fwrite(fout, generatedDgv(:, ii), 'float');
end
fclose(fout);