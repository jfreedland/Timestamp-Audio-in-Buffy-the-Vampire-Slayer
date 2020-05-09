function export = findSpeaker(subtitle,episode,iterations)

    disp('Identifying characters within episode subtitles...')
    % Match each subtitle to a line in the script
    characterNumber = zeros(size(subtitle,1),1);

    % First pass: find very definite speakers
    for a = 1:size(subtitle,1)
        A = lower(subtitle{a,3});
        A = A(isstrprop(A,'alpha')); % only letters

        distance = zeros(size(episode,1),1);
        for b = 1:size(episode,1)
            B = lower(episode{b,2});
            B = B(isstrprop(B,'alpha')); % only letters

            distance(b) = episodeScriptUtils.EditDist(A,B) / length(B); % Compare lines
        end

        [s,i] = sort(distance); % Closest character 

        if length(s) == 1
            s = [s 1e5];
        end

        if s(2) - s(1) > 0.5 && length(A) > 8 % 50% confidence with long phrase unique phrases
            characterNumber(a) = i(1);
        else
            characterNumber(a) = NaN;
        end
    end

    % Regions where sequential character lines were found
    r = find(~isnan(characterNumber));

    % Perform more refined selection
    % Second-to-last repeat performs special search
    % Last repeat makes best guess
    for pp = 1:iterations
        for a = 1:length(characterNumber)
            if isnan(characterNumber(a))

                % Search over tighter range
                t = (r - a);
                r1 = characterNumber(a+max(t(t < 0)));
                r2 = characterNumber(a+min(t(t > 0)));
                regime = r1:r2;

                if ~isempty(regime)
                    A = lower(subtitle{a,3});
                    A = A(isstrprop(A,'alpha')); % only letters

                    % Repeat for closer range
                    distance = zeros(length(regime),1);
                    for b = 1:length(regime)
                        B = lower(episode{regime(b),2});
                        B = B(isstrprop(B,'alpha')); % only letters

                        distance(b) = episodeScriptUtils.EditDist(A,B) / length(B); % Compare lines
                    end

                    [s,i] = sort(distance); % Closest character 

                    if pp == iterations-1 % On second to last repeat
                        
                        % Check whether a line is hidden in another line.
                        % i.e. "I'm not sure. Where do we go?" and "Where do we go?"
                        % This is not typically caught by EditDist
                        s = zeros(length(regime),2);
                        for b = 1:length(regime)
                            B = lower(episode{regime(b),2});
                            B = B(isstrprop(B,'alpha')); % only letters

                            s(b,1) = contains(B,A,'IgnoreCase',true);
                            s(b,2) = contains(A,B,'IgnoreCase',true);
                        end
                        s = sum(s,2);

                        if sum(s > 0) > 0 % Found nearby line containing line
                            [s,i] = sort(s,'descend');
                        else
                            i(1) = NaN;
                        end

                    end

                    if length(s) == 1 || pp == iterations-1
                        characterNumber(a) = i(1)+r1-1;
                    elseif pp == iterations % Perform best guess
                        characterNumber(a) = i(1)+r1-1;
                    elseif s(2) - s(1) > (0.5 - (pp * 0.25/iterations)) % Slowly allow more error as tree restricts
                        characterNumber(a) = i(1)+r1-1;
                    else
                        characterNumber(a) = NaN;
                    end
                end
            end
        end
        r = find(~isnan(characterNumber));
    end

    characterName = cell(size(characterNumber,1),1);
    for a = 1:size(characterName,1)
        if ~isnan(characterNumber(a))
            characterName{a,1} = episode{characterNumber(a),1};
        end
    end
    
    export = [subtitle(:,1:2),characterName,subtitle(:,3)];
end