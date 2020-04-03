function result=RidgeSegmentation(I,aggresive)
%% ridge segmentation method
% input: I-enhanced image of fingerprint, aggresive-control param for
% performance
% output: segmentation of fingerprint
newproc = CloseProc(I,[0 1 0;1 1 1;0 1 0]);
if aggresive
    newproc = CloseProc(newproc,[0 0 1 0 0;0 1 1 1 0;1 1 1 1 1;0 1 1 1 0;0 0 1 0 0]);
end
result = GeodesicDilation(~newproc,[0 1 0;1 1 1;0 1 0],I);
result = ~result;
end