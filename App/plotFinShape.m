function plotFinShape(finType, tipChord, rootChord, span, sweepAngle, trailingEdgeSweep, finArea, CoP)
    
    % Calculate coordinates based on the input parameters
    % Root chord coordinates
    rootLeadingEdge = [0, 0];  % Origin
    rootTrailingEdge = [rootChord, 0];
    
    % Tip chord coordinates (accounting for sweep angle)
    tipLeadingEdge = [span * tand(sweepAngle), span];
    tipTrailingEdge = [tipLeadingEdge(1) + tipChord, span];
    
    % Plot the fin shape
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

    % Calculate data limits
    xDataLimits = [min([rootLeadingEdge(1), rootTrailingEdge(1), tipTrailingEdge(1), tipLeadingEdge(1)]), ...
                   max([rootLeadingEdge(1), rootTrailingEdge(1), tipTrailingEdge(1), tipLeadingEdge(1)])];
    yDataLimits = [min([rootLeadingEdge(2), rootTrailingEdge(2), tipTrailingEdge(2), tipLeadingEdge(2)]), ...
                   max([rootLeadingEdge(2), rootTrailingEdge(2), tipTrailingEdge(2), tipLeadingEdge(2)])];
    
    % Define a margin (e.g., 10% of the data range)
    xMarginRight = 0.1 * range(xDataLimits);
    xMarginLeft = 0.3 * range(xDataLimits);
    yMarginTop = 0.6 * range(yDataLimits);
    yMarginBottom = 0.1 * range(yDataLimits);
    
    % Set new x and y limits with added margins
    xlim([xDataLimits(1) - xMarginLeft, xDataLimits(2) + xMarginRight]);
    ylim([yDataLimits(1) - yMarginBottom, yDataLimits(2) + yMarginTop]);
    
    % Get the new axis limits after margin adjustments
    xLimits = xlim;
    yLimits = ylim;
    
    % Define the text position relative to the axis limits
    xTextPosLeft = xLimits(1) + 0.05 * range(xLimits);  % 5% from the left boundary
    yTextPosTop = yLimits(2) - 0.05 * range(yLimits);   % 10% from the top boundary
    xTextPosRight = xLimits(2) - 0.4 * range(xLimits);

    text(xTextPosLeft, yTextPosTop, sprintf(['Root Chord: %.1f mm\nTip Chord: %.1f mm\nSpan: %.1f mm\n' ...
          'Sweep Angle: %.1f°'], rootChord, tipChord, span, sweepAngle), 'FontSize', 8, ...
          'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'BackgroundColor', 'w', 'EdgeColor', 'k');

    text(xTextPosRight, yTextPosTop, sprintf('Surface Area: %.1f mm^2\nTrailing Edge Sweep: %.1f°', finArea, trailingEdgeSweep), ...
        'FontSize', 8, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'BackgroundColor', 'w', 'EdgeColor', 'k');
    
    % Add horizontal dashed line at the Center of Pressure (CoP)
    line(xlim, [CoP, CoP], 'Color', 'k', 'LineStyle', '--', 'LineWidth', 1.5);
    text(xLimits(2) - 0.05 * range(xLimits), CoP, 'subsonic CoP', 'FontSize', 8, ...
         'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle', 'BackgroundColor', 'w', 'EdgeColor', 'k');
    
    hold off;
end
