%function extractStableFramesM(fin, fout, EVecH, uH)
% extractStableFramesM(fin, fout, EVecH, uH)
% extracts stable frames of consonant parts
%
% INPUT
% fin: input dgv files, dim x frameNum
% fout: extracted stable parts
% EVecH: Eigen vectors
% uH: mean
%
% LINKS
% loadBin.m, loadBinPCA.m
%
% NOTE
% EVecH and uH are obtained by loadEigenParam.m
%
% AUTHOR
% Aki Kunikoshi (D3)
% yemaozi88@gmail.com
%

%% test
clear all, fclose all, clc;
EigenParamDirH = 'J:\!gesture\transitionAmong16of28\EigenParam\all';
[EVecH, EValH, uH] = loadEigenParam(EigenParamDirH);
clear EigenParamDirH EValH

filename = 'ni-m1';
fin  = ['J:\realtimeDemo\v6\0243\synDgv\' filename '.dgv'];
fout = ['J:\realtimeDemo\v6\0243\2ndTrain_byGeneratedData\extractedDgv_auto\' filename '.dgv'];
% thres_norm  = 3.0;
% thres_delta = 60;

fNc = 'J:\realtimeDemo\v6\0243\2ndTrain_byGeneratedData\extractedDgv_auto\n-c.dgv';
Nc = loadBinPCA(fNc, 'uchar', 26, EVecH, uH, 18)';
clear fNc


%% load dgv data
X     = loadBin(fin, 'uchar', 26);
Xpca  = loadBinPCA(fin, 'uchar', 26, EVecH, uH, 18)'; % dim x frameNum
%clear EVecH uH
plot3(Xpca(1, :), Xpca(2, :), Xpca(3, :));
hold on
plot3(Nc(1, :), Nc(2, :), Nc(3, :));
hold off

% %% extract stable parts
% meanY = mean(Xpca')';
% Y = adddelta(Xpca);
% idx = [];
% a = [];
% b = [];
% for ii = 1:size(Xpca, 2)
%     a = [a, norm(Y(19:36, ii))];
%     b = [b, norm(Y(1:18, ii)-meanY)];
%     if norm(Y(19:36, ii)) < thres_norm && norm(Y(1:18, ii)-meanY) < thres_delta
%         idx = [idx, ii];
%     end
% end
% %clear Xpca
% X = X(:, idx);
% Y = Y(1:18, idx);
% 
% meanY = mean(Y')';
% Y = adddelta(Y);
% idx = [];
% x = [];
% for ii = 1:size(Y, 2)
%     if norm(Y(19:36, ii)) < thres_norm && norm(Y(1:18, ii)-meanY) < thres_delta;
%         idx = [idx, ii];
%     end
% end
% X = X(:, idx);
% Y = Y(1:18, idx);
% 
% % check
% % hold on
% %     plot(Y(1, :), Y(2, :), 'b');
% % hold off
% %clear Xpca Y ii
% 
% 
% %% output extracted data
% fod = fopen(fout, 'wb');
% for ii = 1:length(idx)
%     fwrite(fod, X(:, ii), 'uchar');
% end
% fclose(fod);