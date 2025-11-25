    LDI R16, (1<<5) ; R16 = 0010 0000
    SBI DDRB, 5 ; DDRB = 0010 0000
    LDI R17, 0
BEGIN: LDI R20, 206
    OUT TCNT0, R20 ; load the counter register
    LDI R20, 0x0
    OUT TCCR0A, R20 ; load the control register with all 0's (select normal mode)
    LDI R20, 0x01
    OUT TCCR0B, R20 ; select clk with no prescaling
AGAIN: SBIS TIFR0, TOV0 ; skip the next instruction if the overflow is set
    RJMP AGAIN
    LDI R20, 0x0 
    OUT TCCR0B, R20 ; choose no clk to stop the count
    LDI R20, (1<<TOV0)
    OUT TIFR0, R20 ; load the overflow flag with ONE to clear it
    EOR R17, R16 ; toggle bit 5 of R17
    OUT PORTB, R17
    RJMP BEGIN
