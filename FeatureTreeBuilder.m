classdef FeatureTreeBuilder < FeatureTreeFinder
    
    properties (Dependent)
        dataStore
    end
    
    methods
        
        function obj = FeatureTreeBuilder(name, value, dataTree)
            if nargin < 3
                dataTree = tree();
            end
            obj@FeatureTreeFinder(dataTree);
            obj.setRootName(name, value);
        end
        
        function setRootName(obj, name, value)
            epochGroup = EpochGroup(name, value);
            epochGroup.id = 1;
            obj.setepochGroup(epochGroup.id, epochGroup);
        end
        
        function obj = set.dataStore(obj, dataTree)
            obj.tree = dataTree;
        end
        
        function ds = get.dataStore(obj)
            ds = obj.tree;
        end
        
        function append(obj, dataTree, copyEnabled)
            
            if nargin < 3
                copyEnabled = false;
            end
            
            % This may be a performance hit
            % Think of merging a tree in an alternative way.
            
            obj.tree = obj.tree.graft(1, dataTree);
            childrens = obj.tree.getchildren(1);
            obj.updateDataStoreEpochGroupId();
            disp([ dataTree.get(1).name ' is grafted to parant tree ']);
            
            if copyEnabled
                id = childrens(end);
                group = obj.getEpochGroups(id);
                parent = obj.getEpochGroups(1);
                disp([' analysis parameter from [ ' group.name ' ] is pushed to [ ' parent.name ' ]']);
                parent.setParameters(group.attributes);
            end
        end
        
        function [id, epochGroup] = addEpochGroup(obj, id, splitParameter, spiltValue, epochIndices)
            
            epochGroup = EpochGroup(splitParameter, spiltValue);
            epochGroup.epochIndices = epochIndices;
            id = obj.addepochGroup(id, epochGroup);
            epochGroup.id = id;
            disp(['feature group [ ' epochGroup.name ' ] is added at the id [ ' num2str(id) ' ]']);
        end
        
        function collect(obj, epochGroupIds, varargin)
            
            if length(varargin) == 2 && iscell(varargin{1}) && iscell(varargin{2})
                inParameters = varargin{1};
                outParameters = varargin{2};
            else
                inParameters = varargin(1 : 2 : end);
                outParameters = varargin(2 : 2 : end);
            end
            n = length(inParameters) ;
            
            if n ~= length(outParameters)
                error('Error: parameters must be specified in pairs');
            end
            
            copy = @(in, out) arrayfun(@(id) obj.percolateUpEpochGroup(id, in ,out), epochGroupIds);
            arrayfun(@(i) copy(inParameters{i}, outParameters{i}), 1 : n);
        end
        
        function removeEpochGroup(obj, id)
            if ~ isempty(obj.tree.getchildren(id))
                error('cannot remove ! epochGroup has children');
            end
            obj.tree = obj.tree.removenode(id);
            obj.updateDataStoreEpochGroupId();
        end
        
        function curateDataStore(obj)
            ids = obj.tree.treefun(@(node) obj.isEpochGroupAlreadyPresent(node.id)).find();
            
            while ~ isempty(ids)
                id = ids(1);
                obj.tree = obj.tree.removenode(id);
                obj.updateDataStoreEpochGroupId();
                ids = obj.tree.treefun(@(node) obj.isEpochGroupAlreadyPresent(node.id)).find();
            end
        end
        
        function tf = isEpochGroupAlreadyPresent(obj, sourceId)
            siblings = obj.tree.getsiblings(sourceId);
            ids = siblings(siblings ~= sourceId);
            sourceGroup = obj.getEpochGroups(sourceId);
            
            tf = ~ isempty(ids) &&...
                any(arrayfun(@(id) strcmp(obj.getEpochGroups(id).name, sourceGroup.name), ids))...
                && obj.isBasicEpochGroup(sourceGroup);
        end

        function tf = didCollectEpochParameters(obj, epochGroup)
           t = obj.tree; 
           parentId = t.getparent(epochGroup.id);
           parentGroup = t.get(parentId);
           tf = ~ parentGroup.parametersCopied;
        end

        function disableFurtherCollectForEpochParameters(obj, epochGroup)
            t = obj.tree; 
            parentId = t.getparent(epochGroup.id);
            parentGroup = t.get(parentId);
            parentGroup.parametersCopied = true;
        end

        function tf = didCollectCellParameters(obj, epochGroup)
           t = obj.tree; 
           parentId = t.getparent(epochGroup.id);
           parentGroup = t.get(parentId);
           tf = ~ parentGroup.cellParametersCopied;
        end

        function disableFurtherCollectForCellParameter(obj, epochGroup)
            t = obj.tree; 
            parentId = t.getparent(epochGroup.id);
            parentGroup = t.get(parentId);
            parentGroup.cellParametersCopied = true;
        end
    end
    
    methods(Access = private)
        
        function percolateUpEpochGroup(obj, epochGroupId, in , out)
            t = obj.tree;
            epochGroup = t.get(epochGroupId);
            parent = t.getparent(epochGroupId);
            parentEpochGroup = t.get(parent);
            parentEpochGroup.update(epochGroup, in, out);
            obj.setepochGroup(parent, parentEpochGroup);
            info = ['pushing [ ' in ' ] from feature group [ ' epochGroup.name ' ] to parent [ ' parentEpochGroup.name ' ]'];
            obj.log.trace(info)
        end
        
        function setepochGroup(obj, parent, epochGroup)
            obj.tree = obj.tree.set(parent, epochGroup);
            
        end
        
        function id = addepochGroup(obj, id, epochGroup)
            [obj.tree, id] = obj.tree.addnode(id, epochGroup);
        end
        
        function updateDataStoreEpochGroupId(obj)
            for i = obj.tree.breadthfirstiterator
                if obj.tree.get(i).id ~= i
                    obj.log.trace(['updating tree index [ ' num2str(i) ' ]'])
                    obj.tree.get(i).id = i;
                end
            end
        end
    end
end

