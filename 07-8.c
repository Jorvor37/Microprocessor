// example 8-8
// read PORTB and forward the value to PORTC

#include <avr/io.h>    			

int main(void) 
{
	unsigned char temp;
	
	DDRB = 0x00;			
	DDRC = 0xFF;			

	while(1)
	{
		temp = PINB;
		PORTC = temp;
	} 
	return 0;
}