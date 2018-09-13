dr = pi/180;
gamma = asin(sin(24*dr)/sqrt(2))/dr;
beta = atan(tan(24*dr)/sqrt(2))/dr;

% h_dmd = 22.9;
h_dmd=23.45;

% L = 10;
% h = h_dmd - L*tan(gamma*dr)/tan(beta*dr);

% h = 15.35;
h =0;

% L = 
l = (h_dmd - h)*tan(beta*dr)/tan(gamma*dr);

disp(l);
disp(l/tan(beta*dr));