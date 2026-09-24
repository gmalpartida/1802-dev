    .area _CODE (REL,CON)

MAIN: 
    DIS                 ; Disable interrupts
    LDI   #>BLINK     ; Shift right 8 bits to extract the High Byte
    PHI   R3                
    LDI   #<BLINK   ; Mask with 0xFF to extract the Low Byte
    PLO   R3                
    
    SEP   R3                ; Set Program Counter to R3 (jumps to BLINK) 
    
BLINK: 
    SEQ                     ; Set Q line HIGH
    REQ                     ; Reset Q line LOW
    BR    BLINK             ; Loop forever
    
    .END

	.area _DATA(REL, CON)
