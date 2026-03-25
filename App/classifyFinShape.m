function [finShape, trailingEdgeSweep] = classifyFinShape(rootChord, tipChord, span, sweepAngle)
   
    % Calculate leading and trailing edge positions
    xLeadingTip = span * tand(sweepAngle);
    xTrailingTip = xLeadingTip + tipChord;
    
    % Calculate the trailing edge angle in degrees
    trailingEdgeSweep = 90-atan2d(span, xTrailingTip - rootChord);
    
    %Classify based on trailing edge angle
    if trailingEdgeSweep < 0
        finShape = 'forward-swept trapezoidal';
    elseif trailingEdgeSweep > 0
        finShape = 'aft-swept trapezoidal';
    elseif trailingEdgeSweep == 0
        finShape = 'clipped-delta';
    else
        finShape = 'NaN';
    end
end