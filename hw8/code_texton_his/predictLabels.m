function test_samples_labels = predictLabels(test_samples_hist,train_sample_hist)
% predict the labels of each image in the test sample according to the
% train sample histograms
% inputs are the test sample histograms and train sample histograms
% output is the label prediction result of the test samples
% personally I recommend function 'pdist2', you can learn more about the
% function by 'doc pdist2' or 'doc pdist2'

% replace it with your implementation
test_samples_labels.classId = zeros([25,1]);
for i=1:25
    dist = zeros(5,1);
    for j=1:5
        dist(j,1) = pdist2(train_sample_hist.hist{j},test_samples_hist.hist{i});
    end
    idx = find(dist == min(dist));
    test_samples_labels.classId(i,1) = idx;
end