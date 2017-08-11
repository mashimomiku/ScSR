%im_l=imread('Data/noise.bmp');
%img=rgb2gray(img);
im_l=im2uint8(LL2);
im_l_ycbcr = rgb2ycbcr(im_l);
im_l_y = im_l_ycbcr(:, :, 1);
im_l_cb = im_l_ycbcr(:, :, 2);
im_l_cr = im_l_ycbcr(:, :, 3);


%% wavelet denoising
wname = 'bior3.5';
%wname='haar';
level = 3;
[C,S] = wavedec2(im_l_y,level,wname);
thr = wthrmngr('dw2ddenoLVL','penalhi',C,S,3);
sorh = 's';
[XDEN,cfsDEN,dimCFS] = wdencmp('lvd',C,S,wname,level,thr,sorh);

%%
figure;
subplot(1,2,1);
imshow(im_l); %axis off;
title('Noisy Image');
subplot(1,2,2);
imagesc(XDEN); colormap gray; axis off;
title('Denoised Image');

%%
[nrow, ncol] = size(XDEN);
im_h_ycbcr = zeros([nrow, ncol, 3]);
im_h_ycbcr(:, :, 1) = XDEN;
im_h_ycbcr(:, :, 2) = im_l_cb;
im_h_ycbcr(:, :, 3) = im_l_cr;
im_h = ycbcr2rgb(uint8(im_h_ycbcr));

imshow(im_h);