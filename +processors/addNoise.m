function result = addNoise(epoch, device, settings)
%% Adds zero-mean gaussian white noise with specified standard deviation

if nargin == 0
    result.amplitude  = 10;  % standard deviatin of the gaussian noise
    return                   % Return default settings as a structure
end

response            = epoch.getDerivedResponse('filteredResponse', device);
response.quantity   = response.quantity + random('norm', 0, settings.amplitude, size(response.quantity, 1), size(response.quantity, 2));
epoch.addDerivedResponse('filteredResponse', response, device);
result              = epoch;
end