#include <avr/io.h>

int main(void)
{
	DDRD |= (1<<6);	//OC0A as output
	OCR0A = 192;	
	TCCR0A = (1<<COM0A1)|(1<<WGM01)|(1<<WGM00); //Fast PWM, non-inverted
	TCCR0B = 0x01; //no prescaler
    while(1);
}