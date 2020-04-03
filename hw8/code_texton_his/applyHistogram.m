function samples_hist = applyHistogram(samples_cluster)
% apply histogram for each image in the sample
% input is the sample
% output is the histogram result

% replace it with your implementation
if iscell(samples_cluster)
    siz = size(samples_cluster,1);
    samples_hist.data = cell(siz,1);
    samples_hist.hist = cell(siz,1);
    for i=1:siz
        tmp = samples_cluster{i};
        samples_hist.data{i} = tmp;
        bincount = zeros(1,max(tmp(:)));
        for j = 1:length(bincount)
           bincount(j) =  sum(tmp(:)==j);
        end
        samples_hist.hist{i} = bincount;
    end
else
    
    siz = size(samples_cluster,1)/(480*640);
    samples_hist.data = cell(siz,1);
    samples_hist.hist = cell(siz,1);
    for i=1:siz
        tmp = samples_cluster(480*640*(i-1)+1:480*640*i,:);
%         h =  histogram(tmp);
        samples_hist.data{i} = tmp;
        bincount = zeros(1,max(tmp(:)));
        for j = 1:length(bincount)
           bincount(j) =  sum(tmp(:)==j);
        end
        samples_hist.hist{i} = bincount;
    end
end