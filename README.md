# Grove TM1637

This library provides a simple hardware driver for a TM1637-driven display connected via the Grove system, such as the [Seeed 4-Digit Display](http://wiki.seeed.cc/Grove-4-Digit_Display/).



on the .
 
**To use this library, add** `#require "Grove.TM1637.device.lib.nut:1.0.0"` **to the top of your device code.**


## Class Usage ##

### Constructor: GroveTM1637(*dataPin, clockPin*) ###

Instantiating the library requires you to specify the data and clock pins to be used to drive the display. For example, on the [impExplorer™ Kit](https://developer.electricimp.com/hardware/resources/reference-designs/explorerkit), you will need to use either of the two Grove I2C headers, ie. **hardware.pin8** and **hardware.pin9**, for clock and data, respectively.

**Important** Both pins will be configured by the constructor as digital outputs, so this library will not be compatible with I2C add-ons connected via the second header.

#### Example ####

```squirrel
// Load the Grove TM1637 library
#require "Grove.TM1637.device.lib.nut:1.0.0"

// Instantiate the driver on an impExplorer
led = GroveTM1637(hardware.pin9, hardware.pin8);
```

## Class Methods ##

### setDigit(*digit, value*) ###

This method sets the required digit to show the specified value. This can be any value from 0 to 15 &mdash; these will be rendered as 0 to 9 and A to F. In addition, you can specify 16, 17 or 18, which will render, respectively, a minus symbol (-), a degree symbol (&deg;) or a clear space ( ).

The method returns *this*, the context variable, allowing you to chain multiple calls as shown in the example below. Calling *setDigit()* does not update the display &mdash; you will need to call *display()* to do so.

#### Example ####

```squirrel
led.setDigit(0, 13)
   .setDigit(1, 14)
   .setDigit(2, 10)
   .setDigit(3, 13)
   .display();
```

### setColon(*[state]*) ###

This method allows you to indicate whether the Seeed 4-Digit Display’s central colon (:) is lit (*state* = `true`) or not lit (*state* = `false`). The default value of *state* is `true`.

The method returns *this*, the context variable, allowing you to chain multiple calls as shown in the example below. Calling *setColon()* does not update the display &mdash; you will need to call *display()* to do so.

#### Example ####

```squirrel
led.setColon(loopCount % 2 == 0)
   .display();
```

### getColonState() ###

This method returns the current state of the display’s colon: lit (return `true`) or unlit (`false`).

### SetBrightness(*[brightness]*) ###

This method sets the Seeed 4-Digit Display’s brightness. The value of *brightness* is a value between 0 and 7 indicating the duty cycle: 0 (1/16), 1 (2/16), 2 (4/16), 3 (10/16), 4 (11/16), 5 (12/16), 6 (13/16) and 7 (14/16). The default value is 7 (maximum brightness). The new brightness value is applied to the display immediately.

#### Example ####

```squirrel
led.setBrightness(0)
```

### getBrightness() ###

This method returns the current state of the display’s brightness: an integer from 0 to 7.

### display() ###

This method causes the library to update the Seeed 4-Digit Display. See *setDigit()* and *setColon()*, above, for examples of its use.

### clearDisplay() ###

This method clears the display immediately. It clears the internal display buffer and turns off the colon (see *setColon()*).

#### Example ####

```squirrel
// Show inital value
led.setDigit(0, 13)
   .setDigit(1, 14)
   .setDigit(2, 10)
   .setDigit(3, 13)
   .display();

// Wait 20 seconds and start the timer
imp.wakeup(20, function() {
    led.clearDisplay();
    loop();
});
```

### power(*[isOn]*) ###

This method is used to power cycle the display. When the library is instantiated the display will always be powered up, but can subsequently be turned off by passing `false` as the argument of *isOn*. Note that *power()* will only affect the display if the argument of *isOn* does not match the display’s current state: calling `power(true)` or `power()` when the display is already powered up will have no effect.

## License ##

The Grove TM1637 library is releases under the [MIT license](https://github.com/electricimp/Grove_TM1637/blob/master/LICENSE).
