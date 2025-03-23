function similarities = generateSimilaritiesData()
    % Initialize structure
    similarities = struct();
    
    % Manually defined word pairs with relationships (fallback)
    similarities.pairs = {
        {'dog', 'cat'}; 
        {'boat', 'ship'}; 
        {'river', 'lake'};
        {'pen', 'pencil'}; 
        {'chair', 'table'}; 
        {'shirt', 'pants'};
        {'sun', 'moon'}; 
        {'doctor', 'nurse'}; 
        {'hammer', 'nail'}
    };
    
    similarities.relationships = {
        'both are animals'; 
        'both are water vessels'; 
        'both are bodies of water';
        'both are writing instruments'; 
        'both are furniture'; 
        'both are clothing';
        'both are celestial bodies'; 
        'both are medical professionals'; 
        'both are used in construction'
    };
    
    % Generate multiple-choice options
    similarities.options = cell(length(similarities.pairs), 1);
    similarities.correctIndices = zeros(length(similarities.pairs), 1);
    
    for i = 1:length(similarities.pairs)
        correct = similarities.relationships{i};
        
        % Create plausible but incorrect options
        if i == 1 % dog, cat
            incorrect = {'both have tails', 'both are pets', 'both have fur'};
        elseif i == 2 % boat, ship
            incorrect = {'both float', 'both have motors', 'both transport people'};
        elseif i == 3 % river, lake
            incorrect = {'both contain fish', 'both have water', 'both are for recreation'};
        elseif i == 4 % pen, pencil
            incorrect = {'both leave marks', 'both have points', 'both are held in hand'};
        elseif i == 5 % chair, table
            incorrect = {'both have legs', 'both are made of wood', 'both are for eating'};
        elseif i == 6 % shirt, pants
            incorrect = {'both have fabric', 'both are worn daily', 'both protect from elements'};
        elseif i == 7 % sun, moon
            incorrect = {'both appear in sky', 'both provide light', 'both are round'};
        elseif i == 8 % doctor, nurse
            incorrect = {'both work in hospitals', 'both help patients', 'both wear uniforms'};
        else % hammer, nail
            incorrect = {'both are made of metal', 'both are tools', 'both are hard'};
        end
        
        % Randomize order with correct answer
        options = [correct, incorrect];
        randomOrder = randperm(length(options));
        similarities.options{i} = options(randomOrder);
        
        % Keep track of correct answer index for scoring
        similarities.correctIndices(i) = find(strcmp(similarities.options{i}, correct));
    end
end