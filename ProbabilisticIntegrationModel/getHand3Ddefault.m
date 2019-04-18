%
% 2010/11/30
% getHand3Ddefault.m calculates the default value (offset and ratio between dgv and deg) for Hand3D.vcproj
% 
% AUTHOR
% Aki Kunikoshi (D2)
% yemaozi88@gmail.com
%

clear all, clc

%% definition
% 0: only one file for each GU and PA is used to calculate default values
% 1: all files in the directories are used to calculate default values
mode = 0;

% for mode 0
dirDefault = 'C:\research\gesture\transitionAmong16of28\default';
% for mode 1
dirGU = 'L:\research\gesture\default\gu\dgvs';
dirPA = 'L:\research\gesture\default\pa\dgvs';
dirOut = 'L:\research\gesture\default\data';


%% load dgv data
if mode == 0
    fnameGU = [dirDefault '\gu.dgvs'];
    fnamePA = [dirDefault '\pa.dgvs'];

    % GU (No.1 of 28 gestures)
    GU_ = loadBin(fnameGU, 'uchar', 26);
    % PA (No.28 of 28 gestures)
    PA_ = loadBin(fnamePA, 'uchar', 26);
    
    clear fnameGU fnamePA;
    dirOut = dirDefault;
elseif mode == 1
    % GU (No.1 of 28 gestures)
    GU_ = loadBinDir(dirGU, 'uchar', 26);
    % PA (No.28 of 28 gestures)
    PA_ = loadBinDir(dirPA, 'uchar', 26);
end
GU = GU_(5:22, :);
PA = PA_(5:22, :);
clear GU_ PA_


%% compare GU and PA
GUmean = mean(GU')';
PAmean = mean(PA')'; % offset
offset = PAmean
 
diff = GUmean - offset;
% diff
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

% movable range
movable = [1; 70; 90; 1; ...    % thumb
            100; 120; ...       % index
            100; 120; 1; ...    % middle
            100; 120; 1; ...    % ring
            100; 120; 1; ...    % pinky
            1; 1; 1];

% weight
dgv2deg = movable ./ diff; % dgv2deg = deg / dgv
MIPweight = [dgv2deg(5); dgv2deg(7); dgv2deg(10); dgv2deg(13)]
PIPweight = [dgv2deg(6); dgv2deg(8); dgv2deg(11); dgv2deg(14)]


%% write default values needed for Hand3D.vcproj out to .txt files

fname_offset = [dirOut '\offset.txt'];
fname_dgv2deg = [dirOut '\dgv2deg.txt'];

fout_offset  = fopen(fname_offset, 'wt');
fout_dgv2deg = fopen(fname_dgv2deg, 'wt');

fprintf(fout_offset, '%f\n', offset);
fprintf(fout_dgv2deg, '%f\n', dgv2deg);

fclose(fout_offset);
fclose(fout_dgv2deg);