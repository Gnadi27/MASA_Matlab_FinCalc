function finArea_m = calculateFinArea(rootChord, tipChord, span)
    %trapezoidal, clipped-delta, parallelogram
    %claculates plan-form area in m^2
    finArea = (rootChord + tipChord) * span / 2;
    finArea_m = finArea/10^6;
end