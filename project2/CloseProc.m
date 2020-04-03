function result=CloseProc(I,core)
    result = Dilate(I,core);
    result = Erode(result,core);
end