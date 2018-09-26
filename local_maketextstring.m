
function textstring = local_maketextstring(xv,yv)
textstring = {['x = ' num2str(xv,'%2g')];
    ['y = ' num2str(yv,'%2.2g')]};
end