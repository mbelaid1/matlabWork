function [filteredData,xDelayedData,Fc] = MymovingAvg(n,data,logorlin,timeOrDistance)
Fs = 125;
Fc = round(Fs*0.442947/sqrt((n^2)-1),2);
b = (1/n)*ones(1,n);
a = 1;
gd = mean(mygrpdelay(b,a));

switch logorlin
    case 1
        filteredData = myFilter(b,a,data(:,3));
        
    case 2
        filteredData = 5*log10(myFilter(b,a,data(:,3))/max(data(:,3)));
    otherwise
end

switch timeOrDistance
    case 2
        xDelayedData = data(:,2);
        
    case 1
        xDelayedData = data(:,1) - 0.1e6*gd/(Fs*1e6);
    otherwise
end
end

