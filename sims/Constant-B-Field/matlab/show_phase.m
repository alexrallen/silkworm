% Set simulation source
src = "const";

% Load data
if exist('oldsrc', 'var') == 0
    [step, track, map] = load_sim(src);
elseif oldsrc ~= src
    [step, track, map] = load_sim(src);
end
oldsrc = src;

% Constants
m_0 = 510.999e3;
ke = 100e3;
c = 3e8;
theta = -90;
R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
m = 9.109e-31;
q = 1.602e-19;
E = 200000;
B = 1;
l = 0.3;

v = c*sqrt(1 - 1/((ke/m_0 + 1)^2));
gamma = 1/sqrt(1 - v^2/c^2);


% Get initial phase
vtan = v.*vecnorm([track.initial_momentum_x track.initial_momentum_y], 2, 2)./... 
    vecnorm([track.initial_momentum_x track.initial_momentum_y track.initial_momentum_z], 2, 2);
    
larmor = gamma.*m.*vtan./(q*B);

ic = -1*([track.initial_momentum_x track.initial_momentum_y]./vecnorm([track.initial_momentum_x track.initial_momentum_y], 2, 2))*R;

% Get final phase
fc = -1*([track.final_momentum_x track.final_momentum_y]./vecnorm([track.final_momentum_x track.final_momentum_y], 2, 2))*R;

% Get number of complete rotations
rots = arrayfun(@(x,y) sum(diff(diff(step(x + 1:y+1, :).position_x.^2 + step(x + 1:y+1, :).position_y.^2) > 0) == 1),map.FIRST_STEP_INDEX, map.LAST_STEP_INDEX);

vecs = arrayfun(@(x,y) -1*([step(x + 1:y+1, :).momentum_x step(x + 1:y+1, :).momentum_y]./vecnorm([step(x + 1:y+1, :).momentum_x step(x + 1:y+1, :).momentum_y], 2, 2))*R,map.FIRST_STEP_INDEX, map.LAST_STEP_INDEX, 'UniformOutput', false);
rots2 = arrayfun(@(a, b, x) sum(diff(atan2(a*x{1,1}(:,2) - b*x{1,1}(:,1), a*x{1,1}(:,1) + b*x{1,1}(:,2)) > 0) == 1), ic(:, 1), ic(:, 2), vecs);

% Get simulated phase shifts
dph = arrayfun(@(a, b, x, y) atan2(a*y-b*x,a*x+b*y), ic(:, 1), ic(:, 2), fc(:, 1), fc(:, 2));
phase = rots2*2*pi + dph + (dph < 0)*2*pi;


% Compute expected phase shifts

[az, el, ~] = arrayfun(@(x, y, z) cart2sph(x, y, z), track.initial_momentum_x, track.initial_momentum_y, track.initial_momentum_z,'UniformOutput',false);
[vx, vy, vz] = arrayfun(@(x, y, z) sph2cart(x, y, z), cell2mat(az), cell2mat(el), v*ones(size(el, 1), 1),'UniformOutput',false);

h = size(cell2mat(vx));
v = [cell2mat(vx), cell2mat(vy), zeros(h(1), 1)];
r = [-ic.*larmor, zeros(h(1), 1)];

nm = vecnorm(r, 2, 2);
vm = vecnorm(v, 2, 2);
w = vm ./ nm;

t = l ./ cell2mat(vz);
phase2 = w.*t;

% Compare phase results
err = phase - phase2;

%% Plotting
%Graph features

hist(err, 10000);
title("Aggregate \Delta\theta Error")
xlabel("Error (rad)")
ylabel("Count (N = 1e4)")

%Graph z-vel vs err

figure
scatter(track.initial_momentum_z, err);
title("z-Momentum vs. Phase Error");
xlabel("p_z");
ylabel("Error (rad)");








