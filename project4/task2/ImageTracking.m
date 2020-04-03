function ImageTracking(src_img,use_official_lib,use_hough)
hands = [0.96,0.2];
radius = 0.27;
%% start point
prev = rgb2gray(imread(strcat('./pics/',num2str(1),'.jpg')));
prev_points = detectSURFFeatures(prev);
[prev_feature,prev_points] = extractFeatures(prev,prev_points);
[h1,w1,c] = size(src_img);
p0 = [1 1;1 h1;w1 h1;w1 1];
%% 4 corner points
prev_x=[62;79;783;671];
prev_y=[150;896;806;108];

prev_location = [prev_x';prev_y';ones(1,4)];

%% main image tracking loop
for i=2:406
    %% read next frame
    cur_color = imread(strcat('./pics/',num2str(i),'.jpg'));
    cur = rgb2gray(cur_color);
    
    %%detect surf feature
    cur_points = detectSURFFeatures(cur);
    [cur_feature,cur_points] = extractFeatures(cur,cur_points);
    
    %% choose high quality feature points
    dist = pdist2(prev_feature,cur_feature);
    [sdist,ind] = sort(dist,2);
    ratio = sdist(:,1)./sdist(:,2);
    feat_threshold = 0.5;
    idx = find(ratio<feat_threshold);
    
    %% generate matching points
    point1 = prev_points.Location;
    point2 = cur_points.Location;
    match1 = [point1(idx,1) point1(idx,2) ones(size(idx))]';
    match2 = [point2(ind(idx),1) point2(ind(idx),2) ones(size(idx))]';
    ransac_threshold = 50;
    
    %% feature matching, compute transformation matrix
    if use_official_lib
        [hh,inlierPtsDistorted,inlierPtsOriginal] = estimateGeometricTransform(match1(1:2,:)',match2(1:2,:)','affine');
        cur_location = (hh.T)'*prev_location;
    else
        [hh, inliers] = ransacfithomography(match1, match2,size(idx,1), ransac_threshold);
        cur_location = hh*prev_location;
    end
    
    cur_location(3,:) = ones(1,4);
    
    %% transformation and refine the next position of 4 corners
    if use_hough
        % refinement based on houghlines
        if mod(i,2)==0 & i>200
            cur_loc = cur_location(1:2,:)';
            refined = HoughRefine(cur_loc,cur_color);
            error = sum(sum(abs(refined-cur_loc)));
            disp(error);
            if error < 70
                cur_location(1:2,:)=refined';
            end
        end
    else
        %refinement based on local gradient and it's direction
        dist = sum(sum((cur_location-prev_location).^2));
        neighbor_width = 15;
        if mod(i,1)==0
            if dist > 110 & dist < 200
                disp(dist);
                grad = edge(cur,'canny',0.2,2);
                [mag,grad]=imgradient(grad);
                for j=1:4
                    hot_x = floor(cur_location(1,j));
                    hot_y = floor(cur_location(2,j));
                    spot = grad(hot_y-neighbor_width:hot_y+neighbor_width,hot_x-neighbor_width:hot_x+neighbor_width);
                    max_grad = max(max(spot));
                    max_ind = find(spot==max_grad);
                    min_grad = min(min(spot));
                    min_ind = find(spot==min_grad);
                    if min_grad == 0
                        j = j-1;
                        neighbor_width = neighbor_width+2;
                        continue
                    end
                    [col_max,row_max]=ind2sub(size(spot),median(max_ind));
                    [col_min,row_min]=ind2sub(size(spot),median(min_ind));
                    offset = [(col_max+col_min)/2,(row_max+row_min)/2]-[neighbor_width+1 neighbor_width+1];
                    cur_location(2,j) = cur_location(2,j)+offset(1);
                    cur_location(1,j) = cur_location(1,j)+offset(2);
                    neighbor_width = 15;
                end
            end
        end
    end
    
    %% generate mask of area to be replaced
    mask=poly2mask(double(cur_location(1,:)),double(cur_location(2,:)),size(cur,1),size(cur,2));
    
    %% replacement with src img
    [h2,w2,c]=size(cur_color);
    
    % compute transformation matrix
    tform = fitgeotrans(p0,(cur_location(1:2,:))','projective');
    src_registered = imwarp(src_img,tform,'OutputView',imref2d(size(cur_color)));
    src_registered = rgb2hsv(src_registered);
    cur_color = rgb2hsv(cur_color);
    
    if i> 260
    D = (cur_color(:,:,1)-hands(1)).^2+(cur_color(:,:,2)-hands(2)).^2;
    local_mask1 = D<=radius*radius;
    
    Dm = (cur_color(:,:,1)-0.04).^2+(cur_color(:,:,2)-hands(2)).^2;
    local_mask2 = Dm<=radius*radius;
    mask = mask & ~(local_mask1|local_mask2);
    end
    % stylization 
    idx = find(mask);
    src_registered1 = imhistmatch(src_registered(idx),cur_color(idx),'Method','polynomial');
    src_registered2 = imhistmatch(src_registered(idx+h2*w2),cur_color(idx+h2*w2),'Method','polynomial');
    src_registered3 = imhistmatch(src_registered(idx+2*h2*w2),cur_color(idx+2*h2*w2),'Method','polynomial');
    cur_color(idx) = src_registered1;
    cur_color(idx+h2*w2) = src_registered2;
    cur_color(idx+2*h2*w2) = src_registered3;
    
    cur_color=hsv2rgb(cur_color);
    figure(2),imshow(cur_color)
    imwrite(cur_color,strcat('./outputs_nohand/',num2str(i),'.jpg'));
    %% step on
    prev = cur;
    prev_feature = cur_feature;
    prev_points = cur_points;
    prev_location = cur_location;
end
end

