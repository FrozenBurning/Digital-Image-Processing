function painting_img=painting_trans(img)
    ks = adaptive_ks(img)+500;
    I = rgb2lab(img);
    L = SLIC_Proc(I,ks,32);
%     L = EnforceSupervoxelConnectivity(I,L);
    [M,N,Q]=size(I);
    I=img;
    for i = 1:max(L(:))
        idx = find(L==i);
        I(idx) = mean(I(idx));
        I(idx+M*N) = mean(I(idx+M*N));
        I(idx+2*M*N) = mean(I(idx+2*M*N));
    end
    
    painting_img = I;
end