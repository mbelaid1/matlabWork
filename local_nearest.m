function [xv,yv]=local_nearest(x,xl,yl)
%Inputs:
% x   Selected x value
% xl  Line Data (x)

%Find nearest value of [xl] to (x)
%Special Case: Line has a single non-singleton value
% if sum(isfinite(xl))==1
%     fin = find(isfinite(xl));
%     xv = xl(fin);
%     yv = yl(fin);
% else
    %Normalize axes
%     xlmin = min(xl);
%     xlmax = max(xl);
%     xln = (xl - xlmin)/(xlmax - xlmin);
%     xn = (x - xlmin)/(xlmax - xlmin);
%     
%     
%     %Find nearest x value only.
%     temp = xln-xn;
%     c = abs(((xl - min(xl))/(max(xl) - min(xl)))-((x - min(xl))/(max(xl) - min(xl))));
    [~,ind] = min (abs(xl-x));
%     [~,ind] = min(c);
    
    %Nearest value on the line
    xv = xl(ind);
    yv = yl(ind);
% end
end