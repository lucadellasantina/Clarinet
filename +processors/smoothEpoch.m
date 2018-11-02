function result = smoothEpoch(epoch, device, settings)
%% Smooth data along time, mode:[moving|lowess|loess|sgolay]

if isempty(epoch) && isempty(settings)
    result.mode     = 'moving'; % moving / lowess / loess / sgolay / rlowess / rloess
    result.span     = 5;        % Smoothing window size in points
    return                      % Return default settings as a structure
end

response            = epoch.getDerivedResponse('filteredResponse', device);
response.quantity   = smooth(response.quantity, settings.span, settings.mode);
epoch.addDerivedResponse('filteredResponse', response, device);
result              = epoch;
end