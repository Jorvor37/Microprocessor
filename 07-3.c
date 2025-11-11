// toggle all bits of PORTB 200 times

#include <avr/io.h>    		

int main(void) 
{
	DDRB = 0xFF; // make PORTB output port     		
	PORTB = 0xAA; // initial value in PORTB			

	unsigned char z;

	for(z = 0; z < 200; z++)
	{
		PORTB = ~PORTB;
	}

	while(1);

	return 0;
}