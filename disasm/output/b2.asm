.INCLUDE "snes.cfg"
.BANK 2


DATA_028000:        .db $80,$40,$20,$10,$08,$04,$02,$01

ADDR_028008:        PHX                       
                    LDA.W $0DC2               
                    BEQ ADDR_028070           
                    STZ.W $0DC2               
                    PHA                       
                    LDA.B #$0C                
                    STA.W $1DFC               ; / Play sound effect 
                    LDX.B #$0B                
ADDR_028019:        LDA.W $14C8,X             
                    BEQ ADDR_028042           
                    DEX                       
                    BPL ADDR_028019           
                    DEC.W $1861               
                    BPL ADDR_02802B           
                    LDA.B #$01                
                    STA.W $1861               
ADDR_02802B:        LDA.W $1861               
                    CLC                       
                    ADC.B #$0A                
                    TAX                       
                    LDA $9E,X                 
                    CMP.B #$7D                
                    BNE ADDR_028042           
                    LDA.W $14C8,X             
                    CMP.B #$0B                
                    BNE ADDR_028042           
                    STZ.W $13F3               
ADDR_028042:        LDA.B #$08                
                    STA.W $14C8,X             
                    PLA                       
                    CLC                       
                    ADC.B #$73                
                    STA $9E,X                 
                    JSL.L ADDR_07F7D2         
                    LDA.B #$78                
                    CLC                       
                    ADC $1A                   
                    STA $E4,X                 
                    LDA $1B                   
                    ADC.B #$00                
                    STA.W $14E0,X             
                    LDA.B #$20                
                    CLC                       
                    ADC $1C                   
                    STA $D8,X                 
                    LDA $1D                   
                    ADC.B #$00                
                    STA.W $14D4,X             
                    INC.W $1534,X             
ADDR_028070:        PLX                       
                    RTL                       ; Return 


BombExplosionX:     .db $00,$08,$06,$FA,$F8,$06,$08,$00
                    .db $F8,$FA

BombExplosionY:     .db $F8,$FE,$06,$06,$FE,$FA,$02,$08
                    .db $02,$FA

ADDR_028086:        JSR.W ADDR_02808A         
                    RTL                       ; Return 

ADDR_02808A:        STZ.W $1656,X             
                    LDA.B #$11                
                    STA.W $1662,X             
                    JSR.W GetDrawInfo2        
                    LDA $9D                   
                    BNE ADDR_02809C           
                    INC.W $1570,X             
ADDR_02809C:        LDA.W $1540,X             
                    BNE ADDR_0280A5           
                    STZ.W $14C8,X             
                    RTS                       ; Return 

ADDR_0280A5:        LDA.W $1540,X             
                    LSR                       
                    AND.B #$03                
                    CMP.B #$03                
                    BNE ADDR_0280C0           
                    JSR.W ADDR_028139         
                    LDA.W $1540,X             
                    SEC                       
                    SBC.B #$10                
                    CMP.B #$20                
                    BCS ADDR_0280C0           
                    JSL.L MarioSprInteract    
ADDR_0280C0:        LDY.B #$04                
                    STY $0F                   
ADDR_0280C4:        LDA.W $1540,X             
                    LSR                       
                    PHA                       
                    AND.B #$03                
                    STA $02                   
                    LDA $E4,X                 
                    SEC                       
                    SBC $1A                   
                    CLC                       
                    ADC.B #$04                
                    STA $00                   
                    LDA $D8,X                 
                    SEC                       
                    SBC $1C                   
                    CLC                       
                    ADC.B #$04                
                    STA $01                   
                    LDY $0F                   
                    PLA                       
                    AND.B #$04                
                    BEQ ADDR_0280ED           
                    TYA                       
                    CLC                       
                    ADC.B #$05                
                    TAY                       
ADDR_0280ED:        LDA $00                   
                    CLC                       
                    ADC.W BombExplosionX,Y    
                    STA $00                   
                    LDA $01                   
                    CLC                       
                    ADC.W BombExplosionY,Y    
                    STA $01                   
                    DEC $02                   
                    BPL ADDR_0280ED           
                    LDA $0F                   
                    ASL                       
                    ASL                       
                    ADC.W $15EA,X             
                    TAY                       
                    LDA $00                   
                    STA.W $0300,Y             
                    LDA $01                   
                    STA.W $0301,Y             
                    LDA.B #$BC                
                    STA.W $0302,Y             
                    LDA $13                   
                    LSR                       
                    LSR                       
                    AND.B #$03                
                    SEC                       
                    ROL                       
                    ORA $64                   
                    STA.W $0303,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$00                
                    STA.W $0460,Y             
                    DEC $0F                   
                    BPL ADDR_0280C4           
                    LDY.B #$00                
                    LDA.B #$04                
                    JMP.W ADDR_02B7A7         
ADDR_028139:        LDY.B #$09                
ADDR_02813B:        CPY.W $15E9               
                    BEQ ADDR_02814C           
                    PHY                       
                    LDA.W $14C8,Y             
                    CMP.B #$08                
                    BCC ADDR_02814B           
                    JSR.W ADDR_028150         
ADDR_02814B:        PLY                       
ADDR_02814C:        DEY                       
                    BPL ADDR_02813B           
                    RTS                       ; Return 

ADDR_028150:        PHX                       
                    TYX                       
                    JSL.L ADDR_03B6E5         
                    PLX                       
                    JSL.L ADDR_03B69F         
                    JSL.L ADDR_03B72B         
                    BCC ADDR_028177           
                    LDA.W $167A,Y             
                    AND.B #$02                
                    BNE ADDR_028177           
                    LDA.B #$02                
                    STA.W $14C8,Y             
                    LDA.B #$C0                
                    STA.W $00AA,Y             
                    LDA.B #$00                
                    STA.W $00B6,Y             
ADDR_028177:        RTS                       ; Return 


DATA_028178:        .db $F8,$38,$78,$B8,$00,$10,$20,$D0
                    .db $E0,$10,$40,$80,$C0,$10,$10,$20
                    .db $B0,$20,$50,$60,$C0,$F0,$80,$B0
                    .db $20,$60,$A0,$E0,$70,$F0,$70,$B0
                    .db $F0,$10,$20,$50,$60,$90,$A0,$D0
                    .db $E0,$10,$20,$50,$60,$90,$A0,$D0
                    .db $E0,$10,$20,$50,$60,$90,$A0,$D0
                    .db $E0,$50,$60,$C0,$D0,$30,$40,$70
                    .db $80,$B0,$C0,$30,$40,$70,$80,$B0
                    .db $C0,$40,$50,$80,$90,$C8,$D8,$30
                    .db $40,$A0,$B0,$58,$68,$B0,$C0

DATA_0281CF:        .db $70,$70,$70,$70,$20,$20,$20,$20
                    .db $20,$30,$30,$30,$30,$70,$80,$80
                    .db $80,$90,$90,$90,$A0,$50,$60,$60
                    .db $70,$70,$70,$70,$60,$60,$70,$70
                    .db $70,$40,$40,$40,$40,$40,$40,$40
                    .db $40,$50,$50,$50,$50,$50,$50,$50
                    .db $50,$60,$60,$60,$60,$60,$60,$60
                    .db $60,$30,$30,$30,$30,$48,$48,$48
                    .db $48,$48,$48,$58,$58,$58,$58,$58
                    .db $58,$70,$70,$78,$78,$70,$70,$80
                    .db $80,$88,$88,$A0,$A0,$A0,$A0

DATA_028226:        .db $E8,$E8,$E8,$E8,$E4,$E4,$E4,$E4
                    .db $E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4
                    .db $E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4
                    .db $E4,$E4,$E4,$E4,$EE,$EE,$EE,$EE
                    .db $EE,$C0,$C2,$C0,$C2,$C0,$C2,$C0
                    .db $C2,$E0,$E2,$E0,$E2,$E0,$E2,$E0
                    .db $E2,$C4,$A4,$C4,$A4,$C4,$A4,$C4
                    .db $A4,$CC,$CE,$CC,$CE,$C8,$CA,$C8
                    .db $CA,$C8,$CA,$CA,$C8,$CA,$C8,$CA
                    .db $C8,$CC,$CE,$CC,$CE,$CC,$CE,$CC
                    .db $CE,$CC,$CE,$CC,$CE,$CC,$CE

ADDR_02827D:        LDA $1A                   
                    STA.W $188D               
                    EOR.B #$FF                
                    INC A                     
                    STA $05                   
                    LDA $1B                   
                    LSR                       
                    ROR.W $188D               
                    PHA                       
                    LDA.W $188D               
                    EOR.B #$FF                
                    INC A                     
                    STA $06                   
                    PLA                       
                    LSR                       
                    ROR.W $188D               
                    LDA.W $188D               
                    EOR.B #$FF                
                    INC A                     
                    STA.W $188D               
                    REP #$10                  ; Index (16 bit) 
                    LDY.W #$0164              
                    LDA.B #$66                
                    STY $03                   
                    LDA.B #$F0                
ADDR_0282AF:        STA.W $020D,Y             
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    CPY.W #$018C              
                    BCC ADDR_0282AF           
                    LDX.W #$0000              
                    STX $0C                   
                    LDX.W #$0038              
                    LDY.W #$00E0              
                    LDA.W $1884               
                    CMP.B #$01                
                    BNE ADDR_0282D8           
                    LDX.W #$0039              
                    STX $0C                   
                    LDX.W #$001D              
                    LDY.W #$00FC              
ADDR_0282D8:        STX $00                   
                    REP #$20                  ; Accum (16 bit) 
                    TXA                       
                    CLC                       
                    ADC $0C                   
                    STA $0A                   
                    SEP #$20                  ; Accum (8 bit) 
                    LDA $06                   
                    CLC                       
                    LDX $0A                   
                    ADC.L DATA_028178,X       
                    STA.W $020C,Y             
                    STA $02                   
                    LDA.W $1888               
                    STA $07                   
                    ASL                       
                    ROR $07                   
                    LDA.L DATA_0281CF,X       
                    DEC A                     
                    SEC                       
                    SBC $07                   
                    STA.W $020D,Y             
                    LDX $0A                   
                    LDA.W $188C               
                    BNE ADDR_028318           
                    LDA.L DATA_028226,X       
                    STA.W $020E,Y             
                    LDA.B #$0D                
                    STA.W $020F,Y             
ADDR_028318:        REP #$20                  ; Accum (16 bit) 
                    PHY                       
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.B #$02                
                    STA.W $0423,Y             
                    LDA $02                   
                    CMP.B #$F0                
                    BCC ADDR_028367           
                    LDA.W $1884               
                    CMP.B #$01                
                    BEQ ADDR_028367           
                    PLY                       
                    PHY                       
                    LDX $03                   
                    LDA.W $020C,Y             
                    STA.W $020C,X             
                    LDA.W $020D,Y             
                    STA.W $020D,X             
                    LDA.W $020E,Y             
                    STA.W $020E,X             
                    LDA.W $020F,Y             
                    STA.W $020F,X             
                    REP #$20                  ; Accum (16 bit) 
                    TXA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.B #$03                
                    STA.W $0423,Y             
                    LDA $03                   
                    CLC                       
                    ADC.B #$04                
                    STA $03                   
                    BCC ADDR_028367           
                    INC $04                   
ADDR_028367:        PLY                       
                    LDX $00                   
                    DEY                       
                    DEY                       
                    DEY                       
                    DEY                       
                    DEX                       
                    BMI ADDR_028374           
                    JMP.W ADDR_0282D8         
ADDR_028374:        SEP #$10                  ; Index (8 bit) 
                    LDA.B #$01                
                    STA.W $188C               
                    LDA.W $1884               
                    CMP.B #$01                
                    BNE ADDR_028398           
                    LDA.B #$CD                
                    STA.W $02BF               
                    STA.W $02C3               
                    STA.W $02C7               
                    STA.W $02CB               
                    STA.W $02CF               
                    STA.W $02D3               
                    BRA ADDR_0283C4           
ADDR_028398:        LDA $14                   
                    AND.B #$03                
                    BNE ADDR_0283C4           
                    STZ $00                   
ADDR_0283A0:        LDX $00                   
                    LDA.L DATA_0283C8,X       
                    TAY                       
                    JSL.L ADDR_01ACF9         
                    AND.B #$01                
                    BNE ADDR_0283B7           
                    LDA.W $020E,Y             
                    EOR.B #$02                
                    STA.W $020E,Y             
ADDR_0283B7:        LDA.B #$09                
                    STA.W $020F,Y             
                    INC $00                   
                    LDA $00                   
                    CMP.B #$04                
                    BNE ADDR_0283A0           
ADDR_0283C4:        JSR.W ADDR_0283CE         
                    RTL                       ; Return 


DATA_0283C8:        .db $00,$04,$08,$0C

DATA_0283CC:        .db $0C,$30

ADDR_0283CE:        LDA.W $153D               
                    SEC                       
                    SBC.B #$1E                
                    STA $0C                   
                    LDA.W $1617               
                    CLC                       
                    ADC.B #$10                
                    STA $0D                   
                    LDX.B #$01                
ADDR_0283E0:        STX $0F                   
                    LDA.W $18A8,X             
                    BEQ ADDR_0283F4           
                    BMI ADDR_0283F1           
                    STA.W $13FB               
                    STA $9D                   
                    JSR.W ADDR_0283F8         
ADDR_0283F1:        JSR.W ADDR_028439         
ADDR_0283F4:        DEX                       
                    BPL ADDR_0283E0           
                    RTS                       ; Return 

ADDR_0283F8:        LDA.W $18AA,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    SEC                       
                    ADC.W $18AA,X             
                    CMP.B #$B0                
                    BCC ADDR_028435           
                    ASL.W $18A8,X             
                    SEC                       
                    ROR.W $18A8,X             
                    LDA.B #$30                
                    STA.W $1887               
                    LDA.B #$09                
                    STA.W $1DFC               ; / Play sound effect 
                    CPX.B #$00                
                    BNE ADDR_02842A           
                    LDA.W $18A9               
                    BNE ADDR_02842A           
                    INC.W $18A9               
                    STZ.W $18AB               
                    BRA ADDR_028433           
ADDR_02842A:        CPX.B #$01                
                    BNE ADDR_028433           
                    STZ $9D                   
                    STZ.W $13FB               
ADDR_028433:        LDA.B #$B0                
ADDR_028435:        STA.W $18AA,X             
                    RTS                       ; Return 

ADDR_028439:        LDA.L DATA_0283CC,X       
                    TAY                       
                    STZ $00                   
ADDR_028440:        LDA.B #$F0                
                    STA.W $0201,Y             
                    LDA.W $18AA,X             
                    SEC                       
                    SBC $1C                   
                    SEC                       
                    SBC.W $1888               
                    SEC                       
                    SBC $00                   
                    CMP.B #$20                
                    BCC ADDR_02848C           
                    CMP.B #$A4                
                    BCS ADDR_02845D           
                    STA.W $0201,Y             
ADDR_02845D:        LDA $0C,X                 
                    STA.W $0200,Y             
                    LDA.B #$E6                
                    LDX $00                   
                    BEQ ADDR_02846A           
                    LDA.B #$08                
ADDR_02846A:        STA.W $0202,Y             
                    LDA.B #$0D                
                    STA.W $0203,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.B #$02                
                    STA.W $0420,X             
                    LDX $0F                   
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    LDA $00                   
                    CLC                       
                    ADC.B #$10                
                    STA $00                   
                    CMP.B #$90                
                    BCC ADDR_028440           
ADDR_02848C:        RTS                       ; Return 

ADDR_02848D:        LDY.B #$00                
                    LDA $94                   
                    SEC                       
                    SBC $E4,X                 
                    STA $0F                   
                    LDA $95                   
                    SBC.W $14E0,X             
                    BPL ADDR_02849E           
                    INY                       
ADDR_02849E:        RTS                       ; Return 

ADDR_02849F:        LDA.W $15A0,X             
                    ORA.W $186C,X             
                    RTS                       ; Return 

ADDR_0284A6:        STA $03                   
                    LDA.B #$02                
                    STA $01                   
ADDR_0284AC:        JSL.L ADDR_0284D8         
                    LDA $02                   
                    CLC                       
                    ADC $03                   
                    STA $02                   
                    DEC $01                   
                    BPL ADDR_0284AC           
                    RTL                       ; Return 

ADDR_0284BC:        LDA.B #$12                
                    BRA ADDR_0284C2           
ADDR_0284C0:        LDA.B #$00                
ADDR_0284C2:        STA $00                   
                    STZ $02                   
                    LDA $9E,X                 
                    CMP.B #$41                
                    BEQ ADDR_0284D0           
                    CMP.B #$42                
                    BNE ADDR_0284D8           
ADDR_0284D0:        LDA $AA,X                 
                    BPL ADDR_0284E7           
                    LDA.B #$0A                
                    BRA ADDR_0284A6           
ADDR_0284D8:        JSR.W ADDR_02849F         
                    BNE ADDR_0284E7           
                    LDY.B #$0B                
ADDR_0284DF:        LDA.W $17F0,Y             
                    BEQ ADDR_0284E8           
                    DEY                       
                    BPL ADDR_0284DF           
ADDR_0284E7:        RTL                       ; Return 

ADDR_0284E8:        LDA $D8,X                 
                    CLC                       
                    ADC.B #$00                
                    AND.B #$F0                
                    CLC                       
                    ADC.B #$03                
                    STA.W $17FC,Y             
                    LDA $E4,X                 
                    CLC                       
                    ADC $02                   
                    STA.W $1808,Y             
                    LDA.W $14E0,X             
                    ADC.B #$00                
                    STA.W $18EA,Y             
                    LDA.B #$07                
                    STA.W $17F0,Y             
                    LDA $00                   
                    STA.W $1850,Y             
                    RTL                       ; Return 


DATA_028510:        .db $04,$FC,$06,$FA,$08,$F8,$0A,$F6
DATA_028518:        .db $E0,$E1,$E2,$E3,$E4,$E6,$E8,$EA
DATA_028520:        .db $1F,$13,$10,$1C,$17,$1A,$0F,$1E

ADDR_028528:        JSR.W ADDR_02849F         
                    LDA.W $186C,X             
                    BNE ADDR_0284E7           
                    LDA.B #$04                
                    STA $00                   
                    LDY.B #$07                
ADDR_028536:        LDA.W $170B,Y             
                    BEQ ADDR_02853F           
                    DEY                       
                    BPL ADDR_028536           
                    RTL                       ; Return 

ADDR_02853F:        LDA.B #$07                
                    STA.W $170B,Y             
                    LDA $D8,X                 
                    STA.W $1715,Y             
                    LDA.W $14D4,X             
                    STA.W $1729,Y             
                    LDA $E4,X                 
                    CLC                       
                    ADC.B #$04                
                    STA.W $171F,Y             
                    LDA.W $14E0,X             
                    ADC.B #$00                
                    STA.W $1733,Y             
                    JSL.L ADDR_01ACF9         
                    PHX                       
                    AND.B #$07                
                    TAX                       
                    LDA.L DATA_028510,X       
                    STA.W $1747,Y             
                    LDA.W $148E               
                    AND.B #$07                
                    TAX                       
                    LDA.L DATA_028518,X       
                    STA.W $173D,Y             
                    JSL.L ADDR_01ACF9         
                    AND.B #$07                
                    TAX                       
                    LDA.L DATA_028520,X       
                    STA.W $176F,Y             
                    PLX                       
                    DEC $00                   
                    BPL ADDR_028536           
                    RTL                       ; Return 

ADDR_02858F:        LDY.B #$1F                
                    LDX.B #$00                
                    LDA $19                   
                    BNE ADDR_02859B           
                    LDY.B #$0F                
                    LDX.B #$10                
ADDR_02859B:        STX $01                   
                    JSL.L ADDR_01ACF9         
                    TYA                       
                    AND.W $148D               
                    CLC                       
                    ADC $01                   
                    CLC                       
                    ADC $96                   
                    STA $00                   
                    LDA.W $148E               
                    AND.B #$0F                
                    CLC                       
                    ADC.B #$FE                
                    CLC                       
                    ADC $94                   
                    STA $02                   
ADDR_0285BA:        LDY.B #$0B                
ADDR_0285BC:        LDA.W $17F0,Y             
                    BEQ ADDR_0285C5           
                    DEY                       
                    BPL ADDR_0285BC           
                    RTL                       ; Return 

ADDR_0285C5:        LDA.B #$05                
                    STA.W $17F0,Y             
                    LDA.B #$00                
                    STA.W $1820,Y             
                    LDA $00                   
                    STA.W $17FC,Y             
                    LDA $02                   
                    STA.W $1808,Y             
                    LDA.B #$17                
                    STA.W $1850,Y             
                    RTL                       ; Return 

ADDR_0285DF:        JSR.W ADDR_02849F         
                    BNE ADDR_0285EE           
                    LDY.B #$0B                
ADDR_0285E6:        LDA.W $17F0,Y             
                    BEQ ADDR_0285EF           
                    DEY                       
                    BPL ADDR_0285E6           
ADDR_0285EE:        RTL                       ; Return 

ADDR_0285EF:        JSL.L ADDR_01ACF9         
                    LDA.B #$04                
                    STA.W $17F0,Y             
                    LDA.B #$00                
                    STA.W $1820,Y             
                    LDA.W $148D               
                    AND.B #$0F                
                    SEC                       
                    SBC.B #$03                
                    CLC                       
                    ADC $E4,X                 
                    STA.W $1808,Y             
                    LDA.W $14E0,X             
                    ADC.B #$00                
                    STA.W $18EA,Y             
                    LDA.W $148E               
                    AND.B #$07                
                    CLC                       
                    ADC.B #$07                
                    CLC                       
                    ADC $D8,X                 
                    STA.W $17FC,Y             
                    LDA.W $14D4,X             
                    ADC.B #$00                
                    STA.W $1814,Y             
                    LDA.B #$17                
                    STA.W $1850,Y             
                    RTL                       ; Return 

ADDR_02862F:        JSL.L ADDR_02A9E4         
                    BMI ADDR_028662           
                    TYX                       
                    LDA.B #$0B                
                    STA.W $14C8,X             
                    LDA $96                   
                    STA $D8,X                 
                    LDA $97                   
                    STA.W $14D4,X             
                    LDA $94                   
                    STA $E4,X                 
                    LDA $95,X                 
                    STA.W $14E0,X             
                    LDA.B #$53                
                    STA $9E,X                 
                    JSL.L ADDR_07F7D2         
                    LDA.B #$FF                
                    STA.W $1540,X             
                    LDA.B #$08                
                    STA.W $1498               
                    STA.W $148F               
ADDR_028662:        RTL                       ; Return 

ShatterBlock:       PHX                       
                    STA $00                   
                    LDY.B #$03                
                    LDX.B #$0B                
ADDR_02866A:        LDA.W $17F0,X             
                    BEQ ADDR_02867F           
ADDR_02866F:        DEX                       
                    BPL ADDR_02866A           
                    DEC.W $185D               
                    BPL ADDR_02867C           
                    LDA.B #$0B                
                    STA.W $185D               
ADDR_02867C:        LDX.W $185D               
ADDR_02867F:        LDA.B #$07                ; \ 
                    STA.W $1DFC               ; / Play sound effect 
                    LDA.B #$01                
                    STA.W $17F0,X             
                    LDA $9A                   
                    CLC                       
                    ADC.W DATA_028746,Y       
                    STA.W $1808,X             
                    LDA $9B                   
                    ADC.B #$00                
                    STA.W $18EA,X             
                    LDA $98                   
                    CLC                       
                    ADC.W DATA_028742,Y       
                    STA.W $17FC,X             
                    LDA $99                   
                    ADC.B #$00                
                    STA.W $1814,X             
                    LDA.W DATA_02874A,Y       
                    STA.W $1820,X             
                    LDA.W DATA_02874E,Y       
                    STA.W $182C,X             
                    LDA $00                   
                    STA.W $1850,X             
                    DEY                       
                    BPL ADDR_02866F           
                    PLX                       
                    RTL                       ; Return 

ADDR_0286BF:        LDA.W $1697               
                    BNE ADDR_0286EC           
                    PHB                       
                    PHK                       
                    PLB                       
                    JSR.W SprBlkInteract      
                    LDA.B #$02                
                    STA.W $16CD,Y             
                    LDA $94                   
                    STA.W $16D1,Y             
                    LDA $95                   
                    STA.W $16DD,Y             
                    LDA $96                   
                    CLC                       
                    ADC.B #$20                
                    STA.W $16D9,Y             
                    LDA $97                   
                    ADC.B #$00                
                    STA.W $16DD,Y             
                    JSR.W ADDR_029BE4         
                    PLB                       
ADDR_0286EC:        RTL                       ; Return 

SprBlkInteract:     LDY.B #$03                
ADDR_0286EF:        LDA.W $16CD,Y             
                    BEQ ADDR_0286F8           
                    DEY                       
                    BPL ADDR_0286EF           
                    INY                       
ADDR_0286F8:        LDA $9A                   
                    STA.W $16D1,Y             
                    LDA $9B                   
                    STA.W $16D5,Y             
                    LDA $98                   
                    STA.W $16D9,Y             
                    LDA $99                   
                    STA.W $16DD,Y             
                    LDA.W $1933               
                    BEQ ADDR_02872F           
                    LDA $9A                   
                    SEC                       
                    SBC $26                   
                    STA.W $16D1,Y             
                    LDA $9B                   
                    SBC $27                   
                    STA.W $16D5,Y             
                    LDA $98                   
                    SEC                       
                    SBC $28                   
                    STA.W $16D9,Y             
                    LDA $99                   
                    SBC $29                   
                    STA.W $16DD,Y             
ADDR_02872F:        LDA.B #$01                
                    STA.W $16CD,Y             
                    LDA.B #$06                
                    STA.W $18F8,Y             
                    RTS                       ; Return 


BlockBounceSpeedY:  .db $C0,$00,$00,$40

BlockBounceSpeedX:  .db $00,$40,$C0,$00

DATA_028742:        .db $00,$00,$08,$08

DATA_028746:        .db $00,$08,$00,$08

DATA_02874A:        .db $FB,$FB,$FD,$FD

DATA_02874E:        .db $FF,$01,$FF,$01

ADDR_028752:        LDA $04                   
                    CMP.B #$07                
                    BNE NotBreakable          
BreakTurnBlock:     LDA.W $0DB3               ; Increase points 
                    ASL                       
                    ADC.W $0DB3               
                    TAX                       
                    LDA.W $0F34,X             
                    CLC                       
                    ADC.B #$05                
                    STA.W $0F34,X             
                    BCC ADDR_028773           
                    INC.W $0F35,X             
                    BNE ADDR_028773           
                    INC.W $0F36,X             
ADDR_028773:        LDA.B #$D0                ; Deflect Mario downward 
                    STA $7D                   
                    LDA.B #$00                
                    JSL.L ShatterBlock        ; Actually break the block 
                    JSR.W SprBlkInteract      ; Handle sprite/block interaction  
ADDR_028780:        LDA.B #$02                ; \ Replace block with "nothing" tile 
                    STA $9C                   ;  | 
                    JSL.L ADDR_00BEB0         ; / 
                    RTL                       ; Return 


BlockBounce:        .db $00,$03,$00,$00,$01,$07,$00,$04
                    .db $0A

NotBreakable:       LDY.B #$03                ; Reset turning block 
ADDR_028794:        LDA.W $1699,Y             
                    BEQ ADDR_028807           
                    DEY                       
                    BPL ADDR_028794           
                    DEC.W $18CD               
                    BPL ADDR_0287A6           
                    LDA.B #$03                
                    STA.W $18CD               
ADDR_0287A6:        LDY.W $18CD               
                    LDA.W $1699,Y             
                    CMP.B #$07                
                    BNE ADDR_028804           
                    LDA $9A                   
                    PHA                       
                    LDA $9B                   
                    PHA                       
                    LDA $98                   
                    PHA                       
                    LDA $99                   
                    PHA                       
                    LDA.W $16A5,Y             
                    STA $9A                   
                    LDA.W $16AD,Y             
                    STA $9B                   
                    LDA.W $16A1,Y             
                    CLC                       
                    ADC.B #$0C                
                    AND.B #$F0                
                    STA $98                   
                    LDA.W $16A9,Y             
                    ADC.B #$00                
                    STA $99                   
                    LDA.W $16C1,Y             
                    STA $9C                   
                    LDA $04                   
                    PHA                       
                    LDA $05                   
                    PHA                       
                    LDA $06                   
                    PHA                       
                    LDA $07                   
                    PHA                       
                    JSL.L ADDR_00BEB0         
                    PLA                       
                    STA $07                   
                    PLA                       
                    STA $06                   
                    PLA                       
                    STA $05                   
                    PLA                       
                    STA $04                   
                    PLA                       
                    STA $99                   
                    PLA                       
                    STA $98                   
                    PLA                       
                    STA $9B                   
                    PLA                       
                    STA $9A                   
ADDR_028804:        LDY.W $18CD               
ADDR_028807:        LDA $04                   
                    CMP.B #$10                
                    BCC ADDR_028818           
                    STZ $04                   
                    TAX                       
                    LDA.W ADDR_028780,X       
                    STA.W $1901,Y             
                    BRA ADDR_02882A           
ADDR_028818:        LDA $04                   ; \ Play on/off sound if appropriate 
                    CMP.B #$05                ;  | 
                    BNE ADDR_028823           ;  | 
                    LDX.B #$0B                ;  | 
                    STX.W $1DF9               ; / 
ADDR_028823:        TAX                       
                    LDA.W BlockBounce,X       
                    STA.W $1901,Y             
ADDR_02882A:        LDA $04                   
                    INC A                     
                    STA.W $1699,Y             ; Set block bounce sprite type 
                    LDA.B #$00                ; \ set (times can be hit?) 
                    STA.W $169D,Y             ; / 
                    LDA $9A                   ; \ Set bounce block y position 
                    STA.W $16A5,Y             ;  | 
                    LDA $9B                   ;  | 
                    STA.W $16AD,Y             ; / 
                    LDA $98                   ; \ Set bounce block x position 
                    STA.W $16A1,Y             ;  | 
                    LDA $99                   ;  | 
                    STA.W $16A9,Y             ; / 
                    LDA.W $1933               
                    LSR                       
                    ROR                       
                    STA $08                   
                    LDX $06                   
                    LDA.W BlockBounceSpeedY,X ; \ Set bounce y speed 
                    STA.W $16B1,Y             ; / 
                    LDA.W BlockBounceSpeedX,X ; \ Set bounce x speed 
                    STA.W $16B5,Y             ; / 
                    TXA                       
                    ORA $08                   
                    STA.W $16C9,Y             
                    LDA $07                   ; \ Set tile to turn block into 
                    STA.W $16C1,Y             ; / 
                    LDA.B #$08                ; \ Time to show bouncing block 
                    STA.W $16C5,Y             
                    LDA.W $1699,Y             
                    CMP.B #$07                
                    BNE ADDR_02887A           
                    LDA.B #$FF                
                    STA.W $18CE,Y             
ADDR_02887A:        JSR.W SprBlkInteract      
ADDR_02887D:        LDA $05                   
                    BEQ ADDR_0288A0           
                    CMP.B #$0A                
                    BNE ADDR_028885           
ADDR_028885:        LDA $05                   
                    CMP.B #$08                
                    BCS ADDR_0288DC           
                    CMP.B #$06                
                    BCC ADDR_0288DC           
                    CMP.B #$07                
                    BNE ADDR_02889D           
                    LDA.W $186B               
                    BNE ADDR_02889D           
                    LDA.B #$FF                
                    STA.W $186B               
ADDR_02889D:        JSR.W ADDR_028A66         
ADDR_0288A0:        RTL                       ; Return 


DATA_0288A1:        .db $35,$78

DATA_0288A3:        .db $00,$74,$75,$76,$77,$78,$00,$00
                    .db $79,$00,$3E,$7D,$2C,$04,$81,$45
                    .db $80,$00,$74,$75,$76,$77,$78,$00
                    .db $00,$79,$00,$3E,$7D,$2C,$04,$81
                    .db $45,$80

DATA_0288C5:        .db $00,$08,$08,$08,$08,$08,$00,$00
                    .db $08,$00,$09,$08,$09,$09,$08,$08
                    .db $09

DATA_0288D6:        .db $80,$7E,$7D

DATA_0288D9:        .db $09,$08,$08

ADDR_0288DC:        LDY $05                   
                    CPY.B #$0B                
                    BNE ADDR_0288EA           
                    LDA $9A                   
                    AND.B #$30                
                    CMP.B #$20                
                    BEQ ADDR_028905           
ADDR_0288EA:        CPY.B #$10                
                    BEQ ADDR_0288FD           
                    CPY.B #$08                
                    BNE ADDR_0288F9           
                    LDA.W $1692               
                    BEQ ADDR_028905           
                    BNE ADDR_0288FD           
ADDR_0288F9:        CPY.B #$0C                
                    BNE ADDR_028905           
ADDR_0288FD:        JSL.L ADDR_02A9E4         
                    TYX                       
                    BPL ADDR_028922           
                    RTL                       ; Return 

ADDR_028905:        LDX.B #$0B                
ADDR_028907:        LDA.W $14C8,X             
                    BEQ ADDR_028922           
                    DEX                       
                    CPX.B #$FF                
                    BNE ADDR_028907           
                    DEC.W $1861               
                    BPL ADDR_02891B           
                    LDA.B #$01                
                    STA.W $1861               
ADDR_02891B:        LDA.W $1861               
                    CLC                       
                    ADC.B #$0A                
                    TAX                       
ADDR_028922:        STX.W $185E               
                    LDY $05                   
                    LDA.W DATA_0288C5,Y       
                    STA.W $14C8,X             
                    LDA.W $18E2               
                    BEQ ADDR_028937           
                    TYA                       
                    CLC                       
                    ADC.B #$11                
                    TAY                       
ADDR_028937:        STY.W $1695               
                    LDA.W DATA_0288A3,Y       
                    STA $9E,X                 
                    STA $0E                   
                    LDY.B #$02                
                    CMP.B #$81                
                    BCS ADDR_02894C           
                    CMP.B #$79                
                    BCC ADDR_02894C           
                    INY                       
ADDR_02894C:        STY.W $1DFC               ; / Play sound effect 
                    JSL.L ADDR_07F7D2         
                    INC.W $15A0,X             
                    LDA $9E,X                 
                    CMP.B #$45                
                    BNE ADDR_028972           
                    LDA.W $1432               
                    BEQ ADDR_028967           
                    STZ.W $14C8,X             
                    JMP.W ADDR_02889D         
ADDR_028967:        LDA.B #$0E                
                    STA.W $1DFB               ; / Play sound effect 
                    INC.W $1432               
                    STZ.W $190C               
ADDR_028972:        LDA $9A                   
                    STA $E4,X                 
                    LDA $9B                   
                    STA.W $14E0,X             
                    LDA $98                   
                    STA $D8,X                 
                    LDA $99                   
                    STA.W $14D4,X             
                    LDA.W $1933               
                    BEQ ADDR_0289A5           
                    LDA $9A                   
                    SEC                       
                    SBC $26                   
                    STA $E4,X                 
                    LDA $9B                   
                    SBC $27                   
                    STA.W $14E0,X             
                    LDA $98                   
                    SEC                       
                    SBC $28                   
                    STA $D8,X                 
                    LDA $99                   
                    SBC $29                   
                    STA.W $14D4,X             
ADDR_0289A5:        LDA $9E,X                 
                    CMP.B #$7D                
                    BNE ADDR_0289D3           
                    LDA $E4,X                 
                    AND.B #$30                
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_0288D9,Y       
                    STA.W $14C8,X             
                    LDA.W DATA_0288D6,Y       
                    STA $9E,X                 
                    PHA                       
                    JSL.L ADDR_07F7D2         
                    PLA                       
                    CMP.B #$7D                
                    BNE ADDR_0289CD           
                    INC.W $157C,X             
                    RTL                       ; Return 

ADDR_0289CD:        CMP.B #$7E                
                    BEQ ADDR_028A03           
                    BRA ADDR_028A01           
ADDR_0289D3:        CMP.B #$04                
                    BEQ ADDR_028A08           
                    CMP.B #$3E                
                    BEQ ADDR_028A2A           
                    CMP.B #$2C                
                    BNE ADDR_028A11           
                    LDY.B #$0B                
ADDR_0289E1:        LDA.W $14C8,Y             
                    CMP.B #$08                
                    BCC ADDR_0289F3           
                    LDA.W $009E,Y             
                    CMP.B #$2D                
                    BNE ADDR_0289F3           
ADDR_0289EF:        LDY.B #$01                
                    BRA ADDR_0289FB           
ADDR_0289F3:        DEY                       
                    BPL ADDR_0289E1           
                    LDY.W $18E2               
                    BNE ADDR_0289EF           
ADDR_0289FB:        LDA.W DATA_0288A1,Y       
                    STA.W $151C,X             
ADDR_028A01:        BRA ADDR_028A0D           
ADDR_028A03:        INC $C2,X                 
                    INC $C2,X                 
                    RTL                       ; Return 

ADDR_028A08:        LDA.B #$FF                
                    STA.W $1540,X             
ADDR_028A0D:        LDA.B #$D0                
                    BRA ADDR_028A18           
ADDR_028A11:        LDA.B #$3E                
                    STA.W $1540,X             
                    LDA.B #$D0                
ADDR_028A18:        STA $AA,X                 
                    LDA.B #$2C                
                    STA.W $154C,X             
                    LDA.W $190F,X             
                    BPL ADDR_028A29           
                    LDA.B #$10                
                    STA.W $15AC,X             
ADDR_028A29:        RTL                       ; Return 

ADDR_028A2A:        LDA $E4,X                 
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.B #$01                
                    STA.W $151C,X             
                    TAY                       
                    LDA.W DATA_028A42,Y       
                    STA.W $15F6,X             
                    JSL.L ADDR_028A44         
                    BRA ADDR_028A0D           

DATA_028A42:        .db $06,$02

ADDR_028A44:        PHX                       
                    LDX.B #$03                
ADDR_028A47:        LDA.W $17C0,X             
                    BEQ ADDR_028A50           
                    DEX                       
                    BPL ADDR_028A47           
                    INX                       
ADDR_028A50:        LDA.B #$01                
                    STA.W $17C0,X             
                    LDA $98                   
                    STA.W $17C4,X             
                    LDA $9A                   
                    STA.W $17C8,X             
                    LDA.B #$1B                
                    STA.W $17CC,X             
                    PLX                       
                    RTL                       ; Return 

ADDR_028A66:        LDX.B #$03                
ADDR_028A68:        LDA.W $17D0,X             
                    BEQ ADDR_028A7D           
                    DEX                       
                    BPL ADDR_028A68           
                    DEC.W $1865               
                    BPL ADDR_028A7A           
                    LDA.B #$03                
                    STA.W $1865               
ADDR_028A7A:        LDX.W $1865               
ADDR_028A7D:        JSL.L ADDR_05B34A         
                    INC.W $17D0,X             
                    LDA $9A                   
                    STA.W $17E0,X             
                    LDA $9B                   
                    STA.W $17EC,X             
                    LDA $98                   
                    SEC                       
                    SBC.B #$10                
                    STA.W $17D4,X             
                    LDA $99                   
                    SBC.B #$00                
                    STA.W $17E8,X             
                    LDA.W $1933               
                    STA.W $17E4,X             
                    LDA.B #$D0                
                    STA.W $17D8,X             
                    RTS                       ; Return 


DATA_028AA9:        .db $07,$03,$03,$01,$01,$01,$01,$01

ADDR_028AB1:        PHB                       
                    PHK                       
                    PLB                       
                    LDA.W $18E4               
                    BEQ ADDR_028AD5           
                    LDA.W $18E5               
                    BEQ ADDR_028AC3           
                    DEC.W $18E5               
                    BRA ADDR_028AD5           
ADDR_028AC3:        DEC.W $18E4               
                    BEQ ADDR_028ACD           
                    LDA.B #$23                
                    STA.W $18E5               
ADDR_028ACD:        LDA.B #$05                
                    STA.W $1DFC               ; / Play sound effect 
                    INC.W $0DBE               
ADDR_028AD5:        LDA.W $1490               
                    BEQ ADDR_028AEB           
                    CMP.B #$08                
                    BCC ADDR_028AEB           
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA $13                   
                    AND.W DATA_028AA9,Y       
                    BRA ADDR_028AF5           
ADDR_028AEB:        LDA.W $18D3               
                    BEQ ADDR_028B05           
                    DEC.W $18D3               
                    AND.B #$01                
ADDR_028AF5:        ORA $7F                   
                    ORA $81                   
                    BNE ADDR_028B05           
                    LDA $80                   
                    CMP.B #$D0                
                    BCS ADDR_028B05           
                    JSL.L ADDR_02858F         
ADDR_028B05:        JSR.W ADDR_028B67         
                    JSR.W ADDR_02902D         
                    JSR.W ADDR_02ADA4         
                    JSR.W ADDR_029B0A         
                    JSR.W ADDR_0299D2         
                    JSR.W ADDR_02B387         
                    JSR.W ADDR_02AFFE         
                    JSR.W ADDR_0294F5         
                    JSR.W ADDR_02A7FC         
                    LDA.W $18C0               
                    BEQ ADDR_028B65           
                    LDA $13                   
                    AND.B #$01                
                    ORA $9D                   
                    ORA.W $18BF               
                    BNE ADDR_028B65           
                    DEC.W $18C0               
                    BNE ADDR_028B65           
                    JSL.L ADDR_02A9E4         
                    BMI ADDR_028B65           
                    TYX                       
                    LDA.B #$01                
                    STA.W $14C8,X             
                    LDA.W $18C1               
                    STA $9E,X                 
                    LDA $1A                   
                    SEC                       
                    SBC.B #$20                
                    AND.B #$EF                
                    STA $E4,X                 
                    LDA $1B                   
                    SBC.B #$00                
                    STA.W $14E0,X             
                    LDA.W $18C3               
                    STA $D8,X                 
                    LDA.W $18C4               
                    STA.W $14D4,X             
                    JSL.L ADDR_07F7D2         
ADDR_028B65:        PLB                       
                    RTL                       ; Return 

ADDR_028B67:        LDX.B #$0B                
ADDR_028B69:        LDA.W $17F0,X             
                    BEQ ADDR_028B74           
                    STX.W $1698               
                    JSR.W ADDR_028B94         
ADDR_028B74:        DEX                       
                    BPL ADDR_028B69           
ADDR_028B77:        RTS                       ; Return 


BrokenBlock:        .db $50,$54,$58,$5C,$60,$64,$68,$6C
                    .db $70,$74,$78,$7C

BrokenBlock2:       .db $3C,$3D,$3D,$3C,$3C,$3D,$3D,$3C
DATA_028B8C:        .db $00,$00,$80,$80,$80,$C0,$40,$00

ADDR_028B94:        JSL.L ExecutePtr          

Ptrs028B98:         .dw ADDR_028B77           
                    .dw ADDR_028F8B           
                    .dw ADDR_028ED2           
                    .dw ADDR_028E7E           
                    .dw ADDR_028F2F           
                    .dw ADDR_028ED2           
                    .dw ADDR_028DDB           
                    .dw ADDR_028D4F           
                    .dw ADDR_028DDB           
                    .dw ADDR_028DDB           
                    .dw ADDR_028CC4           
                    .dw ADDR_028C0F           

ADDR_028BB0:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_028BB8         
                    PLB                       
                    RTL                       ; Return 

ADDR_028BB8:        RTS                       ; Return 

                    STZ $00                   
                    JSR.W ADDR_028BC0         
                    INC $00                   
ADDR_028BC0:        LDY.B #$0B                
ADDR_028BC2:        LDA.W $17F0,Y             
                    BEQ ADDR_028BCB           
                    DEY                       
                    BPL ADDR_028BC2           
                    RTS                       ; Return 

ADDR_028BCB:        LDA.B #$0B                
                    STA.W $17F0,Y             
                    LDA.B #$00                
                    STA.W $1850,Y             
                    LDA $D8,X                 
                    CLC                       
                    ADC.B #$1C                
                    STA.W $17FC,Y             
                    LDA.W $14D4,X             
                    ADC.B #$00                
                    STA.W $1814,Y             
                    LDA $94                   
                    STA $02                   
                    LDA $95                   
                    STA $03                   
                    PHX                       
                    LDX $00                   
                    LDA.W DATA_028C09,X       
                    STA.W $182C,Y             
                    LDA $02                   
                    CLC                       
                    ADC.W DATA_028C0B,X       
                    STA.W $1808,Y             
                    LDA $03                   
                    ADC.W DATA_028C0D,X       
                    STA.W $18EA,Y             
                    PLX                       
                    RTS                       ; Return 


DATA_028C09:        .db $40,$C0

DATA_028C0B:        .db $0C,$FC

DATA_028C0D:        .db $00,$FF

ADDR_028C0F:        LDA.W $1850,X             
                    BNE ADDR_028C61           
                    LDA.W $182C,X             
                    BEQ ADDR_028C66           
                    BPL ADDR_028C20           
                    CLC                       
                    ADC.B #$08                
                    BRA ADDR_028C23           
ADDR_028C20:        SEC                       
                    SBC.B #$08                
ADDR_028C23:        STA.W $182C,X             
                    JSR.W ADDR_02B5BC         
                    TXA                       
                    EOR $13                   
                    AND.B #$03                
                    BNE ADDR_028C60           
                    LDY.B #$0B                
ADDR_028C32:        LDA.W $17F0,Y             
                    BEQ ADDR_028C3B           
                    DEY                       
                    BPL ADDR_028C32           
                    RTS                       ; Return 

ADDR_028C3B:        LDA.B #$0B                
                    STA.W $17F0,Y             
                    STA.W $1820,Y             
                    LDA.W $1808,X             
                    STA.W $1808,Y             
                    LDA.W $18EA,X             
                    STA.W $18EA,Y             
                    LDA.W $17FC,X             
                    STA.W $17FC,Y             
                    LDA.W $1814,X             
                    STA.W $1814,Y             
                    LDA.B #$10                
                    STA.W $1850,Y             
ADDR_028C60:        RTS                       ; Return 

ADDR_028C61:        DEC.W $1850,X             
                    BNE ADDR_028C6E           
ADDR_028C66:        STZ.W $17F0,X             
                    RTS                       ; Return 


DATA_028C6A:        .db $66,$66,$64,$62

ADDR_028C6E:        LDY.W BrokenBlock,X       
                    LDA.W $1808,X             
                    SEC                       
                    SBC $1A                   
                    STA $00                   
                    LDA.W $18EA,X             
                    SBC $1B                   
                    BNE ADDR_028C66           
                    LDA.W $17FC,X             
                    SEC                       
                    SBC $1C                   
                    STA $01                   
                    LDA.W $1814,X             
                    SBC $1D                   
                    BNE ADDR_028C66           
                    LDA $00                   
                    STA.W $0200,Y             
                    LDA $01                   
                    STA.W $0201,Y             
                    PHX                       
                    LDA.W $1850,X             
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W DATA_028C6A,X       
                    STA.W $0202,Y             
                    PLX                       
                    LDA $64                   
                    ORA.B #$08                
                    STA.W $0203,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$00                
                    STA.W $0420,Y             
                    RTS                       ; Return 


BooStreamTiles:     .db $88,$A8,$AA,$8C,$8E,$AE,$88,$A8
                    .db $AA,$8C,$8E,$AE

ADDR_028CC4:        LDA $9D                   
                    BNE ADDR_028CFF           
                    LDA.W $1808,X             
                    CLC                       
                    ADC.B #$04                
                    STA $04                   
                    LDA.W $18EA,X             
                    ADC.B #$00                
                    STA $0A                   
                    LDA.W $17FC,X             
                    CLC                       
                    ADC.B #$04                
                    STA $05                   
                    LDA.W $1814,X             
                    ADC.B #$00                
                    STA $0B                   
                    LDA.B #$08                
                    STA $06                   
                    STA $07                   
                    JSL.L ADDR_03B664         
                    JSL.L ADDR_03B72B         
                    BCC ADDR_028CFA           
                    JSL.L HurtMario           
ADDR_028CFA:        DEC.W $1850,X             
                    BEQ ADDR_028D62           
ADDR_028CFF:        LDY.W BrokenBlock,X       
                    LDA.W $1808,X             
                    SEC                       
                    SBC $1A                   
                    STA $00                   
                    LDA.W $18EA,X             
                    SBC $1B                   
                    BNE ADDR_028D41           
                    LDA $00                   
                    STA.W $0200,Y             
                    LDA.W $17FC,X             
                    SEC                       
                    SBC $1C                   
                    CMP.B #$F0                
                    BCS ADDR_028D62           
                    STA.W $0201,Y             
                    LDA.W BooStreamTiles,X    
                    STA.W $0202,Y             
                    LDA.W $182C,X             
                    LSR                       
                    AND.B #$40                
                    EOR.B #$40                
                    ORA $64                   
                    ORA.B #$0F                
                    STA.W $0203,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$02                
                    STA.W $0420,Y             
ADDR_028D41:        RTS                       ; Return 


WaterSplashTiles:   .db $68,$68,$6A,$6A,$6A,$62,$62,$62
                    .db $64,$64,$64,$64,$66

ADDR_028D4F:        LDA.W $1808,X             
                    CMP $1A                   
                    LDA.W $18EA,X             
                    SBC $1B                   
                    BNE ADDR_028D62           
                    LDA.W $1850,X             
                    CMP.B #$20                
                    BNE ADDR_028D66           
ADDR_028D62:        STZ.W $17F0,X             
                    RTS                       ; Return 

ADDR_028D66:        STZ $00                   
                    CMP.B #$10                
                    BCC ADDR_028D8B           
                    AND.B #$01                
                    ORA $9D                   
                    BNE ADDR_028D75           
                    INC.W $17FC,X             
ADDR_028D75:        LDA.W $1850,X             
                    SEC                       
                    SBC.B #$10                
                    LSR                       
                    LSR                       
                    STA $02                   
                    LDA $13                   
                    LSR                       
                    LDA $02                   
                    BCC ADDR_028D89           
                    EOR.B #$FF                
                    INC A                     
ADDR_028D89:        STA $00                   
ADDR_028D8B:        LDY.W BrokenBlock,X       
                    LDA.W $1808,X             
                    CLC                       
                    ADC $00                   
                    SEC                       
                    SBC $1A                   
                    CMP.B #$F0                
                    BCS ADDR_028D62           
                    STA.W $0200,Y             
                    LDA.W $17FC,X             
                    SEC                       
                    SBC $1C                   
                    CMP.B #$E8                
                    BCS ADDR_028D62           
                    STA.W $0201,Y             
                    LDA.W $1850,X             
                    LSR                       
                    TAX                       
                    CPX.B #$0C                
                    BCC ADDR_028DB6           
                    LDX.B #$0C                
ADDR_028DB6:        LDA.W WaterSplashTiles,X  
                    LDX.W $1698               
                    STA.W $0202,Y             
                    LDA $64                   
                    ORA.B #$02                
                    STA.W $0203,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$02                
                    STA.W $0420,Y             
                    LDA $9D                   
                    BNE ADDR_028DD6           
                    INC.W $1850,X             
ADDR_028DD6:        RTS                       ; Return 


RipVanFishZsTiles:  .db $F1,$F0,$E1,$E0

ADDR_028DDB:        LDA $9D                   
                    BNE ADDR_028E20           
                    LDA.W $1850,X             
                    BEQ ADDR_028DE7           
                    DEC.W $1850,X             
ADDR_028DE7:        LDA.W $1850,X             
                    AND.B #$00                
                    BNE ADDR_028DFE           
                    LDA.W $1850,X             
                    INC.W $182C,X             
                    AND.B #$10                
                    BNE ADDR_028DFE           
                    DEC.W $182C,X             
                    DEC.W $182C,X             
ADDR_028DFE:        LDA.W $182C,X             
                    PHA                       
                    LDY.W $17F0,X             
                    CPY.B #$09                
                    BNE ADDR_028E0F           
                    EOR.B #$FF                
                    INC A                     
                    STA.W $182C,X             
ADDR_028E0F:        JSR.W ADDR_02B5BC         
                    PLA                       
                    STA.W $182C,X             
                    LDA.W $1850,X             
                    AND.B #$03                
                    BNE ADDR_028E20           
                    DEC.W $17FC,X             
ADDR_028E20:        LDY.W BrokenBlock,X       
                    LDA.W $1808,X             
                    SEC                       
                    SBC $1A                   
                    CMP.B #$08                
                    BCC ADDR_028E76           
                    CMP.B #$FC                
                    BCS ADDR_028E76           
                    STA.W $0200,Y             
                    LDA.W $17FC,X             
                    SEC                       
                    SBC $1C                   
                    CMP.B #$F0                
                    BCS ADDR_028E76           
                    STA.W $0201,Y             
                    LDA $64                   
                    ORA.B #$03                
                    STA.W $0203,Y             
                    LDA.W $1850,X             
                    CMP.B #$14                
                    BEQ ADDR_028E76           
                    LDA.W $17F0,X             
                    CMP.B #$08                
                    LDA.B #$7F                
                    BCS ADDR_028E66           
                    LDA.W $1850,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.B #$03                
                    TAX                       
                    LDA.W RipVanFishZsTiles,X 
ADDR_028E66:        STA.W $0202,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$00                
                    STA.W $0420,Y             
                    LDX.W $1698               
                    RTS                       ; Return 

ADDR_028E76:        STZ.W $17F0,X             
                    RTS                       ; Return 


DATA_028E7A:        .db $03,$43,$83,$C3

ADDR_028E7E:        DEC.W $1850,X             
                    LDA.W $1850,X             
                    AND.B #$3F                
                    BEQ ADDR_028ED7           
                    JSR.W ADDR_02B5BC         
                    JSR.W ADDR_02B5C8         
                    INC.W $1820,X             
                    INC.W $1820,X             
                    LDY.W BrokenBlock,X       
                    LDA.W $17FC,X             
                    SEC                       
                    SBC $1C                   
                    CMP.B #$F0                
                    BCS ADDR_028ED7           
                    STA.W $0201,Y             
                    LDA.W $1808,X             
                    SEC                       
                    SBC $1A                   
                    CMP.B #$F8                
                    BCS ADDR_028ED7           
                    STA.W $0200,Y             
                    LDA.B #$6F                
                    STA.W $0202,Y             
                    LDA.W $1850,X             
                    AND.B #$C0                
                    ORA.B #$03                
                    ORA $64                   
                    STA.W $0203,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$00                
                    STA.W $0420,Y             
                    RTS                       ; Return 


StarSparkleTiles:   .db $66,$6E,$FF,$6D,$6C,$5C

ADDR_028ED2:        LDA.W $1850,X             
                    BNE ADDR_028EDA           
ADDR_028ED7:        JMP.W ADDR_028F87         
ADDR_028EDA:        LDY $9D                   
                    BNE ADDR_028EE1           
                    DEC.W $1850,X             
ADDR_028EE1:        LDY.W BrokenBlock,X       
                    LDA.W $1808,X             
                    SEC                       
                    SBC $1A                   
                    CMP.B #$F0                
                    BCS ADDR_028ED7           
                    STA.W $0200,Y             
                    LDA.W $17FC,X             
                    SEC                       
                    SBC $1C                   
                    CMP.B #$F0                
                    BCS ADDR_028ED7           
                    STA.W $0201,Y             
                    LDA.W $17F0,X             
                    PHA                       
                    LDA.W $1850,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    TAX                       
                    PLA                       
                    CMP.B #$05                
                    BNE ADDR_028F11           
                    INX                       
                    INX                       
                    INX                       
ADDR_028F11:        LDA.W StarSparkleTiles,X  
                    STA.W $0202,Y             
                    LDA $64                   
                    ORA.B #$06                
                    STA.W $0203,Y             
                    LDX.W $1698               
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$00                
                    STA.W $0420,Y             
                    RTS                       ; Return 


LavaSplashTiles:    .db $D7,$C7,$D6,$C6

ADDR_028F2F:        LDA.W $1808,X             
                    CMP $1A                   
                    LDA.W $18EA,X             
                    SBC $1B                   
                    BNE ADDR_028F87           
                    LDA.W $1850,X             
                    BEQ ADDR_028F87           
                    LDY $9D                   
                    BNE ADDR_028F4D           
                    DEC.W $1850,X             
                    JSR.W ADDR_02B5C8         
                    INC.W $1820,X             
ADDR_028F4D:        LDY.W BrokenBlock,X       
                    LDA.W $1808,X             
                    SEC                       
                    SBC $1A                   
                    STA.W $0200,Y             
                    LDA.W $17FC,X             
                    CMP.B #$F0                
                    BCS ADDR_028F87           
                    SEC                       
                    SBC $1C                   
                    STA.W $0201,Y             
                    LDA.W $1850,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W LavaSplashTiles,X   
                    STA.W $0202,Y             
                    LDA $64                   
                    ORA.B #$05                
                    STA.W $0203,Y             
                    LDX.W $1698               
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$00                
                    STA.W $0420,Y             
                    RTS                       ; Return 

ADDR_028F87:        STZ.W $17F0,X             
                    RTS                       ; Return 

ADDR_028F8B:        LDA $9D                   
                    BNE ADDR_028FCA           
                    LDA $13                   
                    AND.B #$03                
                    BEQ ADDR_028FAB           
                    LDY.B #$00                
                    LDA.W $182C,X             
                    BPL ADDR_028F9D           
                    DEY                       
ADDR_028F9D:        CLC                       
                    ADC.W $1808,X             
                    STA.W $1808,X             
                    TYA                       
                    ADC.W $18EA,X             
                    STA.W $18EA,X             
ADDR_028FAB:        LDY.B #$00                
                    LDA.W $1820,X             
                    BPL ADDR_028FB3           
                    DEY                       
ADDR_028FB3:        CLC                       
                    ADC.W $17FC,X             
                    STA.W $17FC,X             
                    TYA                       
                    ADC.W $1814,X             
                    STA.W $1814,X             
                    LDA $13                   
                    AND.B #$03                
                    BNE ADDR_028FCA           
                    INC.W $1820,X             
ADDR_028FCA:        LDA.W $17FC,X             
                    SEC                       
                    SBC $1C                   
                    STA $00                   
                    LDA.W $1814,X             
                    SBC $1D                   
                    BEQ ADDR_028FDD           
                    BPL ADDR_028F87           
                    BMI ADDR_02902C           
ADDR_028FDD:        LDY.W BrokenBlock,X       
                    LDA.W $1808,X             
                    SEC                       
                    SBC $1A                   
                    STA $01                   
                    LDA.W $18EA,X             
                    SBC $1B                   
                    BNE ADDR_028F87           
                    LDA $01                   
                    STA.W $0200,Y             
                    LDA $00                   
                    CMP.B #$F0                
                    BCS ADDR_028F87           
                    STA.W $0201,Y             
                    LDA.W $1850,X             
                    PHA                       
                    LDA $14                   
                    LSR                       
                    CLC                       
                    ADC.W $1698               
                    AND.B #$07                
                    TAX                       
                    LDA.W BrokenBlock2,X      
                    STA.W $0202,Y             
                    PLA                       
                    BEQ ADDR_029018           
                    LDA $13                   
                    AND.B #$0E                
ADDR_029018:        EOR.W DATA_028B8C,X       
                    ORA $64                   
                    STA.W $0203,Y             
                    LDX.W $1698               
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$00                
                    STA.W $0420,Y             
ADDR_02902C:        RTS                       ; Return 

ADDR_02902D:        LDA.W $186B               
                    CMP.B #$02                
                    BCC ADDR_02903B           
                    LDA $9D                   
                    BNE ADDR_02903B           
                    DEC.W $186B               
ADDR_02903B:        LDX.B #$03                
ADDR_02903D:        STX.W $1698               
                    JSR.W ADDR_02904D         
                    JSR.W ADDR_029398         
                    JSR.W ADDR_0296C0         
                    DEX                       
                    BPL ADDR_02903D           
ADDR_02904C:        RTS                       ; Return 

ADDR_02904D:        LDA.W $1699,X             
                    BEQ ADDR_02904C           
                    LDY $9D                   
                    BNE ADDR_02905E           
                    LDY.W $16C5,X             
                    BEQ ADDR_02905E           
                    DEC.W $16C5,X             
ADDR_02905E:        JSL.L ExecutePtr          

Ptrs029062:         .dw ADDR_02904C           
                    .dw ADDR_0290DE           
                    .dw ADDR_0290DE           
                    .dw ADDR_0290DE           
                    .dw ADDR_0290DE           
                    .dw ADDR_0290DE           
                    .dw ADDR_0290DE           
                    .dw ADDR_029076           

DATA_029072:        .db $13,$00,$00,$ED

ADDR_029076:        LDA $9D                   
                    BNE ADDR_0290CD           
                    LDA.W $169D,X             
                    BNE ADDR_029085           
                    INC.W $169D,X             
                    JSR.W ADDR_0291B8         
ADDR_029085:        LDA.W $16C5,X             
                    BEQ ADDR_0290BB           
                    CMP.B #$01                
                    BNE ADDR_0290A8           
                    LDA.W $16A1,X             
                    CLC                       
                    ADC.B #$08                
                    AND.B #$F0                
                    STA.W $16A1,X             
                    LDA.W $16A9,X             
                    ADC.B #$00                
                    STA.W $16A9,X             
                    LDA.B #$05                
                    JSR.W ADDR_0291BA         
                    BRA ADDR_0290BB           
ADDR_0290A8:        JSR.W ADDR_02B526         
                    LDY.W $16C9,X             
                    LDA.W $16B1,X             
                    CLC                       
                    ADC.W DATA_029072,Y       
                    STA.W $16B1,X             
                    JSR.W ADDR_0291F8         
ADDR_0290BB:        LDA.W $18CE,X             
                    BEQ ADDR_0290C4           
                    DEC.W $18CE,X             
                    RTS                       ; Return 

ADDR_0290C4:        LDA.W $16C1,X             
                    JSR.W ADDR_0291BA         
                    STZ.W $1699,X             
ADDR_0290CD:        RTS                       ; Return 


DATA_0290CE:        .db $10,$00,$00,$F0

DATA_0290D2:        .db $00,$F0,$10,$00

DATA_0290D6:        .db $80,$80,$80,$00

DATA_0290DA:        .db $80,$E0,$20,$80

ADDR_0290DE:        JSR.W ADDR_0291F8         
                    LDA $9D                   
                    BNE ADDR_0290CD           
                    LDA.W $169D,X             
                    BNE ADDR_02910B           
                    INC.W $169D,X             
                    JSR.W ADDR_029265         
                    JSR.W ADDR_0291B8         
                    LDA.W $16C9,X             
                    AND.B #$03                
                    TAY                       
                    LDA.W DATA_0290D6,Y       
                    CMP.B #$80                
                    BEQ ADDR_029102           
                    STA $7D                   
ADDR_029102:        LDA.W DATA_0290DA,Y       
                    CMP.B #$80                
                    BEQ ADDR_02910B           
                    STA $7B                   
ADDR_02910B:        JSR.W ADDR_02B526         
                    JSR.W ADDR_02B51A         
                    LDA.W $16C9,X             
                    AND.B #$03                
                    TAY                       
                    LDA.W $16B1,X             
                    CLC                       
                    ADC.W DATA_0290CE,Y       
                    STA.W $16B1,X             
                    LDA.W $16B5,X             
                    CLC                       
                    ADC.W DATA_0290D2,Y       
                    STA.W $16B5,X             
                    LDA.W $16C9,X             
                    AND.B #$03                
                    CMP.B #$03                
                    BNE ADDR_02915E           
                    LDA $71                   
                    CMP.B #$01                
                    BCS ADDR_02915E           
                    LDA.B #$20                
                    LDY.W $187A               
                    BEQ ADDR_029143           
                    LDA.B #$30                
ADDR_029143:        STA $00                   
                    LDA.W $16A1,X             
                    SEC                       
                    SBC $00                   
                    STA $96                   
                    LDA.W $16A9,X             
                    SBC.B #$00                
                    STA $97                   
                    LDA.B #$01                
                    STA.W $1471               
                    STA.W $1402               
                    STZ $7D                   
ADDR_02915E:        LDA.W $16C5,X             
                    BNE ADDR_02919C           
                    LDA.W $16C9,X             
                    AND.B #$03                
                    CMP.B #$03                
                    BNE ADDR_029182           
                    LDA.B #$A0                
                    STA $7D                   
                    LDA $96                   
                    SEC                       
                    SBC.B #$02                
                    STA $96                   
                    LDA $97                   
                    SBC.B #$00                
                    STA $97                   
                    LDA.B #$08                
                    STA.W $1DFC               ; / Play sound effect 
ADDR_029182:        JSR.W ADDR_02919F         
                    LDY.W $1699,X             
                    CPY.B #$06                
                    BCC ADDR_029199           
                    LDA.B #$0B                
                    STA.W $1DF9               ; / Play sound effect 
                    LDA.W $14AF               
                    EOR.B #$01                
                    STA.W $14AF               
ADDR_029199:        STZ.W $1699,X             
ADDR_02919C:        RTS                       ; Return 


DATA_02919D:        .db $01,$00

ADDR_02919F:        LDA.W $16C1,X             
                    CMP.B #$0A                
                    BEQ ADDR_0291AA           
                    CMP.B #$0B                
                    BNE ADDR_0291B6           
ADDR_0291AA:        LDY.W $186B               
                    CPY.B #$01                
                    BNE ADDR_0291B6           
                    STZ.W $186B               
                    LDA.B #$0D                
ADDR_0291B6:        BRA ADDR_0291BA           
ADDR_0291B8:        LDA.B #$09                
ADDR_0291BA:        STA $9C                   
                    LDA.W $16A5,X             
                    CLC                       
                    ADC.B #$08                
                    AND.B #$F0                
                    STA $9A                   
                    LDA.W $16AD,X             
                    ADC.B #$00                
                    STA $9B                   
                    LDA.W $16A1,X             
                    CLC                       
                    ADC.B #$08                
                    AND.B #$F0                
                    STA $98                   
                    LDA.W $16A9,X             
                    ADC.B #$00                
                    STA $99                   
                    LDA.W $16C9,X             
                    ASL                       
                    ROL                       
                    AND.B #$01                
                    STA.W $1933               
                    JSL.L ADDR_00BEB0         
ADDR_0291EC:        RTS                       ; Return 


DATA_0291ED:        .db $10,$14,$18

BlockBounceTiles:   .db $1C,$40,$6B,$2A,$42,$EA,$8A,$40

ADDR_0291F8:        LDY.B #$00                
                    LDA.W $16C9,X             
                    BPL ADDR_029201           
                    LDY.B #$04                
ADDR_029201:        LDA.W $001C,Y             
                    STA $02                   
                    LDA.W $001A,Y             
                    STA $03                   
                    LDA.W $001D,Y             
                    STA $04                   
                    LDA.W $001B,Y             
                    STA $05                   
                    LDA.W $16A1,X             
                    CMP $02                   
                    LDA.W $16A9,X             
                    SBC $04                   
                    BNE ADDR_0291EC           
                    LDA.W $16A5,X             
                    CMP $03                   
                    LDA.W $16AD,X             
                    SBC $05                   
                    BNE ADDR_0291EC           
                    LDY.W DATA_0291ED,X       
                    LDA.W $16A1,X             
                    SEC                       
                    SBC $02                   
                    STA $01                   
                    STA.W $0201,Y             
                    LDA.W $16A5,X             
                    SEC                       
                    SBC $03                   
                    STA $00                   
                    STA.W $0200,Y             
                    LDA.W $1901,X             
                    ORA $64                   
                    STA.W $0203,Y             
                    LDA.W $1699,X             
                    TAX                       
                    LDA.W BlockBounceTiles,X  
                    STA.W $0202,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$02                
                    STA.W $0420,Y             
                    LDX.W $1698               
                    RTS                       ; Return 

ADDR_029265:        LDA.B #$01                
                    LDY.W $16C9,X             
                    STY $0F                   
                    BPL ADDR_02926F           
                    ASL                       
ADDR_02926F:        AND $5B                   
                    BEQ ADDR_0292CA           
                    LDA.W $16A1,X             
                    SEC                       
                    SBC.B #$03                
                    AND.B #$F0                
                    STA $00                   
                    LDA.W $16A9,X             
                    SBC.B #$00                
                    CMP $5D                   
                    BCS ADDR_0292C9           
                    STA $03                   
                    AND.B #$10                
                    STA $08                   
                    LDA.W $16A5,X             
                    STA $01                   
                    LDA.W $16AD,X             
                    CMP.B #$02                
                    BCS ADDR_0292C9           
                    STA $02                   
                    LDA $01                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    ORA $00                   
                    STA $00                   
                    LDX $03                   
                    LDA.L DATA_00BA80,X       
                    LDY $0F                   
                    BEQ ADDR_0292B2           
                    LDA.L DATA_00BA8E,X       
ADDR_0292B2:        CLC                       
                    ADC $00                   
                    STA $05                   
                    LDA.L DATA_00BABC,X       
                    LDY $0F                   
                    BEQ ADDR_0292C3           
                    LDA.L DATA_00BACA,X       
ADDR_0292C3:        ADC $02                   
                    STA $06                   
                    BRA ADDR_02931A           
ADDR_0292C9:        RTS                       ; Return 

ADDR_0292CA:        LDA.W $16A1,X             
                    SEC                       
                    SBC.B #$03                
                    AND.B #$F0                
                    STA $00                   
                    LDA.W $16A9,X             
                    SBC.B #$00                
                    CMP.B #$02                
                    BCS ADDR_0292C9           
                    STA $02                   
                    LDA.W $16A5,X             
                    STA $01                   
                    LDA.W $16AD,X             
                    CMP $5D                   
                    BCS ADDR_0292C9           
                    STA $03                   
                    LDA $01                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    ORA $00                   
                    STA $00                   
                    LDX $03                   
                    LDA.L DATA_00BA60,X       
                    LDY $0F                   
                    BEQ ADDR_029305           
                    LDA.L DATA_00BA70,X       
ADDR_029305:        CLC                       
                    ADC $00                   
                    STA $05                   
                    LDA.L DATA_00BA9C,X       
                    LDY $0F                   
                    BEQ ADDR_029316           
                    LDA.L DATA_00BAAC,X       
ADDR_029316:        ADC $02                   
                    STA $06                   
ADDR_02931A:        LDA.B #$7E                
                    STA $07                   
                    LDX.W $1698               
                    LDA [$05]                 
                    STA.W $1693               
                    INC $07                   
                    LDA [$05]                 
                    BNE ADDR_029355           
                    LDA.W $1693               
                    CMP.B #$2B                
                    BNE ADDR_029355           
                    LDA.W $16A1,X             
                    PHA                       
                    SBC.B #$03                
                    AND.B #$F0                
                    STA.W $16A1,X             
                    LDA.W $16A9,X             
                    PHA                       
                    SBC.B #$00                
                    STA.W $16A9,X             
                    JSR.W ADDR_0291B8         
                    JSR.W ADDR_029356         
                    PLA                       
                    STA.W $16A9,X             
                    PLA                       
                    STA.W $16A1,X             
ADDR_029355:        RTS                       ; Return 

ADDR_029356:        LDY.B #$03                
ADDR_029358:        LDA.W $17D0,Y             
                    BEQ ADDR_029361           
                    DEY                       
                    BPL ADDR_029358           
                    INY                       
ADDR_029361:        LDA.B #$01                
                    STA.W $17D0,Y             
                    JSL.L ADDR_05B34A         
                    LDA.W $16A5,X             
                    STA.W $17E0,Y             
                    LDA.W $16AD,X             
                    STA.W $17EC,Y             
                    LDA.W $16A1,X             
                    STA.W $17D4,Y             
                    LDA.W $16A9,X             
                    STA.W $17E8,Y             
                    LDA.W $16C9,X             
                    ASL                       
                    ROL                       
                    AND.B #$01                
                    STA.W $17E4,Y             
                    LDA.B #$D0                
                    STA.W $17D8,Y             
ADDR_029391:        RTS                       ; Return 


DATA_029392:        .db $F8,$08

ADDR_029394:        STZ.W $16CD,X             
ADDR_029397:        RTS                       ; Return 

ADDR_029398:        LDA.W $16CD,X             
                    BEQ ADDR_029397           
                    DEC.W $18F8,X             
                    BEQ ADDR_029394           
                    LDA.W $18F8,X             
                    CMP.B #$03                
                    BCS ADDR_029391           
                    LDY.W $1698               
                    STZ $0E                   
ADDR_0293AE:        LDX.B #$0B                
ADDR_0293B0:        STX.W $15E9               
                    LDA.W $14C8,X             
                    CMP.B #$0B                
                    BEQ ADDR_0293F7           
                    CMP.B #$08                
                    BCC ADDR_0293F7           
                    LDA.W $166E,X             
                    AND.B #$20                
                    ORA.W $15D0,X             
                    ORA.W $154C,X             
                    ORA.W $1FE2,X             
                    BNE ADDR_0293F7           
                    LDA.W $1632,X             
                    PHY                       
                    LDY $74                   
                    BEQ ADDR_0293D8           
                    EOR.B #$01                
ADDR_0293D8:        PLY                       
                    EOR.W $13F9               
                    BNE ADDR_0293F7           
                    JSL.L ADDR_03B69F         
                    LDA $0E                   
                    BEQ ADDR_0293EB           
                    JSR.W ADDR_029696         
                    BRA ADDR_0293EE           
ADDR_0293EB:        JSR.W ADDR_029663         
ADDR_0293EE:        JSL.L ADDR_03B72B         
                    BCC ADDR_0293F7           
                    JSR.W ADDR_029404         
ADDR_0293F7:        LDY.W $1698               
                    DEX                       
                    BMI ADDR_029400           
                    JMP.W ADDR_0293B0         
ADDR_029400:        LDX.W $1698               
                    RTS                       ; Return 

ADDR_029404:        LDA.B #$08                
                    STA.W $154C,X             
                    LDA $9E,X                 
                    CMP.B #$81                
                    BNE ADDR_029427           
                    LDA $C2,X                 
                    BEQ ADDR_029426           
                    STZ $C2,X                 
                    LDA.B #$C0                
                    STA $AA,X                 
                    LDA.B #$10                
                    STA.W $1540,X             
                    STZ.W $157C,X             
                    LDA.B #$20                
                    STA.W $1558,X             
ADDR_029426:        RTS                       ; Return 

ADDR_029427:        CMP.B #$2D                
                    BEQ ADDR_029448           
                    LDA.W $167A,X             
                    AND.B #$02                
                    BNE ADDR_0294A2           
                    LDA.W $14C8,X             
                    CMP.B #$08                
                    BEQ ADDR_029443           
                    LDA $9E,X                 
                    CMP.B #$0D                
                    BEQ ADDR_029448           
                    LDA $C2,X                 
                    BEQ ADDR_029448           
ADDR_029443:        LDA.B #$FF                
                    STA.W $1540,X             
ADDR_029448:        STZ.W $1558,X             
                    LDA $0E                   
                    CMP.B #$35                
                    BEQ ADDR_029455           
                    JSL.L ADDR_01AB6F         
ADDR_029455:        LDA.B #$00                
                    JSL.L GivePoints          
                    LDA.B #$02                
                    STA.W $14C8,X             
                    LDA $9E,X                 
                    CMP.B #$1E                
                    BNE ADDR_02946B           
                    LDA.B #$1F                
                    STA.W $1549               
ADDR_02946B:        LDA.W $1662,X             
                    AND.B #$80                
                    BNE ADDR_0294A2           
                    LDA.W $1656,X             
                    AND.B #$10                
                    BEQ ADDR_0294A2           
                    LDA.W $1656,X             
                    AND.B #$20                
                    BNE ADDR_0294A2           
                    LDA.B #$09                
                    STA.W $14C8,X             
                    ASL.W $15F6,X             
                    SEC                       
                    ROR.W $15F6,X             
                    LDA.W $1686,X             
                    AND.B #$40                
                    BEQ ADDR_0294A2           
                    PHX                       
                    LDA $9E,X                 
                    TAX                       
                    LDA.L DATA_01A7C9,X       
                    PLX                       
                    STA $9E,X                 
                    JSL.L ADDR_07F78B         
ADDR_0294A2:        LDA.B #$C0                
                    LDY $0E                   
                    BEQ ADDR_0294B0           
                    LDA.B #$B0                
                    CPY.B #$02                
                    BNE ADDR_0294B0           
                    LDA.B #$C0                
ADDR_0294B0:        STA $AA,X                 
                    JSR.W ADDR_02848D         
                    LDA.W DATA_029392,Y       
                    STA $B6,X                 
                    TYA                       
                    EOR.B #$01                
                    STA.W $157C,X             
                    RTS                       ; Return 

ADDR_0294C1:        LDA.B #$30                
                    STA.W $1887               
                    STZ.W $14A9               
                    PHB                       
                    PHK                       
                    PLB                       
                    LDX.B #$09                
ADDR_0294CE:        LDA.W $14C8,X             
                    CMP.B #$08                
                    BCC ADDR_0294F0           
                    LDA.W $1588,X             
                    AND.B #$04                
                    BEQ ADDR_0294F0           
                    LDA.W $166E,X             
                    AND.B #$20                
                    ORA.W $15D0,X             
                    ORA.W $154C,X             
                    BNE ADDR_0294F0           
                    LDA.B #$35                
                    STA $0E                   
                    JSR.W ADDR_029404         
ADDR_0294F0:        DEX                       
                    BPL ADDR_0294CE           
                    PLB                       
                    RTL                       ; Return 

ADDR_0294F5:        LDA.W $13E8               
                    BEQ ADDR_02950A           
                    STA $0E                   
                    LDA $13                   
                    LSR                       
                    BCC ADDR_029507           
                    JSR.W ADDR_0293AE         
                    JSR.W ADDR_029631         
ADDR_029507:        JSR.W ADDR_02950B         
ADDR_02950A:        RTS                       ; Return 

ADDR_02950B:        STZ $0F                   
                    JSR.W ADDR_029540         
                    LDA $5B                   
                    BPL ADDR_02953B           
                    INC $0F                   
                    LDA.W $13E9               
                    CLC                       
                    ADC $26                   
                    STA.W $13E9               
                    LDA.W $13EA               
                    ADC $27                   
                    STA.W $13EA               
                    LDA.W $13EB               
                    CLC                       
                    ADC $28                   
                    STA.W $13EB               
                    LDA.W $13EC               
                    ADC $29                   
                    STA.W $13EC               
                    JSR.W ADDR_029540         
ADDR_02953B:        RTS                       ; Return 


DATA_02953C:        .db $08,$08

DATA_02953E:        .db $02,$0E

ADDR_029540:        LDA $13                   
                    AND.B #$01                
                    TAY                       
                    LDA $0F                   
                    INC A                     
                    AND $5B                   
                    BEQ ADDR_0295AE           
                    LDA.W $13EB               
                    CLC                       
                    ADC.W DATA_02953C,Y       
                    AND.B #$F0                
                    STA $00                   
                    STA $98                   
                    LDA.W $13EC               
                    ADC.B #$00                
                    CMP $5D                   
                    BCS ADDR_0295AD           
                    STA $03                   
                    STA $99                   
                    LDA.W $13E9               
                    CLC                       
                    ADC.W DATA_02953E,Y       
                    STA $01                   
                    STA $9A                   
                    LDA.W $13EA               
                    ADC.B #$00                
                    CMP.B #$02                
                    BCS ADDR_0295AD           
                    STA $02                   
                    STA $9B                   
                    LDA $01                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    ORA $00                   
                    STA $00                   
                    LDX $03                   
                    LDA.L DATA_00BA80,X       
                    LDY $0F                   
                    BEQ ADDR_029596           
                    LDA.L DATA_00BA8E,X       
ADDR_029596:        CLC                       
                    ADC $00                   
                    STA $05                   
                    LDA.L DATA_00BABC,X       
                    LDY $0F                   
                    BEQ ADDR_0295A7           
                    LDA.L DATA_00BACA,X       
ADDR_0295A7:        ADC $02                   
                    STA $06                   
                    BRA ADDR_02960D           
ADDR_0295AD:        RTS                       ; Return 

ADDR_0295AE:        LDA.W $13EB               
                    CLC                       
                    ADC.W DATA_02953C,Y       
                    AND.B #$F0                
                    STA $00                   
                    STA $98                   
                    LDA.W $13EC               
                    ADC.B #$00                
                    CMP.B #$02                
                    BCS ADDR_0295AD           
                    STA $02                   
                    STA $99                   
                    LDA.W $13E9               
                    CLC                       
                    ADC.W DATA_02953E,Y       
                    STA $01                   
                    STA $9A                   
                    LDA.W $13EA               
                    ADC.B #$00                
                    CMP $5D                   
                    BCS ADDR_0295AD           
                    STA $03                   
                    STA $9B                   
                    LDA $01                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    ORA $00                   
                    STA $00                   
                    LDX $03                   
                    LDA.L DATA_00BA60,X       
                    LDY $0F                   
                    BEQ ADDR_0295F8           
                    LDA.L DATA_00BA70,X       
ADDR_0295F8:        CLC                       
                    ADC $00                   
                    STA $05                   
                    LDA.L DATA_00BA9C,X       
                    LDY $0F                   
                    BEQ ADDR_029609           
                    LDA.L DATA_00BAAC,X       
ADDR_029609:        ADC $02                   
                    STA $06                   
ADDR_02960D:        LDA.B #$7E                
                    STA $07                   
                    LDA [$05]                 
                    STA.W $1693               
                    INC $07                   
                    LDA [$05]                 
                    JSL.L ADDR_00F545         
                    CMP.B #$00                
                    BEQ ADDR_029630           
                    LDA $0F                   
                    STA.W $1933               
                    LDA.W $1693               
                    LDY.B #$00                
                    JSL.L ADDR_00F160         
ADDR_029630:        RTS                       ; Return 

ADDR_029631:        LDX.B #$07                
ADDR_029633:        STX.W $15E9               
                    LDA.W $170B,X             
                    CMP.B #$02                
                    BCC ADDR_029653           
                    JSR.W ADDR_02A519         
                    JSR.W ADDR_029696         
                    JSL.L ADDR_03B72B         
                    BCC ADDR_029653           
                    LDA.W $170B,X             
                    CMP.B #$12                
                    BEQ ADDR_029653           
                    JSR.W ADDR_02A4DE         
ADDR_029653:        DEX                       
                    BPL ADDR_029633           
ADDR_029656:        RTS                       ; Return 


DATA_029657:        .db $FC

DATA_029658:        .db $E0,$FF

DATA_02965A:        .db $FF,$18

DATA_02965C:        .db $50,$FC

DATA_02965E:        .db $F8,$FF

DATA_029660:        .db $FF,$18,$10

ADDR_029663:        PHX                       
                    LDA.W $16CD,Y             
                    TAX                       
                    LDA.W $16D1,Y             
                    CLC                       
                    ADC.W ADDR_029656,X       
                    STA $00                   
                    LDA.W $16D5,Y             
                    ADC.W DATA_029658,X       
                    STA $08                   
                    LDA.W DATA_02965A,X       
                    STA $02                   
                    LDA.W $16D9,Y             
                    CLC                       
                    ADC.W DATA_02965C,X       
                    STA $01                   
                    LDA.W $16DD,Y             
                    ADC.W DATA_02965E,X       
                    STA $09                   
                    LDA.W DATA_029660,X       
                    STA $03                   
                    PLX                       
                    RTS                       ; Return 

ADDR_029696:        LDA.W $13E9               
                    SEC                       
                    SBC.B #$02                
                    STA $00                   
                    LDA.W $13EA               
                    SBC.B #$00                
                    STA $08                   
                    LDA.B #$14                
                    STA $02                   
                    LDA.W $13EB               
                    STA $01                   
                    LDA.W $13EC               
                    STA $09                   
                    LDA.B #$10                
                    STA $03                   
                    RTS                       ; Return 


DATA_0296B8:        .db $20,$24,$28,$2C

DATA_0296BC:        .db $90,$94,$98,$9C

ADDR_0296C0:        LDA.W $17C0,X             
                    BEQ ADDR_0296D7           
                    AND.B #$7F                
                    JSL.L ExecutePtr          

Ptrs0296CB:         .dw ADDR_0296D7           
                    .dw ADDR_0296E3           
                    .dw ADDR_029797           
                    .dw ADDR_029927           
                    .dw ADDR_0296D7           
                    .dw ADDR_0298CA           

ADDR_0296D7:        RTS                       ; Return 


DATA_0296D8:        .db $66,$66,$64,$62,$60,$62,$60

ADDR_0296DF:        STZ.W $17C0,X             
                    RTS                       ; Return 

ADDR_0296E3:        LDA.W $17CC,X             
                    BEQ ADDR_0296DF           
                    LDA.W $17C0,X             
                    BMI ADDR_0296F1           
                    LDA $9D                   
                    BNE ADDR_0296F4           
ADDR_0296F1:        DEC.W $17CC,X             
ADDR_0296F4:        LDA $A5                   
                    CMP.B #$A9                
                    BEQ ADDR_02974A           
                    LDA.W $0D9B               
                    AND.B #$40                
                    BEQ ADDR_02974A           
                    LDY.W DATA_0296BC,X       
                    LDA.W $17C8,X             
                    SEC                       
                    SBC $1A                   
                    CMP.B #$F4                
                    BCS ADDR_0296DF           
                    STA.W $0300,Y             
                    LDA.W $17C4,X             
                    SEC                       
                    SBC $1C                   
                    CMP.B #$E0                
                    BCS ADDR_0296DF           
                    STA.W $0301,Y             
                    LDA.W $17CC,X             
                    CMP.B #$08                
                    LDA.B #$00                
                    BCS ADDR_02972D           
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    AND.B #$40                
ADDR_02972D:        ORA $64                   
                    STA.W $0303,Y             
                    LDA.W $17CC,X             
                    PHY                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_0296D8,Y       
                    PLY                       
                    STA.W $0302,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$02                
                    STA.W $0460,Y             
                    RTS                       ; Return 

ADDR_02974A:        LDY.W DATA_0296B8,X       
                    LDA.W $17C8,X             
                    SEC                       
                    SBC $1A                   
                    CMP.B #$F4                
                    BCS ADDR_029793           
                    STA.W $0200,Y             
                    LDA.W $17C4,X             
                    SEC                       
                    SBC $1C                   
                    CMP.B #$E0                
                    BCS ADDR_029793           
                    STA.W $0201,Y             
                    LDA.W $17CC,X             
                    CMP.B #$08                
                    LDA.B #$00                
                    BCS ADDR_029776           
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    AND.B #$40                
ADDR_029776:        ORA $64                   
                    STA.W $0203,Y             
                    LDA.W $17CC,X             
                    PHY                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_0296D8,Y       
                    PLY                       
                    STA.W $0202,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$02                
                    STA.W $0420,Y             
                    RTS                       ; Return 

ADDR_029793:        STZ.W $17C0,X             
                    RTS                       ; Return 

ADDR_029797:        LDA.W $17CC,X             
                    BEQ ADDR_029793           
                    LDY $9D                   
                    BNE ADDR_0297A3           
                    DEC.W $17CC,X             
ADDR_0297A3:        BIT.W $0D9B               
                    BVC ADDR_0297B2           
                    LDA.W $0D9B               
                    CMP.B #$C1                
                    BEQ ADDR_0297B2           
                    JMP.W ADDR_029838         
ADDR_0297B2:        LDY.B #$F0                
                    LDA.W $17C8,X             
                    SEC                       
                    SBC $1A                   
                    CMP.B #$F0                
                    BCS ADDR_029793           
                    STA.W $0200,Y             
                    STA.W $0208,Y             
                    CLC                       
                    ADC.B #$08                
                    STA.W $0204,Y             
                    STA.W $020C,Y             
                    LDA.W $17C4,X             
                    SEC                       
                    SBC $1C                   
                    STA.W $0201,Y             
                    STA.W $0205,Y             
                    CLC                       
                    ADC.B #$08                
                    STA.W $0209,Y             
                    STA.W $020D,Y             
                    LDA.W $17CC,X             
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    AND.B #$40                
                    ORA $64                   
                    STA.W $0203,Y             
                    STA.W $0207,Y             
                    EOR.B #$C0                
                    STA.W $020B,Y             
                    STA.W $020F,Y             
                    LDA.W $17CC,X             
                    AND.B #$02                
                    BNE ADDR_029815           
                    LDA.B #$7C                
                    STA.W $0202,Y             
                    STA.W $020E,Y             
                    LDA.B #$7D                
                    STA.W $0206,Y             
                    STA.W $020A,Y             
                    BRA ADDR_029825           
ADDR_029815:        LDA.B #$7D                
                    STA.W $0202,Y             
                    STA.W $020E,Y             
                    LDA.B #$7C                
                    STA.W $0206,Y             
                    STA.W $020A,Y             
ADDR_029825:        TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$00                
                    STA.W $0420,Y             
                    STA.W $0421,Y             
                    STA.W $0422,Y             
                    STA.W $0423,Y             
                    RTS                       ; Return 

ADDR_029838:        LDY.B #$90                
                    LDA.W $17C8,X             
                    SEC                       
                    SBC $1A                   
                    CMP.B #$F0                
                    BCS ADDR_0298BE           
                    STA.W $0300,Y             
                    STA.W $0308,Y             
                    CLC                       
                    ADC.B #$08                
                    STA.W $0304,Y             
                    STA.W $030C,Y             
                    LDA.W $17C4,X             
                    SEC                       
                    SBC $1C                   
                    STA.W $0301,Y             
                    STA.W $0305,Y             
                    CLC                       
                    ADC.B #$08                
                    STA.W $0309,Y             
                    STA.W $030D,Y             
                    LDA.W $17CC,X             
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    AND.B #$40                
                    ORA $64                   
                    STA.W $0303,Y             
                    STA.W $0307,Y             
                    EOR.B #$C0                
                    STA.W $030B,Y             
                    STA.W $030F,Y             
                    LDA.W $17CC,X             
                    AND.B #$02                
                    BNE ADDR_02989B           
                    LDA.B #$7C                
                    STA.W $0302,Y             
                    STA.W $030E,Y             
                    LDA.B #$7D                
                    STA.W $0306,Y             
                    STA.W $030A,Y             
                    BRA ADDR_0298AB           
ADDR_02989B:        LDA.B #$7D                
                    STA.W $0302,Y             
                    STA.W $030E,Y             
                    LDA.B #$7C                
                    STA.W $0306,Y             
                    STA.W $030A,Y             
ADDR_0298AB:        TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$00                
                    STA.W $0460,Y             
                    STA.W $0461,Y             
                    STA.W $0462,Y             
                    STA.W $0463,Y             
                    RTS                       ; Return 

ADDR_0298BE:        STZ.W $17C0,X             
                    RTS                       ; Return 


DATA_0298C2:        .db $04,$08,$04,$00

DATA_0298C6:        .db $FC,$04,$0C,$04

ADDR_0298CA:        LDA.W $17CC,X             
                    BEQ ADDR_0298BE           
                    LDY $9D                   
                    BNE ADDR_029921           
                    DEC.W $17CC,X             
                    AND.B #$03                
                    BNE ADDR_029921           
                    LDY.B #$0B                
ADDR_0298DC:        LDA.W $17F0,Y             
                    BEQ ADDR_0298F1           
                    DEY                       
                    BPL ADDR_0298DC           
                    DEC.W $185D               
                    BPL ADDR_0298EE           
                    LDA.B #$0B                
                    STA.W $185D               
ADDR_0298EE:        LDY.W $185D               
ADDR_0298F1:        LDA.B #$02                
                    STA.W $17F0,Y             
                    LDA.W $17C4,X             
                    STA $01                   
                    LDA.W $17C8,X             
                    STA $00                   
                    LDA.W $17CC,X             
                    LSR                       
                    LSR                       
                    AND.B #$03                
                    PHX                       
                    TAX                       
                    LDA.W DATA_0298C2,X       
                    CLC                       
                    ADC $00                   
                    STA.W $1808,Y             
                    LDA.W DATA_0298C6,X       
                    CLC                       
                    ADC $01                   
                    STA.W $17FC,Y             
                    PLX                       
                    LDA.B #$17                
                    STA.W $1850,Y             
ADDR_029921:        RTS                       ; Return 


DATA_029922:        .db $66,$66,$64,$62,$62

ADDR_029927:        LDA.W $17CC,X             
                    BNE ADDR_029941           
                    BIT.W $0D9B               
                    BVC ADDR_02993E           
                    LDA.W $140F               
                    BNE ADDR_02993E           
                    LDY.W DATA_0296BC,X       
                    LDA.B #$F0                
                    STA.W $0301,Y             
ADDR_02993E:        JMP.W ADDR_029793         
ADDR_029941:        LDY $9D                   
                    BNE ADDR_02994F           
                    DEC.W $17CC,X             
                    AND.B #$07                
                    BNE ADDR_02994F           
                    DEC.W $17C4,X             
ADDR_02994F:        LDA $A5                   
                    CMP.B #$A9                
                    BEQ ADDR_02996C           
                    LDA.W $140F               
                    BNE ADDR_02996C           
                    LDA.W $0D9B               
                    BPL ADDR_02996C           
                    CMP.B #$C1                
                    BEQ ADDR_029967           
                    AND.B #$40                
                    BNE ADDR_02999F           
ADDR_029967:        LDY.W DATA_0296BC,X       
                    BRA ADDR_02996F           
ADDR_02996C:        LDY.W DATA_0296B8,X       
ADDR_02996F:        LDA.W $17C8,X             
                    SEC                       
                    SBC $1A                   
                    STA.W $0200,Y             
                    LDA.W $17C4,X             
                    SEC                       
                    SBC $1C                   
                    STA.W $0201,Y             
                    LDA $64                   
                    STA.W $0203,Y             
                    LDA.W $17CC,X             
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W DATA_029922,X       
                    LDX.W $1698               
                    STA.W $0202,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$00                
                    STA.W $0420,Y             
                    RTS                       ; Return 

ADDR_02999F:        LDY.W DATA_0296BC,X       
                    LDA.W $17C8,X             
                    SEC                       
                    SBC $1A                   
                    STA.W $0300,Y             
                    LDA.W $17C4,X             
                    SEC                       
                    SBC $1C                   
                    STA.W $0301,Y             
                    LDA $64                   
                    STA.W $0303,Y             
                    LDA.W $17CC,X             
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W DATA_029922,X       
                    LDX.W $1698               
                    STA.W $0302,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$00                
                    STA.W $0460,Y             
                    RTS                       ; Return 

ADDR_0299D2:        LDX.B #$03                
ADDR_0299D4:        STX.W $15E9               
                    LDA.W $17D0,X             
                    BEQ ADDR_0299DF           
                    JSR.W ADDR_0299F1         
ADDR_0299DF:        DEX                       
                    BPL ADDR_0299D4           
                    RTS                       ; Return 

ADDR_0299E3:        LDA.B #$00                
                    STA.W $17D0,X             
                    RTS                       ; Return 


DATA_0299E9:        .db $30,$38,$40,$48,$EC,$EA,$E8,$EC

ADDR_0299F1:        LDA $9D                   
                    BNE ADDR_029A08           
                    JSR.W ADDR_02B58E         
                    LDA.W $17D8,X             
                    CLC                       
                    ADC.B #$03                
                    STA.W $17D8,X             
                    CMP.B #$20                
                    BMI ADDR_029A08           
                    JMP.W ADDR_029AA8         
ADDR_029A08:        LDA.W $17E4,X             
                    ASL                       
                    ASL                       
                    TAY                       
                    LDA.W $001C,Y             
                    STA $02                   
                    LDA.W $001A,Y             
                    STA $03                   
                    LDA.W $001D,Y             
                    STA $04                   
                    LDA.W $17D4,X             
                    CMP $02                   
                    LDA.W $17E8,X             
                    SBC $04                   
                    BNE ADDR_029A6D           
                    LDA.W $17E0,X             
                    SEC                       
                    SBC $03                   
                    CMP.B #$F8                
                    BCS ADDR_0299E3           
                    STA $00                   
                    LDA.W $17D4,X             
                    SEC                       
                    SBC $02                   
                    STA $01                   
                    LDY.W DATA_0299E9,X       
                    STY $0F                   
                    LDY $0F                   
                    LDA $00                   
                    STA.W $0200,Y             
                    LDA $01                   
                    STA.W $0201,Y             
                    LDA.B #$E8                
                    STA.W $0202,Y             
                    LDA.B #$04                
                    ORA $64                   
                    STA.W $0203,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$02                
                    STA.W $0420,Y             
                    TXA                       
                    CLC                       
                    ADC $14                   
                    LSR                       
                    LSR                       
                    AND.B #$03                
                    BNE ADDR_029A71           
ADDR_029A6D:        RTS                       ; Return 


RollingCoinTiles:   .db $EA,$FA,$EA

ADDR_029A71:        LDY $0F                   
                    PHX                       
                    TAX                       
                    LDA $00                   
                    CLC                       
                    ADC.B #$04                
                    STA.W $0200,Y             
                    STA.W $0204,Y             
                    LDA $01                   
                    CLC                       
                    ADC.B #$08                
                    STA.W $0205,Y             
                    LDA.L ADDR_029A6D,X       
                    STA.W $0202,Y             
                    STA.W $0206,Y             
                    LDA.W $0203,Y             
                    ORA.B #$80                
                    STA.W $0207,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$00                
                    STA.W $0420,Y             
                    STA.W $0421,Y             
                    PLX                       
                    RTS                       ; Return 

ADDR_029AA8:        JSL.L ADDR_02AD34         ;  Find next usable location in score sprite table 
                    LDA.B #$01                
                    STA.W $16E1,Y             ;  add a 10 score sprite 
                    LDA.W $17D4,X             
                    STA.W $16E7,Y             ; set Yposition low byte 
                    LDA.W $17E8,X             
                    STA.W $16F9,Y             ; set Ypos high byte 
                    LDA.W $17E0,X             
                    STA.W $16ED,Y             ; set Xpos low byte 
                    LDA.W $17EC,X             
                    STA.W $16F3,Y             ; set Xpos high byte 
                    LDA.B #$30                
                    STA.W $16FF,Y             ; set initial speed to 30 
                    LDA.W $17E4,X             
                    STA.W $1705,Y             
                    JSR.W ADDR_029ADA         
                    JMP.W ADDR_0299E3         
ADDR_029ADA:        LDY.B #$03                
ADDR_029ADC:        LDA.W $17C0,Y             
                    BEQ ADDR_029AE5           
                    DEY                       
                    BPL ADDR_029ADC           
                    RTS                       ; Return 

ADDR_029AE5:        LDA.B #$05                
                    STA.W $17C0,Y             
                    LDA.W $17E4,X             
                    LSR                       
                    PHP                       
                    LDA.W $17E0,X             
                    BCC ADDR_029AF6           
                    SBC $26                   
ADDR_029AF6:        STA.W $17C8,Y             
                    LDA.W $17D4,X             
                    PLP                       
                    BCC ADDR_029B01           
                    SBC $28                   
ADDR_029B01:        STA.W $17C4,Y             
                    LDA.B #$10                
                    STA.W $17CC,Y             
                    RTS                       ; Return 

ADDR_029B0A:        LDX.B #$09                
ADDR_029B0C:        STX.W $15E9               
                    JSR.W ADDR_029B16         
                    DEX                       
                    BPL ADDR_029B0C           
ADDR_029B15:        RTS                       ; Return 

ADDR_029B16:        LDA.W $170B,X             
                    BEQ ADDR_029B15           
                    LDY $9D                   
                    BNE ADDR_029B27           
                    LDY.W $176F,X             
                    BEQ ADDR_029B27           
                    DEC.W $176F,X             
ADDR_029B27:        JSL.L ExecutePtr          

ExtendedSpritePtrs: .dw ADDR_029B15           
                    .dw ADDR_02A34F           
                    .dw ADDR_02A16B           
                    .dw ADDR_02A219           
                    .dw ADDR_02A2EF           
                    .dw ADDR_029FAF           
                    .dw ADDR_02A254           
                    .dw ADDR_029E86           
                    .dw ADDR_029E3D           
                    .dw ADDR_029D9D           
                    .dw ADDR_029CB5           
                    .dw ADDR_02A2EF           
                    .dw ADDR_029B51           
                    .dw ADDR_02A254           
                    .dw ADDR_029CB5           
                    .dw ADDR_029C3E           
                    .dw ADDR_029C83           
                    .dw ADDR_029F61           
                    .dw ADDR_029EEE           

ADDR_029B51:        LDY.W DATA_02A153,X       
                    LDA.W $171F,X             
                    SEC                       
                    SBC $1A                   
                    STA $00                   
                    LDA.W $1733,X             
                    SBC $1B                   
                    BNE ADDR_029BDA           
                    LDA.W $1715,X             
                    SEC                       
                    SBC $1C                   
                    STA $01                   
                    LDA.W $1729,X             
                    SBC $1D                   
                    BEQ ADDR_029B76           
                    BMI ADDR_029BA5           
                    BPL ADDR_029BDA           
ADDR_029B76:        LDA $00                   
                    STA.W $0200,Y             
                    LDA $01                   
                    CMP.B #$F0                
                    BCS ADDR_029BA5           
                    STA.W $0201,Y             
                    LDA.B #$09                
                    ORA $64                   
                    STA.W $0203,Y             
                    LDA $14                   
                    LSR                       
                    EOR.W $15E9               
                    LSR                       
                    LSR                       
                    LDA.B #$A6                
                    BCC ADDR_029B99           
                    LDA.B #$B6                
ADDR_029B99:        STA.W $0202,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$00                
                    STA.W $0420,Y             
ADDR_029BA5:        LDA $9D                   
                    BNE ADDR_029BD9           
                    JSR.W ADDR_02A3F6         
                    JSR.W ADDR_02B554         
                    JSR.W ADDR_02B560         
                    LDA $13                   
                    AND.B #$03                
                    BNE ADDR_029BC2           
                    LDA.W $173D,X             
                    CMP.B #$18                
                    BPL ADDR_029BC2           
                    INC.W $173D,X             
ADDR_029BC2:        LDA.W $173D,X             
                    BMI ADDR_029BD9           
                    TXA                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ADC $13                   
                    LDY.B #$08                
                    AND.B #$08                
                    BNE ADDR_029BD5           
                    LDY.B #$F8                
ADDR_029BD5:        TYA                       
                    STA.W $1747,X             
ADDR_029BD9:        RTS                       ; Return 

ADDR_029BDA:        STZ.W $170B,X             
                    RTS                       ; Return 


DATA_029BDE:        .db $08,$F8

DATA_029BE0:        .db $00,$FF

DATA_029BE2:        .db $18,$E8

ADDR_029BE4:        LDA.B #$05                
                    STA.W $1887               
                    LDA.B #$09                
                    STA.W $1DFC               ; / Play sound effect 
                    STZ $00                   
                    JSR.W ADDR_029BF5         
                    INC $00                   
ADDR_029BF5:        LDY.B #$07                
ADDR_029BF7:        LDA.W $170B,Y             
                    BEQ ADDR_029C00           
                    DEY                       
                    BPL ADDR_029BF7           
                    RTS                       ; Return 

ADDR_029C00:        LDA.B #$0F                
                    STA.W $170B,Y             
                    LDA $96                   
                    CLC                       
                    ADC.B #$28                
                    STA.W $1715,Y             
                    LDA $97                   
                    ADC.B #$00                
                    STA.W $1729,Y             
                    LDX $00                   
                    LDA $94                   
                    CLC                       
                    ADC.W DATA_029BDE,X       
                    STA.W $171F,Y             
                    LDA $95                   
                    ADC.W DATA_029BE0,X       
                    STA.W $1733,Y             
                    LDA.W DATA_029BE2,X       
                    STA.W $1747,Y             
                    LDA.B #$15                
                    STA.W $176F,Y             
                    RTS                       ; Return 


DATA_029C33:        .db $66,$64,$62,$60,$60,$60,$60,$60
                    .db $60,$60,$60

ADDR_029C3E:        JSR.W ADDR_02A1A4         
                    LDY.W DATA_02A153,X       
                    LDA.W $176F,X             
                    LSR                       
                    PHX                       
                    TAX                       
                    LDA $14                   
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    AND.B #$C0                
                    ORA.B #$32                
                    STA.W $0203,Y             
                    LDA.W DATA_029C33,X       
                    STA.W $0202,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$02                
                    STA.W $0420,Y             
                    PLX                       
                    LDA $9D                   
                    BNE ADDR_029C7E           
                    LDA.W $176F,X             
                    BEQ ADDR_029C7F           
                    CMP.B #$06                
                    BNE ADDR_029C7B           
                    LDA.W $1747,X             
                    ASL                       
                    ROR.W $1747,X             
ADDR_029C7B:        JSR.W ADDR_02B554         
ADDR_029C7E:        RTS                       ; Return 

ADDR_029C7F:        STZ.W $170B,X             
                    RTS                       ; Return 

ADDR_029C83:        LDA.W $176F,X             
                    BEQ ADDR_029C7F           
                    JSR.W ADDR_02A1A4         
                    LDY.W DATA_02A153,X       
                    LDA.B #$34                
                    STA.W $0203,Y             
                    LDA.B #$EF                
                    STA.W $0202,Y             
                    LDA $9D                   
                    BNE ADDR_029CAF           
                    LDA.W $176F,X             
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA $13                   
                    AND.W DATA_029CB0,Y       
                    BNE ADDR_029CAF           
                    JSR.W ADDR_02B554         
                    JSR.W ADDR_02B560         
ADDR_029CAF:        RTS                       ; Return 


DATA_029CB0:        .db $FF,$07,$01,$00,$00

ADDR_029CB5:        LDA $9D                   
                    BNE ADDR_029CF8           
                    JSR.W ADDR_02B560         
                    LDA.W $173D,X             
                    CMP.B #$30                
                    BPL ADDR_029CC9           
                    CLC                       
                    ADC.B #$02                
                    STA.W $173D,X             
ADDR_029CC9:        LDA.W $170B,X             
                    CMP.B #$0E                
                    BNE ADDR_029CE3           
                    LDY.B #$08                
                    LDA $14                   
                    AND.B #$08                
                    BEQ ADDR_029CDA           
                    LDY.B #$F8                
ADDR_029CDA:        TYA                       
                    STA.W $1747,X             
                    JSR.W ADDR_02B554         
                    BRA ADDR_029CF8           
ADDR_029CE3:        LDA.W $1765,X             
                    BNE ADDR_029CF5           
                    JSR.W ADDR_02A56E         
                    BCC ADDR_029CF5           
                    LDA.B #$D0                
                    STA.W $173D,X             
                    INC.W $1765,X             
ADDR_029CF5:        JSR.W ADDR_02A3F6         
ADDR_029CF8:        LDA.W $1715,X             
                    SEC                       
                    SBC $1C                   
                    CMP.B #$F0                
                    BCS ADDR_029D5A           
                    STA $01                   
                    LDA.W $171F,X             
                    CMP $1A                   
                    LDA.W $1733,X             
                    SBC $1B                   
                    BNE ADDR_029D5D           
                    LDY.W DATA_02A153,X       
                    STY $0F                   
                    LDA.W $171F,X             
                    SEC                       
                    SBC $1A                   
                    STA $00                   
                    STA.W $0200,Y             
                    LDA.W $170B,X             
                    CMP.B #$0E                
                    BNE ADDR_029D45           
                    LDA $01                   
                    SEC                       
                    SBC.B #$05                
                    STA.W $0201,Y             
                    LDA.B #$98                
                    STA.W $0202,Y             
                    LDA.B #$0B                
ADDR_029D36:        ORA $64                   
                    STA.W $0203,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$00                
                    STA.W $0420,Y             
                    RTS                       ; Return 

ADDR_029D45:        LDA $01                   
                    STA.W $0201,Y             
                    LDA.B #$C2                
                    STA.W $0202,Y             
                    LDA.B #$04                
                    JSR.W ADDR_029D36         
                    LDA.B #$02                
                    STA.W $0420,Y             
                    RTS                       ; Return 

ADDR_029D5A:        STZ.W $170B,X             
ADDR_029D5D:        RTS                       ; Return 


DATA_029D5E:        .db $00,$01,$02,$03,$02,$03,$02,$03
                    .db $03,$02,$03,$02,$03,$02,$01,$00
DATA_029D6E:        .db $10,$F8,$03,$10,$F8,$03,$10,$F0
                    .db $FF,$10,$F0,$FF

DATA_029D7A:        .db $02,$02,$EE,$02,$02,$EE,$FE,$FE
                    .db $E6,$FE,$FE,$E6

DATA_029D86:        .db $B3,$B3,$B1,$B2,$B2,$B0,$8E,$8E
                    .db $A8,$8C,$8C,$88

DATA_029D92:        .db $69,$29,$29

DATA_029D95:        .db $00,$00,$02,$02

ADDR_029D99:        STZ.W $170B,X             
                    RTS                       ; Return 

ADDR_029D9D:        JSR.W ADDR_02A3F6         
                    LDY.W $1747,X             
                    LDA.W $14C8,Y             
                    CMP.B #$08                
                    BNE ADDR_029D99           
                    LDA.W $176F,X             
                    BEQ ADDR_029D99           
                    LSR                       
                    LSR                       
                    NOP                       
                    NOP                       
                    TAY                       
                    LDA.W DATA_029D5E,Y       
                    STA $0F                   
                    ASL                       
                    ADC $0F                   
                    STA $02                   
                    LDA.W $1765,X             
                    CLC                       
                    ADC $02                   
                    TAY                       
                    STY $03                   
                    LDA.W $171F,X             
                    CLC                       
                    ADC.W DATA_029D6E,Y       
                    SEC                       
                    SBC $1A                   
                    STA $00                   
                    LDA.W $1715,X             
                    CLC                       
                    ADC.W DATA_029D7A,Y       
                    SEC                       
                    SBC $1C                   
                    STA $01                   
                    LDY.W DATA_02A153,X       
                    CMP.B #$F0                
                    BCS ADDR_029E39           
                    STA.W $0201,Y             
                    LDA $00                   
                    CMP.B #$10                
                    BCC ADDR_029E39           
                    CMP.B #$F0                
                    BCS ADDR_029E39           
                    STA.W $0200,Y             
                    LDA.W $1765,X             
                    TAX                       
                    LDA.W DATA_029D92,X       
                    STA.W $0203,Y             
                    LDX $03                   
                    LDA.W DATA_029D86,X       
                    STA.W $0202,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDX $0F                   
                    LDA.W DATA_029D95,X       
                    STA.W $0420,Y             
                    LDX.W $15E9               
                    LDA $00                   
                    SEC                       
                    SBC $7E                   
                    CLC                       
                    ADC.B #$04                
                    CMP.B #$08                
                    BCS ADDR_029E35           
                    LDA $01                   
                    SEC                       
                    SBC $80                   
                    SEC                       
                    SBC.B #$10                
                    CLC                       
                    ADC.B #$10                
                    CMP.B #$10                
                    BCS ADDR_029E35           
                    JMP.W ADDR_02A469         
ADDR_029E35:        RTS                       ; Return 


DATA_029E36:        .db $08,$00,$F8

ADDR_029E39:        STZ.W $170B,X             
                    RTS                       ; Return 

ADDR_029E3D:        LDY.B #$00                
                    LDA.W $176F,X             
                    BEQ ADDR_029E39           
                    CMP.B #$60                
                    BCS ADDR_029E4E           
                    INY                       
                    CMP.B #$30                
                    BCS ADDR_029E4E           
                    INY                       
ADDR_029E4E:        PHY                       
                    LDA $9D                   
                    BNE ADDR_029E5C           
                    LDA.W DATA_029E36,Y       
                    STA.W $173D,X             
                    JSR.W ADDR_02B560         
ADDR_029E5C:        JSR.W ADDR_02A1A4         
                    LDY.W DATA_02A153,X       
                    PLA                       
                    CMP.B #$01                
                    LDA.B #$84                
                    BCC ADDR_029E6B           
                    LDA.B #$A4                
ADDR_029E6B:        STA.W $0202,Y             
                    LDA.W $0203,Y             
                    AND.B #$00                
                    ORA.B #$13                
                    STA.W $0203,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$02                
                    STA.W $0420,Y             
                    RTS                       ; Return 


LavaSplashTiles2:   .db $D7,$C7,$D6,$C6

ADDR_029E86:        LDA $9D                   
                    BNE ADDR_029E9D           
                    JSR.W ADDR_02B554         
                    JSR.W ADDR_02B560         
                    LDA.W $173D,X             
                    CLC                       
                    ADC.B #$02                
                    STA.W $173D,X             
                    CMP.B #$30                
                    BPL ADDR_029EE6           
ADDR_029E9D:        LDY.W DATA_02A153,X       
                    LDA.W $171F,X             
                    SEC                       
                    SBC $1A                   
                    STA $00                   
                    LDA.W $1733,X             
                    SBC $1B                   
                    BNE ADDR_029EE6           
                    LDA $00                   
                    STA.W $0200,Y             
                    LDA.W $1715,X             
                    SEC                       
                    SBC $1C                   
                    CMP.B #$F0                
                    BCS ADDR_029EE6           
                    STA.W $0201,Y             
                    LDA.W $176F,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    NOP                       
                    NOP                       
                    AND.B #$03                
                    TAX                       
                    LDA.W LavaSplashTiles2,X  
                    STA.W $0202,Y             
                    LDA $64                   
                    ORA.B #$05                
                    STA.W $0203,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$00                
                    STA.W $0420,Y             
                    LDX.W $15E9               
                    RTS                       ; Return 

ADDR_029EE6:        STZ.W $170B,X             
                    RTS                       ; Return 


DATA_029EEA:        .db $00,$01,$00,$FF

ADDR_029EEE:        LDA $9D                   
                    BNE ADDR_029F2A           
                    INC.W $1765,X             
                    LDA.W $1765,X             
                    AND.B #$30                
                    BEQ ADDR_029F08           
                    DEC.W $1715,X             
                    LDY.W $1715,X             
                    INY                       
                    BNE ADDR_029F08           
                    DEC.W $1729,X             
ADDR_029F08:        TXA                       
                    EOR $13                   
                    LSR                       
                    BCS ADDR_029F2A           
                    JSR.W ADDR_02A56E         
                    BCS ADDR_029F27           
                    LDA $85                   
                    BNE ADDR_029F2A           
                    LDA $0C                   
                    CMP.B #$06                
                    BCC ADDR_029F2A           
                    LDA $0F                   
                    BEQ ADDR_029F27           
                    LDA $0D                   
                    CMP.B #$06                
                    BCC ADDR_029F2A           
ADDR_029F27:        JMP.W ADDR_02A211         
ADDR_029F2A:        LDA.W $1715,X             
                    CMP $1C                   
                    LDA.W $1729,X             
                    SBC $1D                   
                    BNE ADDR_029F27           
                    JSR.W ADDR_02A1A4         
                    LDA.W $1765,X             
                    AND.B #$0C                
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_029EEA,Y       
                    STA $00                   
                    LDY.W DATA_02A153,X       
                    LDA.W $0200,Y             
                    CLC                       
                    ADC $00                   
                    STA.W $0200,Y             
                    LDA.W $0201,Y             
                    CLC                       
                    ADC.B #$05                
                    STA.W $0201,Y             
                    LDA.B #$1C                
                    STA.W $0202,Y             
                    RTS                       ; Return 

ADDR_029F61:        LDA $9D                   
                    BNE ADDR_029F6E           
                    JSR.W ADDR_02B554         
                    JSR.W ADDR_02B560         
                    JSR.W ADDR_02A0AC         
ADDR_029F6E:        JSR.W ADDR_02A1A4         
                    LDA $14                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LDY.W DATA_02A153,X       
                    LDA.B #$04                
                    BCC ADDR_029F7F           
                    LDA.B #$2B                
ADDR_029F7F:        STA.W $0202,Y             
                    LDA.W $1747,X             
                    AND.B #$80                
                    EOR.B #$80                
                    LSR                       
                    ORA.B #$35                
                    STA.W $0203,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$02                
                    STA.W $0420,Y             
                    RTS                       ; Return 


DATA_029F99:        .db $00,$B8,$C0,$C8,$D0,$D8,$E0,$E8
                    .db $F0

DATA_029FA2:        .db $00

DATA_029FA3:        .db $05,$03

DATA_029FA5:        .db $02,$02,$02,$02,$02,$02,$F8,$FC
                    .db $A0,$A4

ADDR_029FAF:        LDA $9D                   
                    BNE ADDR_02A02C           
                    LDA.W $1715,X             
                    CMP $1C                   
                    LDA.W $1729,X             
                    SBC $1D                   
                    BEQ ADDR_029FC2           
                    JMP.W ADDR_02A211         
ADDR_029FC2:        INC.W $1765,X             
                    JSR.W ADDR_02A0AC         
                    LDA.W $173D,X             
                    CMP.B #$30                
                    BPL ADDR_029FD8           
                    LDA.W $173D,X             
                    CLC                       
                    ADC.B #$04                
                    STA.W $173D,X             
ADDR_029FD8:        JSR.W ADDR_02A56E         
                    BCC ADDR_02A010           
                    INC.W $175B,X             
                    LDA.W $175B,X             
                    CMP.B #$02                
                    BCS ADDR_02A042           
                    LDA.W $1747,X             
                    BPL ADDR_029FF3           
                    LDA $0B                   
                    EOR.B #$FF                
                    INC A                     
                    STA $0B                   
ADDR_029FF3:        LDA $0B                   
                    CLC                       
                    ADC.B #$04                
                    TAY                       
                    LDA.W DATA_029F99,Y       
                    STA.W $173D,X             
                    LDA.W $1715,X             
                    SEC                       
                    SBC.W DATA_029FA2,Y       
                    STA.W $1715,X             
                    BCS ADDR_02A00E           
                    DEC.W $1729,X             
ADDR_02A00E:        BRA ADDR_02A013           
ADDR_02A010:        STZ.W $175B,X             
ADDR_02A013:        LDY.B #$00                
                    LDA.W $1747,X             
                    BPL ADDR_02A01B           
                    DEY                       
ADDR_02A01B:        CLC                       
                    ADC.W $171F,X             
                    STA.W $171F,X             
                    TYA                       
                    ADC.W $1733,X             
                    STA.W $1733,X             
                    JSR.W ADDR_02B560         
ADDR_02A02C:        LDA $A5                   
                    CMP.B #$A9                
                    BEQ ADDR_02A03B           
                    LDA.W $0D9B               
                    BPL ADDR_02A03B           
                    AND.B #$40                
                    BNE ADDR_02A04F           
ADDR_02A03B:        LDY.W DATA_029FA3,X       
                    JSR.W ADDR_02A1A7         
                    RTS                       ; Return 

ADDR_02A042:        JSR.W ADDR_02A02C         
ADDR_02A045:        LDA.B #$01                
                    STA.W $1DF9               ; / Play sound effect 
                    LDA.B #$0F                
                    JMP.W ADDR_02A4E0         
ADDR_02A04F:        LDY.W DATA_029FA5,X       
                    LDA.W $1747,X             
                    AND.B #$80                
                    LSR                       
                    STA $00                   
                    LDA.W $171F,X             
                    SEC                       
                    SBC $1A                   
                    CMP.B #$F8                
                    BCS ADDR_02A0A9           
                    STA.W $0300,Y             
                    LDA.W $1715,X             
                    SEC                       
                    SBC $1C                   
                    CMP.B #$F0                
                    BCS ADDR_02A0A9           
                    STA.W $0301,Y             
                    LDA.W $1779,X             
                    STA $01                   
                    LDA.W $1765,X             
                    LSR                       
                    LSR                       
                    AND.B #$03                
                    TAX                       
                    LDA.W FireballTiles,X     
                    STA.W $0302,Y             
                    LDA.W DATA_02A15F,X       
                    EOR $00                   
                    ORA $64                   
                    STA.W $0303,Y             
                    LDX $01                   
                    BEQ ADDR_02A09C           
                    AND.B #$CF                
                    ORA.B #$10                
                    STA.W $0303,Y             
ADDR_02A09C:        TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$00                
                    STA.W $0460,Y             
                    LDX.W $15E9               
ADDR_02A0A8:        RTS                       ; Return 

ADDR_02A0A9:        JMP.W ADDR_02A211         
ADDR_02A0AC:        TXA                       
                    EOR $13                   
                    AND.B #$03                
                    BNE ADDR_02A0A8           
                    PHX                       
                    TXY                       
                    STY.W $185E               
                    LDX.B #$09                
ADDR_02A0BA:        STX.W $15E9               
                    LDA.W $14C8,X             
                    CMP.B #$08                
                    BCC ADDR_02A143           
                    LDA.W $167A,X             
                    AND.B #$02                
                    ORA.W $15D0,X             
                    ORA.W $1632,X             
                    EOR.W $1779,Y             
                    BNE ADDR_02A143           
                    JSL.L ADDR_03B69F         
                    JSR.W ADDR_02A547         
                    JSL.L ADDR_03B72B         
                    BCC ADDR_02A143           
                    LDA.W $170B,Y             
                    CMP.B #$11                
                    BEQ ADDR_02A0EE           
                    PHX                       
                    TYX                       
                    JSR.W ADDR_02A045         
                    PLX                       
ADDR_02A0EE:        LDA.W $166E,X             
                    AND.B #$10                
                    BNE ADDR_02A143           
                    LDA.W $190F,X             
                    AND.B #$08                
                    BEQ ADDR_02A124           
                    INC.W $1528,X             
                    LDA.W $1528,X             
                    CMP.B #$05                
                    BCC ADDR_02A143           
                    LDA.B #$02                
                    STA.W $1DF9               ; / Play sound effect 
                    LDA.B #$02                
                    STA.W $14C8,X             
                    LDA.B #$D0                
                    STA $AA,X                 
                    JSR.W ADDR_02848D         
                    LDA.W DATA_02A151,Y       
                    STA $B6,X                 
                    LDA.B #$04                
                    JSL.L GivePoints          
                    BRA ADDR_02A143           
ADDR_02A124:        LDA.B #$03                
                    STA.W $1DF9               ; / Play sound effect 
                    LDA.B #$21                
                    STA $9E,X                 
                    LDA.B #$08                
                    STA.W $14C8,X             
                    JSL.L ADDR_07F7D2         
                    LDA.B #$D0                
                    STA $AA,X                 
                    JSR.W ADDR_02848D         
                    TYA                       
                    EOR.B #$01                
                    STA.W $157C,X             
ADDR_02A143:        LDY.W $185E               
                    DEX                       
                    BMI ADDR_02A14C           
                    JMP.W ADDR_02A0BA         
ADDR_02A14C:        PLX                       
                    STX.W $15E9               
                    RTS                       ; Return 


DATA_02A151:        .db $F0,$10

DATA_02A153:        .db $90,$94,$98,$9C,$A0,$A4,$A8,$AC
FireballTiles:      .db $2C,$2D,$2C,$2D

DATA_02A15F:        .db $04,$04,$C4,$C4

ReznorFireTiles:    .db $26,$2A,$26,$2A

DATA_02A167:        .db $35,$35,$F5,$F5

ADDR_02A16B:        LDA $9D                   
                    BNE ADDR_02A178           
                    JSR.W ADDR_02B554         
                    JSR.W ADDR_02B560         
                    JSR.W ADDR_02A3F6         
ADDR_02A178:        LDA.W $0D9B               
                    BPL ADDR_02A1A4           
                    JSR.W ADDR_02A1A4         
                    LDY.W DATA_02A153,X       
                    LDA $14                   
                    LSR                       
                    LSR                       
                    AND.B #$03                
                    PHX                       
                    TAX                       
                    LDA.W ReznorFireTiles,X   
                    STA.W $0202,Y             
                    LDA.W DATA_02A167,X       
                    EOR $00                   
                    STA.W $0203,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.B #$02                
                    STA.W $0420,X             
                    PLX                       
                    RTS                       ; Return 

ADDR_02A1A4:        LDY.W DATA_02A153,X       
ADDR_02A1A7:        LDA.W $1747,X             
                    AND.B #$80                
                    EOR.B #$80                
                    LSR                       
                    STA $00                   
                    LDA.W $171F,X             
                    SEC                       
                    SBC $1A                   
                    STA $01                   
                    LDA.W $1733,X             
                    SBC $1B                   
                    BNE ADDR_02A211           
                    LDA.W $1715,X             
                    SEC                       
                    SBC $1C                   
                    STA $02                   
                    LDA.W $1729,X             
                    SBC $1D                   
                    BNE ADDR_02A211           
                    LDA $02                   
                    CMP.B #$F0                
                    BCS ADDR_02A211           
                    STA.W $0201,Y             
                    LDA $01                   
                    STA.W $0200,Y             
                    LDA.W $1779,X             
                    STA $01                   
                    LDA $14                   
                    LSR                       
                    LSR                       
                    AND.B #$03                
                    TAX                       
                    LDA.W FireballTiles,X     
                    STA.W $0202,Y             
                    LDA.W DATA_02A15F,X       
                    EOR $00                   
                    ORA $64                   
                    STA.W $0203,Y             
                    LDX $01                   
                    BEQ ADDR_02A204           
                    AND.B #$CF                
                    ORA.B #$10                
                    STA.W $0203,Y             
ADDR_02A204:        TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$00                
                    STA.W $0420,Y             
                    LDX.W $15E9               
                    RTS                       ; Return 

ADDR_02A211:        LDA.B #$00                
                    STA.W $170B,X             
                    RTS                       ; Return 


SmallFlameTiles:    .db $AC,$AD

ADDR_02A219:        LDA $9D                   
                    BNE ADDR_02A22F           
                    INC.W $1765,X             
                    LDA.W $176F,X             
                    BEQ ADDR_02A211           
                    CMP.B #$50                
                    BCS ADDR_02A22F           
                    AND.B #$01                
                    BNE ADDR_02A253           
                    BEQ ADDR_02A232           
ADDR_02A22F:        JSR.W ADDR_02A3F6         
ADDR_02A232:        JSR.W ADDR_02A1A4         
                    LDY.W DATA_02A153,X       
                    LDA.W $1765,X             
                    LSR                       
                    LSR                       
                    AND.B #$01                
                    TAX                       
                    LDA.W SmallFlameTiles,X   
                    STA.W $0202,Y             
                    LDA.W $0203,Y             
                    AND.B #$3F                
                    ORA.B #$05                
                    STA.W $0203,Y             
                    LDX.W $15E9               
ADDR_02A253:        RTS                       ; Return 

ADDR_02A254:        LDA $9D                   
                    BNE ADDR_02A26A           
                    JSR.W ADDR_02B554         
                    INC.W $1765,X             
                    LDA $13                   
                    AND.B #$01                
                    BNE ADDR_02A267           
                    INC.W $1765,X             
ADDR_02A267:        JSR.W ADDR_02A3F6         
ADDR_02A26A:        LDA.W $170B,X             
                    CMP.B #$0D                
                    BNE ADDR_02A2C3           
                    LDA.W $171F,X             
                    SEC                       
                    SBC $1A                   
                    STA $00                   
                    LDA.W $1733,X             
                    SBC $1B                   
                    BEQ ADDR_02A287           
                    EOR.W $1747,X             
                    BPL ADDR_02A2BF           
                    BMI ADDR_02A2BE           
ADDR_02A287:        LDY.W DATA_02A153,X       
                    LDA $00                   
                    STA.W $0200,Y             
                    LDA.W $1715,X             
                    SEC                       
                    SBC $1C                   
                    STA $01                   
                    LDA.W $1729,X             
                    SBC $1D                   
                    BNE ADDR_02A2BF           
                    LDA $01                   
                    STA.W $0201,Y             
                    LDA.B #$AD                
                    STA.W $0202,Y             
                    LDA $14                   
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    AND.B #$C0                
                    ORA.B #$39                
                    STA.W $0203,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$00                
                    STA.W $0420,Y             
ADDR_02A2BE:        RTS                       ; Return 

ADDR_02A2BF:        STZ.W $170B,X             
                    RTS                       ; Return 

ADDR_02A2C3:        JSR.W ADDR_02A317         
                    LDA.W $0202,Y             
                    CMP.B #$26                
                    LDA.B #$80                
                    BCS ADDR_02A2D1           
                    LDA.B #$82                
ADDR_02A2D1:        STA.W $0202,Y             
                    LDA.W $0203,Y             
                    AND.B #$F1                
                    ORA.B #$02                
                    STA.W $0203,Y             
                    RTS                       ; Return 


HammerTiles:        .db $08,$6D,$6D,$08,$08,$6D,$6D,$08
HammerGfxProp:      .db $47,$47,$07,$07,$87,$87,$C7,$C7

ADDR_02A2EF:        LDA $9D                   
                    BNE ADDR_02A30C           
                    JSR.W ADDR_02B554         
                    JSR.W ADDR_02B560         
                    LDA.W $173D,X             
                    CMP.B #$40                
                    BPL ADDR_02A306           
                    INC.W $173D,X             
                    INC.W $173D,X             
ADDR_02A306:        JSR.W ADDR_02A3F6         
                    INC.W $1765,X             
ADDR_02A30C:        LDA.W $170B,X             
                    CMP.B #$0B                
                    BNE ADDR_02A317           
                    JSR.W ADDR_02A178         
                    RTS                       ; Return 

ADDR_02A317:        JSR.W ADDR_02A1A4         
                    LDY.W DATA_02A153,X       
                    LDA.W $1765,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.B #$07                
                    PHX                       
                    TAX                       
                    LDA.W HammerTiles,X       
                    STA.W $0202,Y             
                    LDA.W HammerGfxProp,X     
                    EOR $00                   
                    EOR.B #$40                
                    ORA $64                   
                    STA.W $0203,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.B #$02                
                    STA.W $0420,X             
                    PLX                       
                    RTS                       ; Return 

ADDR_02A344:        JMP.W ADDR_02A211         

DustCloudTiles:     .db $66,$64,$60,$62

DATA_02A34B:        .db $00,$40,$C0,$80

ADDR_02A34F:        LDA.W $176F,X             
                    BEQ ADDR_02A344           
                    LDA.W $140F               
                    BNE ADDR_02A362           
                    LDA.W $0D9B               
                    BPL ADDR_02A362           
                    AND.B #$40                
                    BNE ADDR_02A3B1           
ADDR_02A362:        LDY.W DATA_02A153,X       
                    CPX.B #$08                
                    BCC ADDR_02A36C           
                    LDY.W DATA_029FA3,X       
ADDR_02A36C:        LDA.W $171F,X             
                    SEC                       
                    SBC $1A                   
                    CMP.B #$F8                
                    BCS ADDR_02A3AE           
                    STA.W $0200,Y             
                    LDA.W $1715,X             
                    SEC                       
                    SBC $1C                   
                    CMP.B #$F0                
                    BCS ADDR_02A3AE           
                    STA.W $0201,Y             
                    LDA.W $176F,X             
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W DustCloudTiles,X    
                    STA.W $0202,Y             
                    LDA $14                   
                    LSR                       
                    LSR                       
                    AND.B #$03                
                    TAX                       
                    LDA.W DATA_02A34B,X       
                    ORA $64                   
                    STA.W $0203,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$02                
                    STA.W $0420,Y             
                    LDX.W $15E9               
                    RTS                       ; Return 

ADDR_02A3AE:        JMP.W ADDR_02A211         
ADDR_02A3B1:        LDY.W DATA_029FA5,X       
                    LDA.W $171F,X             
                    SEC                       
                    SBC $1A                   
                    CMP.B #$F8                
                    BCS ADDR_02A3AE           
                    STA.W $0300,Y             
                    LDA.W $1715,X             
                    SEC                       
                    SBC $1C                   
                    CMP.B #$F0                
                    BCS ADDR_02A3AE           
                    STA.W $0301,Y             
                    LDA.W $176F,X             
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W DustCloudTiles,X    
                    STA.W $0302,Y             
                    LDA $14                   
                    LSR                       
                    LSR                       
                    AND.B #$03                
                    TAX                       
                    LDA.W DATA_02A34B,X       
                    ORA $64                   
                    STA.W $0303,Y             
                    LDX.W $15E9               
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$02                
                    STA.W $0460,Y             
                    RTS                       ; Return 

ADDR_02A3F6:        LDA.W $13F9               
                    EOR.W $1779,X             
                    BNE ADDR_02A468           
                    JSL.L ADDR_03B664         
                    JSR.W ADDR_02A519         
                    JSL.L ADDR_03B72B         
                    BCC ADDR_02A468           
                    LDA.W $170B,X             
                    CMP.B #$0A                
                    BNE ADDR_02A469           
                    JSL.L ADDR_05B34A         
                    INC.W $18E3               
                    STZ.W $170B,X             
                    LDY.B #$03                
ADDR_02A41E:        LDA.W $17C0,Y             
                    BEQ ADDR_02A427           
                    DEY                       
                    BPL ADDR_02A41E           
                    INY                       
ADDR_02A427:        LDA.B #$05                
                    STA.W $17C0,Y             
                    LDA.W $171F,X             
                    STA.W $17C8,Y             
                    LDA.W $1715,X             
                    STA.W $17C4,Y             
                    LDA.B #$0A                
                    STA.W $17CC,Y             
                    JSL.L ADDR_02AD34         
                    LDA.B #$05                
                    STA.W $16E1,Y             
                    LDA.W $1715,X             
                    STA.W $16E7,Y             
                    LDA.W $1729,X             
                    STA.W $16F9,Y             
                    LDA.W $171F,X             
                    STA.W $16ED,Y             
                    LDA.W $1733,X             
                    STA.W $16F3,Y             
                    LDA.B #$30                
                    STA.W $16FF,Y             
                    LDA.B #$00                
                    STA.W $1705,Y             
ADDR_02A468:        RTS                       ; Return 

ADDR_02A469:        LDA.W $1490               
                    BNE ADDR_02A4B5           
                    LDA.W $187A               
                    BEQ ADDR_02A4AE           
ADDR_02A473:        PHX                       
                    LDX.W $18DF               
                    LDA.B #$10                
                    STA.W $163D,X             
                    LDA.B #$03                
                    STA.W $1DFA               ; / Play sound effect 
                    LDA.B #$13                
                    STA.W $1DFC               ; / Play sound effect 
                    LDA.B #$02                
                    STA $C1,X                 
                    STZ.W $187A               
                    STZ.W $0DC1               
                    LDA.B #$C0                
                    STA $7D                   
                    STZ $7B                   
                    LDY.W $157B,X             
                    LDA.W DATA_02A4B3,Y       
                    STA $B5,X                 
                    STZ.W $1593,X             
                    STZ.W $151B,X             
                    STZ.W $18AE               
                    LDA.B #$30                
                    STA.W $1497               
                    PLX                       
                    RTS                       ; Return 

ADDR_02A4AE:        JSL.L HurtMario           
                    RTS                       ; Return 


DATA_02A4B3:        .db $10,$F0

ADDR_02A4B5:        LDA.W $170B,X             
                    CMP.B #$04                
                    BEQ ADDR_02A4DE           
                    LDA.W $171F,X             
                    SEC                       
                    SBC.B #$04                
                    STA.W $171F,X             
                    LDA.W $1733,X             
                    SBC.B #$00                
                    STA.W $1733,X             
                    LDA.W $1715,X             
                    SEC                       
                    SBC.B #$04                
                    STA.W $1715,X             
                    LDA.W $1729,X             
                    SBC.B #$00                
                    STA.W $1729,X             
ADDR_02A4DE:        LDA.B #$07                
ADDR_02A4E0:        STA.W $176F,X             
                    LDA.B #$01                

Instr02A4E5:        .db $9D,$0B

ADDR_02A4E7:        .db $17

                    RTS                       ; Return 


DATA_02A4E9:        .db $03,$03,$04,$03,$04,$00,$00,$00
                    .db $04,$03

DATA_02A4F3:        .db $03,$03,$03,$03,$04,$03,$04,$00
                    .db $00,$00,$02,$03

DATA_02A4FF:        .db $03,$03,$01,$01,$08,$01,$08,$00
                    .db $00,$0F,$08,$01

DATA_02A50B:        .db $01,$01,$01,$01,$08,$01,$08,$00
                    .db $00,$0F,$0C,$01,$01,$01

ADDR_02A519:        LDY.W $170B,X             
                    LDA.W $171F,X             
                    CLC                       
                    ADC.W ADDR_02A4E7,Y       
                    STA $04                   
                    LDA.W $1733,X             
                    ADC.B #$00                
                    STA $0A                   
                    LDA.W DATA_02A4FF,Y       
                    STA $06                   
                    LDA.W $1715,X             
                    CLC                       
                    ADC.W DATA_02A4F3,Y       
                    STA $05                   
                    LDA.W $1729,X             
                    ADC.B #$00                
                    STA $0B                   
                    LDA.W DATA_02A50B,Y       
                    STA $07                   
                    RTS                       ; Return 

ADDR_02A547:        LDA.W $171F,Y             
                    SEC                       
                    SBC.B #$02                
                    STA $00                   
                    LDA.W $1733,Y             
                    SBC.B #$00                
                    STA $08                   
                    LDA.B #$0C                
                    STA $02                   
                    LDA.W $1715,Y             
                    SEC                       
                    SBC.B #$04                
                    STA $01                   
                    LDA.W $1729,Y             
                    SBC.B #$00                
                    STA $09                   
                    LDA.B #$13                
                    STA $03                   
                    RTS                       ; Return 

ADDR_02A56E:        STZ $0F                   
                    STZ $0E                   
                    STZ $0B                   
                    STZ.W $1694               
                    LDA.W $140F               
                    BNE ADDR_02A5BC           
                    LDA.W $0D9B               
                    BPL ADDR_02A5BC           
                    AND.B #$40                
                    BEQ ADDR_02A592           
                    LDA.W $0D9B               
                    CMP.B #$C1                
                    BEQ ADDR_02A5BC           
                    LDA.W $1715,X             
                    CMP.B #$A8                
                    RTS                       ; Return 

ADDR_02A592:        LDA.W $171F,X             
                    CLC                       
                    ADC.B #$04                
                    STA.W $14B4               
                    LDA.W $1733,X             
                    ADC.B #$00                
                    STA.W $14B5               
                    LDA.W $1715,X             
                    CLC                       
                    ADC.B #$08                
                    STA.W $14B6               
                    LDA.W $1729,X             
                    ADC.B #$00                
                    STA.W $14B7               
                    JSL.L ADDR_01CC9D         
                    LDX.W $15E9               
                    RTS                       ; Return 

ADDR_02A5BC:        JSR.W ADDR_02A611         
                    ROL $0E                   
                    LDA.W $1693               
                    STA $0C                   
                    LDA $5B                   
                    BPL ADDR_02A60C           
                    INC $0F                   
                    LDA.W $171F,X             
                    PHA                       
                    CLC                       
                    ADC $26                   
                    STA.W $171F,X             
                    LDA.W $1733,X             
                    PHA                       
                    ADC $27                   
                    STA.W $1733,X             
                    LDA.W $1715,X             
                    PHA                       
                    CLC                       
                    ADC $28                   
                    STA.W $1715,X             
                    LDA.W $1729,X             
                    PHA                       
                    ADC $29                   
                    STA.W $1729,X             
                    JSR.W ADDR_02A611         
                    ROL $0E                   
                    LDA.W $1693               
                    STA $0D                   
                    PLA                       
                    STA.W $1729,X             
                    PLA                       
                    STA.W $1715,X             
                    PLA                       
                    STA.W $1733,X             
                    PLA                       
                    STA.W $171F,X             
ADDR_02A60C:        LDA $0E                   
                    CMP.B #$01                
                    RTS                       ; Return 

ADDR_02A611:        LDA $0F                   
                    INC A                     
                    AND $5B                   
                    BEQ ADDR_02A679           
                    LDA.W $1715,X             
                    CLC                       
                    ADC.B #$08                
                    STA $98                   
                    AND.B #$F0                
                    STA $00                   
                    LDA.W $1729,X             
                    ADC.B #$00                
                    CMP $5D                   
                    BCS ADDR_02A677           
                    STA $03                   
                    STA $99                   
                    LDA.W $171F,X             
                    CLC                       
                    ADC.B #$04                
                    STA $01                   
                    STA $9A                   
                    LDA.W $1733,X             
                    ADC.B #$00                
                    CMP.B #$02                
                    BCS ADDR_02A677           
                    STA $02                   
                    STA $9B                   
                    LDA $01                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    ORA $00                   
                    STA $00                   
                    LDX $03                   
                    LDA.L DATA_00BA80,X       
                    LDY $0F                   
                    BEQ ADDR_02A660           
                    LDA.L DATA_00BA8E,X       
ADDR_02A660:        CLC                       
                    ADC $00                   
                    STA $05                   
                    LDA.L DATA_00BABC,X       
                    LDY $0F                   
                    BEQ ADDR_02A671           
                    LDA.L DATA_00BACA,X       
ADDR_02A671:        ADC $02                   
                    STA $06                   
                    BRA ADDR_02A6DB           
ADDR_02A677:        CLC                       
                    RTS                       ; Return 

ADDR_02A679:        LDA.W $1715,X             
                    CLC                       
                    ADC.B #$08                
                    STA $98                   
                    AND.B #$F0                
                    STA $00                   
                    LDA.W $1729,X             
                    ADC.B #$00                
                    STA $02                   
                    STA $99                   
                    LDA $00                   
                    SEC                       
                    SBC $1C                   
                    CMP.B #$F0                
                    BCS ADDR_02A677           
                    LDA.W $171F,X             
                    CLC                       
                    ADC.B #$04                
                    STA $01                   
                    STA $9A                   
                    LDA.W $1733,X             
                    ADC.B #$00                
                    CMP $5D                   
                    BCS ADDR_02A677           
                    STA $03                   
                    STA $9B                   
                    LDA $01                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    ORA $00                   
                    STA $00                   
                    LDX $03                   
                    LDA.L DATA_00BA60,X       
                    LDY $0F                   
                    BEQ ADDR_02A6C6           
                    LDA.L DATA_00BA70,X       
ADDR_02A6C6:        CLC                       
                    ADC $00                   
                    STA $05                   
                    LDA.L DATA_00BA9C,X       
                    LDY $0F                   
                    BEQ ADDR_02A6D7           
                    LDA.L DATA_00BAAC,X       
ADDR_02A6D7:        ADC $02                   
                    STA $06                   
ADDR_02A6DB:        LDA.B #$7E                
                    STA $07                   
                    LDX.W $15E9               
                    LDA [$05]                 
                    STA.W $1693               
                    INC $07                   
                    LDA [$05]                 
                    JSL.L ADDR_00F545         
                    CMP.B #$00                
                    BEQ ADDR_02A729           
                    LDA.W $1693               
                    CMP.B #$11                
                    BCC ADDR_02A72B           
                    CMP.B #$6E                
                    BCC ADDR_02A727           
                    CMP.B #$D8                
                    BCS ADDR_02A735           
                    LDY $9A                   
                    STY $0A                   
                    LDY $98                   
                    STY $0C                   
                    JSL.L ADDR_00FA19         
                    LDA $00                   
                    CMP.B #$0C                
                    BCS ADDR_02A718           
                    CMP [$05],Y               
                    BCC ADDR_02A729           
ADDR_02A718:        LDA [$05],Y               
                    STA.W $1694               
                    PHX                       
                    LDX $08                   
                    LDA.L DATA_00E53D,X       
                    PLX                       
                    STA $0B                   
ADDR_02A727:        SEC                       
                    RTS                       ; Return 

ADDR_02A729:        CLC                       
                    RTS                       ; Return 

ADDR_02A72B:        LDA $98                   
                    AND.B #$0F                
                    CMP.B #$06                
                    BCS ADDR_02A729           
                    SEC                       
                    RTS                       ; Return 

ADDR_02A735:        LDA $98                   
                    AND.B #$0F                
                    CMP.B #$06                
                    BCS ADDR_02A729           
                    LDA.W $1715,X             
                    SEC                       
                    SBC.B #$02                
                    STA.W $1715,X             
                    LDA.W $1729,X             
                    SBC.B #$00                
                    STA.W $1729,X             
                    JMP.W ADDR_02A611         
ADDR_02A751:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02ABF2         
                    JSR.W ADDR_02AC5C         
                    LDA.W $0D9B               
                    BMI ADDR_02A763           
                    JSL.L ADDR_01808C         
ADDR_02A763:        LDA.W $0DC1               
                    BEQ ADDR_02A771           
                    LDA.W $1B9B               
                    BNE ADDR_02A771           
                    JSL.L ADDR_00FC7A         
ADDR_02A771:        PLB                       
                    RTL                       ; Return 


DATA_02A773:        .db $09,$05,$07,$07,$07,$06,$07,$06
                    .db $06,$09,$08,$04,$07,$07,$07,$08
                    .db $09,$05,$05

DATA_02A786:        .db $09,$07,$07,$01,$00,$01,$07,$06
                    .db $06,$00,$02,$00,$07,$01,$07,$08
                    .db $09,$07,$05

DATA_02A799:        .db $09,$07,$07,$01,$00,$06,$07,$06
                    .db $06,$00,$02,$00,$07,$01,$07,$08
                    .db $09,$07,$05

DATA_02A7AC:        .db $FF,$FF,$00,$01,$00,$01,$FF,$01
                    .db $FF,$00,$FF,$00,$FF,$01,$FF,$FF
                    .db $FF,$FF,$FF

DATA_02A7BF:        .db $FF,$05,$FF,$FF,$FF,$FF,$FF,$01
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$05,$FF

DATA_02A7D2:        .db $FF,$5F,$54,$5E,$60,$28,$88,$FF
                    .db $FF,$C5,$86,$28,$FF,$90,$FF,$FF
                    .db $FF,$AE

DATA_02A7E4:        .db $FF,$64,$FF,$FF,$9F,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$9F,$FF,$FF
                    .db $FF,$FF

DATA_02A7F6:        .db $D0,$00,$20

DATA_02A7F9:        .db $FF,$00,$01

ADDR_02A7FC:        LDA $13                   
                    AND.B #$01                
                    BNE ADDR_02A84B           
ADDR_02A802:        LDY $55                   
                    LDA $5B                   
                    LSR                       
                    BCC ADDR_02A817           
                    LDA $1C                   
                    CLC                       
                    ADC.W DATA_02A7F6,Y       
                    AND.B #$F0                
                    STA $00                   
                    LDA $1D                   
                    BRA ADDR_02A823           
ADDR_02A817:        LDA $1A                   
                    CLC                       
                    ADC.W DATA_02A7F6,Y       
                    AND.B #$F0                
                    STA $00                   
                    LDA $1B                   
ADDR_02A823:        ADC.W DATA_02A7F9,Y       
                    BMI ADDR_02A84B           
                    STA $01                   
                    LDX.B #$00                
                    LDY.B #$01                
ADDR_02A82E:        LDA [$CE],Y               
                    CMP.B #$FF                
                    BEQ ADDR_02A84B           
                    ASL                       
                    ASL                       
                    ASL                       
                    AND.B #$10                
                    STA $02                   
                    INY                       
                    LDA [$CE],Y               
                    AND.B #$0F                
                    ORA $02                   
                    CMP $01                   
                    BCS ADDR_02A84C           
ADDR_02A846:        INY                       
                    INY                       
                    INX                       
                    BRA ADDR_02A82E           
ADDR_02A84B:        RTS                       ; Return 

ADDR_02A84C:        BNE ADDR_02A84B           
                    LDA [$CE],Y               
                    AND.B #$F0                
                    CMP $00                   
                    BNE ADDR_02A846           
                    LDA.W $1938,X             
                    BNE ADDR_02A846           
                    STX $02                   
                    INC.W $1938,X             
                    INY                       
                    LDA [$CE],Y               
                    STA $05                   
                    DEY                       
                    CMP.B #$E7                
                    BCC ADDR_02A88C           
                    LDA.W $143E               
                    ORA.W $143F               
                    BNE ADDR_02A88A           
                    PHY                       
                    PHX                       
                    LDA $05                   
                    SEC                       
                    SBC.B #$E7                
                    STA.W $143E               
                    DEY                       
                    LDA [$CE],Y               
                    LSR                       
                    LSR                       
                    STA.W $1440               
                    JSL.L ADDR_05BCD6         
                    PLX                       
                    PLY                       
ADDR_02A88A:        BRA ADDR_02A846           
ADDR_02A88C:        CMP.B #$DE                
                    BNE ADDR_02A89C           
                    PHY                       
                    PHX                       
                    DEY                       
                    STY $03                   
                    JSR.W ADDR_02AF9D         
                    PLX                       
                    PLY                       
ADDR_02A89A:        BRA ADDR_02A846           
ADDR_02A89C:        CMP.B #$E0                
                    BNE ADDR_02A8AC           
                    PHY                       
                    PHX                       
                    DEY                       
                    STY $03                   
                    JSR.W ADDR_02AF33         
                    PLX                       
                    PLY                       
                    BRA ADDR_02A89A           
ADDR_02A8AC:        CMP.B #$CB                
                    BCC ADDR_02A8D4           
                    CMP.B #$DA                
                    BCS ADDR_02A8C0           
                    SEC                       
                    SBC.B #$CB                
                    INC A                     
                    STA.W $18B9               
                    STZ.W $1938,X             
                    BRA ADDR_02A89A           
ADDR_02A8C0:        CMP.B #$E1                
                    BCC ADDR_02A8D0           
                    PHX                       
                    PHY                       
                    DEY                       
                    STY $03                   
                    JSR.W ADDR_02AAC0         
                    PLY                       
                    PLX                       
                    BRA ADDR_02A89A           
ADDR_02A8D0:        LDA.B #$09                
                    BRA ADDR_02A8DF           
ADDR_02A8D4:        CMP.B #$C9                
                    BCC ADDR_02A8DD           
                    JSR.W ADDR_02AB78         
                    BRA ADDR_02A89A           
ADDR_02A8DD:        LDA.B #$01                
ADDR_02A8DF:        STA $04                   
                    DEY                       
                    STY $03                   
                    LDY.W $1692               
                    LDX.W DATA_02A773,Y       
                    LDA.W DATA_02A7AC,Y       
                    STA $06                   
                    LDA $05                   
                    CMP.W DATA_02A7D2,Y       
                    BNE ADDR_02A8FE           
                    LDX.W DATA_02A786,Y       
                    LDA.W DATA_02A7BF,Y       
                    STA $06                   
ADDR_02A8FE:        LDA $05                   
                    CMP.W DATA_02A7E4,Y       
                    BNE ADDR_02A916           
                    CMP.B #$64                
                    BNE ADDR_02A90F           
                    LDA $00                   
                    AND.B #$10                
                    BEQ ADDR_02A916           
ADDR_02A90F:        LDX.W DATA_02A799,Y       
                    LDA.B #$FF                
                    STA $06                   
ADDR_02A916:        STX $0F                   
ADDR_02A918:        LDA.W $14C8,X             
                    BEQ ADDR_02A93C           
                    DEX                       
                    CPX $06                   
                    BNE ADDR_02A918           
                    LDA $05                   
                    CMP.B #$7B                
                    BNE ADDR_02A936           
                    LDX $0F                   
ADDR_02A92A:        LDA.W $167A,X             
                    AND.B #$02                
                    BEQ ADDR_02A93C           
                    DEX                       
                    CPX $06                   
                    BNE ADDR_02A92A           
ADDR_02A936:        LDX $02                   
                    STZ.W $1938,X             
                    RTS                       ; Return 

ADDR_02A93C:        LDY $03                   
                    LDA $5B                   
                    LSR                       
                    BCC ADDR_02A95B           
                    LDA [$CE],Y               
                    PHA                       
                    AND.B #$F0                
                    STA $E4,X                 
                    PLA                       
                    AND.B #$0D                
                    STA.W $14E0,X             
                    LDA $00                   
                    STA $D8,X                 
                    LDA $01                   
                    STA.W $14D4,X             
                    BRA ADDR_02A971           
ADDR_02A95B:        LDA [$CE],Y               
                    PHA                       
                    AND.B #$F0                
                    STA $D8,X                 
                    PLA                       
                    AND.B #$0D                
                    STA.W $14D4,X             
                    LDA $00                   
                    STA $E4,X                 
                    LDA $01                   
                    STA.W $14E0,X             
ADDR_02A971:        INY                       
                    INY                       
                    LDA $04                   
                    STA.W $14C8,X             
                    CMP.B #$09                
                    LDA [$CE],Y               
                    BCC ADDR_02A984           
                    SEC                       
                    SBC.B #$DA                
                    CLC                       
                    ADC.B #$04                
ADDR_02A984:        PHY                       
                    LDY.W $1EEB               
                    BPL ADDR_02A996           
                    CMP.B #$04                
                    BNE ADDR_02A990           
                    LDA.B #$07                
ADDR_02A990:        CMP.B #$05                
                    BNE ADDR_02A996           
                    LDA.B #$06                
ADDR_02A996:        STA $9E,X                 
                    PLY                       
                    LDA $02                   
                    STA.W $161A,X             
                    LDA.W $14AE               
                    BEQ ADDR_02A9C9           
                    PHX                       
                    LDA $9E,X                 
                    TAX                       
                    LDA.L Sprite190FVals,X    
                    PLX                       
                    AND.B #$40                
                    BNE ADDR_02A9C9           
                    LDA.B #$21                
                    STA $9E,X                 
                    LDA.B #$08                
                    STA.W $14C8,X             
                    JSL.L ADDR_07F7D2         
                    LDA.W $15F6,X             
                    AND.B #$F1                
                    ORA.B #$02                
                    STA.W $15F6,X             
                    BRA ADDR_02A9CD           
ADDR_02A9C9:        JSL.L ADDR_07F7D2         
ADDR_02A9CD:        LDA.B #$01                
                    STA.W $15A0,X             
                    LDA.B #$04                
                    STA.W $1FE2,X             
                    INY                       
                    LDX $02                   
                    INX                       
                    JMP.W ADDR_02A82E         
ADDR_02A9DE:        LDA.B #$02                
                    STA $0E                   
                    BRA ADDR_02A9E6           
ADDR_02A9E4:        STZ $0E                   
ADDR_02A9E6:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02A9EF         
                    PLB                       
                    TYA                       
                    RTL                       ; Return 

ADDR_02A9EF:        LDY.W $1692               
                    LDA.W DATA_02A7AC,Y       
                    STA $0F                   
                    LDA.W DATA_02A773,Y       
                    SEC                       
                    SBC $0E                   
                    TAY                       
ADDR_02A9FE:        LDA.W $14C8,Y             
                    BEQ ADDR_02AA0A           
                    DEY                       
                    CPY $0F                   
                    BNE ADDR_02A9FE           
                    LDY.B #$FF                
ADDR_02AA0A:        RTS                       ; Return 


DATA_02AA0B:        .db $31,$71,$A1,$43,$93,$C3,$14,$65
                    .db $E5,$36,$A7,$39,$99,$F9,$1A,$7A
                    .db $DA,$4C,$AD,$ED

DATA_02AA1F:        .db $01,$51,$91,$D1,$22,$62,$A2,$73
                    .db $E3,$C7,$88,$29,$5A,$AA,$EB,$2C
                    .db $8C,$CC,$FC,$5D

                    LDX.B #$0E                
ADDR_02AA35:        STZ.W $1E66,X             
                    STZ.W $0F86,X             
                    LDA.B #$08                
                    STA.W $1892,X             
                    JSL.L ADDR_01ACF9         
                    CLC                       
                    ADC $1A                   
                    STA.W $1E16,X             
                    STA.W $0F4A,X             
                    LDA $1B                   
                    ADC.B #$00                
                    STA.W $1E3E,X             
                    LDY $03                   
                    LDA [$CE],Y               
                    PHA                       
                    AND.B #$F0                
                    STA.W $1E02,X             
                    PLA                       
                    AND.B #$01                
                    STA.W $1E2A,X             
                    DEX                       
                    BPL ADDR_02AA35           
                    RTS                       ; Return 


DATA_02AA68:        .db $50,$90,$D0,$10

ADDR_02AA6C:        LDA.B #$07                
                    STA.W $14CB               
                    LDX.B #$03                
ADDR_02AA73:        LDA.B #$05                
                    STA.W $1892,X             
                    LDA.W DATA_02AA68,X       
                    STA.W $1E16,X             
                    LDA.B #$F0                
                    STA.W $1E02,X             
                    TXA                       
                    ASL                       
                    ASL                       
                    STA.W $0F4A,X             
                    DEX                       
                    BPL ADDR_02AA73           
                    RTS                       ; Return 

ADDR_02AA8D:        STZ.W $190A               
                    LDX.B #$13                
ADDR_02AA92:        LDA.B #$07                
                    STA.W $1892,X             
                    LDA.W DATA_02AA0B,X       
                    PHA                       
                    AND.B #$F0                
                    STA.W $1E66,X             
                    PLA                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    STA.W $1E52,X             
                    LDA.W DATA_02AA1F,X       
                    PHA                       
                    AND.B #$F0                
                    STA.W $1E8E,X             
                    PLA                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    STA.W $1E7A,X             
                    DEX                       
                    BPL ADDR_02AA92           
                    RTS                       ; Return 


DATA_02AABD:        .db $4C,$33,$AA

ADDR_02AAC0:        LDY.B #$01                
                    STY.W $18B8               
                    CMP.B #$E4                
                    BEQ DATA_02AABD           
                    CMP.B #$E6                
                    BEQ ADDR_02AA6C           
                    CMP.B #$E5                
                    BEQ ADDR_02AA8D           
                    CMP.B #$E2                
                    BCS ADDR_02AB11           
                    LDX.B #$13                
ADDR_02AAD7:        STZ.W $1E66,X             
                    STZ.W $0F86,X             
                    LDA.B #$03                
                    STA.W $1892,X             
                    JSL.L ADDR_01ACF9         
                    CLC                       
                    ADC $1A                   
                    STA.W $1E16,X             
                    STA.W $0F4A,X             
                    LDA $1B                   
                    ADC.B #$00                
                    STA.W $1E3E,X             
                    LDA.W $148E               
                    AND.B #$3F                
                    ADC.B #$08                
                    CLC                       
                    ADC $1C                   
                    STA.W $1E02,X             
                    LDA $1D                   
                    ADC.B #$00                
                    STA.W $1E2A,X             
                    DEX                       
                    BPL ADDR_02AAD7           
                    INC.W $18BA               
                    RTS                       ; Return 

ADDR_02AB11:        LDY.W $18BA               
                    CPY.B #$02                
                    BCS ADDR_02AB77           
                    LDY.B #$01                
                    CMP.B #$E2                
                    BEQ ADDR_02AB20           
                    LDY.B #$FF                
ADDR_02AB20:        STY $0F                   
                    LDA.B #$09                
                    STA $0E                   
                    LDX.B #$13                
ADDR_02AB28:        LDA.W $1892,X             
                    BNE ADDR_02AB71           
                    LDA.B #$04                
                    STA.W $1892,X             
                    LDA.W $18BA               
                    STA.W $0F86,X             
                    LDA $0E                   
                    STA.W $0F72,X             
                    LDA $0F                   
                    STA.W $0F4A,X             
                    STZ $0F                   
                    BEQ ADDR_02AB6D           
                    LDY $03                   
                    LDA [$CE],Y               
                    LDY.W $18BA               
                    PHA                       
                    AND.B #$F0                
                    STA.W $0FB6,Y             
                    PLA                       
                    AND.B #$01                
                    STA.W $0FB8,Y             
                    LDA $00                   
                    STA.W $0FB2,Y             
                    LDA $01                   
                    STA.W $0FB4,Y             
                    LDA.B #$00                
                    STA.W $0FBA,Y             
                    LDA $02                   
                    STA.W $0FBC,Y             
ADDR_02AB6D:        DEC $0E                   
                    BMI ADDR_02AB74           
ADDR_02AB71:        DEX                       
                    BPL ADDR_02AB28           
ADDR_02AB74:        INC.W $18BA               
ADDR_02AB77:        RTS                       ; Return 

ADDR_02AB78:        STX $02                   
                    DEY                       
                    STY $03                   
                    STA $04                   
                    LDX.B #$07                
ADDR_02AB81:        LDA.W $1783,X             
                    BEQ ADDR_02AB9E           
                    DEX                       
                    BPL ADDR_02AB81           
                    DEC.W $18FF               
                    BPL ADDR_02AB93           
                    LDA.B #$07                
                    STA.W $18FF               
ADDR_02AB93:        LDX.W $18FF               
                    LDY.W $17B3,X             
                    LDA.B #$00                
                    STA.W $1938,Y             
ADDR_02AB9E:        LDY $03                   
                    LDA $04                   
                    SEC                       
                    SBC.B #$C8                
                    STA.W $1783,X             
                    LDA $5B                   
                    LSR                       
                    BCC ADDR_02ABC7           
                    LDA [$CE],Y               
                    PHA                       
                    AND.B #$F0                
                    STA.W $179B,X             
                    PLA                       
                    AND.B #$01                
                    STA.W $17A3,X             
                    LDA $00                   
                    STA.W $178B,X             
                    LDA $01                   
                    STA.W $1793,X             
                    BRA ADDR_02ABDF           
ADDR_02ABC7:        LDA [$CE],Y               
                    PHA                       
                    AND.B #$F0                
                    STA.W $178B,X             
                    PLA                       
                    AND.B #$01                
                    STA.W $1793,X             
                    LDA $00                   
                    STA.W $179B,X             
                    LDA $01                   
                    STA.W $17A3,X             
ADDR_02ABDF:        LDA $02                   
                    STA.W $17B3,X             
                    LDA.B #$10                
                    STA.W $17AB,X             
                    INY                       
                    INY                       
                    INY                       
                    LDX $02                   
                    INX                       
                    JMP.W ADDR_02A82E         
ADDR_02ABF2:        LDX.B #$3F                
ADDR_02ABF4:        STZ.W $1938,X             
                    DEX                       
                    BPL ADDR_02ABF4           
                    LDA.B #$FF                
                    STA $00                   
                    LDX.B #$0B                
ADDR_02AC00:        LDA.B #$FF                
                    STA.W $161A,X             
                    LDA.W $14C8,X             
                    CMP.B #$0B                
                    BEQ ADDR_02AC11           
                    STZ.W $14C8,X             
                    BRA ADDR_02AC13           
ADDR_02AC11:        STX $00                   
ADDR_02AC13:        DEX                       
                    BPL ADDR_02AC00           
                    LDX $00                   
                    BMI ADDR_02AC48           
                    STZ.W $14C8,X             
                    LDA.B #$0B                
                    STA.W $14C8               
                    LDA $9E,X                 
                    STA $9E                   
                    LDA $E4,X                 
                    STA $E4                   
                    LDA.W $14E0,X             
                    STA.W $14E0               
                    LDA $D8,X                 
                    STA $D8                   
                    LDA.W $14D4,X             
                    STA.W $14D4               
                    LDA.W $15F6,X             
                    PHA                       
                    LDX.B #$00                
                    JSL.L ADDR_07F7D2         
                    PLA                       
                    STA.W $15F6               
ADDR_02AC48:        REP #$10                  ; Index (16 bit) 
                    LDX.W #$027A              
ADDR_02AC4D:        STZ.W $1693,X             
                    DEX                       
                    BPL ADDR_02AC4D           
                    SEP #$10                  ; Index (8 bit) 
                    STZ.W $143E               
                    STZ.W $143F               
                    RTS                       ; Return 

ADDR_02AC5C:        LDA $5B                   
                    LSR                       
                    BCC ADDR_02ACA1           
                    LDA $55                   
                    PHA                       
                    LDA.B #$01                
                    STA $55                   
                    LDA $1C                   
                    PHA                       
                    SEC                       
                    SBC.B #$60                
                    STA $1C                   
                    LDA $1D                   
                    PHA                       
                    SBC.B #$00                
                    STA $1D                   
                    STZ.W $18B6               
ADDR_02AC7A:        JSR.W ADDR_02A802         
                    JSR.W ADDR_02A802         
                    LDA $1C                   
                    CLC                       
                    ADC.B #$10                
                    STA $1C                   
                    LDA $1D                   
                    ADC.B #$00                
                    STA $1D                   
                    INC.W $18B6               
                    LDA.W $18B6               
                    CMP.B #$20                
                    BCC ADDR_02AC7A           
                    PLA                       
                    STA $1D                   
                    PLA                       
                    STA $1C                   
                    PLA                       
                    STA $55                   
                    RTS                       ; Return 

ADDR_02ACA1:        LDA $55                   
                    PHA                       
                    LDA.B #$01                
                    STA $55                   
                    LDA $1A                   
                    PHA                       
                    SEC                       
                    SBC.B #$60                
                    STA $1A                   
                    LDA $1B                   
                    PHA                       
                    SBC.B #$00                
                    STA $1B                   
                    STZ.W $18B6               
ADDR_02ACBA:        JSR.W ADDR_02A802         
                    JSR.W ADDR_02A802         
                    LDA $1A                   
                    CLC                       
                    ADC.B #$10                
                    STA $1A                   
                    LDA $1B                   
                    ADC.B #$00                
                    STA $1B                   
                    INC.W $18B6               
                    LDA.W $18B6               
                    CMP.B #$20                
                    BCC ADDR_02ACBA           
                    PLA                       
                    STA $1B                   
                    PLA                       
                    STA $1A                   
                    PLA                       
                    STA $55                   
                    RTS                       ; Return 

ADDR_02ACE1:        PHX                       
                    TYX                       
                    BRA ADDR_02ACE6           
GivePoints:         PHX                       ;  takes sprite type -5 as input in A 
ADDR_02ACE6:        CLC                       
                    ADC.B #$05                ; Add 5 to sprite type (200,400,1up) 
                    JSL.L ADDR_02ACEF         ; Set score sprite type/initial position 
                    PLX                       
                    RTL                       ; Return 

ADDR_02ACEF:        PHY                       ;  - note coordinates are level coords, not screen 
                    PHA                       ;    sprite type 1=10,2=20,3=40,4=80,5=100,6=200,7=400,8=800,9=1000,A=2000,B=4000,C=8000,D=1up 
                    JSL.L ADDR_02AD34         ; Get next free position in table($16E1) to add score sprite 
                    PLA                       
                    STA.W $16E1,Y             ; Set score sprite type (200,400,1up, etc) 
                    LDA $D8,X                 ; Load y position of sprite jumped on 
                    SEC                       
                    SBC.B #$08                ;   - make the score sprite appear a little higher 
                    STA.W $16E7,Y             ; Set this as score sprite y-position 
                    PHA                       ; save that value 
                    LDA.W $14D4,X             ; Get y-pos high byte for sprite jumped on 
                    SBC.B #$00                
                    STA.W $16F9,Y             ; Set score sprite y-pos high byte 
                    PLA                       ; restore score sprite y-pos to A 
                    SEC                       ; \ 
                    SBC $1C                   ; | 
                    CMP.B #$F0                ; |if (score sprite ypos <1C && >=0C) 
                    BCC ADDR_02AD22           ; |{ 
                    LDA.W $16E7,Y             ; | 
                    ADC.B #$10                ; | 
                    STA.W $16E7,Y             ; |  move score sprite down by #$10 
                    LDA.W $16F9,Y             ; | 
                    ADC.B #$00                ; | 
                    STA.W $16F9,Y             ; /} 
ADDR_02AD22:        LDA $E4,X                 ; \ 
                    STA.W $16ED,Y             ; /Set score sprite x-position 
                    LDA.W $14E0,X             ; \ 
                    STA.W $16F3,Y             ; /Set score sprite x-pos high byte 
                    LDA.B #$30                ; \ 
                    STA.W $16FF,Y             ; /scoreSpriteSpeed = #$30 
                    PLY                       
                    RTL                       ; Return 

ADDR_02AD34:        LDY.B #$05                ; (here css is used to index through the table of score sprites in table at $16E1 
ADDR_02AD36:        LDA.W $16E1,Y             ; for (css=5;css>=0;css--){ 
                    BEQ ADDR_02AD4B           ;  if (css's type == 0)      --check for empty space 
                    DEY                       
                    BPL ADDR_02AD36           ; } 
                    DEC.W $18F7               ; $18f7--;                   --gives LRU 
                    BPL ADDR_02AD48           ; if ($18f7 <0) 
                    LDA.B #$05                ;   $18f7=5; 
                    STA.W $18F7               
ADDR_02AD48:        LDY.W $18F7               ; return $18f7 in Y; 
ADDR_02AD4B:        RTL                       ; Return 


PointTile1:         .db $00,$83,$83,$83,$83,$44,$54,$46
                    .db $47,$44,$54,$46,$47,$56,$29,$39
                    .db $38,$5E,$5E,$5E,$5E,$5E

PointTile2:         .db $00,$44,$54,$46,$47,$45,$45,$45
                    .db $45,$55,$55,$55,$55,$57,$57,$57
                    .db $57,$4E,$44,$4F,$54,$5D

PointMultiplierLo:  .db $00,$01,$02,$04,$08,$0A,$14,$28
                    .db $50,$64,$C8,$90,$20,$00,$00,$00
                    .db $00

PointMultiplierHi:  .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$01,$03,$00,$00,$00
                    .db $00

PointSpeedY:        .db $03,$01,$00,$00

DATA_02AD9E:        .db $B0,$B8,$C0,$C8,$D0,$D8

ADDR_02ADA4:        BIT.W $0D9B               
                    BVC ADDR_02ADB8           
                    LDA.W $0D9B               
                    CMP.B #$C1                
                    BEQ ADDR_02ADC8           
                    LDA.B #$F0                
                    STA.W $0205               
                    STA.W $0209               
ADDR_02ADB8:        LDX.B #$05                
ADDR_02ADBA:        STX.W $15E9               
                    LDA.W $16E1,X             
                    BEQ ADDR_02ADC5           
                    JSR.W ADDR_02ADC9         
ADDR_02ADC5:        DEX                       
                    BPL ADDR_02ADBA           
ADDR_02ADC8:        RTS                       ; Return 

ADDR_02ADC9:        LDA $9D                   

Instr02ADCB:        .db $F0

ADDR_02ADCC:        .db $03

                    JMP.W ADDR_02AE5B         
                    LDA.W $16FF,X             

Instr02ADD3:        .db $D0

ADDR_02ADD4:        .db $0F

                    STZ.W $16E1,X             
                    RTS                       ; Return 


CoinsToGive:        .db $01,$02,$03,$05,$05,$0A,$0F,$14
                    .db $19

2Up3UpAttr:         .db $04,$06

                    DEC.W $16FF,X             
                    CMP.B #$2A                
                    BNE ADDR_02AE38           
                    LDY.W $16E1,X             
                    CPY.B #$0D                
                    BCC ADDR_02AE12           
                    CPY.B #$11                
                    BCC ADDR_02AE03           
                    PHX                       
                    PHY                       
                    LDA.W ADDR_02ADCC,Y       
                    JSL.L ADDR_05B329         
                    PLY                       
                    PLX                       
                    BRA ADDR_02AE12           
ADDR_02AE03:        LDA.W ADDR_02ADCC,Y       
                    CLC                       
                    ADC.W $18E4               
                    STA.W $18E4               
                    STZ.W $18E5               
                    BRA ADDR_02AE35           
ADDR_02AE12:        LDA.W $0DB3               
                    ASL                       
                    ADC.W $0DB3               
                    TAX                       
                    LDA.W $0F34,X             
                    CLC                       
                    ADC.W PointMultiplierLo,Y 
                    STA.W $0F34,X             
                    LDA.W $0F35,X             
                    ADC.W PointMultiplierHi,Y 
                    STA.W $0F35,X             
                    LDA.W $0F36,X             
                    ADC.B #$00                
                    STA.W $0F36,X             
ADDR_02AE35:        LDX.W $15E9               
ADDR_02AE38:        LDA.W $16FF,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA $13                   
                    AND.W PointSpeedY,Y       
                    BNE ADDR_02AE5B           
                    LDA.W $16E7,X             
                    TAY                       
                    SEC                       
                    SBC $1C                   
                    CMP.B #$04                
                    BCC ADDR_02AE5B           
                    DEC.W $16E7,X             
                    TYA                       
                    BNE ADDR_02AE5B           
                    DEC.W $16F9,X             
ADDR_02AE5B:        LDA.W $1705,X             
                    ASL                       
                    ASL                       
                    TAY                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W $001C,Y             
                    STA $02                   
                    LDA.W $001A,Y             
                    STA $04                   
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.W $16ED,X             
                    CLC                       
                    ADC.B #$0C                
                    PHP                       
                    SEC                       
                    SBC $04                   
                    LDA.W $16F3,X             
                    SBC $05                   
                    PLP                       
                    ADC.B #$00                
                    BNE ADDR_02AEFB           
                    LDA.W $16ED,X             
                    CMP $04                   
                    LDA.W $16F3,X             
                    SBC $05                   
                    BNE ADDR_02AEFB           
                    LDA.W $16E7,X             
                    CMP $02                   
                    LDA.W $16F9,X             
                    SBC $03                   
                    BNE ADDR_02AEFB           
                    LDY.W DATA_02AD9E,X       
                    BIT.W $0D9B               
                    BVC ADDR_02AEA5           
                    LDY.B #$04                
ADDR_02AEA5:        LDA.W $16E7,X             
                    SEC                       
                    SBC $02                   
                    STA.W $0201,Y             
                    STA.W $0205,Y             
                    LDA.W $16ED,X             
                    SEC                       
                    SBC $04                   
                    STA.W $0200,Y             
                    CLC                       
                    ADC.B #$08                
                    STA.W $0204,Y             
                    PHX                       
                    LDA.W $16E1,X             
                    TAX                       
                    LDA.W PointTile1,X        
                    STA.W $0202,Y             
                    LDA.W PointTile2,X        
                    STA.W $0206,Y             
                    PLX                       
                    PHY                       
                    LDY.W $16E1,X             
                    CPY.B #$0E                
                    LDA.B #$08                
                    BCC ADDR_02AEDF           
                    LDA.W ADDR_02ADD4,Y       
ADDR_02AEDF:        PLY                       
                    ORA.B #$30                
                    STA.W $0203,Y             
                    STA.W $0207,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$00                
                    STA.W $0420,Y             
                    STA.W $0421,Y             
                    LDA.W $16E1,X             
                    CMP.B #$11                
                    BCS ADDR_02AEFC           
ADDR_02AEFB:        RTS                       ; Return 

ADDR_02AEFC:        LDY.B #$4C                
                    LDA.W $16ED,X             
                    SEC                       
                    SBC $04                   
                    SEC                       
                    SBC.B #$08                
                    STA.W $0200,Y             
                    LDA.W $16E7,X             
                    SEC                       
                    SBC $02                   
                    STA.W $0201,Y             
                    LDA.B #$5F                
                    STA.W $0202,Y             
                    LDA.B #$04                
                    ORA.B #$30                
                    STA.W $0203,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$00                
                    STA.W $0420,Y             
                    RTS                       ; Return 

                    STZ.W $16E1,X             
                    RTS                       ; Return 


DATA_02AF2D:        .db $00,$AA,$54

DATA_02AF30:        .db $00,$00,$01

ADDR_02AF33:        LDY $03                   
                    LDA [$CE],Y               
                    PHA                       
                    AND.B #$F0                
                    STA $08                   
                    PLA                       
                    AND.B #$01                
                    STA $09                   
                    LDA.B #$02                
                    STA $04                   
ADDR_02AF45:        JSL.L ADDR_02A9E4         
                    BMI ADDR_02AF86           
                    TYX                       
                    LDA.B #$01                
                    STA.W $14C8,X             
                    LDA.B #$A3                
                    STA $9E,X                 
                    JSL.L ADDR_07F7D2         
                    LDA $00                   
                    STA $E4,X                 
                    LDA $01                   
                    STA.W $14E0,X             
                    LDA $08                   
                    STA $D8,X                 
                    LDA $09                   
                    STA.W $14D4,X             
                    LDY $04                   
                    LDA.W DATA_02AF2D,Y       
                    STA.W $1602,X             
                    LDA.W DATA_02AF30,Y       
                    STA.W $151C,X             
                    CPY.B #$02                
                    BNE ADDR_02AF82           
                    LDA $02                   
                    STA.W $161A,X             
ADDR_02AF82:        DEC $04                   
                    BPL ADDR_02AF45           
ADDR_02AF86:        RTS                       ; Return 


DATA_02AF87:        .db $E0,$F0,$00,$10,$20

DATA_02AF8C:        .db $FF,$FF,$00,$00,$00

DATA_02AF91:        .db $17,$E9,$17,$E9,$17

DATA_02AF96:        .db $00,$01,$00,$01,$00

DATA_02AF9B:        .db $10,$F0

ADDR_02AF9D:        LDY $03                   
                    LDA [$CE],Y               
                    PHA                       
                    AND.B #$F0                
                    STA $08                   
                    PLA                       
                    AND.B #$01                
                    STA $09                   
                    LDA.B #$04                
                    STA $04                   
ADDR_02AFAF:        JSL.L ADDR_02A9E4         
                    BMI ADDR_02AFFD           
                    TYX                       
                    LDA.B #$08                
                    STA.W $14C8,X             
                    LDA.B #$39                
                    STA $9E,X                 
                    JSL.L ADDR_07F7D2         
                    LDY $04                   
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_02AF87,Y       
                    STA $E4,X                 
                    LDA $01                   
                    ADC.W DATA_02AF8C,Y       
                    STA.W $14E0,X             
                    LDA $08                   
                    STA $D8,X                 
                    LDA $09                   
                    STA.W $14D4,X             
                    LDA.W DATA_02AF91,Y       
                    STA $AA,X                 
                    LDA.W DATA_02AF96,Y       
                    STA $C2,X                 
                    CPY.B #$04                
                    BNE ADDR_02AFF1           
                    LDA $02                   
                    STA.W $161A,X             
ADDR_02AFF1:        JSR.W ADDR_02848D         
                    LDA.W DATA_02AF9B,Y       
                    STA $B6,X                 
                    DEC $04                   
                    BPL ADDR_02AFAF           
ADDR_02AFFD:        RTS                       ; Return 

ADDR_02AFFE:        LDA.W $18B9               
                    BEQ ADDR_02B02A           
                    LDY $9D                   
                    BNE ADDR_02B02A           
                    DEC A                     
                    JSL.L ExecutePtr          

Ptrs02B00C:         .dw ADDR_02B2D6           
                    .dw ADDR_02B329           
                    .dw ADDR_02B329           
                    .dw ADDR_02B329           
                    .dw ADDR_02B26C           
                    .dw ADDR_02B26C           
                    .dw ADDR_02B15B           
                    .dw ADDR_02B02B           
                    .dw ADDR_02B1BC           
                    .dw ADDR_02B207           
                    .dw ADDR_02B07C           
                    .dw ADDR_02B0CD           
                    .dw ADDR_02B0CD           
                    .dw ADDR_02B036           
                    .dw ADDR_02B032           

ADDR_02B02A:        RTS                       ; Return 

ADDR_02B02B:        INC.W $18BF               
                    STZ.W $18C0               
                    RTS                       ; Return 

ADDR_02B032:        STZ.W $18B9               
                    RTS                       ; Return 

ADDR_02B036:        LDA $14                   
                    AND.B #$7F                
                    BNE ADDR_02B07B           
                    JSL.L ADDR_02A9DE         
                    BMI ADDR_02B07B           
                    TYX                       
                    LDA.B #$17                
                    STA.W $1DFC               ; / Play sound effect 
                    LDA.B #$08                
                    STA.W $14C8,X             
                    LDA.B #$B3                
                    STA $9E,X                 
                    JSL.L ADDR_07F7D2         
                    JSL.L ADDR_01ACF9         
                    AND.B #$7F                
                    ADC.B #$20                
                    ADC $1C                   
                    AND.B #$F0                
                    STA $D8,X                 
                    LDA $1D                   
                    ADC.B #$00                
                    STA.W $14D4,X             
                    LDA $1A                   
                    CLC                       
                    ADC.B #$FF                
                    STA $E4,X                 
                    LDA $1B                   
                    ADC.B #$00                
                    STA.W $14E0,X             
                    INC.W $157C,X             
ADDR_02B07B:        RTS                       ; Return 

ADDR_02B07C:        LDA $14                   
                    AND.B #$7F                
                    BNE ADDR_02B0C8           
                    JSL.L ADDR_02A9DE         
                    BMI ADDR_02B0C8           
                    LDA.B #$09                
                    STA.W $1DFC               ; / Play sound effect 
                    TYX                       
                    LDA.B #$08                
                    STA.W $14C8,X             
                    LDA.B #$1C                
                    STA $9E,X                 
                    JSL.L ADDR_07F7D2         
                    JSL.L ADDR_01ACF9         
                    PHA                       
                    AND.B #$7F                
                    ADC.B #$20                
                    ADC $1C                   
                    AND.B #$F0                
                    STA $D8,X                 
                    LDA $1D                   
                    ADC.B #$00                
                    STA.W $14D4,X             
                    PLA                       
                    AND.B #$01                
                    TAY                       
                    LDA $1A                   
                    CLC                       
                    ADC.W DATA_02B1B8,Y       
                    STA $E4,X                 
ADDR_02B0BD:        LDA $1B                   
ADDR_02B0BF:        ADC.W DATA_02B1BA,Y       
                    STA.W $14E0,X             
                    TYA                       
                    STA $C2,X                 
ADDR_02B0C8:        RTS                       ; Return 


DATA_02B0C9:        .db $04,$08,$04,$03

ADDR_02B0CD:        LDA $14                   
                    LSR                       
                    BCS ADDR_02B0F9           
                    LDA.W $18FE               
                    INC.W $18FE               
                    CMP.B #$A0                
                    BNE ADDR_02B0F9           
                    STZ.W $18FE               
                    LDA.B #$09                
                    STA.W $1DFC               ; / Play sound effect 
                    LDY.W $18B9               
                    LDA.W ADDR_02B0BD,Y       
                    LDX.W ADDR_02B0BF,Y       
                    STA $0D                   
ADDR_02B0EF:        PHX                       
                    JSR.W ADDR_02B115         
                    DEC $0D                   
                    PLX                       
                    DEX                       
                    BPL ADDR_02B0EF           
ADDR_02B0F9:        RTS                       ; Return 


DATA_02B0FA:        .db $00,$00,$40,$C0,$F0,$00,$00,$F0
                    .db $F0

DATA_02B103:        .db $50,$B0,$E0,$E0,$80,$00,$E0,$E0
                    .db $00

DATA_02B10C:        .db $00,$00,$02,$02,$01,$05,$04,$07
                    .db $06

ADDR_02B115:        JSL.L ADDR_02A9DE         
                    BMI ADDR_02B152           
                    LDA.B #$1C                
                    STA.W $009E,Y             
                    LDA.B #$08                
                    STA.W $14C8,Y             
                    TYX                       
                    JSL.L ADDR_07F7D2         
                    LDX $0D                   
                    LDA.W DATA_02B0FA,X       
                    CLC                       
                    ADC $1A                   
                    STA.W $00E4,Y             
                    LDA $1B                   
                    ADC.B #$00                
                    STA.W $14E0,Y             
                    LDA.W DATA_02B103,X       
                    CLC                       
                    ADC $1C                   
                    STA.W $00D8,Y             
                    LDA $1D                   
                    ADC.B #$00                
                    STA.W $14D4,Y             
                    LDA.W DATA_02B10C,X       
                    STA.W $00C2,Y             
ADDR_02B152:        RTS                       ; Return 


DATA_02B153:        .db $10,$18,$20,$28

DATA_02B157:        .db $18,$1A,$1C,$1E

ADDR_02B15B:        LDA $14                   
                    AND.B #$1F                
                    BNE ADDR_02B1B7           
                    JSL.L ADDR_02A9DE         
                    BMI ADDR_02B1B7           
                    TYX                       
                    LDA.B #$08                
                    STA.W $14C8,X             
                    LDA.B #$17                
                    STA $9E,X                 
                    JSL.L ADDR_07F7D2         
                    LDA $1C                   
                    CLC                       
                    ADC.B #$C0                
                    STA $D8,X                 
                    LDA $1D                   
                    ADC.B #$00                
                    STA.W $14D4,X             
                    JSL.L ADDR_01ACF9         
                    CMP.B #$00                
                    PHP                       
                    PHP                       
                    AND.B #$03                
                    TAY                       
                    LDA.W DATA_02B153,Y       
                    PLP                       
                    BPL ADDR_02B196           
                    EOR.B #$FF                
ADDR_02B196:        CLC                       
                    ADC $1A                   
                    STA $E4,X                 
                    LDA $1B                   
                    ADC.B #$00                
                    STA.W $14E0,X             
                    LDA.W $148E               
                    AND.B #$03                
                    TAY                       
                    LDA.W DATA_02B157,Y       
                    PLP                       
                    BPL ADDR_02B1B1           
                    EOR.B #$FF                
                    INC A                     
ADDR_02B1B1:        STA $B6,X                 
                    LDA.B #$B8                
                    STA $AA,X                 
ADDR_02B1B7:        RTS                       ; Return 


DATA_02B1B8:        .db $E0,$10

DATA_02B1BA:        .db $FF,$01

ADDR_02B1BC:        LDA $14                   
                    AND.B #$3F                
                    BNE ADDR_02B206           
                    JSL.L ADDR_02A9DE         
                    BMI ADDR_02B206           
                    TYX                       
                    LDA.B #$08                
                    STA.W $14C8,X             
                    LDA.B #$71                
                    STA $9E,X                 
                    JSL.L ADDR_07F7D2         
                    JSL.L ADDR_01ACF9         
                    PHA                       
                    AND.B #$3F                
                    ADC.B #$20                
                    ADC $1C                   
                    STA $D8,X                 
                    LDA $1D                   
                    ADC.B #$00                
                    STA.W $14D4,X             
                    LDA.B #$28                
                    STA $AA,X                 
                    PLA                       
                    AND.B #$01                
                    TAY                       
                    LDA $1A                   
                    CLC                       
                    ADC.W DATA_02B1B8,Y       
                    STA $E4,X                 
                    LDA $1B                   
                    ADC.W DATA_02B1BA,Y       
                    STA.W $14E0,X             
                    TYA                       
                    STA.W $157C,X             
ADDR_02B206:        RTS                       ; Return 

ADDR_02B207:        LDA $14                   
                    AND.B #$7F                
                    BNE ADDR_02B259           
                    JSL.L ADDR_02A9DE         
                    BMI ADDR_02B259           
                    TYX                       
                    LDA.B #$08                
                    STA.W $14C8,X             
                    LDA.B #$9D                
                    STA $9E,X                 
                    JSL.L ADDR_07F7D2         
                    JSL.L ADDR_01ACF9         
                    PHA                       
                    AND.B #$3F                
                    ADC.B #$20                
                    ADC $1C                   
                    STA $D8,X                 
                    LDA $1D                   
                    ADC.B #$00                
                    STA.W $14D4,X             
                    PLA                       
                    AND.B #$01                
                    TAY                       
                    LDA $1A                   
                    CLC                       
                    ADC.W DATA_02B1B8,Y       
                    STA $E4,X                 
                    LDA $1B                   
                    ADC.W DATA_02B1BA,Y       
                    STA.W $14E0,X             
                    TYA                       
                    STA.W $157C,X             
                    JSL.L ADDR_01ACF9         
                    AND.B #$03                
                    TAY                       
                    LDA.W DATA_02B25A,Y       
                    STA $C2,X                 
ADDR_02B259:        RTS                       ; Return 


DATA_02B25A:        .db $00

DATA_02B25B:        .db $01,$02

DATA_02B25D:        .db $00,$10,$E0,$01,$FF,$E8

DATA_02B263:        .db $18

DATA_02B264:        .db $F0

DATA_02B265:        .db $E0,$00,$10,$04,$09,$FF,$04

ADDR_02B26C:        LDA $14                   
                    AND.B #$1F                
                    BNE ADDR_02B2CF           
                    LDY.W $18B9               
                    LDX.W DATA_02B263,Y       
                    LDA.W DATA_02B265,Y       
                    STA $00                   
ADDR_02B27D:        LDA.W $14C8,X             
                    BEQ ADDR_02B288           
                    DEX                       
                    CPX $00                   
                    BNE ADDR_02B27D           
                    RTS                       ; Return 

ADDR_02B288:        LDA.B #$08                
                    STA.W $14C8,X             
                    LDA.B #$41                
                    STA $9E,X                 
                    JSL.L ADDR_07F7D2         
                    JSL.L ADDR_01ACF9         
                    AND.B #$7F                
                    ADC.B #$40                
                    ADC $1C                   
                    STA $D8,X                 
                    LDA $1D                   
                    ADC.B #$00                
                    STA.W $14D4,X             
                    JSL.L ADDR_01ACF9         
                    AND.B #$03                
                    TAY                       
                    LDA.W DATA_02B264,Y       
                    STA $AA,X                 
                    LDY.W $18B9               
                    LDA $1A                   
                    CLC                       
                    ADC.W ADDR_02B259,Y       
                    STA $E4,X                 
                    LDA $1B                   
                    ADC.W DATA_02B25B,Y       
                    STA.W $14E0,X             
                    LDA.W DATA_02B25D,Y       
                    STA $B6,X                 
                    INC.W $151C,X             
ADDR_02B2CF:        RTS                       ; Return 


DATA_02B2D0:        .db $F0,$FF

DATA_02B2D2:        .db $FF,$00

DATA_02B2D4:        .db $10,$F0

ADDR_02B2D6:        LDA $14                   
                    AND.B #$3F                
                    BNE ADDR_02B31E           
                    JSL.L ADDR_02A9DE         
                    BMI ADDR_02B31E           
                    TYX                       
                    LDA.B #$08                
                    STA.W $14C8,X             
                    LDA.B #$38                
                    STA $9E,X                 
                    JSL.L ADDR_07F7D2         
                    JSL.L ADDR_01ACF9         
                    AND.B #$7F                
                    ADC.B #$40                
                    ADC $1C                   
                    STA $D8,X                 
                    LDA $1D                   
                    ADC.B #$00                
                    STA.W $14D4,X             
                    LDA.W $148E               
                    AND.B #$01                
                    TAY                       
                    LDA.W DATA_02B2D0,Y       
                    CLC                       
                    ADC $1A                   
                    STA $E4,X                 
                    LDA $1B                   
                    ADC.W DATA_02B2D2,Y       
                    STA.W $14E0,X             
                    LDA.W DATA_02B2D4,Y       

Instr02B31C:        .db $95

ADDR_02B31D:        .db $B6

ADDR_02B31E:        RTS                       ; Return 


DATA_02B31F:        .db $3F,$40,$3F,$3F,$40,$40

DATA_02B325:        .db $FA,$FB,$FC,$FD

ADDR_02B329:        LDA $14                   
                    AND.B #$7F                
                    BNE ADDR_02B386           
                    JSL.L ADDR_02A9DE         
                    BMI ADDR_02B386           
                    TYX                       
                    LDA.B #$08                
                    STA.W $14C8,X             
                    JSL.L ADDR_01ACF9         
                    LSR                       
                    LDY.W $18B9               
                    BCC ADDR_02B348           
                    INY                       
                    INY                       
                    INY                       
ADDR_02B348:        LDA.W ADDR_02B31D,Y       
                    STA $9E,X                 
                    JSL.L ADDR_07F7D2         
                    LDA $1C                   
                    SEC                       
                    SBC.B #$20                
                    STA $D8,X                 
                    LDA $1D                   
                    SBC.B #$00                
                    STA.W $14D4,X             
                    LDA.W $148D               
                    AND.B #$FF                
                    CLC                       
                    ADC.B #$30                
                    PHP                       
                    ADC $1A                   
                    STA $E4,X                 
                    PHP                       
                    AND.B #$0E                
                    STA.W $1570,X             
                    LSR                       
                    AND.B #$03                
                    TAY                       
                    LDA.W DATA_02B325,Y       
                    STA $B6,X                 
                    LDA $1B                   
                    PLP                       
                    ADC.B #$00                
                    PLP                       
                    ADC.B #$00                
                    STA.W $14E0,X             
ADDR_02B386:        RTS                       ; Return 

ADDR_02B387:        LDA $9D                   
                    BNE ADDR_02B3AA           
                    LDX.B #$07                
ADDR_02B38D:        STX.W $15E9               
                    LDA.W $1783,X             
                    BEQ ADDR_02B3A7           
                    LDY.W $17AB,X             
                    BEQ ADDR_02B3A4           
                    PHA                       
                    LDA $13                   
                    LSR                       
                    BCC ADDR_02B3A3           
                    DEC.W $17AB,X             
ADDR_02B3A3:        PLA                       
ADDR_02B3A4:        JSR.W ADDR_02B3AB         
ADDR_02B3A7:        DEX                       
                    BPL ADDR_02B38D           
ADDR_02B3AA:        RTS                       ; Return 

ADDR_02B3AB:        DEC A                     
                    JSL.L ExecutePtr          

Ptrs02B3B0:         .dw ADDR_02B466           
                    .dw ADDR_02B3B6           
                    .dw ADDR_02B3AA           

ADDR_02B3B6:        LDA.W $17AB,X             
                    BNE ADDR_02B42C           
                    LDA.B #$50                
                    STA.W $17AB,X             
                    LDA.W $178B,X             
                    CMP $1C                   
                    LDA.W $1793,X             
                    SBC $1D                   
                    BNE ADDR_02B3AA           
                    LDA.W $179B,X             
                    CMP $1A                   
                    LDA.W $17A3,X             
                    SBC $1B                   
                    BNE ADDR_02B3AA           
                    LDA.W $179B,X             
                    SEC                       
                    SBC $1A                   
                    CLC                       
                    ADC.B #$10                
                    CMP.B #$20                
                    BCC ADDR_02B42C           
                    JSL.L ADDR_02A9DE         
                    BMI ADDR_02B42C           
                    LDA.B #$08                
                    STA.W $14C8,Y             
                    LDA.B #$44                
                    STA.W $009E,Y             
                    LDA.W $179B,X             
                    STA.W $00E4,Y             
                    LDA.W $17A3,X             
                    STA.W $14E0,Y             
                    LDA.W $178B,X             
                    STA.W $00D8,Y             
                    LDA.W $1793,X             
                    STA.W $14D4,Y             
                    PHX                       
                    TYX                       
                    JSL.L ADDR_07F7D2         
                    JSR.W ADDR_02848D         
                    TYA                       
                    STA.W $157C,X             
                    STA $00                   
                    LDA.B #$30                
                    STA.W $1540,X             
                    PLX                       
                    LDY.B #$07                
ADDR_02B424:        LDA.W $170B,Y             
                    BEQ ADDR_02B42D           
                    DEY                       
                    BPL ADDR_02B424           
ADDR_02B42C:        RTS                       ; Return 

ADDR_02B42D:        LDA.B #$08                
                    STA.W $170B,Y             
                    LDA.W $179B,X             
                    CLC                       
                    ADC.B #$08                
                    STA.W $171F,Y             
                    LDA.W $17A3,X             
                    ADC.B #$00                
                    STA.W $1733,Y             
                    LDA.W $178B,X             
                    SEC                       
                    SBC.B #$09                
                    STA.W $1715,Y             
                    LDA.W $1793,X             
                    SBC.B #$00                
                    STA.W $1729,Y             
                    LDA.B #$90                
                    STA.W $176F,Y             
                    PHX                       
                    LDX $00                   
                    LDA.W DATA_02B464,X       
                    STA.W $1747,Y             
                    PLX                       
                    RTS                       ; Return 


DATA_02B464:        .db $01,$FF

ADDR_02B466:        LDA.W $17AB,X             ; \ Return if it's not time to generate			        
                    BNE ADDR_02B4DD           ; /								        
                    LDA.B #$60                ; \ Set time till next generation = 60			        
                    STA.W $17AB,X             ; /								        
                    LDA.W $178B,X             ; \ Don't generate if off screen vertically			        
                    CMP $1C                   ;  |							        
                    LDA.W $1793,X             ;  |							        
                    SBC $1D                   ;  |							        
                    BNE ADDR_02B4DD           ; /								        
                    LDA.W $179B,X             ; \ Don't generate if off screen horizontally		        
                    CMP $1A                   ;  |							        
                    LDA.W $17A3,X             ;  |							        
                    SBC $1B                   ;  |							        
                    BNE ADDR_02B4DD           ; / 							        
                    LDA.W $179B,X             ; \ ?? something else related to x position of generator??	        
                    SEC                       ;  | 							        
                    SBC $1A                   ;  |							        
                    CLC                       ;  |							        
                    ADC.B #$10                ;  |							        
                    CMP.B #$10                ;  |							        
                    BCC ADDR_02B4DD           ; /								        
                    LDA $94                   ; \ Don't fire if mario is next to generator		        
                    SBC.W $179B,X             ;  |							        
                    CLC                       ;  |							        
                    ADC.B #$11                ;  |							        
                    CMP.B #$22                ;  |							        
                    BCC ADDR_02B4DD           ; /								        
                    JSL.L ADDR_02A9DE         ; \ Get an index to an unused sprite slot, return if all slots full 
                    BMI ADDR_02B4DD           ; / After: Y has index of sprite being generated		 
GenerateBullet:     LDA.B #$09                ; \ 							 
                    STA.W $1DFC               ; / Play sound effect 
                    LDA.B #$01                ; \ Set sprite status for new sprite			 
                    STA.W $14C8,Y             ; /								 
                    LDA.B #$1C                ; \ Set sprite number for new sprite			 
                    STA.W $009E,Y             ; /								 
                    LDA.W $179B,X             ; \ Set x position for new sprite				 
                    STA.W $00E4,Y             ;  |							 
                    LDA.W $17A3,X             ;  |							 
                    STA.W $14E0,Y             ; /								 
                    LDA.W $178B,X             ; \ Set y position for new sprite				 
                    SEC                       ;  | (y position of generator - 1)				 
                    SBC.B #$01                ;  |							 
                    STA.W $00D8,Y             ;  |							 
                    LDA.W $1793,X             ;  |							 
                    SBC.B #$00                ;  |							 
                    STA.W $14D4,Y             ; /								 
                    PHX                       ; \ Before: X must have index of sprite being generated	 
                    TYX                       ;  | Routine clears *all* old sprite values...		 
                    JSL.L ADDR_07F7D2         ;  | ...and loads in new values for the 6 main sprite tables 
                    PLX                       ; / 							 
                    JSR.W ShowShooterSmoke    ; Display smoke graphic                                      
ADDR_02B4DD:        RTS                       ; Return 

ShowShooterSmoke:   LDY.B #$03                ; \ Find a free slot to display effect 
FindFreeSmokeSlot:  LDA.W $17C0,Y             ;  | 
                    BEQ SetShooterSmoke       ;  | 
                    DEY                       ;  | 
                    BPL FindFreeSmokeSlot     ;  | 
                    RTS                       ; / Return if no slots open 


ShooterSmokeDispX:  .db $F4,$0C

SetShooterSmoke:    LDA.B #$01                ; \ Set effect graphic to smoke graphic		  
                    STA.W $17C0,Y             ; /							  
                    LDA.W $178B,X             ; \ Smoke y position = generator y position		  
                    STA.W $17C4,Y             ; /							  
                    LDA.B #$1B                ; \ Set time to show smoke				  
                    STA.W $17CC,Y             ; /							  
                    LDA.W $179B,X             ; \ Load generator x position and store it for later  
                    PHA                       ; /							  
                    LDA $94                   ; \ Determine which side of the generator mario is on 
                    CMP.W $179B,X             ;  |						  
                    LDA $95                   ;  |						  
                    SBC.W $17A3,X             ;  |						  
                    LDX.B #$00                ;  |						  
                    BCC ADDR_02B50E           ;  |						  
                    INX                       ; /							  
ADDR_02B50E:        PLA                       ; \ Set smoke x position from generator position	  
                    CLC                       ;  |						  
                    ADC.W ShooterSmokeDispX,X ;  |						  
                    STA.W $17C8,Y             ; /   
                    LDX.W $15E9               
                    RTS                       ; Return 

ADDR_02B51A:        TXA                       
                    CLC                       
                    ADC.B #$04                
                    TAX                       
                    JSR.W ADDR_02B526         
                    LDX.W $1698               
                    RTS                       ; Return 

ADDR_02B526:        LDA.W $16B1,X             
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    CLC                       
                    ADC.W $16B9,X             
                    STA.W $16B9,X             
                    PHP                       
                    LDA.W $16B1,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    CMP.B #$08                
                    LDY.B #$00                
                    BCC ADDR_02B545           
                    ORA.B #$F0                
                    DEY                       
ADDR_02B545:        PLP                       
                    ADC.W $16A1,X             
                    STA.W $16A1,X             
                    TYA                       
                    ADC.W $16A9,X             
                    STA.W $16A9,X             
                    RTS                       ; Return 

ADDR_02B554:        TXA                       
                    CLC                       
                    ADC.B #$0A                
                    TAX                       
                    JSR.W ADDR_02B560         
                    LDX.W $15E9               
                    RTS                       ; Return 

ADDR_02B560:        LDA.W $173D,X             
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    CLC                       
                    ADC.W $1751,X             
                    STA.W $1751,X             
                    PHP                       
                    LDY.B #$00                
                    LDA.W $173D,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    CMP.B #$08                
                    BCC ADDR_02B57F           
                    ORA.B #$F0                
                    DEY                       
ADDR_02B57F:        PLP                       
                    ADC.W $1715,X             
                    STA.W $1715,X             
                    TYA                       
                    ADC.W $1729,X             
                    STA.W $1729,X             
                    RTS                       ; Return 

ADDR_02B58E:        LDA.W $17D8,X             
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    CLC                       
                    ADC.W $17DC,X             
                    STA.W $17DC,X             
                    PHP                       
                    LDY.B #$00                
                    LDA.W $17D8,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    CMP.B #$08                
                    BCC ADDR_02B5AD           
                    ORA.B #$F0                
                    DEY                       
ADDR_02B5AD:        PLP                       
                    ADC.W $17D4,X             
                    STA.W $17D4,X             
                    TYA                       
                    ADC.W $17E8,X             
                    STA.W $17E8,X             
                    RTS                       ; Return 

ADDR_02B5BC:        TXA                       
                    CLC                       
                    ADC.B #$0C                
                    TAX                       
                    JSR.W ADDR_02B5C8         
                    LDX.W $1698               
                    RTS                       ; Return 

ADDR_02B5C8:        LDA.W $1820,X             
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    CLC                       
                    ADC.W $1838,X             
                    STA.W $1838,X             
                    PHP                       
                    LDA.W $1820,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    CMP.B #$08                
                    BCC ADDR_02B5E4           
                    ORA.B #$F0                
ADDR_02B5E4:        PLP                       
                    ADC.W $17FC,X             
                    STA.W $17FC,X             
                    RTS                       ; Return 


DATA_02B5EC:        .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF

DATA_02B630:        .db $1B,$1B,$1A,$19,$18,$17

ADDR_02B636:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02B672         
                    LDA $C2,X                 
                    PHX                       
                    LDX.B #$04                
                    LDY.B #$00                
ADDR_02B643:        LSR                       
                    BCC ADDR_02B647           
                    INY                       
ADDR_02B647:        DEX                       
                    BPL ADDR_02B643           
                    PLX                       
                    LDA.W DATA_02B630,Y       
                    STA.W $1662,X             
                    PLB                       
                    RTL                       ; Return 


DATA_02B653:        .db $01,$02,$04,$08

DATA_02B657:        .db $00,$01,$03,$07

DATA_02B65B:        .db $FF,$FE,$FC,$F8

PokeyTileDispX:     .db $00,$01,$00,$FF

PokeySpeed:         .db $02,$FE

DATA_02B665:        .db $00,$05,$09,$0C,$0E,$0F,$10,$10
                    .db $10,$10,$10,$10,$10

ADDR_02B672:        LDA.W $1534,X             
                    BNE ADDR_02B681           
                    LDA.W $14C8,X             
                    CMP.B #$08                
                    BEQ ADDR_02B6A7           
                    JMP.W ADDR_02B726         
ADDR_02B681:        JSL.L GenericSprGfxRt     
                    LDY.W $15EA,X             
                    LDA $C2,X                 
                    CMP.B #$01                
                    LDA.B #$8A                
                    BCC ADDR_02B692           
                    LDA.B #$E8                
ADDR_02B692:        STA.W $0302,Y             
                    LDA.W $14C8,X             
                    CMP.B #$08                
                    BNE ADDR_02B6A6           
                    JSR.W ADDR_02D294         
                    INC $AA,X                 
                    INC $AA,X                 
                    JSR.W ADDR_02D025         
ADDR_02B6A6:        RTS                       ; Return 

ADDR_02B6A7:        LDA $C2,X                 
                    BNE ADDR_02B6AF           
ADDR_02B6AB:        STZ.W $14C8,X             
                    RTS                       ; Return 

ADDR_02B6AF:        CMP.B #$20                
                    BCS ADDR_02B6AB           
                    LDA $9D                   
                    BNE ADDR_02B726           
                    JSR.W ADDR_02D025         
                    JSL.L MarioSprInteract    
                    INC.W $1570,X             
                    LDA.W $1570,X             
                    AND.B #$7F                
                    BNE ADDR_02B6CF           
                    JSR.W ADDR_02D4FA         
                    TYA                       
                    STA.W $157C,X             
ADDR_02B6CF:        LDY.W $157C,X             
                    LDA.W PokeySpeed,Y        
                    STA $B6,X                 
                    JSR.W ADDR_02D288         
                    JSR.W ADDR_02D294         
                    LDA $AA,X                 
                    CMP.B #$40                
                    BPL ADDR_02B6E8           
                    CLC                       
                    ADC.B #$02                
                    STA $AA,X                 
ADDR_02B6E8:        JSL.L ADDR_019138         
                    LDA.W $1588,X             
                    AND.B #$04                
                    BEQ ADDR_02B6F5           
                    STZ $AA,X                 
ADDR_02B6F5:        LDA.W $1588,X             
                    AND.B #$03                
                    BEQ ADDR_02B704           
                    LDA.W $157C,X             
                    EOR.B #$01                
                    STA.W $157C,X             
ADDR_02B704:        JSR.W ADDR_02B7AC         
                    LDY.B #$00                
ADDR_02B709:        LDA $C2,X                 
                    AND.W DATA_02B653,Y       
                    BNE ADDR_02B721           
                    LDA $C2,X                 
                    PHA                       
                    AND.W DATA_02B657,Y       
                    STA $00                   
                    PLA                       
                    LSR                       
                    AND.W DATA_02B65B,Y       
                    ORA $00                   
                    STA $C2,X                 
ADDR_02B721:        INY                       
                    CPY.B #$04                
                    BNE ADDR_02B709           
ADDR_02B726:        JSR.W GetDrawInfo2        
                    LDA $01                   
                    CLC                       
                    ADC.B #$40                
                    STA $01                   
                    LDA $C2,X                 
                    STA $02                   
                    STA $07                   
                    LDA.W $151C,X             
                    STA $04                   
                    LDY.W $1540,X             
                    LDA.W DATA_02B665,Y       
                    STA $03                   
                    STZ $05                   
                    LDY.W $15EA,X             
                    PHX                       
                    LDX.B #$04                
ADDR_02B74B:        STX $06                   
                    LDA $14                   
                    LSR                       
                    LSR                       
                    LSR                       
                    CLC                       
                    ADC $06                   
                    AND.B #$03                
                    TAX                       
                    LDA $07                   
                    CMP.B #$01                
                    BNE ADDR_02B760           
                    LDX.B #$00                
ADDR_02B760:        LDA $00                   
                    CLC                       
                    ADC.W PokeyTileDispX,X    
                    STA.W $0300,Y             
                    LDX $06                   
                    LDA $01                   
                    LSR $02                   
                    BCC ADDR_02B781           
                    LSR $04                   
                    BCS ADDR_02B77B           
                    PHA                       
                    LDA $03                   
                    STA $05                   
                    PLA                       
ADDR_02B77B:        SEC                       
                    SBC $05                   
                    STA.W $0301,Y             
ADDR_02B781:        LDA $01                   
                    SEC                       
                    SBC.B #$10                
                    STA $01                   
                    LDA $02                   
                    LSR                       
                    LDA.B #$E8                
                    BCS ADDR_02B791           
                    LDA.B #$8A                
ADDR_02B791:        STA.W $0302,Y             
                    LDA.B #$05                
                    ORA $64                   
                    STA.W $0303,Y             
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_02B74B           
                    PLX                       
                    LDA.B #$04                
                    LDY.B #$02                
ADDR_02B7A7:        JSL.L ADDR_01B7B3         
                    RTS                       ; Return 

ADDR_02B7AC:        LDY.B #$09                
ADDR_02B7AE:        TYA                       
                    EOR $13                   
                    LSR                       
                    BCS ADDR_02B7D2           
                    LDA.W $14C8,Y             
                    CMP.B #$0A                
                    BNE ADDR_02B7D2           
                    PHB                       
                    LDA.B #$03                
                    PHA                       
                    PLB                       
                    PHX                       
                    TYX                       
                    JSL.L ADDR_03B6E5         
                    PLX                       
                    JSL.L ADDR_03B69F         
                    JSL.L ADDR_03B72B         
                    PLB                       
                    BCS ADDR_02B7D6           
ADDR_02B7D2:        DEY                       
                    BPL ADDR_02B7AE           
ADDR_02B7D5:        RTS                       ; Return 

ADDR_02B7D6:        LDA.W $1558,X             
                    BNE ADDR_02B7D5           
                    LDA.W $00D8,Y             
                    SEC                       
                    SBC $D8,X                 
                    PHY                       
                    STY.W $1695               
                    JSR.W ADDR_02B7ED         
                    PLY                       
                    JSR.W ADDR_02B82E         
                    RTS                       ; Return 

ADDR_02B7ED:        LDY.B #$00                
                    CMP.B #$09                
                    BMI ADDR_02B803           
                    INY                       
                    CMP.B #$19                
                    BMI ADDR_02B803           
                    INY                       
                    CMP.B #$29                
                    BMI ADDR_02B803           
                    INY                       
                    CMP.B #$39                
                    BMI ADDR_02B803           
                    INY                       
ADDR_02B803:        LDA $C2,X                 
                    AND.W DATA_02B824,Y       
                    STA $C2,X                 
                    STA.W $151C,X             
                    LDA.W DATA_02B829,Y       
                    STA $0D                   
                    LDA.B #$0C                
                    STA.W $1540,X             
                    ASL                       
                    STA.W $1558,X             
                    RTS                       ; Return 

ADDR_02B81C:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02B7ED         
                    PLB                       
                    RTL                       ; Return 


DATA_02B824:        .db $EF,$F7,$FB,$FD,$FE

DATA_02B829:        .db $E0,$F0,$F8,$FC,$FE

ADDR_02B82E:        JSL.L ADDR_02A9E4         
                    BMI ADDR_02B881           
                    LDA.B #$02                
                    STA.W $14C8,Y             
                    LDA.B #$70                
                    STA.W $009E,Y             
                    LDA $E4,X                 
                    STA.W $00E4,Y             
                    LDA.W $14E0,X             
                    STA.W $14E0,Y             
                    PHX                       
                    TYX                       
                    JSL.L ADDR_07F7D2         
                    LDX.W $1695               
                    LDA $D8,X                 
                    STA.W $00D8,Y             
                    LDA.W $14D4,X             
                    STA.W $14D4,Y             
                    LDA $B6,X                 
                    STA $00                   
                    ASL                       
                    ROR $00                   
                    LDA $00                   
                    STA.W $00B6,Y             
                    LDA.B #$E0                
                    STA.W $00AA,Y             
                    PLX                       
                    LDA $C2,X                 
                    AND $0D                   
                    STA.W $00C2,Y             
                    LDA.B #$01                
                    STA.W $1534,Y             
                    LDA.B #$01                
                    JSL.L ADDR_02ACE1         
ADDR_02B881:        RTS                       ; Return 

ADDR_02B882:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02B88A         
                    PLB                       
                    RTL                       ; Return 

ADDR_02B88A:        LDA $64                   
                    PHA                       
                    LDA.W $1540,X             
                    BEQ ADDR_02B896           
                    LDA.B #$10                
                    STA $64                   
ADDR_02B896:        JSR.W ADDR_02B8F7         
                    PLA                       
                    STA $64                   
                    LDA $9D                   
                    BNE ADDR_02B8B7           
                    JSR.W ADDR_02D025         
                    JSL.L ADDR_01803A         
                    LDA.W $1540,X             
                    BEQ ADDR_02B8BC           
                    LDA.B #$08                
                    STA $AA,X                 
                    JSR.W ADDR_02D294         
                    LDA.B #$10                
                    STA $AA,X                 
ADDR_02B8B7:        RTS                       ; Return 


DATA_02B8B8:        .db $20,$F0

DATA_02B8BA:        .db $01,$FF

ADDR_02B8BC:        LDA $13                   
                    AND.B #$03                
                    BNE ADDR_02B8D2           
                    LDY.W $157C,X             
                    LDA $B6,X                 
                    CMP.W DATA_02B8B8,Y       
                    BEQ ADDR_02B8D2           
                    CLC                       
                    ADC.W DATA_02B8BA,Y       
                    STA $B6,X                 
ADDR_02B8D2:        JSR.W ADDR_02D288         
                    JSR.W ADDR_02D294         
                    LDA $AA,X                 
                    BEQ ADDR_02B8E4           
                    LDA $13                   
                    AND.B #$01                
                    BNE ADDR_02B8E4           
                    DEC $AA,X                 
ADDR_02B8E4:        TXA                       
                    CLC                       
                    ADC $14                   
                    AND.B #$07                
                    BNE ADDR_02B8EF           
                    JSR.W ADDR_02B952         
ADDR_02B8EF:        RTS                       ; Return 


DATA_02B8F0:        .db $10

DATA_02B8F1:        .db $00,$10,$80,$82

DATA_02B8F5:        .db $40,$00

ADDR_02B8F7:        JSR.W GetDrawInfo2        
                    LDA $01                   
                    STA.W $0301,Y             
                    STA.W $0305,Y             
                    PHX                       
                    LDA.W $15F6,X             
                    ORA $64                   
                    STA $02                   
                    LDA.W $157C,X             
                    TAX                       
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_02B8F0,X       
                    STA.W $0300,Y             
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_02B8F1,X       
                    STA.W $0304,Y             
                    LDA.W DATA_02B8F5,X       
                    ORA $02                   
                    STA.W $0303,Y             
                    STA.W $0307,Y             
                    PLX                       
                    LDA.B #$80                
                    STA.W $0302,Y             
                    LDA.W $1540,X             
                    CMP.B #$01                
                    LDA.B #$82                
                    BCS ADDR_02B944           
                    LDA $14                   
                    LSR                       
                    LSR                       
                    LDA.B #$A0                
                    BCC ADDR_02B944           
                    LDA.B #$82                
ADDR_02B944:        STA.W $0306,Y             
                    LDA.B #$01                
                    LDY.B #$02                
                    JMP.W ADDR_02B7A7         

DATA_02B94E:        .db $F4,$1C

DATA_02B950:        .db $FF,$00

ADDR_02B952:        LDY.B #$03                
ADDR_02B954:        LDA.W $17C0,Y             
                    BEQ ADDR_02B969           
                    DEY                       
                    BPL ADDR_02B954           
                    DEC.W $18E9               
                    BPL ADDR_02B966           
                    LDA.B #$03                
                    STA.W $18E9               
ADDR_02B966:        LDY.W $18E9               
ADDR_02B969:        LDA $E4,X                 
                    STA $00                   
                    LDA.W $14E0,X             
                    STA $01                   
                    PHX                       
                    LDA.W $157C,X             
                    TAX                       
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_02B94E,X       
                    STA $02                   
                    LDA $01                   
                    ADC.W DATA_02B950,X       
                    PHA                       
                    LDA $02                   
                    CMP $1A                   
                    PLA                       
                    PLX                       
                    SBC $1B                   
                    BNE ADDR_02B9A3           
                    LDA.B #$01                
                    STA.W $17C0,Y             
                    LDA $02                   
                    STA.W $17C8,Y             
                    LDA $D8,X                 
                    STA.W $17C4,Y             
                    LDA.B #$0F                
                    STA.W $17CC,Y             
ADDR_02B9A3:        RTS                       ; Return 

                    STA $9C                   
                    LDA $E4,X                 
                    STA $9A                   
                    LDA.W $14E0,X             
                    STA $9B                   
                    LDA $D8,X                 
                    STA $98                   
                    LDA.W $14D4,X             
                    STA $99                   
                    JSL.L ADDR_00BEB0         
                    RTL                       ; Return 

ADDR_02B9BD:        LDA.B #$02                
                    STA.W $18DD               
                    LDY.B #$09                
ADDR_02B9C4:        LDA.W $14C8,Y             
                    CMP.B #$08                
                    BCC ADDR_02B9D5           
                    LDA.W $190F,Y             
                    AND.B #$40                
                    BNE ADDR_02B9D5           
                    JSR.W ADDR_02B9D9         
ADDR_02B9D5:        DEY                       
                    BPL ADDR_02B9C4           
                    RTL                       ; Return 

ADDR_02B9D9:        LDA.B #$21                
                    STA.W $009E,Y             
                    LDA.B #$08                
                    STA.W $14C8,Y             
                    PHX                       
                    TYX                       
                    JSL.L ADDR_07F7D2         
                    LDA.W $15F6,X             
                    AND.B #$F1                
                    ORA.B #$02                
                    STA.W $15F6,X             
                    LDA.B #$D8                
                    STA.W $00AA,X             
                    PLX                       
                    RTS                       ; Return 

ADDR_02B9FA:        STZ $0F                   
                    BRA ADDR_02BA48           
                    LDA $01                   
                    AND.B #$F0                
                    STA $04                   
                    LDA $09                   
                    CMP $5D                   
                    BCS ADDR_02BA47           
                    STA $05                   
                    LDA $00                   
                    STA $07                   
                    LDA $08                   
                    CMP.B #$02                
                    BCS ADDR_02BA47           
                    STA $0A                   
                    LDA $07                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    ORA $04                   
                    STA $04                   
                    LDX $05                   
                    LDA.L DATA_00BA80,X       
                    LDY $0F                   
                    BEQ ADDR_02BA30           
                    LDA.L DATA_00BA8E,X       
ADDR_02BA30:        CLC                       
                    ADC $04                   
                    STA $05                   
                    LDA.L DATA_00BABC,X       
                    LDY $0F                   
                    BEQ ADDR_02BA41           
                    LDA.L DATA_00BACA,X       
ADDR_02BA41:        ADC $0A                   
                    STA $06                   
                    BRA ADDR_02BA92           
ADDR_02BA47:        RTL                       ; Return 

ADDR_02BA48:        LDA $01                   
                    AND.B #$F0                
                    STA $04                   
                    LDA $09                   
                    CMP.B #$02                
                    BCS ADDR_02BA47           
                    STA $0D                   
                    STA.W $18B3               
                    LDA $00                   
                    STA $06                   
                    LDA $08                   
                    CMP $5D                   
                    BCS ADDR_02BA47           
                    STA $07                   
                    LDA $06                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    ORA $04                   
                    STA $04                   
                    LDX $07                   
                    LDA.L DATA_00BA60,X       
                    LDY $0F                   
                    BEQ ADDR_02BA7D           
                    LDA.L DATA_00BA70,X       
ADDR_02BA7D:        CLC                       
                    ADC $04                   
                    STA $05                   
                    LDA.L DATA_00BA9C,X       
                    LDY $0F                   
                    BEQ ADDR_02BA8E           
                    LDA.L DATA_00BAAC,X       
ADDR_02BA8E:        ADC $0D                   
                    STA $06                   
ADDR_02BA92:        LDX.W $15E9               
                    LDA.B #$7E                
                    STA $07                   
                    LDA [$05]                 
                    STA.W $1693               
                    INC $07                   
                    LDA [$05]                 
                    BNE ADDR_02BABF           
                    LDA.W $1693               
                    CMP.B #$45                
                    BCC ADDR_02BABF           
                    CMP.B #$48                
                    BCS ADDR_02BABF           
                    SEC                       
                    SBC.B #$44                
                    STA.W $18D6               
                    LDY.B #$0B                
ADDR_02BAB7:        LDA.W $14C8,Y             
                    BEQ ADDR_02BAC0           
                    DEY                       
                    BPL ADDR_02BAB7           
ADDR_02BABF:        RTL                       ; Return 

ADDR_02BAC0:        LDA.B #$08                
                    STA.W $14C8,Y             
                    LDA.B #$74                
                    STA.W $009E,Y             
                    LDA $00                   
                    STA.W $00E4,Y             
                    STA $9A                   
                    LDA $08                   
                    STA.W $14E0,Y             
                    STA $9B                   
                    LDA $01                   
                    STA.W $00D8,Y             
                    STA $98                   
                    LDA $09                   
                    STA.W $14D4,Y             
                    STA $99                   
                    PHX                       
                    TYX                       
                    JSL.L ADDR_07F7D2         
                    INC.W $160E,X             
                    LDA.W $1662,X             
                    AND.B #$F0                
                    ORA.B #$0C                
                    STA.W $1662,X             
                    LDA.W $167A,X             
                    AND.B #$BF                
                    STA.W $167A,X             
                    PLX                       
                    LDA.B #$04                
                    STA $9C                   
                    JSL.L ADDR_00BEB0         
                    RTL                       ; Return 


DATA_02BB0B:        .db $02,$FA,$06,$06

DATA_02BB0F:        .db $00,$FF,$00,$00

DATA_02BB13:        .db $10,$08,$10,$08

YoshiWingsTiles:    .db $5D,$C6,$5D,$C6

YoshiWingsGfxProp:  .db $46,$46,$06,$06

YoshiWingsSize:     .db $00,$02,$00,$02

ADDR_02BB23:        STA $02                   
                    JSR.W ADDR_02D0C9         
                    BNE ADDR_02BB87           
                    LDA $E4,X                 
                    STA $00                   
                    LDA.W $14E0,X             
                    STA $04                   
                    LDA $D8,X                 
                    STA $01                   
                    LDY.B #$F8                
                    PHX                       
                    LDA.W $157C,X             
                    ASL                       
                    ADC $02                   
                    TAX                       
                    LDA $00                   
                    CLC                       
                    ADC.L DATA_02BB0B,X       
                    STA $00                   
                    LDA $04                   
                    ADC.L DATA_02BB0F,X       
                    PHA                       
                    LDA $00                   
                    SEC                       
                    SBC $1A                   
                    STA.W $0200,Y             
                    PLA                       
                    SBC $1B                   
                    BNE ADDR_02BB86           
                    LDA $01                   
                    SEC                       
                    SBC $1C                   
                    CLC                       
                    ADC.L DATA_02BB13,X       
                    STA.W $0201,Y             
                    LDA.L YoshiWingsTiles,X   
                    STA.W $0202,Y             
                    LDA $64                   
                    ORA.L YoshiWingsGfxProp,X 
                    STA.W $0203,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.L YoshiWingsSize,X    
                    STA.W $0420,Y             
ADDR_02BB86:        PLX                       
ADDR_02BB87:        RTL                       ; Return 


DATA_02BB88:        .db $FF,$01,$FF,$01,$00,$00

DATA_02BB8E:        .db $E8,$18,$F8,$08,$00,$00

ADDR_02BB94:        JSR.W ADDR_02BC14         
                    LDA $9D                   
                    BNE ADDR_02BBFF           
                    JSR.W ADDR_02D01F         
                    JSR.W ADDR_02D294         
                    JSR.W ADDR_02D288         
                    STA.W $1528,X             
                    LDA $14                   
                    AND.B #$00                
                    BNE ADDR_02BBB7           
                    LDA $AA,X                 
                    BMI ADDR_02BBB5           
                    CMP.B #$3F                
                    BCS ADDR_02BBB7           
ADDR_02BBB5:        INC $AA,X                 
ADDR_02BBB7:        TXA                       
                    EOR $13                   
                    LSR                       
                    BCC ADDR_02BBC1           
                    JSL.L ADDR_019138         
ADDR_02BBC1:        LDA $AA,X                 
                    BMI ADDR_02BBFB           
                    LDA.W $164A,X             
                    BEQ ADDR_02BBFB           
                    LDA $AA,X                 
                    BEQ ADDR_02BBD7           
                    SEC                       
                    SBC.B #$08                
                    STA $AA,X                 
                    BPL ADDR_02BBD7           
                    STZ $AA,X                 
ADDR_02BBD7:        LDA.W $151C,X             
                    BNE ADDR_02BBF7           
                    LDA $C2,X                 
                    LSR                       
                    PHP                       
                    LDA $9E,X                 
                    SEC                       
                    SBC.B #$41                
                    PLP                       
                    ROL                       
                    TAY                       
                    LDA $B6,X                 
                    CLC                       
                    ADC.W DATA_02BB88,Y       
                    STA $B6,X                 
                    CMP.W DATA_02BB8E,Y       
                    BNE ADDR_02BBFB           
                    INC $C2,X                 
ADDR_02BBF7:        LDA.B #$C0                
                    STA $AA,X                 
ADDR_02BBFB:        JSL.L InvisBlkMainRt      
ADDR_02BBFF:        RTL                       ; Return 

ADDR_02BC00:        LDA $14                   
                    AND.B #$04                
                    LSR                       
                    LSR                       
                    STA.W $157C,X             
                    JSL.L ADDR_019D5F         
                    RTS                       ; Return 


Dolphin1:           .db $E2,$88

Dolphin2:           .db $E7,$A8

Dolphin3:           .db $E8,$A9

ADDR_02BC14:        LDA $9E,X                 
                    CMP.B #$43                
                    BNE ADDR_02BC1D           
                    JMP.W ADDR_02BC00         
ADDR_02BC1D:        JSR.W GetDrawInfo2        
                    LDA $B6,X                 
                    STA $02                   
                    LDA $00                   
                    ASL $02                   
                    PHP                       
                    BCC ADDR_02BC3C           
                    STA.W $0300,Y             
                    CLC                       
                    ADC.B #$10                
                    STA.W $0304,Y             
                    CLC                       
                    ADC.B #$08                
                    STA.W $0308,Y             
                    BRA ADDR_02BC4E           
ADDR_02BC3C:        CLC                       
                    ADC.B #$18                
                    STA.W $0300,Y             
                    SEC                       
                    SBC.B #$10                
                    STA.W $0304,Y             
                    SEC                       
                    SBC.B #$08                
                    STA.W $0308,Y             
ADDR_02BC4E:        LDA $01                   
                    STA.W $0301,Y             
                    STA.W $0305,Y             
                    STA.W $0309,Y             
                    PHX                       
                    LDA $14                   
                    AND.B #$08                
                    LSR                       
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W Dolphin1,X          
                    STA.W $0302,Y             
                    LDA.W Dolphin2,X          
                    STA.W $0306,Y             
                    LDA.W Dolphin3,X          
                    STA.W $030A,Y             
                    PLX                       
                    LDA.W $15F6,X             
                    ORA $64                   
                    PLP                       
                    BCS ADDR_02BC7F           
                    ORA.B #$40                
ADDR_02BC7F:        STA.W $0303,Y             
                    STA.W $0307,Y             
                    STA.W $030B,Y             
                    LDA.B #$02                
                    LDY.B #$02                
                    JMP.W ADDR_02B7A7         

DATA_02BC8F:        .db $08,$00,$F8,$00,$F8,$00,$08,$00
DATA_02BC97:        .db $00,$08,$00,$F8,$00,$08,$00,$F8
DATA_02BC9F:        .db $01,$FF,$FF,$01,$FF,$01,$01,$FF
DATA_02BCA7:        .db $01,$01,$FF,$FF,$01,$01,$FF,$FF
DATA_02BCAF:        .db $01,$04,$02,$08,$02,$04,$01,$08
DATA_02BCB7:        .db $00,$02,$00,$02,$00,$02,$00,$02
                    .db $05,$04,$05,$04,$05,$04,$05,$04
DATA_02BCC7:        .db $00,$C0,$C0,$00,$40,$80,$80,$40
                    .db $80,$C0,$40,$00,$C0,$80,$00,$40
DATA_02BCD7:        .db $00,$01,$02,$01

ADDR_02BCDB:        JSL.L SprSprInteract      
                    JSL.L ADDR_01ACF9         
                    AND.B #$FF                
                    ORA $9D                   
                    BNE ADDR_02BCEE           
                    LDA.B #$0C                
                    STA.W $1558,X             
ADDR_02BCEE:        LDA $9E,X                 
                    CMP.B #$2E                
                    BNE ADDR_02BD23           
                    LDY $C2,X                 
                    LDA.W $1564,X             
                    BEQ ADDR_02BD04           
                    TYA                       
                    CLC                       
                    ADC.B #$08                
                    TAY                       
                    LDA.B #$00                
                    BRA ADDR_02BD0B           
ADDR_02BD04:        LDA $14                   
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.B #$01                
ADDR_02BD0B:        CLC                       
                    ADC.W DATA_02BCB7,Y       
                    STA.W $1602,X             
                    LDA.W $15F6,X             
                    AND.B #$3F                
                    ORA.W DATA_02BCC7,Y       
                    STA.W $15F6,X             
                    JSL.L GenericSprGfxRt     
                    BRA ADDR_02BD2F           
ADDR_02BD23:        CMP.B #$A5                
                    BCC ADDR_02BD2C           
                    JSR.W ADDR_02BE4E         
                    BRA ADDR_02BD2F           
ADDR_02BD2C:        JSR.W ADDR_02BF5C         
ADDR_02BD2F:        LDA.W $14C8,X             
                    CMP.B #$08                
                    BEQ ADDR_02BD3F           
                    STZ.W $1528,X             
                    LDA.B #$FF                
                    STA.W $1558,X             
                    RTL                       ; Return 

ADDR_02BD3F:        LDA $9D                   
                    BNE ADDR_02BD74           
                    JSR.W ADDR_02D017         
                    JSL.L MarioSprInteract    
                    LDA $9E,X                 
                    CMP.B #$2E                
                    BEQ ADDR_02BDA7           
                    CMP.B #$3C                
                    BEQ ADDR_02BDB3           
                    CMP.B #$A5                
                    BEQ ADDR_02BDB3           
                    CMP.B #$A6                
                    BEQ ADDR_02BDB3           
                    LDA $C2,X                 
                    AND.B #$01                
                    JSL.L ExecutePtr          

Ptrs02BD64:         .dw ADDR_02BD68           
                    .dw ADDR_02BD75           

ADDR_02BD68:        LDA.W $1540,X             
                    BNE ADDR_02BD74           
                    LDA.B #$80                
                    STA.W $1540,X             
                    INC $C2,X                 
ADDR_02BD74:        RTL                       ; Return 

ADDR_02BD75:        LDA $9E,X                 
                    CMP.B #$3B                
                    BEQ ADDR_02BD80           
                    LDA.W $1540,X             
                    BEQ ADDR_02BD91           
ADDR_02BD80:        JSR.W ADDR_02D288         
                    JSR.W ADDR_02D294         
                    JSL.L ADDR_019138         
                    LDA.W $1588,X             
                    AND.B #$0F                
                    BEQ ADDR_02BDA6           
ADDR_02BD91:        LDA $B6,X                 
                    EOR.B #$FF                
                    INC A                     
                    STA $B6,X                 
                    LDA $AA,X                 
                    EOR.B #$FF                
                    INC A                     
                    STA $AA,X                 
                    LDA.B #$40                
                    STA.W $1540,X             
                    INC $C2,X                 
ADDR_02BDA6:        RTL                       ; Return 

ADDR_02BDA7:        LDA $D8,X                 
                    SEC                       
                    SBC $1C                   
                    CMP.B #$E0                
                    BCC ADDR_02BDB3           
                    STZ.W $14C8,X             
ADDR_02BDB3:        LDA.W $1540,X             
                    BNE ADDR_02BDE7           
                    LDY $C2,X                 
                    LDA.W DATA_02BCA7,Y       
                    STA $AA,X                 
                    LDA.W DATA_02BC9F,Y       
                    STA $B6,X                 
                    JSL.L ADDR_019138         
                    LDA.W $1588,X             
                    AND.B #$0F                
                    BNE ADDR_02BDE7           
                    LDA.B #$08                
                    STA.W $1564,X             
                    LDA.B #$38                
                    LDY $9E,X                 
                    CPY.B #$3C                
                    BEQ ADDR_02BDE4           
                    LDA.B #$1A                
                    CPY.B #$A5                
                    BNE ADDR_02BDE4           
                    LSR                       
                    NOP                       
ADDR_02BDE4:        STA.W $1540,X             
ADDR_02BDE7:        LDA.B #$20                
                    LDY $9E,X                 
                    CPY.B #$3C                
                    BEQ ADDR_02BDF7           
                    LDA.B #$10                
                    CPY.B #$A5                
                    BNE ADDR_02BDF7           
                    LSR                       
                    NOP                       
ADDR_02BDF7:        CMP.W $1540,X             
                    BNE ADDR_02BE0E           
                    INC $C2,X                 
                    LDA $C2,X                 
                    CMP.B #$04                
                    BNE ADDR_02BE06           
                    STZ $C2,X                 
ADDR_02BE06:        CMP.B #$08                
                    BNE ADDR_02BE0E           
                    LDA.B #$04                
                    STA $C2,X                 
ADDR_02BE0E:        LDY $C2,X                 
                    LDA.W $1588,X             
                    AND.W DATA_02BCAF,Y       
                    BEQ ADDR_02BE2F           
                    LDA.B #$08                
                    STA.W $1564,X             
                    DEC $C2,X                 
                    LDA $C2,X                 
                    BPL ADDR_02BE27           
                    LDA.B #$03                
                    BRA ADDR_02BE2D           
ADDR_02BE27:        CMP.B #$03                
                    BNE ADDR_02BE2F           
                    LDA.B #$07                
ADDR_02BE2D:        STA $C2,X                 
ADDR_02BE2F:        LDY $C2,X                 
                    LDA.W DATA_02BC97,Y       
                    STA $AA,X                 
                    LDA.W DATA_02BC8F,Y       
                    STA $B6,X                 
                    LDA $9E,X                 
                    CMP.B #$A5                
                    BNE ADDR_02BE45           
                    ASL $B6,X                 
                    ASL $AA,X                 
ADDR_02BE45:        JSR.W ADDR_02D288         
                    JSR.W ADDR_02D294         
                    RTL                       ; Return 


DATA_02BE4C:        .db $05,$45

ADDR_02BE4E:        LDA $9E,X                 
                    CMP.B #$A5                
                    BNE ADDR_02BEB5           
                    JSL.L GenericSprGfxRt     
                    LDY.W $15EA,X             
                    LDA.W $192B               
                    CMP.B #$02                
                    BNE ADDR_02BE79           
                    PHX                       
                    LDA $14                   
                    LSR                       
                    LSR                       
                    AND.B #$01                
                    TAX                       
                    LDA.B #$C8                
                    STA.W $0302,Y             
                    LDA.W DATA_02BE4C,X       
                    ORA $64                   
                    STA.W $0303,Y             
                    PLX                       
                    RTS                       ; Return 

ADDR_02BE79:        LDA.B #$0A                
                    STA.W $0302,Y             
                    LDA $14                   
                    AND.B #$0C                
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    EOR.W $0303,Y             
                    STA.W $0303,Y             
                    RTS                       ; Return 


DATA_02BE8D:        .db $F8,$08,$F8,$08

DATA_02BE91:        .db $F8,$F8,$08,$08

HotheadTiles:       .db $0C,$0E,$0E,$0C,$0E,$0C,$0C,$0E
DATA_02BE9D:        .db $05,$05,$C5,$C5,$45,$45,$85,$85
DATA_02BEA5:        .db $07,$07,$01,$01,$01,$01,$07,$07
DATA_02BEAD:        .db $00,$08,$08,$00,$00,$08,$08,$00

ADDR_02BEB5:        JSR.W GetDrawInfo2        
                    TYA                       
                    CLC                       
                    ADC.B #$04                
                    STA.W $15EA,X             
                    TAY                       
                    LDA $14                   
                    AND.B #$04                
                    STA $03                   
                    PHX                       
                    LDX.B #$03                
ADDR_02BEC9:        LDA $00                   
                    CLC                       
                    ADC.W DATA_02BE8D,X       
                    STA.W $0300,Y             
                    LDA $01                   
                    CLC                       
                    ADC.W DATA_02BE91,X       
                    STA.W $0301,Y             
                    PHX                       
                    TXA                       
                    ORA $03                   
                    TAX                       
                    LDA.W HotheadTiles,X      
                    STA.W $0302,Y             
                    LDA.W DATA_02BE9D,X       
                    ORA $64                   
                    STA.W $0303,Y             
                    PLX                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_02BEC9           
                    PLX                       
                    LDA $00                   
                    PHA                       
                    LDA $01                   
                    PHA                       
                    LDY.B #$02                
                    LDA.B #$03                
                    JSR.W ADDR_02B7A7         
                    PLA                       
                    STA $01                   
                    PLA                       
                    STA $00                   
                    LDA.B #$09                
                    LDY.W $1558,X             
                    BEQ ADDR_02BF13           
                    LDA.B #$19                
ADDR_02BF13:        STA $02                   
                    LDA.W $15EA,X             
                    SEC                       
                    SBC.B #$04                
                    STA.W $15EA,X             
                    TAY                       
                    PHX                       
                    LDA $C2,X                 
                    TAX                       
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_02BEA5,X       
                    STA.W $0300,Y             
                    LDA $01                   
                    CLC                       
                    ADC.W DATA_02BEAD,X       
                    STA.W $0301,Y             
                    LDA $02                   
                    STA.W $0302,Y             
                    LDA.B #$05                
                    ORA $64                   
                    STA.W $0303,Y             
                    PLX                       
                    LDY.B #$00                
                    LDA.B #$00                
                    JMP.W ADDR_02B7A7         

DATA_02BF49:        .db $08,$00,$10,$00,$10

DATA_02BF4E:        .db $08,$00,$00,$10,$10

DATA_02BF53:        .db $37,$37,$77,$B7,$F7

UrchinTiles:        .db $C4,$C6,$C8,$C6

ADDR_02BF5C:        LDA.W $163E,X             
                    BNE ADDR_02BF69           
                    INC.W $1528,X             
                    LDA.B #$0C                
                    STA.W $163E,X             
ADDR_02BF69:        LDA.W $1528,X             
                    AND.B #$03                
                    TAY                       
                    LDA.W DATA_02BCD7,Y       
                    STA.W $1602,X             
                    JSR.W GetDrawInfo2        
                    STZ $05                   
                    LDA.W $1602,X             
                    STA $02                   
                    LDA.W $1558,X             
                    STA $03                   
ADDR_02BF84:        LDX $05                   
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_02BF49,X       
                    STA.W $0300,Y             
                    LDA $01                   
                    CLC                       
                    ADC.W DATA_02BF4E,X       
                    STA.W $0301,Y             
                    LDA.W DATA_02BF53,X       
                    STA.W $0303,Y             
                    CPX.B #$00                
                    BNE ADDR_02BFAC           
                    LDA.B #$CA                
                    LDX $03                   
                    BEQ ADDR_02BFAA           
                    LDA.B #$CC                
ADDR_02BFAA:        BRA ADDR_02BFB1           
ADDR_02BFAC:        LDX $02                   
                    LDA.W UrchinTiles,X       
ADDR_02BFB1:        STA.W $0302,Y             
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    INC $05                   
                    LDA $05                   
                    CMP.B #$05                
                    BNE ADDR_02BF84           
                    LDX.W $15E9               
                    LDY.B #$02                
                    JMP.W ADDR_02C82B         

DATA_02BFC8:        .db $10,$F0

DATA_02BFCA:        .db $01,$FF

ADDR_02BFCC:        RTL                       ; Return 

ADDR_02BFCD:        JSL.L GenericSprGfxRt     
                    LDA $9D                   
                    BNE ADDR_02BFCC           
                    JSR.W ADDR_02D025         
                    JSL.L ADDR_01803A         
                    LDA $B6,X                 
                    PHA                       
                    LDA $AA,X                 
                    PHA                       
                    LDY.W $1490               
                    BEQ ADDR_02BFF3           
                    EOR.B #$FF                
                    INC A                     
                    STA $AA,X                 
                    LDA $B6,X                 
                    EOR.B #$FF                
                    INC A                     
                    STA $B6,X                 
ADDR_02BFF3:        JSR.W ADDR_02C126         
                    JSR.W ADDR_02D288         
                    JSR.W ADDR_02D294         
                    JSL.L ADDR_019138         
                    PLA                       
                    STA $AA,X                 
                    PLA                       
                    STA $B6,X                 
                    INC.W $1570,X             
                    LDA.W $1588,X             
                    AND.B #$03                
                    BEQ ADDR_02C012           
                    STZ $B6,X                 
ADDR_02C012:        LDA.W $1588,X             
                    AND.B #$0C                
                    BEQ ADDR_02C01B           
                    STZ $AA,X                 
ADDR_02C01B:        LDA.W $164A,X             
                    BNE ADDR_02C024           
                    LDA.B #$10                
                    STA $AA,X                 
ADDR_02C024:        LDA $C2,X                 
                    JSL.L ExecutePtr          

Ptrs02C02A:         .dw ADDR_02C02E           
                    .dw ADDR_02C08A           

ADDR_02C02E:        LDA.B #$02                
                    STA $AA,X                 
                    LDA $13                   
                    AND.B #$03                
                    BNE ADDR_02C044           
                    LDA $B6,X                 
                    BEQ ADDR_02C044           
                    BPL ADDR_02C042           
                    INC $B6,X                 
                    BRA ADDR_02C044           
ADDR_02C042:        DEC $B6,X                 
ADDR_02C044:        LDA.W $1588,X             
                    AND.B #$04                
                    BEQ ADDR_02C053           
                    STZ $AA,X                 
                    LDA $D8,X                 
                    AND.B #$F0                
                    STA $D8,X                 
ADDR_02C053:        JSL.L ADDR_02C0D9         
                    LDA.W $18FD               
                    BNE ADDR_02C072           
                    JSR.W ADDR_02D4FA         
                    LDA $0F                   
                    ADC.B #$30                
                    CMP.B #$60                
                    BCS ADDR_02C07B           
                    JSR.W ADDR_02D50C         
                    LDA $0E                   
                    ADC.B #$30                
                    CMP.B #$60                
                    BCS ADDR_02C07B           
ADDR_02C072:        INC $C2,X                 
                    LDA.B #$FF                
                    STA.W $151C,X             
                    BRA ADDR_02C08A           
ADDR_02C07B:        LDY.B #$02                
                    LDA.W $1570,X             
                    AND.B #$30                
                    BNE ADDR_02C085           
                    INY                       
ADDR_02C085:        TYA                       
                    STA.W $1602,X             
                    RTL                       ; Return 

ADDR_02C08A:        LDA $13                   
                    AND.B #$01                
                    BNE ADDR_02C095           
                    DEC.W $151C,X             
                    BEQ ADDR_02C0CA           
ADDR_02C095:        LDA $13                   
                    AND.B #$07                
                    BNE ADDR_02C0BB           
                    JSR.W ADDR_02D4FA         
                    LDA $B6,X                 
                    CMP.W DATA_02BFC8,Y       
                    BEQ ADDR_02C0AB           
                    CLC                       
                    ADC.W DATA_02BFCA,Y       
                    STA $B6,X                 
ADDR_02C0AB:        JSR.W ADDR_02D50C         
                    LDA $AA,X                 
                    CMP.W DATA_02BFC8,Y       
                    BEQ ADDR_02C0BB           
                    CLC                       
                    ADC.W DATA_02BFCA,Y       
                    STA $AA,X                 
ADDR_02C0BB:        LDY.B #$00                
                    LDA.W $1570,X             
                    AND.B #$04                
                    BEQ ADDR_02C0C5           
                    INY                       
ADDR_02C0C5:        TYA                       
                    STA.W $1602,X             
                    RTL                       ; Return 

ADDR_02C0CA:        STZ $C2,X                 
                    JMP.W ADDR_02C02E         
ADDR_02C0CF:        LDA.B #$08                
                    LDY.W $157C,X             
                    BEQ ADDR_02C0D7           
                    INC A                     
ADDR_02C0D7:        BRA ADDR_02C0DB           
ADDR_02C0D9:        LDA.B #$06                
ADDR_02C0DB:        TAY                       
                    LDA.W $15A0,X             
                    ORA.W $186C,X             
                    BNE ADDR_02C125           
                    TYA                       
                    DEC.W $1528,X             
                    BPL ADDR_02C125           
                    PHA                       
                    LDA.B #$28                
                    STA.W $1528,X             
                    LDY.B #$0B                
ADDR_02C0F2:        LDA.W $17F0,Y             
                    BEQ ADDR_02C107           
                    DEY                       
                    BPL ADDR_02C0F2           
                    DEC.W $185D               
                    BPL ADDR_02C104           
                    LDA.B #$0B                
                    STA.W $185D               
ADDR_02C104:        LDY.W $185D               
ADDR_02C107:        PLA                       
                    STA.W $17F0,Y             
                    LDA $E4,X                 
                    CLC                       
                    ADC.B #$06                
                    STA.W $1808,Y             
                    LDA $D8,X                 
                    CLC                       
                    ADC.B #$00                
                    STA.W $17FC,Y             
                    LDA.B #$7F                
                    STA.W $1850,Y             
                    LDA.B #$FA                
                    STA.W $182C,Y             
ADDR_02C125:        RTL                       ; Return 

ADDR_02C126:        LDY.B #$00                
                    LDA $B6,X                 
                    BPL ADDR_02C12D           
                    INY                       
ADDR_02C12D:        TYA                       
                    STA.W $157C,X             
                    RTS                       ; Return 


DATA_02C132:        .db $30,$20,$0A,$30

DATA_02C136:        .db $05,$0E,$0F,$10

ADDR_02C13A:        LDA.W $1558,X             
                    BEQ ADDR_02C156           
                    CMP.B #$01                
                    BNE ADDR_02C150           
                    LDA.B #$30                
                    STA.W $1540,X             
                    LDA.B #$04                
                    STA.W $1534,X             
                    STZ.W $1570,X             
ADDR_02C150:        LDA.B #$02                
                    STA.W $151C,X             
                    RTS                       ; Return 

ADDR_02C156:        LDA.W $1540,X             
                    BNE ADDR_02C181           
                    INC.W $1534,X             
                    LDA.W $1534,X             
                    AND.B #$03                
                    STA.W $1570,X             
                    TAY                       
                    LDA.W DATA_02C132,Y       
                    STA.W $1540,X             
                    CPY.B #$01                
                    BNE ADDR_02C181           
                    LDA.W $1534,X             
                    AND.B #$0C                
                    BNE ADDR_02C17E           
                    LDA.B #$40                
                    STA.W $1558,X             
                    RTS                       ; Return 

ADDR_02C17E:        JSR.W ADDR_02C19A         
ADDR_02C181:        LDY.W $1570,X             
                    LDA.W DATA_02C136,Y       
                    STA.W $1602,X             
                    LDY.W $157C,X             
                    LDA.W DATA_02C1F3,Y       
                    STA.W $151C,X             
                    RTS                       ; Return 


DATA_02C194:        .db $14,$EC

DATA_02C196:        .db $00,$FF

DATA_02C198:        .db $08,$F8

ADDR_02C19A:        JSL.L ADDR_02A9E4         
                    BMI ADDR_02C1F2           
                    LDA.B #$08                
                    STA.W $14C8,Y             
                    LDA.B #$48                
                    STA.W $009E,Y             
                    LDA.W $157C,X             
                    STA $02                   
                    LDA $E4,X                 
                    STA $00                   
                    LDA.W $14E0,X             
                    STA $01                   
                    PHX                       
                    TYX                       
                    JSL.L ADDR_07F7D2         
                    LDX $02                   
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_02C194,X       
                    STA.W $00E4,Y             
                    LDA $01                   
                    ADC.W DATA_02C196,X       
                    STA.W $14E0,Y             
                    LDA.W DATA_02C198,X       
                    STA.W $00B6,Y             
                    PLX                       
                    LDA $D8,X                 
                    CLC                       
                    ADC.B #$0A                
                    STA.W $00D8,Y             
                    LDA.W $14D4,X             
                    ADC.B #$00                
                    STA.W $14D4,Y             
                    LDA.B #$C0                
                    STA.W $00AA,Y             
                    LDA.B #$2C                
                    STA.W $1540,Y             
ADDR_02C1F2:        RTS                       ; Return 


DATA_02C1F3:        .db $01,$03

ADDR_02C1F5:        PHB                       
                    PHK                       
                    PLB                       
                    LDA.W $187B,X             
                    PHA                       
                    JSR.W ADDR_02C22C         
                    PLA                       
                    BNE ADDR_02C211           
                    CMP.W $187B,X             
                    BEQ ADDR_02C211           
                    LDA.W $163E,X             
                    BNE ADDR_02C211           
                    LDA.B #$28                
                    STA.W $163E,X             
ADDR_02C211:        PLB                       
                    RTL                       ; Return 


DATA_02C213:        .db $01,$02,$03,$02

ADDR_02C217:        LDA $14                   
                    LSR                       
                    LSR                       
                    AND.B #$03                
                    TAY                       
                    LDA.W DATA_02C213,Y       
                    STA.W $151C,X             
                    JSR.W ADDR_02C81A         
                    RTS                       ; Return 


DATA_02C228:        .db $40,$10

DATA_02C22A:        .db $03,$01

ADDR_02C22C:        LDA.W $14C8,X             
                    CMP.B #$08                
                    BNE ADDR_02C217           
                    LDA.W $15AC,X             
                    BEQ ADDR_02C23D           
                    LDA.B #$05                
                    STA.W $1602,X             
ADDR_02C23D:        LDA.W $1588,X             
                    AND.B #$04                
                    BNE ADDR_02C253           
                    LDA $AA,X                 
                    BPL ADDR_02C253           
                    LDA $C2,X                 
                    CMP.B #$05                
                    BCS ADDR_02C253           
                    LDA.B #$06                
                    STA.W $1602,X             
ADDR_02C253:        JSR.W ADDR_02C81A         
                    LDA $9D                   
                    BEQ ADDR_02C25B           
                    RTS                       ; Return 

ADDR_02C25B:        JSR.W ADDR_02D025         
                    JSR.W ADDR_02C79D         
                    JSL.L SprSprInteract      
                    JSL.L ADDR_019138         
                    LDA.W $1588,X             
                    AND.B #$08                
                    BEQ ADDR_02C274           
                    LDA.B #$10                
                    STA $AA,X                 
ADDR_02C274:        LDA.W $1588,X             
                    AND.B #$03                
                    BEQ ADDR_02C2F4           
                    LDA.W $15A0,X             
                    ORA.W $186C,X             
                    BNE ADDR_02C2E4           
                    LDA.W $187B,X             
                    BEQ ADDR_02C2E4           
                    LDA $E4,X                 
                    SEC                       
                    SBC $1A                   
                    CLC                       
                    ADC.B #$14                
                    CMP.B #$1C                
                    BCC ADDR_02C2E4           
                    LDA.W $1588,X             
                    AND.B #$40                
                    BNE ADDR_02C2E4           
                    LDA.W $18A7               
                    CMP.B #$2E                
                    BEQ ADDR_02C2A6           
                    CMP.B #$1E                
                    BNE ADDR_02C2E4           
ADDR_02C2A6:        LDA.W $1588,X             
                    AND.B #$04                
                    BEQ ADDR_02C2F7           
                    LDA $9B                   
                    PHA                       
                    LDA $9A                   
                    PHA                       
                    LDA $99                   
                    PHA                       
                    LDA $98                   
                    PHA                       
                    JSL.L ShatterBlock        
                    LDA.B #$02                
                    STA $9C                   
                    JSL.L ADDR_00BEB0         
                    PLA                       
                    SEC                       
                    SBC.B #$10                
                    STA $98                   
                    PLA                       
                    SBC.B #$00                
                    STA $99                   
                    PLA                       
                    STA $9A                   
                    PLA                       
                    STA $9B                   
                    JSL.L ShatterBlock        
                    LDA.B #$02                
                    STA $9C                   
                    JSL.L ADDR_00BEB0         
                    BRA ADDR_02C2F4           
ADDR_02C2E4:        LDA.W $1588,X             
                    AND.B #$04                
                    BEQ ADDR_02C2F7           
                    LDA.B #$C0                
                    STA $AA,X                 
                    JSR.W ADDR_02D294         
                    BRA ADDR_02C301           
ADDR_02C2F4:        JSR.W ADDR_02D288         
ADDR_02C2F7:        LDA.W $1588,X             
                    AND.B #$04                
                    BEQ ADDR_02C301           
                    JSR.W ADDR_02C579         
ADDR_02C301:        JSR.W ADDR_02D294         
                    LDY.W $164A,X             
                    CPY.B #$01                
                    LDY.B #$00                
                    LDA $AA,X                 
                    BCC ADDR_02C31A           
                    INY                       
                    CMP.B #$00                
                    BPL ADDR_02C31A           
                    CMP.B #$E0                
                    BCS ADDR_02C31A           
                    LDA.B #$E0                
ADDR_02C31A:        CLC                       
                    ADC.W DATA_02C22A,Y       
                    BMI ADDR_02C328           
                    CMP.W DATA_02C228,Y       
                    BCC ADDR_02C328           
                    LDA.W DATA_02C228,Y       
ADDR_02C328:        TAY                       
                    BMI ADDR_02C334           
                    LDY $C2,X                 
                    CPY.B #$07                
                    BNE ADDR_02C334           
                    CLC                       
                    ADC.B #$03                
ADDR_02C334:        STA $AA,X                 
                    LDA $C2,X                 
                    JSL.L ExecutePtr          

Ptrs02C33C:         .dw ADDR_02C63B           
                    .dw ADDR_02C6A7           
                    .dw ADDR_02C726           
                    .dw ADDR_02C74A           
                    .dw ADDR_02C13A           
                    .dw ADDR_02C582           
                    .dw ADDR_02C53C           
                    .dw ADDR_02C564           
                    .dw ADDR_02C4E3           
                    .dw ADDR_02C4BD           
                    .dw ADDR_02C3CB           
                    .dw ADDR_02C356           
                    .dw ADDR_02C37B           

ADDR_02C356:        LDA.B #$03                
                    STA.W $1602,X             
                    LDA.W $164A,X             
                    BEQ ADDR_02C370           
                    JSR.W ADDR_02D4FA         
                    LDA $0F                   
                    CLC                       
                    ADC.B #$30                
                    CMP.B #$60                
                    BCS ADDR_02C370           
                    LDA.B #$0C                
                    STA $C2,X                 
ADDR_02C370:        JMP.W ADDR_02C556         

DATA_02C373:        .db $05,$05,$05,$02,$02,$06,$06,$06

ADDR_02C37B:        LDA $14                   
                    AND.B #$3F                
                    BNE ADDR_02C386           
                    LDA.B #$1E                
                    STA.W $1DFC               ; / Play sound effect 
ADDR_02C386:        LDY.B #$03                
                    LDA $14                   
                    AND.B #$30                
                    BEQ ADDR_02C390           
                    LDY.B #$06                
ADDR_02C390:        TYA                       
                    STA.W $1602,X             
                    LDA $14                   
                    LSR                       
                    LSR                       
                    AND.B #$07                
                    TAY                       
                    LDA.W DATA_02C373,Y       
                    STA.W $151C,X             
                    LDA $E4,X                 
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LDA.B #$09                
                    BCC ADDR_02C3AF           
                    STA.W $18B9               
ADDR_02C3AF:        STA.W $18FD               
                    RTS                       ; Return 


DATA_02C3B3:        .db $7F,$BF,$FF,$DF

DATA_02C3B7:        .db $18,$19,$14,$14

DATA_02C3BB:        .db $18,$18,$18,$18,$17,$17,$17,$17
                    .db $17,$17,$16,$15,$15,$16,$16,$16

ADDR_02C3CB:        LDA.W $1534,X             
                    BNE ADDR_02C43A           
                    JSR.W ADDR_02D50C         
                    LDA $0E                   
                    BPL ADDR_02C3E7           
                    CMP.B #$D0                
                    BCS ADDR_02C3E7           
                    LDA.B #$C8                
                    STA $AA,X                 
                    LDA.B #$3E                
                    STA.W $1540,X             
                    INC.W $1534,X             
ADDR_02C3E7:        LDA $13                   
                    AND.B #$07                
                    BNE ADDR_02C3F5           
                    LDA.W $1540,X             
                    BEQ ADDR_02C3F5           
                    INC.W $1540,X             
ADDR_02C3F5:        LDA $14                   
                    AND.B #$3F                
                    BNE ADDR_02C3FE           
                    JSR.W ADDR_02C556         
ADDR_02C3FE:        LDA.W $1540,X             
                    BNE ADDR_02C40C           
                    LDY.W $187B,X             
                    LDA.W DATA_02C3B3,Y       
                    STA.W $1540,X             
ADDR_02C40C:        LDA.W $1540,X             
                    CMP.B #$40                
                    BCS ADDR_02C419           
                    LDA.B #$00                
                    STA.W $1602,X             
                    RTS                       ; Return 

ADDR_02C419:        SEC                       
                    SBC.B #$40                
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.B #$03                
                    TAY                       
                    LDA.W DATA_02C3B7,Y       
                    STA.W $1602,X             
                    LDA.W $1540,X             
                    AND.B #$1F                
                    CMP.B #$06                
                    BNE ADDR_02C439           
                    JSR.W ADDR_02C466         
                    LDA.B #$08                
                    STA.W $1558,X             
ADDR_02C439:        RTS                       ; Return 

ADDR_02C43A:        LDA.W $1540,X             
                    BEQ ADDR_02C45C           
                    PHA                       
                    CMP.B #$20                
                    BCC ADDR_02C44A           
                    CMP.B #$30                
                    BCS ADDR_02C44A           
                    STZ $AA,X                 
ADDR_02C44A:        LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_02C3BB,Y       
                    STA.W $1602,X             
                    PLA                       
                    CMP.B #$26                
                    BNE ADDR_02C45B           
                    JSR.W ADDR_02C466         
ADDR_02C45B:        RTS                       ; Return 

ADDR_02C45C:        STZ.W $1534,X             
                    RTS                       ; Return 


BaseballTileDispX:  .db $10,$F8

DATA_02C462:        .db $00,$FF

BaseballSpeed:      .db $18,$E8

ADDR_02C466:        LDA.W $1558,X             
                    ORA.W $186C,X             
                    BNE ADDR_02C439           
                    LDY.B #$07                
ADDR_02C470:        LDA.W $170B,Y             
                    BEQ ADDR_02C479           
                    DEY                       
                    BPL ADDR_02C470           
                    RTS                       ; Return 

ADDR_02C479:        LDA.B #$0D                
                    STA.W $170B,Y             
                    LDA $E4,X                 
                    STA $00                   
                    LDA.W $14E0,X             
                    STA $01                   
                    LDA $D8,X                 
                    CLC                       
                    ADC.B #$00                
                    STA.W $1715,Y             
                    LDA.W $14D4,X             
                    ADC.B #$00                
                    STA.W $1729,Y             
                    PHX                       
                    LDA.W $157C,X             
                    TAX                       
                    LDA $00                   
                    CLC                       
                    ADC.W BaseballTileDispX,X 
                    STA.W $171F,Y             
                    LDA $01                   
                    ADC.W DATA_02C462,X       
                    STA.W $1733,Y             
                    LDA.W BaseballSpeed,X     
                    STA.W $1747,Y             
                    PLX                       
                    RTS                       ; Return 


DATA_02C4B5:        .db $00,$00,$11,$11,$11,$11,$00,$00

ADDR_02C4BD:        STZ.W $1602,X             
                    TXA                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ADC $13                   
                    AND.B #$7F                
                    CMP.B #$00                
                    BNE ADDR_02C4D5           
                    PHA                       
                    JSR.W ADDR_02C556         
                    JSL.L ADDR_03CBB3         
                    PLA                       
ADDR_02C4D5:        CMP.B #$20                
                    BCS ADDR_02C4E2           
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_02C4B5,Y       
                    STA.W $1602,X             
ADDR_02C4E2:        RTS                       ; Return 

ADDR_02C4E3:        JSR.W ADDR_02C556         
                    LDA.B #$06                
                    LDY $AA,X                 
                    CPY.B #$F0                
                    BMI ADDR_02C504           
                    LDY.W $160E,X             
                    BEQ ADDR_02C504           
                    LDA.W $1FE2,X             
                    BNE ADDR_02C502           
                    LDA.B #$19                
                    STA.W $1DFC               ; / Play sound effect 
                    LDA.B #$20                
                    STA.W $1FE2,X             
ADDR_02C502:        LDA.B #$07                
ADDR_02C504:        STA.W $1602,X             
                    LDA.W $1588,X             
                    AND.B #$04                
                    BEQ ADDR_02C53B           
                    STZ.W $160E,X             
                    LDA.B #$04                
                    STA.W $1602,X             
                    LDA.W $1540,X             
                    BNE ADDR_02C53B           
                    LDA.B #$20                
                    STA.W $1540,X             
                    LDA.B #$F0                
                    STA $AA,X                 
                    JSR.W ADDR_02D50C         
                    LDA $0E                   
                    BPL ADDR_02C53B           
                    CMP.B #$D0                
                    BCS ADDR_02C53B           
                    LDA.B #$C0                
                    STA $AA,X                 
                    INC.W $160E,X             
ADDR_02C536:        LDA.B #$08                
                    STA.W $1DFC               ; / Play sound effect 
ADDR_02C53B:        RTS                       ; Return 

ADDR_02C53C:        LDA.B #$06                
                    STA.W $1602,X             
                    LDA.W $1588,X             
                    AND.B #$04                
                    BEQ ADDR_02C555           
                    JSR.W ADDR_02C579         
                    JSR.W ADDR_02C556         
                    LDA.B #$08                
                    STA.W $1540,X             
                    INC $C2,X                 
ADDR_02C555:        RTS                       ; Return 

ADDR_02C556:        JSR.W ADDR_02D4FA         
                    TYA                       
                    STA.W $157C,X             
                    LDA.W DATA_02C639,Y       
                    STA.W $151C,X             
                    RTS                       ; Return 

ADDR_02C564:        LDA.B #$03                
                    STA.W $1602,X             
                    LDA.W $1540,X             
                    BNE ADDR_02C579           
                    LDA.W $1588,X             
                    AND.B #$04                
                    BEQ ADDR_02C57D           
                    LDA.B #$05                
                    STA $C2,X                 
ADDR_02C579:        STZ $B6,X                 
                    STZ $AA,X                 
ADDR_02C57D:        RTS                       ; Return 


DATA_02C57E:        .db $10,$F0

DATA_02C580:        .db $20,$E0

ADDR_02C582:        JSR.W ADDR_02C556         
                    LDA.W $1540,X             
                    BEQ ADDR_02C602           
                    CMP.B #$01                
                    BNE ADDR_02C5FC           
                    LDA $9E,X                 
                    CMP.B #$93                
                    BNE ADDR_02C5A7           
                    JSR.W ADDR_02D4FA         
                    LDA.W DATA_02C580,Y       
                    STA $B6,X                 
                    LDA.B #$B0                
                    STA $AA,X                 
                    LDA.B #$06                
                    STA $C2,X                 
                    JMP.W ADDR_02C536         
ADDR_02C5A7:        STZ $C2,X                 
                    LDA.B #$50                
                    STA.W $1540,X             
                    LDA.B #$10                
                    STA.W $1DF9               ; / Play sound effect 
                    STZ.W $185E               
                    JSR.W ADDR_02C5BC         
                    INC.W $185E               
ADDR_02C5BC:        JSL.L ADDR_02A9E4         
                    BMI ADDR_02C5FC           
                    LDA.B #$08                
                    STA.W $14C8,Y             
                    LDA.B #$91                
                    STA.W $009E,Y             
                    LDA $E4,X                 
                    STA.W $00E4,Y             
                    LDA.W $14E0,X             
                    STA.W $14E0,Y             
                    LDA $D8,X                 
                    STA.W $00D8,Y             
                    LDA.W $14D4,X             
                    STA.W $14D4,Y             
                    PHX                       
                    TYX                       
                    JSL.L ADDR_07F7D2         
                    LDX.W $185E               
                    LDA.W DATA_02C57E,X       
                    STA.W $00B6,Y             
                    PLX                       
                    LDA.B #$C8                
                    STA.W $00AA,Y             
                    LDA.B #$50                
                    STA.W $1540,Y             
ADDR_02C5FC:        LDA.B #$09                
                    STA.W $1602,X             
                    RTS                       ; Return 

ADDR_02C602:        JSR.W ADDR_02D4FA         
                    TYA                       
                    STA.W $157C,X             
                    LDA $0F                   
                    CLC                       
                    ADC.B #$50                
                    CMP.B #$A0                
                    BCS ADDR_02C618           
                    LDA.B #$40                
                    STA.W $1540,X             
                    RTS                       ; Return 

ADDR_02C618:        LDA.B #$03                
                    STA.W $1602,X             
                    LDA $13                   
                    AND.B #$3F                
                    BNE ADDR_02C627           
                    LDA.B #$E0                
                    STA $AA,X                 
ADDR_02C627:        RTS                       ; Return 

ADDR_02C628:        LDA.B #$08                
                    STA.W $15AC,X             
                    RTS                       ; Return 


DATA_02C62E:        .db $00,$00,$00,$00,$01,$02,$03,$04
                    .db $04,$04,$04

DATA_02C639:        .db $00,$04

ADDR_02C63B:        LDA.B #$03                
                    STA.W $1602,X             
                    STZ.W $187B,X             
                    LDA.W $1540,X             
                    AND.B #$0F                
                    BNE ADDR_02C668           
                    JSR.W ADDR_02D50C         
                    LDA $0E                   
                    CLC                       
                    ADC.B #$28                
                    CMP.B #$50                
                    BCS ADDR_02C668           
                    JSR.W ADDR_02C556         
                    INC.W $187B,X             
ADDR_02C65C:        LDA.B #$02                
                    STA $C2,X                 
                    LDA.B #$18                
                    STA.W $1540,X             
                    RTS                       ; Return 


DATA_02C666:        .db $01,$FF

ADDR_02C668:        LDA.W $1540,X             
                    BNE ADDR_02C677           
                    LDA.W $157C,X             
                    EOR.B #$01                
                    STA.W $157C,X             
                    BRA ADDR_02C65C           
ADDR_02C677:        LDA $14                   
                    AND.B #$03                
                    BNE ADDR_02C691           
                    LDA.W $1534,X             
                    AND.B #$01                
                    TAY                       
                    LDA.W $1594,X             
                    CLC                       
                    ADC.W DATA_02C666,Y       
                    CMP.B #$0B                
                    BCS ADDR_02C69B           
                    STA.W $1594,X             
ADDR_02C691:        LDY.W $1594,X             
                    LDA.W DATA_02C62E,Y       
                    STA.W $151C,X             
                    RTS                       ; Return 

ADDR_02C69B:        INC.W $1534,X             
                    RTS                       ; Return 


DATA_02C69F:        .db $10,$F0,$18,$E8

DATA_02C6A3:        .db $12,$13,$12,$13

ADDR_02C6A7:        LDA.W $1588,X             
                    AND.B #$04                
                    BEQ ADDR_02C6BA           
                    LDA.W $163E,X             
                    CMP.B #$01                
                    BRA ADDR_02C6BA           
                    LDA.B #$24                
                    STA.W $1DF9               ; / Play sound effect 
ADDR_02C6BA:        JSR.W ADDR_02D50C         
                    LDA $0E                   
                    CLC                       
                    ADC.B #$30                
                    CMP.B #$60                
                    BCS ADDR_02C6D7           
                    JSR.W ADDR_02D4FA         
                    TYA                       
                    CMP.W $157C,X             
                    BNE ADDR_02C6D7           
                    LDA.B #$20                
                    STA.W $1540,X             
                    STA.W $187B,X             
ADDR_02C6D7:        LDA.W $1540,X             
                    BNE ADDR_02C6EC           
                    STZ $C2,X                 
                    JSR.W ADDR_02C628         
                    JSL.L ADDR_01ACF9         
                    AND.B #$3F                
                    ORA.B #$40                
                    STA.W $1540,X             
ADDR_02C6EC:        LDY.W $157C,X             
                    LDA.W DATA_02C639,Y       
                    STA.W $151C,X             
                    LDA.W $1588,X             
                    AND.B #$04                
                    BEQ ADDR_02C713           
                    LDA.W $187B,X             
                    BEQ ADDR_02C70E           
                    LDA $14                   
                    AND.B #$07                
                    BNE ADDR_02C70C           
                    LDA.B #$01                
                    STA.W $1DF9               ; / Play sound effect 
ADDR_02C70C:        INY                       
                    INY                       
ADDR_02C70E:        LDA.W DATA_02C69F,Y       
                    STA $B6,X                 
ADDR_02C713:        LDA $13                   
                    LDY.W $187B,X             
                    BNE ADDR_02C71B           
                    LSR                       
ADDR_02C71B:        LSR                       
                    AND.B #$03                
                    TAY                       
                    LDA.W DATA_02C6A3,Y       
                    STA.W $1602,X             
                    RTS                       ; Return 

ADDR_02C726:        LDA.B #$03                
                    STA.W $1602,X             
                    LDA.W $1540,X             
                    BNE ADDR_02C73C           
                    JSR.W ADDR_02C628         
                    LDA.B #$01                
                    STA $C2,X                 
                    LDA.B #$40                
                    STA.W $1540,X             
ADDR_02C73C:        RTS                       ; Return 


DATA_02C73D:        .db $0A,$0B,$0A,$0C,$0D,$0C

DATA_02C743:        .db $0C,$10,$10,$04,$08,$10,$18

ADDR_02C74A:        LDY.W $1570,X             
                    LDA.W $1540,X             
                    BNE ADDR_02C760           
                    INC.W $1570,X             
                    INY                       
                    CPY.B #$07                
                    BEQ ADDR_02C777           
                    LDA.W DATA_02C743,Y       
                    STA.W $1540,X             
ADDR_02C760:        LDA.W DATA_02C73D,Y       
                    STA.W $1602,X             
                    LDA.B #$02                
                    CPY.B #$05                
                    BNE ADDR_02C773           
                    LDA $14                   
                    LSR                       
                    NOP                       
                    AND.B #$02                
                    INC A                     
ADDR_02C773:        STA.W $151C,X             
                    RTS                       ; Return 

ADDR_02C777:        LDA $9E,X                 
                    CMP.B #$94                
                    BEQ ADDR_02C794           
                    CMP.B #$46                
                    BNE ADDR_02C785           
                    LDA.B #$91                
                    STA $9E,X                 
ADDR_02C785:        LDA.B #$30                
                    STA.W $1540,X             
                    LDA.B #$02                
                    STA $C2,X                 
                    INC.W $187B,X             
                    JMP.W ADDR_02C556         
ADDR_02C794:        LDA.B #$0C                
                    STA $C2,X                 
                    RTS                       ; Return 


DATA_02C799:        .db $F0,$10

DATA_02C79B:        .db $20,$E0

ADDR_02C79D:        LDA.W $1564,X             
                    BNE ADDR_02C80F           
                    JSL.L MarioSprInteract    
                    BCC ADDR_02C80F           
                    LDA.W $1490               
                    BEQ ADDR_02C7C4           
                    LDA.B #$D0                
                    STA $AA,X                 
ADDR_02C7B1:        STZ $B6,X                 
                    LDA.B #$02                
                    STA.W $14C8,X             
                    LDA.B #$03                
                    STA.W $1DF9               ; / Play sound effect 
                    LDA.B #$03                
                    JSL.L GivePoints          
                    RTS                       ; Return 

ADDR_02C7C4:        JSR.W ADDR_02D50C         
                    LDA $0E                   
                    CMP.B #$EC                
                    BPL ADDR_02C810           
                    LDA.B #$05                
                    STA.W $1564,X             
                    LDA.B #$02                
                    STA.W $1DF9               ; / Play sound effect 
                    JSL.L DisplayContactGfx   
                    JSL.L BoostMarioSpeed     
                    STZ.W $163E,X             
                    LDA $C2,X                 
                    CMP.B #$03                
                    BEQ ADDR_02C80F           
                    INC.W $1528,X             
                    LDA.W $1528,X             
                    CMP.B #$03                
                    BCC ADDR_02C7F6           
                    STZ $AA,X                 
                    BRA ADDR_02C7B1           
ADDR_02C7F6:        LDA.B #$28                
                    STA.W $1DFC               ; / Play sound effect 
                    LDA.B #$03                
                    STA $C2,X                 
                    LDA.B #$03                
                    STA.W $1540,X             
                    STZ.W $1570,X             
                    JSR.W ADDR_02D4FA         
                    LDA.W DATA_02C79B,Y       
                    STA $7B                   
ADDR_02C80F:        RTS                       ; Return 

ADDR_02C810:        LDA.W $187A               
                    BNE ADDR_02C819           
                    JSL.L HurtMario           
ADDR_02C819:        RTS                       ; Return 

ADDR_02C81A:        JSR.W GetDrawInfo2        
                    JSR.W ADDR_02C88C         
                    JSR.W ADDR_02CA27         
                    JSR.W ADDR_02CA9D         
                    JSR.W ADDR_02CBA1         
                    LDY.B #$FF                
ADDR_02C82B:        LDA.B #$04                
                    JMP.W ADDR_02B7A7         

DATA_02C830:        .db $F8,$F8,$F8,$00,$00,$FE,$00,$00
                    .db $FA,$00,$00,$00,$00,$00,$00,$FD
                    .db $FD,$F9,$F6,$F6,$F8,$FE,$FC,$FA
                    .db $F8,$FA

DATA_02C84A:        .db $F8,$F9,$F7,$F8,$FC,$F8,$F4,$F5
                    .db $F5,$FC,$FD,$00,$F9,$F5,$F8,$FA
                    .db $F6,$F6,$F4,$F4,$F8,$F6,$F6,$F8
                    .db $F8,$F5

DATA_02C864:        .db $08,$08,$08,$00,$00,$00,$08,$08
                    .db $08,$00,$08,$08,$00,$00,$00,$00
                    .db $00,$08,$10,$10,$0C,$0C,$0C,$0C
                    .db $0C,$0C

ChuckHeadTiles:     .db $06,$0A,$0E,$0A,$06,$4B,$4B

DATA_02C885:        .db $40,$40,$00,$00,$00,$00,$40

ADDR_02C88C:        STZ $07                   
                    LDY.W $1602,X             
                    STY $04                   
                    CPY.B #$09                
                    CLC                       
                    BNE ADDR_02C8AB           
                    LDA.W $1540,X             
                    SEC                       
                    SBC.B #$20                
                    BCC ADDR_02C8AB           
                    PHA                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    STA $07                   
                    PLA                       
                    LSR                       
                    LSR                       
ADDR_02C8AB:        LDA $00                   
                    ADC.B #$00                
                    STA $00                   
                    LDA.W $151C,X             
                    STA $02                   
                    LDA.W $157C,X             
                    STA $03                   
                    LDA.W $15F6,X             
                    ORA $64                   
                    STA $08                   
                    LDA.W $15EA,X             
                    STA $05                   
                    CLC                       
                    ADC.W DATA_02C864,Y       
                    TAY                       
                    LDX $04                   
                    LDA.W DATA_02C830,X       
                    LDX $03                   
                    BNE ADDR_02C8D8           
                    EOR.B #$FF                
                    INC A                     
ADDR_02C8D8:        CLC                       
                    ADC $00                   
                    STA.W $0300,Y             
                    LDX $04                   
                    LDA $01                   
                    CLC                       
                    ADC.W DATA_02C84A,X       
                    SEC                       
                    SBC $07                   
                    STA.W $0301,Y             
                    LDX $02                   
                    LDA.W DATA_02C885,X       
                    ORA $08                   
                    STA.W $0303,Y             
                    LDA.W ChuckHeadTiles,X    
                    STA.W $0302,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$02                
                    STA.W $0460,Y             
                    LDX.W $15E9               
                    RTS                       ; Return 


DATA_02C909:        .db $F8,$F8,$F8,$FC,$FC,$FC,$FC,$F8
                    .db $01,$FC,$FC,$FC,$FC,$FC,$FC,$FC
                    .db $FC,$F8,$F8,$F8,$F8,$08,$06,$F8
                    .db $F8,$01,$10,$10,$10,$04,$04,$04
                    .db $04,$08,$07,$04,$04,$04,$04,$04
                    .db $04,$04,$04,$10,$08,$08,$10,$00
                    .db $02,$10,$10,$07

DATA_02C93D:        .db $00,$00,$00,$04,$04,$04,$04,$08
                    .db $00,$04,$04,$04,$04,$04,$04,$04
                    .db $04,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$FC,$FC,$FC
                    .db $FC,$F8,$00,$FC,$FC,$FC,$FC,$FC
                    .db $FC,$FC,$FC,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00

DATA_02C971:        .db $06,$06,$06,$00,$00,$00,$00,$00
                    .db $F8,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$03,$00,$00,$06,$F8,$F8,$00
                    .db $00,$F8

ChuckBody1:         .db $0D,$34,$35,$26,$2D,$28,$40,$42
                    .db $5D,$2D,$64,$64,$64,$64,$E7,$28
                    .db $82,$CB,$23,$20,$0D,$0C,$5D,$BD
                    .db $BD,$5D

ChuckBody2:         .db $4E,$0C,$22,$26,$2D,$29,$40,$42
                    .db $AE,$2D,$64,$64,$64,$64,$E8,$29
                    .db $83,$CC,$24,$21,$4E,$A0,$A0,$A2
                    .db $A4,$AE

DATA_02C9BF:        .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$40,$00,$00
                    .db $00,$00

DATA_02C9D9:        .db $00,$00,$00,$40,$40,$00,$40,$40
                    .db $00,$40,$40,$40,$40,$40,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00

DATA_02C9F3:        .db $00,$00,$00,$02,$02,$02,$02,$02
                    .db $00,$02,$02,$02,$02,$02,$02,$02
                    .db $02,$00,$02,$02,$00,$00,$00,$00
                    .db $00,$00

DATA_02CA0D:        .db $00,$00,$00,$04,$04,$04,$0C,$0C
                    .db $00,$08,$00,$00,$04,$04,$04,$04
                    .db $04,$00,$08,$08,$00,$00,$00,$00
                    .db $00,$00

ADDR_02CA27:        STZ $06                   
                    LDA $04                   
                    LDY $03                   
                    BNE ADDR_02CA36           
                    CLC                       
                    ADC.B #$1A                
                    LDX.B #$40                
                    STX $06                   
ADDR_02CA36:        TAX                       
                    LDY $04                   
                    LDA.W DATA_02CA0D,Y       
                    CLC                       
                    ADC $05                   
                    TAY                       
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_02C909,X       
                    STA.W $0300,Y             
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_02C93D,X       
                    STA.W $0304,Y             
                    LDX $04                   
                    LDA $01                   
                    CLC                       
                    ADC.W DATA_02C971,X       
                    STA.W $0301,Y             
                    LDA $01                   
                    STA.W $0305,Y             
                    LDA.W ChuckBody1,X        
                    STA.W $0302,Y             
                    LDA.W ChuckBody2,X        
                    STA.W $0306,Y             
                    LDA $08                   
                    ORA $06                   
                    PHA                       
                    EOR.W DATA_02C9BF,X       
                    STA.W $0303,Y             
                    PLA                       
                    EOR.W DATA_02C9D9,X       
                    STA.W $0307,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_02C9F3,X       
                    STA.W $0460,Y             
                    LDA.B #$02                
                    STA.W $0461,Y             
                    LDX.W $15E9               
                    RTS                       ; Return 


DATA_02CA93:        .db $FA,$00

DATA_02CA95:        .db $0E,$00

ClappinChuckTiles:  .db $0C,$44

DATA_02CA99:        .db $F8,$F0

DATA_02CA9B:        .db $00,$02

ADDR_02CA9D:        LDA $04                   
                    CMP.B #$14                
                    BCC ADDR_02CAA6           
                    JMP.W ADDR_02CB53         
ADDR_02CAA6:        CMP.B #$12                
                    BEQ ADDR_02CAFC           
                    CMP.B #$13                
                    BEQ ADDR_02CAFC           
                    SEC                       
                    SBC.B #$06                
                    CMP.B #$02                
                    BCS ADDR_02CAF9           
                    TAX                       
                    LDY $05                   
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_02CA93,X       
                    STA.W $0300,Y             
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_02CA95,X       
                    STA.W $0304,Y             
                    LDA $01                   
                    CLC                       
                    ADC.W DATA_02CA99,X       
                    STA.W $0301,Y             
                    STA.W $0305,Y             
                    LDA.W ClappinChuckTiles,X 
                    STA.W $0302,Y             
                    STA.W $0306,Y             
                    LDA $08                   
                    STA.W $0303,Y             
                    ORA.B #$40                
                    STA.W $0307,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_02CA9B,X       
                    STA.W $0460,Y             
                    STA.W $0461,Y             
                    LDX.W $15E9               
ADDR_02CAF9:        RTS                       ; Return 


ChuckGfxProp:       .db $47,$07

ADDR_02CAFC:        LDY $05                   
                    LDA.W $157C,X             
                    PHX                       
                    TAX                       
                    ASL                       
                    ASL                       
                    ASL                       
                    PHA                       
                    EOR.B #$08                
                    CLC                       
                    ADC $00                   
                    STA.W $0300,Y             
                    PLA                       
                    CLC                       
                    ADC $00                   
                    STA.W $0304,Y             
                    LDA.B #$1C                
                    STA.W $0302,Y             
                    INC A                     
                    STA.W $0306,Y             
                    LDA $01                   
                    SEC                       
                    SBC.B #$08                
                    STA.W $0301,Y             
                    STA.W $0305,Y             
                    LDA.W ChuckGfxProp,X      
ADDR_02CB2D:        ORA $64                   
                    STA.W $0303,Y             
                    STA.W $0307,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAX                       
ADDR_02CB39:        STZ.W $0460,X             
                    STZ.W $0461,X             
                    PLX                       
                    RTS                       ; Return 


DATA_02CB41:        .db $FA,$0A,$06,$00,$00,$01,$0E,$FE
                    .db $02,$00,$00,$09,$08,$F4,$F4,$00
                    .db $00,$F4

ADDR_02CB53:        PHX                       
                    STA $02                   
                    LDY.W $157C,X             
                    BNE ADDR_02CB5E           
                    CLC                       
                    ADC.B #$06                
ADDR_02CB5E:        TAX                       
                    LDA $05                   
                    CLC                       
                    ADC.B #$08                
                    TAY                       
                    LDA $00                   
                    CLC                       
                    ADC.W ADDR_02CB2D,X       
                    STA.W $0300,Y             
                    LDX $02                   
                    LDA.W ADDR_02CB39,X       
                    BEQ ADDR_02CB8E           
                    CLC                       
                    ADC $01                   
                    STA.W $0301,Y             
                    LDA.B #$AD                
                    STA.W $0302,Y             
                    LDA.B #$09                
                    ORA $64                   
                    STA.W $0303,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAX                       
                    STZ.W $0460,X             
ADDR_02CB8E:        PLX                       
                    RTS                       ; Return 


DigChuckTileDispX:  .db $FC,$04,$10,$F0,$12,$EE

DigChuckTileProp:   .db $47,$07

DigChuckTileDispY:  .db $F8,$00,$F8

DigChuckTiles:      .db $CA,$E2,$A0

DigChuckTileSize:   .db $00,$02,$02

ADDR_02CBA1:        LDA $9E,X                 
                    CMP.B #$46                
                    BNE ADDR_02CBFB           
                    LDA.W $1602,X             
                    CMP.B #$05                
                    BNE ADDR_02CBB2           
                    LDA.B #$01                
                    BRA ADDR_02CBB9           
ADDR_02CBB2:        CMP.B #$0E                
                    BCC ADDR_02CBFB           
                    SEC                       
                    SBC.B #$0E                
ADDR_02CBB9:        STA $02                   
                    LDA.W $15EA,X             
                    CLC                       
                    ADC.B #$0C                
                    TAY                       
                    PHX                       
                    LDA $02                   
                    ASL                       
                    ORA.W $157C,X             
                    TAX                       
                    LDA $00                   
                    CLC                       
                    ADC.W DigChuckTileDispX,X 
                    STA.W $0300,Y             
                    TXA                       
                    AND.B #$01                
                    TAX                       
                    LDA.W DigChuckTileProp,X  
                    ORA $64                   
                    STA.W $0303,Y             
                    LDX $02                   
                    LDA $01                   
                    CLC                       
                    ADC.W DigChuckTileDispY,X 
                    STA.W $0301,Y             
                    LDA.W DigChuckTiles,X     
                    STA.W $0302,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DigChuckTileSize,X  
                    STA.W $0460,Y             
                    PLX                       
ADDR_02CBFB:        RTS                       ; Return 

                    RTS                       ; Return 

ADDR_02CBFD:        RTL                       ; Return 

ADDR_02CBFE:        LDA $9D                   
                    BNE ADDR_02CC05           
                    INC.W $1570,X             
ADDR_02CC05:        JSR.W ADDR_02CCB9         
                    PHX                       
                    JSL.L ADDR_00FF32         
                    PLX                       
                    LDA $E4,X                 
                    CLC                       
                    ADC.W $17BD               
                    STA $E4,X                 
                    LDA.W $14E0,X             
                    ADC.B #$00                
                    STA.W $14E0,X             
                    LDA $71                   
                    CMP.B #$01                
                    BCS ADDR_02CBFD           
                    LDA.W $18B5               
                    BEQ ADDR_02CC2D           
                    JSL.L ADDR_00FF07         
ADDR_02CC2D:        LDY.B #$00                
                    LDA.W $17BC               
                    BPL ADDR_02CC35           
                    DEY                       
ADDR_02CC35:        CLC                       
                    ADC $D8,X                 
                    STA $D8,X                 
                    TYA                       
                    ADC.W $14D4,X             
                    STA.W $14D4,X             
                    LDA $E4,X                 
                    STA $00                   
                    LDA.W $14E0,X             
                    STA $01                   
                    LDA $D8,X                 
                    STA $02                   
                    LDA.W $14D4,X             
                    STA $03                   
                    REP #$20                  ; Accum (16 bit) 
                    LDA $00                   
                    LDY $7B                   
                    DEY                       
                    BPL ADDR_02CC6C           
                    CLC                       
                    ADC.W #$0000              
                    CMP $94                   
                    BCC ADDR_02CC7F           
                    STA $94                   
                    LDY.B #$00                
                    STY $7B                   
                    BRA ADDR_02CC7F           
ADDR_02CC6C:        CLC                       
                    ADC.W #$0090              
                    CMP $94                   
                    BCS ADDR_02CC7F           
                    LDA $00                   
                    ADC.W #$0091              
                    STA $94                   
                    LDY.B #$00                
                    STY $7B                   
ADDR_02CC7F:        LDA $02                   
                    LDY $7D                   
                    BPL ADDR_02CC93           
                    CLC                       
                    ADC.W #$0020              
                    CMP $96                   
                    BCC ADDR_02CCAE           
                    LDY.B #$00                
                    STY $7D                   
                    BRA ADDR_02CCAE           
ADDR_02CC93:        CLC                       
                    ADC.W #$0060              
                    CMP $96                   
                    BCS ADDR_02CCAE           
                    LDA $02                   
                    ADC.W #$0061              
                    STA $96                   
                    LDY.B #$00                
                    STY $7D                   
                    LDY.B #$01                
                    STY.W $1471               
                    STY.W $18B5               
ADDR_02CCAE:        SEP #$20                  ; Accum (8 bit) 
                    RTL                       ; Return 


CageWingTileDispX:  .db $00,$30,$60,$90

CageWingTileDispY:  .db $F8,$00,$F8,$00

ADDR_02CCB9:        LDA.B #$03                
                    STA $08                   
                    LDA $E4,X                 
                    SEC                       
                    SBC $1A                   
                    STA $00                   
                    LDA $D8,X                 
                    SEC                       
                    SBC $1C                   
                    STA $01                   
                    LDY.W $15EA,X             
                    STY $02                   
ADDR_02CCD0:        LDY $02                   
                    LDX $08                   
                    LDA $00                   
                    CLC                       
                    ADC.W CageWingTileDispX,X 
                    STA.W $0300,Y             
                    STA.W $0304,Y             
                    LDA $01                   
                    CLC                       
                    ADC.W CageWingTileDispY,X 
                    STA.W $0301,Y             
                    CLC                       
                    ADC.B #$08                
                    STA.W $0305,Y             
                    LDX.W $15E9               
                    LDA.W $1570,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    EOR $08                   
                    LSR                       
                    LDA.B #$C6                
                    BCC ADDR_02CD01           
                    LDA.B #$81                
ADDR_02CD01:        STA.W $0302,Y             
                    LDA.B #$D6                
                    BCC ADDR_02CD0A           
                    LDA.B #$D7                
ADDR_02CD0A:        STA.W $0306,Y             
                    LDA.B #$70                
                    STA.W $0303,Y             
                    STA.W $0307,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$00                
                    STA.W $0460,Y             
                    STA.W $0461,Y             
                    LDA $02                   
                    CLC                       
                    ADC.B #$08                
                    STA $02                   
                    DEC $08                   
                    BPL ADDR_02CCD0           
                    RTS                       ; Return 

ADDR_02CD2D:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02CD59         
                    PLB                       
                    RTL                       ; Return 


DATA_02CD35:        .db $00,$08,$10,$18,$00,$08,$10,$18
DATA_02CD3D:        .db $00,$00,$00,$00,$08,$08,$08,$08
DATA_02CD45:        .db $00,$01,$01,$00,$10,$11,$11,$10
DATA_02CD4D:        .db $31,$31,$71,$71,$31,$31,$71,$71
DATA_02CD55:        .db $0A,$04,$06,$08

ADDR_02CD59:        LDA.W $1540,X             
                    CMP.B #$5E                
                    BNE ADDR_02CD7F           
                    LDA.B #$1B                
                    STA $9C                   
                    LDA $E4,X                 
                    STA $9A                   
                    LDA.W $14E0,X             
                    STA $9B                   
                    LDA $D8,X                 
                    SEC                       
                    SBC.B #$10                
                    STA $98                   
                    LDA.W $14D4,X             
                    SBC.B #$00                
                    STA $99                   
                    JSL.L ADDR_00BEB0         
ADDR_02CD7F:        JSL.L InvisBlkMainRt      
                    JSR.W GetDrawInfo2        
                    PHX                       
                    LDX.W $191E               
                    LDA.W DATA_02CD55,X       
                    STA $02                   
                    LDX.B #$07                
ADDR_02CD91:        LDA $00                   
                    CLC                       
                    ADC.W DATA_02CD35,X       
                    STA.W $0300,Y             
                    LDA $01                   
                    CLC                       
                    ADC.W DATA_02CD3D,X       
                    STA.W $0301,Y             
                    LDA.W DATA_02CD45,X       
                    STA.W $0302,Y             
                    LDA.W DATA_02CD4D,X       
                    CPX.B #$04                
                    BCS ADDR_02CDB2           
                    ORA $02                   
ADDR_02CDB2:        STA.W $0303,Y             
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_02CD91           
                    PLX                       
                    LDY.B #$00                
                    LDA.B #$07                
                    JMP.W ADDR_02B7A7         
                    RTS                       ; Return 


DATA_02CDC5:        .db $00,$07,$F9,$00,$01,$FF

ADDR_02CDCB:        JSR.W ADDR_02D025         
                    JSR.W ADDR_02CEE0         
                    LDA $9D                   
                    BNE ADDR_02CDFE           
                    LDA.W $1534,X             
                    BEQ ADDR_02CDF1           
                    DEC.W $1534,X             
                    BIT $15                   
                    BPL ADDR_02CDF1           
                    STZ.W $1534,X             
                    LDY.W $151C,X             
                    LDA.W DATA_02CDFF,Y       
                    STA $7D                   
                    LDA.B #$08                
                    STA.W $1DFC               ; / Play sound effect 
ADDR_02CDF1:        LDA.W $1528,X             
                    JSL.L ExecutePtr          

Ptrs02CDF8:         .dw ADDR_02CDFE           
                    .dw ADDR_02CE0F           
                    .dw ADDR_02CE3A           

ADDR_02CDFE:        RTL                       ; Return 


DATA_02CDFF:        .db $B6,$B4,$B0,$A8,$A0,$98,$90,$88
DATA_02CE07:        .db $00,$00,$E8,$E0,$D0,$C8,$C0,$B8

ADDR_02CE0F:        LDA.W $1540,X             
                    BEQ ADDR_02CE20           
                    DEC A                     
                    BNE ADDR_02CE1F           
                    INC.W $1528,X             
                    LDA.B #$01                
                    STA.W $157C,X             
ADDR_02CE1F:        RTL                       ; Return 

ADDR_02CE20:        LDA $C2,X                 
                    BMI ADDR_02CE29           
                    CMP.W $151C,X             
                    BCS ADDR_02CE2F           
ADDR_02CE29:        CLC                       
                    ADC.B #$01                
                    STA $C2,X                 
                    RTL                       ; Return 

ADDR_02CE2F:        LDA.W $151C,X             
                    STA $C2,X                 
                    LDA.B #$08                
                    STA.W $1540,X             
                    RTL                       ; Return 

ADDR_02CE3A:        INC.W $1570,X             
                    LDA.W $1570,X             
                    AND.B #$03                
                    BNE ADDR_02CE49           
                    DEC.W $151C,X             
                    BEQ ADDR_02CE86           
ADDR_02CE49:        LDA.W $151C,X             
                    EOR.B #$FF                
                    INC A                     
                    STA $00                   
                    LDA.W $157C,X             
                    AND.B #$01                
                    BNE ADDR_02CE70           
                    LDA $C2,X                 
                    CLC                       
                    ADC.B #$04                
                    STA $C2,X                 
                    BMI ADDR_02CE66           
                    CMP.W $151C,X             
                    BCS ADDR_02CE67           
ADDR_02CE66:        RTL                       ; Return 

ADDR_02CE67:        LDA.W $151C,X             
                    STA $C2,X                 
                    INC.W $157C,X             
                    RTL                       ; Return 

ADDR_02CE70:        LDA $C2,X                 
                    SEC                       
                    SBC.B #$04                
                    STA $C2,X                 
                    BPL ADDR_02CE7D           
                    CMP $00                   
                    BCC ADDR_02CE7E           
ADDR_02CE7D:        RTL                       ; Return 

ADDR_02CE7E:        LDA $00                   
                    STA $C2,X                 
                    INC.W $157C,X             
                    RTL                       ; Return 

ADDR_02CE86:        STZ $C2,X                 
                    STZ.W $1528,X             
                    RTL                       ; Return 

                    JSR.W ADDR_02CEE0         
                    RTL                       ; Return 


DATA_02CE90:        .db $00,$08,$10,$18,$20,$00,$08,$10
                    .db $18,$20,$00,$08,$10,$18,$20,$00
                    .db $08,$10,$18,$1F,$00,$08,$10,$17
                    .db $1E,$00,$08,$0F,$16,$1D,$00,$07
                    .db $0F,$16,$1C,$00,$07,$0E,$15,$1B
DATA_02CEB8:        .db $00,$00,$00,$00,$00,$00,$01,$01
                    .db $01,$02,$00,$00,$01,$02,$04,$00
                    .db $01,$02,$04,$06,$00,$01,$03,$06
                    .db $08,$00,$02,$04,$08,$0A,$00,$02
                    .db $05,$07,$0C,$00,$02,$05,$09,$0E

ADDR_02CEE0:        JSR.W GetDrawInfo2        
                    LDA.B #$04                
                    STA $02                   
                    LDA $9E,X                 
                    SEC                       
                    SBC.B #$6B                
                    STA $05                   
                    LDA $C2,X                 
                    STA $03                   
                    BPL ADDR_02CEF7           
                    EOR.B #$FF                
                    INC A                     
ADDR_02CEF7:        STA $04                   
                    LDY.W $15EA,X             
ADDR_02CEFC:        LDA $04                   
                    ASL                       
                    ASL                       
                    ADC $04                   
                    ADC $02                   
                    TAX                       
                    LDA $05                   
                    LSR                       
                    LDA.W DATA_02CE90,X       
                    BCC ADDR_02CF10           
                    EOR.B #$FF                
                    INC A                     
ADDR_02CF10:        STA $08                   
                    CLC                       
                    ADC $00                   
                    STA.W $0300,Y             
                    LDA $03                   
                    ASL                       
                    LDA.W DATA_02CEB8,X       
                    BCC ADDR_02CF23           
                    EOR.B #$FF                
                    INC A                     
ADDR_02CF23:        STA $09                   
                    CLC                       
                    ADC $01                   
                    STA.W $0301,Y             
                    LDA.B #$3D                
                    STA.W $0302,Y             
                    LDA $64                   
                    ORA.B #$0A                
                    STA.W $0303,Y             
                    LDX.W $15E9               
                    PHY                       
                    JSR.W ADDR_02CF52         
                    PLY                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEC $02                   
                    BMI ADDR_02CF4A           
                    JMP.W ADDR_02CEFC         
ADDR_02CF4A:        LDY.B #$00                
                    LDA.B #$04                
                    JMP.W ADDR_02B7A7         
ADDR_02CF51:        RTS                       ; Return 

ADDR_02CF52:        LDA $71                   
                    CMP.B #$01                
                    BCS ADDR_02CF51           
                    LDA $81                   
                    ORA $7F                   
                    ORA.W $15A0,X             
                    ORA.W $186C,X             
                    BNE ADDR_02CF51           
                    LDA $7E                   
                    CLC                       
                    ADC.B #$02                
                    STA $0A                   
                    LDA.W $187A               
                    CMP.B #$01                
                    LDA.B #$10                
                    BCC ADDR_02CF76           
                    LDA.B #$20                
ADDR_02CF76:        CLC                       
                    ADC $80                   
                    STA $0B                   
                    LDA.W $0300,Y             
                    SEC                       
                    SBC $0A                   
                    CLC                       
                    ADC.B #$08                
                    CMP.B #$14                
                    BCS ADDR_02CFFD           
                    LDA $19                   
                    CMP.B #$01                
                    LDA.B #$1A                
                    BCS ADDR_02CF92           
                    LDA.B #$1C                
ADDR_02CF92:        STA $0F                   
                    LDA.W $0301,Y             
                    SEC                       
                    SBC $0B                   
                    CLC                       
                    ADC.B #$08                
                    CMP $0F                   
                    BCS ADDR_02CFFD           
                    LDA $7D                   
                    BMI ADDR_02CFFD           
                    LDA.B #$1F                
                    PHX                       
                    LDX.W $187A               
                    BEQ ADDR_02CFAF           
                    LDA.B #$2F                
ADDR_02CFAF:        STA $0F                   
                    PLX                       
                    LDA.W $0301,Y             
                    SEC                       
                    SBC $0F                   
                    PHP                       
                    CLC                       
                    ADC $1C                   
                    STA $96                   
                    LDA $1D                   
                    ADC.B #$00                
                    PLP                       
                    SBC.B #$00                
                    STA $97                   
                    STZ $72                   
                    LDA.B #$02                
                    STA.W $1471               
                    LDA.W $1528,X             
                    BEQ ADDR_02CFEB           
                    CMP.B #$02                
                    BEQ ADDR_02CFEB           
                    LDA.W $1540,X             
                    CMP.B #$01                
                    BNE ADDR_02CFEA           
                    LDA.B #$08                
                    STA.W $1534,X             
                    LDY $C2,X                 
                    LDA.W DATA_02CE07,Y       
                    STA $7D                   
ADDR_02CFEA:        RTS                       ; Return 

ADDR_02CFEB:        STZ $7B                   
                    LDY $02                   
                    LDA.W PeaBouncerPhysics,Y 
                    STA.W $151C,X             
                    LDA.B #$01                
                    STA.W $1528,X             
                    STZ.W $1570,X             
ADDR_02CFFD:        RTS                       ; Return 


PeaBouncerPhysics:  .db $01,$01,$03,$05,$07

DATA_02D003:        .db $40,$B0

DATA_02D005:        .db $01,$FF

DATA_02D007:        .db $30,$C0,$A0,$C0,$A0,$70,$60,$B0
DATA_02D00F:        .db $01,$FF,$01,$FF,$01,$FF,$01,$FF

ADDR_02D017:        LDA.B #$06                
                    BRA ADDR_02D021           
ADDR_02D01B:        LDA.B #$04                
                    BRA ADDR_02D021           
ADDR_02D01F:        LDA.B #$02                
ADDR_02D021:        STA $03                   
                    BRA ADDR_02D027           
ADDR_02D025:        STZ $03                   
ADDR_02D027:        JSR.W ADDR_02D0C9         
                    BEQ ADDR_02D090           
                    LDA $5B                   
                    AND.B #$01                
                    BNE ADDR_02D091           
                    LDA $03                   
                    CMP.B #$04                
                    BEQ ADDR_02D04D           
                    LDA $D8,X                 
                    CLC                       
                    ADC.B #$50                
                    LDA.W $14D4,X             
                    ADC.B #$00                
                    CMP.B #$02                
                    BPL ADDR_02D07A           
                    LDA.W $167A,X             
                    AND.B #$04                
                    BNE ADDR_02D090           
ADDR_02D04D:        LDA $13                   
                    AND.B #$01                
                    ORA $03                   
                    STA $01                   
                    TAY                       
                    LDA $1A                   
                    CLC                       
                    ADC.W DATA_02D007,Y       
                    ROL $00                   
                    CMP $E4,X                 
                    PHP                       
                    LDA $1B                   
                    LSR $00                   
                    ADC.W DATA_02D00F,Y       
                    PLP                       
                    SBC.W $14E0,X             
                    STA $00                   
                    LSR $01                   
                    BCC ADDR_02D076           
                    EOR.B #$80                
                    STA $00                   
ADDR_02D076:        LDA $00                   
                    BPL ADDR_02D090           
ADDR_02D07A:        LDA.W $14C8,X             
                    CMP.B #$08                
                    BCC ADDR_02D08D           
                    LDY.W $161A,X             
                    CPY.B #$FF                
                    BEQ ADDR_02D08D           
                    LDA.B #$00                
                    STA.W $1938,Y             
ADDR_02D08D:        STZ.W $14C8,X             
ADDR_02D090:        RTS                       ; Return 

ADDR_02D091:        LDA.W $167A,X             
                    AND.B #$04                
                    BNE ADDR_02D090           
                    LDA $13                   
                    LSR                       
                    BCS ADDR_02D090           
                    AND.B #$01                
                    STA $01                   
                    TAY                       
                    LDA $1C                   
                    CLC                       
                    ADC.W DATA_02D003,Y       
                    ROL $00                   
                    CMP $D8,X                 
                    PHP                       
                    LDA.W $001D               
                    LSR $00                   
                    ADC.W DATA_02D005,Y       
                    PLP                       
                    SBC.W $14D4,X             
                    STA $00                   
                    LDY $01                   
                    BEQ ADDR_02D0C3           
                    EOR.B #$80                
                    STA $00                   
ADDR_02D0C3:        LDA $00                   
                    BPL ADDR_02D090           
                    BMI ADDR_02D07A           
ADDR_02D0C9:        LDA.W $15A0,X             
                    ORA.W $186C,X             
                    RTS                       ; Return 


DATA_02D0D0:        .db $14,$FC

DATA_02D0D2:        .db $00,$FF

ADDR_02D0D4:        LDA.W $1564,X             
                    BNE ADDR_02D0E5           
                    LDA.W $160E,X             
                    BPL ADDR_02D0E5           
                    PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02D0E6         
                    PLB                       
ADDR_02D0E5:        RTL                       ; Return 

ADDR_02D0E6:        STZ $0F                   
                    BRA ADDR_02D149           
                    LDA $D8,X                 
                    CLC                       
                    ADC.B #$08                
                    AND.B #$F0                
                    STA $00                   
                    LDA.W $14D4,X             
                    ADC.B #$00                
                    CMP $5D                   
                    BCS ADDR_02D148           
                    STA $03                   
                    AND.B #$10                
                    STA $08                   
                    LDY.W $157C,X             
                    LDA $E4,X                 
                    CLC                       
                    ADC.W DATA_02D0D0,Y       
                    STA $01                   
                    LDA.W $14E0,X             
                    ADC.W DATA_02D0D2,Y       
                    CMP.B #$02                
                    BCS ADDR_02D148           
                    STA $02                   
                    LDA $01                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    ORA $00                   
                    STA $00                   
                    LDX $03                   
                    LDA.L DATA_00BA80,X       
                    LDY $0F                   
                    BEQ ADDR_02D131           
                    LDA.L DATA_00BA8E,X       
ADDR_02D131:        CLC                       
                    ADC $00                   
                    STA $05                   
                    LDA.L DATA_00BABC,X       
                    LDY $0F                   
                    BEQ ADDR_02D142           
                    LDA.L DATA_00BACA,X       
ADDR_02D142:        ADC $02                   
                    STA $06                   
                    BRA ADDR_02D1AD           
ADDR_02D148:        RTS                       ; Return 

ADDR_02D149:        LDA $D8,X                 
                    CLC                       
                    ADC.B #$08                
                    STA.W $18B2               
                    AND.B #$F0                
                    STA $00                   
                    LDA.W $14D4,X             
                    ADC.B #$00                
                    CMP.B #$02                
                    BCS ADDR_02D148           
                    STA $02                   
                    STA.W $18B3               
                    LDY.W $157C,X             
                    LDA $E4,X                 
                    CLC                       
                    ADC.W DATA_02D0D0,Y       
                    STA $01                   
                    STA.W $18B0               
                    LDA.W $14E0,X             
                    ADC.W DATA_02D0D2,Y       
                    CMP $5D                   
                    BCS ADDR_02D148           
                    STA.W $18B1               
                    STA $03                   
                    LDA $01                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    ORA $00                   
                    STA $00                   
                    LDX $03                   
                    LDA.L DATA_00BA60,X       
                    LDY $0F                   
                    BEQ ADDR_02D198           
                    LDA.L DATA_00BA70,X       
ADDR_02D198:        CLC                       
                    ADC $00                   
                    STA $05                   
                    LDA.L DATA_00BA9C,X       
                    LDY $0F                   
                    BEQ ADDR_02D1A9           
                    LDA.L DATA_00BAAC,X       
ADDR_02D1A9:        ADC $02                   
                    STA $06                   
ADDR_02D1AD:        LDA.B #$7E                
                    STA $07                   
                    LDX.W $15E9               
                    LDA [$05]                 
                    STA.W $1693               
                    INC $07                   
                    LDA [$05]                 
                    BNE ADDR_02D1F0           
                    LDA.W $1693               
                    CMP.B #$45                
                    BCC ADDR_02D1F0           
                    CMP.B #$48                
                    BCS ADDR_02D1F0           
                    SEC                       
                    SBC.B #$44                
                    STA.W $18D6               
                    STZ.W $14A3               
                    LDY.W $18DC               
                    LDA.W DATA_02D1F1,Y       
                    STA.W $1602,X             
                    LDA.B #$22                
                    STA.W $1564,X             
                    LDA $96                   
                    CLC                       
                    ADC.B #$08                
                    AND.B #$F0                
                    STA $96                   
                    LDA $97                   
                    ADC.B #$00                
                    STA $97                   
ADDR_02D1F0:        RTS                       ; Return 


DATA_02D1F1:        .db $00,$04

ADDR_02D1F3:        LDA.W $18B0               
                    STA $9A                   
                    LDA.W $18B1               
                    STA $9B                   
                    LDA.W $18B2               
                    STA $98                   
                    LDA.W $18B3               
                    STA $99                   
                    LDA.B #$04                
                    STA $9C                   
                    JSL.L ADDR_00BEB0         
ADDR_02D20F:        RTL                       ; Return 


DATA_02D210:        .db $01

DATA_02D211:        .db $FF,$10,$F0

ADDR_02D214:        LDA $15                   
                    AND.B #$03                
                    BNE ADDR_02D228           
ADDR_02D21A:        LDA $B6,X                 
                    BEQ ADDR_02D226           
                    BPL ADDR_02D224           
                    INC $B6,X                 
                    INC $B6,X                 
ADDR_02D224:        DEC $B6,X                 
ADDR_02D226:        BRA ADDR_02D247           
ADDR_02D228:        TAY                       
                    CPY.B #$01                
                    BNE ADDR_02D238           
                    LDA $B6,X                 
                    CMP.W DATA_02D211,Y       
                    BEQ ADDR_02D247           
                    BPL ADDR_02D21A           
                    BRA ADDR_02D241           
ADDR_02D238:        LDA $B6,X                 
                    CMP.W DATA_02D211,Y       
                    BEQ ADDR_02D247           
                    BMI ADDR_02D21A           
ADDR_02D241:        CLC                       
                    ADC.W ADDR_02D20F,Y       
                    STA $B6,X                 
ADDR_02D247:        LDY.B #$00                
                    LDA $9E,X                 
                    CMP.B #$87                
                    BNE ADDR_02D25F           
                    LDA $15                   
                    AND.B #$0C                
                    BEQ ADDR_02D26F           
                    LDY.B #$10                
                    AND.B #$08                
                    BEQ ADDR_02D26F           
                    LDY.B #$F0                
                    BRA ADDR_02D26F           
ADDR_02D25F:        LDY.B #$F8                
                    LDA $15                   
                    AND.B #$0C                
                    BEQ ADDR_02D26F           
                    LDY.B #$F0                
                    AND.B #$08                
                    BNE ADDR_02D26F           
                    LDY.B #$08                
ADDR_02D26F:        STY $00                   
                    LDA $AA,X                 
                    CMP $00                   
                    BEQ ADDR_02D27F           
                    BPL ADDR_02D27D           
                    INC $AA,X                 
                    INC $AA,X                 
ADDR_02D27D:        DEC $AA,X                 
ADDR_02D27F:        LDA $B6,X                 
                    STA $7B                   
                    LDA $AA,X                 
                    STA $7D                   
                    RTL                       ; Return 

ADDR_02D288:        TXA                       
                    CLC                       
                    ADC.B #$0C                
                    TAX                       
                    JSR.W ADDR_02D294         
                    LDX.W $15E9               
                    RTS                       ; Return 

ADDR_02D294:        LDA $AA,X                 
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    CLC                       
                    ADC.W $14EC,X             
                    STA.W $14EC,X             
                    PHP                       
                    PHP                       
                    LDY.B #$00                
                    LDA $AA,X                 
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    CMP.B #$08                
                    BCC ADDR_02D2B2           
                    ORA.B #$F0                
                    DEY                       
ADDR_02D2B2:        PLP                       
                    PHA                       
                    ADC $D8,X                 
                    STA $D8,X                 
                    TYA                       
                    ADC.W $14D4,X             
                    STA.W $14D4,X             
                    PLA                       
                    PLP                       
                    ADC.B #$00                
                    STA.W $1491               
                    RTS                       ; Return 

                    STA $00                   
                    LDA $94                   
                    PHA                       
                    LDA $95                   
                    PHA                       
                    LDA $96                   
                    PHA                       
                    LDA $97                   
                    PHA                       
                    LDA.W $00E4,Y             
                    STA $94                   
                    LDA.W $14E0,Y             
                    STA $95                   
                    LDA.W $00D8,Y             
                    STA $96                   
                    LDA.W $14D4,Y             
                    STA $97                   
                    LDA $00                   
                    JSR.W ADDR_02D2FB         
                    PLA                       
                    STA $97                   
                    PLA                       
                    STA $96                   
                    PLA                       
                    STA $95                   
                    PLA                       
                    STA $94                   
                    RTS                       ; Return 

ADDR_02D2FB:        STA $01                   
                    PHX                       
                    PHY                       
                    JSR.W ADDR_02D50C         
                    STY $02                   
                    LDA $0E                   
                    BPL ADDR_02D30D           
                    EOR.B #$FF                
                    CLC                       
                    ADC.B #$01                
ADDR_02D30D:        STA $0C                   
                    JSR.W ADDR_02D4FA         
                    STY $03                   
                    LDA $0F                   
                    BPL ADDR_02D31D           
                    EOR.B #$FF                
                    CLC                       
                    ADC.B #$01                
ADDR_02D31D:        STA $0D                   
                    LDY.B #$00                
                    LDA $0D                   
                    CMP $0C                   
                    BCS ADDR_02D330           
                    INY                       
                    PHA                       
                    LDA $0C                   
                    STA $0D                   
                    PLA                       
                    STA $0C                   
ADDR_02D330:        LDA.B #$00                
                    STA $0B                   
                    STA $00                   
                    LDX $01                   
ADDR_02D338:        LDA $0B                   
                    CLC                       
                    ADC $0C                   
                    CMP $0D                   
                    BCC ADDR_02D345           
                    SBC $0D                   
                    INC $00                   
ADDR_02D345:        STA $0B                   
                    DEX                       
                    BNE ADDR_02D338           
                    TYA                       
                    BEQ ADDR_02D357           
                    LDA $00                   
                    PHA                       
                    LDA $01                   
                    STA $00                   
                    PLA                       
                    STA $01                   
ADDR_02D357:        LDA $00                   
                    LDY $02                   
                    BEQ ADDR_02D364           
                    EOR.B #$FF                
                    CLC                       
                    ADC.B #$01                
                    STA $00                   
ADDR_02D364:        LDA $01                   
                    LDY $03                   
                    BEQ ADDR_02D371           
                    EOR.B #$FF                
                    CLC                       
                    ADC.B #$01                
                    STA $01                   
ADDR_02D371:        PLY                       
                    PLX                       
                    RTS                       ; Return 


DATA_02D374:        .db $0C,$1C

DATA_02D376:        .db $01,$02

GetDrawInfo2:       STZ.W $186C,X             
                    STZ.W $15A0,X             
                    LDA $E4,X                 
                    CMP $1A                   
                    LDA.W $14E0,X             
                    SBC $1B                   
                    BEQ ADDR_02D38C           
                    INC.W $15A0,X             
ADDR_02D38C:        LDA.W $14E0,X             
                    XBA                       
                    LDA $E4,X                 
                    REP #$20                  ; Accum (16 bit) 
                    SEC                       
                    SBC $1A                   
                    CLC                       
                    ADC.W #$0040              
                    CMP.W #$0180              
                    SEP #$20                  ; Accum (8 bit) 
                    ROL                       
                    AND.B #$01                
                    STA.W $15C4,X             
                    BNE ADDR_02D3E7           
                    LDY.B #$00                
                    LDA.W $1662,X             
                    AND.B #$20                
                    BEQ ADDR_02D3B2           
                    INY                       
ADDR_02D3B2:        LDA $D8,X                 
                    CLC                       
                    ADC.W DATA_02D374,Y       
                    PHP                       
                    CMP $1C                   
                    ROL $00                   
                    PLP                       
                    LDA.W $14D4,X             
                    ADC.B #$00                
                    LSR $00                   
                    SBC $1D                   
                    BEQ ADDR_02D3D2           
                    LDA.W $186C,X             
                    ORA.W DATA_02D376,Y       
                    STA.W $186C,X             
ADDR_02D3D2:        DEY                       
                    BPL ADDR_02D3B2           
                    LDY.W $15EA,X             
                    LDA $E4,X                 
                    SEC                       
                    SBC $1A                   
                    STA $00                   
                    LDA $D8,X                 
                    SEC                       
                    SBC $1C                   
                    STA $01                   
                    RTS                       ; Return 

ADDR_02D3E7:        PLA                       
                    PLA                       
                    RTS                       ; Return 

ADDR_02D3EA:        JSL.L ADDR_00FF61         
                    LDA $9D                   
                    BNE ADDR_02D444           
                    JSR.W ADDR_02D49C         
                    LDY.B #$00                
                    LDA.W $17BD               
                    BPL ADDR_02D3FD           
                    DEY                       
ADDR_02D3FD:        CLC                       
                    ADC $E4,X                 
                    STA $E4,X                 
                    TYA                       
                    ADC.W $14E0,X             
                    STA.W $14E0,X             
                    LDA $C2,X                 
                    JSL.L ExecutePtr          

Ptrs02D40F:         .dw ADDR_02D419           
                    .dw ADDR_02D445           
                    .dw ADDR_02D455           
                    .dw ADDR_02D481           
                    .dw ADDR_02D489           

ADDR_02D419:        LDA.W $18BF               
                    BEQ ADDR_02D422           
                    JSR.W ADDR_02D07A         
                    RTS                       ; Return 

ADDR_02D422:        LDA.W $1540,X             
                    BNE ADDR_02D444           
                    INC $C2,X                 
                    LDA.B #$80                
                    STA.W $1540,X             
                    JSL.L ADDR_01ACF9         
                    AND.B #$3F                
                    ORA.B #$80                
                    STA $E4,X                 
                    LDA.B #$FF                
                    STA.W $14E0,X             
                    STZ $D8,X                 
                    STZ.W $14D4,X             
                    STZ $AA,X                 
ADDR_02D444:        RTL                       ; Return 

ADDR_02D445:        LDA.W $1540,X             
                    BEQ ADDR_02D452           
                    LDA.B #$04                
                    STA $AA,X                 
                    JSR.W ADDR_02D294         
                    RTL                       ; Return 

ADDR_02D452:        INC $C2,X                 
                    RTL                       ; Return 

ADDR_02D455:        JSR.W ADDR_02D294         
                    LDA $AA,X                 
                    BMI ADDR_02D460           
                    CMP.B #$40                
                    BCS ADDR_02D465           
ADDR_02D460:        CLC                       
                    ADC.B #$07                
                    STA $AA,X                 
ADDR_02D465:        LDA $D8,X                 
                    CMP.B #$A0                
                    BCC ADDR_02D480           
                    AND.B #$F0                
                    STA $D8,X                 
                    LDA.B #$50                
                    STA.W $1887               
                    LDA.B #$09                
                    STA.W $1DFC               ; / Play sound effect 
                    LDA.B #$30                
                    STA.W $1540,X             
                    INC $C2,X                 
ADDR_02D480:        RTL                       ; Return 

ADDR_02D481:        LDA.W $1540,X             
                    BNE ADDR_02D488           
                    INC $C2,X                 
ADDR_02D488:        RTL                       ; Return 

ADDR_02D489:        LDA.B #$E0                
                    STA $AA,X                 
                    JSR.W ADDR_02D294         
                    LDA $D8,X                 
                    BNE ADDR_02D49B           
                    STZ $C2,X                 
                    LDA.B #$A0                
                    STA.W $1540,X             
ADDR_02D49B:        RTL                       ; Return 

ADDR_02D49C:        LDA.B #$00                
                    LDY $19                   
                    BEQ ADDR_02D4A8           
                    LDY $73                   
                    BNE ADDR_02D4A8           
                    LDA.B #$10                
ADDR_02D4A8:        CLC                       
                    ADC $D8,X                 
                    CMP $80                   
                    BCC ADDR_02D4EF           
                    LDA $E4,X                 
                    STA $00                   
                    LDA.W $14E0,X             
                    STA $01                   
                    REP #$20                  ; Accum (16 bit) 
                    LDA $7E                   
                    CLC                       
                    ADC $00                   
                    SEC                       
                    SBC.W #$0030              
                    CMP.W #$0090              
                    BCS ADDR_02D4EF           
                    SEC                       
                    SBC.W #$0008              
                    CMP.W #$0080              
                    SEP #$20                  ; Accum (8 bit) 
                    BCS ADDR_02D4E5           
                    LDA $72                   
                    BNE ADDR_02D4DC           
                    JSL.L HurtMario           
                    RTS                       ; Return 

ADDR_02D4DC:        STZ $7D                   
                    LDA $AA,X                 
                    BMI ADDR_02D4E4           
                    STA $7D                   
ADDR_02D4E4:        RTS                       ; Return 

ADDR_02D4E5:        PHP                       
                    LDA.B #$08                
                    PLP                       
                    BPL ADDR_02D4ED           
                    LDA.B #$F8                
ADDR_02D4ED:        STA $7B                   
ADDR_02D4EF:        SEP #$20                  ; Accum (8 bit) 
                    RTS                       ; Return 


DATA_02D4F2:        .db $80,$40,$20,$10,$08,$04,$02,$01

ADDR_02D4FA:        LDY.B #$00                
                    LDA $94                   
                    SEC                       
                    SBC $E4,X                 
                    STA $0F                   
                    LDA $95                   
                    SBC.W $14E0,X             
                    BPL ADDR_02D50B           
                    INY                       
ADDR_02D50B:        RTS                       ; Return 

ADDR_02D50C:        LDY.B #$00                
                    LDA $96                   
                    SEC                       
                    SBC $D8,X                 
                    STA $0E                   
                    LDA $97                   
                    SBC.W $14D4,X             
                    BPL ADDR_02D51D           
                    INY                       
ADDR_02D51D:        RTS                       ; Return 


DATA_02D51E:        .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF

DATA_02D57F:        .db $FF,$13,$14,$15,$16,$17,$18,$19

ADDR_02D587:        JSR.W ADDR_02D5E4         
                    LDA.W $14C8,X             
                    CMP.B #$02                
                    BEQ ADDR_02D5A3           
                    LDA $9D                   
                    BNE ADDR_02D5A3           
                    JSR.W ADDR_02D025         
                    LDA.B #$E8                
                    STA $B6,X                 
                    JSR.W ADDR_02D288         
                    JSL.L MarioSprInteract    
ADDR_02D5A3:        RTS                       ; Return 


DATA_02D5A4:        .db $00,$10,$20,$30,$00,$10,$20,$30
                    .db $00,$10,$20,$30,$00,$10,$20,$30
DATA_02D5B4:        .db $00,$00,$00,$00,$10,$10,$10,$10
                    .db $20,$20,$20,$20,$30,$30,$30,$30
BanzaiBillTiles:    .db $80,$82,$84,$86,$A0,$88,$CE,$EE
                    .db $C0,$C2,$CE,$EE,$8E,$AE,$84,$86
DATA_02D5D4:        .db $33,$33,$33,$33,$33,$33,$33,$33
                    .db $33,$33,$33,$33,$33,$33,$B3,$B3

ADDR_02D5E4:        JSR.W GetDrawInfo2        
                    PHX                       
                    LDX.B #$0F                
ADDR_02D5EA:        LDA $00                   
                    CLC                       
                    ADC.W DATA_02D5A4,X       
                    STA.W $0300,Y             
                    LDA $01                   
                    CLC                       
                    ADC.W DATA_02D5B4,X       
                    STA.W $0301,Y             
                    LDA.W BanzaiBillTiles,X   
                    STA.W $0302,Y             
                    LDA.W DATA_02D5D4,X       
                    STA.W $0303,Y             
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_02D5EA           
                    PLX                       
                    LDY.B #$02                
                    LDA.B #$0F                
                    JMP.W ADDR_02B7A7         
ADDR_02D617:        PHB                       
                    PHK                       
                    PLB                       
                    LDA $9E,X                 
                    CMP.B #$9F                
                    BNE ADDR_02D625           
                    JSR.W ADDR_02D587         
                    BRA ADDR_02D628           
ADDR_02D625:        JSR.W ADDR_02D62A         
ADDR_02D628:        PLB                       
                    RTL                       ; Return 

ADDR_02D62A:        JSR.W ADDR_02D017         
                    LDA $9D                   
                    BNE ADDR_02D653           
                    LDA $E4,X                 
                    LDY.B #$02                
                    AND.B #$10                
                    BNE ADDR_02D63B           
                    LDY.B #$FE                
ADDR_02D63B:        TYA                       
                    LDY.B #$00                
                    CMP.B #$00                
                    BPL ADDR_02D643           
                    DEY                       
ADDR_02D643:        CLC                       
                    ADC.W $1602,X             
                    STA.W $1602,X             
                    TYA                       
                    ADC.W $151C,X             
                    AND.B #$01                
                    STA.W $151C,X             
ADDR_02D653:        LDA.W $151C,X             
                    STA $01                   
                    LDA.W $1602,X             
                    STA $00                   
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA $00                   
                    CLC                       
                    ADC.W #$0080              
                    AND.W #$01FF              
                    STA $02                   
                    LDA $00                   
                    AND.W #$00FF              
                    ASL                       
                    TAX                       
                    LDA.L CircleCoords,X      
                    STA $04                   
                    LDA $02                   
                    AND.W #$00FF              
                    ASL                       
                    TAX                       
                    LDA.L CircleCoords,X      
                    STA $06                   
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDX.W $15E9               
                    LDA $04                   
                    STA.W $4202               ; Multiplicand A
                    LDA.W $187B,X             
                    LDY $05                   
                    BNE ADDR_02D6A3           
                    STA.W $4203               ; Multplier B
                    JSR.W ADDR_02D800         
                    ASL.W $4216               ; Product/Remainder Result (Low Byte)
                    LDA.W $4217               ; Product/Remainder Result (High Byte)
                    ADC.B #$00                
ADDR_02D6A3:        LSR $01                   
                    BCC ADDR_02D6AA           
                    EOR.B #$FF                
                    INC A                     
ADDR_02D6AA:        STA $04                   
                    LDA $06                   
                    STA.W $4202               ; Multiplicand A
                    LDA.W $187B,X             
                    LDY $07                   
                    BNE ADDR_02D6C6           
                    STA.W $4203               ; Multplier B
                    JSR.W ADDR_02D800         
                    ASL.W $4216               ; Product/Remainder Result (Low Byte)
                    LDA.W $4217               ; Product/Remainder Result (High Byte)
                    ADC.B #$00                
ADDR_02D6C6:        LSR $03                   
                    BCC ADDR_02D6CD           
                    EOR.B #$FF                
                    INC A                     
ADDR_02D6CD:        STA $06                   
                    LDA $E4,X                 
                    PHA                       
                    LDA.W $14E0,X             
                    PHA                       
                    LDA $D8,X                 
                    PHA                       
                    LDA.W $14D4,X             
                    PHA                       
                    LDY.W $0F86,X             
                    STZ $00                   
                    LDA $04                   
                    BPL ADDR_02D6E8           
                    DEC $00                   
ADDR_02D6E8:        CLC                       
                    ADC $E4,X                 
                    STA $E4,X                 
                    PHP                       
                    PHA                       
                    SEC                       
                    SBC.W $1534,X             
                    STA.W $1528,X             
                    PLA                       
                    STA.W $1534,X             
                    PLP                       
                    LDA.W $14E0,X             
                    ADC $00                   
                    STA.W $14E0,X             
                    STZ $01                   
                    LDA $06                   
                    BPL ADDR_02D70B           
                    DEC $01                   
ADDR_02D70B:        CLC                       
                    ADC $D8,X                 
                    STA $D8,X                 
                    LDA.W $14D4,X             
                    ADC $01                   
                    STA.W $14D4,X             
                    LDA $9E,X                 
                    CMP.B #$9E                
                    BEQ ADDR_02D750           
                    JSL.L InvisBlkMainRt      
                    BCC ADDR_02D73D           
                    LDA.B #$03                
                    STA.W $160E,X             
                    STA.W $1471               
                    LDA.W $187A               
                    BNE ADDR_02D74B           
                    PHX                       
                    JSL.L ADDR_00E2BD         
                    PLX                       
                    LDA.B #$FF                
                    STA $78                   
                    BRA ADDR_02D74B           
ADDR_02D73D:        LDA.W $160E,X             
                    BEQ ADDR_02D74B           
                    STZ.W $160E,X             
                    PHX                       
                    JSL.L ADDR_00E2BD         
                    PLX                       
ADDR_02D74B:        JSR.W ADDR_02D848         
                    BRA ADDR_02D757           
ADDR_02D750:        JSL.L MarioSprInteract    
                    JSR.W ADDR_02D813         
ADDR_02D757:        PLA                       
                    STA.W $14D4,X             
                    PLA                       
                    STA $D8,X                 
                    PLA                       
                    STA.W $14E0,X             
                    PLA                       
                    STA $E4,X                 
                    LDA $00                   
                    CLC                       
                    ADC $1A                   
                    SEC                       
                    SBC $E4,X                 
                    JSR.W ADDR_02D870         
                    CLC                       
                    ADC $E4,X                 
                    SEC                       
                    SBC $1A                   
                    STA $00                   
                    LDA $01                   
                    CLC                       
                    ADC $1C                   
                    SEC                       
                    SBC $D8,X                 
                    JSR.W ADDR_02D870         
                    CLC                       
                    ADC $D8,X                 
                    SEC                       
                    SBC $1C                   
                    STA $01                   
                    LDA.W $15C4,X             
                    BNE ADDR_02D806           
                    LDA.W $15EA,X             
                    CLC                       
                    ADC.B #$10                
                    TAY                       
                    PHX                       
                    LDA $E4,X                 
                    STA $0A                   
                    LDA $D8,X                 
                    STA $0B                   
                    LDA $9E,X                 
                    TAX                       
                    LDA.B #$E8                
                    CPX.B #$9E                
                    BEQ ADDR_02D7AB           
                    LDA.B #$A2                
ADDR_02D7AB:        STA $08                   
                    LDX.B #$01                
ADDR_02D7AF:        LDA $00                   
                    STA.W $0300,Y             
                    LDA $01                   
                    STA.W $0301,Y             
                    LDA $08                   
                    STA.W $0302,Y             
                    LDA.B #$33                
                    STA.W $0303,Y             
                    LDA $00                   
                    CLC                       
                    ADC $1A                   
                    SEC                       
                    SBC $0A                   
                    STA $00                   
                    ASL                       
                    ROR $00                   
                    LDA $00                   
                    SEC                       
                    SBC $1A                   
                    CLC                       
                    ADC $0A                   
                    STA $00                   
                    LDA $01                   
                    CLC                       
                    ADC $1C                   
                    SEC                       
                    SBC $0B                   
                    STA $01                   
                    ASL                       
                    ROR $01                   
                    LDA $01                   
                    SEC                       
                    SBC $1C                   
                    CLC                       
                    ADC $0B                   
                    STA $01                   
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_02D7AF           
                    PLX                       
                    LDY.B #$02                
                    LDA.B #$05                
                    JMP.W ADDR_02B7A7         
ADDR_02D800:        NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
ADDR_02D806:        RTS                       ; Return 


DATA_02D807:        .db $F8,$08,$F8,$08

DATA_02D80B:        .db $F8,$F8,$08,$08

DATA_02D80F:        .db $33,$73,$B3,$F3

ADDR_02D813:        JSR.W GetDrawInfo2        
                    PHX                       
                    LDX.B #$03                
ADDR_02D819:        LDA $00                   
                    CLC                       
                    ADC.W DATA_02D807,X       
                    STA.W $0300,Y             
                    LDA $01                   
                    CLC                       
                    ADC.W DATA_02D80B,X       
                    STA.W $0301,Y             
                    LDA.W ADDR_02D800,X       
                    STA.W $0302,Y             
                    LDA.W DATA_02D80F,X       
                    STA.W $0303,Y             
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_02D819           
                    PLX                       
                    RTS                       ; Return 


DATA_02D840:        .db $00,$F0,$00,$10

WoodPlatformTiles:  .db $A2,$60,$61,$62

ADDR_02D848:        JSR.W GetDrawInfo2        
                    PHX                       
                    LDX.B #$03                
ADDR_02D84E:        LDA $00                   
                    CLC                       
                    ADC.W DATA_02D840,X       
                    STA.W $0300,Y             
                    LDA $01                   
                    STA.W $0301,Y             
                    LDA.W WoodPlatformTiles,X 
                    STA.W $0302,Y             
                    LDA.B #$33                
                    STA.W $0303,Y             
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_02D84E           
                    PLX                       
                    RTS                       ; Return 

ADDR_02D870:        PHP                       
                    BPL ADDR_02D876           
                    EOR.B #$FF                
                    INC A                     
ADDR_02D876:        STA.W $4205               ; Dividend (High-Byte)
                    STZ.W $4204               ; Dividend (Low Byte)
                    LDA.W $187B,X             
                    LSR                       
                    STA.W $4206               ; Divisor B
                    JSR.W ADDR_02D800         
                    LDA.W $4214               ; Quotient of Divide Result (Low Byte)
                    STA $0E                   
                    LDA.W $4215               ; Quotient of Divide Result (High Byte)
                    ASL $0E                   
                    ROL                       
                    ASL $0E                   
                    ROL                       
                    ASL $0E                   
                    ROL                       
                    ASL $0E                   
                    ROL                       
                    PLP                       
                    BPL ADDR_02D8A0           
                    EOR.B #$FF                
                    INC A                     
ADDR_02D8A0:        RTS                       ; Return 


BubbleSprTiles1:    .db $A8,$CA,$67,$24

BubbleSprTiles2:    .db $AA,$CC,$69,$24

BubbleSprGfxProp1:  .db $84,$85,$05,$08

ADDR_02D8AD:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02D8BB         
                    PLB                       
                    RTL                       ; Return 


BubbleSprGfxProp2:  .db $08,$F8

BubbleSprGfxProp3:  .db $01,$FF

BubbleSprGfxProp4:  .db $0C,$F4

ADDR_02D8BB:        LDA.W $15EA,X             
                    CLC                       
                    ADC.B #$14                
                    STA.W $15EA,X             
                    JSL.L GenericSprGfxRt     
                    PHX                       
                    LDA $C2,X                 
                    LDY.W $15EA,X             
                    TAX                       
                    LDA.W BubbleSprGfxProp1,X 
                    ORA $64                   
                    STA.W $0303,Y             
                    LDA $14                   
                    ASL                       
                    ASL                       
                    ASL                       
                    LDA.W BubbleSprTiles1,X   
                    BCC ADDR_02D8E4           
                    LDA.W BubbleSprTiles2,X   
ADDR_02D8E4:        STA.W $0302,Y             
                    PLX                       
                    LDA.W $1534,X             
                    CMP.B #$60                
                    BCS ADDR_02D8F3           
                    AND.B #$02                
                    BEQ ADDR_02D8F6           
ADDR_02D8F3:        JSR.W ADDR_02D9D6         
ADDR_02D8F6:        LDA.W $14C8,X             
                    CMP.B #$02                
                    BNE ADDR_02D904           
                    LDA.B #$08                
                    STA.W $14C8,X             
                    BRA ADDR_02D96B           
ADDR_02D904:        LDA $9D                   
                    BNE ADDR_02D977           
                    LDA $13                   
                    AND.B #$01                
                    BNE ADDR_02D91D           
                    DEC.W $1534,X             
                    LDA.W $1534,X             
                    CMP.B #$04                
                    BNE ADDR_02D91D           
                    LDA.B #$19                
                    STA.W $1DFC               ; / Play sound effect 
ADDR_02D91D:        LDA.W $1534,X             
                    DEC A                     
                    BEQ ADDR_02D978           
                    CMP.B #$07                
                    BCC ADDR_02D977           
                    JSR.W ADDR_02D025         
                    JSR.W ADDR_02D288         
                    JSR.W ADDR_02D294         
                    JSL.L ADDR_019138         
                    LDY.W $157C,X             
                    LDA.W BubbleSprGfxProp2,Y 
                    STA $B6,X                 
                    LDA $13                   
                    AND.B #$01                
                    BNE ADDR_02D958           
                    LDA.W $151C,X             
                    AND.B #$01                
                    TAY                       
                    LDA $AA,X                 
                    CLC                       
                    ADC.W BubbleSprGfxProp3,Y 
                    STA $AA,X                 
                    CMP.W BubbleSprGfxProp4,Y 
                    BNE ADDR_02D958           
                    INC.W $151C,X             
ADDR_02D958:        LDA.W $1588,X             
                    BNE ADDR_02D96B           
                    JSL.L SprSprInteract      
                    JSL.L MarioSprInteract    
                    BCC ADDR_02D9A0           
                    STZ $7D                   
                    STZ $7B                   
ADDR_02D96B:        LDA.W $1534,X             
                    CMP.B #$07                
                    BCC ADDR_02D977           
                    LDA.B #$06                
                    STA.W $1534,X             
ADDR_02D977:        RTS                       ; Return 

ADDR_02D978:        LDY $C2,X                 
                    LDA.W BubbleSprites,Y     
                    STA $9E,X                 
                    PHA                       
                    JSL.L ADDR_07F7D2         
                    PLY                       
                    LDA.B #$20                
                    CPY.B #$74                
                    BNE ADDR_02D98D           
                    LDA.B #$04                
ADDR_02D98D:        STA.W $154C,X             
                    LDA $9E,X                 
                    CMP.B #$0D                
                    BNE ADDR_02D999           
                    DEC.W $1540,X             
ADDR_02D999:        JSR.W ADDR_02D4FA         
                    TYA                       
                    STA.W $157C,X             
ADDR_02D9A0:        RTS                       ; Return 


BubbleSprites:      .db $0F,$0D,$15,$74

BubbleTileDispX:    .db $F8,$08,$F8,$08,$FF,$F9,$07,$F9
                    .db $07,$00,$FA,$06,$FA,$06,$00

BubbleTileDispY:    .db $F6,$F6,$02,$02,$FC,$F5,$F5,$03
                    .db $03,$FC,$F4,$F4,$04,$04,$FB

BubbleTiles:        .db $A0,$A0,$A0,$A0,$99

BubbleGfxProp:      .db $07,$47,$87,$C7,$03

BubbleSize:         .db $02,$02,$02,$02,$00

DATA_02D9D2:        .db $00,$05,$0A,$05

ADDR_02D9D6:        JSR.W GetDrawInfo2        
                    LDA $14                   
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.B #$03                
                    TAY                       
                    LDA.W DATA_02D9D2,Y       
                    STA $02                   
                    LDA.W $15EA,X             
                    SEC                       
                    SBC.B #$14                
                    STA.W $15EA,X             
                    TAY                       
                    PHX                       
                    LDA.W $1534,X             
                    STA $03                   
                    LDX.B #$04                
ADDR_02D9F8:        PHX                       
                    TXA                       
                    CLC                       
                    ADC $02                   
                    TAX                       
                    LDA $00                   
                    CLC                       
                    ADC.W BubbleTileDispX,X   
                    STA.W $0300,Y             
                    LDA $01                   
                    CLC                       
                    ADC.W BubbleTileDispY,X   
                    STA.W $0301,Y             
                    PLX                       
                    LDA.W BubbleTiles,X       
                    STA.W $0302,Y             
                    LDA.W BubbleGfxProp,X     
                    ORA $64                   
                    STA.W $0303,Y             
                    LDA $03                   
                    CMP.B #$06                
                    BCS ADDR_02DA37           
                    CMP.B #$03                
                    LDA.B #$02                
                    ORA $64                   
                    STA.W $0303,Y             
                    LDA.B #$64                
                    BCS ADDR_02DA34           
                    LDA.B #$66                
ADDR_02DA34:        STA.W $0302,Y             
ADDR_02DA37:        PHY                       
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W BubbleSize,X        
                    STA.W $0460,Y             
                    PLY                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_02D9F8           
                    PLX                       
                    LDY.B #$FF                
                    LDA.B #$04                
                    JMP.W ADDR_02B7A7         
ADDR_02DA52:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02DA5A         
                    PLB                       
ADDR_02DA59:        RTL                       ; Return 

ADDR_02DA5A:        STZ.W $157C,X             
                    LDA.W $14C8,X             
                    CMP.B #$02                
                    BNE ADDR_02DA6E           
                    JMP.W ADDR_02DAFD         

HammerFreq:         .db $1F,$0F,$0F,$0F,$0F,$0F,$0F

ADDR_02DA6E:        LDA $9D                   
                    BNE ADDR_02DAE8           
                    JSL.L ADDR_01803A         
                    JSR.W ADDR_02D01F         
                    LDY.W $0DB3               
                    LDA.W $1F11,Y             
                    TAY                       
                    LDA $13                   
                    AND.B #$03                
                    BEQ ADDR_02DA89           
                    INC.W $1570,X             
ADDR_02DA89:        LDA.W $1570,X             
                    ASL                       
                    CPY.B #$00                
                    BEQ ADDR_02DA92           
                    ASL                       
ADDR_02DA92:        AND.B #$40                
                    STA.W $157C,X             
                    LDA.W $1570,X             
                    AND.W HammerFreq,Y        
                    ORA.W $15A0,X             
                    ORA.W $186C,X             
                    ORA.W $1540,X             
                    BNE ADDR_02DAE8           
                    LDA.B #$03                
                    STA.W $1540,X             
                    LDY.B #$10                
                    LDA.W $157C,X             
                    BNE ADDR_02DAB6           
                    LDY.B #$F0                
ADDR_02DAB6:        STY $00                   
                    LDY.B #$07                
ADDR_02DABA:        LDA.W $170B,Y             
                    BEQ ADDR_02DAC3           
                    DEY                       
                    BPL ADDR_02DABA           
                    RTS                       ; Return 

ADDR_02DAC3:        LDA.B #$04                
                    STA.W $170B,Y             
                    LDA $E4,X                 
                    STA.W $171F,Y             
                    LDA.W $14E0,X             
                    STA.W $1733,Y             
                    LDA $D8,X                 
                    STA.W $1715,Y             
                    LDA.W $14D4,X             
                    STA.W $1729,Y             
                    LDA.B #$D0                
                    STA.W $173D,Y             
                    LDA $00                   
                    STA.W $1747,Y             
ADDR_02DAE8:        RTS                       ; Return 


DATA_02DAE9:        .db $08,$10,$00,$10

DATA_02DAED:        .db $F8,$F8,$00,$00

HammerBroTiles:     .db $5A,$4A,$46,$48,$4A,$5A,$48,$46
DATA_02DAF9:        .db $00,$00,$02,$02

ADDR_02DAFD:        JSR.W GetDrawInfo2        
                    LDA.W $157C,X             
                    STA $02                   
                    PHX                       
                    LDX.B #$03                
ADDR_02DB08:        LDA $00                   
                    CLC                       
                    ADC.W DATA_02DAE9,X       
                    STA.W $0300,Y             
                    LDA $01                   
                    CLC                       
                    ADC.W DATA_02DAED,X       
                    STA.W $0301,Y             
                    PHX                       
                    LDA $02                   
                    PHA                       
                    ORA.B #$37                
                    STA.W $0303,Y             
                    PLA                       
                    BEQ ADDR_02DB2A           
                    INX                       
                    INX                       
                    INX                       
                    INX                       
ADDR_02DB2A:        LDA.W HammerBroTiles,X    
                    STA.W $0302,Y             
                    PLX                       
                    PHY                       
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_02DAF9,X       
                    STA.W $0460,Y             
                    PLY                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_02DB08           
ADDR_02DB44:        PLX                       
                    LDY.B #$FF                
                    LDA.B #$03                
                    JMP.W ADDR_02B7A7         
ADDR_02DB4C:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02DB5C         
                    PLB                       
                    RTL                       ; Return 


DATA_02DB54:        .db $01,$FF

DATA_02DB56:        .db $20,$E0

DATA_02DB58:        .db $02,$FE

DATA_02DB5A:        .db $20,$E0

ADDR_02DB5C:        JSR.W ADDR_02DC3F         
                    LDA.B #$FF                
                    STA.W $1594,X             
                    LDY.B #$09                
ADDR_02DB66:        LDA.W $14C8,Y             
                    CMP.B #$08                
                    BNE ADDR_02DB74           
                    LDA.W $009E,Y             
                    CMP.B #$9B                
                    BEQ ADDR_02DB79           
ADDR_02DB74:        DEY                       
                    BPL ADDR_02DB66           
                    BRA ADDR_02DB9E           
ADDR_02DB79:        TYA                       
                    STA.W $1594,X             
                    LDA $E4,X                 
                    STA.W $00E4,Y             
                    LDA.W $14E0,X             
                    STA.W $14E0,Y             
                    LDA $D8,X                 
                    SEC                       
                    SBC.B #$10                
                    STA.W $00D8,Y             
                    LDA.W $14D4,X             
                    SBC.B #$00                
                    STA.W $14D4,Y             
                    PHX                       
                    TYX                       
                    JSR.W ADDR_02DAFD         
                    PLX                       
ADDR_02DB9E:        LDA $9D                   
                    BNE ADDR_02DC0E           
                    JSR.W ADDR_02D01F         
                    LDA $13                   
                    AND.B #$01                
                    BNE ADDR_02DBD7           
                    LDA.W $1534,X             
                    AND.B #$01                
                    TAY                       
                    LDA $B6,X                 
                    CLC                       
                    ADC.W DATA_02DB54,Y       
                    STA $B6,X                 
                    CMP.W DATA_02DB56,Y       
                    BNE ADDR_02DBC1           
                    INC.W $1534,X             
ADDR_02DBC1:        LDA.W $151C,X             
                    AND.B #$01                
                    TAY                       
                    LDA $AA,X                 
                    CLC                       
                    ADC.W DATA_02DB58,Y       
                    STA $AA,X                 
                    CMP.W DATA_02DB5A,Y       
                    BNE ADDR_02DBD7           
                    INC.W $151C,X             
ADDR_02DBD7:        JSR.W ADDR_02D294         
                    JSR.W ADDR_02D288         
                    STA.W $1528,X             
                    JSL.L InvisBlkMainRt      
                    LDA.W $1558,X             
                    BEQ ADDR_02DC0E           
                    LDA.B #$01                
                    STA $C2,X                 
                    JSR.W ADDR_02D4FA         
                    LDA $0F                   
                    CMP.B #$08                
                    BMI ADDR_02DBF8           
                    INC $C2,X                 
ADDR_02DBF8:        LDY.W $1594,X             
                    BMI ADDR_02DC0E           
                    LDA.B #$02                
                    STA.W $14C8,Y             
                    LDA.B #$C0                
                    STA.W $00AA,Y             
                    PHX                       
                    TYX                       
                    JSL.L ADDR_01AB6F         
                    PLX                       
ADDR_02DC0E:        RTS                       ; Return 


DATA_02DC0F:        .db $00,$10,$F2,$1E,$00,$10,$FA,$1E
DATA_02DC17:        .db $00,$00,$F6,$F6,$00,$00,$FE,$FE
HmrBroPlatTiles:    .db $40,$40,$C6,$C6,$40,$40,$5D,$5D
DATA_02DC27:        .db $32,$32,$72,$32,$32,$32,$72,$32
DATA_02DC2F:        .db $02,$02,$02,$02,$02,$02,$00,$00
DATA_02DC37:        .db $00,$04,$06,$08,$08,$06,$04,$00

ADDR_02DC3F:        JSR.W GetDrawInfo2        
                    LDA $C2,X                 
                    STA $07                   
                    LDA.W $1558,X             
                    LSR                       
                    TAY                       
                    LDA.W DATA_02DC37,Y       
                    STA $05                   
                    LDY.W $15EA,X             
                    PHX                       
                    LDA $14                   
                    LSR                       
                    AND.B #$04                
                    STA $02                   
                    LDX.B #$03                
ADDR_02DC5D:        STX $06                   
                    TXA                       
                    ORA $02                   
                    TAX                       
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_02DC0F,X       
                    STA.W $0300,Y             
                    LDA $01                   
                    CLC                       
                    ADC.W DATA_02DC17,X       
                    STA.W $0301,Y             
                    PHX                       
                    LDX $06                   
                    CPX.B #$02                
                    BCS ADDR_02DC8A           
                    INX                       
                    CPX $07                   
                    BNE ADDR_02DC8A           
                    LDA.W $0301,Y             
                    SEC                       
                    SBC $05                   
                    STA.W $0301,Y             
ADDR_02DC8A:        PLX                       
                    LDA.W HmrBroPlatTiles,X   
                    STA.W $0302,Y             
                    LDA.W DATA_02DC27,X       
                    STA.W $0303,Y             
                    PHY                       
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_02DC2F,X       
                    STA.W $0460,Y             
                    PLY                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    LDX $06                   
                    DEX                       
                    BPL ADDR_02DC5D           
                    JMP.W ADDR_02DB44         
ADDR_02DCAF:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02DCB7         
                    PLB                       
                    RTL                       ; Return 

ADDR_02DCB7:        JSR.W ADDR_02DE3E         
                    LDA $9D                   
                    BNE ADDR_02DCE9           
                    LDA.W $14C8,X             
                    CMP.B #$08                
                    BNE ADDR_02DCE9           
                    JSR.W ADDR_02D025         
                    JSL.L ADDR_01803A         
                    JSL.L UpdateSpritePos     
                    LDA.W $1588,X             
                    AND.B #$04                
                    BEQ ADDR_02DCDB           
                    STZ $AA,X                 
                    STZ $B6,X                 
ADDR_02DCDB:        LDA $C2,X                 
                    JSL.L ExecutePtr          

Ptrs02DCE1:         .dw ADDR_02DCEA           
                    .dw ADDR_02DCFF           
                    .dw ADDR_02DD0E           
                    .dw ADDR_02DD4B           

ADDR_02DCE9:        RTS                       ; Return 

ADDR_02DCEA:        LDA.B #$01                
                    STA.W $1602,X             
                    LDA.W $1540,X             
                    BNE ADDR_02DCFE           
                    STZ.W $1602,X             
                    LDA.B #$03                
ADDR_02DCF9:        STA.W $1540,X             
                    INC $C2,X                 
ADDR_02DCFE:        RTS                       ; Return 

ADDR_02DCFF:        LDA.W $1540,X             
                    BNE ADDR_02DD0B           
                    INC.W $1602,X             
                    LDA.B #$03                
                    BRA ADDR_02DCF9           
ADDR_02DD0B:        RTS                       ; Return 


DATA_02DD0C:        .db $20,$E0

ADDR_02DD0E:        LDA.W $1558,X             
                    BNE ADDR_02DD45           
                    LDY.W $157C,X             
                    LDA.W DATA_02DD0C,Y       
                    STA $B6,X                 
                    LDA.W $1540,X             
                    BNE ADDR_02DD44           
                    INC.W $1570,X             
                    LDA.W $1570,X             
                    AND.B #$01                
                    BNE ADDR_02DD2F           
                    LDA.B #$20                
                    STA.W $1558,X             
ADDR_02DD2F:        LDA.W $1570,X             
                    CMP.B #$03                
                    BNE ADDR_02DD3D           
                    STZ.W $1570,X             
                    LDA.B #$70                
                    BRA ADDR_02DCF9           
ADDR_02DD3D:        LDA.B #$03                
ADDR_02DD3F:        JSR.W ADDR_02DCF9         
                    STZ $C2,X                 
ADDR_02DD44:        RTS                       ; Return 

ADDR_02DD45:        LDA.B #$01                
                    STA.W $1602,X             
                    RTS                       ; Return 

ADDR_02DD4B:        LDA.B #$03                
                    LDY.W $1540,X             
                    BEQ ADDR_02DD81           
                    CPY.B #$2E                
                    BNE ADDR_02DD6F           
                    PHA                       
                    LDA.W $15A0,X             
                    ORA.W $186C,X             
                    BNE ADDR_02DD6E           
                    LDA.B #$30                
                    STA.W $1887               
                    LDA.B #$09                
                    STA.W $1DFC               ; / Play sound effect 
                    PHY                       
                    JSR.W ADDR_02DD8F         
                    PLY                       
ADDR_02DD6E:        PLA                       
ADDR_02DD6F:        CPY.B #$30                
                    BCC ADDR_02DD7D           
                    CPY.B #$50                
                    BCS ADDR_02DD7D           
                    INC A                     
                    CPY.B #$44                
                    BCS ADDR_02DD7D           
                    INC A                     
ADDR_02DD7D:        STA.W $1602,X             
                    RTS                       ; Return 

ADDR_02DD81:        LDA.W $157C,X             
                    EOR.B #$01                
                    STA.W $157C,X             
                    LDA.B #$40                
                    JSR.W ADDR_02DD3F         
                    RTS                       ; Return 

ADDR_02DD8F:        JSL.L ADDR_02A9E4         
                    BMI ADDR_02DDC5           
                    LDA.B #$2B                
                    STA.W $009E,Y             
                    LDA.B #$08                
                    STA.W $14C8,Y             
                    LDA $E4,X                 
                    ADC.B #$04                
                    STA.W $00E4,Y             
                    LDA.W $14E0,X             
                    ADC.B #$00                
                    STA.W $14E0,Y             
                    LDA $D8,X                 
                    STA.W $00D8,Y             
                    LDA.W $14D4,X             
                    STA.W $14D4,Y             
                    PHX                       
                    TYX                       
                    JSL.L ADDR_07F7D2         
                    LDA.B #$10                
                    STA.W $1FE2,X             
                    PLX                       
ADDR_02DDC5:        RTS                       ; Return 


DATA_02DDC6:        .db $FF,$07,$FC,$04,$FF,$07,$FC,$04
                    .db $FF,$FF,$FC,$04,$FF,$FF,$FC,$04
                    .db $02,$02,$F4,$04,$02,$02,$F4,$04
                    .db $09,$01,$04,$FC,$09,$01,$04,$FC
                    .db $01,$01,$04,$FC,$01,$01,$04,$FC
                    .db $FF,$FF,$0C,$FC,$FF,$FF,$0C,$FC
DATA_02DDF6:        .db $F8,$F8,$00,$00,$F8,$F8,$00,$00
                    .db $F8,$F0,$00,$00,$F8,$F8,$00,$00
                    .db $F8,$F8,$01,$00,$F8,$F8,$FF,$00
SumoBrosTiles:      .db $98,$99,$A7,$A8,$98,$99,$AA,$AB
                    .db $8A,$66,$AA,$AB,$EE,$EE,$C5,$C6
                    .db $80,$80,$C1,$C3,$80,$80,$C1,$C3
DATA_02DE26:        .db $00,$00,$02,$02,$00,$00,$02,$02
                    .db $02,$02,$02,$02,$02,$02,$02,$02
                    .db $02,$02,$02,$02,$02,$02,$02,$02

ADDR_02DE3E:        JSR.W GetDrawInfo2        
                    LDA.W $157C,X             
                    LSR                       
                    ROR                       
                    ROR                       
                    AND.B #$40                
                    EOR.B #$40                
                    STA $02                   
                    LDY.W $15EA,X             
                    LDA.W $1602,X             
                    ASL                       
                    ASL                       
                    PHX                       
                    TAX                       
                    LDA.B #$03                
                    STA $05                   
ADDR_02DE5B:        PHX                       
                    LDA $02                   
                    BEQ ADDR_02DE65           
                    TXA                       
                    CLC                       
                    ADC.B #$18                
                    TAX                       
ADDR_02DE65:        LDA $00                   
                    CLC                       
                    ADC.W DATA_02DDC6,X       
                    STA.W $0300,Y             
                    PLX                       
                    LDA $01                   
                    CLC                       
                    ADC.W DATA_02DDF6,X       
                    STA.W $0301,Y             
                    LDA.W SumoBrosTiles,X     
                    STA.W $0302,Y             
                    CMP.B #$66                
                    SEC                       
                    BNE ADDR_02DE84           
                    CLC                       
ADDR_02DE84:        LDA.B #$34                
                    ADC $02                   
                    STA.W $0303,Y             
                    PHY                       
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_02DE26,X       
                    STA.W $0460,Y             
                    PLY                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    INX                       
                    DEC $05                   
                    BPL ADDR_02DE5B           
                    PLX                       
                    LDY.B #$FF                
                    LDA.B #$03                
                    JMP.W ADDR_02B7A7         
ADDR_02DEA8:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02DEB0         
                    PLB                       
                    RTL                       ; Return 

ADDR_02DEB0:        LDA.W $1540,X             
                    BNE ADDR_02DEFC           
                    LDA.B #$30                
                    STA $AA,X                 
                    JSR.W ADDR_02D294         
                    LDA.W $1FE2,X             
                    BNE ADDR_02DEEA           
                    JSL.L ADDR_019138         
                    LDA.W $1588,X             
                    AND.B #$04                
                    BEQ ADDR_02DEEA           
                    LDA.B #$17                
                    STA.W $1DFC               ; / Play sound effect 
                    LDA.B #$22                
                    STA.W $1540,X             
                    LDA.W $15A0,X             
                    ORA.W $186C,X             
                    BNE ADDR_02DEEA           
                    LDA $E4,X                 
                    STA $9A                   
                    LDA $D8,X                 
                    STA $98                   
                    JSL.L ADDR_028A44         
ADDR_02DEEA:        LDA.B #$00                
                    JSL.L ADDR_018042         
                    LDY.W $15EA,X             
                    LDA.W $0307,Y             
                    EOR.B #$C0                
                    STA.W $0307,Y             
                    RTS                       ; Return 

ADDR_02DEFC:        STA $02                   
                    CMP.B #$01                
                    BNE ADDR_02DF05           
                    STZ.W $14C8,X             
ADDR_02DF05:        AND.B #$0F                
                    CMP.B #$01                
                    BNE ADDR_02DF21           
                    STA.W $18B8               
                    JSR.W ADDR_02DF2C         
                    INC.W $1570,X             
                    LDA.W $1570,X             
                    CMP.B #$01                
                    BEQ ADDR_02DF21           
                    JSR.W ADDR_02DF2C         
                    INC.W $1570,X             
ADDR_02DF21:        RTS                       ; Return 


DATA_02DF22:        .db $FC,$0C,$EC,$1C,$DC

DATA_02DF27:        .db $FF,$00,$FF,$00,$FF

ADDR_02DF2C:        LDA $E4,X                 
                    STA $00                   
                    LDA.W $14E0,X             
                    STA $01                   
                    LDY.B #$09                
ADDR_02DF37:        LDA.W $1892,Y             
                    BEQ ADDR_02DF4C           
                    DEY                       
                    BPL ADDR_02DF37           
                    DEC.W $191D               
                    BPL ADDR_02DF49           
                    LDA.B #$09                
                    STA.W $191D               
ADDR_02DF49:        LDY.W $191D               
ADDR_02DF4C:        PHX                       
                    LDA.W $1570,X             
                    TAX                       
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_02DF22,X       
                    STA.W $1E16,Y             
                    LDA $01                   
                    ADC.W DATA_02DF27,X       
                    STA.W $1E3E,Y             
                    PLX                       
                    LDA $D8,X                 
                    SEC                       
                    SBC.B #$10                
                    STA.W $1E02,Y             
                    LDA.W $14D4,X             
                    SEC                       
                    SBC.B #$00                
                    STA.W $1E2A,Y             
                    LDA.B #$7F                
                    STA.W $0F4A,Y             
                    LDA.W $1E16,Y             
                    CMP $1A                   
                    LDA.W $1E3E,Y             
                    SBC $1B                   
                    BNE ADDR_02DF8A           
                    LDA.B #$06                
                    STA.W $1892,Y             
ADDR_02DF8A:        RTS                       ; Return 

ADDR_02DF8B:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02DF93         
                    PLB                       
                    RTL                       ; Return 

ADDR_02DF93:        JSR.W ADDR_02E00B         
                    LDA $9D                   
                    BNE ADDR_02DFC8           
                    STZ.W $151C,X             
                    JSL.L ADDR_01803A         
                    JSR.W ADDR_02D025         
                    JSR.W ADDR_02D294         
                    LDA $AA,X                 
                    CMP.B #$40                
                    BPL ADDR_02DFAF           
                    INC $AA,X                 
ADDR_02DFAF:        JSL.L ADDR_019138         
                    LDA.W $1588,X             
                    AND.B #$04                
                    BEQ ADDR_02DFBC           
                    STZ $AA,X                 
ADDR_02DFBC:        LDA $C2,X                 
                    JSL.L ExecutePtr          

Ptrs02DFC2:         .dw ADDR_02DFC9           
                    .dw ADDR_02DFDF           
                    .dw ADDR_02DFEF           

ADDR_02DFC8:        RTS                       ; Return 

ADDR_02DFC9:        LDA.W $1540,X             
                    BNE ADDR_02DFD6           
                    LDA.B #$40                
ADDR_02DFD0:        STA.W $1540,X             
                    INC $C2,X                 
                    RTS                       ; Return 

ADDR_02DFD6:        LSR                       
                    LSR                       
                    LSR                       
                    AND.B #$01                
                    STA.W $1602,X             
                    RTS                       ; Return 

ADDR_02DFDF:        LDA.W $1540,X             
                    BNE ADDR_02DFE8           
                    LDA.B #$40                
                    BRA ADDR_02DFD0           
ADDR_02DFE8:        LSR                       
                    AND.B #$01                
                    STA.W $151C,X             
                    RTS                       ; Return 

ADDR_02DFEF:        LDA.W $1540,X             
                    BNE ADDR_02DFFB           
                    LDA.B #$80                
                    JSR.W ADDR_02DFD0         
                    STZ $C2,X                 
ADDR_02DFFB:        CMP.B #$38                
                    BNE ADDR_02E002           
                    JSR.W ADDR_02E079         
ADDR_02E002:        LDA.B #$02                
                    STA.W $1602,X             
                    RTS                       ; Return 


VolcanoLotusTiles:  .db $8E,$9E,$E2

ADDR_02E00B:        JSR.W ADDR_02E57E         
                    LDY.W $15EA,X             
                    LDA.B #$CE                
                    STA.W $0302,Y             
                    STA.W $0306,Y             
                    LDA.W $0303,Y             
                    AND.B #$30                
                    ORA.B #$0B                
                    STA.W $0303,Y             
                    ORA.B #$40                
                    STA.W $0307,Y             
                    LDA.W $0300,Y             
                    CLC                       
                    ADC.B #$08                
                    STA.W $0308,Y             
                    CLC                       
                    ADC.B #$08                
                    STA.W $030C,Y             
                    LDA.W $0301,Y             
                    STA.W $0309,Y             
                    STA.W $030D,Y             
                    PHX                       
                    LDA.W $1602,X             
                    TAX                       
                    LDA.W VolcanoLotusTiles,X 
                    STA.W $030A,Y             
                    INC A                     
                    STA.W $030E,Y             
                    PLX                       
                    LDA.W $151C,X             
                    CMP.B #$01                
                    LDA.B #$39                
                    BCC ADDR_02E05B           
                    LDA.B #$35                
ADDR_02E05B:        STA.W $030B,Y             
                    STA.W $030F,Y             
                    LDA.W $15EA,X             
                    CLC                       
                    ADC.B #$08                
                    STA.W $15EA,X             
                    LDY.B #$00                
                    LDA.B #$01                
                    JMP.W ADDR_02B7A7         

DATA_02E071:        .db $10,$F0,$06,$FA

DATA_02E075:        .db $EC,$EC,$E8,$E8

ADDR_02E079:        LDA.W $15A0,X             
                    ORA.W $186C,X             
                    BNE ADDR_02E0C4           
                    LDA.B #$03                
                    STA $00                   
ADDR_02E085:        LDY.B #$07                
ADDR_02E087:        LDA.W $170B,Y             
                    BEQ ADDR_02E090           
                    DEY                       
                    BPL ADDR_02E087           
                    RTS                       ; Return 

ADDR_02E090:        LDA.B #$0C                
                    STA.W $170B,Y             
                    LDA $E4,X                 
                    CLC                       
                    ADC.B #$04                
                    STA.W $171F,Y             
                    LDA.W $14E0,X             
                    ADC.B #$00                
                    STA.W $1733,Y             
                    LDA $D8,X                 
                    STA.W $1715,Y             
                    LDA.W $14D4,X             
                    STA.W $1729,Y             
                    PHX                       
                    LDX $00                   
                    LDA.W DATA_02E071,X       
                    STA.W $1747,Y             
                    LDA.W DATA_02E075,X       
                    STA.W $173D,Y             
                    PLX                       
                    DEC $00                   
                    BPL ADDR_02E085           
ADDR_02E0C4:        RTS                       ; Return 

ADDR_02E0C5:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02E0CD         
                    PLB                       
                    RTL                       ; Return 

ADDR_02E0CD:        JSL.L ADDR_07F78B         
                    LDA $64                   
                    PHA                       
                    LDA.B #$10                
                    STA $64                   
                    LDA.W $1570,X             
                    AND.B #$08                
                    LSR                       
                    LSR                       
                    EOR.B #$02                
                    STA.W $1602,X             
                    JSL.L GenericSprGfxRt     
                    LDA.W $15EA,X             
                    CLC                       
                    ADC.B #$04                
                    STA.W $15EA,X             
                    LDA.W $151C,X             
                    AND.B #$04                
                    LSR                       
                    LSR                       
                    INC A                     
                    STA.W $1602,X             
                    LDA $D8,X                 
                    PHA                       
                    CLC                       
                    ADC.B #$08                
                    STA $D8,X                 
                    LDA.W $14D4,X             
                    PHA                       
                    ADC.B #$00                
                    STA.W $14D4,X             
                    LDA.B #$0A                
                    STA.W $15F6,X             
                    LDA.B #$01                
                    JSL.L ADDR_018042         
                    PLA                       
                    STA.W $14D4,X             
                    PLA                       
                    STA $D8,X                 
                    PLA                       
                    STA $64                   
                    LDA $9D                   
                    BNE ADDR_02E158           
                    JSR.W ADDR_02D025         
                    JSL.L ADDR_01803A         
                    JSR.W ADDR_02D294         
                    LDA $C2,X                 
                    JSL.L ExecutePtr          

Ptrs02E136:         .dw ADDR_02E13C           
                    .dw ADDR_02E159           
                    .dw ADDR_02E177           

ADDR_02E13C:        STZ $AA,X                 
                    LDA.W $1540,X             
                    BNE ADDR_02E158           
                    JSR.W ADDR_02D4FA         
                    LDA $0F                   
                    CLC                       
                    ADC.B #$1B                
                    CMP.B #$37                
                    BCC ADDR_02E158           
                    LDA.B #$C0                
                    STA $AA,X                 
                    INC $C2,X                 
                    STZ.W $1602,X             
ADDR_02E158:        RTS                       ; Return 

ADDR_02E159:        LDA $AA,X                 
                    BMI ADDR_02E161           
                    CMP.B #$40                
                    BCS ADDR_02E166           
ADDR_02E161:        CLC                       
                    ADC.B #$02                
                    STA $AA,X                 
ADDR_02E166:        INC.W $1570,X             
                    LDA $AA,X                 
                    CMP.B #$F0                
                    BMI ADDR_02E176           
                    LDA.B #$50                
                    STA.W $1540,X             
                    INC $C2,X                 
ADDR_02E176:        RTS                       ; Return 

ADDR_02E177:        INC.W $151C,X             
                    LDA.W $1540,X             
                    BNE ADDR_02E1A4           
ADDR_02E17F:        INC.W $1570,X             
                    LDA $14                   
                    AND.B #$03                
                    BNE ADDR_02E191           
                    LDA $AA,X                 
                    CMP.B #$08                
                    BPL ADDR_02E191           
                    INC A                     
                    STA $AA,X                 
ADDR_02E191:        JSL.L ADDR_019138         
                    LDA.W $1588,X             
                    AND.B #$04                
                    BEQ ADDR_02E176           
                    STZ $C2,X                 
                    LDA.B #$40                
                    STA.W $1540,X             
                    RTS                       ; Return 

ADDR_02E1A4:        LDY $9E,X                 
                    CPY.B #$50                
                    BNE ADDR_02E1F7           
                    STZ.W $1570,X             
                    CMP.B #$40                
                    BNE ADDR_02E1F7           
                    LDA.W $15A0,X             
                    ORA.W $186C,X             
                    BNE ADDR_02E1F7           
                    LDA.B #$10                
                    JSR.W ADDR_02E1C0         
                    LDA.B #$F0                
ADDR_02E1C0:        STA $00                   
                    LDY.B #$07                
ADDR_02E1C4:        LDA.W $170B,Y             
                    BEQ ADDR_02E1CD           
                    DEY                       
                    BPL ADDR_02E1C4           
                    RTS                       ; Return 

ADDR_02E1CD:        LDA.B #$0B                
                    STA.W $170B,Y             
                    LDA $E4,X                 
                    CLC                       
                    ADC.B #$04                
                    STA.W $171F,Y             
                    LDA.W $14E0,X             
                    ADC.B #$00                
                    STA.W $1733,Y             
                    LDA $D8,X                 
                    STA.W $1715,Y             
                    LDA.W $14D4,X             
                    STA.W $1729,Y             
                    LDA.B #$D0                
                    STA.W $173D,Y             
                    LDA $00                   
                    STA.W $1747,Y             
ADDR_02E1F7:        BRA ADDR_02E17F           

DATA_02E1F9:        .db $00,$00,$F0,$10

DATA_02E1FD:        .db $F0,$10,$00,$00

DATA_02E201:        .db $00,$03,$02,$00,$01,$03,$02,$00
                    .db $00,$03,$02,$00,$00,$00,$00,$00
DATA_02E211:        .db $01,$00,$03,$02

ADDR_02E215:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02E21D         
                    PLB                       
                    RTL                       ; Return 

ADDR_02E21D:        LDA $64                   
                    PHA                       
                    LDA.W $1540,X             
                    CMP.B #$30                
                    BCC ADDR_02E22B           
                    LDA.B #$10                
                    STA $64                   
ADDR_02E22B:        LDA $1C                   
                    PHA                       
                    CLC                       
                    ADC.B #$01                
                    STA $1C                   
                    LDA $1D                   
                    PHA                       
                    ADC.B #$00                
                    STA $1D                   
                    LDA.W $14AD               
                    BNE ADDR_02E245           
                    JSL.L ADDR_01C641         
                    BRA ADDR_02E259           
ADDR_02E245:        JSL.L GenericSprGfxRt     
                    LDY.W $15EA,X             
                    LDA.B #$2E                
                    STA.W $0302,Y             
                    LDA.W $0303,Y             
                    AND.B #$3F                
                    STA.W $0303,Y             
ADDR_02E259:        PLA                       
                    STA $1D                   
                    PLA                       
                    STA $1C                   
                    PLA                       
                    STA $64                   
                    LDA $9D                   
                    BNE ADDR_02E2DE           
                    LDA $13                   
                    AND.B #$03                
                    BNE ADDR_02E288           
                    DEC.W $190C               
                    BNE ADDR_02E288           
ADDR_02E271:        STZ.W $190C               
                    STZ.W $14C8,X             
                    LDA.W $14AD               
                    ORA.W $14AE               
                    BNE ADDR_02E287           
                    LDA.W $0DDA               
                    BMI ADDR_02E287           
                    STA.W $1DFB               ; / Play sound effect 
ADDR_02E287:        RTS                       ; Return 

ADDR_02E288:        LDY $C2,X                 
                    LDA.W DATA_02E1F9,Y       
                    STA $B6,X                 
                    LDA.W DATA_02E1FD,Y       
                    STA $AA,X                 
                    JSR.W ADDR_02D294         
                    JSR.W ADDR_02D288         
                    LDA $15                   
                    AND.B #$0F                
                    BEQ ADDR_02E2B0           
                    TAY                       
                    LDA.W DATA_02E201,Y       
                    TAY                       
                    LDA.W DATA_02E211,Y       
                    CMP $C2,X                 
                    BEQ ADDR_02E2B0           
                    TYA                       
                    STA.W $151C,X             
ADDR_02E2B0:        LDA $D8,X                 
                    AND.B #$0F                
                    STA $00                   
                    LDA $E4,X                 
                    AND.B #$0F                
                    ORA $00                   
                    BNE ADDR_02E2DE           
                    LDA.W $151C,X             
                    STA $C2,X                 
                    LDA $E4,X                 
                    STA $9A                   
                    LDA.W $14E0,X             
                    STA $9B                   
                    LDA $D8,X                 
                    STA $98                   
                    LDA.W $14D4,X             
                    STA $99                   
                    LDA.B #$06                
                    STA $9C                   
                    JSL.L ADDR_00BEB0         
                    RTS                       ; Return 

ADDR_02E2DE:        JSL.L ADDR_019138         
                    LDA $B6,X                 
                    BNE ADDR_02E2F3           
                    LDA.W $18D7               
                    BNE ADDR_02E2FF           
                    LDA.W $185F               
                    CMP.B #$25                
                    BNE ADDR_02E2FF           
                    RTS                       ; Return 

ADDR_02E2F3:        LDA.W $1862               
                    BNE ADDR_02E2FF           
                    LDA.W $1860               
                    CMP.B #$25                
                    BEQ ADDR_02E302           
ADDR_02E2FF:        JSR.W ADDR_02E271         
ADDR_02E302:        RTS                       ; Return 

ADDR_02E303:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02E311         
                    PLB                       
                    RTL                       ; Return 


DATA_02E30B:        .db $10,$F0

DATA_02E30D:        .db $01,$FF

DATA_02E30F:        .db $10,$F0

ADDR_02E311:        JSR.W ADDR_02E3AA         
                    LDA $9D                   
                    BNE ADDR_02E351           
                    LDA.W $14C8,X             
                    CMP.B #$08                
                    BNE ADDR_02E351           
                    LDY.W $157C,X             
                    LDA.W DATA_02E30B,Y       
                    STA $B6,X                 
                    JSR.W ADDR_02D288         
                    LDA $13                   
                    AND.B #$03                
                    BNE ADDR_02E344           
                    LDA $C2,X                 
                    AND.B #$01                
                    TAY                       
                    LDA $AA,X                 
                    CLC                       
                    ADC.W DATA_02E30D,Y       
                    STA $AA,X                 
                    CMP.W DATA_02E30F,Y       
                    BNE ADDR_02E344           
                    INC $C2,X                 
ADDR_02E344:        JSR.W ADDR_02D294         
                    INC.W $1570,X             
                    JSR.W ADDR_02D025         
                    JSL.L MarioSprInteract    
ADDR_02E351:        RTS                       ; Return 


DATA_02E352:        .db $00,$10,$20,$30,$00,$10,$20,$30
                    .db $00,$10,$20,$30,$00,$10,$20,$30
DATA_02E362:        .db $00,$00,$00,$00,$10,$10,$10,$10
                    .db $20,$20,$20,$20,$30,$30,$30,$30
DATA_02E372:        .db $80,$82,$84,$86,$A0,$A2,$A4,$A6
                    .db $A0,$A2,$A4,$A6,$80,$82,$84,$86
DATA_02E382:        .db $3B,$3B,$3B,$3B,$3B,$3B,$3B,$3B
                    .db $BB,$BB,$BB,$BB,$BB,$BB,$BB,$BB
DATA_02E392:        .db $00,$00,$02,$02,$00,$00,$02,$02
                    .db $01,$01,$03,$03,$01,$01,$03,$03
DATA_02E3A2:        .db $00,$01,$02,$01

DATA_02E3A6:        .db $02,$01,$00,$01

ADDR_02E3AA:        JSR.W GetDrawInfo2        
                    LDA.W $1570,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.B #$03                
                    TAY                       
                    LDA.W DATA_02E3A2,Y       
                    STA $02                   
                    LDA.W DATA_02E3A6,Y       
                    STA $03                   
                    LDY.W $15EA,X             
                    PHX                       
                    LDX.B #$0F                
ADDR_02E3C6:        LDA $00                   
                    CLC                       
                    ADC.W DATA_02E352,X       
                    PHA                       
                    LDA.W DATA_02E392,X       
                    AND.B #$02                
                    BNE ADDR_02E3DA           
                    PLA                       
                    CLC                       
                    ADC $02                   
                    BRA ADDR_02E3DE           
ADDR_02E3DA:        PLA                       
                    SEC                       
                    SBC $02                   
ADDR_02E3DE:        STA.W $0300,Y             
                    LDA $01                   
                    CLC                       
                    ADC.W DATA_02E362,X       
                    PHA                       
                    LDA.W DATA_02E392,X       
                    AND.B #$01                
                    BNE ADDR_02E3F5           
                    PLA                       
                    CLC                       
                    ADC $03                   
                    BRA ADDR_02E3F9           
ADDR_02E3F5:        PLA                       
                    SEC                       
                    SBC $03                   
ADDR_02E3F9:        STA.W $0301,Y             
                    LDA.W DATA_02E372,X       
                    STA.W $0302,Y             
                    LDA.W DATA_02E382,X       
                    STA.W $0303,Y             
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_02E3C6           
                    PLX                       
                    LDY.B #$02                
                    LDA.B #$0F                
                    JMP.W ADDR_02B7A7         
ADDR_02E417:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02E41F         
                    PLB                       
                    RTL                       ; Return 

ADDR_02E41F:        JSL.L GenericSprGfxRt     
                    LDA $9D                   
                    BNE ADDR_02E462           
                    BRA ADDR_02E42D           
                    JSL.L ADDR_02C0CF         
ADDR_02E42D:        LDY.B #$00                
                    INC.W $1570,X             
                    LDA.W $1570,X             
                    AND.B #$40                
                    BEQ ADDR_02E444           
                    LDY.B #$04                
                    LDA.W $1570,X             
                    AND.B #$04                
                    BEQ ADDR_02E444           
                    LDY.B #$FC                
ADDR_02E444:        STY $B6,X                 
                    JSR.W ADDR_02D288         
                    JSL.L ADDR_01803A         
                    JSR.W ADDR_02D4FA         
                    LDA $0F                   
                    CLC                       
                    ADC.B #$60                
                    CMP.B #$C0                
                    BCS ADDR_02E462           
                    LDY.W $15A0,X             
                    BNE ADDR_02E462           
                    JSL.L ADDR_02E463         
ADDR_02E462:        RTS                       ; Return 

ADDR_02E463:        LDA $C2,X                 
                    STA $9E,X                 
                    JSL.L ADDR_07F7D2         
                    LDA.B #$D0                
                    STA $AA,X                 
                    JSR.W ADDR_02D4FA         
                    TYA                       
                    STA.W $157C,X             
                    LDA $E4,X                 
                    STA $9A                   
                    LDA.W $14E0,X             
                    STA $9B                   
                    LDA $D8,X                 
                    STA $98                   
                    LDA.W $14D4,X             
                    STA $99                   
                    PHB                       
                    LDA.B #$02                
                    PHA                       
                    PLB                       
                    LDA.B #$00                
                    JSL.L ShatterBlock        
                    PLB                       
                    RTL                       ; Return 

ADDR_02E495:        LDA.W $15EA,X             
                    PHA                       
                    PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02E4A5         
                    PLB                       
                    PLA                       
                    STA.W $15EA,X             
                    RTL                       ; Return 

ADDR_02E4A5:        JSR.W ADDR_02D01B         
                    STZ.W $185E               
                    LDA $E4,X                 
                    PHA                       
                    LDA.W $14E0,X             
                    PHA                       
                    LDA $D8,X                 
                    PHA                       
                    LDA.W $14D4,X             
                    PHA                       
                    LDA.W $151C,X             
                    STA.W $14D4,X             
                    LDA.W $1534,X             
                    STA $D8,X                 
                    LDA $C2,X                 
                    STA $E4,X                 
                    LDA.W $1602,X             
                    STA.W $14E0,X             
                    LDY.B #$02                
                    JSR.W ADDR_02E524         
                    PLA                       
                    STA.W $14D4,X             
                    PLA                       
                    STA $D8,X                 
                    PLA                       
                    STA.W $14E0,X             
                    PLA                       
                    STA $E4,X                 
                    BCC ADDR_02E4EB           
                    INC.W $185E               
                    LDA.B #$F8                
                    JSR.W ADDR_02E559         
ADDR_02E4EB:        LDA.W $15EA,X             
                    CLC                       
                    ADC.B #$08                
                    STA.W $15EA,X             
                    LDY.B #$00                
                    JSR.W ADDR_02E524         
                    BCC ADDR_02E503           
                    INC.W $185E               
                    LDA.B #$08                
                    JSR.W ADDR_02E559         
ADDR_02E503:        LDA.W $185E               
                    BNE ADDR_02E51F           
                    LDY.B #$02                
                    LDA $D8,X                 
                    CMP.W $1534,X             
                    BEQ ADDR_02E51F           
                    LDA.W $14D4,X             
                    SBC.W $151C,X             
                    BMI ADDR_02E51B           
                    LDY.B #$FE                
ADDR_02E51B:        TYA                       
                    JSR.W ADDR_02E559         
ADDR_02E51F:        RTS                       ; Return 


MushrmScaleTiles:   .db $02,$07,$07,$02

ADDR_02E524:        LDA $D8,X                 
                    AND.B #$0F                
                    BNE ADDR_02E54E           
                    LDA $AA,X                 
                    BEQ ADDR_02E54E           
                    LDA $AA,X                 
                    BPL ADDR_02E533           
                    INY                       
ADDR_02E533:        LDA.W MushrmScaleTiles,Y  
                    STA $9C                   
                    LDA $E4,X                 
                    STA $9A                   
                    LDA.W $14E0,X             
                    STA $9B                   
                    LDA $D8,X                 
                    STA $98                   
                    LDA.W $14D4,X             
                    STA $99                   
                    JSL.L ADDR_00BEB0         
ADDR_02E54E:        JSR.W ADDR_02E57E         
                    STZ.W $1528,X             
                    JSL.L InvisBlkMainRt      
                    RTS                       ; Return 

ADDR_02E559:        LDY $9D                   
                    BNE ADDR_02E57D           
                    PHA                       
                    JSR.W ADDR_02D294         
                    PLA                       
                    STA $AA,X                 
                    LDY.B #$00                
                    LDA.W $1491               
                    EOR.B #$FF                
                    INC A                     
                    BPL ADDR_02E56F           
                    DEY                       
ADDR_02E56F:        CLC                       
                    ADC.W $1534,X             
                    STA.W $1534,X             
                    TYA                       
                    ADC.W $151C,X             
                    STA.W $151C,X             
ADDR_02E57D:        RTS                       ; Return 

ADDR_02E57E:        JSR.W GetDrawInfo2        
                    LDA $00                   
                    SEC                       
                    SBC.B #$08                
                    STA.W $0300,Y             
                    CLC                       
                    ADC.B #$10                
                    STA.W $0304,Y             
                    LDA $01                   
                    DEC A                     
                    STA.W $0301,Y             
                    STA.W $0305,Y             
                    LDA.B #$80                
                    STA.W $0302,Y             
                    STA.W $0306,Y             
                    LDA.W $15F6,X             
                    ORA $64                   
                    STA.W $0303,Y             
                    ORA.B #$40                
                    STA.W $0307,Y             
                    LDA.B #$01                
                    LDY.B #$02                
                    JMP.W ADDR_02B7A7         
ADDR_02E5B4:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02E5BC         
                    PLB                       
                    RTL                       ; Return 

ADDR_02E5BC:        JSR.W ADDR_02D025         
                    LDA $9D                   
                    BNE ADDR_02E5D7           
                    INC.W $1570,X             
                    LDY.B #$10                
                    LDA.W $1570,X             
                    AND.B #$80                
                    BNE ADDR_02E5D1           
                    LDY.B #$F0                
ADDR_02E5D1:        TYA                       
                    STA $B6,X                 
                    JSR.W ADDR_02D288         
ADDR_02E5D7:        JSR.W ADDR_02E637         
                    JSR.W ADDR_02E5F7         
                    LDA.W $185C               
                    BEQ ADDR_02E5E8           
                    DEC A                     
                    CMP.W $15E9               
                    BNE ADDR_02E5F6           
ADDR_02E5E8:        JSL.L MarioSprInteract    
                    STZ.W $185C               
                    BCC ADDR_02E5F6           
                    INX                       
                    STX.W $185C               
                    DEX                       
ADDR_02E5F6:        RTS                       ; Return 

ADDR_02E5F7:        LDY.B #$0B                
ADDR_02E5F9:        CPY.W $15E9               
                    BEQ ADDR_02E633           
                    TYA                       
                    EOR $13                   
                    AND.B #$03                
                    BNE ADDR_02E633           
                    LDA.W $14C8,Y             
                    CMP.B #$08                
                    BCC ADDR_02E633           
                    LDA.W $15DC,Y             
                    BEQ ADDR_02E617           
                    DEC A                     
                    CMP.W $15E9               
                    BNE ADDR_02E633           
ADDR_02E617:        TYX                       
                    JSL.L ADDR_03B6E5         
                    LDX.W $15E9               
                    JSL.L ADDR_03B69F         
                    JSL.L ADDR_03B72B         
                    LDA.B #$00                
                    STA.W $15DC,Y             
                    BCC ADDR_02E633           
                    TXA                       
                    INC A                     
                    STA.W $15DC,Y             
ADDR_02E633:        DEY                       
                    BPL ADDR_02E5F9           
                    RTS                       ; Return 

ADDR_02E637:        JSR.W GetDrawInfo2        
                    PHX                       
                    LDX.B #$03                
ADDR_02E63D:        LDA $00                   
                    CLC                       
                    ADC.W DATA_02E666,X       
                    STA.W $0300,Y             
                    LDA $01                   
                    STA.W $0301,Y             
                    LDA.W MovingHoleTiles,X   
                    STA.W $0302,Y             
                    LDA.W DATA_02E66E,X       
                    STA.W $0303,Y             
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_02E63D           
                    PLX                       
                    LDA.B #$03                
                    LDY.B #$02                
                    JMP.W ADDR_02B7A7         

DATA_02E666:        .db $00,$08,$18,$20

MovingHoleTiles:    .db $EB,$EA,$EA,$EB

DATA_02E66E:        .db $71,$31,$31,$31

ADDR_02E672:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02E67A         
                    PLB                       
                    RTL                       ; Return 

ADDR_02E67A:        JSR.W GetDrawInfo2        
                    TYA                       
                    CLC                       
                    ADC.B #$08                
                    STA.W $15EA,X             
                    TAY                       
                    LDA $00                   
                    SEC                       
                    SBC.B #$0D                
                    STA.W $0300,Y             
                    SEC                       
                    SBC.B #$08                
                    STA.W $185E               
                    STA.W $0304,Y             
                    LDA $01                   
                    CLC                       
                    ADC.B #$02                
                    STA.W $0301,Y             
                    STA.W $18B6               
                    CLC                       
                    ADC.B #$40                
                    STA.W $0305,Y             
                    LDA.B #$AA                
                    STA.W $0302,Y             
                    LDA.B #$24                
                    STA.W $0306,Y             
                    LDA.B #$35                
                    STA.W $0303,Y             
                    LDA.B #$3A                
                    STA.W $0307,Y             
                    LDA.B #$01                
                    LDY.B #$02                
                    JSR.W ADDR_02B7A7         
                    LDA.W $15A0,X             
                    BNE ADDR_02E6EB           
                    LDY.W $15EA,X             
                    LDA $7E                   
                    SEC                       
                    SBC.W $0304,Y             
                    CLC                       
                    ADC.B #$0C                
                    CMP.B #$18                
                    BCS ADDR_02E6EB           
                    LDA $80                   
                    SEC                       
                    SBC.W $0305,Y             
                    CLC                       
                    ADC.B #$0C                
                    CMP.B #$18                
                    BCS ADDR_02E6EB           
                    STZ.W $151C,X             
                    JSL.L ADDR_00F388         
ADDR_02E6EB:        PHX                       
                    LDA.B #$38                
                    STA.W $15EA,X             
                    TAY                       
                    LDX.B #$07                
ADDR_02E6F4:        LDA.W $185E               
                    STA.W $0300,Y             
                    LDA.W $18B6               
                    STA.W $0301,Y             
                    CLC                       
                    ADC.B #$08                
                    STA.W $18B6               
                    LDA.B #$89                
                    STA.W $0302,Y             
                    LDA.B #$35                
                    STA.W $0303,Y             
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_02E6F4           
                    PLX                       
                    LDA.B #$07                
                    LDY.B #$00                
                    JMP.W ADDR_02B7A7         
ADDR_02E71F:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02E727         
                    PLB                       
                    RTL                       ; Return 

ADDR_02E727:        JSL.L GenericSprGfxRt     
                    LDA $9D                   
                    BNE ADDR_02E74B           
                    JSR.W ADDR_02D025         
                    JSL.L ADDR_01803A         
                    JSL.L ADDR_019138         
                    LDY.B #$00                
                    JSR.W ADDR_02EB3D         
                    LDA $C2,X                 
                    AND.B #$01                
                    JSL.L ExecutePtr          

Ptrs02E747:         .dw ADDR_02E74E           
                    .dw ADDR_02E788           

ADDR_02E74B:        RTS                       ; Return 


DATA_02E74C:        .db $14,$EC

ADDR_02E74E:        LDY.W $157C,X             
                    LDA.W DATA_02E74C,Y       
                    STA $B6,X                 
                    JSR.W ADDR_02D288         
                    LDA.W $1540,X             
                    BNE ADDR_02E77B           
                    INC.W $1570,X             
                    LDY.W $1570,X             
                    CPY.B #$04                
                    BEQ ADDR_02E77C           
                    LDA.W $157C,X             
                    EOR.B #$01                
                    STA.W $157C,X             
                    LDA.B #$20                
                    CPY.B #$03                
                    BEQ ADDR_02E778           
                    LDA.B #$40                
ADDR_02E778:        STA.W $1540,X             
ADDR_02E77B:        RTS                       ; Return 

ADDR_02E77C:        INC $C2,X                 
                    LDA.B #$80                
                    STA.W $1540,X             
                    LDA.B #$A0                
                    STA $AA,X                 
                    RTS                       ; Return 

ADDR_02E788:        LDA.W $1540,X             
                    BEQ ADDR_02E7A4           
                    CMP.B #$70                
                    BCS ADDR_02E7A3           
                    STZ $B6,X                 
                    JSR.W ADDR_02D294         
                    LDA $AA,X                 
                    BMI ADDR_02E79E           
                    CMP.B #$30                
                    BCS ADDR_02E7A3           
ADDR_02E79E:        CLC                       
                    ADC.B #$02                
                    STA $AA,X                 
ADDR_02E7A3:        RTS                       ; Return 

ADDR_02E7A4:        LDA $D8,X                 
                    AND.B #$F0                
                    STA $D8,X                 
                    INC $C2,X                 
                    STZ.W $1570,X             
                    LDA.B #$20                
                    STA.W $1540,X             
                    RTS                       ; Return 

ADDR_02E7B5:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02E7BD         
                    PLB                       
                    RTL                       ; Return 

ADDR_02E7BD:        LDA $64                   
                    PHA                       
                    LDA.W $1540,X             
                    BEQ ADDR_02E7C9           
                    LDA.B #$10                
                    STA $64                   
ADDR_02E7C9:        JSL.L GenericSprGfxRt     
                    PLA                       
                    STA $64                   
                    LDA $9D                   
                    BNE ADDR_02E82C           
                    LDA.W $1540,X             
                    CMP.B #$08                
                    BCS ADDR_02E82C           
                    LDY.B #$00                
                    LDA $13                   
                    LSR                       
                    JSR.W ADDR_02EB3D         
                    JSR.W ADDR_02D025         
                    JSL.L UpdateSpritePos     
                    LDA.W $1540,X             
                    BNE ADDR_02E828           
                    LDA.W $1588,X             
                    AND.B #$03                
                    BEQ ADDR_02E7FD           
                    LDA $B6,X                 
                    EOR.B #$FF                
                    INC A                     
                    STA $B6,X                 
ADDR_02E7FD:        LDA.W $1588,X             
                    AND.B #$08                
                    BEQ ADDR_02E808           
                    LDA.B #$10                
                    STA $AA,X                 
ADDR_02E808:        LDA.W $1588,X             
                    AND.B #$04                
                    BEQ ADDR_02E828           
                    LDA $AA,X                 
                    CMP.B #$38                
                    LDA.B #$E0                
                    BCC ADDR_02E819           
                    LDA.B #$D0                
ADDR_02E819:        STA $AA,X                 
                    LDA.B #$08                
                    LDY.W $15B8,X             
                    BEQ ADDR_02E828           
                    BPL ADDR_02E826           
                    LDA.B #$F8                
ADDR_02E826:        STA $B6,X                 
ADDR_02E828:        JSL.L ADDR_01803A         
ADDR_02E82C:        RTS                       ; Return 

ADDR_02E82D:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02E845         
                    PLB                       
                    RTL                       ; Return 


DATA_02E835:        .db $00,$F0,$00,$10

DATA_02E839:        .db $20,$40,$20,$40

GrowingPipeTiles1:  .db $00,$14,$00,$02

GrowingPipeTiles2:  .db $00,$15,$00,$02

ADDR_02E845:        LDA.W $1534,X             
                    BMI ADDR_02E872           
                    LDA $D8,X                 
                    PHA                       
                    SEC                       
                    SBC.W $1534,X             
                    STA $D8,X                 
                    LDA.W $14D4,X             
                    PHA                       
                    SBC.B #$00                
                    STA.W $14D4,X             
                    LDY.B #$03                
                    JSR.W ADDR_02E8BA         
                    PLA                       
                    STA.W $14D4,X             
                    PLA                       
                    STA $D8,X                 
                    LDA.W $1534,X             
                    SEC                       
                    SBC.B #$10                
                    STA.W $1534,X             
                    RTS                       ; Return 

ADDR_02E872:        JSR.W ADDR_02E902         
                    JSR.W ADDR_02D025         
                    LDA $9D                   
                    ORA.W $15A0,X             
                    BNE ADDR_02E8B5           
                    JSR.W ADDR_02D4FA         
                    LDA $0F                   
                    CLC                       
                    ADC.B #$50                
                    CMP.B #$A0                
                    BCS ADDR_02E8B5           
                    LDA $C2,X                 
                    AND.B #$03                
                    TAY                       
                    INC.W $1570,X             
                    LDA.W $1570,X             
                    CMP.W DATA_02E839,Y       
                    BNE ADDR_02E8A2           
                    STZ.W $1570,X             
                    INC $C2,X                 
                    BRA ADDR_02E8B5           
ADDR_02E8A2:        LDA.W DATA_02E835,Y       
                    STA $AA,X                 
                    BEQ ADDR_02E8B2           
                    LDA $D8,X                 
                    AND.B #$0F                
                    BNE ADDR_02E8B2           
                    JSR.W ADDR_02E8BA         
ADDR_02E8B2:        JSR.W ADDR_02D294         
ADDR_02E8B5:        JSL.L InvisBlkMainRt      
                    RTS                       ; Return 

ADDR_02E8BA:        LDA.W GrowingPipeTiles1,Y 
                    STA.W $185E               
                    LDA.W GrowingPipeTiles2,Y 
                    STA.W $18B6               
                    LDA.W $185E               
                    STA $9C                   
                    LDA $E4,X                 
                    STA $9A                   
                    LDA.W $14E0,X             
                    STA $9B                   
                    LDA $D8,X                 
                    STA $98                   
                    LDA.W $14D4,X             
                    STA $99                   
                    JSL.L ADDR_00BEB0         
                    LDA.W $18B6               
                    STA $9C                   
                    LDA $E4,X                 
                    CLC                       
                    ADC.B #$10                
                    STA $9A                   
                    LDA.W $14E0,X             
                    ADC.B #$00                
                    STA $9B                   
                    LDA $D8,X                 
                    STA $98                   
                    LDA.W $14D4,X             
                    STA $99                   
                    JSL.L ADDR_00BEB0         
                    RTS                       ; Return 

ADDR_02E902:        JSR.W GetDrawInfo2        
                    LDA $00                   
                    STA.W $0300,Y             
                    CLC                       
                    ADC.B #$10                
                    STA.W $0304,Y             
                    LDA $01                   
                    DEC A                     
                    STA.W $0301,Y             
                    STA.W $0305,Y             
                    LDA.B #$A4                
                    STA.W $0302,Y             
                    LDA.B #$A6                
                    STA.W $0306,Y             
                    LDA.W $15F6,X             
                    ORA $64                   
                    STA.W $0303,Y             
                    STA.W $0307,Y             
ADDR_02E92E:        LDA.B #$01                
                    LDY.B #$02                
                    JMP.W ADDR_02B7A7         
ADDR_02E935:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02E93D         
                    PLB                       
                    RTL                       ; Return 

ADDR_02E93D:        LDA.W $14C8,X             
                    CMP.B #$02                
                    BNE ADDR_02E94C           
                    LDA.B #$02                
                    STA.W $1602,X             
                    JMP.W ADDR_02E9EC         
ADDR_02E94C:        JSR.W ADDR_02E9EC         
                    LDA $9D                   
                    BNE ADDR_02E985           
                    STZ.W $1602,X             
                    JSR.W ADDR_02D025         
                    JSL.L ADDR_01803A         
                    LDA $C2,X                 
                    JSL.L ExecutePtr          

Ptrs02E963:         .dw ADDR_02E96D           
                    .dw ADDR_02E986           
                    .dw ADDR_02E9B4           
                    .dw ADDR_02E9BD           
                    .dw ADDR_02E9D5           

ADDR_02E96D:        LDA.W $1540,X             
                    BNE ADDR_02E985           
                    JSR.W ADDR_02D4FA         
                    LDA $0F                   
                    CLC                       
                    ADC.B #$13                
                    CMP.B #$36                
                    BCC ADDR_02E985           
                    LDA.B #$90                
ADDR_02E980:        STA.W $1540,X             
                    INC $C2,X                 
ADDR_02E985:        RTS                       ; Return 

ADDR_02E986:        LDA.W $1540,X             
                    BNE ADDR_02E996           
                    JSR.W ADDR_02D4FA         
                    TYA                       
                    STA.W $157C,X             
                    LDA.B #$0C                
                    BRA ADDR_02E980           
ADDR_02E996:        CMP.B #$7C                
                    BCC ADDR_02E9A2           
ADDR_02E99A:        LDA.B #$F8                
ADDR_02E99C:        STA $AA,X                 
                    JSR.W ADDR_02D294         
                    RTS                       ; Return 

ADDR_02E9A2:        CMP.B #$50                
                    BCS ADDR_02E9B3           
                    LDY.B #$00                
                    LDA $13                   
                    AND.B #$20                
                    BEQ ADDR_02E9AF           
                    INY                       
ADDR_02E9AF:        TYA                       
                    STA.W $157C,X             
ADDR_02E9B3:        RTS                       ; Return 

ADDR_02E9B4:        LDA.W $1540,X             
                    BNE ADDR_02E99A           
                    LDA.B #$80                
                    BRA ADDR_02E980           
ADDR_02E9BD:        LDA.W $1540,X             
                    BNE ADDR_02E9C6           
                    LDA.B #$20                
                    BRA ADDR_02E980           
ADDR_02E9C6:        CMP.B #$40                
                    BNE ADDR_02E9CF           
                    JSL.L ADDR_01EA19         
                    RTS                       ; Return 

ADDR_02E9CF:        BCS ADDR_02E9D4           
                    INC.W $1602,X             
ADDR_02E9D4:        RTS                       ; Return 

ADDR_02E9D5:        LDA.W $1540,X             
                    BNE ADDR_02E9E2           
                    LDA.B #$50                
                    JSR.W ADDR_02E980         
                    STZ $C2,X                 
                    RTS                       ; Return 

ADDR_02E9E2:        LDA.B #$08                
                    BRA ADDR_02E99C           

PipeLakitu1:        .db $EC,$A8,$CE

PipeLakitu2:        .db $EE,$EE,$EE

ADDR_02E9EC:        JSR.W GetDrawInfo2        
                    LDA $00                   
                    STA.W $0300,Y             
                    STA.W $0304,Y             
                    LDA $01                   
                    STA.W $0301,Y             
                    CLC                       
                    ADC.B #$10                
                    STA.W $0305,Y             
                    PHX                       
                    LDA.W $1602,X             
                    TAX                       
                    LDA.W PipeLakitu1,X       
                    STA.W $0302,Y             
                    LDA.W PipeLakitu2,X       
                    STA.W $0306,Y             
                    PLX                       
                    LDA.W $157C,X             
                    LSR                       
                    ROR                       
                    LSR                       
                    EOR.B #$5B                
                    STA.W $0303,Y             
                    STA.W $0307,Y             
                    JMP.W ADDR_02E92E         
ADDR_02EA25:        LDY.W $15EA,X             
                    LDA.W $0302,Y             
                    STA $00                   
                    STZ $01                   
                    LDA.B #$06                
                    STA.W $0302,Y             
                    REP #$20                  ; Accum (16 bit) 
                    LDA $00                   
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    CLC                       
                    ADC.W #$8500              
                    STA.W $0D8B               
                    CLC                       
                    ADC.W #$0200              
                    STA.W $0D95               
                    SEP #$20                  ; Accum (8 bit) 
                    RTL                       ; Return 

ADDR_02EA4E:        LDY.B #$0B                
ADDR_02EA50:        TYA                       
                    CMP.W $160E,X             
                    BEQ ADDR_02EA86           
                    EOR $13                   
                    LSR                       
                    BCS ADDR_02EA86           
                    CPY.W $15E9               
                    BEQ ADDR_02EA86           
                    STY.W $1695               
                    LDA.W $14C8,Y             
                    CMP.B #$08                
                    BCC ADDR_02EA86           
                    LDA.W $009E,Y             
                    CMP.B #$70                
                    BEQ ADDR_02EA86           
                    CMP.B #$0E                
                    BEQ ADDR_02EA86           
                    CMP.B #$1D                
                    BCC ADDR_02EA83           
                    LDA.W $1686,Y             
                    AND.B #$03                
                    ORA.W $18E8               
                    BNE ADDR_02EA86           
ADDR_02EA83:        JSR.W ADDR_02EA8A         
ADDR_02EA86:        DEY                       
                    BPL ADDR_02EA50           
                    RTL                       ; Return 

ADDR_02EA8A:        PHX                       
                    TYX                       
                    JSL.L ADDR_03B6E5         
                    PLX                       
                    JSL.L ADDR_03B69F         
                    JSL.L ADDR_03B72B         
                    BCC ADDR_02EACD           
                    LDA.W $163E,X             
                    BEQ ADDR_02EAA9           
                    JSL.L ADDR_03C023         
                    LDA.W $18E8               
                    BNE ADDR_02EACE           
ADDR_02EAA9:        LDA.B #$37                
                    STA.W $163E,X             
                    LDY.W $1695               
                    STA.W $1632,Y             
                    LDA.W $1695               
                    STA.W $160E,X             
                    STZ.W $157C,X             
                    LDA $E4,X                 
                    CMP.W $00E4,Y             
                    LDA.W $14E0,X             
                    SBC.W $14E0,Y             
                    BCC ADDR_02EACD           
                    INC.W $157C,X             
ADDR_02EACD:        RTS                       ; Return 

ADDR_02EACE:        STZ.W $163E,X             
                    RTS                       ; Return 

ADDR_02EAD2:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02EADA         
                    PLB                       
                    RTL                       ; Return 

ADDR_02EADA:        JSL.L MarioSprInteract    
                    BCC ADDR_02EAF0           
                    STZ $7B                   
                    LDA $E4,X                 
                    CLC                       
                    ADC.B #$0A                
                    STA $94                   
                    LDA.W $14E0,X             
                    ADC.B #$00                
                    STA $95                   
ADDR_02EAF0:        RTS                       ; Return 

                    RTS                       

ADDR_02EAF2:        JSL.L ADDR_02A9E4         
                    BMI ADDR_02EB26           
                    LDA.B #$08                
                    STA.W $14C8,Y             
                    LDA.B #$77                
                    STA.W $009E,Y             
                    LDA $E4,X                 
                    STA.W $00E4,Y             
                    LDA.W $14E0,X             
                    STA.W $14E0,Y             
                    LDA $D8,X                 
                    STA.W $00D8,Y             
                    LDA.W $14D4,X             
                    STA.W $14D4,Y             
                    TYX                       
                    JSL.L ADDR_07F7D2         
                    LDA.B #$30                
                    STA.W $154C,X             
                    LDA.B #$D0                
                    STA $AA,X                 
ADDR_02EB26:        RTL                       ; Return 

ADDR_02EB27:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02EB31         
                    PLB                       
                    RTL                       ; Return 


DATA_02EB2F:        .db $18,$E8

ADDR_02EB31:        JSR.W ADDR_02ECDE         
                    LDA.W $14C8,X             
                    CMP.B #$02                
                    BNE ADDR_02EB49           
                    LDY.B #$04                
ADDR_02EB3D:        LDA $14                   
                    AND.B #$04                
                    BEQ ADDR_02EB44           
                    INY                       
ADDR_02EB44:        TYA                       
                    STA.W $1602,X             
                    RTS                       ; Return 

ADDR_02EB49:        LDA $9D                   
                    BNE ADDR_02EB7C           
                    JSR.W ADDR_02D025         
                    JSL.L ADDR_01803A         
                    JSR.W ADDR_02D288         
                    JSR.W ADDR_02D294         
                    LDA $9E,X                 
                    CMP.B #$73                
                    BEQ ADDR_02EB7D           
                    LDY.W $157C,X             
                    LDA.W DATA_02EB2F,Y       
                    STA $B6,X                 
                    JSR.W ADDR_02EBF8         
                    LDA $13                   
                    AND.B #$01                
                    BNE ADDR_02EB7C           
                    LDA $AA,X                 
                    CMP.B #$F0                
                    BMI ADDR_02EB7C           
                    CLC                       
                    ADC.B #$FF                
                    STA $AA,X                 
ADDR_02EB7C:        RTS                       ; Return 

ADDR_02EB7D:        LDA $C2,X                 
                    JSL.L ExecutePtr          

Ptrs02EB83:         .dw ADDR_02EB8D           
                    .dw ADDR_02EBD1           
                    .dw ADDR_02EBE7           

DATA_02EB89:        .db $18,$E8

DATA_02EB8B:        .db $01,$FF

ADDR_02EB8D:        LDA $13                   
                    AND.B #$00                
                    STA $01                   
                    STZ $00                   
                    LDY.W $157C,X             
                    LDA $B6,X                 
                    CMP.W DATA_02EB89,Y       
                    BEQ ADDR_02EBAB           
                    CLC                       
                    ADC.W DATA_02EB8B,Y       
                    LDY $01                   
                    BNE ADDR_02EBA9           
                    STA $B6,X                 
ADDR_02EBA9:        INC $00                   
ADDR_02EBAB:        INC.W $151C,X             
                    LDA.W $151C,X             
                    CMP.B #$30                
                    BEQ ADDR_02EBCA           
ADDR_02EBB5:        LDY.B #$00                
                    LDA $13                   
                    AND.B #$04                
                    BEQ ADDR_02EBBE           
                    INY                       
ADDR_02EBBE:        TYA                       
                    LDY $00                   
                    BNE ADDR_02EBC6           
                    CLC                       
                    ADC.B #$06                
ADDR_02EBC6:        STA.W $1602,X             
                    RTS                       ; Return 

ADDR_02EBCA:        INC $C2,X                 
                    LDA.B #$D0                
                    STA $AA,X                 
                    RTS                       ; Return 

ADDR_02EBD1:        LDA $AA,X                 
                    CLC                       
                    ADC.B #$02                
                    STA $AA,X                 
                    CMP.B #$14                
                    BMI ADDR_02EBDE           
                    INC $C2,X                 
ADDR_02EBDE:        STZ $00                   
                    JSR.W ADDR_02EBB5         
                    INC.W $1602,X             
                    RTS                       ; Return 

ADDR_02EBE7:        LDY.W $157C,X             
                    LDA.W DATA_02EB89,Y       
                    STA $B6,X                 
                    LDA $AA,X                 
                    BEQ ADDR_02EBF8           
                    CLC                       
                    ADC.B #$FF                
                    STA $AA,X                 
ADDR_02EBF8:        LDY.B #$02                
                    LDA $13                   
                    AND.B #$04                
                    BEQ ADDR_02EC01           
                    INY                       
ADDR_02EC01:        TYA                       
                    STA.W $1602,X             
                    RTS                       ; Return 


DATA_02EC06:        .db $08,$08,$10,$00,$08,$08,$10,$00
                    .db $08,$10,$10,$00,$08,$10,$10,$00
                    .db $09,$09,$00,$00,$09,$09,$00,$00
                    .db $08,$10,$00,$00,$08,$10,$00,$00
                    .db $08,$10,$00,$00,$00,$00,$F8,$00
                    .db $00,$00,$F8,$00,$00,$F8,$F8,$00
                    .db $00,$F8,$F8,$00,$FF,$FF,$00,$00
                    .db $FF,$FF,$00,$00,$00,$F8,$00,$00
                    .db $00,$F8,$00,$00,$00,$F8,$00,$00
DATA_02EC4E:        .db $00,$08,$08,$00,$00,$08,$08,$00
                    .db $03,$03,$08,$00,$03,$03,$08,$00
                    .db $FF,$07,$00,$00,$FF,$07,$00,$00
                    .db $FD,$FD,$00,$00,$FD,$FD,$00,$00
                    .db $FD,$FD,$00,$00

SuperKoopaTiles:    .db $C8,$D8,$D0,$E0,$C9,$D9,$C0,$E2
                    .db $E4,$E5,$F2,$E0,$F4,$F5,$F2,$E0
                    .db $DA,$CA,$E0,$CF,$DB,$CB,$E0,$CF
                    .db $E4,$E5,$E0,$CF,$F4,$F5,$E2,$CF
                    .db $E4,$E5,$E2,$CF

DATA_02EC96:        .db $03,$03,$03,$00,$03,$03,$03,$00
                    .db $03,$03,$01,$01,$03,$03,$01,$01
                    .db $83,$83,$80,$00,$83,$83,$80,$00
                    .db $03,$03,$00,$01,$03,$03,$00,$01
                    .db $03,$03,$00,$01

DATA_02ECBA:        .db $00,$00,$00,$02,$00,$00,$00,$02
                    .db $00,$00,$00,$02,$00,$00,$00,$02
                    .db $00,$00,$02,$00,$00,$00,$02,$00
                    .db $00,$00,$02,$00,$00,$00,$02,$00
                    .db $00,$00,$02,$00

ADDR_02ECDE:        JSR.W GetDrawInfo2        
                    LDA.W $157C,X             
                    STA $02                   
                    LDA.W $15F6,X             
                    AND.B #$0E                
                    STA $05                   
                    LDA.W $1602,X             
                    ASL                       
                    ASL                       
                    STA $03                   
                    PHX                       
                    STZ $04                   
                    LDA $03                   
                    CLC                       
                    ADC $04                   
                    TAX                       
                    LDA $01                   
                    CLC                       
                    ADC.W DATA_02EC4E,X       
                    STA.W $0301,Y             
                    LDA.W SuperKoopaTiles,X   
                    STA.W $0302,Y             
                    PHY                       
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_02ECBA,X       
                    STA.W $0460,Y             
                    PLY                       
                    LDA $02                   
                    LSR                       
                    LDA.W DATA_02EC96,X       
                    AND.B #$02                
                    BEQ ADDR_02ED4D           
                    PHP                       
                    PHX                       
                    LDX.W $15E9               
                    LDA.W $1534,X             
                    BEQ ADDR_02ED3B           
                    LDA $14                   
                    LSR                       
                    AND.B #$01                
                    PHY                       
                    TAY                       
                    LDA.W DATA_02ED39,Y       
                    PLY                       
                    BRA ADDR_02ED44           

DATA_02ED39:        .db $10,$0A

ADDR_02ED3B:        LDA $9E,X                 
                    CMP.B #$72                
                    LDA.B #$08                
                    BCC ADDR_02ED44           
                    LSR                       
ADDR_02ED44:        PLX                       
                    PLP                       
                    ORA.W DATA_02EC96,X       
                    AND.B #$FD                
                    BRA ADDR_02ED52           
ADDR_02ED4D:        LDA.W DATA_02EC96,X       
                    ORA $05                   
ADDR_02ED52:        ORA $64                   
                    BCS ADDR_02ED5F           
                    PHA                       
                    TXA                       
                    CLC                       
                    ADC.B #$24                
                    TAX                       
                    PLA                       
                    ORA.B #$40                
ADDR_02ED5F:        STA.W $0303,Y             
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_02EC06,X       
                    STA.W $0300,Y             
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    INC $04                   
                    LDA $04                   
                    CMP.B #$04                

Instr02ED75:        .db $D0,$80

                    PLX                       
                    LDY.B #$FF                
                    LDA.B #$03                
                    JMP.W ADDR_02B7A7         

DATA_02ED7F:        .db $10,$20,$30

ADDR_02ED82:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02ED8A         
                    PLB                       
                    RTL                       ; Return 

ADDR_02ED8A:        STZ.W $18BC               
                    INC $C2,X                 
                    LDA.B #$02                
                    STA $00                   
ADDR_02ED93:        JSL.L ADDR_02A9E4         
                    BMI ADDR_02EDCB           
                    LDA.B #$08                
                    STA.W $14C8,Y             
                    LDA.B #$61                
                    STA.W $009E,Y             
                    LDA $D8,X                 
                    STA.W $00D8,Y             
                    LDA.W $14D4,X             
                    STA.W $14D4,Y             
                    LDX $00                   
                    LDA.W DATA_02ED7F,X       
                    LDX.W $15E9               
                    CLC                       
                    ADC $E4,X                 
                    STA.W $00E4,Y             
                    LDA.W $14E0,X             
                    ADC.B #$00                
                    STA.W $14E0,Y             
                    PHX                       
                    TYX                       
                    JSL.L ADDR_07F7D2         
                    PLX                       
ADDR_02EDCB:        DEC $00                   
                    BPL ADDR_02ED93           
                    RTS                       ; Return 

ADDR_02EDD0:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02EDD8         
                    PLB                       
                    RTL                       ; Return 

ADDR_02EDD8:        LDA $C2,X                 
                    BEQ ADDR_02EDF6           
                    JSR.W ADDR_02D025         
                    LDA.W $14C8,X             
                    BNE ADDR_02EDF6           
                    LDY.B #$09                
ADDR_02EDE6:        LDA.W $009E,Y             
                    CMP.B #$61                
                    BNE ADDR_02EDF2           
                    LDA.B #$00                
                    STA.W $14C8,Y             
ADDR_02EDF2:        DEY                       
                    BPL ADDR_02EDE6           
ADDR_02EDF5:        RTS                       ; Return 

ADDR_02EDF6:        JSL.L GenericSprGfxRt     
                    LDY.W $15EA,X             
                    LDA $14                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LDA.B #$E0                
                    BCC ADDR_02EE09           
                    LDA.B #$E2                
ADDR_02EE09:        STA.W $0302,Y             
                    LDA.W $0301,Y             
                    CMP.B #$F0                
                    BCS ADDR_02EE19           
                    CLC                       
                    ADC.B #$03                
                    STA.W $0301,Y             
ADDR_02EE19:        LDA $9D                   
                    BNE ADDR_02EDF5           
                    STZ $00                   
                    LDY.B #$09                
ADDR_02EE21:        LDA.W $14C8,Y             
                    BEQ ADDR_02EE36           
                    LDA.W $009E,Y             
                    CMP.B #$61                
                    BNE ADDR_02EE36           
                    LDA.W $1588,Y             
                    AND.B #$0F                
                    BEQ ADDR_02EE36           
                    STA $00                   
ADDR_02EE36:        DEY                       
                    BPL ADDR_02EE21           
                    LDA.W $18BC               
                    STA $B6,X                 
                    LDA $AA,X                 
                    CMP.B #$20                
                    BMI ADDR_02EE48           
                    LDA.B #$20                
                    STA $AA,X                 
ADDR_02EE48:        JSL.L UpdateSpritePos     
                    LDA.W $1588,X             
                    AND.B #$04                
                    BEQ ADDR_02EE57           
                    LDA.B #$10                
                    STA $AA,X                 
ADDR_02EE57:        JSL.L MarioSprInteract    
                    BCC ADDR_02EEA8           
                    LDA $7D                   
                    BMI ADDR_02EEA8           
                    LDA.B #$0C                
                    STA.W $18BC               
                    LDA.W $15EA,X             
                    TAX                       
                    INC.W $0301,X             
                    LDX.W $15E9               
                    LDA.B #$01                
                    STA.W $1471               
                    STZ $72                   
                    LDA.B #$1C                
                    LDY.W $187A               
                    BEQ ADDR_02EE80           
                    LDA.B #$2C                
ADDR_02EE80:        STA $01                   
                    LDA $D8,X                 
                    SEC                       
                    SBC $01                   
                    STA $96                   
                    LDA.W $14D4,X             
                    SBC.B #$00                
                    STA $97                   
                    LDA $77                   
                    AND.B #$01                
                    BNE ADDR_02EEA8           
                    LDY.B #$00                
                    LDA.W $1491               
                    BPL ADDR_02EE9E           
                    DEY                       
ADDR_02EE9E:        CLC                       
                    ADC $94                   
                    STA $94                   
                    TYA                       
                    ADC $95                   
                    STA $95                   
ADDR_02EEA8:        RTS                       ; Return 

ADDR_02EEA9:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02EEB5         
                    PLB                       
                    RTL                       ; Return 


DATA_02EEB1:        .db $01,$FF

DATA_02EEB3:        .db $10,$F0

ADDR_02EEB5:        LDA $C2,X                 
                    BNE ADDR_02EEBE           
                    INC $C2,X                 
                    STZ.W $18E3               
ADDR_02EEBE:        LDA $9D                   
                    BNE ADDR_02EF1C           
                    LDA $14                   
                    AND.B #$7F                
                    BNE ADDR_02EED5           
                    LDA.W $1570,X             
                    CMP.B #$0B                
                    BCS ADDR_02EED5           
                    INC.W $1570,X             
                    JSR.W ADDR_02EF67         
ADDR_02EED5:        LDA $14                   
                    AND.B #$01                
                    BNE ADDR_02EF12           
                    LDA $D8,X                 
                    STA $00                   
                    LDA.W $14D4,X             
                    STA $01                   
                    LDA.B #$10                
                    STA $02                   
                    LDA.B #$01                
                    STA $03                   
                    REP #$20                  ; Accum (16 bit) 
                    LDA $00                   
                    CMP $02                   
                    SEP #$20                  ; Accum (8 bit) 
                    LDY.B #$00                
                    BCC ADDR_02EEF9           
                    INY                       
ADDR_02EEF9:        LDA.W $1570,X             
                    CMP.B #$0B                
                    BCC ADDR_02EF05           
                    JSR.W ADDR_02D025         
                    LDY.B #$01                
ADDR_02EF05:        LDA $AA,X                 
                    CMP.W DATA_02EEB3,Y       
                    BEQ ADDR_02EF12           
                    CLC                       
                    ADC.W DATA_02EEB1,Y       
                    STA $AA,X                 
ADDR_02EF12:        JSR.W ADDR_02D294         
                    LDA.B #$08                
                    STA $B6,X                 
                    JSR.W ADDR_02D288         
ADDR_02EF1C:        LDA.W $15EA,X             
                    PHA                       
                    CLC                       
                    ADC.B #$04                
                    STA.W $15EA,X             
                    JSL.L GenericSprGfxRt     
                    LDY.W $15EA,X             
                    LDA.B #$60                
                    STA.W $0302,Y             
                    LDA $14                   
                    ASL                       
                    ASL                       
                    ASL                       
                    AND.B #$C0                
                    ORA.B #$30                
                    STA.W $0303,Y             
                    PLA                       
                    STA.W $15EA,X             
                    JSR.W GetDrawInfo2        
                    LDA $00                   
                    CLC                       
                    ADC.B #$04                
                    STA.W $0300,Y             
                    LDA $01                   
                    CLC                       
                    ADC.B #$04                
                    STA.W $0301,Y             
                    LDA.B #$4D                
                    STA.W $0302,Y             
                    LDA.B #$39                
                    STA.W $0303,Y             
                    LDY.B #$00                
                    LDA.B #$00                
                    JSR.W ADDR_02B7A7         
                    RTS                       ; Return 

ADDR_02EF67:        LDA.W $18E3               
                    CMP.B #$0A                
                    BCC ADDR_02EFAA           
                    LDY.B #$0B                
ADDR_02EF70:        LDA.W $14C8,Y             
                    BEQ ADDR_02EF7B           
                    DEY                       
                    CPY.B #$09                
                    BNE ADDR_02EF70           
                    RTS                       ; Return 

ADDR_02EF7B:        LDA.B #$08                
                    STA.W $14C8,Y             
                    LDA.B #$78                
                    STA.W $009E,Y             
                    LDA $E4,X                 
                    STA.W $00E4,Y             
                    LDA.W $14E0,X             
                    STA.W $14E0,Y             
                    LDA $D8,X                 
                    STA.W $00D8,Y             
                    LDA.W $14D4,X             
                    STA.W $14D4,Y             
                    PHX                       
                    TYX                       
                    JSL.L ADDR_07F7D2         
                    LDA.B #$E0                
                    STA $AA,X                 
                    INC.W $157C,X             
                    PLX                       
                    RTS                       ; Return 

ADDR_02EFAA:        LDA.W $1570,X             
                    CMP.B #$0B                
                    BCS ADDR_02EFBB           
                    LDY.B #$07                
ADDR_02EFB3:        LDA.W $170B,Y             
                    BEQ ADDR_02EFBC           
                    DEY                       
                    BPL ADDR_02EFB3           
ADDR_02EFBB:        RTS                       ; Return 

ADDR_02EFBC:        LDA.B #$0A                
                    STA.W $170B,Y             
                    LDA $E4,X                 
                    CLC                       
                    ADC.B #$04                
                    STA.W $171F,Y             
                    LDA.W $14E0,X             
                    ADC.B #$00                
                    STA.W $1733,Y             
                    LDA $D8,X                 
                    STA.W $1715,Y             
                    LDA.W $14D4,X             
                    STA.W $1729,Y             
                    LDA.B #$D0                
                    STA.W $173D,Y             
                    LDA.B #$00                
                    STA.W $1747,Y             
                    STA.W $1765,Y             
                    RTS                       ; Return 


DATA_02EFEA:        .db $00,$80,$00,$80

DATA_02EFEE:        .db $00,$00,$01,$01

ADDR_02EFF2:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02F011         
                    LDY.B #$7E                
ADDR_02EFFA:        LDA $E4,X                 
                    STA [$D5],Y               
                    LDA $D8,X                 
                    INY                       
                    STA [$D5],Y               
                    DEY                       
                    DEY                       
                    DEY                       
                    BPL ADDR_02EFFA           
                    JSR.W ADDR_02D4FA         
                    TYA                       
                    STA.W $157C,X             
                    PLB                       
                    RTL                       ; Return 

ADDR_02F011:        TXA                       
                    AND.B #$03                
                    TAY                       
                    LDA.B #$7B                
                    CLC                       
                    ADC.W DATA_02EFEA,Y       
                    STA $D5                   
                    LDA.B #$9A                
                    ADC.W DATA_02EFEE,Y       
                    STA $D6                   
                    LDA.B #$7F                
                    STA $D7                   
                    RTS                       ; Return 

ADDR_02F029:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02F035         
                    PLB                       
                    RTL                       ; Return 


WigglerSpeed:       .db $08,$F8,$10,$F0

ADDR_02F035:        JSR.W ADDR_02F011         
                    LDA $9D                   
                    BEQ ADDR_02F03F           
                    JMP.W ADDR_02F0D8         
ADDR_02F03F:        JSL.L SprSprInteract      
                    LDA.W $1540,X             
                    BEQ ADDR_02F061           
                    CMP.B #$01                
                    BNE ADDR_02F050           
                    LDA.B #$08                
                    BRA ADDR_02F052           
ADDR_02F050:        AND.B #$0E                
ADDR_02F052:        STA $00                   
                    LDA.W $15F6,X             
                    AND.B #$F1                
                    ORA $00                   
                    STA.W $15F6,X             
                    JMP.W ADDR_02F0D8         
ADDR_02F061:        JSR.W ADDR_02D288         
                    JSR.W ADDR_02D294         
                    JSR.W ADDR_02D025         
                    INC.W $1570,X             
                    LDA.W $151C,X             
                    BEQ ADDR_02F086           
                    INC.W $1570,X             
                    INC.W $1534,X             
                    LDA.W $1534,X             
                    AND.B #$3F                
                    BNE ADDR_02F086           
                    JSR.W ADDR_02D4FA         
                    TYA                       
                    STA.W $157C,X             
ADDR_02F086:        LDY.W $157C,X             
                    LDA.W $151C,X             
                    BEQ ADDR_02F090           
                    INY                       
                    INY                       
ADDR_02F090:        LDA.W WigglerSpeed,Y      
                    STA $B6,X                 
                    INC $AA,X                 
                    JSL.L ADDR_019138         
                    LDA.W $1588,X             
                    AND.B #$03                
                    BNE ADDR_02F0AE           
                    LDA.W $1588,X             
                    AND.B #$04                
                    BEQ ADDR_02F0AE           
                    JSR.W ADDR_02FFD1         
                    BRA ADDR_02F0C3           
ADDR_02F0AE:        LDA.W $15AC,X             
                    BNE ADDR_02F0C3           
                    LDA.W $157C,X             
                    EOR.B #$01                
                    STA.W $157C,X             
                    STZ.W $1602,X             
                    LDA.B #$08                
                    STA.W $15AC,X             
ADDR_02F0C3:        JSR.W ADDR_02F0DB         
                    LDA.W $1602,X             
                    INC.W $1602,X             
                    AND.B #$07                
                    BNE ADDR_02F0D8           
                    LDA $C2,X                 
                    ASL                       
                    ORA.W $157C,X             
                    STA $C2,X                 
ADDR_02F0D8:        JMP.W ADDR_02F110         
ADDR_02F0DB:        PHX                       
                    PHB                       
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA $D5                   
                    CLC                       
                    ADC.W #$007D              
                    TAX                       
                    LDA $D5                   
                    CLC                       
                    ADC.W #$007F              
                    TAY                       
                    LDA.W #$007D              
                    MVP $7F,$7F               
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    PLB                       
                    PLX                       
                    LDY.B #$00                
                    LDA $E4,X                 
                    STA [$D5],Y               
                    LDA $D8,X                 
                    INY                       
                    STA [$D5],Y               
                    RTS                       ; Return 


DATA_02F103:        .db $00,$1E,$3E,$5E,$7E

DATA_02F108:        .db $00,$01,$02,$01

WigglerTiles:       .db $C4,$C6,$C8,$C6

ADDR_02F110:        JSR.W GetDrawInfo2        
                    LDA.W $1570,X             
                    STA $03                   
                    LDA.W $15F6,X             
                    STA $07                   
                    LDA.W $151C,X             
                    STA $08                   
                    LDA $C2,X                 
                    STA $02                   
                    TYA                       
                    CLC                       
                    ADC.B #$04                
                    TAY                       
                    LDX.B #$00                
ADDR_02F12D:        PHX                       
                    STX $05                   
                    LDA $03                   
                    LSR                       
                    LSR                       
                    LSR                       
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    CLC                       
                    ADC $05                   
                    AND.B #$03                
                    STA $06                   
                    PHY                       
                    LDY.W DATA_02F103,X       
                    LDA $08                   
                    BEQ ADDR_02F14D           
                    TYA                       
                    LSR                       
                    AND.B #$FE                
                    TAY                       
ADDR_02F14D:        STY $09                   
                    LDA [$D5],Y               
                    PLY                       
                    SEC                       
                    SBC $1A                   
                    STA.W $0300,Y             
                    PHY                       
                    LDY $09                   
                    INY                       
                    LDA [$D5],Y               
                    PLY                       
                    SEC                       
                    SBC $1C                   
                    LDX $06                   
                    SEC                       
                    SBC.W DATA_02F108,X       
                    STA.W $0301,Y             
                    PLX                       
                    PHX                       
                    LDA.B #$8C                
                    CPX.B #$00                
                    BEQ ADDR_02F178           
                    LDX $06                   
                    LDA.W WigglerTiles,X      
ADDR_02F178:        STA.W $0302,Y             
                    PLX                       
                    LDA $07                   
                    ORA $64                   
                    LSR $02                   
                    BCS ADDR_02F186           
                    ORA.B #$40                
ADDR_02F186:        STA.W $0303,Y             
                    PHY                       
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$02                
                    STA.W $0460,Y             
                    PLY                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    INX                       
                    CPX.B #$05                
                    BNE ADDR_02F12D           
                    LDX.W $15E9               
                    LDA $08                   
                    BEQ ADDR_02F1C7           
                    PHX                       
                    LDY.W $15EA,X             
                    LDA.W $157C,X             
                    TAX                       
                    LDA.W $0304,Y             
                    CLC                       
                    ADC.W WigglerEyesX,X      
                    PLX                       
                    STA.W $0300,Y             
                    LDA.W $0305,Y             
                    STA.W $0301,Y             
                    LDA.B #$88                
                    STA.W $0302,Y             
                    LDA.W $0307,Y             
                    BRA ADDR_02F1EF           
ADDR_02F1C7:        PHX                       
                    LDY.W $15EA,X             
                    LDA.W $157C,X             
                    TAX                       
                    LDA.W $0304,Y             
                    CLC                       
                    ADC.W DATA_02F2D3,X       
                    PLX                       
                    STA.W $0300,Y             
                    LDA.W $0305,Y             
                    SEC                       
                    SBC.B #$08                
                    STA.W $0301,Y             
                    LDA.B #$98                
                    STA.W $0302,Y             
                    LDA.W $0307,Y             
                    AND.B #$F1                
                    ORA.B #$0A                
ADDR_02F1EF:        STA.W $0303,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$00                
                    STA.W $0460,Y             
                    LDA.B #$05                
                    LDY.B #$FF                
                    JSR.W ADDR_02B7A7         
                    LDA $E4,X                 
                    STA $00                   
                    LDA.W $14E0,X             
                    STA $01                   
                    REP #$20                  ; Accum (16 bit) 
                    LDA $00                   
                    SEC                       
                    SBC $94                   
                    CLC                       
                    ADC.W #$0050              
                    CMP.W #$00A0              
                    SEP #$20                  ; Accum (8 bit) 
                    BCS ADDR_02F295           
                    LDA.W $14C8,X             
                    CMP.B #$08                
                    BNE ADDR_02F295           
                    LDA.B #$04                
                    STA $00                   
                    LDY.W $15EA,X             
ADDR_02F22B:        LDA.W $0304,Y             
                    SEC                       
                    SBC $7E                   
                    ADC.B #$0C                
                    CMP.B #$18                
                    BCS ADDR_02F29B           
                    LDA.W $0305,Y             
                    SEC                       
                    SBC $80                   
                    SBC.B #$10                
                    PHY                       
                    LDY.W $187A               
                    BEQ ADDR_02F247           
                    SBC.B #$10                
ADDR_02F247:        PLY                       
                    CLC                       
                    ADC.B #$0C                
                    CMP.B #$18                
                    BCS ADDR_02F29B           
                    LDA.W $1490               
                    BNE ADDR_02F29D           
                    LDA.W $154C,X             
                    ORA $81                   
                    BNE ADDR_02F29B           
                    LDA.B #$08                
                    STA.W $154C,X             
                    LDA.W $1697               
                    BNE ADDR_02F26B           
                    LDA $7D                   
                    CMP.B #$08                
                    BMI ADDR_02F296           
ADDR_02F26B:        LDA.B #$03                
                    STA.W $1DF9               ; / Play sound effect 
                    JSL.L BoostMarioSpeed     
                    LDA.W $151C,X             
                    ORA.W $15D0,X             
                    BNE ADDR_02F295           
                    JSL.L DisplayContactGfx   
                    LDA.W $1697               
                    INC.W $1697               
                    JSL.L GivePoints          
                    LDA.B #$40                
                    STA.W $1540,X             
                    INC.W $151C,X             
                    JSR.W ADDR_02F2D7         
ADDR_02F295:        RTS                       ; Return 

ADDR_02F296:        JSL.L HurtMario           
                    RTS                       ; Return 

ADDR_02F29B:        BRA ADDR_02F2C7           
ADDR_02F29D:        LDA.B #$02                
                    STA.W $14C8,X             
                    LDA.B #$D0                
                    STA $AA,X                 
                    INC.W $18D2               
                    LDA.W $18D2               
                    CMP.B #$09                
                    BCC ADDR_02F2B5           
                    LDA.B #$09                
                    STA.W $18D2               
ADDR_02F2B5:        JSL.L GivePoints          
                    LDY.W $18D2               
                    CPY.B #$08                
                    BCS ADDR_02F2C6           
                    LDA.W DATA_02D57F,Y       
                    STA.W $1DF9               ; / Play sound effect 
ADDR_02F2C6:        RTS                       ; Return 

ADDR_02F2C7:        INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEC $00                   
                    BMI ADDR_02F2D2           
                    JMP.W ADDR_02F22B         
ADDR_02F2D2:        RTS                       ; Return 


DATA_02F2D3:        .db $00,$08

WigglerEyesX:       .db $04,$04

ADDR_02F2D7:        LDY.B #$07                
ADDR_02F2D9:        LDA.W $170B,Y             
                    BEQ ADDR_02F2E2           
                    DEY                       
                    BPL ADDR_02F2D9           
                    RTS                       ; Return 

ADDR_02F2E2:        LDA.B #$0E                
                    STA.W $170B,Y             
                    LDA.B #$01                
                    STA.W $1765,Y             
                    LDA $E4,X                 
                    STA.W $171F,Y             
                    LDA.W $14E0,X             
                    STA.W $1733,Y             
                    LDA $D8,X                 
                    STA.W $1715,Y             
                    LDA $D8,X                 
                    STA.W $1729,Y             
                    LDA.B #$D0                
                    STA.W $173D,Y             
                    LDA $B6,X                 
                    EOR.B #$FF                
                    INC A                     
                    STA.W $1747,Y             
                    RTS                       ; Return 

ADDR_02F30F:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02F317         
                    PLB                       
                    RTL                       ; Return 

ADDR_02F317:        LDA.W $15AC,X             
                    BEQ ADDR_02F321           
                    LDA.B #$04                
                    STA.W $1602,X             
ADDR_02F321:        JSR.W ADDR_02F3EA         
                    JSR.W ADDR_02D288         
                    JSR.W ADDR_02D294         
                    LDA $AA,X                 
                    CLC                       
                    ADC.B #$03                
                    STA $AA,X                 
                    LDA $C2,X                 
                    JSL.L ExecutePtr          

Ptrs02F337:         .dw ADDR_02F342           
                    .dw ADDR_02F38F           

                    RTS                       


DATA_02F33C:        .db $02,$03,$05,$01

DATA_02F340:        .db $08,$F8

ADDR_02F342:        LDY.W $157C,X             
                    LDA.W DATA_02F340,Y       
                    STA $B6,X                 
                    STZ.W $1602,X             
                    LDA $AA,X                 
                    BMI ADDR_02F370           
                    LDA $D8,X                 
                    CMP.B #$E8                
                    BCC ADDR_02F370           
                    AND.B #$F8                
                    STA $D8,X                 
                    LDA.B #$F0                
                    STA $AA,X                 
                    LDA $E4,X                 
                    CLC                       
                    ADC.B #$30                
                    CMP.B #$60                
                    BCC ADDR_02F381           
                    LDA.W $1570,X             
                    BEQ ADDR_02F371           
                    DEC.W $1570,X             
ADDR_02F370:        RTS                       ; Return 

ADDR_02F371:        INC $C2,X                 
                    JSL.L ADDR_01ACF9         
                    AND.B #$03                
                    TAY                       
                    LDA.W DATA_02F33C,Y       
                    STA.W $1570,X             
                    RTS                       ; Return 

ADDR_02F381:        LDA.W $154C,X             
                    BNE ADDR_02F38E           
                    JSR.W ADDR_02F3C1         
                    LDA.B #$10                
                    STA.W $154C,X             
ADDR_02F38E:        RTS                       ; Return 

ADDR_02F38F:        STZ $AA,X                 
                    STZ $B6,X                 
                    STZ.W $1602,X             
                    LDA.W $1540,X             
                    BEQ ADDR_02F3A3           
                    CMP.B #$08                
                    BCS ADDR_02F3A2           
                    INC.W $1602,X             
ADDR_02F3A2:        RTS                       ; Return 

ADDR_02F3A3:        LDA.W $1570,X             
                    BEQ ADDR_02F3B7           
                    DEC.W $1570,X             
                    JSL.L ADDR_01ACF9         
                    AND.B #$1F                
                    ORA.B #$0A                
                    STA.W $1540,X             
                    RTS                       ; Return 

ADDR_02F3B7:        STZ $C2,X                 
                    JSL.L ADDR_01ACF9         
                    AND.B #$01                
                    BNE ADDR_02F3CE           
ADDR_02F3C1:        LDA.W $157C,X             
                    EOR.B #$01                
                    STA.W $157C,X             
                    LDA.B #$0A                
                    STA.W $15AC,X             
ADDR_02F3CE:        JSL.L ADDR_01ACF9         
                    AND.B #$03                
                    CLC                       
                    ADC.B #$02                
                    STA.W $1570,X             
                    RTS                       ; Return 


BirdsTilemap:       .db $D2,$D3,$D0,$D1,$9B

BirdsFlip:          .db $71,$31

BirdsPal:           .db $08,$04,$06,$0A

FireplaceTilemap:   .db $30,$34,$48,$3C

ADDR_02F3EA:        TXA                       
                    AND.B #$03                
                    TAY                       
                    LDA.W BirdsPal,Y          
                    LDY.W $157C,X             
                    ORA.W BirdsFlip,Y         
                    STA $02                   
                    TXA                       
                    AND.B #$03                
                    TAY                       
                    LDA.W FireplaceTilemap,Y  
                    TAY                       
                    LDA $E4,X                 
                    SEC                       
                    SBC $1A                   
                    STA.W $0200,Y             
                    LDA $D8,X                 
                    SEC                       
                    SBC $1C                   
                    STA.W $0201,Y             
                    PHX                       
                    LDA.W $1602,X             
                    TAX                       
                    LDA.W BirdsTilemap,X      
                    STA.W $0202,Y             
                    PLX                       
                    LDA $02                   
                    STA.W $0203,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$00                
                    STA.W $0420,Y             
                    RTS                       ; Return 

ADDR_02F42C:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02F434         
                    PLB                       
                    RTL                       ; Return 

ADDR_02F434:        INC.W $1570,X             
                    LDY.B #$04                
                    LDA.W $1570,X             
                    AND.B #$40                
                    BEQ ADDR_02F442           
                    LDY.B #$FE                
ADDR_02F442:        STY $B6,X                 
                    LDA.B #$FC                
                    STA $AA,X                 
                    JSR.W ADDR_02D294         
                    LDA.W $1540,X             
                    BNE ADDR_02F453           
                    JSR.W ADDR_02D288         
ADDR_02F453:        JSR.W ADDR_02F47C         
                    LDA $D8,X                 
                    SEC                       
                    SBC $1C                   
                    CMP.B #$F0                
                    BNE ADDR_02F462           
                    STZ.W $14C8,X             
ADDR_02F462:        RTS                       ; Return 


DATA_02F463:        .db $03,$04,$05,$04,$05,$06,$05,$06
                    .db $07,$06,$07,$08,$07,$08,$07,$08
                    .db $07,$08,$07,$08,$07,$08,$07,$08
                    .db $07

ADDR_02F47C:        LDA $14                   
                    AND.B #$0F                
                    BNE ADDR_02F485           
                    INC.W $151C,X             
ADDR_02F485:        LDY.W $151C,X             
                    LDA.W DATA_02F463,Y       
                    STA $00                   
                    LDY.W $15EA,X             
                    LDA $E4,X                 
                    SEC                       
                    SBC $1A                   
                    PHA                       
                    SEC                       
                    SBC $00                   
                    STA.W $0300,Y             
                    PLA                       
                    CLC                       
                    ADC $00                   
                    STA.W $0304,Y             
                    LDA $D8,X                 
                    SEC                       
                    SBC $1C                   
                    STA.W $0301,Y             
                    STA.W $0305,Y             
                    LDA.B #$C5                
                    STA.W $0302,Y             
                    STA.W $0306,Y             
                    LDA.B #$05                
                    STA.W $0303,Y             
                    ORA.B #$40                
                    STA.W $0307,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$02                
                    STA.W $0460,Y             
                    STA.W $0461,Y             
                    RTS                       ; Return 

ADDR_02F4CD:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02F4D5         
                    PLB                       
                    RTL                       ; Return 

ADDR_02F4D5:        LDA.B #$01                
                    STA.W $1B96               
                    LDA $E4,X                 
                    AND.B #$10                
                    BNE ADDR_02F4E6           
                    JSR.W ADDR_02F4EB         
                    JSR.W ADDR_02F53E         
ADDR_02F4E6:        RTS                       ; Return 


DATA_02F4E7:        .db $D4,$AB

DATA_02F4E9:        .db $BB,$9A

ADDR_02F4EB:        LDA.W $15EA,X             
                    CLC                       
                    ADC.B #$08                
                    TAY                       
                    LDA.B #$B8                
                    STA.W $0300,Y             
                    STA.W $0304,Y             
                    LDA.B #$B0                
                    STA.W $0301,Y             
                    LDA.B #$B8                
                    STA.W $0305,Y             
                    LDA $13                   
                    AND.B #$03                
                    BNE ADDR_02F516           
                    PHY                       
                    JSL.L ADDR_01ACF9         
                    PLY                       
                    AND.B #$03                
                    BNE ADDR_02F516           
                    INC $C2,X                 
ADDR_02F516:        PHX                       
                    LDA $C2,X                 
                    AND.B #$01                
                    TAX                       
                    LDA.W DATA_02F4E7,X       
                    STA.W $0302,Y             
                    LDA.W DATA_02F4E9,X       
                    STA.W $0306,Y             
                    LDA.B #$35                
                    STA.W $0303,Y             
                    STA.W $0307,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$00                
                    STA.W $0460,Y             
                    STA.W $0461,Y             
                    PLX                       
                    RTS                       ; Return 

ADDR_02F53E:        LDA $14                   
                    AND.B #$3F                
                    BNE ADDR_02F547           
                    JSR.W ADDR_02F548         
ADDR_02F547:        RTS                       ; Return 

ADDR_02F548:        LDY.B #$09                
ADDR_02F54A:        LDA.W $14C8,Y             
                    BEQ ADDR_02F553           
                    DEY                       
                    BPL ADDR_02F54A           
                    RTS                       ; Return 

ADDR_02F553:        LDA.B #$8B                
                    STA.W $009E,Y             
                    LDA.B #$08                
                    STA.W $14C8,Y             
                    PHX                       
                    TYX                       
                    JSL.L ADDR_07F7D2         
                    LDA.B #$BB                
                    STA $E4,X                 
                    LDA.B #$00                
                    STA.W $14E0,X             
                    LDA.B #$00                
                    STA.W $14D4,X             
                    LDA.B #$E0                
                    STA $D8,X                 
                    LDA.B #$20                
                    STA.W $1540,X             
                    PLX                       
                    RTS                       ; Return 

ADDR_02F57C:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02F759         
                    PLB                       
                    RTL                       ; Return 

ADDR_02F584:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02F66E         
                    PLB                       
                    RTL                       ; Return 

ADDR_02F58C:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02F639         
                    PLB                       
                    RTL                       ; Return 

ADDR_02F594:        PHB                       
                    PHK                       
                    PLB                       
                    PHX                       
                    JSR.W ADDR_02F5D0         
                    PLX                       
                    PLB                       
                    RTL                       ; Return 


DATA_02F59E:        .db $08,$18,$F8,$F8,$F8,$F8,$28,$28
                    .db $28,$28

DATA_02F5A8:        .db $00,$00,$FF,$FF,$FF,$FF,$00,$00
                    .db $00,$00

DATA_02F5B2:        .db $5F,$5F,$8F,$97,$A7,$AF,$8F,$97
                    .db $A7,$AF

DATA_02F5BC:        .db $9C,$9E,$A0,$B0,$B0,$A0,$A0,$B0
                    .db $B0,$A0

DATA_02F5C6:        .db $23,$23,$2D,$2D,$AD,$AD,$6D,$6D
                    .db $ED,$ED

ADDR_02F5D0:        LDA $1A                   
                    CMP.B #$46                
                    BCS ADDR_02F618           
                    LDX.B #$09                
                    LDY.B #$A0                
ADDR_02F5DA:        STZ $02                   
                    LDA.W DATA_02F59E,X       
                    SEC                       
                    SBC $1A                   
                    STA $00                   
                    LDA.W DATA_02F5A8,X       
                    SBC $1B                   
                    BEQ ADDR_02F5ED           
                    INC $02                   
ADDR_02F5ED:        LDA $00                   
                    STA.W $0300,Y             
                    LDA.W DATA_02F5B2,X       
                    STA.W $0301,Y             
                    LDA.W DATA_02F5BC,X       
                    STA.W $0302,Y             
                    LDA.W DATA_02F5C6,X       
                    STA.W $0303,Y             
                    PHY                       
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$02                
                    ORA $02                   
                    STA.W $0460,Y             
                    PLY                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_02F5DA           
ADDR_02F618:        RTS                       ; Return 


DATA_02F619:        .db $F8,$08,$F8,$08,$00,$00,$00,$00
DATA_02F621:        .db $00,$00,$10,$10,$20,$30,$40,$08
DATA_02F629:        .db $C7,$A7,$A7,$C7,$A9,$C9,$C9,$E0
DATA_02F631:        .db $A9,$69,$A9,$69,$29,$29,$29,$6B

ADDR_02F639:        LDX.B #$07                
                    LDY.B #$B0                
ADDR_02F63D:        LDA.B #$C0                
                    CLC                       
                    ADC.W DATA_02F619,X       
                    STA.W $0300,Y             
                    LDA.B #$70                
                    CLC                       
                    ADC.W DATA_02F621,X       
                    STA.W $0301,Y             
                    LDA.W DATA_02F629,X       
                    STA.W $0302,Y             
                    LDA.W DATA_02F631,X       
                    STA.W $0303,Y             
                    PHY                       
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$02                
                    STA.W $0460,Y             
                    PLY                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_02F63D           
                    RTS                       ; Return 

ADDR_02F66E:        LDA.W $18D9               
                    BEQ ADDR_02F676           
                    DEC.W $18D9               
ADDR_02F676:        CMP.B #$B0                
                    BNE ADDR_02F67F           
                    LDY.B #$0F                
                    STY.W $1DFC               ; / Play sound effect 
ADDR_02F67F:        CMP.B #$01                
                    BNE ADDR_02F688           
                    LDY.B #$10                
                    STY.W $1DFC               ; / Play sound effect 
ADDR_02F688:        CMP.B #$30                
                    BCC ADDR_02F69A           
                    CMP.B #$81                
                    BCC ADDR_02F698           
                    CLC                       
                    ADC.B #$4F                
                    EOR.B #$FF                
                    INC A                     
                    BRA ADDR_02F69A           
ADDR_02F698:        LDA.B #$30                
ADDR_02F69A:        STA $00                   
                    JSR.W ADDR_02F6B8         
                    RTS                       ; Return 


DATA_02F6A0:        .db $00,$10,$20,$00,$10,$20,$00,$10
                    .db $20,$00,$10,$20

DATA_02F6AC:        .db $00,$00,$00,$10,$10,$10,$20,$20
                    .db $20,$30,$30,$30

ADDR_02F6B8:        LDX.B #$0B                
                    LDY.B #$B0                
ADDR_02F6BC:        LDA.B #$B8                
                    CLC                       
                    ADC.W DATA_02F6A0,X       
                    STA.W $0200,Y             
                    LDA.B #$50                
                    SEC                       
                    SBC $1C                   
                    SEC                       
                    SBC $00                   
                    CLC                       
                    ADC.W DATA_02F6AC,X       
                    STA.W $0201,Y             
                    LDA.B #$A5                
                    STA.W $0202,Y             
                    LDA.B #$21                
                    STA.W $0203,Y             
                    PHY                       
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$02                
                    STA.W $0420,Y             
                    PLY                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_02F6BC           
                    RTS                       ; Return 


DATA_02F6F1:        .db $00,$00,$00,$00,$10,$10,$10,$10
                    .db $00,$00,$00,$00,$10,$10,$10,$10
                    .db $00,$00,$00,$00,$10,$10,$10,$10
                    .db $F2,$F2,$F2,$F2,$1E,$1E,$1E,$1E
DATA_02F711:        .db $00,$08,$18,$20,$00,$08,$18,$20
DATA_02F719:        .db $7D,$7D,$FD,$FD,$3D,$3D,$BD,$BD
DATA_02F721:        .db $A0,$B0,$B0,$A0,$A0,$B0,$B0,$A0
                    .db $A3,$B3,$B3,$A3,$A3,$B3,$B3,$A3
                    .db $A2,$B2,$B2,$A2,$A2,$B2,$B2,$A2
                    .db $A3,$B3,$B3,$A3,$A3,$B3,$B3,$A3
DATA_02F741:        .db $40,$44,$48,$4C,$F0,$F4,$F8,$FC
DATA_02F749:        .db $00,$01,$02,$03,$03,$03,$03,$03
                    .db $03,$03,$03,$03,$03,$02,$01,$00

ADDR_02F759:        LDA.W $18D9               
                    BEQ ADDR_02F761           
                    DEC.W $18D9               
ADDR_02F761:        CMP.B #$76                
                    BNE ADDR_02F76A           
                    LDY.B #$0F                
                    STY.W $1DFC               ; / Play sound effect 
ADDR_02F76A:        CMP.B #$08                
                    BNE ADDR_02F773           
                    LDY.B #$10                
                    STY.W $1DFC               ; / Play sound effect 
ADDR_02F773:        LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_02F749,Y       
                    STA $03                   
                    LDX.B #$07                
                    LDA.B #$B8                
                    SEC                       
                    SBC $1A                   
                    STA $00                   
                    LDA.B #$60                
                    SEC                       
                    SBC $1C                   
                    STA $01                   
ADDR_02F78C:        STX $02                   
                    LDY.W DATA_02F741,X       
                    LDA $03                   
                    ASL                       
                    ASL                       
                    ASL                       
                    CLC                       
                    ADC $02                   
                    TAX                       
                    TYA                       
                    BMI ADDR_02F7D0           
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_02F6F1,X       
                    STA.W $0300,Y             
                    LDA.W DATA_02F721,X       
                    STA.W $0302,Y             
                    LDX $02                   
                    LDA $01                   
                    CLC                       
                    ADC.W DATA_02F711,X       
                    STA.W $0301,Y             
                    LDA $03                   
                    CMP.B #$03                
                    LDA.W DATA_02F719,X       
                    BCC ADDR_02F7C2           
                    EOR.B #$40                
ADDR_02F7C2:        STA.W $0303,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$02                
                    STA.W $0460,Y             
                    BRA ADDR_02F801           
ADDR_02F7D0:        LDA $00                   
                    CLC                       
                    ADC.W DATA_02F6F1,X       
                    STA.W $0200,Y             
                    LDA.W DATA_02F721,X       
                    STA.W $0202,Y             
                    LDX $02                   
                    LDA $01                   
                    CLC                       
                    ADC.W DATA_02F711,X       
                    STA.W $0201,Y             
                    LDA $03                   
                    CMP.B #$03                
                    LDA.W DATA_02F719,X       
                    BCC ADDR_02F7F5           
                    EOR.B #$40                
ADDR_02F7F5:        STA.W $0203,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$02                
                    STA.W $0420,Y             
ADDR_02F801:        DEX                       
                    BMI ADDR_02F807           
                    JMP.W ADDR_02F78C         
ADDR_02F807:        RTS                       ; Return 

ADDR_02F808:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_02F810         
                    PLB                       
                    RTL                       ; Return 

ADDR_02F810:        LDX.B #$13                
ADDR_02F812:        STX.W $15E9               
                    LDA.W $1892,X             
                    BEQ ADDR_02F81D           
                    JSR.W ADDR_02F821         
ADDR_02F81D:        DEX                       
                    BPL ADDR_02F812           
ADDR_02F820:        RTS                       ; Return 

ADDR_02F821:        JSL.L ExecutePtr          

Ptrs02F825:         .dw ADDR_02F820           
                    .dw ADDR_02FDBC           
                    .dw $0000                 
                    .dw ADDR_02FBC7           
                    .dw ADDR_02FA98           
                    .dw ADDR_02FA16           
                    .dw ADDR_02F91C           
                    .dw ADDR_02F83D           
                    .dw ADDR_02FBC7           

DATA_02F837:        .db $01,$FF

DATA_02F839:        .db $00,$FF,$02,$0E

ADDR_02F83D:        LDA.W $190A               
                    STA.W $185E               
                    TXY                       
                    BNE ADDR_02F855           
                    DEC.W $190A               
                    CMP.B #$00                
                    BNE ADDR_02F855           
                    INC.W $18BA               
                    LDY.B #$FF                
                    STY.W $190A               
ADDR_02F855:        CMP.B #$00                
                    BNE ADDR_02F89E           
                    LDA.W $18BF               
                    BEQ ADDR_02F865           
                    STZ.W $1892,X             
                    STZ.W $18BA               
                    RTS                       ; Return 

ADDR_02F865:        LDA.W $1E66,X             
                    STA $00                   
                    LDA.W $1E52,X             
                    STA $01                   
                    LDA.W $18BA               
                    AND.B #$01                
                    BNE ADDR_02F880           
                    LDA.W $1E8E,X             
                    STA $00                   
                    LDA.W $1E7A,X             
                    STA $01                   
ADDR_02F880:        LDA $00                   
                    CLC                       
                    ADC $1A                   
                    STA.W $1E16,X             
                    LDA $1B                   
                    ADC.B #$00                
                    STA.W $1E3E,X             
                    LDA $01                   
                    CLC                       
                    ADC $1C                   
                    STA.W $1E02,X             
                    LDA $1D                   
                    ADC.B #$00                
                    STA.W $1E2A,X             
ADDR_02F89E:        TXA                       
                    ASL                       
                    ASL                       
                    ADC $14                   
                    STA $00                   
                    AND.B #$07                
                    ORA $9D                   
                    BNE ADDR_02F8C8           
                    LDA $00                   
                    AND.B #$20                
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W $1E02,X             
                    CLC                       
                    ADC.W DATA_02F837,Y       
                    STA.W $1E02,X             
                    LDA.W $1E2A,X             
                    ADC.W DATA_02F839,Y       
                    STA.W $1E2A,X             
ADDR_02F8C8:        LDY.W $185E               
                    CPY.B #$20                
                    BCC ADDR_02F8FB           
                    CPY.B #$40                
                    BCS ADDR_02F8D8           
                    TYA                       
                    SBC.B #$1F                
                    BRA ADDR_02F8E2           
ADDR_02F8D8:        CPY.B #$E0                
                    BCC ADDR_02F8E6           
                    TYA                       
                    SBC.B #$E0                
                    EOR.B #$1F                
                    INC A                     
ADDR_02F8E2:        LSR                       
                    LSR                       
                    BRA ADDR_02F8EB           
ADDR_02F8E6:        JSR.W ADDR_02FBB0         
                    LDA.B #$08                
ADDR_02F8EB:        STA.W $190B               
                    CPX.B #$00                
                    BNE ADDR_02F8F6           
                    JSL.L ADDR_038239         
ADDR_02F8F6:        LDA.B #$0F                
                    JSR.W ADDR_02FD48         
ADDR_02F8FB:        RTS                       ; Return 


DATA_02F8FC:        .db $00,$10,$00,$10,$08,$10,$FF,$10
SumoBroFlameTiles:  .db $DC,$EC,$CC,$EC,$CC,$DC,$00,$CC
DATA_02F90C:        .db $03,$03,$03,$03,$02,$01,$00,$00
                    .db $00,$00,$00,$00,$01,$02,$03,$03

ADDR_02F91C:        LDA.W $0F4A,X             
                    BEQ ADDR_02F93C           
                    LDY $9D                   
                    BNE ADDR_02F928           
                    DEC.W $0F4A,X             
ADDR_02F928:        LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_02F90C,Y       
                    ASL                       
                    STA.W $185E               
                    JSR.W ADDR_02F9AE         
                    PHX                       
                    JSR.W ADDR_02F940         
                    PLX                       
                    RTS                       ; Return 

ADDR_02F93C:        STZ.W $1892,X             
                    RTS                       ; Return 

ADDR_02F940:        TXA                       
                    ASL                       
                    TAY                       
                    LDA.W DATA_02FF50,Y       
                    STA.W $15EA               
                    LDA.W $1E16,X             
                    STA $E4                   
                    LDA.W $1E3E,X             
                    STA.W $14E0               
                    LDA.W $1E02,X             
                    STA $D8                   
                    LDA.W $1E2A,X             
                    STA.W $14D4               
                    TAY                       
                    LDX.B #$00                
                    JSR.W GetDrawInfo2        
                    LDX.B #$01                
ADDR_02F967:        PHX                       
                    LDA $00                   
                    STA.W $0300,Y             
                    TXA                       
                    ORA.W $185E               
                    TAX                       
                    LDA.W DATA_02F8FC,X       
                    BMI ADDR_02F993           
                    CLC                       
                    ADC $01                   
                    STA.W $0301,Y             
                    LDA.W SumoBroFlameTiles,X 
                    STA.W $0302,Y             
                    LDA $14                   
                    AND.B #$04                
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    NOP                       
                    ORA $64                   
                    ORA.B #$05                
                    STA.W $0303,Y             
ADDR_02F993:        PLX                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_02F967           
                    LDX.B #$00                
                    LDY.B #$02                
                    LDA.B #$01                
                    JSL.L ADDR_01B7B3         
                    RTS                       ; Return 

ADDR_02F9A6:        STZ.W $1892,X             
                    RTS                       ; Return 


DATA_02F9AA:        .db $02,$0A,$12,$1A

ADDR_02F9AE:        TXA                       
                    EOR $13                   
                    AND.B #$03                
                    BNE ADDR_02F9FE           
                    LDA.W $0F4A,X             
                    CMP.B #$10                
                    BCC ADDR_02F9FE           
                    LDA.W $1E16,X             
                    CLC                       
                    ADC.B #$02                
                    STA $04                   
                    LDA.W $1E3E,X             
                    ADC.B #$00                
                    STA $0A                   
                    LDA.B #$0C                
                    STA $06                   
                    LDY.W $185E               
                    LDA.W $1E02,X             
                    CLC                       
                    ADC.W DATA_02F9AA,Y       
                    STA $05                   
                    LDA.B #$14                
                    STA $07                   
                    LDA.W $1E2A,X             
                    ADC.B #$00                
                    STA $0B                   
                    JSL.L ADDR_03B664         
                    JSL.L ADDR_03B72B         
                    BCC ADDR_02F9FE           
                    LDA.W $1490               
                    BNE ADDR_02F9A6           
ADDR_02F9F5:        LDA.W $187A               
                    BNE ADDR_02F9FF           
                    JSL.L HurtMario           
ADDR_02F9FE:        RTS                       ; Return 

ADDR_02F9FF:        JMP.W ADDR_02A473         

DATA_02FA02:        .db $03,$07,$07,$07,$0F,$07,$07,$0F
DATA_02FA0A:        .db $F0,$F4,$F8,$FC

CstleBGFlameTiles:  .db $E2,$E4,$E2,$E4

DATA_02FA12:        .db $09,$09,$49,$49

ADDR_02FA16:        LDA $9D                   
                    BNE ADDR_02FA2B           
                    JSL.L ADDR_01ACF9         
                    AND.B #$07                
                    TAY                       
                    LDA $13                   
                    AND.W DATA_02FA02,Y       
                    BNE ADDR_02FA2B           
                    INC.W $0F4A,X             
ADDR_02FA2B:        LDY.W DATA_02FA0A,X       
                    LDA.W $1E16,X             
                    SEC                       
                    SBC $1E                   
                    STA.W $0300,Y             
                    LDA.W $1E02,X             
                    SEC                       
                    SBC $20                   
                    STA.W $0301,Y             
                    PHY                       
                    PHX                       
                    LDA.W $0F4A,X             
                    AND.B #$03                
                    TAX                       
                    LDA.W CstleBGFlameTiles,X 
                    STA.W $0302,Y             
                    LDA.W DATA_02FA12,X       
                    STA.W $0303,Y             
                    PLX                       
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$02                
                    STA.W $0460,Y             
                    PLY                       
                    LDA.W $0300,Y             
                    CMP.B #$F0                
                    BCC ADDR_02FA83           
                    LDA.W $0300,Y             
                    STA.W $03EC               
                    LDA.W $0301,Y             
                    STA.W $03ED               
                    LDA.W $0302,Y             
                    STA.W $03EE               
                    LDA.W $0303,Y             
                    STA.W $03EF               
                    LDA.B #$03                
                    STA.W $049B               
ADDR_02FA83:        RTS                       ; Return 


DATA_02FA84:        .db $00

DATA_02FA85:        .db $00,$28,$00,$50,$00,$78,$00,$A0
                    .db $00,$C8,$00,$F0,$00,$18,$01,$40
                    .db $01,$68,$01

ADDR_02FA98:        LDY.W $0F86,X             
                    LDA.W $0FBA,Y             
                    BEQ ADDR_02FAA4           
                    STZ.W $1892,X             
                    RTS                       ; Return 

ADDR_02FAA4:        LDA $9D                   
                    BNE ADDR_02FAF0           
                    LDA.W $0F4A,X             
                    BEQ ADDR_02FAF0           
                    STZ $00                   
                    BPL ADDR_02FAB3           
                    DEC $00                   
ADDR_02FAB3:        CLC                       
                    ADC.W $0FAE,Y             
                    STA.W $0FAE,Y             
                    LDA.W $0FB0,Y             
                    ADC $00                   
                    AND.B #$01                
                    STA.W $0FB0,Y             
                    LDA.W $0FB2,Y             
                    STA $00                   
                    LDA.W $0FB4,Y             
                    STA $01                   
                    REP #$20                  ; Accum (16 bit) 
                    LDA $00                   
                    SEC                       
                    SBC $1A                   
                    CLC                       
                    ADC.W #$0080              
                    CMP.W #$0200              
                    SEP #$20                  ; Accum (8 bit) 
                    BCC ADDR_02FAF0           
                    LDA.B #$01                
                    STA.W $0FBA,Y             
                    PHX                       
                    LDX.W $0FBC,Y             
                    STZ.W $1938,X             
                    PLX                       
                    DEC.W $18BA               
ADDR_02FAF0:        PHX                       
                    LDA.W $0F72,X             
                    ASL                       
                    TAX                       
                    LDA.W DATA_02FA84,X       
                    CLC                       
                    ADC.W $0FAE,Y             
                    STA $00                   
                    LDA.W DATA_02FA85,X       
                    ADC.W $0FB0,Y             
                    AND.B #$01                
                    STA $01                   
                    PLX                       
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA $00                   
                    CLC                       
                    ADC.W #$0080              
                    AND.W #$01FF              
                    STA $02                   
                    LDA $00                   
                    AND.W #$00FF              
                    ASL                       
                    TAX                       
                    LDA.L CircleCoords,X      
                    STA $04                   
                    LDA $02                   
                    AND.W #$00FF              
                    ASL                       
                    TAX                       
                    LDA.L CircleCoords,X      
                    STA $06                   
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDA $04                   
                    STA.W $4202               ; Multiplicand A
                    LDA.B #$50                
                    LDY $05                   
                    BNE ADDR_02FB4D           
                    STA.W $4203               ; Multplier B
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    ASL.W $4216               ; Product/Remainder Result (Low Byte)
                    LDA.W $4217               ; Product/Remainder Result (High Byte)
                    ADC.B #$00                
ADDR_02FB4D:        LSR $01                   
                    BCC ADDR_02FB54           
                    EOR.B #$FF                
                    INC A                     
ADDR_02FB54:        STA $04                   
                    LDA $06                   
                    STA.W $4202               ; Multiplicand A
                    LDA.B #$50                
                    LDY $07                   
                    BNE ADDR_02FB70           
                    STA.W $4203               ; Multplier B
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    ASL.W $4216               ; Product/Remainder Result (Low Byte)
                    LDA.W $4217               ; Product/Remainder Result (High Byte)
                    ADC.B #$00                
ADDR_02FB70:        LSR $03                   
                    BCC ADDR_02FB77           
                    EOR.B #$FF                
                    INC A                     
ADDR_02FB77:        STA $06                   
                    LDX.W $15E9               
                    LDY.W $0F86,X             
                    STZ $00                   
                    LDA $04                   
                    BPL ADDR_02FB87           
                    DEC $00                   
ADDR_02FB87:        CLC                       
                    ADC.W $0FB2,Y             
                    STA.W $1E16,X             
                    LDA.W $0FB4,Y             
                    ADC $00                   
                    STA.W $1E3E,X             
                    STZ $01                   
                    LDA $06                   
                    BPL ADDR_02FB9E           
                    DEC $01                   
ADDR_02FB9E:        CLC                       
                    ADC.W $0FB6,Y             
                    STA.W $1E02,X             
                    LDA.W $0FB8,Y             
                    ADC $01                   
                    STA.W $1E2A,X             
                    JSR.W ADDR_02FC8D         
ADDR_02FBB0:        TXA                       
                    EOR $13                   
                    AND.B #$03                
                    BNE ADDR_02FBBA           
                    JSR.W ADDR_02FE71         
ADDR_02FBBA:        RTS                       ; Return 


DATA_02FBBB:        .db $01,$FF

DATA_02FBBD:        .db $08,$F8

BooRingTiles:       .db $88,$8C,$A8,$8E,$AA,$AE,$88,$8C

ADDR_02FBC7:        CPX.B #$00                
                    BEQ ADDR_02FBCE           
                    JMP.W ADDR_02FC41         
ADDR_02FBCE:        LDA $13                   
                    AND.B #$07                
                    ORA $9D                   
                    BNE ADDR_02FC3E           
                    JSL.L ADDR_01ACF9         
                    AND.B #$1F                
                    CMP.B #$14                
                    BCC ADDR_02FBE2           
                    SBC.B #$14                
ADDR_02FBE2:        TAX                       
                    LDA.W $0F86,X             
                    BNE ADDR_02FC3E           
                    INC.W $0F86,X             
                    LDA.B #$20                
                    STA.W $0F9A,X             
                    STZ $00                   
                    LDA.W $1E16,X             
                    SBC $1A                   
                    ADC $1A                   
                    PHP                       
                    ADC $00                   
                    STA.W $1E16,X             
                    STA $E4                   
                    LDA $1B                   
                    ADC.B #$00                
                    PLP                       
                    ADC.B #$00                
                    STA.W $1E3E,X             
                    STA.W $14E0               
                    LDA.W $1E02,X             
                    SBC $1C                   
                    ADC $1C                   
                    STA.W $1E02,X             
                    STA $D8                   
                    AND.B #$FC                
                    STA.W $0F72,X             
                    LDA $1D                   
                    ADC.B #$00                
                    STA.W $1E2A,X             
                    STA.W $14D4               
                    PHX                       
                    LDX.B #$00                
                    LDA.B #$10                
                    JSR.W ADDR_02D2FB         
                    PLX                       
                    LDA $00                   
                    ADC.B #$09                
                    STA.W $1E52,X             
                    LDA $01                   
                    STA.W $1E66,X             
ADDR_02FC3E:        LDX.W $15E9               
ADDR_02FC41:        LDA $9D                   
                    BNE ADDR_02FC4D           
                    LDA.W $0F9A,X             
                    BEQ ADDR_02FC4D           
                    DEC.W $0F9A,X             
ADDR_02FC4D:        LDA.W $0F86,X             
                    BNE ADDR_02FC55           
                    JMP.W ADDR_02FCE2         
ADDR_02FC55:        LDA $9D                   
                    BNE ADDR_02FC8D           
                    LDA.W $0F9A,X             
                    BNE ADDR_02FC78           
                    JSR.W ADDR_02FF98         
                    JSR.W ADDR_02FFA3         
                    TXA                       
                    EOR $13                   
                    AND.B #$03                
                    BNE ADDR_02FC78           
                    JSR.W ADDR_02FE71         
                    LDA.W $1E52,X             
                    CMP.B #$E1                
                    BMI ADDR_02FC78           
                    DEC.W $1E52,X             
ADDR_02FC78:        LDA.W $1E02,X             
                    AND.B #$FC                
                    CMP.W $0F72,X             
                    BNE ADDR_02FC8D           
                    LDA.W $1E52,X             
                    BPL ADDR_02FC8D           
                    STZ.W $0F86,X             
                    STZ.W $1E66,X             
ADDR_02FC8D:        LDA.W $1E16,X             
                    STA $00                   
                    LDA.W $1E3E,X             
                    STA $01                   
                    REP #$20                  ; Accum (16 bit) 
                    LDA $00                   
                    SEC                       
                    SBC $1A                   
                    CLC                       
                    ADC.W #$0040              
                    CMP.W #$0180              
                    SEP #$20                  ; Accum (8 bit) 
                    BCS ADDR_02FCD8           
                    LDA.B #$02                
                    JSR.W ADDR_02FD48         
                    LDA.W $1E02,X             
                    CLC                       
                    ADC.B #$10                
                    PHP                       
                    CMP $1C                   
                    LDA.W $1E2A,X             
                    SBC $1D                   
                    PLP                       
                    ADC.B #$00                
                    BNE ADDR_02FCD9           
                    LDA.W $1E16,X             
                    CMP $1A                   
                    LDA.W $1E3E,X             
                    SBC $1B                   
                    BEQ ADDR_02FCD8           
                    LDA.W DATA_02FF50,X       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$03                
                    STA.W $0460,Y             
ADDR_02FCD8:        RTS                       ; Return 

ADDR_02FCD9:        LDY.W DATA_02FF50,X       
                    LDA.B #$F0                
                    STA.W $0301,Y             
                    RTS                       ; Return 

ADDR_02FCE2:        LDA $9D                   
                    BNE ADDR_02FD46           
                    LDA.W $1892,X             
                    CMP.B #$08                
                    BEQ ADDR_02FD46           
                    LDA.W $0F9A,X             
                    BNE ADDR_02FD1A           
                    LDA $13                   
                    AND.B #$01                
                    BNE ADDR_02FD1A           
                    LDA.W $0F4A,X             
                    AND.B #$01                
                    TAY                       
                    LDA.W $1E66,X             
                    CLC                       
                    ADC.W DATA_02FBBB,Y       
                    STA.W $1E66,X             
                    CMP.W DATA_02FBBD,Y       
                    BNE ADDR_02FD1A           
                    INC.W $0F4A,X             
                    LDA.W $148D               
                    AND.B #$FF                
                    ORA.B #$3F                
                    STA.W $0F9A,X             
ADDR_02FD1A:        JSR.W ADDR_02FF98         
                    TXA                       
                    EOR $13                   
                    AND.B #$03                
                    BNE ADDR_02FD46           
                    STZ $00                   
                    LDY.B #$01                
                    TXA                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ADC $13                   
                    AND.B #$40                
                    BEQ ADDR_02FD36           
                    LDY.B #$FF                
                    DEC $00                   
ADDR_02FD36:        TYA                       
                    CLC                       
                    ADC.W $1E02,X             
                    STA.W $1E02,X             
                    LDA $00                   
                    ADC.W $1E2A,X             
                    STA.W $1E2A,X             
ADDR_02FD46:        LDA.B #$0E                
ADDR_02FD48:        STA $02                   
                    LDY.W DATA_02FF50,X       
                    LDA.W $1E16,X             
                    SEC                       
                    SBC $1A                   
                    STA.W $0300,Y             
                    LDA.W $1E02,X             
                    SEC                       
                    SBC $1C                   
                    STA.W $0301,Y             
                    LDA $14                   
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.B #$01                
                    STA $00                   
                    TXA                       
                    AND.B #$03                
                    ASL                       
                    ADC $00                   
                    PHX                       
                    TAX                       
                    LDA.W BooRingTiles,X      
                    STA.W $0302,Y             
                    PLX                       
                    LDA.W $1E66,X             
                    ASL                       
                    LDA.B #$00                
                    BCS ADDR_02FD81           
                    LDA.B #$40                
ADDR_02FD81:        ORA.B #$31                
                    ORA $02                   
                    STA.W $0303,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$02                
                    STA.W $0460,Y             
                    LDA.W $1892,X             
                    CMP.B #$08                
                    BNE ADDR_02FDB7           
                    LDY.W DATA_02FF50,X       
                    LDA $14                   
                    LSR                       
                    LSR                       
                    AND.B #$01                
                    STA $00                   
                    LDA.W $0F86,X             
                    ASL                       
                    ORA $00                   
                    PHX                       
                    TAX                       
                    LDA.W BatCeilingTiles,X   
                    STA.W $0302,Y             
                    LDA.B #$37                
                    STA.W $0303,Y             
                    PLX                       
ADDR_02FDB7:        RTS                       ; Return 


BatCeilingTiles:    .db $AE,$AE,$C0,$EB

ADDR_02FDBC:        JSR.W ADDR_02FFA3         
                    LDA.W $1E52,X             
                    CMP.B #$40                
                    BPL ADDR_02FDCC           
                    CLC                       
                    ADC.B #$03                
                    STA.W $1E52,X             
ADDR_02FDCC:        LDA.W $1E2A,X             
                    BEQ ADDR_02FDE0           
                    LDA.W $1E02,X             
                    CMP.B #$80                
                    BCC ADDR_02FDE0           
                    AND.B #$F0                
                    STA.W $1E02,X             
                    STZ.W $1E52,X             
ADDR_02FDE0:        TXA                       
                    EOR $13                   
                    LSR                       
                    BCC ADDR_02FE48           
                    LDA.W $1E52,X             
                    BNE ADDR_02FE10           
                    LDA.W $1E66,X             
                    CLC                       
                    ADC.W $1E16,X             
                    STA.W $1E16,X             
                    LDA.W $1E16,X             
                    EOR.W $1E66,X             
                    BPL ADDR_02FE10           
                    LDA.W $1E16,X             
                    CLC                       
                    ADC.B #$20                
                    CMP.B #$30                
                    BCS ADDR_02FE10           
                    LDA.W $1E66,X             
                    EOR.B #$FF                
                    INC A                     
                    STA.W $1E66,X             
ADDR_02FE10:        LDA $94                   
                    SEC                       
                    SBC.W $1E16,X             
                    CLC                       
                    ADC.B #$0C                
                    CMP.B #$1E                
                    BCS ADDR_02FE48           
                    LDA.B #$20                
                    LDY $73                   
                    BNE ADDR_02FE29           
                    LDY $19                   
                    BEQ ADDR_02FE29           
                    LDA.B #$30                
ADDR_02FE29:        STA $00                   
                    LDA $96                   
                    SEC                       
                    SBC.W $1E02,X             
                    CLC                       
                    ADC.B #$20                
                    CMP $00                   
                    BCS ADDR_02FE48           
                    STZ.W $1892,X             
                    JSR.W ADDR_02FF6C         
                    DEC.W $1920               
                    BNE ADDR_02FE48           
                    LDA.B #$58                
                    STA.W $14AB               
ADDR_02FE48:        LDY.W DATA_02FF64,X       
                    LDA.W $1E16,X             
                    SEC                       
                    SBC $1A                   
                    STA.W $0200,Y             
                    LDA.W $1E02,X             
                    SEC                       
                    SBC $1C                   
                    STA.W $0201,Y             
                    LDA.B #$24                
                    STA.W $0202,Y             
                    LDA.B #$3A                
                    STA.W $0203,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$02                
                    STA.W $0420,Y             
                    RTS                       ; Return 

ADDR_02FE71:        LDA.B #$14                
                    BRA ADDR_02FE77           
                    LDA.B #$0C                
ADDR_02FE77:        STA $02                   
                    STZ $03                   
                    LDA.W $1E16,X             
                    STA $00                   
                    LDA.W $1E3E,X             
                    STA $01                   
                    REP #$20                  ; Accum (16 bit) 
                    LDA $94                   
                    SEC                       
                    SBC $00                   
                    CLC                       
                    ADC.W #$000A              
                    CMP $02                   
                    SEP #$20                  ; Accum (8 bit) 
                    BCS ADDR_02FEC4           
                    LDA.W $1E02,X             
                    ADC.B #$03                
                    STA $02                   
                    LDA.W $1E2A,X             
                    ADC.B #$00                
                    STA $03                   
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W #$0014              
                    LDY $19                   
                    BEQ ADDR_02FEB0           
                    LDA.W #$0020              
ADDR_02FEB0:        STA $04                   
                    LDA $96                   
                    SEC                       
                    SBC $02                   
                    CLC                       
                    ADC.W #$001C              
                    CMP $04                   
                    SEP #$20                  ; Accum (8 bit) 
                    BCS ADDR_02FEC4           
                    JSR.W ADDR_02F9F5         
ADDR_02FEC4:        RTS                       ; Return 


DATA_02FEC5:        .db $40,$B0

DATA_02FEC7:        .db $01,$FF

DATA_02FEC9:        .db $30,$C0

DATA_02FECB:        .db $01,$FF

                    LDA $5B                   
                    AND.B #$01                
                    BNE ADDR_02FF1E           
                    LDA.W $1E02,X             
                    CLC                       
                    ADC.B #$50                
                    LDA.W $1E2A,X             
                    ADC.B #$00                
                    CMP.B #$02                
                    BPL ADDR_02FF0E           
                    LDA $13                   
                    AND.B #$01                
                    STA $01                   
                    TAY                       
                    LDA $1A                   
                    CLC                       
                    ADC.W DATA_02FEC9,Y       
                    ROL $00                   
                    CMP.W $1E16,X             
                    PHP                       
                    LDA $1B                   
                    LSR $00                   
                    ADC.W DATA_02FECB,Y       
                    PLP                       
                    SBC.W $1E3E,X             
                    STA $00                   
                    LSR $01                   
                    BCC ADDR_02FF0A           
                    EOR.B #$80                
                    STA $00                   
ADDR_02FF0A:        LDA $00                   
                    BPL ADDR_02FF1D           
ADDR_02FF0E:        LDY.W $0F86,X             
                    CPY.B #$FF                
                    BEQ ADDR_02FF1A           
                    LDA.B #$00                
                    STA.W $1938,Y             
ADDR_02FF1A:        STZ.W $1892,X             
ADDR_02FF1D:        RTS                       ; Return 

ADDR_02FF1E:        LDA $13                   
                    LSR                       
                    BCS ADDR_02FF1D           
                    AND.B #$01                
                    STA $01                   
                    TAY                       
                    LDA $1A                   
                    CLC                       
                    ADC.W DATA_02FEC5,Y       
                    ROL $00                   
                    CMP.W $1E02,X             
                    PHP                       
                    LDA.W $001D               
                    LSR $00                   
                    ADC.W DATA_02FEC7,Y       
                    PLP                       
                    SBC.W $1E2A,X             
                    STA $00                   
                    LDY $01                   
                    BEQ ADDR_02FF4A           
                    EOR.B #$80                
                    STA $00                   
ADDR_02FF4A:        LDA $00                   
                    BPL ADDR_02FF1D           
                    BMI ADDR_02FF0E           

DATA_02FF50:        .db $E0,$E4,$E8,$EC,$F0,$F4,$F8,$FC
                    .db $5C,$58,$54,$50,$4C,$48,$44,$40
                    .db $3C,$38,$34,$30

DATA_02FF64:        .db $90,$94,$98,$9C,$A0,$A4,$A8,$AC

ADDR_02FF6C:        JSL.L ADDR_02AD34         
                    LDA.B #$0D                
                    STA.W $16E1,Y             
                    LDA.W $1E02,X             
                    SEC                       
                    SBC.B #$08                
                    STA.W $16E7,Y             
                    LDA.W $1E2A,X             
                    SBC.B #$00                
                    STA.W $16F9,Y             
                    LDA.W $1E16,X             
                    STA.W $16ED,Y             
                    LDA.W $1E3E,X             
                    STA.W $16F3,Y             
                    LDA.B #$30                
                    STA.W $16FF,Y             
                    RTS                       ; Return 

ADDR_02FF98:        PHX                       
                    TXA                       
                    CLC                       
                    ADC.B #$14                
                    TAX                       
                    JSR.W ADDR_02FFA3         
                    PLX                       
                    RTS                       ; Return 

ADDR_02FFA3:        LDA.W $1E52,X             
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    CLC                       
                    ADC.W $1E7A,X             
                    STA.W $1E7A,X             
                    PHP                       
                    LDA.W $1E52,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    CMP.B #$08                
                    LDY.B #$00                
                    BCC ADDR_02FFC2           
                    ORA.B #$F0                
                    DEY                       
ADDR_02FFC2:        PLP                       
                    ADC.W $1E02,X             
                    STA.W $1E02,X             
                    TYA                       
                    ADC.W $1E2A,X             
                    STA.W $1E2A,X             
                    RTS                       ; Return 

ADDR_02FFD1:        LDA.W $1588,X             
                    BMI ADDR_02FFDD           
                    LDA.B #$00                
                    LDY.W $15B8,X             
                    BEQ ADDR_02FFDF           
ADDR_02FFDD:        LDA.B #$18                
ADDR_02FFDF:        STA $AA,X                 
                    RTS                       ; Return 


DATA_02FFE2:        .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF
