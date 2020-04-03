function result = normalization(I, M, VAR)
%% normalize image with desired mean and var
% input: input image-I, desired mean-M, desired variance-VAR
% output: normalized image
    result = M + (I - mean(I(:))) * sqrt(VAR) / sqrt(var(I(:)));
end