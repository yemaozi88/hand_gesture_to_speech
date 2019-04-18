%
% 2009/08/24
% checkWav2cep.m loads cepstum data made by wav2cep3.cpp and synthesize speech
%
% Aki Kunikoshi (M1)
% yemaozi88@gmail.com
%

clear all

%- deg of jointvector
NUM = 22; % number of signal from dataglove
SNS = 18; % number of sensor
DEG = 18; % degree of cepstrum, extract 0-DEG cep using wav2cep3.cpp 
JNT = 36; % degree per a joint vector


%% load wav file
% x: waveform
% fs: sampling frequency
[x, fs] = wavread('C:\Documents and Settings\kunikoshi\My Documents\Visual Studio 2005\Projects\wav2cep\wav2cep\wav\na1.wav');


%% previous method
% f0raw: fundamental frequency
% ap:18
% n3gram: STRAIGHT spectrogram
[f0raw, ap, prmF0] = exstraightsource(x, fs);
[n3sgram, prmP] = exstraightspec(x, f0raw, fs);


%% analysis
scep = sgram2cep(n3sgram, DEG);
sgram = cep2sgram(scep);


%% make f0 vector
f0raw2 = f0raw;
fmax = length(f0raw(1,:));
for i = 1:fmax
    f0raw2(1, i) = 140;
end


%% make ap matrix
ap2 = ap;
for t = 1:fmax
     for s = 1:513
         ap2(s, t) = -20;
     end
end


%% write to wav file
[sy, prmS] = exstraightsynth(f0raw2, sgram, ap2, fs);
wavwrite(sy/32768, fs, 16, 'C:\Documents and Settings\kunikoshi\My Documents\Visual Studio 2005\Projects\wav2cep\wav2cep\syn\na1.wav');