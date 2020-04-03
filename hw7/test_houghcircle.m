
raw_I = imread('eye1.jpg');
I = rgb2gray(raw_I);
% I = imgaussfilt(I,4.5);
I = imadjust(I,[0 0.8]);
% figure(3),plot(hisgram)
BW = edge(I,'canny',0.43,4);

IEdge = BW;
figure(1),imshow(BW);
figure(2),imshow(BW);
[height,width] = size(I);
totalnum=sum(sum(IEdge));
X=zeros(1,totalnum);
Y=zeros(1,totalnum);
k=0;

for x=1:width
    for y=1:height
        if IEdge(y,x)% 是轨迹点 一定要注意是y（行） x（列）
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

xpro_min=1080;
ypro_min=540;
range=20;
APRO=(xpro_min:xpro_min+range-1)';
BPRO=(ypro_min:ypro_min+range-1)';

fprintf('  2、半径长度在95左右，半径计算范围可缩小至85:105。\n');

r_min=155;
range2=20;

fprintf('\n Program paused. Press enter to continue.\n');
pause;

% 求解二元隐函数非常非常复杂。我们反过来，在20x20方阵内，逐点验证是否可能为参数圆的轨迹点。
% 误差delta可调，在正负delta内都算有效解。预实验建议值为25。
% 预实验说明，当delta较小时，最大频次很小，统计误差很大。
delta=25;
r_step=0.5;
count=0;
A_Maxpro=[];
B_Maxpro=[];
RMAXNUM=[];
tic;
for r=r_min:r_step:r_min+range2 % 半径也取决于统计峰值
    count=count+1;
    Frequency=zeros(range,range);% 该20x20方阵点出现在参数圆轨迹中的次数
    for k=1:totalnum %逐个样本
        left=repmat(((APRO-X(k)).^2)',range,1)+repmat((BPRO-Y(k)).^2,1,range);
        right=r^2;
        Difference=round(left-right);
        ISSOLUTION=(Difference<delta & Difference>-delta);
        Frequency=Frequency+ISSOLUTION;
    end
    maxFrequency=max(Frequency(:));% 找出统计峰值
    [b_maxpro,a_maxpro]=find(Frequency==max(Frequency(:)));% 具有统计峰值，意味着该点最有可能是圆心(a_0,b_0)
    A_Maxpro=[A_Maxpro;a_maxpro];
    B_Maxpro=[B_Maxpro;b_maxpro];
    RMAXNUM=[RMAXNUM;maxFrequency];
    % 以上三者，记录的是在某一个r下的统计峰值和圆心坐标
end

final_max_Rposition=find(RMAXNUM==max(RMAXNUM));
R=r_min+(final_max_Rposition-1)*r_step;% 在所有r下的最大峰值对应的半径r

final_x_pro=A_Maxpro(final_max_Rposition)+xpro_min;
final_y_pro=B_Maxpro(final_max_Rposition)+ypro_min;
fprintf(' \n Hough圆形边缘检测结果：Centre=(%d,%d)，Radius=%.1f。\n',final_x_pro,final_y_pro,R);
for i=1:size(I,2)
    for j=1:size(I,1)
        if (i-final_x_pro)^2 + (j-final_y_pro)^2 < R^2
            raw_I(j,i) = 1;
        end
    end
end
figure(2),imshow(raw_I)