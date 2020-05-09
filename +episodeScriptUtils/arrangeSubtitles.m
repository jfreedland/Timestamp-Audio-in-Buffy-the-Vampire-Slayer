function finalSubtitle = arrangeSubtitles(episodeSubtitle)

    % Arrange subtitles
    episodeSubtitle = [episodeSubtitle{1};{'end'};{'1'};{'1'};{'1'};{'1'};{'1'}]; % Append
    finalSubtitle = cell(size(episodeSubtitle,1)*2,3);
    counter = 1;

    for a = 1:size(episodeSubtitle,1)
        A = strfind(episodeSubtitle{a,1},'-->');

        if ~isempty(A)

            % Time is in HH:MM:SS, we instead convert to seconds
            % (universal format)
            [ms, ~,~,~,minut,sec] = datevec(episodeSubtitle{a,1}(1:A-2));
            finalSubtitle{counter,1} = round(minut * 60 + sec + ms/1000,2);

            [ms, ~,~,~,minut,sec] = datevec(episodeSubtitle{a,1}(A+4:end));
            finalSubtitle{counter,2} = round(minut * 60 + sec + ms/1000,2);

            % Look for double subtitles (two characters)
            A = find(~isnan(str2double(episodeSubtitle(a+1:a+5))),1);
            for b = 1:A-1
                finalSubtitle{counter,3} = episodeSubtitle{a+b,1};
                counter = counter + 1;
            end
        end
    end
    finalSubtitle = finalSubtitle(~cellfun('isempty',finalSubtitle(:,3)),:);

    for a = 1:size(finalSubtitle,1)
        A = finalSubtitle{a,3};
        
        % Remove extraneous symbols
        A(strfind(A,'-')) = [];
        if contains(A,'(')
            A(strfind(A,'('):strfind(A,')')) = [];
        end
        if contains(A,'[')
            A(strfind(A,'['):strfind(A,']')) = [];
        end
        
        % Force only first letter to be uppercase (universal format).
        A = A(find(isstrprop(A,'alpha'),1):end);
        finalSubtitle{a,3} = A;
    end
end