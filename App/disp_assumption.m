function disp_assumption(assumption)
    % Helper function to ensure an assumption is printed only once
    persistent printedAssumptions;

    % Check if the function is called with 'reset'
    if nargin > 0 && strcmp(assumption, 'reset')
        % Clear the persistent variable
        printedAssumptions = containers.Map('KeyType', 'char', 'ValueType', 'logical');
        %disp('disp_assumption has been reset.');
        return;
    end

    % Initialize the persistent variable as a container if not already done
    if isempty(printedAssumptions)
        printedAssumptions = containers.Map('KeyType', 'char', 'ValueType', 'logical');
    end

    % Check if the assumption has already been printed
    if ~isKey(printedAssumptions, assumption)
        % Print the assumption
        fprintf('%s\n', assumption); % Use fprintf for better formatting of \n

        % Mark the assumption as printed
        printedAssumptions(assumption) = true;
    end
end
