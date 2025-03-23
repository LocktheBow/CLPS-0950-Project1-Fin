% MAIN - Script for Verbal Comprehension Enhancement Training Module (Modified version) (Modified version)
% 
% This script coordinates the entire training flow, including pre-test, 
% training, practice, and post-test phases to measure improvement in
% verbal comprehension skills.

try
    % Clear workspace and prepare environment
    close all;
    clear variables;
    clc;
    
    % Add subdirectories to path
    addpath('data');
    addpath('utils');
    addpath('tasks');
    
    % Use enhanced dynamic content generation
    useDynamic = true; % Set to true for dynamic question generation
    
    % Initialize Psychtoolbox
    PsychDefaultSetup(2);
    screenNumber = max(Screen('Screens'));
    white = WhiteIndex(screenNumber);
    black = BlackIndex(screenNumber);
    grey = white / 2;
    
    % Skip sync tests for development
    Screen('Preference', 'SkipSyncTests', 1);
    
    % Open a window
    [window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);
    
    % Define screen parameters
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    [xCenter, yCenter] = RectCenter(windowRect);
    
    % Store screen parameters for consistent use across functions
    screenInfo = struct('screenXpixels', screenXpixels, ...
                       'screenYpixels', screenYpixels, ...
                       'xCenter', xCenter, ...
                       'yCenter', yCenter, ...
                       'white', white, ...
                       'black', black, ...
                       'grey', grey);
    
    % Show welcome screen with improved instructions
    Screen('TextSize', window, 36);
    DrawFormattedText(window, 'Verbal Comprehension Enhancement Training Module', 'center', screenYpixels * 0.3, black);
    DrawFormattedText(window, 'This module will measure and improve your verbal comprehension skills.', 'center', screenYpixels * 0.4, black);
    DrawFormattedText(window, 'You will complete a pre-test, training, practice, and post-test.', 'center', screenYpixels * 0.5, black);
    DrawFormattedText(window, 'Press any key to begin... (ESC to exit at any time)', 'center', screenYpixels * 0.7, black);
    Screen('Flip', window);
    KbStrokeWait;
    
    % Load task data with enhanced dynamic content
    fprintf('Loading task data with enhanced generators (useDynamic = %d)...\n', useDynamic);
    
    % Try to use enhanced data generators if available
    if exist('data/enhancedGenerateInformationData.m', 'file')
        fprintf('Using enhanced task data generators...\n');
        tasks = loadTaskData(useDynamic);
    else
        tasks = loadTaskData(useDynamic);
    end
    
    % Initialize question tracking to prevent overlap between phases
    if exist('questionTracker', 'file')
        questionTracker('init');
        fprintf('Question tracking initialized to prevent repetition.\n');
    end
    
    % Run enhanced pre-test with 5 questions per category
    fprintf('Starting pre-test with 5 questions per category...\n');
    preTestResults = runPreTest(window, tasks, screenInfo);
    
    % Run enhanced training phase
    fprintf('Starting training phase...\n');
    runTrainingPhase(window, tasks, screenInfo);
    
    % Run enhanced practice phase
    fprintf('Starting practice phase...\n');
    runPracticePhase(window, tasks, screenInfo);
    
    % Run enhanced post-test (uses different questions than pre-test)
    fprintf('Starting post-test...\n');
    if exist('improvedRunPostTest', 'file')
        [postTestResults, improvement] = improvedRunPostTest(window, tasks, preTestResults, screenInfo);
    else
        [postTestResults, improvement] = runPostTest(window, tasks, preTestResults, screenInfo);
    end
    
    % Save results with more comprehensive data
    results = struct('preTest', preTestResults, ...
                    'postTest', postTestResults, ...
                    'improvement', improvement, ...
                    'timestamp', now, ...
                    'usedDynamicContent', useDynamic);
    
    resultsFilename = ['verbal_comprehension_results_' datestr(now, 'yyyymmdd_HHMMSS') '.mat'];
    save(resultsFilename, 'results');
    fprintf('Results saved to %s\n', resultsFilename);
    
    % Show enhanced results summary
    Screen('TextSize', window, 36);
    DrawFormattedText(window, 'Training Complete', 'center', screenYpixels * 0.3, black);
    DrawFormattedText(window, sprintf('Accuracy improvement: %.1f%%', improvement.overallAccuracy * 100), 'center', screenYpixels * 0.4, black);
    
    if improvement.overallRT > 0
        DrawFormattedText(window, sprintf('Response time improvement: %.2f seconds faster', improvement.overallRT), 'center', screenYpixels * 0.5, black);
    else
        DrawFormattedText(window, sprintf('Response time change: %.2f seconds slower', abs(improvement.overallRT)), 'center', screenYpixels * 0.5, black);
    end
    
    % Show category-specific improvements if available
    if isfield(improvement, 'similaritiesAccuracy')
        yPos = screenYpixels * 0.6;
        DrawFormattedText(window, sprintf('Similarities improvement: %.1f%%', improvement.similaritiesAccuracy * 100), 'center', yPos, black);
        yPos = yPos + 30;
        DrawFormattedText(window, sprintf('Vocabulary improvement: %.1f%%', improvement.vocabularyAccuracy * 100), 'center', yPos, black);
        yPos = yPos + 30;
        DrawFormattedText(window, sprintf('Information improvement: %.1f%%', improvement.informationAccuracy * 100), 'center', yPos, black);
    else
        DrawFormattedText(window, 'Thank you for participating!', 'center', screenYpixels * 0.6, black);
    end
    
    DrawFormattedText(window, 'Press any key to exit.', 'center', screenYpixels * 0.8, black);
    Screen('Flip', window);
    KbStrokeWait;
    
    % Clean up
    sca;
    fprintf('Training module completed successfully.\n');
    
catch e
    % Enhanced error handling with more informative output
    sca;
    fprintf('\n======= ERROR =======\n');
    fprintf('Error in Verbal Comprehension Training Module:\n');
    fprintf('  Message: %s\n', e.message);
    
    % Print stack trace with file and line information
    if ~isempty(e.stack)
        fprintf('Stack trace:\n');
        for i = 1:length(e.stack)
            fprintf('  File: %s, Line: %d, Function: %s\n', ...
                e.stack(i).file, e.stack(i).line, e.stack(i).name);
        end
    end
    
    % Display error on screen if window is available
    try
        if exist('window', 'var') && window > 0
            Screen('TextSize', window, 36);
            DrawFormattedText(window, 'An error occurred', 'center', screenYpixels * 0.4, [1 0 0]);
            DrawFormattedText(window, e.message, 'center', screenYpixels * 0.5, [1 0 0]);
            DrawFormattedText(window, 'Press any key to exit.', 'center', screenYpixels * 0.7, black);
            Screen('Flip', window);
            KbStrokeWait;
        end
    catch
        % Ignore errors in error handling
    end
    
    fprintf('\n====================\n');
    psychrethrow(psychlasterror);
end