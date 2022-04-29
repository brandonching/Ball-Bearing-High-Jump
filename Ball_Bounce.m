%% Ball Bounce Project
clc; clear; close all;

%% Initial Setup
E = 0.894153; % COR of ball/plate
h = 0.548; % height at which ball is droped from above impact point
obj_x = 0.456; %x length of the object placement from impact
obj_y = 0.062; %y height of the object placement from impact
alpha = 7.72; %vary the plate angle from flat to vertical

% Setup parameters to model projectile with drag
r = 0.0065; % Radius of ball
g = 9.81; % g, gravity, m/s^2
m = (4/3)*pi*r^3 * 1150; % m, mass, kg (1150kg/m^3 for nylon)
A = pi*r^2; % A, drag area, m^2
cd = 0.5; % cd, dimensionless drag coefficient
rho = 1.01; % rho, air density of denver, kg/m^3
y0 = 0; % y, initial vertical position, m
x0 = 0; % x, initial horizontal position, m

%% Solve and Plot Projectile Motion for various angles of alpha
tiledlayout(1,2);
nexttile
hold on
max_height = [];
cleared =[];

% iterate through all the angles, alpha for the plate
for a = alpha
    v = (E * cosd(a) * sqrt(2*g*h)) / (sind(atand(E*cotd(a)))); % v, initial velocity
    angle = atand(E*cotd(a)) - a; % angle, launch angle
    
    [x,y,vx,vy,t] = projectile_motion_drag(v,angle,g,m,A,cd,rho,y0,x0);
    max_height = [max_height max(y)]; % get max height of projectile
    cleared = [cleared max(x > obj_x & y > obj_y)]; % check if the ball will clear the obstacle
    
    if cleared(end)
        plot(x, y, 'g', 'LineWidth', 2); % plot a green path if cleared
    else
        plot(x, y, 'r', 'LineWidth', 2); % plot a red path if failed
    end
end

% plot best path
a = min(alpha(logical(cleared)));
v = (E * cosd(a) * sqrt(2*g*h)) / (sind(acotd(E*tand(a)))); % v, initial velocity
angle = atand(E*cotd(a)) - a; % angle, launch angle
    
[x,y,vx,vy,t] = projectile_motion_drag(v,angle,g,m,A,cd,rho,y0,x0);
plot(x,y, 'b', 'LineWidth', 2);

% plot the obstacle location and labels
plot(obj_x,obj_y, 'b.', 'MarkerSize', 30); 
xlabel('Horizontal Distance (m)')
ylabel('Verticle Distance (m)')
title('Ball Projectile Motion Simulated Paths (All Angles 0-90deg)')
set(gca,'FontSize',14)
axis([0 0.9 0 0.45])

% create custom legend
h=zeros(4,1); 
h(1) = plot(NaN,NaN,'r', 'LineWidth', 2);
h(2) = plot(NaN,NaN,'g', 'LineWidth', 2);
h(3) = plot(NaN,NaN,'b', 'LineWidth', 2);
h(4) = plot(NaN,NaN,'b.', 'MarkerSize', 30);
legend(h, 'Failed Path','Sucessful Path','Best Path', 'Obstacle');

%% Generate and Plot agregated data for angle vs max height
nexttile
hold on
plot(alpha, max_height,'r', 'LineWidth', 2);
plot(alpha(logical(cleared)), max_height(logical(cleared)),'g', 'LineWidth', 2);
xlabel('Plate angle (deg)')
ylabel('Max Height (m)')
title('Affect of Angle on Max Height of Ball')
legend('Does not Clear Obstacle','Clears Obstacle');
set(gca,'FontSize',14)
%% Print out a summary of the data
fprintf("With a COR of e=%f, this plate/ball combination can clear an obstacle %.3fm away\nand %.3fm high when the plate angle is between %.1f-%.1f degrees.\n",E,obj_x,obj_y, min(alpha(logical(cleared))), max(alpha(logical(cleared))))
fprintf("The best angle to clear the obstacle & maximize height is %.1f degrees with a height of %fm.\n", min(alpha(logical(cleared))), max(max_height(logical(cleared))))
