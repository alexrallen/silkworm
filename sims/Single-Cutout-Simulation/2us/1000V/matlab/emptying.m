[step, track, map] = load_sim();

%sweep = track(track.terminator_name == "term_max_r", :);
sweep = track;
trapped = sweep(sweep.total_steps > 100, :);
times = trapped.final_time - trapped.initial_time;

% These are the particle lifetimes that are likely to be trapped. 
hist(times, 25);
title("Emptying Times");
xlabel("Time to Leave Trap (s)");
ylabel("Count");

saveas(gcf,'../img/EmptyingTimes.png')
figure

% Load in and show polarizations
opts = delimitedTextImportOptions("NumVariables", 2);

opts.DataLines = [2, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["FreqGHz", "dBS1222"];
opts.VariableTypes = ["double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

horiz = readtable("../fields/horiz.csv", opts);

arr = table2array(horiz);
plot(arr(:,1), arr(:,2));
title("Horizontal Attenuation");
xlabel("Frequency (GHz)");
ylabel("S12 (dB)");

saveas(gcf,'../img/HorizAtten.png')
figure

vert = readtable("../fields/vert.csv", opts);

arr = table2array(horiz);
plot(arr(:,1), arr(:,2));
title("Vertical Attenuation");
xlabel("Frequency (GHz)");
ylabel("S12 (dB)");

saveas(gcf,'../img/VertAtten.png')
