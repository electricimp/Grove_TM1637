// IMPORTS
#require "grove.tm1637.device.lib.nut:1.0.0"

// GLOBALS
local led = null;
local savedData = null;
local tickFlag = true;

// FUNCTIONS
function displayWeather(data) {
    savedData = data;
    local temp = 0;
    
    if (savedData != null) {
        temp = savedData.temp.tointeger();
    }

    led.setGlyph(0, (temp < 0 ? 0x40 : 0x00))
       .setDigit(1, (temp < 0 ? -1 * temp / 10 : temp / 10))
       .setDigit(2, (temp < 0 ? -1 * temp % 10 : temp % 10))
       .setGlyph(3, (tickFlag ? 0x6B : 0x63))
       .display();
    
    tickFlag = !tickFlag;
    
    imp.wakeup(1.0, function() {
        displayWeather(savedData);
    });
}

// START
// Instantiate display object
led = GroveTM1637(hardware.pin9, hardware.pin8);

// Set up agent interaction
agent.on("homeweather.show.forecast", displayWeather);
