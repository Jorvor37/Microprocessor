/*
 * This file demonstrates a more complex inline assembly function
 * that uses the "clobber" list.
 *
 * We will create a function to swap the values of two variables
 * directly in memory, using assembly.
 */

#include <avr/io.h>

// 1. Define F_CPU for delay functions
#define F_CPU 16000000UL

#include <util/delay.h>

/**
 * @brief Swaps the 8-bit values pointed to by 'a' and 'b'.
 *
 * This function is a classic example of using the clobber list.
 * We tell the compiler to load the pointers 'a' and 'b' into
 * specific registers (Z and X), then we use other "scratch"
 * registers (r16, r17) to perform the swap.
 *
 * We must "clobber" r16, r17, and "memory" to do this safely.
 *
 * @param a Pointer to the first 8-bit value.
 * @param b Pointer to the second 8-bit value.
 */
void swap_bytes_asm(uint8_t* a, uint8_t* b) {
    // This is the core inline assembly block
    asm volatile (
        // 1. Load the value from address 'a' (in Z) into r16
        "ld r16, Z \n\t"
        
        // 2. Load the value from address 'b' (in X) into r17
        "ld r17, X \n\t"
        
        // 3. Store r17 (value from *b) into address 'a' (in Z)
        "st Z, r17 \n\t"
        
        // 4. Store r16 (value from *a) into address 'b' (in X)
        "st X, r16 \n\t"

        // === Operand Constraints ===
        
        // Output Operands: None.
        // We are not returning a value to a C variable. We are
        // changing memory *indirectly*.
        :
        
        // Input Operands:
        // "%0" (a): Use the 'z' constraint (the Z-register, r30:r31)
        // "%1" (b): Use the 'x' constraint (the X-register, r26:r27)
        // When using 'z' and 'x', we use 'Z' and 'X' in the
        // assembly string.
        : "z" (a), "x" (b)
        
        // Clobber List:
        // This is the most important part of this example.
        // 1. "r16", "r17": We tell the compiler we used r16 and r17
        //    as temporary scratch pads. This forces the compiler
        //    to save/restore them if it was using them.
        // 2. "memory": This is a *critical* clobber.
        //    - It tells the compiler "this code block changed RAM."
        //    - This prevents an bug where the compiler might *think*
        //      it knows what's in *a and *b, but it's wrong.
        //    - This forces the compiler to re-read *a and *b from
        //      memory the next time they are used in C.
        : "r16", "r17", "memory"
    );
}

/**
 * @brief Delays for a variable number of milliseconds.
 *
 * NOTE: The standard _delay_ms() requires a compile-time constant.
 * This function provides a workaround by calling _delay_ms(1)
 * in a loop.
 *
 * @param ms The number of milliseconds to delay.
 */
void variable_delay_ms(uint16_t ms) {
    while (ms > 0) {
        _delay_ms(1);
        ms--;
    }
}


/**
 * Main application entry point.
 * This example will blink an LED at two different speeds,
 * then swap those speeds using our assembly function.
 */
int main(void) {
    // Set PORTB pin 5 (PB5) as an output
    DDRB |= (1 << DDB5);

    // Our two delay periods
    uint16_t delay_a = 100; // 100ms
    uint16_t delay_b = 600; // 600ms

    while (1) {
        // --- Blink using 'delay_a' (fast) ---
        PORTB |= (1 << PORTB5);  // LED on
        variable_delay_ms(delay_a);
        PORTB &= ~(1 << PORTB5); // LED off
        variable_delay_ms(delay_a);

        // --- Blink using 'delay_b' (slow) ---
        PORTB |= (1 << PORTB5);  // LED on
        variable_delay_ms(delay_b);
        PORTB &= ~(1 << PORTB5); // LED off
        variable_delay_ms(delay_b);

        // --- Now, swap the values ---
        // Our function expects 8-bit (uint8_t) pointers.
        // Our delays are 16-bit (uint16_t).
        // This is a bit tricky, but we can swap the
        // low and high bytes of each variable.
        
        // This is an advanced C technique called "type punning".
        // We are "lying" to the compiler, telling it to treat
        // our 16-bit variables as arrays of 8-bit bytes.
        uint8_t* a_bytes = (uint8_t*) &delay_a;
        uint8_t* b_bytes = (uint8_t*) &delay_b;
        
        // Swap the low bytes (at offset 0)
        swap_bytes_asm( &a_bytes[0], &b_bytes[0] );

        // Swap the high bytes (at offset 1)
        swap_bytes_asm( &a_bytes[1], &b_bytes[1] );
        
        // After this, the C variable 'delay_a' will hold 600
        // and 'delay_b' will hold 100.
        // The loop will now blink slow, then fast.
    }

    return 0; // Will never be reached
}