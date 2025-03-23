function tasks = loadTaskData(useDynamic)
% LOADTASKDATA Loads task data with enhanced content when available
%
% This function loads task data for the verbal comprehension training module.
% It can load either static dataset or enhanced datasets with more questions.
%
% Inputs:
%   useDynamic - (optional) Boolean, if true uses enhanced generators
%
% Returns:
%   tasks - Structure containing organized task data for all subtests

% Default to static loading if not specified
if nargin < 1
    useDynamic = false;
end

% Add path to data generators
addpath('data');

try
    % Try to use enhanced generators if available and useDynamic is true
    if useDynamic
        fprintf('Loading enhanced task data...\n');
        
        % Try loading enhanced similarities data
        if exist('enhancedGenerateSimilaritiesData.m', 'file')
            fprintf('Using enhanced similarities generator...\n');
            similarities = enhancedGenerateSimilaritiesData();
            fprintf('Loaded enhanced similarities data: %d items\n', length(similarities.pairs));
        else
            fprintf('Enhanced similarities generator not found, using standard...\n');
            similarities = generateSimilaritiesData();
        end
        
        % Try loading enhanced vocabulary data
        if exist('enhancedGenerateVocabularyData.m', 'file')
            fprintf('Using enhanced vocabulary generator...\n');
            vocabulary = enhancedGenerateVocabularyData();
            fprintf('Loaded enhanced vocabulary data: %d items\n', length(vocabulary.words));
        else
            fprintf('Enhanced vocabulary generator not found, using standard...\n');
            vocabulary = generateVocabularyData();
        end
        
        % Try loading enhanced information data
        if exist('enhancedGenerateInformationData.m', 'file')
            fprintf('Using enhanced information generator...\n');
            information = enhancedGenerateInformationData();
            fprintf('Loaded enhanced information data: %d items\n', length(information.questions));
        else
            fprintf('Enhanced information generator not found, using standard...\n');
            information = generateInformationData();
        end
    else
        % Load standard data generators
        fprintf('Loading standard task data...\n');
        similarities = generateSimilaritiesData();
        vocabulary = generateVocabularyData();
        information = generateInformationData();
    end
    
    % Format similarities data into consistent task structure
    tasks.similarities = [];
    for i = 1:length(similarities.pairs)
        task = struct();
        task.word1 = similarities.pairs{i}{1};
        task.word2 = similarities.pairs{i}{2};
        task.options = similarities.options{i};
        task.correctAnswer = similarities.correctIndices(i);
        tasks.similarities = [tasks.similarities; task];
    end
    
    % Format vocabulary data into consistent task structure
    tasks.vocabulary = [];
    for i = 1:length(vocabulary.words)
        task = struct();
        task.word = vocabulary.words{i};
        task.options = vocabulary.options{i};
        task.correctAnswer = vocabulary.correctIndices(i);
        tasks.vocabulary = [tasks.vocabulary; task];
    end
    
    % Format information data into consistent task structure
    tasks.information = [];
    for i = 1:length(information.questions)
        task = struct();
        task.question = information.questions{i};
        task.options = information.options{i};
        task.correctAnswer = information.correctIndices(i);
        tasks.information = [tasks.information; task];
    end
    
    fprintf('Successfully loaded all task data.\n');
    fprintf('Similarities: %d items\n', length(tasks.similarities));
    fprintf('Vocabulary: %d items\n', length(tasks.vocabulary));
    fprintf('Information: %d items\n', length(tasks.information));
    
catch err
    % When error occurs in loading data, log and rethrow
    fprintf('Error loading task data: %s\n', err.message);
    rethrow(err);
end
end