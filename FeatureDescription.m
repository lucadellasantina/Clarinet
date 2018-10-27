%% Clarinet: Lightweight electrophysiology data analysis
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
classdef FeatureDescription < dynamicprops
    
    properties
        id
        description
        strategy
        unit
        chartType
        xAxis
        downSampleFactor
    end
    
    methods
        
        function obj = FeatureDescription(map)
            props = [];
            
            if isKey(map, 'properties')
                props = map('properties');
                map = remove(map, 'properties');
            end
            cellfun(@(k) obj.set(k, map(k)), map.keys);
            
            if isempty(props)
                return
            end
            
            obj.setProperties(props);
        end
        
        function setProperties(obj, props)
            import  sa_labs.analysis.app.*;
            
            props = strsplit(props, ',');
            
            for i = 1 : numel(props)
                props = strrep(props, '"', '');
                prop = strsplit(props{i}, '=');
                
                if numel(prop) == 2
                    obj.set(prop{1}, prop{2});
                else
                    Exceptions.INVALID_PROPERTY_PAIR.create('warning', true);
                end
            end
        end
        
        function setFromMap(obj, map)
            cellfun(@(k) obj.set(k, map(k)), map.keys);
        end
        
        function map = toMap(obj)
            keys = properties(obj);
            map = containers.Map();
            
            for key = each(keys)
                map(key) = obj.(key);
            end
        end
        
        function set(obj, k, v)
            try
                if ~ isempty(k)
                    var = strtrim(k);
                    
                    if ~ isprop(obj, var)
                        addprop(obj, var);
                    end
                    % TODO check for data type of v and convert to appropriate
                    if ischar(v)
                        v = strtrim(v);
                    end
                    obj.(var) = v;
                end
            catch exception
                warning(exception.identifier, exception.message)
            end
        end
        
    end
    
end