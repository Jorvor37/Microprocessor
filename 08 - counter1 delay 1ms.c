#include <avr/io.h>

void delay1ms(); // clk frequency is 10 MHz

int main ( )
{
	DDRB |= 1 << 5; // PB5 is output
    while(1) {
        delay1ms();
        PORTB ^= (1<<5); // toggle PB5
    }
	return 0;
}

void delay1ms() {
    TCNT1 = 0; // initialize counter
    OCR1A = 10000-1; // count from 0-9999
    TCCR1A = 0; // set CTC and no prescaling
    TCCR1B = 0x09;

    while((TIFR1&(1<<OCF1A))==0)
    {}
    TCCR1B = 0; // stop counting
    TIFR1 = 1<<OCF1A; // clear the compare flag
}