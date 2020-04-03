%% video to images

% vid = VideoReader('targetVideo.MP4');
% numFrames = vid.NumberOfFrames;
% for k = 1:numFrames
%    frame = READFRAME(vid,k);
%     imwrite(frame,strcat('./pics/',num2str(k),'.jpg'),'jpg');
% end

%% images to video
framesPath = './outputs_nohand/';
videoName = 'result_nohand';
fps = 25;
startFrame = 2; %从哪一帧开始
endFrame = 406; %哪一帧结束

%生成视频的参数设定
aviobj=VideoWriter(videoName); %创建一个avi视频文件对象，开始时其为空
aviobj.FrameRate=fps;

open(aviobj);%Open file for writing video data
%读入图片
for i=startFrame:endFrame
frames=imread(strcat(framesPath,num2str(i),'.jpg'));
writeVideo(aviobj,frames);
end
close(aviobj);% 关闭创建视频