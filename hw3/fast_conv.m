%% Fast conv function that is space consuming
% Input: (image,filter_size,filter,mode)
% Output: filted image
function result=fast_conv(varargin)
mat = varargin{1};
window = varargin{2};
fun = varargin{3};
mode = varargin{4};%1 for small_mat, 0 for large_mat

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

%% mode for small image (time consuming)
result=zeros(size(mat));
if mode
    s = size(mat);
    core = ones(window)/(window(1)*window(2));
    for i=1:s(1)
        for j=1:s(2)
            tmp = expanded(i:i+window(1)-1,j:j+window(2)-1).*core;
            result(i,j)= sum(tmp(:));
        end
    end
    
%% mode for large image (space consuming)
else
    window2vector = im2col(expanded,window);
    
    
    for i = 1:numel(mat)
        result(i)=fun(window2vector(:,i));
    end
    
    result = reshape(result,size(mat));
end
end