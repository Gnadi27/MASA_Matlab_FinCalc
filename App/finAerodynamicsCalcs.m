function finAerodynamicsCalcs(finShape, tipChord, rootChord, span, sweepAngle, trailingEdgeSweep)
% --- Create figure for the output of app ---
    %relative box positions
    out_window_size = [600,200];
    border = 10;
    out_box_pos = [border, border];
    out_box_size = out_window_size-2*[border,border];

    out_box_col1_pos = out_box_pos+[0, out_window_size(2)-100];
    out_box_col2_pos = out_box_col1_pos+[165,0];

    fig_out = uifigure('Position', [150, 150, out_window_size], 'Name', 'Rocket Fin Aerodynamic Forces');

    % Panel for Output Data
    outputPanel = uipanel(fig_out, 'Title', 'Output Graphs', 'Position', [out_box_pos, out_box_size]);

        % Output Field for Fin Properties
        uilabel(outputPanel, 'Position', [out_box_col1_pos, 200, 22], 'Text', 'Surface Area (m^2):');
        surfaceAreaField = uitextarea(outputPanel, 'Position', [out_box_col2_pos, 100, 22], 'Editable', 'off');

        uilabel(outputPanel, 'Position', [out_box_col1_pos+[0,-30], 200, 22], 'Text', 'subsonic CoP from root (mm):');
        centerOfPressureField = uitextarea(outputPanel, 'Position', [out_box_col2_pos+[0,-30], 100, 22], 'Editable', 'off');
        


% --- Calculate fin properties ---
    surfaceArea = calculateFinArea(rootChord, tipChord, span);
    centerOfPressure = calculateCenterOfPressure(finShape, rootChord, tipChord, span, sweepAngle);
    
    % Update UI output fields
    surfaceAreaField.Value = sprintf('%.2f', surfaceArea);
    centerOfPressureField.Value = sprintf('%.2f mm', centerOfPressure);

% --- Plot Fin ---
    plotFinShape(finShape, tipChord, rootChord, span, sweepAngle, trailingEdgeSweep, surfaceArea, centerOfPressure)
end