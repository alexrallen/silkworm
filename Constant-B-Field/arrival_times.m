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
m_0 = 510.999e3;
ke = 511e3;
l = 0.3;

v = sqrt(1 - 1/((ke/m_0 + 1)^2));

% Verify distrobution of arrival times
final_time = track.final_time;
vz = l./final_time;
vz = vz / (v*c);

% Should be constant
nbins = 15;
avg = mean(hist(vz, nbins));
dev = std(hist(vz, nbins));
hist(vz, nbins); hold on;

yline(avg + 2*dev,'color','green');
yline(avg,'color','red');
yline(avg - 2*dev,'color','green');

title("Portion of Velocity on Z-axis");
ylabel("Counts (N = 1e4)");
xlabel("v_z/v");