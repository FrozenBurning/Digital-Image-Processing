function result=preproc_3(I)
%% pre-processing function for 3.bmp, feat: remove dotted background, remove noises, binarized
% input: image-I
% output: pre-processed image 

ori = I;
figure(99),imshow(I);
I = remove_dotted_bg(I,[54 427; 236 48; 427 615; 610 236;984 423;1357 611;1168 45;1541 232],50,3);

I = histeq(I);

figure(1),imshow(I);

smtI = medfilt2(I,[7 7]);

I=2*I-smtI;

smtI = imgaussfilt(I,10);

figure(2),imshow(smtI);
I=2*I-smtI;

figure(3),imshow(I);


FT_I =fftshift(fft2(I));

figure(4),subplot(1,2,2),imshow(log(abs(FT_I)),[]);
subplot(1,2,1),imshow(log(abs(fftshift(fft2(ori)))),[]);

[M1, N1] = size(I);
w = 160;
block_x = (0 : floor((M1-w)/w) ) * w + 1; % separating into blocks
block_y = (0 : floor((N1-w)/w) ) * w + 1;
J = I;
for i = 1 : length(block_x)
    for j = 1 : length(block_y)
        u = block_x(i); v = block_y(j);
        block_region = I(u:(u+w-1), v:(v+w-1));
        thresh = mean(block_region(:))-0.05;
        J(u:(u+w-1), v:(v+w-1)) = imbinarize(block_region, thresh);
    end
end
figure(2),imshow(J);

result = J;
end