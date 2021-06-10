function output = wordPreferences(script)

    % Remove lines not attributed to a single character
    S = script(~cellfun('isempty',script(:,3)),:);

    % Identify key characters
    [characters,~,index] = unique(S(:,3));

    output = cell(length(characters),2);
    for i = 1:length(characters)
        % Identify all lines spoken by character in an episode
        lines = S(index == i,:);

        % Combine lines into one cell
        combinedLines = [];
        for j = 1:size(lines,1)
            combinedLines = strcat(combinedLines,lines{j,4});
        end
        
        % Remove punctuation
        combinedLines = replace(combinedLines,"."," ");
        combinedLines = replace(combinedLines,"!"," ");
        combinedLines = replace(combinedLines,","," ");
        combinedLines = replace(combinedLines,"?"," ");

        output{i,1} = lower(characters{i});
        output{i,2} = lower(combinedLines);
    end

end

