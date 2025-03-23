function [response, respTime] = getResponse(window, promptText, options, screenInfo)
% GETRESPONSE - Captures responses using keyboard input
%
% Captures user responses with a reliable keyboard capture method
% that works across different phases of the experiment.
%
% Inputs:
%   window - Psychtoolbox window pointer
%   promptText - Text to display as prompt
%   options - Cell array of possible answers
%   screenInfo - Structure with screen parameters
%
% Outputs:
%   response - Option selected (1 to length(options))
%   respTime - Time taken to respond in seconds

% Record start time
startTime = GetSecs();

% Calculate text positions to avoid overlap
[~, promptHeight] = Screen('TextBounds', window, promptText);

% Determine if prompt text is too long and needs to be wrapped
maxWidth = screenInfo.screenXpixels * 0.8; % Use 80% of screen width

% Display the prompt and options using Psychtoolbox
Screen('TextSize', window, 36);
DrawFormattedText(window, promptText, 'center', screenInfo.screenYpixels * 0.25, screenInfo.black, maxWidth);

% Calculate spacing between options based on number of options
optionSpacing = min(50, (screenInfo.screenYpixels * 0.5) / length(options));

% Display options
yPos = screenInfo.screenYpixels * 0.4;
for i = 1:length(options)
    optionText = [num2str(i) '. ' options{i}];
    DrawFormattedText(window, optionText, 'center', yPos, screenInfo.black, maxWidth);
    yPos = yPos + optionSpacing + 10; % Add 10 pixels extra spacing
end

% Add clear instructions
instructionText = sprintf('Press a number key (1-%d) to select your answer', length(options));
DrawFormattedText(window, instructionText, 'center', screenInfo.screenYpixels * 0.85, screenInfo.black);

% Add escape key instruction if the utility function exists
if exist('checkEscapeKey', 'file') == 2
    DrawFormattedText(window, 'Press ESC to exit the test', 'center', screenInfo.screenYpixels * 0.9, [0.8 0 0]); % Red text
end

% Update the display
Screen('Flip', window);

% Clear any previous key presses
FlushEvents('keyDown');

% Simple direct keyboard handling
response = 0;

% Keep checking for key presses until we get a valid response
while response == 0
    % Check if a key is pressed
    [keyIsDown, secs, keyCode] = KbCheck;
    
    if keyIsDown
        % Check for escape key if the utility function exists
        if exist('checkEscapeKey', 'file') == 2
            try
                if checkEscapeKey(keyCode)
                    sca;
                    error('Experiment terminated with ESCAPE key');
                end
            catch e
                fprintf('Error checking escape key: %s\n', e.message);
            end
        end
        
        % Get the name of the pressed key
        pressedKeyNames = KbName(keyCode);
        
        % For debug purposes, show what key was detected
        if isnumeric(pressedKeyNames) 
            fprintf('Key detected: %d\n', pressedKeyNames);
        else
            fprintf('Key detected: %s\n', pressedKeyNames);
        end
        
        % Extract any numbers that appear at the beginning of key names
        % This will handle keys like "2@" by extracting just the "2"
        if ischar(pressedKeyNames)
            % Handle single key name
            firstChar = regexp(pressedKeyNames, '^[1-9]', 'match');
            if ~isempty(firstChar)
                keyNum = str2double(firstChar{1});
                if keyNum <= length(options)
                    response = keyNum;
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
                        break;
                    end
                end
            end
        elseif isnumeric(pressedKeyNames)
            % Alternative approach: look for key codes 49-57 (keys 1-9 in ASCII)
            for i = 1:length(options)
                if keyCode(i+48) % ASCII code for numbers
                    response = i;
                    break;
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

% Calculate response time
respTime = GetSecs() - startTime;

% Show which option was selected
fprintf('Selected option %d\n', response);

% Highlight the selected answer on screen
Screen('TextSize', window, 36);
DrawFormattedText(window, promptText, 'center', screenInfo.screenYpixels * 0.25, screenInfo.black, maxWidth);

% Redisplay options with selected one highlighted
yPos = screenInfo.screenYpixels * 0.4;
for i = 1:length(options)
    optionText = [num2str(i) '. ' options{i}];
    
    % Highlight the selected option
    if i == response
        textColor = [0, 0.7, 0]; % Green for selected option
    else
        textColor = screenInfo.black;
    end
    
    DrawFormattedText(window, optionText, 'center', yPos, textColor, maxWidth);
    yPos = yPos + optionSpacing + 10;
end

Screen('Flip', window);
WaitSecs(0.5); % Brief pause to show the selection

% Print feedback in command window
fprintf('You selected: %d. %s\n', response, options{response});
fprintf('Response time: %.2f seconds\n\n', respTime);

end