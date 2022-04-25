%% Ball Bounce Project
clc; clear; close all;

%% Initial Setup
E = 0.894153; % COR of ball/plate
h = 0.5; % height at which ball is droped from above impact point
obj_x = 0.454025; %x length of the object placement from impact
obj_y =0.060325; %y height of the object placement from impact
alpha = 0:0.1:90;

% Setup parameters to model projectile with drag
g = 9.81; % g, gravity, m/s^2
m = 0.523598776 * 0.00114; % m, mass, kg
A = pi*0.01^2; % A, drag area, m^2
cd = 0.5; % cd, dimensionless drag coefficient
rho = 1.01; % rho, air density of denver, kg/m^3
y0 = 0; % y, initial vertical position, m
x0 = 0; % x, initial horizontal position, m

tiledlayout(1,2);
nexttile
hold on
max_height = [];
cleared =[];
%% Solve and Plot Projectile Motion for various angles of alpha

% iterate through all the angles, alpha for the plate
for a = alpha
    v = (E * cosd(a) * sqrt(2*g*h)) / (sind(acotd(E*tand(a)))); % v, initial velocity
    angle = acotd(E*tand(a)) - a; % angle, launch angle
    
    [x,y,vx,vy,t] = projectile_motion_drag(v,angle,g,m,A,cd,rho,y0,x0);
    max_height = [max_height max(y)]; % get max height of projectile
    cleared = [cleared max(x > obj_x & y > obj_y)]; % check if the ball will clear the obstacle
    
    if cleared(end)
        plot(x, y, 'g', 'LineWidth', 2); % plot a green path if cleared
    else
        plot(x, y, 'r', 'LineWidth', 2); % plot a red path if failed
    end
end

% plot the obstacle location and labels
plot(obj_x,obj_y, 'b.', 'MarkerSize', 30); 
xlabel('Horizontal Distance (m)')
ylabel('Verticle Distance (m)')
title('Ball Projectile Motion Simulated Paths (All Angles 0-90deg)')
set(gca,'FontSize',14)
axis([0 0.75 0 0.4])

% create custom legend
h=zeros(3,1); 
h(1) = plot(NaN,NaN,'r', 'LineWidth', 2);
h(2) = plot(NaN,NaN,'g', 'LineWidth', 2);
h(3) = plot(NaN,NaN,'b.', 'MarkerSize', 30);
legend(h, 'Failed Path','Sucessful Path','Obstacle');

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
fprintf("With a COR of e=%f, this plate/ball combination can clear an obstacle %fm away\nand %fm high when the plate angle is between %.1f-%.1f degrees.\n",E,obj_x,obj_y, min(alpha(logical(cleared))), max(alpha(logical(cleared))))
fprintf("The best angle to clear the obstacle & maximize height is %.1f degrees with a height of %fm.\n", min(alpha(logical(cleared))), max(max_height(logical(cleared))))
