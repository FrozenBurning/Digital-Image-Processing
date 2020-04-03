function result=gauss_seperated_filter(varargin)
    mat = varargin{1};
    siz = varargin{2};
    std=varargin{3};
    
    gauss_x = gauss_core(siz,std);
    gauss_y = gauss_core(siz,std);
    
    center = floor((siz+1) /2);
    temp = mat;
    result=mat;
    
    s=size(mat);
    
    %for x
    for i=1:s(1)
        for j=1:s(2)
            if (i>center -1) && (j > center -1) && (i < s(1)-center) && (j < s(2)-center)
                sum = 0.0;
                for l=1:siz
                   sum = sum + mat(i,j-l+center+1)*gauss_x(l);%check
                end
                temp(i,j)= max(min(sum,255),0);
            end
        end
    end
    
    %for y
    for i=1:s(1)
        for j=1:s(2)
            if (i>center -1) && (j > center -1) && (i < s(1)-center) && (j < s(2)-center)
                sum = 0.0;
                for l=1:siz
                   sum = sum+ temp(i-l+center+1,j)*gauss_y(l);
                end
                result(i,j)=max(min(sum,255),0);
            end 
        end
    end
    
end


function result=gauss_core(varargin)
    siz = varargin{1};
    std=varargin{2};

    result = zeros(1,siz);
    
    center = floor((siz+1)/2);
    
    sum = 0.0;
    
    for i=1:siz
       result(i) = exp(-(i-center)^2/(2*std*std));
       sum = sum + result(i);
    end
    
    if sum ~= 0 
        result = result/sum;
    end
end