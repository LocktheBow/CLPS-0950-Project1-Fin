% ENHANCEDMAIN - Enhanced main script for Verbal Comprehension Training Module
% 
% This script coordinates the complete verbal comprehension training sequence
% with the following improvements:
% 1. Expanded question bank (20+ questions per category)
% 2. Increased number of questions per phase (5 instead of 3)
% 3. Fixed text overlap issues
% 4. Added escape key functionality to exit the test at any point
% 5. Preserves backward compatibility with original version

try
    % Clear workspace and prepare environment
    close all;
    clear variables;
    clc;
    
    % Add necessary paths
    addpath('utils');
    addpath('data');
    addpath('tasks');
    
    % Create a log file for tracking
    logFile = fopen(['log_' datestr(now, 'yyyymmdd_HHMMSS') '.txt'], 'w');
    fprintf(logFile, 'Verbal Comprehension Enhancement Training Module Log\n');
    fprintf(logFile, 'Started at: %s\n 44\n', datestr(now));
    
    % Initialize Psychtoolbox
    PsychDefaultSetup(2);
    Screen('Preference', 'SkipSyncTests', 1);
    Screen('Preference', 'ConserveVRAM', 64); % Use simpler rendering for better compatibility
    Screen('Preference', 'VBLTimestampingMode', -1); % Less accurate but more reliable timing
    
    % Initialize question tracking system
    if exist('questionTracker', 'file') == 2
        fprintf('Initializing question tracker...\n');
        fprintf(logFile, 'Initializing question tracker...\n');
        % Reset question tracking to start fresh
        questionTracker('init');
        
        % No need to pre-mark training examples anymore as they're separated 
        % in the data structures and not part of the main question pool
        
        % Show initial tracking status
        fprintf('Question tracking initialized.\n');
        fprintf(logFile, 'Question tracking initialized.\n');
        questionTracker('status');
    else
        fprintf('WARNING: Question tracking not available. Repetition prevention disabled.\n');
        fprintf(logFile, 'WARNING: Question tracking not available. Repetition prevention disabled.\n');
    end
    
    % Set up display parameters
    screenNumber = max(Screen('Screens'));
    white = WhiteIndex(screenNumber);
    black = BlackIndex(screenNumber);
    grey = white / 2;
    
    % Open window
    [window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);
    
    % Define screen parameters
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    [xCenter, yCenter] = RectCenter(windowRect);
    
    % Store screen parameters in a structure for easy reference
    screenInfo = struct('screenXpixels', screenXpixels, ...
                       'screenYpixels', screenYpixels, ...
                       'xCenter', xCenter, ...
                       'yCenter', yCenter, ...
                       'white', white, ...
                       'black', black, ...
                       'grey', grey);
    
    % Load task data using enhanced generators
    fprintf('Loading enhanced task data...\n');
    fprintf(logFile, 'Loading enhanced task data...\n');
    
    % Use enhancedLoadTaskData function if it exists, otherwise create the tasks directly
    tasks = struct();
    
    % Load Similarities data
    if exist('enhancedGenerateSimilaritiesData', 'file')
        similarities = enhancedGenerateSimilaritiesData();
        
        % Format similarities data into consistent task structure, including training examples
        tasks.similarities = [];
        
        % First create a structure with just the training data
        tasks.similarities = struct();
        tasks.similarities.trainingPairs = similarities.trainingPairs;
        tasks.similarities.trainingOptions = similarities.trainingOptions;
        tasks.similarities.trainingCorrectIndices = similarities.trainingCorrectIndices;
        
        % Then add the main questions as an array field
        tasks.similarities.questions = [];
        for i = 1:length(similarities.pairs)
            task = struct();
            task.word1 = similarities.pairs{i}{1};
            task.word2 = similarities.pairs{i}{2};
            task.options = similarities.options{i};
            task.correctAnswer = similarities.correctIndices(i);
            tasks.similarities.questions = [tasks.similarities.questions; task];
        end
        fprintf('Loaded enhanced similarities data: %d items\n', length(tasks.similarities.questions));
        fprintf(logFile, 'Loaded enhanced similarities data: %d items\n', length(tasks.similarities.questions));
    else
        % Fall back to original data generator
        fprintf('Enhanced similarities generator not found. Using original...\n');
        fprintf(logFile, 'Enhanced similarities generator not found. Using original...\n');
        similarities = generateSimilaritiesData();
        
        % Format similarities data
        tasks.similarities = [];
        for i = 1:length(similarities.pairs)
            task = struct();
            task.word1 = similarities.pairs{i}{1};
            task.word2 = similarities.pairs{i}{2};
            task.options = similarities.options{i};
            task.correctAnswer = similarities.correctIndices(i);
            tasks.similarities = [tasks.similarities; task];
        end
    end
    
    % Load Vocabulary data
    if exist('enhancedGenerateVocabularyData', 'file')
        vocabulary = enhancedGenerateVocabularyData();
        
        % Format vocabulary data
        tasks.vocabulary = [];
        for i = 1:length(vocabulary.words)
            task = struct();
            task.word = vocabulary.words{i};
            task.options = vocabulary.options{i};
            task.correctAnswer = vocabulary.correctIndices(i);
            tasks.vocabulary = [tasks.vocabulary; task];
        end
        fprintf('Loaded enhanced vocabulary data: %d items\n', length(tasks.vocabulary));
        fprintf(logFile, 'Loaded enhanced vocabulary data: %d items\n', length(tasks.vocabulary));
    else
        % Fall back to original data generator
        fprintf('Enhanced vocabulary generator not found. Using original...\n');
        fprintf(logFile, 'Enhanced vocabulary generator not found. Using original...\n');
        vocabulary = generateVocabularyData();
        
        % Format vocabulary data
        tasks.vocabulary = [];
        for i = 1:length(vocabulary.words)
            task = struct();
            task.word = vocabulary.words{i};
            task.options = vocabulary.options{i};
            task.correctAnswer = vocabulary.correctIndices(i);
            tasks.vocabulary = [tasks.vocabulary; task];
        end
    end
    
    % Load Information data
    if exist('enhancedGenerateInformationData', 'file')
        information = enhancedGenerateInformationData();
        
        % Format information data
        tasks.information = [];
        for i = 1:length(information.questions)
            task = struct();
            task.question = information.questions{i};
            task.options = information.options{i};
            task.correctAnswer = information.correctIndices(i);
            tasks.information = [tasks.information; task];
        end
        fprintf('Loaded enhanced information data: %d items\n', length(tasks.information));
        fprintf(logFile, 'Loaded enhanced information data: %d items\n', length(tasks.information));
    else
        % Fall back to original data generator
        fprintf('Enhanced information generator not found. Using original...\n');
        fprintf(logFile, 'Enhanced information generator not found. Using original...\n');
        information = generateInformationData();
        
        % Format information data
        tasks.information = [];
        for i = 1:length(information.questions)
            task = struct();
            task.question = information.questions{i};
            task.options = information.options{i};
            task.correctAnswer = information.correctIndices(i);
            tasks.information = [tasks.information; task];
        end
    end
    
    % ----- STAGE 1: WELCOME & INTRODUCTION -----
    showInstructions(window, 'welcome', screenInfo);
    
    % ----- STAGE 2: PRE-TEST ASSESSMENT -----
    fprintf('Beginning pre-test assessment...\n');
    fprintf(logFile, 'Beginning pre-test assessment...\n');
    
    % Use enhanced pre-test if available
    if exist('enhancedRunPreTest', 'file')
        preTestResults = enhancedRunPreTest(window, tasks, screenInfo);
    else
        % Fall back to original pre-test
        fprintf('Enhanced pre-test not found. Using original...\n');
        fprintf(logFile, 'Enhanced pre-test not found. Using original...\n');
        preTestResults = runPreTest(window, tasks, screenInfo);
    end
    
    % Check if test was exited early
    if isfield(preTestResults, 'completed') && ~preTestResults.completed
        % User pressed escape to exit
        fprintf('Pre-test was exited early at: %s\n', preTestResults.exitPoint);
        fprintf(logFile, 'Pre-test was exited early at: %s\n', preTestResults.exitPoint);
        
        % Show confirmation
        Screen('TextSize', window, 42);
        DrawFormattedText(window, 'Test Exited', 'center', screenYpixels * 0.4, [0.8 0 0]);
        DrawFormattedText(window, 'You chose to exit the test early.', 'center', screenYpixels * 0.5, black);
        DrawFormattedText(window, 'Press any key to close...', 'center', screenYpixels * 0.7, black);
        Screen('Flip', window);
        KbStrokeWait;
        
        % Close and exit
        sca;
        fprintf('Program terminated by user request.\n');
        fprintf(logFile, 'Program terminated by user request.\n');
        fclose(logFile);
        return;
    end
    
    % ----- STAGE 3: TRAINING PHASE -----
    fprintf('Beginning training phase...\n');
    fprintf(logFile, 'Beginning training phase...\n');
    
    % Use the most appropriate training function
    if exist('enhancedRunTrainingPhase', 'file')
        enhancedRunTrainingPhase(window, tasks, screenInfo);
    elseif exist('runTrainingPhase', 'file')
        runTrainingPhase(window, tasks, screenInfo);
    else
        % Fallback to instructions only if function not found
        fprintf('WARNING: Training function not found. Showing instructions only.\n');
        fprintf(logFile, 'WARNING: Training function not found. Showing instructions only.\n');
        showInstructions(window, 'training', screenInfo);
    end
    
    % ----- STAGE 4: PRACTICE PHASE -----
    fprintf('Beginning practice phase...\n');
    fprintf(logFile, 'Beginning practice phase...\n');
    
    % Use the most appropriate practice function
    if exist('enhancedRunPracticePhase', 'file')
        enhancedRunPracticePhase(window, tasks, screenInfo);
    elseif exist('runPracticePhase', 'file')
        runPracticePhase(window, tasks, screenInfo);
    else
        % Fallback to instructions only if function not found
        fprintf('WARNING: Practice function not found. Showing instructions only.\n');
        fprintf(logFile, 'WARNING: Practice function not found. Showing instructions only.\n');
        showInstructions(window, 'practice', screenInfo);
    end
    
    % ----- STAGE 5: POST-TEST ASSESSMENT -----
    fprintf('Beginning post-test assessment...\n');
    fprintf(logFile, 'Beginning post-test assessment...\n');
    
    % Use enhanced post-test if available, otherwise use original
    if exist('enhancedRunPostTest', 'file')
        [postTestResults, improvement] = enhancedRunPostTest(window, tasks, preTestResults, screenInfo);
    else
        % Fall back to original post-test
        fprintf('Enhanced post-test not found. Using original...\n');
        fprintf(logFile, 'Enhanced post-test not found. Using original...\n');
        [postTestResults, improvement] = runPostTest(window, tasks, preTestResults, screenInfo);
    end
    
    % Check if test was exited early
    if isfield(postTestResults, 'completed') && ~postTestResults.completed
        % User pressed escape to exit
        fprintf('Post-test was exited early at: %s\n', postTestResults.exitPoint);
        fprintf(logFile, 'Post-test was exited early at: %s\n', postTestResults.exitPoint);
        
        % Show confirmation
        Screen('TextSize', window, 42);
        DrawFormattedText(window, 'Test Exited', 'center', screenYpixels * 0.4, [0.8 0 0]);
        DrawFormattedText(window, 'You chose to exit the test early.', 'center', screenYpixels * 0.5, black);
        DrawFormattedText(window, 'Press any key to close...', 'center', screenYpixels * 0.7, black);
        Screen('Flip', window);
        KbStrokeWait;
        
        % Close and exit
        sca;
        fprintf('Program terminated by user request.\n');
        fprintf(logFile, 'Program terminated by user request.\n');
        fclose(logFile);
        return;
    end
    
    % ----- STAGE 6: RESULTS STORAGE -----
    % Create results structure
    results = struct('preTest', preTestResults, ...
                    'postTest', postTestResults, ...
                    'improvement', improvement);
    
    % Save results to file with timestamp
    resultsFilename = ['verbal_comprehension_results_' datestr(now, 'yyyymmdd_HHMMSS') '.mat'];
    save(resultsFilename, 'results');
    fprintf('Results saved to %s\n', resultsFilename);
    fprintf(logFile, 'Results saved to %s\n', resultsFilename);
    
    % Show results screen
    showInstructions(window, 'results', screenInfo);
    
    % ----- STAGE 7: FINAL SUMMARY DISPLAY -----
    Screen('TextSize', window, 42);
    DrawFormattedText(window, 'Training Complete', 'center', screenYpixels * 0.2, black);
    
    Screen('TextSize', window, 36);
    DrawFormattedText(window, sprintf('Accuracy improvement: %.1f%%', improvement.overallAccuracy * 100), 'center', screenYpixels * 0.35, black);
    
    % Display response time improvement
    if improvement.overallRT > 0
        DrawFormattedText(window, sprintf('Response time: %.2f seconds faster', improvement.overallRT), 'center', screenYpixels * 0.45, black);
    else
        DrawFormattedText(window, sprintf('Response time: %.2f seconds slower', abs(improvement.overallRT)), 'center', screenYpixels * 0.45, black);
    end
    
    % Show improvements by category
    categoryY = screenYpixels * 0.55;
    if isfield(improvement, 'similarities')
        DrawFormattedText(window, sprintf('Similarities improvement: %d correct answers', improvement.similarities), 'center', categoryY, black);
        categoryY = categoryY + 40;
    end
    
    if isfield(improvement, 'vocabulary')
        DrawFormattedText(window, sprintf('Vocabulary improvement: %d correct answers', improvement.vocabulary), 'center', categoryY, black);
        categoryY = categoryY + 40;
    end
    
    if isfield(improvement, 'information')
        DrawFormattedText(window, sprintf('Information improvement: %d correct answers', improvement.information), 'center', categoryY, black);
    end
    
    DrawFormattedText(window, 'Thank you for participating!', 'center', screenYpixels * 0.8, black);
    DrawFormattedText(window, 'Press any key to exit...', 'center', screenYpixels * 0.9, black);
    Screen('Flip', window);
    KbStrokeWait;
    
    % Close window and clean up
    sca;
    fprintf('Program completed successfully.\n');
    fprintf(logFile, 'Program completed successfully.\n');
    fclose(logFile);
    
catch psychError
    % Better error handling
    fprintf('Error: %s\n', psychError.message);
    if exist('logFile', 'var') && logFile ~= -1
        fprintf(logFile, 'Error: %s\n', psychError.message);
    end
    
    % Try to safely clean up
    try
        % Restore cursor
        if exist('ShowCursor', 'file')
            ShowCursor();
        end
        
        % Close any open windows
        if exist('Screen', 'file')
            windowList = Screen('Windows');
            for i = 1:length(windowList)
                if windowList(i) > 0
                    Screen('Close', windowList(i));
                end
            end
            Screen('CloseAll');
        end
    catch
        fprintf('Could not safely close Psychtoolbox windows.\n');
        if exist('logFile', 'var') && logFile ~= -1
            fprintf(logFile, 'Could not safely close Psychtoolbox windows.\n');
        end
    end
    
    % Show error details
    fprintf('Error in: %s (line %d)\n', psychError.stack(1).name, psychError.stack(1).line);
    if exist('logFile', 'var') && logFile ~= -1
        fprintf(logFile, 'Error in: %s (line %d)\n', psychError.stack(1).name, psychError.stack(1).line);
        fclose(logFile);
    end
    
    % Print full stack trace for debugging
    for i = 1:length(psychError.stack)
        fprintf('  Called from: %s (line %d)\n', psychError.stack(i).name, psychError.stack(i).line);
    end
end  