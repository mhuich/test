clear all
% path: where is SMARSCAN root?
%the SMARSCAN root is found relative to the path of the current file
strfilepath=mfilename('fullpath');
indexdum=strfind(strfilepath,filesep);
rootstr=strfilepath(1:indexdum(end-1)-1);
clear indexdum strfilepath²


%% parameters of DMD execution
pictime=120;%in MILLIsecond 
illumintime=90; % in MILLIseconds
DMDreadout=10;%in MILLIsecond





%% load library before using commands
addpath([rootstr filesep 'lib' filesep 'lib_DMD']); %add the folder path for search
loadlibrary('alp4395','alp.h');

%% create the array you want to use
% % All white
% array = uint8(255*ones(1200, 1920));

% % Random
% percentage of white pixels
% p = 5; 
% array = rand_pattern(1200,1920,5) < p/100;
% array = uint8(255*array);

% % Circle
%  radius = 50;
%  array = circ_pattern(1920,1200, radius);
 
 %Lattice
%  array(:,:,1)=lattice_pattern(1920,1200,100,30,[0 1]);
%  array(:,:,2)=lattice_pattern(1920,1200,100,30,[0 10]);
%  array=repmat(array,1,1,5);
 
 % % % % % % % % % method 3: fast-moving
% % % lattice_moving_fast(height, width,period,pinhole,step_band,moving_speed)
 %
 array=lattice_moving_fast(1920,1200,50,30,30,2);

% Moving grid
% [xx,yy] = meshgrid(1:1920,1:1200);
% array = repmat(xx,1,1,5);
% m = 100;
% 
% for i=1:size(array,3)
%     array(:,:,i) = array(:,:,i) + 1;
% end
% array = mod(array,m) < 4;
% array = ~array;
% array = uint8(255*array);


picnum = size(array,3);
%% AlpDevAlloc ... use AlpDevFree afterfinishing
% prepare pointer to ALP_ID (uint32) for 3rd parameter
deviceid = int32(0);
deviceidptr = libpointer('uint32Ptr', deviceid);
[alp_returnvalue, deviceid] = calllib('alp4395','AlpDevAlloc',...
    int32(0), int32(0), deviceidptr);%ALP_DEFAULT=0

%% Setting the SYNCH OUT 1
Gated.Period = uint8(1);
Gated.Polarity = uint8(1);
Gated.Gate = uint8(ones(1,16));

Gate_ptr = libpointer('tAlpDynSynchOutGate', Gated);

alp_returnvalue = calllib('alp4395','AlpDevControlEx',...
    deviceid, int32(2023), Gate_ptr ); %ALP_DEV_DYN_SYNCH_OUT1_GATE = 2023

%% AlpSeqAlloc... allocate memory for a sequence of images to be shown
bitdepth = int32(1);
seqidptr = libpointer('uint32Ptr', uint32(0));

alp_returnvalue = calllib('alp4395','AlpSeqAlloc',...
    deviceid, bitdepth, picnum, seqidptr)
get(seqidptr); % to get the info indide ptr, so the adress
seqid = seqidptr.Value; %gets the id of the sequence of images

%% AlpSeqControl... To set binary uninterrupted mode ! 
alp_returnvalue = calllib('alp4395','AlpSeqControl',...
    deviceid, seqid, int32(2103), int32(1)); % ALP_BITNUM (bitdepth) = 1
alp_returnvalue = calllib('alp4395','AlpSeqControl',...
    deviceid, seqid, int32(2110), int32(0)); % ALP_DATA_FORMAT -> MSB_ALIGN
alp_returnvalue = calllib('alp4395','AlpSeqControl',...
    deviceid, seqid, int32(2104), int32(2105)); % % ALP_BIN_MODE -> normal BIN mode

%% AlpSeqTiming
illumtime_us = int32(1000*illumintime); %in us. minimum accepted is 10us Ignored in uninterrupted binary mode
pictime_us = int32(1000*pictime); %in us, by default is 61us in binary mode
synchdelay = int32(0); %note: micromirrors have a ~40us mechanical relax time
synchpulsewidth = int32(0.2*pictime_us); % equal to half inttime in uninterrupted mode
alp_returnvalue = calllib('alp4395','AlpSeqTiming',...
    deviceid, seqid, illumtime_us, pictime_us, synchdelay, synchpulsewidth, int32(0))


%% AlpProjControl...projection parameters

alp_proj_mode = int32(2300);
%For slave mode
alp_returnvalue = calllib('alp4395','AlpProjControl',...
    deviceid, alp_proj_mode, int32(2302)); % ALP_SLAVE

%detect rising edge 
alp_TRIGGER_EDGE = int32(2005);
alp_returnvalue = calllib('alp4395','AlpDevControl',...
    deviceid, alp_TRIGGER_EDGE, int32(2009)); % ALP_EDGE_RISING





%% AlpSeqPut.. upload the sequence of images
arrayptr = libpointer('voidPtr', array);
picoffset = int32(0);
picload = int32(size(array,3));
alp_returnvalue = calllib('alp4395','AlpSeqPut',...
    deviceid, seqid, picoffset, picload, arrayptr);

%% Run measurement

alp_returnvalue = calllib('alp4395','AlpProjStart',...
    deviceid, seqid);
% 
% tic;
% pause(double(picload)*inttime*1e-6)%an estimation of the time it takes to acquire data
% while length(Buffer)<picload%make a pause until data is fully taken from acquisition board
%     pause(0.1)
% end
% toc
%% stop sequence
alp_returnvalue = calllib('alp4395','AlpProjHalt',...
    deviceid);

%% AlpSeqFree
alp_returnvalue = calllib('alp4395','AlpSeqFree',...
    deviceid, seqid);

%% AlpDevFree ...and id has to be known first
alp_returnvalue = calllib('alp4395','AlpDevFree',deviceid);

%% unload library after finishing...do not forget to AlpDevFree before disconnecting
clear infoptrbis; % remove struct entities before unloeading library
clear Gate_ptr;
unloadlibrary('alp4395')