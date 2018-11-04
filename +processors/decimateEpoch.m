function result = decimateEpoch(epoch, device, settings)
%% Decimate epoch data points by a given factor (opposite of interpolate)
if nargin == 0
    result.factor  = 2;  % standard deviatin of the gaussian noise
    return               % Return default settings as a structure
end

response            = epoch.getDerivedResponse('filteredResponse', device);
response.quantity   = decimate(response.quantity, settings.factor);
epoch.addDerivedResponse('filteredResponse', response, device);
result              = epoch;
end