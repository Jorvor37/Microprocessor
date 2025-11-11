// send HEX values of characters 0,1,2,3,4,5,A,B,C,D to PORTB

#include <avr/io.h>    			

int main(void) 
{
	unsigned char myList[]= "012345ABCD";
	unsigned char z ;			 
	DDRB = 0xFF; // make PORTB output port    			
	for( z = 0; z < 10; z++)
		PORTB = myList[z] ;

	while(1);		
	return 0;
}