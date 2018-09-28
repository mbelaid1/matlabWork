function data = readDataFPGA()
Fs = 125e6;
load('matlab.mat');
data(:,1) = real(datainPa(:,1));
data(:,2) = real((1e6*(1/Fs:1/Fs:length(data(:,1))/Fs))'-380);
data(:,3)  = datainPa(:,2);
data(:,4)  = real(5*log10(data(:,3) /max(data(:,3) )));
data = data(47e3:end,:);

end

