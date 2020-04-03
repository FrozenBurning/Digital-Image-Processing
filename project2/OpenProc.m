function result=OpenProc(I,core)
%% basic morphology method
    result = Erode(I,core);
    result = Dilate(result,core);
end