%
% 2011/10/10
% projectData2PCAplane2.m project dgv data to PCA plane
%
% NOTES:
% - gesture data for 57 objects is used
% - this code is based on projectData2PCAplane.m
%
% Aki Kunikoshi (D3)
% yemaozi88@gmail.com
%


dirH = 'K:\!gesture\57objects\dgvs\static_real';
EigenParamDir = 'K:\!gesture\57objects\EigenParam16\static_real';
del = '\';

[EVec, EVal, u] = loadEigenParam(EigenParamDir);
clear EigenParamDir

hold on
for ii = 1:57
    if ii < 10
        iiStr = ['0' num2str(ii)];
    else
        iiStr = num2str(ii);
    end
    disp(iiStr)
    A = loadBin([dirH del iiStr '.dgv'], 'uchar', 26);
    A = A(5:22, :);
    A = A(1:16, :);
    
    B = PCA_Trans(A', EVec, u, 16);
    meanB = mean(B)';
    plot(meanB(1, 1), meanB(2, 1), '.')
end
hold off