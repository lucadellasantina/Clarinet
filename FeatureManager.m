classdef FeatureManager < handle
    
    properties
        descriptionMap
    end
    
    properties (Constant)
        
        % Format specifier description
        % ----------------------------------------------------------------------------
        % 'id', 'description', 'strategy', 'unit', 'chartType', 'xAxis', 'properties'
        % ----------------------------------------------------------------------------
        
        FORMAT_SPECIFIER = '%s%s%s%s%s%s%s%[^\n\r]';
    end
    
    methods
        
        function obj = FeatureManager(descriptionFile)
             obj.loadFeatureDescription(descriptionFile);
        end
        
        function loadFeatureDescription(obj, descriptionFile)
            
            if ~ isempty(obj.descriptionMap)
                warning('featureManager:reloadDescriptionCSV', ['reloading descriptionMap from file ' descriptionFile])
            end
            text = readCSVToCell(descriptionFile, obj.FORMAT_SPECIFIER);
            
            % get the first column and use it as key for descriptionMap
            vars = text(:, 1);
            header = text(1, :);
            obj.descriptionMap = containers.Map();
            
            % skip the header rows
            for i = 2 : numel(vars)
                key = strtrim(vars{i});
                desc = FeatureDescription(containers.Map(header, text(i, :)));
                obj.descriptionMap(key) = desc;
            end
        end
        
        % TODO test
        function updateFeatureDescription(obj, epochGroups)
            keySet = epochGroups.getFeatureKey();
            
            for i = 1 : numel(keySet)
                key = keySet{i};
                features = epochGroups.featureMap(key);
                
                if ~ isKey(obj.descriptionMap, key)
                    obj.descriptionMap(key) = features(1).description;
                    FeatureDescription.cacheMap(obj.descriptionMap);
                end
                
            end
        end
        
        function saveFeatureDescription(obj)
            % TODO update the CSV file
        end
    end
    
    
    methods (Static)
        
        function descriptionMap = cacheMap(descriptionMap)
            
            persistent map;
            
            if nargin < 1
                descriptionMap = map;
                return
            end
            map = descriptionMap;
        end
        
        function tf = isPresent(id)
            map = FeatureDescription.cacheMap();
            tf = isKey(map, id);
        end
        
    end
end
