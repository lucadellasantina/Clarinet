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