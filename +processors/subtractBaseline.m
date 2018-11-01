%% Clarinet: Electrophysiology time series data analysis
% Copyright (C) 2018 Luca Della Santina
%
%  This file is part of Clarinet
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
% This software is released under the terms of the GPL v3 software license
%
function result = subtractBaseline(epoch, settings)
%% Subtract the average of pre-stimulus points from epoch

if isempty(epoch) && isempty(settings)
    result.prePoints = 15;  % Pre-stimulus points to use as baseline
    result.device    = '';  % Device to filter epoch (i.e amplifier name)
    return                  % Return default settings as a structure
end

response            = epoch.getDerivedResponse('filteredResponse', settings.device);
data                = response.quantity';

fdata               = data - mean(data(1:settings.prePoints));
response.quantity   = fdata';

epoch.addDerivedResponse('filteredResponse', response, settings.device);
result              = epoch;
end