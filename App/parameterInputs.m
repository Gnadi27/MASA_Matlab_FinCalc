function parameterInputs

% --- Create figure for the  input of app ---
    %relative box positions
    in_window_size = [600,300];
    border = 10;
    in_box_pos = [border, border];
    in_box_size = in_window_size-2*[border,border];

    in_box_col1_pos = in_box_pos+[0, in_window_size(2)-100];
    in_box_col2_pos = in_box_col1_pos+[155,0];
    in_box_col3_pos = in_box_col2_pos+[150,0];
    in_box_col4_pos = in_box_col3_pos+[155,0];

    
    fig_in = uifigure('Position', [100, 100, in_window_size], 'Name', 'Rocket Fin Aerodynamic Forces');

    % Panel for Input Parameters
    inputPanel = uipanel(fig_in, 'Title', 'Input Parameters', 'Position', [in_box_pos, in_box_size]);
    
        % CSV File Upload
        uilabel(inputPanel, 'Position', [in_box_col1_pos, 200, 22], 'Text', 'Velocity-Altitude CSV File:');
        fileBtn = uibutton(inputPanel, 'push', 'Text', 'Upload CSV', 'Position', [in_box_col2_pos, 100, 22], ...
            'ButtonPushedFcn', @(~, ~) uploadCSV());
    
        % Dropdown for Fin Shape
        uilabel(inputPanel, 'Position', [in_box_col1_pos+[0,-40], 200, 22], 'Text', 'Fin Shape:');
        finShapeDropdown = uidropdown(inputPanel, 'Position', [in_box_col2_pos+[0,-40], 100, 22], ...
            'Items', {'Trapezoidal', 'Clipped-Delta', 'Sym. Trapezoidal (Forward-Swept)', 'Parallelogram (Sym. Aft-Swept)'});
    
        % Input Fields for Fin Dimensions
        uilabel(inputPanel, 'Position', [in_box_col1_pos+[0,-80], 200, 22], 'Text', 'Tip Chord Length (mm):');
        tipChordInput = uieditfield(inputPanel, 'numeric', 'Position', [in_box_col2_pos+[0,-80], 100, 22]);
    
        uilabel(inputPanel, 'Position', [in_box_col1_pos+[0,-110], 200, 22], 'Text', 'Root Chord Length (mm):');
        rootChordInput = uieditfield(inputPanel, 'numeric', 'Position', [in_box_col2_pos+[0,-110], 100, 22]);
    
        uilabel(inputPanel, 'Position', [in_box_col1_pos+[0,-140], 200, 22], 'Text', 'Span (mm):');
        spanInput = uieditfield(inputPanel, 'numeric', 'Position', [in_box_col2_pos+[0,-140], 100, 22]);
    
        uilabel(inputPanel, 'Position', [in_box_col1_pos+[0,-170], 200, 22], 'Text', 'Sweep Angle (deg):');
        sweepAngleInput = uieditfield(inputPanel, 'numeric', 'Position', [in_box_col2_pos+[0,-170], 100, 22]);
    
        % Input Fields for AoA and Roll Rate
        uilabel(inputPanel, 'Position', [in_box_col3_pos+[0,-80], 200, 22], 'Text', 'Angle of Attack (deg):');
        AoAInput = uieditfield(inputPanel, 'numeric', 'Position', [in_box_col4_pos+[0,-80], 100, 22]);
    
        uilabel(inputPanel, 'Position', [in_box_col3_pos+[0,-110], 200, 22], 'Text', 'Roll Rate (rpm):');
        rollRateInput = uieditfield(inputPanel, 'numeric', 'Position', [in_box_col4_pos+[0,-110], 100, 22]);
    

    function uploadCSV()
        global altitudes velocities;  % Declare as global variables

        [file, path] = uigetfile('*.csv', 'Select CSV file');
        if isequal(file, 0)
            disp('User canceled file selection');
        else
            csvFilePath = fullfile(path, file);
        
            % Load CSV file data
            data = readmatrix(csvFilePath);
            
            % Assuming altitude is in the first column and velocity is in the second column
            altitudes = data(:, 1);  % Replace with correct column index for altitude if necessary
            velocities = data(:, 2); % Replace with correct column index for velocity if necessary
            
                
            % Call the plot function with Mach number
            plotRocketFlightProfile(csvFilePath);  % Call any external plotting functions here
        end
    end

% --- Calculation button to trigger calculations ---
   
    % Calculation button
    calcBtn = uibutton(inputPanel, 'push', 'Text', 'Calculate', ...
        'Position', [in_box_col4_pos(1), in_box_col4_pos(2), 100, 30], ...
        'ButtonPushedFcn', @(~, ~) calculateFinProperties());
    
    % Function to calculate and update the fin properties
    function calculateFinProperties()
        global altitudes velocities;  % Declare the variables as global
        disp_assumption('reset'); % Reset assumptions display
        disp_warning('reset'); % Reset warning windows
        selectedShape = finShapeDropdown.Value;

        if strcmp(selectedShape, 'Trapezoidal')
            [finShape, trailingEdgeSweep] = classifyFinShape(rootChordInput.Value, tipChordInput.Value, spanInput.Value, sweepAngleInput.Value);
            % Use user-provided tip chord for trapezoidal
            tipChord = tipChordInput.Value;

        elseif strcmp(selectedShape, 'Clipped-Delta')
            finShape = 'clipped-delta';
            % Calculate tip chord and trailing edge angle for perfect delta fin
            tipChord = rootChordInput.Value-spanInput.Value*tand(sweepAngleInput.Value);
            trailingEdgeSweep = 0;
            if tipChord < 0
                errordlg('Invalid configuration: span * tan(sweepAngle) exceeds rootChord. Adjust parameters.');
            else
                tipChordInput.Value = tipChord;  % Update the field with calculated value
            end

        elseif strcmp(selectedShape, 'Sym. Trapezoidal (Forward-Swept)')
            finShape = 'forward-swept trapezoidal';
            % Calculate tip chord and trailing edge angle for symmetric forward swept trapezoidal (Isosceles Trapezoid) fin
            trailingEdgeSweep = - sweepAngleInput.Value;
            tipChord = rootChordInput.Value-2*spanInput.Value*tand(sweepAngleInput.Value);
            if tipChord < 0
                errordlg('Invalid configuration: span * tan(sweepAngle) exceeds rootChord. Adjust parameters.');
            else
                tipChordInput.Value = tipChord;  % Update the field with calculated value
            end
        
        elseif strcmp(selectedShape, 'Parallelogram (Sym. Aft-Swept)')
            finShape = 'aft-swept trapezoidal';
            trailingEdgeSweep = sweepAngleInput.Value;
            tipChord = rootChordInput.Value;
            if tipChord < 0
                errordlg('Invalid configuration: span * tan(sweepAngle) exceeds rootChord. Adjust parameters.');
            else
                tipChordInput.Value = tipChord;  % Update the field with calculated value
            end
        else
            errordlg("No valid fin shape in dropdown menu recognized")
        end
        drawnow %update input UI window

        % Call other functions here, passing the calculated or user-provided tip chord
        finAerodynamicsCalcs(finShape, tipChord, rootChordInput.Value, spanInput.Value, sweepAngleInput.Value, trailingEdgeSweep);
        FinLoadCalcs(finShape, tipChord, rootChordInput.Value, spanInput.Value, sweepAngleInput.Value, trailingEdgeSweep, velocities, altitudes, AoAInput.Value);
    end
end