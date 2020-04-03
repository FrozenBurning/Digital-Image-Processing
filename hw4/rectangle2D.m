function result=rectangle2D(angle,centre,ratio,width,imgsiz)
if nargin<5
   imgsiz = [256 256];
end
    
    window = [width*ratio width];
    result = zeros(imgsiz);
    [X, Y] = meshgrid(1:window(2),1:window(1));
    X = X - floor(window(2)/2);
    Y = Y - floor(window(1)/2);
    cos_rot = cos(angle);
    sin_rot = sin(angle);
    newX = floor(centre(2) + cos_rot*X - sin_rot*Y);
    newY = floor(centre(1) + sin_rot*X + cos_rot*Y);
    
    for i=1:window(2)
        for j = 1:window(1)
            result(newX(j,i),newY(j,i)) = 1;
        end
    end
    
    se =strel('square',2);
    result = imdilate(result,se);
    
    
    
end