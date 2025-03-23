function preTestResults = enhancedRunPreTest(window, tasks, screenInfo)
% ENHANCEDRUNPRETEST - Enhanced version of pre-test with more questions
%
% This function administers the pre-test with 5 questions per category
% instead of 3, and properly handles the escape key feature.
%
% Inputs:
%   window - Psychtoolbox window pointer
%   tasks - Structure containing task data
%   screenInfo - Screen parameters
%
% Outputs:
%   preTestResults - Structure containing baseline performance measurements

% Number of tasks to present in each category (increased from 3 to 5)
numTasksPerCategory = 5;

% Initialize global question tracking if it exists
if exist('questionTracker', 'file') == 2
    try
        questionTracker('init');
    catch
        fprintf('WARNING: questionTracker.m could not be initialized. Question overlap prevention may be disabled.\n');
    end
end

% Initialize results structure
preTestResults = struct();
preTestResults.similarities = struct('correct', [], 'responseTime', [], 'taskIds', []);
preTestResults.vocabulary = struct('correct', [], 'responseTime', [], 'taskIds', []);
preTestResults.information = struct('correct', [], 'responseTime', [], 'taskIds', []);
preTestResults.timestamp = now;
preTestResults.completed = false; % Add flag to track if test was completed or exited early

% Display pre-test instructions
showInstructions(window, 'pre-test', screenInfo);

% --- 1. SIMILARITIES TASKS ---
% Display category header
Screen('TextSize', window, 36);
DrawFormattedText(window, 'SIMILARITIES', 'center', 'center', screenInfo.black);
DrawFormattedText(window, 'Identify the relationship between pairs of words', 'center', screenInfo.screenYpixels * 0.6, screenInfo.black);
DrawFormattedText(window, 'Press any key to continue...', 'center', screenInfo.screenYpixels * 0.7, screenInfo.black);
Screen('Flip', window);
KbStrokeWait;
WaitSecs(0.5);

% Select unused tasks for the pre-test
if exist('getUnusedQuestions', 'file') == 2
    try
        % Use the question selection helper function
        randomIndices = getUnusedQuestions('similarities', numTasksPerCategory);
        numTasksPerCategory_similarities = length(randomIndices);
        
        % Mark these questions as used in the question tracker
        questionTracker('mark', 'similarities', randomIndices);
    catch selectionError
        fprintf('WARNING: Error using getUnusedQuestions: %s\n', selectionError.message);
        % Fall back to random selection
        if length(tasks.similarities.questions) < numTasksPerCategory
            fprintf('WARNING: Not enough similarities tasks available! Requested %d, but only %d available.\n', ...
                numTasksPerCategory, length(tasks.similarities.questions));
            numTasksPerCategory_similarities = length(tasks.similarities.questions);
        else
            numTasksPerCategory_similarities = numTasksPerCategory;
        end
        randomIndices = randperm(length(tasks.similarities.questions), numTasksPerCategory_similarities);
        
        % Try to mark questions as used
        if exist('questionTracker', 'file') == 2
            try
                questionTracker('mark', 'similarities', randomIndices);
            catch
                fprintf('WARNING: Could not mark similarities questions as used.\n');
            end
        end
    end
else
    % Fall back to random selection without tracking
    if length(tasks.similarities.questions) < numTasksPerCategory
        fprintf('WARNING: Not enough similarities tasks available! Requested %d, but only %d available.\n', ...
            numTasksPerCategory, length(tasks.similarities.questions));
        numTasksPerCategory_similarities = length(tasks.similarities.questions);
    else
        numTasksPerCategory_similarities = numTasksPerCategory;
    end
    randomIndices = randperm(length(tasks.similarities.questions), numTasksPerCategory_similarities);
end

for i = 1:numTasksPerCategory_similarities
    taskIdx = randomIndices(i);
    currentTask = tasks.similarities.questions(taskIdx);
    
    % Create the prompt
    promptText = sprintf('How are "%s" and "%s" alike?', currentTask.word1, currentTask.word2);
    
    % Present task and get response using enhanced function
    [response, respTime] = enhancedGetResponse(window, promptText, currentTask.options, screenInfo);
    
    % Check for escape key
    if response == -1
        fprintf('Test exited during Similarities question %d\n', i);
        preTestResults.exitPoint = sprintf('Similarities question %d', i);
        return;
    end
    
    % Check if response is correct
    isCorrect = (response == currentTask.correctAnswer);
    
    % Store results
    preTestResults.similarities.correct(i) = isCorrect;
    preTestResults.similarities.responseTime(i) = respTime;
    preTestResults.similarities.taskIds(i) = taskIdx;
    
    % Provide feedback
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
% Display category header
Screen('TextSize', window, 36);
DrawFormattedText(window, 'VOCABULARY', 'center', 'center', screenInfo.black);
DrawFormattedText(window, 'Define or identify the meaning of words', 'center', screenInfo.screenYpixels * 0.6, screenInfo.black);
DrawFormattedText(window, 'Press any key to continue...', 'center', screenInfo.screenYpixels * 0.7, screenInfo.black);
Screen('Flip', window);
KbStrokeWait;
WaitSecs(0.5);

% Select unused vocabulary tasks
if exist('getUnusedQuestions', 'file') == 2
    try
        % Use the question selection helper function
        randomIndices = getUnusedQuestions('vocabulary', numTasksPerCategory);
        numTasksPerCategory_vocab = length(randomIndices);
        
        % Mark these questions as used in the question tracker
        questionTracker('mark', 'vocabulary', randomIndices);
    catch selectionError
        fprintf('WARNING: Error using getUnusedQuestions: %s\n', selectionError.message);
        % Fall back to random selection
        if length(tasks.vocabulary) < numTasksPerCategory
            fprintf('WARNING: Not enough vocabulary tasks available! Requested %d, but only %d available.\n', ...
                numTasksPerCategory, length(tasks.vocabulary));
            numTasksPerCategory_vocab = length(tasks.vocabulary);
        else
            numTasksPerCategory_vocab = numTasksPerCategory;
        end
        randomIndices = randperm(length(tasks.vocabulary), numTasksPerCategory_vocab);
        
        % Try to mark questions as used
        if exist('questionTracker', 'file') == 2
            try
                questionTracker('mark', 'vocabulary', randomIndices);
            catch
                fprintf('WARNING: Could not mark vocabulary questions as used.\n');
            end
        end
    end
else
    % Fall back to random selection without tracking
    if length(tasks.vocabulary) < numTasksPerCategory
        fprintf('WARNING: Not enough vocabulary tasks available! Requested %d, but only %d available.\n', ...
            numTasksPerCategory, length(tasks.vocabulary));
        numTasksPerCategory_vocab = length(tasks.vocabulary);
    else
        numTasksPerCategory_vocab = numTasksPerCategory;
    end
    randomIndices = randperm(length(tasks.vocabulary), numTasksPerCategory_vocab);
end

for i = 1:numTasksPerCategory_vocab
    taskIdx = randomIndices(i);
    currentTask = tasks.vocabulary(taskIdx);
    
    % Create the prompt
    promptText = sprintf('What does "%s" mean?', currentTask.word);
    
    % Present task and get response using enhanced function
    [response, respTime] = enhancedGetResponse(window, promptText, currentTask.options, screenInfo);
    
    % Check for escape key
    if response == -1
        fprintf('Test exited during Vocabulary question %d\n', i);
        preTestResults.exitPoint = sprintf('Vocabulary question %d', i);
        return;
    end
    
    % Check if response is correct
    isCorrect = (response == currentTask.correctAnswer);
    
    % Store results
    preTestResults.vocabulary.correct(i) = isCorrect;
    preTestResults.vocabulary.responseTime(i) = respTime;
    preTestResults.vocabulary.taskIds(i) = taskIdx;
    
    % Provide feedback
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
% Display category header
Screen('TextSize', window, 36);
DrawFormattedText(window, 'INFORMATION', 'center', 'center', screenInfo.black);
DrawFormattedText(window, 'Answer general knowledge questions', 'center', screenInfo.screenYpixels * 0.6, screenInfo.black);
DrawFormattedText(window, 'Press any key to continue...', 'center', screenInfo.screenYpixels * 0.7, screenInfo.black);
Screen('Flip', window);
KbStrokeWait;
WaitSecs(0.5);

% Select unused information tasks
if exist('getUnusedQuestions', 'file') == 2
    try
        % Use the question selection helper function
        randomIndices = getUnusedQuestions('information', numTasksPerCategory);
        numTasksPerCategory_info = length(randomIndices);
        
        % Mark these questions as used in the question tracker
        questionTracker('mark', 'information', randomIndices);
    catch selectionError
        fprintf('WARNING: Error using getUnusedQuestions: %s\n', selectionError.message);
        % Fall back to random selection
        if length(tasks.information) < numTasksPerCategory
            fprintf('WARNING: Not enough information tasks available! Requested %d, but only %d available.\n', ...
                numTasksPerCategory, length(tasks.information));
            numTasksPerCategory_info = length(tasks.information);
        else
            numTasksPerCategory_info = numTasksPerCategory;
        end
        randomIndices = randperm(length(tasks.information), numTasksPerCategory_info);
        
        % Try to mark questions as used
        if exist('questionTracker', 'file') == 2
            try
                questionTracker('mark', 'information', randomIndices);
            catch
                fprintf('WARNING: Could not mark information questions as used.\n');
            end
        end
    end
else
    % Fall back to random selection without tracking
    if length(tasks.information) < numTasksPerCategory
        fprintf('WARNING: Not enough information tasks available! Requested %d, but only %d available.\n', ...
            numTasksPerCategory, length(tasks.information));
        numTasksPerCategory_info = length(tasks.information);
    else
        numTasksPerCategory_info = numTasksPerCategory;
    end
    randomIndices = randperm(length(tasks.information), numTasksPerCategory_info);
end

for i = 1:numTasksPerCategory_info
    taskIdx = randomIndices(i);
    currentTask = tasks.information(taskIdx);
    
    % Present task and get response using enhanced function
    [response, respTime] = enhancedGetResponse(window, currentTask.question, currentTask.options, screenInfo);
    
    % Check for escape key
    if response == -1
        fprintf('Test exited during Information question %d\n', i);
        preTestResults.exitPoint = sprintf('Information question %d', i);
        return;
    end
    
    % Check if response is correct
    isCorrect = (response == currentTask.correctAnswer);
    
    % Store results
    preTestResults.information.correct(i) = isCorrect;
    preTestResults.information.responseTime(i) = respTime;
    preTestResults.information.taskIds(i) = taskIdx;
    
    % Provide feedback
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

% Mark test as completed
preTestResults.completed = true;

% Calculate overall metrics
preTestResults.overallAccuracy = (sum(preTestResults.similarities.correct) + ...
                                  sum(preTestResults.vocabulary.correct) + ...
                                  sum(preTestResults.information.correct)) / ...
                                 (length(preTestResults.similarities.correct) + ...
                                  length(preTestResults.vocabulary.correct) + ...
                                  length(preTestResults.information.correct));
                              
preTestResults.averageResponseTime = mean([mean(preTestResults.similarities.responseTime), ...
                                          mean(preTestResults.vocabulary.responseTime), ...
                                          mean(preTestResults.information.responseTime)]);

% Display pre-test completion
Screen('TextSize', window, 36);
DrawFormattedText(window, 'Pre-Test Completed', 'center', screenInfo.screenYpixels * 0.4, screenInfo.black);
DrawFormattedText(window, sprintf('Your accuracy: %.1f%%', preTestResults.overallAccuracy * 100), 'center', screenInfo.screenYpixels * 0.5, screenInfo.black);
DrawFormattedText(window, sprintf('Average response time: %.2f seconds', preTestResults.averageResponseTime), 'center', screenInfo.screenYpixels * 0.6, screenInfo.black);
DrawFormattedText(window, 'Press any key to continue to the training phase...', 'center', screenInfo.screenYpixels * 0.7, screenInfo.black);
Screen('Flip', window);
KbStrokeWait;
WaitSecs(0.5);

% Show a summary of used questions if tracking is available
if exist('questionTracker', 'file') == 2
    try
        questionTracker('status');
    catch
        fprintf('WARNING: Could not display question tracker status.\n');
    end
end
end