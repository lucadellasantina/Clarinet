function result = subtractBaseline(epoch, settings)
%% Subtract pre-stimulus points as baseline

if isempty(epoch) && isempty(settings)
    result.prePoints = 15;      % Pre-stimulus points to use as baseline
    result.device = 'Amp1';     % Device to filter epoch (i.e amplifier name)
    return                      % Return default settings as a structure
end

data            = epoch.getResponse(settings.device);
response        = data.quantity';

fresponse       = response - mean(response(1:settings.prePoints));
data.quantity   = fresponse';

epoch.addDerivedResponse('filteredResponse', data, settings.device);
result          = epoch;