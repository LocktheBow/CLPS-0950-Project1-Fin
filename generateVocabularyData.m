function vocabulary = generateVocabularyData()
    % Initialize structure
    vocabulary = struct();
    
    % Words with their definitions - each on a separate line with semicolons
    vocabulary.words = {
        'benevolent'; 
        'arduous'; 
        'frugal'; 
        'ubiquitous'; 
        'resilient';
        'ambiguous'; 
        'meticulous'; 
        'pragmatic'; 
        'eloquent'; 
        'vigilant'
    };
    
    % Corresponding definitions - structure mirrors the words
    vocabulary.definitions = {
        'showing kindness and goodwill';
        'requiring great effort; difficult and tiring';
        'being economical with money or food';
        'present, appearing, or found everywhere';
        'able to recover quickly from difficulties';
        'open to more than one interpretation';
        'showing great attention to detail';
        'dealing with things sensibly and realistically';
        'fluent or persuasive in speaking or writing';
        'keeping careful watch for possible danger'
    };
    
    % Initialize arrays for options and correct indices
    vocabulary.options = cell(length(vocabulary.words), 1);
    vocabulary.correctIndices = zeros(length(vocabulary.words), 1);
    
    % Generate multiple-choice options for each word
    for i = 1:length(vocabulary.words)
        correct = vocabulary.definitions{i};
        
        % Create incorrect but plausible options for each word
        if i == 1 % benevolent
            incorrect = {'showing malice toward others', 'acting without thinking', 'having great intelligence'};
        elseif i == 2 % arduous
            incorrect = {'simple and effortless', 'full of joy', 'ancient or outdated'};
        elseif i == 3 % frugal
            incorrect = {'wasteful with resources', 'generous with money', 'careful with time'};
        elseif i == 4 % ubiquitous
            incorrect = {'rare and uncommon', 'unique and special', 'hidden from view'};
        elseif i == 5 % resilient
            incorrect = {'fragile under pressure', 'flexible or bendable', 'resistant to change'};
        elseif i == 6 % ambiguous
            incorrect = {'clearly defined', 'moving quickly', 'unnecessarily complicated'};
        elseif i == 7 % meticulous
            incorrect = {'careless or sloppy', 'overly dramatic', 'quick and efficient'};
        elseif i == 8 % pragmatic
            incorrect = {'idealistic and impractical', 'theoretical only', 'concerned with beauty'};
        elseif i == 9 % eloquent
            incorrect = {'unable to express thoughts clearly', 'speaking very little', 'highly technical in speech'};
        else % vigilant
            incorrect = {'unaware of surroundings', 'relaxed and carefree', 'sleeping heavily'};
        end
        
        % Randomize the order of options (correct + incorrect)
        options = [correct, incorrect];
        randomOrder = randperm(length(options));
        vocabulary.options{i} = options(randomOrder);
        
        % Record which option is correct (for scoring)
        vocabulary.correctIndices(i) = find(strcmp(vocabulary.options{i}, correct));
    end
end