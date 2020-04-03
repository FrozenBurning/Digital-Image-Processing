function result = NeighborPostProc(feature,I)
%% neighborhood morphology method based on feature points
% input: feature-sparse feature points, I-segmentation of fingerprint
% output: segmentation of fingerprint without bridges, outliers,
% unreasonable enhancement
% proc on 9x9 neighborhood
[M, N] = size(feature);
tmpf = padarray(feature,[4 4],'replicate','both');

% imp = [1 1 1 1 1;0 1 1 1 0;1 1 1 1 1;0 1 1 1 0;1 1 1 1 1];
%dilate core
imp = [1 1 1;1 1 1;1 1 1];
result = I;
m = 4;
n = 4;
for i=(1+m):(M+m)
    for j = (1+n):(N+n)
        neighbor = tmpf(i-m:i+m,j-n:j+n);
        if neighbor(5,5) == 128 %ending point
            neighbor(5,5) = 255;%temporarily put it into 255 to keep it from searching that followed
            tmp = find(neighbor ~= 255); % find both ending points and bifurcation points
        else
            continue;
        end
        
        if size(tmp) ~=0 % find feature pairs that too close,size supposed to be 1
            % assume size(tmp) ==1
            [x,y]=ind2sub(size(neighbor,1),tmp(1));
            x = x-5;
            y = y-5;
            %re dilate
            I(i-m,j-n) = 1;
            I(i-m+x,j-n+y) = 1;
            result(min(i-m,i-m+x):max(i-m,i-m+x),min(j-n,j-n+y):max(j-n,j-n+y))=Dilate...
                (I(min(i-m,i-m+x):max(i-m,i-m+x),min(j-n,j-n+y):max(j-n,j-n+y)),imp);
        end
        
        
    end
end


end