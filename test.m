addpath(genpath('RegularizedSC'));
TR_IMG_PATH = 'Data/Training3';

dict_size   = 250;          % dictionary size
lambda      = 0.15;         % sparsity regularization
patch_size  = 5;            % image patch size
num_patch   = 10000;       % number of patches to sample
upscale     = 2;            % upscaling factor

img_dir = dir(fullfile(TR_IMG_PATH, '*.bmp'));

Xh = [];
Xl = [];

img_num = length(img_dir);
nper_img = zeros(1, img_num);

for ii = 1:110,            %length(img_dir),
    %im = imread(fullfile(img_path, type));
    im = imread(strcat('Data/Training3/t',num2str(ii),'.bmp'));
    %im = imread(fullfile(img_path, img_dir(ii).name));
    nper_img(ii) = prod(size(im));
end

nper_img = floor(nper_img*num_patch/sum(nper_img));

for ii = 1:110,    %img_num,
    patch_num = nper_img(ii);
    im = im2double(imread(strcat('Data/Training3/t',num2str(ii),'.bmp')));
    [LL, LH, HL, HH] = dwt2(im, 'haar');
    imwrite(LL,['Data/Training2/tLL',num2str(ii),'.bmp']);
    imwrite(LH,['Data/Training2/tLH',num2str(ii),'.bmp']);
    imwrite(HL,['Data/Training2/tHL',num2str(ii),'.bmp']);
    imwrite(HH,['Data/Training2/tHH',num2str(ii),'.bmp']);
    LL = imread(strcat('Data/Training2/tLL',num2str(ii),'.bmp'));
    LH = imread(strcat('Data/Training2/tLH',num2str(ii),'.bmp'));
    HL = imread(strcat('Data/Training2/tHL',num2str(ii),'.bmp'));
    HH = imread(strcat('Data/Training2/tHH',num2str(ii),'.bmp'));
    
    im = [LL, LH, HL, HH];
    im2 =[LL; LH; HL; HH];
    
    [H, L] = sample_patches(im2, patch_size, patch_num, upscale);
    Xh = [Xh, H];
    Xl = [Xl, L];
end

patch_path = ['Training/rnd_patches_' num2str(patch_size) '_' num2str(num_patch) '_s' num2str(upscale) '.mat'];
save(patch_path, 'Xh', 'Xl');

%%
[Xh, Xl] = patch_pruning(Xh, Xl, 10);


%% joint sparse coding 
[Dh, Dl] = train_coupled_dict(Xh, Xl, dict_size, lambda, upscale);
dict_path = ['Dictionary/D_' num2str(dict_size) '_' num2str(lambda) '_' num2str(patch_size) '.mat' ];
save(dict_path, 'Dh', 'Dl');

save('Dh.mat','Dh');
save('Dl.mat','Dl');