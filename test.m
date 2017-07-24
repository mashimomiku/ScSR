img = imread('t1.bmp');
LL = imread('LL.bmp');
LH = imread('LH.bmp');
HL = imread('HL.bmp');
HH = imread('HH.bmp');

img_num = 1;
num_patch = 10;
patch_size = 5;
upscale = 2;

nper_img = zeros(1, img_num);
nper_img = floor(nper_img*num_patch/sum(nper_img));

nper_img (1) = prod(size(LL));

patch_num = nper_img(1);
[H1,L1] = sample_patches(LL, patch_size, patch_num, upscale);
[H2,L2] = sample_patches(LH, patch_size, patch_num, upscale);
[H3,L3] = sample_patches(HL, patch_size, patch_num, upscale);
[H4,L4] = sample_patches(HH, patch_size, patch_num, upscale);
Xh = [H1, H2, H3, H4];
%Xh2 = [H2, H3, H4];
Xl = [L1, L2, L3, L4];
%Xl2 = [L2, L3, L4];

patch_path = ['Training/rnd_patches_' num2str(patch_size) '_' num2str(num_patch) '_s' num2str(upscale) '.mat'];
save(patch_path, 'Xh', 'Xl');