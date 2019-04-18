%
% 2011/08/24
% checkGestures.m extracts stable parts of generated gestures by 1st
% training
%
% NOTE
% frame number will be approximately 150 for 'c' and 'm'
%
% AUTHOR
% Aki Kunikoshi(D3)
% yemaozi88@gmail.com
%

clear all, fclose all, clc;

dirSynDgvCheck = 'J:\H2SwithDelta\demoSample\0243\synDgvCheck';
% manually made data
dirSynDgvMan = 'J:\H2SwithDelta\demoSample\0243\synDgvManual';


%% m_c
m_c = loadBin([dirSynDgvCheck '\ma-c.dgv'], 'uchar', 26);
m_c = m_c(:, 236:245);
m_c = repmat(m_c, 1, 15);

fmax = size(m_c, 2);
fm_c = fopen([dirSynDgvMan '\m-c.dgv'], 'wb');
for ii = 1:fmax
    fwrite(fm_c, m_c(:,ii), 'uchar');
end
fclose(fm_c);
clear fm_c


%% m_m
m_m = loadBin([dirSynDgvCheck '\me-m.dgv'], 'uchar', 26);
m_m = m_m(:, 14:16);
m_m = repmat(m_m, 1, 50);

fmax = size(m_m, 2);
fm_m = fopen([dirSynDgvMan '\m-m.dgv'], 'wb');
for ii = 1:fmax
    fwrite(fm_m, m_m(:,ii), 'uchar');
end
fclose(fm_m);
clear fm_m


%% n_c
n_c = loadBin([dirSynDgvCheck '\ni-c.dgv'], 'uchar', 26);
n_c = n_c(:, 16:25);
n_c = repmat(n_c, 1, 15);

fmax = size(n_c, 2);
fn_c = fopen([dirSynDgvMan '\n-c.dgv'], 'wb');
for ii = 1:fmax
    fwrite(fn_c, n_c(:,ii), 'uchar');
end
fclose(fn_c);
clear fn_c


%% n_m
n_m = loadBin([dirSynDgvCheck '\nu-m.dgv'], 'uchar', 26);
n_m = n_m(:, 29:33);
n_m = repmat(n_m, 1, 30);

fmax = size(n_m, 2);
fn_m = fopen([dirSynDgvMan '\n-m.dgv'], 'wb');
for ii = 1:fmax
    fwrite(fn_m, n_m(:,ii), 'uchar');
end
fclose(fn_m);
clear fn_m


%% r_c
r_c = loadBin([dirSynDgvCheck '\ru-c.dgv'], 'uchar', 26);

% first part
r_c1 = r_c(:, 2:6);
r_c1 = repmat(r_c1, 1, 30);

fmax = size(r_c1, 2);
fr_c1 = fopen([dirSynDgvMan '\r-c1.dgv'], 'wb');
for ii = 1:fmax
    fwrite(fr_c1, r_c1(:,ii), 'uchar');
end
fclose(fr_c1);
clear fr_c1

% second part
r_c2 = r_c(:, 40:44);
r_c2 = repmat(r_c2, 1, 30);

fmax = size(r_c2, 2);
fr_c2 = fopen([dirSynDgvMan '\r-c2.dgv'], 'wb');
for ii = 1:fmax
    fwrite(fr_c2, r_c2(:,ii), 'uchar');
end
fclose(fr_c2);
clear fr_c2
