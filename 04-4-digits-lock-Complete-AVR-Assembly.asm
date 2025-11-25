;=================================================================
;  AVR Password Door Lock (4x4 Keypad + 16x2 LCD)
;  Target: ATmega328P, 8MHz
;=================================================================
.include "m328pdef.inc"

.def temp = r16
.def col  = r17
.def row  = r18
.def i    = r19
.def attempts = r20
.def key = r21
.def match = r22

.dseg
passcode: .byte 4
inputbuf: .byte 4

.cseg
.org 0x0000
rjmp RESET

;-----------------------------------------------------------------
; Initialization
;-----------------------------------------------------------------
RESET:
    ldi temp, LOW(RAMEND)
    out SPL, temp
    ldi temp, HIGH(RAMEND)
    out SPH, temp

    ; Initialize passcode "1234"
    ldi ZH, HIGH(passcode)
    ldi ZL, LOW(passcode)
    ldi temp, '1'
    st Z+, temp
    ldi temp, '2'
    st Z+, temp
    ldi temp, '3'
    st Z+, temp
    ldi temp, '4'
    st Z+, temp

    ; Ports
    ldi temp, 0x0F
    out DDRD, temp       ; PD0–3 rows output, PD4–7 input
    ldi temp, 0xF0
    out PORTD, temp      ; pull-ups on columns

    ldi temp, 0xFF
    out DDRB, temp       ; LCD control+data as output
    ldi temp, 0x03
    out DDRC, temp       ; PC0, PC1 = LED outputs

    ; LCD init
    rcall LCD_INIT

    clr attempts
MAIN_LOOP:
    rcall GET_4_KEYS
    rcall CHECK_CODE
    cpi match, 1
    breq ACCESS_OK
    inc attempts
    cpi attempts, 3
    brlo TRY_AGAIN
LOCKDOWN:
    rcall LCD_LOCK_MSG
    sbi PORTC, 1         ; red LED on
    rcall DELAY_30S
    cbi PORTC, 1
    clr attempts
    rjmp MAIN_LOOP

TRY_AGAIN:
    rcall LCD_DENY_MSG
    rjmp MAIN_LOOP

ACCESS_OK:
    rcall LCD_GRANT_MSG
    sbi PORTC, 0         ; green LED on
    rcall DELAY_10S
    cbi PORTC, 0
    clr attempts
    rjmp MAIN_LOOP

;-----------------------------------------------------------------
; GET_4_KEYS: read 4 keys into inputbuf
;-----------------------------------------------------------------
GET_4_KEYS:
    ldi i, 0
READ_NEXT:
    rcall GET_KEY
    sts inputbuf+i, key
    inc i
    cpi i, 4
    brlo READ_NEXT
    ret

;-----------------------------------------------------------------
; GET_KEY: waits until one key pressed and released
;-----------------------------------------------------------------
GET_KEY:
WAIT_RELEASE:
    sbis PIND,4
    sbis PIND,5
    sbis PIND,6
    sbis PIND,7
    rjmp WAIT_RELEASE

SCAN_LOOP:
    ldi row, 0x01
NEXT_ROW:
    out PORTD, row
    nop
    in temp, PIND
    andi temp, 0xF0
    cpi temp, 0xF0
    brne FOUND_COL
    lsl row
    cpi row, 0x10
    brne NEXT_ROW
    rjmp SCAN_LOOP

FOUND_COL:
    ; Determine which key (simple demo mapping)
    ldi key, '1'         ; (replace with lookup table later)
    ret

;-----------------------------------------------------------------
; CHECK_CODE: compare passcode vs inputbuf
;-----------------------------------------------------------------
CHECK_CODE:
    ldi ZH, HIGH(passcode)
    ldi ZL, LOW(passcode)
    ldi YH, HIGH(inputbuf)
    ldi YL, LOW(inputbuf)
    ldi i, 4
    ldi match, 1
CMP_LOOP:
    ld temp, Z+
    ld col, Y+
    cp temp, col
    brne NOT_MATCH
    dec i
    brne CMP_LOOP
    ret
NOT_MATCH:
    clr match
    ret

;-----------------------------------------------------------------
; LCD SUBROUTINES (4-bit)
;-----------------------------------------------------------------
LCD_INIT:
    rcall DELAY_MS
    ret

LCD_CMD:
    ; send command in temp
    ret

LCD_DATA:
    ; send data in temp
    ret

LCD_GRANT_MSG:
    rcall LCD_CLEAR
    ldi ZL, LOW(MSG_OK*2)
    ldi ZH, HIGH(MSG_OK*2)
DISP_OK:
    lpm temp, Z+
    cpi temp, 0
    breq DISP_END
    rcall LCD_DATA
    rjmp DISP_OK
DISP_END:
    ret

LCD_DENY_MSG:
    rcall LCD_CLEAR
    ldi ZL, LOW(MSG_DENY*2)
    ldi ZH, HIGH(MSG_DENY*2)
DISP_DENY:
    lpm temp, Z+
    cpi temp, 0
    breq DISP_END
    rcall LCD_DATA
    rjmp DISP_DENY

LCD_LOCK_MSG:
    rcall LCD_CLEAR
    ldi ZL, LOW(MSG_LOCK*2)
    ldi ZH, HIGH(MSG_LOCK*2)
DISP_LOCK:
    lpm temp, Z+
    cpi temp, 0
    breq DISP_END
    rcall LCD_DATA
    rjmp DISP_LOCK

LCD_CLEAR:
    ret

;-----------------------------------------------------------------
; Delay routines (rough software loops)
;-----------------------------------------------------------------
DELAY_MS:
    ldi temp, 255
DL1: dec temp
    brne DL1
    ret

DELAY_10S:
    ldi i, 100
DL10: rcall DELAY_MS
    dec i
    brne DL10
    ret

DELAY_30S:
    ldi i, 300
DL30: rcall DELAY_MS
    dec i
    brne DL30
    ret

;-----------------------------------------------------------------
; Message constants
;-----------------------------------------------------------------
MSG_OK:   .db "ACCESS GRANTED",0
MSG_DENY: .db "ACCESS DENIED",0
MSG_LOCK: .db "SYSTEM LOCKED",0
;=================================================================
