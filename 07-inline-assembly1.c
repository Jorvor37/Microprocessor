/*
 * This file demonstrates two things:
 * 1. A low-level delay function using inline assembly (`delay_asm_cycles`).
 * 2. The standard, correct way to implement delays (`_delay_ms`)
 */

#include <avr/io.h>

/**
 * @brief Creates a delay for a specific number of CPU cycles
 * using an inline assembly loop.
 *
 * This function is a low-level demonstration. Each loop of the
 * 'sbiw' and 'brne' takes exactly 4 CPU cycles.
 *
 * Total delay = count * 4 cycles.
 *
 * @param count The number of 4-cycle loops to execute.
 * This is a uint16_t, so the max delay is
 * 65535 * 4 = 262,140 cycles.
 */
void delay_asm_cycles(uint16_t count) {
    // This is the core inline assembly block
    asm volatile (
        // "1:" is a local label for our loop
        "1: \n\t"
        
        // sbiw: Subtract Immediate from Word.
        // This subtracts '1' from the 16-bit register pair %0.
        // Takes 2 CPU cycles.
        "sbiw %0, 1 \n\t"
        
        // brne: Branch if Not Equal (to zero)
        // Jumps back to label "1b" ("b" means "backwards") if the
        // result of 'sbiw' was not zero.
        // Takes 2 CPU cycles when the branch is taken.
        "brne 1b \n\t"

        // === Operand Constraints ===
        // We put the read-write operand in the "output" section.
        // The '+' means it is both read and written to.
        // The 'w' constraint tells gcc to use a 16-bit "word"
        // register pair (e.g., r24:r25) for the 'count' variable.
        : "+w" (count)
        
        // No "pure" input operands (the 2nd section).
        :
        
        // No "clobbers" (the 3rd section), because the "+w"
        // constraint already tells the compiler everything
        // it needs to know about which registers are being used.
        :
    );
}


/*
 * ===================================================================
 * THE STANDARD (CORRECT) WAY
 * ===================================================================
 *
 * While the function above *works*, you should almost always
 * use the built-in delay functions from the avr-libc library.
 *
 * They are more robust, more accurate, and handle all the
 * calculations for you.
 *
 * To use them:
 * 1. Define F_CPU (your CPU clock speed) *before* including the header.
 * 2. Include <util/delay.h>
 * 3. Call _delay_ms() or _delay_us()
 */

// 1. Define F_CPU. This MUST be defined before the include.
// Let's assume a 16MHz clock (e.g., standard Arduino Uno)
#define F_CPU 16000000UL

#include <util/delay.h> // 2. Include the library

/**
 * Main application entry point.
 * This example will blink an LED connected to PORTB, pin 5 (PB5).
 */
int main(void) {
    // Set PORTB pin 5 (PB5) as an output
    DDRB |= (1 << DDB5);

    while (1) {
        // --- Using our assembly function ---
        // Let's calculate the 'count' for a 500ms (0.5s) delay
        // F_CPU = 16,000,000 cycles/sec
        // Cycles for 500ms = 16,000,000 * 0.5 = 8,000,000 cycles
        // Our loop is 4 cycles, so count = 8,000,000 / 4 = 2,000,000
        //
        // *** PROBLEM ***: 2,000,000 is larger than a uint16_t (65535)!
        // This is a key limitation of this simple loop.
        //
        // The max delay at 16MHz is 262,140 cycles = ~16.4 milliseconds.
        //
        // This is why the standard _delay_ms() is better.
        // It uses nested loops to handle large delays.
        

        // --- Using the STANDARD library function ---
        
        // Turn LED on (Set PB5 high)
        PORTB |= (1 << PORTB5);

        // 3. Call the standard function
        _delay_ms(500); // Wait for 500 milliseconds

        // Turn LED off (Clear PB5 low)
        PORTB &= ~(1 << PORTB5);

        // Wait for another 500 milliseconds
        _delay_ms(500);
    }

    return 0; // Will never be reached
}