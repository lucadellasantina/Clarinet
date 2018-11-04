function result = interpolateEpoch(epoch, device, settings)
%% Interpolate epoch data points by a given factor (opposite of decimate)
if nargin == 0
    result.factor  = 2;  % standard deviatin of the gaussian noise
    return               % Return default settings as a structure
end

response            = epoch.getDerivedResponse('filteredResponse', device);
response.quantity   = interp(response.quantity, settings.factor);
epoch.addDerivedResponse('filteredResponse', response, device);
result              = epoch;
end