function [samples_cluster,centers] = applyKmeans(samples_res,k)
% apply kmeans algorithm to cluster all pixels into k classes.
% input are the samples responses and class numbers 
% output are the samples cluster result and kmeans centers
% personnally I recommand function 'kmeans', you can learn how 
% to use it by 'doc kmeans' or 'help kmeans'

% replace it with your implementation
% samples_cluster = zeros(480*640*5,1);
% centers = zeros(20,8);

data_base = [];
for i=1:5
   tmp = samples_res{i};
   tmp = reshape(tmp,[size(tmp,1)*size(tmp,2) size(tmp,3)]);
   data_base=[data_base;tmp];
end
   [idx,c]=kmeans(data_base,k,'MaxIter',1000);
   samples_cluster = idx;
   centers = c;