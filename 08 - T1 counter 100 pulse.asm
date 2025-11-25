    CBI DDRD, 5 ; make PD5 input pin (clear DDR PD5, pin PD5 is T1)
    SBI DDRC, 0 ; make PC0 output pin (set DDR PC0)

    LDI R20, 0x00
    STS TCCR1A, R20 ; choose counter mode, write 0x00 to control A
    LDI R20, 0x0E
    STS TCCR1B, R20 ; choose counter mode, write 0x0E to control B (pin T1 is the clock source, counts on falling edge)

AGAIN:
    LDI R20, 0
    STS OCR1AH, R20
    LDI R20, 99
    STS OCR1AL, R20 ; write 99 to compare register A

L1: 
    SBIS TIFR1, OCF1A ; skip the next instruction if the output compare flag A is set (counter is the same as the compare register)
    RJMP L1
    LDI R20, 1<<OCF1A ; didn't skip the previous instruction, so the counting was done
    OUT TIFR1, R20 ; clear the output compare flag

    SBI PORTC, 0 ; make low-to-high pulse at pin PC0
    CBI PORTC, 0
    RJMP AGAIN
