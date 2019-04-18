%
% 2011/09/21
% CCgestures.m calculates correlation between one factor to another of dgv data 
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

%% definition
del = '\';
dirIn  = 'G:\!gesture\transitionAmong16of28\dgvs';
dirOut = 'G:\analysis\correlation\16of28_all';


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
% % number of data is too much??
% B = [];
% for ii = 1:size(A, 2)
%     if rem(ii, 10) == 1
%         B = [B, A(:, ii)];
%     end
% end
% A = B;
% clear B


%% draw figures and calculate correlation coefficient
flog_name = [dirOut del 'corr.txt'];
flog = fopen(flog_name, 'wt');

for n1 = 1:17;
    for n2 = n1+1:18;

    % get filename
    if n1 < 10
        n1Str = ['0' num2str(n1)];
    else
        n1Str = num2str(n1);
    end
    if n2 < 10
        n2Str = ['0' num2str(n2)];
    else
        n2Str = num2str(n2);
    end
    ffig_name = [dirOut del n1Str '-' n2Str];

    X = A(n1, :);
    Y = A(n2, :);
    % draw the distribution
    fh = plot(X, Y, '.');
    axis([0, 255, 0, 255]);
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    saveas(fh, [ffig_name '.png']);
    saveas(fh, [ffig_name '.eps']);

    % get correlation  coeeficient
    cc = corr(X', Y');

    % output
    disp([n1Str '-' n2Str ' : ' num2str(cc)]);
    fprintf(flog, '%s-%s\t%f\n', n1Str, n2Str, cc);

    end % n2
end % n1

fclose(flog);
clear flog_name flog