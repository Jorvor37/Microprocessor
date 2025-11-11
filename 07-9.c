// example 8-9
// logic operations

#include <avr/io.h>		

int main ()
{
	DDRB = 0xFF;		
	DDRC = 0xFF;		
	DDRD = 0xFF;		

	PORTB = 0x35 & 0x0F; //AND
	PORTC = 0x04 | 0x68; //OR
	PORTD = 0x54 ^ 0x78; // XOR
	PORTB = ~0x55; // NOT		

	while(1);
	return 0;
}