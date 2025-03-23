function result = questionTracker(action, category, indices)
% QUESTIONTRACKER - Tracks which questions have been used across all phases
%
% This function uses a persistent variable to track which questions have
% been used to prevent overlap between pre-test, training, practice, and post-test.
%
% Inputs:
%   action - String: 'init', 'mark', 'check', 'clear', 'status'
%   category - String: 'similarities', 'vocabulary', 'information' (not needed for 'init', 'clear', 'status')
%   indices - Array of question indices (not needed for 'init', 'clear', 'status')
%
% Outputs:
%   result - For 'check': logical array indicating available questions
%            For other actions: boolean indicating success

% Use persistent variable to maintain state across function calls
persistent usedQuestions;

% Process based on action
switch lower(action)
    case 'init'
        % Initialize tracking structure
        usedQuestions = struct();
        usedQuestions.similarities = [];
        usedQuestions.vocabulary = [];
        usedQuestions.information = [];
        fprintf('Question tracking initialized.\n');
        result = true;
        
    case 'mark'
        % Mark questions as used
        if isempty(usedQuestions)
            questionTracker('init');
        end
        
        % Ensure category exists
        if ~isfield(usedQuestions, category)
            usedQuestions.(category) = [];
        end
        
        % Mark the indices as used
        usedQuestions.(category) = unique([usedQuestions.(category), indices(:)']);
        fprintf('Marked %d %s questions as used. Total used: %d\n', ...
            length(indices), category, length(usedQuestions.(category)));
        result = true;
        
    case 'check'
        % Check if questions are available (not used yet)
        if isempty(usedQuestions)
            questionTracker('init');
        end
        
        % Ensure category exists
        if ~isfield(usedQuestions, category)
            usedQuestions.(category) = [];
        end
        
        % For single index
        if isscalar(indices)
            result = ~any(usedQuestions.(category) == indices);
        else
            % For array of indices, create logical array where true means available
            result = true(size(indices));
            for i = 1:length(indices)
                if any(usedQuestions.(category) == indices(i))
                    result(i) = false;
                end
            end
        end
        
    case 'clear'
        % Reset tracking
        usedQuestions = [];
        fprintf('Question tracking cleared.\n');
        result = true;
        
    case 'status'
        % Show current tracking status
        if isempty(usedQuestions)
            fprintf('Question tracking not initialized.\n');
            result = false;
            return;
        end
        
        fprintf('=== Question Usage Status ===\n');
        
        if isfield(usedQuestions, 'similarities')
            fprintf('Similarities: %d questions used\n', length(usedQuestions.similarities));
        else
            fprintf('Similarities: 0 questions used\n');
        end
        
        if isfield(usedQuestions, 'vocabulary')
            fprintf('Vocabulary: %d questions used\n', length(usedQuestions.vocabulary));
        else
            fprintf('Vocabulary: 0 questions used\n');
        end
        
        if isfield(usedQuestions, 'information')
            fprintf('Information: %d questions used\n', length(usedQuestions.information));
        else
            fprintf('Information: 0 questions used\n');
        end
        
        result = true;
        
    otherwise
        error('Unknown action: %s', action);
end
end