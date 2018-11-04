function result = applyNonLinearity(epoch, device, settings)
%% 	Apply multiplicative nonlinearity. Each point is multiplied by corresponding weight of the cumulative gaussian

if nargin == 0
    result.mean = 10;  % mean of the added nonlinearity
    result.sd   = 5;  % standard deviatin of the cumulative gaussian
    return             % Return default settings as a structure
end

response            = epoch.getDerivedResponse('filteredResponse', device);
response.quantity   = normcdf(response.quantity, settings.mean, settings.sd) .* response.quantity;
epoch.addDerivedResponse('filteredResponse', response, device);
result              = epoch;
end