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
%% Test importing symphony v1

disp(['Importing file coming from Sympohony version: ' num2str(SymphonyParser.getVersion('symphony_v1.h5'))]);
ref = SymphonyV1Parser('symphony_v1.h5');
ref.parse;
data = ref.getResult;
celldata = data{end};
epochs = celldata.epochs;
epoch = epochs(1);
epoch.get('devices')

%% Test importing symphony v2

disp(['Importing file coming from Sympohony version: ' num2str(SymphonyParser.getVersion('symphony_v2.h5'))]);
ref = SymphonyV2Parser('symphony_v2.h5');
ref.parse; % find out where is tree(), now it conflicts with tree.m in one deprecated matlab toolbox, check using "which tree"
data = ref.getResult;
celldata = data{end};
epochs = celldata.epochs;
epoch = epochs(1);
epoch.get('devices')
