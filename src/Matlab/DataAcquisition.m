%% Discover Device
devices = daq.getDevices;

%% Create a session and add the four analog input channels
s = daq.createSession('ni');
s.addAnalogInputChannel('cDAQ1Mod1',0,'Voltage');
s.addAnalogInputChannel('cDAQ1Mod1',1,'Voltage');
s.addAnalogInputChannel('cDAQ1Mod1',2,'Voltage');
s.addAnalogInputChannel('cDAQ1Mod1',3,'Voltage');

%% Session Rate Default 1000 scans/second
%S.Rate = 1000;

%% Set Duration
s.DurationInSeconds = 10;

%% Acquire Multiple Scans and Save 
trial = input('What trial is this?: ', 's');

[data.(trial),time.(trial)] = s.startForeground;

figure(1)
plot(time.(trial), data.(trial));
xlabel('Time(secs)');
ylabel('Voltage');
title ('Trial ', trial); 

h=get(0,'children');
h=sort(h);
imgfile = mfilename;
imgfolder = ['Trials'];
imgdir = fullfile(imgfile,'Images', imgfolder);
if(exist(imgfile,'file') == 0)
    mkdir(imgfile);
end
if(exist(fullfile(imgfile, 'Images'),'file') == 0)
    mkdir(fullfile(imgfile, 'Images'));
end
if(exist(fullfile(imgdir),'file') == 0)
    mkdir(fullfile(imgdir));
end
for i = 1:length(h)
    print (h(i), '-dpdf', fullfile(imgdir, ['Trial - ', trial, ' Figure ', num2str(i)]));
end

varname = ['Trial', trial,'.mat'];
vardir = fullfile(imgfile,'Variables', imgfolder);
if(exist(imgfile,'file') == 0)
    mkdir(imgfile);
end
if(exist(fullfile(imgfile,'Variables'),'file') == 0)
    mkdir(fullfile(imgfile,'Variables'));
end
if(exist(fullfile(vardir),'file') == 0)
    mkdir(fullfile(vardir));
end

save(fullfile(vardir,varname));

