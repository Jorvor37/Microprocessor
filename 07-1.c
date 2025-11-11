// write the value 00-FF to PORTB
#include <avr/io.h>    			

int main(void) 
{
	char z ; // 8-bit datatype			 
	DDRB = 0xFF; // make PORTB output port    		
	for( z=0; z <= 255; z++)
		PORTB = z ;

	while(1);					
	return 0;
}