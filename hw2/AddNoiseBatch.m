%% AddNoiseBatch Function

% Input: folder's path to be scanned for .jpg file

% Output: .bmp files with guass noise

function AddNoiseBatch(folderpath)
%% default parameter
if(nargin < 1)
   folderpath = cd;
end
%% to avoid non-string input
if ischar(class(folderpath))
    if folderpath(end) ~= '/'
        folderpath = [folderpath,'/'];
    end
    %% scan in the folder for jpg files
    filelist = dir(strcat(folderpath,'*.jpg'));
    
    %% processing each .jpg
    for iter = 1:length(filelist)
        name = filelist(iter);
        
        %% read I1
        I1 = imread(name.name);
        imshow(I1);
        %% generate I2
        if ndims(I1) > 1
            I2 = rgb2gray(I1);
        end
        
        %% resize I2 into I3
        I3 = imresize(I2,[nan,1000],'bicubic');
        I3 = im2double(I3);
        
        
        %% mean = 0, stdDeviation = 1 guass noise
        guass = 0+1*randn(size(I3));
        
        I4 = guass + I3;
        I4 = imadjust(I4);
        
        %% show 3 image in one figure with subplots
        figure(iter);
        img_show(1) = subplot(1,3,1);
        imshow(I3);
        img_show(2) = subplot(1,3,2);
        imshow(guass);
        img_show(3) = subplot(1,3,3);
        imshow(I4);
        linkaxes(img_show,'xy');
        imwrite(I4,strcat(name.name(1:end-4),'.bmp'));
    end
    
    hold on;
end
end