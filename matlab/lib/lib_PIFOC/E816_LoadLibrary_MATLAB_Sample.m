%%
% Small Sample Macro to demonstrate the use of the E816_GCS_DLL with MATLAB
% Note that only MATLAB Versions higher than 7 supports easy implementation
% of dll calls

% Loading the dll and connecting to the controller

% specify DLL name and alias
% shrlib = 'C:\Users\loic\Desktop\PI_MATLAB\E816_DLL.dll';
% hfile = 'C:\Users\loic\Desktop\PI_MATLAB\E816_DLL.h';
 shrlib = 'E816_DLL';
 hfile = 'E816_DLL.h';
libalias = 'E816';
% only load dll if it wasn't loaded before
if(~libisloaded(libalias))
    [m, t] = loadlibrary (shrlib,hfile,'alias',libalias);
    disp(t);
end
%%
% only connect to Controller if no connection exists
if(~exist('ID'))
    ID = calllib(libalias,'E816_ConnectRS232',1,115200);
    if(ID<0)
        clear('ID');
    end
end
%%
% preload return variable
idn = blanks(100);
% query Identification string
[ret,idn] = calllib(libalias,'E816_qIDN',ID,idn,100);
disp(sprintf('Connected to %s\n',idn));
% query baud rate
bdr = 0;
[ret,bdr] = calllib(libalias,'E816_qBDR',ID,bdr);
disp(sprintf('Connection speed: %d baud\n',bdr));
%%
% query connected axes
axes = blanks(10);
[ret,axes] = calllib(libalias,'E816_qSAI',ID,axes,10);
%%
% query servo state
svo = zeros(size(axes));
[ret,axes,svo] = calllib(libalias,'E816_qSVO',ID,axes,svo);
%%
% set servo state to on
svo = ones(size(axes));
calllib(libalias,'E816_SVO',ID,axes,svo);

%%
% query current position of first axis
pos = 0;
axis = axes(1);
[ret,axis,pos] = calllib(libalias,'E816_qPOS',ID,axis,pos);
disp(sprintf('qPOS(%d,%c) = %g\n',ID,axis,pos));
% move first axis to random position 
pos = rand(1)*2;
calllib(libalias,'E816_MOV',ID,axis,pos);
disp(sprintf('MOV(%d,%c,%g)\n',ID,axis,pos));
%%
% query current position of first axis
pos = 0;
axis = axes(1);
for n = 1:10
    [ret,axis,pos] = calllib(libalias,'E816_qPOS',ID,axis,pos);
    disp(sprintf('qPOS(%d,%c) = %g\n',ID,axis,pos));
    pause(0.01);
end
    

%%
% close connection to controller
calllib(libalias,'E816_CloseConnection',ID);
% unload library
unloadlibrary(libalias);
% delete ID variable
clear('ID');
