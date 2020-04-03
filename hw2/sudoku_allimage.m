%% sudoku_allimage function
% Input: image folder path
% Output: 9 sudoku images with mask on 

function sudoku_allimage(folderpath)
%% read image and resize
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
    
    mask = imread('thumask.png');
    s = size(mask);
    
    %% generate 36 blocks
    result = mask;
    divided = mat2cell(result,[s(1)/6,s(1)/6,s(1)/6,s(1)/6,s(1)/6,s(1)/6],[s(2)/6,s(2)/6,s(2)/6,s(2)/6,s(2)/6,s(2)/6],3);
    block_size = size(divided{1});
    for iter = 1:length(filelist)
       name = filelist(iter).name;
       img = imread(name);
       tmp_size = size(img);
       %% cut to square
       if tmp_size(2)>tmp_size(1)
       img = img(:,tmp_size(2)/2-tmp_size(1)/2+1:tmp_size(2)/2+tmp_size(1)/2,:);
       else
          img = img(tmp_size(1)/2-tmp_size(2)/2+1:tmp_size(1)/2+tmp_size(2)/2,:,:); 
       end
       
       % resize and fit in one block
       img = imresize(img,block_size(1:2),'bicubic');
       divided{iter} = img;
       
    end
    %combine blocks
    result = cell2mat(divided);
    imshow(result);
    
    %% process target image with mask
    for i = 1:s(1)
        for j = 1:s(2)
            if (i-333)*(i-333)+(j-333)*(j-333) >106500
               result(i,j,:) = [255,255,255]; 
            end
            if mask(i,j,1) < 200 
                result(i,j,:) = [255,255,255];
            end
            
        end
    end
    
    imshow(result);

    %% divide target image into 9 images
    gap = s (1)/3;
    
    part = result(1:gap-1,1:gap-1,:);
    imwrite(part,'thu1.png');
        part = result(gap:2*gap-1,1:gap-1,:);
    imwrite(part,'thu4.png');
        part = result(2*gap:s(1),1:gap-1,:);
    imwrite(part,'thu7.png');
    part = result(1:gap-1,gap:2*gap-1,:);
    imwrite(part,'thu2.png');
        part = result(gap:2*gap-1,gap:2*gap-1,:);
    imwrite(part,'thu5.png');
        part = result(2*gap:s(1),gap:2*gap-1,:);
    imwrite(part,'thu8.png');
        part = result(1:gap-1,2*gap:s(2),:);
    imwrite(part,'thu3.png');
        part = result(gap:2*gap-1,2*gap:s(2),:);
    imwrite(part,'thu6.png');
        part = result(2*gap:s(1),2*gap:s(2),:);
    imwrite(part,'thu9.png');

end
end