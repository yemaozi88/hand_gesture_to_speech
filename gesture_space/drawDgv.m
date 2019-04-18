%
% 2011/11/04
% draw dgv data estimated the model trained by static data and that by static+delta
%
% NOTES
% sensor location
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
% AUTHOR
% Aki Kunikoshi(D3)
% yemaozi88@gmail.com
%

clear all, fclose all, clc;

%% definition
% sample num = 0243
% a = '28'; % T 11111 P
% i = '02'; % T 00001 P
% u = '01'; % T 00000 P
% e = '09'; % T 01001 P
% o = '25'; % T 11100 P

% dirStatic    = 'J:\H2Swith16deg_0243\S2H\synDgv_noPCA\16of18';
% dirStaticPCA = 'J:\H2Swith16deg_0243\S2H\synDgv_withPCA_alpha04';
% dirDelta     = 'J:\H2Swith16deg_0243\S2HwithDelta\synDgv_noPCA';
% dirDeltaPCA  = 'J:\H2Swith16deg_0243\S2HwithDelta\synDgv_withPCA_alpha04';
% 
% VC   = 'consonants';
% word = 'nu';

dirAlpha = 'J:\H2Swith16deg_0243\S2H\synDgv_withPCA_alpha10\16of18\alpha';
word = 'nu';

del  = '\';
sNo = 6;


%% delta
% % probabilistic integration model
% fStatic     = [dirStatic del VC '_1of8' del word '.dgv'];
% fStaticPCA  = [dirStaticPCA del VC del word '.dgv'];
% fDelta      = [dirDelta del VC del word '.dgv'];
% fDeltaPCA   = [dirDeltaPCA del VC del word '.dgv'];
% % normal VC
% %fStaticPCA_ = [dirStaticPCA del VC '_1of8_previous' del word '.dgv'];
% %fDeltaPCA_  = [dirDeltaPCA del VC '_previous' del word '.dgv'];
% 
% clear dirStatic dirStaticPCA
% clear dirDelta dirDeltaPCA
% clear VC word del
% 
% dgvStatic     = loadBin(fStatic, 'uchar', 26);
% dgvStaticPCA  = loadBin(fStaticPCA, 'uchar', 26);
% %dgvStaticPCA_ = loadBin(fStaticPCA_, 'uchar', 26);
% dgvDelta      = loadBin(fDelta, 'uchar', 26);
% dgvDeltaPCA   = loadBin(fDeltaPCA, 'uchar', 26);
% %dgvDeltaPCA_  = loadBin(fDeltaPCA_, 'uchar', 26);
% clear fStatic fStaticPCA fStaticPCA_
% clear fDelta fDeltaPCA fDeltaPCA_
% 
% dgvStatic     = dgvStatic(5:22, :);
% dgvStaticPCA  = dgvStaticPCA(5:22, :);
% %dgvStaticPCA_ = dgvStaticPCA_(5:22, :);
% dgvDelta      = dgvDelta(5:22, :);
% dgvDeltaPCA   = dgvDeltaPCA(5:22, :);
% %dgvDeltaPCA_  = dgvDeltaPCA_(5:22, :);
% 
% % output
% hold on
%     xlabel('Time [ms]', 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold');
%     ylabel('Sensor output', 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold');
%     %plot(dgvStatic(sNo, :), 'b', 'linewidth', 2);
%     plot(dgvStaticPCA(sNo, :), 'ko-', 'linewidth', 2, 'MarkerSize', 10);
%     %plot(dgvStaticPCA_(sNo, :), 'r', 'linewidth', 2);
%     %plot(dgvDelta(sNo, :), 'b', 'linewidth', 2);
%     plot(dgvDeltaPCA(sNo, :), 'kx--', 'linewidth', 2, 'MarkerSize',10);
%     set(gca, 'FontName', 'Arial', 'FontSize', 14);
%     legend([{'Static'}; {'Static+Delta'}]);
%     %plot(dgvDeltaPCA_(sNo, :), 'r', 'linewidth', 2);
% hold off


%% alpha
alpha = -2.0;
alphaStr = num2str(alpha);
dgvM20 = loadDgv([dirAlpha del word '_alpha' alphaStr '.dgv'], alpha);

alpha = -1.5;
alphaStr = num2str(alpha);
dgvM15 = loadDgv([dirAlpha del word '_alpha' alphaStr '.dgv'], alpha);

alpha = -1.0;
alphaStr = num2str(alpha);
dgvM10 = loadDgv([dirAlpha del word '_alpha' alphaStr '.dgv'], alpha);

alpha = -0.5;
alphaStr = num2str(alpha);
dgvM05 = loadDgv([dirAlpha del word '_alpha' alphaStr '.dgv'], alpha);

alpha = 0.0;
alphaStr = num2str(alpha);
dgv000 = loadDgv([dirAlpha del word '_alpha' alphaStr '.dgv'], alpha);

alpha = 0.1;
alphaStr = num2str(alpha);
dgvP01 = loadDgv([dirAlpha del word '_alpha' alphaStr '.dgv'], alpha);

alpha = 0.2;
alphaStr = num2str(alpha);
dgvP02 = loadDgv([dirAlpha del word '_alpha' alphaStr '.dgv'], alpha);

alpha = 0.3;
alphaStr = num2str(alpha);
dgvP03 = loadDgv([dirAlpha del word '_alpha' alphaStr '.dgv'], alpha);

alpha = 0.4;
alphaStr = num2str(alpha);
dgvP04 = loadDgv([dirAlpha del word '_alpha' alphaStr '.dgv'], alpha);

alpha = 0.5;
alphaStr = num2str(alpha);
dgvP05 = loadDgv([dirAlpha del word '_alpha' alphaStr '.dgv'], alpha);

alpha = 0.6;
alphaStr = num2str(alpha);
dgvP06 = loadDgv([dirAlpha del word '_alpha' alphaStr '.dgv'], alpha);

alpha = 0.7;
alphaStr = num2str(alpha);
dgvP07 = loadDgv([dirAlpha del word '_alpha' alphaStr '.dgv'], alpha);

alpha = 0.8;
alphaStr = num2str(alpha);
dgvP08 = loadDgv([dirAlpha del word '_alpha' alphaStr '.dgv'], alpha);

alpha = 0.9;
alphaStr = num2str(alpha);
dgvP09 = loadDgv([dirAlpha del word '_alpha' alphaStr '.dgv'], alpha);

alpha = 1.0;
alphaStr = num2str(alpha);
dgvP10 = loadDgv([dirAlpha del word '_alpha' alphaStr '.dgv'], alpha);

alpha = 1.5;
alphaStr = num2str(alpha);
dgvP15 = loadDgv([dirAlpha del word '_alpha' alphaStr '.dgv'], alpha);

alpha = 2.0;
alphaStr = num2str(alpha);
dgvP20 = loadDgv([dirAlpha del word '_alpha' alphaStr '.dgv'], alpha);

hold on
    xlabel('Time [ms]', 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold');
    ylabel('Sensor output', 'FontName', 'Arial', 'FontSize', 16, 'FontWeight', 'bold');

    %plot(dgvM10(sNo, :), 'r', 'linewidth', 2);
    %plot(dgvM05(sNo, :), 'm', 'linewidth', 2);   
%     plot(dgv000(sNo, :), 'k', 'linewidth', 2);
%     plot(dgvP05(sNo, :), 'g', 'linewidth', 2);
%     plot(dgvP10(sNo, :), 'b', 'linewidth', 2);
%     plot(dgvP15(sNo, :), 'm', 'linewidth', 2);
%     plot(dgvP20(sNo, :), 'r', 'linewidth', 2);
    
    plot(dgv000(sNo, :), 'k--', 'linewidth', 2, 'MarkerSize',10);
    %plot(dgvP01(sNo, :), 'bo-', 'linewidth', 2, 'MarkerSize',10);
    plot(dgvP02(sNo, :), 'kx-', 'linewidth', 2, 'MarkerSize',10);
    %plot(dgvP03(sNo, :), 'mo-', 'linewidth', 2, 'MarkerSize',10);
    plot(dgvP04(sNo, :), 'ko-', 'linewidth', 2, 'MarkerSize',10);
    %plot(dgvP05(sNo, :), 'bo--', 'linewidth', 2, 'MarkerSize',10);
    plot(dgvP06(sNo, :), 'k+-', 'linewidth', 2, 'MarkerSize',10);
    %plot(dgvP07(sNo, :), 'mo--', 'linewidth', 2, 'MarkerSize',10);
    plot(dgvP08(sNo, :), 'kd-', 'linewidth', 2, 'MarkerSize',10);
%     plot(dgvP09(sNo, :), 'mo-', 'linewidth', 2, 'MarkerSize',10);
    plot(dgvP10(sNo, :), 'ks-', 'linewidth', 2, 'MarkerSize',10);

    set(gca, 'FontName', 'Arial', 'FontSize', 14);
    legend([{'alpha=0.0'}; {'alpha=0.2'}; {'alpha=0.4'}; {'alpha=0.6'}; {'alpha=1.0'}]);

hold off