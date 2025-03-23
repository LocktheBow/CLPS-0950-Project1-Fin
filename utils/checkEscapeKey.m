function isEscapePressed = checkEscapeKey(keyCode)
% CHECKESCAPEKEY - Safely check if escape key was pressed
%
% This helper function checks if the escape key was pressed
% in a safe way that handles both scalar and array key indices.
%
% Input:
%   keyCode - KeyCode array from KbCheck or KbStrokeWait
%
% Output:
%   isEscapePressed - Boolean, true if escape key was pressed

    try
        % Get escape key code from KbName
        escapeKey = KbName('ESCAPE');
        
        % Handle both cases: if escapeKey is scalar or array
        if isscalar(escapeKey)
            % Simple check when escapeKey is a single value
            isEscapePressed = keyCode(escapeKey);
        else
            % Check if any of the elements in escapeKey array are pressed
            isEscapePressed = any(keyCode(escapeKey));
        end
        
        % Debug output
        if isEscapePressed
            fprintf('Escape key detected by checkEscapeKey function\n');
        end
    catch e
        % More robust error handling
        fprintf('Error in checkEscapeKey: %s\n', e.message);
        
        % Fallback method - try to detect escape key in multiple ways
        try
            % Method 1: Try to find key code 27 (common ASCII code for Escape)
            if any(find(keyCode) == 27)
                isEscapePressed = true;
                fprintf('Detected Escape key via ASCII code 27\n');
                return;
            end
            
            % Method 2: Try a different label for escape
            alternateEscLabels = {'escape', 'ESC', 'esc', 'ESCAPE'};
            for i = 1:length(alternateEscLabels)
                try
                    escKey = KbName(alternateEscLabels{i});
                    if (isscalar(escKey) && keyCode(escKey)) || (~isscalar(escKey) && any(keyCode(escKey)))
                        isEscapePressed = true;
                        fprintf('Detected Escape key via alternate label: %s\n', alternateEscLabels{i});
                        return;
                    end
                catch
                    % Continue to next label
                end
            end
            
            % Method 3: Look for any pressed key and check the name
            pressedKeys = find(keyCode);
            for i = 1:length(pressedKeys)
                try
                    keyName = KbName(pressedKeys(i));
                    if ischar(keyName) && contains(lower(keyName), 'esc')
                        isEscapePressed = true;
                        fprintf('Detected Escape key via key name: %s\n', keyName);
                        return;
                    end
                catch
                    % Continue to next key
                end
            end
            
            % If we get here, escape was not pressed
            isEscapePressed = false;
        catch
            % Ultimate fallback - assume not pressed
            isEscapePressed = false;
        end
    end
end