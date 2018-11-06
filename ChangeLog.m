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
%
% *Change log*
%
% _*Version 1.7*            created on 2018-11-06 by Luca Della Santina_
%
%  + Add custom tags to selected epochs
%  + Remove selected tag from epoch
%  + Processing pipelines are stored as an attribute of the epoch
%  + Load pipeline used to process selected epoch
%  + Added acknowledgement to contributing labs/projects in about window
%
% _*Version 1.6*            created on 2018-11-04 by Luca Della Santina_
%
%  + Custom epoch processors stored in userpath/Clarinet/+customProcessors
%  + Processing pipelines can be saved and loaded from disk
%  + Fixed enabled/disabled status of processing pipeline buttons
%  + Fixed error when searching text attributes
%  + Fixed UI size to allow visualization on small projectors (1024x768)
%
% _*Version 1.5*            created on 2018-11-04 by Luca Della Santina_
%
%  + New Epoch processors: interpolate, decimate, truncate
%  + New Epoch processors: addNoise, addNonLinearity
%  + New Epoch processor: powerSpectrum, subtractDrift
%  + Fixed error when loading About dialog multiple times
%
% _*Version 1.4*            created on 2018-11-04 by Luca Della Santina_
%
%  + Epoch processors called without arguments return default setting
%  + Removed need for settings.device in UI processor settings
%  + Display date and time each epoch was recorded inside EpochTree
%  + SymphonyParser removed enforcement of label naming scheme (c1 ... cn)
%  + SymphonyParser.parse returns only the list of epochs by label(faster)
%
% _*Version 1.3*            created on 2018-11-03 by Luca Della Santina_
%
%  + Epochs can be tagged with colors for easy grouping
%  + Save button stores processed version of epochs and tags
%  + Fixed error when trying to visualize search epochs before searching
%  + Added EpochData.hasAttribute method to check for attribute existence
%
% _*Version 1.2*            created on 2018-11-02 by Luca Della Santina_
%
%  + Processing pipeline allows using multiple epoch processors in chain
%  + Processor function definition now requires device as parameter
%  + Fixed bug in processors displaying license instead of description
%
% _*Version 1.1*            created on 2018-11-01 by Luca Della Santina_
%
%  + 2D/3D plot switcher
%  + Search criteria can be either "Any" or "All" conditions to be met
%  + Find dialog remembers last settings within session
%  + Ensured destruction of dialogs before Clarinet is closed
%
% _*Version 1.0*            created on 2018-10-30 by Luca Della Santina_
%
%  + Import epochs from Symphony v1 & v2
%  + Load / Save current analysis
%  + Process selected epoch with dynamically imported processor functions
%  + Search epochs matching a set of conditions
%  + Display epoch's metadata as table
%  + Plot selected epochs
%  + Plot raw or processed version of the epoch
%  + Plot all epochs or result of last search
%  + Display epoch data as a function of time or samples
%  + Spike detection processor
%  + Smooth epoch processor
%  + Frequency filter processor
%  + Subtract baseline processor
%