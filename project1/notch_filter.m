function enhanced = notch_filter(I,Freq,Orient,w,mask)
%% ideal notch filter
% input: original image-I,freq map-F,orientation map-O,window
% size-w,foreground map-mask
% output: enhanced fingerprint image

%% seperate into blocks
blocks = seperated_into_blocks(I,w);
oris = size(I);
I = padarray(I,[w/4 w/4],'replicate','pre');
I = padarray(I,[w/2 w/2],'replicate','post');

s = size(I);
enhanced = zeros(s);
overlap = zeros(s);
block_x = blocks{1};
block_y = blocks{2};

%% perform notch filting to each 32x32 region 
for i=1:length(block_x)
    for j = 1:length(block_y)
        u = block_x(i);
        v = block_y(j);
        hot_block = I((u-w/4):(u+w*3/4-1), (v-w/4):(v+w*3/4-1));
        
        region_fft = fftshift(fft2(hot_block));
        
        region_magnitude = abs(region_fft);
        region_fft(region_magnitude == max(region_magnitude(:))) =  0+1i*0;%delete DC
        
        % notch filted
        filted_region = region_fft .* lpf(Freq(i,j)+1,Orient(i,j),w,mask(i,j));
        tmp = ifft2(ifftshift(filted_region));
        
        enhanced(u:(u+w/2-1), v:(v+w/2-1)) = enhanced(u:(u+w/2-1), v:(v+w/2-1)) + tmp((w/4+1):w*3/4,(w/4+1):w*3/4);
        %calc overlap
        overlap((u):(u+w*2/4-1), (v):(v+w*2/4-1)) = overlap((u):(u+w*2/4-1), (v):(v+w*2/4-1)) + ones(w/2);
        
%         enhanced((u-w/4):(u+w*3/4-1), (v-w/4):(v+w*3/4-1)) = enhanced((u-w/4):(u+w*3/4-1), (v-w/4):(v+w*3/4-1)) + tmp;
%         %enhanced(u:(u+w/4-1),v:(v+w/4-1))=tmp((1+w/4):w/2,(1+w/4):w/2);
%         overlap((u-w/4):(u+w*3/4-1), (v-w/4):(v+w*3/4-1)) = overlap((u-w/4):(u+w*3/4-1), (v-w/4):(v+w*3/4-1)) + ones(w);
    end
end

%% average smoothening based on overlap
enhanced = enhanced ./ overlap;
enhanced = enhanced(w/4+1:w/4+oris(1),w/4+1:w/4+oris(2));

end

function f=lpf(freq,orient,w,mask)
%% ideal notch filter core(two 3x3 region)
f = zeros(w,w);

% perform only to fingerprint
if mask
    tocenter = freq/2;
    % treat [17,17] as center in each 32x32 region
    p1 = [17-floor(tocenter*sin(orient)),17+ceil(tocenter*cos(orient))];
    p2 = [17+ceil(tocenter*sin(orient)),17-floor(tocenter*cos(orient))];
    
    f(p1(1)-1:p1(1)+1,p1(2)-1:p1(2)+1) = ones(3,3);
    f(p2(1)-1:p2(1)+1,p2(2)-1:p2(2)+1) = ones(3,3);

end
end