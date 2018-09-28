function [header,data] = formatDataToSave(handles)
%pull all the data needed to be added to the CSV file that will be written

i = 0;
header(1,1) = "Launch Power (dBm)";
header(1,2) = getValue(handles.laserLaunchPower);

header(2,1) = "Pulse Width (nS)";
header(2,2) = getValue(handles.pulseWidth);

header(3,1) = "PD RVB (V)";
header(3,2) = getValue(handles.pdReverseBiasVoltage);

header(4,1) = "# Avgs";
header(4,2) = getValue(handles.numberOfAverages);

header(5,1) = "TIA Gain";
header(5,2) = getValue(handles.gainSelection)+"Ohm";

header(6,1) = "Analog Bandwidth";
header(6,2) = getValue(handles.banwdithSelection);

if(getValue(handles.applyMovingAverage))
    
    header(7,1) = "Moving Average Window";
    header(7,2) = getValue(handles.movingAverageWindowSize);
    header(9,3) = "Filtered Data";

    i = 1;
end
header(8+i,1) = "Distance (km)";
try
switch cell2mat(getValue(handles.dBCurrent))
    case "Current (pA)"
        header(8+i,2) = "Signal (pA)";
    case "dB"
        header(8+i,2) = "Loss (dB)";
    otherwise
end
c = get(handles.mainPlot,'Children');
xData = get(c,'XData');
yData = get(c,'YData');
if iscell(xData)
%     for x = 1:length(xData)
        data(:,1) = (cell2mat(xData(1)))';
        data(:,2) = (cell2mat(yData(1)))';
        data(:,3) = (cell2mat(yData(2)))';
%         i = 0;

%     end
    return
else
    data(:,1) = xData';
    data(:,2) = yData';
end
catch me
    data = -1;
    msgbox('no data to save')
end
end

