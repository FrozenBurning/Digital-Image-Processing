function samples_res = applyFilterbank(train_samples,fb)
% apply Filter into the images of the sample,
% input is the images sample and filter bank
% output is the filter respons of the images sample
siz = size(train_samples.class,1);
samples_res = cell(siz,1);

for i=1:siz
    samples_res{i} = zeros([480 640 size(fb,3)]);
end

% replace it with your implementation
for j=1:siz
    if siz > 5
        img = imread(strcat('../data/uiuc_texture/test_data/',train_samples.image{j}));
    else
        img = imread(strcat('../data/uiuc_texture/train_data/',train_samples.image{j}));
    end
    for i=1:8
        samples_res{j}(:,:,i) = imfilter(img,fb(:,:,i));
    end
end



