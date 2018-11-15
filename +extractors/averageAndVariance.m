function result = averageAndVariance(epochGroup, device, settings)
%% Average epochs and calculate mean trace and variance [SEM | SD] 

    if nargin == 0
        result.varianceType = 'SD';     % Variance [SD | SEM]
        return
    end
    
    for i = 1:numel(epochGroup.epochs)
        if epochGroup.epochs(i).hasDerivedResponse('filteredResponse', device)
            response = epochGroup.epochs(i).getDerivedResponse('filteredResponse', device);
        else
            response = epochGroup.epochs(i).getResponse(device);
        end
        
        if i==1
            data = response.quantity;
        else
            data(:,i) = response.quantity;
        end
    end
    
    fmean = mean(data,2);
    switch settings.varianceType
        case 'SD'
            fvar  = std(data,[],2);
        case 'SEM'
            fvar = std(data,[],2)/sqrt(size(data,2));
    end        

    epochGroup.createFeature('responseMean', fmean, 'append', true);
    epochGroup.createFeature('responseVariance', fvar, 'append', true);
    
    result = epochGroup;
end
