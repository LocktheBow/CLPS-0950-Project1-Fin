function information = generateInformationData()
    % Initialize structure
    information = struct();
    
    % Questions - each on a separate line with semicolons
    information.questions = {
        'What is the capital of France?';
        'Who wrote the play "Romeo and Juliet"?';
        'What is the chemical symbol for water?';
        'Which planet is known as the Red Planet?';
        'What is the largest organ in the human body?';
        'Which element has the chemical symbol "Au"?';
        'What is the tallest mountain in the world?';
        'Who painted the Mona Lisa?';
        'What is the largest ocean on Earth?';
        'What is the smallest prime number?'
    };
    
    % Corresponding answers - structure mirrors the questions
    information.answers = {
        'Paris';
        'William Shakespeare';
        'H2O';
        'Mars';
        'Skin';
        'Gold';
        'Mount Everest';
        'Leonardo da Vinci';
        'Pacific Ocean';
        '2'
    };
    
    % Initialize arrays for options and correct indices
    information.options = cell(length(information.questions), 1);
    information.correctIndices = zeros(length(information.questions), 1);
    
    % Generate multiple-choice options for each question
    for i = 1:length(information.questions)
        correct = information.answers{i};
        
        % Create incorrect but plausible options for each question
        if i == 1 % capital of France
            incorrect = {'London', 'Berlin', 'Rome'};
        elseif i == 2 % Romeo and Juliet
            incorrect = {'Charles Dickens', 'Jane Austen', 'Mark Twain'};
        elseif i == 3 % water
            incorrect = {'CO2', 'O2', 'NaCl'};
        elseif i == 4 % Red Planet
            incorrect = {'Venus', 'Jupiter', 'Mercury'};
        elseif i == 5 % largest organ
            incorrect = {'Heart', 'Liver', 'Brain'};
        elseif i == 6 % Au
            incorrect = {'Silver', 'Aluminum', 'Copper'};
        elseif i == 7 % tallest mountain
            incorrect = {'K2', 'Kilimanjaro', 'Denali'};
        elseif i == 8 % Mona Lisa
            incorrect = {'Michelangelo', 'Vincent van Gogh', 'Pablo Picasso'};
        elseif i == 9 % largest ocean
            incorrect = {'Atlantic Ocean', 'Indian Ocean', 'Arctic Ocean'};
        else % smallest prime
            incorrect = {'1', '0', '3'};
        end
        
        % Randomize the order of options (correct + incorrect)
        options = [correct, incorrect];
        randomOrder = randperm(length(options));
        information.options{i} = options(randomOrder);
        
        % Record which option is correct (for scoring)
        information.correctIndices(i) = find(strcmp(information.options{i}, correct));
    end
end