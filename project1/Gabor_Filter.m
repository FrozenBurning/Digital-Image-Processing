function result = Gabor_Filter(I,F,O,w,mask)
%% Gabor Filter 
% input: original image-I,freq map-F,orientation map-O,windows
% size-w,fingerprintRegion-mask
% output: enhanced fingerprint image
blocks = seperated_into_blocks(I,w);
oris = size(I);
I = padarray(I,[w/4 w/4],'replicate','pre');
I = padarray(I,[w/2 w/2],'replicate','post');

s = size(I);

block_x = blocks{1};
block_y = blocks{2};
result = zeros(s);

overlap = zeros(s);

%% perform gabor filter to each 32x32 region
for i = 1:length(block_x)
    for j = 1:length(block_y)
        if mask(i,j)
            u = block_x(i);
            v = block_y(j);
            hot_block = I((u-w/4):(u+w*3/4-1), (v-w/4):(v+w*3/4-1));
            
            %frequency equal to wavelength in my algorithm
            [magnitude, phase] = imgaborfilt(hot_block,F(i,j),O(i,j)*180/pi);
            tmp = magnitude .*cos(phase);
            tmp = normalization(tmp,0.5,1);
            result((u-w/4):(u+w*3/4-1), (v-w/4):(v+w*3/4-1)) = result((u-w/4):(u+w*3/4-1), (v-w/4):(v+w*3/4-1)) + tmp; 
            %calc overlap
            overlap((u-w/4):(u+w*3/4-1), (v-w/4):(v+w*3/4-1)) = overlap((u-w/4):(u+w*3/4-1), (v-w/4):(v+w*3/4-1)) + ones(w);
        end
    end
end

%% average smoothening based on overlap
result = result ./ overlap;
result = result(w/4+1:w/4+oris(1),w/4+1:w/4+oris(2));
end