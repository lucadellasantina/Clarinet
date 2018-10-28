function result = detectSpikesSimple(epoch, settings)
%% Simple spike detection (Greg Schwartz)

% For more info, refer to https://github.com/SchwartzNU/SymphonyAnalysis/blob/master/GUIs/SpikeDetectorGUI.m

if isempty(epoch) && isempty(settings)
    result.mode = 'Advanced';   % Type of spike detection, Example- 'Simple threshold' (or) 'Advanced'
    result.threshold = -10;     % Threshold value to detect spikes
    result.device = 'Amp1';     % List of amplifier channels to process, default: "@(epoch, devices) sa_labs.analysis.common.getdeviceForEpoch(epoch, devices)"
    return                      % Return default settings as a structure
end

thresholdSign =  sign(settings.threshold);
threshold = settings.threshold;
mode = settings.mode;
structure = load(which('spikeFilter.mat'));
spikeFilter = structure.spikeFilter;

sampleRate = epoch.get('sampleRate');
data = epoch.getResponse(device);
response = data.quantity';

spikeIndices = getThresCross(response, threshold, thresholdSign);

if strcmpi(mode, 'Simple threshold')
    spikeIndices = getThresCross(response, threshold, thresholdSign);
elseif strcmpi(mode, 'Advanced')
    [fresponse, noise] = filterResponse(response, spikeFilter);
    spikeIndices = getThresCross(fresponse, noise * threshold, thresholdSign);
    epochData.addDerivedResponseInMemory('filteredResponse', fresponse, device);
end

if threshold < 0
    spikeIndices = getSpikeIndicesForNegativeThresold(spikeIndices, response);
else
    spikeIndices = getSpikeIndicesForPositiveThresold(spikeIndices, response);
end

% Remove double-counted spikes
if length(spikeIndices) >= 2
    ISItest = diff(spikeIndices);
    spikeIndices = spikeIndices([(ISItest > (0.001 * sampleRate)) true]);
end
epoch.addDerivedResponse('spikeTimes', spikeIndices, device);

result = epoch;
end

function Ind = getThresCross(V,th,dir)
%dir 1 = up, -1 = down

Vorig = V(1:end-1);
Vshift = V(2:end);

if dir>0
    Ind = find(Vorig<th & Vshift>=th) + 1;
else
    Ind = find(Vorig>=th & Vshift<th) + 1;
end
end

function [fdata, noise] = filterResponse(fdata, spikeFilter)

fdata = [fdata(1) + zeros(1,2000), fdata, fdata(end) + zeros(1,2000)];
fdata = filtfilt(spikeFilter, fdata);
fdata = fdata(2001:(end-2000));
noise = median(abs(fdata) / 0.6745);

end

function spikeIndices = getSpikeIndicesForNegativeThresold(spikeIndices, response)
for spikeIndex = 1 : length(spikeIndices)
    sp = spikeIndices(spikeIndex);
    if sp < 100 || sp > length(response) - 100
        continue
    end
    while response(sp) > response(sp + 1)
        sp = sp + 1;
    end
    while response(sp) > response(sp - 1)
        sp = sp - 1;
    end
    spikeIndices(spikeIndex) = sp;
end
end

function spikeIndices = getSpikeIndicesForPositiveThresold(spikeIndices, response)
for spikeIndex = 1 : length(spikeIndices)
    sp = spikeIndices(spikeIndex);
    if sp < 100 || sp > length(response) - 100
        continue
    end
    while response(sp) < response(sp + 1)
        sp = sp + 1;
    end
    while response(sp) < response(sp - 1)
        sp = sp - 1;
    end
    spikeIndices(spikeIndex) = sp;
end
end