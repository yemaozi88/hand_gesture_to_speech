%
% 2011/08/25
% outputMatlabGMM.m outputs Matlab GMM object for realtime demonstration on C
%
% NOTES:
% - this code is based on ConvertMatlabGMM.m, TrainConvertModel.m, GMM_Map_Model.m
% - this code assumes dimensions of source/target spaces are the same
% - this code should be functionized??
%   function outputMatlabGMM(obj)
%   INPUT
%   obj: matlab GMM object gotten by gmdistribution.m
%
% LINK
% ConvertMatlabGMM.m, GMM_Map_Model.m
%
% AUTHOR
% Aki Kunikoshi (D3)
% yemaozi88@gmail.com
%

% test
clear all, fclose all, clc;
load('J:\H2Swith16deg_0243\realTimeSystem\joint\H2Smodel_mix8_obj.mat');
dirOut = 'J:\realtimeDemo\v6\gmm-param';

[CovArr, MeanArr, WArr, gNum] = ConvertMatlabGMM(obj);

dim  = obj.NDimensions;
dX = dim/2;
if floor(dX)*2 ~= dim
    error('the number of dimension of source and target should be the same!');
end

[yMeanArr, xMeanArr, xCovArr, TinvxCovArr] = GMM_Map_Model(MeanArr, CovArr, dX);

invxCovArr = zeros(gNum, dX, dX);
detxCovArr = zeros(gNum, 1);
for k = 1:gNum
    invxCovArr(k, :, :) = inv(squeeze(xCovArr(k, :, :)));
    detxCovArr(k, 1)    = det(squeeze(xCovArr(k, :, :)));
end

fout_WArr = fopen([dirOut '\WArr.txt'], 'wt');
fout_xMeanArr = fopen([dirOut '\xMeanArr.txt'], 'wt');
fout_yMeanArr = fopen([dirOut '\yMeanArr.txt'], 'wt');
fout_xCovArr = fopen([dirOut '\xCovArr.txt'], 'wt');
fout_TinvxCovArr = fopen([dirOut '\TinvxCovArr.txt'], 'wt');
fout_invxCovArr = fopen([dirOut '\invxCovArr.txt'], 'wt');
fout_detxCovArr = fopen([dirOut '\detxCovArr.txt'], 'wt');

fprintf(fout_WArr, '%f\n', WArr);
fprintf(fout_xMeanArr, '%f\n', xMeanArr);
fprintf(fout_yMeanArr, '%f\n', yMeanArr);
fprintf(fout_xCovArr, '%f\n', xCovArr);
fprintf(fout_TinvxCovArr, '%f\n', TinvxCovArr);
fprintf(fout_invxCovArr, '%f\n', invxCovArr);
fprintf(fout_detxCovArr, '%e\n', detxCovArr);

fclose(fout_WArr);
fclose(fout_xMeanArr);
fclose(fout_yMeanArr);
fclose(fout_xCovArr);
fclose(fout_TinvxCovArr);
fclose(fout_invxCovArr);
fclose(fout_detxCovArr);
clear fout_WArr fout_xMeanArr fout_yMeanArr
clear fout_xCovArr fout_TinvxCovArr fout_invxCovArr fout_detxCovArr