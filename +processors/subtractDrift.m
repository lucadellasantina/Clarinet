function result = subtractDrift(epoch, device, settings)
%% Subtract drifting of the epoch (calculated as the linear fit from startPoint)

if nargin == 0
    result.startPoint = 1; % Pre-stimulus points to use as baseline
    return                 % Return default settings as a structure
end

response    = epoch.getDerivedResponse('filteredResponse', device);
data        = response.quantity;

Fit         = zeros(numel(data),1);
Xaxis       = (settings.startPoint:numel(data))';
FitCoeffs   = polyfit(Xaxis, data(settings.startPoint:end), 1);
for i=1:numel(data)
    Fit(i)  = FitCoeffs(1) * i + FitCoeffs(2);
end

response.quantity   = data - Fit;
epoch.addDerivedResponse('filteredResponse', response, device);
result              = epoch;
end