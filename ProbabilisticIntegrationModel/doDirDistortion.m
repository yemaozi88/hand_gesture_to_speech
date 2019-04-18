%
% 2009/05/02
% do processes to all files in the directory
% 

clc, clear all

%% definition
dirIn           = 'C:\research\ProbabilisticIntegrationModel\S2H-H2S_ERRV20_ERRC20_thres5_mix32\28-07-04-13-14';
dirVowel        = 'C:\research\speech\Japanese5vowels\isolated\suzuki\16k\scep18\1';
dirConsonant    = 'C:\research\speech\JapaneseConsonants';

if ismac == 1
    dirSynScep  = [dirIn '/synScep'];
    fname_log   = [dirIn '/cepstralDistortion.txt'];
else
    dirSynScep  = [dirIn '\synScep'];
    fname_log   = [dirIn '\cepstralDistortion.txt'];
end

consonant       = ['b', 'm', 'n', 'p', 'r'];
vowel           = ['a', 'i', 'u', 'e', 'o'];


%% log
flog  = fopen(fname_log, 'wt');

fprintf(flog, '< Cepstral distortion >\n');
fprintf(flog, '- The data set numbers are always 1\n\n');


%% directory processing

CDmat = zeros(5, 6);

% vowels
for nV = 1:5
    mora = sprintf('%s%s', vowel(nV), vowel(nV));
    if ismac == 1
        filenameResyn   = [dirVowel '/' mora '.scep'];
        filenameSynScep = [dirSynScep '/' mora '.scep'];
    else
        filenameResyn   = [dirVowel '\' mora '.scep'];
        filenameSynScep = [dirSynScep '\' mora '.scep'];
    end

    %disp(filenameResyn)
    %disp(filenameSynScep)
    
    NMmean = distortion2(filenameResyn, filenameSynScep);
    CDmat(nV, 1) = NMmean;
    
    fprintf(flog, '%s, %.4f\n', mora, NMmean);
    disp([mora ' : ' num2str(NMmean)])
end % nV
fprintf(flog, '\n');

% consonants
for nC = 1:5 % for consonant
    for nV = 1:5 % for vowels
        mora = sprintf('%s%s', consonant(nC), vowel(nV));
        if ismac == 1
            filenameResyn   = [dirConsonant '/' consonant(nC) '/suzuki/16k/scep18/1/' mora '.scep'];
            filenameSynScep = [dirSynScep '/' mora '.scep'];
        else
            filenameResyn   = [dirConsonant '\' consonant(nC) '\suzuki\16k\scep18\1\' mora '.scep'];
            filenameSynScep = [dirSynScep '\' mora '.scep'];
        end

        %disp(filenameResyn)
        %disp(filenameSynScep)

        NMmean = distortion2(filenameResyn, filenameSynScep);
        CDmat(nV, nC+1) = NMmean;

        fprintf(flog, '%s, %.4f\n', mora, NMmean);
        disp([mora ' : ' num2str(NMmean)])
    end % nV
    fprintf(flog, '\n');
end % nC