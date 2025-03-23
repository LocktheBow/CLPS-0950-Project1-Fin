function runTrainingPhase(window, tasks, screenInfo)
% RUNTRAININGPHASE - Teaches users how to approach verbal comprehension tasks
%
% This function provides examples and explanations for each task type,
% helping users understand the patterns and strategies needed for success.
%
% Inputs:
%   window - Psychtoolbox window pointer
%   tasks - Structure containing all tasks data
%   screenInfo - Structure with screen parameters

% Show training introduction
showInstructions(window, 'training', screenInfo);

% === 1. SIMILARITIES TRAINING ===
% Display category header
Screen('TextSize', window, 42);
DrawFormattedText(window, 'SIMILARITIES TRAINING', 'center', screenInfo.screenYpixels * 0.2, screenInfo.black);
Screen('TextSize', window, 36);
DrawFormattedText(window, 'Learn to identify relationships between words', 'center', screenInfo.screenYpixels * 0.3, screenInfo.black);
DrawFormattedText(window, 'Press any key to begin...', 'center', screenInfo.screenYpixels * 0.8, screenInfo.black);
Screen('Flip', window);
KbStrokeWait;
WaitSecs(0.5);

% Show examples from the dedicated training examples
for i = 1:length(tasks.similarities.trainingPairs)
    % Get training example data
    pair = tasks.similarities.trainingPairs{i};
    options = tasks.similarities.trainingOptions{i};
    correctAnswer = tasks.similarities.trainingCorrectIndices(i);
    
    % Create the prompt
    promptText = sprintf('EXAMPLE %d: How are "%s" and "%s" alike?', i, pair{1}, pair{2});
    
    % Display the example
    Screen('TextSize', window, 36);
    DrawFormattedText(window, promptText, 'center', screenInfo.screenYpixels * 0.2, screenInfo.black);
    
    % Display options with correct answer highlighted
    yPos = screenInfo.screenYpixels * 0.35;
    for j = 1:length(options)
        if j == correctAnswer
            optionText = ['>> ' num2str(j) '. ' options{j} ' <<'];
            textColor = [0, 0.6, 0]; % Green for correct
        else
            optionText = [num2str(j) '. ' options{j}];
            textColor = screenInfo.black;
        end
        DrawFormattedText(window, optionText, 'center', yPos, textColor);
        yPos = yPos + 40;
    end
    
    % Provide explanation
    yPos = screenInfo.screenYpixels * 0.6;
    
    % Customize explanation based on the example
    if i == 1 % dog, cat
        explanationText = {'When finding relationships between words, look for the most:', ...
                          '* General category they both belong to', ...
                          '* Important shared attribute', ...
                          '* Functional similarity', ...
                          '', ...
                          'Both "dog" and "cat" are animals - this is the fundamental category.'};
    elseif i == 2 % pen, pencil
        explanationText = {'The best approach is to identify what makes these items similar:', ...
                          '* What purpose do they serve?', ...
                          '* What category do they both fall under?', ...
                          '', ...
                          'Both "pen" and "pencil" are writing instruments - identifying their', ...
                          'shared function gives us the most precise relationship.'};
    else % sun, moon
        explanationText = {'For abstract or different items, look for higher-level categories:', ...
                          '* What scientific classification do they share?', ...
                          '* What role do they play in a larger system?', ...
                          '', ...
                          'Both "sun" and "moon" are celestial bodies - they belong to', ...
                          'the same astronomical classification despite their differences.'};
    end
    
    % Display explanation
    for j = 1:length(explanationText)
        DrawFormattedText(window, explanationText{j}, 'center', yPos, screenInfo.black);
        yPos = yPos + 30;
    end
    
    DrawFormattedText(window, 'Press any key to continue...', 'center', screenInfo.screenYpixels * 0.9, screenInfo.black);
    Screen('Flip', window);
    KbStrokeWait;
    WaitSecs(0.5);
end

% === 2. VOCABULARY TRAINING ===
% Display category header
Screen('TextSize', window, 42);
DrawFormattedText(window, 'VOCABULARY TRAINING', 'center', screenInfo.screenYpixels * 0.2, screenInfo.black);
Screen('TextSize', window, 36);
DrawFormattedText(window, 'Learn to identify the meanings of words', 'center', screenInfo.screenYpixels * 0.3, screenInfo.black);
DrawFormattedText(window, 'Press any key to begin...', 'center', screenInfo.screenYpixels * 0.8, screenInfo.black);
Screen('Flip', window);
KbStrokeWait;
WaitSecs(0.5);

% Show examples (3 examples from the vocabulary tasks)
exampleIndices = [2, 5, 8]; % Choose diverse examples
for i = 1:length(exampleIndices)
    taskIdx = exampleIndices(i);
    currentTask = tasks.vocabulary(taskIdx);
    
    % Create the prompt
    promptText = sprintf('EXAMPLE %d: What does "%s" mean?', i, currentTask.word);
    
    % Display the example
    Screen('TextSize', window, 36);
    DrawFormattedText(window, promptText, 'center', screenInfo.screenYpixels * 0.2, screenInfo.black);
    
    % Display options with correct answer highlighted
    yPos = screenInfo.screenYpixels * 0.35;
    for j = 1:length(currentTask.options)
        if j == currentTask.correctAnswer
            optionText = ['>> ' num2str(j) '. ' currentTask.options{j} ' <<'];
            textColor = [0, 0.6, 0]; % Green for correct
        else
            optionText = [num2str(j) '. ' currentTask.options{j}];
            textColor = screenInfo.black;
        end
        DrawFormattedText(window, optionText, 'center', yPos, textColor);
        yPos = yPos + 40;
    end
    
    % Provide explanation
    yPos = screenInfo.screenYpixels * 0.6;
    
    % Customize explanation based on the example
    if i == 1 % probably "arduous"
        explanationText = {'When determining word meanings, consider:', ...
                          '* The context if available', ...
                          '* Word roots you recognize', ...
                          '* Prefixes and suffixes', ...
                          '', ...
                          'This word refers to something difficult or requiring great effort -', ...
                          'many challenging tasks can be described as arduous.'};
    elseif i == 2 % probably "resilient"
        explanationText = {'For definitions, look for the core concept:', ...
                          '* What is the primary characteristic?', ...
                          '* What situations would this word apply to?', ...
                          '', ...
                          'Being "resilient" means being able to recover quickly from difficulties -', ...
                          'it describes the ability to bounce back from challenges.'};
    else % probably "eloquent"
        explanationText = {'To identify correct definitions:', ...
                          '* Rule out options that are opposite in meaning', ...
                          '* Consider related words you might know', ...
                          '* Think of examples where you''ve heard the word', ...
                          '', ...
                          'Being "eloquent" means being fluent or persuasive in speaking or writing -', ...
                          'it describes someone who expresses themselves effectively.'};
    end
    
    % Display explanation
    for j = 1:length(explanationText)
        DrawFormattedText(window, explanationText{j}, 'center', yPos, screenInfo.black);
        yPos = yPos + 30;
    end
    
    DrawFormattedText(window, 'Press any key to continue...', 'center', screenInfo.screenYpixels * 0.9, screenInfo.black);
    Screen('Flip', window);
    KbStrokeWait;
    WaitSecs(0.5);
end

% === 3. INFORMATION TRAINING ===
% Display category header
Screen('TextSize', window, 42);
DrawFormattedText(window, 'INFORMATION TRAINING', 'center', screenInfo.screenYpixels * 0.2, screenInfo.black);
Screen('TextSize', window, 36);
DrawFormattedText(window, 'Learn to retrieve facts from memory', 'center', screenInfo.screenYpixels * 0.3, screenInfo.black);
DrawFormattedText(window, 'Press any key to begin...', 'center', screenInfo.screenYpixels * 0.8, screenInfo.black);
Screen('Flip', window);
KbStrokeWait;
WaitSecs(0.5);

% Show examples (3 examples from the information tasks)
exampleIndices = [1, 4, 7]; % Choose diverse examples
for i = 1:length(exampleIndices)
    taskIdx = exampleIndices(i);
    currentTask = tasks.information(taskIdx);
    
    % Create the prompt
    promptText = sprintf('EXAMPLE %d: %s', i, currentTask.question);
    
    % Display the example
    Screen('TextSize', window, 36);
    DrawFormattedText(window, promptText, 'center', screenInfo.screenYpixels * 0.2, screenInfo.black);
    
    % Display options with correct answer highlighted
    yPos = screenInfo.screenYpixels * 0.35;
    for j = 1:length(currentTask.options)
        if j == currentTask.correctAnswer
            optionText = ['>> ' num2str(j) '. ' currentTask.options{j} ' <<'];
            textColor = [0, 0.6, 0]; % Green for correct
        else
            optionText = [num2str(j) '. ' currentTask.options{j}];
            textColor = screenInfo.black;
        end
        DrawFormattedText(window, optionText, 'center', yPos, textColor);
        yPos = yPos + 40;
    end
    
    % Provide explanation
    yPos = screenInfo.screenYpixels * 0.6;
    
    % Customize explanation based on the example
    if i == 1 % capital of France
        explanationText = {'For factual questions, use these strategies:', ...
                          '* Visualize the information if possible', ...
                          '* Make associations with things you already know', ...
                          '* Eliminate obviously incorrect options', ...
                          '', ...
                          'Paris is the capital of France - a basic geography fact that', ...
                          'connects to many historical and cultural associations.'};
    elseif i == 2 % mountain or chemical
        explanationText = {'When retrieving information from memory:', ...
                          '* Try to recall specific details you''ve learned', ...
                          '* Consider subject categories (science, history, etc.)', ...
                          '* Use logical reasoning for unfamiliar questions', ...
                          '', ...
                          'This fact comes from established knowledge that you''ve', ...
                          'encountered before - try to form stronger associations.'};
    else % likely an art or literature question
        explanationText = {'To improve information recall:', ...
                          '* Create mental images connected to facts', ...
                          '* Make personal connections to the information', ...
                          '* Group related facts together', ...
                          '', ...
                          'When you encounter this information again, try to form', ...
                          'stronger memory connections by relating it to things you know well.'};
    end
    
    % Display explanation
    for j = 1:length(explanationText)
        DrawFormattedText(window, explanationText{j}, 'center', yPos, screenInfo.black);
        yPos = yPos + 30;
    end
    
    DrawFormattedText(window, 'Press any key to continue...', 'center', screenInfo.screenYpixels * 0.9, screenInfo.black);
    Screen('Flip', window);
    KbStrokeWait;
    WaitSecs(0.5);
end

% Training summary
Screen('TextSize', window, 42);
DrawFormattedText(window, 'TRAINING COMPLETE', 'center', screenInfo.screenYpixels * 0.3, screenInfo.black);
Screen('TextSize', window, 36);

summaryText = {
    'You have learned strategies for three types of verbal tasks:', ...
    '', ...
    '1. SIMILARITIES: Identify the fundamental category or function', ...
    '   that two items share.', ...
    '', ...
    '2. VOCABULARY: Understand word meanings by considering context,', ...
    '   word roots, and examples of usage.', ...
    '', ...
    '3. INFORMATION: Retrieve facts by forming strong associations', ...
    '   and using elimination for unfamiliar questions.'
};

yPos = screenInfo.screenYpixels * 0.4;
for i = 1:length(summaryText)
    DrawFormattedText(window, summaryText{i}, 'center', yPos, screenInfo.black);
    yPos = yPos + 35;
end

DrawFormattedText(window, 'Next, you will practice these skills with new examples.', 'center', screenInfo.screenYpixels * 0.8, screenInfo.black);
DrawFormattedText(window, 'Press any key to continue to practice...', 'center', screenInfo.screenYpixels * 0.9, screenInfo.black);
Screen('Flip', window);
KbStrokeWait;
% Mark these training examples as used in the question tracker
if exist('questionTracker', 'file') == 2
    % Mark similarities training examples
    questionTracker('mark', 'similarities', exampleIndices);
    
    % Mark vocabulary training examples 
    questionTracker('mark', 'vocabulary', exampleIndices);
    
    % Mark information training examples
    questionTracker('mark', 'information', exampleIndices);
    
    % Show tracking status
    questionTracker('status');
else
    fprintf('Question tracking not available - training examples not marked.\n');
end
WaitSecs(0.5);
end