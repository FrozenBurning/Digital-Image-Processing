function test_samples_cluster = predictClasses(test_samples_res,centers)
% predict the class of each pixel for all images responses in the sample according to
% the kmeans centers.
% inputs are the images responses sample and kmeans centers
% output is the cluster result of the sample
% personnally I recommend function 'pdist2', you can learn how to use it
% by 'doc pdist2' or 'help pdist2'

% replace it with your implementation
siz = size(test_samples_res,1);
test_samples_cluster = cell(siz,1);

for i=1:siz
    tmp = reshape(test_samples_res{i},[480*640 size(centers,2)]);
%     dist = pdist2(tmp,centers{ceil(i/5)});
    dist = pdist2(tmp,centers);
    [min_dist,index]=min(dist,[],2);
    test_samples_cluster{i} = index;
end
