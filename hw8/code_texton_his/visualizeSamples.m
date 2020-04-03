function visualizeSamples(samples_cluster)
% visualize the samples result
figure(99);
for i=1:5
%    tmp = samples_cluster{i};
    tmp = samples_cluster(480*640*(i-1)+1:480*640*i,:);
   tmp = reshape(tmp,[480 640]);
   subplot(1,5,i),imshow(tmp,[],'Colormap',jet(255));
%     figure(i),pcolor(tmp);
end