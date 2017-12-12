// IMPORTS
#require "grove.tm1637.device.lib.nut:1.0.0"

// GLOBALS
local led = null;
local tickFlag = true;

// FUNCTIONS
function displayTime() {
    // Re-call in one second's time
    imp.wakeup(1.0, displayTime);
    
    local now = date();
    local hour = now.hour;
    local mins = now.min;
    
    led.setColon(tickFlag)
       .setDigit(0, (hour / 10))
       .setDigit(1, (hour % 10))
       .setDigit(2, (mins / 10))
       .setDigit(3, (mins % 10))
       .display();
    
    tickFlag = !tickFlag;
}

// START
// Instantiate display object
led = GroveTM1637(hardware.pin9, hardware.pin8);

// Start the clock
displayTime();
