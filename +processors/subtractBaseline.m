function result = subtractBaseline(epoch, settings)
%% Subtract the average of pre-stimulus points from epoch

if isempty(epoch) && isempty(settings)
    result.prePoints = 15;      % Pre-stimulus points to use as baseline
    result.device    = 'Amp1';  % Device to filter epoch (i.e amplifier name)
    return                      % Return default settings as a structure
end

response            = epoch.getDerivedResponse('filteredResponse', settings.device);
data                = response.quantity';

fdata               = data - mean(data(1:settings.prePoints));
response.quantity   = fdata';

epoch.addDerivedResponse('filteredResponse', response, settings.device);
result              = epoch;
end