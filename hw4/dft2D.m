function result=dft2D(image)

s = size(image);

% image=padarray(image,size(image),0,'post');

[M_x,M_y]=meshgrid(0:s(2)-1,0:s(2)-1);
[N_x,N_y] = meshgrid(0:s(1)-1,0:s(1)-1);

G_M = exp(-1i*2*pi*(M_x.*M_y)/s(2));
G_N = exp(-1i*2*pi*(N_x.*N_y)/s(1));

result = G_N * image * G_M;

for w = 1:s(1)
    for h = 1:s(2)
        if abs(result(w,h))<10^-9
           result(w,h)=0; 
        end
    end
end

%     for u=0:(s(2)-1)
%         for v = 0:(s(1)-1)
%
% %             tmp = image.*exp(-(1i*2*pi)*(u*x/s(2)+v*y/s(1)));
%
% %              tmp = image.*cos(2*pi*(u*x/s(2)+v*y/s(1)))-1i*image.*sin(2*pi*(u*x/s(2)+v*y/s(1)));
% %             result(v+1,u+1) = sum(tmp(:));
%         end
%     end

end