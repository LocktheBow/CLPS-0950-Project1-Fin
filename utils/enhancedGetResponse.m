function [response, responseTime] = enhancedGetResponse(window, promptText, options, screenInfo)
% ENHANCEDGETRESPONSE - Captures user responses with escape key exit option
%
% This function displays a prompt and multiple-choice options and captures
% the user's response. It includes an escape key option to exit the test.
%
% Inputs:
%   window - Psychtoolbox window pointer
%   promptText - Text to display as the question prompt
%   options - Cell array of possible answers
%   screenInfo - Structure containing screen parameters
%
% Outputs:
%   response - The option selected (or -1 if escape was pressed)
%   responseTime - Time taken to respond in seconds

    % Begin measuring time
    startTime = GetSecs();
    
    % Calculate text positions to avoid overlap
    [~, promptHeight] = Screen('TextBounds', window, promptText);
    
    % Determine if prompt text is too long and needs to be wrapped
    maxWidth = screenInfo.screenXpixels * 0.8; % Use 80% of screen width
    
    % Display the prompt with wrapping if needed
    Screen('TextSize', window, 36);
    DrawFormattedText(window, promptText, 'center', screenInfo.screenYpixels * 0.25, screenInfo.black, maxWidth);
    
    % Calculate spacing between options based on number of options
    optionSpacing = min(50, (screenInfo.screenYpixels * 0.5) / length(options));
    
    % Display the options with dynamically calculated spacing
    yPos = screenInfo.screenYpixels * 0.4;
    for i = 1:length(options)
        optionText = [num2str(i) '. ' options{i}];
        
        % Wrap long option text
        DrawFormattedText(window, optionText, 'center', yPos, screenInfo.black, maxWidth);
        yPos = yPos + optionSpacing + 10; % Add 10 pixels extra spacing
    end
    
    % Add clear instructions
    instructionText = sprintf('Press a number key (1-%d) to select your answer', length(options));
    DrawFormattedText(window, instructionText, 'center', screenInfo.screenYpixels * 0.85, screenInfo.black);
    
    % Add escape key instruction
    DrawFormattedText(window, 'Press ESC to exit the test', 'center', screenInfo.screenYpixels * 0.9, [0.8 0 0]); % Red text
    
    % Update the display
    Screen('Flip', window);
    
    % Clear any previous key presses
    FlushEvents('keyDown');
    
    % Simple direct keyboard handling
    response = 0;
    responseTime = 0;
    
    % Keep checking for key presses until we get a valid response
    while response == 0
        % Check if a key is pressed
        [keyIsDown, secs, keyCode] = KbCheck;
        
        if keyIsDown
            % Check for escape key
            if keyCode(KbName('ESCAPE'))
                response = -1; % Special code for escape
                responseTime = secs - startTime;
                fprintf('Escape key pressed. Exiting test.\n');
                return;
            end
            
            % Get the name of the pressed key
            pressedKeyNames = KbName(keyCode);
            
            % For debug purposes, show what key was detected
            fprintf('Key detected: %s\n', pressedKeyNames);
            
            % Extract any numbers that appear at the beginning of key names
            % This will handle keys like "2@" by extracting just the "2"
            if ischar(pressedKeyNames)
                % Handle single key name
                firstChar = regexp(pressedKeyNames, '^[1-9]', 'match');
                if ~isempty(firstChar)
                    keyNum = str2double(firstChar{1});
                    if keyNum <= length(options)
                        response = keyNum;
                        responseTime = secs - startTime;
                    end
                end
            elseif iscell(pressedKeyNames)
                % Handle multiple key names
                for i = 1:length(pressedKeyNames)
                    firstChar = regexp(pressedKeyNames{i}, '^[1-9]', 'match');
                    if ~isempty(firstChar)
                        keyNum = str2double(firstChar{1});
                        if keyNum <= length(options)
                            response = keyNum;
                            responseTime = secs - startTime;
                            break;
                        end
                    end
                end
            end
            
            % Wait until key is released to prevent multiple detections
            while KbCheck; end
            WaitSecs(0.2);
        end
        
        % Brief pause to avoid hogging CPU
        WaitSecs(0.01);
    end
    
    % Show which option was selected
    fprintf('Selected option %d\n', response);
    
    % Display feedback about the selected option
    Screen('TextSize', window, 36);
    DrawFormattedText(window, promptText, 'center', screenInfo.screenYpixels * 0.25, screenInfo.black, maxWidth);
    
    yPos = screenInfo.screenYpixels * 0.4;
    for i = 1:length(options)
        if i == response
            optionText = ['>> ' num2str(i) '. ' options{i} ' <<'];
            DrawFormattedText(window, optionText, 'center', yPos, [0 0 1], maxWidth); % Blue for selected
        else
            optionText = [num2str(i) '. ' options{i}];
            DrawFormattedText(window, optionText, 'center', yPos, screenInfo.black, maxWidth);
        end
        yPos = yPos + optionSpacing + 10;
    end
    
    % Update the display with selection highlighted
    Screen('Flip', window);
    
    % Short pause to show selection
    WaitSecs(0.8);
end