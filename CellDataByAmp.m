classdef CellDataByAmp < handle
    
    properties
        deviceType
        recordingLabel
        cellDataRecordingLabel
    end
    
    methods
        
        function obj = CellDataByAmp(recordingLabel, deviceType)
            obj.deviceType = deviceType;
            obj.recordingLabel = strcat(recordingLabel, '_', deviceType);
            obj.cellDataRecordingLabel = recordingLabel;
        end
        
        function updateCellDataForTransientProperties(obj, cellData)
            cellData.deviceType = obj.deviceType;
        end
    end
end