% Daniel Lui 2017 

% This script allows a robotic pointer arm to be controller by an accelerometer sensor 
% Values may need to be adjusted for different sensors/servos 

% COM4- servos
% COM3- gyro

clear

% Define two arduinos (ard1/com4 for robot, ard2/com3 for gyro sensor)

ard1 = arduino('COM4','Uno');
ard2 = arduino('COM3','Uno');

s1 = servo(ard1 , 'D4');
s2 = servo(ard1 , 'D7');

% Initialize values
x = 0; y = 0; z = 0; n = 1;

% A little bit of a "dance" to show that full range of motion is possible

writePosition(s1, 0.05)
writePosition(s2, 0.05)
pause(0.5)

writePosition(s1, 0.95)
writePosition(s2, 0.95)
pause(0.5)

writePosition(s1, 0.55)
writePosition(s2, 0.55)
pause(0.5)


% Main loop
while 1==1
    clc    
      a = readVoltage(ard2,'A1');
      b = readVoltage(ard2,'A2');
		
% Converts voltage reading to servo output value for servo 1		
    pos1 = ceil(((1-(a-1.25)/0.85)*25))/25;
    
% Filters out any values >1 or <0, because they cause an error 
% in MATLAB's servo function
  
    if pos1 > 1 
        pos1 = 0;
    elseif pos1 < 0
        pos1 = 1;
    end
 
% Converts voltage reading to servo output value for servo 2	    
	pos2 = ceil((((b-1.25)/0.85)*25))/25;
    
	
% Filters out any values >1 or <0, because they cause an error 
% in MATLAB's servo function	
    if pos2 > 1 
        pos2 = 1;
    elseif pos2 < 0h
        pos2 = 0;
    end
    
% Outputs position     
    writePosition(s2, pos1/2)
    writePosition(s1, pos2)
    y1(n) = pos1;

    
    plot(1:n,y1)
    
    n = n + 1;

% Kill switch (if button is pressed, break loop)
    if readVoltage(ard2,'A3 ') > 3
        break
    end
end

% After kill switch is pressed, do a "reverse dance" and end terminate script
writePosition(s1, 0.95)
writePosition(s2, 0.95)
pause(0.5)

writePosition(s1, 0.05)
writePosition(s2, 0.05)

writePosition(s1, 0.55)
writePosition(s2, 0.55)
pause(0.5)
