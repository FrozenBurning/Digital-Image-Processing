function fb = makeFilterbank
% Make filter bank. It is convinient to represent this as a [N N 8] array.
hsize = 49;
% Random filterbank. You should replace this with your implementation.
fb = zeros([hsize hsize 16]);

SCALES=sqrt(2).^[1:4];
prewitt_f=fspecial('prewitt');
count=1;
for i=1:length(SCALES)
    fb(:,:,count)=normalise(fspecial('log',hsize,SCALES(i)));
    fb(:,:,count+1)=normalise(fspecial('log',hsize,3*SCALES(i)));
    fb(:,:,count+2)=normalise(fspecial('gaussian',hsize,SCALES(i)));
    fb(:,:,count+3)=normalise(conv2(fb(:,:,count+2),prewitt_f,'same'));
    count = count+4;
end


function f=normalise(f), f=f-mean(f(:)); f=f/sum(abs(f(:))); return