function disp_warning(warningMessage, warningTitle)
    % Helper function to make sure to display a warning dialog only once
    persistent displayedWarnings;

    % Check if the function is called with 'reset'
    if nargin > 0 && strcmp(warningMessage, 'reset')
        % Clear the persistent variable
        displayedWarnings = containers.Map('KeyType', 'char', 'ValueType', 'logical');
        return;
    end

    % Initialize the persistent variable as a container if not already done
    if isempty(displayedWarnings)
        displayedWarnings = containers.Map('KeyType', 'char', 'ValueType', 'logical');
    end

    % Use a combination of message and title as the unique key
    if nargin < 2
        warningTitle = 'Warning'; % Default title if not provided
    end
    uniqueKey = sprintf('%s - %s', warningTitle, warningMessage);

    % Check if the warning has already been displayed
    if ~isKey(displayedWarnings, uniqueKey)
        % Show the warning dialog
        warndlg(warningMessage, warningTitle);

        % Mark the warning as displayed
        displayedWarnings(uniqueKey) = true;
    end
end
