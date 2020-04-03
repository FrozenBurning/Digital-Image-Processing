function orientation=LocalOrientation(I,w,filter_siz,sigma)
%% acquire orientation map
% Input: I-image, w-windows size, filter_siz- lpf filter size which used in
% smoothen orientation map,sigma-var of filter
% Output: local orientation

%% blocks-from seperated blocks
blocks = seperated_into_blocks(I,w);

I = padarray(I,[w/4 w/4],'replicate','pre');
I = padarray(I,[w/2 w/2],'replicate','post');

block_x = blocks{1};
block_y = blocks{2};
orientation = nan(length(block_x), length(block_y));

%% orientation map acquisition
for i =1:length(block_x)
    for j = 1:length(block_y)
        u = block_x(i);
        v = block_y(j);
        hot_block = I((u-w/4):(u+w*3/4-1), (v-w/4):(v+w*3/4-1));
%         if sum(hot_block(:)) == 0
%             continue; %mask
%         end
        
        region_magnitude = abs(fftshift(fft2(hot_block)));
        peak = find(region_magnitude == max(region_magnitude(:)));
        k = 0;
        
        
        while length(peak) ~= 2 && k<3
            region_magnitude(region_magnitude == max(region_magnitude(:))) =  0; % delete DC
            peak = find(region_magnitude == max(region_magnitude(:))); % find max freq
            k = k+1;
        end
        
        % only iter for 3 times, because there is assumption that the top-3
        % magnitude should be DC, sine_peak1,sine_peak2
        if k==3
            orientation(i,j) = pi/2;
            continue;
        end
        
        % using atan2 to calculate orientation 
        dy = mod(peak(1), w) - mod(peak(2), w);
        dx = ceil(peak(1)/w) - ceil(peak(2)/w);
        if dy < 0
            orientation(i,j) = pi-atan2(-dy,-dx);
        else
            orientation(i,j) = atan2(dy,-dx);
        end
    end
end

%% smoothen
orientation = ori_smooth_filter(orientation,filter_siz,sigma);

end

function SmoothOrientation = ori_smooth_filter(ori,w,sigma)
%% lpf smooth filter based on hint given by teacher

    kernel = fspecial('gaussian',[w w],sigma);
    tobeproc = ori*2;
    sine_phase = sin(tobeproc);
    cosine_phase = cos(tobeproc);
    
    sine_phase = imfilter(sine_phase,kernel,'replicate');
    cosine_phase = imfilter(cosine_phase,kernel,'replicate');
    SmoothOrientation = atan2(sine_phase,cosine_phase)/2;
    
end