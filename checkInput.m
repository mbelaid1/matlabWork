function checkInput(hObject,eventdata)
try
if isletter( eventdata.Character)
    import java.awt.Robot;
    import java.awt.event.KeyEvent;
    robot=Robot;
    robot.keyPress(KeyEvent.VK_ENTER);
    pause(0.01)
    robot.keyRelease(KeyEvent.VK_ENTER);
    text = get(hObject,'String');
    text(isletter(text)) = [];
    set(hObject,'String',text);
end
catch
    return;
end

