function result = GeodesicDilation(I,core,mask)
%% basic morphology method
% input: I-marker,core-structual element,mask-mask
    tmp = I;
    prev = I;
    %in previous use on fingerprint, inverse is needed
    mask = ~mask;
    while true
       tmp = Dilate(tmp,core);
       tmp = tmp & mask;
       gap = tmp - prev;
       % judge whether could stop
       if sum(gap(:)) == 0
           break;
       end
       prev = tmp;
    end
    
    result = tmp;
end