function centerOfPressure = calculateCenterOfPressure(finShape, rootChord, tipChord, span, sweepAngle)
    switch lower(finShape)
        case 'aft-swept trapezoidal'
            % Trapezoidal center of pressure
            centerOfPressure = (rootChord + 2 * tipChord) / (3 * (rootChord + tipChord)) * span;
            
        case 'clipped-delta'
            % Clipped delta treated as a trapezoid with adjustment for higher sweep
            centerOfPressure = (rootChord + 2 * tipChord) / (3 * (rootChord + tipChord)) * span;
            
        case 'forward-swept trapezoidal'
            % Calculate center of pressure for a forward-swept trapezoidal fin
            centerOfPressure = (2 * rootChord + tipChord) / (3 * (rootChord + tipChord)) * span;

    end

    % Effective spanwise CoP, adjust for high sweep angles - worst case
    % assumption (sweepAngle > 0)
    if sweepAngle > 0
        centerOfPressure = centerOfPressure + (span * tand(sweepAngle) / 4);
    end
end


% Piqing Liu: 11.9.2 Effects of Mach Number on the Position of the Pressure
% Center of the Wing