%openExample('spc_channel/RayTracingInConferenceRoomExample')

mapFileName = "traininterior_simple.stl";

%Visualize the 3-D map.
figure; view(3);
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

% Plot channel impulse response
stem(pathToA-min(pathToA), abs(pathGains), 'filled');
grid on;
title('Channel Impulse Response');
xlabel('Delay (s)'); ylabel('Magnitude'); 