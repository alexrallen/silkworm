
function [step, track, map] = load_sim()

    basename = "sim";

    % Import data
    opts = delimitedTextImportOptions("NumVariables", 21);
    opts.DataLines = [2, Inf];
    opts.Delimiter = ",";
    opts.VariableNames = ["step_id", "continuous_time", "continuous_length", "time", "position_x", "position_y", "position_z", "momentum_x", "momentum_y", "momentum_z", "magnetic_field_x", "magnetic_field_y", "magnetic_field_z", "electric_field_x", "electric_field_y", "electric_field_z", "electric_potential", "kinetic_energy", "orbital_magnetic_moment", "polar_angle_to_z", "polar_angle_to_b"];
    opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";
    step = readtable("../tracks/" + basename + "_step.csv", opts);
    clear opts


    opts = delimitedTextImportOptions("NumVariables", 39);
    opts.DataLines = [2, Inf];
    opts.Delimiter = ",";
    opts.VariableNames = ["creator_name", "terminator_name", "total_steps", "initial_time", "initial_position_x", "initial_position_y", "initial_position_z", "initial_momentum_x", "initial_momentum_y", "initial_momentum_z", "initial_magnetic_field_x", "initial_magnetic_field_y", "initial_magnetic_field_z", "initial_electric_field_x", "initial_electric_field_y", "initial_electric_field_z", "initial_electric_potential", "initial_kinetic_energy", "initial_orbital_magnetic_moment", "initial_polar_angle_to_z", "initial_polar_angle_to_b", "final_time", "final_position_x", "final_position_y", "final_position_z", "final_momentum_x", "final_momentum_y", "final_momentum_z", "final_magnetic_field_x", "final_magnetic_field_y", "final_magnetic_field_z", "final_electric_field_x", "final_electric_field_y", "final_electric_field_z", "final_electric_potential", "final_kinetic_energy", "final_orbital_magnetic_moment", "final_polar_angle_to_z", "final_polar_angle_to_b"];
    opts.VariableTypes = ["categorical", "categorical", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";
    opts = setvaropts(opts, ["creator_name", "terminator_name"], "EmptyFieldRule", "auto");
    track = readtable("../tracks/" + basename + "_track.csv", opts);
    clear opts

    opts = delimitedTextImportOptions("NumVariables", 3);
    opts.DataLines = [2, Inf];
    opts.Delimiter = ",";
    opts.VariableNames = ["TRACK_INDEX", "FIRST_STEP_INDEX", "LAST_STEP_INDEX"];
    opts.VariableTypes = ["double", "double", "double"];
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";
    map = readtable("../tracks/" + basename + "_map.csv", opts);
    clear opts

end
