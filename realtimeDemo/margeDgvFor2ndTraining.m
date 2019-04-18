
%
% AUTHOR
% Aki Kunikoshi (D3)
% yemaozi88@gmail.com
%

%% definition
clear all, fclose all, clc

synDgvAutoDir = 'J:\realtimeDemo\v6\0243\2ndTrain_byGeneratedData\extractedDgv_auto';

vowels = ['a', 'i', 'u', 'e', 'o'];

% m-c
Mc = [];
Nc = [];
Rc = [];

for ii = 1:3
    for nV = 1:5
        Nc_ = [];
        Mc_ = [];
        Rc_ = [];
        
        iiStr = num2str(ii);
        Mc_ = loadBin([synDgvAutoDir '\m' vowels(nV) '-c' iiStr '.dgv'], 'uchar', 26);
        
        if ii == 1 && nV == 3
        elseif ii == 1 && nV == 4
        elseif ii == 2 && nV == 2
        elseif ii == 3 && nV == 3
        elseif ii == 3 && nV == 4
        else
            Nc_ = loadBin([synDgvAutoDir '\n' vowels(nV) '-c' iiStr '.dgv'], 'uchar', 26);
        end

        if ii == 1
        elseif ii == 2 && nV == 5
        elseif ii == 3 && nV == 3
        elseif ii == 3 && nV == 5
        else
            Rc_ = loadBin([synDgvAutoDir '\r' vowels(nV) '-c' iiStr '.dgv'], 'uchar', 26);
        end
        
        Mc = [Mc, Mc_];
        Nc = [Nc, Nc_];
        Rc = [Rc, Rc_];
    end
end
clear Mc_ Nc_ Rc_


%% output

fodMc = fopen([synDgvAutoDir '\m-c.dgv'], 'wb');
fodNc = fopen([synDgvAutoDir '\n-c.dgv'], 'wb');
fodRc = fopen([synDgvAutoDir '\r-c.dgv'], 'wb');

for ii = 1:size(Mc, 2)
    fwrite(fodMc, Mc(:, ii), 'uchar');
end
for ii = 1:size(Nc, 2)
    fwrite(fodNc, Nc(:, ii), 'uchar');
end
for ii = 1:size(Rc, 2)
    fwrite(fodRc, Rc(:, ii), 'uchar');
end

fclose(fodMc);
fclose(fodNc);
fclose(fodRc);
clear fodMc fodNc fodRc