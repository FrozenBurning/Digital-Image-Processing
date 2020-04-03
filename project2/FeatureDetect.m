function result=FeatureDetect(I)
%% feature detect method
% input: I-thined fingerprint image
% output: sparse feature points
[M, N] = size(I);
tmpI = padarray(I,[1 1],'replicate','both');
m = 1;
n = 1;
result = ones(M,N)*255;
for i=(1+m):(M+m)
    for j = (1+n):(N+n)
        spot = tmpI(i-m:i+m,j-n:j+n);
        if spot(2,2) == 0 %central point has fingerprint
            %calc cross number
           CrossNum = (abs(spot(1,2)-spot(1,1))+abs(spot(1,3)-spot(1,2))+...
               abs(spot(2,3)-spot(1,3))+abs(spot(3,3)-spot(2,3))+...
               abs(spot(3,2)-spot(3,3))+abs(spot(3,1)-spot(3,2))+...
               abs(spot(2,1)-spot(3,1))+abs(spot(1,1)-spot(2,1)))/2;
           if CrossNum == 1
               result(i-m,j-n) = 0; % ending point
           elseif CrossNum ==3
               result(i-m,j-n) = 128; % bifurcation point
           end
           
        end

    end
end
end