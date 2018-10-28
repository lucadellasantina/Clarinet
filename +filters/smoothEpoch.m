function result = smoothEpoch(epoch, settings)
%% Smooth data (mode = moving/lowess/loess/sgolay)

if isempty(epoch) && isempty(settings)
    result.mode     = 'moving'; % moving / lowess / loess / sgolay / rlowess / rloess
    result.span     = 5;        % Smoothing window size in points
    result.device   = 'Amp1';   % Device to filter epoch (i.e amplifier name)
    return                      % Return default settings as a structure
end

response            = epoch.getDerivedResponse('filteredResponse', settings.device);
data                = response.quantity';

fdata               = smooth(data, settings.span, settings.mode);
response.quantity   = fdata';

epoch.addDerivedResponse('filteredResponse', response, settings.device);
result              = epoch;
end