%% Optimized mean2 filter for image using IntegralImage
%  Input: (image, filter_size)
% Output: mean filted image
function result = fast_mean2(varargin)
mat = varargin{1};
window = varargin{2};


result = mat;
siz = size(mat);

%% expand image to adapte conv_core size (using '0' pollicy not 'replicate')
if mod(window(1),2) ~= 0 && mod(window(2),2) ~= 0 %odd window
    expanded = padarray(mat,floor((window-[1 1])/2),0);
else%once even window
    expanded = padarray(mat,floor((window-[1 1])/2),0);
    s = size(expanded);
    if mod(window(1),2) == 0 && mod(window(2),2) ~= 0
        expanded(s(1)+1,:)= zeros(1,s(2));
        
    elseif mod(window(2),2) == 0 && mod(window(1),2) ~= 0
        expanded(:,s(2)+1)= zeros(s(1),1);
    else %even even
        expanded = padarray(expanded,[1 1],0,'post');
    end
end

%% Calculate IntegralImgae
expanded = integralImage(expanded);

%% Calculate mean in O(siz) time
for i=1:siz(1)
    for j=1:siz(2)
        result(i,j)=(expanded(i+window(1),j+window(2))+expanded(i,j)-expanded(i,j+window(2))-expanded(i+window(1),j))/(window(1)*window(2));
    end
end

end