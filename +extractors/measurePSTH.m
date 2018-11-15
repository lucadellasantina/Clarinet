function result = measurePSTH(epochGroup, device, settings)
%% Extracts Peri-Stimuls time histogram from the epochGroup

    if nargin == 0
        result.binWidth = 0.01;     % Bin width in seconds to estimate PSTH
        result.smoothingWindow = 0; % Guassian smoothing window for PSTH
        return
    end
    
	spikeTimes      = epochGroup.getFeatureData('SPIKETIMES');
	duration        = getUniqueDurationInSeconds(epochGroup);

	if numel(duration) > 1
	    error('cannot get psth for varying response duration. check preTime, stimTime and tailTime')
	end
	
	rate            = epochGroup.getParameter('sampleRate');
	preTime         = epochGroup.getParameter('preTime') * 1e-3; % in seconds
	n               = round(settings.binWidth * rate);
	durationSteps   = duration * rate;
	
	bins = 1 : n : durationSteps;
	spikeTimeSteps  = cell2mat(spikeTimes) + preTime * rate;
	count           = histc(spikeTimeSteps, bins);
	
	if settings.smoothingWindow
	    smoothingWindowSteps = round(rate * (settings.smoothingWindow / settings.binWidth));
	    w           = gausswin(smoothingWindowSteps);
	    w           = w / sum(w);
	    count       = conv(count, w, 'same');
	end

	freq = count / numel(spikeTimes) / settings.binWidth;
	x = bins/rate - preTime;
    
    epochGroup.createFeature('PSTH', freq, ...
        'xAxis', x, ...
        'xLabel', 'Time (s)', ...
        'yLabel', 'Firing rate (Hz)', ...
        'binWidth', settings.binWidth, ...
        'smoothingWindow', settings.smoothingWindow);
    
    result = epochGroup;
end

function duration = getUniqueDurationInSeconds(epochGroup)
    data = epochGroup.get('preTime') + epochGroup.get('stimTime') + epochGroup.get('tailTime');
    duration = unique(data) * 1e-3;
end
