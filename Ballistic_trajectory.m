clear;clc;
syms dv dt dy v_v y_v v t
t_v = 25; %burn time
thrust = 600;%pounds force
weight = 500;
mass = weight/32.17;
v0 = 0; x0 = 0; t0=0;z0=0;
acceleration = (thrust-weight)/mass;
eqn1 = int(1,dv,v0,v_v) == int(acceleration,dt,0,t_v);
eqn2 = int(1,dy,0,y_v) == int(v,dt,0,v_v);
eqn3 = int(1,dv,v0,v) == int(acceleration,dt,0,t);
[v_v,y_v,v] = solve([eqn1,eqn2,eqn3],[v_v,y_v,v]);
height_equation=y_v
fprintf("If the rocket weighs %.1f pounds and you burn for %.1f seconds with a constant thrust of %.1f pounds force,\n" + ...
"it accelerates at %.1f ft/s " + ...
"then its final velocity when the burn stops is %.2f ft/s \nand the height when the burn finishes is %.2f ft.\n", ...
weight, t_v, thrust,acceleration, (v_v), subs(y_v,t_v));
x_F = 10000;
z_F = 10000;
x_v = (x_F-x0)*.6+x0
z_v = (z_F-z0)*.6+z0
y_v = .7*subs(y_v,t_v); %The reason i multiply by .7 is I want to only go up to 60% of its max height. That way it spends more energy going side ways
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%t = linspace(-4000, 1, 10);
t=[-10000:1:0];
x_0 = x0;
y_0 = 0;
z_0 = z0;
x_f = x_v; %these arent actually final but the mid points
y_f = y_v;
z_f = z_v;
t_0 = x_0-x_f;
a = (-y_f+y_0)/t_0^2;
b = (-z_f+z_0)/t_0;
% Parametric equations
x = t+x_f;
y = a.*t.^2+y_f; % Quadratic component
z = b*t+z_f; % Linear component
% Create a 3D plot
figure;
plot3(x, y, z, 'LineWidth', 4);
grid on; hold on;
plot3(x_0, y_0, z_0, 'bo', 'MarkerSize', 8, 'LineWidth', 2); % 'ro' for red circle
plot3(x_f, y_f, z_f, 'ro', 'MarkerSize', 8, 'LineWidth', 2); % 'ro' for red circle
text(x_0, y_0, z_0, ' Start', 'Color', 'blue', 'FontSize', 10, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
text(x_f, y_f, z_f, ' End', 'Color', 'red', 'FontSize', 10, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left');
% Label the axes
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Z-axis');
title('3D Parabola Plot');
axis equal; % Equal scaling for all axes
% Set view angle
view(3);
grid on;
hold off;
