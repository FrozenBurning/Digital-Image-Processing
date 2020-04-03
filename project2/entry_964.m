I = imread('r96_4.bmp');
I = histeq(I);
I = imbinarize(I,0.48);

seg = RidgeSegmentation(I,false);

% fill white holes and remove outliers
I1 = FillHoles(seg);
%thin
I2 = ~bwmorph(~I1,'thin',5);
%detect raw feature
feature = FeatureDetect(I2);
%refine image accrording to feature
newI1 = NeighborPostProc(feature,I1);

%thin the refined image
newI2 = ~bwmorph(~newI1,'thin',5);

%redetect feature
newfeature = FeatureDetect(newI2);

%refine again in case some bridge cannot removed once
newI1 = NeighborPostProc(newfeature,newI1);
%remove several outliers
newI1 = FillHoles(newI1);

%rethin
newI2 = ~bwmorph(~newI1,'thin',5);
FinalFeature = EndValidation(newI1,FeatureDetect(newI2));
ShowFeature(FinalFeature,newI2,99);

figure(1),imshow(I);
figure(2),imshow(newI1);
figure(3),imshow(newI2);