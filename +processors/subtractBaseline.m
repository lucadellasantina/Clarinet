function result = subtractBaseline(epoch, device, settings)
%% Subtract average of pre-stimulus points from epoch (use zero to read prePoints from each epoch)

if nargin == 0
    result.prePoints = 0;  % Pre-stimulus points to use as baseline
    return                 % Return default settings as a structure
end

response = epoch.getDerivedResponse('filteredResponse', device);
meta     = epoch.toStructure; 
data     = response.quantity';

if settings.prePoints == 0
    settings.prePoints = meta.preTime * meta.sampleRate /1000 ; % calculate PrePoints from epoch's preTime (stored in ms)
end
fdata               = data - mean(data(1:settings.prePoints));
response.quantity   = fdata';

epoch.addDerivedResponse('filteredResponse', response, device);
result              = epoch;
end