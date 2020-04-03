%% Fast gauss filter2D
% Input: (image, gauss_core_size, sigma)
% Output: filted image
function result=fast_gauss_filter(varargin)
    mat = varargin{1};
    siz = varargin{2};
    sigma = varargin{3};
   
    outsiz = size(mat);
    h = gauss_conv2_core(siz,sigma);
    %% expand image to adapte conv_core size (using 'replicate' pollicy smooth boundary)
    if mod(siz(1),2) ~= 0 && mod(siz(2),2) ~= 0 %odd window
        expanded = padarray(mat,floor((siz-[1 1])/2),'replicate');
    else%once even window
        expanded = padarray(mat,floor((siz-[1 1])/2),'replicate');
        s = size(expanded);
        if mod(siz(1),2) == 0 && mod(siz(2),2) ~= 0
            expanded(s(1)+1,:)= zeros(1,s(2));
            
        elseif mod(siz(2),2) == 0 && mod(siz(1),2) ~= 0
            expanded(:,s(2)+1)= zeros(s(1),1);
        else %even even
            expanded = padarray(expanded,[1 1],'replicate','post');
        end
    end
    
    if ~isfloat(expanded)
        expanded = double(expanded);
    end
    
%% do FFT for efficiency
    fftsize= size(expanded);
    expanded = ifft2( fft2(expanded) .* fft2(h, fftsize(1), fftsize(2)), 'symmetric' );
    
    % crop image
    start = 1+size(expanded)-outsiz;
    stop = start+outsiz-1;
    
    result=expanded(start(1):stop(1),start(2):stop(2));
    
    % type trans
    result = cast(result,'uint8');
end