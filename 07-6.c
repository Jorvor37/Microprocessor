// the volatile keyword
// make delay of 100ms when the clock speed is 16 MHz

#include <avr/io.h>    

void delay100ms(void);			

int main(void) 
{
	
	DDRB = 0xFF;    	
	while (1) 
	{
		PORTB = 0xAA;
		delay100ms();
		PORTB = 0x55;
		delay100ms();	
	} 
	return 0;
}

void delay100ms(void)
{
  volatile unsigned long i; // force the compiler to not optimize this variable
  for(i = 0; i < 47060; i++);	
}