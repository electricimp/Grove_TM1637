# Examples #

The examples in this folder demonstrate the use of the Grove TM1637 library.

## Thermoreadout ##

```
thermoreadout.device.nut
thermoreadout.agent.nut
```

This example displays the current outdoor temperature on the display. The weather data is sourced from DarkSky using 
Electric Imp’s [DarkSky library](https://github.com/electricimp/DarkSky), so to try this example you will need to sign up 
for a free DarkSky API Key. 

Note that though account sign-up is free, DarkSky bills for API usage above 1000 calls a day, so the current call count is 
displayed in the device log. The example retrieves a forecast every two minutes, ie. 720 calls in 24 hours. Please bear this 
in mind if you use the DarkSky API elsewhere. You can change the period between each all to the API in the agent code by 
increasing the vale of the constant *FORECAST_REFRESH*.

The device code makes use of library not only to show the temperature numerals (using the library’s *setDigit()* method, 
but also to draw in a degree symbol and, if necessary, a minus symbol. These are set using the *setGlyph()* method. The code 
refreshes the display and uses the value passed into *setGlyph()* to switch on a ‘heartbeat’ indicator every other second 
&mdash; this indicator appears below the degree symbol and is a useful way of showing that the device is ‘alive’, especially 
in applications such as this where the displayed data does not change frequently.
