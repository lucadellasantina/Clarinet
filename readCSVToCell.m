function text = readCSVToCell(fname, formatSpecifier)
    
    fid = fopen(fname, 'r');
    text = textscan(fid, formatSpecifier, 'Delimiter', ',');
    % unwrap cell array to array
    text =  [text{1, :}];
    columns = find(~ cellfun(@isempty, text(1, :)));
    text = text(:, columns);
    fclose(fid);
end