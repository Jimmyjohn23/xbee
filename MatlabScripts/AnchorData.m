classdef AnchorData
    properties
        X_Value
        Y_Value
        Address
        RSSI
        MobileConnected
        Distance
        MobileCalc
        MobileX
        MobileY
    end
    
    methods
   
        function obj = AnchorData(addr, X, Y)
            obj.Address = addr;
            obj.X_Value = X;
            obj.Y_Value = Y;
            obj.RSSI = NaN;
            obj.MobileConnected = NaN;
            obj.Distance = NaN;
            obj.MobileCalc = NaN;
            obj.MobileX = NaN;
            obj.MobileY = NaN;
        end

        function obj = set.MobileX(obj, x)
            obj.MobileX = x;
        end

        function obj = set.MobileY(obj, y)
            obj.MobileY = y;
        end

        function obj = set.RSSI(obj, rssi)
                obj.RSSI = rssi;
        end
        
        function obj = set.MobileConnected(obj, mobileAddr)
                obj.MobileConnected = mobileAddr;
        end
        
        function Address = get.Address(obj)
            Address = obj.Address;
        end
  
        function RSSI = get.RSSI(obj)
            RSSI = obj.RSSI;
        end
        
        function MobileConnected = get.MobileConnected(obj)
            MobileConnected = obj.MobileConnected;
        end
        
        function X_Value = get.X_Value(obj)
            X_Value = obj.X_Value;
        end
        
        function Y_Value = get.Y_Value(obj)
            Y_Value = obj.Y_Value;
        end
        
        function obj = set.Distance(obj, rssi)
                obj.Distance = 10.^((rssi - 31) / (10 * 1.6)); % Assuming indoor conditions
        end
        
        function obj = set.MobileCalc(obj, M)
            obj.MobileCalc = M;
        end

        function MobileCalc = get.MobileCalc(obj)
            MobileCalc = obj.MobileCalc;
        end
    end
end