function result = subtractBaseline(epoch, device, settings)
%% Subtract the average of pre-stimulus points from epoch

if isempty(epoch) && isempty(settings)
    result.prePoints = 15;  % Pre-stimulus points to use as baseline
    return                  % Return default settings as a structure
end

response            = epoch.getDerivedResponse('filteredResponse', device);
data                = response.quantity';

fdata               = data - mean(data(1:settings.prePoints));
response.quantity   = fdata';

epoch.addDerivedResponse('filteredResponse', response, device);
result              = epoch;
end