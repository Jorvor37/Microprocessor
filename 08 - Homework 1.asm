;=============================================================
; Program: Generate 80kHz squarew wave on OC1A (PB1)
;
; Attach a screenshot of the oscilloscope showing the correct (to within +/- 5%) frequency.
; (84000-76000 Hz) frequency is allow
;=============================================================

MAIN:
        sbi DDRB, PB1           ; Set PB1 as output

        ldi R16, (1<<COM1A0)    ;Toggle OC1A on compare match
        sts TCCR1A, R16

        ldi R16, (1<<WGM12) | (1<<CS10)     ; CTC mode
        sts TCCR1B, R16         ; Timer 1 in CTC mode

        ; set OCR1A = 100
        ldi R16, 100
        sts OCR1AL, R16
        clr R16
        sts OCR1AH, R16

END:    
        rjmp END
    