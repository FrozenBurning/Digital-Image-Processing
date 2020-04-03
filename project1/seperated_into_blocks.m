function blocks=seperated_into_blocks(I,w)
% Returns a matrix of local orientations in each block
% Input: I-original image,w-window size
% Output: block ordination cell {x,y}
    [M, N] = size(I);

    block_x = (1 : floor(M/(w/4)) ) * w / 4 + 1; % separate into blocks
    block_y = (1 : floor(N/(w/4)) ) * w / 4 + 1;
    blocks = cell(1,2);
    blocks{1} = block_x;
    blocks{2} = block_y;
end