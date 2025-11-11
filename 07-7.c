// toggle PORTB with some delay
// can run in Picsimlab, make sure to set clock speed = 1 MHz

// this line must come before include
#define F_CPU 1000000UL

#include <avr/io.h>
#include <util/delay.h>

int main() {
    DDRB = 0xFF; // make PORTB output port     		
	PORTB = 0xAA; // initial value in PORTB
    while(1) {
        PORTB = ~PORTB;
        _delay_ms(100);
    }
}