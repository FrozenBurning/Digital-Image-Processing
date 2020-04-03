function gauss=gauss_conv2_core(varargin)
    s = varargin{1};
    std = varargin{2};
    
    [x,y]=meshgrid(-floor(s(2)/2):floor(s(2)/2),-floor(s(1)/2):floor(s(1)/2));
    
    gauss = exp(-(x.*x+y.*y)/(2*std*std));
    
    gauss_sum = sum(gauss(:));
    if gauss_sum ~= 0 
        gauss = gauss/gauss_sum;
    end
end