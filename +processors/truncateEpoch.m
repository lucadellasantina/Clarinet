function result = truncateEpoch(epoch, device, settings)
%%  Truncate epoch data from startSample to specified length 

if nargin == 0
    result.startSample   = 1;    % start position
    result.lengthSamples = 5000; % length of the truncated epoch
    return                       % Return default settings as a structure
end

response            = epoch.getDerivedResponse('filteredResponse', device);
response.quantity   = response.quantity(settings.startSample : settings.lengthSamples);
epoch.addDerivedResponse('filteredResponse', response, device);
result              = epoch;
end