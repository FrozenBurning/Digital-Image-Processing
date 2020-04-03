%% sudoku function
% Input: image path
% Output: 9 sudoku images with mask on 

function sudoku(imgpath)
%% read image and resize
if(nargin < 1)
   imgpath = strcat(cd,'/greathall.jpg'); 
end
if ischar(class(imgpath))
    target = imread(imgpath);
    mask = imread('thumask.png');
    s = size(target);    
    target = target(:,s(2)/2-s(1)/2+1:s(2)/2+s(1)/2,:);
    s = size(target);
    mask = imresize(mask,s(1:2),'bicubic');

    %% process target image with mask
    for i = 1:s(1)
        for j = 1:s(2)
            if (i-346)*(i-346)+(j-345)*(j-345) >110700
               target(i,j,:) = [255,255,255]; 
            end
            if mask(i,j,1) < 200 
                target(i,j,:) = [255,255,255];
            end
            
        end
    end

    %% divide target image into 9 images
    gap = s (1)/3;
    
    part = target(1:gap-1,1:gap-1,:);
    imwrite(part,'1.jpg');
        part = target(gap:2*gap-1,1:gap-1,:);
    imwrite(part,'4.jpg');
        part = target(2*gap:s(1),1:gap-1,:);
    imwrite(part,'7.jpg');
    part = target(1:gap-1,gap:2*gap-1,:);
    imwrite(part,'2.jpg');
        part = target(gap:2*gap-1,gap:2*gap-1,:);
    imwrite(part,'5.jpg');
        part = target(2*gap:s(1),gap:2*gap-1,:);
    imwrite(part,'8.jpg');
        part = target(1:gap-1,2*gap:s(2),:);
    imwrite(part,'3.jpg');
        part = target(gap:2*gap-1,2*gap:s(2),:);
    imwrite(part,'6.jpg');
        part = target(2*gap:s(1),2*gap:s(2),:);
    imwrite(part,'9.jpg');
    
    imshow(target);
end
end