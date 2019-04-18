% 2011/03/03
% train GMM for S2H-H2S combined system
%
% REMARKS
% this program is used for the quasi-optimal design
% it gives parameters for Qiao's program
% synthesis part is combinedModelWithPCA4demo.m
%
% AUTHOR
% Aki Kunikoshi (D2)
% yemaozi88@gmail.com
%

clear all, clc, fclose('all');

%% definition
dirJointVowels     = 'I:\ProbabilisticIntegrationModel\distortionWithEnergy\reducedJoint';
%dirJointConsonant_ = 'J:\ProbabilisticIntegrationModel\distortion\5840\joint\consonant';


%% load data
V = loadBinDir(dirJointVowels, 'float', 36);

% C_c = [];
% C_m = [];
% for nn = 1:10
%     if ismac == 1
%         dirJointConsonant = [dirJointConsonant_ '/' num2str(nn)];
%     else
%         dirJointConsonant = [dirJointConsonant_ '\' num2str(nn)];
%     end
%     dirlist_c = dir([dirJointConsonant '/*-c.joint']);
%     dirlist_m = dir([dirJointConsonant '/*-m.joint']);
%     dirlength = length(dirlist_c);
% 
%     for ii = 1:dirlength
%         if ismac == 1
%             fname_c = [dirJointConsonant '/' dirlist_c(ii).name];
%             fname_m = [dirJointConsonant '/' dirlist_m(ii).name];
%         else
%             fname_c = [dirJointConsonant '\' dirlist_c(ii).name];
%             fname_m = [dirJointConsonant '\' dirlist_m(ii).name];
%         end
%         %disp(fname)
%         tmp_c = loadBin(fname_c, 'float', 36);
%         tmp_m = loadBin(fname_m, 'float', 36);
%         C_c = [C_c, tmp_c];
%         C_m = [C_m, tmp_m];
%     end
%     clear dirlist_c dirlist_m dirlength fname_c fname_m
%     clear tmp_c tmp_m ii
% end

%Y = [V, C_c, C_m];
%clear dirJointVowels dirJointConsonant dirJointConsonant_ nn
%clear V C_c C_m

Y = V;
clear V;

% data
%X1 = Y(1:18, :)';
%Y1 = Y(19:36, :)';
%clear Y;


%% train GMM
% INPUT
% dirIn: the directory where joint vectors are put in
% dirOut: the directory where GMM info will be put in
% MIX: the GMM mixture number
% SNS: the number of input vectors
%
%[ModelArr, obj] = TrainConvertModel(X1, Y1, para, method);
%
% method=-1: train linear model ; method=0: GMM with source vectors; 
% method = 1: GMM with joint vector;  method = 3  train all
%
% ModelArr has following parameters:
%(correspondence of parameters of ModelArr and INTERSPEECH2009 paper)
%             dX: dimensions of source vectors
%             dY: dimensions of target vectors
%       yMeanArr: \mu^B mean of target vector in mapping function (GMM), gNum x dY    
%       xMeanArr: \mu^A mean of source vector in mapping function (GMM), gNUm x dX
%        xCovArr: \Sigma^{AA} covariance of source vector in mapping function, gNum x dX x dY
%(GMM)
%    TinvxCovArr: \Sigma^{BA}\Sigma^{AA}^{-1}, gNum x dX x dY
%           gNum: GMM mixture number
%           WArr: weights of GMM, 1 x gNum
%     invxCovArr: \Sigma^{AA}^{-1}, gNum x dX x dX
%     detxCovArr: [\Sigma^{AA}], gNUm x dX

%for gNum = [2]
% for gNum = [2, 4, 8, 16, 32, 64, 128, 256]
%     disp(gNum)
%     tic
%     %gNum  = 2;
%     dirOut = ['J:\ProbabilisticIntegrationModel\distortion\5840\joint\matrix' num2str(gNum)];
% 
%     % parameters for conversion
%     para.gNum       = gNum;    %number of mixtures
%     para.MaxIter    = 500;   %maximum training iterations
%     para.TolFun     = 1e-05;
%     para.RegCov     = 1e-04; %regulization of covariance matrix
%     method          = 1;     % trained with joint vectors
% 
%     Model = TrainConvertModel(X1, Y1, para, method);
%     save(['J:\ProbabilisticIntegrationModel\distortion\5840\joint\matrix' num2str(gNum) '\Model'], 'Model');
%     %clear X1;
%     %clear Y1;
%     %load('I:\ProbabilisticIntegrationModel\distortion\5840\joint\matrix4\Model');
% 
%     invxCovArr = zeros(Model.gNum, Model.dX, Model.dX);
%     detxCovArr = zeros(Model.gNum, 1);
%     for q = 1:Model.gNum
%         invxCovArr(q, :, :) = inv(squeeze(Model.xCovArr(q, :, :)));
%         detxCovArr(q, 1)    = det(squeeze(Model.xCovArr(q, :, :)));
%     end
% 
% 
%     %% write out matrix data
%     fout_WArr = fopen([dirOut '\WArr.txt'], 'wt');
%     fout_xMeanArr = fopen([dirOut '\xMeanArr.txt'], 'wt');
%     fout_yMeanArr = fopen([dirOut '\yMeanArr.txt'], 'wt');
%     fout_xCovArr = fopen([dirOut '\xCovArr.txt'], 'wt');
%     fout_TinvxCovArr = fopen([dirOut '\TinvxCovArr.txt'], 'wt');
%     fout_invxCovArr = fopen([dirOut '\invxCovArr.txt'], 'wt');
%     fout_detxCovArr = fopen([dirOut '\detxCovArr.txt'], 'wt');
% 
%     fprintf(fout_WArr, '%f\n', Model.WArr);
%     fprintf(fout_xMeanArr, '%f\n', Model.xMeanArr);
%     fprintf(fout_yMeanArr, '%f\n', Model.yMeanArr);
%     fprintf(fout_xCovArr, '%f\n', Model.xCovArr);
%     fprintf(fout_TinvxCovArr, '%f\n', Model.TinvxCovArr);
%     fprintf(fout_invxCovArr, '%f\n', invxCovArr);
%     fprintf(fout_detxCovArr, '%e\n', detxCovArr);
% 
%     fclose(fout_WArr);
%     fclose(fout_xMeanArr);
%     fclose(fout_yMeanArr);
%     fclose(fout_xCovArr);
%     fclose(fout_TinvxCovArr);
%     fclose(fout_invxCovArr);
%     fclose(fout_detxCovArr);
%     toc
% end % gNum