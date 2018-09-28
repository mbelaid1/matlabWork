function checkInput(hObject,eventdata, lowerLimit, upperLimit)
try
    if(eventdata.Key =='return'), return,end
    import java.awt.Robot;
    import java.awt.event.KeyEvent;
    robot=Robot;
    robot.keyPress(KeyEvent.VK_ENTER);
    pause(0.02)
    robot.keyRelease(KeyEvent.VK_ENTER);
    text = get(hObject,'String');
    if(sum(isletter(text)) > 0)
        text(isletter(text)) = [];
        set(hObject,'String',text);
        disp ('letter section')
        return;
    end
    if(sum(isletter(text)) ==0)
        disp ('limits section')
        
        if str2double(text) > upperLimit
            set(hObject,'String',num2str(upperLimit));
            msgbox('Exceeded Upper limit for this variable');
            return;
        end
        if str2double(text) < lowerLimit
            set(hObject,'String',num2str(lowerLimit));
            msgbox('value entered was lower than minimum valeu for this variable')
            return;
        end
        return;
        
    end
catch
    return;
end

