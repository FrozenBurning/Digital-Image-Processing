function visualizeHistogram(samples_hist)
% visualize histogram result of the samples
figure(50);
for i=1:5
   subplot(1,5,i),histogram(samples_hist.data{i});
end