function old_img=oldpic_trans(img)

I=double(img);
old_img=I;
old_img(:,:,1)=0.393*I(:,:,1)+0.769*I(:,:,2)+0.189*I(:,:,3);
old_img(:,:,2)=0.349*I(:,:,1)+0.686*I(:,:,2)+0.168*I(:,:,3);
old_img(:,:,3)=0.272*I(:,:,1)+0.534*I(:,:,2)+0.131*I(:,:,3);

end