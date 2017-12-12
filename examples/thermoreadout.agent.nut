// IMPORTS
#require "DarkSky.class.nut:1.0.1"

// CONSTANTS
const FORECAST_REFRESH = 120;
const MY_LATITUDE = <YOUR_LATITUDE_AS_FLOAT>;
const MY_LONGITUDE = <YOUR_LONGITUDE_AS_FLOAT>;
const MY_API_KEY = <"YOUR_DARK_SKY_API_KEY_AS_STRING">;

// GLOBALS
local nextForecastTimer = null;
local forecaster = null;

// WEATHER FUNCTIONS
function getForecast() {
    // Request the weather data from DarkSky asynchronously
    forecaster.forecastRequest(MY_LONGITUDE, MY_LATITUDE, forecastCallback);
}

function forecastCallback(err, data) {
    // Decode the JSON-format data from forecast.io (error thrown if invalid)
    if (data) {
        if ("hourly" in data) {
            if ("data" in data.hourly) {
                local item = data.hourly.data[0];
                local sendData = {};
                sendData.temp <- item.apparentTemperature;
                if (device.isconnected()) device.send("thermoreadout.show.forecast", sendData);
            }
        }

        if ("callCount" in data) server.log("Current DarkSky API call tally: " + data.callCount + "/1000");
    }

    // Get the next forecast in an 'FORECAST_REFRESH' minutes' time
    if (nextForecastTimer) imp.cancelwakeup(nextForecastTimer);
    nextForecastTimer = imp.wakeup(FORECAST_REFRESH, getForecast);
}

// START
forecaster = DarkSky(MY_API_KEY);
getForecast();
