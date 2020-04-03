function result=Erode(I,core)
%% basic morphology method
[M, N] = size(I);
result = 0;
sizm = size(core,1);
sizn = size(core,2);
% only process odds*odds core
if mod(sizm,2) == 0 || mod(sizn,2) ==0
    warning('input core size must be odds!');
    return 
end

flag = sum(core(:));
result = I;
m =floor(sizm/2);
n = floor(sizn/2);
tmpI = padarray(I,[m n],'replicate','both');
for i=(1+m):(M+m)
    for j = (1+n):(N+n)
        spot = tmpI(i-m:i+m,j-n:j+n);
        spot = spot .* core;
        if sum(spot(:)) < flag
            result(i-m,j-n) = 0;
        else
            result(i-m,j-n) = 1;
        end
    end
end
end
