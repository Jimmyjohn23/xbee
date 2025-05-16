clear all
close all
clc
serialObject = serialport('COM3', 9600); 
counter = 0;

nodeCount = input("Enter number of anchors: ");
mobileCount = input("Enter number of mobile: ");
mobileX = [];
mobileY = [];
distance = [];
positionX = [];
positionY = [];
dataCell = {'AnchorID', 'Anchor_X','Anchor_Y','RSSI','MobileID','MobileX','MobileY'};

xbees   = { "x415634FA", "x40E5F2A6", "x40F754A7", "x4152F33E" ,"x40F7569E"};
labels  = { 'Black',         'Yellow',       'Red',         'Grey','White' };

for i = 1:nodeCount
    choice = menu( sprintf('Anchor #%d → pick XBee', i), labels{:} );
    X = input(  sprintf('  X position of anchor #%d: ', i) );
    Y = input(  sprintf('  Y position of anchor #%d: ', i) );
    anchor(i) = AnchorData( xbees{choice}, X, Y );
    nodeAddr{i} = matlab.lang.makeValidName(xbees{choice});
end

for i = 1:mobileCount
    choice = menu( sprintf('Mobile #%d → pick XBee', i), labels{:} );
    X = input(  sprintf('  X position of mobile #%d: ', i) );
    Y = input(  sprintf('  Y position of mobile #%d: ', i) );
    mobile(i) = MobileData( xbees{choice}, X, Y );
end
try
    while true
        for jj = 1:10
            [data, count, msg] = fread(serialObject, 1);
            if numel(data) > 0 && isnumeric(data)
                if data(1) == hex2dec('F0') 
                    len = fread(serialObject, 1);  
                    bufS = fread(serialObject, len); 
                    mobileAddress = sprintf('%X', bufS(1:4))
                    validMobile = matlab.lang.makeValidName(mobileAddress);
                    for ii = 5:5:len
                        rssi = bufS(ii); 
                        addrs = sprintf('%X', bufS((ii+1):(ii+4))); 
                        validAddr = matlab.lang.makeValidName(addrs);
        
                        for j = 1:nodeCount
                            if strcmp(validAddr, nodeAddr{j}) 
                                anchor(j).RSSI = rssi;  
                                anchor(j).Distance = rssi;  
                                anchor(j).MobileConnected = validMobile;
                                for m = 1:mobileCount
                                    if validMobile == mobile(m).Address
                                        anchor(j).MobileX = mobile(m).X_Value
                                        anchor(j).MobileY = mobile(m).Y_Value
                                    end
                                end   
                                positionX(end+1) = anchor(j).X_Value;
                                positionY(end+1) = anchor(j).Y_Value;
                                distance(end+1) = anchor(j).Distance;
                            end
                        end
                    end
                    
                    positionX = positionX';
                    positionY = positionY';
                    pos = [positionX,positionY]
                    distance = distance'  
                    getPos(pos, distance)
            
                    for j = 1:nodeCount
                        newRow = {anchor(j).Address, anchor(j).X_Value, anchor(j).Y_Value, anchor(j).RSSI,...
                            anchor(j).MobileConnected, anchor(j).MobileX, anchor(j).MobileY};
                        dataCell(j+1,:) = newRow;
                    end
                    
                end
            end
            % Define the current date and time
            Y = year(datetime);     % Get current year
            M = month(datetime);    % Get current month
            D = day(datetime);      % Get current day
            H = hour(datetime);     % Get current hour
            MI = minute(datetime);  % Get current minute
            S = second(datetime);   % Get current second
            
            % Construct the filename
            filename = "xBeeData_" + string(Y) + "_" + string(M) + "_" + string(D) + "_" + ...
                       string(H) + "_" + string(MI) + "_" + string(S) + '.csv';
            
            % Save the dataCell to the constructed CSV filename
            writecell(dataCell, filename);
            disp(dataCell)
            
            counter = 0;
        end
        break
    end
catch
    disp("Error")
end
 