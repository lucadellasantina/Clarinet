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
fName = 'symphony_v1.h5';
%fName = '20180102Fc1.h5';

disp(['Importing file coming from Symphony version: ' num2str(SymphonyParser.getVersion(fName))]);
ref = SymphonyV1Parser(fName);
ref.parse;
data = ref.getResult;
celldata = data{end};
epochs = celldata.epochs;
epoch = epochs(1);
%epoch.get('devices')

%% Test importing symphony v2
%fName = 'symphony_v2.h5';
%fName = '2018-01-23_ERG_CD1b.h5';
fName = '2018-01-23_ERG_C57BL.h5';

disp(['Importing file coming from Symphony version: ' num2str(SymphonyParser.getVersion(fName))]);
ref = SymphonyV2Parser(fName);
ref.parse; % find out where is tree(), now it conflicts with tree.m in one deprecated matlab toolbox, check using "which tree"
data = ref.getResult;
celldata = data{end};
epochs = celldata.epochs;
epoch = epochs(1);
%epoch.get('devices')

%% Feature extraction test

FeatureManager('feature-description.csv')