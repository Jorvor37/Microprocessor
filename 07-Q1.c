#define F_CPU 1000000UL

#include <avr/io.h>
#include <util/delay.h>

int main(void) {
	DDRD = 0xFF;
	unsigned char i;
	while(1){
		for(i = 0; i < 32; i++){
			PORTD = i;
			_delay_ms(250);
		}
		_delay_ms(1000);
		for(i = 32; i > 0; i--){
			PORTD = i;
			_delay_ms(250);
		}
	}
}