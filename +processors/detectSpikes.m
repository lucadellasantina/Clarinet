function result = detectSpikes(epoch, settings)
%% Detect times at which spike occurr in the epoch

if isempty(epoch) && isempty(settings)
    result.refractoryPeriod = 1.5E-3;   % Refactory period in seconds
    result.searchWindow = 1E-3;         % Search window for spikes in seconds
    result.device = '';                 % Device on which perform the filter (i.e. amplifier channel)
    return                              % Return default settings as a structure
end

response = epoch.getResponse(settings.device);

[spikeTimes, spikeAmplitudes, statistics] = detectSpikesMHT(response.quantity,...
    'sampleRate', epoch.get('sampleRate'),...
    'refractoryPeriod', settings.refractoryPeriod,...
    'searchWindow', settings.searchWindow);

fdata = zeros(size(response.quantity));
fdata(spikeTimes) = 1;
response.quantity = fdata;

epoch.addDerivedResponse('filteredResponse', response, settings.device);
%epoch.addDerivedResponse('spikeTimes', spikeTimes, settings.device);
%epoch.addDerivedResponse('spikeAmplitudes', spikeAmplitudes, settings.device);
%epoch.addDerivedResponseInMemory('spikeStatistics', statistics, settings.device);

result = epoch;
end

function [spikeTimes, spikeAmplitudes, statistics] = detectSpikesMHT(dataMatrix, varargin)
%% SpikeDetector detects spikes in an extracellular / cell attached recording
%   [SpikeTimes, SpikeAmplitudes, RefractoryViolations] = SpikeDetector(dataMatrix,varargin)
%
%   RETURNS
%       spikeTimes: In datapoints. Cell array. Or array if just one trial;
%       spikeAmplitudes: Cell array.
%       refractoryViolations: Indices of SpikeTimes that had refractory
%           violations. Cell array.
%
%   REQUIRED INPUTS
%       dataMatrix: Each row is a trial
%   OPTIONAL ARGUMENTS
%       checkDetection: (false) (logical) Plots clustering information for
%           each trace
%       sampleRate: (1e4) (Hz)
%       refractoryPeriod: (1.5e-3) (sec)
%       searchWindow; (1.2e-3) (sec) To look for rebounds. Search interval
%           is (peak time +/- SearchWindow/2)
%
%   Clusters peak waveforms into 2 clusters using k-means. Based on three
%   quantities about each spike waveform: amplitude of the peak, amlitude
%   of a rebound on the right and left.
%   MHT 9.23.2016 - Ported over from personal version

ip = inputParser;
ip.addRequired('dataMatrix', @ismatrix);
addParameter(ip,'checkDetection', false, @islogical);
addParameter(ip,'sampleRate', 1e4, @isnumeric);
addParameter(ip,'refractoryPeriod', 1.5E-3, @isnumeric);
addParameter(ip,'searchWindow', 1.2E-3, @isnumeric);

ip.parse(dataMatrix, varargin{:});

dataMatrix = ip.Results.dataMatrix;
checkDetection = ip.Results.checkDetection;
sampleRate = ip.Results.sampleRate;
refractoryPeriod = ip.Results.refractoryPeriod * sampleRate; % datapoints
searchWindow = ip.Results.searchWindow * sampleRate; % datapoints

cutoffFrequency = 500; %Hz

dataMatrix = highPassFilter(dataMatrix, cutoffFrequency, 1/sampleRate);

nTraces = size(dataMatrix, 1);
spikeTimes = cell(nTraces, 1);
spikeAmplitudes = cell(nTraces, 1);
refractoryViolations = cell(nTraces, 1);

for tt = 1 : nTraces
    statistics(tt) = struct();
    
    currentTrace = dataMatrix(tt, :);
    if abs(max(currentTrace)) > abs(min(currentTrace)) % flip it over, big peaks down
        currentTrace = -currentTrace;
    end
    
    % get peaks
    [peakAmplitudes, peakTimes] = getPeaks(currentTrace, -1); % -1 for negative peaks
    peakTimes = peakTimes(peakAmplitudes < 0); % only negative deflections
    peakAmplitudes = abs(peakAmplitudes(peakAmplitudes < 0)); % only negative deflections
    
    % get rebounds on either side of each peak
    rebound = getRebounds(peakTimes, currentTrace, searchWindow);
    
    % cluster spikes
    clusteringData = [peakAmplitudes', rebound.Left', rebound.Right'];
    startMatrix = [median(peakAmplitudes) median(rebound.Left) median(rebound.Right);...
        max(peakAmplitudes) max(rebound.Left) max(rebound.Right)];
    clusteringOptions = statset('MaxIter', 10000);
    
    try %traces with no spikes sometimes throw an "empty cluster" error in kmeans
        [clusterIndex, centroidAmplitudes] = kmeans(clusteringData, 2,...
            'start',startMatrix,'Options',clusteringOptions);
    catch err
        if strcmp(err.identifier,'stats:kmeans:EmptyCluster')
            %initialize clusters using random sampling instead
            [clusterIndex, centroidAmplitudes] = kmeans(clusteringData, 2,...
                'start', 'sample', 'Options', clusteringOptions);
        end
    end
    
    [~, spikeClusterIndex] = max(centroidAmplitudes(:, 1)); %find cluster with largest peak amplitude
    nonspikeClusterIndex = setdiff([1 2], spikeClusterIndex); %nonspike cluster index
    spikeIndex_logical = (clusterIndex == spikeClusterIndex); %spike_ind_log is logical, length of peaks
    
    % get spike times and amplitudes
    spikeTimes{tt} = peakTimes(spikeIndex_logical);
    spikeAmplitudes{tt} = peakAmplitudes(spikeIndex_logical);
    nonspikeAmplitudes = peakAmplitudes(~spikeIndex_logical);
    
    %check for no spikes trace
    %how many st-devs greater is spike peak than noise peak?
    sigF = (mean(spikeAmplitudes{tt}) - mean(nonspikeAmplitudes)) / std(nonspikeAmplitudes);
    
    if sigF < 5 %no spikes
        spikeTimes{tt} = [];
        spikeAmplitudes{tt} = [];
        refractoryViolations{tt} = [];
        warning(['Trial '  num2str(tt) ': no spikes!']);
        continue
    end
    
    % check for refractory violations
    refractoryViolations{tt} = find(diff(spikeTimes{tt}) < refractoryPeriod) + 1;
    ref_violations = length(refractoryViolations{tt});
    if ref_violations > 0
        warning(['Trial '  num2str(tt) ': ' num2str(ref_violations) ' refractory violations']);
    end
    
    
    statistics(tt).refractoryViolations = refractoryViolations{tt};
    statistics(tt).spikeClusterIndex = spikeClusterIndex;
    statistics(tt).clusterIndex = clusterIndex;
    statistics(tt).nonspikeClusterIndex = nonspikeClusterIndex;
    statistics(tt).rebound = rebound;
    statistics(tt).sigF = sigF;
    statistics(tt).peakAmplitudes = peakAmplitudes;
end

if length(spikeTimes) == 1 %return vector not cell array if only 1 trial
    spikeTimes = spikeTimes{1};
    spikeAmplitudes = spikeAmplitudes{1};
end

end

function r = getRebounds(peaks_ind,trace,searchInterval)
%Mod MHT 1/28/15 - gets "rebounds" +/- searchInterval/2 of peaktime

peaks = trace(peaks_ind);
r.Left = zeros(size(peaks));
r.Right = zeros(size(peaks));

for i=1:length(peaks)
    startPoint = max(1,peaks_ind(i) - round(searchInterval/2));
    endPoint = min(peaks_ind(i)+round(searchInterval/2),length(trace));
    if peaks(i)<0 %negative peaks, look for positive rebounds
        rLeft = getPeaks(trace(startPoint:peaks_ind(i)),1);
        rRight = getPeaks(trace(peaks_ind(i):endPoint),1);
    elseif peaks(i)>0 %positive peaks, look for negative rebounds
        rLeft = getPeaks(trace(startPoint:peaks_ind(i)),-1);
        rRight = getPeaks(trace(peaks_ind(i):endPoint),-1);
    end 
    if isempty(rLeft); rLeft = 0; else rLeft = rLeft(1); end
    if isempty(rRight); rRight = 0; else rRight = rRight(1); end

    r.Left(i) = rLeft;
    r.Right(i) = rRight;

end

end

function [peaks,Ind] = getPeaks(X,dir)    
    if dir > 0 %local max
        Ind = find(diff(diff(X)>0)<0)+1;
    else %local min
        Ind = find(diff(diff(X)>0)>0)+1;
    end
    peaks = X(Ind);
end

function Xfilt = highPassFilter(X,F,SampleInterval)
    % F is in Hz
    % SampleInterval is in seconds
    % X is a vector or a matrix of row vectors
    L = size(X,2);
    if L == 1 %flip if given a column vector
        X=X'; 
        L = size(X,2);
    end

    FreqStepSize = 1/(SampleInterval * L);
    FreqKeepPts = round(F / FreqStepSize);

    FFTData = fft(X, [], 2);
    FFTData(:,1:FreqKeepPts) = 0;
    FFTData(end-FreqKeepPts:end) = 0;
    Xfilt = real(ifft(FFTData, [], 2));
end