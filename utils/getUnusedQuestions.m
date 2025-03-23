function selectedIndices = getUnusedQuestions(category, numNeeded)
% GETUNUSEDQUESTIONS - Selects unused questions for a test phase
%
% This function selects a specified number of unused questions from a category
% using the questionTracker to avoid repetition across test phases
%
% Inputs:
%   category - String: 'similarities', 'vocabulary', 'information'
%   numNeeded - Number of questions needed for the current phase
%
% Outputs:
%   selectedIndices - Array of indices for questions to use

    % Get total number of questions available for the category
    switch category
        case 'similarities'
            totalQuestions = 26;  % Updated count from enhancedGenerateSimilaritiesData.m
        case 'vocabulary'
            totalQuestions = 28;  % From enhancedGenerateVocabularyData.m
        case 'information'
            totalQuestions = 25;  % From enhancedGenerateInformationData.m
        otherwise
            error('Unknown category: %s', category);
    end
    
    % Create array of all possible indices
    allIndices = 1:totalQuestions;
    
    % Initialize question tracker if not already initialized
    if ~exist('questionTracker', 'file')
        error('Question tracker function not found.');
    end
    
    % Check which questions are still available
    availabilityStatus = questionTracker('check', category, allIndices);
    
    % Filter to get only unused questions
    availableIndices = allIndices(availabilityStatus);
    
    % If not enough available questions, show warning
    if length(availableIndices) < numNeeded
        warning('Not enough unused %s questions. Need %d but only %d available.', ...
                category, numNeeded, length(availableIndices));
        % Use whatever is available
        selectedIndices = availableIndices;
    else
        % Randomly select required number of questions
        randOrder = randperm(length(availableIndices));
        selectedIndices = availableIndices(randOrder(1:numNeeded));
    end
    
    % Log the selected indices
    fprintf('Selected %d %s questions: %s\n', length(selectedIndices), category, ...
        mat2str(selectedIndices));
end