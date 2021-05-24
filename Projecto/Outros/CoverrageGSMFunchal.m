% tx = txsite('Name','MathWorks', ...
%         'Latitude', 32.644838, ...
%         'Longitude', -16.914588);
%     coverage(tx)
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
strongSignal = -75;
strongSignalColor = "green";
weakSignal = -90;
weakSignalColor = "cyan";
    
tx = txsite('Name','MathWorks','Latitude', 32.644838,'Longitude', -16.914588);
cov=coverage(tx,'SignalStrengths',[strongSignal,weakSignal], ...
       'Colors', [strongSignalColor,weakSignalColor])
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fq = 4.5e9;
y = design(yagiUda,fq);
y.Tilt = 90;
y.TiltAxis = 'y';

tx = txsite('Name','MathWorks', ...
    'Latitude',42.3001,'Longitude',-71.3503, ...
    'Antenna',y,'AntennaHeight',60, ...
    'TransmitterFrequency',fq,'TransmitterPower',10)


coverage(tx,'rain','SignalStrengths',-90)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

names = ["Estádio","Jaime Moniz"];
lats = [32.645586,32.649366];
lons = [-16.929935,-16.901796];

txs = txsite('Name', names,...
       'Latitude',lats,...
       'Longitude',lons, ...
       'TransmitterFrequency',900e6, ...
       'TransmitterPower',1, ...
       'AntennaHeight',60);
   
coverage(txs,'SignalStrengths',-100:5:-60)

viewer = siteviewer("Buildings","map.osm");