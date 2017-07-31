%im_l = imread('LLlena.bmp');
%im_LH = imread('LHlena.bmp');
%im_HL = imread('HLlena.bmp');
%im_HH = imread('HHlena.bmp');

im_l = imread('input.bmp');

% set parameters
lambda = 0.2;                   % sparsity regularization
overlap = 4;                    % the more overlap the better (patch size 5x5)
up_scale = 2;                   % scaling factor, depending on the trained dictionary
maxIter = 20;                   % if 0, do not use backprojection

% load dictionary
load('reg_sc_b512_20170731T141235.mat');
load('Dl.mat');
load('Dh.mat');

im_l = imresize(im_l ,2, 'bicubic');

im_l2 = im2double(im_l);
[LL_orig, LH_orig, HL_orig, HH_orig] = dwt2(im_l2, 'haar');
%LL_orig = uint8(LL_orig);
%LH_orig = uint8(LH_orig);
%HL_orig = uint8(HL_orig);
%HH_orig = uint8(HH_orig);

%% change color space, work on illuminance only  LL
im_l_ycbcr = rgb2ycbcr(LL_orig);
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

LL = im_h;
%% change color space, work on illuminance only  LH
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
%% change color space, work on illuminance only  HL
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
%% change color space, work on illuminance only  HH
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
%%
%LL = imresize(LL_orig, 2, 'bicubic');
%LH = imresize(LH_orig, 2, 'bicubic');
%HL = imresize(HL_orig, 2, 'bicubic');
%HH = imresize(HH_orig, 2, 'bicubic');

img_recovered = idwt2(LL, LH, HL, HH, 'haar');
SRimg = imresize( img_recovered, 0.5, 'bicubic');

