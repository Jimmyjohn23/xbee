classdef MobileData

    properties
        Address
        X_Value
        Y_Value
        RSSI
        Position
    end

    methods
        function obj = MobileData(addr,x,y)
           obj.Address = addr;
           obj.X_Value = x;
           obj.Y_Value = y;
           obj.RSSI = NaN;
           obj.Position = NaN;
        end
    end
end