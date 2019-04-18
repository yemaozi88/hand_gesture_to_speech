%
% 2008/10/21
% projectData2PCAplane.m projects data into PCA plane
%
% HISOTRY
% 2011/08/01 cleaned up codes
%

clear all, fclose all, clc;

%% definition
type       = 'uchar';
DIM        = 26;
mode = 1; % 0:get EigenParam, 1: project data into PCA plane
del = '\';

dirIn         = 'J:\!gesture\transitionAmong16of28\dgvs';
EigenParamDir = 'J:\!gesture\transitionAmong16of28\EigenParam16\1';
datasetNum = 1;


%% get EigenParam
if mode == 0
    clear EigenParamDir
    
    X = [];
    for ii = 1:3
        X_ = loadBinDir([dirIn del num2str(ii)], type, DIM);
        X = [X, X_];
    end
    clear type DIM
    clear ii datasetNum X_

    % dgv
    X = X(5:22, :)';
    
    getEigenParam(X, EigenParamDir);
    
    
%% project data into PCA plane
elseif mode == 1    
    % project data
    sNumArray     = [1, 2, 4, 7, 8, 9, 11, 13, 14, 15, 16, 21, 22, 25, 27, 28];
    sNumMax       = length(sNumArray);

    % load EigenParam
    [EVec, EVal, u] = loadEigenParam(EigenParamDir);
    
    % load 28 gesture data
    % X = []; % mean of every points
    hold on
    % label
    xlabel('1st Principal Component', 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold');
    ylabel('2nd Principal Component', 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold');
    set(gca, 'FontName', 'Arial', 'FontSize', 14);

    for ii_ = 1:sNumMax
        ii = sNumArray(ii_);
        if ii < 10
            iiStr = ['0' num2str(ii)];
        else
            iiStr = num2str(ii);
        end
        
        for dNum = 1:datasetNum
            fname = [dirIn del num2str(dNum) del iiStr '-' iiStr '.dgvs'];
            X = loadBin(fname, type, DIM);
        end % dNum
        X = X(5:22, :);
        X = X(1:16, :);
        clear fname

%         % calculate mean of data from several dataset
%         if ismac == 1
%             fin1 = loadBin([dirIn '/1/' iistr '.dgvs'], type, DIM);
%             fin2 = loadBin([dirIn '/2/' iistr '.dgvs'], type, DIM);
%         else
%             fin1 = loadBin([dirIn '\1\' iistr '.dgvs'], type, DIM);
%             fin2 = loadBin([dirIn '\2\' iistr '.dgvs'], type, DIM);
%         end

%         fin = [fin1, fin2];
%         fin = fin(5:22, :);
%         X_ = mean(fin')';
%         X = [X, X_];

        % project data
        Xmean = mean(X');
        Xpca = PCA_Trans(Xmean, EVec, u, 2);
        if ii_ == 16
            plot(Xpca(1), Xpca(2), 'r+', 'MarkerSize', 10);
            disp(iiStr)
        else
            plot(Xpca(1), Xpca(2), 'b+', 'MarkerSize', 10);
        end
    end % ii
    clear datasetNum
   hold off
end


% cd 'H:\u-tokyo\HMTS-win\PCA\scep'
% 
% NUM = 22; % number of signal from dataglove
% SNS = 18; % number of sensor
% 
% 
% %% aiueo
% X = load_scep('aiueo1.scep');
% [EVec1, EVal1, u1] = PCA(X);
% Y0 = PCA_Trans(X, EVec1, u1, 3);
% 
% % X = load_scep('aiueo2.scep');
% % Y1 = PCA_Trans(X, EVec1, u1, 2);
% % X = load_scep('aiueo3.scep');
% % Y2 = PCA_Trans(X, EVec1, u1, 2);
% % X = load_scep('aiueo4.scep');
% % Y3 = PCA_Trans(X, EVec1, u1, 2);
% % X = load_scep('aiueo5.scep');
% % Y4 = PCA_Trans(X, EVec1, u1, 2);
% % X = load_scep('aiueo6.scep');
% % Y5 = PCA_Trans(X, EVec1, u1, 2);
%  
%  
% %% transition
% X = load_scep('ai.scep');
% Yai = PCA_Trans(X, EVec1, u1, 3);
% X = load_scep('iu.scep');
% Yiu = PCA_Trans(X, EVec1, u1, 3);
% X = load_scep('ue.scep');
% Yue = PCA_Trans(X, EVec1, u1, 3);
% X = load_scep('eo.scep');
% Yeo = PCA_Trans(X, EVec1, u1, 3);
%  
% 
% %% 5 vowels
% X = load_scep('aa.scep');
% Yaa = PCA_Trans(X, EVec1, u1, 2);
% X = load_scep('ii.scep');
% Yii = PCA_Trans(X, EVec1, u1, 2);
% X = load_scep('uu.scep');
% Yuu = PCA_Trans(X, EVec1, u1, 2);
% X = load_scep('ee.scep');
% Yee = PCA_Trans(X, EVec1, u1, 2);
% X = load_scep('oo.scep');
% Yoo = PCA_Trans(X, EVec1, u1, 2);


%% visualize
% aiueo
% plot(Y0(:,1), Y0(:,2), 'b:');
% plot(Y1(:,1), Y1(:,2), 'r');
% plot(Y2(:,1), Y2(:,2), 'g');
% plot(Y3(:,1), Y3(:,2), 'c');
% plot(Y4(:,1), Y4(:,2), 'm');
% plot(Y5(:,1), Y5(:,2), 'k');

%plot3(Y0(:,1),Y0(:,2),Y0(:,3), 'b:');

% 5 vowels
% plot(Yaa(:,1), Yaa(:,2), 'r.')
% plot(Yii(:,1), Yii(:,2), 'g.');
% plot(Yuu(:,1), Yuu(:,2), 'c.');
% plot(Yee(:,1), Yee(:,2), 'm.');
% plot(Yoo(:,1), Yoo(:,2), 'k.');
%hold on
% plot3(Yaa(:,1), Yaa(:,2), Yaa(:,3), 'c.')
% plot3(Yii(:,1), Yii(:,2), Yii(:,3), 'r.')
% plot3(Yuu(:,1), Yuu(:,2), Yuu(:,3), 'c.')
% plot3(Yee(:,1), Yee(:,2), Yee(:,3), 'c.')
% plot3(Yoo(:,1), Yoo(:,2), Yoo(:,3), 'c.')


% mean
%mYaa = mean(Yaa);
%mYii = mean(Yii);
%mYuu = mean(Yuu);
%mYee = mean(Yee);
%mYoo = mean(Yoo);

% plot3(mYaa(:,1), mYaa(:,2), mYaa(:,3), 'r.')
% plot3(mYii(:,1), mYii(:,2), mYii(:,3), 'g.')
% plot3(mYuu(:,1), mYuu(:,2), mYuu(:,3), 'c.')
% plot3(mYee(:,1), mYee(:,2), mYee(:,3), 'm.')
% plot3(mYoo(:,1), mYoo(:,2), mYoo(:,3), 'k.')


% transition
% plot(Y0(:,1), Y0(:,2), 'b:');
% plot(Yai(:,1), Yai(:,2), 'r.');
% plot(Yiu(:,1), Yiu(:,2), 'g.');
% plot(Yue(:,1), Yue(:,2), 'c.');
% plot(Yeo(:,1), Yeo(:,2), 'm.');

% plot3(Yai(:,1),Yai(:,2),Yai(:,3), 'r.');
% hold on
% plot3(Yiu(:,1),Yiu(:,2),Yiu(:,3), 'g.');
% plot3(Yue(:,1),Yue(:,2),Yue(:,3), 'c.');
% plot3(Yeo(:,1),Yeo(:,2),Yeo(:,3), 'm.');
%hold off