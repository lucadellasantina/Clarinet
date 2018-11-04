function result = powerSpectrum(epoch, device, settings)
%% Compute power spectrum of the epoch. Sampling interval is used to scale to power spectral density (i.e. power per unit bandwidth)

if nargin == 0
    result.includePrePoints  = 1;  % if true include PrePoint in spectrum    
    return                         % Return default settings as a structure
end

response            = epoch.getDerivedResponse('filteredResponse', device);
meta                = epoch.toStructure;
SamplingInterval    = 1/ meta.sampleRate;


if settings.includePrePoints
    % Calculate PrePoints from preTime attibute (stored in ms)
    PrePts = 0;
    PSPts = meta.preTime * meta.sampleRate / 1000; 
else
    % Start calculating power spectrum after preTime
    PrePts = meta.preTime * meta.sampleRate / 1000;
    PSPts  = 0;
end

temp(1:PSPts) = response.quantity((PrePts+1):(PrePts + PSPts));
tempfft = fft(temp);
PowerSpec = tempfft .* conj(tempfft);
PowerSpec = real(PowerSpec);
PowerSpec = 2 * PowerSpec * SamplingInterval / PSPts;

response.quantity   = PowerSpec;
epoch.addDerivedResponse('filteredResponse', response, device);
result              = epoch;
end