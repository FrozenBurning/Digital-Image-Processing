function carton_img=carton_trans(img)
    filted = imbilatfilt(img,100,20);
    grad = 1-edge((rgb2gray(img)),'canny',[0.05,0.1]);
    carton_img = filted.*(uint8(repmat(grad,[1,1,3])));
end