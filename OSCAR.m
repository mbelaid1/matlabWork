function varargout = OSCAR(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @OSCAR_OpeningFcn, ...
    'gui_OutputFcn',  @OSCAR_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function OSCAR_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
% axes(handles.mainPlot);
%  profile on

function varargout = OSCAR_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

function applyMovingAverage_Callback(hObject, eventdata, handles)
try
    data = handles.UserData;
catch
    return
end
dualcursor off
dataToPlot= real(getValue(handles.mainPlot,1));
switch getValue(handles.applyMovingAverage)
    case 0
        set(handles.movingAverageBandwidth,'string','Moving Avg BW');
    case 1
        [dataToPlot(:,4),dataToPlot(:,3),Fc] = MymovingAvg(str2double...
            (getValue(handles.movingAverageWindowSize))...
            ,data,handles.dBCurrent.Value,get(handles.timeDistance,'Value'));
        set(handles.movingAverageBandwidth,'string',round(Fc,2));
    otherwise
end

plotArray(round(dataToPlot,3),handles,1);
set(handles.runFilter,'Enable','off')
cursorEnable_Callback(hObject, eventdata, handles)

function runConfigure_Callback(hObject, eventdata, handles)
h = waitbar(1/7,'Please wait');
data =round(readDataFPGA,3);
waitbar(2/7,h);
set(handles.axesPanel,'Visible','on');
set(handles.mainPlot,'Visible','on');
waitbar(3/7,h);

handles.UserData = data;
waitbar(4/7,h);

guidata(hObject, handles);
waitbar(5/7,h);

plotArray([data(:,1),data(:,3)],handles,1);
waitbar(6/7,h);

grid on
grid minor
set(handles.runFilter,'Enable','on')
set(handles.runConfigure,'Enable','off')
waitbar(1,h);
close(h)
configureAxes_Callback(hObject, eventdata, handles)

function configureAxes_Callback(hObject, eventdata, handles)
try
    data = handles.UserData;
catch
    return
end
xtitle = ["Distance (km)", "Time (uSec)"];
xlowerValue = str2double(get(handles.xLowerLimit,'String'));
xupperValue = str2double(get(handles.xUpperLimit,'String'));
ylowerValue = str2double(get(handles.yLowerLimit,'String'));
yupperValue = str2double(get(handles.yUpperLimit,'String'));
if(xlowerValue >= xupperValue |ylowerValue >= yupperValue)
    msgbox('x or y lower limit cant be higher than the upper limit', 'Error','error');
else
    switch get(handles.timeDistance,'Value')
        case 1
            xindex = 1;
        case 2
            xindex= 2;
        otherwise
    end
    switch get(handles.dBCurrent,'Value')
        case 1
            plotArray([data(:,xindex),data(:,3)],handles,1);
            set(handles.mainPlot,'yscale','log');
            ylabel(handles.mainPlot,'Signal (pA)')
        case 2
            plotArray([data(:,xindex),data(:,4)],handles,1);
            set(handles.mainPlot,'yscale','linear');
            ylabel(handles.mainPlot,'Loss (dB)')
        otherwise
    end
    set(handles.mainPlot,'ylim',[ ylowerValue yupperValue]);
    set(handles.mainPlot,'xlim',[ xlowerValue xupperValue]);
    set(handles.mainPlot,'fontsize',18)
    xlabel(handles.mainPlot,xtitle(xindex));
    grid on
    grid minor
    
    set(handles.configureAxes,'Enable','off')
    set(handles.mainPlot,'UserData', [xlim  ylim]) ;
    applyMovingAverage_Callback(hObject, eventdata, handles)
end

function dBCurrent_Callback(hObject, eventdata, handles)
switch get(handles.dBCurrent,'Value')
    case 1
        set(handles.upperpAText,'String','Y-Upper Limit (pA)')
        set(handles.lowerpAText,'String','Y-Lower Limit (pA)')
        
        set(handles.yUpperLimit,'String','1e7')
        set(handles.yLowerLimit,'String','1')
    case 2
        set(handles.upperpAText,'String','Y-Upper Limit (dB)')
        set(handles.lowerpAText,'String','Y-Lower Limit (dB)')
        
        set(handles.yUpperLimit,'String','0')
        set(handles.yLowerLimit,'String','-35')
    otherwise
end
set(handles.configureAxes,'Enable','on')

function cursorEnable_Callback(hObject, eventdata, handles)
zoom off
dualcursor;   %Specifies the location to display DeltaX
switch handles.cursorEnable.Value
    case 0
        dualcursor off
    case 1
        dualcursor on
        dualcursor('update');
    otherwise
end

function customSave_ClickedCallback(hObject, eventdata, handles)
dualcursor off
try
    [header, data] = formatDataToSave(handles);
    if data==-1
        return
    end
    filter = {'*.csv';'*.*'};
    [file, path] = uiputfile(filter,'','OTDR Data.csv');
    header = cellstr(header);
    fid = fopen(strcat(path,file(1:end-3)+"csv"),'w');
    if fid == -1
        fclose(fid);
        cursorEnable_Callback(hObject, eventdata, handles)
        return
    end
    h = waitbar(0,'Saving Data. Please Wait!');
    for i=1:length(header)
        fprintf(fid,'%s',header{i,1});
        fprintf(fid,'%s',',');
        fprintf(fid,'%s \n',header{i,2});
        waitbar(i/(length(header)+1),h,'Please Wait!')
    end
    fclose(fid);
    dlmwrite(strcat(path,file), data, 'delimiter', ',', 'precision', 5, '-append');
    waitbar(1,h,'Data was Saved Successfully')
    pause(0.5)
    close (h)
    cursorEnable_Callback(hObject, eventdata, handles)
catch
    cursorEnable_Callback(hObject, eventdata, handles)
end


function timeDistance_Callback(hObject, eventdata, handles)
switch get(handles.timeDistance,'Value')
    case 1
        set(handles.upperkmText,'String','X-Upper Limit (km)')
        set(handles.lowerkmText,'String','X-Lower Limit (km)')
        
        set(handles.xUpperLimit,'String','160')
        set(handles.xLowerLimit,'String','0')
        
    case 2
        set(handles.upperkmText,'String','X-Upper Limit (uSec)')
        set(handles.lowerkmText,'String','X-Lower Limit (uSec)')
        
        set(handles.xUpperLimit,'String','1600')
        set(handles.xLowerLimit,'String','0')
    otherwise
end
set(handles.configureAxes,'Enable','on')

function runFilter_Callback(hObject, eventdata, handles)
% profile off
% profile viewer
applyMovingAverage_Callback(hObject, eventdata, handles)

function gainSelection_Callback(hObject, eventdata, handles)
set(handles.runConfigure,'Enable',isValueDirty(handles.gainSelection,'gain'));

function pdReverseBiasVoltage_Callback(hObject, eventdata, handles)
set(handles.runConfigure,'Enable',isValueDirty(handles.gainSelection,'pdRBV'));

function laserLaunchPower_Callback(hObject, eventdata, handles)
set(handles.runConfigure,'Enable',isValueDirty(handles.gainSelection,'laserPower'));

function pulseWidth_Callback(hObject, eventdata, handles)
set(handles.runConfigure,'Enable',isValueDirty(handles.gainSelection,'pw'));

function numberOfAverages_Callback(hObject, eventdata, handles)
set(handles.runConfigure,'Enable',isValueDirty(handles.gainSelection,'numberAverages'));

function pdReverseBiasVoltage_KeyPressFcn(hObject, eventdata, handles)
checkInput(hObject,eventdata);

function laserLaunchPower_KeyPressFcn(hObject, eventdata, handles)
checkInput(hObject,eventdata);

function pulseWidth_KeyPressFcn(hObject, eventdata, handles)
checkInput(hObject,eventdata);

function numberOfAverages_KeyPressFcn(hObject, eventdata, handles)
checkInput(hObject,eventdata);

function movingAverageWindowSize_KeyPressFcn(hObject, eventdata, handles)
checkInput(hObject,eventdata);
set(handles.runFilter,'Enable','on')

function xLowerLimit_KeyPressFcn(hObject, eventdata, handles)
checkInput(hObject,eventdata);
set(handles.configureAxes,'Enable','on')

function xUpperLimit_KeyPressFcn(hObject, eventdata, handles)
checkInput(hObject,eventdata);
set(handles.configureAxes,'Enable','on')

function yLowerLimit_KeyPressFcn(hObject, eventdata, handles)
checkInput(hObject,eventdata);
set(handles.configureAxes,'Enable','on')

function yUpperLimit_KeyPressFcn(hObject, eventdata, handles)
checkInput(hObject,eventdata);
set(handles.configureAxes,'Enable','on')

function banwdithSelection_Callback(hObject, eventdata, handles)
set(handles.runConfigure,'Enable',isValueDirty(handles.banwdithSelection,'filter'));

function movingAverageWindowSize_Callback(hObject, eventdata, handles)
checkInput(hObject,eventdata);