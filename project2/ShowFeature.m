function ShowFeature(feature,thin,index)
%% showfeature on thined fingerprint image
% input: index-figure(index), feature-sparse feature points
% image,thin-thined fingerprint image
figure(index),imshow(thin,[]);
EndsList  = find(feature == 0);
FrucList = find(feature == 128);

siz = size(feature);

for i = 1:size(EndsList)
   tmp = EndsList(i);
   [centrex,centrey] = ind2sub(siz,tmp);
   rectangle('Position',[centrey-3,centrex-3,6,6],'EdgeColor','r','LineWidth',1);
end


for i = 1:size(FrucList)
   tmp = FrucList(i);
   [centrex,centrey] = ind2sub(siz,tmp);
   rectangle('Position',[centrey-3,centrex-3,6,6],'EdgeColor','b','LineWidth',1);
end


end