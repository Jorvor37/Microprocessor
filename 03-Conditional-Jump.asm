// Example 2
SUB R26, R21
BRCS NEXT
INC R22
NEXT:

// Example 3


// Example 4
    .ORG 00
    LDI R16, 9      ;R16 = 9
L1: ADD R30, R31
    DEC R16         ;R16 = R16-1
    BRNE L1         ;if Z = 0 we will loop
L2: RJMP L2         ;if Z not 0 we goes into infinite loop to finish. It's might go to unknown state.

// Stack Example
ORG 0
LDI R16, HIGH(RAMEND)       ;load high bite of RAM END to R16
OUT SPH, R16
LDI R16, LOW(RAMEND)        ;load low bite of RAM END to R16
OUT SPL, R16
LDI R20, 0x10               ;load into last element
LDI R21, 0x20               ;
LDI R22, 0x30               ;
PUSH R20
PUSH R21
PUSH R22
POP R21
POP R0
POP R20
L1: RJMP L1

//Call Function
