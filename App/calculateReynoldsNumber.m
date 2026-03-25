function local_Re = calculateReynoldsNumber(velocity, altitude, characteristic_length)
    % Constants for atmospheric properties
    gamma = 1.4; % Ratio of specific heats for air
    R = 287; % Specific gas constant for air in J/(kg*K)
    mu_0 = 1.716e-5; % Reference viscosity at T0 [Pa·s]
    T0 = 273.15; % Reference temperature [K]
    C = 110.4; % Sutherland's constant [K]

    % Atmospheric properties
    if altitude < 11000
        temp = T0 + 15 - 0.0065 * altitude; % Temperature [K]
        pressure = 101325 * (1 - 0.0065 * altitude / T0)^(5.256); % Pressure [Pa]
    else
        temp = 216.65; % Constant temperature in stratosphere [K]
        pressure = 22632 * exp(-9.81 * (altitude - 11000) / (R * temp)); % Pressure [Pa]
    end
    rho = pressure / (R * temp); % Air density [kg/m^3]

    % Dynamic viscosity using Sutherland's Law
    mu = mu_0 * (temp / T0)^(3/2) * (T0 + C) / (temp + C);

    % Calculate local Reynolds number
    local_Re = (rho * velocity * characteristic_length) / mu;
end
