function dgv = loadDgv(fIn, alpha)

% alpha = -2;
%fIn = [dirAlpha del 'na_alpha' alphaStr '.dgv'];
%alphaStr = num2str(alpha);
dgv = loadBin(fIn, 'uchar', 26);
dgv = dgv(5:22, :);
dgv = dgv(1:16, :);