function [dgvMean, gestureCombinationList] = make16gestureCombinationList(dirDgv)
% [dgvMean, gestureCombinationList] = make16gestureCombinationList(dirDgv)
% make Gesture combination list for S2Hmodel.m
% 
% INPUT
% dirDgv: the directory for transitionAmong16of28
% OUTPUT
% dgvMean: the mean of every gesture, 19 x 16 double
% gestureCombinationList: gesture combinations for 5 vowels, where /a/ is fixed as 28
%
% LINK
% loadGestureData.m
%
% HISTORY
% 2011/01/05 functionized
% 2010/12/21 
%
% AUTHOR
% Aki Kunikoshi (D2)
% yemaozi88@gmail.com
%


%% definition
%dirDgv = '/Users/kunikoshi/research/gesture/transitionAmong16of28/dgvs';
%dirDgv = 'C:\research\gesture\transitionAmong16of28\dgvs';
SNS = 18; % 18-sensor DataGlove
ges  = [1, 2, 4, 7, 8, 9, 11, 13, 14, 15, 16, 21, 22, 25, 27, 28];


%%
gestureCombinationList = [];
dgvMean = loadGestureData(dirDgv, 3, 1); % load mean value of 16 gestures, (SNS+1) x (gmax+1)


%% fix one gesture for /a/
aIdx = 16;
ges(:, 16) = [];

gmax = size(ges, 2);
gesIdx = 1:gmax; % index for 16 gestures


%% 
C = nchoosek(gesIdx, 4);   % the list of vowel sets
Cnum = size(C, 1);      % the number of vowel sets
for nC = 1:Cnum; % the number of the vowel combination

    P = perms(C(nC, :));    % the permucation of a vowel set
    Pnum = size(P, 1);      % the number of all permutations
    for nP = 1:Pnum; % the number of the permutation
        iIdx = P(nP, 1);
        uIdx = P(nP, 2);
        eIdx = P(nP, 3);
        oIdx = P(nP, 4);

        %% remove gestures which doesn't have the equivalent allocation to the one of five Japanese vowels
        % |ao| < |au|
        disAO_ = dgvMean(:, aIdx) - dgvMean(:, oIdx);
        disAO  = norm(disAO_(1:SNS));
        disAU_ = dgvMean(:, aIdx) - dgvMean(:, uIdx);
        disAU  = norm(disAU_(1:SNS));
        if disAO < disAU
            % |ae| < |ai|
            disAE_ = dgvMean(:, aIdx) - dgvMean(:, eIdx);
            disAE  = norm(disAE_(1:SNS));
            disAI_ = dgvMean(:, aIdx) - dgvMean(:, iIdx);
            disAI  = norm(disAI_(1:SNS));
            if disAE < disAI
                gestureCombination = [28, ges(P(nP, 1)), ges(P(nP, 2)), ges(P(nP, 3)), ges(P(nP, 4))];
                gestureCombinationList = [gestureCombinationList; gestureCombination];
                clear gestureCombination
            end
            clear disAE_ disAE disAI_ disAI
        end
        clear disAO_ disAO disAU_ disAU
    end
end
clear SNS dirDgv ges gesIdx gmax
clear C Cnum nC P Pnum nP
clear aIdx iIdx uIdx eIdx oIdx