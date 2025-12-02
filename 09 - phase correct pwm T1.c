#include <avr/io.h>

int main(void)
{
	DDRB |= (1<<1);	// PB1
	OCR1A = 0x2FF; // 75% duty	
	TCCR1A = 0x83; //phase correct PWM, non-inverted
	TCCR1B = 0x01; //no prescaler
    while(1);
}