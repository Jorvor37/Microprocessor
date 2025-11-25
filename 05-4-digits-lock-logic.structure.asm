;START:
;  Initialize ports (LCD, Keypad, LEDs)
;  Display "Enter Passcode"
;
;MAIN_LOOP:
;  Wait for 4 key presses (store in memory)
;  Compare input with stored passcode
;  If match → call UNLOCK
;  If not match → increment attempt count
;       If attempts < 3 → go back to MAIN_LOOP
;       If attempts == 3 → call LOCKDOWN
;  Repeat

; reserve memory for variables in SRAM:
.def temp = r16
.def counter = r17
.def attempts = r18

.dseg
passcode: .byte 4       ; Predefined password = 1,2,3,4
inputbuf: .byte 4       ; User input storage

; load the password
ldi r16, 1
sts passcode, r16       ; Store Direct to Data Space (It tells the CPU: “Take the value in register r16 and store it into the SRAM address labeled passcode.”)
ldi r16, 2
sts passcode+1, r16
ldi r16, 3
sts passcode+2, r16
ldi r16, 4
sts passcode+3, r16

; set up I/O
; PORTC – Keypad: lower nibble output (rows), upper nibble input (cols)
ldi temp, 0x0F
out DDRC, temp          ; Data Direction Register for Port C     Purpose: It sets whether each pin is an input (0) or output (1).

; PORTD – LCD control/data pins as output
ldi temp, 0xFF
out DDRD, temp

; PORTB – LEDs output
ldi temp, 0x03
out DDRB, temp

; Turn off both LEDs initially
ldi temp, 0x00
out PORTB, temp

ReadKey:
    ; r19 = key value
    ; PORTC lower nibble outputs, upper nibble inputs

ScanRow1:
    ldi temp, 0xFE        ; Row 1 low (PC0 = 0)
    out PORTC, temp
    in temp, PINC
    andi temp, 0xF0       ; Mask columns
    cpi temp, 0xE0
    breq Key1
    cpi temp, 0xD0
    breq Key2
    cpi temp, 0xB0
    breq Key3
    cpi temp, 0x70
    breq KeyA
; Repeat for Row2, Row3, Row4...
ret

Key1:  ldi r19, 1  ; Return key = 1
       ret
Key2:  ldi r19, 2
       ret
Key3:  ldi r19, 3
       ret
KeyA:  ldi r19, 10
       ret

; Compare Entered Code to Stored Password
CheckCode:
    ldi ZH, high(passcode)
    ldi ZL, low(passcode)
    ldi YH, high(inputbuf)
    ldi YL, low(inputbuf)
    ldi counter, 4

CompareLoop:
    ld temp, Z+
    ld r20, Y+
    cp temp, r20
    brne NotMatch
    dec counter
    brne CompareLoop
    rjmp Match

NotMatch:
    inc attempts
    cpi attempts, 3
    brlo TryAgain
    rjmp Lockdown

Match:
    rjmp Unlock

TryAgain:
    rjmp MainLoop

;Unlock or Lockdown
Unlock:
    rcall LCD_Clear
    rcall LCD_DisplayGranted
    sbi PORTB, 1          ; Turn on GREEN LED
    rcall Delay10s
    cbi PORTB, 1          ; Turn off GREEN LED
    clr attempts
    rjmp MainLoop

Lockdown:
    rcall LCD_Clear
    rcall LCD_DisplayLocked

    ldi counter, 60
LockBlink:
    sbi PORTB, 0
    rcall Delay500ms
    cbi PORTB, 0
    rcall Delay500ms
    dec counter
    brne LockBlink

    clr attempts
    rjmp MainLoop

Delay500ms:
    ldi r20, 100
D1: ldi r21, 250
D2: dec r21
    brne D2
    dec r20
    brne D1
    ret

Delay10s:
    ldi counter, 20
D3: rcall Delay500ms
    dec counter
    brne D3
    ret

LCD_Command:
    ; send instruction to PORTD
    ; toggle EN bit high-low
    ret

LCD_Data:
    ; send ASCII data to LCD
    ret

LCD_Clear:
    ; send 0x01 command
    ret

LCD_DisplayGranted:
    ; send string “Access Granted”
    ret

LCD_DisplayDenied:
    ; send string “Access Denied”
    ret

LCD_DisplayLocked:
    ; send string “System Locked”
    ret


