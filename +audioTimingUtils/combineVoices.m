function [characterTimings,aud] = combineVoices(season,episode,export)

    % Assign directory
    directory = '/Users/Julian/Desktop/Buffy Audio Package/';
    
    % Convert episode # into filename
    if episode < 10
        episode = ['0',mat2str(episode)];
    else
        episode = mat2str(episode);
    end

    % Load subtitle
    D = dir([directory,'Episode Audio/']);
    for a = 1:size(D,1)
        if contains(D(a).name,strcat('S0',mat2str(season),'E',episode))
            [audio,fs] = audioread([directory,'Episode Audio/',D(a).name]);
            disp(['Audio File: ',D(a).name]) % Confirm file found
            audio = audio(:,1); % Single channel
        end
    end

    % Find all unique characters
    A = audioTimingUtils.uniquecell(export(:,3));

    characterTimings = cell(size(A,1),2);
    aud = cell(size(A,1),1);
    for a = 1:size(A,1)
        characterAudio = zeros(length(audio),1);
        for b = 1:size(export,1)
            if isequal(export{b,3},A{a,1}) % Each unique character

                s = export{b,1} * fs; % Audio sampling
                l = export{b,2} * fs;
                l(l > length(audio)) = length(audio);
                
                unfiltered = audio(round(s:l));

                if length(unfiltered) > fs*0.03 % Must be greater than window
                    idx = detectSpeech(unfiltered,fs); % Remove non-speech (requires MATLAB's Audio Toolbox)
                    if size(idx,1) > 1
                        for j = 1:size(idx,1)-1
                            unfiltered(idx(j,2):idx(j+1,1)) = 0;
                        end
                        unfiltered(idx(end,2):end) = 0;
                    end
                end
                filtered = audioTimingUtils.finerPower(unfiltered,fs,0.3); % Remove low-power

                if ~isempty(filtered)
                    characterAudio(round(s:l)) = filtered;
                end
            end
        end
        characterAudio(characterAudio == 0) = [];

        % Repeat speech detection
        if length(characterAudio) > fs*0.03
            idx = detectSpeech(characterAudio,fs);
            if size(idx,1) > 1
                for b = 1:size(idx,1)-1
                    characterAudio(idx(b,2):idx(b+1,1)) = 0;
                end
                characterAudio(idx(end,2):end) = 0;
            end
            characterAudio(characterAudio == 0) = [];
        end
        
        if ~isempty(characterAudio)
            cAudio = audioTimingUtils.finerPower(characterAudio,fs,0.1);
            cAudio(cAudio == 0) = [];
        else
            cAudio = 0;
        end

        disp([A{a,1},': ',num2str(round(length(cAudio)/fs),2),' seconds'])

        characterTimings{a,1} = A{a,1};
        characterTimings{a,2} = length(cAudio)/fs;
        aud{a,1} = cAudio;
    end
    disp('Timings complete.')
end