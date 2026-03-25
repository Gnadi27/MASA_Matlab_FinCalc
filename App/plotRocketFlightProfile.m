function plotRocketFlightProfile(csvFilePath)
    % Read data from CSV with preserved variable names
    data = readtable(csvFilePath, 'VariableNamingRule', 'preserve');

    % Ensure the data contains 'Altitude (m)' and 'Speed (m/s)' columns
    if all(ismember({'Altitude (m)', 'Speed (m/s)'}, data.Properties.VariableNames))
        % Calculate Mach number at each altitude and speed
        mach_number = arrayfun(@(s, a) calculateMachNumber(s, a), data.("Speed (m/s)"), data.("Altitude (m)"));
        
        % Plot with shaded patches for subsonic, transonic, and supersonic regions
        fig_plot_with_patches = uifigure('Name', 'Rocket Flight Profile with Regions');
        ax1 = uiaxes(fig_plot_with_patches, 'Position', [50, 50, 500, 300], 'Layer', 'top');  % Ensure line plots on top
        
        % Plot altitude vs. speed as a smooth line on top of patches
        plot(ax1, data.("Altitude (m)"), data.("Speed (m/s)"), '-', 'LineWidth', 1.5, 'DisplayName', 'Flight Profile');

        % Define Y limits
        y_limits = [min(data.("Speed (m/s)")) max(data.("Speed (m/s)"))];
        
        % Subsonic region (0 < Ma < 1)
        subsonic_index = mach_number < 1;
        patch(ax1, [data.("Altitude (m)")(subsonic_index); flipud(data.("Altitude (m)")(subsonic_index))], ...
            [y_limits(1) * ones(sum(subsonic_index), 1); y_limits(2) * ones(sum(subsonic_index), 1)], ...
            'b', 'FaceAlpha', 0.1, 'EdgeColor', 'none', 'DisplayName', 'Subsonic (Ma < 1)');
        
        % Transonic region (0.8 < Ma < 1.2)
        transonic_index = mach_number >= 0.8 & mach_number <= 1.2;
        patch(ax1, [data.("Altitude (m)")(transonic_index); flipud(data.("Altitude (m)")(transonic_index))], ...
            [y_limits(1) * ones(sum(transonic_index), 1); y_limits(2) * ones(sum(transonic_index), 1)], ...
            'y', 'FaceAlpha', 0.1, 'EdgeColor', 'none', 'DisplayName', 'Transonic (0.8 < Ma < 1.2)');
        
        % Supersonic region (Ma > 1)
        supersonic_index = mach_number > 1;
        patch(ax1, [data.("Altitude (m)")(supersonic_index); flipud(data.("Altitude (m)")(supersonic_index))], ...
            [y_limits(1) * ones(sum(supersonic_index), 1); y_limits(2) * ones(sum(supersonic_index), 1)], ...
            'r', 'FaceAlpha', 0.1, 'EdgeColor', 'none', 'DisplayName', 'Supersonic (Ma > 1)');

        % Configure plot appearance
        title(ax1, 'Rocket Flight Profile with Mach Regions');
        xlabel(ax1, 'Altitude (m)');
        ylabel(ax1, 'Speed (m/s)');
        grid(ax1, 'on');

        % Legend to identify regions and flight profile
        legend(ax1, 'show');
        
        % Separate plot without patches for interactive selection
        fig_plot_no_patches = uifigure('Name', 'Rocket Flight Profile');
        ax2 = uiaxes(fig_plot_no_patches, 'Position', [50, 50, 500, 300], 'Layer', 'top');
        plot(ax2, data.("Altitude (m)"), data.("Speed (m/s)"), '-', 'LineWidth', 1.5, 'DisplayName', 'Flight Profile');
        
        % Configure appearance of second plot
        title(ax2, 'Rocket Flight Profile');
        xlabel(ax2, 'Altitude (m)');
        ylabel(ax2, 'Speed (m/s)');
        grid(ax2, 'on');
        legend(ax2, 'show');
        
    else
        % Create a figure for the alert in case fig_plot isn't defined
        fig_plot = uifigure('Name', 'Error');
        uialert(fig_plot, 'CSV file must contain "Altitude (m)" and "Speed (m/s)" columns.', 'Invalid CSV Format');
    end
end