function finalClip = finerPower(isolated_clip,Fs,cutoffVal)

    % Calculate energy of signal
    N = Fs/10;       % window length
    df = Fs/N;      % frequency increment
    y_squared = (isolated_clip/Fs).*conj(isolated_clip/Fs);  % Normalize the FFT amplitudes
    
    power = zeros(floor(length(isolated_clip)/N),1);
    for a = 1:size(power,1)
        r = (a-1) * N + 1 : a * N;
        power(a) = log(2*sum(y_squared(r))*df);
    end

    if ~isempty(power)
        cutoff = repelem(power < quantile(power,cutoffVal),ceil(length(isolated_clip)/length(power)));

        finalClip = isolated_clip;
        finalClip(cutoff(1:length(isolated_clip))) = 0;
    else
        finalClip = isolated_clip;
    end
end