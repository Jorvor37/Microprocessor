// example 8-9
// logic operations

#include <avr/io.h>		

int main ()
{
	DDRB = 0xFF;		
	DDRC = 0xFF;		
	DDRD = 0xFF;		

	PORTB = 0x35 & 0x0F; //AND   0011 0101 & 0000 1111 = 0000 0101
	PORTC = 0x04 | 0x68; //OR    0000 0100 | 0110 1000 = 0110 1100
	PORTD = 0x54 ^ 0x78; //XOR   0101 0100 ^ 0111 1000 = 0010 1100
	PORTB = ~0x55; // NOT		 0101 0101 = 1010 1010
	while(1);
	return 0;
}