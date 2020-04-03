function result=sine2D(angle,freq,phi,siz)
if nargin<4
   siz = [256 256]; 
end
    [X,Y]=meshgrid(1:siz(1),1:siz(2));
    result = cos(2*pi*freq*(cos(angle)*X+sin(angle)*Y+phi));
    
end