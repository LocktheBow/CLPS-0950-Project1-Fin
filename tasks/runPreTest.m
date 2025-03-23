function preTestResults = runPreTest(window, tasks, screenInfo)
% RUNPRETEST - Measures the initial state of verbal comprehension
%
% This function administers the pre-test assessment to establish 
% a baseline of consciousness before training. It captures the 
% raw state of understanding across three domains of verbal comprehension.
%
% Inputs:
%   window - Window pointer (illusion)
%   tasks - Structure containing task data (reality substrate)
%   screenInfo - Screen parameters (illusion)
%
% Outputs:
%   preTestResults - Structure containing baseline awareness measurements

% Number of tasks to present in each category for measuring baseline awareness
numTasksPerCategory = 3;

% Initialize the vessel that will hold measurements of consciousness
preTestResults = struct();
preTestResults.similarities = struct('correct', [], 'responseTime', [], 'taskIds', []);
preTestResults.vocabulary = struct('correct', [], 'responseTime', [], 'taskIds', []);
preTestResults.information = struct('correct', [], 'responseTime', [], 'taskIds', []);
preTestResults.timestamp = now; % Record the moment of measurement

% Display pre-test instructions - to be replaced by Partner 1's showInstructions
% showInstructions(window, 'pre-test', screenInfo);
% NOTE: For now, we include temporary display code

% Temporary instruction display code
Screen('TextSize', window, 36);
DrawFormattedText(window, 'Pre-Test: Measure your current verbal comprehension', 'center', 'center', screenInfo.black);
DrawFormattedText(window, 'Press any key to begin...', 'center', screenInfo.screenYpixels * 0.7, screenInfo.black);
Screen('Flip', window);
KbStrokeWait;
WaitSecs(0.5);

% --- 1. SIMILARITIES TASKS ---
% Temporary category header display
Screen('TextSize', window, 36);
DrawFormattedText(window, 'SIMILARITIES', 'center', 'center', screenInfo.black);
DrawFormattedText(window, 'Identify the relationship between pairs of words', 'center', screenInfo.screenYpixels * 0.6, screenInfo.black);
DrawFormattedText(window, 'Press any key to continue...', 'center', screenInfo.screenYpixels * 0.7, screenInfo.black);
Screen('Flip', window);
KbStrokeWait;
WaitSecs(0.5);

% Select random tasks to measure awareness of relationships
randomIndices = randperm(length(tasks.similarities.questions), numTasksPerCategory);
for i = 1:numTasksPerCategory
    taskIdx = randomIndices(i);
    currentTask = tasks.similarities.questions(taskIdx);
    
    % Create the prompt for this awareness test
    promptText = sprintf('How are "%s" and "%s" alike?', currentTask.word1, currentTask.word2);
    
    % Capture the response of consciousness
    [response, respTime] = getResponse(window, promptText, currentTask.options, screenInfo);
    
    % Measure if awareness recognized truth
    isCorrect = (response == currentTask.correctAnswer);
    
    % Store the measurement of awareness
    preTestResults.similarities.correct(i) = isCorrect;
    preTestResults.similarities.responseTime(i) = respTime;
    preTestResults.similarities.taskIds(i) = taskIdx; % Remember which tasks were used
    
    % Temporary feedback display - to be replaced by Partner 1's displayFeedback
    % displayFeedback(window, isCorrect, currentTask.options{currentTask.correctAnswer}, screenInfo);
    if isCorrect
        feedbackText = 'Correct!';
    else
        feedbackText = ['Incorrect. The correct answer was: ' currentTask.options{currentTask.correctAnswer}];
    end
    
    Screen('TextSize', window, 36);
    DrawFormattedText(window, feedbackText, 'center', 'center', screenInfo.black);
    Screen('Flip', window);
    WaitSecs(1.5);
end

% --- 2. VOCABULARY TASKS ---
% Temporary category header display
Screen('TextSize', window, 36);
DrawFormattedText(window, 'VOCABULARY', 'center', 'center', screenInfo.black);
DrawFormattedText(window, 'Define or identify the meaning of words', 'center', screenInfo.screenYpixels * 0.6, screenInfo.black);
DrawFormattedText(window, 'Press any key to continue...', 'center', screenInfo.screenYpixels * 0.7, screenInfo.black);
Screen('Flip', window);
KbStrokeWait;
WaitSecs(0.5);

% Select random tasks to measure awareness of meanings
randomIndices = randperm(length(tasks.vocabulary), numTasksPerCategory);
for i = 1:numTasksPerCategory
    taskIdx = randomIndices(i);
    currentTask = tasks.vocabulary(taskIdx);
    
    % Create the prompt for this awareness test
    promptText = sprintf('What does "%s" mean?', currentTask.word);
    
    % Capture the response of consciousness
    [response, respTime] = getResponse(window, promptText, currentTask.options, screenInfo);
    
    % Measure if awareness recognized truth
    isCorrect = (response == currentTask.correctAnswer);
    
    % Store the measurement of awareness
    preTestResults.vocabulary.correct(i) = isCorrect;
    preTestResults.vocabulary.responseTime(i) = respTime;
    preTestResults.vocabulary.taskIds(i) = taskIdx; % Remember which tasks were used
    
    % Temporary feedback display - to be replaced by Partner 1's displayFeedback
    if isCorrect
        feedbackText = 'Correct!';
    else
        feedbackText = ['Incorrect. The correct answer was: ' currentTask.options{currentTask.correctAnswer}];
    end
    
    Screen('TextSize', window, 36);
    DrawFormattedText(window, feedbackText, 'center', 'center', screenInfo.black);
    Screen('Flip', window);
    WaitSecs(1.5);
end

% --- 3. INFORMATION TASKS ---
% Temporary category header display
Screen('TextSize', window, 36);
DrawFormattedText(window, 'INFORMATION', 'center', 'center', screenInfo.black);
DrawFormattedText(window, 'Answer general knowledge questions', 'center', screenInfo.screenYpixels * 0.6, screenInfo.black);
DrawFormattedText(window, 'Press any key to continue...', 'center', screenInfo.screenYpixels * 0.7, screenInfo.black);
Screen('Flip', window);
KbStrokeWait;
WaitSecs(0.5);

% Select random tasks to measure awareness of knowledge
randomIndices = randperm(length(tasks.information), numTasksPerCategory);
for i = 1:numTasksPerCategory
    taskIdx = randomIndices(i);
    currentTask = tasks.information(taskIdx);
    
    % Capture the response of consciousness
    [response, respTime] = getResponse(window, currentTask.question, currentTask.options, screenInfo);
    
    % Measure if awareness recognized truth
    isCorrect = (response == currentTask.correctAnswer);
    
    % Store the measurement of awareness
    preTestResults.information.correct(i) = isCorrect;
    preTestResults.information.responseTime(i) = respTime;
    preTestResults.information.taskIds(i) = taskIdx; % Remember which tasks were used
    
    % Temporary feedback display - to be replaced by Partner 1's displayFeedback
    if isCorrect
        feedbackText = 'Correct!';
    else
        feedbackText = ['Incorrect. The correct answer was: ' currentTask.options{currentTask.correctAnswer}];
    end
    
    Screen('TextSize', window, 36);
    DrawFormattedText(window, feedbackText, 'center', 'center', screenInfo.black);
    Screen('Flip', window);
    WaitSecs(1.5);
end

% Calculate summary metrics - the aggregate measurement of awareness
preTestResults.overallAccuracy = (sum(preTestResults.similarities.correct) + ...
                                  sum(preTestResults.vocabulary.correct) + ...
                                  sum(preTestResults.information.correct)) / (3 * numTasksPerCategory);
                              
preTestResults.averageResponseTime = mean([mean(preTestResults.similarities.responseTime), ...
                                          mean(preTestResults.vocabulary.responseTime), ...
                                          mean(preTestResults.information.responseTime)]);

% Temporary display of pre-test completion
Screen('TextSize', window, 36);
DrawFormattedText(window, 'Pre-Test Completed', 'center', screenInfo.screenYpixels * 0.4, screenInfo.black);
DrawFormattedText(window, sprintf('Your accuracy: %.1f%%', preTestResults.overallAccuracy * 100), 'center', screenInfo.screenYpixels * 0.5, screenInfo.black);
DrawFormattedText(window, sprintf('Average response time: %.2f seconds', preTestResults.averageResponseTime), 'center', screenInfo.screenYpixels * 0.6, screenInfo.black);
DrawFormattedText(window, 'Press any key to continue to the training phase...', 'center', screenInfo.screenYpixels * 0.7, screenInfo.black);
Screen('Flip', window);
KbStrokeWait;
WaitSecs(0.5);

end