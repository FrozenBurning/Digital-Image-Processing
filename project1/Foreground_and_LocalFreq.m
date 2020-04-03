function [frequency,newI]=Foreground_and_LocalFreq(I,w,arm_inf,arm_sup,threshold)
%% get frequency map and acquire foreground
% Input: I-original image, w-windows size
% Output: local frequency, also background masked I

%% blocks-from seperated blocks
blocks = seperated_into_blocks(I,w);
I = padarray(I,[w/4 w/4],'replicate','pre');
I = padarray(I,[w/2 w/2],'replicate','post');


%% foreground acquisition
figure(1),imshow(I);
block_x = blocks{1};
block_y = blocks{2};
frequency = nan(length(block_x), length(block_y));
newI = false(size(frequency));
for i = 1 : length(block_x)
    for j = 1 : length(block_y)
        fingerprint_region = 0;
        
        u = block_x(i); %central
        v = block_y(j); %central
        hot_block = I((u-w/4):(u+w*3/4-1), (v-w/4):(v+w*3/4-1));


        region_magnitude = abs(fftshift(fft2(hot_block)));

                
%         if i == 48
%             figure(2),imshow(hot_block);
%             figure(3),imshow(log(region_magnitude),[]);
%         end
        
        region_magnitude(region_magnitude == max(region_magnitude(:))) =  0; %delete DC
        [mag,index]=sort(region_magnitude(:),'descend');

        % iteration to find sine wave pattern wanted
        for k=1:10
            [p1_x,p1_y] = ind2sub(size(region_magnitude),index(k));
            [p2_x,p2_y] = ind2sub(size(region_magnitude),index(k+1));
            centralgap = [(p1_x+p2_x)/2-17,(p1_y+p2_y)/2-17];
            arm = abs(p1_x-17)+abs(p1_y-17);
            if mag(k) == mag(k+1) & mag(k)>80
                if (abs(centralgap(:)) < 1) & arm > arm_inf & arm < arm_sup  & mag(k+1)/mag(k+2) > threshold %modified needed
                    %finger-print region
                    fingerprint_region = 1;
                    break;
                end
            end
        end
        
        %% calculate frequency map
        if(fingerprint_region)
            newI(i,j) = true;
            
            peak = find(region_magnitude == max(region_magnitude(:))); % find freq peak
            k = 0;
            while length(peak) ~= 2 && k<3
                peak = find(region_magnitude == max(region_magnitude(:))); % find freq peak
                k = k+1;
            end
            if k == 3
                frequency(i, j) = 2;
                continue;
            end
            dy = mod(peak(1), w) - mod(peak(2), w);
            dx = ceil(peak(1)/w) - ceil(peak(2)/w);
            frequency(i, j) = sqrt(dy^2 + dx^2);
            if frequency(i, j) < 2
                frequency(i, j) = 2;
            end
        else
            % non-fingerprint region
            newI(i,j)=false;
            frequency(i,j) = 2; %frequency sets 2 to avoid issue in use of gabor filter
        end
        
    end
end

%% low pass smooth filter
    frequency = Freq_smooth_filter(frequency, 7); % apply LPF
    newI = Freq_smooth_filter(newI,6);
%     imshow(newI);
end

function SmoothFreq = Freq_smooth_filter(Freq, w)
    kernel = fspecial('gaussian', w,30);
    SmoothFreq = imfilter(Freq, kernel, 'replicate');
end