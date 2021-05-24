names = ["Lis. Sta Apolonia Sul", "Lis. Sta Apolonia Norte"];
lats = [38.72292344263412,38.72292344263412];
lons = [-9.113768639578858, -9.113768639578858];

%Antena Design-------------------------
    fq = 1.8e9;
    y = design(yagiUda,fq);
    y.Tilt = 230;
    y.TiltAxis = 'y';
    
    y1 = design(yagiUda,fq);
    y1.Tilt = 50;
    y1.TiltAxis = 'y';
%     
%     tx = txsite('Name','MathWorks', ...
%     'Latitude',42.3001,'Longitude',-71.3503, ...
%     'Antenna',y,'AntennaHeight',60, ...
%     'TransmitterFrequency',fq,'TransmitterPower',10);

%38.71603944342921, -9.120287407781346
txs = txsite('Name', names,...
       'Latitude',lats,...
       'Longitude',lons, ...
       'TransmitterFrequency',fq, ...
       'TransmitterPower',1, ...
       'AntennaHeight',60,...
       'Antenna',y);
   
viewer = siteviewer("Buildings","StaApolonia.osm");




coverage(txs,'SignalStrengths',-100:5:-60)

%coverage(txs,"raytracing","SignalStrengths",-100:-5, ...
%    "MaxRange",250,"Resolution",2)

