;=============================================================
; Program: Toggle PB3 using Timer0 in CTC mode

; Description:
;   - PB3 is configured as an output.
;   - Timer0 is set to CTC mode with OCR0A as the compare value.
;   - When the compare match flag (OCF0A) is set, the program:
;       * stops Timer0
;       * clears the OCF0A flag
;       * toggles PB3
;       * restarts Timer0
;
; Result: PB3 toggles continuously at a rate determined by OCR0A.
;=============================================================

    LDI R16, (1<<3)
    SBI DDRB, 3
    LDI R17, 0
    OUT PORTB, R17
    LDI R20, 38
    OUT OCR0A, R20
BEGIN: LDI R20, (1<<WGM01)
    OUT TCCR0A, R20
    LDI R20, 1
    OUT TCCR0B, R20
AGAIN: SBIS TIFR0, OCF0A
    RJMP AGAIN
    LDI R20, 0x0
    OUT TCCR0B, R20
    LDI R20, 1<<OCF0A
    OUT TIFR0, R20
    EOR R17,R16
    OUT PORTB, R17
    RJMP BEGIN                           // 2 cycle