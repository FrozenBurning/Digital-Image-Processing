function mask = hough_cirle(BW,sup_x,sup_y,xy_range,radius,r_range,delta_limit,generate_pupil)
%% hough transform to find circle in image
% INPUT: BW- Edge image, (sup_x,sup_y)-circle center, xy_range-circle
% center search range, radius-circle radius, r_range-circle radius range,
% delta_limit-control params, generate_pupil- if set non-zero value,
% generate pupil depends on given radius
% OUTPUT: mask-Iris image
if nargin < 8
    generate_pupil = 0;
end

%% init value
mask = false(size(BW));
[height,width] = size(BW);
totalnum=sum(sum(BW));
X=zeros(1,totalnum);
Y=zeros(1,totalnum);
k=0;

%% search for edge point in BW,convert into two vector
for x=1:width
    for y=1:height
        if BW(y,x)
            k=k+1;
            X(k)=x;
            Y(k)=y;
            if k==totalnum
                break;
            end
        end
    end
    if k==totalnum
        break;
    end
end

%% generate hough transform params
x_range_list=(sup_x:sup_x+xy_range-1)';
y_range_list=(sup_y:sup_y+xy_range-1)';

r_step=0.5; %search step for radius
count=0;
X_Max_list=[];
Y_Max_list=[];
Max_R=[];

%% search in hough space
for r=radius:r_step:radius+r_range
    count=count+1;
    votes=zeros(xy_range,xy_range);
    for k=1:totalnum 
        tmp=repmat(((x_range_list-X(k)).^2)',xy_range,1)+repmat((y_range_list-Y(k)).^2,1,xy_range);
        Difference=round(tmp-r^2);
        possible_ans=(Difference<delta_limit & Difference>-delta_limit);
        votes=votes+possible_ans;
    end
    maxVote=max(votes(:));
    [y_tmp_max,x_tmp_max]=find(votes==max(votes(:)));
    X_Max_list=[X_Max_list;x_tmp_max];
    Y_Max_list=[Y_Max_list;y_tmp_max];
    Max_R=[Max_R;maxVote];
end

result_radius=find(Max_R==max(Max_R));
R=radius+(result_radius-1)*r_step;

result_x=X_Max_list(result_radius)+sup_x;
result_y=Y_Max_list(result_radius)+sup_y;

%% generate mask, points locate in the circle should be set to 1
for i=1:size(BW,2)
    for j=1:size(BW,1)
        if (i-result_x)^2 + (j-result_y)^2 < R^2
            if generate_pupil ~= 0 
                if (i-result_x)^2 + (j-result_y)^2 < generate_pupil^2
                   continue; 
                end
            end
            mask(j,i) = 1;
        end
    end
end


end