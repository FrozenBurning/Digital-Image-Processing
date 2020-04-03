function result=FillHoles(I)
%% fill white holes, also remove outliers
% input: I-segmentation from fingerprint image
% output:segmentation without holes and outliers
[M, N] = size(I);
tmpI = padarray(I,[1 1],'replicate','both');
m = 1;
n = 1;
for i=(1+m):(M+m)
    for j = (1+n):(N+n)
        spot = tmpI(i-m:i+m,j-n:j+n);
        if tmpI(i,j) == 1
            if sum(spot(:)) <= 4 % fill white holes
                tmpI(i,j) = 0;
            end
        else
            if sum(spot(:)) >= 5 %remove black outliers
                tmpI(i,j) = 1;
            end
        end
    end
end
result = tmpI(1+m:M+m,1+n:N+n);
end