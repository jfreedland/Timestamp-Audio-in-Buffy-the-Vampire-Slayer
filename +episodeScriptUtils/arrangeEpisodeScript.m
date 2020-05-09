function finalScript = arrangeEpisodeScript(episodeScript,season,episode)

    if size(episodeScript,1) == 1
        episodeScript = episodeScript.script;
    end

    if (season == 5 && strcmp(episode,'05')) || (season == 5 && strcmp(episode,'07')) || ...
            season == 7 % Caveat for season 7 scripts
        newEpisodeScript = cell(size(episodeScript));
        for a = 1:size(episodeScript,1)-1
            if sum(isstrprop(episodeScript{a,1},'upper')) / sum(isstrprop(episodeScript{a,1},'alpha')) == 1
                newEpisodeScript{a,1} = strcat(episodeScript{a,1},': ',episodeScript{a+1,1});
            else
                newEpisodeScript{a,1} = [];
            end
        end
        episodeScript = newEpisodeScript(~cellfun('isempty',newEpisodeScript(:,1)),:);
    end
    
    if season == 3 && strcmp(episode,'18')
        newEpisodeScript = cell(size(episodeScript));
        for a = 1:size(episodeScript,1)
            A = episodeScript{a,1};
            A = A{1,1};
            
            if length(A) > 2
                if sum(isstrprop(A(1:2),'upper')) == 2
                    r = find(~isstrprop(A,'alpha'),1);
                    newEpisodeScript{a,1} = [A(1:r-1),':',A(r+1:end)];
                end
            end
        end
        episodeScript = newEpisodeScript(~cellfun('isempty',newEpisodeScript(:,1)),:);
    end
    
    % Warning: S03E22 script is a particularly unusual script and difficult to format--ignore this code.
    if (season == 3 && strcmp(episode,'22')) || (season == 4 && strcmp(episode,'04')) ||...
            (season == 4 && strcmp(episode,'11')) || (season == 4 && strcmp(episode,'17'))
        newEpisodeScript = cell(size(episodeScript,1)*2,1);
        counter = 1;
        for a = 1:size(episodeScript,1)
            A = episodeScript{a,1};
            A = A{1,1};
            B = [strfind(A,':'),length(A)];
            B2 = [strfind(A,' '),length(A)];
            r = find(isstrprop(A,'upper'));
            
            if ~isempty(B)
                for b = 1:length(B)-1
                    
                    % Find first capital letter before ":"
                    val = find((B(b)-r)>0, 1, 'last' );
                    val = r(val);
                    
                    % Find first space after capital letter defines name
                    valAlt = find((B2-val)>0, 1);
                    name = A(val:B2(valAlt));
                    name(strfind(name,':')) = [];
                    
                    if (season == 3 && strcmp(episode,'22'))
                    
                        r2 = strfind(A,'"');
                        if ~isempty(r2)
                            val2 = find((B(b)-r2)<0); % Find first quotation

                            if length(val2) > 1
                                line = A(r2(val2(1)):r2(val2(2)));
                                newEpisodeScript{counter,1} = [name,':',line];
                                counter = counter+1;
                            end
                        end
                        
                    else
                        line = A(min(B)+1:max(B));
                        newEpisodeScript{counter,1} = [name,':',line];
                        counter = counter+1;
                    end
                end
            end
        end
        episodeScript = newEpisodeScript(~cellfun('isempty',newEpisodeScript(:,1)),:);
    end

    finalScript = cell(size(episodeScript,1),2);
    for a = 1:size(episodeScript,1)
        A = strfind(episodeScript{a,1},':');

        if ~isempty(A)
            line = char(episodeScript{a,1});
            finalScript{a,1} = line(1:A-1);
            finalScript{a,2} = line(A+1:end);
        end
    end
    finalScript = finalScript(~cellfun('isempty',finalScript(:,1)),:);

    for a = 1:size(finalScript,1)
        A = finalScript{a,2};
        if contains(A,'(')
            A(strfind(A,'('):strfind(A,')')) = [];
        end
        if contains(A,'[')
            A(strfind(A,'['):strfind(A,']')) = [];
        end
        
        A = A(find(isstrprop(A,'alpha'),1):end);
        finalScript{a,2} = A;
    end
        
end