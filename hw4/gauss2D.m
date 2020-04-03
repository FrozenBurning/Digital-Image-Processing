function result=gauss2D(sigma,siz)
if nargin < 2
    siz = [256 256];
end

    [x,y]=meshgrid(-floor(siz(2)/2):floor(siz(2)/2)-1,-floor(siz(1)/2):floor(siz(1)/2)-1);
    
    result = exp(-(x.*x+y.*y)/(2*sigma*sigma)); 
end