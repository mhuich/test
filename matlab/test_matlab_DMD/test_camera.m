vid = videoinput('hamamatsuadaptorimaq', 1, 'MONO16_2048x2048_FastMode');
src = getselectedsource(vid);

vid.FramesPerTrigger = 1;

% Trigger parameters

src.TriggerSource = 'external';
src.TriggerGlobalExposure = 'globalreset';
src.TriggerTimes = 5; % number of frames to acquire

% Set OUTPUT 1 on high, as it will be the reference voltage
src.OutputTriggerKindOpt1 = 'high';

% Set OUTPUT 2 on trigger ready for the DMD
src.OutputTriggerKindOpt2 = 'triggerready';

% Set OUTPUT 3 on exposure, for the laser
src.OutputTriggerKindOpt3 = 'exposure';

%% Start the acquisition
% preview(vid);
start(vid);

%% Stop it
stop(vid);

%% Get the image in data
data = getdata(vid);

%% Save it to a file
save('data.mat', 'data');

%% Clear the variable
clear data;
delete(vid);
clear;
close(gcf);