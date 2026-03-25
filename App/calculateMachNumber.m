function local_machNumber = calculateMachNumber(speed, altitude)
    % Constants
    T0 = 288.15; % Sea-level standard temperature in Kelvin
    L = -0.0065; % Temperature lapse rate in K/m (for altitudes below 11 km)
    R = 287; % Specific gas constant for dry air in J/(kg*K)
    gamma = 1.4; % Specific heat ratio for dry air

    if altitude > 11000 %[m]
        warndlg("Warning: Altitude is above 11 km => local Mach number calculations are not meant for stratosphere", "calculateMachNumber()");
    end

    % Calculate temperature at the given altitude
    temperature = T0 + L * altitude;

    % Calculate the speed of sound at the given altitude
    local_speedOfSound = sqrt(gamma * R * temperature);

    % Calculate the Mach number
    local_machNumber = speed / local_speedOfSound;
end