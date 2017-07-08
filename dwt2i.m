%ウェーブレット変換と逆ウェーブレット変換

%%
%イメージ読み込み
img = imread('input.bmp');
size = size(img);
img = rgb2gray(im2double(img));


%%
%ウェーブレット変換
[c,s]=wavedec2(img, 2, 'haar');  %レベルとwname

%レベル１
[H1,V1,D1] = detcoef2('all',c,s,1);
A1 = appcoef2(c,s,'haar',1);
V1img = wcodemat(V1,255,'mat',1);
H1img = wcodemat(H1,255,'mat',1);
D1img = wcodemat(D1,255,'mat',1);
A1img = wcodemat(A1,255,'mat',1);

%レベル２
[H2,V2,D2] = detcoef2('all',c,s,2);
A2 = appcoef2(c,s,'haar',2);
V2img = wcodemat(V2,255,'mat',1);
H2img = wcodemat(H2,255,'mat',1);
D2img = wcodemat(D2,255,'mat',1);
A2img = wcodemat(A2,255,'mat',1);

%%
%プロット　レベル１
subplot(2,2,1);
imagesc(A1img);
colormap pink(255);
title('Approximation Coef. of Level 1');

subplot(2,2,2);
imagesc(H1img);
title('Horizontal detail Coef. of Level 1');

subplot(2,2,3);
imagesc(V1img);
title('Vertical detail Coef. of Level 1');

subplot(2,2,4);
imagesc(D1img);
title('Diagonal detail Coef. of Level 1');

%%
%プロット　レベル２
figure;
subplot(2,2,1);
imagesc(A2img);
colormap pink(255);
title('Approximation Coef. of Level 2');

subplot(2,2,2)
imagesc(H2img);
title('Horizontal detail Coef. of Level 2');

subplot(2,2,3)
imagesc(V2img);
title('Vertical detail Coef. of Level 2');

subplot(2,2,4)
imagesc(D2img);
title('Diagonal detail Coef. of Level 2');

%%
%画像保存
imwrite(A1img, pink(255), 'A1img2.bmp');
imwrite(H1img, pink(255), 'H1img2.bmp');
imwrite(V1img, pink(255), 'V1img2.bmp');
imwrite(D1img, pink(255), 'D1img2.bmp');

%%
%逆ウェーブレット変換
Y = idwt2(A1, H1, V1, D1, 'haar', size);
imshow(Y);
