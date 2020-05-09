%%
% This script measures speaking time for each character in Buffy the Vampire Slayer.
% By J. Freedland, 2020

season = 1; % Which season of Buffy the Vampire Slayer
episode = 1; % Which episode within season of Buffy the Vampire Slayer

% Find script and associated subtitles from BtVS episode
script = episodeScriptUtils.matchSubtitlesToScript(season,episode);

% Export as .csv (if desired)
% writecell(script,['S0',mat2str(season),'E',mat2str(episode),'_script.csv'])

%%
% We can combine voices to ensure quality audio timings
% THIS REQUIRES: Episode audio
%                MATLAB's AudioToolbox
[timing, audio] = audioTimingUtils.combineVoices(season,episode,script);
writecell(script,['S0',mat2str(season),'E',mat2str(episode),'_timing.csv'])

%%
% Test a single character's audio to ensure timings are decent
character = 'Giles';
obj = audioplayer(audio{strcmp(timing(:,1),character),1},48000);
play(obj)

% to stop playing audio: stop(obj)