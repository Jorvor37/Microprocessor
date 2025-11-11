// example 8-11
// program to monitor PORTB.1 and turn PORTC.5 on if PORTB.1 is HIGH


#include <avr/io.h>    		

int main(void) 
{
	DDRB = DDRB & 0b11111101; // PB.1 is input			
	DDRC = DDRC | 0b00100000; // PC.7 is output			
	
	while(1)
	{
		if((PINB & 0b00000010) != 0) // case1: 0000 0010 & 0000 0010 = 0000 0010 = 2    case2: 0000 0000 & 0000 0010 = 0000 0000 = 0
			PORTC = PORTC |0b00100000;	
		else
			PORTC = PORTC & 0b11011111;	
	} 

	return 0;
}
