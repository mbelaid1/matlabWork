function value = getValue(object, isplot)
if exist('isplot','var')
    c = get(object,'Children');
    xData = get(c,'XData');
    yData = get(c,'YData');
    if iscell(xData)
        value(:,1) = cell2mat(xData(length(xData)));
        value(:,2) = cell2mat(yData(length(yData)));
    return
    end
    value(:,1) = xData;
    value(:,2) = yData;
    return
end
switch object.Style
    case 'popupmenu'
        value = object.String(object.Value);
    case 'edit'
        value = object.String;
    case 'radiobutton'
        value = object.Value;
    otherwise
end

end

