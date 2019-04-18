%
% 2011/11/21
% train GMM for the real-time H2S system
%
% NOTES
% - this program is based on makeSamples2listeningTest.m
%
% AUTHOR
% Aki Kunikoshi (D3)
% yemaozi88@gmail.com
%

clear all, clc, fclose('all');
% 0: make joint vectors for consonant 'n'
% 1: GMM training
FLAG = 1;

%% make joint vectors for consonants 'n'
if FLAG == 0
    for nn = 1:10
        nnStr = num2str(nn);
        % output of S2Hdelta (alpha=0.6)
        dirH = ['J:\H2Swith16deg_0243\realTimeSystem\n\' nnStr];
        dirS = ['J:\!speech\JapaneseConsonants\n\suzuki\16k\scep16\' nnStr];
        dirJ = ['J:\H2Swith16deg_0243\realTimeSystem\jointN\' nnStr];
        del = '\';
%         logfile = [dirJ del 'frameNum.txt'];
%         flog = fopen(logfile, 'wt');
        
        dirlist = dir([dirS del '*.scep']);
        dirlength = length(dirlist);
        for ii = 1:dirlength
            % except ".", "..", "DS_Store"
            if length(dirlist(ii).name) > 3
                filename = strrep(dirlist(ii).name, '.scep', '');
                disp([nnStr ':' filename])

                H = loadBin([dirH del filename '.dgv'], 'uchar', 26);
                %H = H(5:20, :);
                S = loadBin([dirS del filename '.scep'], 'float', 17);
                %S = S(1:16, :);
                
                % cut the fist and the last 8 frames because of delta
                frameS = size(S, 2);
                S(:, frameS-7:frameS) = [];
                S(:, 1:8) = [];
                frameS = size(S, 2);                
                %frameH  = size(H, 2);
                %disp([num2str(frameH) ':' num2str(frameS)])
                
                J = makeJoint(H, S, 1, 0); % with scep0, H->S
                frameJ = size(J, 2);
                %fprintf(flog, '%d\t%s\t%d\n', nn, filename, frameJ);
                
                fout = fopen([dirJ del filename '.joint'], 'wb');
                for jj = 1:frameJ
                    fwrite(fout, J(:, jj), 'float');
                end
                fclose(fout);
                
            end % dirlist
        end % ii
        %fclose(flog);
    end % nn
%% GMM training
elseif FLAG == 1;
    %% definitions
    YV = loadBinDir('J:\H2Swith16deg_0243\realTimeSystem\jointH2S_11','float', 32);
    dirYC = 'J:\H2Swith16deg_0243\realTimeSystem\jointN';
    U = loadBin('J:\H2Swith16deg_0243\realTimeSystem\jointH2S_22\ai.joint', 'float', 32); % test data
    
    dirOut = 'J:\H2Swith16deg_0243\realTimeSystem\joint';
    del = '\';

    EigenParamDir = 'J:\!gesture\transitionAmong16of28\EigenParam16\1';
    gMax_         = 128;

    %% load Eigen parameters
    [EVec, EVal, u] = loadEigenParam(EigenParamDir);
    clear EigenParamDir

    %% load joint data for consonants
%     YC = [];
%     for nn = 1:10
%         nnStr = num2str(nn);
%         YC_ = loadBinDir([dirYC del nnStr], 'float', 32);
%         YC = [YC, YC_];
%     end
%     clear nn nnStr dirYC YC_
%     
%     % reduce data
%     YC_ = [];
%     fmax = size(YC, 2);
%     for t=1:fmax
%         if rem(t, 2)==1
%             YC_ = [YC_, YC(:, t)];
%         end
%     end
%     YC = YC_;
%     clear YC_
%     
%     Y = [YV, YC];
%     clear YV YC
    Y = YV;
    clear YV
    
    %% perform PCA
    YH = Y(1:16, :);
    YS = Y(17:32, :);
    YHpca = PCA_Trans(YH', EVec, u, 16);
    YHpca = YHpca';
    Y = [YHpca; YS];
    Y = Y';
    clear YS YH YHpca

    UH = U(1:16, :);
    US = U(17:32, :);
    UHpca = PCA_Trans(UH', EVec, u, 16);
    UHpca = UHpca';
    U = [UHpca; US];
    U = U';
    clear US UH UHpca

    clear EVal EVec u
    
    %% preparation for ML calculation
    gNumArray = [1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096];
    gMax = length(gNumArray);
    gMax = log2(gMax_)+1;
    ML = zeros(gMax, 1);
    clear gMax_

% log
flog = fopen([dirOut '\log.txt'], 'wt');
fprintf(flog, '<Maximum Likelihood>\n');
fprintf(flog, 'The number of data : %d\n\n', size(Y, 1));

for g = 1:gMax
tic
    gNum = gNumArray(g);
    disp(gNum)

    obj = trainGMM(Y, gNum, 0); % 0 - full, 1 - diagonal
    fOut = [dirOut '\H2Smodel_mix' num2str(gNum) '_obj'];
    save(fOut, 'obj');
    clear fOut
        
    L_ = pdf(obj, U);
    L = log(max(L_));
    ML(g, 1) = L;
    disp([num2str(gNum) ':' num2str(L)]);

    % log
    fprintf(flog, 'The number of mixtures : %d\n', gNum);
    fprintf(flog, '\ttrain : %6.4f\n', obj.NlogL);
    fprintf(flog, '\ttest  : %6.4f\n', L);
    
    save([dirOut '\ML'], 'ML');
toc
end
fclose(flog);
clear flog  
end % FLAG