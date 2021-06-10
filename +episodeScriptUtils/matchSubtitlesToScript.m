function finalSubtitle = matchSubtitlesToScript(season,episode)
    
    % Assign directory
    directory = '';
    
    % Convert episode # into filename
    if episode < 10
        episode = ['0',mat2str(episode)];
    else
        episode = mat2str(episode);
    end
    
    % Load subtitle
    D = dir([directory,'Subtitles/']);
    for a = 1:size(D,1)
        if contains(D(a).name,strcat('S0',mat2str(season),'E',episode))
            episodeSubtitle = textscan(fopen([directory,'Subtitles/',D(a).name]),...
                '%s','Delimiter','\b');
            disp(['Subtitle File: ',D(a).name]) % Confirm file found
        end
    end
    
    % Load script
    D = dir([directory,'Episode Scripts/']);
    for a = 1:size(D,1)
        if contains(D(a).name,[mat2str(season),'x',episode])
            episodeScript = load([directory,'Episode Scripts/',D(a).name]);
            disp(['Transcript File: ',D(a).name]) % Confirm file found
        end
    end

    % Arrange into similar formats
    episodeSubtitle = episodeScriptUtils.arrangeSubtitles(episodeSubtitle);
    episodeScript = episodeScriptUtils.arrangeEpisodeScript(episodeScript,season,episode);
    
    % Identify speaker in subtitle using episode script (>97% accuracy)
    iterations = 50; % Number of times to repeat search
    tic
    formattedSubtitle = episodeScriptUtils.findSpeaker(episodeSubtitle,episodeScript,iterations);
    toc
    
    % Estimate timepoints in subtitles with multiple simultaneous speakers
    finalSubtitle = episodeScriptUtils.estimateTimepoints(formattedSubtitle);
    disp('Complete.')
end