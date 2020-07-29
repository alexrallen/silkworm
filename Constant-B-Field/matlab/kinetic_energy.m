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
c = 3e8;


% Calculate change in kinetic energy across simulation
dat = track.final_kinetic_energy - track.initial_kinetic_energy;
dat = dat ./ 1e3;

% Histogram of kinetic energy errors
hist(dat, 10000);

title('\Delta Kinetic Energy')
xlabel('Kinetic Energy Change (keV)')
ylabel('Count (n=1e4)')






