% Set simulation source
src = "empty_mapped";

% Load data
if exist('oldsrc', 'var') == 0
    [step, track, map] = load_sim(src);
elseif oldsrc ~= src
    [step, track, map] = load_sim(src);
end
oldsrc = src;

sweep = track(track.terminator_name == "term_max_r", :);
trapped = sweep(sweep.total_steps > 100, :);
times = trapped.final_time - trapped.initial_time;

% These are the particle lifetimes that are likely to be trapped. 
hist(times, 25);
title("Emptying Times");
xlabel("Time to Leave Trap (s)");
ylabel("Count")

