function [postTestResults, improvement] = runPostTest(window, tasks, preTestResults, screenInfo)
% RUNPOSTTEST - Measures the evolved state of awareness after training
%
% This function administers the post-test assessment to measure how
% comprehension has changed through training. It uses DIFFERENT tasks
% from the pre-test to ensure valid comparison without memory effects.
%
% Inputs:
%   window - Window pointer
%   tasks - Structure containing task data
%   preTestResults - Structure containing baseline measurements
%   screenInfo - Screen parameters
%
% Outputs:
%   postTestResults - Structure containing post-training measurements
%   improvement - Structure containing the delta in performance

% Initialize results structure
postTestResults = struct();
postTestResults.similarities = struct('correct', [], 'responseTime', [], 'taskIds', []);
postTestResults.vocabulary = struct('correct', [], 'responseTime', [], 'taskIds', []);
postTestResults.information = struct('correct', [], 'responseTime', [], 'taskIds', []);
postTestResults.timestamp = now;

% Number of questions for each category - matching pre-test
numQuestionsNeeded = length(preTestResults.similarities.taskIds);

% Display post-test instructions
Screen('TextSize', window, 36);
DrawFormattedText(window, 'Post-Test: Measure your verbal comprehension after training', 'center', 'center', screenInfo.black);
DrawFormattedText(window, 'Press any key to begin...', 'center', screenInfo.screenYpixels * 0.7, screenInfo.black);
Screen('Flip', window);
KbStrokeWait;
WaitSecs(0.5);

% --- 1. SIMILARITIES TASKS ---
% Display category header
Screen('TextSize', window, 36);
DrawFormattedText(window, 'SIMILARITIES', 'center', 'center', screenInfo.black);
DrawFormattedText(window, 'Identify the relationship between pairs of words', 'center', screenInfo.screenYpixels * 0.6, screenInfo.black);
DrawFormattedText(window, 'Press any key to continue...', 'center', screenInfo.screenYpixels * 0.7, screenInfo.black);
Screen('Flip', window);
KbStrokeWait;
WaitSecs(0.5);

% Select DIFFERENT questions for the post-test using our helper function
if exist('getUnusedQuestions', 'file') == 2
    try
        % Use our question selection helper
        randomIndices = getUnusedQuestions('similarities', numQuestionsNeeded);
        
        % Mark these as used
        if exist('questionTracker', 'file') == 2
            questionTracker('mark', 'similarities', randomIndices);
        end
    catch helperError
        fprintf('Error using getUnusedQuestions: %s\n', helperError.message);
        
        % Fall back to original method
        if exist('questionTracker', 'file') == 2
            % Find unused similarity questions
            availableIndices = [];
            for i = 1:length(tasks.similarities.questions)
                try
                    isAvailable = questionTracker('check', 'similarities', i);
                    if isAvailable
                        availableIndices = [availableIndices, i];
                    end
                catch
                    % Skip this question if there's an error checking it
                    continue;
                end
            end
            
            if length(availableIndices) >= numQuestionsNeeded
                % We have enough unused questions, select random ones from available set
                randomIndices = availableIndices(randperm(length(availableIndices), numQuestionsNeeded));
                % Mark these as used
                questionTracker('mark', 'similarities', randomIndices);
            else
                % Not enough unused questions, generate warning and select random ones
                fprintf('WARNING: Not enough unused similarity questions for post-test. Some questions may repeat.\n');
                randomIndices = randperm(length(tasks.similarities.questions), numQuestionsNeeded);
            end
        else
            % No question tracker available, just pick random questions
            % Try to avoid the ones used in pre-test if possible
            allIndices = 1:length(tasks.similarities.questions);
            usedIndices = preTestResults.similarities.taskIds;
            availableIndices = setdiff(allIndices, usedIndices);
            
            if length(availableIndices) >= numQuestionsNeeded
                randomIndices = availableIndices(randperm(length(availableIndices), numQuestionsNeeded));
            else
                % Not enough different questions, use random ones
                randomIndices = randperm(length(tasks.similarities.questions), numQuestionsNeeded);
            end
        end
    end
else
    % Helper function not available, use original method
    if exist('questionTracker', 'file') == 2
        % Find unused similarity questions
        availableIndices = [];
        for i = 1:length(tasks.similarities)
            try
                isAvailable = questionTracker('check', 'similarities', i);
                if isAvailable
                    availableIndices = [availableIndices, i];
                end
            catch
                % Skip this question if there's an error checking it
                continue;
            end
        end
        
        if length(availableIndices) >= numQuestionsNeeded
            % We have enough unused questions, select random ones from available set
            randomIndices = availableIndices(randperm(length(availableIndices), numQuestionsNeeded));
            % Mark these as used
            questionTracker('mark', 'similarities', randomIndices);
        else
            % Not enough unused questions, generate warning and select random ones
            fprintf('WARNING: Not enough unused similarity questions for post-test. Some questions may repeat.\n');
            randomIndices = randperm(length(tasks.similarities), numQuestionsNeeded);
        end
    else
        % No question tracker available, just pick random questions
        % Try to avoid the ones used in pre-test if possible
        allIndices = 1:length(tasks.similarities);
        usedIndices = preTestResults.similarities.taskIds;
        availableIndices = setdiff(allIndices, usedIndices);
        
        if length(availableIndices) >= numQuestionsNeeded
            randomIndices = availableIndices(randperm(length(availableIndices), numQuestionsNeeded));
        else
            % Not enough different questions, use random ones
            randomIndices = randperm(length(tasks.similarities), numQuestionsNeeded);
        end
    end
end

% Present the selected similarities tasks
for i = 1:length(randomIndices)
    taskIdx = randomIndices(i);
    currentTask = tasks.similarities.questions(taskIdx);
    
    % Create the prompt
    promptText = sprintf('How are "%s" and "%s" alike?', currentTask.word1, currentTask.word2);
    
    % Capture response
    [response, respTime] = getResponse(window, promptText, currentTask.options, screenInfo);
    
    % Check if correct
    isCorrect = (response == currentTask.correctAnswer);
    
    % Store results
    postTestResults.similarities.correct(i) = isCorrect;
    postTestResults.similarities.responseTime(i) = respTime;
    postTestResults.similarities.taskIds(i) = taskIdx;
    
    % Display feedback
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

% Select unused vocabulary questions using our helper function
if exist('getUnusedQuestions', 'file') == 2
    try
        % Use our question selection helper
        randomIndices = getUnusedQuestions('vocabulary', numQuestionsNeeded);
        
        % Mark these as used
        if exist('questionTracker', 'file') == 2
            questionTracker('mark', 'vocabulary', randomIndices);
        end
    catch helperError
        fprintf('Error using getUnusedQuestions for vocabulary: %s\n', helperError.message);
        
        % Fall back to original method
        if exist('questionTracker', 'file') == 2
            availableIndices = [];
            for i = 1:length(tasks.vocabulary)
                try
                    isAvailable = questionTracker('check', 'vocabulary', i);
                    if isAvailable
                        availableIndices = [availableIndices, i];
                    end
                catch
                    continue;
                end
            end
            
            if length(availableIndices) >= numQuestionsNeeded
                randomIndices = availableIndices(randperm(length(availableIndices), numQuestionsNeeded));
                questionTracker('mark', 'vocabulary', randomIndices);
            else
                fprintf('WARNING: Not enough unused vocabulary questions for post-test. Some questions may repeat.\n');
                randomIndices = randperm(length(tasks.vocabulary), numQuestionsNeeded);
            end
        else
            allIndices = 1:length(tasks.vocabulary);
            usedIndices = preTestResults.vocabulary.taskIds;
            availableIndices = setdiff(allIndices, usedIndices);
            
            if length(availableIndices) >= numQuestionsNeeded
                randomIndices = availableIndices(randperm(length(availableIndices), numQuestionsNeeded));
            else
                randomIndices = randperm(length(tasks.vocabulary), numQuestionsNeeded);
            end
        end
    end
else
    % Helper function not available, use original method
    if exist('questionTracker', 'file') == 2
        availableIndices = [];
        for i = 1:length(tasks.vocabulary)
            try
                isAvailable = questionTracker('check', 'vocabulary', i);
                if isAvailable
                    availableIndices = [availableIndices, i];
                end
            catch
                continue;
            end
        end
        
        if length(availableIndices) >= numQuestionsNeeded
            randomIndices = availableIndices(randperm(length(availableIndices), numQuestionsNeeded));
            questionTracker('mark', 'vocabulary', randomIndices);
        else
            fprintf('WARNING: Not enough unused vocabulary questions for post-test. Some questions may repeat.\n');
            randomIndices = randperm(length(tasks.vocabulary), numQuestionsNeeded);
        end
    else
        allIndices = 1:length(tasks.vocabulary);
        usedIndices = preTestResults.vocabulary.taskIds;
        availableIndices = setdiff(allIndices, usedIndices);
        
        if length(availableIndices) >= numQuestionsNeeded
            randomIndices = availableIndices(randperm(length(availableIndices), numQuestionsNeeded));
        else
            randomIndices = randperm(length(tasks.vocabulary), numQuestionsNeeded);
        end
    end
end

% Present the selected vocabulary tasks
for i = 1:length(randomIndices)
    taskIdx = randomIndices(i);
    currentTask = tasks.vocabulary(taskIdx);
    
    % Create the prompt
    promptText = sprintf('What does "%s" mean?', currentTask.word);
    
    % Capture response
    [response, respTime] = getResponse(window, promptText, currentTask.options, screenInfo);
    
    % Check if correct
    isCorrect = (response == currentTask.correctAnswer);
    
    % Store results
    postTestResults.vocabulary.correct(i) = isCorrect;
    postTestResults.vocabulary.responseTime(i) = respTime;
    postTestResults.vocabulary.taskIds(i) = taskIdx;
    
    % Display feedback
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

% Select unused information questions using our helper function
if exist('getUnusedQuestions', 'file') == 2
    try
        % Use our question selection helper
        randomIndices = getUnusedQuestions('information', numQuestionsNeeded);
        
        % Mark these as used
        if exist('questionTracker', 'file') == 2
            questionTracker('mark', 'information', randomIndices);
        end
    catch helperError
        fprintf('Error using getUnusedQuestions for information: %s\n', helperError.message);
        
        % Fall back to original method
        if exist('questionTracker', 'file') == 2
            availableIndices = [];
            for i = 1:length(tasks.information)
                try
                    isAvailable = questionTracker('check', 'information', i);
                    if isAvailable
                        availableIndices = [availableIndices, i];
                    end
                catch
                    continue;
                end
            end
            
            if length(availableIndices) >= numQuestionsNeeded
                randomIndices = availableIndices(randperm(length(availableIndices), numQuestionsNeeded));
                questionTracker('mark', 'information', randomIndices);
            else
                fprintf('WARNING: Not enough unused information questions for post-test. Some questions may repeat.\n');
                randomIndices = randperm(length(tasks.information), numQuestionsNeeded);
            end
        else
            allIndices = 1:length(tasks.information);
            usedIndices = preTestResults.information.taskIds;
            availableIndices = setdiff(allIndices, usedIndices);
            
            if length(availableIndices) >= numQuestionsNeeded
                randomIndices = availableIndices(randperm(length(availableIndices), numQuestionsNeeded));
            else
                randomIndices = randperm(length(tasks.information), numQuestionsNeeded);
            end
        end
    end
else
    % Helper function not available, use original method
    if exist('questionTracker', 'file') == 2
        availableIndices = [];
        for i = 1:length(tasks.information)
            try
                isAvailable = questionTracker('check', 'information', i);
                if isAvailable
                    availableIndices = [availableIndices, i];
                end
            catch
                continue;
            end
        end
        
        if length(availableIndices) >= numQuestionsNeeded
            randomIndices = availableIndices(randperm(length(availableIndices), numQuestionsNeeded));
            questionTracker('mark', 'information', randomIndices);
        else
            fprintf('WARNING: Not enough unused information questions for post-test. Some questions may repeat.\n');
            randomIndices = randperm(length(tasks.information), numQuestionsNeeded);
        end
    else
        allIndices = 1:length(tasks.information);
        usedIndices = preTestResults.information.taskIds;
        availableIndices = setdiff(allIndices, usedIndices);
        
        if length(availableIndices) >= numQuestionsNeeded
            randomIndices = availableIndices(randperm(length(availableIndices), numQuestionsNeeded));
        else
            randomIndices = randperm(length(tasks.information), numQuestionsNeeded);
        end
    end
end

% Present the selected information tasks
for i = 1:length(randomIndices)
    taskIdx = randomIndices(i);
    currentTask = tasks.information(taskIdx);
    
    % Present task and get response
    [response, respTime] = getResponse(window, currentTask.question, currentTask.options, screenInfo);
    
    % Check if correct
    isCorrect = (response == currentTask.correctAnswer);
    
    % Store results
    postTestResults.information.correct(i) = isCorrect;
    postTestResults.information.responseTime(i) = respTime;
    postTestResults.information.taskIds(i) = taskIdx;
    
    % Display feedback
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

% Calculate overall metrics
postTestResults.overallAccuracy = (sum(postTestResults.similarities.correct) + ...
                                  sum(postTestResults.vocabulary.correct) + ...
                                  sum(postTestResults.information.correct)) / ...
                                 (length(postTestResults.similarities.correct) + ...
                                  length(postTestResults.vocabulary.correct) + ...
                                  length(postTestResults.information.correct));
                              
postTestResults.averageResponseTime = mean([mean(postTestResults.similarities.responseTime), ...
                                           mean(postTestResults.vocabulary.responseTime), ...
                                           mean(postTestResults.information.responseTime)]);

% Calculate improvement metrics
improvement = struct();

% Calculate accuracy improvement (percentage points)
improvement.similaritiesAccuracy = mean(postTestResults.similarities.correct) - mean(preTestResults.similarities.correct);
improvement.vocabularyAccuracy = mean(postTestResults.vocabulary.correct) - mean(preTestResults.vocabulary.correct);
improvement.informationAccuracy = mean(postTestResults.information.correct) - mean(preTestResults.information.correct);
improvement.overallAccuracy = postTestResults.overallAccuracy - preTestResults.overallAccuracy;

% Calculate response time improvement (negative values mean faster times)
improvement.similaritiesRT = mean(preTestResults.similarities.responseTime) - mean(postTestResults.similarities.responseTime);
improvement.vocabularyRT = mean(preTestResults.vocabulary.responseTime) - mean(postTestResults.vocabulary.responseTime);
improvement.informationRT = mean(preTestResults.information.responseTime) - mean(postTestResults.information.responseTime);
improvement.overallRT = preTestResults.averageResponseTime - postTestResults.averageResponseTime;

% Calculate percentage improvements
if preTestResults.overallAccuracy > 0
    improvement.accuracyPercentage = (improvement.overallAccuracy / preTestResults.overallAccuracy) * 100;
else
    improvement.accuracyPercentage = Inf; % If pre-test accuracy was 0
end

if preTestResults.averageResponseTime > 0
    improvement.rtPercentage = (improvement.overallRT / preTestResults.averageResponseTime) * 100;
else
    improvement.rtPercentage = 0; % No improvement if pre-test RT was 0
end

% Display post-test completion with improvement statistics
Screen('TextSize', window, 36);
DrawFormattedText(window, 'Post-Test Completed', 'center', screenInfo.screenYpixels * 0.3, screenInfo.black);
DrawFormattedText(window, sprintf('Pre-test accuracy: %.1f%%', preTestResults.overallAccuracy * 100), 'center', screenInfo.screenYpixels * 0.4, screenInfo.black);
DrawFormattedText(window, sprintf('Post-test accuracy: %.1f%%', postTestResults.overallAccuracy * 100), 'center', screenInfo.screenYpixels * 0.45, screenInfo.black);
DrawFormattedText(window, sprintf('Accuracy improvement: %.1f percentage points', improvement.overallAccuracy * 100), 'center', screenInfo.screenYpixels * 0.5, screenInfo.black);
DrawFormattedText(window, sprintf('Pre-test response time: %.2f seconds', preTestResults.averageResponseTime), 'center', screenInfo.screenYpixels * 0.55, screenInfo.black);
DrawFormattedText(window, sprintf('Post-test response time: %.2f seconds', postTestResults.averageResponseTime), 'center', screenInfo.screenYpixels * 0.6, screenInfo.black);

if improvement.overallRT > 0
    DrawFormattedText(window, sprintf('Response time improvement: %.2f seconds faster', improvement.overallRT), 'center', screenInfo.screenYpixels * 0.65, screenInfo.black);
else
    DrawFormattedText(window, sprintf('Response time change: %.2f seconds slower', abs(improvement.overallRT)), 'center', screenInfo.screenYpixels * 0.65, screenInfo.black);
end

DrawFormattedText(window, 'Press any key to exit...', 'center', screenInfo.screenYpixels * 0.75, screenInfo.black);
Screen('Flip', window);
KbStrokeWait;
WaitSecs(0.5);

end