function nlabels= EnforceSupervoxelConnectivity(img_Lab, labels)
%% enforce the connectivity of supervoxel
% input: img_Lab-image in LAB color space, labels-superpixels label
% output: connectivity enforced superpixel

%% init
dx = [-1, 0, 1, 0];
dy = [0, -1, 0, 1];
[height, width, channel] = size(img_Lab);
[M, N] = size(labels);
nlabels = (-1)*ones(M, N);


label = 1;
adjlabel = 1;
xvec = zeros(height*width, 1);
yvec = zeros(height*width, 1);
m = 1;
n = 1;

%% main process
for j = 1: height
    for k = 1: width
        %  looking for unlabeled pixel
        if (0>nlabels(m, n))
            % label a new voxel
            nlabels(m, n) = label;
            %take a record for staring point
            xvec(1, 1) = k;
            yvec(1, 1) = j;
            %adjlabel for adjacent voxel
            for i = 1: 4
                x = xvec(1, 1)+dx(1, i);
                y = yvec(1, 1)+dy(1, i);
                if (x>0 && x<=width && y>0 && y<=height)
                    if (nlabels(y, x)>0)
                        adjlabel = nlabels(y, x);
                    end
                end
            end
            %searching, compute voxel size
            count = 2;
            c = 1;
            while (c<=count)
                for i = 1: 4
                    x = xvec(c, 1)+dx(1, i);
                    y = yvec(c, 1)+dy(1, i);
                    if (x>0 && x<=width && y>0 && y<=height)
                        if (0>nlabels(y, x) && labels(m, n)==labels(y, x))
                            xvec(count, 1) = x;
                            yvec(count, 1) = y;
                            nlabels(y, x) = label;
                            count = count+1;
                        end
                    end
                end
                c = c+1;
            end
            %combine small voxel
            if (count<600)
                for c = 1: (count-1)
                    nlabels(yvec(c, 1), xvec(c, 1)) = adjlabel;
                end
                label = label-1;
            end
            label = label+1;           
        end
        
        % prepare for next loop
        n = n+1;
        if (n>width)
            n = 1;
            m = m+1;
        end
        
    end
end


end