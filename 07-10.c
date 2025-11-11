// example 8-10
// set and clear individual bits


#include <avr/io.h>    

int main(void) 
{	
	DDRB = 0xFF;

	while(1)
	{
		//toggle some number that I want to become 1(works for any number of bits)
		PORTB = PORTB | 0b00010000; // xxxx xxxx OR 0001 0000 = xxx1 xxxx
		//(clear)toggle some number that I want to become 0
		PORTB = PORTB & 0b11101111; // xxxx xxxx AND 1110 1111 = xxx0 xxxx
	} 

	return 0;
}