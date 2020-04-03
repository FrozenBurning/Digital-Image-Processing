function result=remove_dotted_bg(f,p,D0,n)
%% remove dotted background for 3.bmp
% input: image-f,points wanted for notch filter-p, std2-D0, rank-n

% points position are obtained using matlab GUI, shown below
% p=[54 427; 236 48; 427 615; 610 236;984 423;1357 611;1168 45;1541 232]
% D0=50
% n=3


f = im2double(f);
[M,N] = size(f);
P = max(2*[M N]);% Padding size. 
F = fftshift(fft2(f,P,P));

% Creat 4 pairs of notch reject filters

H = ones(P,P);
[DX, DY] = meshgrid(1:P);
siz = size(p);
for k = 1:siz(1)
    Dk1 = sqrt((DX-p(k,1)).^2+(DY-p(k,2)).^2);
    Dk2 = sqrt((DX-P-2+p(k,1)).^2+(DY-P-2+p(k,2)).^2);
    H1 = 1./(1+(D0./Dk1).^(2*n));
    H2 = 1./(1+(D0./Dk2).^(2*n));
    H = H.*H1.*H2;
end

% Filtering
G = H.*F;
result = real(ifft2(ifftshift(G)));
result = result(1:M,1:N);
end
