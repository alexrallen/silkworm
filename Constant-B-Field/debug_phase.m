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
m = 9.109e-31;
q = 1.602e-19;
B = 1;
m_0 = 510.999e3;
c = 3e8;
theta = -90;
R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];

gamma_old = gamma;

errors = [];
vari = [];
raderr = [];

factor = [];

for i=1:100
    
    loop = 0;
    step_data = step(map.FIRST_STEP_INDEX(i) + 1 : map.LAST_STEP_INDEX(i), : );
    time = step_data.time;
    time = time - time(1);
    
    mom = [step_data.momentum_x step_data.momentum_y];
    nmom = mom./arrayfun(@(x, y) norm([x y]), mom(:, 1), mom(:, 2));
    ic = -1*cell2mat(arrayfun(@(x, y) [x y]*R, nmom(:, 1), nmom(:, 2),'UniformOutput',false));
    phase_sim = atan2d(ic(:, 2),ic(:, 1)) + 360.*(ic(:, 2)< 0);
    phase_sim = phase_sim - phase_sim(1);
    phase_sim = phase_sim + 360*(phase_sim < 0);
    
    te = step_data.kinetic_energy(1) + m_0;
    gamma = te / m_0;
    v0 = sqrt(1 - 1/(gamma^2))*c;
    
    [az, el, ~] = cart2sph(step_data.momentum_x(1), step_data.momentum_y(1), step_data.momentum_z(1));
    [vx, vy, vz] = sph2cart(az, el, v0);
        
    v = [vx vy 0];
    
    % Calculate expected lamar
    lamar = gamma*m*norm(v)/(q*B);
    
    r = [-ic(1, :)*lamar, 0];
    
    w = (norm(v) / norm(r));
    phase_calc = (w.*time);
    
    a = cosd(phase_sim);
    b = cosd(phase_calc);
    
    %figure; 
    %plot(step_data.time, cosd(phase_sim)); hold on
    %plot(step_data.time, cos(phase_calc)); hold on
    
    %Err stuff
    
    %a = diff(phase_sim);
    %b = diff((phase_calc*180)/pi);
    %err = a(1) / b(1);
    %errors = [errors; err];
    %vari = [vari; norm(v)];
    %raderr = [raderr; lamar / d];
    
    factor = [factor; step_data.momentum_z(1) / vz];
    
end

%scatter(vari, errors);
%figure;
%scatter(vari, raderr);
%figure;
%scatter(errors, raderr);


