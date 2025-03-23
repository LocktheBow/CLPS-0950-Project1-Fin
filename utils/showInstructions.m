function showInstructions(window, phaseType, screenInfo)
% SHOWINSTRUCTIONS - Displays instructions for different phases of the
% training
%Inputs:
% window - Psychtoolbox window pointer
% phaseType - String indicating which phase ('pre-test', 'training', etc.)
% screenInfo - Structure containing screen parameters

%This function displays appropriate instructions to the user based on which
%phase of the Verbal Comprehension Training they are currently in.

%setting up text size
Screen('TextSize',window,36);

%Determine which instructions of display based on the phase
switch phaseType
    case 'welcome'
        title = 'Verbal Comprehension Enhancement Training Module'
        instructions = {
          'Welcome to the Verbal Comprehension Training Module!',
          '',
          'This program will help improve your ability to uderstand,',
          'use, and think with language through a series of exercises,',
          '',
          'You will complete a pre-test, training session, and post-test',
          'to measure your improvement.',
          '',
          'Press any key to begin...'
        };
    case 'pre-test'
        title = 'Pre-Test: Baseline Measurement';
        instructions = {
        'First, we need to measure your current verbal comphrehension skills.',
        '',
        'You will be presented with three types of questions:',
        '1. Similarities: Identify how two words are related',
        '2. Vocabulary: Define words or select the correct meaning',
        '3. Information: Answer general knowledge questions',
        '',
        'Don''t worry about your score - this is just to establish a baseline.',
        '',
        'Press any key to begin the pre-test...'
        };
    case 'training'
        title = 'Training Phase';
        instructions = {
        'Now we will show you examples of each task type.',
        '',
        'For each example, we will explain the correct approach',
        'and the reasoning behind the answer.',
        '',
        'Pay close attention to these examples as they will help you',
        'develop strategies for solving similar problems.',
        '',
        'Press any key to begin training...'        
        };
    case 'practice'
        title = 'Practice Phase';
        instructions = {
        'It''s time to practice what you''ve learned!',
        '',
        'You will be presented with a series of tasks similar to',
        'those you saw in the training phase.',
        '',
        'For each task, select the best answer.',
        'You will receive immediate feedback on your responses.',
        '',
        'Press any key to begin practice...'
        };
    case 'post-test'
        title = 'Post-Test: Measuring Improvement';
        instructions = {
        'Finally, we will measure your verbal comprehension skills again',
        'to see how much you''ve improved.',
        '',
        'The post-test will be similar to the pre-test you completed earlier.',
        '',
        'Try your best on each question!',
        '',
        'Press any key to begin the post-test...'
        };
    case 'results'
        title = 'Training Complete';
        instructions = {
        'Congratulations! You have completed the',
        'Verbal Comprehension Enhancement Training Module.',
        '',
        'On the next screen, you will see your results,',
        'including how much you''ve improved.',
        '',
        'Press any key to see your results...'
        };

    otherwise
        title = 'Instructions';
        instructions = {
            'Press any key to continue...'
            };
end


%Display the title at the top of the screen
DrawFormattedText(window,title,'center',screenInfo.screenYpixels * 0.2, screenInfo.black);

%Calculate the starting Y poisition for instructions (below the title)
startY = screenInfo.screenYpixels * 0.3;
lineHeight = 40; % Space between lines

%Display each line of the instructions
for i = 1:length(instructions)
    yPos = startY + (i-1) * lineHeight;
    DrawFormattedText(window, instructions{i}, 'center', yPos, screenInfo.black);
end

%Update the display to show the text
Screen('Flip', window);

%Wait for the user to press any key before continuing
KbStrokeWait;
WaitSecs(0.2); %Small delay to prevent accidental double presses
end