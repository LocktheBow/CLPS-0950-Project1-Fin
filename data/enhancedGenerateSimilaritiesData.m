function similarities = enhancedGenerateSimilaritiesData()
% ENHANCEDGENERATESIMILARITIESDATA Creates an expanded set of similarity word pairs
%
% This function generates a larger bank of word pairs with their relationships
% for the Similarities task to ensure minimal repetition across test phases.
%
% Returns:
%   similarities - Structure with pairs, relationships, and options

% Initialize structure
similarities = struct();

% SEPARATE TRAINING EXAMPLES - These questions are used in the training phase
% and will be excluded from the regular question bank
similarities.trainingPairs = {
    {'dog', 'cat'},       % Used in training example 1
    {'pen', 'pencil'},    % Used in training example 2
    {'sun', 'moon'}       % Used in training example 3
};

similarities.trainingRelationships = {
    'both are animals',
    'both are writing instruments',
    'both are celestial bodies'
};

% Main question bank - EXCLUDING the training examples
similarities.pairs = {
    % Group 1 - Basic categories
    {'boat', 'ship'}; 
    {'river', 'lake'};
    {'chair', 'table'}; 
    {'shirt', 'pants'};
    {'doctor', 'nurse'}; 
    {'hammer', 'nail'};
    
    % Group 2 - More categories
    {'piano', 'guitar'};
    {'apple', 'orange'};
    {'car', 'bus'};
    {'telephone', 'computer'};
    {'knife', 'fork'};
    {'teacher', 'professor'};
    
    % Group 3 - More abstract relationships
    {'foot', 'hand'};
    {'lamp', 'candle'};
    {'watch', 'clock'};
    {'mountain', 'hill'};
    {'cup', 'glass'};
    {'bread', 'cake'};
    
    % Group 4 - Advanced categories
    {'butterfly', 'moth'};
    {'violin', 'cello'};
    {'novel', 'poem'};
    {'painting', 'sculpture'};
    {'library', 'museum'};
    {'bicycle', 'skateboard'};
    {'lightning', 'fire'};
    {'wolf', 'fox'};      % Added new pair to replace dog/cat
};

similarities.relationships = {
    % Group 1
    'both are water vessels'; 
    'both are bodies of water';
    'both are furniture'; 
    'both are clothing';
    'both are medical professionals'; 
    'both are used in construction';
    
    % Group 2
    'both are musical instruments';
    'both are fruits';
    'both are vehicles';
    'both are communication devices';
    'both are eating utensils';
    'both are educators';
    
    % Group 3
    'both are body parts';
    'both provide light';
    'both tell time';
    'both are landforms';
    'both are drinking vessels';
    'both are baked goods';
    
    % Group 4
    'both are insects';
    'both are string instruments';
    'both are literary works';
    'both are art forms';
    'both are places that preserve knowledge';
    'both are human-powered transportation devices';
    'both are natural forms of energy release';
    'both are wild canines';  % New relationship for wolf/fox
};

% Generate multiple-choice options for the main question bank
similarities.options = cell(length(similarities.pairs), 1);
similarities.correctIndices = zeros(length(similarities.pairs), 1);

for i = 1:length(similarities.pairs)
    correct = similarities.relationships{i};
    
    % Create plausible but incorrect options based on item type
    % Note: The indices have changed since we removed the training examples
    if i == 1 % boat, ship
        incorrect = {'both float', 'both have motors', 'both transport people'};
    elseif i == 2 % river, lake
        incorrect = {'both contain fish', 'both have water', 'both are for recreation'};
    elseif i == 3 % chair, table
        incorrect = {'both have legs', 'both are made of wood', 'both are for eating'};
    elseif i == 4 % shirt, pants
        incorrect = {'both have fabric', 'both are worn daily', 'both protect from elements'};
    elseif i == 5 % doctor, nurse
        incorrect = {'both work in hospitals', 'both help patients', 'both wear uniforms'};
    elseif i == 6 % hammer, nail
        incorrect = {'both are made of metal', 'both are tools', 'both are hard'};
    elseif i == 7 % piano, guitar
        incorrect = {'both have strings', 'both make noise', 'both are played by hand'};
    elseif i == 8 % apple, orange
        incorrect = {'both are round', 'both grow on trees', 'both have seeds'};
    elseif i == 9 % car, bus
        incorrect = {'both have wheels', 'both have engines', 'both use fuel'};
    elseif i == 10 % telephone, computer
        incorrect = {'both use electricity', 'both have screens', 'both connect to internet'};
    elseif i == 11 % knife, fork
        incorrect = {'both are made of metal', 'both have handles', 'both are silverware'};
    elseif i == 12 % teacher, professor
        incorrect = {'both grade papers', 'both give lectures', 'both work with students'};
    elseif i == 13 % foot, hand
        incorrect = {'both have fingers/toes', 'both have nails', 'both are used for touching'};
    elseif i == 14 % lamp, candle
        incorrect = {'both get hot', 'both use electricity', 'both are household items'};
    elseif i == 15 % watch, clock
        incorrect = {'both have hands', 'both tick', 'both have numbers'};
    elseif i == 16 % mountain, hill
        incorrect = {'both have peaks', 'both are tall', 'both have slopes'};
    elseif i == 17 % cup, glass
        incorrect = {'both are breakable', 'both have handles', 'both hold hot liquids'};
    elseif i == 18 % bread, cake
        incorrect = {'both contain flour', 'both are sweet', 'both are desserts'};
    elseif i == 19 % butterfly, moth
        incorrect = {'both are colorful', 'both are attracted to light', 'both have antennae'};
    elseif i == 20 % violin, cello
        incorrect = {'both have four strings', 'both use bows', 'both are wooden'};
    elseif i == 21 % novel, poem
        incorrect = {'both use words', 'both have authors', 'both tell stories'};
    elseif i == 22 % painting, sculpture
        incorrect = {'both are created by artists', 'both are displayed in museums', 'both are expensive'};
    elseif i == 23 % library, museum
        incorrect = {'both have visitors', 'both are public buildings', 'both have collections'};
    elseif i == 24 % bicycle, skateboard
        incorrect = {'both have wheels', 'both are for recreation', 'both require balance'};
    elseif i == 25 % lightning, fire
        incorrect = {'both are dangerous', 'both produce light', 'both generate heat'};
    else % wolf, fox
        incorrect = {'both have tails', 'both are predators', 'both have fur'};
    end
    
    % Randomize order with correct answer
    options = [correct, incorrect];
    randomOrder = randperm(length(options));
    similarities.options{i} = options(randomOrder);
    
    % Keep track of correct answer index for scoring
    similarities.correctIndices(i) = find(strcmp(similarities.options{i}, correct));
end

% Now create separate options for the training examples
similarities.trainingOptions = cell(length(similarities.trainingPairs), 1);
similarities.trainingCorrectIndices = zeros(length(similarities.trainingPairs), 1);

for i = 1:length(similarities.trainingPairs)
    correct = similarities.trainingRelationships{i};
    
    % Create plausible but incorrect options for training examples
    if i == 1 % dog, cat
        incorrect = {'both have tails', 'both are pets', 'both have fur'};
    elseif i == 2 % pen, pencil
        incorrect = {'both leave marks', 'both have points', 'both are held in hand'};
    else % sun, moon
        incorrect = {'both appear in sky', 'both provide light', 'both are round'};
    end
    
    % Randomize order with correct answer
    options = [correct, incorrect];
    randomOrder = randperm(length(options));
    similarities.trainingOptions{i} = options(randomOrder);
    
    % Keep track of correct answer index for scoring
    similarities.trainingCorrectIndices(i) = find(strcmp(similarities.trainingOptions{i}, correct));
end

fprintf('Enhanced similarities data generated with %d pairs.\n', length(similarities.pairs));
end