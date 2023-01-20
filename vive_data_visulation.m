%% PROPERTY OF UNIVERSITY OF CALIFORNIA DAVIS - Machine systems Lab
% Authors: Guilherme De Moura Araujo & Sami Kabakibo - Date: 10/22/2021
% Takes Vive tracker coordinate and perform data translation and rotation
% to get a better representation of the ATV.
%% Start
clear; close all; clc
% Add files to the path
d = dir;
folder = d.folder;
path = [folder '\examples'];
addpath(path);
%addpath("C:\Users\gdemoura\Box\Gui\ATV\2. Reach Evaluation\Matlab Files\Vive files");
%% ATV Dimensions - ATVs' coordinates, measured in the field with Vive tracker
% Define which ATVs should be processed
ATVs = [40,41,42,43,44,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66];
n = length(ATVs);
%% Identify the correct axes 

% Definitions:
% X Y Z: True axes (X is the axis along the ATV's width or left-right sides
% Y is the axis along the ATV length or rear-front and Z is the axis along
% the ATV height);
% x y z: First, second, and third column points given by the Vive output.

% The first step is to figure out which axis is which. This is done in an
% error and trial attempt. We first assume that X = x and Y = y. We then
% rotate all points in such a way to perfectly align the wheels of the ATV
%(points #34-#37). Our second assumption is that X = x and Y = z.
% The algorithm performs the same rotation (align points 34 - 37). Lastly,
% we assume that X = y and Y = z and do the same thing all over again.
% At each step, we calculate a few metrics that will assist us in figuring
% out which column (x, y, z) correspond to each axis (X, Y, Z).

% By rotating the data, we automatically line up the points in the correct
% XY plane, i.e., the wheels, seat center and the handlebar are
% automatically aligned.

% Start of variables
coordinates{n} = [];
seat = cell(1,n); handlebar = seat; wheels = seat; seat_p = seat;
handbrake{1,n} = []; throttle{1,n} = []; chassis = seat; footbrake = seat;
% Step 1: X = x, Y = y
thetaXY = zeros(n,1);
%ATV_val = 21;
for i = 1:n
    name = [num2str(ATVs(i)) '.csv']; % Reads all Excel files
    %if atvnum == ATV_val
    %    name = 'ATV Validation data.csv';
    %end
    [system,~,~]= xlsread(name); % Gets point coordinates  
    % Step 2: X = x, Y = z
    backup = system(:,5); % Backup data
    system(:,5) = system(:,6); system(:,6) = backup; 
    % From this point on, we just do the same thing again (translate
    % points, find angles, make transformation, get error metrics, and 
    % visualize how did the transformation work)
    x = system(:,4); y = system(:,5); z = system(:,6);
    xc = system(1,4); yc = system(1,5); zc = system(1,6);
    x = x - xc; y = y-yc; z = z-zc;
    LR_wheel = [x(34),y(34)]; LF_wheel = [x(35),y(35)];
    RR_wheel = [x(37),y(37)]; RF_wheel = [x(36),y(36)];
    dx1 = LF_wheel(1) - LR_wheel(1); dx2 = RF_wheel(1) - RR_wheel(1);
    dy1 = LF_wheel(2) - LR_wheel(2); dy2 = RF_wheel(2) - RR_wheel(2);
    theta1 = atan(dx1/dy1); theta2 = atan(dx2/dy2);
    thetaXY(i) = (theta1+theta2)/2;
    mat1 = [cos(thetaXY(i)) -sin(thetaXY(i)); sin(thetaXY(i)) cos(thetaXY(i))];
    coordinates{i} = [];
    for j = 1:size(system,1)
        coordinates{i} = [coordinates{i},mat1*[x(j);y(j)]];
    end
    coordinates{i} = coordinates{i}';
    
    if coordinates{i}(7,2) < 0
        coordinates{i}(:,2) = coordinates{i}(:,2)*-1;
    end
    
    if coordinates{i}(19,1) < 0 % Flip points around the Y axis in case
        % they are flipped (e.g., throttle lever x < seat center x
        coordinates{i}(:,1) = coordinates{i}(:,1)*-1;
    end
    
    coordinates{i} = [coordinates{i},z];
    
    seat{i} = coordinates{i}(1:5,:); % Just for visualization purposes
    seat_p{i} = [seat{i}(2,:);seat{i}(5,:);seat{i}(3,:);seat{i}(4,:);seat{i}(2,:)];
    handlebar{i} = coordinates{i}(6:8,:); % Just for visualization purposes
    handbrake{i} = coordinates{i}(9:11,:); % Just for visualization purposes
    throttle{i} = coordinates{i}(17:19,:); % Just for visualization purposes
    chassis{i} = coordinates{i}(21:32,:);
    wheels{i} = coordinates{i}(34:37,:); % Just for visualization purposes
    footbrake{i} = [coordinates{i}(20,:); coordinates{i}(38,:)];
    
    
    figure(ATVs(i)) % Visualize how well does the points match our expectations
    patch(seat_p{i}(:,1),seat_p{i}(:,2),'b');
    hold on;
    plot(handlebar{i}(:,1),handlebar{i}(:,2),'g-');
    plot(handbrake{i}(:,1),handbrake{i}(:,2),'m-');
    plot(throttle{i}(:,1),throttle{i}(:,2),'c-');
    plot(chassis{i}(:,1),chassis{i}(:,2),'-','color',[0.8500 0.3250 0.0980]);
    plot(wheels{i}(:,1),wheels{i}(:,2),'ko');
    plot(footbrake{i}(:,1),footbrake{i}(:,2),'*','color',[0.4940 0.1840 0.5560]);
    title('X = x, Y = z'); axis('square');
end
%% Visual aid (I)
% PLOTS in 3D - Visualize how the ATV looks like in 3-D after our XY transformation
close all;
figure()
s1 = ceil(sqrt(n));
s2 = ceil(n/s1);

close all
figure()
for i = 1:n
    subplot(s2,s1,i)
    plot3(handlebar{i}(:,1),handlebar{i}(:,2),handlebar{i}(:,3),'g-','MarkerFaceColor','g');
    hold on
    patch(seat_p{i}(:,1),seat_p{i}(:,2),seat_p{i}(:,3),'b');
    plot3(handbrake{i}(:,1),handbrake{i}(:,2),handbrake{i}(:,3),'m','MarkerFaceColor','m');
    plot3(throttle{i}(:,1),throttle{i}(:,2),throttle{i}(:,3),'c','MarkerFaceColor','c');
    plot3(footbrake{i}(:,1),footbrake{i}(:,2),footbrake{i}(:,3),'yo','MarkerFaceColor','y');
    if length(coordinates{i}) > 36
        plot3(coordinates{i}(34:37,1),coordinates{i}(34:37,2),coordinates{i}(34:37,3),'ko','MarkerFaceColor','k');
    xlabel('X');ylabel('Y');zlabel('Z');
    end
    patch(chassis{i}(:,1),chassis{i}(:,2),chassis{i}(:,3),'r');
    axis('square')
    title(ATVs(i));
end
%% Organize the new data to make it easier for the user
for i = 1:n
    coordinates{2,i} = coordinates{1,i};
    coordinates{1,i} = "ATV = " + ATVs(i);
end
%% Save new coordinates in a csv file
close all;
save = convertCharsToStrings(questdlg('Do you want to save the newly rotated data?', 'Data handling', ...
	'Yes','No','No')) == 'Yes';

if save
    dir = convertCharsToStrings(path) + '\Rotated Data\';
    if ~exist(dir, 'dir')
        mkdir(dir);   %create the directory
    end
    
    for i = 1:length(ATVs)
        name = [num2str(ATVs(i)) '_rot.csv'];
        %if i == ATV_val
        %  name = ['ATV Validation data' '_rot.csv'];
        %end
        fulldestination = fullfile(dir,name);
        mat{1,1} = 'Point Set Index'; mat{1,2} = 'Point Set Label';
        mat{1,3} = 'Point Index'; mat{1,4} = 'Position X';
        mat{1,5} = 'Position Y'; mat{1,6} = 'Position Z';
        for j = 1:length(coordinates{2,i})
            mat{j+1,1} = 1;
            mat{j+1,2} = 'Point Set 1';
            mat{j+1,3} = j;
            mat{j+1,4} = coordinates{2,i}(j,1);
            mat{j+1,5} = coordinates{2,i}(j,2);
            mat{j+1,6} = coordinates{2,i}(j,3);
        end
        writecell(mat,fulldestination);
    end
end
coordinates = coordinates';
%%
clear('atvnum','backup','brake','c1','c2','c3','c4','c5','chassis','d',...
    'dir','dT','dx1','dx2','dy1','dy2','dz1','dz2','dzH','dzHandlebar',...
    'dzS','dzSeat','error','error_handlebar','error_seat','folder',...
    'fulldestination','handbrake','handlebar','i','j','LF_wheel','LR_wheel',...
    'mat','mat1','mat2','mat3','name','new_ATV','p','path','RF_wheel',...
    'RR_wheel','s','n','save','seat','system','t','theta1','theta2',...
    'thetaXY','thetaXZ','thetaYZ','throttle','true','v','vive','wheels','x',...
    'xc','XZ','XZROT','y','yc','YZ','YZROT','z','zc','s1','s2','ATVs','seat_p','footbrake')