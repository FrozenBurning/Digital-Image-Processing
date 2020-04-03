function ShowOrientation(I, O, maskI, w)
%% show orientation map- optional function
% used only in report
    blocks = seperated_into_blocks(I,w);
    block_x = blocks{1};
    block_y = blocks{2};
    
    figure(6),imshow(I);
    hold on;
    
    [m, n] = size(O);
    for i = 1:m
        for j = 1:n
            center_x = block_x(i) + ceil(w/4);
            center_y = block_y(j) + ceil(w/4);
            if maskI(i,j)
                angle = O(i, j);
                len = w/8;
                line([center_y - len * sin(angle), center_y + len * sin(angle)],[center_x - len * cos(angle), center_x + len * cos(angle)], 'linewidth', 2);
            end
        end
    end
end