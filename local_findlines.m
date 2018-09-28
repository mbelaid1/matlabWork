function lineh = local_findlines(axh);
lineh = findobj(axh,'Type','line');        %Find a line to add cursor to
dots = findobj(axh,'Type','line','Tag','Cursor');  %Ignore existing cursors
lineh = setdiff(lineh,dots);

xdtemp = get(lineh,'XData');
linehtemp = lineh;
lineh=[];
if ~iscell(xdtemp)      %If there's only one line, force data into a cell array
    xdtemp = {xdtemp};
end

for ii=1:length(xdtemp);
    if length(xdtemp{ii})>2
        lineh = [lineh; linehtemp(ii)];
    end
end
end