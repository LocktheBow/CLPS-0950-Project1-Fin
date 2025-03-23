function information = enhancedGenerateInformationData()
% ENHANCEDGENERATEINFORMATIONDATA Creates an expanded set of general knowledge questions
%
% This function generates a larger bank of general knowledge questions
% for the Information task to ensure minimal repetition across test phases.
%
% Returns:
%   information - Structure with questions, answers, options, and correctIndices

% Initialize structure
information = struct();

% Expanded set of general knowledge questions and answers
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
    'What is the smallest prime number?';
    'What is the capital of Japan?';
    'Which is the largest species of big cat?';
    'What is the chemical symbol for sodium?';
    'Who discovered penicillin?';
    'What is the largest mammal on Earth?';
    'What is the official language of Brazil?';
    'In which year did World War II end?';
    'Which gas makes up the majority of Earth''s atmosphere?';
    'What is the currency of Japan?';
    'Which planet is closest to the sun?';
    'Who wrote "To Kill a Mockingbird"?';
    'What is the longest river in the world?';
    'What is the square root of 144?';
    'What is the capital of Australia?';
    'What is the freezing point of water in Celsius?'
};

% Corresponding answers
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
    '2';
    'Tokyo';
    'Tiger';
    'Na';
    'Alexander Fleming';
    'Blue Whale';
    'Portuguese';
    '1945';
    'Nitrogen';
    'Yen';
    'Mercury';
    'Harper Lee';
    'Nile';
    '12';
    'Canberra';
    '0'
};

% Initialize arrays for options and correct indices
information.options = cell(length(information.questions), 1);
information.correctIndices = zeros(length(information.questions), 1);

% Generate multiple-choice options for each question
for i = 1:length(information.questions)
    correct = information.answers{i};
    
    % Create incorrect but plausible options for each question
    % We'll map specific options for each question
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
    elseif i == 10 % smallest prime
        incorrect = {'1', '0', '3'};
    elseif i == 11 % capital of Japan
        incorrect = {'Beijing', 'Seoul', 'Bangkok'};
    elseif i == 12 % largest big cat
        incorrect = {'Lion', 'Jaguar', 'Leopard'};
    elseif i == 13 % sodium symbol
        incorrect = {'So', 'Nd', 'Ni'};
    elseif i == 14 % penicillin
        incorrect = {'Marie Curie', 'Louis Pasteur', 'Albert Einstein'};
    elseif i == 15 % largest mammal
        incorrect = {'African Elephant', 'Sperm Whale', 'Giraffe'};
    elseif i == 16 % Brazil language
        incorrect = {'Spanish', 'English', 'Brazilian'};
    elseif i == 17 % WWII end
        incorrect = {'1918', '1939', '1950'};
    elseif i == 18 % Earth's atmosphere
        incorrect = {'Oxygen', 'Carbon Dioxide', 'Hydrogen'};
    elseif i == 19 % Japan currency
        incorrect = {'Yuan', 'Won', 'Dollar'};
    elseif i == 20 % closest to sun
        incorrect = {'Venus', 'Earth', 'Mars'};
    elseif i == 21 % To Kill a Mockingbird
        incorrect = {'Ernest Hemingway', 'F. Scott Fitzgerald', 'John Steinbeck'};
    elseif i == 22 % longest river
        incorrect = {'Amazon', 'Mississippi', 'Yangtze'};
    elseif i == 23 % sqrt(144)
        incorrect = {'10', '14', '24'};
    elseif i == 24 % capital of Australia
        incorrect = {'Sydney', 'Melbourne', 'Perth'};
    else % freezing point
        incorrect = {'32', '100', '-273'};
    end
    
    % Randomize the order of options (correct + incorrect)
    options = [correct, incorrect];
    randomOrder = randperm(length(options));
    information.options{i} = options(randomOrder);
    
    % Record which option is correct (for scoring)
    information.correctIndices(i) = find(strcmp(information.options{i}, correct));
end

fprintf('Enhanced information data generated with %d questions.\n', length(information.questions));
end