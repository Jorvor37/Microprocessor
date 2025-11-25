    cbi ddrd, 4           ; Set PD4 as input
    sbi portd, 4          ; Enable pull-up resistor on PD4
    ldi r20, 0xff
    out ddrc, r20         ; Set PORTC as output
    ldi r20, 0x00
    out tccr0a, r20       ; Normal mode for Timer0
    ldi r20, 0x06
    out tccr0b, r20       ; External clock source on T0 pin, clock on falling edge
again:
    in r20, tcnt0
    out portc, r20    ; Output TCNT0 value to PORTC
    rjmp again