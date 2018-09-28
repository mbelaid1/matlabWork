
function repositionCursors(~,ev)
% disp('Reposition is here');
axh = ev.Axes;
xLimits = xlim(axh) + diff(xlim(axh))*[.02 -.02];

% Get locations of each cursor
cursors = findobj(axh,'Tag','Cursor');
cd1 = getappdata(cursors(1),'Coordinates');
cd2 = getappdata(cursors(2),'Coordinates');
cn1 = getappdata(cursors(1),'CursorNumber');
cn2 = getappdata(cursors(2),'CursorNumber');
xCursors(cn1) = cd1(1);        %x value of cursor number cn1
xCursors(cn2) = cd2(1);        %x value of cursor number cn2

% If cursor is off left edge, snap left
% If cursor is off right edge, snap right

% First cursor
xCursors(1) = max([xLimits(1) xCursors(1)]); % Bring to left edge if needed
xCursors(1) = min([xLimits(2) xCursors(1)]); % Bring to right edge if needed

% Second cursor
xCursors(2) = max([xLimits(1) xCursors(2)]); % Bring to left edge if needed
xCursors(2) = min([xLimits(2) xCursors(2)]); % Bring to right edge if needed

% If both cursors are on an edge, put one in middle
if xCursors(1)==xCursors(2)
    if xCursors(1) == xLimits(1)        % Left edge.  #2 to middle
        xCursors(2) = mean(xLimits);
    elseif xCursors(1)== xLimits(2)     % Right edge. #1 to middle
        xCursors(1) = mean(xLimits);
    end
end

% Put cursors in new positions
% color = getappdata(axh,'Color');
dualcursor(xCursors)
lh = getappdata(axh,'SelectedLine');
color = get(lh,'Color')*0.65;
cursors = findobj(axh,'Tag','Cursor');
set(cursors(1),'Color',color);
set(cursors(2),'Color',color);

end
