OUT DDRB, R20    ; Configure PORTB pins as outputs
OUT PORTB, R21   ; Send segment pattern to PORTB
IN R30, PINC    ; Read input from PORTC in binary format

; ===== Digits =====
LDI R20, 0x3F ; 0
LDI R21, 0x06 ; 1
LDI R22, 0x5B ; 2
LDI R23, 0x4F ; 3
LDI R24, 0x66 ; 4
LDI R25, 0x6D ; 5
LDI R26, 0x7D ; 6
LDI R27, 0x07 ; 7
LDI R28, 0x7F ; 8
LDI R29, 0x6F ; 9

; ===== Letters =====
LDI R30, 0x77 ; A
LDI R31, 0x7C ; B
LDI R16, 0x39 ; C
LDI R17, 0x5E ; D
LDI R18, 0x79 ; E
LDI R19, 0x71 ; F
LDI R8,  0x3D ; G
LDI R9,  0x76 ; H
LDI R10, 0x06 ; I
LDI R11, 0x1E ; J
LDI R12, 0x76 ; K (same as H)
LDI R13, 0x38 ; L
LDI R14, 0x15 ; M (approximation)
LDI R15, 0x54 ; N (approximation)
LDI R0,  0x3F ; O
LDI R1,  0x73 ; P
LDI R2,  0x67 ; Q
LDI R3,  0x50 ; R (approximation)
LDI R4,  0x6D ; S
LDI R5,  0x78 ; T
LDI R6,  0x3E ; U
LDI R7,  0x3E ; V (same as U)
LDI R8,  0x2A ; W (rough)
LDI R9,  0x76 ; X (same as H/K)
LDI R10, 0x6E ; Y
LDI R11, 0x5B ; Z
