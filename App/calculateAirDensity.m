function rho = calculateAirDensity(altitude)
    % Constants
    T0 = 288.15; % Sea-level standard temperature (K)
    P0 = 101325; % Sea-level standard pressure (Pa)
    L = 0.0065; % Temperature lapse rate (K/m)
    R = 287.05; % Specific gas constant for dry air (J/kg·K)
    g = 9.80665; % Acceleration due to gravity (m/s²)
    
    % Calculate temperature and pressure at altitude
    if altitude <= 11000 % Troposphere
        T = T0 - L * altitude;
        P = P0 * (T / T0)^(g / (R * L));
    else
        T = T0 - L * 11000; % Isothermal layer above 11 km
        P = P0 * (T / T0)^(g / (R * L)); % Pressure at 11 km
    end
    
    % Air density
    rho = P / (R * T); % Ideal gas law
end