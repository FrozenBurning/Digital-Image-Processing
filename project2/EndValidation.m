function result=EndValidation(Seg,feature)
%% validate feature points
% input: seg-segmentation, feature-sparse raw feature points
% output: validated feature points
Seg = ~Seg;
[M, N] = size(feature);
tmpI = padarray(Seg,[15 15],'replicate','both');
m = 15;
n = 15;
% neighborhood search
for i=(1+m):(M+m)
    for j = (1+n):(N+n)
        if feature(i-m,j-n) == 0 %ending points
            spot = tmpI(i-m:i+m,j-n:j+n);
            %remove unvalid ending point
            if sum(spot(:)) < 400 %param needed modified
                feature(i-m,j-n) = 255;
            end
            
        end
        
    end
end
result = feature;

end