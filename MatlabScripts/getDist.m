function dist = getDist(rssi, M1rssi,n)

dist = 10.^((rssi - M1rssi)./(10.*n)); 




