.INCLUDE "snes.cfg"
.BANK 4
DATA_048000:        .db $80,$B4,$98,$B4,$B0,$B4

DATA_048006:        .db $00,$B3,$18,$B3,$30,$B3,$48,$B3
                    .db $60,$B3,$78,$B3,$90,$B3,$A8,$B3
                    .db $C0,$B3,$D8,$B3,$F0,$B3,$08,$B4
                    .db $20,$B4,$38,$B4,$50,$B4,$68,$B4
                    .db $80,$B4,$98,$B4,$B0,$B4,$C8,$B4
                    .db $E0,$B4,$F8,$B4,$10,$B5,$28,$B5
                    .db $40,$B5,$58,$B5,$70,$B5,$88,$B5
                    .db $A0,$B5,$B8,$B5,$D0,$B5,$E8,$B5
                    .db $00,$B6,$18,$B6,$30,$B6,$48,$B6
                    .db $60,$B6,$78,$B6,$90,$B6,$A8,$B6
                    .db $C0,$B6,$D8,$B6,$F0,$B6,$08,$B7
                    .db $20,$B7,$38,$B7,$50,$B7,$68,$B7
                    .db $80,$B7,$98,$B7,$B0,$B7,$C8,$B7
                    .db $E0,$B7,$F8,$B7,$10,$B8,$28,$B8
                    .db $40,$B8,$58,$B8,$70,$B8,$88,$B8
                    .db $A0,$B8,$B8,$B8,$D0,$B8,$E8,$B8

ADDR_048086:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    STZ $03                   
                    STZ $05                   
ADDR_04808C:        LDX $03                   
                    LDA.W DATA_048000,X       
                    STA $00                   
                    SEP #$10                  ; Index (8 bit) 
                    LDY.B #$7E                
                    STY $02                   
                    REP #$10                  ; Index (16 bit) 
                    LDX $05                   
                    JSR.W ADDR_0480B9         
                    LDA $05                   
                    CLC                       
                    ADC.W #$0020              
                    STA $05                   
                    LDA $03                   
                    INC A                     
                    INC A                     
                    STA $03                   
                    AND.W #$00FF              
                    CMP.W #$0006              
                    BNE ADDR_04808C           
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    RTS                       ; Return 

ADDR_0480B9:        LDY.W #$0000              ; Index (16 bit) Accum (16 bit) 
                    LDA.W #$0008              
                    STA $07                   
                    STA $09                   
ADDR_0480C3:        LDA [$00],Y               
                    STA.W $0AF6,X             
                    INY                       
                    INY                       
                    INX                       
                    INX                       
                    DEC $07                   
                    BNE ADDR_0480C3           
ADDR_0480D0:        LDA [$00],Y               
                    AND.W #$00FF              
                    STA.W $0AF6,X             
                    INY                       
                    INX                       
                    INX                       
                    DEC $09                   
                    BNE ADDR_0480D0           
                    RTS                       ; Return 

ADDR_0480E0:        LDA $13                   ; Index (8 bit) Accum (8 bit) 
                    AND.B #$07                
                    BNE ADDR_048101           
                    LDX.B #$1F                
ADDR_0480E8:        LDA.W $0AF6,X             
                    STA $00                   
                    TXA                       
                    AND.B #$08                
                    BNE ADDR_0480F9           
                    ASL $00                   
                    ROL.W $0AF6,X             
                    BRA ADDR_0480FE           
ADDR_0480F9:        LSR $00                   
                    ROR.W $0AF6,X             
ADDR_0480FE:        DEX                       
                    BPL ADDR_0480E8           
ADDR_048101:        LDA $13                   
                    AND.B #$07                
                    BNE ADDR_04810C           
                    LDX.B #$20                
                    JSR.W ADDR_048172         
ADDR_04810C:        LDA $13                   
                    AND.B #$07                
                    BNE ADDR_048123           
                    LDX.B #$1F                
ADDR_048114:        LDA.W $0B36,X             
                    ASL                       
                    ROL.W $0B36,X             
                    DEX                       
                    BPL ADDR_048114           
                    LDX.B #$40                
                    JSR.W ADDR_048172         
ADDR_048123:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.W #$0060              
                    STA $0D                   
                    STZ $0B                   
ADDR_04812C:        LDX.W #$0038              
                    LDA $0B                   
                    CMP.W #$0020              
                    BCS ADDR_048139           
                    LDX.W #$0070              
ADDR_048139:        TXA                       
                    AND $13                   
                    LSR                       
                    LSR                       
                    CPX.W #$0038              
                    BEQ ADDR_048144           
                    LSR                       
ADDR_048144:        CLC                       
                    ADC $0B                   
                    TAX                       
                    LDA.W DATA_048006,X       
                    STA $00                   
                    SEP #$10                  ; Index (8 bit) 
                    LDY.B #$7E                
                    STY $02                   
                    REP #$10                  ; Index (16 bit) 
                    LDX $0D                   
                    JSR.W ADDR_0480B9         
                    LDA $0D                   
                    CLC                       
                    ADC.W #$0020              
                    STA $0D                   
                    LDA $0B                   
                    CLC                       
                    ADC.W #$0010              
                    STA $0B                   
                    CMP.W #$0080              
                    BNE ADDR_04812C           
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    RTS                       ; Return 

ADDR_048172:        REP #$20                  ; Accum (16 bit) 
                    LDY.B #$00                
ADDR_048176:        PHX                       
                    TXA                       
                    CLC                       
                    ADC.W #$000E              
                    TAX                       
                    LDA.W $0AF6,X             
                    STA $00                   
                    PLX                       
ADDR_048183:        LDA.W $0AF6,X             
                    STA $02                   
                    LDA $00                   
                    STA.W $0AF6,X             
                    LDA $02                   
                    STA $00                   
                    INX                       
                    INX                       
                    INY                       
                    CPY.B #$08                
                    BEQ ADDR_048176           
                    CPY.B #$10                
                    BNE ADDR_048183           
                    SEP #$20                  ; Accum (8 bit) 
                    RTS                       ; Return 


DATA_04819F:        .db $50,$CF,$00,$03,$7E,$78,$7E,$38
                    .db $50,$EF,$00,$03,$7F,$38,$7F,$78
                    .db $51,$C3,$00,$03,$7E,$78,$7D,$78
                    .db $51,$E3,$00,$03,$7E,$F8,$7D,$F8
                    .db $51,$DB,$00,$03,$7D,$38,$7E,$38
                    .db $51,$FB,$00,$03,$7D,$B8,$7E,$B8
                    .db $52,$EF,$00,$03,$7F,$B8,$7F,$F8
                    .db $53,$0F,$00,$03,$7E,$F8,$7E,$B8
                    .db $FF,$50,$CF,$40,$02,$FC,$00,$50
                    .db $EF,$40,$02,$FC,$00,$51,$C3,$40
                    .db $02,$FC,$00,$51,$E3,$40,$02,$FC
                    .db $00,$51,$DB,$40,$02,$FC,$00,$51
                    .db $FB,$40,$02,$FC,$00,$52,$EF,$40
                    .db $02,$FC,$00,$53,$0F,$40,$02,$FC
                    .db $00,$FF

DATA_048211:        .db $00,$00,$02,$00,$FE,$FF,$02,$00
                    .db $00,$00,$02,$00,$FE,$FF,$02,$00
DATA_048221:        .db $00,$00,$11,$01,$EF,$FF,$11,$01
                    .db $00,$00,$32,$01,$D7,$FF,$32,$01
DATA_048231:        .db $0F,$0F,$07,$07,$07,$03,$03,$03
                    .db $01,$01,$03,$03,$03,$07,$07,$07

ADDR_048241:        PHB                       
                    PHK                       
                    PLB                       
                    LDX.B #$01                
ADDR_048246:        LDA.W $0DA6,X             
                    AND.B #$20                
                    BRA ADDR_048261           
                    LDA.W $0DBA,X             
                    INC A                     
                    INC A                     
                    CMP.B #$04                
                    BCS ADDR_048258           
                    LDA.B #$04                
ADDR_048258:        CMP.B #$0B                
                    BCC ADDR_04825E           
                    LDA.B #$00                
ADDR_04825E:        STA.W $0DBA,X             
ADDR_048261:        DEX                       
                    BPL ADDR_048246           
                    JSR.W ADDR_0485A7         
                    JSR.W ADDR_0480E0         
                    LDA.W $13D2               
                    BEQ ADDR_048275           
                    JSR.W ADDR_04F290         
                    JMP.W ADDR_04840D         
ADDR_048275:        LDA.W $13C9               
                    BEQ ADDR_048281           
                    JSL.L ADDR_009B80         
                    JMP.W ADDR_048410         
ADDR_048281:        LDA.W $1B87               
                    BEQ ADDR_048295           
                    CMP.B #$05                
                    BCS ADDR_04828F           
                    LDY.W $0DB2               
                    BEQ ADDR_048295           
ADDR_04828F:        JSR.W ADDR_04F3E5         
                    JMP.W ADDR_048413         
ADDR_048295:        LDA.W $13D4               
                    LSR                       
                    BNE ADDR_04829E           
                    JMP.W ADDR_048356         
ADDR_04829E:        REP #$20                  ; Accum (16 bit) 
                    LDA.W $1DF2               
                    SEC                       
                    SBC $1C                   
                    STA $01                   
                    BPL ADDR_0482AE           
                    EOR.W #$FFFF              
                    INC A                     
ADDR_0482AE:        LSR                       
                    SEP #$20                  ; Accum (8 bit) 
                    STA $05                   
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W $1DF0               
                    SEC                       
                    SBC $1A                   
                    STA $00                   
                    BPL ADDR_0482C3           
                    EOR.W #$FFFF              
                    INC A                     
ADDR_0482C3:        LSR                       
                    SEP #$20                  ; Accum (8 bit) 
                    STA $04                   
                    LDX.B #$01                
                    CMP $05                   
                    BCS ADDR_0482D1           
                    DEX                       
                    LDA $05                   
ADDR_0482D1:        CMP.B #$02                
                    BCS ADDR_0482ED           
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W $1DF0               
                    STA $1A                   
                    STA $1E                   
                    LDA.W $1DF2               
                    STA $1C                   
                    STA $20                   
                    SEP #$20                  ; Accum (8 bit) 
                    STZ.W $13D4               
                    JMP.W ADDR_0483BD         
ADDR_0482ED:        STZ.W $4204               ; Dividend (Low Byte)
                    LDY $04,X                 
                    STY.W $4205               ; Dividend (High-Byte)
                    STA.W $4206               ; Divisor B
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W $4214               ; Quotient of Divide Result (Low Byte)
                    LSR                       
                    LSR                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDY $01,X                 
                    BPL ADDR_04830E           
                    EOR.B #$FF                
                    INC A                     
ADDR_04830E:        STA $01,X                 
                    TXA                       
                    EOR.B #$01                
                    TAX                       
                    LDA.B #$40                
                    LDY $01,X                 
                    BPL ADDR_04831C           
                    LDA.B #$C0                
ADDR_04831C:        STA $01,X                 
                    LDY.B #$01                
ADDR_048320:        TYA                       
                    ASL                       
                    TAX                       
                    LDA.W $0001,Y             
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    CLC                       
                    ADC.W $1B7C,Y             
                    STA.W $1B7C,Y             
                    LDA.W $0001,Y             
                    PHY                       
                    PHP                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LDY.B #$00                
                    PLP                       
                    BPL ADDR_048342           
                    ORA.B #$F0                
                    DEY                       
ADDR_048342:        ADC $1A,X                 
                    STA $1A,X                 
                    STA $1E,X                 
                    TYA                       
                    ADC $1B,X                 
                    STA $1B,X                 
                    STA $1F,X                 
                    PLY                       
                    DEY                       
                    BPL ADDR_048320           
                    JMP.W ADDR_04840D         
ADDR_048356:        LDA.W $13D9               
                    CMP.B #$03                
                    BEQ ADDR_048366           
                    CMP.B #$04                
                    BNE ADDR_04839A           
                    LDA.W $0DD8               
                    BNE ADDR_04839A           
ADDR_048366:        LDA.W $0DA8               
                    ORA.W $0DA9               
                    AND.B #$30                
                    BEQ ADDR_048375           
                    LDA.B #$01                
                    STA.W $1B87               
ADDR_048375:        LDX.W $0DB3               
                    LDA.W $1F11,X             
                    BNE ADDR_04839A           
                    LDA $16                   
                    AND.B #$10                
                    BEQ ADDR_04839A           
                    INC.W $13D4               
                    LDA.W $13D4               
                    LSR                       
                    BNE ADDR_04839A           
                    REP #$20                  ; Accum (16 bit) 
                    LDA $1A                   
                    STA.W $1DF0               
                    LDA $1C                   
                    STA.W $1DF2               
                    SEP #$20                  ; Accum (8 bit) 
ADDR_04839A:        LDA.W $13D4               
                    BEQ ADDR_0483C3           
                    LDX.B #$00                
                    LDA $15                   
                    AND.B #$03                
                    ASL                       
                    JSR.W ADDR_048415         
                    LDX.B #$02                
                    LDA $15                   
                    AND.B #$0C                
                    ORA.B #$10                
                    LSR                       
                    JSR.W ADDR_048415         
                    LDY.B #$15                
                    LDA $13                   
                    AND.B #$18                
                    BNE ADDR_0483BF           
ADDR_0483BD:        LDY.B #$18                
ADDR_0483BF:        STY $12                   
                    BRA ADDR_04840D           
ADDR_0483C3:        LDX.W $1BA0               
                    BEQ ADDR_04840A           
                    CPX.B #$FE                
                    BNE ADDR_0483D6           
                    LDA.B #$21                
                    STA.W $1DF9               ; / Play sound effect 
                    LDA.B #$08                
                    STA.W $1DFB               ; / Play sound effect 
ADDR_0483D6:        TXA                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA $13                   
                    AND.W DATA_048231,Y       
                    BNE ADDR_0483F3           
                    LDA $1A                   
                    EOR.B #$01                
                    STA $1A                   
                    STA $1E                   
                    LDA $1C                   
                    EOR.B #$01                
                    STA $1C                   
                    STA $20                   
ADDR_0483F3:        CPX.B #$80                
                    BCS ADDR_0483FE           
                    LDA.W $13D9               
                    CMP.B #$02                
                    BNE ADDR_04840A           
ADDR_0483FE:        DEC.W $1BA0               
                    BNE ADDR_04840D           
                    LDA.B #$22                
                    STA.W $1DF9               ; / Play sound effect 
                    BRA ADDR_04840D           
ADDR_04840A:        JSR.W ADDR_048576         
ADDR_04840D:        JSR.W ADDR_04F708         
ADDR_048410:        JSR.W ADDR_04862E         
ADDR_048413:        PLB                       
                    RTL                       ; Return 

ADDR_048415:        TAY                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA $1A,X                 
                    CLC                       
                    ADC.W DATA_048211,Y       
                    PHA                       
                    SEC                       
                    SBC.W DATA_048221,Y       
                    EOR.W DATA_048211,Y       
                    ASL                       
                    PLA                       
                    BCC ADDR_04842E           
                    STA $1A,X                 
                    STA $1E,X                 
ADDR_04842E:        SEP #$20                  ; Accum (8 bit) 
                    RTS                       ; Return 


DATA_048431:        .db $11,$00,$0A,$00,$09,$00,$0B,$00
                    .db $12,$00,$0A,$00,$07,$00,$0A,$02
                    .db $03,$02,$10,$04,$12,$04,$1C,$04
                    .db $14,$04,$12,$06,$00,$02,$12,$06
                    .db $10,$00,$17,$06,$14,$00,$1C,$06
                    .db $14,$00,$1C,$06,$17,$06,$11,$05
                    .db $11,$05,$14,$04,$06,$01

DATA_048467:        .db $07,$00,$03,$00,$10,$00,$0E,$00
                    .db $17,$00,$18,$00,$12,$00,$14,$00
                    .db $0B,$00,$03,$00,$01,$00,$09,$00
                    .db $09,$00,$1D,$00,$0E,$00,$18,$00
                    .db $0F,$00,$16,$00,$10,$00,$18,$00
                    .db $02,$00,$1D,$00,$18,$00,$13,$00
                    .db $11,$00,$03,$00,$07,$00

DATA_04849D:        .db $A8,$04,$38,$04,$08,$09,$28,$09
                    .db $C8,$09,$48,$09,$28,$0D,$18,$01
                    .db $A8,$00,$98,$00,$B8,$00,$28,$01
                    .db $A8,$00,$78,$00,$28,$0D,$08,$04
                    .db $78,$0D,$08,$01,$C8,$0D,$48,$01
                    .db $C8,$0D,$48,$09,$18,$0B,$78,$0D
                    .db $68,$02,$C8,$0D,$28,$0D

DATA_0484D3:        .db $48,$01,$B8,$00,$38,$00,$18,$00
                    .db $98,$00,$98,$00,$D8,$01,$78,$00
                    .db $38,$00,$08,$01,$E8,$00,$78,$01
                    .db $88,$01,$28,$01,$88,$01,$E8,$00
                    .db $68,$01,$F8,$00,$88,$01,$08,$01
                    .db $D8,$01,$38,$00,$38,$01,$88,$01
                    .db $78,$00,$D8,$01,$D8,$01

ADDR_048509:        LDY.W $0DB3               
                    LDA.W $1F11,Y             
                    STA $01                   
                    STZ $00                   
                    REP #$20                  ; Accum (16 bit) 
                    LDX.W $0DD6               
                    LDY.B #$34                
ADDR_04851A:        LDA.W DATA_048431,Y       
                    EOR $00                   
                    CMP.W #$0200              
                    BCS ADDR_048531           
                    CMP.W $1F1F,X             
                    BNE ADDR_048531           
                    LDA.W $1F21,X             
                    CMP.W DATA_048467,Y       
                    BEQ ADDR_048535           
ADDR_048531:        DEY                       
                    DEY                       
                    BPL ADDR_04851A           
ADDR_048535:        STY.W $1DF6               
                    SEP #$20                  ; Accum (8 bit) 
                    RTS                       ; Return 

ADDR_04853B:        PHB                       
                    PHK                       
                    PLB                       
                    REP #$20                  ; Accum (16 bit) 
                    LDX.W $0DD6               
                    LDY.W $1DF6               
                    LDA.W DATA_04849D,Y       
                    PHA                       
                    AND.W #$01FF              
                    STA.W $1F17,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    STA.W $1F1F,X             
                    LDA.W DATA_0484D3,Y       
                    STA.W $1F19,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    STA.W $1F21,X             
                    PLA                       
                    LSR                       
                    XBA                       
                    AND.W #$000F              
                    STA.W $13C3               
                    REP #$10                  ; Index (16 bit) 
                    JSR.W ADDR_049A93         
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    PLB                       
                    RTL                       ; Return 

ADDR_048576:        LDA.W $13D9               
                    JSL.L ExecutePtrLong      

PtrsLong04857D:     .db $F1,$8E,$04
                    .db $70,$E5,$04
                    .db $87,$8F,$04
                    .db $20,$91,$04
                    .db $5D,$94,$04
                    .db $9A,$9D,$04
                    .db $22,$9E,$04
                    .db $D1,$9D,$04
                    .db $22,$9E,$04
                    .db $4C,$9E,$04
                    .db $EF,$DA,$04
                    .db $52,$9E,$04
                    .db $C6,$98,$04

ADDR_0485A4:        JSR.W ADDR_04862E         
ADDR_0485A7:        REP #$20                  ; Accum (16 bit) 
                    LDA.W #$001E              
                    CLC                       
                    ADC $1A                   
                    STA $94                   
                    LDA.W #$0006              
                    CLC                       
                    ADC $1C                   
                    STA $96                   
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.B #$08                
                    STA.W $007B               
                    PHB                       
                    LDA.B #$00                
                    PHA                       
                    PLB                       
                    JSL.L ADDR_00CEB1         
                    PLB                       
                    LDA.B #$03                
                    STA.W $13F9               
                    JSL.L ADDR_00E2BD         
                    LDA.B #$06                
                    STA.W $0D84               
                    LDA.W $1496               
                    BEQ ADDR_0485E0           
                    DEC.W $1496               
ADDR_0485E0:        LDA.W $14A2               
                    BEQ ADDR_0485E8           
                    DEC.W $14A2               
ADDR_0485E8:        LDA.B #$18                
                    STA $00                   
                    LDA.B #$07                
                    STA $01                   
                    LDY.B #$00                
                    TYX                       
ADDR_0485F3:        LDA $00                   
                    STA.W $0200,X             
                    CLC                       
                    ADC.B #$08                
                    STA $00                   
                    LDA $01                   
                    STA.W $0201,X             
                    LDA.B #$7E                
                    STA.W $0202,X             
                    LDA.B #$36                
                    STA.W $0203,X             
                    PHX                       
                    TYX                       
                    LDA.B #$00                
                    STA.W $0420,X             
                    PLX                       
                    INY                       
                    TYA                       
                    AND.B #$03                
                    BNE ADDR_048625           
                    LDA.B #$18                
                    STA $00                   
                    LDA $01                   
                    CLC                       
                    ADC.B #$08                
                    STA $01                   
ADDR_048625:        INX                       
                    INX                       
                    INX                       
                    INX                       
                    CPY.B #$10                
                    BNE ADDR_0485F3           
                    RTS                       ; Return 

ADDR_04862E:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDX.W $0DD6               
                    LDA.W $1F17,X             
                    SEC                       
                    SBC $1A                   
                    CMP.W #$0100              
                    BCS ADDR_04864D           
                    STA $00                   
                    STA $08                   
                    LDA.W $1F19,X             
                    SEC                       
                    SBC $1C                   
                    CMP.W #$0100              
                    BCC ADDR_048650           
ADDR_04864D:        LDA.W #$00F0              
ADDR_048650:        STA $02                   
                    STA $0A                   
                    TXA                       
                    EOR.W #$0004              
                    TAX                       
                    LDA.W $1F17,X             
                    SEC                       
                    SBC $1A                   
                    CMP.W #$0100              
                    BCS ADDR_048673           
                    STA $04                   
                    STA $0C                   
                    LDA.W $1F19,X             
                    SEC                       
                    SBC $1C                   
                    CMP.W #$0100              
                    BCC ADDR_048676           
ADDR_048673:        LDA.W #$00F0              
ADDR_048676:        STA $06                   
                    STA $0E                   
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDA $00                   
                    SEC                       
                    SBC.B #$08                
                    STA $00                   
                    LDA $02                   
                    SEC                       
                    SBC.B #$09                
                    STA $01                   
                    LDA $04                   
                    SEC                       
                    SBC.B #$08                
                    STA $02                   
                    LDA $06                   
                    SEC                       
                    SBC.B #$09                
                    STA $03                   
                    LDA.B #$03                
                    STA $8C                   
                    LDA $00                   
                    STA $06                   
                    STA $8A                   
                    LDA $01                   
                    STA $07                   
                    STA $8B                   
                    LDA.W $0DD6               
                    LSR                       
                    TAY                       
                    LDA.W $1F13,Y             
                    CMP.B #$12                
                    BEQ ADDR_0486C5           
                    CMP.B #$07                
                    BCC ADDR_0486BC           
                    CMP.B #$0F                
                    BCC ADDR_0486C5           
ADDR_0486BC:        LDA $8B                   
                    SEC                       
                    SBC.B #$05                
                    STA $8B                   
                    STA $07                   
ADDR_0486C5:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.W $0DD6               
                    XBA                       
                    LSR                       
                    STA $04                   
                    LDX.W #$0000              
                    JSR.W ADDR_048789         
                    LDA.W $0DD6               
                    LSR                       
                    TAY                       
                    LDX.W #$0000              
                    JSR.W ADDR_04894F         
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    STZ.W $0447               
                    STZ.W $0448               
                    STZ.W $0449               
                    STZ.W $044A               
                    STZ.W $044B               
                    STZ.W $044C               
                    STZ.W $044D               
                    STZ.W $044E               
                    LDA.B #$03                
                    STA $8C                   
                    LDA.W $1F11               
                    LDY.W $13D9               
                    CPY.B #$0A                
                    BNE ADDR_048709           
                    EOR.B #$01                
ADDR_048709:        CMP.W $1F12               
                    BNE ADDR_048786           
                    LDA $02                   
                    STA $06                   
                    STA $8A                   
                    LDA $03                   
                    STA $07                   
                    STA $8B                   
                    LDA.W $0DD6               
                    LSR                       
                    EOR.B #$02                
                    TAY                       
                    LDA.W $1F13,Y             
                    CMP.B #$12                
                    BEQ ADDR_048739           
                    CMP.B #$07                
                    BCC ADDR_048730           
                    CMP.B #$0F                
                    BCC ADDR_048739           
ADDR_048730:        LDA $8B                   
                    SEC                       
                    SBC.B #$05                
                    STA $8B                   
                    STA $07                   
ADDR_048739:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.W $0DB2               
                    AND.W #$00FF              
                    BEQ ADDR_048786           
                    LDA $0C                   
                    CMP.W #$00F0              
                    BCS ADDR_048786           
                    LDA $0E                   
                    CMP.W #$00F0              
                    BCS ADDR_048786           
                    LDA $04                   
                    EOR.W #$0200              
                    STA $04                   
                    LDX.W #$0020              
                    JSR.W ADDR_048789         
                    LDA.W $0DD6               
                    LSR                       
                    EOR.W #$0002              
                    TAY                       
                    LDX.W #$0020              
                    JSR.W ADDR_04894F         
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    STZ.W $044F               
                    STZ.W $0450               
                    STZ.W $0451               
                    STZ.W $0452               
                    STZ.W $0453               
                    STZ.W $0454               
                    STZ.W $0455               
                    STZ.W $0456               
ADDR_048786:        SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    RTS                       ; Return 

ADDR_048789:        LDA $8A                   ; Index (16 bit) Accum (16 bit) 
                    PHA                       
                    PHX                       
                    LDA $04                   
                    XBA                       
                    LSR                       
                    TAX                       
                    LDA.W $0DB3,X             
                    PLX                       
                    AND.W #$FF00              
                    BPL ADDR_0487C7           
                    SEP #$20                  ; Accum (8 bit) 
                    LDA $8A                   
                    STA.W $02B4,X             
                    CLC                       
                    ADC.B #$08                
                    STA.W $02B8,X             
                    LDA $8B                   
                    CLC                       
                    ADC.B #$F9                
                    STA.W $02B5,X             
                    STA.W $02B9,X             
                    LDA.B #$7C                
                    STA.W $02B6,X             
                    STA.W $02BA,X             
                    LDA.B #$20                
                    STA.W $02B7,X             
                    LDA.B #$60                
                    STA.W $02BB,X             
                    REP #$20                  ; Accum (16 bit) 
ADDR_0487C7:        PLA                       
                    STA $8A                   
                    RTS                       ; Return 


DATA_0487CB:        .db $0E,$24,$0F,$24,$1E,$24,$1F,$24
                    .db $20,$24,$21,$24,$30,$24,$31,$24
                    .db $0E,$24,$0F,$24,$1E,$24,$1F,$24
                    .db $20,$24,$21,$24,$31,$64,$30,$64
                    .db $0A,$24,$0B,$24,$1A,$24,$1B,$24
                    .db $0C,$24,$0D,$24,$1C,$24,$1D,$24
                    .db $0A,$24,$0B,$24,$1A,$24,$1B,$24
                    .db $0C,$24,$0D,$24,$1D,$64,$1C,$64
                    .db $08,$24,$09,$24,$18,$24,$19,$24
                    .db $06,$24,$07,$24,$16,$24,$17,$24
                    .db $08,$24,$09,$24,$18,$24,$19,$24
                    .db $06,$24,$07,$24,$16,$24,$17,$24
                    .db $09,$64,$08,$64,$19,$64,$18,$64
                    .db $07,$64,$06,$64,$17,$64,$16,$64
                    .db $09,$64,$08,$64,$19,$64,$18,$64
                    .db $07,$64,$06,$64,$17,$64,$16,$64
                    .db $0E,$24,$0F,$24,$38,$24,$38,$64
                    .db $20,$24,$21,$24,$39,$24,$39,$64
                    .db $0E,$24,$0F,$24,$38,$24,$38,$64
                    .db $20,$24,$21,$24,$39,$24,$39,$64
                    .db $0A,$24,$0B,$24,$38,$24,$38,$64
                    .db $0C,$24,$0D,$24,$39,$24,$39,$64
                    .db $0A,$24,$0B,$24,$38,$24,$38,$64
                    .db $0C,$24,$0D,$24,$39,$24,$39,$64
                    .db $08,$24,$09,$24,$38,$24,$38,$64
                    .db $06,$24,$07,$24,$39,$24,$39,$64
                    .db $08,$24,$09,$24,$38,$24,$38,$64
                    .db $06,$24,$07,$24,$39,$24,$39,$64
                    .db $09,$64,$08,$64,$38,$24,$38,$64
                    .db $07,$64,$06,$64,$39,$24,$39,$64
                    .db $09,$64,$08,$64,$38,$24,$38,$64
                    .db $07,$64,$06,$64,$39,$24,$39,$64
                    .db $24,$24,$25,$24,$34,$24,$35,$24
                    .db $24,$24,$25,$24,$34,$24,$35,$24
                    .db $24,$24,$25,$24,$34,$24,$35,$24
                    .db $24,$24,$25,$24,$34,$24,$35,$24
                    .db $24,$24,$25,$24,$38,$24,$38,$64
                    .db $24,$24,$25,$24,$38,$24,$38,$64
                    .db $24,$24,$25,$24,$38,$24,$38,$64
                    .db $24,$24,$25,$24,$38,$24,$38,$64
                    .db $46,$24,$47,$24,$56,$24,$57,$24
                    .db $47,$64,$46,$64,$57,$64,$56,$64
                    .db $46,$24,$47,$24,$56,$24,$57,$24
                    .db $47,$64,$46,$64,$57,$64,$56,$64
                    .db $46,$24,$47,$24,$56,$24,$57,$24
                    .db $47,$64,$46,$64,$57,$64,$56,$64
                    .db $46,$24,$47,$24,$56,$24,$57,$24
                    .db $47,$64,$46,$64,$57,$64,$56,$64
DATA_04894B:        .db $20,$60,$00,$40

ADDR_04894F:        SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    PHY                       
                    TYA                       
                    LSR                       
                    TAY                       
                    LDA.W $0DBA,Y             
                    BEQ ADDR_048962           
                    STA $0E                   
                    STZ $0F                   
                    PLY                       
                    JMP.W ADDR_048CE6         
ADDR_048962:        PLY                       
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.W $1F13,Y             
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    STA $00                   
                    LDA $13                   
                    AND.W #$0018              
                    CLC                       
                    ADC $00                   
                    TAY                       
                    PHX                       
                    LDA $04                   
                    XBA                       
                    LSR                       
                    TAX                       
                    LDA.W $0DB3,X             
                    PLX                       
                    AND.W #$FF00              
                    BPL ADDR_04898B           
                    LDA $00                   
                    TAY                       
                    BRA ADDR_0489A7           
ADDR_04898B:        CPX.W #$0000              
                    BNE ADDR_0489A7           
                    LDA.W $13D9               
                    CMP.W #$000B              
                    BNE ADDR_0489A7           
                    LDA $13                   
                    AND.W #$000C              
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_04894B,Y       
                    AND.W #$00FF              
                    TAY                       
ADDR_0489A7:        REP #$20                  ; Accum (16 bit) 
                    LDA $8A                   
                    STA.W $029C,X             
                    LDA.W DATA_0487CB,Y       
                    CLC                       
                    ADC $04                   
                    STA.W $029E,X             
                    SEP #$20                  ; Accum (8 bit) 
                    INX                       
                    INX                       
                    INX                       
                    INX                       
                    INY                       
                    INY                       
                    LDA $8A                   
                    CLC                       
                    ADC.B #$08                
                    STA $8A                   
                    DEC $8C                   
                    LDA $8C                   
                    AND.B #$01                
                    BEQ ADDR_0489D9           
                    LDA $06                   
                    STA $8A                   
                    LDA $8B                   
                    CLC                       
                    ADC.B #$08                
                    STA $8B                   
ADDR_0489D9:        LDA $8C                   
                    BPL ADDR_0489A7           
                    RTS                       ; Return 


DATA_0489DE:        .db $66,$24,$67,$24,$76,$24,$77,$24
                    .db $2F,$62,$2E,$62,$3F,$62,$3E,$62
                    .db $66,$24,$67,$24,$76,$24,$77,$24
                    .db $2E,$22,$2F,$22,$3E,$22,$3F,$22
                    .db $2F,$62,$2E,$62,$3F,$62,$3E,$62
                    .db $0A,$24,$0B,$24,$1A,$24,$1B,$24
                    .db $2E,$22,$2F,$22,$3E,$22,$3F,$22
                    .db $0A,$24,$0B,$24,$1A,$24,$1B,$24
                    .db $64,$24,$65,$24,$74,$24,$75,$24
                    .db $40,$22,$41,$22,$50,$22,$51,$22
                    .db $64,$24,$65,$24,$74,$24,$75,$24
                    .db $42,$22,$43,$24,$52,$24,$53,$24
                    .db $65,$64,$64,$64,$75,$64,$74,$64
                    .db $41,$62,$40,$62,$51,$62,$50,$62
                    .db $65,$64,$64,$64,$75,$64,$74,$64
                    .db $43,$62,$42,$62,$53,$62,$52,$62
                    .db $38,$24,$38,$64,$66,$24,$67,$24
                    .db $76,$24,$77,$24,$FF,$FF,$FF,$FF
                    .db $39,$24,$39,$64,$66,$24,$67,$24
                    .db $76,$24,$77,$24,$FF,$FF,$FF,$FF
                    .db $38,$24,$38,$64,$2F,$62,$2E,$62
                    .db $0A,$24,$0B,$24,$1A,$24,$1B,$24
                    .db $39,$24,$39,$24,$2E,$22,$2F,$22
                    .db $0A,$24,$0B,$24,$1A,$24,$1B,$24
                    .db $38,$24,$38,$64,$64,$24,$65,$24
                    .db $74,$24,$75,$24,$40,$22,$41,$22
                    .db $39,$24,$39,$64,$64,$24,$65,$24
                    .db $74,$24,$75,$24,$42,$22,$42,$22
                    .db $38,$24,$38,$64,$65,$64,$64,$64
                    .db $75,$64,$74,$64,$41,$62,$40,$62
                    .db $39,$24,$39,$64,$65,$64,$64,$64
                    .db $75,$64,$74,$64,$43,$62,$42,$62
                    .db $2F,$62,$2E,$62,$3F,$62,$3E,$62
                    .db $24,$24,$25,$24,$34,$24,$35,$24
                    .db $2E,$22,$2F,$22,$3E,$22,$3F,$22
                    .db $24,$24,$25,$24,$34,$24,$35,$24
                    .db $38,$24,$38,$64,$2F,$62,$2E,$62
                    .db $24,$24,$25,$24,$34,$24,$35,$24
                    .db $39,$24,$39,$64,$2E,$22,$2F,$22
                    .db $24,$24,$25,$24,$34,$24,$35,$24
                    .db $66,$24,$67,$24,$76,$24,$77,$24
                    .db $2F,$62,$2E,$62,$3F,$62,$3E,$62
                    .db $66,$24,$67,$24,$76,$24,$77,$24
                    .db $2E,$22,$2F,$22,$3E,$22,$3F,$22
                    .db $66,$24,$67,$24,$76,$24,$77,$24
                    .db $2F,$62,$2E,$62,$3F,$62,$3E,$62
                    .db $66,$24,$67,$24,$76,$24,$77,$24
                    .db $2E,$22,$2F,$22,$3E,$22,$3F,$22
DATA_048B5E:        .db $00,$08,$00,$08,$00,$08,$00,$08
                    .db $00,$08,$00,$08,$00,$08,$00,$08
                    .db $00,$08,$00,$08,$00,$08,$00,$08
                    .db $00,$08,$00,$08,$00,$08,$00,$08
                    .db $07,$0F,$07,$0F,$00,$08,$00,$08
                    .db $07,$0F,$07,$0F,$00,$08,$00,$08
                    .db $F9,$01,$F9,$01,$00,$08,$00,$08
                    .db $F9,$01,$F9,$01,$00,$08,$00,$08
                    .db $00,$08,$00,$08,$00,$08,$00,$08
                    .db $00,$08,$00,$08,$00,$08,$00,$08
                    .db $00,$08,$00,$08,$00,$08,$00,$08
                    .db $00,$08,$00,$08,$00,$08,$00,$08
                    .db $00,$08,$07,$0F,$07,$0F,$00,$08
                    .db $00,$08,$07,$0F,$07,$0F,$00,$08
                    .db $00,$08,$F9,$01,$F9,$01,$00,$08
                    .db $00,$08,$F9,$01,$F9,$01,$00,$08
                    .db $00,$08,$00,$08,$00,$08,$00,$08
                    .db $00,$08,$00,$08,$00,$08,$00,$08
                    .db $00,$08,$00,$08,$00,$08,$00,$08
                    .db $00,$08,$00,$08,$00,$08,$00,$08
                    .db $00,$08,$00,$08,$00,$08,$00,$08
                    .db $00,$08,$00,$08,$00,$08,$00,$08
                    .db $00,$08,$00,$08,$00,$08,$00,$08
                    .db $00,$08,$00,$08,$00,$08,$00,$08
DATA_048C1E:        .db $FB,$FB,$03,$03,$00,$00,$08,$08
                    .db $FA,$FA,$02,$02,$00,$00,$08,$08
                    .db $00,$00,$08,$08,$F8,$F8,$00,$00
                    .db $00,$00,$08,$08,$F9,$F9,$01,$01
                    .db $FC,$FC,$04,$04,$00,$00,$08,$08
                    .db $FB,$FB,$03,$03,$00,$00,$08,$08
                    .db $FC,$FC,$04,$04,$00,$00,$08,$08
                    .db $FB,$FB,$03,$03,$00,$00,$08,$08
                    .db $08,$08,$FB,$FB,$03,$03,$00,$00
                    .db $08,$08,$FA,$FA,$02,$02,$00,$00
                    .db $08,$08,$00,$00,$F8,$F8,$00,$00
                    .db $08,$08,$00,$00,$F9,$F9,$01,$01
                    .db $08,$08,$FC,$FC,$04,$04,$00,$00
                    .db $08,$08,$FB,$FB,$03,$03,$00,$00
                    .db $08,$08,$FC,$FC,$04,$04,$00,$00
                    .db $08,$08,$FB,$FB,$03,$03,$00,$00
                    .db $00,$00,$08,$08,$F8,$F8,$00,$00
                    .db $00,$00,$08,$08,$F8,$F8,$00,$00
                    .db $08,$08,$00,$00,$F8,$F8,$00,$00
                    .db $08,$08,$00,$00,$F8,$F8,$00,$00
                    .db $FB,$FB,$03,$03,$00,$00,$08,$08
                    .db $FA,$FA,$02,$02,$00,$00,$08,$08
                    .db $FB,$FB,$03,$03,$00,$00,$08,$08
                    .db $FA,$FA,$02,$02,$00,$00,$08,$08
DATA_048CDE:        .db $00,$00,$00,$02,$00,$04,$00,$06

ADDR_048CE6:        LDA.B #$07                
                    STA $8C                   
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.W $1F13,Y             
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    STA $00                   
                    LDA $13                   
                    AND.W #$0008              
                    ASL                       
                    CLC                       
                    ADC $00                   
                    TAY                       
                    CPX.W #$0000              
                    BNE ADDR_048D1B           
                    LDA.W $13D9               
                    CMP.W #$000B              
                    BNE ADDR_048D1B           
                    LDA $13                   
                    AND.W #$000C              
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_04894B,Y       
                    AND.W #$00FF              
                    TAY                       
ADDR_048D1B:        REP #$20                  ; Accum (16 bit) 
                    PHY                       
                    TYA                       
                    LSR                       
                    TAY                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.W DATA_048B5E,Y       
                    CLC                       
                    ADC $8A                   
                    STA.W $029C,X             
                    LDA.W DATA_048C1E,Y       
                    CLC                       
                    ADC $8B                   
                    STA.W $029D,X             
                    PLY                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W DATA_0489DE,Y       
                    CMP.W #$FFFF              
                    BEQ ADDR_048D67           
                    PHA                       
                    AND.W #$0F00              
                    CMP.W #$0200              
                    BNE ADDR_048D5E           
                    STY $08                   
                    LDA $0E                   
                    SEC                       
                    SBC.W #$0004              
                    TAY                       
                    PLA                       
                    AND.W #$F0FF              
                    ORA.W DATA_048CDE,Y       
                    PHA                       
                    LDY $08                   
                    BRA ADDR_048D63           
ADDR_048D5E:        PLA                       
                    CLC                       
                    ADC $04                   
                    PHA                       
ADDR_048D63:        PLA                       
                    STA.W $029E,X             
ADDR_048D67:        SEP #$20                  ; Accum (8 bit) 
                    INX                       
                    INX                       
                    INX                       
                    INX                       
                    INY                       
                    INY                       
                    DEC $8C                   
                    BPL ADDR_048D1B           
                    RTS                       ; Return 


DATA_048D74:        .db $0B,$00,$13,$00,$1A,$00,$1B,$00
                    .db $1F,$00,$20,$00,$31,$00,$32,$00
                    .db $34,$00,$35,$00,$40,$00

DATA_048D8A:        .db $02,$03,$04,$06,$07,$09,$05

ADDR_048D91:        PHB                       ; Index (8 bit) 
                    PHK                       
                    PLB                       
                    STZ.W $1B9E               
                    LDA.B #$0F                
                    STA.W $144E               
                    LDX.B #$02                
                    LDA.W $1F13               
                    CMP.B #$12                
                    BEQ ADDR_048DA9           
                    AND.B #$08                
                    BEQ ADDR_048DAB           
ADDR_048DA9:        LDX.B #$0A                
ADDR_048DAB:        STX.W $1F13               
                    LDX.B #$02                
                    LDA.W $1F15               
                    CMP.B #$12                
                    BEQ ADDR_048DBB           
                    AND.B #$08                
                    BEQ ADDR_048DBD           
ADDR_048DBB:        LDX.B #$0A                
ADDR_048DBD:        STX.W $1F15               
                    SEP #$10                  ; Index (8 bit) 
                    JSR.W ADDR_048E55         
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.W $0DD4               
                    AND.W #$FF00              
                    BEQ ADDR_048DDF           
                    BMI ADDR_048DDF           
                    LDA.W $13BF               
                    AND.W #$00FF              
                    CMP.W #$0018              
                    BNE ADDR_048DDF           
                    BRL ADDR_048E34           
ADDR_048DDF:        LDA.W $13C6               
                    AND.W #$00FF              
                    BEQ ADDR_048E38           
                    LDA.W $13C6               
                    AND.W #$FF00              
                    STA.W $13C6               
                    SEP #$10                  ; Index (8 bit) 
                    LDX.W $0DD6               
                    LDA.W $1F17,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    STA $00                   
                    LDA.W $1F19,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    STA $02                   
                    TXA                       
                    LSR                       
                    LSR                       
                    TAX                       
                    JSR.W ADDR_049885         
                    REP #$10                  ; Index (16 bit) 
                    LDX $04                   
                    LDA.L $7ED000,X           
                    AND.W #$00FF              
                    TAX                       
                    LDA.W $1EA2,X             
                    AND.W #$0080              
                    BNE ADDR_048E38           
                    LDY.W #$0014              
ADDR_048E25:        LDA.W $13BF               
                    AND.W #$00FF              
                    CMP.W DATA_048D74,Y       
                    BEQ ADDR_048E38           
                    DEY                       
                    DEY                       
                    BPL ADDR_048E25           
ADDR_048E34:        SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    BRA ADDR_048E47           
ADDR_048E38:        SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDX.W $0DB3               
                    LDA.W $1F11,X             
                    TAX                       
                    LDA.W DATA_048D8A,X       
                    STA.W $1DFB               ; / Play sound effect 
ADDR_048E47:        PLB                       
                    RTL                       ; Return 


DATA_048E49:        .db $28,$01,$00,$00,$88,$01

DATA_048E4F:        .db $C8,$01,$00,$00,$D8,$01

ADDR_048E55:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.W $0DB3               
                    AND.W #$00FF              
                    ASL                       
                    ASL                       
                    STA.W $0DD6               
                    LDX.W $0DD6               
                    LDA.W $1F1F,X             
                    STA $00                   
                    LDA.W $1F21,X             
                    STA $02                   
                    TXA                       
                    LSR                       
                    LSR                       
                    TAX                       
                    JSR.W ADDR_049885         
                    STZ $00                   
                    LDX $04                   
                    LDA.L $7ED000,X           
                    AND.W #$00FF              
                    ASL                       
                    TAX                       
                    LDA.W DATA_04A0FC,X       
                    STA $00                   
                    JSR.W ADDR_049D07         
                    LDX $04                   
                    BMI ADDR_048E9E           
                    CPX.W #$0800              
                    BCS ADDR_048E9E           
                    LDA.L $7EC800,X           
                    AND.W #$00FF              
                    STA.W $13C1               
ADDR_048E9E:        SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDX.W $0EF7               
                    BEQ ADDR_048EE1           
                    BPL ADDR_048ED9           
                    TXA                       
                    AND.B #$7F                
                    TAX                       
                    STZ.W $0DF5,X             
                    LDA.W $0EF6               
                    LDX.W $0DD5               
                    BPL ADDR_048ECD           
                    ASL                       
                    TAX                       
                    REP #$20                  ; Accum (16 bit) 
                    LDY.W $0DD6               
                    LDA.W DATA_048E49,X       
                    STA.W $1F17,Y             
                    LDA.W DATA_048E4F,X       
                    STA.W $1F19,Y             
                    SEP #$20                  ; Accum (8 bit) 
                    BRA ADDR_048EE1           
ADDR_048ECD:        TAX                       
                    LDA.W DATA_04FB85,X       
                    ORA.W $0EF5               
                    STA.W $0EF5               
                    BRA ADDR_048EE1           
ADDR_048ED9:        LDA.W $0DD5               
                    BMI ADDR_048EE1           
                    STZ.W $0DE5,X             
ADDR_048EE1:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    JSR.W ADDR_049831         
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    JSR.W ADDR_0485A4         
                    JSR.W ADDR_048086         
                    JMP.W ADDR_0480E0         
                    LDA.B #$08                
                    STA.W $0DB1               
                    LDA.W $1F11               
                    CMP.B #$01                
                    BNE ADDR_048F13           
                    LDA.W $1F17               
                    CMP.B #$68                
                    BNE ADDR_048F13           
                    LDA.W $1F19               
                    CMP.B #$8E                
                    BNE ADDR_048F13           
                    LDA.B #$0C                
                    STA.W $13D9               
                    BRL ADDR_048F7A           
ADDR_048F13:        REP #$20                  ; Accum (16 bit) 
                    LDX.W $0DD6               
                    LDA.W $1F17,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    STA $00                   
                    LDA.W $1F19,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    STA $02                   
                    TXA                       
                    LSR                       
                    LSR                       
                    TAX                       
                    JSR.W ADDR_049885         
                    REP #$10                  ; Index (16 bit) 
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.W $13CE               
                    BEQ ADDR_048F56           
                    LDA.W $0DD5               
                    BEQ ADDR_048F56           
                    BPL ADDR_048F5F           
                    REP #$20                  ; Accum (16 bit) 
                    LDX $04                   
                    LDA.L $7ED000,X           
                    AND.W #$00FF              
                    TAX                       
                    LDA.W $1EA2,X             
                    ORA.W #$0040              
                    STA.W $1EA2,X             
ADDR_048F56:        SEP #$20                  ; Accum (8 bit) 
                    LDA.B #$05                
                    STA.W $13D9               
                    BRA ADDR_048F7A           
ADDR_048F5F:        REP #$20                  ; Accum (16 bit) 
                    LDX $04                   
                    LDA.L $7ED000,X           
                    AND.W #$00FF              
                    TAX                       
                    LDA.W $1EA2,X             
                    ORA.W #$0080              
                    AND.W #$FFBF              
                    STA.W $1EA2,X             
                    INC.W $13D9               
ADDR_048F7A:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    JMP.W ADDR_049831         

DATA_048F7F:        .db $58,$59,$5D,$63,$77,$79,$7E,$80

                    JSR.W ADDR_049903         ; Index (8 bit) 
                    LDX.B #$07                
ADDR_048F8C:        LDA.W $13C1               
                    CMP.W DATA_048F7F,X       
                    BNE ADDR_049000           
                    LDX.B #$2C                
ADDR_048F96:        LDA.W $1F02,X             
                    STA.W $1FA9,X             
                    DEX                       
                    BPL ADDR_048F96           
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDX.W $0DD6               
                    TXA                       
                    EOR.W #$0004              
                    TAY                       
                    LDA.W $1FBE,X             
                    STA.W $1FBE,Y             
                    LDA.W $1FC0,X             
                    STA.W $1FC0,Y             
                    LDA.W $1FC6,X             
                    STA.W $1FC6,Y             
                    LDA.W $1FC8,X             
                    STA.W $1FC8,Y             
                    TXA                       
                    LSR                       
                    TAX                       
                    EOR.W #$0002              
                    TAY                       
                    LDA.W $1FBA,X             
                    STA.W $1FBA,Y             
                    TXA                       
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LSR                       
                    TAX                       
                    EOR.B #$01                
                    TAY                       
                    LDA.W $1FB8,X             
                    STA.W $1FB8,Y             
                    LDA.W $0DD5               
                    CMP.B #$E0                
                    BNE ADDR_048FFB           
                    DEC.W $0DB1               
                    BMI ADDR_048FE9           
                    RTS                       ; Return 

ADDR_048FE9:        INC.W $13CA               
                    JSR.W ADDR_049037         
                    LDA.B #$02                
                    STA.W $0DB1               
                    LDA.B #$04                
                    STA.W $13D9               
                    BRA ADDR_049003           
ADDR_048FFB:        INC.W $13CA               
                    BRA ADDR_049003           
ADDR_049000:        DEX                       
                    BPL ADDR_048F8C           
ADDR_049003:        REP #$20                  ; Accum (16 bit) 
                    STZ $06                   
                    LDX.W $0DD6               
                    LDA.W $1F17,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    STA $00                   
                    LDA.W $1F19,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    STA $02                   
                    TXA                       
                    LSR                       
                    LSR                       
                    TAX                       
                    JSR.W ADDR_049885         
                    REP #$10                  ; Index (16 bit) 
                    LDX $04                   
                    LDA.L $7EC800,X           
                    AND.W #$00FF              
                    STA.W $13C1               
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    INC.W $13D9               
                    RTS                       ; Return 

ADDR_049037:        PHX                       
                    PHY                       
                    PHP                       
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDA.W $13CA               
                    BEQ ADDR_049054           
                    LDX.B #$5F                
ADDR_049043:        LDA.W $1EA2,X             
                    STA.W $1F49,X             
                    DEX                       
                    BPL ADDR_049043           
                    STZ.W $13CA               
                    LDA.B #$05                
                    STA.W $1B87               
ADDR_049054:        PLP                       
                    PLY                       
                    PLX                       
                    RTS                       ; Return 


DATA_049058:        .db $FF,$FF,$01,$00,$FF,$FF,$01,$00
DATA_049060:        .db $05,$03,$01,$00

DATA_049064:        .db $00,$00,$02,$00,$04,$00,$06,$00
DATA_04906C:        .db $28,$00,$08,$00,$14,$00,$36,$00
                    .db $3F,$00,$45,$00

DATA_049078:        .db $09,$15,$23,$1B,$43,$44,$24,$FF
                    .db $30,$31

DATA_049082:        .db $78,$01

DATA_049084:        .db $28,$01

DATA_049086:        .db $10,$10,$1E,$19,$16,$66,$16,$19
                    .db $1E,$10,$10,$66,$04,$04,$04,$58
                    .db $04,$04,$04,$66,$04,$04,$04,$04
                    .db $04,$6A,$04,$04,$04,$04,$04,$66
                    .db $1E,$19,$06,$09,$0F,$20,$1A,$21
                    .db $1A,$14,$19,$18,$1F,$17,$82,$17
                    .db $1F,$18,$19,$14,$1A,$21,$1A,$20
                    .db $0F,$09,$06,$19,$1E,$66,$04,$04
                    .db $58,$04,$04,$5F

DATA_0490CA:        .db $02,$02,$02,$02,$06,$06,$04,$04
                    .db $00,$00,$00,$00,$04,$04,$04,$04
                    .db $06,$06,$06,$06,$06,$06,$06,$06
                    .db $06,$06,$04,$04,$04,$04,$04,$04
                    .db $02,$02,$06,$06,$00,$00,$00,$04
                    .db $00,$04,$04,$00,$04,$00,$04,$06
                    .db $02,$06,$02,$06,$06,$02,$06,$02
                    .db $02,$02,$04,$04,$00,$00,$06,$06
                    .db $06,$04,$04,$04

DATA_04910E:        .db $00,$06,$0C,$10,$14,$1A,$20,$2F
                    .db $3E,$41,$08,$00,$04,$00,$02,$00
                    .db $01,$00

                    STZ.W $0DD8               
                    LDY.W $0EF7               
                    BMI ADDR_049199           
                    LDA.W $0DD5               
                    BMI ADDR_049132           
                    BEQ ADDR_049132           
                    BRL ADDR_0491E9           
ADDR_049132:        LDA $16                   
                    AND.B #$20                
                    BRA ADDR_049141           
                    LDA.W $13C1               
                    BEQ ADDR_049165           
                    CMP.B #$56                
                    BEQ ADDR_049165           
ADDR_049141:        LDA $17                   
                    AND.B #$30                
                    CMP.B #$30                
                    BNE ADDR_049150           
                    LDA.W $13C1               
                    CMP.B #$81                
                    BEQ ADDR_04919F           
ADDR_049150:        LDA $16                   
                    ORA $18                   
                    AND.B #$C0                
                    BNE ADDR_04915B           
                    BRL ADDR_0491E9           
ADDR_04915B:        STZ.W $1B9E               
                    LDA.W $13C1               
                    CMP.B #$5F                
                    BNE ADDR_04917D           
ADDR_049165:        JSR.W ADDR_048509         
                    BNE ADDR_049198           
                    STZ.W $1DF7               
                    STZ.W $1DF8               
                    LDA.B #$0D                
                    STA.W $1DF9               ; / Play sound effect 
                    LDA.B #$0B                
                    STA.W $13D9               
                    JMP.W ADDR_049E52         
ADDR_04917D:        LDA.W $13C1               
                    CMP.B #$82                
                    BEQ ADDR_049188           
                    CMP.B #$5B                
                    BNE ADDR_049199           
ADDR_049188:        JSR.W ADDR_048509         
                    BNE ADDR_049198           
ADDR_04918D:        INC.W $1B9C               
                    STZ.W $0DD5               
                    LDA.B #$0B                
                    STA.W $0100               
ADDR_049198:        RTS                       ; Return 

ADDR_049199:        CMP.B #$81                
                    BEQ ADDR_0491E9           
                    BCS ADDR_0491E9           
ADDR_04919F:        LDA.W $0DD6               
                    LSR                       
                    AND.B #$02                
                    TAX                       
                    LDY.B #$10                
                    LDA.W $1F13,X             
                    AND.B #$08                
                    BEQ ADDR_0491B1           
                    LDY.B #$12                
ADDR_0491B1:        TYA                       
                    STA.W $1F13,X             
                    LDX.W $0DB3               
                    LDA.W $0DB6,X             
                    STA.W $0DBF               
                    LDA.W $0DB4,X             
                    STA.W $0DBE               
                    LDA.W $0DB8,X             
                    STA $19                   
                    LDA.W $0DBA,X             
                    STA.W $0DC1               
                    STA.W $13C7               
                    STA.W $187A               
                    LDA.W $0DBC,X             
                    STA.W $0DC2               
                    LDA.B #$02                
                    STA.W $0DB1               
                    LDA.B #$80                
                    STA.W $1DFB               ; / Play sound effect 
                    INC.W $0100               
                    RTS                       ; Return 

ADDR_0491E9:        REP #$20                  ; Accum (16 bit) 
                    LDX.W $0DD6               
                    LDA.W $1F17,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    STA $00                   
                    STA.W $1F1F,X             
                    LDA.W $1F19,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    STA $02                   
                    STA.W $1F21,X             
                    TXA                       
                    LSR                       
                    LSR                       
                    TAX                       
                    JSR.W ADDR_049885         
                    SEP #$20                  ; Accum (8 bit) 
                    LDX.W $0DD5               
                    BEQ ADDR_04925A           
                    DEX                       
                    LDA.W DATA_049060,X       
                    STA $08                   
                    STZ $09                   
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDX $04                   
                    LDA.L $7ED000,X           
                    AND.W #$00FF              
                    LDY.W #$000A              
ADDR_04922A:        CMP.W DATA_04906C,Y       
                    BNE ADDR_04923B           
                    LDA.W #$0005              
                    STA.W $13D9               
                    JSR.W ADDR_049037         
                    BRL ADDR_049411           
ADDR_04923B:        DEY                       
                    DEY                       
                    BPL ADDR_04922A           
                    LDA.L $7ED800,X           
                    AND.W #$00FF              
                    LDX $08                   
                    BEQ ADDR_04924E           
ADDR_04924A:        LSR                       
                    DEX                       
                    BPL ADDR_04924A           
ADDR_04924E:        AND.W #$0003              
                    ASL                       
                    TAX                       
                    LDA.W DATA_049064,X       
                    TAY                       
                    JMP.W ADDR_0492BC         
ADDR_04925A:        SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    STZ.W $0DD5               
                    LDA $16                   
                    AND.B #$0F                
                    BEQ ADDR_04926E           
                    LDX.W $13C1               
                    CPX.B #$82                
                    BEQ ADDR_0492AD           
                    BRA ADDR_04928C           
ADDR_04926E:        DEC.W $144E               
                    BPL ADDR_049287           
                    STZ.W $144E               
                    LDA.W $0DD6               
                    LSR                       
                    AND.B #$02                
                    TAX                       
                    LDA.W $1F13,X             
                    AND.B #$08                
                    ORA.B #$02                
                    STA.W $1F13,X             
ADDR_049287:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    JMP.W ADDR_049831         
ADDR_04928C:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    AND.W #$00FF              
                    NOP                       
                    NOP                       
                    NOP                       
                    PHA                       
                    STZ $06                   
                    LDX $04                   
                    LDA.L $7ED000,X           
                    AND.W #$00FF              
                    TAX                       
                    PLA                       
                    AND.W $1EA2,X             
                    AND.W #$000F              
                    BNE ADDR_0492AD           
                    JMP.W ADDR_049411         
ADDR_0492AD:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    AND.W #$00FF              
                    LDY.W #$0006              
ADDR_0492B5:        LSR                       
                    BCS ADDR_0492BC           
                    DEY                       
                    DEY                       
                    BPL ADDR_0492B5           
ADDR_0492BC:        TYA                       
                    STA.W $0DD3               
                    LDX.W #$0000              
                    CPY.W #$0004              
                    BCS ADDR_0492CB           
                    LDX.W #$0002              
ADDR_0492CB:        LDA $04                   
                    STA $08                   
                    LDA $00,X                 
                    CLC                       
                    ADC.W DATA_049058,Y       
                    STA $00,X                 
                    LDA.W $0DD6               
                    LSR                       
                    LSR                       
                    TAX                       
                    JSR.W ADDR_049885         
                    LDX $04                   
                    BMI ADDR_049301           
                    CMP.W #$0800              
                    BCS ADDR_049301           
                    LDA.L $7EC800,X           
                    AND.W #$00FF              
                    BEQ ADDR_049301           
                    CMP.W #$0056              
                    BCC ADDR_0492FE           
                    CMP.W #$0087              
                    BCC ADDR_0492FE           
                    BRA ADDR_049301           
ADDR_0492FE:        BRL ADDR_049384           
ADDR_049301:        STZ.W $1B78               
                    STZ.W $1B7A               
                    LDX $08                   
                    LDA.L $7ED000,X           
                    AND.W #$00FF              
                    STA $00                   
                    LDX.W #$0009              
ADDR_049315:        LDA.W DATA_049078,X       
                    AND.W #$00FF              
                    CMP.W #$00FF              
                    BNE ADDR_049349           
                    PHX                       
                    LDX.W $0DD6               
                    LDA.W $1F19,X             
                    CMP.W DATA_049082         
                    BNE ADDR_049346           
                    LDA.W $1F17,X             
                    CMP.W DATA_049084         
                    BNE ADDR_049346           
                    LDA.W $0DB3               
                    AND.W #$00FF              
                    TAX                       
                    LDA.W $1F11,X             
                    AND.W #$00FF              
                    BNE ADDR_049346           
                    PLX                       
                    BRA ADDR_04934D           
ADDR_049346:        PLX                       
                    BRA ADDR_049374           
ADDR_049349:        CMP $00                   
                    BNE ADDR_049374           
ADDR_04934D:        STX $00                   
                    LDA.W DATA_04910E,X       
                    AND.W #$00FF              
                    TAX                       
                    DEC A                     
                    STA.W $1B7A               
                    STY $02                   
                    LDA.W DATA_0490CA,X       
                    AND.W #$00FF              
                    CMP $02                   
                    BNE ADDR_04937A           
                    LDA.W #$0001              
                    STA.W $1B78               
                    LDA.W DATA_049086,X       
                    AND.W #$00FF              
                    BRA ADDR_049384           
ADDR_049374:        DEX                       
                    BMI ADDR_04937A           
                    BRL ADDR_049315           
ADDR_04937A:        SEP #$20                  ; Accum (8 bit) 
                    STZ.W $0DD5               
                    REP #$20                  ; Accum (16 bit) 
                    JMP.W ADDR_049411         
ADDR_049384:        STA.W $13C1               
                    STA $00                   
                    STZ $02                   
                    LDX.W #$0017              
ADDR_04938E:        LDA.W DATA_04A03C,X       
                    AND.W #$00FF              
                    CMP $00                   
                    BNE ADDR_0493B5           
                    LDA.W DATA_04A0E4,X       
                    CLC                       
                    ADC.W $0DD6               
                    PHA                       
                    TXA                       
                    ASL                       
                    ASL                       
                    TAX                       
                    LDA.W DATA_04A084,X       
                    STA $00                   
                    LDA.W DATA_04A086,X       
                    STA $02                   
                    PLA                       
                    AND.W #$00FF              
                    TAX                       
                    BRA ADDR_0493DA           
ADDR_0493B5:        DEX                       
                    BPL ADDR_04938E           
                    LDX.W #$0008              
                    TYA                       
                    AND.W #$0002              
                    BNE ADDR_0493C7           
                    TXA                       
                    EOR.W #$FFFF              
                    INC A                     
                    TAX                       
ADDR_0493C7:        STX $00                   
                    LDX.W #$0000              
                    CPY.W #$0004              
                    BCS ADDR_0493D4           
                    LDX.W #$0002              
ADDR_0493D4:        TXA                       
                    CLC                       
                    ADC.W $0DD6               
                    TAX                       
ADDR_0493DA:        LDA $00                   
                    CLC                       
                    ADC.W $1F17,X             
                    STA.W $0DC7,X             
                    TXA                       
                    EOR.W #$0002              
                    TAX                       
                    LDA $02                   
                    CLC                       
                    ADC.W $1F17,X             
                    STA.W $0DC7,X             
                    TXA                       
                    LSR                       
                    AND.W #$0002              
                    TAX                       
                    TYA                       
                    STA $00                   
                    LDA.W $1F13,X             
                    AND.W #$0008              
                    ORA $00                   
                    STA.W $1F13,X             
                    LDA.W #$000F              
                    STA.W $144E               
                    INC.W $13D9               
                    STZ.W $1444               
ADDR_049411:        JMP.W ADDR_049831         

DATA_049414:        .db $0D,$08

DATA_049416:        .db $EF,$FF,$D7,$FF

DATA_04941A:        .db $11,$01,$31,$01

DATA_04941E:        .db $08,$00,$04,$00,$02,$00,$01,$00
DATA_049426:        .db $44,$43,$45,$46,$47,$48,$25,$40
                    .db $42,$4D

DATA_049430:        .db $0C

DATA_049431:        .db $00,$0E,$00,$10,$06,$12,$00,$18
                    .db $04,$1A,$02,$20,$06,$42,$06,$4E
                    .db $04,$50,$02,$58,$06,$5A,$00,$70
                    .db $06,$90,$00,$A0,$06

DATA_04944E:        .db $01,$01,$00,$01,$01,$00,$00,$00
                    .db $01,$00,$00,$01,$00,$01,$00

ADDR_04945D:        LDA.W $0DD8               ; Accum (8 bit) 
                    BEQ ADDR_049468           
                    LDA.B #$08                
                    STA.W $13D9               
                    RTS                       ; Return 

ADDR_049468:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.W $0DD6               
                    CLC                       
                    ADC.W #$0002              
                    TAY                       
                    LDX.W #$0002              
ADDR_049475:        LDA.W $0DC7,Y             
                    SEC                       
                    SBC.W $1F17,Y             
                    STA $00,X                 
                    BPL ADDR_049484           
                    EOR.W #$FFFF              
                    INC A                     
ADDR_049484:        STA $04,X                 
                    DEY                       
                    DEY                       
                    DEX                       
                    DEX                       
                    BPL ADDR_049475           
                    LDY.W #$FFFF              
                    LDA $04                   
                    STA $0A                   
                    LDA $06                   
                    STA $0C                   
                    CMP $04                   
                    BCC ADDR_0494A4           
                    STA $0A                   
                    LDA $04                   
                    STA $0C                   
                    LDY.W #$0001              
ADDR_0494A4:        STY $08                   
                    SEP #$20                  ; Accum (8 bit) 
                    LDX.W $1B80               
                    LDA.W DATA_049414,X       
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    STA.W $4202               ; Multiplicand A
                    LDA $0C                   
                    BEQ ADDR_0494DA           
                    STA.W $4203               ; Multplier B
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W $4216               ; Product/Remainder Result (Low Byte)
                    STA.W $4204               ; Dividend (Low Byte)
                    SEP #$20                  ; Accum (8 bit) 
                    LDA $0A                   
                    STA.W $4206               ; Divisor B
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W $4214               ; Quotient of Divide Result (Low Byte)
ADDR_0494DA:        REP #$20                  ; Accum (16 bit) 
                    STA $0E                   
                    LDX.W $1B80               
                    LDA.W DATA_049414,X       
                    AND.W #$00FF              
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    STA $0A                   
                    LDX.W #$0002              
ADDR_0494F0:        LDA $08                   
                    BMI ADDR_0494F8           
                    LDA $0A                   
                    BRA ADDR_0494FA           
ADDR_0494F8:        LDA $0E                   
ADDR_0494FA:        BIT $00,X                 
                    BPL ADDR_049502           
                    EOR.W #$FFFF              
                    INC A                     
ADDR_049502:        STA.W $0DCF,X             
                    LDA $08                   
                    EOR.W #$FFFF              
                    INC A                     
                    STA $08                   
                    DEX                       
                    DEX                       
                    BPL ADDR_0494F0           
                    LDX.W #$0000              
                    LDA $08                   
                    BMI ADDR_04951B           
                    LDX.W #$0002              
ADDR_04951B:        LDA $00,X                 
                    BEQ ADDR_049522           
                    JMP.W ADDR_049801         
ADDR_049522:        LDA.W $1444               
                    BEQ ADDR_04955C           
                    STZ.W $1B78               
                    LDX.W $0DD6               
                    LDA.W $1F1F,X             
                    STA $00                   
                    LDA.W $1F21,X             
                    STA $02                   
                    TXA                       
                    LSR                       
                    LSR                       
                    TAX                       
                    JSR.W ADDR_049885         
                    STZ $00                   
                    LDX $04                   
                    LDA.L $7ED000,X           
                    AND.W #$00FF              
                    ASL                       
                    TAX                       
                    LDA.W DATA_04A0FC,X       
                    STA $00                   
                    JSR.W ADDR_049D07         
                    INC.W $13D9               
                    JSR.W ADDR_049037         
                    JMP.W ADDR_049831         
ADDR_04955C:        LDA.W $13C1               
                    STA.W $1B7E               
                    LDA.W #$0008              
                    STA $08                   
                    LDY.W $0DD3               
                    TYA                       
                    AND.W #$00FF              
                    EOR.W #$0002              
                    STA $0A                   
                    BRA ADDR_049582           
ADDR_049575:        LDA $08                   
                    SEC                       
                    SBC.W #$0002              
                    STA $08                   
                    CMP $0A                   
                    BEQ ADDR_049575           
                    TAY                       
ADDR_049582:        LDX.W $0DD6               
                    LDA.W $1F1F,X             
                    STA $00                   
                    LDA.W $1F21,X             
                    STA $02                   
                    LDX.W #$0000              
                    CPY.W #$0004              
                    BCS ADDR_04959A           
                    LDX.W #$0002              
ADDR_04959A:        LDA $00,X                 
                    CLC                       
                    ADC.W DATA_049058,Y       
                    STA $00,X                 
                    LDA.W $0DD6               
                    LSR                       
                    LSR                       
                    TAX                       
                    JSR.W ADDR_049885         
                    LDA.W $1B78               
                    BEQ ADDR_0495CE           
                    STY $06                   
                    LDX.W $1B7A               
                    INX                       
                    LDA.W DATA_0490CA,X       
                    AND.W #$00FF              
                    CMP $06                   
                    BNE ADDR_049575           
                    STX.W $1B7A               
                    LDA.W DATA_049086,X       
                    AND.W #$00FF              
                    CMP.W #$0058              
                    BNE ADDR_0495DE           
ADDR_0495CE:        LDX $04                   
                    BMI ADDR_049575           
                    CMP.W #$0800              
                    BCS ADDR_049575           
                    LDA.L $7EC800,X           
                    AND.W #$00FF              
ADDR_0495DE:        STA.W $13C1               
                    BEQ ADDR_049575           
                    CMP.W #$0087              
                    BCS ADDR_049575           
                    PHA                       
                    PHY                       
                    TAX                       
                    DEX                       
                    LDY.W #$0000              
                    LDA.W DATA_049FEB,X       
                    STA $0E                   
                    AND.W #$00FF              
                    CMP.W #$0014              
                    BNE ADDR_0495FF           
                    LDY.W #$0001              
ADDR_0495FF:        STY.W $1B80               
                    LDX.W $0DD6               
                    LDA $00                   
                    STA.W $1F1F,X             
                    LDA $02                   
                    STA.W $1F21,X             
                    PLY                       
                    PLA                       
                    PHA                       
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDX.B #$09                
ADDR_049616:        CMP.W DATA_049426,X       
                    BNE ADDR_049645           
                    PHY                       
                    JSR.W ADDR_049A24         
                    PLY                       
                    LDA.B #$01                
                    STA.W $1B9E               
                    JSR.W ADDR_04F407         
                    STZ.W $1B8C               
                    REP #$20                  ; Accum (16 bit) 
                    STZ.W $0701               
                    LDA.W #$7000              
                    STA.W $1B8D               
                    LDA.W #$5400              
                    STA.W $1B8F               
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.B #$0A                
                    STA.W $13D9               
                    BRA ADDR_049648           
ADDR_049645:        DEX                       
                    BPL ADDR_049616           
ADDR_049648:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    PLA                       
                    PHA                       
                    CMP.W #$0056              
                    BCS ADDR_049654           
                    JMP.W ADDR_04971D         
ADDR_049654:        CMP.W #$0080              
                    BEQ ADDR_049663           
                    CMP.W #$006A              
                    BCC ADDR_049676           
                    CMP.W #$006E              
                    BCS ADDR_049676           
ADDR_049663:        LDA.W $0DD6               
                    LSR                       
                    AND.W #$0002              
                    TAX                       
                    LDA.W $1F13,X             
                    ORA.W #$0008              
                    STA.W $1F13,X             
                    BRA ADDR_049687           
ADDR_049676:        LDA.W $0DD6               
                    LSR                       
                    AND.W #$0002              
                    TAX                       
                    LDA.W $1F13,X             
                    AND.W #$00F7              
                    STA.W $1F13,X             
ADDR_049687:        LDA.W #$0001              
                    STA.W $1444               
                    LDA.W $13C1               
                    CMP.W #$005F              
                    BEQ ADDR_0496A5           
                    CMP.W #$005B              
                    BEQ ADDR_0496A5           
                    CMP.W #$0082              
                    BEQ ADDR_0496A5           
                    LDA.W #$0023              
                    STA.W $1DFC               ; / Play sound effect 
ADDR_0496A5:        NOP                       
                    NOP                       
                    NOP                       
                    LDA.W $13C1               
                    AND.W #$00FF              
                    CMP.W #$0082              
                    BEQ ADDR_0496D2           
                    PHY                       
                    TYA                       
                    AND.W #$00FF              
                    EOR.W #$0002              
                    TAY                       
                    STZ $06                   
                    LDX $04                   
                    LDA.L $7ED000,X           
                    AND.W #$00FF              
                    TAX                       
                    LDA.W DATA_04941E,Y       
                    ORA.W $1EA2,X             
                    STA.W $1EA2,X             
                    PLY                       
ADDR_0496D2:        LDA.W $0DD6               
                    LSR                       
                    AND.W #$0002              
                    TAX                       
                    LDA.W $1F13,X             
                    AND.W #$000C              
                    STA $0E                   
                    LDA.W #$0001              
                    STA $04                   
                    LDA.W $1B7E               
                    AND.W #$00FF              
                    STA $00                   
                    LDX.W #$0017              
ADDR_0496F2:        LDA.W DATA_04A03C,X       
                    AND.W #$00FF              
                    CMP $00                   
                    BNE ADDR_049704           
                    TXA                       
                    ASL                       
                    TAX                       
                    LDA.W DATA_04A054,X       
                    BRA ADDR_049718           
ADDR_049704:        DEX                       
                    BPL ADDR_0496F2           
                    LDA.W #$0000              
                    ORA.W #$0800              
                    CPY.W #$0004              
                    BCC ADDR_049718           
                    LDA.W #$0000              
                    ORA.W #$0008              
ADDR_049718:        LDX.W #$0000              
                    BRA ADDR_049728           
ADDR_04971D:        DEC A                     
                    ASL                       
                    TAX                       
                    LDA.W DATA_049F49,X       
                    STA $04                   
                    LDA.W DATA_049EA7,X       
ADDR_049728:        STA $00                   
                    TXA                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDX.W #$001C              
ADDR_049730:        CMP.W DATA_049430,X       
                    BEQ ADDR_04973B           
                    DEX                       
                    DEX                       
                    BPL ADDR_049730           
                    BRA ADDR_04974A           
ADDR_04973B:        TYA                       
                    CMP.W DATA_049431,X       
                    BEQ ADDR_04974A           
                    TXA                       
                    LSR                       
                    TAX                       
                    LDA.W DATA_04944E,X       
                    TAX                       
                    BRA ADDR_049755           
ADDR_04974A:        LDX.W #$0000              
                    TYA                       
                    AND.B #$02                
                    BEQ ADDR_049755           
                    LDX.W #$0001              
ADDR_049755:        LDA $04,X                 
                    BEQ ADDR_049767           
                    LDA $00                   
                    EOR.B #$FF                
                    INC A                     
                    STA $00                   
                    LDA $01                   
                    EOR.B #$FF                
                    INC A                     
                    STA $01                   
ADDR_049767:        REP #$20                  ; Accum (16 bit) 
                    PLA                       
                    LDX.W #$0000              
                    LDA $0E                   
                    AND.W #$0007              
                    BNE ADDR_049777           
                    LDX.W #$0001              
ADDR_049777:        LDA $0E                   
                    AND.W #$00FF              
                    STA $04                   
                    LDA $00,X                 
                    AND.W #$00FF              
                    CMP.W #$0080              
                    BCS ADDR_049790           
                    LDA $04                   
                    CLC                       
                    ADC.W #$0002              
                    STA $04                   
ADDR_049790:        LDA.W $0DD6               
                    LSR                       
                    AND.W #$0002              
                    TAX                       
                    LDA $04                   
                    STA.W $1F13,X             
                    LDX.W $0DD6               
                    LDA $00                   
                    AND.W #$00FF              
                    CMP.W #$0080              
                    BCC ADDR_0497AD           
                    ORA.W #$FF00              
ADDR_0497AD:        CLC                       
                    ADC.W $1F17,X             
                    AND.W #$FFFC              
                    STA.W $0DC7,X             
                    LDA $01                   
                    AND.W #$00FF              
                    CMP.W #$0080              
                    BCC ADDR_0497C4           
                    ORA.W #$FF00              
ADDR_0497C4:        CLC                       
                    ADC.W $1F19,X             
                    AND.W #$FFFC              
                    STA.W $0DC9,X             
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.W $0DC7,X             
                    AND.B #$0F                
                    BNE ADDR_0497E3           
                    LDY.W #$0004              
                    LDA $00                   
                    BMI ADDR_0497E1           
                    LDY.W #$0006              
ADDR_0497E1:        BRA ADDR_0497F4           
ADDR_0497E3:        LDA.W $0DC9,X             
                    AND.B #$0F                
                    BNE ADDR_0497F4           
                    LDY.W #$0000              
                    LDA $01                   
                    BMI ADDR_0497F4           
                    LDY.W #$0002              
ADDR_0497F4:        STY.W $0DD3               
                    LDA.W $13D9               
                    CMP.B #$0A                
                    BEQ ADDR_049831           
                    JMP.W ADDR_04945D         
ADDR_049801:        REP #$20                  ; Accum (16 bit) 
                    LDA.W $0DD6               
                    CLC                       
                    ADC.W #$0002              
                    TAX                       
                    LDY.W #$0002              
ADDR_04980E:        LDA.W $13D5,Y             
                    AND.W #$00FF              
                    CLC                       
                    ADC.W $0DCF,Y             
                    STA.W $13D5,Y             
                    AND.W #$FF00              
                    BPL ADDR_049823           
                    ORA.W #$00FF              
ADDR_049823:        XBA                       
                    CLC                       
                    ADC.W $1F17,X             
                    STA.W $1F17,X             
                    DEX                       
                    DEX                       
                    DEY                       
                    DEY                       
                    BPL ADDR_04980E           
ADDR_049831:        SEP #$20                  ; Accum (8 bit) 
                    LDA.W $13D9               
                    CMP.B #$0A                
                    BEQ ADDR_049882           
                    LDA.W $1BA0               
                    BNE ADDR_049882           
ADDR_04983F:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDX.W $0DD6               
                    LDA.W $1F17,X             
                    STA $00                   
                    LDA.W $1F19,X             
                    STA $02                   
                    TXA                       
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W $1F11,X             
                    AND.W #$00FF              
                    BNE ADDR_049882           
                    LDX.W #$0002              
                    TXY                       
ADDR_04985E:        LDA $00,X                 
                    SEC                       
                    SBC.W #$0080              
                    BPL ADDR_049870           
                    CMP.W DATA_049416,Y       
                    BCS ADDR_049878           
                    LDA.W DATA_049416,Y       
                    BRA ADDR_049878           
ADDR_049870:        CMP.W DATA_04941A,Y       
                    BCC ADDR_049878           
                    LDA.W DATA_04941A,Y       
ADDR_049878:        STA $1A,X                 
                    STA $1E,X                 
                    DEY                       
                    DEY                       
                    DEX                       
                    DEX                       
                    BPL ADDR_04985E           
ADDR_049882:        SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    RTS                       ; Return 

ADDR_049885:        LDA $00                   ; Accum (16 bit) 
                    AND.W #$000F              
                    STA $04                   
                    LDA $00                   
                    AND.W #$0010              
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ADC $04                   
                    STA $04                   
                    LDA $02                   
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    AND.W #$00FF              
                    ADC $04                   
                    STA $04                   
                    LDA $02                   
                    AND.W #$0010              
                    BEQ ADDR_0498B5           
                    LDA $04                   
                    CLC                       
                    ADC.W #$0200              
                    STA $04                   
ADDR_0498B5:        LDA.W $1F11,X             
                    AND.W #$00FF              
                    BEQ ADDR_0498C5           
                    LDA $04                   
                    CLC                       
                    ADC.W #$0400              
                    STA $04                   
ADDR_0498C5:        RTS                       ; Return 

                    STZ.W $1F13               ; Accum (8 bit) 
                    LDA.B #$80                
                    CLC                       
                    ADC.W $13D7               
                    STA.W $13D7               
                    PHP                       
                    LDA.B #$0F                
                    CMP.B #$08                
                    LDY.B #$00                
                    BCC ADDR_0498DE           
                    ORA.B #$F0                
                    DEY                       
ADDR_0498DE:        PLP                       
                    ADC.W $1F19               
                    STA.W $1F19               
                    TYA                       
                    ADC.W $1F1A               
                    STA.W $1F1A               
                    LDA.W $1F19               
                    CMP.B #$78                
                    BNE ADDR_0498FA           
                    STZ.W $13D9               
                    JSL.L ADDR_009BC9         
ADDR_0498FA:        RTS                       ; Return 


DATA_0498FB:        .db $08,$00,$04,$00,$02,$00,$01,$00

ADDR_049903:        LDX.W $0DD5               
                    BEQ ADDR_0498C5           
                    BMI ADDR_0498C5           
                    DEX                       
                    LDA.W DATA_049060,X       
                    STA $08                   
                    STZ $09                   
                    REP #$20                  ; Accum (16 bit) 
                    LDX.W $0DD6               
                    LDA.W $1F17,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    STA $00                   
                    STA.W $1F1F,X             
                    LDA.W $1F19,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    STA $02                   
                    STA.W $1F21,X             
                    TXA                       
                    LSR                       
                    LSR                       
                    TAX                       
                    JSR.W ADDR_049885         
                    REP #$10                  ; Index (16 bit) 
                    LDX $04                   
                    LDA.L $7ED800,X           
                    AND.W #$00FF              
                    LDX $08                   
                    BEQ ADDR_049949           
ADDR_049945:        LSR                       
                    DEX                       
                    BPL ADDR_049945           
ADDR_049949:        AND.W #$0003              
                    ASL                       
                    TAY                       
                    LDX $04                   
                    LDA.L $7ED000,X           
                    AND.W #$00FF              
                    TAX                       
                    LDA.W DATA_04941E,Y       
                    ORA.W $1EA2,X             
                    STA.W $1EA2,X             
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    RTS                       ; Return 


DATA_049964:        .db $40,$01

DATA_049966:        .db $28,$00

DATA_049968:        .db $00,$50,$01,$58,$00,$00,$10,$00
                    .db $48,$00,$01,$10,$00,$98,$00,$01
                    .db $A0,$00,$D8,$00,$00,$40,$01,$58
                    .db $00,$02,$90,$00,$E8,$01,$04,$60
                    .db $01,$E8,$00,$00,$A0,$00,$C8,$01
                    .db $00,$60,$01,$88,$00,$03,$08,$01
                    .db $90,$01,$00,$E8,$01,$10,$00,$03
                    .db $10,$01,$C8,$01,$00,$F0,$01,$88
                    .db $00,$03

DATA_0499AA:        .db $00,$00

DATA_0499AC:        .db $48,$00

DATA_0499AE:        .db $01,$00,$00,$98,$00,$01,$50,$01
                    .db $28,$00,$00,$60,$01,$58,$00,$00
                    .db $50,$01,$58,$00,$02,$90,$00,$D8
                    .db $00,$00,$50,$01,$E8,$00,$00,$A0
                    .db $00,$E8,$01,$04,$50,$01,$88,$00
                    .db $03,$B0,$00,$C8,$01,$00,$E8,$01
                    .db $00,$00,$03,$08,$01,$A0,$01,$00
                    .db $00,$02,$88,$00,$03,$00,$01,$C8
                    .db $01,$00

DATA_0499F0:        .db $00

DATA_0499F1:        .db $04,$00,$09,$14,$02,$15,$05,$14
                    .db $05,$09,$0D,$15,$0E,$09,$1E,$15
                    .db $08,$0A,$1C,$1E,$00,$10,$19,$1F
                    .db $08,$10,$1C

DATA_049A0C:        .db $EF,$FF

DATA_049A0E:        .db $D8,$FF,$EF,$FF,$80,$00,$EF,$FF
                    .db $28,$01,$F0,$00,$D8,$FF,$F0,$00
                    .db $80,$00,$F0,$00,$28,$01

ADDR_049A24:        REP #$20                  ; Accum (16 bit) 
                    LDA.W $0DD6               
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W $1F11,X             
                    AND.W #$00FF              
                    STA.W $13C3               
                    LDA.W #$001A              
                    STA $02                   
                    LDY.B #$41                
                    LDX.W $0DD6               
ADDR_049A3F:        LDA.W $1F19,X             
                    CMP.W DATA_049964,Y       
                    BNE ADDR_049A85           
                    LDA.W $1F17,X             
                    CMP.W DATA_049966,Y       
                    BNE ADDR_049A85           
                    LDA.W DATA_049968,Y       
                    AND.W #$00FF              
                    CMP.W $13C3               
                    BNE ADDR_049A85           
                    LDA.W DATA_0499AA,Y       
                    STA.W $1F19,X             
                    LDA.W DATA_0499AC,Y       
                    STA.W $1F17,X             
                    LDA.W DATA_0499AE,Y       
                    AND.W #$00FF              
                    STA.W $13C3               
                    LDY $02                   
                    LDA.W DATA_0499F0,Y       
                    AND.W #$00FF              
                    STA.W $1F21,X             
                    LDA.W DATA_0499F1,Y       
                    AND.W #$00FF              
                    STA.W $1F1F,X             
                    BRA ADDR_049A90           
ADDR_049A85:        DEC $02                   
                    DEC $02                   
                    DEY                       
                    DEY                       
                    DEY                       
                    DEY                       
                    DEY                       
                    BPL ADDR_049A3F           
ADDR_049A90:        SEP #$20                  ; Accum (8 bit) 
                    RTS                       ; Return 

ADDR_049A93:        LDA.W $0DD6               ; Accum (16 bit) 
                    AND.W #$00FF              
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W $1F11,X             
                    AND.W #$FF00              
                    ORA.W $13C3               
                    STA.W $1F11,X             
                    AND.W #$00FF              
                    BNE ADDR_049AB0           
                    JMP.W ADDR_04983F         
ADDR_049AB0:        DEC A                     
                    ASL                       
                    ASL                       
                    TAY                       
                    LDA.W DATA_049A0C,Y       
                    STA $1A                   
                    STA $1E                   
                    LDA.W DATA_049A0E,Y       
                    STA $1C                   
                    STA $20                   
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    RTS                       ; Return 


DATA_049AC5:        .db $18,$0E,$12,$07,$08,$5D,$12,$9F
                    .db $12,$13,$00,$11,$9F,$5A,$64,$1F
                    .db $08,$06,$06,$18,$5D,$12,$9F,$5A
                    .db $65,$1F,$0C,$0E,$11,$13,$0E,$0D
                    .db $5D,$12,$9F,$5A,$66,$1F,$0B,$04
                    .db $0C,$0C,$18,$5D,$12,$9F,$5A,$67
                    .db $1F,$0B,$14,$03,$16,$08,$06,$5D
                    .db $12,$9F,$5A,$68,$1F,$11,$0E,$18
                    .db $5D,$12,$9F,$5A,$69,$1F,$16,$04
                    .db $0D,$03,$18,$5D,$12,$9F,$5A,$6A
                    .db $1F,$0B,$00,$11,$11,$18,$5D,$12
                    .db $9F,$03,$0E,$0D,$14,$13,$9F,$06
                    .db $11,$04,$04,$0D,$9F,$13,$0E,$0F
                    .db $1F,$12,$04,$02,$11,$04,$13,$1F
                    .db $00,$11,$04,$00,$9F,$15,$00,$0D
                    .db $08,$0B,$0B,$00,$9F,$38,$39,$3A
                    .db $3B,$3C,$9F,$11,$04,$03,$9F,$01
                    .db $0B,$14,$04,$9F,$01,$14,$13,$13
                    .db $04,$11,$1F,$01,$11,$08,$03,$06
                    .db $04,$9F,$02,$07,$04,$04,$12,$04
                    .db $1F,$01,$11,$08,$03,$06,$04,$9F
                    .db $12,$0E,$03,$00,$1F,$0B,$00,$0A
                    .db $04,$9F,$02,$0E,$0E,$0A,$08,$04
                    .db $1F,$0C,$0E,$14,$0D,$13,$00,$08
                    .db $0D,$9F,$05,$0E,$11,$04,$12,$13
                    .db $9F,$02,$07,$0E,$02,$0E,$0B,$00
                    .db $13,$04,$9F,$02,$07,$0E,$02,$0E
                    .db $1C,$06,$07,$0E,$12,$13,$1F,$07
                    .db $0E,$14,$12,$04,$9F,$12,$14,$0D
                    .db $0A,$04,$0D,$1F,$06,$07,$0E,$12
                    .db $13,$1F,$12,$07,$08,$0F,$9F,$15
                    .db $00,$0B,$0B,$04,$18,$9F,$01,$00
                    .db $02,$0A,$1F,$03,$0E,$0E,$11,$9F
                    .db $05,$11,$0E,$0D,$13,$1F,$03,$0E
                    .db $0E,$11,$9F,$06,$0D,$00,$11,$0B
                    .db $18,$9F,$13,$14,$01,$14,$0B,$00
                    .db $11,$9F,$16,$00,$18,$1F,$02,$0E
                    .db $0E,$0B,$9F,$07,$0E,$14,$12,$04
                    .db $9F,$08,$12,$0B,$00,$0D,$03,$9F
                    .db $12,$16,$08,$13,$02,$07,$1F,$0F
                    .db $00,$0B,$00,$02,$04,$9F,$02,$00
                    .db $12,$13,$0B,$04,$9F,$0F,$0B,$00
                    .db $08,$0D,$12,$9F,$06,$07,$0E,$12
                    .db $13,$1F,$07,$0E,$14,$12,$04,$9F
                    .db $12,$04,$02,$11,$04,$13,$9F,$03
                    .db $0E,$0C,$04,$9F,$05,$0E,$11,$13
                    .db $11,$04,$12,$12,$9F,$0E,$05,$32
                    .db $33,$34,$35,$36,$37,$0E,$0D,$9F
                    .db $0E,$05,$1F,$01,$0E,$16,$12,$04
                    .db $11,$9F,$11,$0E,$00,$03,$9F,$16
                    .db $0E,$11,$0B,$03,$9F,$00,$16,$04
                    .db $12,$0E,$0C,$04,$9F,$E4,$E5,$E6
                    .db $E7,$E8,$0F,$00,$0B,$00,$02,$84
                    .db $00,$11,$04,$80,$06,$11,$0E,$0E
                    .db $15,$98,$0C,$0E,$0D,$03,$8E,$0E
                    .db $14,$13,$11,$00,$06,$04,$0E,$14
                    .db $92,$05,$14,$0D,$0A,$98,$07,$0E
                    .db $14,$12,$84,$9F

DATA_049C91:        .db $CB,$01,$00,$00,$08,$00,$0D,$00
                    .db $17,$00,$23,$00,$2E,$00,$3A,$00
                    .db $43,$00,$4E,$00,$59,$00,$5F,$00
                    .db $65,$00,$75,$00,$7D,$00,$83,$00
                    .db $87,$00,$8C,$00,$9A,$00,$A8,$00
                    .db $B2,$00,$C2,$00,$C9,$00,$D3,$00
                    .db $E5,$00,$F7,$00,$FE,$00,$08,$01
                    .db $13,$01,$1A,$01,$22,$01

DATA_049CCF:        .db $CB,$01,$2B,$01,$31,$01,$38,$01
                    .db $46,$01,$4D,$01,$54,$01,$60,$01
                    .db $67,$01,$6C,$01,$75,$01,$80,$01
                    .db $8A,$01,$8F,$01,$95,$01

DATA_049CED:        .db $CB,$01,$9D,$01,$9E,$01,$9F,$01
                    .db $A0,$01,$A1,$01,$A2,$01,$A8,$01
                    .db $AC,$01,$B2,$01,$B7,$01,$C1,$01
                    .db $C6,$01

ADDR_049D07:        LDA.L $7F837B             ; Index (16 bit) Accum (16 bit) 
                    TAX                       
                    CLC                       
                    ADC.W #$0026              
                    STA $02                   
                    CLC                       
                    ADC.W #$0004              
                    STA.L $7F837B             
                    LDA.W #$2500              
                    STA.L $7F837F,X           
                    LDA.W #$8B50              
                    STA.L $7F837D,X           
                    LDA $01                   
                    AND.W #$007F              
                    ASL                       
                    TAY                       
                    LDA.W DATA_049C91,Y       
                    TAY                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.W DATA_049AC5,Y       
                    BMI ADDR_049D3D           
                    JSR.W ADDR_049D7F         
ADDR_049D3D:        REP #$20                  ; Accum (16 bit) 
                    LDA $00                   
                    AND.W #$00F0              
                    LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_049CCF,Y       
                    TAY                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.W DATA_049AC5,Y       
                    CMP.B #$9F                
                    BEQ ADDR_049D58           
                    JSR.W ADDR_049D7F         
ADDR_049D58:        REP #$20                  ; Accum (16 bit) 
                    LDA $00                   
                    AND.W #$000F              
                    ASL                       
                    TAY                       
                    LDA.W DATA_049CED,Y       
                    TAY                       
                    SEP #$20                  ; Accum (8 bit) 
                    JSR.W ADDR_049D7F         
ADDR_049D6A:        CPX $02                   
                    BCS ADDR_049D76           
                    LDY.W #$01CB              
                    JSR.W ADDR_049D7F         
                    BRA ADDR_049D6A           
ADDR_049D76:        LDA.B #$FF                
                    STA.L $7F8381,X           
                    REP #$20                  ; Accum (16 bit) 
                    RTS                       ; Return 

ADDR_049D7F:        LDA.W DATA_049AC5,Y       ; Index (8 bit) Accum (8 bit) 
                    PHP                       
                    CPX $02                   
                    BCS ADDR_049D95           
                    AND.B #$7F                
                    STA.L $7F8381,X           
                    LDA.B #$39                
                    STA.L $7F8382,X           
                    INX                       
                    INX                       
ADDR_049D95:        INY                       
                    PLP                       
                    BPL ADDR_049D7F           
                    RTS                       ; Return 

                    LDA.W $0DB2               
                    BEQ ADDR_049DAF           
                    LDA.W $0DB3               
                    EOR.B #$01                
                    TAX                       
                    LDA.W $0DB4,X             
                    BMI ADDR_049DAF           
                    LDA.W $0DD5               
                    BNE ADDR_049DBC           
ADDR_049DAF:        LDA.B #$03                
                    STA.W $13D9               
                    STZ.W $0DD5               
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    JMP.W ADDR_049831         
ADDR_049DBC:        DEC.W $0DB1               ; Index (8 bit) Accum (8 bit) 
                    BPL ADDR_049DCC           
                    LDA.B #$02                
                    STA.W $0DB1               
                    STZ.W $0DD5               
                    INC.W $13D9               
ADDR_049DCC:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    JMP.W ADDR_049831         
                    LDA.W $0DB3               ; Index (8 bit) Accum (8 bit) 
                    EOR.B #$01                
                    STA.W $0DB3               
                    TAX                       
                    LDA.W $0DB6,X             
                    STA.W $0DBF               
                    LDA.W $0DB4,X             
                    STA.W $0DBE               
                    LDA.W $0DB8,X             
                    STA $19                   
                    LDA.W $0DBA,X             
                    STA.W $0DC1               
                    STA.W $13C7               
                    STA.W $187A               
                    LDA.W $0DBC,X             
                    STA.W $0DC2               
                    JSL.L ADDR_05DBF2         
                    REP #$20                  ; Accum (16 bit) 
                    JSR.W ADDR_048E55         
                    SEP #$20                  ; Accum (8 bit) 
                    LDX.W $0DB3               
                    LDA.W $1F11,X             
                    STA.W $13C3               
                    STZ.W $13C4               
                    LDA.B #$02                
                    STA.W $0DB1               
                    LDA.B #$0A                
                    STA.W $13D9               
                    INC.W $0DD8               
                    RTS                       ; Return 

                    DEC.W $0DB1               
                    BPL ADDR_049E4B           
                    LDA.B #$02                
                    STA.W $0DB1               
                    LDX.W $0DAF               
                    LDA.W $0DAE               
                    CLC                       
                    ADC.L DATA_009F2F,X       
                    STA.W $0DAE               
                    CMP.L DATA_009F33,X       
                    BNE ADDR_049E4B           
                    INC.W $13D9               
                    LDA.W $0DAF               
                    EOR.B #$01                
                    STA.W $0DAF               
ADDR_049E4B:        RTS                       ; Return 

                    LDA.B #$03                
                    STA.W $13D9               
                    RTS                       ; Return 

ADDR_049E52:        LDA.W $1DF7               
                    BNE ADDR_049E63           
                    INC.W $1DF8               
                    LDA.W $1DF8               
                    CMP.B #$31                
                    BNE ADDR_049E93           
                    BRA ADDR_049E69           
ADDR_049E63:        LDA $13                   
                    AND.B #$07                
                    BNE ADDR_049E78           
ADDR_049E69:        INC.W $1DF7               
                    LDA.W $1DF7               
                    CMP.B #$05                
                    BNE ADDR_049E78           
                    LDA.B #$04                
                    STA.W $1DF7               
ADDR_049E78:        REP #$20                  ; Accum (16 bit) 
                    LDA.W $1DF7               
                    AND.W #$00FF              
                    STA $00                   
                    LDX.W $0DD6               
                    LDA.W $1F19,X             
                    SEC                       
                    SBC $00                   
                    STA.W $1F19,X             
                    SEC                       
                    SBC $1C                   
                    BMI ADDR_049E96           
ADDR_049E93:        SEP #$20                  ; Accum (8 bit) 
                    RTS                       ; Return 

ADDR_049E96:        SEP #$20                  ; Accum (8 bit) 
                    JMP.W ADDR_04918D         
                    LDY.B #$00                
ADDR_049E9D:        CMP.B #$0A                
                    BCC ADDR_049EA6           
                    SBC.B #$0A                
                    INY                       
                    BRA ADDR_049E9D           
ADDR_049EA6:        RTS                       ; Return 


DATA_049EA7:        .db $10,$F8,$10,$00,$10,$FC,$10,$00
                    .db $10,$FC,$10,$00,$08,$FC,$0C,$F4
                    .db $FC,$04,$04,$FC,$F8,$10,$00,$10
                    .db $FC,$08,$FC,$08,$FC,$10,$00,$10
                    .db $F8,$04,$FC,$10,$00,$10,$10,$08
                    .db $10,$04,$10,$04,$08,$04,$0C,$0C
                    .db $04,$04,$04,$04,$08,$10,$FC,$F8
                    .db $FC,$F8,$04,$10,$F8,$FC,$04,$10
                    .db $F4,$F4,$0C,$F4,$10,$00,$00,$10
                    .db $00,$10,$10,$00,$10,$00,$FC,$08
                    .db $FC,$08,$00,$10,$10,$FC,$10,$FC
                    .db $FC,$04,$04,$FC,$F8,$10,$00,$10
                    .db $FC,$10,$10,$04,$10,$00,$04,$10
                    .db $04,$04,$FC,$F8,$04,$04,$10,$08
                    .db $0C,$F4,$00,$10,$FC,$10,$10,$00
                    .db $04,$10,$10,$F8,$00,$10,$00,$10
                    .db $FC,$10,$10,$00,$00,$10,$00,$10
                    .db $00,$10,$00,$10,$00,$10,$00,$10
                    .db $04,$FC,$04,$04,$04,$04,$00,$10
                    .db $00,$10,$10,$00,$10,$00,$FC,$10
                    .db $FC,$04

DATA_049F49:        .db $01,$00,$01,$00,$01,$00,$01,$00
                    .db $01,$00,$01,$00,$00,$01,$00,$01
                    .db $00,$01,$00,$01,$01,$00,$01,$00
                    .db $00,$01,$01,$00,$01,$00,$01,$00
                    .db $00,$01,$01,$00,$01,$00,$01,$00
                    .db $01,$00,$01,$00,$01,$00,$01,$00
                    .db $01,$00,$01,$00,$01,$00,$00,$01
                    .db $00,$01,$01,$00,$00,$01,$01,$00
                    .db $00,$01,$01,$00,$01,$00,$01,$00
                    .db $01,$00,$01,$00,$01,$00,$00,$01
                    .db $01,$00,$01,$00,$01,$00,$01,$00
                    .db $00,$01,$00,$01,$01,$00,$01,$00
                    .db $01,$00,$01,$00,$01,$00,$01,$00
                    .db $01,$00,$00,$01,$01,$00,$01,$00
                    .db $01,$00,$01,$00,$01,$00,$01,$00
                    .db $01,$00,$01,$00,$01,$00,$01,$00
                    .db $01,$00,$01,$00,$01,$00,$01,$00
                    .db $01,$00,$01,$00,$01,$00,$01,$00
                    .db $00,$01,$01,$00,$01,$00,$01,$00
                    .db $01,$00,$01,$00,$01,$00,$01,$00
                    .db $00,$01

DATA_049FEB:        .db $04,$04,$04,$04,$04,$04,$04,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $04,$00,$00,$04,$04,$04,$04,$00
                    .db $00,$00,$00,$00,$00,$00,$04,$00
                    .db $00,$00,$04,$00,$00,$04,$04,$08
                    .db $08,$08,$0C,$0C,$08,$08,$08,$08
                    .db $08,$0C,$0C,$08,$08,$08,$08,$0C
                    .db $08,$08,$08,$0C,$08,$0C,$14,$14
                    .db $14,$04,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$04,$04,$08
                    .db $00

DATA_04A03C:        .db $07,$09,$0A,$0D,$0E,$11,$17,$19
                    .db $1A,$1C,$1D,$1F,$28,$29,$2D,$2E
                    .db $35,$36,$37,$49,$4A,$4B,$4D,$51
DATA_04A054:        .db $08,$FC,$FC,$08,$FC,$08,$FC,$08
                    .db $FC,$08,$04,$00,$08,$04,$04,$08
                    .db $04,$08,$04,$00,$04,$08,$04,$00
                    .db $FC,$08,$00,$00,$FC,$08,$FC,$08
                    .db $04,$00,$04,$00,$00,$00,$08,$FC
                    .db $08,$04,$08,$04,$FC,$08,$08,$FC
DATA_04A084:        .db $04,$00

DATA_04A086:        .db $F8,$FF,$08,$00,$FC,$FF,$F8,$FF
                    .db $04,$00,$F8,$FF,$04,$00,$08,$00
                    .db $FC,$FF,$04,$00,$04,$00,$04,$00
                    .db $08,$00,$08,$00,$04,$00,$F8,$FF
                    .db $FC,$FF,$00,$00,$00,$00,$08,$00
                    .db $04,$00,$04,$00,$04,$00,$F8,$FF
                    .db $04,$00,$04,$00,$04,$00,$08,$00
                    .db $FC,$FF,$F8,$FF,$04,$00,$04,$00
                    .db $04,$00,$00,$00,$00,$00,$04,$00
                    .db $04,$00,$04,$00,$F8,$FF,$04,$00
                    .db $08,$00,$FC,$FF,$F8,$FF,$F8,$FF
                    .db $04,$00,$FC,$FF,$08,$00

DATA_04A0E4:        .db $02,$02,$02,$02,$02,$00,$02,$02
                    .db $02,$00,$02,$00,$02,$00,$02,$02
                    .db $00,$00,$00,$02,$02,$02,$02,$02
DATA_04A0FC:        .db $00,$00,$72,$0D,$73,$0D,$00,$0C
                    .db $60,$0A,$53,$0A,$54,$0A,$40,$04
                    .db $30,$0B,$52,$0A,$71,$0A,$90,$0D
                    .db $01,$11,$02,$11,$40,$06,$07,$12
                    .db $00,$14,$00,$13,$C0,$02,$7C,$0A
                    .db $33,$0E,$51,$0A,$C0,$02,$53,$04
                    .db $00,$18,$53,$04,$40,$08,$90,$16
                    .db $25,$16,$24,$16,$C0,$02,$90,$15
                    .db $40,$07,$00,$17,$21,$16,$23,$16
                    .db $22,$16,$40,$03,$24,$01,$23,$01
                    .db $10,$01,$21,$01,$22,$01,$60,$0D
                    .db $C0,$02,$71,$0D,$83,$0D,$72,$0A
                    .db $C0,$02,$00,$1B,$00,$1A,$B4,$19
                    .db $40,$09,$90,$19,$00,$00,$B3,$19
                    .db $60,$19,$B2,$19,$B1,$19,$70,$16
                    .db $82,$0D,$84,$0D,$81,$0D,$30,$0F
                    .db $40,$05,$60,$15,$A1,$15,$A4,$15
                    .db $A2,$15,$30,$10,$77,$15,$A3,$15
                    .db $C0,$02,$0B,$00,$0A,$00,$09,$00
                    .db $08,$00,$C0,$02,$00,$1C,$00,$1D
                    .db $00,$1E,$E0,$00,$C0,$02,$C0,$02
                    .db $D2,$02,$C0,$02,$D3,$02,$C0,$02
                    .db $D1,$02,$D4,$02,$D5,$02,$C0,$02
                    .db $C0,$02,$FF,$FF,$FF,$FF,$FF,$FF
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
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$50,$00,$41,$3E
                    .db $FE,$38,$50,$A0,$C0,$28,$FE,$38
                    .db $50,$A1,$C0,$28,$FE,$38,$50,$BE
                    .db $C0,$28,$FE,$38,$50,$BF,$C0,$28
                    .db $FE,$38,$53,$40,$41,$7E,$FE,$38
                    .db $50,$A2,$00,$01,$92,$3C,$50,$A3
                    .db $40,$32,$93,$3C,$50,$BD,$00,$01
                    .db $92,$7C,$50,$C2,$C0,$24,$94,$7C
                    .db $50,$DD,$C0,$24,$94,$3C,$53,$22
                    .db $00,$01,$92,$BC,$53,$23,$40,$32
                    .db $93,$BC,$53,$3D,$00,$01,$92,$FC
                    .db $50,$FE,$C0,$24,$D6,$2C,$53,$44
                    .db $40,$32,$D5,$2C,$50,$DE,$00,$01
                    .db $D4,$2C,$53,$43,$00,$01,$D4,$EC
                    .db $53,$5E,$00,$01,$D4,$AC,$50,$02
                    .db $00,$01,$95,$38,$50,$09,$00,$01
                    .db $97,$38,$50,$0E,$00,$01,$96,$38
                    .db $50,$33,$00,$01,$97,$38,$50,$37
                    .db $00,$01,$95,$38,$50,$3B,$00,$01
                    .db $96,$38,$50,$42,$00,$01,$96,$38
                    .db $50,$50,$00,$01,$95,$38,$50,$55
                    .db $00,$01,$96,$38,$50,$5E,$00,$01
                    .db $95,$38,$51,$01,$00,$01,$97,$38
                    .db $51,$5F,$00,$01,$96,$38,$51,$81
                    .db $00,$01,$95,$38,$51,$C0,$00,$01
                    .db $96,$38,$51,$FF,$00,$01,$97,$38
                    .db $52,$60,$00,$01,$95,$38,$52,$7F
                    .db $00,$01,$95,$38,$53,$00,$00,$01
                    .db $97,$38,$53,$1F,$00,$01,$96,$38
                    .db $53,$61,$00,$01,$95,$38,$53,$6A
                    .db $00,$01,$95,$38,$53,$73,$00,$01
                    .db $96,$38,$53,$76,$00,$01,$95,$38
                    .db $53,$86,$00,$01,$96,$38,$53,$91
                    .db $00,$01,$95,$38,$53,$9A,$00,$01
                    .db $97,$38,$53,$9E,$00,$01,$95,$38
                    .db $50,$23,$C0,$06,$FC,$2C,$50,$24
                    .db $C0,$06,$FC,$2C,$50,$25,$C0,$06
                    .db $FC,$2C,$50,$26,$C0,$06,$FC,$2C
                    .db $50,$87,$00,$01,$8F,$38,$FF,$9B
                    .db $75,$81,$20,$01,$76,$20,$9B,$75
                    .db $81,$20,$01,$76,$20,$9A,$75,$00
                    .db $10,$81,$20,$01,$76,$20,$94,$75
                    .db $00,$01,$81,$02,$81,$01,$05,$02
                    .db $11,$50,$20,$7D,$20,$92,$75,$02
                    .db $10,$03,$11,$81,$71,$81,$11,$81
                    .db $71,$03,$11,$43,$10,$9C,$91,$75
                    .db $01,$10,$11,$89,$71,$01,$11,$10
                    .db $89,$75,$04,$01,$02,$03,$02,$01
                    .db $82,$75,$01,$3D,$71,$83,$AD,$81
                    .db $8A,$81,$AD,$81,$8A,$01,$11,$10
                    .db $89,$75,$00,$3D,$82,$71,$00,$3D
                    .db $82,$75,$01,$3D,$71,$83,$AD,$81
                    .db $8A,$81,$AD,$81,$8A,$01,$3D,$3F
                    .db $89,$75,$00,$00,$81,$43,$01,$42
                    .db $40,$81,$75,$01,$10,$00,$83,$43
                    .db $00,$11,$85,$71,$01,$11,$10,$88
                    .db $75,$01,$11,$20,$82,$69,$03,$20
                    .db $11,$75,$3D,$81,$20,$82,$69,$00
                    .db $00,$81,$43,$00,$11,$83,$71,$00
                    .db $3D,$88,$75,$01,$11,$50,$81,$69
                    .db $04,$41,$42,$11,$75,$3D,$81,$20
                    .db $81,$69,$01,$20,$69,$81,$20,$00
                    .db $50,$83,$43,$00,$10,$89,$75,$00
                    .db $11,$81,$43,$00,$11,$82,$75,$02
                    .db $3D,$50,$20,$82,$69,$81,$20,$01
                    .db $69,$20,$82,$69,$01,$20,$76,$86
                    .db $75,$01,$54,$55,$87,$75,$01,$00
                    .db $11,$83,$43,$00,$50,$81,$20,$83
                    .db $69,$01,$20,$76,$86,$75,$03,$9E
                    .db $9F,$06,$05,$85,$03,$01,$20,$50
                    .db $83,$43,$00,$11,$81,$43,$00,$50
                    .db $82,$69,$01,$20,$7D,$84,$75,$04
                    .db $01,$02,$9E,$9F,$58,$81,$71,$02
                    .db $BA,$BD,$BF,$81,$71,$81,$20,$83
                    .db $69,$03,$50,$11,$71,$11,$82,$43
                    .db $01,$9C,$10,$84,$75,$0E,$3D,$71
                    .db $9E,$9F,$71,$58,$71,$BD,$BF,$BA
                    .db $71,$11,$20,$69,$20,$83,$69,$00
                    .db $50,$83,$43,$02,$10,$9C,$43,$84
                    .db $75,$04,$3D,$58,$9E,$9F,$71,$81
                    .db $58,$06,$BF,$71,$BD,$71,$11,$50
                    .db $20,$84,$69,$00,$20,$82,$69,$03
                    .db $20,$76,$20,$69,$83,$75,$05,$10
                    .db $11,$58,$9E,$9F,$58,$81,$71,$07
                    .db $58,$BA,$BD,$BF,$71,$11,$50,$20
                    .db $84,$69,$00,$20,$81,$69,$03,$20
                    .db $76,$20,$69,$82,$75,$06,$10,$11
                    .db $56,$57,$9E,$9F,$58,$82,$71,$02
                    .db $BD,$71,$BA,$81,$71,$81,$58,$04
                    .db $43,$58,$43,$50,$20,$82,$69,$03
                    .db $20,$76,$20,$69,$82,$75,$05,$3D
                    .db $58,$9E,$9F,$64,$65,$84,$71,$81
                    .db $BD,$00,$BF,$83,$58,$04,$71,$58
                    .db $11,$50,$20,$81,$69,$03,$20,$76
                    .db $20,$69,$82,$75,$03,$3D,$71,$64
                    .db $65,$81,$71,$00,$6E,$81,$6B,$05
                    .db $6E,$BD,$BF,$BA,$BD,$58,$81,$8A
                    .db $01,$AD,$8E,$81,$58,$07,$11,$43
                    .db $BC,$3D,$20,$7D,$20,$69,$82,$75
                    .db $01,$00,$11,$81,$71,$01,$AE,$BC
                    .db $83,$68,$04,$BA,$BD,$11,$43,$11
                    .db $81,$8A,$09,$AD,$8A,$8F,$53,$52
                    .db $71,$BC,$3D,$43,$3F,$81,$43,$82
                    .db $75,$06,$20,$50,$11,$8F,$9B,$71
                    .db $6E,$81,$6B,$05,$6E,$11,$43,$00
                    .db $69,$00,$81,$43,$08,$58,$8F,$9B
                    .db $63,$62,$71,$BC,$71,$10,$82,$3F
                    .db $82,$75,$02,$20,$50,$11,$81,$AC
                    .db $01,$58,$11,$82,$43,$04,$00,$69
                    .db $50,$43,$50,$81,$20,$04,$50,$58
                    .db $9B,$8F,$6C,$81,$68,$01,$6C,$3D
                    .db $82,$3F,$82,$75,$02,$00,$11,$58
                    .db $81,$AC,$09,$11,$50,$20,$69,$20
                    .db $50,$43,$11,$3F,$11,$81,$43,$03
                    .db $50,$3D,$8A,$BC,$83,$68,$00,$6C
                    .db $82,$03,$81,$75,$03,$10,$11,$56
                    .db $57,$81,$AC,$01,$3D,$50,$82,$43
                    .db $00,$11,$85,$3F,$03,$10,$11,$8A
                    .db $BC,$84,$68,$81,$71,$00,$43,$81
                    .db $75,$03,$3D,$58,$64,$65,$81,$8A
                    .db $01,$11,$10,$87,$3F,$03,$10,$03
                    .db $52,$53,$81,$71,$00,$6C,$82,$68
                    .db $03,$6C,$11,$00,$69,$81,$75,$03
                    .db $3D,$71,$56,$57,$81,$8A,$01,$58
                    .db $3D,$86,$3F,$00,$10,$81,$8F,$0B
                    .db $62,$63,$52,$53,$71,$52,$53,$71
                    .db $11,$50,$69,$20,$81,$75,$03,$00
                    .db $11,$64,$65,$81,$AC,$02,$11,$00
                    .db $11,$84,$3F,$0F,$10,$52,$53,$71
                    .db $8E,$71,$62,$63,$52,$51,$63,$11
                    .db $50,$69,$20,$69,$81,$75,$03,$20
                    .db $3D,$71,$58,$81,$AC,$02,$3D,$50
                    .db $11,$84,$3F,$04,$3D,$62,$63,$71
                    .db $8E,$82,$71,$03,$62,$63,$42,$41
                    .db $82,$69,$00,$20,$81,$75,$03,$20
                    .db $3D,$58,$71,$81,$AC,$00,$3D,$83
                    .db $3F,$00,$10,$81,$03,$0A,$11,$52
                    .db $53,$52,$53,$71,$52,$53,$11,$50
                    .db $20,$82,$69,$07,$50,$43,$75,$11
                    .db $20,$00,$11,$71,$81,$AC,$01,$11
                    .db $10,$82,$3F,$00,$3D,$81,$71,$09
                    .db $52,$51,$63,$62,$63,$52,$51,$63
                    .db $3A,$20,$82,$69,$03,$50,$11,$75
                    .db $20,$9E,$75,$00,$20,$9E,$75,$01
                    .db $20,$10,$95,$75,$03,$E2,$E5,$F5
                    .db $F6,$83,$75,$02,$50,$11,$10,$90
                    .db $75,$07,$01,$02,$03,$05,$84,$32
                    .db $33,$C4,$83,$75,$03,$11,$71,$11
                    .db $10,$8D,$75,$02,$01,$02,$11,$82
                    .db $71,$04,$35,$36,$37,$38,$01,$82
                    .db $75,$01,$10,$03,$81,$11,$00,$10
                    .db $8B,$75,$01,$10,$11,$84,$71,$05
                    .db $49,$4A,$59,$5A,$11,$10,$81,$75
                    .db $81,$3F,$02,$10,$71,$3D,$8B,$75
                    .db $02,$3D,$AD,$5D,$84,$68,$00,$5D
                    .db $82,$71,$00,$3D,$81,$75,$82,$3F
                    .db $81,$3D,$8B,$75,$01,$3D,$AD,$86
                    .db $68,$81,$71,$01,$11,$00,$81,$75
                    .db $81,$3F,$02,$10,$11,$00,$87,$75
                    .db $01,$01,$02,$81,$03,$02,$00,$11
                    .db $5D,$84,$68,$04,$5D,$71,$11,$50
                    .db $20,$81,$75,$05,$3F,$10,$11,$50
                    .db $20,$10,$85,$75,$01,$10,$11,$82
                    .db $71,$04,$20,$50,$44,$43,$44,$81
                    .db $43,$05,$44,$43,$42,$40,$69,$20
                    .db $81,$75,$05,$9C,$43,$50,$69,$20
                    .db $3D,$85,$A4,$01,$3D,$AD,$81,$8A
                    .db $03,$11,$20,$69,$20,$87,$69,$81
                    .db $20,$81,$75,$81,$20,$81,$69,$01
                    .db $50,$3D,$81,$B4,$01,$B5,$A5,$81
                    .db $B4,$01,$3D,$AD,$81,$8A,$02,$11
                    .db $50,$20,$87,$69,$0A,$20,$69,$20
                    .db $10,$75,$20,$69,$20,$50,$11,$4D
                    .db $85,$75,$01,$4D,$71,$81,$AC,$03
                    .db $71,$11,$50,$20,$87,$69,$81,$20
                    .db $01,$11,$10,$81,$20,$00,$50,$81
                    .db $11,$01,$00,$02,$82,$03,$05,$02
                    .db $01,$3D,$71,$8F,$9B,$81,$71,$01
                    .db $11,$44,$81,$43,$00,$60,$83,$69
                    .db $04,$20,$69,$20,$71,$3D,$81,$43
                    .db $81,$11,$02,$50,$20,$11,$82,$43
                    .db $81,$11,$03,$00,$11,$71,$AE,$83
                    .db $BC,$02,$AE,$11,$00,$84,$69,$0A
                    .db $20,$50,$58,$4D,$43,$11,$71,$3D
                    .db $69,$20,$41,$82,$69,$07,$41,$42
                    .db $20,$41,$42,$44,$43,$44,$81,$43
                    .db $02,$44,$50,$20,$83,$69,$0B,$20
                    .db $50,$11,$71,$3D,$20,$50,$43,$00
                    .db $69,$20,$42,$82,$43,$02,$42,$41
                    .db $20,$81,$69,$00,$20,$84,$69,$81
                    .db $20,$82,$69,$0B,$41,$42,$11,$58
                    .db $71,$4D,$69,$20,$69,$20,$69,$20
                    .db $85,$73,$02,$20,$69,$20,$84,$69
                    .db $02,$20,$69,$20,$82,$43,$00,$11
                    .db $81,$58,$03,$71,$58,$3D,$20,$81
                    .db $69,$03,$20,$69,$50,$11,$83,$3F
                    .db $01,$11,$20,$81,$69,$00,$20,$84
                    .db $69,$02,$20,$50,$58,$81,$AC,$81
                    .db $89,$81,$58,$07,$11,$00,$69,$20
                    .db $69,$20,$50,$11,$84,$3F,$03,$11
                    .db $50,$69,$20,$84,$69,$01,$20,$50
                    .db $81,$89,$81,$AC,$81,$99,$81,$89
                    .db $00,$3D,$81,$20,$81,$69,$01,$20
                    .db $11,$86,$3F,$04,$11,$42,$41,$20
                    .db $60,$83,$43,$00,$11,$81,$99,$81
                    .db $AC,$81,$89,$81,$99,$06,$3D,$20
                    .db $43,$50,$69,$50,$11,$88,$3F,$03
                    .db $11,$43,$3D,$71,$81,$89,$01,$71
                    .db $58,$81,$89,$81,$8F,$09,$99,$98
                    .db $89,$71,$3D,$20,$3F,$11,$43,$11
                    .db $8A,$3F,$02,$10,$11,$58,$81,$99
                    .db $81,$89,$01,$99,$98,$82,$89,$81
                    .db $99,$02,$58,$3D,$50,$82,$3F,$81
                    .db $10,$83,$3F,$81,$10,$82,$3F,$01
                    .db $10,$11,$81,$89,$04,$58,$89,$98
                    .db $99,$89,$82,$98,$00,$99,$81,$89
                    .db $02,$58,$4D,$11,$82,$03,$02,$11
                    .db $00,$11,$81,$3F,$00,$10,$81,$11
                    .db $82,$03,$04,$11,$58,$99,$98,$89
                    .db $81,$99,$00,$89,$83,$98,$00,$89
                    .db $81,$99,$02,$71,$4D,$75,$82,$43
                    .db $81,$50,$02,$11,$3F,$9C,$82,$43
                    .db $02,$11,$71,$58,$82,$89,$01,$98
                    .db $99,$81,$89,$85,$99,$00,$58,$81
                    .db $89,$01,$11,$10,$81,$69,$81,$20
                    .db $82,$76,$00,$20,$81,$69,$03,$20
                    .db $50,$11,$71,$82,$99,$03,$98,$89
                    .db $99,$98,$86,$89,$81,$99,$01,$58
                    .db $3D,$81,$69,$81,$20,$82,$76,$00
                    .db $20,$82,$69,$03,$20,$41,$42,$11
                    .db $81,$89,$81,$99,$01,$89,$98,$81
                    .db $99,$81,$98,$82,$99,$81,$89,$01
                    .db $58,$3D,$81,$69,$81,$20,$82,$7D
                    .db $00,$20,$81,$69,$00,$20,$82,$69
                    .db $00,$3D,$81,$99,$81,$89,$01,$99
                    .db $98,$81,$89,$81,$98,$06,$89,$3B
                    .db $89,$98,$99,$11,$00,$81,$69,$05
                    .db $20,$50,$11,$3F,$11,$20,$82,$69
                    .db $00,$20,$81,$69,$06,$3D,$71,$58
                    .db $99,$98,$89,$99,$83,$98,$01,$99
                    .db $89,$81,$98,$02,$89,$3D,$20,$82
                    .db $43,$00,$11,$81,$3F,$00,$11,$83
                    .db $43,$03,$50,$41,$42,$11,$82,$89
                    .db $82,$98,$82,$99,$01,$98,$89,$83
                    .db $99,$01,$3D,$20,$87,$75,$04,$08
                    .db $07,$06,$05,$11,$81,$58,$84,$99
                    .db $00,$98,$82,$89,$81,$99,$81,$89
                    .db $09,$58,$71,$3D,$20,$75,$11,$50
                    .db $20,$3D,$71,$81,$AC,$01,$71,$11
                    .db $82,$03,$00,$11,$81,$71,$01,$62
                    .db $63,$82,$71,$08,$62,$63,$11,$2A
                    .db $69,$20,$69,$50,$11,$83,$75,$05
                    .db $11,$20,$00,$11,$8F,$9B,$84,$71
                    .db $00,$5D,$81,$68,$00,$5D,$82,$71
                    .db $03,$58,$71,$11,$50,$81,$20,$02
                    .db $41,$42,$11,$85,$75,$06,$00,$43
                    .db $23,$30,$AE,$AF,$AD,$81,$8A,$01
                    .db $71,$5D,$81,$68,$00,$5D,$83,$71
                    .db $05,$11,$50,$20,$69,$2A,$11,$86
                    .db $75,$01,$10,$11,$81,$71,$03,$11
                    .db $30,$8E,$AD,$81,$8A,$01,$52,$53
                    .db $81,$71,$81,$58,$03,$71,$58,$11
                    .db $50,$81,$69,$01,$20,$3A,$81,$75
                    .db $01,$A6,$A7,$83,$75,$01,$00,$11
                    .db $81,$71,$03,$11,$00,$52,$53,$81
                    .db $AC,$02,$62,$63,$71,$81,$58,$03
                    .db $11,$43,$42,$41,$81,$69,$08,$20
                    .db $50,$11,$A6,$A7,$B6,$B7,$A6,$A7
                    .db $81,$75,$01,$20,$50,$81,$43,$03
                    .db $50,$20,$62,$63,$81,$AC,$00,$71
                    .db $81,$58,$03,$71,$11,$50,$20,$83
                    .db $69,$04,$50,$11,$75,$B6,$B7,$81
                    .db $3F,$01,$B6,$B7,$81,$75,$01,$20
                    .db $69,$81,$3E,$0C,$69,$20,$42,$44
                    .db $43,$44,$43,$44,$43,$42,$41,$69
                    .db $20,$82,$69,$03,$50,$11,$A6,$A7
                    .db $85,$3F,$81,$75,$01,$20,$69,$81
                    .db $3E,$00,$69,$82,$20,$84,$69,$00
                    .db $20,$81,$69,$00,$20,$81,$69,$04
                    .db $50,$11,$75,$B6,$B7,$85,$3F,$81
                    .db $75,$01,$20,$69,$81,$3E,$03,$69
                    .db $20,$69,$20,$83,$69,$00,$20,$82
                    .db $69,$05,$20,$41,$42,$11,$A6,$A7
                    .db $87,$3F,$81,$75,$01,$20,$69,$81
                    .db $3E,$00,$69,$81,$20,$85,$69,$04
                    .db $20,$69,$50,$43,$11,$81,$75,$01
                    .db $B6,$B7,$87,$3F,$81,$75,$01,$20
                    .db $69,$81,$3E,$03,$69,$20,$41,$20
                    .db $83,$69,$03,$20,$41,$42,$11,$83
                    .db $75,$01,$A6,$A7,$87,$3F,$81,$75
                    .db $01,$20,$69,$81,$3E,$02,$69,$20
                    .db $11,$85,$43,$00,$11,$85,$75,$01
                    .db $B6,$B7,$87,$3F,$81,$75,$01,$20
                    .db $69,$81,$3E,$08,$69,$20,$03,$04
                    .db $03,$04,$03,$02,$01,$87,$75,$01
                    .db $A6,$A7,$86,$3F,$03,$75,$10,$20
                    .db $C2,$81,$C3,$03,$C2,$20,$56,$57
                    .db $82,$71,$02,$56,$57,$10,$86,$75
                    .db $03,$B6,$B7,$A6,$A7,$83,$3F,$04
                    .db $A6,$75,$4D,$50,$D2,$81,$D3,$03
                    .db $D2,$50,$9E,$9F,$82,$71,$02,$9E
                    .db $9F,$3D,$88,$75,$0A,$B6,$B7,$3F
                    .db $A6,$A7,$3F,$B6,$75,$3D,$11,$20
                    .db $81,$3E,$03,$20,$11,$9E,$9F,$82
                    .db $71,$02,$64,$65,$4D,$8B,$75,$01
                    .db $B6,$B7,$82,$75,$02,$4D,$11,$50
                    .db $81,$3E,$05,$50,$11,$9E,$9F,$56
                    .db $57,$81,$71,$01,$58,$3D,$90,$75
                    .db $02,$3D,$58,$11,$81,$43,$06,$11
                    .db $58,$64,$65,$9E,$9F,$71,$81,$58
                    .db $00,$3D,$83,$75,$81,$60,$8A,$75
                    .db $00,$00,$81,$43,$00,$11,$83,$71
                    .db $03,$58,$64,$65,$11,$81,$43,$00
                    .db $00,$83,$75,$02,$3D,$11,$60,$83
                    .db $75,$02,$60,$03,$60,$82,$75,$81
                    .db $20,$01,$69,$3D,$86,$71,$00,$3D
                    .db $81,$69,$00,$20,$83,$75,$00,$60
                    .db $81,$11,$00,$60,$81,$75,$03,$60
                    .db $11,$A6,$A7,$81,$03,$00,$75,$81
                    .db $20,$01,$69,$00,$81,$43,$05,$44
                    .db $43,$44,$43,$44,$00,$81,$69,$00
                    .db $20,$83,$75,$03,$20,$3D,$A6,$A7
                    .db $81,$03,$06,$11,$A6,$A9,$B7,$A6
                    .db $A7,$11,$81,$20,$00,$69,$81,$20
                    .db $84,$69,$81,$20,$81,$69,$01,$20
                    .db $11,$82,$75,$03,$60,$11,$B6,$B7
                    .db $82,$71,$08,$B6,$A8,$A7,$B6,$A8
                    .db $11,$50,$20,$69,$81,$20,$84,$69
                    .db $81,$20,$81,$69,$01,$50,$11,$81
                    .db $75,$01,$60,$11,$84,$71,$07,$A6
                    .db $A7,$B6,$B7,$71,$B6,$75,$11,$81
                    .db $43,$81,$20,$84,$69,$81,$20,$81
                    .db $43,$00,$11,$82,$75,$02,$60,$11
                    .db $58,$83,$71,$02,$B6,$B7,$58,$82
                    .db $71,$82,$75,$02,$11,$50,$20,$84
                    .db $69,$02,$20,$50,$11,$84,$75,$0C
                    .db $20,$3D,$58,$A6,$A7,$A6,$A7,$A6
                    .db $A7,$A6,$A7,$A6,$A7,$83,$75,$00
                    .db $11,$86,$43,$00,$11,$85,$75,$0C
                    .db $60,$11,$A6,$A9,$B7,$B6,$B7,$B6
                    .db $B7,$B6,$B7,$B6,$B7,$92,$75,$04
                    .db $60,$11,$B6,$A8,$A7,$81,$71,$05
                    .db $A6,$A7,$A6,$A7,$A6,$A7,$8D,$75
                    .db $11,$A6,$A7,$75,$A6,$A7,$20,$60
                    .db $11,$B6,$A8,$A7,$71,$B6,$B7,$B6
                    .db $B7,$B6,$B7,$8D,$75,$04,$B6,$B7
                    .db $A6,$A9,$B7,$81,$20,$05,$60,$11
                    .db $B6,$B7,$11,$43,$81,$11,$81,$43
                    .db $00,$11,$8C,$75,$05,$A6,$A7,$A6
                    .db $A9,$B7,$3F,$82,$20,$00,$60,$81
                    .db $43,$01,$60,$69,$81,$3D,$81,$69
                    .db $00,$3D,$89,$75,$08,$A6,$A7,$75
                    .db $B6,$B7,$B6,$B7,$A6,$A7,$83,$20
                    .db $81,$69,$01,$20,$69,$81,$60,$81
                    .db $69,$00,$60,$89,$75,$01,$B6,$B7
                    .db $84,$75,$02,$B6,$B7,$43,$82,$20
                    .db $81,$69,$01,$20,$69,$81,$20,$81
                    .db $69,$00,$20,$86,$75,$04,$10,$11
                    .db $71,$58,$6E,$82,$6B,$83,$AD,$01
                    .db $8E,$99,$81,$98,$00,$99,$81,$8F
                    .db $05,$99,$98,$89,$58,$3D,$50,$86
                    .db $75,$03,$3D,$71,$58,$71,$83,$68
                    .db $83,$AD,$01,$8E,$89,$81,$98,$00
                    .db $89,$81,$AC,$05,$89,$98,$99,$11
                    .db $00,$11,$86,$75,$04,$4D,$58,$71
                    .db $58,$5D,$81,$68,$00,$5D,$84,$89
                    .db $82,$98,$00,$99,$81,$AC,$81,$99
                    .db $02,$11,$50,$20,$87,$75,$03,$3D
                    .db $71,$00,$50,$81,$43,$81,$71,$87
                    .db $99,$02,$71,$9B,$8F,$81,$89,$02
                    .db $3D,$69,$20,$87,$75,$01,$4D,$3D
                    .db $81,$50,$81,$20,$02,$50,$71,$6E
                    .db $82,$6B,$83,$AD,$08,$AF,$AE,$89
                    .db $98,$99,$3D,$69,$20,$11,$86,$75
                    .db $03,$00,$11,$10,$11,$81,$43,$01
                    .db $50,$3D,$83,$68,$83,$AD,$0A,$8E
                    .db $89,$98,$99,$11,$00,$69,$50,$11
                    .db $A6,$A7,$84,$75,$03,$20,$50,$11
                    .db $10,$81,$3F,$02,$11,$3D,$5D,$81
                    .db $68,$01,$5D,$58,$82,$89,$00,$98
                    .db $81,$99,$07,$71,$3A,$20,$50,$11
                    .db $75,$B6,$B7,$84,$75,$04,$20,$69
                    .db $50,$11,$03,$81,$10,$01,$58,$71
                    .db $81,$AC,$01,$58,$89,$82,$98,$00
                    .db $99,$81,$71,$03,$11,$2A,$20,$11
                    .db $81,$75,$81,$3F,$01,$A6,$A7,$81
                    .db $75,$01,$11,$20,$81,$69,$00,$50
                    .db $82,$11,$01,$71,$58,$81,$AC,$00
                    .db $71,$83,$99,$03,$71,$11,$42,$41
                    .db $81,$20,$00,$11,$81,$75,$81,$3F
                    .db $01,$B6,$B7,$81,$75,$01,$11,$50
                    .db $82,$69,$01,$41,$42,$89,$43,$06
                    .db $42,$41,$69,$20,$69,$50,$11,$81
                    .db $75,$81,$3F,$01,$A6,$A7,$82,$75
                    .db $01,$11,$50,$83,$69,$00,$20,$87
                    .db $69,$00,$20,$82,$69,$02,$20,$2A
                    .db $11,$82,$75,$81,$3F,$01,$B6,$B7
                    .db $83,$75,$00,$60,$83,$43,$02,$50
                    .db $69,$50,$81,$43,$00,$50,$83,$69
                    .db $00,$20,$81,$69,$01,$20,$3A,$83
                    .db $75,$02,$3F,$A6,$A7,$84,$75,$00
                    .db $3D,$82,$71,$03,$AD,$DA,$69,$DA
                    .db $81,$8A,$00,$3D,$82,$69,$00,$20
                    .db $82,$69,$01,$50,$11,$83,$75,$02
                    .db $A7,$B6,$B7,$84,$75,$01,$3D,$58
                    .db $81,$71,$03,$AD,$DA,$69,$DA,$81
                    .db $8A,$00,$3D,$81,$69,$07,$50,$43
                    .db $50,$41,$42,$10,$03,$10,$82,$75
                    .db $00,$B7,$81,$75,$02,$60,$03,$60
                    .db $81,$75,$07,$60,$11,$A6,$A7,$58
                    .db $3D,$43,$00,$81,$43,$00,$00,$81
                    .db $43,$07,$00,$43,$00,$11,$75,$00
                    .db $43,$00,$85,$75,$0B,$3D,$71,$11
                    .db $03,$60,$20,$3D,$B6,$B7,$11,$60
                    .db $75,$83,$20,$81,$75,$82,$20,$81
                    .db $75,$02,$20,$69,$20,$85,$75,$0B
                    .db $3D,$A6,$A7,$A6,$A7,$43,$11,$A6
                    .db $A7,$3D,$20,$75,$83,$20,$81,$75
                    .db $82,$20,$81,$75,$02,$20,$69,$20
                    .db $82,$75,$00,$60,$81,$03,$0B,$A6
                    .db $A9,$A8,$A9,$B7,$71,$58,$B6,$B7
                    .db $3D,$20,$11,$83,$20,$01,$11,$75
                    .db $82,$20,$05,$75,$11,$20,$69,$20
                    .db $11,$81,$75,$0F,$3D,$A6,$A7,$B6
                    .db $B7,$B6,$A8,$A7,$A6,$A7,$A6,$A7
                    .db $3D,$20,$11,$50,$81,$20,$00,$50
                    .db $81,$11,$82,$20,$81,$11,$03,$50
                    .db $69,$50,$11,$81,$75,$0F,$11,$B6
                    .db $B7,$A6,$A7,$71,$B6,$A8,$A9,$B7
                    .db $B6,$B7,$11,$60,$75,$11,$81,$43
                    .db $0A,$11,$75,$11,$50,$20,$50,$11
                    .db $75,$11,$43,$11,$82,$75,$0D,$58
                    .db $A6,$A7,$B6,$A8,$A7,$A6,$A9,$A8
                    .db $A7,$A6,$A7,$71,$11,$81,$03,$00
                    .db $60,$83,$75,$02,$11,$43,$11,$87
                    .db $75,$11,$A7,$B6,$B7,$71,$B6,$B7
                    .db $B6,$B7,$B6,$A8,$A9,$A8,$A7,$71
                    .db $A6,$A7,$11,$60,$8D,$75,$13,$A8
                    .db $A7,$A6,$A7,$A6,$A7,$A6,$A7,$A6
                    .db $A9,$B7,$B6,$A8,$A7,$B6,$A8,$A7
                    .db $11,$03,$60,$8B,$75,$13,$B6,$B7
                    .db $B6,$B7,$B6,$B7,$B6,$B7,$B6,$B7
                    .db $A6,$A7,$B6,$B7,$71,$B6,$A8,$A7
                    .db $11,$60,$81,$75,$01,$A6,$A7,$87
                    .db $75,$17,$A6,$A7,$A6,$A7,$A6,$A7
                    .db $A6,$A7,$A6,$A7,$B6,$B7,$A6,$A7
                    .db $71,$A6,$A9,$B7,$3D,$20,$75,$A6
                    .db $A9,$B7,$87,$75,$16,$B6,$A8,$A9
                    .db $B7,$B6,$B7,$B6,$B7,$B6,$A8,$A7
                    .db $A6,$A9,$A8,$A7,$B6,$A8,$A7,$11
                    .db $60,$75,$B6,$B7,$88,$75,$13,$A6
                    .db $A9,$B7,$A6,$A7,$A6,$A7,$A6,$A7
                    .db $B6,$B7,$B6,$B7,$B6,$B7,$A6,$A9
                    .db $B7,$11,$60,$8B,$75,$09,$B6,$B7
                    .db $A6,$A9,$A8,$A9,$A8,$A9,$B7,$11
                    .db $83,$43,$07,$11,$B6,$B7,$11,$60
                    .db $20,$A6,$A7,$82,$75,$01,$A6,$A7
                    .db $84,$75,$09,$A6,$A7,$B6,$B7,$B6
                    .db $B7,$B6,$B7,$58,$3D,$83,$69,$00
                    .db $60,$81,$11,$00,$60,$81,$20,$06
                    .db $B6,$A8,$A7,$A6,$A7,$B6,$B7,$84
                    .db $75,$01,$B6,$B7,$81,$43,$81,$11
                    .db $03,$43,$11,$71,$3D,$83,$69,$00
                    .db $20,$81,$60,$82,$20,$04,$3F,$B6
                    .db $A8,$A9,$B7,$86,$75,$01,$43,$60
                    .db $81,$69,$81,$60,$03,$69,$3D,$58
                    .db $3D,$83,$69,$85,$20,$03,$A6,$A7
                    .db $B6,$B7,$87,$75,$01,$69,$20,$81
                    .db $69,$81,$20,$03,$69,$60,$43,$60
                    .db $83,$69,$84,$20,$02,$43,$B6,$B7
                    .db $89,$75,$83,$75,$03,$20,$69,$20
                    .db $B8,$81,$B9,$06,$B8,$20,$69,$20
                    .db $75,$54,$55,$8C,$75,$81,$4F,$83
                    .db $75,$03,$20,$69,$20,$B8,$81,$B9
                    .db $06,$B8,$20,$69,$20,$04,$9E,$9F
                    .db $82,$03,$04,$05,$06,$07,$54,$55
                    .db $84,$75,$81,$4F,$81,$75,$05,$54
                    .db $55,$20,$69,$20,$B8,$81,$B9,$07
                    .db $B8,$20,$69,$20,$71,$9E,$9F,$71
                    .db $81,$AC,$04,$71,$56,$57,$9E,$9F
                    .db $84,$75,$81,$4F,$81,$75,$05,$9E
                    .db $9F,$20,$C6,$C7,$C8,$81,$C9,$07
                    .db $C8,$C7,$C6,$20,$71,$9E,$9F,$71
                    .db $81,$AC,$04,$71,$64,$65,$9E,$9F
                    .db $84,$75,$81,$4F,$81,$75,$05,$9E
                    .db $9F,$20,$D6,$D7,$AA,$81,$AB,$07
                    .db $AA,$D7,$D6,$20,$11,$9E,$67,$57
                    .db $81,$AC,$82,$71,$02,$64,$67,$55
                    .db $83,$75,$81,$4F,$07,$75,$0A,$9E
                    .db $9F,$50,$E6,$E7,$AA,$81,$AB,$07
                    .db $AA,$E7,$E6,$50,$11,$64,$9E,$9F
                    .db $81,$71,$81,$BC,$04,$AE,$71,$64
                    .db $65,$0A,$82,$75,$81,$4F,$07,$75
                    .db $1A,$64,$65,$11,$50,$F7,$F8,$81
                    .db $F9,$10,$F8,$F7,$50,$11,$71,$56
                    .db $66,$9F,$71,$53,$52,$71,$9B,$8F
                    .db $52,$53,$1A,$82,$75,$81,$4F,$02
                    .db $75,$00,$11,$81,$71,$02,$11,$20
                    .db $B8,$81,$B9,$0B,$B8,$20,$11,$56
                    .db $57,$9E,$9F,$67,$57,$63,$51,$52
                    .db $81,$AC,$02,$62,$63,$3D,$82,$75
                    .db $81,$4F,$07,$75,$20,$3D,$56,$57
                    .db $11,$20,$B8,$81,$B9,$0B,$B8,$20
                    .db $11,$9E,$67,$66,$9F,$9E,$9F,$3C
                    .db $63,$62,$81,$8A,$02,$71,$11,$00
                    .db $82,$75,$81,$4F,$07,$75,$20,$3D
                    .db $64,$65,$11,$50,$B8,$81,$B9,$02
                    .db $B8,$50,$11,$81,$9E,$06,$9F,$67
                    .db $66,$9F,$58,$52,$53,$81,$8A,$02
                    .db $11,$50,$20,$82,$75,$81,$4F,$07
                    .db $11,$20,$3D,$71,$BF,$71,$11,$43
                    .db $81,$AC,$0B,$43,$56,$57,$64,$9E
                    .db $9F,$9E,$9F,$65,$58,$62,$63,$81
                    .db $AC,$02,$11,$50,$20,$82,$75,$81
                    .db $4F,$11,$11,$50,$3D,$BD,$BA,$BD
                    .db $BF,$71,$9B,$8F,$58,$64,$65,$71
                    .db $64,$65,$9E,$9F,$81,$58,$07,$3C
                    .db $58,$9B,$8F,$58,$3D,$20,$11,$81
                    .db $75,$81,$4F,$08,$75,$11,$3D,$BF
                    .db $BD,$BF,$71,$8F,$9B,$81,$58,$84
                    .db $2C,$01,$9E,$9F,$81,$8A,$07,$AD
                    .db $AF,$AE,$58,$3C,$3D,$50,$11,$81
                    .db $75,$81,$4F,$81,$75,$09,$4D,$BA
                    .db $BF,$BD,$71,$9B,$8F,$58,$71,$2C
                    .db $82,$71,$02,$2C,$9E,$9F,$81,$8A
                    .db $06,$AD,$8E,$58,$3C,$58,$4D,$11
                    .db $82,$75,$81,$43,$81,$75,$08,$40
                    .db $42,$43,$11,$8F,$9B,$56,$57,$2C
                    .db $83,$71,$02,$2C,$9E,$9F,$81,$AC
                    .db $81,$58,$03,$43,$44,$42,$40,$83
                    .db $75,$81,$69,$81,$75,$00,$20,$81
                    .db $69,$00,$3D,$81,$AC,$03,$64,$65
                    .db $6E,$5D,$81,$68,$03,$5D,$6E,$64
                    .db $65,$81,$AC,$01,$3C,$3D,$82,$69
                    .db $00,$20,$83,$75,$81,$69,$81,$75
                    .db $00,$20,$81,$69,$00,$3D,$81,$5D
                    .db $00,$6B,$81,$6D,$83,$6B,$81,$6D
                    .db $00,$6B,$81,$5D,$01,$58,$3D,$82
                    .db $69,$00,$20,$83,$75,$81,$69,$02
                    .db $75,$11,$20,$81,$69,$00,$3D,$81
                    .db $5D,$01,$6B,$6E,$84,$2C,$02,$71
                    .db $6E,$6B,$81,$5D,$01,$71,$3D,$82
                    .db $69,$01,$20,$11,$82,$75,$81,$69
                    .db $09,$75,$11,$42,$41,$69,$00,$43
                    .db $44,$43,$44,$81,$43,$81,$44,$81
                    .db $43,$05,$44,$43,$44,$43,$44,$00
                    .db $81,$69,$02,$41,$42,$11,$82,$75
                    .db $81,$69,$82,$75,$01,$11,$43,$81
                    .db $20,$8C,$69,$81,$20,$81,$43,$00
                    .db $11,$84,$75,$81,$69,$84,$75,$81
                    .db $20,$8C,$69,$81,$20,$87,$75,$82
                    .db $69,$81,$20,$00,$3D,$85,$71,$04
                    .db $3D,$69,$20,$69,$20,$84,$69,$02
                    .db $20,$69,$20,$81,$69,$81,$20,$82
                    .db $69,$81,$71,$81,$20,$01,$69,$3D
                    .db $85,$71,$02,$3D,$69,$20,$81,$69
                    .db $00,$00,$83,$43,$02,$46,$47,$48
                    .db $81,$20,$81,$69,$00,$20,$81,$69
                    .db $81,$71,$81,$20,$02,$2A,$00,$11
                    .db $83,$71,$06,$11,$00,$2A,$69,$20
                    .db $2A,$11,$85,$71,$02,$11,$42,$41
                    .db $81,$20,$82,$69,$81,$71,$81,$20
                    .db $03,$3A,$20,$40,$42,$81,$43,$07
                    .db $42,$40,$20,$3A,$20,$69,$3A,$71
                    .db $81,$8A,$83,$AD,$04,$8E,$71,$11
                    .db $50,$20,$82,$69,$81,$71,$02,$69
                    .db $00,$11,$82,$20,$81,$69,$82,$20
                    .db $04,$3D,$20,$69,$3D,$71,$81,$8A
                    .db $83,$AD,$81,$AF,$03,$8E,$11,$50
                    .db $20,$81,$69,$81,$71,$00,$43,$81
                    .db $11,$00,$50,$81,$20,$81,$69,$81
                    .db $20,$01,$50,$3D,$81,$43,$00,$3D
                    .db $87,$71,$04,$8E,$8A,$8F,$11,$0F
                    .db $81,$69,$81,$71,$05,$A6,$A7,$3C
                    .db $11,$42,$40,$81,$69,$03,$40,$42
                    .db $11,$00,$81,$71,$01,$40,$42,$83
                    .db $43,$00,$11,$82,$71,$81,$AC,$01
                    .db $71,$1F,$81,$69,$81,$71,$05,$B6
                    .db $B7,$A6,$A7,$3C,$11,$81,$43,$81
                    .db $11,$04,$00,$20,$71,$11,$20,$84
                    .db $69,$03,$40,$42,$11,$71,$81,$8A
                    .db $01,$71,$2F,$81,$69,$81,$71,$04
                    .db $A6,$A7,$B6,$B7,$11,$82,$43,$01
                    .db $42,$40,$81,$20,$02,$11,$50,$20
                    .db $83,$69,$04,$20,$69,$20,$50,$11
                    .db $81,$8A,$01,$71,$11,$83,$71,$04
                    .db $B6,$B7,$3C,$11,$00,$83,$69,$82
                    .db $20,$02,$3D,$50,$20,$84,$69,$03
                    .db $20,$69,$20,$3D,$81,$AC,$85,$71
                    .db $81,$3C,$02,$11,$50,$20,$84,$69
                    .db $05,$20,$00,$3D,$11,$42,$41,$82
                    .db $69,$04,$20,$69,$20,$69,$3D,$81
                    .db $AC,$85,$71,$03,$4F,$3C,$4F,$3C
                    .db $81,$4F,$00,$3D,$96,$3F,$81,$75
                    .db $83,$4F,$81,$3C,$01,$11,$0A,$95
                    .db $3F,$81,$75,$81,$8A,$81,$AD,$81
                    .db $4F,$01,$3C,$1A,$95,$3F,$81,$75
                    .db $81,$8A,$81,$AD,$03,$4F,$3C,$4F
                    .db $3D,$8E,$3F,$00,$0A,$81,$03,$01
                    .db $02,$01,$81,$3F,$81,$75,$81,$AC
                    .db $81,$4F,$03,$11,$43,$42,$40,$8E
                    .db $3F,$00,$1A,$81,$4F,$01,$3C,$11
                    .db $81,$23,$81,$75,$81,$AC,$81,$4F
                    .db $00,$3A,$82,$20,$8E,$43,$04,$3D
                    .db $4F,$3C,$4F,$3C,$81,$4F,$81,$75
                    .db $82,$4F,$01,$11,$2A,$82,$20,$00
                    .db $4F,$81,$3C,$01,$4F,$3C,$87,$4F
                    .db $81,$3C,$03,$00,$11,$4F,$3C,$82
                    .db $4F,$81,$75,$81,$4F,$01,$11,$50
                    .db $81,$20,$06,$69,$20,$3C,$4F,$3C
                    .db $4F,$3C,$88,$4F,$04,$3C,$20,$40
                    .db $42,$11,$82,$4F,$81,$75,$81,$4F
                    .db $01,$3D,$69,$81,$20,$05,$69,$20
                    .db $4F,$3C,$4F,$3C,$81,$4F,$81,$AC
                    .db $01,$4F,$3C,$81,$4F,$02,$3C,$11
                    .db $43,$81,$20,$01,$69,$50,$82,$43
                    .db $81,$75,$81,$4F,$01,$3D,$69,$81
                    .db $20,$03,$69,$20,$3C,$4F,$81,$3C
                    .db $01,$4F,$3C,$81,$AC,$00,$3C,$82
                    .db $4F,$02,$11,$50,$69,$81,$20,$84
                    .db $69,$81,$75,$03,$4F,$3C,$11,$50
                    .db $81,$20,$01,$69,$20,$81,$8A,$83
                    .db $AD,$81,$5D,$01,$4F,$3C,$81,$5D
                    .db $02,$3D,$50,$43,$81,$20,$84,$69
                    .db $81,$75,$03,$3C,$4F,$3C,$3D,$81
                    .db $20,$01,$69,$20,$81,$8A,$83,$AD
                    .db $81,$68,$01,$3C,$4F,$81,$68,$00
                    .db $3D,$81,$11,$01,$50,$20,$84,$69
                    .db $81,$75,$07,$4F,$3C,$11,$00,$69
                    .db $20,$40,$42,$81,$AC,$03,$3C,$4F
                    .db $3C,$4F,$81,$5D,$81,$3C,$81,$5D
                    .db $05,$11,$10,$3F,$10,$42,$41,$83
                    .db $69,$81,$75,$81,$43,$05,$50,$20
                    .db $2A,$43,$11,$3C,$81,$AC,$00,$4F
                    .db $84,$3C,$00,$4F,$83,$3C,$05,$11
                    .db $03,$11,$3C,$4F,$50,$82,$69,$81
                    .db $75,$81,$69,$81,$20,$00,$3A,$82
                    .db $3C,$81,$8A,$83,$AD,$81,$5D,$81
                    .db $AD,$81,$8A,$81,$AD,$81,$8A,$81
                    .db $AD,$00,$8E,$82,$43,$81,$75,$07
                    .db $69,$20,$69,$20,$43,$11,$3C,$4F
                    .db $81,$8A,$83,$AD,$81,$68,$81,$AD
                    .db $81,$8A,$81,$AD,$81,$8A,$81,$AD
                    .db $81,$AF,$01,$8E,$4F,$81,$75,$07
                    .db $69,$20,$69,$20,$69,$50,$11,$3C
                    .db $82,$4F,$00,$3C,$81,$4F,$81,$5D
                    .db $00,$3C,$83,$4F,$00,$3C,$81,$4F
                    .db $81,$3C,$03,$4F,$8E,$AF,$4F,$81
                    .db $75,$81,$69,$81,$20,$00,$43,$81
                    .db $50,$01,$43,$11,$81,$60,$82,$3C
                    .db $03,$4F,$3C,$4F,$3C,$81,$60,$81
                    .db $3C,$81,$60,$00,$3C,$81,$60,$82
                    .db $3C,$81,$75,$08,$69,$20,$69,$20
                    .db $3F,$11,$50,$69,$60,$81,$11,$00
                    .db $60,$81,$3C,$00,$60,$82,$23,$81
                    .db $11,$81,$23,$81,$11,$02,$23,$11
                    .db $3D,$82,$3C,$81,$75,$81,$69,$81
                    .db $20,$04,$11,$3F,$11,$60,$11,$81
                    .db $4F,$00,$11,$81,$23,$00,$11,$8A
                    .db $4F,$00,$11,$82,$23,$81,$75,$07
                    .db $69,$20,$69,$50,$11,$3F,$60,$11
                    .db $95,$4F,$81,$75,$9D,$71,$81,$69
                    .db $9D,$71,$81,$69,$9D,$71,$81,$69
                    .db $9D,$71,$81,$69,$9D,$71,$81,$69
                    .db $82,$71,$00,$7C,$81,$71,$81,$7C
                    .db $81,$71,$82,$7C,$81,$71,$00,$7C
                    .db $81,$71,$00,$7C,$81,$71,$00,$7C
                    .db $81,$71,$00,$7C,$84,$71,$81,$43
                    .db $81,$71,$08,$7C,$71,$7C,$71,$7C
                    .db $71,$7C,$71,$7C,$82,$71,$0A,$7C
                    .db $71,$7C,$71,$7C,$71,$7C,$71,$7C
                    .db $71,$7C,$88,$71,$00,$7C,$82,$71
                    .db $04,$7C,$71,$7C,$71,$7C,$82,$71
                    .db $00,$7C,$82,$71,$06,$7C,$71,$7C
                    .db $71,$7C,$71,$7C,$89,$71,$00,$7C
                    .db $81,$71,$03,$7C,$71,$7C,$71,$82
                    .db $7C,$01,$71,$7C,$82,$71,$01,$7C
                    .db $71,$82,$7C,$01,$71,$7C,$8A,$71
                    .db $01,$7C,$71,$81,$7C,$81,$71,$00
                    .db $7C,$82,$71,$00,$7C,$82,$71,$06
                    .db $7C,$71,$7C,$71,$7C,$71,$7C,$88
                    .db $71,$04,$7C,$71,$7C,$71,$7C,$82
                    .db $71,$00,$7C,$82,$71,$0A,$7C,$71
                    .db $7C,$71,$7C,$71,$7C,$71,$7C,$71
                    .db $7C,$86,$71,$81,$43,$02,$00,$69
                    .db $20,$83,$69,$06,$20,$50,$11,$71
                    .db $02,$01,$11,$83,$43,$03,$42,$41
                    .db $20,$3D,$81,$8A,$85,$71,$82,$69
                    .db $81,$20,$82,$69,$06,$41,$42,$A6
                    .db $A7,$A6,$A7,$3D,$85,$3F,$02,$11
                    .db $50,$3D,$81,$8A,$85,$71,$81,$43
                    .db $02,$60,$20,$50,$82,$43,$07,$11
                    .db $A6,$A9,$B7,$B6,$B7,$00,$11,$85
                    .db $3F,$01,$60,$11,$81,$AC,$87,$71
                    .db $04,$11,$60,$11,$A6,$A7,$81,$71
                    .db $01,$B6,$B7,$81,$71,$02,$3D,$50
                    .db $11,$85,$3F,$01,$3D,$71,$81,$AC
                    .db $88,$71,$06,$11,$60,$B6,$B7,$A6
                    .db $A7,$71,$81,$8A,$02,$AD,$3D,$11
                    .db $85,$3F,$02,$10,$3D,$71,$81,$AC
                    .db $89,$71,$05,$11,$60,$71,$B6,$B7
                    .db $71,$81,$8A,$01,$AD,$3D,$84,$3F
                    .db $04,$10,$03,$11,$3D,$5D,$81,$68
                    .db $00,$5D,$86,$71,$00,$3C,$81,$71
                    .db $01,$3D,$71,$81,$60,$00,$71,$81
                    .db $AC,$02,$71,$11,$10,$83,$3F,$00
                    .db $3D,$81,$71,$01,$3D,$5D,$81,$68
                    .db $00,$5D,$85,$71,$05,$3C,$71,$3C
                    .db $71,$11,$43,$81,$11,$00,$60,$81
                    .db $AC,$00,$71,$81,$60,$00,$10,$81
                    .db $3F,$00,$60,$82,$43,$03,$11,$71
                    .db $9B,$8F,$87,$71,$00,$3C,$85,$71
                    .db $00,$11,$82,$43,$81,$11,$00,$43
                    .db $81,$03,$00,$11,$81,$71,$81,$AD
                    .db $01,$AF,$AE,$9B,$71,$81,$AD,$00
                    .db $8E,$87,$71,$00,$87,$81,$88,$00
                    .db $97,$81,$86,$81,$85,$81,$86,$02
                    .db $85,$71,$85,$81,$86,$00,$85,$81
                    .db $89,$00,$87,$81,$88,$01,$87,$85
                    .db $81,$86,$00,$85,$81,$89,$81,$71
                    .db $81,$BB,$03,$58,$71,$58,$95,$81
                    .db $96,$81,$95,$81,$96,$02,$95,$71
                    .db $95,$81,$96,$00,$95,$81,$99,$00
                    .db $85,$81,$86,$01,$85,$95,$81,$96
                    .db $00,$95,$81,$99,$81,$71,$81,$BB
                    .db $00,$85,$81,$86,$00,$97,$81,$88
                    .db $81,$87,$81,$88,$02,$87,$58,$87
                    .db $81,$88,$00,$87,$81,$89,$00,$95
                    .db $81,$96,$01,$95,$87,$81,$88,$00
                    .db $97,$81,$86,$01,$85,$71,$81,$BB
                    .db $00,$95,$81,$96,$01,$95,$58,$81
                    .db $71,$00,$58,$81,$89,$85,$71,$81
                    .db $99,$00,$87,$81,$88,$04,$87,$71
                    .db $58,$71,$95,$81,$96,$01,$95,$71
                    .db $81,$BB,$00,$87,$81,$88,$01,$87
                    .db $85,$81,$86,$00,$85,$81,$99,$81
                    .db $71,$83,$89,$81,$5D,$81,$89,$81
                    .db $71,$00,$85,$81,$86,$00,$97,$81
                    .db $88,$01,$97,$71,$81,$BB,$00,$85
                    .db $81,$86,$01,$85,$95,$81,$96,$00
                    .db $95,$83,$71,$83,$99,$81,$5D,$81
                    .db $99,$81,$89,$00,$95,$81,$96,$00
                    .db $95,$81,$58,$81,$71,$81,$BB,$00
                    .db $95,$81,$96,$01,$95,$87,$81,$88
                    .db $00,$87,$81,$71,$83,$89,$02,$58
                    .db $71,$58,$82,$71,$81,$99,$00,$87
                    .db $81,$88,$01,$87,$85,$81,$86,$00
                    .db $71,$81,$BB,$00,$87,$81,$88,$01
                    .db $87,$85,$81,$86,$00,$85,$81,$71
                    .db $83,$99,$00,$85,$81,$86,$00,$85
                    .db $83,$89,$00,$85,$81,$86,$01,$85
                    .db $95,$81,$96,$00,$71,$81,$BB,$00
                    .db $85,$81,$86,$01,$85,$95,$81,$96
                    .db $00,$95,$81,$71,$83,$89,$00,$95
                    .db $81,$96,$00,$95,$83,$99,$00,$95
                    .db $81,$96,$01,$95,$87,$81,$88,$00
                    .db $71,$81,$BB,$00,$95,$81,$96,$01
                    .db $95,$87,$81,$88,$00,$87,$81,$71
                    .db $83,$99,$00,$87,$81,$88,$01,$87
                    .db $58,$82,$71,$00,$87,$81,$88,$00
                    .db $87,$83,$71,$81,$BB,$00,$87,$81
                    .db $88,$00,$97,$81,$86,$01,$85,$71
                    .db $81,$89,$81,$71,$83,$89,$00,$71
                    .db $81,$89,$00,$71,$81,$2B,$85,$89
                    .db $81,$71,$81,$BB,$00,$71,$81,$58
                    .db $00,$95,$81,$96,$01,$95,$71,$81
                    .db $99,$81,$71,$83,$99,$00,$58,$81
                    .db $99,$00,$58,$81,$2B,$85,$99,$81
                    .db $71,$81,$E8,$00,$85,$81,$86,$00
                    .db $97,$81,$88,$00,$87,$82,$71,$81
                    .db $89,$82,$71,$81,$89,$00,$71,$81
                    .db $89,$81,$71,$81,$89,$00,$85,$81
                    .db $86,$00,$85,$81,$71,$81,$3F,$00
                    .db $95,$81,$96,$00,$95,$81,$89,$83
                    .db $71,$81,$99,$00,$71,$81,$89,$81
                    .db $99,$00,$71,$81,$99,$81,$71,$81
                    .db $99,$00,$95,$81,$96,$00,$95,$81
                    .db $71,$81,$3F,$00,$87,$81,$88,$00
                    .db $87,$81,$99,$83,$89,$02,$58,$71
                    .db $58,$81,$99,$00,$71,$81,$89,$00
                    .db $71,$81,$89,$00,$85,$81,$86,$00
                    .db $97,$81,$88,$00,$87,$81,$71,$81
                    .db $D8,$81,$89,$00,$85,$81,$86,$00
                    .db $85,$83,$99,$00,$85,$81,$86,$00
                    .db $85,$81,$71,$81,$99,$00,$71,$81
                    .db $99,$00,$95,$81,$96,$01,$95,$71
                    .db $81,$89,$81,$71,$81,$3F,$81,$99
                    .db $00,$95,$81,$96,$00,$95,$83,$89
                    .db $00,$95,$81,$96,$00,$95,$83,$89
                    .db $00,$85,$81,$86,$00,$97,$81,$88
                    .db $01,$87,$58,$81,$99,$81,$71,$81
                    .db $3F,$81,$71,$00,$87,$81,$88,$00
                    .db $87,$83,$99,$00,$87,$81,$88,$00
                    .db $87,$83,$99,$00,$95,$81,$96,$00
                    .db $95,$81,$89,$00,$85,$81,$86,$00
                    .db $85,$81,$71,$81,$3F,$00,$71,$81
                    .db $89,$01,$71,$58,$83,$89,$00,$71
                    .db $81,$89,$00,$85,$81,$86,$00,$85
                    .db $81,$58,$00,$87,$81,$88,$00,$87
                    .db $81,$99,$00,$95,$81,$96,$00,$95
                    .db $81,$71,$81,$D9,$00,$71,$81,$99
                    .db $01,$58,$71,$83,$99,$00,$58,$81
                    .db $99,$00,$95,$81,$96,$00,$95,$81
                    .db $89,$00,$85,$81,$86,$00,$85,$81
                    .db $89,$00,$87,$81,$88,$00,$87,$81
                    .db $71,$81,$D8,$01,$71,$85,$81,$86
                    .db $03,$85,$71,$58,$85,$81,$86,$02
                    .db $85,$71,$87,$81,$88,$00,$87,$81
                    .db $99,$00,$95,$81,$96,$00,$95,$81
                    .db $99,$85,$71,$81,$3F,$83,$75,$03
                    .db $20,$69,$20,$B8,$81,$B9,$03,$B8
                    .db $20,$69,$20,$8F,$75,$81,$4F,$82
                    .db $71,$00,$7C,$81,$71,$00,$7C,$82
                    .db $71,$82,$7C,$81,$71,$00,$7C,$81
                    .db $71,$05,$7C,$71,$7C,$71,$7C,$71
                    .db $82,$7C,$82,$71,$81,$43,$9D,$71
                    .db $81,$69,$85,$71,$81,$7B,$83,$71
                    .db $81,$7B,$83,$71,$81,$7B,$83,$71
                    .db $81,$7B,$83,$71,$81,$43,$85,$71
                    .db $81,$7B,$83,$71,$81,$7B,$83,$71
                    .db $81,$7B,$83,$71,$81,$7B,$C7,$71
                    .db $81,$5D,$81,$6B,$81,$5D,$83,$71
                    .db $81,$7B,$83,$71,$81,$7B,$83,$71
                    .db $81,$7B,$87,$71,$81,$5D,$81,$6B
                    .db $81,$5D,$83,$71,$81,$7B,$83,$71
                    .db $81,$7B,$83,$71,$81,$7B,$C5,$71
                    .db $83,$BB,$00,$7C,$88,$BB,$81,$10
                    .db $81,$BB,$81,$7B,$89,$BB,$81,$71
                    .db $81,$BB,$01,$B0,$B1,$86,$BB,$02
                    .db $7C,$BB,$10,$81,$11,$01,$10,$BB
                    .db $81,$7B,$82,$BB,$00,$7C,$85,$BB
                    .db $81,$71,$03,$BB,$E0,$C0,$C1,$82
                    .db $BB,$81,$7B,$82,$BB,$01,$10,$11
                    .db $81,$5D,$01,$11,$10,$8B,$BB,$81
                    .db $71,$03,$BB,$E1,$D0,$D1,$82,$BB
                    .db $81,$7B,$82,$BB,$08,$3D,$4F,$5D
                    .db $68,$4F,$11,$10,$BB,$7C,$83,$BB
                    .db $81,$7B,$82,$BB,$81,$71,$8A,$BB
                    .db $00,$10,$82,$4F,$81,$6C,$01,$4F
                    .db $3D,$85,$BB,$81,$7B,$82,$BB,$81
                    .db $71,$82,$BB,$00,$10,$86,$03,$84
                    .db $4F,$81,$6C,$04,$11,$03,$04,$03
                    .db $04,$82,$03,$00,$10,$82,$BB,$81
                    .db $71,$81,$7B,$01,$BB,$3D,$81,$5D
                    .db $83,$6B,$81,$5D,$84,$4F,$02,$6C
                    .db $68,$5D,$83,$4F,$81,$5D,$00,$3D
                    .db $82,$BB,$81,$71,$81,$7B,$01,$BB
                    .db $3D,$81,$5D,$83,$6B,$81,$5D,$05
                    .db $4F,$12,$13,$14,$15,$4F,$81,$5D
                    .db $83,$4F,$02,$68,$5D,$3D,$82,$BB
                    .db $81,$71,$82,$BB,$00,$00,$87,$4F
                    .db $05,$58,$31,$32,$33,$34,$58,$84
                    .db $4F,$81,$6C,$01,$11,$00,$82,$BB
                    .db $81,$71,$04,$BB,$7C,$BB,$20,$50
                    .db $85,$4F,$07,$58,$4F,$35,$36,$37
                    .db $38,$4F,$58,$82,$4F,$81,$6C,$02
                    .db $11,$50,$20,$82,$BB,$81,$71,$82
                    .db $BB,$02,$20,$69,$00,$81,$4F,$81
                    .db $5D,$10,$4F,$58,$4F,$35,$36,$37
                    .db $38,$4F,$58,$4F,$5D,$68,$6C,$11
                    .db $00,$69,$20,$82,$BB,$81,$71,$02
                    .db $E8,$E9,$E8,$81,$20,$04,$69,$50
                    .db $4F,$68,$5D,$81,$4F,$05,$58,$49
                    .db $4A,$59,$5A,$58,$81,$4F,$81,$5D
                    .db $02,$4F,$3D,$69,$81,$20,$82,$E8
                    .db $81,$71,$82,$3F,$05,$20,$69,$20
                    .db $50,$4F,$68,$84,$4F,$81,$5D,$86
                    .db $4F,$03,$3D,$20,$69,$20,$82,$D8
                    .db $81,$71,$81,$3F,$04,$D8,$20,$69
                    .db $00,$11,$81,$6C,$84,$4F,$03,$5D
                    .db $68,$6D,$6E,$84,$4F,$03,$11,$00
                    .db $69,$20,$82,$3F,$81,$71,$05,$D8
                    .db $D9,$3F,$20,$50,$11,$81,$6C,$85
                    .db $4F,$81,$11,$00,$6E,$81,$6D,$00
                    .db $6E,$83,$4F,$02,$11,$50,$20,$82
                    .db $D9,$81,$71,$04,$3F,$D8,$D9,$00
                    .db $11,$81,$6C,$85,$4F,$05,$11,$00
                    .db $50,$43,$11,$6E,$81,$6D,$00,$6E
                    .db $83,$4F,$00,$00,$82,$3F,$81,$71
                    .db $81,$3F,$03,$10,$11,$5D,$68,$84
                    .db $4F,$09,$11,$43,$50,$69,$20,$69
                    .db $50,$11,$4F,$6E,$81,$6D,$00,$6E
                    .db $81,$5D,$01,$4F,$10,$81,$3F,$81
                    .db $71,$81,$3F,$01,$3D,$4F,$81,$5D
                    .db $81,$4F,$00,$11,$81,$43,$00,$00
                    .db $82,$69,$00,$20,$81,$69,$01,$00
                    .db $18,$81,$4F,$05,$6E,$6D,$68,$5D
                    .db $4F,$3D,$81,$3F,$81,$71,$02,$D9
                    .db $3F,$3D,$82,$4F,$02,$11,$43,$50
                    .db $82,$69,$00,$20,$81,$69,$08,$20
                    .db $69,$20,$69,$48,$47,$46,$45,$11
                    .db $82,$4F,$00,$00,$81,$3F,$81,$71
                    .db $03,$D8,$D9,$40,$42,$81,$43,$02
                    .db $50,$69,$20,$82,$69,$02,$20,$69
                    .db $20,$82,$69,$00,$20,$83,$69,$00
                    .db $00,$81,$43,$01,$50,$20,$81,$3F
                    .db $81,$71,$81,$3F,$02,$20,$69,$20
                    .db $81,$69,$00,$20,$83,$69,$00,$20
                    .db $81,$69,$02,$20,$69,$20,$84,$69
                    .db $04,$20,$69,$20,$69,$20,$81,$3F
                    .db $81,$71,$03,$4F,$3C,$4F,$3C,$81
                    .db $4F,$00,$3D,$96,$3F,$81,$75,$9B
                    .db $1C,$03,$58,$18,$1C,$58,$9B,$1C
                    .db $03,$58,$18,$1C,$58,$9A,$1C,$04
                    .db $10,$58,$18,$1C,$58,$94,$1C,$81
                    .db $10,$81,$50,$82,$10,$03,$50,$18
                    .db $14,$58,$90,$1C,$81,$5C,$84,$10
                    .db $00,$50,$82,$10,$03,$50,$10,$50
                    .db $90,$90,$1C,$00,$5C,$81,$10,$8B
                    .db $50,$89,$1C,$82,$10,$81,$50,$81
                    .db $1C,$00,$5C,$86,$10,$00,$50,$82
                    .db $10,$00,$50,$81,$D0,$89,$1C,$83
                    .db $10,$00,$50,$81,$1C,$00,$5C,$81
                    .db $10,$84,$90,$00,$D0,$82,$90,$02
                    .db $D0,$50,$18,$89,$1C,$00,$50,$81
                    .db $90,$81,$D0,$81,$1C,$01,$18,$50
                    .db $84,$90,$85,$10,$81,$50,$88,$1C
                    .db $01,$D4,$58,$82,$1C,$03,$18,$94
                    .db $1C,$18,$81,$58,$82,$5C,$00,$50
                    .db $82,$90,$84,$50,$88,$1C,$81,$54
                    .db $81,$1C,$82,$14,$01,$1C,$18,$81
                    .db $58,$81,$5C,$03,$18,$5C,$58,$18
                    .db $84,$90,$00,$D0,$89,$1C,$00,$54
                    .db $82,$14,$82,$1C,$00,$18,$81,$58
                    .db $82,$5C,$81,$58,$01,$5C,$58,$82
                    .db $5C,$01,$18,$14,$86,$1C,$81,$10
                    .db $87,$1C,$01,$58,$98,$83,$18,$81
                    .db $58,$00,$18,$83,$5C,$01,$18,$14
                    .db $86,$1C,$81,$10,$81,$50,$85,$10
                    .db $00,$58,$85,$98,$81,$18,$00,$58
                    .db $82,$5C,$01,$18,$14,$84,$1C,$84
                    .db $10,$81,$50,$06,$10,$50,$10,$50
                    .db $10,$58,$18,$83,$5C,$81,$98,$01
                    .db $18,$58,$82,$18,$01,$D8,$18,$84
                    .db $1C,$01,$10,$50,$81,$10,$02,$50
                    .db $10,$50,$81,$10,$05,$D0,$50,$D0
                    .db $58,$5C,$58,$83,$5C,$84,$98,$02
                    .db $D8,$18,$98,$84,$1C,$83,$10,$00
                    .db $50,$82,$10,$84,$50,$00,$18,$84
                    .db $5C,$00,$18,$82,$5C,$03,$18,$14
                    .db $58,$5C,$83,$1C,$85,$10,$00,$50
                    .db $81,$10,$81,$50,$00,$90,$82,$50
                    .db $00,$58,$84,$5C,$00,$58,$81,$5C
                    .db $03,$18,$14,$58,$5C,$82,$1C,$8A
                    .db $10,$83,$50,$84,$10,$01,$50,$18
                    .db $82,$5C,$03,$18,$14,$58,$5C,$82
                    .db $1C,$89,$10,$81,$50,$81,$90,$85
                    .db $10,$81,$50,$00,$58,$81,$5C,$03
                    .db $18,$14,$58,$5C,$82,$1C,$85,$10
                    .db $00,$50,$84,$10,$01,$50,$D0,$81
                    .db $10,$00,$50,$83,$10,$00,$50,$81
                    .db $10,$04,$50,$18,$14,$58,$5C,$82
                    .db $1C,$01,$50,$90,$81,$10,$01,$50
                    .db $10,$83,$18,$02,$10,$50,$D0,$82
                    .db $90,$00,$D0,$81,$90,$00,$10,$81
                    .db $50,$81,$10,$02,$50,$14,$58,$81
                    .db $14,$82,$1C,$00,$58,$81,$90,$03
                    .db $50,$90,$10,$D0,$82,$90,$04,$D0
                    .db $90,$10,$5C,$50,$81,$90,$02,$10
                    .db $D0,$10,$81,$50,$82,$10,$00,$50
                    .db $82,$58,$82,$1C,$00,$58,$82,$10
                    .db $02,$50,$10,$D0,$82,$90,$01,$10
                    .db $5C,$81,$14,$07,$54,$58,$18,$90
                    .db $10,$D0,$10,$50,$81,$18,$01,$10
                    .db $50,$82,$58,$82,$1C,$00,$D0,$82
                    .db $10,$00,$50,$81,$D0,$02,$58,$5C
                    .db $18,$82,$14,$01,$58,$54,$81,$14
                    .db $00,$54,$82,$10,$83,$18,$00,$10
                    .db $82,$50,$81,$1C,$84,$10,$81,$50
                    .db $84,$14,$85,$58,$81,$10,$01,$90
                    .db $10,$84,$18,$81,$10,$00,$90,$81
                    .db $1C,$84,$10,$82,$50,$87,$58,$01
                    .db $10,$50,$83,$10,$00,$D0,$82,$18
                    .db $02,$90,$D0,$10,$82,$1C,$83,$10
                    .db $03,$90,$D0,$10,$50,$86,$58,$01
                    .db $10,$50,$88,$10,$81,$D0,$01,$1C
                    .db $58,$81,$1C,$01,$50,$90,$82,$10
                    .db $03,$50,$D0,$10,$94,$84,$58,$83
                    .db $10,$00,$50,$83,$10,$01,$18,$10
                    .db $81,$D0,$01,$1C,$18,$82,$1C,$00
                    .db $58,$83,$10,$81,$50,$81,$14,$84
                    .db $58,$83,$10,$00,$D0,$84,$10,$81
                    .db $D0,$82,$1C,$00,$58,$81,$1C,$00
                    .db $58,$83,$10,$81,$50,$83,$58,$00
                    .db $10,$81,$50,$87,$10,$81,$D0,$00
                    .db $58,$82,$1C,$81,$14,$04,$1C,$D4
                    .db $58,$50,$90,$81,$10,$82,$50,$82
                    .db $58,$83,$10,$00,$18,$83,$10,$03
                    .db $18,$10,$D0,$18,$82,$1C,$81,$14
                    .db $01,$1C,$18,$9E,$1C,$00,$18,$9E
                    .db $1C,$01,$18,$50,$95,$1C,$83,$10
                    .db $83,$1C,$00,$10,$81,$50,$90,$1C
                    .db $87,$10,$83,$1C,$01,$90,$10,$81
                    .db $50,$8D,$1C,$89,$10,$01,$50,$5C
                    .db $81,$1C,$82,$90,$81,$50,$8B,$1C
                    .db $81,$10,$84,$50,$83,$10,$81,$50
                    .db $81,$1C,$81,$58,$02,$90,$10,$50
                    .db $8B,$1C,$82,$10,$84,$18,$00,$50
                    .db $82,$10,$00,$50,$81,$1C,$82,$58
                    .db $01,$10,$50,$8B,$1C,$01,$10,$90
                    .db $85,$18,$00,$58,$81,$50,$01,$D0
                    .db $10,$81,$1C,$81,$58,$02,$10,$D0
                    .db $10,$87,$1C,$83,$18,$00,$50,$81
                    .db $90,$84,$18,$01,$D0,$10,$81,$D0
                    .db $00,$18,$81,$1C,$01,$58,$10,$81
                    .db $D0,$01,$18,$58,$85,$1C,$84,$18
                    .db $00,$58,$87,$90,$81,$D0,$01,$5C
                    .db $18,$81,$1C,$05,$10,$90,$D0,$5C
                    .db $18,$58,$88,$18,$04,$58,$D8,$58
                    .db $5C,$58,$81,$1C,$85,$5C,$01,$58
                    .db $18,$81,$1C,$01,$58,$18,$81,$5C
                    .db $01,$18,$58,$86,$18,$81,$98,$00
                    .db $D8,$81,$58,$01,$18,$5C,$81,$1C
                    .db $84,$5C,$07,$18,$5C,$18,$50,$1C
                    .db $58,$5C,$58,$81,$18,$00,$58,$85
                    .db $1C,$82,$18,$01,$58,$18,$82,$58
                    .db $81,$1C,$85,$5C,$01,$58,$18,$81
                    .db $50,$00,$58,$82,$18,$01,$D8,$18
                    .db $83,$10,$81,$50,$81,$18,$00,$D8
                    .db $82,$18,$00,$58,$82,$18,$00,$58
                    .db $83,$5C,$04,$18,$5C,$18,$10,$50
                    .db $82,$18,$81,$D8,$01,$18,$D0,$83
                    .db $90,$04,$50,$58,$98,$18,$D8,$83
                    .db $18,$02,$98,$D8,$18,$84,$5C,$00
                    .db $58,$81,$10,$00,$50,$81,$98,$04
                    .db $18,$58,$5C,$18,$D0,$82,$5C,$81
                    .db $90,$00,$58,$87,$98,$01,$D8,$18
                    .db $83,$5C,$00,$18,$82,$10,$01,$50
                    .db $18,$81,$98,$02,$18,$5C,$18,$83
                    .db $14,$81,$54,$00,$58,$81,$5C,$00
                    .db $58,$84,$5C,$01,$58,$18,$82,$5C
                    .db $83,$10,$81,$50,$05,$5C,$58,$5C
                    .db $18,$5C,$18,$85,$1C,$02,$58,$5C
                    .db $18,$84,$5C,$02,$18,$5C,$18,$87
                    .db $10,$01,$50,$18,$81,$5C,$01,$18
                    .db $5C,$81,$14,$83,$58,$01,$D4,$58
                    .db $81,$5C,$00,$58,$84,$5C,$00,$58
                    .db $82,$10,$02,$50,$10,$50,$81,$10
                    .db $05,$D0,$10,$5C,$58,$5C,$18,$81
                    .db $14,$00,$18,$83,$58,$81,$54,$01
                    .db $5C,$18,$84,$5C,$00,$18,$81,$10
                    .db $05,$50,$10,$50,$10,$50,$10,$81
                    .db $50,$81,$18,$81,$5C,$01,$18,$94
                    .db $86,$58,$82,$54,$00,$58,$86,$10
                    .db $05,$50,$10,$50,$10,$50,$10,$81
                    .db $50,$03,$18,$14,$54,$5C,$81,$14
                    .db $01,$58,$18,$85,$58,$02,$18,$54
                    .db $14,$82,$10,$00,$50,$82,$10,$02
                    .db $50,$D0,$90,$81,$10,$82,$50,$02
                    .db $18,$58,$54,$81,$14,$81,$58,$84
                    .db $18,$83,$58,$83,$10,$02,$50,$10
                    .db $50,$81,$10,$07,$50,$10,$50,$10
                    .db $50,$10,$50,$14,$82,$58,$02,$10
                    .db $50,$58,$82,$18,$01,$10,$50,$82
                    .db $58,$82,$10,$00,$50,$81,$10,$81
                    .db $50,$02,$10,$50,$10,$81,$50,$04
                    .db $10,$50,$10,$50,$14,$82,$50,$81
                    .db $10,$00,$94,$81,$18,$81,$10,$01
                    .db $50,$10,$81,$50,$83,$10,$0D,$50
                    .db $10,$50,$10,$50,$10,$50,$10,$50
                    .db $10,$50,$10,$50,$1C,$82,$90,$00
                    .db $D0,$81,$14,$01,$18,$10,$83,$90
                    .db $82,$10,$01,$50,$10,$81,$50,$07
                    .db $10,$50,$10,$50,$10,$50,$10,$50
                    .db $81,$10,$82,$50,$81,$1C,$81,$18
                    .db $82,$14,$00,$58,$81,$1C,$00,$18
                    .db $81,$90,$81,$10,$00,$50,$81,$10
                    .db $00,$50,$81,$10,$0A,$50,$10,$50
                    .db $10,$50,$10,$50,$10,$50,$10,$50
                    .db $81,$1C,$81,$18,$82,$14,$00,$58
                    .db $82,$1C,$00,$58,$82,$90,$04,$10
                    .db $50,$10,$50,$10,$81,$50,$81,$10
                    .db $81,$50,$05,$10,$50,$10,$50,$10
                    .db $50,$81,$1C,$81,$18,$82,$14,$00
                    .db $58,$81,$1C,$00,$18,$82,$1C,$81
                    .db $10,$02,$50,$10,$50,$81,$10,$06
                    .db $50,$10,$50,$10,$50,$14,$10,$81
                    .db $50,$01,$D0,$10,$82,$1C,$81,$14
                    .db $02,$18,$D4,$58,$82,$1C,$00,$58
                    .db $81,$1C,$84,$10,$00,$50,$81,$10
                    .db $01,$50,$10,$81,$50,$02,$10,$50
                    .db $10,$81,$50,$02,$18,$14,$54,$81
                    .db $14,$01,$18,$58,$85,$54,$83,$10
                    .db $06,$50,$10,$50,$10,$50,$10,$50
                    .db $81,$10,$03,$50,$10,$50,$10,$81
                    .db $50,$00,$18,$87,$1C,$83,$50,$83
                    .db $10,$02,$50,$10,$50,$81,$10,$06
                    .db $50,$10,$50,$10,$50,$10,$50,$81
                    .db $10,$02,$50,$18,$1C,$81,$54,$00
                    .db $58,$82,$10,$01,$50,$10,$83,$50
                    .db $89,$10,$81,$D0,$02,$1C,$58,$1C
                    .db $81,$14,$83,$1C,$04,$54,$58,$50
                    .db $90,$D0,$86,$10,$81,$18,$00,$50
                    .db $84,$10,$81,$D0,$01,$58,$18,$82
                    .db $14,$85,$1C,$00,$D0,$81,$10,$01
                    .db $50,$D0,$82,$10,$02,$50,$10,$90
                    .db $81,$18,$00,$D0,$83,$10,$81,$D0
                    .db $01,$18,$1C,$81,$14,$86,$1C,$83
                    .db $10,$81,$50,$00,$D0,$81,$90,$00
                    .db $D0,$87,$10,$81,$D0,$81,$1C,$01
                    .db $58,$14,$81,$1C,$81,$14,$83,$1C
                    .db $01,$50,$90,$81,$10,$00,$D0,$83
                    .db $10,$00,$50,$84,$10,$01,$D0,$90
                    .db $81,$D0,$81,$1C,$00,$18,$87,$14
                    .db $81,$1C,$00,$58,$82,$90,$01,$D0
                    .db $18,$82,$10,$00,$50,$83,$10,$81
                    .db $D0,$00,$58,$83,$1C,$81,$14,$00
                    .db $1C,$81,$14,$81,$58,$81,$14,$81
                    .db $1C,$05,$58,$1C,$18,$58,$1C,$18
                    .db $86,$90,$81,$D0,$02,$1C,$58,$5C
                    .db $81,$1C,$83,$14,$85,$58,$81,$1C
                    .db $04,$58,$1C,$18,$58,$1C,$81,$18
                    .db $00,$58,$84,$1C,$00,$58,$81,$1C
                    .db $00,$58,$81,$1C,$81,$14,$00,$1C
                    .db $81,$14,$85,$58,$81,$1C,$07,$58
                    .db $1C,$18,$58,$1C,$18,$1C,$58,$83
                    .db $1C,$01,$18,$5C,$81,$1C,$00,$58
                    .db $84,$14,$87,$58,$81,$1C,$04,$58
                    .db $1C,$18,$58,$1C,$81,$18,$01,$1C
                    .db $5C,$83,$1C,$01,$58,$1C,$82,$14
                    .db $81,$1C,$81,$14,$87,$58,$81,$1C
                    .db $07,$58,$1C,$18,$58,$1C,$18,$54
                    .db $58,$83,$1C,$00,$18,$82,$14,$83
                    .db $1C,$81,$14,$87,$58,$81,$1C,$06
                    .db $58,$1C,$18,$58,$1C,$18,$54,$86
                    .db $14,$85,$1C,$81,$14,$87,$58,$81
                    .db $1C,$05,$58,$1C,$18,$58,$1C,$18
                    .db $84,$10,$81,$50,$87,$1C,$81,$14
                    .db $86,$58,$02,$1C,$10,$58,$81,$10
                    .db $81,$50,$00,$18,$86,$10,$00,$50
                    .db $86,$1C,$83,$14,$83,$58,$03,$14
                    .db $1C,$10,$50,$81,$10,$81,$50,$87
                    .db $10,$00,$50,$88,$1C,$81,$14,$00
                    .db $58,$81,$14,$09,$58,$14,$1C,$10
                    .db $D0,$58,$18,$58,$18,$90,$86,$10
                    .db $00,$50,$8B,$1C,$81,$14,$82,$1C
                    .db $00,$10,$81,$50,$01,$18,$58,$88
                    .db $10,$00,$50,$90,$1C,$81,$10,$00
                    .db $50,$8A,$10,$00,$50,$83,$1C,$01
                    .db $18,$58,$8A,$1C,$00,$50,$82,$90
                    .db $86,$10,$00,$D0,$81,$90,$00,$10
                    .db $83,$1C,$00,$18,$81,$58,$83,$1C
                    .db $81,$18,$00,$58,$82,$1C,$81,$58
                    .db $00,$1C,$87,$10,$00,$50,$81,$1C
                    .db $00,$18,$83,$1C,$81,$98,$81,$58
                    .db $81,$1C,$85,$18,$00,$1C,$81,$58
                    .db $01,$1C,$50,$86,$90,$00,$10,$81
                    .db $1C,$00,$18,$83,$1C,$00,$58,$8A
                    .db $18,$00,$D4,$81,$58,$00,$1C,$81
                    .db $58,$84,$1C,$81,$18,$81,$1C,$01
                    .db $18,$94,$82,$1C,$8B,$18,$81,$54
                    .db $01,$58,$1C,$81,$58,$84,$1C,$81
                    .db $18,$81,$1C,$81,$14,$81,$1C,$8C
                    .db $18,$01,$1C,$54,$81,$14,$81,$58
                    .db $84,$1C,$81,$18,$82,$14,$82,$1C
                    .db $81,$98,$8A,$18,$82,$1C,$81,$54
                    .db $00,$58,$84,$1C,$00,$18,$81,$14
                    .db $84,$1C,$00,$58,$8B,$18,$83,$1C
                    .db $00,$54,$87,$14,$85,$1C,$8C,$18
                    .db $92,$1C,$81,$98,$8A,$18,$8D,$1C
                    .db $81,$14,$00,$1C,$81,$14,$00,$58
                    .db $81,$98,$89,$18,$8D,$1C,$84,$14
                    .db $81,$58,$81,$98,$81,$18,$00,$D8
                    .db $81,$98,$00,$D8,$82,$98,$8C,$1C
                    .db $84,$14,$83,$58,$82,$98,$03,$D8
                    .db $1C,$18,$58,$81,$1C,$00,$18,$89
                    .db $1C,$81,$14,$00,$1C,$85,$14,$83
                    .db $58,$81,$1C,$03,$18,$1C,$98,$D8
                    .db $81,$1C,$00,$98,$89,$1C,$81,$14
                    .db $84,$1C,$82,$14,$82,$58,$81,$1C
                    .db $03,$18,$1C,$58,$18,$81,$1C,$00
                    .db $58,$86,$1C,$83,$10,$83,$50,$86
                    .db $10,$82,$50,$82,$10,$03,$50,$10
                    .db $50,$14,$86,$1C,$83,$10,$83,$18
                    .db $84,$90,$06,$10,$50,$10,$50,$10
                    .db $50,$10,$81,$50,$02,$D0,$10,$14
                    .db $86,$1C,$83,$10,$00,$90,$81,$18
                    .db $07,$D0,$10,$50,$10,$50,$10,$50
                    .db $10,$81,$50,$03,$10,$50,$10,$50
                    .db $81,$D0,$00,$18,$87,$1C,$82,$10
                    .db $82,$90,$82,$10,$0A,$50,$10,$50
                    .db $10,$50,$10,$50,$10,$50,$90,$10
                    .db $81,$50,$01,$1C,$18,$87,$1C,$07
                    .db $10,$50,$14,$54,$58,$18,$90,$10
                    .db $83,$50,$83,$10,$02,$50,$90,$10
                    .db $82,$50,$02,$1C,$18,$94,$86,$1C
                    .db $03,$50,$90,$50,$54,$81,$14,$01
                    .db $54,$10,$83,$18,$84,$90,$00,$10
                    .db $81,$50,$02,$D0,$10,$1C,$83,$14
                    .db $84,$1C,$00,$58,$81,$90,$00,$50
                    .db $81,$58,$02,$54,$10,$90,$81,$18
                    .db $00,$D0,$81,$10,$07,$50,$10,$50
                    .db $10,$50,$10,$D0,$18,$81,$14,$00
                    .db $1C,$81,$14,$84,$1C,$01,$58,$1C
                    .db $81,$90,$81,$50,$83,$10,$00,$50
                    .db $81,$10,$01,$50,$10,$81,$50,$81
                    .db $10,$81,$D0,$01,$18,$14,$81,$1C
                    .db $81,$58,$81,$14,$81,$1C,$01,$D4
                    .db $58,$81,$1C,$81,$90,$00,$50,$83
                    .db $10,$00,$50,$81,$10,$03,$50,$10
                    .db $50,$10,$82,$D0,$02,$58,$18,$94
                    .db $81,$1C,$81,$58,$81,$14,$81,$1C
                    .db $81,$54,$82,$1C,$8B,$90,$81,$D0
                    .db $02,$1C,$18,$1C,$81,$14,$81,$1C
                    .db $81,$58,$81,$14,$82,$1C,$81,$54
                    .db $83,$1C,$00,$58,$87,$1C,$00,$18
                    .db $82,$1C,$00,$18,$81,$14,$82,$1C
                    .db $81,$58,$81,$14,$83,$1C,$84,$18
                    .db $01,$58,$1C,$82,$10,$00,$50,$83
                    .db $1C,$00,$58,$81,$1C,$01,$18,$14
                    .db $83,$1C,$00,$58,$81,$14,$84,$1C
                    .db $84,$18,$01,$58,$1C,$81,$10,$81
                    .db $50,$82,$1C,$00,$18,$82,$1C,$81
                    .db $14,$83,$1C,$82,$14,$84,$1C,$83
                    .db $18,$02,$98,$D8,$1C,$81,$90,$01
                    .db $D0,$50,$81,$1C,$81,$18,$00,$58
                    .db $81,$14,$81,$10,$00,$50,$82,$1C
                    .db $00,$14,$81,$1C,$81,$18,$00,$58
                    .db $81,$1C,$81,$98,$82,$18,$02,$58
                    .db $14,$50,$81,$90,$00,$10,$81,$14
                    .db $07,$58,$98,$18,$14,$1C,$50,$90
                    .db $10,$85,$1C,$81,$18,$01,$58,$18
                    .db $81,$58,$82,$18,$81,$D8,$00,$1C
                    .db $81,$58,$81,$18,$81,$1C,$81,$58
                    .db $00,$18,$81,$1C,$02,$58,$1C,$18
                    .db $85,$1C,$88,$18,$02,$58,$18,$1C
                    .db $81,$58,$81,$18,$81,$1C,$81,$58
                    .db $00,$18,$81,$1C,$02,$58,$1C,$18
                    .db $82,$1C,$8B,$18,$02,$58,$18,$D4
                    .db $81,$58,$81,$18,$01,$94,$1C,$81
                    .db $58,$06,$18,$1C,$D4,$58,$1C,$18
                    .db $94,$81,$1C,$8B,$18,$01,$58,$18
                    .db $81,$54,$01,$58,$18,$81,$14,$00
                    .db $D4,$81,$58,$01,$18,$94,$81,$54
                    .db $00,$1C,$81,$14,$81,$1C,$8B,$18
                    .db $81,$58,$01,$1C,$54,$82,$14,$00
                    .db $1C,$81,$54,$00,$58,$81,$14,$01
                    .db $1C,$54,$81,$14,$82,$1C,$8C,$18
                    .db $00,$58,$81,$18,$00,$58,$83,$1C
                    .db $00,$54,$81,$14,$87,$1C,$8F,$18
                    .db $81,$58,$8D,$1C,$90,$18,$02,$58
                    .db $18,$58,$8B,$1C,$91,$18,$81,$D8
                    .db $81,$1C,$81,$14,$87,$1C,$91,$18
                    .db $02,$58,$18,$1C,$82,$14,$87,$1C
                    .db $91,$18,$81,$58,$00,$1C,$81,$14
                    .db $88,$1C,$91,$18,$81,$D8,$8B,$1C
                    .db $88,$18,$00,$D8,$84,$98,$81,$18
                    .db $81,$D8,$00,$18,$81,$14,$82,$1C
                    .db $81,$14,$84,$1C,$88,$18,$00,$58
                    .db $83,$1C,$81,$98,$81,$D8,$81,$18
                    .db $86,$14,$84,$1C,$81,$18,$82,$98
                    .db $00,$D8,$81,$98,$01,$18,$58,$83
                    .db $1C,$02,$58,$98,$D8,$82,$18,$00
                    .db $58,$83,$14,$86,$1C,$01,$98,$D8
                    .db $81,$1C,$02,$98,$D8,$1C,$81,$18
                    .db $00,$58,$83,$1C,$81,$58,$83,$18
                    .db $83,$14,$88,$1C,$00,$18,$81,$1C
                    .db $02,$58,$18,$1C,$81,$98,$00,$D8
                    .db $83,$1C,$81,$58,$82,$18,$82,$14
                    .db $89,$1C,$83,$14,$00,$50,$83,$10
                    .db $82,$50,$81,$10,$00,$14,$81,$18
                    .db $8C,$14,$81,$10,$83,$14,$00,$50
                    .db $83,$10,$82,$50,$82,$10,$81,$18
                    .db $85,$10,$81,$18,$84,$14,$81,$10
                    .db $81,$14,$81,$18,$00,$50,$83,$10
                    .db $82,$50,$82,$10,$81,$18,$81,$10
                    .db $01,$50,$10,$83,$18,$84,$14,$81
                    .db $10,$81,$14,$81,$18,$00,$50,$83
                    .db $10,$83,$50,$81,$10,$81,$18,$81
                    .db $10,$01,$50,$10,$83,$18,$84,$14
                    .db $81,$10,$81,$14,$81,$18,$00,$50
                    .db $83,$10,$81,$50,$03,$10,$50,$10
                    .db $90,$82,$18,$01,$10,$50,$82,$10
                    .db $82,$18,$83,$14,$81,$10,$01,$14
                    .db $10,$81,$18,$00,$50,$81,$10,$81
                    .db $90,$81,$D0,$81,$50,$81,$10,$82
                    .db $18,$85,$10,$81,$18,$00,$50,$82
                    .db $14,$81,$10,$01,$14,$10,$81,$18
                    .db $81,$50,$82,$10,$82,$50,$82,$10
                    .db $82,$18,$00,$10,$81,$50,$01,$10
                    .db $D0,$82,$10,$00,$50,$82,$14,$81
                    .db $10,$02,$14,$50,$90,$81,$10,$81
                    .db $50,$81,$10,$81,$50,$81,$10,$85
                    .db $18,$82,$50,$01,$10,$50,$81,$10
                    .db $00,$50,$82,$14,$81,$10,$02,$14
                    .db $54,$10,$81,$18,$01,$D0,$50,$81
                    .db $10,$81,$50,$01,$10,$90,$86,$18
                    .db $81,$50,$04,$10,$50,$10,$D0,$10
                    .db $82,$14,$81,$10,$02,$14,$54,$10
                    .db $81,$18,$81,$50,$81,$10,$81,$50
                    .db $81,$10,$85,$18,$82,$10,$00,$90
                    .db $82,$D0,$83,$14,$81,$10,$01,$D4
                    .db $54,$83,$10,$00,$50,$81,$10,$01
                    .db $50,$10,$87,$18,$83,$10,$82,$50
                    .db $83,$14,$81,$10,$81,$54,$82,$10
                    .db $00,$50,$81,$10,$02,$50,$90,$10
                    .db $81,$18,$00,$10,$83,$18,$81,$10
                    .db $07,$18,$10,$50,$90,$10,$50,$14
                    .db $94,$81,$14,$81,$10,$08,$14,$54
                    .db $10,$50,$10,$90,$10,$50,$90,$81
                    .db $10,$84,$50,$81,$18,$07,$10,$50
                    .db $10,$50,$90,$10,$18,$50,$83,$14
                    .db $81,$10,$81,$14,$81,$10,$04,$90
                    .db $50,$10,$50,$90,$85,$10,$00,$50
                    .db $81,$18,$01,$90,$D0,$81,$90,$03
                    .db $10,$18,$10,$50,$83,$14,$81,$D0
                    .db $81,$14,$83,$90,$01,$50,$90,$81
                    .db $18,$00,$50,$84,$10,$81,$18,$01
                    .db $10,$50,$81,$10,$81,$90,$81,$D0
                    .db $83,$14,$81,$50,$81,$14,$00,$54
                    .db $81,$14,$81,$10,$00,$50,$81,$18
                    .db $00,$50,$82,$10,$01,$50,$10,$81
                    .db $18,$03,$10,$50,$18,$50,$87,$14
                    .db $81,$50,$81,$14,$00,$54,$81,$14
                    .db $81,$10,$05,$50,$10,$50,$90,$D0
                    .db $90,$82,$D0,$05,$10,$50,$10,$50
                    .db $10,$50,$87,$14,$81,$50,$02,$14
                    .db $D4,$54,$81,$14,$02,$10,$90,$D0
                    .db $81,$90,$85,$10,$81,$D0,$03,$90
                    .db $D0,$10,$50,$83,$14,$00,$94,$82
                    .db $14,$81,$50,$00,$14,$82,$54,$01
                    .db $14,$50,$8E,$90,$00,$10,$87,$14
                    .db $81,$50,$82,$14,$01,$54,$14,$81
                    .db $50,$8E,$10,$87,$14,$81,$50,$84
                    .db $14,$81,$50,$8E,$10,$87,$14,$81
                    .db $50,$00,$10,$81,$50,$86,$10,$00
                    .db $50,$88,$10,$00,$50,$83,$10,$00
                    .db $50,$81,$10,$81,$50,$8B,$10,$00
                    .db $50,$83,$10,$00,$D0,$86,$10,$00
                    .db $50,$82,$10,$82,$50,$84,$10,$01
                    .db $50,$90,$83,$10,$04,$D0,$10,$50
                    .db $10,$50,$87,$10,$83,$50,$81,$10
                    .db $81,$50,$84,$10,$00,$50,$83,$90
                    .db $81,$D0,$01,$10,$50,$84,$10,$00
                    .db $50,$85,$10,$81,$50,$81,$10,$81
                    .db $50,$82,$10,$01,$D0,$10,$81,$50
                    .db $82,$10,$00,$50,$81,$10,$00,$50
                    .db $83,$10,$01,$90,$D0,$83,$90,$00
                    .db $D0,$81,$10,$84,$50,$83,$10,$82
                    .db $50,$82,$10,$00,$50,$81,$10,$00
                    .db $50,$81,$18,$88,$10,$02,$D0,$90
                    .db $10,$83,$50,$84,$10,$82,$50,$85
                    .db $10,$81,$18,$86,$90,$83,$10,$01
                    .db $50,$10,$82,$50,$86,$10,$00,$50
                    .db $82,$10,$00,$D0,$81,$10,$02,$18
                    .db $D8,$50,$84,$10,$82,$90,$81,$10
                    .db $01,$50,$10,$82,$50,$85,$10,$00
                    .db $D0,$82,$90,$81,$D0,$81,$10,$81
                    .db $D8,$00,$50,$86,$10,$82,$90,$02
                    .db $D0,$10,$50,$86,$10,$00,$D0,$87
                    .db $10,$02,$58,$14,$50,$84,$10,$02
                    .db $50,$10,$50,$81,$10,$00,$50,$87
                    .db $10,$81,$D0,$85,$10,$03,$50,$D8
                    .db $58,$14,$81,$54,$88,$10,$00,$50
                    .db $8B,$10,$00,$50,$96,$10,$81,$14
                    .db $85,$10,$81,$50,$95,$10,$81,$14
                    .db $01,$10,$50,$84,$10,$00,$50,$95
                    .db $10,$81,$14,$01,$90,$D0,$81,$90
                    .db $82,$10,$00,$50,$91,$10,$81,$50
                    .db $81,$10,$81,$14,$01,$10,$50,$81
                    .db $10,$83,$D0,$92,$10,$00,$50,$81
                    .db $10,$81,$14,$01,$10,$50,$81,$10
                    .db $00,$D0,$81,$50,$00,$10,$8E,$18
                    .db $86,$10,$81,$14,$82,$10,$81,$D0
                    .db $81,$50,$00,$10,$8E,$18,$01,$50
                    .db $90,$84,$10,$81,$14,$81,$10,$81
                    .db $D0,$81,$10,$01,$50,$10,$8E,$18
                    .db $00,$50,$82,$90,$82,$10,$81,$14
                    .db $81,$10,$81,$50,$81,$10,$01,$50
                    .db $10,$86,$18,$00,$58,$84,$18,$01
                    .db $D8,$98,$82,$50,$00,$90,$82,$D0
                    .db $81,$14,$81,$10,$81,$50,$81,$10
                    .db $01,$50,$10,$86,$18,$00,$58,$83
                    .db $18,$81,$D8,$87,$50,$81,$14,$81
                    .db $10,$81,$50,$81,$10,$03,$50,$10
                    .db $18,$58,$84,$18,$00,$58,$82,$18
                    .db $81,$58,$81,$14,$86,$50,$81,$14
                    .db $82,$10,$00,$50,$81,$10,$03,$50
                    .db $10,$98,$D8,$83,$98,$85,$18,$01
                    .db $58,$14,$81,$54,$85,$50,$81,$14
                    .db $81,$10,$01,$D0,$10,$81,$50,$82
                    .db $18,$00,$58,$83,$18,$01,$98,$D8
                    .db $81,$18,$01,$98,$D8,$81,$58,$81
                    .db $18,$81,$58,$83,$50,$81,$14,$82
                    .db $D0,$00,$10,$84,$18,$00,$58,$8A
                    .db $18,$00,$58,$83,$18,$00,$58,$82
                    .db $50,$81,$14,$82,$50,$00,$10,$84
                    .db $18,$00,$58,$84,$18,$00,$58,$82
                    .db $18,$00,$58,$82,$18,$00,$58,$85
                    .db $18,$81,$14,$03,$50,$10,$50,$10
                    .db $81,$98,$81,$18,$01,$98,$D8,$83
                    .db $98,$81,$18,$82,$98,$00,$D8,$82
                    .db $98,$00,$D8,$81,$98,$00,$D8,$82
                    .db $18,$81,$14,$04,$50,$10,$50,$10
                    .db $50,$81,$98,$86,$18,$01,$98,$D8
                    .db $8A,$18,$81,$D8,$00,$18,$81,$14
                    .db $82,$50,$02,$10,$14,$54,$82,$98
                    .db $01,$10,$50,$86,$18,$01,$10,$50
                    .db $81,$18,$04,$10,$50,$18,$10,$50
                    .db $82,$18,$81,$14,$04,$50,$10,$50
                    .db $10,$18,$81,$54,$00,$50,$81,$10
                    .db $81,$50,$81,$18,$84,$10,$00,$50
                    .db $82,$10,$00,$50,$81,$10,$00,$50
                    .db $82,$18,$81,$14,$82,$50,$03,$10
                    .db $94,$18,$54,$83,$10,$00,$50,$8D
                    .db $10,$00,$50,$82,$10,$81,$14,$02
                    .db $50,$10,$50,$81,$14,$00,$18,$97
                    .db $10,$81,$14,$9D,$10,$81,$50,$9D
                    .db $10,$81,$50,$9D,$10,$81,$50,$9D
                    .db $10,$81,$50,$9D,$10,$81,$50,$82
                    .db $10,$00,$14,$81,$10,$81,$14,$81
                    .db $10,$82,$14,$81,$10,$00,$14,$81
                    .db $10,$00,$14,$81,$10,$00,$14,$81
                    .db $10,$00,$14,$88,$10,$08,$14,$10
                    .db $14,$10,$14,$10,$14,$10,$14,$82
                    .db $10,$0A,$14,$10,$14,$10,$14,$10
                    .db $14,$10,$14,$10,$14,$88,$10,$00
                    .db $14,$82,$10,$04,$14,$10,$14,$10
                    .db $14,$82,$10,$00,$14,$82,$10,$06
                    .db $14,$10,$14,$10,$14,$10,$14,$89
                    .db $10,$00,$14,$81,$10,$03,$14,$10
                    .db $14,$10,$82,$14,$01,$10,$14,$82
                    .db $10,$01,$14,$10,$82,$14,$01,$10
                    .db $14,$8A,$10,$01,$14,$10,$81,$14
                    .db $81,$10,$00,$14,$82,$10,$00,$14
                    .db $82,$10,$06,$14,$10,$14,$10,$14
                    .db $10,$14,$88,$10,$04,$14,$10,$14
                    .db $10,$14,$82,$10,$00,$14,$82,$10
                    .db $0A,$14,$10,$14,$10,$14,$10,$14
                    .db $10,$14,$10,$14,$86,$10,$81,$90
                    .db $87,$10,$82,$18,$81,$58,$00,$54
                    .db $83,$14,$81,$54,$00,$50,$81,$10
                    .db $00,$50,$88,$10,$00,$50,$83,$10
                    .db $85,$18,$00,$58,$85,$18,$81,$54
                    .db $02,$10,$90,$D0,$87,$10,$81,$50
                    .db $8A,$18,$00,$94,$85,$18,$82,$10
                    .db $00,$50,$87,$10,$81,$50,$88,$18
                    .db $00,$58,$81,$14,$85,$18,$82,$10
                    .db $00,$50,$88,$10,$81,$50,$85,$18
                    .db $03,$58,$18,$58,$14,$86,$18,$82
                    .db $10,$00,$50,$89,$10,$81,$50,$83
                    .db $18,$03,$98,$D8,$98,$58,$87,$18
                    .db $83,$10,$00,$50,$89,$10,$03,$50
                    .db $18,$10,$50,$81,$18,$01,$58,$18
                    .db $81,$58,$86,$18,$01,$10,$90,$81
                    .db $10,$00,$D0,$89,$10,$00,$50,$81
                    .db $10,$81,$50,$05,$18,$58,$18,$10
                    .db $50,$58,$81,$18,$85,$10,$01,$50
                    .db $90,$8E,$10,$00,$50,$83,$10,$00
                    .db $50,$87,$10,$01,$50,$90,$9B,$10
                    .db $82,$90,$87,$10,$81,$1C,$00,$5C
                    .db $81,$1C,$81,$5C,$81,$1C,$81,$5C
                    .db $00,$10,$81,$1C,$81,$5C,$01,$10
                    .db $50,$81,$1C,$81,$5C,$81,$1C,$81
                    .db $5C,$01,$10,$50,$81,$10,$81,$1C
                    .db $82,$10,$81,$1C,$81,$5C,$81,$1C
                    .db $81,$5C,$00,$10,$81,$1C,$81,$5C
                    .db $01,$10,$50,$81,$1C,$81,$5C,$81
                    .db $1C,$81,$5C,$01,$10,$50,$81,$10
                    .db $83,$1C,$81,$5C,$00,$1C,$81,$5C
                    .db $81,$1C,$81,$5C,$00,$10,$81,$1C
                    .db $81,$5C,$01,$10,$50,$81,$1C,$81
                    .db $5C,$81,$1C,$00,$5C,$81,$1C,$81
                    .db $5C,$00,$10,$83,$1C,$81,$5C,$84
                    .db $10,$00,$50,$86,$10,$00,$50,$81
                    .db $1C,$81,$5C,$82,$10,$81,$1C,$81
                    .db $5C,$00,$10,$83,$1C,$81,$5C,$81
                    .db $1C,$81,$5C,$01,$10,$50,$82,$10
                    .db $06,$50,$10,$50,$10,$50,$10,$50
                    .db $81,$10,$81,$1C,$81,$5C,$03,$1C
                    .db $5C,$1C,$10,$83,$1C,$81,$5C,$81
                    .db $1C,$81,$5C,$84,$10,$08,$50,$10
                    .db $50,$90,$D0,$10,$50,$10,$50,$81
                    .db $1C,$81,$5C,$83,$10,$83,$1C,$81
                    .db $5C,$81,$1C,$81,$5C,$82,$10,$02
                    .db $50,$10,$50,$86,$10,$00,$50,$81
                    .db $1C,$81,$5C,$81,$1C,$01,$5C,$10
                    .db $83,$1C,$81,$5C,$81,$1C,$81,$5C
                    .db $82,$10,$02,$50,$10,$50,$81,$1C
                    .db $81,$5C,$03,$10,$50,$10,$50,$81
                    .db $1C,$81,$5C,$81,$1C,$01,$5C,$10
                    .db $83,$1C,$81,$5C,$81,$1C,$81,$5C
                    .db $82,$10,$02,$50,$10,$50,$81,$1C
                    .db $81,$5C,$03,$10,$50,$10,$50,$81
                    .db $1C,$81,$5C,$81,$1C,$01,$5C,$10
                    .db $83,$1C,$81,$5C,$81,$1C,$81,$5C
                    .db $82,$10,$02,$50,$10,$50,$81,$1C
                    .db $81,$5C,$83,$10,$81,$1C,$81,$5C
                    .db $83,$10,$83,$1C,$00,$5C,$81,$1C
                    .db $81,$5C,$81,$10,$00,$50,$82,$10
                    .db $02,$50,$10,$50,$81,$10,$09,$50
                    .db $10,$14,$54,$10,$50,$10,$50,$10
                    .db $50,$81,$10,$81,$1C,$82,$10,$81
                    .db $1C,$81,$5C,$81,$10,$00,$50,$82
                    .db $10,$02,$50,$10,$50,$81,$10,$09
                    .db $50,$10,$94,$D4,$10,$50,$10,$50
                    .db $10,$50,$81,$10,$81,$18,$81,$1C
                    .db $81,$5C,$00,$1C,$81,$5C,$83,$10
                    .db $00,$50,$83,$10,$00,$50,$81,$10
                    .db $00,$50,$82,$10,$00,$50,$81,$1C
                    .db $81,$5C,$83,$10,$81,$1C,$81,$5C
                    .db $01,$10,$50,$84,$10,$00,$50,$81
                    .db $10,$02,$50,$10,$50,$81,$10,$00
                    .db $50,$82,$10,$00,$50,$81,$1C,$81
                    .db $5C,$83,$10,$81,$1C,$81,$5C,$05
                    .db $10,$50,$10,$50,$10,$50,$83,$10
                    .db $00,$50,$81,$10,$00,$50,$81,$10
                    .db $00,$50,$81,$1C,$81,$5C,$00,$1C
                    .db $81,$5C,$81,$10,$81,$18,$01,$10
                    .db $50,$81,$1C,$81,$5C,$03,$10,$50
                    .db $10,$50,$81,$1C,$81,$5C,$82,$10
                    .db $00,$50,$81,$10,$00,$50,$81,$1C
                    .db $81,$5C,$81,$10,$00,$50,$84,$10
                    .db $00,$50,$81,$1C,$81,$5C,$03,$10
                    .db $50,$10,$50,$81,$1C,$81,$5C,$03
                    .db $10,$50,$10,$50,$81,$1C,$81,$5C
                    .db $00,$1C,$81,$5C,$81,$10,$00,$50
                    .db $85,$10,$81,$1C,$81,$5C,$03,$10
                    .db $50,$10,$50,$81,$1C,$81,$5C,$03
                    .db $10,$50,$10,$50,$81,$1C,$81,$5C
                    .db $01,$10,$50,$81,$1C,$81,$5C,$85
                    .db $10,$00,$50,$82,$10,$02,$50,$10
                    .db $50,$81,$10,$00,$50,$81,$1C,$81
                    .db $5C,$81,$10,$81,$1C,$81,$5C,$01
                    .db $10,$50,$81,$1C,$81,$5C,$81,$10
                    .db $81,$18,$81,$10,$00,$50,$82,$10
                    .db $02,$50,$10,$50,$81,$10,$00,$50
                    .db $81,$1C,$81,$5C,$01,$10,$50,$81
                    .db $1C,$81,$5C,$01,$10,$50,$81,$1C
                    .db $81,$5C,$81,$10,$81,$18,$00,$10
                    .db $81,$1C,$81,$5C,$81,$10,$81,$1C
                    .db $81,$5C,$00,$10,$81,$1C,$81,$5C
                    .db $01,$10,$50,$81,$1C,$81,$5C,$01
                    .db $10,$50,$87,$10,$83,$14,$00,$50
                    .db $83,$10,$82,$50,$81,$10,$8F,$14
                    .db $84,$10,$00,$14,$81,$10,$00,$14
                    .db $82,$10,$82,$14,$81,$10,$00,$14
                    .db $81,$10,$05,$14,$10,$14,$10,$14
                    .db $10,$82,$14,$82,$10,$81,$90,$A5
                    .db $10,$01,$54,$14,$83,$10,$01,$54
                    .db $14,$83,$10,$01,$54,$14,$83,$10
                    .db $01,$54,$14,$8B,$10,$01,$D4,$94
                    .db $83,$10,$01,$D4,$94,$83,$10,$01
                    .db $D4,$94,$83,$10,$01,$D4,$94,$C8
                    .db $10,$82,$50,$01,$10,$50,$83,$10
                    .db $01,$54,$14,$83,$10,$01,$54,$14
                    .db $83,$10,$01,$54,$14,$87,$10,$00
                    .db $90,$82,$D0,$01,$90,$D0,$83,$10
                    .db $01,$D4,$94,$83,$10,$01,$D4,$94
                    .db $83,$10,$01,$D4,$94,$C5,$10,$83
                    .db $1C,$00,$14,$88,$1C,$01,$18,$58
                    .db $81,$1C,$01,$54,$14,$89,$1C,$81
                    .db $10,$81,$1C,$81,$14,$86,$1C,$08
                    .db $14,$1C,$18,$10,$50,$58,$1C,$D4
                    .db $94,$82,$1C,$00,$14,$85,$1C,$81
                    .db $10,$00,$1C,$82,$14,$82,$1C,$01
                    .db $54,$14,$82,$1C,$00,$18,$81,$10
                    .db $81,$50,$00,$58,$8B,$1C,$81,$10
                    .db $00,$1C,$82,$14,$82,$1C,$01,$D4
                    .db $94,$82,$1C,$81,$10,$00,$90,$81
                    .db $10,$03,$50,$58,$1C,$14,$83,$1C
                    .db $01,$54,$14,$82,$1C,$81,$10,$8A
                    .db $1C,$00,$18,$82,$10,$00,$D0,$81
                    .db $10,$00,$50,$85,$1C,$01,$D4,$94
                    .db $82,$1C,$81,$10,$82,$1C,$87,$18
                    .db $84,$10,$02,$D0,$10,$50,$86,$18
                    .db $00,$58,$82,$1C,$81,$10,$02,$54
                    .db $14,$1C,$81,$10,$00,$50,$84,$10
                    .db $00,$50,$84,$10,$02,$D0,$10,$50
                    .db $84,$10,$81,$50,$82,$1C,$81,$10
                    .db $05,$D4,$94,$1C,$10,$90,$D0,$84
                    .db $90,$00,$D0,$85,$10,$01,$90,$D0
                    .db $84,$10,$01,$D0,$50,$82,$1C,$81
                    .db $10,$82,$1C,$00,$50,$87,$10,$00
                    .db $18,$83,$10,$00,$18,$84,$10,$02
                    .db $50,$90,$D0,$83,$1C,$81,$10,$04
                    .db $1C,$14,$1C,$50,$90,$85,$10,$00
                    .db $18,$85,$10,$00,$18,$82,$10,$03
                    .db $50,$90,$D0,$DC,$83,$1C,$81,$10
                    .db $82,$1C,$02,$50,$10,$50,$82,$10
                    .db $02,$50,$10,$18,$85,$10,$00,$18
                    .db $82,$10,$01,$90,$D0,$85,$1C,$81
                    .db $10,$82,$18,$00,$50,$81,$10,$00
                    .db $90,$81,$10,$00,$D0,$81,$10,$00
                    .db $18,$83,$10,$00,$18,$81,$10,$06
                    .db $90,$D0,$10,$5C,$1C,$5C,$1C,$82
                    .db $18,$84,$10,$02,$50,$10,$50,$88
                    .db $10,$00,$50,$83,$10,$00,$50,$81
                    .db $10,$00,$5C,$82,$1C,$82,$18,$83
                    .db $10,$06,$18,$50,$10,$D0,$10,$50
                    .db $90,$84,$10,$00,$90,$84,$10,$00
                    .db $50,$81,$10,$01,$50,$9C,$81,$1C
                    .db $84,$10,$81,$18,$01,$10,$50,$81
                    .db $10,$01,$50,$90,$85,$10,$01,$D0
                    .db $90,$81,$D0,$85,$10,$02,$50,$5C
                    .db $1C,$82,$18,$82,$10,$81,$18,$03
                    .db $D0,$10,$50,$90,$85,$10,$01,$D0
                    .db $1C,$82,$90,$81,$D0,$85,$10,$00
                    .db $9C,$8F,$10,$05,$D0,$9C,$DC,$1C
                    .db $50,$10,$81,$90,$00,$10,$81,$D0
                    .db $82,$10,$02,$50,$10,$50,$87,$10
                    .db $01,$90,$D0,$81,$10,$00,$D0,$81
                    .db $9C,$83,$1C,$00,$50,$81,$10,$01
                    .db $50,$D0,$81,$10,$81,$D0,$03,$10
                    .db $D0,$10,$50,$83,$10,$00,$18,$84
                    .db $10,$02,$D0,$9C,$DC,$82,$1C,$00
                    .db $5C,$81,$1C,$00,$50,$82,$10,$83
                    .db $D0,$00,$90,$82,$10,$00,$1C,$83
                    .db $10,$81,$18,$81,$90,$81,$9C,$02
                    .db $DC,$1C,$5C,$82,$1C,$00,$5C,$81
                    .db $1C,$82,$10,$00,$50,$83,$10,$00
                    .db $50,$81,$90,$01,$DC,$1C,$85,$10
                    .db $02,$50,$10,$5C,$86,$1C,$00,$5C
                    .db $81,$1C,$00,$50,$86,$10,$00,$50
                    .db $81,$10,$81,$1C,$89,$10,$00,$50
                    .db $96,$10,$81,$14

DATA_04D678:        .db $00,$C0,$C0,$C0,$30,$C0,$C0,$00
                    .db $C0,$20,$30,$C0,$C0,$C0,$C0,$D0
                    .db $40,$40,$40,$D0,$40,$80,$80,$00
                    .db $00,$00,$00,$40,$00,$80,$20,$80
                    .db $40,$40,$80,$60,$90,$00,$00,$C0
                    .db $00,$00,$00,$C0,$40,$20,$40,$C0
                    .db $E0,$C0,$00,$C0,$00,$00,$C0,$20
                    .db $80,$80,$80,$80,$30,$40,$E0,$00
                    .db $40,$E0,$E0,$D0,$70,$FF,$40,$90
                    .db $55,$80,$80,$80,$80,$00,$C0,$C0
                    .db $C0,$C0,$40,$00,$80,$A0,$30,$AA
                    .db $60,$D0,$80,$00,$55,$55,$00,$00
                    .db $AA,$55,$FF,$FF,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00

ADDR_04D6E9:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    STZ $1C                   
                    LDA.W #$FFFF              
                    STA $4D                   
                    STA $4F                   
                    LDA.W #$0202              
                    STA $55                   
                    LDA.W $0DD6               
                    LSR                       
                    LSR                       
                    AND.W #$00FF              
                    TAX                       
                    LDA.W $1F11,X             
                    AND.W #$000F              
                    BEQ ADDR_04D714           
                    LDA.W #$0020              
                    STA $47                   
                    LDA.W #$0200              
                    STA $1C                   
ADDR_04D714:        JSL.L ADDR_05881A         
                    JSL.L ADDR_0087AD         
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    INC $47                   
                    LDA $1C                   
                    CLC                       
                    ADC.W #$0010              
                    STA $1C                   
                    AND.W #$01FF              
                    BNE ADDR_04D714           
                    LDA $20                   
                    STA $1C                   
                    STZ $47                   
                    STZ.W $1925               
                    STZ $5B                   
                    LDA.W #$FFFF              
                    STA $4D                   
                    STA $4F                   
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDA.B #$80                
                    STA.W $2115               ; VRAM Address Increment Value
                    STZ.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDA.B #$30                
                    STA.W $2117               ; Address for VRAM Read/Write (High Byte)
                    LDX.B #$06                
ADDR_04D750:        LDA.L DATA_04DAB3,X       
                    STA.W $4310,X             
                    DEX                       
                    BPL ADDR_04D750           
                    LDA.W $0DD6               
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W $1F11,X             
                    BEQ ADDR_04D76A           
                    LDA.B #$60                
                    STA.W $4313               ; A Address (High Byte)
ADDR_04D76A:        LDA.B #$02                
                    STA.W $420B               ; Regular DMA Channel Enable
                    RTL                       ; Return 

ADDR_04D770:        STA.L $7FC800,X           
                    STA.L $7FC9B0,X           
                    STA.L $7FCB60,X           
                    STA.L $7FCD10,X           
                    STA.L $7FCEC0,X           
                    STA.L $7FD070,X           
                    STA.L $7FD220,X           
                    STA.L $7FD3D0,X           
                    STA.L $7FD580,X           
                    STA.L $7FD730,X           
                    STA.L $7FD8E0,X           
                    STA.L $7FDA90,X           
                    STA.L $7FDC40,X           
                    STA.L $7FDDF0,X           
                    STA.L $7FDFA0,X           
                    STA.L $7FE150,X           
                    STA.L $7FE300,X           
                    STA.L $7FE4B0,X           
                    STA.L $7FE660,X           
                    STA.L $7FE810,X           
                    STA.L $7FE9C0,X           
                    STA.L $7FEB70,X           
                    STA.L $7FED20,X           
                    STA.L $7FEED0,X           
                    STA.L $7FF080,X           
                    STA.L $7FF230,X           
                    STA.L $7FF3E0,X           
                    STA.L $7FF590,X           
                    STA.L $7FF740,X           
                    STA.L $7FF8F0,X           
                    STA.L $7FFAA0,X           
                    STA.L $7FFC50,X           
                    INX                       
                    RTS                       ; Return 

ADDR_04D7F2:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.W #$0000              
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.B #$00                
                    STA $0D                   
                    LDA.B #$D0                
                    STA $0E                   
                    LDA.B #$7E                
                    STA $0F                   
                    LDA.B #$00                
                    STA $0A                   
                    LDA.B #$D8                
                    STA $0B                   
                    LDA.B #$7E                
                    STA $0C                   
                    LDA.B #$00                
                    STA $04                   
                    LDA.B #$C8                
                    STA $05                   
                    LDA.B #$7E                
                    STA $06                   
                    LDY.W #$0001              
                    STY $00                   
                    LDY.W #$07FF              
                    LDA.B #$00                
ADDR_04D827:        STA [$0A],Y               
                    STA [$0D],Y               
                    DEY                       
                    BPL ADDR_04D827           
                    LDY.W #$0000              
                    TYX                       
ADDR_04D832:        LDA [$04],Y               
                    CMP.B #$56                
                    BCC ADDR_04D849           
                    CMP.B #$81                
                    BCS ADDR_04D849           
                    LDA $00                   
                    STA [$0D],Y               
                    TAX                       
                    LDA.L DATA_04D678,X       
                    STA [$0A],Y               
                    INC $00                   
ADDR_04D849:        INY                       
                    CPY.W #$0800              
                    BNE ADDR_04D832           
                    STZ $0F                   
ADDR_04D851:        JSR.W ADDR_04DA49         
                    INC $0F                   
                    LDA $0F                   
                    CMP.B #$6F                
                    BNE ADDR_04D851           
                    RTS                       ; Return 


DATA_04D85D:        .db $00,$00,$00,$00,$00,$00,$69,$04
                    .db $4B,$04,$29,$04,$09,$04,$D3,$00
                    .db $E5,$00,$A5,$00,$D1,$00,$85,$00
                    .db $A9,$00,$CB,$00,$BD,$00,$9D,$00
                    .db $A5,$00,$07,$02,$00,$00,$27,$02
                    .db $12,$05,$08,$06,$E3,$04,$C8,$04
                    .db $2A,$06,$EC,$04,$0C,$06,$1C,$06
                    .db $4A,$06,$00,$00,$E0,$04,$3E,$00
                    .db $30,$01,$34,$01,$36,$01,$3A,$01
                    .db $00,$00,$57,$01,$84,$01,$3A,$01
                    .db $00,$00,$00,$00,$AA,$06,$76,$06
                    .db $C8,$06,$AC,$06,$76,$06,$00,$00
                    .db $00,$00,$A4,$06,$AA,$06,$C4,$06
                    .db $00,$00,$04,$03,$00,$00,$00,$00
                    .db $79,$05,$77,$05,$59,$05,$74,$05
                    .db $00,$00,$54,$05,$00,$00,$34,$05
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$B3,$03,$00,$00
                    .db $00,$00,$00,$00,$DF,$02,$DC,$02
                    .db $00,$00,$7E,$02,$00,$00,$00,$00
                    .db $00,$00,$E0,$04,$E0,$04,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$34,$05,$34,$05
                    .db $00,$00,$00,$00,$87,$07,$00,$00
                    .db $F0,$01,$68,$03,$65,$03,$B5,$03
                    .db $00,$00,$36,$07,$39,$07,$3C,$07
                    .db $1C,$07,$19,$07,$16,$07,$13,$07
                    .db $11,$07,$00,$00,$00,$00,$00,$00
DATA_04D93D:        .db $00,$00,$00,$00,$00,$00,$21,$92
                    .db $21,$16,$20,$92,$20,$12,$23,$46
                    .db $23,$8A,$22,$8A,$23,$42,$22,$0A
                    .db $22,$92,$23,$16,$22,$DA,$22,$5A
                    .db $22,$8A,$28,$0E,$00,$00,$28,$8E
                    .db $24,$04,$28,$10,$23,$86,$23,$10
                    .db $28,$94,$23,$98,$28,$18,$28,$58
                    .db $29,$14,$00,$00,$23,$80,$20,$DC
                    .db $24,$C0,$24,$C8,$24,$CC,$24,$D4
                    .db $00,$00,$25,$4E,$26,$08,$24,$D4
                    .db $00,$00,$00,$00,$2A,$94,$29,$CC
                    .db $2B,$10,$2A,$98,$29,$CC,$00,$00
                    .db $00,$00,$2A,$88,$2A,$94,$2B,$08
                    .db $00,$00,$2C,$08,$00,$00,$00,$00
                    .db $25,$D2,$25,$CE,$25,$52,$25,$C8
                    .db $00,$00,$25,$48,$00,$00,$24,$C8
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$2E,$C6,$00,$00
                    .db $00,$00,$00,$00,$2B,$5E,$2B,$58
                    .db $00,$00,$29,$DC,$00,$00,$00,$00
                    .db $00,$00,$23,$80,$23,$80,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$24,$C8,$24,$C8
                    .db $00,$00,$00,$00,$2E,$0E,$00,$00
                    .db $27,$C0,$2D,$90,$2D,$8A,$2E,$CA
                    .db $00,$00,$2C,$CC,$2C,$D2,$2C,$D8
                    .db $2C,$58,$2C,$52,$2C,$4C,$2C,$46
                    .db $2C,$42,$00,$00,$00,$00,$00,$00
DATA_04DA1D:        .db $6E,$6F,$70,$71,$72,$73,$74,$75
                    .db $59,$53,$52,$83,$4D,$57,$5A,$76
                    .db $78,$7A,$7B,$7D,$7F,$54

DATA_04DA33:        .db $66,$67,$68,$69,$6A,$6B,$6C,$6D
                    .db $58,$43,$44,$45,$25,$5E,$5F,$77
                    .db $79,$63,$7C,$7E,$80,$23

ADDR_04DA49:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA $0F                   
                    AND.W #$00F8              
                    LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA $0F                   
                    AND.W #$0007              
                    TAX                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.W $1F02,Y             
                    AND.L DATA_04E44B,X       
                    BEQ ADDR_04DAAC           
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W #$C800              
                    STA $04                   
                    LDA $0F                   
                    AND.W #$00FF              
                    ASL                       
                    TAX                       
                    LDA.L DATA_04D85D,X       
                    TAY                       
                    LDX.W #$0015              
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.B #$7E                
                    STA $06                   
                    LDA [$04],Y               
ADDR_04DA83:        CMP.L DATA_04DA1D,X       
                    BEQ ADDR_04DA8F           
                    DEX                       
                    BPL ADDR_04DA83           
                    JMP.W ADDR_04DA9D         
ADDR_04DA8F:        LDA.L DATA_04DA33,X       
                    STA [$04],Y               
                    CPX.W #$0015              
                    BNE ADDR_04DA9D           
                    INY                       
                    STA [$04],Y               
ADDR_04DA9D:        LDA $0F                   
                    JSR.W ADDR_04E677         
                    SEP #$10                  ; Index (8 bit) 
                    STZ.W $1B86               
                    LDA $0F                   
                    JSR.W ADDR_04E9F1         
ADDR_04DAAC:        RTS                       ; Return 

ADDR_04DAAD:        PHP                       
                    JSR.W ADDR_04DC6A         
                    PLP                       
                    RTL                       ; Return 


DATA_04DAB3:        .db $01,$18,$00,$40,$7F,$00,$20

ADDR_04DABA:        SEP #$20                  ; Accum (8 bit) 
                    REP #$10                  ; Index (16 bit) 
                    LDA [$00],Y               
                    STA $03                   
                    AND.B #$80                
                    BNE ADDR_04DAD6           
ADDR_04DAC6:        INY                       
                    LDA [$00],Y               
                    STA.L $7F4000,X           
                    INX                       
                    INX                       
                    DEC $03                   
                    BPL ADDR_04DAC6           
                    JMP.W ADDR_04DAE9         
ADDR_04DAD6:        LDA $03                   
                    AND.B #$7F                
                    STA $03                   
                    INY                       
                    LDA [$00],Y               
ADDR_04DADF:        STA.L $7F4000,X           
                    INX                       
                    INX                       
                    DEC $03                   
                    BPL ADDR_04DADF           
ADDR_04DAE9:        INY                       
                    CPX $0E                   
                    BCC ADDR_04DABA           
                    RTS                       ; Return 

                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDA.W $1DE8               
                    JSL.L ExecutePtr          

Ptrs04DAF8:         .dw ADDR_04DB18           
                    .dw ADDR_04DCB6           
                    .dw ADDR_04DCB6           
                    .dw ADDR_04DCB6           
                    .dw ADDR_04DCB6           
                    .dw ADDR_04DB9D           
                    .dw ADDR_04DB18           
                    .dw ADDR_04DBCF           

DATA_04DB08:        .db $00,$F9,$00,$07

DATA_04DB0C:        .db $00,$00,$00,$70

DATA_04DB10:        .db $C0,$FA,$40,$05

DATA_04DB14:        .db $00,$00,$00,$54

ADDR_04DB18:        REP #$20                  ; Accum (16 bit) 
                    LDX.W $1B8C               
                    LDA.W $1B8D               
                    CLC                       
                    ADC.W DATA_04DB08,X       
                    STA.W $1B8D               
                    SEC                       
                    SBC.W DATA_04DB0C,X       
                    EOR.W DATA_04DB08,X       
                    BPL ADDR_04DB43           
                    LDA.W $1B8F               
                    CLC                       
                    ADC.W DATA_04DB10,X       
                    STA.W $1B8F               
                    SEC                       
                    SBC.W DATA_04DB14,X       
                    EOR.W DATA_04DB10,X       
                    BMI ADDR_04DB5F           
ADDR_04DB43:        LDA.W DATA_04DB0C,X       
                    STA.W $1B8D               
                    LDA.W DATA_04DB14,X       
                    STA.W $1B8F               
                    INC.W $1DE8               
                    TXA                       
                    EOR.W #$0002              
                    TAX                       
                    STX.W $1B8C               
                    BEQ ADDR_04DB5F           
                    JSR.W ADDR_049A93         
ADDR_04DB5F:        SEP #$20                  ; Accum (8 bit) 
                    LDA.W $1B90               
                    ASL                       
                    STA $00                   
                    LDA.W $1B8E               
                    CLC                       
                    ADC.B #$80                
                    XBA                       
                    LDA.B #$80                
                    SEC                       
                    SBC.W $1B8E               
                    REP #$20                  ; Accum (16 bit) 
                    LDX.B #$00                
                    LDY.B #$A8                
ADDR_04DB7A:        CPX $00                   
                    BCC ADDR_04DB81           
                    LDA.W #$00FF              
ADDR_04DB81:        STA.W $04EE,Y             
                    STA.W $0598,X             
                    INX                       
                    INX                       
                    DEY                       
                    DEY                       
                    BNE ADDR_04DB7A           
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.B #$33                
                    STA $41                   
                    LDA.B #$33                
ADDR_04DB95:        STA $43                   
                    LDA.B #$80                
                    STA.W $0D9F               
                    RTS                       ; Return 

ADDR_04DB9D:        LDA.W $0DD6               
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W $1F11,X             
                    TAX                       
                    LDA.L DATA_04DC02,X       
                    STA.W $1931               
                    JSL.L ADDR_00A594         
                    LDA.B #$FE                
                    STA.W $0703               
                    LDA.B #$01                
                    STA.W $0704               
                    STZ.W $0803               
                    LDA.B #$06                
                    STA.W $0680               
                    INC.W $1DE8               
                    RTS                       ; Return 


DATA_04DBC8:        .db $02,$03,$04,$06,$07,$09,$05

ADDR_04DBCF:        STZ.W $1DE8               
                    LDA.B #$04                
                    STA.W $13D9               
                    LDA.W $0DD6               
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W $0DB2               
                    BEQ ADDR_04DBF3           
                    LDA.W $1B9E               
                    BNE ADDR_04DBF3           
                    TYA                       
                    EOR.B #$01                
                    TAX                       
                    LDA.W $1F11,Y             
                    CMP.W $1F11,X             
                    BEQ ADDR_04DC01           
ADDR_04DBF3:        LDA.W $1F11,Y             
                    TAX                       
                    LDA.L DATA_04DBC8,X       
                    STA.W $1DFB               ; / Play sound effect 
                    STZ.W $1B9E               
ADDR_04DC01:        RTS                       ; Return 


DATA_04DC02:        .db $11,$12,$13,$14,$15,$16,$17

ADDR_04DC09:        SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDA.W $0DD6               
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W $1F11,X             
                    TAX                       
                    LDA.L DATA_04DC02,X       
                    STA.W $1931               
                    LDA.B #$11                
                    STA.W $192B               
                    LDA.B #$07                
                    STA.W $1925               
                    LDA.B #$03                
                    STA $5B                   
                    REP #$10                  ; Index (16 bit) 
                    LDX.W #$0000              
                    TXA                       
ADDR_04DC30:        JSR.W ADDR_04D770         
                    CPX.W #$01B0              
                    BNE ADDR_04DC30           
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.W #$D000              
                    STA $00                   
                    LDX.W #$0000              
ADDR_04DC42:        LDA $00                   
                    STA.W $0FBE,X             
                    LDA $00                   
                    CLC                       
                    ADC.W #$0008              
                    STA $00                   
                    INX                       
                    INX                       
                    CPX.W #$0400              
                    BNE ADDR_04DC42           
                    PHB                       
                    LDA.W #$07FF              
                    LDX.W #$F7DF              
                    LDY.W #$C800              
                    MVN $7E,$0C               
                    PLB                       
                    JSR.W ADDR_04D7F2         
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    RTL                       ; Return 

ADDR_04DC6A:        SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    JSR.W ADDR_04DD40         
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W #$A533              
                    STA $00                   
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDA.B #$04                
                    STA $02                   
                    REP #$10                  ; Index (16 bit) 
                    LDY.W #$4000              
                    STY $0E                   
                    LDY.W #$0000              
                    TYX                       
                    JSR.W ADDR_04DABA         
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W #$C02B              
                    STA $00                   
                    SEP #$20                  ; Accum (8 bit) 
                    LDX.W #$0001              
                    LDY.W #$0000              
                    JSR.W ADDR_04DABA         
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDA.B #$00                
                    STA $0F                   
ADDR_04DCA2:        JSR.W ADDR_04E453         
                    INC $0F                   
                    LDA $0F                   
                    CMP.B #$6F                
                    BNE ADDR_04DCA2           
                    RTS                       ; Return 


DATA_04DCAE:        .db $80,$40,$20,$10,$08,$04,$02,$01

ADDR_04DCB6:        PHP                       
                    REP #$10                  ; Index (16 bit) 
                    SEP #$20                  ; Accum (8 bit) 
                    LDX.W #$D000              
                    STX $65                   
                    LDA.B #$05                
                    STA $67                   
                    LDX.W #$0000              
                    STX $00                   
                    LDA.W $1DE8               
                    DEC A                     
                    STA $01                   
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W $0DD6               
                    LSR                       
                    LSR                       
                    AND.W #$00FF              
                    TAX                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.W $1F11,X             
                    BEQ ADDR_04DCE8           
                    LDA $01                   
                    CLC                       
                    ADC.B #$04                
                    STA $01                   
ADDR_04DCE8:        LDX $00                   
                    LDA.L $7EC800,X           
                    STA $02                   
                    REP #$20                  ; Accum (16 bit) 
                    LDA.L $7FC800,X           
                    STA $03                   
                    LDA $02                   
                    ASL                       
                    ASL                       
                    ASL                       
                    TAY                       
                    LDA $00                   
                    AND.W #$00FF              
                    ASL                       
                    ASL                       
                    PHA                       
                    AND.W #$003F              
                    STA $02                   
                    PLA                       
                    ASL                       
                    AND.W #$0F80              
                    ORA $02                   
                    TAX                       
                    LDA [$65],Y               
                    STA.L $7EE400,X           
                    INY                       
                    INY                       
                    LDA [$65],Y               
                    STA.L $7EE440,X           
                    INY                       
                    INY                       
                    LDA [$65],Y               
                    STA.L $7EE402,X           
                    INY                       
                    INY                       
                    LDA [$65],Y               
                    STA.L $7EE442,X           
                    SEP #$20                  ; Accum (8 bit) 
                    INC $00                   
                    LDA $00                   
                    AND.B #$FF                
                    BNE ADDR_04DCE8           
                    INC.W $1DE8               
                    PLP                       
                    RTS                       ; Return 

ADDR_04DD40:        REP #$10                  ; Index (16 bit) 
                    SEP #$20                  ; Accum (8 bit) 
                    LDY.W #$8D00              
                    STY $02                   
                    LDA.B #$0C                
                    STA $04                   
                    LDX.W #$0000              
                    TXY                       
                    JSR.W ADDR_04DD57         
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    RTS                       ; Return 

ADDR_04DD57:        SEP #$20                  ; Accum (8 bit) 
                    LDA [$02],Y               
                    INY                       
                    STA $05                   
                    AND.B #$80                
                    BNE ADDR_04DD71           
ADDR_04DD62:        LDA [$02],Y               
                    STA.L $7F0000,X           
                    INY                       
                    INX                       
                    DEC $05                   
                    BPL ADDR_04DD62           
                    JMP.W ADDR_04DD83         
ADDR_04DD71:        LDA $05                   
                    AND.B #$7F                
                    STA $05                   
                    LDA [$02],Y               
ADDR_04DD79:        STA.L $7F0000,X           
                    INX                       
                    DEC $05                   
                    BPL ADDR_04DD79           
                    INY                       
ADDR_04DD83:        REP #$20                  ; Accum (16 bit) 
                    LDA [$02],Y               
                    CMP.W #$FFFF              
                    BNE ADDR_04DD57           
                    RTS                       ; Return 


DATA_04DD8D:        .db $00,$09

DATA_04DD8F:        .db $CC,$23,$04,$09,$8C,$23,$08,$09
                    .db $4E,$23,$0C,$09,$0E,$23,$10,$09
                    .db $D0,$22,$14,$09,$90,$22,$8C,$01
                    .db $02,$22,$B0,$01,$02,$22,$D4,$01
                    .db $02,$22,$44,$0A,$C6,$21,$48,$0A
                    .db $44,$20,$4C,$0A,$86,$21,$48,$0A
                    .db $04,$20,$00,$09,$E4,$23,$38,$09
                    .db $A4,$23,$28,$09,$24,$23,$18,$09
                    .db $26,$23,$1C,$09,$28,$23,$20,$09
                    .db $EC,$22,$24,$09,$AC,$22,$0C,$0B
                    .db $2C,$22,$10,$0B,$EC,$21,$30,$09
                    .db $6C,$21,$34,$09,$68,$21,$38,$09
                    .db $E4,$20,$38,$09,$A4,$20,$3C,$09
                    .db $90,$10,$40,$09,$4C,$10,$44,$09
                    .db $0C,$10,$38,$09,$8C,$07,$38,$09
                    .db $0C,$07,$28,$09,$8C,$06,$48,$09
                    .db $14,$10,$4C,$09,$94,$07,$50,$09
                    .db $54,$07,$38,$09,$0C,$06,$04,$09
                    .db $8C,$05,$54,$09,$0E,$05,$E8,$09
                    .db $48,$06,$E8,$09,$C8,$06,$98,$09
                    .db $88,$06,$EC,$09,$12,$05,$F0,$09
                    .db $D2,$04,$F4,$09,$92,$04,$00,$00
                    .db $D8,$04,$24,$00,$98,$04,$48,$00
                    .db $D8,$03,$6C,$00,$56,$03,$90,$00
                    .db $56,$03,$B4,$00,$56,$03,$10,$05
                    .db $18,$05,$28,$09,$24,$05,$38,$0B
                    .db $14,$07,$60,$09,$28,$05,$64,$09
                    .db $6A,$05,$68,$09,$AC,$05,$6C,$09
                    .db $2C,$06,$70,$09,$30,$06,$74,$09
                    .db $B2,$05,$78,$09,$32,$05,$68,$01
                    .db $FC,$07,$50,$0A,$C0,$0F,$D8,$00
                    .db $7C,$07,$FC,$00,$7C,$07,$20,$01
                    .db $7C,$07,$44,$01,$7C,$07,$50,$09
                    .db $D4,$06,$4C,$09,$94,$06,$7C,$09
                    .db $14,$06,$80,$09,$94,$05,$84,$09
                    .db $18,$07,$88,$09,$1A,$07,$48,$09
                    .db $9C,$07,$8C,$09,$1C,$10,$90,$09
                    .db $60,$10,$94,$09,$64,$10,$38,$09
                    .db $DC,$10,$98,$09,$84,$28,$A4,$09
                    .db $18,$31,$84,$09,$1C,$31,$A8,$09
                    .db $E0,$30,$4C,$09,$60,$30,$A0,$09
                    .db $CA,$30,$A0,$09,$0E,$31,$B0,$09
                    .db $10,$31,$B4,$09,$CC,$30,$B8,$09
                    .db $8C,$30,$BC,$09,$0C,$30,$BC,$09
                    .db $8C,$27,$BC,$09,$A0,$27,$BC,$09
                    .db $20,$27,$AC,$09,$A0,$26,$28,$09
                    .db $20,$26,$00,$0A,$64,$30,$04,$0A
                    .db $A8,$30,$08,$0A,$28,$31,$18,$09
                    .db $22,$26,$98,$09,$26,$26,$C0,$09
                    .db $2A,$26,$C4,$09,$6C,$26,$C8,$09
                    .db $70,$26,$CC,$09,$B0,$26,$28,$09
                    .db $30,$27,$D0,$09,$70,$27,$38,$09
                    .db $B0,$27,$28,$09,$30,$30,$38,$09
                    .db $B0,$30,$38,$09,$F0,$30,$D4,$09
                    .db $B0,$31,$D8,$09,$2E,$32,$98,$09
                    .db $2A,$32,$E0,$09,$CC,$26,$BC,$09
                    .db $8C,$26,$E4,$09,$0C,$26,$DC,$09
                    .db $04,$27,$DC,$09,$C0,$26,$DC,$09
                    .db $40,$27,$98,$09,$B4,$01,$0C,$0B
                    .db $B8,$01,$30,$0B,$88,$09,$34,$0B
                    .db $A0,$09,$10,$0A,$8A,$09,$10,$0A
                    .db $9E,$09,$0C,$0A,$8C,$09,$0C,$0A
                    .db $9C,$09,$10,$0A,$8E,$09,$10,$0A
                    .db $9A,$09,$0C,$0A,$90,$09,$0C,$0A
                    .db $98,$09,$10,$0A,$92,$09,$10,$0A
                    .db $96,$09,$14,$0A,$A4,$09,$A8,$03
                    .db $30,$08,$18,$0A,$AC,$09,$1C,$0A
                    .db $F0,$09,$9C,$09,$70,$0A,$20,$0A
                    .db $F0,$0A,$20,$0A,$70,$0B,$20,$0A
                    .db $F0,$0B,$24,$0A,$70,$0C,$38,$09
                    .db $F0,$0C,$28,$0A,$30,$0D,$2C,$0A
                    .db $98,$0A,$30,$0A,$9C,$0A,$14,$0B
                    .db $10,$0B,$18,$0B,$90,$0B,$34,$0A
                    .db $1C,$0B,$38,$0A,$5E,$0B,$3C,$0A
                    .db $62,$0B,$40,$0A,$66,$0B,$20,$0A
                    .db $E8,$0A,$9C,$09,$68,$0A,$7C,$0A
                    .db $A4,$33,$7C,$0A,$E8,$33,$7C,$0A
                    .db $68,$34,$18,$09,$A2,$33,$C0,$09
                    .db $A4,$33,$30,$09,$E8,$33,$54,$0A
                    .db $28,$34,$38,$09,$A8,$34,$7C,$0A
                    .db $98,$33,$7C,$0A,$9C,$33,$58,$0A
                    .db $9E,$33,$98,$09,$9C,$33,$28,$09
                    .db $98,$33,$7C,$0A,$26,$36,$7C,$0A
                    .db $20,$36,$5C,$0A,$68,$35,$14,$09
                    .db $A8,$35,$D8,$09,$26,$36,$1C,$09
                    .db $24,$36,$28,$09,$20,$36,$7C,$0A
                    .db $2C,$35,$7C,$0A,$30,$35,$60,$0A
                    .db $2A,$35,$98,$09,$2C,$35,$98,$09
                    .db $2E,$35,$98,$09,$30,$35,$7C,$0A
                    .db $DA,$35,$7C,$0A,$98,$34,$7C,$0A
                    .db $18,$34,$58,$0A,$1E,$36,$3C,$09
                    .db $1C,$36,$64,$0A,$D8,$35,$44,$09
                    .db $98,$35,$28,$09,$18,$35,$38,$09
                    .db $98,$34,$38,$09,$18,$34,$28,$09
                    .db $98,$33,$7C,$0A,$A0,$36,$7C,$0A
                    .db $60,$37,$D0,$09,$60,$36,$38,$09
                    .db $E0,$36,$38,$09,$60,$37,$7C,$0A
                    .db $9C,$33,$18,$09,$9A,$33,$98,$09
                    .db $9C,$33,$7C,$0A,$10,$35,$58,$0A
                    .db $96,$33,$6C,$0A,$92,$33,$70,$0A
                    .db $D0,$33,$74,$0A,$10,$34,$38,$09
                    .db $90,$34,$28,$09,$10,$35,$7C,$0A
                    .db $1C,$35,$7C,$0A,$22,$35,$98,$09
                    .db $14,$35,$28,$09,$18,$35,$98,$09
                    .db $1C,$35,$98,$09,$20,$35,$98,$09
                    .db $24,$35,$7C,$0A,$10,$36,$D0,$09
                    .db $50,$35,$38,$09,$90,$35,$28,$09
                    .db $10,$36,$7C,$0A,$90,$36,$7C,$0A
                    .db $0E,$37,$7C,$0A,$0A,$37,$7C,$0A
                    .db $02,$37,$D0,$09,$50,$36,$78,$0A
                    .db $D0,$36,$1C,$09,$0C,$37,$98,$09
                    .db $08,$37,$98,$09,$04,$37,$98,$09
                    .db $00,$37,$90,$0A,$12,$18,$94,$0A
                    .db $AA,$2B,$98,$0A,$A8,$2B,$9C,$0A
                    .db $A4,$2B,$94,$0A,$A2,$2B,$98,$0A
                    .db $A0,$2B,$A0,$0A,$64,$2B,$A4,$0A
                    .db $9A,$2B,$98,$0A,$98,$2B,$98,$0A
                    .db $96,$2B,$98,$0A,$94,$2B,$9C,$0A
                    .db $90,$2B,$A0,$0A,$5C,$2B,$A0,$0A
                    .db $50,$2B,$A8,$0A,$10,$2B,$9C,$0A
                    .db $90,$2A,$AC,$0A,$92,$2A,$98,$0A
                    .db $94,$2A,$98,$0A,$96,$2A,$98,$0A
                    .db $98,$2A,$A0,$0A,$50,$2A,$A8,$0A
                    .db $10,$2A,$3C,$0B,$90,$29,$40,$0B
                    .db $94,$29,$40,$0B,$98,$29,$A0,$0A
                    .db $5C,$2A,$A8,$0A,$1C,$2A,$A8,$0A
                    .db $DC,$29,$A0,$0A,$64,$2A,$A8,$0A
                    .db $24,$2A,$A8,$0A,$E4,$29,$B0,$0A
                    .db $90,$1D,$A0,$09,$8C,$1D,$B0,$0A
                    .db $56,$1E,$B4,$0A,$5A,$1E,$B8,$0A
                    .db $5C,$1D,$A0,$09,$18,$1D,$BC,$0A
                    .db $90,$1C,$BC,$0A,$0C,$1C,$A0,$09
                    .db $0C,$1E,$C0,$0A,$8A,$1E,$C0,$0A
                    .db $86,$1E,$BC,$0A,$04,$1E,$A0,$09
                    .db $84,$1D,$B8,$0A,$C6,$1C,$B0,$0A
                    .db $0C,$1D,$A0,$09,$88,$1D,$A0,$09
                    .db $84,$1D,$B4,$0A,$80,$1D,$A0,$09
                    .db $3C,$16,$A0,$09,$BC,$16,$A0,$09
                    .db $B8,$16,$A0,$09,$B4,$16,$A0,$09
                    .db $30,$16,$A8,$0A,$70,$15,$C4,$0A
                    .db $30,$15,$D8,$0A,$B8,$13,$4C,$09
                    .db $B0,$14,$C8,$0A,$32,$14,$CC,$0A
                    .db $F4,$13,$D0,$0A,$B8,$13,$D4,$0A
                    .db $B8,$12,$F8,$01,$F4,$11,$1C,$02
                    .db $F4,$11,$40,$02,$F4,$11,$64,$02
                    .db $F4,$11,$88,$02,$F4,$11,$AC,$02
                    .db $F4,$11,$D0,$02,$F4,$11,$F4,$02
                    .db $F4,$11,$18,$03,$F4,$11,$3C,$03
                    .db $B4,$11,$60,$03,$B4,$11,$3C,$03
                    .db $B4,$11,$DC,$0A,$10,$3D,$E0,$0A
                    .db $CE,$3C,$E4,$0A,$8C,$3C,$E8,$0A
                    .db $48,$3C,$EC,$0A,$14,$3C,$F0,$0A
                    .db $D6,$3B,$F4,$0A,$98,$3B,$F8,$0A
                    .db $5A,$3B,$18,$09,$26,$3C,$98,$09
                    .db $28,$3C,$98,$09,$2A,$3C,$98,$09
                    .db $2C,$3C,$6C,$09,$28,$3D,$FC,$0A
                    .db $68,$3D,$00,$0B,$AA,$3D,$E4,$0A
                    .db $EC,$3D,$E4,$0A,$2E,$3E,$DC,$0A
                    .db $B0,$3E,$3C,$0B,$90,$29,$40,$0B
                    .db $94,$29,$40,$0B,$98,$29,$04,$0B
                    .db $9C,$3D,$08,$0B,$D8,$3D,$08,$0B
                    .db $14,$3E,$08,$0B,$50,$3E,$08,$0B
                    .db $8C,$3E,$6C,$09,$88,$3E,$44,$01
                    .db $7C,$07,$38,$09,$E0,$19,$1C,$0B
                    .db $20,$1A,$CC,$03,$DC,$1A,$F0,$03
                    .db $DC,$1A,$14,$04,$DC,$1A,$38,$04
                    .db $9C,$1B,$5C,$04,$9C,$1B,$80,$04
                    .db $5C,$1B,$A4,$04,$1C,$1B,$C8,$04
                    .db $DC,$1A,$EC,$04,$9C,$1A,$58,$0A
                    .db $1E,$1B,$20,$0B,$1C,$1B,$24,$0B
                    .db $1A,$1B,$28,$0B,$18,$1B,$A0,$09
                    .db $94,$1B,$A0,$09,$14,$1C,$A0,$09
                    .db $94,$1C,$C0,$0A,$14,$1D,$2C,$0B
                    .db $56,$1D,$A0,$09,$D4,$1D,$98,$09
                    .db $90,$39,$98,$09,$94,$39,$28,$09
                    .db $98,$39,$98,$09,$9C,$39,$98,$09
                    .db $A0,$39,$28,$09,$A4,$39,$98,$09
                    .db $A8,$39,$98,$09,$AC,$39,$28,$09
                    .db $B0,$39,$98,$09,$B4,$39,$98,$09
                    .db $B4,$38,$28,$09,$B0,$38,$98,$09
                    .db $AC,$38,$98,$09,$A8,$38,$28,$09
                    .db $A4,$38,$98,$09,$A0,$38,$98,$09
                    .db $9C,$38,$28,$09,$98,$38,$98,$09
                    .db $94,$38,$98,$09,$90,$38,$28,$09
                    .db $8C,$38,$98,$09,$88,$38,$28,$09
                    .db $84,$38

DATA_04E359:        .db $00,$00

DATA_04E35B:        .db $00,$00,$0D,$00,$0D,$00,$10,$00
                    .db $15,$00,$18,$00,$1A,$00,$20,$00
                    .db $23,$00,$26,$00,$29,$00,$2C,$00
                    .db $35,$00,$39,$00,$3A,$00,$42,$00
                    .db $46,$00,$4A,$00,$4C,$00,$4D,$00
                    .db $4E,$00,$52,$00,$59,$00,$5D,$00
                    .db $60,$00,$67,$00,$6A,$00,$6C,$00
                    .db $6F,$00,$72,$00,$75,$00,$77,$00
                    .db $77,$00,$83,$00,$83,$00,$84,$00
                    .db $8E,$00,$90,$00,$92,$00,$98,$00
                    .db $98,$00,$98,$00,$A0,$00,$A5,$00
                    .db $AC,$00,$B2,$00,$BD,$00,$C2,$00
                    .db $C5,$00,$CC,$00,$D3,$00,$D7,$00
                    .db $E1,$00,$E2,$00,$E2,$00,$E2,$00
                    .db $E5,$00,$E7,$00,$E8,$00,$ED,$00
                    .db $EE,$00,$F1,$00,$F5,$00,$FA,$00
                    .db $FD,$00,$00,$01,$00,$01,$00,$01
                    .db $00,$01,$00,$01,$02,$01,$08,$01
                    .db $0F,$01,$12,$01,$14,$01,$16,$01
                    .db $17,$01,$1E,$01,$2B,$01,$2B,$01
                    .db $2B,$01,$2B,$01,$2F,$01,$2F,$01
                    .db $2F,$01,$33,$01,$33,$01,$33,$01
                    .db $37,$01,$37,$01,$37,$01,$40,$01
                    .db $40,$01,$46,$01,$46,$01,$46,$01
                    .db $47,$01,$52,$01,$56,$01,$5C,$01
                    .db $5C,$01,$5F,$01,$62,$01,$65,$01
                    .db $68,$01,$6B,$01,$6E,$01,$71,$01
                    .db $73,$01,$73,$01,$73,$01,$73,$01
                    .db $73,$01,$73,$01,$73,$01,$73,$01
                    .db $73,$01,$73,$01,$73,$01,$73,$01
DATA_04E44B:        .db $80,$40,$20,$10,$08,$04,$02,$01

ADDR_04E453:        SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDA $0F                   
                    AND.B #$07                
                    TAX                       
                    LDA $0F                   
                    LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W $1F02,Y             
                    AND.L DATA_04E44B,X       
                    BNE ADDR_04E46A           
                    RTS                       ; Return 

ADDR_04E46A:        LDA $0F                   
                    ASL                       
                    TAX                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA.L DATA_04E359,X       
                    STA.W $1DEB               
                    LDA.L DATA_04E35B,X       
                    STA.W $1DED               
                    CMP.W $1DEB               
                    BEQ ADDR_04E493           
ADDR_04E483:        JSR.W ADDR_04E496         
                    REP #$20                  ; Accum (16 bit) 
                    INC.W $1DEB               
                    LDA.W $1DEB               
                    CMP.W $1DED               
                    BNE ADDR_04E483           
ADDR_04E493:        SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    RTS                       ; Return 

ADDR_04E496:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.W $1DEB               
                    ASL                       
                    ASL                       
                    TAX                       
                    LDA.L DATA_04DD8D,X       
                    TAY                       
                    LDA.L DATA_04DD8F,X       
                    STA $04                   
ADDR_04E4A9:        SEP #$20                  ; Accum (8 bit) 
                    LDA.B #$7F                
                    STA $08                   
                    LDA.B #$0C                
                    STA $0B                   
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W #$0000              
                    STA $06                   
                    LDA.W #$8000              
                    STA $09                   
                    CPY.W #$0900              
                    BCC ADDR_04E4CA           
                    JSR.W ADDR_04E4D0         
                    JMP.W ADDR_04E4CD         
ADDR_04E4CA:        JSR.W ADDR_04E520         
ADDR_04E4CD:        SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    RTS                       ; Return 

ADDR_04E4D0:        LDA.W #$0001              ; Accum (16 bit) 
                    STA $00                   
ADDR_04E4D5:        LDX $04                   
                    LDA.W #$0001              
                    STA $0C                   
ADDR_04E4DC:        SEP #$20                  ; Accum (8 bit) 
                    LDA [$09],Y               
                    STA.L $7F4000,X           
                    INX                       
                    LDA [$06],Y               
                    STA.L $7F4000,X           
                    INY                       
                    INX                       
                    REP #$20                  ; Accum (16 bit) 
                    TXA                       
                    AND.W #$003F              
                    BNE ADDR_04E4FF           
                    DEX                       
                    TXA                       
                    AND.W #$FFC0              
                    CLC                       
                    ADC.W #$0800              
                    TAX                       
ADDR_04E4FF:        DEC $0C                   
                    BPL ADDR_04E4DC           
                    LDA $04                   
                    TAX                       
                    CLC                       
                    ADC.W #$0040              
                    STA $04                   
                    AND.W #$07C0              
                    BNE ADDR_04E51B           
                    TXA                       
                    AND.W #$F83F              
                    CLC                       
                    ADC.W #$1000              
                    STA $04                   
ADDR_04E51B:        DEC $00                   
                    BPL ADDR_04E4D5           
                    RTS                       ; Return 

ADDR_04E520:        LDA.W #$0005              
                    STA $00                   
ADDR_04E525:        LDX $04                   
                    LDA.W #$0005              
                    STA $0C                   
ADDR_04E52C:        SEP #$20                  ; Accum (8 bit) 
                    LDA [$09],Y               
                    STA.L $7F4000,X           
                    INX                       
                    LDA [$06],Y               
                    STA.L $7F4000,X           
                    INY                       
                    INX                       
                    REP #$20                  ; Accum (16 bit) 
                    TXA                       
                    AND.W #$003F              
                    BNE ADDR_04E54F           
                    DEX                       
                    TXA                       
                    AND.W #$FFC0              
                    CLC                       
                    ADC.W #$0800              
                    TAX                       
ADDR_04E54F:        DEC $0C                   
                    BPL ADDR_04E52C           
                    LDA $04                   
                    TAX                       
                    CLC                       
                    ADC.W #$0040              
                    STA $04                   
                    AND.W #$07C0              
                    BNE ADDR_04E56B           
                    TXA                       
                    AND.W #$F83F              
                    CLC                       
                    ADC.W #$1000              
                    STA $04                   
ADDR_04E56B:        DEC $00                   
                    BPL ADDR_04E525           
                    RTS                       ; Return 

                    LDA.W $1B86               
                    JSL.L ExecutePtr          

Ptrs04E577:         .dw ADDR_04E5EE           
                    .dw ADDR_04EBEB           
                    .dw ADDR_04E6D3           
                    .dw ADDR_04E6F9           
                    .dw ADDR_04EAA4           
                    .dw ADDR_04EC78           
                    .dw ADDR_04EBEB           
                    .dw ADDR_04E9EC           

DATA_04E587:        .db $20,$52,$22,$DA,$28,$58,$24,$C0
                    .db $24,$94,$23,$42,$28,$94,$2A,$98
                    .db $25,$0E,$25,$52,$25,$C4,$2A,$DE
                    .db $2A,$98,$28,$44,$2C,$50,$2C,$0C
DATA_04E5A7:        .db $77,$79,$58,$4C,$A6

DATA_04E5AC:        .db $85,$86,$00,$10,$00

DATA_04E5B1:        .db $85,$86,$81,$81,$81

DATA_04E5B6:        .db $19,$04,$BD,$00,$1C,$06,$30,$01
                    .db $2A,$01,$D1,$00,$2A,$06,$AC,$06
                    .db $47,$05,$59,$05,$72,$05,$BF,$02
                    .db $AC,$02,$12,$02,$18,$03,$06,$03
DATA_04E5D6:        .db $06,$0F,$1C,$21,$24,$28,$29,$37
                    .db $40,$41,$43,$4A,$4D,$02,$61,$35
DATA_04E5E6:        .db $58,$59,$5D,$63,$77,$79,$7E,$80

ADDR_04E5EE:        LDA.W $0DD5               ; Accum (8 bit) 
                    CMP.B #$02                
                    BNE ADDR_04E5F8           
                    INC.W $1DEA               
ADDR_04E5F8:        LDA.W $1DE9               
                    BEQ ADDR_04E61A           
                    LDA.W $1DEA               
                    CMP.B #$FF                
                    BEQ ADDR_04E61A           
                    LDA.W $1DEA               
                    AND.B #$07                
                    TAX                       
                    LDA.W $1DEA               
                    LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W $1F02,Y             
                    AND.L DATA_04E44B,X       
                    BEQ ADDR_04E640           
ADDR_04E61A:        LDX.B #$07                
ADDR_04E61C:        LDA.W DATA_04E5E6,X       
                    CMP.W $13C1               
                    BNE ADDR_04E632           
                    INC.W $13D9               
                    LDA.B #$E0                
                    STA.W $0DD5               
                    LDA.B #$0F                
                    STA.W $0DB1               
                    RTS                       ; Return 

ADDR_04E632:        DEX                       
                    BPL ADDR_04E61C           
                    LDA.B #$05                
                    STA.W $13D9               
                    LDA.B #$80                
                    STA.W $0DD5               
                    RTS                       ; Return 

ADDR_04E640:        INC.W $1B86               
                    LDA.W $1DEA               
                    JSR.W ADDR_04E677         
                    TYA                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    STA.W $1B82               
                    TYA                       
                    AND.B #$F0                
                    STA.W $1B83               
                    LDA.B #$28                
                    STA.W $1B84               
                    LDA.W $13BF               
                    CMP.B #$18                
                    BNE ADDR_04E668           
                    LDA.B #$FF                
                    STA.W $1BA0               
ADDR_04E668:        LDA.W $1B86               
                    CMP.B #$02                
                    BEQ ADDR_04E674           
                    LDA.B #$16                
                    STA.W $1DFC               ; / Play sound effect 
ADDR_04E674:        SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    RTS                       ; Return 

ADDR_04E677:        SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDX.B #$17                
ADDR_04E67B:        CMP.L DATA_04E5D6,X       
                    BEQ ADDR_04E68A           
                    DEX                       
                    BPL ADDR_04E67B           
ADDR_04E684:        LDA.B #$02                
                    STA.W $1B86               
                    RTS                       ; Return 

ADDR_04E68A:        STX.W $13D1               
                    TXA                       
                    ASL                       
                    TAX                       
                    LDA.B #$7E                
                    STA $0C                   
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.W #$C800              
                    STA $0A                   
                    LDA.L DATA_04E5B6,X       
                    TAY                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDX.W #$0004              
                    LDA [$0A],Y               
ADDR_04E6A7:        CMP.L DATA_04E5A7,X       
                    BEQ ADDR_04E6B3           
                    DEX                       
                    BPL ADDR_04E6A7           
                    JMP.W ADDR_04E684         
ADDR_04E6B3:        TXA                       
                    STA.W $13D0               
                    CPX.W #$0003              
                    BMI ADDR_04E6CA           
                    LDA.L DATA_04E5AC,X       
                    STA [$0A],Y               
                    REP #$20                  ; Accum (16 bit) 
                    TYA                       
                    CLC                       
                    ADC.W #$0010              
                    TAY                       
ADDR_04E6CA:        SEP #$20                  ; Accum (8 bit) 
                    LDA.L DATA_04E5B1,X       
                    STA [$0A],Y               
                    RTS                       ; Return 

ADDR_04E6D3:        INC.W $1B86               
                    LDA.W $1DEA               
                    ASL                       
                    TAX                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA.L DATA_04E359,X       
                    STA.W $1DEB               
                    LDA.L DATA_04E35B,X       
                    STA.W $1DED               
                    CMP.W $1DEB               
                    SEP #$20                  ; Accum (8 bit) 
                    BNE ADDR_04E6F8           
                    INC.W $1B86               
                    INC.W $1B86               
ADDR_04E6F8:        RTS                       ; Return 

ADDR_04E6F9:        JSR.W ADDR_04EA62         
                    LDA.B #$7F                
                    STA $0E                   
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.W $1DEB               
                    ASL                       
                    ASL                       
                    TAX                       
                    LDA.L DATA_04DD8D,X       
                    STA.W $1B84               
                    LDA.L DATA_04DD8F,X       
                    STA $00                   
                    AND.W #$1FFF              
                    LSR                       
                    CLC                       
                    ADC.W #$3000              
                    XBA                       
                    STA $02                   
                    LDA $00                   
                    LSR                       
                    LSR                       
                    LSR                       
                    SEP #$20                  ; Accum (8 bit) 
                    AND.B #$F8                
                    STA.W $1B83               
                    LDA $00                   
                    AND.B #$3E                
                    ASL                       
                    ASL                       
                    STA.W $1B82               
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W #$4000              
                    STA $0C                   
                    LDA.W #$EFFF              
                    STA $0A                   
                    LDA.W $1B84               
                    CMP.W #$0900              
                    BCC ADDR_04E74F           
                    JSR.W ADDR_04E76C         
                    JMP.W ADDR_04E752         
ADDR_04E74F:        JSR.W ADDR_04E824         
ADDR_04E752:        LDA.W #$00FF              
                    STA.L $7F837D,X           
                    TXA                       
                    STA.L $7F837B             
                    JSR.W ADDR_04E496         
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDA.B #$15                
                    STA.W $1DFC               ; / Play sound effect 
                    INC.W $1B86               
                    RTS                       ; Return 

ADDR_04E76C:        LDA.W #$0001              ; Index (16 bit) Accum (16 bit) 
                    STA $06                   
                    LDA.L $7F837B             
                    TAX                       
ADDR_04E776:        LDA $02                   
                    STA.L $7F837D,X           
                    INX                       
                    INX                       
                    LDY.W #$0300              
                    LDA $03                   
                    AND.W #$001F              
                    STA $08                   
                    LDA.W #$0020              
                    SEC                       
                    SBC $08                   
                    STA $08                   
                    CMP.W #$0001              
                    BNE ADDR_04E79B           
                    LDA $08                   
                    ASL                       
                    DEC A                     
                    XBA                       
                    TAY                       
ADDR_04E79B:        TYA                       
                    STA.L $7F837D,X           
                    INX                       
                    INX                       
                    LDA.W #$0001              
                    STA $04                   
                    LDY $00                   
ADDR_04E7A9:        LDA [$0C],Y               
                    AND $0A                   
                    STA.L $7F837D,X           
                    INX                       
                    INX                       
                    INY                       
                    INY                       
                    TYA                       
                    AND.W #$003F              
                    BNE ADDR_04E7E5           
                    LDA $04                   
                    BEQ ADDR_04E7E5           
                    DEY                       
                    TYA                       
                    AND.W #$FFC0              
                    CLC                       
                    ADC.W #$0800              
                    TAY                       
                    LDA $02                   
                    XBA                       
                    AND.W #$3BE0              
                    CLC                       
                    ADC.W #$0400              
                    XBA                       
                    STA.L $7F837D,X           
                    INX                       
                    INX                       
                    LDA $08                   
                    ASL                       
                    DEC A                     
                    XBA                       
                    STA.L $7F837D,X           
                    INX                       
                    INX                       
ADDR_04E7E5:        DEC $04                   
                    BPL ADDR_04E7A9           
                    LDA $02                   
                    XBA                       
                    CLC                       
                    ADC.W #$0020              
                    XBA                       
                    STA $02                   
                    LDA $00                   
                    TAY                       
                    CLC                       
                    ADC.W #$0040              
                    STA $00                   
                    AND.W #$07C0              
                    BNE ADDR_04E81C           
                    TYA                       
                    AND.W #$F83F              
                    CLC                       
                    ADC.W #$1000              
                    STA $00                   
                    LDA $02                   
                    XBA                       
                    SEC                       
                    SBC.W #$0020              
                    AND.W #$341F              
                    CLC                       
                    ADC.W #$0800              
                    XBA                       
                    STA $02                   
ADDR_04E81C:        DEC $06                   
                    BMI ADDR_04E823           
                    JMP.W ADDR_04E776         
ADDR_04E823:        RTS                       ; Return 

ADDR_04E824:        LDA.W #$0005              
                    STA $06                   
                    LDA.L $7F837B             
                    TAX                       
ADDR_04E82E:        LDA $02                   
                    STA.L $7F837D,X           
                    INX                       
                    INX                       
                    LDY.W #$0B00              
                    LDA $03                   
                    AND.W #$001F              
                    STA $08                   
                    LDA.W #$0020              
                    SEC                       
                    SBC $08                   
                    STA $08                   
                    CMP.W #$0006              
                    BCS ADDR_04E85B           
                    LDA $08                   
                    ASL                       
                    DEC A                     
                    XBA                       
                    TAY                       
                    LDA.W #$0006              
                    SEC                       
                    SBC $08                   
                    STA $08                   
ADDR_04E85B:        TYA                       
                    STA.L $7F837D,X           
                    INX                       
                    INX                       
                    LDA.W #$0005              
                    STA $04                   
                    LDY $00                   
ADDR_04E869:        LDA [$0C],Y               
                    AND $0A                   
                    STA.L $7F837D,X           
                    INX                       
                    INX                       
                    INY                       
                    INY                       
                    TYA                       
                    AND.W #$003F              
                    BNE ADDR_04E8A5           
                    LDA $04                   
                    BEQ ADDR_04E8A5           
                    DEY                       
                    TYA                       
                    AND.W #$FFC0              
                    CLC                       
                    ADC.W #$0800              
                    TAY                       
                    LDA $02                   
                    XBA                       
                    AND.W #$3BE0              
                    CLC                       
                    ADC.W #$0400              
                    XBA                       
                    STA.L $7F837D,X           
                    INX                       
                    INX                       
                    LDA $08                   
                    ASL                       
                    DEC A                     
                    XBA                       
                    STA.L $7F837D,X           
                    INX                       
                    INX                       
ADDR_04E8A5:        DEC $04                   
                    BPL ADDR_04E869           
                    LDA $02                   
                    XBA                       
                    CLC                       
                    ADC.W #$0020              
                    XBA                       
                    STA $02                   
                    LDA $00                   
                    TAY                       
                    CLC                       
                    ADC.W #$0040              
                    STA $00                   
                    AND.W #$07C0              
                    BNE ADDR_04E8DC           
                    TYA                       
                    AND.W #$F83F              
                    CLC                       
                    ADC.W #$1000              
                    STA $00                   
                    LDA $02                   
                    XBA                       
                    SEC                       
                    SBC.W #$0020              
                    AND.W #$341F              
                    CLC                       
                    ADC.W #$0800              
                    XBA                       
                    STA $02                   
ADDR_04E8DC:        DEC $06                   
                    BMI ADDR_04E8E3           
                    JMP.W ADDR_04E82E         
ADDR_04E8E3:        RTS                       ; Return 


DATA_04E8E4:        .db $06,$06,$06,$06,$06,$06,$06,$06
                    .db $14,$14,$14,$14,$14,$1D,$1D,$1D
                    .db $1D,$12,$12,$12,$1C,$2F,$2F,$2F
                    .db $2F,$2F,$34,$34,$34,$47,$4E,$4E
                    .db $01,$0F,$24,$24,$6C,$0F,$0F,$54
                    .db $55,$57,$58,$5D

DATA_04E910:        .db $00,$00,$00,$00,$00,$00,$01,$01
                    .db $00,$01,$01,$01,$01,$01,$01,$01
                    .db $00,$01,$01,$00,$00,$01,$01,$01
                    .db $01,$01,$01,$01,$01,$00,$01,$00
                    .db $00,$01,$01,$01,$01,$01,$00,$00
                    .db $00,$00,$00,$00

DATA_04E93C:        .db $15,$02,$35,$02,$45,$02,$55,$02
                    .db $65,$02,$75,$02,$14,$11,$94,$10
                    .db $A9,$00,$A4,$05,$24,$05,$28,$07
                    .db $A4,$06,$A8,$01,$AC,$01,$B0,$01
                    .db $3C,$00,$00,$29,$80,$28,$10,$05
                    .db $54,$01,$30,$18,$B0,$18,$2E,$19
                    .db $2A,$19,$26,$19,$24,$18,$20,$18
                    .db $1C,$18,$97,$05,$EC,$2A,$7B,$05
                    .db $12,$02,$94,$31,$A0,$32,$20,$33
                    .db $16,$1D,$14,$31,$25,$06,$F0,$01
                    .db $F0,$01,$04,$03,$04,$03,$27,$02
DATA_04E994:        .db $68,$00,$24,$00,$24,$00,$25,$00
                    .db $00,$00,$81,$00,$38,$09,$28,$09
                    .db $66,$00,$9C,$09,$28,$09,$F8,$09
                    .db $FC,$09,$98,$09,$98,$09,$28,$09
                    .db $66,$00,$38,$09,$28,$09,$66,$00
                    .db $68,$00,$80,$0A,$84,$0A,$88,$0A
                    .db $98,$09,$98,$09,$94,$09,$98,$09
                    .db $8C,$0A,$66,$00,$84,$03,$66,$00
                    .db $79,$00,$A8,$0A,$38,$09,$38,$09
                    .db $A0,$09,$30,$0A,$69,$00,$5F,$00
                    .db $5F,$00,$5F,$00,$5F,$00,$5F,$00

ADDR_04E9EC:        LDA.W $1DEA               ; Index (8 bit) Accum (8 bit) 
                    STA $0F                   
ADDR_04E9F1:        LDX.B #$2B                
ADDR_04E9F3:        CMP.L DATA_04E8E4,X       
                    BEQ ADDR_04EA25           
ADDR_04E9F9:        DEX                       
                    BPL ADDR_04E9F3           
                    LDA.W $1B86               
                    BEQ ADDR_04EA24           
                    STZ.W $1B86               
                    INC.W $13D9               
                    LDA.W $1DEA               
                    AND.B #$07                
                    TAX                       
                    LDA.W $1DEA               
                    LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W $1F02,Y             
                    ORA.L DATA_04E44B,X       
                    STA.W $1F02,Y             
                    INC.W $1F2E               
                    STZ.W $1DE9               
ADDR_04EA24:        RTS                       ; Return 

ADDR_04EA25:        PHX                       
                    LDA.L DATA_04E910,X       
                    STA $02                   
                    TXA                       
                    ASL                       
                    TAX                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA.L DATA_04E994,X       
                    STA $00                   
                    LDA.L DATA_04E93C,X       
                    STA $04                   
                    LDA $02                   
                    AND.W #$0001              
                    BEQ ADDR_04EA4E           
                    REP #$10                  ; Index (16 bit) 
                    LDY $00                   
                    JSR.W ADDR_04E4A9         
                    JMP.W ADDR_04EA5A         
ADDR_04EA4E:        SEP #$20                  ; Accum (8 bit) 
                    REP #$10                  ; Index (16 bit) 
                    LDX $04                   
                    LDA $00                   
                    STA.L $7EC800,X           
ADDR_04EA5A:        SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    PLX                       
                    LDA $0F                   
                    JMP.W ADDR_04E9F9         
ADDR_04EA62:        STZ.W $1495               
                    STZ.W $1494               
                    LDX.B #$6F                
ADDR_04EA6A:        LDA.W $0703,X             
                    STA.W $0907,X             
                    STZ.W $0979,X             
                    DEX                       
                    BPL ADDR_04EA6A           
                    LDX.B #$6F                
ADDR_04EA78:        LDY.B #$10                
ADDR_04EA7A:        LDA.W $0783,X             
                    STA.W $0907,X             
                    DEX                       
                    DEY                       
                    BNE ADDR_04EA7A           
                    TXA                       
                    SEC                       
                    SBC.B #$10                
                    TAX                       
                    BPL ADDR_04EA78           
ADDR_04EA8B:        REP #$20                  ; Accum (16 bit) 
                    LDA.W #$0070              
                    STA.W $0905               
                    LDA.W #$C070              
                    STA.W $0977               
                    SEP #$20                  ; Accum (8 bit) 
                    STZ.W $09E9               
                    LDA.B #$03                
                    STA.W $0680               
                    RTS                       ; Return 

ADDR_04EAA4:        LDA.W $1495               
                    CMP.B #$40                
                    BCC ADDR_04EAC9           
                    INC.W $1B86               
                    JSR.W ADDR_04EE30         
                    JSR.W ADDR_04E496         
                    REP #$20                  ; Accum (16 bit) 
                    INC.W $1DEB               
                    LDA.W $1DEB               
                    CMP.W $1DED               
                    SEP #$20                  ; Accum (8 bit) 
                    BCS ADDR_04EAC8           
                    LDA.B #$03                
                    STA.W $1B86               
ADDR_04EAC8:        RTS                       ; Return 

ADDR_04EAC9:        JSR.W ADDR_04EC67         
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDY.W #$008C              
                    LDX.W #$0006              
                    LDA.W $1B84               
                    CMP.W #$0900              
                    BCC ADDR_04EAE2           
                    LDY.W #$000C              
                    LDX.W #$0002              
ADDR_04EAE2:        STX $05                   
                    TAX                       
                    SEP #$20                  ; Accum (8 bit) 
ADDR_04EAE7:        LDA $05                   
                    STA $03                   
                    LDA $00                   
ADDR_04EAED:        STA $02                   
                    LDA $01                   
                    STA.W $0351,Y             
                    LDA.L DATA_0C8000,X       
                    STA.W $0352,Y             
                    LDA.L $7F0000,X           
                    AND.B #$C0                
                    STA $04                   
                    LDA.L $7F0000,X           
                    AND.B #$1C                
                    LSR                       
                    ORA $04                   
                    ORA.B #$11                
                    STA.W $0353,Y             
                    LDA $02                   
                    STA.W $0350,Y             
                    CLC                       
                    ADC.B #$08                
                    INX                       
                    DEY                       
                    DEY                       
                    DEY                       
                    DEY                       
                    DEC $03                   
                    BNE ADDR_04EAED           
                    LDA $01                   
                    CLC                       
                    ADC.B #$08                
                    STA $01                   
                    CPY.W #$FFFC              
                    BNE ADDR_04EAE7           
                    SEP #$10                  ; Index (8 bit) 
                    LDX.B #$23                
ADDR_04EB32:        STZ.W $0474,X             
                    DEX                       
                    BPL ADDR_04EB32           
                    LDY.B #$08                
                    LDX.W $0DB3               
                    LDA.W $1F11,X             
                    CMP.B #$03                
                    BNE ADDR_04EB46           
                    LDY.B #$01                
ADDR_04EB46:        STY $8A                   
ADDR_04EB48:        LDA.W $1495               
                    JSL.L ADDR_00B006         
                    DEC $8A                   
                    BNE ADDR_04EB48           
                    JMP.W ADDR_04EA8B         

DATA_04EB56:        .db $F5,$11,$F2,$15,$F5,$11,$F3,$14
                    .db $F5,$11,$F3,$14,$F6,$10,$F4,$13
                    .db $F7,$0F,$F5,$12,$F8,$0E,$F7,$11
                    .db $FA,$0D,$F9,$10,$FC,$0C,$FB,$0D
                    .db $FF,$0A,$FE,$0B,$01,$07,$01,$07
                    .db $00,$08,$00,$08

DATA_04EB82:        .db $F8,$F8,$11,$12,$F8,$F8,$10,$11
                    .db $F8,$F8,$10,$11,$F9,$F9,$0F,$10
                    .db $FA,$FA,$0E,$0F,$FB,$FB,$0C,$0D
                    .db $FC,$FC,$0B,$0B,$FE,$FE,$0A,$0A
                    .db $00,$00,$08,$08,$01,$01,$07,$07
                    .db $00,$00,$08,$08

DATA_04EBAE:        .db $F6,$B6,$76,$36,$F6,$B6,$76,$36
                    .db $36,$76,$B6,$F6,$36,$76,$B6,$F6
                    .db $36,$36,$36,$36,$36,$36,$36,$36
                    .db $36,$36,$36,$36,$36,$36,$36,$36
                    .db $36,$36,$36,$36,$36,$36,$36,$36
                    .db $30,$70,$B0,$F0

DATA_04EBDA:        .db $22,$23,$32,$33,$32,$23,$22

DATA_04EBE1:        .db $73,$73,$72,$72,$5F,$5F,$28,$28
                    .db $28,$28

ADDR_04EBEB:        DEC.W $1B84               
                    BPL ADDR_04EBF4           
                    INC.W $1B86               
                    RTS                       ; Return 

ADDR_04EBF4:        LDA.W $1B84               
                    LDY.W $1B86               
                    CPY.B #$01                
                    BEQ ADDR_04EC17           
                    CMP.B #$10                
                    BNE ADDR_04EC07           
                    PHA                       
                    JSR.W ADDR_04ED83         
                    PLA                       
ADDR_04EC07:        LSR                       
                    LSR                       
                    TAX                       
                    LDA.W DATA_04EBDA,X       
                    STA $02                   
                    JSR.W ADDR_04EC67         
                    LDX.B #$28                
                    JMP.W ADDR_04EC2E         
ADDR_04EC17:        CMP.B #$18                
                    BNE ADDR_04EC20           
                    PHA                       
                    JSR.W ADDR_04EEAA         
                    PLA                       
ADDR_04EC20:        AND.B #$FC                
                    TAX                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_04EBE1,Y       
                    STA $02                   
                    JSR.W ADDR_04EC67         
ADDR_04EC2E:        LDA.B #$03                
                    STA $03                   
                    LDY.B #$00                
ADDR_04EC34:        LDA $00                   
                    CLC                       
                    ADC.W DATA_04EB56,X       
                    STA.W $0280,Y             
                    LDA $01                   
                    CLC                       
                    ADC.W DATA_04EB82,X       
                    STA.W $0281,Y             
                    LDA $02                   
                    STA.W $0282,Y             
                    LDA.W DATA_04EBAE,X       
                    STA.W $0283,Y             
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    INX                       
                    DEC $03                   
                    BPL ADDR_04EC34           
                    STZ.W $0440               
                    STZ.W $0441               
                    STZ.W $0442               
                    STZ.W $0443               
                    RTS                       ; Return 

ADDR_04EC67:        LDA.W $1B82               
                    SEC                       
                    SBC $1E                   
                    STA $00                   
                    LDA.W $1B83               
                    CLC                       
                    SBC $20                   
                    STA $01                   
                    RTS                       ; Return 

ADDR_04EC78:        LDA.B #$7E                
                    STA $0F                   
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.W #$C800              
                    STA $0D                   
                    LDA.W $1DEA               
                    AND.W #$00FF              
                    ASL                       
                    TAX                       
                    LDA.L DATA_04D85D,X       
                    TAY                       
                    LDX.W #$0015              
                    SEP #$20                  ; Accum (8 bit) 
                    LDA [$0D],Y               
ADDR_04EC97:        CMP.L DATA_04DA1D,X       
                    BEQ ADDR_04ECA8           
                    DEX                       
                    BPL ADDR_04EC97           
                    SEP #$10                  ; Index (8 bit) 
                    LDA.B #$07                
                    STA.W $1B86               
                    RTS                       ; Return 

ADDR_04ECA8:        SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDA.B #$01                
                    STA.W $1DFC               ; / Play sound effect 
                    INC.W $1B86               
                    LDA.W $1DEA               
                    AND.B #$FF                
                    ASL                       
                    TAX                       
                    LDA.L DATA_04D85D,X       
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    STA.W $1B82               
                    LDA.L DATA_04D85D,X       
                    AND.B #$F0                
                    STA.W $1B83               
                    LDA.B #$1C                
                    STA.W $1B84               
                    RTS                       ; Return 


DATA_04ECD3:        .db $86,$99,$86,$19,$86,$D9,$86,$59
                    .db $96,$99,$96,$19,$96,$D9,$96,$59
                    .db $86,$9D,$86,$1D,$86,$DD,$86,$5D
                    .db $96,$9D,$96,$1D,$96,$DD,$96,$5D
                    .db $86,$99,$86,$19,$86,$D9,$86,$59
                    .db $96,$99,$96,$19,$96,$D9,$96,$59
                    .db $86,$9D,$86,$1D,$86,$DD,$86,$5D
                    .db $96,$9D,$96,$1D,$96,$DD,$96,$5D
                    .db $88,$15,$98,$15,$89,$15,$99,$15
                    .db $A4,$11,$B4,$11,$A5,$11,$B5,$11
                    .db $22,$11,$90,$11,$22,$11,$91,$11
                    .db $C2,$11,$D2,$11,$C3,$11,$D3,$11
                    .db $A6,$11,$B6,$11,$A7,$11,$B7,$11
                    .db $82,$19,$92,$19,$83,$19,$93,$19
                    .db $C8,$19,$F8,$19,$C9,$19,$F9,$19
                    .db $80,$1C,$90,$1C,$81,$1C,$90,$5C
                    .db $80,$14,$90,$14,$81,$14,$90,$54
                    .db $A2,$11,$B2,$11,$A3,$11,$B3,$11
                    .db $82,$1D,$92,$1D,$83,$1D,$93,$1D
                    .db $86,$99,$86,$19,$86,$D9,$86,$59
                    .db $86,$99,$86,$19,$86,$D9,$86,$59
                    .db $A8,$11,$B8,$11,$A9,$11,$B9,$11

ADDR_04ED83:        LDA.B #$7E                
                    STA $0F                   
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.W #$C800              
                    STA $0D                   
                    LDA.W $1DEA               
                    AND.W #$00FF              
                    ASL                       
                    TAX                       
                    LDA.L DATA_04D85D,X       
                    TAY                       
                    LDX.W #$0015              
                    SEP #$20                  ; Accum (8 bit) 
                    LDA [$0D],Y               
ADDR_04EDA2:        CMP.L DATA_04DA1D,X       
                    BEQ ADDR_04EDAB           
                    DEX                       
                    BNE ADDR_04EDA2           
ADDR_04EDAB:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    STX $0E                   
                    LDA.W $1DEA               
                    AND.W #$00FF              
                    ASL                       
                    TAX                       
                    LDA.L DATA_04D93D,X       
                    STA $00                   
                    LDA.L DATA_04D85D,X       
                    TAX                       
                    PHX                       
                    LDX $0E                   
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.L DATA_04DA33,X       
                    PLX                       
                    STA.L $7EC800,X           
                    LDA.B #$04                
                    STA $0C                   
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W #$ECD3              
                    STA $0A                   
                    LDA $0E                   
                    ASL                       
                    ASL                       
                    ASL                       
                    TAY                       
                    LDA.L $7F837B             
                    TAX                       
ADDR_04EDE6:        LDA $00                   
                    STA.L $7F837D,X           
                    CLC                       
                    ADC.W #$2000              
                    STA.L $7F8385,X           
                    LDA.W #$0300              
                    STA.L $7F837F,X           
                    STA.L $7F8387,X           
                    LDA [$0A],Y               
                    STA.L $7F8381,X           
                    INY                       
                    INY                       
                    LDA [$0A],Y               
                    STA.L $7F8389,X           
                    INY                       
                    INY                       
                    LDA [$0A],Y               
                    STA.L $7F8383,X           
                    INY                       
                    INY                       
                    LDA [$0A],Y               
                    STA.L $7F838B,X           
                    LDA.W #$00FF              
                    STA.L $7F838D,X           
                    TXA                       
                    CLC                       
                    ADC.W #$0010              
                    STA.L $7F837B             
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    RTS                       ; Return 

ADDR_04EE30:        SEP #$20                  ; Accum (8 bit) 
                    LDA.B #$7F                
                    STA $0E                   
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.W $1DEB               
                    ASL                       
                    ASL                       
                    TAX                       
                    LDA.L DATA_04DD8F,X       
                    STA $00                   
                    AND.W #$1FFF              
                    LSR                       
                    CLC                       
                    ADC.W #$3000              
                    XBA                       
                    STA $02                   
                    LDA.W #$4000              
                    STA $0C                   
                    LDA.W #$FFFF              
                    STA $0A                   
                    LDA.L DATA_04DD8D,X       
                    CMP.W #$0900              
                    BCC ADDR_04EE68           
                    JSR.W ADDR_04E76C         
                    JMP.W ADDR_04EE6B         
ADDR_04EE68:        JSR.W ADDR_04E824         
ADDR_04EE6B:        LDA.W #$00FF              
                    STA.L $7F837D,X           
                    TXA                       
                    STA.L $7F837B             
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    RTS                       ; Return 


DATA_04EE7A:        .db $22,$01,$82,$1C,$22,$01,$83,$1C
                    .db $22,$01,$82,$14,$22,$01,$83,$14
                    .db $EA,$01,$EA,$01,$EA,$C1,$EA,$C1
                    .db $EA,$01,$EA,$01,$EA,$C1,$EA,$C1
                    .db $22,$01,$22,$01,$22,$01,$22,$01
                    .db $8A,$15,$9A,$15,$8B,$15,$9B,$15

ADDR_04EEAA:        SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDA.B #$7E                
                    STA $0F                   
                    LDA.B #$04                
                    STA $0C                   
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.W #$C800              
                    STA $0D                   
                    LDA.W #$EE7A              
                    STA $0A                   
                    LDA.W $13D1               
                    AND.W #$00FF              
                    ASL                       
                    TAX                       
                    LDA.L DATA_04E587,X       
                    STA $00                   
                    LDA.L $7F837B             
                    TAX                       
                    LDA.W $13D0               
                    AND.W #$00FF              
                    CMP.W #$0003              
                    BMI ADDR_04EF27           
                    ASL                       
                    ASL                       
                    ASL                       
                    TAY                       
                    LDA $00                   
                    STA.L $7F837D,X           
                    CLC                       
                    ADC.W #$2000              
                    STA.L $7F8385,X           
                    XBA                       
                    CLC                       
                    ADC.W #$0020              
                    XBA                       
                    STA $00                   
                    LDA.W #$0300              
                    STA.L $7F837F,X           
                    STA.L $7F8387,X           
                    LDA [$0A],Y               
                    STA.L $7F8381,X           
                    INY                       
                    INY                       
                    LDA [$0A],Y               
                    STA.L $7F8389,X           
                    INY                       
                    INY                       
                    LDA [$0A],Y               
                    STA.L $7F8383,X           
                    INY                       
                    INY                       
                    LDA [$0A],Y               
                    STA.L $7F838B,X           
                    TXA                       
                    CLC                       
                    ADC.W #$0010              
                    TAX                       
ADDR_04EF27:        LDA.W $13D0               
                    AND.W #$00FF              
                    CMP.W #$0002              
                    BPL ADDR_04EF38           
                    ASL                       
                    ASL                       
                    ASL                       
                    TAY                       
                    BRA ADDR_04EF3B           
ADDR_04EF38:        LDY.W #$0028              
ADDR_04EF3B:        JMP.W ADDR_04EDE6         

DATA_04EF3E:        .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
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
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF

DATA_04F280:        .db $00,$D8,$28,$D0,$30,$D8,$28,$00
DATA_04F288:        .db $D0,$D8,$D8,$00,$00,$28,$28,$30

ADDR_04F290:        LDY.W $1439               ; Index (8 bit) Accum (8 bit) 
                    CPY.B #$0C                
                    BCC ADDR_04F29B           
                    STZ.W $13D2               
                    RTS                       ; Return 

ADDR_04F29B:        LDA.W $1437               
                    BNE ADDR_04F314           
                    CPY.B #$08                
                    BCS ADDR_04F30C           
                    LDA.B #$1C                
                    STA.W $1DFC               ; / Play sound effect 
                    LDA.B #$07                
                    STA $00                   
                    LDX.W $1436               
ADDR_04F2B0:        LDY.W $0DD6               
                    LDA.W $1F17,Y             
                    STA.L $7EB978,X           
                    LDA.W $1F18,Y             
                    STA.L $7EB900,X           
                    LDA.W $1F19,Y             
                    STA.L $7EB9A0,X           
                    LDA.W $1F1A,Y             
                    STA.L $7EB928,X           
                    LDA.B #$00                
                    STA.L $7EB9C8,X           
                    STA.L $7EB950,X           
                    LDY $00                   
                    LDA.W DATA_04F280,Y       
                    STA.L $7EB9F0,X           
                    LDA.W DATA_04F288,Y       
                    STA.L $7EBA18,X           
                    LDA.B #$D0                
                    STA.L $7EBA40,X           
                    INX                       
                    DEC $00                   
                    BPL ADDR_04F2B0           
                    CPX.B #$28                
                    BCC ADDR_04F309           
                    LDA.W $1438               
                    CLC                       
                    ADC.B #$20                
                    CMP.B #$A0                
                    BCC ADDR_04F304           
                    LDA.B #$00                
ADDR_04F304:        STA.W $1438               
                    LDX.B #$00                
ADDR_04F309:        STX.W $1436               
ADDR_04F30C:        LDA.B #$10                
                    STA.W $1437               
                    INC.W $1439               
ADDR_04F314:        DEC.W $1437               
                    LDA.W $1438               
                    STA $0F                   
                    LDX.B #$00                
ADDR_04F31E:        PHX                       
                    LDY.B #$00                
                    JSR.W ADDR_04F39C         
                    JSR.W ADDR_04F397         
                    JSR.W ADDR_04F397         
                    PLX                       
                    LDA.L $7EBA40,X           
                    CLC                       
                    ADC.B #$01                
                    BMI ADDR_04F33A           
                    CMP.B #$40                
                    BCC ADDR_04F33A           
                    LDA.B #$40                
ADDR_04F33A:        STA.L $7EBA40,X           
                    LDA.L $7EB950,X           
                    XBA                       
                    LDA.L $7EB9C8,X           
                    REP #$20                  ; Accum (16 bit) 
                    CLC                       
                    ADC $02                   
                    STA $02                   
                    SEP #$20                  ; Accum (8 bit) 
                    XBA                       
                    ORA $01                   
                    BNE ADDR_04F378           
                    LDY $0F                   
                    XBA                       
                    STA.W $0341,Y             
                    LDA $00                   
                    STA.W $0340,Y             
                    LDA.B #$E6                
                    STA.W $0342,Y             
                    LDA.W $13D2               
                    DEC A                     
                    ASL                       
                    ORA.B #$30                
                    STA.W $0343,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$02                
                    STA.W $0470,Y             
ADDR_04F378:        LDA $0F                   
                    CLC                       
                    ADC.B #$04                
                    CMP.B #$A0                
                    BCC ADDR_04F383           
                    LDA.B #$00                
ADDR_04F383:        STA $0F                   
                    INX                       
                    CPX.W $1436               
                    BCC ADDR_04F31E           
                    LDA.W $1439               
                    CMP.B #$05                
                    BCC ADDR_04F396           
                    CPX.B #$28                
                    BCC ADDR_04F31E           
ADDR_04F396:        RTS                       ; Return 

ADDR_04F397:        TXA                       
                    CLC                       
                    ADC.B #$28                
                    TAX                       
ADDR_04F39C:        PHY                       
                    LDA.L $7EB9F0,X           
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    CLC                       
                    ADC.L $7EBA68,X           
                    STA.L $7EBA68,X           
                    LDA.L $7EB9F0,X           
                    PHP                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LDY.B #$00                
                    PLP                       
                    BPL ADDR_04F3BF           
                    ORA.B #$F0                
                    DEY                       
ADDR_04F3BF:        ADC.L $7EB978,X           
                    STA.L $7EB978,X           
                    XBA                       
                    TYA                       
                    ADC.L $7EB900,X           
                    STA.L $7EB900,X           
                    XBA                       
                    PLY                       
                    REP #$20                  ; Accum (16 bit) 
                    SEC                       
                    SBC.W $001A,Y             
                    SEC                       
                    SBC.W #$0008              
                    STA.W $0000,Y             
                    SEP #$20                  ; Accum (8 bit) 
                    INY                       
                    INY                       
                    RTS                       ; Return 

ADDR_04F3E5:        DEC A                     
                    JSL.L ExecutePtr          

Ptrs04F3EA:         .dw ADDR_04F3FF           
                    .dw ADDR_04F415           
                    .dw ADDR_04F513           
                    .dw ADDR_04F415           
                    .dw ADDR_04F3FF           
                    .dw ADDR_04F415           
                    .dw ADDR_04F3FA           
                    .dw ADDR_04F415           

ADDR_04F3FA:        JSL.L ADDR_009BA8         
                    RTS                       ; Return 

ADDR_04F3FF:        LDA.B #$22                
                    STA.W $1DFC               ; / Play sound effect 
                    INC.W $1B87               
ADDR_04F407:        STZ $41                   
                    STZ $42                   
                    STZ $43                   
                    STZ.W $0D9F               
                    RTS                       ; Return 


DATA_04F411:        .db $04,$FC

DATA_04F413:        .db $68,$00

ADDR_04F415:        .db $A2,$00,$AD,$B4,$0D,$CD,$B5,$0D
                    .db $10,$01,$E8

                    STX.W $1B8A               
                    LDX.W $1B88               
                    LDA.W $1B89               
                    CMP.L DATA_04F413,X       
                    BNE ADDR_04F44B           
                    INC.W $1B87               
                    LDA.W $1B87               
                    CMP.B #$07                
                    BNE ADDR_04F43D           
                    LDY.B #$1E                
                    STY $12                   
ADDR_04F43D:        DEC A                     
                    AND.B #$03                
                    BNE ADDR_04F44A           
                    STZ.W $1B87               
                    STZ.W $1B88               
                    BRA ADDR_04F407           
ADDR_04F44A:        RTS                       ; Return 

ADDR_04F44B:        CLC                       
                    ADC.L DATA_04F411,X       
                    STA.W $1B89               
                    CLC                       
                    ADC.B #$80                
                    XBA                       
                    REP #$10                  ; Index (16 bit) 
                    LDX.W #$016E              
                    LDA.B #$FF                
ADDR_04F45E:        STA.W $04F0,X             
                    STZ.W $04F1,X             
                    DEX                       
                    DEX                       
                    BPL ADDR_04F45E           
                    SEP #$10                  ; Index (8 bit) 
                    LDA.W $1B89               
                    LSR                       
                    ADC.W $1B89               
                    LSR                       
                    AND.B #$FE                
                    TAX                       
                    LDA.B #$80                
                    SEC                       
                    SBC.W $1B89               
                    REP #$20                  ; Accum (16 bit) 
                    LDY.B #$48                
ADDR_04F47F:        STA.W $0548,Y             
                    STA.W $0590,X             
                    DEY                       
                    DEY                       
                    DEX                       
                    DEX                       
                    BPL ADDR_04F47F           
                    STZ.W $0701               
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.B #$22                
                    STA $41                   
                    LDA.B #$20                
                    JMP.W ADDR_04DB95         

DATA_04F499:        .db $51,$C4,$40,$24,$FC,$38,$52,$04
                    .db $40,$2C,$FC,$38,$52,$2F,$40,$02
                    .db $FC,$38,$52,$48,$40,$1C,$FC,$38
                    .db $FF

DATA_04F4B2:        .db $52,$49,$00,$09,$16,$28,$0A,$28
                    .db $1B,$28,$12,$28,$18,$28,$52,$52
                    .db $00,$09,$15,$28,$1E,$28,$12,$28
                    .db $10,$28,$12,$28,$52,$0B,$00,$05
                    .db $26,$28,$00,$28,$00,$28,$52,$14
                    .db $00,$05,$26,$28,$00,$28,$00,$28
                    .db $52,$0F,$00,$03,$FC,$38,$FC,$38
                    .db $52,$2F,$00,$03,$FC,$38,$FC,$38
                    .db $51,$C9,$00,$03,$85,$29,$85,$69
                    .db $51,$D2,$00,$03,$85,$29,$85,$69
                    .db $FF

DATA_04F503:        .db $7D,$38,$7E,$78

DATA_04F507:        .db $7E,$38,$7D,$78

DATA_04F50B:        .db $7D,$B8,$7E,$F8

DATA_04F50F:        .db $7E,$B8,$7D,$F8

ADDR_04F513:        LDA.W $0DA6               
                    ORA.W $0DA7               
                    AND.B #$10                
                    BEQ ADDR_04F52B           
                    LDX.W $0DB3               
                    LDA.W $0DB4,X             
                    STA.W $0DBE               
                    JSL.L ADDR_009C13         
                    RTS                       ; Return 

ADDR_04F52B:        LDA.W $0DA6               
                    AND.B #$C0                
                    BNE ADDR_04F53B           
                    LDA.W $0DA7               
                    AND.B #$C0                
                    BEQ ADDR_04F56C           
                    EOR.B #$C0                
ADDR_04F53B:        LDX.B #$01                
                    ASL                       
                    BCS ADDR_04F541           
                    DEX                       
ADDR_04F541:        CPX.W $1B8A               
                    BEQ ADDR_04F54B           
                    LDA.B #$18                
                    STA.W $1B8B               
ADDR_04F54B:        STX.W $1B8A               
                    TXA                       
                    EOR.B #$01                
                    TAY                       
                    LDA.W $0DB4,X             
                    BEQ ADDR_04F56C           
                    BMI ADDR_04F56C           
                    LDA.W $0DB4,Y             
                    CMP.B #$62                
                    BPL ADDR_04F56C           
                    INC A                     
                    STA.W $0DB4,Y             
                    DEC.W $0DB4,X             
                    LDA.B #$23                
                    STA.W $1DFC               ; / Play sound effect 
ADDR_04F56C:        REP #$20                  ; Accum (16 bit) 
                    LDA.W #$7848              
                    STA.W $029C               
                    LDA.W #$7890              
                    STA.W $02A0               
                    LDA.W #$340A              
                    STA.W $029E               
                    LDA.W #$360A              
                    STA.W $02A2               
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.B #$02                
                    STA.W $0447               
                    STA.W $0448               
                    JSL.L ADDR_05DBF2         
                    LDY.B #$50                
                    TYA                       
                    CLC                       
                    ADC.L $7F837B             
                    STA.L $7F837B             
                    TAX                       
ADDR_04F5A1:        LDA.W DATA_04F4B2,Y       
                    STA.L $7F837D,X           
                    DEX                       
                    DEY                       
                    BPL ADDR_04F5A1           
                    INX                       
                    REP #$20                  ; Accum (16 bit) 
                    LDY.W $0DB4               
                    BMI ADDR_04F5BF           
                    LDA.W #$38FC              
                    STA.L $7F83C1,X           
                    STA.L $7F83C3,X           
ADDR_04F5BF:        LDY.W $0DB5               
                    BMI ADDR_04F5CF           
                    LDA.W #$38FC              
                    STA.L $7F83C9,X           
                    STA.L $7F83CB,X           
ADDR_04F5CF:        SEP #$20                  ; Accum (8 bit) 
                    INC.W $1B8B               
                    LDA.W $1B8B               
                    AND.B #$18                
                    BEQ ADDR_04F600           
                    LDA.W $1B8A               
                    ASL                       
                    TAY                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W DATA_04F503,Y       
                    STA.L $7F83B1,X           
                    LDA.W DATA_04F507,Y       
                    STA.L $7F83B3,X           
                    LDA.W DATA_04F50B,Y       
                    STA.L $7F83B9,X           
                    LDA.W DATA_04F50F,Y       
                    STA.L $7F83BB,X           
                    SEP #$20                  ; Accum (8 bit) 
ADDR_04F600:        LDA.W $0DB4               
                    JSR.W ADDR_04F60E         
                    TXA                       
                    CLC                       
                    ADC.B #$0A                
                    TAX                       
                    LDA.W $0DB5               
ADDR_04F60E:        INC A                     
                    PHX                       
                    JSL.L ADDR_00974C         
                    TXY                       

Instr04F615:        .db $D0

ADDR_04F616:        .db $02

Instr04F617:        .db $A2

ADDR_04F618:        .db $FC

ADDR_04F619:        TXY                       
ADDR_04F61A:        PLX                       
                    STA.L $7F83A1,X           
                    TYA                       
                    STA.L $7F839F,X           
                    RTS                       ; Return 


DATA_04F625:        .db $00,$00,$01,$E0,$00,$00,$00,$01
                    .db $60,$00,$06,$70,$01,$20,$00,$07
                    .db $38,$00,$8A,$01,$00,$58,$00,$7A
                    .db $00,$08,$88,$01,$18,$00,$09,$48
                    .db $01,$FC,$FF,$00,$80,$00,$00

DATA_04F64C:        .db $01,$00,$50,$00,$40,$01

DATA_04F652:        .db $03,$00,$00,$00,$00,$0A,$40,$00
                    .db $98,$00,$0A,$60,$00,$F8,$00,$0A
                    .db $40,$01,$58

DATA_04F665:        .db $01,$30,$00,$00,$01,$10,$FF,$20
                    .db $00,$70,$FF,$10,$00,$01,$40,$80

ADDR_04F675:        PHB                       
                    PHK                       
                    PLB                       
                    LDX.B #$0C                
                    LDY.B #$4B                
ADDR_04F67C:        LDA.W ADDR_04F616,Y       
                    STA.W $0DE8,X             
                    CMP.B #$01                
                    BEQ ADDR_04F68A           
                    CMP.B #$02                
                    BNE ADDR_04F68F           
ADDR_04F68A:        LDA.B #$40                
                    STA.W $0E58,X             
ADDR_04F68F:        LDA.W Instr04F617,Y       
                    STA.W $0E38,X             
                    LDA.W ADDR_04F618,Y       
                    STA.W $0E68,X             
                    LDA.W ADDR_04F619,Y       
                    STA.W $0E48,X             
                    LDA.W ADDR_04F61A,Y       
                    STA.W $0E78,X             
                    TYA                       
                    SEC                       
                    SBC.B #$05                
                    TAY                       
                    DEX                       
                    BPL ADDR_04F67C           
                    LDX.B #$0D                
ADDR_04F6B1:        STZ.W $0E25,X             
                    LDA.W DATA_04FD22         
                    DEC A                     
                    STA.W $0EB5,X             
                    LDA.W DATA_04F665,X       
ADDR_04F6BE:        PHA                       
                    STX.W $0DDE               
                    JSR.W ADDR_04F853         
                    PLA                       
                    DEC A                     
                    BNE ADDR_04F6BE           
                    INX                       
                    CPX.B #$10                
                    BCC ADDR_04F6B1           
                    PLB                       
                    RTL                       ; Return 


DATA_04F6D0:        .db $70,$7F,$78,$7F,$70,$7F,$78,$7F
DATA_04F6D8:        .db $F0,$FF,$20,$00,$C0,$00,$F0,$FF
                    .db $F0,$FF,$80,$00,$F0,$FF,$00,$00
DATA_04F6E8:        .db $70,$00,$60,$01,$58,$01,$B0,$00
                    .db $60,$01,$60,$01,$70,$00,$60,$01
DATA_04F6F8:        .db $20,$58,$43,$CF,$18,$34,$A2,$5E
DATA_04F700:        .db $07,$05,$06,$07,$04,$06,$07,$05

ADDR_04F708:        LDA.B #$F7                
                    JSR.W ADDR_04F882         
                    BNE ADDR_04F76E           
                    LDY.W $1FFB               
                    BNE ADDR_04F73B           
                    LDA $13                   
                    LSR                       
                    BCC ADDR_04F76E           
                    DEC.W $1FFC               
                    BNE ADDR_04F76E           
                    TAY                       
                    LDA.W ADDR_04F708,Y       
                    AND.B #$07                
                    TAX                       
                    LDA.W DATA_04F6F8,X       
                    STA.W $1FFC               
                    LDY.W DATA_04F700,X       
                    STY.W $1FFB               
                    LDA.B #$08                
                    STA.W $1FFD               
                    LDA.B #$18                
                    STA.W $1DFC               ; / Play sound effect 
ADDR_04F73B:        DEC.W $1FFD               
                    BPL ADDR_04F748           
                    DEC.W $1FFB               
                    LDA.B #$04                
                    STA.W $1FFD               
ADDR_04F748:        TYA                       
                    ASL                       
                    TAY                       
                    LDX.W $0681               
                    LDA.B #$02                
                    STA.W $0682,X             
                    LDA.B #$47                
                    STA.W $0683,X             
                    LDA.W $0753,Y             
                    STA.W $0684,X             
                    LDA.W $0754,Y             
                    STA.W $0685,X             
                    STZ.W $0686,X             
                    TXA                       
                    CLC                       
                    ADC.B #$04                
                    STA.W $0681               
ADDR_04F76E:        LDX.B #$02                
ADDR_04F770:        LDA.W $0DE5,X             
                    BNE ADDR_04F7AB           
                    LDA.B #$05                
                    STA.W $0DE5,X             
                    JSR.W ADDR_04FE5B         
                    AND.B #$07                
                    TAY                       
                    LDA.W DATA_04F6D0,Y       
                    STA.W $0E55,X             
                    TYA                       
                    ASL                       
                    TAY                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA $1A                   
                    CLC                       
                    ADC.W DATA_04F6D8,Y       
                    SEP #$20                  ; Accum (8 bit) 
                    STA.W $0E35,X             
                    XBA                       
                    STA.W $0E65,X             
                    REP #$20                  ; Accum (16 bit) 
                    LDA $1C                   
                    CLC                       
                    ADC.W DATA_04F6E8,Y       
                    SEP #$20                  ; Accum (8 bit) 
                    STA.W $0E45,X             
                    XBA                       
                    STA.W $0E75,X             
ADDR_04F7AB:        DEX                       
                    BPL ADDR_04F770           
                    LDX.B #$04                
ADDR_04F7B0:        TXA                       
                    STA.W $0DE0,X             
                    DEX                       
                    BPL ADDR_04F7B0           
                    LDX.B #$04                
ADDR_04F7B9:        STX $00                   
ADDR_04F7BB:        STX $01                   
                    LDX $00                   
                    LDY.W $0DE0,X             
                    LDA.W $0E45,Y             
                    STA $02                   
                    LDA.W $0E75,Y             
                    STA $03                   
                    LDX $01                   
                    LDY.W $0DDF,X             
                    LDA.W $0E75,Y             
                    XBA                       
                    LDA.W $0E45,Y             
                    REP #$20                  ; Accum (16 bit) 
                    CMP $02                   
                    SEP #$20                  ; Accum (8 bit) 
                    BPL ADDR_04F7ED           
                    PHY                       
                    LDY $00                   
                    LDA.W $0DE0,Y             
                    STA.W $0DDF,X             
                    PLA                       
                    STA.W $0DE0,Y             
ADDR_04F7ED:        DEX                       
                    BNE ADDR_04F7BB           
                    LDX $00                   
                    DEX                       
                    BNE ADDR_04F7B9           
                    LDA.B #$30                
                    STA.W $0DDF               
                    STZ.W $0EF7               
                    LDX.B #$0F                
                    LDY.B #$2D                
ADDR_04F801:        CPX.B #$0D                
                    BCS ADDR_04F80D           
                    LDA.W $0E25,X             
                    BEQ ADDR_04F80D           
                    DEC.W $0E25,X             
ADDR_04F80D:        CPX.B #$05                
                    BCC ADDR_04F819           
                    STX.W $0DDE               
                    JSR.W ADDR_04F853         
                    BRA ADDR_04F825           
ADDR_04F819:        PHX                       
                    LDA.W $0DE0,X             
                    TAX                       
                    STX.W $0DDE               
                    JSR.W ADDR_04F853         
                    PLX                       
ADDR_04F825:        DEX                       
                    BPL ADDR_04F801           
ADDR_04F828:        RTS                       ; Return 


DATA_04F829:        .db $7F,$21,$7F,$7F,$7F,$77,$3F,$F7
                    .db $F7,$00

DATA_04F833:        .db $00,$52,$31,$19,$45,$2A,$03,$8B
                    .db $94,$3C,$78,$0D,$36,$5E,$87,$1F
DATA_04F843:        .db $F4,$F4,$F4,$F4,$F4,$9C,$3C,$48
                    .db $C8,$CC,$A0,$A4,$D8,$DC,$E0,$E4

ADDR_04F853:        JSR.W ADDR_04F87C         
                    BNE ADDR_04F828           
                    LDA.W $0DE5,X             
                    JSL.L ExecutePtr          

Ptrs04F85F:         .dw ADDR_04F828           
                    .dw ADDR_04F8CC           
                    .dw ADDR_04F9B8           
                    .dw ADDR_04FA3E           
                    .dw ADDR_04FAF1           
                    .dw ADDR_04FB37           
                    .dw ADDR_04FB98           
                    .dw ADDR_04FC46           
                    .dw ADDR_04FCE1           
                    .dw ADDR_04FD24           
                    .dw ADDR_04FD70           

DATA_04F875:        .db $80,$40,$20,$10,$08,$04,$02

ADDR_04F87C:        LDY.W $0DE5,X             
                    LDA.W ADDR_04F828,Y       
ADDR_04F882:        STA $00                   
                    LDY.W $13D9               
                    CPY.B #$0A                
                    BNE ADDR_04F892           
                    LDY.W $1DE8               
                    CPY.B #$01                
                    BNE ADDR_04F8A3           
ADDR_04F892:        LDA.W $0DD6               
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W $1F11,Y             
                    TAY                       
                    LDA.W DATA_04F875,Y       
                    AND $00                   
                    BEQ ADDR_04F8A5           
ADDR_04F8A3:        LDA.B #$01                
ADDR_04F8A5:        RTS                       ; Return 


DATA_04F8A6:        .db $01,$01,$03,$01,$01,$01,$01,$02
DATA_04F8AE:        .db $0C,$0C,$12,$12,$12,$12,$0C,$0C
DATA_04F8B6:        .db $10,$00,$08,$00,$20,$00,$20,$00
DATA_04F8BE:        .db $10,$00,$30,$00,$08,$00,$10,$00
DATA_04F8C6:        .db $01,$FF

DATA_04F8C8:        .db $10,$F0

DATA_04F8CA:        .db $10,$F0

ADDR_04F8CC:        JSR.W ADDR_04FE90         
                    CLC                       
                    JSR.W ADDR_04FE00         
                    JSR.W ADDR_04FE62         
                    REP #$20                  ; Accum (16 bit) 
                    LDA $02                   
                    STA $04                   
                    SEP #$20                  ; Accum (8 bit) 
                    JSR.W ADDR_04FE5B         
                    LDX.B #$06                
                    AND.B #$10                
                    BEQ ADDR_04F8E8           
                    INX                       
ADDR_04F8E8:        STX $06                   
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_04F8A6,X       
                    STA $00                   
                    BCC ADDR_04F8F6           
                    INC $01                   
ADDR_04F8F6:        LDA $04                   
                    CLC                       
                    ADC.W DATA_04F8AE,X       
                    STA $02                   
                    LDA $05                   
                    ADC.B #$00                
                    STA $03                   
                    LDA.B #$32                
                    XBA                       
                    LDA.B #$28                
                    JSR.W ADDR_04FB7B         
                    LDX $06                   
                    DEX                       
                    DEX                       
                    BPL ADDR_04F8E8           
                    LDX.W $0DDE               
                    JSR.W ADDR_04FE62         
                    LDA.B #$32                
                    XBA                       
                    LDA.B #$26                
                    JSR.W ADDR_04FB7A         
                    LDA.W $0E15,X             
                    BEQ ADDR_04F928           
                    JMP.W ADDR_04FF2E         
ADDR_04F928:        LDA.W $0E05,X             
                    AND.B #$01                
                    TAY                       
                    LDA.W $0EB5,X             
                    CLC                       
                    ADC.W DATA_04F8C6,Y       
                    STA.W $0EB5,X             
                    CMP.W DATA_04F8CA,Y       
                    BNE ADDR_04F945           
                    LDA.W $0E05,X             
                    EOR.B #$01                
                    STA.W $0E05,X             
ADDR_04F945:        JSR.W ADDR_04FEEF         
                    LDY.W $0DF5,X             ; Accum (16 bit) 
                    LDA.W $0E04,X             
                    ASL                       
                    EOR $00                   
                    BPL ADDR_04F95D           
                    LDA $06                   
                    CMP.W DATA_04F8B6,Y       
                    LDA.W #$0040              
                    BCS ADDR_04F96D           
ADDR_04F95D:        LDA.W $0E04,X             
                    EOR $02                   
                    ASL                       
                    BCC ADDR_04F96D           
                    LDA $08                   
                    CMP.W DATA_04F8BE,Y       
                    LDA.W #$0080              
ADDR_04F96D:        SEP #$20                  ; Accum (8 bit) 
                    BCC ADDR_04F97F           
                    EOR.W $0E05,X             
                    STA.W $0E05,X             
                    JSR.W ADDR_04FE5B         
                    AND.B #$06                
                    STA.W $0DF5,X             
ADDR_04F97F:        TXA                       
                    CLC                       
                    ADC.B #$10                
                    TAX                       
                    LDA.W $0DF5,X             
                    ASL                       
                    JSR.W ADDR_04F993         
                    LDX.W $0DDE               
                    LDA.W $0E05,X             
                    ASL                       
                    ASL                       
ADDR_04F993:        LDY.B #$00                
                    BCS ADDR_04F998           
                    INY                       
ADDR_04F998:        LDA.W $0E95,X             
                    CLC                       
                    ADC.W DATA_04F8C6,Y       
                    CMP.W DATA_04F8C8,Y       
                    BEQ ADDR_04F9A7           
                    STA.W $0E95,X             
ADDR_04F9A7:        RTS                       ; Return 


DATA_04F9A8:        .db $4E,$4F,$5E,$4F

DATA_04F9AC:        .db $08,$07,$04,$07

DATA_04F9B0:        .db $00,$01,$04,$01

DATA_04F9B4:        .db $01,$07,$09,$07

ADDR_04F9B8:        CLC                       
                    JSR.W ADDR_04FE00         
                    JSR.W ADDR_04FEEF         
                    SEP #$20                  ; Accum (8 bit) 
                    LDY.B #$00                
                    LDA $01                   
                    BMI ADDR_04F9C8           
                    INY                       
ADDR_04F9C8:        LDA.W $0E95,X             
                    CLC                       
                    ADC.W DATA_04F8C6,Y       
                    CMP.W DATA_04F8C8,Y       
                    BEQ ADDR_04F9D7           
                    STA.W $0E95,X             
ADDR_04F9D7:        LDY.W $0DD6               
                    LDA.W $1F19,Y             
                    STA.W $0E45,X             
                    LDA.W $1F1A,Y             
                    STA.W $0E75,X             
                    JSR.W ADDR_04FE90         
                    JSR.W ADDR_04FE62         
                    LDA.B #$36                
                    LDY.W $0E95,X             
                    BMI ADDR_04F9F5           
                    ORA.B #$40                
ADDR_04F9F5:        PHA                       
                    XBA                       
                    LDA.B #$4C                
                    JSR.W ADDR_04FB7A         
                    PLA                       
                    XBA                       
                    JSR.W ADDR_04FE5B         
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.B #$03                
                    TAY                       
                    LDA.W DATA_04F9AC,Y       
                    BIT.W $0E95,X             
                    BMI ADDR_04FA12           
                    LDA.W DATA_04F9B0,Y       
ADDR_04FA12:        CLC                       
                    ADC $00                   
                    STA $00                   
                    BCC ADDR_04FA1B           
                    INC $01                   
ADDR_04FA1B:        LDA.W DATA_04F9B4,Y       
                    CLC                       
                    ADC $02                   
                    STA $02                   
                    BCC ADDR_04FA27           
                    INC $03                   
ADDR_04FA27:        LDA.W DATA_04F9A8,Y       
                    CLC                       
                    JMP.W ADDR_04FB7B         

DATA_04FA2E:        .db $70,$50,$B0

DATA_04FA31:        .db $00,$01,$00

DATA_04FA34:        .db $CF,$8F,$7F

DATA_04FA37:        .db $00,$00,$01

DATA_04FA3A:        .db $73,$72,$63,$62

ADDR_04FA3E:        LDA.W $0DF5,X             
                    BNE ADDR_04FA83           
                    LDA.W $13C1               
                    SEC                       
                    SBC.B #$4E                
                    CMP.B #$03                
                    BCS ADDR_04FA82           
                    TAY                       
                    LDA.W DATA_04FA2E,Y       
                    STA.W $0E35,X             
                    LDA.W DATA_04FA31,Y       
                    STA.W $0E65,X             
                    LDA.W DATA_04FA34,Y       
                    STA.W $0E45,X             
                    LDA.W DATA_04FA37,Y       
                    STA.W $0E75,X             
                    JSR.W ADDR_04FE5B         
                    LSR                       
                    ROR                       
                    LSR                       
                    AND.B #$40                
                    ORA.B #$12                
                    STA.W $0DF5,X             
                    LDA.B #$24                
                    STA.W $0EB5,X             
                    LDA.B #$0E                
                    STA.W $1DF9               ; / Play sound effect 
ADDR_04FA7D:        LDA.B #$0F                
                    STA.W $0E25,X             
ADDR_04FA82:        RTS                       ; Return 

ADDR_04FA83:        DEC.W $0EB5,X             
                    LDA.W $0EB5,X             
                    CMP.B #$E4                
                    BNE ADDR_04FA90           
                    JSR.W ADDR_04FA7D         
ADDR_04FA90:        JSR.W ADDR_04FE90         
                    LDA.W $0E55,X             
                    ORA.W $0E25,X             
                    BNE ADDR_04FA9E           
                    STZ.W $0DF5,X             
ADDR_04FA9E:        JSR.W ADDR_04FE62         
                    LDA.W $0DF5,X             
                    LDY.B #$08                
                    BIT.W $0EB5,X             
                    BPL ADDR_04FAAF           
                    EOR.B #$C0                
                    LDY.B #$10                
ADDR_04FAAF:        XBA                       
                    TYA                       
                    LDY.B #$4A                
                    AND $13                   
                    BEQ ADDR_04FAB9           
                    LDY.B #$48                
ADDR_04FAB9:        TYA                       
                    JSR.W ADDR_04FB06         
                    JSR.W ADDR_04FE4E         
                    SEC                       
                    SBC.B #$08                
                    STA $02                   
                    BCS ADDR_04FAC9           
                    DEC $03                   
ADDR_04FAC9:        LDA.B #$36                
                    XBA                       
                    LDA.W $0E25,X             
                    BEQ ADDR_04FA82           
                    LSR                       
                    LSR                       
                    PHY                       
                    TAY                       
                    LDA.W DATA_04FA3A,Y       
                    PLY                       
                    PHA                       
                    JSR.W ADDR_04FAED         
                    REP #$20                  ; Accum (16 bit) 
                    LDA $00                   
                    CLC                       
                    ADC.W #$0008              
                    STA $00                   
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.B #$76                
                    XBA                       
                    PLA                       
ADDR_04FAED:        CLC                       
                    JMP.W ADDR_04FB0A         
ADDR_04FAF1:        JSR.W ADDR_04FED7         
                    JSR.W ADDR_04FE62         
                    JSR.W ADDR_04FE5B         
                    LDY.B #$2A                
                    AND.B #$08                
                    BEQ ADDR_04FB02           
                    LDY.B #$2C                
ADDR_04FB02:        LDA.B #$32                
                    XBA                       
                    TYA                       
ADDR_04FB06:        SEC                       
                    LDY.W DATA_04F843,X       
ADDR_04FB0A:        STA.W $0242,Y             
                    XBA                       
                    STA.W $0243,Y             
                    LDA $01                   
                    BNE ADDR_04FB36           
                    LDA $00                   
                    STA.W $0240,Y             
                    LDA $03                   
                    BNE ADDR_04FB36           
                    PHP                       
                    LDA $02                   
                    STA.W $0241,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    PLP                       
                    PHY                       
                    TAY                       
                    ROL                       
                    ASL                       
                    AND.B #$03                
                    STA.W $0430,Y             
                    PLY                       
                    DEY                       
                    DEY                       
                    DEY                       
                    DEY                       
ADDR_04FB36:        RTS                       ; Return 

ADDR_04FB37:        LDA.B #$02                
                    STA.W $0E95,X             
                    LDA.B #$FF                
                    STA.W $0EA5,X             
                    JSR.W ADDR_04FE90         
                    JSR.W ADDR_04FE62         
                    REP #$20                  ; Accum (16 bit) 
                    LDA $00                   
                    CLC                       
                    ADC.W #$0020              
                    CMP.W #$0140              
                    BCS ADDR_04FB5D           
                    LDA $02                   
                    CLC                       
                    ADC.W #$0080              
                    CMP.W #$01A0              
ADDR_04FB5D:        SEP #$20                  ; Accum (8 bit) 
                    BCC ADDR_04FB64           
                    STZ.W $0DE5,X             
ADDR_04FB64:        LDA.B #$32                
                    JSR.W ADDR_04FB77         
                    REP #$20                  ; Accum (16 bit) 
                    LDA $00                   
                    CLC                       
                    ADC.W #$0010              
                    STA $00                   
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.B #$72                
ADDR_04FB77:        XBA                       
                    LDA.B #$44                
ADDR_04FB7A:        SEC                       
ADDR_04FB7B:        LDY.W $0DDF               
                    JSR.W ADDR_04FB0A         
                    STY.W $0DDF               
ADDR_04FB84:        RTS                       ; Return 


DATA_04FB85:        .db $80,$40,$20

DATA_04FB88:        .db $30,$10,$C0

DATA_04FB8B:        .db $01,$01,$01

DATA_04FB8E:        .db $7F,$7F,$8F

DATA_04FB91:        .db $01,$00

DATA_04FB93:        .db $01,$08

DATA_04FB95:        .db $02,$0F,$00

ADDR_04FB98:        LDA.W $0DF5,X             
                    BNE ADDR_04FBD8           
                    LDA.W $13C1               
                    SEC                       
                    SBC.B #$49                
                    CMP.B #$03                
                    BCS ADDR_04FB84           
                    TAY                       
                    STA.W $0EF6               
                    LDA.W $0EF5               
                    AND.W DATA_04FB85,Y       
                    BNE ADDR_04FB84           
                    LDA.W DATA_04FB88,Y       
                    STA.W $0E35,X             
                    LDA.W DATA_04FB8B,Y       
                    STA.W $0E65,X             
                    LDA.W DATA_04FB8E,Y       
                    STA.W $0E45,X             
                    LDA.W DATA_04FB91,Y       
                    STA.W $0E75,X             
                    LDA.B #$02                
                    STA.W $0DF5,X             
                    LDA.B #$F0                
                    STA.W $0E95,X             
                    STZ.W $0E25,X             
ADDR_04FBD8:        JSR.W ADDR_04FE62         
                    LDA.W $0E25,X             
                    BNE ADDR_04FC00           
                    INC.W $0E05,X             
                    JSR.W ADDR_04FEAB         
                    LDY.W $0DF5,X             
                    LDA.W $0E35,X             
                    AND.B #$0F                
                    CMP.W DATA_04FB95,Y       
                    BNE ADDR_04FC00           
                    DEC.W $0DF5,X             
                    LDA.B #$04                
                    STA.W $0E95,X             
                    LDA.B #$60                
                    STA.W $0E25,X             
ADDR_04FC00:        LDA.W DATA_04FB93,Y       
                    LDY.B #$22                
                    AND.W $0E05,X             
                    BNE ADDR_04FC0C           
                    LDY.B #$62                
ADDR_04FC0C:        TYA                       
                    XBA                       
                    LDA.B #$6A                
                    JSR.W ADDR_04FB06         
                    JSR.W ADDR_04FED7         
                    BCS ADDR_04FC1D           
                    ORA.B #$80                
                    STA.W $0EF7               
ADDR_04FC1D:        RTS                       ; Return 


DATA_04FC1E:        .db $38

DATA_04FC1F:        .db $00,$68,$00

DATA_04FC22:        .db $8A

DATA_04FC23:        .db $01,$6A,$00

DATA_04FC26:        .db $01,$02,$03,$04,$03,$02,$01,$00
                    .db $01,$02,$03,$04,$03,$02,$01,$00
DATA_04FC36:        .db $FF,$FF,$FE,$FD,$FD,$FC,$FB,$FB
                    .db $FA,$F9,$F9,$F8,$F7,$F7,$F6,$F5

ADDR_04FC46:        LDA.W $0DD6               
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W $1F11,Y             
                    ASL                       
                    TAY                       
                    LDA.W DATA_04FC1E,Y       
                    STA.W $0E35,X             
                    LDA.W DATA_04FC1F,Y       
                    STA.W $0E65,X             
                    LDA.W DATA_04FC22,Y       
                    STA.W $0E45,X             
                    LDA.W DATA_04FC23,Y       
                    STA.W $0E75,X             
                    LDA $13                   
                    AND.B #$0F                
                    BNE ADDR_04FC7C           
                    LDA.W $0DF5,X             
                    INC A                     
                    CMP.B #$0C                
                    BCC ADDR_04FC79           
                    LDA.B #$00                
ADDR_04FC79:        STA.W $0DF5,X             
ADDR_04FC7C:        LDA.B #$03                
                    STA $04                   
                    LDA $13                   
                    STA $06                   
                    STZ $07                   
                    LDY.W DATA_04F843,X       
                    LDA.W $0DF5,X             
                    TAX                       
ADDR_04FC8D:        PHY                       
                    PHX                       
                    LDX.W $0DDE               
                    JSR.W ADDR_04FE62         
                    PLX                       
                    LDA $07                   
                    CLC                       
                    ADC.W DATA_04FC36,X       
                    CLC                       
                    ADC $02                   
                    STA $02                   
                    BCS ADDR_04FCA5           
                    DEC $03                   
ADDR_04FCA5:        LDA $00                   
                    CLC                       
                    ADC.W DATA_04FC26,X       
                    STA $00                   
                    BCC ADDR_04FCB1           
                    INC $01                   
ADDR_04FCB1:        TXA                       
                    CLC                       
                    ADC.B #$0C                
                    CMP.B #$10                
                    AND.B #$0F                
                    TAX                       
                    BCC ADDR_04FCC2           
                    LDA $07                   
                    SBC.B #$0C                
                    STA $07                   
ADDR_04FCC2:        LDA.B #$30                
                    XBA                       
                    LDY.B #$28                
                    LDA $06                   
                    CLC                       
                    ADC.B #$0A                
                    STA $06                   
                    AND.B #$20                
                    BEQ ADDR_04FCD4           
                    LDY.B #$5F                
ADDR_04FCD4:        TYA                       
                    PLY                       
                    JSR.W ADDR_04FAED         
                    DEC $04                   
                    BNE ADDR_04FC8D           
                    LDX.W $0DDE               
                    RTS                       ; Return 

ADDR_04FCE1:        JSR.W ADDR_04FE62         
                    LDA.B #$04                
                    STA $04                   
                    LDA.B #$6F                
                    STA $05                   
                    LDY.W DATA_04F843,X       
ADDR_04FCEF:        LDA $13                   
                    LSR                       
                    AND.B #$06                
                    ORA.B #$30                
                    XBA                       
                    LDA $05                   
                    JSR.W ADDR_04FAED         
                    LDA $00                   
                    SEC                       
                    SBC.B #$08                
                    STA $00                   
                    DEC $05                   

Instr04FD05:        .db $C6

ADDR_04FD06:        .db $04

                    BNE ADDR_04FCEF           
                    RTS                       ; Return 


DATA_04FD0A:        .db $07,$07,$03,$03,$5F,$5F

DATA_04FD10:        .db $01,$FF,$01,$FF,$01,$FF,$01,$FF
                    .db $01,$FF

DATA_04FD1A:        .db $18,$E8,$0A,$F6,$08,$F8,$03,$FD
DATA_04FD22:        .db $01,$FF

ADDR_04FD24:        JSR.W ADDR_04FE90         
                    JSR.W ADDR_04FE62         
                    JSR.W ADDR_04FE62         
                    LDA.B #$00                
                    LDY.W $0E95,X             
                    BMI ADDR_04FD36           
                    LDA.B #$40                
ADDR_04FD36:        XBA                       
                    LDA.B #$68                
                    JSR.W ADDR_04FB06         
                    INC.W $0E15,X             
                    LDA.W $0E15,X             
                    LSR                       
                    BCS ADDR_04FD6F           
                    LDA.W $0E05,X             
                    ORA.B #$02                
                    TAY                       
                    TXA                       
                    ADC.B #$10                
                    TAX                       
                    JSR.W ADDR_04FD55         
                    LDY.W $0DF5,X             
ADDR_04FD55:        LDA.W $0E95,X             
                    CLC                       
                    ADC.W DATA_04FD10,Y       
                    STA.W $0E95,X             
                    CMP.W DATA_04FD1A,Y       
                    BNE ADDR_04FD68           
                    TYA                       
                    EOR.B #$01                
                    TAY                       
ADDR_04FD68:        TYA                       
                    STA.W $0DF5,X             
                    LDX.W $0DDE               
ADDR_04FD6F:        RTS                       ; Return 

ADDR_04FD70:        JSR.W ADDR_04FE90         
                    JSR.W ADDR_04FE62         
                    JSR.W ADDR_04FE62         
                    LDY.W $0DB3               
                    LDA.W $1F11,Y             
                    BEQ ADDR_04FDA5           
                    CPX.B #$0F                
                    BNE ADDR_04FD8E           
                    LDA.W $1F07               
                    AND.B #$12                
                    BNE ADDR_04FD8E           
                    STX $03                   
ADDR_04FD8E:        TXA                       
                    ASL                       
                    TAY                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_04F64C,Y       
                    STA $00                   
                    LDA $02                   
                    CLC                       
                    ADC.W DATA_04F652,Y       
                    STA $02                   
                    SEP #$20                  ; Accum (8 bit) 
ADDR_04FDA5:        LDA.B #$34                
                    LDY.W $0E95,X             
                    BMI ADDR_04FDAE           
                    LDA.B #$44                
ADDR_04FDAE:        XBA                       
                    LDA.B #$60                
                    JSR.W ADDR_04FB06         
                    LDA.W $0E25,X             
                    STA $00                   
                    INC.W $0E25,X             
                    TXA                       
                    CLC                       
                    ADC.B #$20                
                    TAX                       
                    LDA.B #$08                
                    JSR.W ADDR_04FDD2         
                    TXA                       
                    CLC                       
                    ADC.B #$10                
                    TAX                       
                    LDA.B #$06                
                    JSR.W ADDR_04FDD2         
                    LDA.B #$04                
ADDR_04FDD2:        ORA.W $0DF5,X             
                    TAY                       
                    LDA.W ADDR_04FD06,Y       
                    AND $00                   
                    BNE ADDR_04FD68           
                    JMP.W ADDR_04FD55         

DATA_04FDE0:        .db $00,$00,$00,$00,$01,$02,$02,$02
                    .db $00,$00,$01,$01,$02,$02,$03,$03
DATA_04FDF0:        .db $08,$08,$08,$08,$07,$06,$05,$05
                    .db $00,$00,$0E,$0E,$0C,$0C,$0A,$0A

ADDR_04FE00:        ROR $04                   
                    JSR.W ADDR_04FE62         
                    JSR.W ADDR_04FE4E         
                    LDA.W $0E55,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LDY.B #$29                
                    BIT $04                   
                    BPL ADDR_04FE1A           
                    LDY.B #$2E                
                    CLC                       
                    ADC.B #$08                
ADDR_04FE1A:        STY $05                   
                    TAY                       
                    STY $06                   
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_04FDE0,Y       
                    STA $00                   
                    BCC ADDR_04FE2B           
                    INC $01                   
ADDR_04FE2B:        LDA.B #$32                
                    LDY.W DATA_04F843,X       
                    JSR.W ADDR_04FE45         
                    PHY                       
                    LDY $06                   
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_04FDF0,Y       
                    STA $00                   
                    BCC ADDR_04FE42           
                    INC $01                   
ADDR_04FE42:        LDA.B #$72                
                    PLY                       
ADDR_04FE45:        XBA                       
                    LDA $04                   
                    ASL                       
                    LDA $05                   
                    JMP.W ADDR_04FB0A         
ADDR_04FE4E:        LDA $02                   
                    CLC                       
                    ADC.W $0E55,X             
                    STA $02                   
                    BCC ADDR_04FE5A           
                    INC $03                   
ADDR_04FE5A:        RTS                       ; Return 

ADDR_04FE5B:        LDA $13                   
                    CLC                       
                    ADC.W DATA_04F833,X       
                    RTS                       ; Return 

ADDR_04FE62:        TXA                       
                    CLC                       
                    ADC.B #$10                
                    TAX                       
                    LDY.B #$02                
                    JSR.W ADDR_04FE7D         
                    LDX.W $0DDE               
                    LDA $02                   
                    SEC                       
                    SBC.W $0E55,X             
                    STA $02                   
                    BCS ADDR_04FE7B           
                    DEC $03                   
ADDR_04FE7B:        LDY.B #$00                
ADDR_04FE7D:        LDA.W $0E65,X             
                    XBA                       
                    LDA.W $0E35,X             
                    REP #$20                  ; Accum (16 bit) 
                    SEC                       
                    SBC.W $001A,Y             
                    STA.W $0000,Y             
                    SEP #$20                  ; Accum (8 bit) 
                    RTS                       ; Return 

ADDR_04FE90:        TXA                       
                    CLC                       
                    ADC.B #$20                
                    TAX                       
                    JSR.W ADDR_04FEAB         
                    LDA.W $0E35,X             
                    BPL ADDR_04FEA0           
                    STZ.W $0E35,X             
ADDR_04FEA0:        TXA                       
                    SEC                       
                    SBC.B #$10                
                    TAX                       
                    JSR.W ADDR_04FEAB         
                    LDX.W $0DDE               
ADDR_04FEAB:        LDA.W $0E95,X             
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    CLC                       
                    ADC.W $0EC5,X             
                    STA.W $0EC5,X             
                    LDA.W $0E95,X             
                    PHP                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LDY.B #$00                
                    PLP                       
                    BPL ADDR_04FEC9           
                    ORA.B #$F0                
                    DEY                       
ADDR_04FEC9:        ADC.W $0E35,X             
                    STA.W $0E35,X             
                    TYA                       
                    ADC.W $0E65,X             
                    STA.W $0E65,X             
                    RTS                       ; Return 

ADDR_04FED7:        JSR.W ADDR_04FEEF         ; Accum (16 bit) 
                    LDA $06                   
                    CMP.W #$0008              
                    BCS ADDR_04FEE6           
                    LDA $08                   
                    CMP.W #$0008              
ADDR_04FEE6:        SEP #$20                  ; Accum (8 bit) 
                    TXA                       
                    BCS ADDR_04FEEE           
                    STA.W $0EF7               
ADDR_04FEEE:        RTS                       ; Return 

ADDR_04FEEF:        LDA.W $0E65,X             
                    XBA                       
                    LDA.W $0E35,X             
                    REP #$20                  ; Accum (16 bit) 
                    CLC                       
                    ADC.W #$0008              
                    LDY.W $0DD6               
                    SEC                       
                    SBC.W $1F17,Y             
                    STA $00                   
                    BPL ADDR_04FF0B           
                    EOR.W #$FFFF              
                    INC A                     
ADDR_04FF0B:        STA $06                   
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.W $0E75,X             
                    XBA                       
                    LDA.W $0E45,X             
                    REP #$20                  ; Accum (16 bit) 
                    CLC                       
                    ADC.W #$0008              
                    LDY.W $0DD6               
                    SEC                       
                    SBC.W $1F19,Y             
                    STA $02                   
                    BPL ADDR_04FF2B           
                    EOR.W #$FFFF              
                    INC A                     
ADDR_04FF2B:        STA $08                   
                    RTS                       ; Return 

ADDR_04FF2E:        JSR.W ADDR_04FEEF         
                    LSR $06                   
                    LSR $08                   
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.W $0E55,X             
                    LSR                       
                    STA $0A                   
                    STZ $05                   
                    LDY.B #$04                
                    CMP $08                   
                    BCS ADDR_04FF49           
                    LDY.B #$02                
                    LDA $08                   
ADDR_04FF49:        CMP $06                   
                    BCS ADDR_04FF51           
                    LDY.B #$00                
                    LDA $06                   
ADDR_04FF51:        CMP.B #$01                
                    BCS ADDR_04FF67           
                    STZ.W $0E15,X             
                    STZ.W $0E95,X             
                    STZ.W $0EA5,X             
                    STZ.W $0EB5,X             
                    LDA.B #$40                
                    STA.W $0E55,X             
                    RTS                       ; Return 

ADDR_04FF67:        STY $0C                   
                    LDX.B #$04                
ADDR_04FF6B:        CPX $0C                   
                    BNE ADDR_04FF73           
                    LDA.B #$20                
                    BRA ADDR_04FF91           
ADDR_04FF73:        STZ.W $4204               ; Dividend (Low Byte)
                    LDA $06,X                 
                    STA.W $4205               ; Dividend (High-Byte)
                    LDA.W $0006,Y             
                    STA.W $4206               ; Divisor B
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W $4214               ; Quotient of Divide Result (Low Byte)
                    LSR                       
                    LSR                       
                    LSR                       
                    SEP #$20                  ; Accum (8 bit) 
ADDR_04FF91:        BIT $01,X                 
                    BMI ADDR_04FF98           
                    EOR.B #$FF                
                    INC A                     
ADDR_04FF98:        STA $00,X                 
                    DEX                       
                    DEX                       
                    BPL ADDR_04FF6B           
                    LDX.W $0DDE               
                    LDA $00                   
                    STA.W $0E95,X             
                    LDA $02                   
                    STA.W $0EA5,X             
                    LDA $04                   
                    STA.W $0EB5,X             
                    RTS                       ; Return 


DATA_04FFB1:        .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF
