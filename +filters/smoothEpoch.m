function result = smoothEpoch(epoch, settings)
%% Smooth data using mode = moving/lowess/loess/sgolay

if isempty(epoch) && isempty(settings)
    result.mode = 'moving';     % moving / lowess / loess / sgolay / rlowess / rloess
    result.span = 5;            % Smoothing window size in points
    result.device = 'Amp1';     %% Device to filter epoch (i.e amplifier name)
    return                      % Return default settings as a structure
end

data            = epoch.getResponse(settings.device);
response        = data.quantity';

fresponse       = smooth(response,settings.span, settings.mode);
data.quantity   = fresponse';

epoch.addDerivedResponse('filteredResponse', data, settings.device);
result          = epoch;
end