function result = filterFrequencies(epoch, device, settings)
%% Filter data in the frequency domain [lowpass|highpass|notch] 
 
% Version 3.0                              2018-10-30 by Luca Della Santina
%  + Simplified the logic of this filter to the bare minimum
%  + Wrapped the function as a Clarinet processor
%
% Version 2.1                              2018-03-20 by Luca Della Santina 
%   % Output time series vector size matches the size of input data
%   + notch_freq allows to add a custom notch filter (-1 means disabled)
%
% Version 2.0                              2017-08-08 by Luca Della Santina 
%   % Preserves signal amplitude
%   + Allows to plot results or silently resutn results with last parameter
%
% Version 1.0 Shmuel Ben-Ezra, Ultrashape ltd. August 2009


if isempty(epoch) && isempty(settings)
    result.highpass_freq = 0;  % High-pass filter cutoff frequency
    result.lowpass_freq  = 0;  % Low-pass filter cutoff frequency
    result.notch_freq    = 0;  % Notch frequency to remove
    return                     % Return default settings
end

meta        = epoch.toStructure;% metadata of the epoch stored as structure
response    = epoch.getDerivedResponse('filteredResponse', device);
data        = response.quantity';

N           = length(data);     % number of samples in the time domain
Nfft        = 2^nextpow2(N);    % number of samples in freq domain must be a power of 2
f           = meta.sampleRate/2*linspace(0,1,1+Nfft/2); % create freqs vector

y           = fft(data,Nfft);   % transform data to the frequency domain
y2          = filterfft(f, y, settings.lowpass_freq, settings.highpass_freq, settings.notch_freq);
X           = ifft(y2);         % inverse transform data to the time domain

fdata       = X(1:numel(data)); % keep only the same time range as original signal
response.quantity = fdata';

epoch.addDerivedResponse('filteredResponse', response, device);
result      = epoch;
end

function y2 = filterfft(f, y, lowpass, highpass, notch)
nf  = length(f);
ny  = length(y);
if ~(ny/2+1 == nf)
    disp('unexpected dimensions of input vectors!')
    y2 = -1;
    return
end

% cutoff filter
y2 = y;
if lowpass > 0,     y2(f>=lowpass) = 0;     end
if highpass > 0,    y2(f<=highpass) = 0;    end
if notch > 0,       y2(notch)= 0;           end

% create a conjugate symmetric vector of amplitudes
for k = nf+1:ny
    y2(k)   = conj(y2(mod(ny-k+1,ny)+1)); % formula ifft's help
end
end