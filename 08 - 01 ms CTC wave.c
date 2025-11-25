#include <avr/io.h>

int main ( )
{
	DDRB |= 1<<3; // set PB3 as an output
    while(1) {
        OCR0A = 49; // value to count up to
        TCCR0A = (1<<WGM01); // choose CTC mode
        TCCR0B = 1; // clk with no prescaling
        while( (TIFR0 & (1<<OCF0A)) == 0 ) // same as (TIFR0 & (b00000010)) == 0
        {}
        TCCR0B = 0; // stop timer0
        TIFR0 = 1<<OCF0A; // clear the flag
        PORTB ^= 1<<3; // toggle PB3
    }
	return 0;
}
