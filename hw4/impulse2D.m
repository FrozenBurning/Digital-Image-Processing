function result=impulse2D(centre,siz)
if nargin < 2
   siz = [256 256];
   if nargin <1
      centre = [127 127]; 
   end
end
    result = zeros(siz);
    
    result(floor(centre(2)),floor(centre(1))) = 1;
end