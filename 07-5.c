// toggle PORTB 50,000 times

#include <avr/io.h>    

int main(void) 
{	
  unsigned int z;
	
	DDRB = 0xFF;    

  for(z=0;z<50000;z++)
  {
    PORTB = 0x55;
    PORTB = 0xAA;
  }

  while(1);
	return 0;
}