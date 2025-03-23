function vocabulary = enhancedGenerateVocabularyData()
% ENHANCEDGENERATEVOCABULARYDATA Creates an expanded set of vocabulary questions
%
% This function generates a larger bank of vocabulary words with their
% definitions for the Vocabulary task to ensure minimal repetition across test phases.
%
% Returns:
%   vocabulary - Structure with words, definitions, options, and correctIndices

% Initialize structure
vocabulary = struct();

% Expanded word bank with definitions (paired for easier processing)
wordBank = {
    'benevolent', 'showing kindness and goodwill';
    'arduous', 'requiring great effort; difficult and tiring';
    'frugal', 'being economical with money or food';
    'ubiquitous', 'present, appearing, or found everywhere';
    'resilient', 'able to recover quickly from difficulties';
    'ambiguous', 'open to more than one interpretation';
    'meticulous', 'showing great attention to detail';
    'pragmatic', 'dealing with things sensibly and realistically';
    'eloquent', 'fluent or persuasive in speaking or writing';
    'vigilant', 'keeping careful watch for possible danger';
    'tenacious', 'tending to keep a firm hold of something; persistent';
    'audacious', 'showing a willingness to take bold risks';
    'verbose', 'using or containing more words than needed';
    'diligent', 'having or showing care and conscientiousness';
    'astute', 'having or showing an ability to accurately assess situations';
    'prudent', 'acting with or showing care and thought for the future';
    'intrepid', 'fearless; adventurous';
    'convoluted', 'extremely complex and difficult to follow';
    'exuberant', 'filled with or characterized by joy and vitality';
    'nonchalant', 'feeling or appearing casually calm and relaxed';
    'surreptitious', 'kept secret, especially because it would not be approved';
    'perilous', 'full of danger or risk';
    'ostentatious', 'characterized by showy display; designed to impress';
    'garrulous', 'excessively talkative, especially about trivial matters';
    'fortuitous', 'happening by chance rather than intention';
    'ephemeral', 'lasting for a very short time';
    'panacea', 'a solution or remedy for all difficulties';
    'quintessential', 'representing the most perfect example of a quality'
};

% Separate words and definitions
numWords = size(wordBank, 1);
vocabulary.words = cell(numWords, 1);
vocabulary.definitions = cell(numWords, 1);

for i = 1:numWords
    vocabulary.words{i} = wordBank{i, 1};
    vocabulary.definitions{i} = wordBank{i, 2};
end

% Initialize arrays for options and correct indices
vocabulary.options = cell(numWords, 1);
vocabulary.correctIndices = zeros(numWords, 1);

% Generate multiple-choice options for each word
for i = 1:numWords
    correct = vocabulary.definitions{i};
    
    % Create incorrect but plausible options (other definitions as wrong answers)
    otherIndices = setdiff(1:numWords, i);
    wrongIndices = otherIndices(randperm(length(otherIndices), 3));
    
    % Get the wrong definitions
    incorrect = {vocabulary.definitions{wrongIndices(1)}, ...
                vocabulary.definitions{wrongIndices(2)}, ...
                vocabulary.definitions{wrongIndices(3)}};
    
    % Randomize the order of options (correct + incorrect)
    options = [correct, incorrect];
    randomOrder = randperm(length(options));
    vocabulary.options{i} = options(randomOrder);
    
    % Record which option is correct (for scoring)
    vocabulary.correctIndices(i) = find(strcmp(vocabulary.options{i}, correct));
end

fprintf('Enhanced vocabulary data generated with %d words.\n', numWords);
end