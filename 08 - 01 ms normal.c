#include <avr/io.h>

int main() {
    DDRB = 1<<5; // set bit 5
    PORTB &= ~(1<<5); // clear bit 5
    while (1) {
        TCNT0 = 206; // load counter
        TCCR0A = 0x00; // choose mode
        TCCR0B = 0x01; // clk no prescaling
        while ((TIFR0&(1<<TOV0)) == 0) // while TOV0 not set  0000 0001 & 0000 0001        
        {}
        TCCR0B = 0; // no clk, stop count
        TIFR0 = (1<<TOV0); // set TOV0 to CLEAR it
        PORTB ^= (1<<5); // toggle PB.5
    }
}