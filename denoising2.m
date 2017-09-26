%img=rgb2gray(img);
img=im2double(imread('input2.bmp'));
img=imresize(img,2,'bicubic');
% im_l_y = im_l_ycbcr(:, :, 1);
% im_l_cb = im_l_ycbcr(:, :, 2);
% im_l_cr = im_l_ycbcr(:, :, 3);

% set parameters
lambda = 0.2;                   % sparsity regularization
overlap = 4;                    % the more overlap the better (patch size 5x5)
up_scale = 2;                   % scaling factor, depending on the trained dictionary
maxIter = 20;                   % if 0, do not use backprojection

% load dictionary
load('0912dictionary.mat');
load('0912Dl.mat');
load('0912Dh.mat');
%% wavelet denoising
wname = 'bior3.5';
%wname='haar';

[LL_orig, LH_orig, HL_orig, HH_orig] = dwt2(img, wname);
LH_orig2=LH_orig;
HL_orig2=HL_orig;
HH_orig2=HH_orig;

%% LH
thr_LH= wthrmngr('dw2dcompGBL','rem_n0',LH_orig);
LH_orig(abs(LH_orig)<thr_LH)=0; 
im_l_ycbcr = rgb2ycbcr(LH_orig);
im_l_y = im_l_ycbcr(:, :, 1);
im_l_cb = im_l_ycbcr(:, :, 2);
im_l_cr = im_l_ycbcr(:, :, 3);

% image super-resolution based on sparse representation
[im_h_y] = ScSR(im_l_y, 2, Dh, Dl, lambda, overlap);
[im_h_y] = backprojection(im_h_y, im_l_y, maxIter);

% upscale the chrominance simply by "bicubic" 
[nrow, ncol] = size(im_h_y);
im_h_cb = imresize(im_l_cb, [nrow, ncol], 'bicubic');
im_h_cr = imresize(im_l_cr, [nrow, ncol], 'bicubic');

im_h_ycbcr = zeros([nrow, ncol, 3]);
im_h_ycbcr(:, :, 1) = im_h_y;
im_h_ycbcr(:, :, 2) = im_h_cb;
im_h_ycbcr(:, :, 3) = im_h_cr;
%im_h = ycbcr2rgb(uint8(im_h_ycbcr));
im_h = ycbcr2rgb(im_h_ycbcr);

LH = im_h;
%%  HL
thr_HL= wthrmngr('dw2dcompGBL','rem_n0',HL_orig);
HL_orig(abs(HL_orig)<thr_HL)=0; 
im_l_ycbcr = rgb2ycbcr(HL_orig);
im_l_y = im_l_ycbcr(:, :, 1);
im_l_cb = im_l_ycbcr(:, :, 2);
im_l_cr = im_l_ycbcr(:, :, 3);

% image super-resolution based on sparse representation
[im_h_y] = ScSR(im_l_y, 2, Dh, Dl, lambda, overlap);
[im_h_y] = backprojection(im_h_y, im_l_y, maxIter);

% upscale the chrominance simply by "bicubic" 
[nrow, ncol] = size(im_h_y);
im_h_cb = imresize(im_l_cb, [nrow, ncol], 'bicubic');
im_h_cr = imresize(im_l_cr, [nrow, ncol], 'bicubic');

im_h_ycbcr = zeros([nrow, ncol, 3]);
im_h_ycbcr(:, :, 1) = im_h_y;
im_h_ycbcr(:, :, 2) = im_h_cb;
im_h_ycbcr(:, :, 3) = im_h_cr;
%im_h = ycbcr2rgb(uint8(im_h_ycbcr));
im_h = ycbcr2rgb(im_h_ycbcr);

HL = im_h;
%% HH
thr_HH= wthrmngr('dw2dcompGBL','rem_n0',HH_orig);
HH_orig(abs(HH_orig)<thr_HH)=0; 
im_l_ycbcr = rgb2ycbcr(HH_orig);
im_l_y = im_l_ycbcr(:, :, 1);
im_l_cb = im_l_ycbcr(:, :, 2);
im_l_cr = im_l_ycbcr(:, :, 3);

% image super-resolution based on sparse representation
[im_h_y] = ScSR(im_l_y, 2, Dh, Dl, lambda, overlap);
[im_h_y] = backprojection(im_h_y, im_l_y, maxIter);

% upscale the chrominance simply by "bicubic" 
[nrow, ncol] = size(im_h_y);
im_h_cb = imresize(im_l_cb, [nrow, ncol], 'bicubic');
im_h_cr = imresize(im_l_cr, [nrow, ncol], 'bicubic');

im_h_ycbcr = zeros([nrow, ncol, 3]);
im_h_ycbcr(:, :, 1) = im_h_y;
im_h_ycbcr(:, :, 2) = im_h_cb;
im_h_ycbcr(:, :, 3) = im_h_cr;
%im_h = ycbcr2rgb(uint8(im_h_ycbcr));
im_h = ycbcr2rgb(im_h_ycbcr);

HH = im_h;

LL = imresize(LL_orig,2,'bicubic');
img_recovered = idwt2(LL, LH, HL, HH, wname);
%%
figure;
subplot(2,2,1);
imshow(img);
title('Image');
subplot(2,2,2);
imagesc(getWaveletImage(LL_orig, LH_orig2, HL_orig2, HH_orig2));
title('DWT');
subplot(2,2,3);
imagesc(getWaveletImage(LL_orig, LH_orig2, HL_orig2, HH_orig2));
title('denoising');
subplot(2,2,4);
imagesc(img_recovered);
title('Denoised Image');

%%
% level = 3;
% [C,S] = wavedec2(im_l_y,level,wname);
% thr = wthrmngr('dw2ddenoLVL','penalhi',C,S,3);
% sorh = 's';

%[XDEN,cfsDEN,dimCFS] = wdencmp('lvd',C,S,wname,level,thr,sorh);
%[H1,V1,D1] = detcoef2('all',C,S,1);
% [XDEN,cfsDEN,dimCFS] = wdencmp_h('lvd',C,S,wname,level,thr,sorh);
% [XDEN2,cfsDEN,dimCFS] = wdencmp_d('lvd',C,S,wname,level,thr,sorh);
% [XDEN3,cfsDEN,dimCFS] = wdencmp_v('lvd',C,S,wname,level,thr,sorh);

% [nrow, ncol] = size(XDEN);
% im_h_ycbcr = zeros([nrow, ncol, 3]);
% im_h_ycbcr(:, :, 1) = XDEN;
% im_h_ycbcr(:, :, 2) = im_l_cb;
% im_h_ycbcr(:, :, 3) = im_l_cr;
% im_h = ycbcr2rgb(uint8(im_h_ycbcr));
% 
% imshow(im_h);