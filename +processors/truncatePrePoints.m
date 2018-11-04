function result = truncatePrePoints(epoch, device, settings)
%%  Remove pre-stimulus points (use zero to use preTime from each epoch)

if nargin == 0
    result.prePoints   = 0;    % start position
    return                       % Return default settings as a structure
end

response            = epoch.getDerivedResponse('filteredResponse', device);
meta                = epoch.toStructure;

if settings.prePoints == 0
    settings.prePoints = meta.preTime * meta.sampleRate / 1000;
end

response.quantity   = response.quantity(settings.prePoints+1 : end);
epoch.addDerivedResponse('filteredResponse', response, device);
result              = epoch;
end