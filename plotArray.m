function plotArray(data,handles,clearPlot)
axes(handles.mainPlot);
cutFrom = 1;
switch clearPlot
    case 0
        hold on
        for i = 1:size(data,2)/2
            plot(handles.mainPlot,data(cutFrom:end,2*i-1),data(cutFrom:end,2*i));
        end
    case 1
        cla(handles.mainPlot)
        hold on
        for i = 1:size(data,2)/2
            plot(handles.mainPlot, data(cutFrom:end,2*i-1),data(cutFrom:end,2*i));
            hold on
        end
    otherwise
        
end

