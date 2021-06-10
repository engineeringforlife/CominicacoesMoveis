%Model High-Speed Train Propagation Channel
%https://www.mathworks.com/help/lte/ref/ltehstchannel.html#bt4ipn2-2
%openExample('lte/ModelHighSpeedTrainPropagationChannelExample')
clear all

% Generate a frame and filter it with the high-speed train channel model.
% Create a reference channel configuration structure initialized to 'R.10'. 
% Generate a waveform.

rmc = lteRMCDL('R.10');
[txWaveform,txGrid,info] = lteRMCDLTool(rmc,[1;0;1]);

chcfg.NRxAnts = 1;
chcfg.Ds = 100;
chcfg.Dmin = 500;
chcfg.Velocity = 350;
chcfg.DopplerFreq = 5;
chcfg.SamplingRate = info.SamplingRate;
chcfg.InitTime = 0;
rxWaveform = lteHSTChannel(chcfg,txWaveform);