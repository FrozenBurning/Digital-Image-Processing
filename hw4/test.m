% r = rectangle2D(0,[80 130],4,30);
r = impulse2D([133 128]);
% r= gauss2D(5,[256 256]);
% r = sine2D(36/180*pi,0.0271,0);


dftr = dft2D(r);
dftr = fftshift(dftr);
% dftr= dftr;

figure(1),imshow(log(abs(dftr)),[]);
figure(3),surf(log(abs(dftr(1:4:end,1:4:end))));

fftr = fft2(r);
fftr = fftshift(fftr);
% fftr = fftr*2;

figure(2),imshow(log(abs(fftr)),[]);
figure(4),surf(log(abs(fftr(1:4:end,1:4:end))));