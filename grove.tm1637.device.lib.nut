const GROVE_TM1637_HIGH = 1;
const GROVE_TM1637_LOW = 0;
const GROVE_TM1637_ADDR_AUTO = 0x40;
const GROVE_TM1637_ADDR_FIXED = 0x44;
const GROVE_TM1637_dataPin_CMD = 0xC0;
const GROVE_TM1637_DISPLAY_CMD = 0x88;

class GROVE_TM1637 {

	_dataPin = null;
	_clockPin = null;
	_buffer = null;
	_chars = [0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F, // 0-9
			  0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71, // A-F
			  0x40, 0x63, 0x00]; // -, degree symbol, space
	_brightness = 7;
	_colonState = true;

	constructor(dataPin = null, clockPin = null) {
		// Reject unset parameters
		if (dataPin == null || clockPin == null) {
			throw "GROVE_TM1637() requires valid clock and data pin objects as parameters";
		}
		
		// Configure the clock and data pins as digital outputs, initially low
		_dataPin = dataPin;
		_dataPin.configure(DIGITAL_OUT, GROVE_TM1637_LOW);
		_clockPin = clockPin;
		_clockPin.configure(DIGITAL_OUT, GROVE_TM1637_LOW);
		
		// Clear the display (resets the display buffer too)
		clearDisplay();
	}

	function setBrightness(value) {
		// Convert percentage brightness to range 0-7
		// 0 = 1/16, 8 = 14/16 duty cyle
		_brightness = ((value / 100) * 8 - 1);
		if (_brightness < 0) _brightness = 0;
		if (_brightness > 7) _brightness = 7;
		_display();
	}

	function setColon(state = true) {
		// Indicate whether the central colon should be lit (true)
		if (typeof state == "boolean") _colonState = state;
		return this;
	}

	function setDigit(digit = 0, data = 0) {
		 // Set the digit to the required value:
		 // 0-17, ie. 0-9, A-F, -, degree, or space
		 // Digits are 0-3
		
		if (data < 0 || data >= _chars.len()) {
			server.error("GROVE_TM1637.setDigit() data out of range");
			return;
		}
		
		 _buffer[digit] = _chars[data];
		 return this;
	}
	
	function display() {
		// Trigger the display to update
		_display();
	}
	
	function clearDisplay() {
		_buffer = [0,0,0,0];
		_display();
	}
	
	// ********** Private Functions - Do not call directly **********
	
	function _display() {
		// Tell the TM1637 to auto-increment the input data address
		_start();
		_writeByte(GROVE_TM1637_ADDR_AUTO);
		_stop();

		// Send the command value, then each segment value
		_start();
		_writeByte(GROVE_TM1637_dataPin_CMD);
		for (local i = 0 ; i < 4 ; i++) { 
			_writeByte(_buffer[i] + (_colonState ? 0x80 : 0x00));
		}
		_stop();

		// Send the display command to draw the display at the requested brightness
		_start();
		_writeByte(GROVE_TM1637_DISPLAY_CMD + _brightness);
		_stop();
	}

	function _start() {
		// Signal the start of data input
		_clockPin.write(GROVE_TM1637_HIGH);
		_dataPin.write(GROVE_TM1637_HIGH);
		_dataPin.write(GROVE_TM1637_LOW);
		_clockPin.write(GROVE_TM1637_LOW);
	}

	function _stop() {
		// Signal the end of data input
		_clockPin.write(GROVE_TM1637_LOW);
		_dataPin.write(GROVE_TM1637_LOW);
		_clockPin.write(GROVE_TM1637_HIGH);
		_dataPin.write(GROVE_TM1637_HIGH);
	}

	function _writeByte(value) {
		// Send the byte as bits, least significant first and toggling the
		// clock pin (low to high) to signal that the data should be read
		for (local i = 0 ; i < 8 ; i++) {
			_clockPin.write(GROVE_TM1637_LOW);
			// Read bit 0 and send high or low accordingly
			_dataPin.write(value & 0x01 ? GROVE_TM1637_HIGH : GROVE_TM1637_LOW);
			// Shift the next into bit 0 for the next pass
			value = value >> 1;
			_clockPin.write(GROVE_TM1637_HIGH);
		}

		// Toggle the clock piun to trigger the TM1637's data ACK
		_clockPin.write(GROVE_TM1637_LOW);
		_clockPin.write(GROVE_TM1637_HIGH);
	}
}
