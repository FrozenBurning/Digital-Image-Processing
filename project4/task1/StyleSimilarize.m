function result=StyleSimilarize(src,tar,mask)
    src = rgb2hsv(src);
    tar=rgb2hsv(tar);
    [h,w,c]=size(tar);
    idx = find(mask);
    src_reg1 = imhistmatch(src(idx),tar(idx),'Method','polynomial');
    src_reg2 = imhistmatch(src(idx+h*w),tar(idx+h*w),'Method','polynomial');
    src_reg3 = imhistmatch(src(idx+2*h*w),tar(idx+2*h*w),'Method','polynomial');
    tar(idx) = src_reg1;
    tar(idx+h*w) = src_reg2;
    tar(idx+2*h*w) = src_reg3;
    result=hsv2rgb(tar);    
end