    LDI R16, HIGH(RAMEND)
    OUT SPH, R16
    LDI R16, LOW(RAMEND)
    OUT SPL, R16
    SBI DDRB, 5 ; PB5 as an output

BEGIN: SBI PORTB, 5 ; PB5 = 1
    RCALL DELAY_1ms
    CBI PORTB, 5 ; PB5 = 0
    RCALL DELAY_1ms
    RJMP BEGIN

DELAY_1ms:

    ; initialize value in the counter
    LDI R20, 0x00
    STS TCNT1H, R20 
    STS TCNT1L, R20

    ; initialize the compare register
    ; we want to count 10000 cycles
    ; 10000 = 0x2710
    ; we count from 0 to 9999, so load the value of 0x2710 - 1 = 0x270F
    LDI R20, 0x27
    STS OCR1AH, R20
    LDI R20, 0x0F
    STS OCR1AL, R20

    ; select CTC mode and no prescaling
    LDI R20, 0x00
    STS TCCR1A, R20
    LDI R20, 0x09
    STS TCCR1B, R20

AGAIN:
    SBIS TIFR1, OCF1A
    RJMP AGAIN

    ; stop counting
    LDI R19, 0
    STS TCCR1B, R19 
    STS TCCR1A, R19

    ; reset the compare flag
    LDI R20, 1<<OCF1A
    OUT TIFR1, R20
    RET