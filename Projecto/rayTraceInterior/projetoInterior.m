clear
%openExample('spc_channel/RayTracingInConferenceRoomExample')
mapFileName = "traininterior_simple.stl";

%Visualize the 3-D map.
figure(1); 
view(3);
trisurf(stlread(mapFileName), 'FaceAlpha', 0.3, 'EdgeColor', 'none'); 
hold on; axis equal; grid off;
xlabel('x'); ylabel('y'); zlabel('z');

%Define a transmitter site close to the wall and a receiver site under the table. 
tx = txsite("cartesian",  "AntennaPosition", [0; 10; 4],"TransmitterFrequency", 2.8e9);
rx = rxsite("cartesian","AntennaPosition", [1; 5; 2]);

%Plot the transmitter site in red and receiver site in blue.
scatter3(tx.AntennaPosition(1,:), tx.AntennaPosition(2,:), tx.AntennaPosition(3,:), 'sr', 'filled');
scatter3(rx.AntennaPosition(1,:), rx.AntennaPosition(2,:),rx.AntennaPosition(3,:), 'sb', 'filled');

%Create a ray tracing propagation model for Cartesian coordinates. 
% Specify the ray tracing method as shooting and bouncing rays (SBR). 
% Set the surface material to wood. 
pm = propagationModel("raytracing","CoordinateSystem","cartesian", ...
    "Method","sbr","MaxNumReflections",2,"SurfaceMaterial","wood"); 
%Perform ray tracing and save the computed rays using comm.Ray object
rays = raytrace(tx, rx, pm, 'Map', mapFileName); 
rays = rays{1};

%Visualize rays in the 3D map.
for i = 1:length(rays)
    if rays(i).LineOfSight
        propPath = [rays(i).TransmitterLocation, ...
                    rays(i).ReceiverLocation];
    else
        propPath = [rays(i).TransmitterLocation, ...
                rays(i).ReflectionLocations, ...
                    rays(i).ReceiverLocation];
    end
    line(propPath(1,:), propPath(2,:), propPath(3,:), 'Color', 'red');
end

%Visualize rays in the 3D map.
pathDists  = []; % Unit: meter
pathLosses = []; % Unit: dB
pathPhases = []; % Unit: radians

%Create vector to impulse response
for i = 1:length(rays)
    pathDists  = [pathDists rays(i).PropagationDistance]; % Unit: meter
    pathLosses = [pathLosses rays(i).PathLoss];           % Unit: dB
    pathPhases = [pathPhases rays(i).PhaseShift];         % Unit: radians
end

% Derive the complex gain and time of arrival for each path
pathGains = 10.^((-1*pathLosses)/20) .* exp(1i*pathPhases);
pathToA = pathDists/physconst("lightspeed"); % Unit: second

% Plot channel impulse response
figure(2); 
stem(pathToA-min(pathToA), abs(pathGains), 'filled');
grid on;
title('Channel Impulse Response');
xlabel('Delay (s)'); ylabel('Magnitude'); 

% A signal is passed through the channel and plotted in a constellation diagram.
%In order to model the effects of a receiver in motion, an instantaneous speed 
%is defined which produces a Doppler frequency shift. The received signal is highly 
%distorted due to the significant intersymbol interference (ISI) caused by the multipath 
%channel on a wideband 5G signal.
% Define instantaneous receiver speed and derive Doppler shift
rxSpeed = 0; % Unit: m/s . Definido como 0 mas podemos alterar
fd = rxSpeed * tx.TransmitterFrequency / physconst("lightspeed");

% Set the sampling rate, frame length and constellation size
%Rs = 122.88e6; % Corresponds to 5G signal rate
%frmLen = 30720;% same as LTE
%M = 64;

%In 802.11a, the fundamental sampling rate is 20 MHz, with a 64-point FFT/IFFT. 
%The Fourier transform symbol period, T, is 3.2 μs in duration and F is 312.5 kHz.
Rs = 122.88e6; % Corresponds to wifi802.11a signal rate
frmLen = 30720;% same as LTE
M = 64;

constDiagram = comm.ConstellationDiagram( ...
    "XLimits",[-15 15], ...
    "YLimits",[-15 15], ...
    "ReferenceConstellation",qammod(0:M-1, M));

% Randomly generate 64-QAM signals to be passed through the channel. 
% Perform channel filtering and observe the channel-impaired signal in
% the constellation diagram. The path gains are normalized in order to
% preserve the average input signal power. 
data  = randi([0 M-1], frmLen, 1);
txSig = qammod(data, M);
%rxSig = helperRayTracingChannelModel(Rs, pathToA, txSig, pathGains/norm(pathGains), fd);
constDiagram(txSig);

