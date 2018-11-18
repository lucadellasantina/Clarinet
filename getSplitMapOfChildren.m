% Trasverse the tree branches starting from nodeParent to find Feature keys 
function splitMap = getSplitMapOfChildren(nodeParent)
splitMap = containers.Map;
nodes = nodeParent;

for i=1:numel(nodes)
    % Accumulate splitParameter/splitValue pairs found across cells
    node = nodes(i);
    if ~isempty(node.Children)
        % Recursively go deeper in the tree structure
        splitMap = app.getSplitMapOfChildren(node);
    end
    
    % Accumulate data of current node
    data = node.NodeData;
    if ~splitMap.isKey(data.splitParameter)
        splitMap(data.splitParameter) = {data.splitValue};
    else
        value = splitMap(data.splitParameter);
        value{end+1} = data.splitValue;
        splitMap(data.splitParameter) = value;
    end
end
end
