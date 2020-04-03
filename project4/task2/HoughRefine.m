function refine_p=HoughRefine(ctl_p,I)
% ctl_p=[516 160;1069 106;1266 798;594 861];
have_k = zeros(1,4);
have_b = zeros(1,4);

have_k(1)=(ctl_p(1,2)-ctl_p(2,2))/(ctl_p(1,1)-ctl_p(2,1));
have_b(1)=ctl_p(1,2)-have_k(1)*ctl_p(1,1);
have_k(2)=(ctl_p(2,2)-ctl_p(3,2))/(ctl_p(2,1)-ctl_p(3,1));
have_b(2)=ctl_p(2,2)-have_k(2)*ctl_p(2,1);
have_k(3)=(ctl_p(3,2)-ctl_p(4,2))/(ctl_p(3,1)-ctl_p(4,1));
have_b(3)=ctl_p(3,2)-have_k(3)*ctl_p(3,1);
have_k(4)=(ctl_p(4,2)-ctl_p(1,2))/(ctl_p(4,1)-ctl_p(1,1));
have_b(4)=ctl_p(4,2)-have_k(4)*ctl_p(4,1);

I = rgb2lab(I);
I = imgaussfilt(I(:,:,3),5);
BW = edge(I,'canny',0.2,2);
[H,T,R] = hough(BW);

P  = houghpeaks(H,40,'threshold',ceil(0.1*max(H(:))));

% Find lines and plot them
lines = houghlines(BW,T,R,P,'FillGap',15,'MinLength',30);
cur_k = zeros(1,length(lines));
cur_b = zeros(1,length(lines));

for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    cur_k(k) = (xy(1,2)-xy(2,2))/(xy(1,1)-xy(2,1));
    cur_b(k) = xy(1,2)-cur_k(k)*xy(1,1);
end

guideline_k=zeros(1,4);
guideline_b=zeros(1,4);

for i=1:4
    error = (cur_k-have_k(i)).^2+0.001*(cur_b-have_b(i)).^2;
    idx=find(error==min(error(:)));
    try
        guideline_k(i)=cur_k(idx(1));
        guideline_b(i)=cur_b(idx(1));
    catch
       pause() 
    end
    %     guideline=[lines(idx).point1;lines(idx).point2];
    %     figure(1),plot(guideline(:,1),guideline(:,2),'LineWidth',2,'Color','cyan');
end

cross_x=zeros(1,4);
cross_y = zeros(1,4);

cross_x(2) = (guideline_b(1)-guideline_b(2))/(guideline_k(2)-guideline_k(1));
cross_y(2) = guideline_k(1)*cross_x(2)+guideline_b(1);
cross_x(3) = (guideline_b(2)-guideline_b(3))/(guideline_k(3)-guideline_k(2));
cross_y(3) = guideline_k(2)*cross_x(3)+guideline_b(2);
cross_x(4) = (guideline_b(3)-guideline_b(4))/(guideline_k(4)-guideline_k(3));
cross_y(4) = guideline_k(3)*cross_x(4)+guideline_b(3);
cross_x(1) = (guideline_b(4)-guideline_b(1))/(guideline_k(1)-guideline_k(4));
cross_y(1) = guideline_k(4)*cross_x(1)+guideline_b(4);
pos = [cross_x',cross_y'];
% drawpolygon('Position',pos,'Color','r');
refine_p=pos;
end