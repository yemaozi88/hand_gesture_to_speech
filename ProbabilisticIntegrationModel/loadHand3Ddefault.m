function [offset, dgv2deg] = loadHand3Ddefault(dirDefault)
% [offset, dgv2deg] = loadHand3Ddefault(dirDefault)
% loads offset and dgv2deg value which made by getHand3Ddefault.m
%
% INPUT
% dirDefault: the directory which default files made by getHand3Ddefault.m are located in
% OUTPUT
% offset: dgv value when a hand makes no.1 of 28 gestures (PA) shape
% dgv2deg: dgv2deg = deg / dgv
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
% movable range
% movable = [1; 70; 90; 1; ...    % thumb
%             100; 120; ...       % index
%             100; 120; 1; ...    % middle
%             100; 120; 1; ...    % ring
%             100; 120; 1; ...    % pinky
%             1; 1; 1];
%
% HISTORY
% 2011/01/05 functionized
%
% AUTHOR
% Aki Kunikoshi (D2)
% yemaozi88@gmail.com
%

%% definition
%dirDefault = 'C:\research\gesture\transitionAmong16of28\default';


%% load default value
if ismac == 1
    offset  = load([dirDefault '/offset.txt']);
    dgv2deg = load([dirDefault '/dgv2deg.txt']);
else
    offset  = load([dirDefault '\offset.txt']);
    dgv2deg = load([dirDefault '\dgv2deg.txt']);
end