function plotFinShapeSupersonic(finType, tipChord, rootChord, span, sweepAngle, trailingEdgeSweep, finArea, CoP, maxMachNumber)
    %% Calculate coordinates based on the input parameters
    rootLeadingEdge = [0, 0];  % Origin
    rootTrailingEdge = [rootChord, 0];
    tipLeadingEdge = [span * tand(sweepAngle), span];
    tipTrailingEdge = [tipLeadingEdge(1) + tipChord, span];
    
    %% Plot the fin shape
    figure; hold on; axis equal;
    title(sprintf('Fin Shape: %s', strrep(finType, '-', ' ')));
    xlabel('Chordwise Direction (mm)');
    ylabel('Spanwise Direction (mm)');
    
    % Plot the fin using the fill function with color based on type
    switch finType
        case 'forward-swept trapezoidal'
            color = 'b';
        case 'aft-swept trapezoidal'
            color = 'r';
        case 'clipped-delta'
            color = 'g';
        otherwise
            error('Unrecognized fin type');
    end
    
    fill([rootLeadingEdge(1), rootTrailingEdge(1), tipTrailingEdge(1), tipLeadingEdge(1)], ...
         [rootLeadingEdge(2), rootTrailingEdge(2), tipTrailingEdge(2), tipLeadingEdge(2)], ...
         color, 'FaceAlpha', 0.3, 'EdgeColor', 'k');

    %% Calculate and plot the Mach cone lines if Mach number is supersonic
    if maxMachNumber > 1
        theta = asind(1 / maxMachNumber);  % Mach cone angle in degrees
        coneSlope = tand(theta);           % Slope for the outward Mach cone line
     
        % Fixed x-axis extension for both lines
        xExtension = 100;  % Arbitrary long extension in x-direction

        % Check if the leading edge is supersonic
        if sweepAngle > theta
            leadEdgeText = sprintf('Mach Cone, Ma = %.1f \n subsonic leading edge', maxMachNumber);
        else
            leadEdgeText = sprintf('Mach Cone, Ma = %.1f \n supersonic leading edge', maxMachNumber);
        end

        % Check if the trailing edge is supersonic
        if trailingEdgeSweep > theta
            trailEdgeText = sprintf('Mach Cone, Ma = %.1f \n subsonic trailing edge', maxMachNumber);
        else
            trailEdgeText = sprintf('Mach Cone, Ma = %.1f \n supersonic trailing edge', maxMachNumber);
        end
        % plot Mach Cones
        % Outward Mach cone from root leading edge
        machLineEndX_rootLeading = rootLeadingEdge(1) + xExtension;
        machLineEndY_rootLeading = rootLeadingEdge(2) + coneSlope * xExtension;
        
        line([rootLeadingEdge(1), machLineEndX_rootLeading], [rootLeadingEdge(2), machLineEndY_rootLeading], ...
             'Color', 'k', 'LineStyle', '--', 'LineWidth', 1.5);
        text(machLineEndX_rootLeading - 0.05 * range(xlim), machLineEndY_rootLeading+30, leadEdgeText, ...
             'FontSize', 8, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', ...
             'BackgroundColor', 'w', 'EdgeColor', 'k');
        
        % Outward Mach cone from root trailing edge
        machLineEndX_rootTrailing = rootTrailingEdge(1) + xExtension;
        machLineEndY_rootTrailing = rootTrailingEdge(2) + coneSlope * xExtension;
        
        line([rootTrailingEdge(1), machLineEndX_rootTrailing], [rootTrailingEdge(2), machLineEndY_rootTrailing], ...
             'Color', 'k', 'LineStyle', '--', 'LineWidth', 1.5);
        text(machLineEndX_rootTrailing - 0.05 * range(xlim), machLineEndY_rootTrailing+30, trailEdgeText, ...
             'FontSize', 8, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', ...
             'BackgroundColor', 'w', 'EdgeColor', 'k');
        
        % Inward Mach cone from the tip leading edge
        machLineEndX_tipLeadingInward = tipLeadingEdge(1) + xExtension;  
        machLineEndY_tipLeadingInward = tipLeadingEdge(2) - coneSlope * xExtension; % Negative direction for inward cone

        line([tipLeadingEdge(1), machLineEndX_tipLeadingInward], [tipLeadingEdge(2), machLineEndY_tipLeadingInward], ...
             'Color', 'k', 'LineStyle', '--', 'LineWidth', 1.5);

        % Inward Mach cone from the tip trailing edge
        machLineEndX_tipTrailingInward = tipTrailingEdge(1) + xExtension;  
        machLineEndY_tipTrailingInward = tipTrailingEdge(2) - coneSlope * xExtension; % Negative direction for inward cone

        line([tipTrailingEdge(1), machLineEndX_tipTrailingInward], [tipTrailingEdge(2), machLineEndY_tipTrailingInward], ...
             'Color', 'k', 'LineStyle', '--', 'LineWidth', 1.5);
    
        %% Define the triangle vertices for the Region of application of two-dimensional characteristics to swept back wing (ahead of Mach cone) - linear assumption 
        % Slope-intercept form (y = mx + b) for both lines
        m1 = coneSlope;  % Slope of line from root leading edge
        m2 = -coneSlope; % Slope of line from tip leading edge (negative for inward direction)
        
        b1 = rootLeadingEdge(2) - m1 * rootLeadingEdge(1);  % Intercept for line 1
        b2 = tipLeadingEdge(2) - m2 * tipLeadingEdge(1);    % Intercept for line 2
        
        % Calculate intersection (x, y) by equating the two line equations
        intersectionX = (b2 - b1) / (m1 - m2);
        intersectionY = m1 * intersectionX + b1;

        % Define the triangle vertices for the Mach cone shading
        triangleX = [rootLeadingEdge(1), tipLeadingEdge(1), intersectionX];
        triangleY = [rootLeadingEdge(2), tipLeadingEdge(2), intersectionY];
        
        % Fill the triangle with a semi-transparent color
        fill(triangleX, triangleY, 'k', 'FaceAlpha', 0.1, 'EdgeColor', 'none');

        % Add label for the triangular region
        text(100, -50, ...
            {'Region of application of', 'two-dimensional characteristics', 'to swept back wing', '(ahead of Mach cone) - linear assumption'}, ...
            'FontSize', 8, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
            'BackgroundColor', 'w', 'EdgeColor', 'k');
    else
        warning('Mach cone not plotted because Mach number is <= 1 (subsonic flow).');
    end

    hold off;
end