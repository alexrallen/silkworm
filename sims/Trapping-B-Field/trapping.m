% Set simulation source
src = "trap";

% Load data
if exist('oldsrc', 'var') == 0
    [step, track, map] = load_sim(src);
elseif oldsrc ~= src
    [step, track, map] = load_sim(src);
end
oldsrc = src;


times_ahead = [0; step.position_z(1:end-1)];
times = step.position_z;
times_behind = [step.position_z(2:end); 0];
turnaround = (abs(times_ahead) < abs(times)).*(abs(times_behind) < abs(times));

%turnaround = abs(diff(diff(step.momentum_z) > 0));

m = arrayfun(@(x,y,z)  repmat(x + 1, z - y + 1, 1), map.TRACK_INDEX, map.FIRST_STEP_INDEX, map.LAST_STEP_INDEX, 'UniformOutput', false);
m = vertcat(m{:});

step.track_id = m;
turn_data = step(turnaround == 1,:);

turnlist = arrayfun(@(x) table2array(turn_data(turn_data.track_id == (x + 1),'time')), map.TRACK_INDEX, 'UniformOutput', false);
zlist = arrayfun(@(x) table2array(turn_data(turn_data.track_id == (x + 1),'position_z')), map.TRACK_INDEX, 'UniformOutput', false);

turntimes = arrayfun(@(x) mean(diff(x{1, 1}(2:end-1))), turnlist);
turnz = arrayfun(@(x) mean(abs(diff(x{1, 1}(2:end-1)))), zlist);
track.turn_time = turntimes;
track.turn_z = turnz;

% Measured Trapping Fraction
disp(["Measured Trapping Fraction " num2str(size(track(track.terminator_name == "term_max_steps", :), 1) / size(track, 1))]);

% Measured Critical Angle
disp(["Measured Critical Pitch Angle " num2str(min(track(track.turn_z > 0, :).initial_polar_angle_to_z))]);

% Calculated Trapping Fraction
rm = max(step.magnetic_field_z) / min(step.magnetic_field_z); % Mirror ratio
rat = 1 / sqrt(rm); % Loss cone
cpa = 90 - acosd(rat); % Critical Pitch Angle
tf = cosd(cpa); % Trapping fraction

disp(["Analytical Trapping Fraction " num2str(tf)]);
disp(["Analytical Critical Pitch Angle " num2str(cpa)]);

figure;
scatter(step.position_z, step.magnetic_field_z);
title("Magnetic Field")
xlabel("z position (m)")
ylabel("B-Field z-component (T)")

figure;
scatter(track.initial_polar_angle_to_z, track.turn_time);
title("Oscillation Time vs. Pitch Angle")
xlabel("Pitch Angle (degrees)");
ylabel("Elapsed Time Between Classical Turning Points (s)");

figure;
scatter(track.initial_polar_angle_to_z, track.turn_z);
title("Oscillation Width vs. Pitch Angle");
xlabel("Pitch Angle (degrees)");
ylabel("Distance Between Classical Turning Points (m)");


%% Trapping Fraction for Uniform Spatial Dist. 

% Set simulation source
src = "trap_uniform";

% Load data
if exist('oldsrc', 'var') == 0
    [~, track, ~] = load_sim(src);
elseif oldsrc ~= src
    [~, track, ~] = load_sim(src);
end
oldsrc = src;

% Calculate maximum possible radius to be trapped

% Constants
m_0 = 510.999e3;
c = 3e8;
theta = -90;
R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
m = 9.109e-31;
q = 1.602e-19;
E = 200000;
B = 1;
l = 0.3;

% Get max radius from center to be trapped (without colliding with edges)
ke = 50e3:1:500e3;
%ke = [ 100e3  100e3 ];
v = c.*sqrt(1 - 1./((ke./m_0 + 1).^2));
gamma = 1./sqrt(1 - v.^2./c^2);
lmax = gamma.*m.*v./(q*B);
r = 0.0057785;
rmax = r - lmax;
tfke = rmax ./ r;
tf_r = mean(tfke);

% Get trapping fraction as function of z-distance from center of trap

% First, we approximate the B-field as a parabolic field
btmax = 0.1;
btmin = -0.1;
% Now we calculate the probabilities inside this parabola
zp = 0:0.0001:0.1; %Parabolic space
bp = 10.*zp.^2 + 0.9; %Parabolic approximation
rmp = 1 ./ bp; %Mirror ratio vs z
ratp = 1 ./ sqrt(rmp); %Velocity ratio vs z
cpap = 90 - acosd(ratp); %Critical pitch angle vs z
tfp = (cosd(cpap) + max(cosd(cpap)))/2; % Trapping fraction vs z (average because generally half of these will go the opposite direction and cross the center)
tf_z = trapz(zp, tfp) / l;

atf = tf_r * tf_z;

disp(["Analytical Trapping Fraction " num2str(atf)]);
disp(["Trapping Fraction " num2str(size(track(track.terminator_name == "term_max_steps", :), 1) / size(track, 1))]);

%disp(["Left Geometry" num2str(size(track(track.terminator_name == "term_max_z", :), 1) / size(track, 1))]);
%disp(["Larmor Exceeds Geometry" num2str(size(track(track.terminator_name == "term_max_r", :), 1) / size(track, 1))]);


