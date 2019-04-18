%
% 2011/09/21
% PCAgestures.m performs PCA to gestures 
%
% NOTES
% - dgv data is from $RESEARCH$/!gesture/transitionAmong16of28/dgvs (all)
%
% - sensor location
%  1: thumb roll sensor
%  2: thumb inner joint sensor
%  3: thumb outer joint sensor
%  4: thumb-index abduction sensor
%  5: index finger inner joint sensor
%  6: index finger middle joint sensor
%  7: middle finger inner joint sensor
%  8: middle finger middle joint sensor
%  9: middle-index abduction sensor
% 10: ring finger inner joint sensor
% 11: ring finger middle joint sensor
% 12: ring-middle abduction sensor
% 13: pinky finger inner joint sensor
% 14: pinky finger middle joint sensor
% 15: pinky-ring abduction sensor
% 16: palm arch sensor
% 17: wrist flexion sensor
% 18: wrist abduction sensor
%
% Aki Kunikoshi (D3)
% yemaozi88@gmail.com
%

clear all, fclose all, clc;

del = '\';
dirIn  = 'J:\!gesture\transitionAmong16of28\dgvs';
dirOut = 'J:\analysis\PCAwith16of28gestures'; 
EigenParamDir = 'J:\!gesture\transitionAmong16of28\EigenParam\all';

% output
outNum = 100;
outFreq = 15;


%% load Eigen parameters
[EVec, EVal, u] = loadEigenParam(EigenParamDir);
clear EigenParamDir


%% load data
A1 = loadBinDir([dirIn del num2str(1)], 'uchar', 26);
% all dataset
A2 = loadBinDir([dirIn del num2str(2)], 'uchar', 26);
A3 = loadBinDir([dirIn del num2str(3)], 'uchar', 26);
A = [A1, A2, A3];
clear A1 A2 A3 dirIn

% only 1 dataset
%A = A1;
%clear A1 dirIn

A = A(5:22, :);


%% perform PCA
Apca = PCA_Trans(A', EVec, u, 18)';

% mean
Hu = repmat(u', 1, outNum*outFreq);
Hu = conv2dgv(Hu, outFreq);

fHu = fopen([dirOut del 'Hu.dgv'], 'wb');
for ii = 1:size(Hu, 2)
    fwrite(fHu, Hu(:, ii), 'uchar');
end
fclose(fHu);
clear fHu

% get max/min
for ii = 1:18
    maxA(ii, 1)    = max(A(ii, :));
    minA(ii, 1)    = min(A(ii, :));
    maxApca(ii, 1) = max(Apca(ii, :));
    minApca(ii, 1) = min(Apca(ii, :));
end

% PCA max/min values -> vectors -> matrice
pc1maxVal = maxApca(1, 1);
pc1minVal = minApca(1, 1);
pc2maxVal = maxApca(2, 1);
pc2minVal = minApca(2, 1);

fil1 = repmat([0], 17, 1);
pc1maxVec_ = [pc1maxVal; fil1];
pc1minVec_ = [pc1minVal; fil1];
clear fil1 pc1maxVal pc1minVal

fil2 = repmat([0], 16, 1);
pc2maxVec_ = [0; pc2maxVal; fil2];
pc2minVec_ = [0; pc2minVal; fil2];
clear fil2 pc2maxVal pc2minVal

pc1maxVec = PCA_TransInv(pc1maxVec_', EVec, u)';
pc1minVec = PCA_TransInv(pc1minVec_', EVec, u)';
pc2maxVec = PCA_TransInv(pc2maxVec_', EVec, u)';
pc2minVec = PCA_TransInv(pc2minVec_', EVec, u)';
clear pc1maxVec_ pc1minVec_ 
clear pc2maxVec_ pc2minVec_

pc1maxMat = repmat(pc1maxVec, 1, outNum*outFreq);
pc1minMat = repmat(pc1minVec, 1, outNum*outFreq);
pc2maxMat = repmat(pc2maxVec, 1, outNum*outFreq);
pc2minMat = repmat(pc2minVec, 1, outNum*outFreq);
%clear pc1maxVec pc1minVec
%clear pc2maxVec pc2minVec

Hpc1max = conv2dgv(pc1maxMat, outFreq);
Hpc1min = conv2dgv(pc1minMat, outFreq);
Hpc2max = conv2dgv(pc2maxMat, outFreq);
Hpc2min = conv2dgv(pc2minMat, outFreq);
%clear pc1maxMat pc1minMat
%clear pc2maxMat pc2minMat

fPC1max = fopen([dirOut del 'Hpc1max.dgv'], 'wb');
for ii = 1:size(Hpc1max, 2)
    fwrite(fPC1max, Hpc1max(:, ii), 'uchar');
end
fPC1min = fopen([dirOut del 'Hpc1min.dgv'], 'wb');
for ii = 1:size(Hpc1min, 2)
    fwrite(fPC1min, Hpc1min(:, ii), 'uchar');
end
fPC2max = fopen([dirOut del 'Hpc2max.dgv'], 'wb');
for ii = 1:size(Hpc2max, 2)
    fwrite(fPC2max, Hpc2max(:, ii), 'uchar');
end
fPC2min = fopen([dirOut del 'Hpc2min.dgv'], 'wb');
for ii = 1:size(Hpc2min, 2)
    fwrite(fPC2min, Hpc2min(:, ii), 'uchar');
end

fclose(fPC1max);
fclose(fPC1min);
fclose(fPC2max);
fclose(fPC2min);
clear fPC1max fPC1min
clear fPC2max fPC2min