.INCLUDE "snes.cfg"
.BANK 5


DATA_058000:        .db $70,$8B,$00,$BC,$00,$C8,$00,$D4
                    .db $00,$E3,$00,$E3,$00,$C8,$70,$8B
                    .db $00,$C8,$00,$D4,$00,$D4,$00,$D4
                    .db $70,$8B,$00,$E3,$00,$D4

ADDR_05801E:        PHP                       
                    SEP #$20                  ; Accum (8 bit) 
                    REP #$10                  ; Index (16 bit) 
                    LDX.W #$0000              
ADDR_058026:        LDA.B #$25                
                    STA.L $7EB900,X           
                    STA.L $7EBB00,X           
                    INX                       
                    CPX.W #$0200              
                    BNE ADDR_058026           
                    STZ.W $1928               
                    LDA $6A                   
                    CMP.B #$FF                
                    BNE ADDR_058074           
                    REP #$10                  ; Index (16 bit) 
                    LDY.W #$0000              
                    LDX $68                   
                    CPX.W #$E8FE              
                    BCC ADDR_05804E           
                    LDY.W #$0001              
ADDR_05804E:        LDX.W #$0000              
                    TYA                       
ADDR_058052:        STA.L $7EBD00,X           
                    STA.L $7EBF00,X           
                    INX                       
                    CPX.W #$0200              
                    BNE ADDR_058052           
                    LDA.B #$0C                
                    STA $6A                   
                    STZ.W $1932               
                    STZ.W $1931               
                    LDX.W #$B900              
                    STX $0D                   
                    REP #$20                  ; Accum (16 bit) 
                    JSR.W ADDR_058126         
ADDR_058074:        SEP #$20                  ; Accum (8 bit) 
                    LDX.W #$0000              
ADDR_058079:        LDA.B #$00                
                    JSR.W ADDR_05833A         
                    DEX                       
                    LDA.B #$25                
                    JSR.W ADDR_0582C8         
                    CPX.W #$0200              
                    BNE ADDR_058079           
                    STZ.W $1928               
                    JSR.W ADDR_0583AC         
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDA.W $0100               
                    CMP.B #$22                
                    BPL ADDR_05809C           
                    JSL.L ADDR_02A751         
ADDR_05809C:        PLP                       
                    RTL                       ; Return 

ADDR_05809E:        PHP                       
                    SEP #$20                  ; Accum (8 bit) 
                    STZ.W $1928               
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.W #$FFFF              
                    STA $4D                   
                    STA $4F                   
                    JSR.W ADDR_05877E         
                    LDA $45                   
                    STA $47                   
                    LDA $49                   
                    STA $4B                   
                    LDA.W #$0202              
                    STA $55                   
ADDR_0580BD:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    JSL.L ADDR_0588EC         
                    JSL.L ADDR_058955         
                    JSL.L ADDR_0087AD         
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    INC $47                   
                    INC $4B                   
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDA $47                   
                    LSR                       
                    LSR                       
                    LSR                       
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    AND.W #$0006              
                    TAX                       
                    LDA.W #$0133              
                    ASL                       
                    TAY                       
                    LDA.W #$0007              
                    STA $00                   
                    LDA.L DATA_058776,X       
ADDR_0580EC:        STA.W $0FBE,Y             
                    INY                       
                    INY                       
                    CLC                       
                    ADC.W #$0008              
                    DEC $00                   
                    BPL ADDR_0580EC           
                    SEP #$20                  ; Accum (8 bit) 
                    INC.W $1928               
                    LDA.W $1928               
                    CMP.B #$20                
                    BNE ADDR_0580BD           
                    LDA.W $0D9D               
                    STA.W $212C               ; Background and Object Enable
                    STA.W $212E               ; Window Mask Designation for Main Screen
                    LDA.W $0D9E               
                    STA.W $212D               ; Sub Screen Designation
                    STA.W $212F               ; Window Mask Designation for Sub Screen
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W #$FFFF              
                    STA $4D                   
                    STA $4F                   
                    STA $51                   
                    STA $53                   
                    PLP                       
                    RTL                       ; Return 

ADDR_058126:        PHP                       
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDY.W #$0000              
                    STY $03                   
                    STY $05                   
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDA.B #$7E                
                    STA $0F                   
ADDR_058136:        SEP #$20                  ; Accum (8 bit) 
                    REP #$10                  ; Index (16 bit) 
                    LDY $03                   
                    LDA [$68],Y               
                    STA $07                   
                    INY                       
                    REP #$20                  ; Accum (16 bit) 
                    STY $03                   
                    SEP #$20                  ; Accum (8 bit) 
                    AND.B #$80                
                    BEQ ADDR_05816A           
                    LDA $07                   
                    AND.B #$7F                
                    STA $07                   
                    LDA [$68],Y               
                    INY                       
                    REP #$20                  ; Accum (16 bit) 
                    STY $03                   
                    LDY $05                   
ADDR_05815A:        SEP #$20                  ; Accum (8 bit) 
                    STA [$0D],Y               
                    INY                       
                    DEC $07                   
                    BPL ADDR_05815A           
                    REP #$20                  ; Accum (16 bit) 
                    STY $05                   
                    JMP.W ADDR_058188         
ADDR_05816A:        REP #$20                  ; Accum (16 bit) 
                    LDY $03                   
                    SEP #$20                  ; Accum (8 bit) 
                    LDA [$68],Y               
                    INY                       
                    REP #$20                  ; Accum (16 bit) 
                    STY $03                   
                    LDY $05                   
                    SEP #$20                  ; Accum (8 bit) 
                    STA [$0D],Y               
                    REP #$20                  ; Accum (16 bit) 
                    INY                       
                    STY $05                   
                    SEP #$20                  ; Accum (8 bit) 
                    DEC $07                   
                    BPL ADDR_05816A           
ADDR_058188:        REP #$20                  ; Accum (16 bit) 
                    LDY $03                   
                    SEP #$20                  ; Accum (8 bit) 
                    LDA [$68],Y               
                    CMP.B #$FF                
                    BNE ADDR_058136           
                    INY                       
                    LDA [$68],Y               
                    CMP.B #$FF                
                    BNE ADDR_058136           
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W #$9100              
                    STA $00                   
                    LDX.W #$0000              
ADDR_0581A5:        LDA $00                   
                    STA.W $0FBE,X             
                    LDA $00                   
                    CLC                       
                    ADC.W #$0008              
                    STA $00                   
                    INX                       
                    INX                       
                    CPX.W #$0400              
                    BNE ADDR_0581A5           
                    PLP                       
                    RTS                       ; Return 


DATA_0581BB:        .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$E0,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $FE,$00,$7F,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$E0,$00,$00,$03,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

ADDR_0581FB:        SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDA.W $1931               
                    ASL                       
                    TAX                       
                    LDA.B #$05                
                    STA $0F                   
                    LDA.B #$00                
                    STA $84                   
                    LDA.B #$C4                
                    STA.W $1430               
                    LDA.B #$CA                
                    STA.W $1431               
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W #$E55E              
                    STA $82                   
                    LDA.L DATA_058000,X       
                    STA $00                   
                    LDA.W #$8000              
                    STA $02                   
                    LDA.W #$81BB              
                    STA $0D                   
                    STZ $04                   
                    STZ $09                   
                    STZ $0B                   
                    REP #$10                  ; Index (16 bit) 
                    LDY.W #$0000              
                    TYX                       
ADDR_058237:        SEP #$20                  ; Accum (8 bit) 
                    LDA [$0D],Y               
                    STA $0C                   
ADDR_05823D:        ASL $0C                   
                    BCC ADDR_058253           
                    REP #$20                  ; Accum (16 bit) 
                    LDA $02                   
                    STA.W $0FBE,X             
                    LDA $02                   
                    CLC                       
                    ADC.W #$0008              
                    STA $02                   
                    JMP.W ADDR_058262         
ADDR_058253:        REP #$20                  ; Accum (16 bit) 
                    LDA $00                   
                    STA.W $0FBE,X             
                    LDA $00                   
                    CLC                       
                    ADC.W #$0008              
                    STA $00                   
ADDR_058262:        SEP #$20                  ; Accum (8 bit) 
                    INX                       
                    INX                       
                    INC $09                   
                    INC $0B                   
                    LDA $0B                   
                    CMP.B #$08                
                    BNE ADDR_05823D           
                    STZ $0B                   
                    INY                       
                    CPY.W #$0040              
                    BNE ADDR_058237           
                    LDA.W $1931               
                    BEQ ADDR_058281           
                    CMP.B #$07                
                    BNE ADDR_0582C5           
ADDR_058281:        LDA.B #$FF                
                    STA.W $1430               
                    STA.W $1431               
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.W #$E5C8              
                    STA $82                   
                    LDA.W #$01C4              
                    ASL                       
                    TAY                       
                    LDA.W #$8A70              
                    STA $00                   
                    LDX.W #$0003              
ADDR_05829D:        LDA $00                   
                    STA.W $0FBE,Y             
                    CLC                       
                    ADC.W #$0008              
                    STA $00                   
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_05829D           
                    LDA.W #$01EC              
                    ASL                       
                    TAY                       
                    LDX.W #$0003              
ADDR_0582B5:        LDA $00                   
                    STA.W $0FBE,Y             
                    CLC                       
                    ADC.W #$0008              
                    STA $00                   
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_0582B5           
ADDR_0582C5:        SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    RTS                       ; Return 

ADDR_0582C8:        STA.L $7EC800,X           
                    STA.L $7ECA00,X           
                    STA.L $7ECC00,X           
                    STA.L $7ECE00,X           
                    STA.L $7ED000,X           
                    STA.L $7ED200,X           
                    STA.L $7ED400,X           
                    STA.L $7ED600,X           
                    STA.L $7ED800,X           
                    STA.L $7EDA00,X           
                    STA.L $7EDC00,X           
                    STA.L $7EDE00,X           
                    STA.L $7EE000,X           
                    STA.L $7EE200,X           
                    STA.L $7EE400,X           
                    STA.L $7EE600,X           
                    STA.L $7EE800,X           
                    STA.L $7EEA00,X           
                    STA.L $7EEC00,X           
                    STA.L $7EEE00,X           
                    STA.L $7EF000,X           
                    STA.L $7EF200,X           
                    STA.L $7EF400,X           
                    STA.L $7EF600,X           
                    STA.L $7EF800,X           
                    STA.L $7EFA00,X           
                    STA.L $7EFC00,X           
                    STA.L $7EFE00,X           
                    INX                       
                    RTS                       ; Return 

ADDR_05833A:        STA.L $7FC800,X           
                    STA.L $7FCA00,X           
                    STA.L $7FCC00,X           
                    STA.L $7FCE00,X           
                    STA.L $7FD000,X           
                    STA.L $7FD200,X           
                    STA.L $7FD400,X           
                    STA.L $7FD600,X           
                    STA.L $7FD800,X           
                    STA.L $7FDA00,X           
                    STA.L $7FDC00,X           
                    STA.L $7FDE00,X           
                    STA.L $7FE000,X           
                    STA.L $7FE200,X           
                    STA.L $7FE400,X           
                    STA.L $7FE600,X           
                    STA.L $7FE800,X           
                    STA.L $7FEA00,X           
                    STA.L $7FEC00,X           
                    STA.L $7FEE00,X           
                    STA.L $7FF000,X           
                    STA.L $7FF200,X           
                    STA.L $7FF400,X           
                    STA.L $7FF600,X           
                    STA.L $7FF800,X           
                    STA.L $7FFA00,X           
                    STA.L $7FFC00,X           
                    STA.L $7FFE00,X           
                    INX                       
                    RTS                       ; Return 

ADDR_0583AC:        PHP                       
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    STZ.W $1933               
                    JSR.W ADDR_0584E3         
                    JSR.W ADDR_0581FB         
ADDR_0583B8:        LDA.W $1925               
                    CMP.B #$09                
                    BEQ ADDR_058412           
                    CMP.B #$0B                
                    BEQ ADDR_058412           
                    CMP.B #$10                
                    BEQ ADDR_058412           
                    LDY.B #$00                
                    LDA [$65],Y               
                    CMP.B #$FF                
                    BEQ ADDR_0583D2           
                    JSR.W ADDR_0585FF         
ADDR_0583D2:        SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDA.W $1925               
                    BEQ ADDR_058412           
                    CMP.B #$0A                
                    BEQ ADDR_058412           
                    CMP.B #$0C                
                    BEQ ADDR_058412           
                    CMP.B #$0D                
                    BEQ ADDR_058412           
                    CMP.B #$0E                
                    BEQ ADDR_058412           
                    CMP.B #$11                
                    BEQ ADDR_058412           
                    CMP.B #$1E                
                    BEQ ADDR_058412           
                    INC.W $1933               
                    LDA.W $1933               
                    CMP.B #$02                
                    BEQ ADDR_058412           
                    LDA $68                   
                    CLC                       
                    ADC.B #$05                
                    STA $65                   
                    LDA $69                   
                    ADC.B #$00                
                    STA $66                   
                    LDA $6A                   
                    STA $67                   
                    STZ.W $1928               
                    JMP.W ADDR_0583B8         
ADDR_058412:        STZ.W $1933               
                    PLP                       
                    RTS                       ; Return 


DATA_058417:        .db $00,$00,$80,$01,$81,$02,$82,$03
                    .db $83,$00,$01,$00,$00,$01,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$80
DATA_058437:        .db $15,$15,$17,$15,$15,$15,$17,$15
                    .db $17,$15,$15,$15,$15,$15,$04,$04
                    .db $15,$17,$15,$15,$15,$15,$15,$15
                    .db $15,$15,$15,$15,$15,$15,$01,$02
DATA_058457:        .db $02,$02,$00,$02,$02,$02,$00,$02
                    .db $00,$00,$02,$00,$02,$02,$13,$13
                    .db $00,$00,$02,$02,$02,$02,$02,$02
                    .db $02,$02,$02,$02,$02,$02,$16,$15
DATA_058477:        .db $24,$24,$24,$24,$24,$24,$20,$24
                    .db $24,$20,$24,$20,$70,$70,$24,$24
                    .db $20,$FF,$24,$24,$24,$24,$24,$24
                    .db $24,$24,$24,$24,$24,$24,$21,$22
DATA_058497:        .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$C0,$00,$80,$00,$00,$00,$00
                    .db $C1,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
DATA_0584B7:        .db $20,$20,$20,$30,$30,$30,$30,$30
                    .db $30,$30,$30,$30,$30,$30,$20,$20
                    .db $30,$30,$30,$30,$30,$30,$30,$30
                    .db $30,$30,$30,$30,$30,$30,$30,$30
DATA_0584D7:        .db $00,$02,$03,$04

DATA_0584DB:        .db $02,$06,$01,$08,$07,$03,$05,$12

ADDR_0584E3:        LDY.B #$00                
                    LDA [$65],Y               
                    TAX                       
                    AND.B #$1F                
                    INC A                     
                    STA $5D                   
                    TXA                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    STA.W $1930               
                    INY                       
                    LDA [$65],Y               
                    AND.B #$1F                
                    STA.W $1925               
                    TAX                       
                    LDA.L DATA_0584B7,X       
                    STA $64                   
                    LDA.L DATA_058437,X       
                    STA.W $0D9D               
                    LDA.L DATA_058457,X       
                    STA.W $0D9E               
                    LDA.L DATA_058477,X       
                    STA $40                   
                    LDA.L DATA_058497,X       
                    STA.W $0D9B               
                    LDA.L DATA_058417,X       
                    STA $5B                   
                    LSR                       
                    LDA $5D                   
                    LDX.B #$01                
                    BCC ADDR_058530           
                    TAX                       
                    LDA.B #$01                
ADDR_058530:        STA $5E                   
                    STX $5F                   
                    LDA [$65],Y               
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    STA.W $192F               
                    INY                       
                    LDA [$65],Y               
                    STA $00                   
                    TAX                       
                    AND.B #$0F                
                    STA.W $192B               
                    TXA                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.B #$07                
                    TAX                       
                    LDA.L DATA_0584DB,X       
                    LDX.W $0DDA               
                    BPL ADDR_05855C           
                    ORA.B #$80                
ADDR_05855C:        CMP.W $0DDA               
                    BNE ADDR_058563           
                    ORA.B #$40                
ADDR_058563:        STA.W $0DDA               
                    LDA $00                   
                    AND.B #$80                
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    ORA.B #$01                
                    STA $3E                   
                    INY                       
                    LDA [$65],Y               
                    STA $00                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W $141A               
                    BNE ADDR_058590           
                    LDA.L DATA_0584D7,X       
                    STA.W $0F31               
                    STZ.W $0F32               
                    STZ.W $0F33               
ADDR_058590:        LDA $00                   
                    AND.B #$07                
                    STA.W $192D               
                    LDA $00                   
                    AND.B #$38                
                    LSR                       
                    LSR                       
                    LSR                       
                    STA.W $192E               
                    INY                       
                    LDA [$65],Y               
                    AND.B #$0F                
                    STA.W $1931               
                    STA.W $1932               
                    LDA [$65],Y               
                    AND.B #$C0                
                    ASL                       
                    ROL                       
                    ROL                       
                    STA.W $13BE               
                    LDA [$65],Y               
                    AND.B #$30                
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    CMP.B #$03                
                    BNE ADDR_0585C7           
                    STZ.W $1411               
                    LDA.B #$00                
ADDR_0585C7:        STA.W $1412               
                    LDA $65                   
                    CLC                       
                    ADC.B #$05                
                    STA $65                   
                    LDA $66                   
                    ADC.B #$00                
                    STA $66                   
                    RTS                       ; Return 

ADDR_0585D8:        LDA $5A                   
                    BNE ADDR_0585E2           
                    LDA $59                   
                    CMP.B #$02                
                    BCC ADDR_0585FE           
ADDR_0585E2:        LDA $0A                   
                    AND.B #$0F                
                    STA $00                   
                    LDA $0B                   
                    AND.B #$0F                
                    STA $01                   
                    LDA $0A                   
                    AND.B #$F0                
                    ORA $01                   
                    STA $0A                   
                    LDA $0B                   
                    AND.B #$F0                
                    ORA $00                   
                    STA $0B                   
ADDR_0585FE:        RTS                       ; Return 

ADDR_0585FF:        SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDY.B #$00                
                    LDA [$65],Y               
                    STA $0A                   
                    INY                       
                    LDA [$65],Y               
                    STA $0B                   
                    INY                       
                    LDA [$65],Y               
                    STA $59                   
                    INY                       
                    TYA                       
                    CLC                       
                    ADC $65                   
                    STA $65                   
                    LDA $66                   
                    ADC.B #$00                
                    STA $66                   
                    LDA $0B                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    STA $5A                   
                    LDA $0A                   
                    AND.B #$60                
                    LSR                       
                    ORA $5A                   
                    STA $5A                   
                    LDA $5B                   
                    LDY.W $1933               
                    BEQ ADDR_058637           
                    LSR                       
ADDR_058637:        AND.B #$01                
                    BEQ ADDR_05863E           
                    JSR.W ADDR_0585D8         
ADDR_05863E:        LDA $0A                   
                    AND.B #$0F                
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    STA $57                   
                    LDA $0B                   
                    AND.B #$0F                
                    ORA $57                   
                    STA $57                   
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W $1933               
                    AND.W #$00FF              
                    ASL                       
                    TAX                       
                    LDA.L LoadBlkTable1,X     
                    STA $03                   
                    LDA.L LoadBlkTable2,X     
                    STA $06                   
                    LDA.W $1925               
                    AND.W #$001F              
                    ASL                       
                    TAY                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.B #$00                
                    STA $05                   
                    STA $08                   
                    LDA [$03],Y               
                    STA $00                   
                    LDA [$06],Y               
                    STA $0D                   
                    INY                       
                    LDA [$03],Y               
                    STA $01                   
                    LDA [$06],Y               
                    STA $0E                   
                    LDA.B #$00                
                    STA $02                   
                    STA $0F                   
                    LDA $0A                   
                    AND.B #$80                
                    ASL                       
                    ADC.W $1928               
                    STA.W $1928               
                    STA.W $1BA1               
                    ASL                       
                    CLC                       
                    ADC.W $1928               
                    TAY                       
                    LDA [$00],Y               
                    STA $6B                   
                    LDA [$0D],Y               
                    STA $6E                   
                    INY                       
                    LDA [$00],Y               
                    STA $6C                   
                    LDA [$0D],Y               
                    STA $6F                   
                    INY                       
                    LDA [$00],Y               
                    STA $6D                   
                    LDA [$0D],Y               
                    STA $70                   
                    LDA $0A                   
                    AND.B #$10                
                    BEQ ADDR_0586C5           
                    INC $6C                   
                    INC $6F                   
ADDR_0586C5:        LDA $5A                   
                    BNE ADDR_0586CF           
                    JSR.W ADDR_0586E3         
                    JMP.W ADDR_0586D2         
ADDR_0586CF:        JSR.W ADDR_0586EA         
ADDR_0586D2:        SEP #$20                  ; Accum (8 bit) 
                    REP #$10                  ; Index (16 bit) 
                    LDY.W #$0000              
                    LDA [$65],Y               
                    CMP.B #$FF                
                    BEQ ADDR_0586E2           
                    JMP.W ADDR_0585FF         
ADDR_0586E2:        RTS                       ; Return 

ADDR_0586E3:        SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    JSL.L ADDR_0DA100         
                    RTS                       ; Return 

ADDR_0586EA:        SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    JSL.L ADDR_0DA40F         
                    RTS                       ; Return 

ADDR_0586F1:        PHP                       
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    JSR.W ADDR_05877E         
                    SEP #$20                  ; Accum (8 bit) 
                    LDA $5B                   
                    AND.B #$01                
                    BNE ADDR_058713           
                    REP #$20                  ; Accum (16 bit) 
                    LDA $55                   
                    AND.W #$00FF              
                    TAX                       
                    LDA $1A                   
                    AND.W #$FFF0              
                    CMP $4D,X                 
                    BEQ ADDR_058737           
                    JMP.W ADDR_058724         
ADDR_058713:        REP #$20                  ; Accum (16 bit) 
                    LDA $55                   
                    AND.W #$00FF              
                    TAX                       
                    LDA $1C                   
                    AND.W #$FFF0              
                    CMP $4D,X                 
                    BEQ ADDR_058737           
ADDR_058724:        STA $4D,X                 
                    TXA                       
                    EOR.W #$0002              
                    TAX                       
                    LDA.W #$FFFF              
                    STA $4D,X                 
                    JSL.L ADDR_05881A         
                    JMP.W ADDR_058774         
ADDR_058737:        SEP #$20                  ; Accum (8 bit) 
                    LDA $5B                   
                    AND.B #$02                
                    BNE ADDR_058753           
                    REP #$20                  ; Accum (16 bit) 
                    LDA $56                   
                    AND.W #$00FF              
                    TAX                       
                    LDA $1E                   
                    AND.W #$FFF0              
                    CMP $51,X                 
                    BEQ ADDR_058774           
                    JMP.W ADDR_058764         
ADDR_058753:        REP #$20                  ; Accum (16 bit) 
                    LDA $56                   
                    AND.W #$00FF              
                    TAX                       
                    LDA $20                   
                    AND.W #$FFF0              
                    CMP $51,X                 
                    BEQ ADDR_058774           
ADDR_058764:        STA $51,X                 
                    TXA                       
                    EOR.W #$0002              
                    TAX                       
                    LDA.W #$FFFF              
                    STA $51,X                 
                    JSL.L ADDR_058883         
ADDR_058774:        PLP                       
                    RTL                       ; Return 


DATA_058776:        .db $B0,$8A,$E0,$84,$F0,$8A,$30,$8B

ADDR_05877E:        PHP                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDA $5B                   
                    AND.B #$01                
                    BNE ADDR_0587CB           
                    REP #$20                  ; Accum (16 bit) 
                    LDA $1A                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    SEC                       
                    SBC.W #$0008              
                    STA $45                   
                    TYA                       
                    CLC                       
                    ADC.W #$0017              
                    STA $47                   
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDA $55                   
                    TAX                       
                    LDA $45,X                 
                    LSR                       
                    LSR                       
                    LSR                       
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    AND.W #$0006              
                    TAX                       
                    LDA.W #$0133              
                    ASL                       
                    TAY                       
                    LDA.W #$0007              
                    STA $00                   
                    LDA.L DATA_058776,X       
ADDR_0587BB:        STA.W $0FBE,Y             
                    INY                       
                    INY                       
                    CLC                       
                    ADC.W #$0008              
                    DEC $00                   
                    BPL ADDR_0587BB           
                    JMP.W ADDR_0587E1         
ADDR_0587CB:        REP #$20                  ; Accum (16 bit) 
                    LDA $1C                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    SEC                       
                    SBC.W #$0008              
                    STA $45                   
                    TYA                       
                    CLC                       
                    ADC.W #$0017              
                    STA $47                   
ADDR_0587E1:        SEP #$20                  ; Accum (8 bit) 
                    LDA $5B                   
                    AND.B #$02                
                    BNE ADDR_058802           
                    REP #$20                  ; Accum (16 bit) 
                    LDA $1E                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    SEC                       
                    SBC.W #$0008              
                    STA $49                   
                    TYA                       
                    CLC                       
                    ADC.W #$0017              
                    STA $4B                   
                    JMP.W ADDR_058818         
ADDR_058802:        REP #$20                  ; Accum (16 bit) 
                    LDA $20                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    SEC                       
                    SBC.W #$0008              
                    STA $49                   
                    TYA                       
                    CLC                       
                    ADC.W #$0017              
                    STA $4B                   
ADDR_058818:        PLP                       
                    RTS                       ; Return 

ADDR_05881A:        SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDA.W $1925               
                    JSL.L ExecutePtrLong      

PtrsLong058823:     .db $CE,$89,$05
                    .db $CE,$89,$05
                    .db $CE,$89,$05
                    .db $9B,$8A,$05
                    .db $9B,$8A,$05
                    .db $CE,$89,$05
                    .db $CE,$89,$05
                    .db $9B,$8A,$05
                    .db $9B,$8A,$05
                    .db $9A,$8A,$05
                    .db $9B,$8A,$05
                    .db $9A,$8A,$05
                    .db $CE,$89,$05
                    .db $9B,$8A,$05
                    .db $CE,$89,$05
                    .db $CE,$89,$05
                    .db $9A,$8A,$05
                    .db $CE,$89,$05
                    .db $9A,$8A,$05
                    .db $9A,$8A,$05
                    .db $9A,$8A,$05
                    .db $9A,$8A,$05
                    .db $9A,$8A,$05
                    .db $9A,$8A,$05
                    .db $9A,$8A,$05
                    .db $9A,$8A,$05
                    .db $9A,$8A,$05
                    .db $9A,$8A,$05
                    .db $9A,$8A,$05
                    .db $9A,$8A,$05
                    .db $CE,$89,$05
                    .db $CE,$89,$05

ADDR_058883:        SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDA.W $1925               
                    JSL.L ExecutePtrLong      

PtrsLong05888C:     .db $70,$8C,$05
                    .db $8D,$8B,$05
                    .db $8D,$8B,$05
                    .db $8D,$8B,$05
                    .db $8D,$8B,$05
                    .db $71,$8C,$05
                    .db $71,$8C,$05
                    .db $71,$8C,$05
                    .db $71,$8C,$05
                    .db $70,$8C,$05
                    .db $70,$8C,$05
                    .db $70,$8C,$05
                    .db $70,$8C,$05
                    .db $70,$8C,$05
                    .db $70,$8C,$05
                    .db $8D,$8B,$05
                    .db $70,$8C,$05
                    .db $70,$8C,$05
                    .db $70,$8C,$05
                    .db $70,$8C,$05
                    .db $70,$8C,$05
                    .db $70,$8C,$05
                    .db $70,$8C,$05
                    .db $70,$8C,$05
                    .db $70,$8C,$05
                    .db $70,$8C,$05
                    .db $70,$8C,$05
                    .db $70,$8C,$05
                    .db $70,$8C,$05
                    .db $70,$8C,$05
                    .db $70,$8C,$05
                    .db $8D,$8B,$05

ADDR_0588EC:        SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDA.W $1925               
                    JSL.L ExecutePtrLong      

PtrsLong0588F5:     .db $CE,$89,$05
                    .db $CE,$89,$05
                    .db $CE,$89,$05
                    .db $9B,$8A,$05
                    .db $9B,$8A,$05
                    .db $CE,$89,$05
                    .db $CE,$89,$05
                    .db $9B,$8A,$05
                    .db $9B,$8A,$05
                    .db $9A,$8A,$05
                    .db $9B,$8A,$05
                    .db $9A,$8A,$05
                    .db $CE,$89,$05
                    .db $9B,$8A,$05
                    .db $CE,$89,$05
                    .db $CE,$89,$05
                    .db $9A,$8A,$05
                    .db $CE,$89,$05
                    .db $9A,$8A,$05
                    .db $9A,$8A,$05
                    .db $9A,$8A,$05
                    .db $9A,$8A,$05
                    .db $9A,$8A,$05
                    .db $9A,$8A,$05
                    .db $9A,$8A,$05
                    .db $9A,$8A,$05
                    .db $9A,$8A,$05
                    .db $9A,$8A,$05
                    .db $9A,$8A,$05
                    .db $9A,$8A,$05
                    .db $CE,$89,$05
                    .db $CE,$89,$05

ADDR_058955:        SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDA.W $1925               
                    JSL.L ExecutePtrLong      

PtrsLong05895E:     .db $7A,$8D,$05
                    .db $8D,$8B,$05
                    .db $8D,$8B,$05
                    .db $8D,$8B,$05
                    .db $8D,$8B,$05
                    .db $71,$8C,$05
                    .db $71,$8C,$05
                    .db $71,$8C,$05
                    .db $71,$8C,$05
                    .db $70,$8C,$05
                    .db $7A,$8D,$05
                    .db $70,$8C,$05
                    .db $7A,$8D,$05
                    .db $7A,$8D,$05
                    .db $7A,$8D,$05
                    .db $8D,$8B,$05
                    .db $70,$8C,$05
                    .db $7A,$8D,$05
                    .db $70,$8C,$05
                    .db $70,$8C,$05
                    .db $70,$8C,$05
                    .db $70,$8C,$05
                    .db $70,$8C,$05
                    .db $70,$8C,$05
                    .db $70,$8C,$05
                    .db $70,$8C,$05
                    .db $70,$8C,$05
                    .db $70,$8C,$05
                    .db $70,$8C,$05
                    .db $70,$8C,$05
                    .db $7A,$8D,$05
                    .db $8D,$8B,$05

DATA_0589BE:        .db $80,$00,$40,$00,$20,$00,$10,$00
                    .db $08,$00,$04,$00,$02,$00,$01,$00

                    PHP                       
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.W $1925               
                    AND.W #$00FF              
                    ASL                       
                    TAX                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.L DATA_00BDA8,X       
                    STA $0A                   
                    LDA.L DATA_00BDA9,X       
                    STA $0B                   
                    LDA.L DATA_00BE28,X       
                    STA $0D                   
                    LDA.L DATA_00BE29,X       
                    STA $0E                   
                    LDA.B #$00                
                    STA $0C                   
                    STA $0F                   
                    LDA $55                   
                    TAX                       
                    LDA $45,X                 
                    AND.B #$0F                
                    ASL                       
                    STA.W $1BE5               
                    LDY.W #$0020              
                    LDA $45,X                 
                    AND.B #$10                
                    BEQ ADDR_058A10           
                    LDY.W #$0024              
ADDR_058A10:        TYA                       
                    STA.W $1BE4               
                    REP #$20                  ; Accum (16 bit) 
                    LDA $45,X                 
                    AND.W #$01F0              
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    STA $00                   
                    ASL                       
                    CLC                       
                    ADC $00                   
                    TAY                       
                    LDA [$0A],Y               
                    STA $6B                   
                    LDA [$0D],Y               
                    STA $6E                   
                    SEP #$20                  ; Accum (8 bit) 
                    INY                       
                    INY                       
                    LDA [$0A],Y               
                    STA $6D                   
                    LDA [$0D],Y               
                    STA $70                   
                    SEP #$10                  ; Index (8 bit) 
                    LDY.B #$0D                
                    LDA.W $1931               
                    CMP.B #$10                
                    BMI ADDR_058A47           
                    LDY.B #$05                
ADDR_058A47:        STY $0C                   
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA $45,X                 
                    AND.W #$000F              
                    STA $08                   
                    LDX.W #$0000              
ADDR_058A55:        LDY $08                   
                    LDA [$6B],Y               
                    AND.W #$00FF              
                    STA $00                   
                    LDA [$6E],Y               
                    STA $01                   
                    LDA $00                   
                    ASL                       
                    TAY                       
                    LDA.W $0FBE,Y             
                    STA $0A                   
                    LDY.W #$0000              
                    LDA [$0A],Y               
                    STA.W $1BE6,X             
                    INY                       
                    INY                       
                    LDA [$0A],Y               
                    STA.W $1BE8,X             
                    INY                       
                    INY                       
                    LDA [$0A],Y               
                    STA.W $1C66,X             
                    INY                       
                    INY                       
                    LDA [$0A],Y               
                    STA.W $1C68,X             
                    INX                       
                    INX                       
                    INX                       
                    INX                       
                    LDA $08                   
                    CLC                       
                    ADC.W #$0010              
                    STA $08                   
                    CMP.W #$01B0              
                    BCC ADDR_058A55           
                    PLP                       
                    RTL                       ; Return 

                    PHP                       
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.W $1925               
                    AND.W #$00FF              
                    ASL                       
                    TAX                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.L DATA_00BDA8,X       
                    STA $0A                   
                    LDA.L DATA_00BDA9,X       
                    STA $0B                   
                    LDA.L DATA_00BE28,X       
                    STA $0D                   
                    LDA.L DATA_00BE29,X       
                    STA $0E                   
                    LDA.B #$00                
                    STA $0C                   
                    STA $0F                   
                    LDA $55                   
                    TAX                       
                    LDY.W #$0020              
                    LDA $45,X                 
                    AND.B #$10                
                    BEQ ADDR_058AD5           
                    LDY.W #$0028              
ADDR_058AD5:        TYA                       
                    STA $00                   
                    LDA $45,X                 
                    LSR                       
                    LSR                       
                    AND.B #$03                
                    ORA $00                   
                    STA.W $1BE4               
                    LDA $45,X                 
                    AND.B #$03                
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    STA.W $1BE5               
                    REP #$20                  ; Accum (16 bit) 
                    LDA $45,X                 
                    AND.W #$01F0              
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    STA $00                   
                    ASL                       
                    CLC                       
                    ADC $00                   
                    TAY                       
                    LDA [$0A],Y               
                    STA $6B                   
                    LDA [$0D],Y               
                    STA $6E                   
                    SEP #$20                  ; Accum (8 bit) 
                    INY                       
                    INY                       
                    LDA [$0A],Y               
                    STA $6D                   
                    LDA [$0D],Y               
                    STA $70                   
                    SEP #$10                  ; Index (8 bit) 
                    LDY.B #$0D                
                    LDA.W $1931               
                    CMP.B #$10                
                    BMI ADDR_058B23           
                    LDY.B #$05                
ADDR_058B23:        STY $0C                   
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA $45,X                 
                    AND.W #$000F              
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    STA $08                   
                    LDX.W #$0000              
ADDR_058B35:        LDY $08                   
                    LDA [$6B],Y               
                    AND.W #$00FF              
                    STA $00                   
                    LDA [$6E],Y               
                    STA $01                   
                    LDA $00                   
                    ASL                       
                    TAY                       
                    LDA.W $0FBE,Y             
                    STA $0A                   
                    LDY.W #$0000              
                    LDA [$0A],Y               
                    STA.W $1BE6,X             
                    INY                       
                    INY                       
                    LDA [$0A],Y               
                    STA.W $1C66,X             
                    INX                       
                    INX                       
                    INY                       
                    INY                       
                    LDA [$0A],Y               
                    STA.W $1BE6,X             
                    INY                       
                    INY                       
                    LDA [$0A],Y               
                    STA.W $1C66,X             
                    INX                       
                    INX                       
                    LDA $08                   
                    TAY                       
                    CLC                       
                    ADC.W #$0001              
                    STA $08                   
                    AND.W #$000F              
                    BNE ADDR_058B84           
                    TYA                       
                    AND.W #$FFF0              
                    CLC                       
                    ADC.W #$0100              
                    STA $08                   
ADDR_058B84:        LDA $08                   
                    AND.W #$010F              
                    BNE ADDR_058B35           
                    PLP                       
                    RTL                       ; Return 

                    PHP                       
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.W $1925               
                    AND.W #$00FF              
                    ASL                       
                    TAX                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDY.W #$0000              
                    LDA.W $1931               
                    CMP.B #$03                
                    BNE ADDR_058BA7           
                    LDY.W #$1000              
ADDR_058BA7:        STY $03                   
                    LDA.L DATA_00BDE8,X       
                    STA $0A                   
                    LDA.L DATA_00BDE9,X       
                    STA $0B                   
                    LDA.L DATA_00BE68,X       
                    STA $0D                   
                    LDA.L DATA_00BE69,X       
                    STA $0E                   
                    LDA.B #$00                
                    STA $0C                   
                    STA $0F                   
                    LDA $56                   
                    TAX                       
                    LDA $49,X                 
                    AND.B #$0F                
                    ASL                       
                    STA.W $1CE7               
                    LDY.W #$0030              
                    LDA $49,X                 
                    AND.B #$10                
                    BEQ ADDR_058BDE           
                    LDY.W #$0034              
ADDR_058BDE:        TYA                       
                    STA.W $1CE6               
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA $49,X                 
                    AND.W #$01F0              
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    STA $00                   
                    ASL                       
                    CLC                       
                    ADC $00                   
                    TAY                       
                    LDA [$0A],Y               
                    STA $6B                   
                    LDA [$0D],Y               
                    STA $6E                   
                    SEP #$20                  ; Accum (8 bit) 
                    INY                       
                    INY                       
                    LDA [$0A],Y               
                    STA $6D                   
                    LDA [$0D],Y               
                    STA $70                   
                    SEP #$10                  ; Index (8 bit) 
                    LDY.B #$0D                
                    LDA.W $1931               
                    CMP.B #$10                
                    BMI ADDR_058C15           
                    LDY.B #$05                
ADDR_058C15:        STY $0C                   
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA $49,X                 
                    AND.W #$000F              
                    STA $08                   
                    LDX.W #$0000              
ADDR_058C23:        LDY $08                   
                    LDA [$6B],Y               
                    AND.W #$00FF              
                    STA $00                   
                    LDA [$6E],Y               
                    STA $01                   
                    LDA $00                   
                    ASL                       
                    TAY                       
                    LDA.W $0FBE,Y             
                    STA $0A                   
                    LDY.W #$0000              
                    LDA [$0A],Y               
                    ORA $03                   
                    STA.W $1CE8,X             
                    INY                       
                    INY                       
                    LDA [$0A],Y               
                    ORA $03                   
                    STA.W $1CEA,X             
                    INY                       
                    INY                       
                    LDA [$0A],Y               
                    ORA $03                   
                    STA.W $1D68,X             
                    INY                       
                    INY                       
                    LDA [$0A],Y               
                    ORA $03                   
                    STA.W $1D6A,X             
                    INX                       
                    INX                       
                    INX                       
                    INX                       
                    LDA $08                   
                    CLC                       
                    ADC.W #$0010              
                    STA $08                   
                    CMP.W #$01B0              
                    BCC ADDR_058C23           
                    PLP                       
                    RTL                       ; Return 

                    PHP                       
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.W $1925               
                    AND.W #$00FF              
                    ASL                       
                    TAX                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDY.W #$0000              
                    LDA.W $1931               
                    CMP.B #$03                
                    BNE ADDR_058C8B           
                    LDY.W #$1000              
ADDR_058C8B:        STY $03                   
                    LDA.L DATA_00BDE8,X       
                    STA $0A                   
                    LDA.L DATA_00BDE9,X       
                    STA $0B                   
                    LDA.L DATA_00BE68,X       
                    STA $0D                   
                    LDA.L DATA_00BE69,X       
                    STA $0E                   
                    LDA.B #$00                
                    STA $0C                   
                    STA $0F                   
                    LDA $56                   
                    TAX                       
                    LDY.W #$0030              
                    LDA $49,X                 
                    AND.B #$10                
                    BEQ ADDR_058CBA           
                    LDY.W #$0038              
ADDR_058CBA:        TYA                       
                    STA $00                   
                    LDA $49,X                 
                    LSR                       
                    LSR                       
                    AND.B #$03                
                    ORA $00                   
                    STA.W $1CE6               
                    LDA $49,X                 
                    AND.B #$03                
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    STA.W $1CE7               
                    REP #$20                  ; Accum (16 bit) 
                    LDA $49,X                 
                    AND.W #$01F0              
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    STA $00                   
                    ASL                       
                    CLC                       
                    ADC $00                   
                    TAY                       
                    LDA [$0A],Y               
                    STA $6B                   
                    LDA [$0D],Y               
                    STA $6E                   
                    SEP #$20                  ; Accum (8 bit) 
                    INY                       
                    INY                       
                    LDA [$0A],Y               
                    STA $6D                   
                    LDA [$0D],Y               
                    STA $70                   
                    SEP #$10                  ; Index (8 bit) 
                    LDY.B #$0D                
                    LDA.W $1931               
                    CMP.B #$10                
                    BMI ADDR_058D08           
                    LDY.B #$05                
ADDR_058D08:        STY $0C                   
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA $49,X                 
                    AND.W #$000F              
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    STA $08                   
                    LDX.W #$0000              
ADDR_058D1A:        LDY $08                   
                    LDA [$6B],Y               
                    AND.W #$00FF              
                    STA $00                   
                    LDA [$6E],Y               
                    STA $01                   
                    LDA $00                   
                    ASL                       
                    TAY                       
                    LDA.W $0FBE,Y             
                    STA $0A                   
                    LDY.W #$0000              
                    LDA [$0A],Y               
                    ORA $03                   
                    STA.W $1CE8,X             
                    INY                       
                    INY                       
                    LDA [$0A],Y               
                    ORA $03                   
                    STA.W $1D68,X             
                    INX                       
                    INX                       
                    INY                       
                    INY                       
                    LDA [$0A],Y               
                    ORA $03                   
                    STA.W $1CE8,X             
                    INY                       
                    INY                       
                    LDA [$0A],Y               
                    ORA $03                   
                    STA.W $1D68,X             
                    INX                       
                    INX                       
                    LDA $08                   
                    TAY                       
                    CLC                       
                    ADC.W #$0001              
                    STA $08                   
                    AND.W #$000F              
                    BNE ADDR_058D71           
                    TYA                       
                    AND.W #$FFF0              
                    CLC                       
                    ADC.W #$0100              
                    STA $08                   
ADDR_058D71:        LDA $08                   
                    AND.W #$010F              
                    BNE ADDR_058D1A           
                    PLP                       
                    RTL                       ; Return 

                    PHP                       
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDA.W $1928               
                    AND.B #$0F                
                    ASL                       
                    STA.W $1CE7               
                    LDY.B #$30                
                    LDA.W $1928               
                    AND.B #$10                
                    BEQ ADDR_058D91           
                    LDY.B #$34                
ADDR_058D91:        TYA                       
                    STA.W $1CE6               
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W #$B900              
                    STA $6B                   
                    LDA.W #$BD00              
                    STA $6E                   
                    LDA.W #$9100              
                    STA $0A                   
                    LDA.W $1928               
                    AND.W #$00F0              
                    BEQ ADDR_058DBE           
                    LDA $6B                   
                    CLC                       
                    ADC.W #$01B0              
                    STA $6B                   
                    LDA $6E                   
                    CLC                       
                    ADC.W #$01B0              
                    STA $6E                   
ADDR_058DBE:        SEP #$20                  ; Accum (8 bit) 
                    LDA.B #$7E                
                    STA $6D                   
                    LDA.B #$7E                
                    STA $70                   
                    LDY.B #$0D                
                    STY $0C                   
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.W $1928               
                    AND.W #$000F              
                    STA $08                   
                    LDX.W #$0000              
ADDR_058DD9:        LDY $08                   
                    LDA [$6B],Y               
                    AND.W #$00FF              
                    STA $00                   
                    LDA [$6E],Y               
                    STA $01                   
                    LDA $00                   
                    ASL                       
                    ASL                       
                    ASL                       
                    TAY                       
                    LDA [$0A],Y               
                    STA.W $1CE8,X             
                    INY                       
                    INY                       
                    LDA [$0A],Y               
                    STA.W $1CEA,X             
                    INY                       
                    INY                       
                    LDA [$0A],Y               
                    STA.W $1D68,X             
                    INY                       
                    INY                       
                    LDA [$0A],Y               
                    STA.W $1D6A,X             
                    INX                       
                    INX                       
                    INX                       
                    INX                       
                    LDA $08                   
                    CLC                       
                    ADC.W #$0010              
                    STA $08                   
                    CMP.W #$01B0              
                    BCC ADDR_058DD9           
                    PLP                       
                    RTL                       ; Return 


DATA_058E19:        .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
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
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF

DATA_059000:        .db $49

DATA_059001:        .db $95

DATA_059002:        .db $05,$49,$95,$05,$87,$90,$05,$49
                    .db $95,$05,$94,$92,$05,$E0,$9A,$05
                    .db $49,$95,$05,$49,$95,$05,$87,$90
                    .db $05,$49,$95,$05,$49,$95,$05,$21
                    .db $A2,$05,$49,$95,$05,$49,$95,$05
                    .db $87,$90,$05,$49,$95,$05,$49,$95
                    .db $05,$DE,$95,$05,$49,$95,$05,$49
                    .db $95,$05,$87,$90,$05,$49,$95,$05
                    .db $49,$95,$05,$87,$90,$05,$49,$95
                    .db $05,$49,$95,$05,$87,$90,$05,$49
                    .db $95,$05,$49,$95,$05,$17,$9A,$05
                    .db $49,$95,$05,$49,$95,$05,$87,$90
                    .db $05,$49,$95,$05,$49,$95,$05,$87
                    .db $90,$05,$49,$95,$05,$49,$95,$05
                    .db $87,$90,$05,$49,$95,$05,$49,$95
                    .db $05,$DE,$95,$05,$49,$95,$05,$49
                    .db $95,$05,$21,$A2,$05,$58,$06,$00
                    .db $03,$87,$39,$88,$39,$58,$12,$00
                    .db $03,$87,$39,$88,$39,$58,$26,$00
                    .db $03,$97,$39,$98,$39,$58,$2C,$00
                    .db $03,$87,$39,$88,$39,$58,$32,$00
                    .db $03,$97,$39,$98,$39,$58,$38,$00
                    .db $03,$87,$39,$88,$39,$58,$46,$00
                    .db $03,$85,$39,$86,$39,$58,$4C,$00
                    .db $03,$97,$39,$98,$39,$58,$52,$00
                    .db $03,$85,$39,$86,$39,$58,$58,$00
                    .db $03,$97,$39,$98,$39,$58,$66,$00
                    .db $03,$95,$39,$96,$39,$58,$6C,$00
                    .db $03,$95,$39,$96,$39,$58,$72,$00
                    .db $03,$95,$39,$96,$39,$58,$78,$00
                    .db $03,$95,$39,$96,$39,$58,$84,$00
                    .db $2F,$80,$3D,$81,$3D,$82,$3D,$82
                    .db $7D,$82,$3D,$82,$7D,$82,$3D,$82
                    .db $7D,$82,$3D,$82,$7D,$82,$3D,$82
                    .db $7D,$82,$3D,$82,$7D,$82,$3D,$82
                    .db $7D,$82,$3D,$82,$7D,$82,$3D,$82
                    .db $7D,$82,$3D,$82,$7D,$81,$7D,$80
                    .db $7D,$58,$A4,$00,$2F,$90,$3D,$91
                    .db $3D,$92,$3D,$92,$7D,$92,$3D,$92
                    .db $7D,$92,$3D,$92,$7D,$92,$3D,$92
                    .db $7D,$92,$3D,$92,$7D,$92,$3D,$92
                    .db $7D,$92,$3D,$92,$7D,$92,$3D,$92
                    .db $7D,$92,$3D,$92,$7D,$92,$3D,$92
                    .db $7D,$91,$7D,$90,$7D,$58,$C4,$80
                    .db $13,$83,$3D,$83,$BD,$83,$3D,$83
                    .db $BD,$83,$3D,$83,$BD,$83,$3D,$83
                    .db $BD,$83,$3D,$83,$BD,$58,$C5,$80
                    .db $13,$84,$3D,$84,$BD,$84,$3D,$84
                    .db $BD,$84,$3D,$84,$BD,$84,$3D,$84
                    .db $BD,$84,$3D,$84,$BD,$58,$C7,$C0
                    .db $12,$93,$39,$58,$C8,$C0,$12,$94
                    .db $39,$58,$C9,$C0,$12,$93,$39,$58
                    .db $CA,$C0,$12,$94,$39,$58,$CB,$C0
                    .db $12,$93,$39,$58,$CC,$C0,$12,$94
                    .db $39,$58,$CD,$C0,$12,$93,$39,$58
                    .db $CE,$C0,$12,$94,$39,$58,$CF,$C0
                    .db $12,$93,$39,$58,$D0,$C0,$12,$94
                    .db $39,$58,$D1,$C0,$12,$93,$39,$58
                    .db $D2,$C0,$12,$94,$39,$58,$D3,$C0
                    .db $12,$93,$39,$58,$D4,$C0,$12,$94
                    .db $39,$58,$D5,$C0,$12,$93,$39,$58
                    .db $D6,$C0,$12,$94,$39,$58,$D7,$C0
                    .db $12,$93,$39,$58,$D8,$C0,$12,$94
                    .db $39,$58,$DA,$80,$13,$83,$3D,$83
                    .db $BD,$83,$3D,$83,$BD,$83,$3D,$83
                    .db $BD,$83,$3D,$83,$BD,$83,$3D,$83
                    .db $BD,$58,$DB,$80,$13,$84,$3D,$84
                    .db $BD,$84,$3D,$84,$BD,$84,$3D,$84
                    .db $BD,$84,$3D,$84,$BD,$84,$3D,$84
                    .db $BD,$5A,$04,$00,$2F,$90,$BD,$91
                    .db $BD,$82,$3D,$82,$7D,$82,$3D,$82
                    .db $7D,$82,$3D,$82,$7D,$82,$3D,$82
                    .db $7D,$82,$3D,$82,$7D,$82,$3D,$82
                    .db $7D,$82,$3D,$82,$7D,$82,$3D,$82
                    .db $7D,$82,$3D,$82,$7D,$82,$3D,$82
                    .db $7D,$91,$FD,$90,$FD,$5A,$24,$00
                    .db $2F,$80,$BD,$81,$BD,$92,$3D,$92
                    .db $7D,$92,$3D,$92,$7D,$92,$3D,$92
                    .db $7D,$92,$3D,$92,$7D,$92,$3D,$92
                    .db $7D,$92,$3D,$92,$7D,$92,$3D,$92
                    .db $7D,$92,$3D,$92,$7D,$92,$3D,$92
                    .db $7D,$92,$3D,$92,$7D,$81,$FD,$80
                    .db $FD,$FF,$50,$A8,$00,$1F,$99,$3D
                    .db $9A,$3D,$A1,$AD,$B2,$2D,$B3,$2D
                    .db $B4,$2D,$A5,$AD,$B6,$2D,$B7,$2D
                    .db $B8,$2D,$B4,$2D,$BA,$2D,$BB,$2D
                    .db $BC,$2D,$FE,$2C,$FE,$2C,$50,$C8
                    .db $00,$1F,$8B,$3D,$8C,$3D,$C1,$2D
                    .db $C2,$2D,$C3,$2D,$B4,$AD,$A3,$2D
                    .db $A4,$2D,$C7,$2D,$C8,$2D,$B4,$AD
                    .db $BA,$AD,$D5,$2D,$CC,$2D,$FE,$2C
                    .db $FE,$2C,$50,$E8,$00,$1F,$9B,$3D
                    .db $9C,$3D,$D1,$2D,$D2,$2D,$D3,$2D
                    .db $B7,$AD,$D5,$2D,$B4,$2D,$D7,$2D
                    .db $C7,$2D,$D9,$2D,$D9,$6D,$DB,$2D
                    .db $DC,$2D,$FE,$2C,$FE,$2C,$51,$08
                    .db $00,$1F,$89,$3D,$8A,$3D,$A1,$2D
                    .db $A2,$2D,$A3,$2D,$A4,$2D,$A5,$2D
                    .db $B4,$AD,$D5,$2D,$C7,$AD,$FD,$2C
                    .db $AA,$2D,$AB,$2D,$AC,$2D,$FE,$2C
                    .db $FE,$2C,$51,$28,$00,$1F,$99,$3D
                    .db $9A,$3D,$A1,$AD,$B2,$2D,$B3,$2D
                    .db $B4,$2D,$A5,$AD,$B6,$2D,$B7,$2D
                    .db $B8,$2D,$B4,$2D,$BA,$2D,$BB,$2D
                    .db $BC,$2D,$FE,$2C,$FE,$2C,$51,$48
                    .db $00,$1F,$8B,$3D,$8C,$3D,$C1,$2D
                    .db $C2,$2D,$C3,$2D,$B4,$AD,$A3,$2D
                    .db $A4,$2D,$C7,$2D,$C8,$2D,$B4,$AD
                    .db $BA,$AD,$D5,$2D,$CC,$2D,$FE,$2C
                    .db $FE,$2C,$51,$68,$00,$1F,$9B,$3D
                    .db $9C,$3D,$D1,$2D,$D2,$2D,$D3,$2D
                    .db $B7,$AD,$D5,$2D,$B4,$2D,$D7,$2D
                    .db $C7,$2D,$D9,$2D,$D9,$6D,$DB,$2D
                    .db $DC,$2D,$FE,$2C,$FE,$2C,$51,$88
                    .db $00,$1F,$89,$3D,$8A,$3D,$A1,$2D
                    .db $A2,$2D,$A3,$2D,$A4,$2D,$A5,$2D
                    .db $B4,$AD,$D5,$2D,$C7,$AD,$FD,$2C
                    .db $AA,$2D,$AB,$2D,$AC,$2D,$FE,$2C
                    .db $FE,$2C,$51,$A8,$00,$1F,$99,$3D
                    .db $9A,$3D,$A1,$AD,$B2,$2D,$B3,$2D
                    .db $B4,$2D,$A5,$AD,$B6,$2D,$B7,$2D
                    .db $B8,$2D,$B4,$2D,$BA,$2D,$BB,$2D
                    .db $BC,$2D,$FE,$2C,$FE,$2C,$51,$C8
                    .db $00,$1F,$8B,$3D,$8C,$3D,$C1,$2D
                    .db $C2,$2D,$C3,$2D,$B4,$AD,$A3,$2D
                    .db $A4,$2D,$C7,$2D,$C8,$2D,$B4,$AD
                    .db $BA,$AD,$D5,$2D,$CC,$2D,$FE,$2C
                    .db $FE,$2C,$51,$E8,$00,$1F,$9B,$3D
                    .db $9C,$3D,$D1,$2D,$D2,$2D,$D3,$2D
                    .db $B7,$AD,$D5,$2D,$B4,$2D,$D7,$2D
                    .db $C7,$2D,$D9,$2D,$D9,$6D,$DB,$2D
                    .db $DC,$2D,$FE,$2C,$FE,$2C,$52,$08
                    .db $00,$1F,$89,$3D,$8A,$3D,$A1,$2D
                    .db $A2,$2D,$A3,$2D,$A4,$2D,$A5,$2D
                    .db $B4,$AD,$D5,$2D,$C7,$AD,$FD,$2C
                    .db $AA,$2D,$AB,$2D,$AC,$2D,$FE,$2C
                    .db $FE,$2C,$52,$28,$00,$1F,$99,$3D
                    .db $9A,$3D,$A1,$AD,$B2,$2D,$B3,$2D
                    .db $B4,$2D,$A5,$AD,$B6,$2D,$B7,$2D
                    .db $B8,$2D,$B4,$2D,$BA,$2D,$BB,$2D
                    .db $BC,$2D,$FE,$2C,$FE,$2C,$52,$48
                    .db $00,$1F,$8B,$3D,$8C,$3D,$C1,$2D
                    .db $C2,$2D,$C3,$2D,$B4,$AD,$A3,$2D
                    .db $A4,$2D,$C7,$2D,$C8,$2D,$B4,$AD
                    .db $BA,$AD,$D5,$2D,$CC,$2D,$FE,$2C
                    .db $FE,$2C,$52,$68,$00,$1F,$9B,$3D
                    .db $9C,$3D,$D1,$2D,$D2,$2D,$D3,$2D
                    .db $B7,$AD,$D5,$2D,$B4,$2D,$D7,$2D
                    .db $C7,$2D,$D9,$2D,$D9,$6D,$DB,$2D
                    .db $DC,$2D,$FE,$2C,$FE,$2C,$52,$88
                    .db $00,$1F,$89,$3D,$8A,$3D,$A1,$2D
                    .db $A2,$2D,$A3,$2D,$A4,$2D,$A5,$2D
                    .db $B4,$AD,$D5,$2D,$C7,$AD,$FD,$2C
                    .db $AA,$2D,$AB,$2D,$AC,$2D,$FE,$2C
                    .db $FE,$2C,$52,$A8,$00,$1F,$99,$3D
                    .db $9A,$3D,$A1,$AD,$B2,$2D,$B3,$2D
                    .db $B4,$2D,$A5,$AD,$B6,$2D,$B7,$2D
                    .db $B8,$2D,$B4,$2D,$BA,$2D,$BB,$2D
                    .db $BC,$2D,$FE,$2C,$FE,$2C,$52,$C7
                    .db $00,$23,$CD,$2D,$CE,$2D,$CF,$2D
                    .db $E1,$2D,$E2,$2D,$E3,$2D,$E4,$2D
                    .db $E5,$2D,$E6,$2D,$E7,$2D,$E8,$2D
                    .db $E9,$2D,$EA,$2D,$EB,$2D,$EC,$2D
                    .db $ED,$2D,$EE,$2D,$CD,$6D,$52,$E7
                    .db $00,$23,$DD,$2D,$DE,$2D,$DF,$2D
                    .db $F1,$2D,$F2,$2D,$DE,$2D,$DF,$2D
                    .db $F1,$2D,$F2,$2D,$DE,$2D,$DF,$2D
                    .db $F1,$2D,$F2,$2D,$DE,$2D,$DF,$2D
                    .db $F1,$2D,$F2,$2D,$DD,$6D,$FF,$58
                    .db $00,$00,$3F,$7D,$39,$7E,$39,$7D
                    .db $39,$7E,$39,$7D,$39,$7E,$39,$7D
                    .db $39,$7E,$39,$7D,$39,$7E,$39,$7D
                    .db $39,$7E,$39,$7D,$39,$7E,$39,$7D
                    .db $39,$7E,$39,$7D,$39,$7E,$39,$7D
                    .db $39,$7E,$39,$7D,$39,$7E,$39,$7D
                    .db $39,$7E,$39,$7D,$39,$7E,$39,$7D
                    .db $39,$7E,$39,$7D,$39,$7E,$39,$7D
                    .db $39,$7E,$39,$58,$20,$47,$7E,$8E
                    .db $39,$5C,$00,$00,$3F,$7D,$39,$7E
                    .db $39,$7D,$39,$7E,$39,$7D,$39,$7E
                    .db $39,$7D,$39,$7E,$39,$7D,$39,$7E
                    .db $39,$7D,$39,$7E,$39,$7D,$39,$7E
                    .db $39,$7D,$39,$7E,$39,$7D,$39,$7E
                    .db $39,$7D,$39,$7E,$39,$7D,$39,$7E
                    .db $39,$7D,$39,$7E,$39,$7D,$39,$7E
                    .db $39,$7D,$39,$7E,$39,$7D,$39,$7E
                    .db $39,$7D,$39,$7E,$39,$5C,$20,$47
                    .db $7E,$8E,$39,$FF,$53,$A0,$00,$03
                    .db $FF,$60,$9E,$61,$53,$B8,$00,$01
                    .db $9E,$21,$53,$B9,$40,$0C,$FF,$20
                    .db $53,$C0,$00,$03,$FF,$60,$9E,$E1
                    .db $53,$D8,$00,$01,$9E,$A1,$53,$D9
                    .db $40,$0C,$FF,$20,$53,$E0,$40,$08
                    .db $FF,$60,$53,$E5,$00,$01,$9E,$61
                    .db $53,$EA,$00,$0B,$9E,$21,$FF,$20
                    .db $FF,$20,$FF,$20,$FF,$60,$9E,$61
                    .db $53,$FB,$00,$01,$9E,$21,$53,$FC
                    .db $40,$06,$FF,$20,$58,$00,$40,$08
                    .db $FF,$60,$58,$05,$00,$01,$9E,$E1
                    .db $58,$0A,$00,$0B,$9E,$A1,$FF,$20
                    .db $FF,$20,$FF,$20,$FF,$60,$9E,$E1
                    .db $58,$1B,$00,$01,$9E,$A1,$58,$1C
                    .db $40,$06,$FF,$20,$58,$60,$80,$0F
                    .db $FF,$20,$FF,$20,$8F,$61,$8F,$E1
                    .db $FF,$20,$FF,$20,$FF,$60,$FF,$60
                    .db $58,$61,$80,$0F,$FF,$20,$FF,$20
                    .db $FC,$60,$FC,$60,$FF,$20,$FF,$20
                    .db $9E,$61,$9E,$E1,$58,$62,$00,$03
                    .db $FF,$60,$9E,$61,$58,$82,$00,$03
                    .db $FF,$60,$9E,$E1,$58,$E2,$40,$06
                    .db $FF,$20,$58,$E6,$00,$03,$FF,$60
                    .db $9E,$61,$59,$02,$40,$06,$FF,$20
                    .db $59,$06,$00,$03,$FF,$60,$9E,$E1
                    .db $58,$6C,$00,$01,$9E,$21,$58,$6D
                    .db $40,$24,$FF,$20,$58,$8C,$00,$01
                    .db $9E,$A1,$58,$8D,$40,$24,$FF,$20
                    .db $58,$B2,$00,$01,$9E,$21,$58,$B3
                    .db $40,$18,$FF,$20,$58,$D2,$00,$01
                    .db $9E,$A1,$58,$D3,$40,$18,$FF,$20
                    .db $58,$FC,$00,$07,$FC,$20,$8F,$21
                    .db $FF,$20,$FF,$20,$59,$1C,$00,$07
                    .db $FC,$20,$8F,$A1,$FF,$20,$FF,$20
                    .db $59,$2E,$00,$0B,$9E,$21,$FF,$20
                    .db $FF,$20,$FF,$20,$FF,$60,$9E,$61
                    .db $59,$4E,$00,$0B,$9E,$A1,$FF,$20
                    .db $FF,$20,$FF,$20,$FF,$60,$9E,$E1
                    .db $59,$38,$00,$01,$9E,$21,$59,$39
                    .db $40,$0C,$FF,$20,$59,$58,$00,$01
                    .db $9E,$A1,$59,$59,$40,$0C,$FF,$20
                    .db $59,$A4,$00,$01,$9E,$21,$59,$A5
                    .db $40,$0E,$FF,$20,$59,$AD,$00,$05
                    .db $FF,$60,$FF,$60,$9E,$61,$59,$C4
                    .db $00,$01,$9E,$A1,$59,$C5,$40,$0E
                    .db $FF,$20,$59,$CD,$00,$05,$FF,$60
                    .db $FF,$60,$9E,$E1,$59,$E0,$00,$03
                    .db $FF,$60,$9E,$61,$5A,$00,$00,$03
                    .db $FF,$60,$9E,$E1,$59,$E8,$00,$01
                    .db $9E,$21,$59,$E9,$40,$12,$FF,$20
                    .db $59,$F3,$00,$05,$FF,$60,$FF,$60
                    .db $9E,$61,$5A,$08,$00,$01,$9E,$A1
                    .db $5A,$09,$40,$12,$FF,$20,$5A,$13
                    .db $00,$05,$FF,$60,$FF,$60,$9E,$E1
                    .db $59,$FC,$00,$07,$9E,$21,$FF,$20
                    .db $FF,$20,$FF,$20,$5A,$1C,$00,$07
                    .db $9E,$A1,$FF,$20,$FF,$20,$FF,$20
                    .db $5A,$2E,$00,$03,$FC,$20,$8F,$21
                    .db $5A,$30,$40,$0C,$FF,$20,$5A,$37
                    .db $00,$05,$FF,$60,$FF,$60,$9E,$61
                    .db $5A,$4E,$00,$03,$FC,$20,$8F,$A1
                    .db $5A,$50,$40,$0C,$FF,$20,$5A,$57
                    .db $00,$05,$FF,$60,$FF,$60,$9E,$E1
                    .db $5A,$6C,$00,$0B,$9E,$21,$FF,$20
                    .db $FF,$20,$FF,$20,$FF,$60,$9E,$61
                    .db $5A,$8C,$00,$0B,$9E,$A1,$FF,$20
                    .db $FF,$20,$FF,$20,$FF,$60,$9E,$E1
                    .db $57,$A0,$00,$03,$FF,$60,$9E,$61
                    .db $57,$B8,$00,$01,$9E,$21,$57,$B9
                    .db $40,$0C,$FF,$20,$57,$C0,$00,$03
                    .db $FF,$60,$9E,$E1,$57,$D8,$00,$01
                    .db $9E,$A1,$57,$D9,$40,$0C,$FF,$20
                    .db $57,$E0,$40,$08,$FF,$60,$57,$E5
                    .db $00,$01,$9E,$61,$57,$EA,$00,$0B
                    .db $9E,$21,$FF,$20,$FF,$20,$FF,$20
                    .db $FF,$20,$9E,$61,$57,$FB,$00,$01
                    .db $9E,$21,$57,$FC,$40,$06,$FF,$20
                    .db $5C,$00,$40,$08,$FF,$60,$5C,$05
                    .db $00,$01,$9E,$E1,$5C,$0A,$00,$0B
                    .db $9E,$A1,$FF,$20,$FF,$20,$FF,$20
                    .db $FF,$60,$9E,$E1,$5C,$1B,$00,$01
                    .db $9E,$A1,$5C,$1C,$40,$06,$FF,$20
                    .db $5C,$60,$80,$0F,$FF,$20,$FF,$20
                    .db $8F,$61,$8F,$E1,$FF,$20,$FF,$20
                    .db $FF,$60,$FF,$60,$5C,$61,$80,$0F
                    .db $FF,$20,$FF,$20,$FC,$60,$FC,$60
                    .db $FF,$20,$FF,$20,$9E,$61,$9E,$E1
                    .db $5C,$62,$00,$03,$FF,$60,$9E,$61
                    .db $5C,$82,$00,$03,$FF,$60,$9E,$E1
                    .db $5C,$E2,$40,$06,$FF,$20,$5C,$E6
                    .db $00,$03,$FF,$60,$9E,$61,$5D,$02
                    .db $40,$06,$FF,$20,$5D,$06,$00,$03
                    .db $FF,$60,$9E,$E1,$5C,$6C,$00,$01
                    .db $9E,$21,$5C,$6D,$40,$24,$FF,$20
                    .db $5C,$8C,$00,$01,$9E,$A1,$5C,$8D
                    .db $40,$24,$FF,$20,$5C,$B2,$00,$01
                    .db $9E,$21,$5C,$B3,$40,$18,$FF,$20
                    .db $5C,$D2,$00,$01,$9E,$A1,$5C,$D3
                    .db $40,$18,$FF,$20,$5C,$FC,$00,$07
                    .db $FC,$20,$8F,$21,$FF,$20,$FF,$20
                    .db $5D,$1C,$00,$07,$FC,$20,$8F,$A1
                    .db $FF,$20,$FF,$20,$5D,$2E,$00,$0B
                    .db $9E,$21,$FF,$20,$FF,$20,$FF,$20
                    .db $FF,$60,$9E,$61,$5D,$4E,$00,$0B
                    .db $9E,$A1,$FF,$20,$FF,$20,$FF,$20
                    .db $FF,$60,$9E,$E1,$5D,$38,$00,$01
                    .db $9E,$21,$5D,$39,$40,$0C,$FF,$20
                    .db $5D,$58,$00,$01,$9E,$A1,$5D,$59
                    .db $40,$0C,$FF,$20,$5D,$A4,$00,$01
                    .db $9E,$21,$5D,$A5,$40,$0E,$FF,$20
                    .db $5D,$AD,$00,$05,$FF,$60,$FF,$60
                    .db $9E,$61,$5D,$C4,$00,$01,$9E,$A1
                    .db $5D,$C5,$40,$0E,$FF,$20,$5D,$CD
                    .db $00,$05,$FF,$60,$FF,$60,$9E,$E1
                    .db $5D,$E0,$00,$03,$FF,$60,$9E,$61
                    .db $5E,$00,$00,$03,$FF,$60,$9E,$E1
                    .db $5D,$E8,$00,$01,$9E,$21,$5D,$E9
                    .db $40,$12,$FF,$20,$5D,$F3,$00,$05
                    .db $FF,$60,$FF,$60,$9E,$61,$5E,$08
                    .db $00,$01,$9E,$A1,$5E,$09,$40,$12
                    .db $FF,$20,$5E,$13,$00,$05,$FF,$60
                    .db $FF,$60,$9E,$E1,$5D,$FC,$00,$07
                    .db $9E,$21,$FF,$20,$FF,$20,$FF,$20
                    .db $5E,$1C,$00,$07,$9E,$A1,$FF,$20
                    .db $FF,$20,$FF,$20,$5E,$2E,$00,$03
                    .db $FC,$20,$8F,$21,$5E,$30,$40,$0C
                    .db $FF,$20,$5E,$37,$00,$05,$FF,$60
                    .db $FF,$60,$9E,$61,$5E,$4E,$00,$03
                    .db $FC,$20,$8F,$A1,$5E,$50,$40,$0C
                    .db $FF,$20,$5E,$57,$00,$05,$FF,$60
                    .db $FF,$60,$9E,$E1,$5E,$6C,$00,$0B
                    .db $9E,$21,$FF,$20,$FF,$20,$FF,$20
                    .db $FF,$60,$9E,$61,$5E,$8C,$00,$0B
                    .db $9E,$A1,$FF,$20,$FF,$20,$FF,$20
                    .db $FF,$60,$9E,$E1,$FF,$51,$67,$00
                    .db $01,$9F,$39,$51,$93,$00,$01,$9F
                    .db $29,$51,$D1,$00,$01,$9F,$39,$52
                    .db $5A,$00,$01,$9F,$39,$52,$77,$00
                    .db $01,$9F,$29,$52,$79,$80,$03,$9F
                    .db $29,$9F,$39,$52,$8C,$00,$01,$9F
                    .db $29,$53,$3D,$00,$01,$9F,$39,$55
                    .db $67,$00,$01,$9F,$39,$55,$93,$00
                    .db $01,$9F,$29,$55,$D1,$00,$01,$9F
                    .db $39,$56,$5A,$00,$01,$9F,$39,$56
                    .db $77,$00,$01,$9F,$29,$56,$79,$80
                    .db $03,$9F,$29,$9F,$39,$56,$8C,$00
                    .db $01,$9F,$29,$57,$3D,$00,$01,$9F
                    .db $39,$58,$07,$00,$01,$9F,$39,$58
                    .db $33,$00,$01,$9F,$29,$58,$71,$00
                    .db $01,$9F,$39,$58,$FA,$00,$01,$9F
                    .db $39,$59,$17,$00,$01,$9F,$29,$59
                    .db $19,$80,$03,$9F,$29,$9F,$39,$59
                    .db $2C,$00,$01,$9F,$29,$59,$DD,$00
                    .db $01,$9F,$39,$5C,$07,$00,$01,$9F
                    .db $39,$5C,$33,$00,$01,$9F,$29,$5C
                    .db $71,$00,$01,$9F,$39,$5C,$FA,$00
                    .db $01,$9F,$39,$5D,$17,$00,$01,$9F
                    .db $29,$5D,$19,$80,$03,$9F,$29,$9F
                    .db $39,$5D,$2C,$00,$01,$9F,$29,$5D
                    .db $DD,$00,$01,$9F,$39,$FF,$58,$03
                    .db $00,$03,$80,$01,$81,$01,$58,$07
                    .db $00,$03,$80,$01,$81,$01,$58,$0F
                    .db $00,$07,$80,$01,$81,$01,$80,$01
                    .db $81,$01,$58,$15,$00,$0B,$80,$01
                    .db $81,$01,$80,$01,$81,$01,$80,$01
                    .db $81,$01,$58,$20,$00,$0F,$80,$01
                    .db $81,$01,$86,$15,$87,$15,$82,$15
                    .db $83,$15,$80,$01,$81,$01,$58,$22
                    .db $80,$05,$86,$15,$96,$15,$90,$15
                    .db $58,$23,$80,$05,$87,$15,$97,$15
                    .db $91,$15,$58,$2C,$80,$05,$86,$15
                    .db $96,$15,$90,$15,$58,$2D,$80,$05
                    .db $87,$15,$97,$15,$91,$15,$58,$2F
                    .db $80,$05,$86,$15,$96,$15,$90,$15
                    .db $58,$30,$80,$05,$87,$15,$97,$15
                    .db $91,$15,$58,$32,$80,$05,$86,$15
                    .db $96,$15,$90,$15,$58,$33,$80,$05
                    .db $87,$15,$97,$15,$91,$15,$58,$36
                    .db $00,$03,$80,$01,$81,$01,$58,$3A
                    .db $00,$03,$80,$01,$81,$01,$58,$3C
                    .db $80,$05,$86,$15,$96,$15,$90,$15
                    .db $58,$3D,$80,$05,$87,$15,$97,$15
                    .db $91,$15,$58,$45,$00,$03,$82,$15
                    .db $83,$15,$58,$8D,$00,$03,$80,$01
                    .db $81,$01,$58,$9E,$00,$03,$80,$01
                    .db $81,$01,$58,$BD,$00,$03,$80,$01
                    .db $81,$01,$58,$C7,$00,$03,$80,$01
                    .db $81,$01,$58,$D9,$00,$01,$81,$01
                    .db $58,$DC,$00,$07,$80,$01,$81,$01
                    .db $82,$15,$83,$15,$58,$E4,$00,$03
                    .db $80,$01,$81,$01,$58,$E8,$00,$07
                    .db $80,$01,$81,$01,$80,$01,$81,$01
                    .db $58,$F9,$00,$0D,$80,$01,$81,$01
                    .db $80,$01,$81,$01,$82,$15,$83,$15
                    .db $82,$15,$59,$02,$80,$05,$86,$15
                    .db $96,$15,$90,$15,$59,$03,$80,$05
                    .db $87,$15,$97,$15,$91,$15,$59,$05
                    .db $00,$0B,$80,$01,$81,$01,$82,$15
                    .db $83,$15,$80,$01,$81,$01,$59,$0C
                    .db $80,$05,$86,$15,$96,$15,$90,$15
                    .db $59,$0D,$80,$05,$87,$15,$97,$15
                    .db $91,$15,$59,$0F,$80,$05,$86,$15
                    .db $96,$15,$90,$15,$59,$10,$80,$05
                    .db $87,$15,$97,$15,$91,$15,$59,$12
                    .db $80,$05,$86,$15,$96,$15,$90,$15
                    .db $59,$13,$80,$05,$87,$15,$97,$15
                    .db $91,$15,$59,$1A,$00,$0B,$80,$01
                    .db $81,$01,$86,$15,$87,$15,$82,$15
                    .db $83,$15,$59,$1C,$80,$05,$86,$15
                    .db $96,$15,$90,$15,$59,$1D,$80,$05
                    .db $87,$15,$97,$15,$91,$15,$59,$24
                    .db $00,$0F,$80,$01,$81,$01,$82,$15
                    .db $83,$15,$82,$15,$83,$15,$80,$01
                    .db $81,$01,$59,$39,$00,$03,$80,$01
                    .db $81,$01,$59,$47,$00,$07,$80,$01
                    .db $81,$01,$82,$15,$83,$15,$59,$5A
                    .db $00,$0B,$80,$01,$81,$01,$90,$15
                    .db $91,$15,$80,$01,$81,$01,$59,$64
                    .db $00,$17,$80,$01,$81,$01,$82,$15
                    .db $83,$15,$80,$01,$81,$01,$80,$01
                    .db $81,$01,$80,$01,$81,$01,$80,$01
                    .db $81,$01,$59,$87,$00,$03,$80,$01
                    .db $81,$01,$59,$8B,$00,$07,$80,$01
                    .db $81,$01,$80,$01,$81,$01,$59,$98
                    .db $00,$03,$80,$01,$81,$01,$59,$A8
                    .db $00,$07,$80,$01,$81,$01,$82,$15
                    .db $83,$15,$59,$B9,$00,$03,$80,$01
                    .db $81,$01,$59,$C5,$00,$03,$80,$01
                    .db $81,$01,$59,$C9,$00,$07,$80,$01
                    .db $81,$01,$80,$01,$81,$01,$59,$D6
                    .db $00,$0F,$80,$01,$81,$01,$82,$15
                    .db $83,$15,$80,$01,$81,$01,$80,$01
                    .db $81,$01,$59,$E2,$80,$05,$86,$15
                    .db $96,$15,$90,$15,$59,$E3,$80,$05
                    .db $87,$15,$97,$15,$91,$15,$59,$EA
                    .db $00,$0B,$80,$01,$81,$01,$86,$15
                    .db $87,$15,$82,$15,$83,$15,$59,$EC
                    .db $80,$05,$86,$15,$96,$15,$90,$15
                    .db $59,$ED,$80,$05,$87,$15,$97,$15
                    .db $91,$15,$59,$EF,$80,$05,$86,$15
                    .db $96,$15,$90,$15,$59,$F0,$80,$05
                    .db $87,$15,$97,$15,$91,$15,$59,$F2
                    .db $80,$05,$86,$15,$96,$15,$90,$15
                    .db $59,$F3,$80,$05,$87,$15,$97,$15
                    .db $91,$15,$59,$F7,$00,$07,$82,$15
                    .db $83,$15,$82,$15,$83,$15,$59,$FC
                    .db $80,$05,$86,$15,$96,$15,$90,$15
                    .db $59,$FD,$80,$05,$87,$15,$97,$15
                    .db $91,$15,$5A,$14,$00,$0F,$80,$01
                    .db $81,$01,$82,$15,$83,$15,$80,$01
                    .db $81,$01,$82,$15,$83,$15,$5A,$20
                    .db $00,$01,$81,$01,$5A,$27,$00,$03
                    .db $80,$01,$81,$01,$5A,$35,$00,$0B
                    .db $80,$01,$81,$01,$80,$01,$81,$01
                    .db $82,$15,$83,$15,$5A,$40,$00,$07
                    .db $80,$01,$81,$01,$80,$01,$81,$01
                    .db $5A,$56,$00,$03,$80,$01,$81,$01
                    .db $5A,$5A,$00,$03,$80,$01,$81,$01
                    .db $5A,$60,$00,$09,$81,$01,$82,$15
                    .db $83,$15,$80,$01,$81,$01,$5A,$67
                    .db $00,$03,$80,$01,$81,$01,$5A,$79
                    .db $00,$07,$80,$01,$81,$01,$80,$01
                    .db $81,$01,$5A,$80,$00,$0B,$82,$15
                    .db $83,$15,$80,$01,$81,$01,$80,$01
                    .db $81,$01,$5A,$98,$00,$03,$80,$01
                    .db $81,$01,$5A,$9C,$00,$03,$80,$01
                    .db $81,$01,$5A,$A0,$00,$05,$83,$15
                    .db $80,$01,$81,$01,$5A,$A5,$00,$07
                    .db $80,$01,$81,$01,$80,$01,$81,$01
                    .db $5A,$C0,$00,$07,$82,$15,$83,$15
                    .db $82,$15,$83,$15,$5A,$C6,$00,$03
                    .db $80,$01,$81,$01,$5A,$CA,$00,$03
                    .db $80,$01,$81,$01,$5A,$E0,$00,$0D
                    .db $83,$15,$82,$15,$83,$15,$82,$15
                    .db $83,$15,$80,$01,$81,$01,$5A,$E9
                    .db $00,$03,$80,$01,$81,$01,$5C,$03
                    .db $00,$03,$80,$01,$81,$01,$5C,$07
                    .db $00,$03,$80,$01,$81,$01,$5C,$0F
                    .db $00,$07,$80,$01,$81,$01,$80,$01
                    .db $81,$01,$5C,$15,$00,$0B,$80,$01
                    .db $81,$01,$80,$01,$81,$01,$80,$01
                    .db $81,$01,$5C,$20,$00,$0F,$80,$01
                    .db $81,$01,$86,$15,$87,$15,$82,$15
                    .db $83,$15,$80,$01,$81,$01,$5C,$22
                    .db $80,$05,$86,$15,$96,$15,$90,$15
                    .db $5C,$23,$80,$05,$87,$15,$97,$15
                    .db $91,$15,$5C,$2C,$80,$05,$86,$15
                    .db $96,$15,$90,$15,$5C,$2D,$80,$05
                    .db $87,$15,$97,$15,$91,$15,$5C,$2F
                    .db $80,$05,$86,$15,$96,$15,$90,$15
                    .db $5C,$30,$80,$05,$87,$15,$97,$15
                    .db $91,$15,$5C,$32,$80,$05,$86,$15
                    .db $96,$15,$90,$15,$5C,$33,$80,$05
                    .db $87,$15,$97,$15,$91,$15,$5C,$36
                    .db $00,$03,$80,$01,$81,$01,$5C,$3A
                    .db $00,$03,$80,$01,$81,$01,$5C,$3C
                    .db $80,$05,$86,$15,$96,$15,$90,$15
                    .db $5C,$3D,$80,$05,$87,$15,$97,$15
                    .db $91,$15,$5C,$45,$00,$03,$82,$15
                    .db $83,$15,$5C,$8D,$00,$03,$80,$01
                    .db $81,$01,$5C,$9E,$00,$03,$80,$01
                    .db $81,$01,$5C,$BD,$00,$03,$80,$01
                    .db $81,$01,$5C,$C7,$00,$03,$80,$01
                    .db $81,$01,$5C,$D9,$00,$01,$81,$01
                    .db $5C,$DC,$00,$07,$80,$01,$81,$01
                    .db $82,$15,$83,$15,$5C,$E4,$00,$03
                    .db $80,$01,$81,$01,$5C,$E8,$00,$07
                    .db $80,$01,$81,$01,$80,$01,$81,$01
                    .db $5C,$F9,$00,$0D,$80,$01,$81,$01
                    .db $80,$01,$81,$01,$82,$15,$83,$15
                    .db $82,$15,$5D,$02,$80,$05,$86,$15
                    .db $96,$15,$90,$15,$5D,$03,$80,$05
                    .db $87,$15,$97,$15,$91,$15,$5D,$05
                    .db $00,$0B,$80,$01,$81,$01,$82,$15
                    .db $83,$15,$80,$01,$81,$01,$5D,$0C
                    .db $80,$05,$86,$15,$96,$15,$90,$15
                    .db $5D,$0D,$80,$05,$87,$15,$97,$15
                    .db $91,$15,$5D,$0F,$80,$05,$86,$15
                    .db $96,$15,$90,$15,$5D,$10,$80,$05
                    .db $87,$15,$97,$15,$91,$15,$5D,$12
                    .db $80,$05,$86,$15,$96,$15,$90,$15
                    .db $5D,$13,$80,$05,$87,$15,$97,$15
                    .db $91,$15,$5D,$1A,$00,$0B,$80,$01
                    .db $81,$01,$86,$15,$87,$15,$82,$15
                    .db $83,$15,$5D,$1C,$80,$05,$86,$15
                    .db $96,$15,$90,$15,$5D,$1D,$80,$05
                    .db $87,$15,$97,$15,$91,$15,$5D,$24
                    .db $00,$0F,$80,$01,$81,$01,$82,$15
                    .db $83,$15,$82,$15,$83,$15,$80,$01
                    .db $81,$01,$5D,$39,$00,$03,$80,$01
                    .db $81,$01,$5D,$47,$00,$07,$80,$01
                    .db $81,$01,$82,$15,$83,$15,$5D,$5A
                    .db $00,$0B,$80,$01,$81,$01,$90,$15
                    .db $91,$15,$80,$01,$81,$01,$5D,$64
                    .db $00,$17,$80,$01,$81,$01,$82,$15
                    .db $83,$15,$80,$01,$81,$01,$80,$01
                    .db $81,$01,$80,$01,$81,$01,$80,$01
                    .db $81,$01,$5D,$87,$00,$03,$80,$01
                    .db $81,$01,$5D,$8B,$00,$07,$80,$01
                    .db $81,$01,$80,$01,$81,$01,$5D,$98
                    .db $00,$03,$80,$01,$81,$01,$5D,$A8
                    .db $00,$07,$80,$01,$81,$01,$82,$15
                    .db $83,$15,$5D,$B9,$00,$03,$80,$01
                    .db $81,$01,$5D,$C5,$00,$03,$80,$01
                    .db $81,$01,$5D,$C9,$00,$07,$80,$01
                    .db $81,$01,$80,$01,$81,$01,$5D,$D6
                    .db $00,$0F,$80,$01,$81,$01,$82,$15
                    .db $83,$15,$80,$01,$81,$01,$80,$01
                    .db $81,$01,$5D,$E2,$80,$05,$86,$15
                    .db $96,$15,$90,$15,$5D,$E3,$80,$05
                    .db $87,$15,$97,$15,$91,$15,$5D,$EA
                    .db $00,$0B,$80,$01,$81,$01,$86,$15
                    .db $87,$15,$82,$15,$83,$15,$5D,$EC
                    .db $80,$05,$86,$15,$96,$15,$90,$15
                    .db $5D,$ED,$80,$05,$87,$15,$97,$15
                    .db $91,$15,$5D,$EF,$80,$05,$86,$15
                    .db $96,$15,$90,$15,$5D,$F0,$80,$05
                    .db $87,$15,$97,$15,$91,$15,$5D,$F2
                    .db $80,$05,$86,$15,$96,$15,$90,$15
                    .db $5D,$F3,$80,$05,$87,$15,$97,$15
                    .db $91,$15,$5D,$F7,$00,$07,$82,$15
                    .db $83,$15,$82,$15,$83,$15,$5D,$FC
                    .db $80,$05,$86,$15,$96,$15,$90,$15
                    .db $5D,$FD,$80,$05,$87,$15,$97,$15
                    .db $91,$15,$5E,$14,$00,$0F,$80,$01
                    .db $81,$01,$82,$15,$83,$15,$80,$01
                    .db $81,$01,$82,$15,$83,$15,$5E,$20
                    .db $00,$01,$81,$01,$5E,$27,$00,$03
                    .db $80,$01,$81,$01,$5E,$35,$00,$0B
                    .db $80,$01,$81,$01,$80,$01,$81,$01
                    .db $82,$15,$83,$15,$5E,$40,$00,$07
                    .db $80,$01,$81,$01,$80,$01,$81,$01
                    .db $5E,$56,$00,$03,$80,$01,$81,$01
                    .db $5E,$5A,$00,$03,$80,$01,$81,$01
                    .db $5E,$60,$00,$09,$81,$01,$82,$15
                    .db $83,$15,$80,$01,$81,$01,$5E,$67
                    .db $00,$03,$80,$01,$81,$01,$5E,$79
                    .db $00,$07,$80,$01,$81,$01,$80,$01
                    .db $81,$01,$5E,$80,$00,$0B,$82,$15
                    .db $83,$15,$80,$01,$81,$01,$80,$01
                    .db $81,$01,$5E,$98,$00,$03,$80,$01
                    .db $81,$01,$5E,$9C,$00,$03,$80,$01
                    .db $81,$01,$5E,$A0,$00,$05,$83,$15
                    .db $80,$01,$81,$01,$5E,$A5,$00,$07
                    .db $80,$01,$81,$01,$80,$01,$81,$01
                    .db $5E,$C0,$00,$07,$82,$15,$83,$15
                    .db $82,$15,$83,$15,$5E,$C6,$00,$03
                    .db $80,$01,$81,$01,$5E,$CA,$00,$03
                    .db $80,$01,$81,$01,$5E,$E0,$00,$0D
                    .db $83,$15,$82,$15,$83,$15,$82,$15
                    .db $83,$15,$80,$01,$81,$01,$5E,$E9
                    .db $00,$03,$80,$01,$81,$01,$FF,$53
                    .db $DA,$00,$05,$F9,$11,$FA,$11,$FB
                    .db $11,$53,$FA,$00,$05,$FC,$11,$FD
                    .db $11,$FE,$11,$58,$3C,$00,$01,$DA
                    .db $11,$58,$6D,$00,$05,$F9,$11,$FA
                    .db $11,$FB,$11,$58,$8D,$00,$05,$FC
                    .db $11,$FD,$11,$FE,$11,$58,$E5,$00
                    .db $07,$92,$11,$95,$11,$98,$11,$AD
                    .db $11,$59,$05,$00,$07,$B1,$11,$B5
                    .db $11,$C4,$51,$B9,$11,$59,$25,$00
                    .db $07,$BD,$11,$C4,$11,$C4,$51,$D8
                    .db $11,$59,$45,$00,$0D,$D6,$11,$D8
                    .db $11,$C9,$11,$CA,$11,$F9,$15,$FA
                    .db $15,$FB,$15,$59,$65,$00,$0D,$C9
                    .db $11,$CA,$11,$CB,$11,$DA,$11,$FC
                    .db $15,$FD,$15,$FE,$15,$59,$85,$00
                    .db $0D,$CB,$11,$DA,$11,$CB,$11,$92
                    .db $11,$95,$11,$98,$11,$AD,$11,$59
                    .db $A4,$00,$0F,$F3,$11,$F4,$11,$F5
                    .db $11,$FC,$38,$B1,$11,$B5,$11,$C4
                    .db $51,$B9,$11,$59,$C4,$00,$0F,$F6
                    .db $11,$F7,$11,$F8,$11,$DA,$05,$BD
                    .db $11,$C4,$11,$C4,$51,$D8,$11,$59
                    .db $CF,$00,$05,$F9,$15,$FA,$15,$FB
                    .db $15,$59,$E3,$00,$1D,$CB,$15,$FC
                    .db $11,$FD,$11,$FE,$11,$FC,$38,$D6
                    .db $11,$D8,$11,$C9,$11,$CA,$11,$F3
                    .db $15,$F4,$15,$F5,$15,$FC,$15,$FD
                    .db $15,$FE,$15,$5A,$08,$00,$17,$C9
                    .db $11,$CA,$11,$CB,$11,$DA,$11,$F6
                    .db $15,$F7,$15,$F8,$15,$F9,$55,$FC
                    .db $0D,$F3,$15,$F4,$15,$F5,$15,$5A
                    .db $28,$00,$19,$CB,$11,$DA,$11,$CB
                    .db $11,$DA,$11,$FD,$15,$FD,$15,$FE
                    .db $15,$DA,$55,$F9,$15,$F6,$15,$F7
                    .db $15,$F8,$15,$FB,$15,$5A,$49,$00
                    .db $17,$DA,$15,$F9,$05,$FA,$05,$FB
                    .db $05,$FC,$38,$FC,$38,$DA,$15,$FE
                    .db $15,$FC,$15,$FD,$15,$FE,$15,$DA
                    .db $55,$5A,$6A,$00,$09,$FC,$05,$FD
                    .db $05,$FE,$05,$FC,$38,$DA,$05,$58
                    .db $F6,$00,$05,$F9,$11,$FA,$11,$FB
                    .db $11,$59,$13,$00,$0B,$F9,$11,$FA
                    .db $11,$FB,$11,$FC,$11,$FD,$11,$FE
                    .db $11,$59,$31,$00,$09,$F9,$15,$FA
                    .db $15,$FB,$15,$FD,$11,$FE,$11,$59
                    .db $51,$00,$11,$FC,$15,$FD,$15,$FE
                    .db $15,$F3,$11,$F4,$11,$F5,$11,$FC
                    .db $11,$FD,$11,$FE,$11,$59,$72,$00
                    .db $0B,$FC,$15,$F9,$15,$F6,$11,$F7
                    .db $11,$F8,$11,$DA,$51,$59,$92,$00
                    .db $0D,$DA,$15,$FE,$15,$FC,$11,$FD
                    .db $11,$FE,$11,$FC,$11,$DA,$55,$57
                    .db $DA,$00,$05,$F9,$11,$FA,$11,$FB
                    .db $11,$57,$FA,$00,$05,$FC,$11,$FD
                    .db $11,$FE,$11,$5C,$3C,$00,$01,$DA
                    .db $11,$5C,$6D,$00,$05,$F9,$11,$FA
                    .db $11,$FB,$11,$5C,$8D,$00,$05,$FC
                    .db $11,$FD,$11,$FE,$11,$5C,$E5,$00
                    .db $07,$92,$11,$95,$11,$98,$11,$AD
                    .db $11,$5D,$05,$00,$07,$B1,$11,$B5
                    .db $11,$C4,$51,$B9,$11,$5D,$25,$00
                    .db $07,$BD,$11,$C4,$11,$C4,$51,$D8
                    .db $11,$5D,$45,$00,$0D,$D6,$11,$D8
                    .db $11,$C9,$11,$CA,$11,$F9,$51,$FA
                    .db $51,$FB,$51,$5D,$65,$00,$0D,$C9
                    .db $11,$CA,$11,$CB,$11,$DA,$11,$FC
                    .db $51,$FD,$51,$FE,$51,$5D,$85,$00
                    .db $0D,$CB,$11,$DA,$11,$CB,$11,$92
                    .db $11,$95,$11,$98,$11,$AD,$11,$5D
                    .db $A4,$00,$0F,$F3,$11,$F4,$11,$F5
                    .db $11,$FC,$38,$B1,$11,$B5,$11,$C4
                    .db $51,$B9,$11,$5D,$C4,$00,$0F,$F6
                    .db $11,$F7,$11,$F8,$11,$DA,$05,$BD
                    .db $11,$C4,$11,$C4,$51,$D8,$11,$5D
                    .db $CF,$00,$05,$F9,$15,$FA,$15,$FB
                    .db $15,$5D,$E3,$00,$1D,$CB,$15,$FC
                    .db $11,$FD,$11,$FE,$11,$FC,$38,$D6
                    .db $11,$D8,$11,$C9,$11,$CA,$11,$F3
                    .db $15,$F4,$15,$F5,$15,$FC,$15,$FD
                    .db $15,$FE,$15,$5E,$08,$00,$17,$C9
                    .db $11,$CA,$11,$CB,$11,$DA,$11,$F6
                    .db $15,$F7,$15,$F8,$15,$F9,$55,$FC
                    .db $0D,$F3,$15,$F4,$15,$F5,$15,$5E
                    .db $28,$00,$19,$CB,$11,$DA,$11,$CB
                    .db $11,$DA,$11,$FD,$15,$FD,$15,$FE
                    .db $15,$DA,$55,$F9,$15,$F6,$15,$F7
                    .db $15,$F8,$15,$FB,$15,$5E,$49,$00
                    .db $17,$DA,$15,$F9,$05,$FA,$05,$FB
                    .db $05,$FC,$38,$FC,$38,$DA,$15,$FE
                    .db $15,$FC,$15,$FD,$15,$FE,$15,$DA
                    .db $55,$5E,$6A,$00,$09,$FC,$05,$FD
                    .db $05,$FE,$05,$FC,$38,$DA,$05,$5C
                    .db $F6,$00,$05,$F9,$11,$FA,$11,$FB
                    .db $11,$5D,$13,$00,$0B,$F9,$11,$FA
                    .db $11,$FB,$11,$FC,$11,$FD,$11,$FE
                    .db $11,$5D,$31,$00,$09,$F9,$15,$FA
                    .db $15,$FB,$15,$FD,$11,$FE,$11,$5D
                    .db $51,$00,$11,$FC,$15,$FD,$15,$FE
                    .db $15,$F3,$11,$F4,$11,$F5,$11,$FC
                    .db $11,$FD,$11,$FE,$11,$5D,$72,$00
                    .db $0B,$FC,$15,$F9,$15,$F6,$11,$F7
                    .db $11,$F8,$11,$DA,$51,$5D,$92,$00
                    .db $0D,$DA,$15,$FE,$15,$FC,$11,$FD
                    .db $11,$FE,$11,$FC,$11,$DA,$55,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF

DATA_05A580:        .db $51,$A7,$51,$87,$51,$67,$51,$47
                    .db $51,$27,$51,$07,$50,$E7,$50,$C7
DATA_05A590:        .db $14,$45,$3F,$08,$00,$29,$AA,$27
                    .db $26,$84,$95,$A9,$15,$13,$CE,$A7
                    .db $A4,$25,$A5,$05,$A6,$2A,$28

DATA_05A5A7:        .db $8D,$00,$8D,$00,$8D,$00,$8D,$00
                    .db $00,$00,$91,$02,$1D,$04,$18,$05
                    .db $1D,$06,$B7,$08,$B2,$07,$0B,$03
                    .db $3C,$08,$9D,$09,$9E,$0A,$A0,$04
                    .db $2C,$0A,$A6,$06,$30,$07,$11,$09
                    .db $A4,$05,$8F,$03,$09,$01,$0A,$02
                    .db $91,$01

DATA_05A5D9:        .db $16,$44,$4B,$42,$4E,$4C,$44,$1A
                    .db $1F,$1F,$1F,$13,$47,$48,$52,$1F
                    .db $48,$D2,$03,$48,$4D,$4E,$52,$40
                    .db $54,$51,$1F,$0B,$40,$4D,$43,$1B
                    .db $1F,$1F,$08,$CD,$53,$47,$48,$52
                    .db $1F,$52,$53,$51,$40,$4D,$46,$44
                    .db $1F,$1F,$4B,$40,$4D,$C3,$56,$44
                    .db $1F,$1F,$1F,$1F,$45,$48,$4D,$43
                    .db $1F,$1F,$1F,$1F,$53,$47,$40,$D3
                    .db $0F,$51,$48,$4D,$42,$44,$52,$52
                    .db $1F,$13,$4E,$40,$43,$52,$53,$4E
                    .db $4E,$CB,$48,$52,$1F,$1F,$4C,$48
                    .db $52,$52,$48,$4D,$46,$1F,$40,$46
                    .db $40,$48,$4D,$9A,$0B,$4E,$4E,$4A
                    .db $52,$1F,$1F,$4B,$48,$4A,$44,$1F
                    .db $01,$4E,$56,$52,$44,$D1,$48,$52
                    .db $1F,$40,$53,$1F,$48,$53,$1F,$40
                    .db $46,$40,$48,$4D,$9A,$1C,$1F,$12
                    .db $16,$08,$13,$02,$07,$1F,$0F,$00
                    .db $0B,$00,$02,$04,$1F,$9C,$13,$47
                    .db $44,$1F,$1F,$4F,$4E,$56,$44,$51
                    .db $1F,$1F,$4E,$45,$1F,$53,$47,$C4
                    .db $52,$56,$48,$53,$42,$47,$1F,$1F
                    .db $58,$4E,$54,$1F,$1F,$1F,$47,$40
                    .db $55,$C4,$4F,$54,$52,$47,$44,$43
                    .db $1F,$1F,$56,$48,$4B,$4B,$1F,$1F
                    .db $53,$54,$51,$CD,$9F,$1F,$1F,$1F
                    .db $1F,$1F,$1F,$48,$4D,$53,$4E,$1F
                    .db $1F,$1F,$1F,$1F,$9B,$18,$4E,$54
                    .db $51,$1F,$4F,$51,$4E,$46,$51,$44
                    .db $52,$52,$1F,$56,$48,$4B,$CB,$40
                    .db $4B,$52,$4E,$1F,$1F,$1F,$41,$44
                    .db $1F,$1F,$1F,$52,$40,$55,$44,$43
                    .db $9B,$07,$44,$4B,$4B,$4E,$1A,$1F
                    .db $1F,$1F,$12,$4E,$51,$51,$58,$1F
                    .db $08,$5D,$CC,$4D,$4E,$53,$1F,$1F
                    .db $47,$4E,$4C,$44,$1D,$1F,$1F,$41
                    .db $54,$53,$1F,$1F,$88,$47,$40,$55
                    .db $44,$1F,$1F,$1F,$1F,$46,$4E,$4D
                    .db $44,$1F,$1F,$1F,$1F,$53,$CE,$51
                    .db $44,$52,$42,$54,$44,$1F,$1F,$4C
                    .db $58,$1F,$45,$51,$48,$44,$4D,$43
                    .db $D2,$56,$47,$4E,$1F,$56,$44,$51
                    .db $44,$1F,$1F,$42,$40,$4F,$53,$54
                    .db $51,$44,$C3,$41,$58,$1F,$01,$4E
                    .db $56,$52,$44,$51,$9B,$1F,$1F,$1F
                    .db $1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F
                    .db $1F,$1F,$1F,$1F,$1F,$60,$E1,$1F
                    .db $1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F
                    .db $1C,$1F,$18,$4E,$52,$47,$48,$62
                    .db $E3,$07,$4E,$4E,$51,$40,$58,$1A
                    .db $1F,$1F,$13,$47,$40,$4D,$4A,$1F
                    .db $58,$4E,$D4,$45,$4E,$51,$1F,$51
                    .db $44,$52,$42,$54,$48,$4D,$46,$1F
                    .db $1F,$1F,$4C,$44,$9B,$0C,$58,$1F
                    .db $4D,$40,$4C,$44,$1F,$1F,$48,$52
                    .db $1F,$18,$4E,$52,$47,$48,$9B,$0E
                    .db $4D,$1F,$1F,$1F,$4C,$58,$1F,$1F
                    .db $1F,$56,$40,$58,$1F,$1F,$1F,$53
                    .db $CE,$51,$44,$52,$42,$54,$44,$1F
                    .db $4C,$58,$1F,$45,$51,$48,$44,$4D
                    .db $43,$52,$9D,$01,$4E,$56,$52,$44
                    .db $51,$1F,$53,$51,$40,$4F,$4F,$44
                    .db $43,$1F,$1F,$4C,$C4,$48,$4D,$1F
                    .db $53,$47,$40,$53,$1F,$44,$46,$46
                    .db $9B,$9F,$08,$53,$1F,$48,$52,$1F
                    .db $4F,$4E,$52,$52,$48,$41,$4B,$44
                    .db $1F,$1F,$53,$CE,$45,$48,$4B,$4B
                    .db $1F,$48,$4D,$1F,$53,$47,$44,$1F
                    .db $43,$4E,$53,$53,$44,$C3,$4B,$48
                    .db $4D,$44,$1F,$41,$4B,$4E,$42,$4A
                    .db $52,$1B,$1F,$1F,$1F,$1F,$13,$CE
                    .db $45,$48,$4B,$4B,$1F,$48,$4D,$1F
                    .db $53,$47,$44,$1F,$58,$44,$4B,$4B
                    .db $4E,$D6,$4E,$4D,$44,$52,$1D,$1F
                    .db $49,$54,$52,$53,$1F,$46,$4E,$1F
                    .db $56,$44,$52,$D3,$53,$47,$44,$4D
                    .db $1F,$4D,$4E,$51,$53,$47,$1F,$1F
                    .db $53,$4E,$1F,$53,$47,$C4,$53,$4E
                    .db $4F,$1F,$1F,$1F,$1F,$1F,$4E,$45
                    .db $1F,$1F,$1F,$1F,$1F,$53,$47,$C4
                    .db $4C,$4E,$54,$4D,$53,$40,$48,$4D
                    .db $9B,$1C,$0F,$0E,$08,$0D,$13,$1F
                    .db $0E,$05,$1F,$00,$03,$15,$08,$02
                    .db $04,$9C,$18,$4E,$54,$1F,$1F,$42
                    .db $40,$4D,$1F,$1F,$47,$4E,$4B,$43
                    .db $1F,$1F,$40,$CD,$44,$57,$53,$51
                    .db $40,$1F,$48,$53,$44,$4C,$1F,$1F
                    .db $48,$4D,$1F,$53,$47,$C4,$41,$4E
                    .db $57,$1F,$40,$53,$1F,$1F,$53,$47
                    .db $44,$1F,$53,$4E,$4F,$1F,$4E,$C5
                    .db $53,$47,$44,$1F,$52,$42,$51,$44
                    .db $44,$4D,$1B,$1F,$1F,$1F,$1F,$1F
                    .db $13,$CE,$54,$52,$44,$1F,$48,$53
                    .db $1D,$1F,$1F,$4F,$51,$44,$52,$52
                    .db $1F,$53,$47,$C4,$12,$04,$0B,$04
                    .db $02,$13,$1F,$01,$54,$53,$53,$4E
                    .db $4D,$9B,$9F,$1C,$0F,$0E,$08,$0D
                    .db $13,$1F,$0E,$05,$1F,$00,$03,$15
                    .db $08,$02,$04,$9C,$13,$4E,$1F,$1F
                    .db $1F,$4F,$48,$42,$4A,$1F,$1F,$1F
                    .db $54,$4F,$1F,$1F,$1F,$C0,$52,$47
                    .db $44,$4B,$4B,$1D,$1F,$1F,$54,$52
                    .db $44,$1F,$1F,$53,$47,$44,$1F,$97
                    .db $4E,$51,$1F,$1F,$18,$1F,$1F,$01
                    .db $54,$53,$53,$4E,$4D,$1B,$1F,$1F
                    .db $13,$CE,$53,$47,$51,$4E,$56,$1F
                    .db $1F,$1F,$1F,$40,$1F,$1F,$1F,$52
                    .db $47,$44,$4B,$CB,$54,$4F,$56,$40
                    .db $51,$43,$52,$1D,$1F,$1F,$4B,$4E
                    .db $4E,$4A,$1F,$1F,$54,$CF,$40,$4D
                    .db $43,$1F,$4B,$44,$53,$1F,$46,$4E
                    .db $1F,$4E,$45,$1F,$1F,$53,$47,$C4
                    .db $41,$54,$53,$53,$4E,$4D,$9B,$13
                    .db $4E,$1F,$43,$4E,$1F,$40,$1F,$52
                    .db $4F,$48,$4D,$1F,$49,$54,$4C,$4F
                    .db $9D,$4F,$51,$44,$52,$52,$1F,$1F
                    .db $1F,$1F,$53,$47,$44,$1F,$1F,$1F
                    .db $1F,$1F,$80,$01,$54,$53,$53,$4E
                    .db $4D,$1B,$1F,$1F,$1F,$1F,$00,$1F
                    .db $12,$54,$4F,$44,$D1,$0C,$40,$51
                    .db $48,$4E,$1F,$1F,$1F,$52,$4F,$48
                    .db $4D,$1F,$1F,$49,$54,$4C,$CF,$42
                    .db $40,$4D,$1F,$41,$51,$44,$40,$4A
                    .db $1F,$52,$4E,$4C,$44,$1F,$1F,$4E
                    .db $C5,$53,$47,$44,$1F,$1F,$1F,$41
                    .db $4B,$4E,$42,$4A,$52,$1F,$1F,$1F
                    .db $40,$4D,$C3,$43,$44,$45,$44,$40
                    .db $53,$1F,$52,$4E,$4C,$44,$1F,$4E
                    .db $45,$1F,$53,$47,$C4,$53,$4E,$54
                    .db $46,$47,$44,$51,$1F,$44,$4D,$44
                    .db $4C,$48,$44,$52,$9B,$1C,$0F,$0E
                    .db $08,$0D,$13,$1F,$0E,$05,$1F,$00
                    .db $03,$15,$08,$02,$04,$9C,$13,$47
                    .db $48,$52,$1F,$1F,$1F,$46,$40,$53
                    .db $44,$1F,$1F,$4C,$40,$51,$4A,$D2
                    .db $53,$47,$44,$1F,$4C,$48,$43,$43
                    .db $4B,$44,$1F,$4E,$45,$1F,$53,$47
                    .db $48,$D2,$40,$51,$44,$40,$1B,$1F
                    .db $1F,$1F,$01,$58,$1F,$42,$54,$53
                    .db $53,$48,$4D,$C6,$53,$47,$44,$1F
                    .db $53,$40,$4F,$44,$1F,$47,$44,$51
                    .db $44,$1D,$1F,$58,$4E,$D4,$42,$40
                    .db $4D,$1F,$42,$4E,$4D,$53,$48,$4D
                    .db $54,$44,$1F,$1F,$45,$51,$4E,$CC
                    .db $42,$4B,$4E,$52,$44,$1F,$1F,$1F
                    .db $53,$4E,$1F,$1F,$1F,$1F,$53,$47
                    .db $48,$D2,$4F,$4E,$48,$4D,$53,$9B
                    .db $1C,$0F,$0E,$08,$0D,$13,$1F,$0E
                    .db $05,$1F,$00,$03,$15,$08,$02,$04
                    .db $9C,$13,$47,$44,$1F,$41,$48,$46
                    .db $1F,$42,$4E,$48,$4D,$52,$1F,$1F
                    .db $40,$51,$C4,$03,$51,$40,$46,$4E
                    .db $4D,$1F,$02,$4E,$48,$4D,$52,$1B
                    .db $1F,$1F,$1F,$08,$C5,$58,$4E,$54
                    .db $1F,$1F,$4F,$48,$42,$4A,$1F,$54
                    .db $4F,$1F,$1F,$45,$48,$55,$C4,$4E
                    .db $45,$1F,$1F,$53,$47,$44,$52,$44
                    .db $1F,$1F,$48,$4D,$1F,$1F,$4E,$4D
                    .db $C4,$40,$51,$44,$40,$1D,$1F,$1F
                    .db $58,$4E,$54,$1F,$1F,$46,$44,$53
                    .db $1F,$40,$CD,$44,$57,$53,$51,$40
                    .db $1F,$0C,$40,$51,$48,$4E,$9B,$9F
                    .db $16,$47,$44,$4D,$1F,$58,$4E,$54
                    .db $1F,$1F,$52,$53,$4E,$4C,$4F,$1F
                    .db $4E,$CD,$40,$4D,$1F,$44,$4D,$44
                    .db $4C,$58,$1D,$1F,$1F,$58,$4E,$54
                    .db $1F,$42,$40,$CD,$49,$54,$4C,$4F
                    .db $1F,$47,$48,$46,$47,$1F,$1F,$48
                    .db $45,$1F,$1F,$58,$4E,$D4,$47,$4E
                    .db $4B,$43,$1F,$1F,$1F,$1F,$53,$47
                    .db $44,$1F,$1F,$1F,$49,$54,$4C,$CF
                    .db $41,$54,$53,$53,$4E,$4D,$1B,$1F
                    .db $1F,$14,$52,$44,$1F,$14,$4F,$1F
                    .db $4E,$CD,$53,$47,$44,$1F,$02,$4E
                    .db $4D,$53,$51,$4E,$4B,$1F,$0F,$40
                    .db $43,$1F,$53,$CE,$49,$54,$4C,$4F
                    .db $1F,$47,$48,$46,$47,$1F,$1F,$48
                    .db $4D,$1F,$1F,$53,$47,$C4,$52,$47
                    .db $40,$4B,$4B,$4E,$56,$1F,$56,$40
                    .db $53,$44,$51,$9B,$08,$45,$1F,$1F
                    .db $58,$4E,$54,$1F,$40,$51,$44,$1F
                    .db $1F,$48,$4D,$1F,$40,$CD,$40,$51
                    .db $44,$40,$1F,$53,$47,$40,$53,$1F
                    .db $58,$4E,$54,$1F,$47,$40,$55,$C4
                    .db $40,$4B,$51,$44,$40,$43,$58,$1F
                    .db $1F,$1F,$42,$4B,$44,$40,$51,$44
                    .db $43,$9D,$58,$4E,$54,$1F,$42,$40
                    .db $4D,$1F,$1F,$51,$44,$53,$54,$51
                    .db $4D,$1F,$53,$CE,$53,$47,$44,$1F
                    .db $4C,$40,$4F,$1F,$52,$42,$51,$44
                    .db $44,$4D,$1F,$1F,$41,$D8,$4F,$51
                    .db $44,$52,$52,$48,$4D,$46,$1F,$1F
                    .db $1F,$1F,$12,$13,$00,$11,$13,$9D
                    .db $53,$47,$44,$4D,$1F,$12,$04,$0B
                    .db $04,$02,$13,$9B,$9F,$18,$4E,$54
                    .db $1F,$1F,$1F,$46,$44,$53,$1F,$1F
                    .db $1F,$1F,$01,$4E,$4D,$54,$D2,$12
                    .db $53,$40,$51,$52,$1F,$1F,$48,$45
                    .db $1F,$1F,$58,$4E,$54,$1F,$42,$54
                    .db $D3,$53,$47,$44,$1F,$1F,$53,$40
                    .db $4F,$44,$1F,$1F,$40,$53,$1F,$1F
                    .db $53,$47,$C4,$44,$4D,$43,$1F,$1F
                    .db $4E,$45,$1F,$44,$40,$42,$47,$1F
                    .db $40,$51,$44,$40,$9B,$08,$45,$1F
                    .db $58,$4E,$54,$1F,$42,$4E,$4B,$4B
                    .db $44,$42,$53,$1F,$64,$6B,$EB,$01
                    .db $4E,$4D,$54,$52,$1F,$1F,$12,$53
                    .db $40,$51,$52,$1F,$1F,$1F,$58,$4E
                    .db $D4,$42,$40,$4D,$1F,$1F,$1F,$4F
                    .db $4B,$40,$58,$1F,$1F,$40,$1F,$1F
                    .db $45,$54,$CD,$41,$4E,$4D,$54,$52
                    .db $1F,$46,$40,$4C,$44,$9B,$0F,$51
                    .db $44,$52,$52,$1F,$14,$4F,$1F,$1F
                    .db $1F,$4E,$4D,$1F,$1F,$53,$47,$C4
                    .db $02,$4E,$4D,$53,$51,$4E,$4B,$1F
                    .db $0F,$40,$43,$1F,$1F,$56,$47,$48
                    .db $4B,$C4,$49,$54,$4C,$4F,$48,$4D
                    .db $46,$1F,$1F,$1F,$40,$4D,$43,$1F
                    .db $1F,$58,$4E,$D4,$42,$40,$4D,$1F
                    .db $1F,$42,$4B,$48,$4D,$46,$1F,$1F
                    .db $53,$4E,$1F,$53,$47,$C4,$45,$44
                    .db $4D,$42,$44,$1B,$1F,$1F,$1F,$1F
                    .db $13,$4E,$1F,$46,$4E,$1F,$48,$CD
                    .db $53,$47,$44,$1F,$1F,$43,$4E,$4E
                    .db $51,$1F,$1F,$40,$53,$1F,$1F,$53
                    .db $47,$C4,$44,$4D,$43,$1F,$1F,$4E
                    .db $45,$1F,$53,$47,$48,$52,$1F,$40
                    .db $51,$44,$40,$9D,$54,$52,$44,$1F
                    .db $14,$4F,$1F,$40,$4B,$52,$4E,$9B
                    .db $1C,$0F,$0E,$08,$0D,$13,$1F,$0E
                    .db $05,$1F,$00,$03,$15,$08,$02,$04
                    .db $9C,$0E,$4D,$44,$1F,$1F,$1F,$4E
                    .db $45,$1F,$1F,$1F,$18,$4E,$52,$47
                    .db $48,$5D,$D2,$45,$51,$48,$44,$4D
                    .db $43,$52,$1F,$48,$52,$1F,$53,$51
                    .db $40,$4F,$4F,$44,$C3,$48,$4D,$1F
                    .db $1F,$53,$47,$44,$1F,$42,$40,$52
                    .db $53,$4B,$44,$1F,$1F,$41,$D8,$08
                    .db $46,$46,$58,$1F,$0A,$4E,$4E,$4F
                    .db $40,$1B,$1F,$1F,$1F,$1F,$1F,$13
                    .db $CE,$43,$44,$45,$44,$40,$53,$1F
                    .db $1F,$47,$48,$4C,$1D,$1F,$1F,$4F
                    .db $54,$52,$C7,$47,$48,$4C,$1F,$48
                    .db $4D,$53,$4E,$1F,$1F,$53,$47,$44
                    .db $1F,$4B,$40,$55,$C0,$4F,$4E,$4E
                    .db $4B,$9B,$14,$52,$44,$1F,$1F,$0C
                    .db $40,$51,$48,$4E,$5D,$52,$1F,$1F
                    .db $42,$40,$4F,$C4,$53,$4E,$1F,$1F
                    .db $1F,$52,$4E,$40,$51,$1F,$1F,$53
                    .db $47,$51,$4E,$54,$46,$C7,$53,$47
                    .db $44,$1F,$40,$48,$51,$1A,$1F,$11
                    .db $54,$4D,$1F,$45,$40,$52,$53,$9D
                    .db $49,$54,$4C,$4F,$1D,$1F,$40,$4D
                    .db $43,$1F,$47,$4E,$4B,$43,$1F,$53
                    .db $47,$C4,$18,$1F,$01,$54,$53,$53
                    .db $4E,$4D,$1B,$1F,$1F,$13,$4E,$1F
                    .db $4A,$44,$44,$CF,$41,$40,$4B,$40
                    .db $4D,$42,$44,$1D,$1F,$1F,$54,$52
                    .db $44,$1F,$4B,$44,$45,$D3,$40,$4D
                    .db $43,$1F,$1F,$51,$48,$46,$47,$53
                    .db $1F,$1F,$4E,$4D,$1F,$53,$47,$C4
                    .db $02,$4E,$4D,$53,$51,$4E,$4B,$1F
                    .db $0F,$40,$43,$9B,$13,$47,$44,$1F
                    .db $51,$44,$43,$1F,$43,$4E,$53,$1F
                    .db $1F,$40,$51,$44,$40,$D2,$4E,$4D
                    .db $1F,$1F,$53,$47,$44,$1F,$1F,$4C
                    .db $40,$4F,$1F,$1F,$47,$40,$55,$C4
                    .db $53,$56,$4E,$1F,$1F,$1F,$1F,$1F
                    .db $1F,$43,$48,$45,$45,$44,$51,$44
                    .db $4D,$D3,$44,$57,$48,$53,$52,$1B
                    .db $1F,$1F,$1F,$1F,$1F,$1F,$08,$45
                    .db $1F,$58,$4E,$D4,$47,$40,$55,$44
                    .db $1F,$1F,$53,$47,$44,$1F,$53,$48
                    .db $4C,$44,$1F,$40,$4D,$C3,$52,$4A
                    .db $48,$4B,$4B,$1D,$1F,$1F,$41,$44
                    .db $1F,$52,$54,$51,$44,$1F,$53,$CE
                    .db $4B,$4E,$4E,$4A,$1F,$45,$4E,$51
                    .db $1F,$53,$47,$44,$4C,$9B,$9F,$13
                    .db $47,$48,$52,$1F,$1F,$48,$52,$1F
                    .db $1F,$40,$1F,$1F,$06,$47,$4E,$52
                    .db $D3,$07,$4E,$54,$52,$44,$1B,$1F
                    .db $1F,$1F,$1F,$1F,$02,$40,$4D,$1F
                    .db $58,$4E,$D4,$45,$48,$4D,$43,$1F
                    .db $1F,$1F,$53,$47,$44,$1F,$1F,$1F
                    .db $44,$57,$48,$53,$9E,$07,$44,$44
                    .db $1D,$1F,$1F,$47,$44,$44,$1D,$1F
                    .db $1F,$47,$44,$44,$1B,$1B,$9B,$03
                    .db $4E,$4D,$5D,$53,$1F,$46,$44,$53
                    .db $1F,$4B,$4E,$52,$53,$9A,$9F,$9F
                    .db $9F,$18,$4E,$54,$1F,$42,$40,$4D
                    .db $1F,$1F,$52,$4B,$48,$43,$44,$1F
                    .db $53,$47,$C4,$52,$42,$51,$44,$44
                    .db $4D,$1F,$1F,$1F,$4B,$44,$45,$53
                    .db $1F,$1F,$1F,$4E,$D1,$51,$48,$46
                    .db $47,$53,$1F,$1F,$41,$58,$1F,$4F
                    .db $51,$44,$52,$52,$48,$4D,$C6,$53
                    .db $47,$44,$1F,$0B,$1F,$4E,$51,$1F
                    .db $11,$1F,$01,$54,$53,$53,$4E,$4D
                    .db $D2,$4E,$4D,$1F,$1F,$1F,$53,$4E
                    .db $4F,$1F,$1F,$1F,$4E,$45,$1F,$1F
                    .db $53,$47,$C4,$42,$4E,$4D,$53,$51
                    .db $4E,$4B,$4B,$44,$51,$1B,$1F,$1F
                    .db $1F,$1F,$18,$4E,$D4,$4C,$40,$58
                    .db $1F,$41,$44,$1F,$40,$41,$4B,$44
                    .db $1F,$53,$4E,$1F,$52,$44,$C4,$45
                    .db $54,$51,$53,$47,$44,$51,$1F,$40
                    .db $47,$44,$40,$43,$9B,$13,$47,$44
                    .db $51,$44,$1F,$1F,$1F,$40,$51,$44
                    .db $1F,$1F,$1F,$45,$48,$55,$C4,$44
                    .db $4D,$53,$51,$40,$4D,$42,$44,$52
                    .db $1F,$1F,$53,$4E,$1F,$1F,$53,$47
                    .db $C4,$12,$53,$40,$51,$1F,$1F,$1F
                    .db $16,$4E,$51,$4B,$43,$1F,$1F,$1F
                    .db $1F,$48,$CD,$03,$48,$4D,$4E,$52
                    .db $40,$54,$51,$1F,$1F,$1F,$1F,$1F
                    .db $0B,$40,$4D,$43,$9B,$05,$48,$4D
                    .db $43,$1F,$1F,$53,$47,$44,$4C,$1F
                    .db $40,$4B,$4B,$1F,$40,$4D,$C3,$58
                    .db $4E,$54,$1F,$1F,$1F,$42,$40,$4D
                    .db $1F,$1F,$1F,$53,$51,$40,$55,$44
                    .db $CB,$41,$44,$53,$56,$44,$44,$4D
                    .db $1F,$1F,$1F,$1F,$1F,$1F,$1F,$4C
                    .db $40,$4D,$D8,$43,$48,$45,$45,$44
                    .db $51,$44,$4D,$53,$1F,$4F,$4B,$40
                    .db $42,$44,$52,$9B,$07,$44,$51,$44
                    .db $1D,$1F,$1F,$1F,$53,$47,$44,$1F
                    .db $1F,$42,$4E,$48,$4D,$D2,$58,$4E
                    .db $54,$1F,$1F,$1F,$42,$4E,$4B,$4B
                    .db $44,$42,$53,$1F,$1F,$1F,$4E,$D1
                    .db $53,$47,$44,$1F,$53,$48,$4C,$44
                    .db $1F,$51,$44,$4C,$40,$48,$4D,$48
                    .db $4D,$C6,$42,$40,$4D,$1F,$1F,$42
                    .db $47,$40,$4D,$46,$44,$1F,$1F,$1F
                    .db $58,$4E,$54,$D1,$4F,$51,$4E,$46
                    .db $51,$44,$52,$52,$1B,$1F,$1F,$02
                    .db $40,$4D,$1F,$58,$4E,$D4,$45,$48
                    .db $4D,$43,$1F,$1F,$53,$47,$44,$1F
                    .db $1F,$52,$4F,$44,$42,$48,$40,$CB
                    .db $46,$4E,$40,$4B,$9E,$9F,$00,$4C
                    .db $40,$59,$48,$4D,$46,$1A,$1F,$1F
                    .db $05,$44,$56,$1F,$47,$40,$55,$C4
                    .db $4C,$40,$43,$44,$1F,$48,$53,$1F
                    .db $1F,$53,$47,$48,$52,$1F,$45,$40
                    .db $51,$9B,$01,$44,$58,$4E,$4D,$43
                    .db $1F,$1F,$4B,$48,$44,$52,$1F,$1F
                    .db $1F,$53,$47,$C4,$12,$4F,$44,$42
                    .db $48,$40,$4B,$1F,$1F,$1F,$1F,$1F
                    .db $1F,$19,$4E,$4D,$44,$9B,$02,$4E
                    .db $4C,$4F,$4B,$44,$53,$44,$1F,$1F
                    .db $48,$53,$1F,$1F,$1F,$40,$4D,$C3
                    .db $58,$4E,$54,$1F,$42,$40,$4D,$1F
                    .db $44,$57,$4F,$4B,$4E,$51,$44,$1F
                    .db $1F,$C0,$52,$53,$51,$40,$4D,$46
                    .db $44,$1F,$4D,$44,$56,$1F,$56,$4E
                    .db $51,$4B,$43,$9B,$06,$0E,$0E,$03
                    .db $1F,$0B,$14,$02,$0A,$9A,$50,$C7
                    .db $41,$E2,$FC,$38,$FF

DATA_05B106:        .db $4C,$50

DATA_05B108:        .db $50,$00

DATA_05B10A:        .db $04,$FC

ADDR_05B10C:        PHB                       ; Accum (8 bit) 
                    PHK                       
                    PLB                       
                    LDX.W $1B88               
                    LDA.W $1B89               
                    CMP.W DATA_05B108,X       
                    BNE ADDR_05B191           
                    TXA                       
                    BEQ ADDR_05B132           
                    STZ.W $1426               
                    STZ.W $1B88               
                    STZ $41                   
                    STZ $42                   
                    STZ $43                   
                    STZ.W $0D9F               
                    LDA.B #$02                
                    STA $44                   
                    BRA ADDR_05B18E           
ADDR_05B132:        LDA.W $0109               
                    ORA.W $13D2               
                    BEQ ADDR_05B16E           
                    LDA.W $1DF5               
                    BEQ ADDR_05B16E           
                    LDA $13                   
                    AND.B #$03                
                    BNE ADDR_05B18E           
                    DEC.W $1DF5               
                    BNE ADDR_05B18E           
                    LDA.W $13D2               
                    BEQ ADDR_05B16E           
                    PLB                       
                    INC.W $1DE9               
                    LDA.B #$01                
                    STA.W $13CE               
                    BRA ADDR_05B165           
ADDR_05B15A:        PLB                       
                    LDA.B #$8E                
                    STA.W $1F19               
SubSideExit:        STZ.W $0109               
                    LDA.B #$00                
ADDR_05B165:        STA.W $0DD5               
                    LDA.B #$0B                
                    STA.W $0100               
                    RTL                       ; Return 

ADDR_05B16E:        LDA $15                   ; Index (8 bit) 
                    AND.B #$F0                
                    BEQ ADDR_05B18E           
                    EOR $16                   
                    AND.B #$F0                
                    BEQ ADDR_05B186           
                    LDA $17                   
                    AND.B #$C0                
                    BEQ ADDR_05B18E           
                    EOR $18                   
                    AND.B #$C0                
                    BNE ADDR_05B18E           
ADDR_05B186:        LDA.W $0109               
                    BNE ADDR_05B15A           
                    INC.W $1B88               
ADDR_05B18E:        JMP.W ADDR_05B299         
ADDR_05B191:        CMP.W DATA_05B106,X       
                    BNE ADDR_05B1A0           
                    TXA                       
                    BEQ ADDR_05B1A3           
                    JSR.W ADDR_05B31B         
                    LDA.B #$09                
                    STA $12                   
ADDR_05B1A0:        JMP.W ADDR_05B250         
ADDR_05B1A3:        LDX.B #$16                
ADDR_05B1A5:        LDY.B #$01                
                    LDA.W DATA_05A590,X       
                    BPL ADDR_05B1AF           
                    INY                       
                    AND.B #$7F                
ADDR_05B1AF:        CPY.W $1426               
                    BNE ADDR_05B1B9           
                    CMP.W $13BF               
                    BEQ ADDR_05B1BC           
ADDR_05B1B9:        DEX                       
                    BNE ADDR_05B1A5           
ADDR_05B1BC:        LDY.W $1426               
                    CPY.B #$03                
                    BNE ADDR_05B1C5           
                    LDX.B #$18                
ADDR_05B1C5:        CPX.B #$04                
                    BCS ADDR_05B1D1           
                    INX                       
                    STX.W $13D2               
                    DEX                       
                    JSR.W ADDR_05B2EB         
ADDR_05B1D1:        CPX.B #$16                
                    BNE ADDR_05B1DB           
                    LDA.W $187A               
                    BEQ ADDR_05B1DB           
                    INX                       
ADDR_05B1DB:        TXA                       
                    ASL                       
                    TAX                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W DATA_05A5A7,X       
                    STA $00                   
                    REP #$10                  ; Index (16 bit) 
                    LDA.L $7F837B             
                    TAX                       
                    LDY.W #$000E              
ADDR_05B1EF:        LDA.W DATA_05A580,Y       
                    STA.L $7F837D,X           
                    LDA.W #$2300              
                    STA.L $7F837F,X           
                    PHY                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.B #$12                
                    STA $02                   
                    STZ $03                   
                    LDY $00                   
ADDR_05B208:        LDA.B #$1F                
                    BIT.W $0003               
                    BMI ADDR_05B218           
                    LDA.W DATA_05A5D9,Y       
                    STA.W $0003               
                    AND.B #$7F                
                    INY                       
ADDR_05B218:        STA.L $7F8381,X           
                    LDA.B #$39                
                    STA.L $7F8382,X           
                    INX                       
                    INX                       
                    DEC $02                   
                    BNE ADDR_05B208           
                    STY $00                   
                    REP #$20                  ; Accum (16 bit) 
                    INX                       
                    INX                       
                    INX                       
                    INX                       
                    PLY                       
                    DEY                       
                    DEY                       
                    BPL ADDR_05B1EF           
                    LDA.W #$00FF              
                    STA.L $7F837D,X           
                    TXA                       
                    STA.L $7F837B             
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDA.B #$01                
                    STA.W $13D5               
                    STZ $22                   
                    STZ $23                   
                    STZ $24                   
                    STZ $25                   
ADDR_05B250:        LDX.W $1B88               
                    LDA.W $1B89               
                    CLC                       
                    ADC.W DATA_05B10A,X       
                    STA.W $1B89               
                    CLC                       
                    ADC.B #$80                
                    XBA                       
                    LDA.B #$80                
                    SEC                       
                    SBC.W $1B89               
                    REP #$20                  ; Accum (16 bit) 
                    LDX.B #$00                
                    LDY.B #$50                
ADDR_05B26D:        CPX.W $1B89               
                    BCC ADDR_05B275           
                    LDA.W #$00FF              
ADDR_05B275:        STA.W $04EC,Y             
                    STA.W $053C,X             
                    INX                       
                    INX                       
                    DEY                       
                    DEY                       
                    BNE ADDR_05B26D           
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.B #$22                
                    STA $41                   
                    LDY.W $13D2               
                    BEQ ADDR_05B28E           
                    LDA.B #$20                
ADDR_05B28E:        STA $43                   
                    LDA.B #$22                
                    STA $44                   
                    LDA.B #$80                
                    STA.W $0D9F               
ADDR_05B299:        PLB                       
                    RTL                       ; Return 


DATA_05B29B:        .db $AD,$35,$AD,$75,$AD,$B5,$AD,$F5
                    .db $A7,$35,$A7,$75,$B7,$35,$B7,$75
                    .db $BD,$37,$BD,$77,$BD,$B7,$BD,$F7
                    .db $A7,$37,$A7,$77,$B7,$37,$B7,$77
                    .db $AD,$39,$AD,$79,$AD,$B9,$AD,$F9
                    .db $A7,$39,$A7,$79,$B7,$39,$B7,$79
                    .db $BD,$3B,$BD,$7B,$BD,$BB,$BD,$FB
                    .db $A7,$3B,$A7,$7B,$B7,$3B,$B7,$7B
DATA_05B2DB:        .db $50,$4F,$58,$4F,$50,$57,$58,$57
                    .db $92,$4F,$9A,$4F,$92,$57,$9A,$57

ADDR_05B2EB:        PHX                       
                    TXA                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    TAX                       
                    STZ $00                   
                    REP #$20                  ; Accum (16 bit) 
                    LDY.B #$1C                
ADDR_05B2F8:        LDA.W DATA_05B29B,X       
                    STA.W $0202,Y             
                    PHX                       
                    LDX $00                   
                    LDA.W DATA_05B2DB,X       
                    STA.W $0200,Y             
                    PLX                       
                    INX                       
                    INX                       
                    INC $00                   
                    INC $00                   
                    DEY                       
                    DEY                       
                    DEY                       
                    DEY                       
                    BPL ADDR_05B2F8           
                    STZ.W $0400               
                    SEP #$20                  ; Accum (8 bit) 
                    PLX                       
                    RTS                       ; Return 

ADDR_05B31B:        LDY.B #$1C                
                    LDA.B #$F0                
ADDR_05B31F:        STA.W $0201,Y             
                    DEY                       
                    DEY                       
                    DEY                       
                    DEY                       
                    BPL ADDR_05B31F           
                    RTS                       ; Return 

ADDR_05B329:        PHA                       
                    LDA.B #$01                
                    STA.W $1DFC               ; / Play sound effect 
                    PLA                       
ADDR_05B330:        STA $00                   
                    CLC                       
                    ADC.W $13CC               
                    STA.W $13CC               
                    LDA.W $0DC0               
                    BEQ ADDR_05B35A           
                    SEC                       
                    SBC $00                   
                    BPL ADDR_05B345           
                    LDA.B #$00                
ADDR_05B345:        STA.W $0DC0               
                    BRA ADDR_05B35A           
ADDR_05B34A:        INC.W $13CC               
                    LDA.B #$01                
                    STA.W $1DFC               ; / Play sound effect 
                    LDA.W $0DC0               
                    BEQ ADDR_05B35A           
                    DEC.W $0DC0               
ADDR_05B35A:        RTL                       ; Return 


DATA_05B35B:        .db $80,$40,$20,$10,$08,$04,$02,$01

                    TYA                       
                    AND.B #$07                
                    PHA                       
                    TYA                       
                    LSR                       
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W $1F02,X             
                    PLX                       
                    AND.L DATA_05B35B,X       
                    RTL                       ; Return 


DATA_05B375:        .db $50,$00,$00,$7F,$58,$2C,$59,$2C
                    .db $55,$2C,$56,$2C,$66,$EC,$65,$EC
                    .db $57,$2C,$58,$2C,$59,$2C,$57,$2C
                    .db $58,$2C,$59,$2C,$57,$2C,$58,$2C
                    .db $59,$2C,$38,$2C,$39,$2C,$66,$EC
                    .db $65,$EC,$57,$2C,$58,$2C,$59,$2C
                    .db $57,$2C,$58,$2C,$59,$2C,$57,$2C
                    .db $58,$2C,$59,$2C,$38,$2C,$39,$2C
                    .db $56,$6C,$55,$2C,$68,$2C,$69,$2C
                    .db $65,$2C,$66,$2C,$56,$EC,$55,$AC
                    .db $67,$2C,$68,$2C,$69,$2C,$67,$2C
                    .db $68,$2C,$69,$2C,$67,$2C,$68,$2C
                    .db $69,$2C,$48,$2C,$49,$2C,$56,$EC
                    .db $55,$AC,$67,$2C,$68,$2C,$69,$2C
                    .db $67,$2C,$68,$2C,$69,$2C,$67,$2C
                    .db $68,$2C,$69,$2C,$48,$2C,$49,$2C
                    .db $66,$6C,$65,$6C,$50,$40,$80,$33
                    .db $55,$2C,$65,$2C,$38,$2C,$48,$2C
                    .db $55,$2C,$65,$2C,$38,$2C,$48,$2C
                    .db $55,$2C,$65,$2C,$38,$2C,$48,$2C
                    .db $55,$2C,$65,$2C,$38,$2C,$48,$2C
                    .db $55,$2C,$65,$2C,$38,$2C,$48,$2C
                    .db $55,$2C,$65,$2C,$38,$2C,$48,$2C
                    .db $55,$2C,$65,$2C,$50,$41,$80,$33
                    .db $56,$2C,$66,$2C,$39,$2C,$49,$2C
                    .db $56,$2C,$66,$2C,$39,$2C,$49,$2C
                    .db $56,$2C,$66,$2C,$39,$2C,$49,$2C
                    .db $56,$2C,$66,$2C,$39,$2C,$49,$2C
                    .db $56,$2C,$66,$2C,$39,$2C,$49,$2C
                    .db $56,$2C,$66,$2C,$39,$2C,$49,$2C
                    .db $56,$2C,$66,$2C,$50,$5E,$80,$33
                    .db $66,$EC,$56,$EC,$39,$6C,$49,$6C
                    .db $56,$6C,$66,$6C,$39,$6C,$49,$6C
                    .db $56,$6C,$66,$6C,$39,$6C,$49,$6C
                    .db $56,$6C,$66,$6C,$39,$6C,$49,$6C
                    .db $56,$6C,$66,$6C,$39,$6C,$49,$6C
                    .db $56,$6C,$66,$6C,$39,$6C,$49,$6C
                    .db $56,$6C,$66,$6C,$50,$5F,$80,$33
                    .db $65,$EC,$55,$EC,$38,$6C,$48,$6C
                    .db $55,$6C,$65,$6C,$38,$6C,$48,$6C
                    .db $55,$6C,$65,$6C,$38,$6C,$48,$6C
                    .db $55,$6C,$65,$6C,$38,$6C,$48,$6C
                    .db $55,$6C,$65,$6C,$38,$6C,$48,$6C
                    .db $55,$6C,$65,$6C,$38,$6C,$48,$6C
                    .db $55,$6C,$65,$6C,$53,$40,$00,$7F
                    .db $69,$AC,$67,$AC,$68,$AC,$69,$AC
                    .db $67,$AC,$68,$AC,$69,$AC,$48,$AC
                    .db $49,$AC,$56,$6C,$55,$2C,$67,$AC
                    .db $68,$AC,$69,$AC,$67,$AC,$68,$AC
                    .db $69,$AC,$67,$AC,$68,$AC,$69,$AC
                    .db $48,$AC,$49,$AC,$66,$EC,$65,$EC
                    .db $57,$2C,$58,$2C,$59,$2C,$57,$2C
                    .db $58,$2C,$57,$2C,$58,$2C,$59,$2C
                    .db $59,$AC,$57,$AC,$58,$AC,$59,$AC
                    .db $57,$AC,$58,$AC,$59,$AC,$38,$AC
                    .db $39,$AC,$66,$6C,$65,$6C,$57,$AC
                    .db $58,$AC,$59,$AC,$57,$AC,$58,$AC
                    .db $59,$AC,$57,$AC,$58,$AC,$59,$AC
                    .db $38,$AC,$39,$AC,$56,$EC,$55,$AC
                    .db $67,$2C,$68,$2C,$69,$2C,$67,$2C
                    .db $68,$2C,$67,$2C,$68,$2C,$69,$2C
                    .db $50,$AA,$00,$13,$98,$3C,$A9,$3C
                    .db $2F,$38,$AE,$28,$E0,$B8,$2C,$38
                    .db $4B,$28,$F0,$28,$F1,$28,$98,$68
                    .db $50,$CA,$00,$15,$4F,$3C,$8A,$3C
                    .db $8B,$28,$8C,$28,$8D,$38,$35,$38
                    .db $45,$28,$2A,$28,$2B,$28,$60,$28
                    .db $A2,$28,$50,$EA,$00,$15,$99,$3C
                    .db $9A,$3C,$9B,$28,$9C,$28,$9D,$38
                    .db $9E,$38,$9F,$28,$5A,$28,$5B,$28
                    .db $90,$28,$A0,$28,$51,$0A,$00,$13
                    .db $5C,$28,$5C,$68,$71,$28,$71,$68
                    .db $5C,$28,$72,$28,$73,$28,$71,$68
                    .db $75,$28,$89,$28,$51,$3B,$00,$03
                    .db $7B,$39,$7C,$39,$51,$23,$00,$2F
                    .db $B0,$28,$B1,$28,$B2,$28,$B3,$28
                    .db $B4,$28,$B5,$38,$F5,$38,$2C,$38
                    .db $AC,$3C,$F2,$3C,$F3,$3C,$F4,$3C
                    .db $E0,$B8,$3C,$38,$FB,$38,$74,$38
                    .db $F3,$28,$F8,$28,$F5,$3C,$2C,$3C
                    .db $AC,$3C,$B5,$3C,$F5,$3C,$98,$68
                    .db $51,$43,$00,$31,$6A,$28,$6B,$28
                    .db $6C,$28,$6D,$28,$6E,$28,$6F,$38
                    .db $C6,$38,$C7,$38,$D8,$3C,$C9,$3C
                    .db $CA,$3C,$CB,$3C,$D0,$B8,$CD,$38
                    .db $CE,$38,$CF,$38,$CA,$28,$A1,$28
                    .db $C6,$3C,$C7,$3C,$D8,$3C,$A5,$3C
                    .db $A3,$3C,$B6,$3C,$C8,$28,$51,$63
                    .db $00,$31,$D0,$3C,$D1,$28,$D2,$28
                    .db $D3,$28,$61,$28,$62,$38,$63,$38
                    .db $D7,$38,$D8,$3C,$D9,$3C,$DA,$3C
                    .db $DB,$3C,$DC,$38,$DD,$38,$DE,$38
                    .db $DF,$38,$DA,$28,$29,$28,$63,$3C
                    .db $D7,$3C,$D8,$3C,$2D,$3C,$4C,$3C
                    .db $4D,$3C,$CC,$28,$51,$83,$00,$31
                    .db $E0,$3C,$E1,$28,$E2,$28,$E3,$28
                    .db $E4,$28,$E5,$38,$E6,$38,$E7,$38
                    .db $E8,$3C,$E9,$3C,$EA,$3C,$EB,$3C
                    .db $EC,$38,$ED,$38,$EE,$38,$EF,$38
                    .db $EA,$28,$F7,$28,$E6,$3C,$E7,$3C
                    .db $E8,$3C,$5D,$3C,$5E,$3C,$5F,$3C
                    .db $FA,$28,$51,$A3,$00,$2F,$5C,$28
                    .db $A4,$28,$FC,$28,$FC,$28,$A6,$38
                    .db $75,$28,$A7,$28,$A8,$38,$FC,$28
                    .db $FC,$28,$FC,$28,$FC,$28,$AA,$38
                    .db $5C,$68,$AB,$38,$71,$68,$FC,$28
                    .db $FC,$28,$A7,$28,$A8,$38,$FC,$28
                    .db $AD,$3C,$A7,$28,$AF,$3C,$53,$07
                    .db $00,$25,$F6,$38,$FC,$28,$36,$38
                    .db $37,$38,$37,$38,$54,$38,$20,$39
                    .db $36,$38,$37,$38,$37,$38,$36,$38
                    .db $FC,$28,$46,$38,$47,$38,$AE,$39
                    .db $AF,$39,$C5,$39,$C6,$39,$BF,$39
                    .db $FF

DATA_05B6FE:        .db $51,$E5,$40,$2E,$FC,$38,$52,$08
                    .db $40,$1C,$FC,$38,$52,$25,$40,$2E
                    .db $FC,$38,$52,$48,$40,$1C,$FC,$38
                    .db $52,$65,$40,$2E,$FC,$38,$52,$A5
                    .db $40,$1C,$FC,$38,$51,$ED,$00,$1F
                    .db $76,$31,$71,$31,$74,$31,$82,$30
                    .db $83,$30,$FC,$38,$71,$31,$FC,$38
                    .db $24,$38,$24,$38,$24,$38,$73,$31
                    .db $76,$31,$6F,$31,$2F,$31,$72,$31
                    .db $52,$2D,$00,$1F,$76,$31,$71,$31
                    .db $74,$31,$82,$30,$83,$30,$FC,$38
                    .db $2C,$31,$FC,$38,$24,$38,$24,$38
                    .db $24,$38,$73,$31,$76,$31,$6F,$31
                    .db $2F,$31,$72,$31,$52,$6D,$00,$1F
                    .db $76,$31,$71,$31,$74,$31,$82,$30
                    .db $83,$30,$FC,$38,$2D,$31,$FC,$38
                    .db $24,$38,$24,$38,$24,$38,$73,$31
                    .db $76,$31,$6F,$31,$2F,$31,$72,$31
                    .db $51,$E7,$00,$0B,$73,$31,$74,$31
                    .db $71,$31,$31,$31,$73,$31,$FC,$38
                    .db $52,$27,$00,$0B,$73,$31,$74,$31
                    .db $71,$31,$31,$31,$73,$31,$FC,$38
                    .db $52,$67,$00,$0B,$73,$31,$74,$31
                    .db $71,$31,$31,$31,$73,$31,$FC,$38
                    .db $52,$A7,$00,$05,$73,$31,$79,$30
                    .db $7C,$30,$FF,$51,$E5,$40,$2E,$FC
                    .db $38,$52,$08,$40,$1C,$FC,$38,$52
                    .db $25,$40,$2E,$FC,$38,$52,$48,$40
                    .db $1C,$FC,$38,$52,$65,$40,$2E,$FC
                    .db $38,$52,$A5,$40,$1C,$FC,$38,$51
                    .db $EA,$00,$1F,$76,$31,$71,$31,$74
                    .db $31,$82,$30,$83,$30,$FC,$38,$71
                    .db $31,$FC,$38,$24,$38,$24,$38,$24
                    .db $38,$73,$31,$76,$31,$6F,$31,$2F
                    .db $31,$72,$31,$52,$2A,$00,$1F,$76
                    .db $31,$71,$31,$74,$31,$82,$30,$83
                    .db $30,$FC,$38,$2C,$31,$FC,$38,$24
                    .db $38,$24,$38,$24,$38,$73,$31,$76
                    .db $31,$6F,$31,$2F,$31,$72,$31,$52
                    .db $6A,$00,$1F,$76,$31,$71,$31,$74
                    .db $31,$82,$30,$83,$30,$FC,$38,$2D
                    .db $31,$FC,$38,$24,$38,$24,$38,$24
                    .db $38,$73,$31,$76,$31,$6F,$31,$2F
                    .db $31,$72,$31,$52,$AA,$00,$13,$73
                    .db $31,$74,$31,$71,$31,$31,$31,$73
                    .db $31,$FC,$38,$7C,$30,$71,$31,$2F
                    .db $31,$71,$31,$FF,$51,$E5,$40,$2F
                    .db $FC,$38,$52,$25,$40,$2F,$FC,$38
                    .db $52,$65,$40,$2F,$FC,$38,$52,$A5
                    .db $40,$1C,$FC,$38,$52,$0A,$00,$19
                    .db $6D,$31,$FC,$38,$6F,$31,$70,$31
                    .db $71,$31,$72,$31,$73,$31,$74,$31
                    .db $FC,$38,$75,$31,$71,$31,$76,$31
                    .db $73,$31,$52,$4A,$00,$19,$6E,$31
                    .db $FC,$38,$6F,$31,$70,$31,$71,$31
                    .db $72,$31,$73,$31,$74,$31,$FC,$38
                    .db $75,$31,$71,$31,$76,$31,$73,$31
                    .db $FF,$51,$C6,$00,$21,$2D,$39,$7A
                    .db $38,$79,$38,$2F,$39,$82,$38,$79
                    .db $38,$7B,$38,$73,$39,$FC,$38,$71
                    .db $39,$79,$38,$7C,$38,$FC,$38,$31
                    .db $39,$71,$39,$80,$38,$73,$39,$52
                    .db $06,$00,$29,$2D,$39,$7A,$38,$79
                    .db $38,$2F,$39,$82,$38,$79,$38,$7B
                    .db $38,$73,$39,$FC,$38,$81,$38,$82
                    .db $38,$2F,$39,$84,$38,$7A,$38,$7B
                    .db $38,$2F,$39,$FC,$38,$31,$39,$71
                    .db $39,$80,$38,$73,$39,$FF,$51,$CD
                    .db $00,$0F,$2D,$39,$7A,$38,$79,$38
                    .db $2F,$39,$82,$38,$79,$38,$7B,$38
                    .db $73,$39,$52,$0D,$00,$05,$73,$39
                    .db $79,$38,$7C,$38,$FF

DATA_05B93B:        .db $00,$06

DATA_05B93D:        .db $40,$06

DATA_05B93F:        .db $80,$06,$40,$07,$A0,$0E,$00,$08
                    .db $00,$05,$40,$05,$80,$05,$C0,$05
                    .db $80,$07,$C0,$07,$A0,$0D,$C0,$06
                    .db $00,$07,$C0,$04,$40,$04,$80,$04
                    .db $00,$04,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00

DATA_05B96B:        .db $00,$00,$00,$00,$00,$00,$01,$01
                    .db $01,$01,$01,$01,$01,$01,$02,$02
                    .db $02,$02

DATA_05B97D:        .db $02,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$01,$00,$02,$02,$00

DATA_05B98B:        .db $00,$05,$0A,$0F,$14,$14,$19,$14
                    .db $0A,$14,$00,$05,$00,$14

DATA_05B999:        .db $00,$95,$00,$97,$00,$99,$00,$9B
                    .db $80,$95,$80,$97,$80,$99,$80,$9B
                    .db $00,$96,$00,$96,$00,$96,$00,$96
                    .db $80,$9D,$80,$9F,$80,$A1,$80,$A3
                    .db $00,$96,$00,$98,$00,$9A,$00,$9C
                    .db $80,$6D,$80,$6F,$00,$7C,$80,$7C
                    .db $20,$AC,$20,$AC,$20,$AC,$20,$AC
                    .db $20,$AC,$20,$AC,$20,$AC,$20,$AC
                    .db $80,$93,$80,$93,$80,$93,$80,$93
                    .db $00,$A4,$80,$A4,$00,$A4,$80,$A4
                    .db $20,$AC,$20,$AC,$20,$AC,$20,$AC
                    .db $00,$AC,$00,$AC,$00,$AC,$00,$AC
                    .db $00,$91,$00,$91,$00,$91,$00,$91
                    .db $80,$96,$80,$98,$80,$9A,$80,$9C
                    .db $00,$9D,$00,$9F,$00,$A1,$00,$A3
                    .db $80,$8E,$80,$90,$80,$92,$80,$94
                    .db $00,$95,$00,$95,$00,$95,$00,$95
                    .db $00,$95,$00,$95,$00,$95,$00,$95
                    .db $00,$95,$00,$95,$00,$95,$00,$95
                    .db $00,$9D,$00,$9F,$00,$A1,$00,$A3
DATA_05BA39:        .db $80,$8E,$80,$90,$80,$92,$80,$94
                    .db $00,$7D,$00,$7F,$00,$81,$00,$83
                    .db $00,$83,$00,$81,$00,$7F,$00,$7D
                    .db $00,$9E,$00,$A0,$00,$A2,$00,$A0
                    .db $00,$9D,$00,$9F,$00,$A1,$00,$A3
                    .db $00,$A5,$00,$A7,$00,$A9,$00,$AB
                    .db $80,$A5,$80,$A7,$80,$A9,$80,$AB
                    .db $80,$AB,$80,$A9,$80,$A7,$80,$A5
                    .db $00,$95,$00,$95,$00,$95,$00,$95
                    .db $80,$9E,$80,$A0,$80,$A2,$80,$A0
                    .db $80,$7D,$80,$7F,$80,$81,$80,$83
                    .db $00,$7E,$00,$80,$00,$82,$00,$84
                    .db $80,$7E,$80,$80,$80,$82,$80,$84
                    .db $80,$83,$80,$81,$80,$7F,$80,$7D
                    .db $00,$95,$00,$95,$00,$95,$00,$95
                    .db $80,$A6,$80,$A8,$80,$AA,$80,$A8
                    .db $00,$8E,$00,$90,$00,$92,$00,$94
                    .db $00,$95,$00,$95,$00,$95,$00,$95
                    .db $00,$95,$00,$95,$00,$95,$00,$95
                    .db $80,$9E,$80,$A0,$80,$A2,$80,$A0
                    .db $00,$A6,$00,$A8,$00,$AA,$00,$A8
                    .db $00,$95,$00,$95,$00,$95,$00,$95
                    .db $00,$95,$00,$95,$00,$95,$00,$95
                    .db $00,$95,$00,$95,$00,$95,$00,$95
                    .db $80,$91,$80,$91,$80,$91,$80,$91
                    .db $80,$96,$80,$98,$80,$9A,$80,$9C
                    .db $80,$96,$80,$98,$80,$9A,$80,$9C
                    .db $80,$96,$80,$98,$80,$9A,$80,$9C
                    .db $00,$95,$00,$97,$00,$99,$00,$9B
                    .db $80,$AC,$80,$AC,$80,$AC,$80,$AC
                    .db $00,$93,$00,$93,$00,$93,$00,$93
                    .db $80,$93,$80,$93,$80,$93,$80,$93

ADDR_05BB39:        PHB                       
                    PHK                       
                    PLB                       
                    LDA $14                   
                    AND.B #$07                
                    STA $00                   
                    ASL                       
                    ADC $00                   
                    TAY                       
                    ASL                       
                    TAX                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA $14                   
                    AND.W #$0018              
                    LSR                       
                    LSR                       
                    STA $00                   
                    LDA.W DATA_05B93B,X       
                    STA.W $0D80               
                    LDA.W DATA_05B93D,X       
                    STA.W $0D7E               
                    LDA.W DATA_05B93F,X       
                    STA.W $0D7C               
                    LDX.B #$04                
ADDR_05BB67:        PHY                       
                    PHX                       
                    SEP #$20                  ; Accum (8 bit) 
                    TYA                       
                    LDX.W DATA_05B96B,Y       
                    BEQ ADDR_05BB88           
                    DEX                       
                    BNE ADDR_05BB81           
                    LDX.W DATA_05B97D,Y       
                    LDY.W $14AD,X             
                    BEQ ADDR_05BB88           
                    CLC                       
                    ADC.B #$26                
                    BRA ADDR_05BB88           
ADDR_05BB81:        LDY.W $1931               
                    CLC                       
                    ADC.W DATA_05B98B,Y       
ADDR_05BB88:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    AND.W #$00FF              
                    ASL                       
                    ASL                       
                    ASL                       
                    ORA $00                   
                    TAY                       
                    LDA.W DATA_05B999,Y       
                    SEP #$10                  ; Index (8 bit) 
                    PLX                       
                    STA.W $0D76,X             
                    PLY                       
                    INY                       
                    DEX                       
                    DEX                       
                    BPL ADDR_05BB67           
                    SEP #$20                  ; Accum (8 bit) 
                    PLB                       
                    RTL                       ; Return 


DATA_05BBA6:        .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
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

ADDR_05BC00:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_05BC76         
                    JSR.W ADDR_05BCA5         
                    JSR.W ADDR_05BC4A         
                    LDA.W $1462               
                    SEC                       
                    SBC $1A                   
                    CLC                       
                    ADC.W $17BD               
                    STA.W $17BD               
                    LDA.W $1464               
                    SEC                       
                    SBC $1C                   
                    CLC                       
                    ADC.W $17BC               
                    STA.W $17BC               
                    LDA.W $1466               
                    SEC                       
                    SBC $1E                   
                    LDY.W $143F               
                    DEY                       
                    BNE ADDR_05BC33           
                    TYA                       
ADDR_05BC33:        STA.W $17BF               
                    LDA.W $1468               
                    SEC                       
                    SBC $20                   
                    STA.W $17BE               
                    LDA.W $13D5               
                    BNE ADDR_05BC47           
                    JSR.W ADDR_05C40C         
ADDR_05BC47:        PLB                       
                    RTL                       ; Return 

ADDR_05BC49:        RTS                       ; Return 

ADDR_05BC4A:        REP #$20                  ; Accum (16 bit) 
                    LDY.W $1403               
                    BNE ADDR_05BC5F           
                    LDA.W $1466               
                    SEC                       
                    SBC.W $1462               
                    STA $26                   
                    LDA.W $1468               
                    BRA ADDR_05BC69           
ADDR_05BC5F:        LDA $22                   
                    SEC                       
                    SBC.W $1462               
                    STA $26                   
                    LDA $24                   
ADDR_05BC69:        SEC                       
                    SBC.W $1464               
                    STA $28                   
                    SEP #$20                  ; Accum (8 bit) 
                    RTS                       ; Return 

ADDR_05BC72:        JSR.W ADDR_05BC4A         
                    RTL                       ; Return 

ADDR_05BC76:        STZ.W $1456               
                    LDA.W $009D               
                    BNE ADDR_05BC49           
                    LDA.W $143E               
                    BEQ ADDR_05BC49           
                    JSL.L ExecutePtr          

Ptrs05BC87:         .dw ADDR_05C04D           
                    .dw ADDR_05C04D           
                    .dw ADDR_05BC49           
                    .dw ADDR_05BC49           
                    .dw ADDR_05C283           
                    .dw ADDR_05C69E           
                    .dw ADDR_05BC49           
                    .dw ADDR_05BFF5           
                    .dw ADDR_05C51F           
                    .dw ADDR_05BC49           
                    .dw ADDR_05C32E           
                    .dw ADDR_05C727           
                    .dw ADDR_05C787           
                    .dw ADDR_05BC49           
                    .dw ADDR_05BC49           

ADDR_05BCA5:        LDA.B #$04                
                    STA.W $1456               
                    LDA.W $143F               
                    BEQ ADDR_05BC49           
                    LDY.W $009D               
                    BNE ADDR_05BC49           
                    JSL.L ExecutePtr          

Ptrs05BCB8:         .dw ADDR_05C04D           
                    .dw ADDR_05C198           
                    .dw ADDR_05C955           
                    .dw ADDR_05C5BB           
                    .dw ADDR_05C283           
                    .dw ADDR_05BC49           
                    .dw ADDR_05C659           
                    .dw ADDR_05BFF5           
                    .dw ADDR_05C51F           
                    .dw ADDR_05C7C1           
                    .dw ADDR_05C32E           
                    .dw ADDR_05C727           
                    .dw ADDR_05C787           
                    .dw ADDR_05C7BC           
                    .dw ADDR_05C81C           

ADDR_05BCD6:        PHB                       
                    PHK                       
                    PLB                       
                    STZ.W $1456               
                    JSR.W ADDR_05BCE9         
                    LDA.B #$04                
                    STA.W $1456               
                    JSR.W ADDR_05BD0E         
                    PLB                       
                    RTL                       ; Return 

ADDR_05BCE9:        LDA.W $143E               
                    JSL.L ExecutePtr          

Ptrs05BCF0:         .dw ADDR_05BD36           
                    .dw ADDR_05BD36           
                    .dw ADDR_05BF6A           
                    .dw ADDR_05BF0A           
                    .dw ADDR_05BDDD           
                    .dw ADDR_05BFBA           
                    .dw ADDR_05BF97           
                    .dw ADDR_05BD35           
                    .dw ADDR_05BEA6           
                    .dw ADDR_05BC49           
                    .dw ADDR_05BE3A           
                    .dw ADDR_05BFF6           
                    .dw ADDR_05C005           
                    .dw ADDR_05C01A           
                    .dw ADDR_05C036           

ADDR_05BD0E:        LDA.W $143F               
                    BEQ ADDR_05BD35           
                    JSL.L ExecutePtr          

Ptrs05BD17:         .dw ADDR_05BD4C           
                    .dw ADDR_05BD4C           
                    .dw ADDR_05BC49           
                    .dw ADDR_05BF20           
                    .dw ADDR_05BDF0           
                    .dw ADDR_05BC49           
                    .dw ADDR_05BC49           
                    .dw ADDR_05BD35           
                    .dw ADDR_05BEC6           
                    .dw ADDR_05C022           
                    .dw ADDR_05BE4D           
                    .dw ADDR_05BC49           
                    .dw ADDR_05BC49           
                    .dw ADDR_05BC49           
                    .dw ADDR_05BC49           

ADDR_05BD35:        RTS                       ; Return 

ADDR_05BD36:        STZ.W $1411               
                    LDA.W $1440               
                    ASL                       
                    TAY                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W DATA_05C9D1,Y       
                    STA.W $143E               
                    LDA.W DATA_05C9DB,Y       
                    STA.W $1440               
ADDR_05BD4C:        LDX.W $1456               
                    REP #$20                  ; Accum (16 bit) 
                    STZ.W $1446,X             
                    STZ.W $1448,X             
                    STZ.W $144E,X             
                    STZ.W $1450,X             
                    SEP #$20                  ; Accum (8 bit) 
                    TXA                       
                    LSR                       
                    LSR                       
                    TAX                       
                    LDY.W $1440               
                    LDA.W $1456               
                    BEQ ADDR_05BD6E           
                    LDY.W $1441               
ADDR_05BD6E:        LDA.W DATA_05CA61,Y       
                    STA.W $1442,X             
                    LDA.W DATA_05CA68,Y       
                    STA.W $1444,X             
                    RTS                       ; Return 

                    LDA.W $1440               
                    ASL                       
                    TAY                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W DATA_05C9E5,Y       
                    STA.W $143E               
                    LDA.W DATA_05C9E7,Y       
                    STA.W $1440               
                    REP #$20                  ; Accum (16 bit) 
                    LDY.W $1440               
                    LDA.W $1456               
                    AND.W #$00FF              
                    BEQ ADDR_05BD9E           
                    LDY.W $1441               
ADDR_05BD9E:        LDA.W $1456               
                    AND.W #$00FF              
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W DATA_05C9E9,Y       
                    STA.W $1442,X             
                    LDA.W DATA_05CBC7,Y       
                    AND.W #$00FF              
                    BEQ ADDR_05BDB9           
                    EOR.W #$FFFF              
                    INC A                     
ADDR_05BDB9:        LDX.W $1456               
                    CLC                       
                    ADC.W $1464,X             
                    AND.W #$00FF              
                    STA.W $144E,X             
                    STZ.W $1450,X             
ADDR_05BDC9:        STZ.W $1446,X             
                    STZ.W $1448,X             
ADDR_05BDCF:        SEP #$20                  ; Accum (8 bit) 
                    TXA                       
                    LSR                       
                    LSR                       
                    AND.B #$FF                
                    TAX                       
                    LDA.B #$FF                
                    STA.W $1444,X             
                    RTS                       ; Return 

ADDR_05BDDD:        LDA.W $1440               
                    ASL                       
                    TAY                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W DATA_05CA08,Y       
                    STA.W $143E               
                    LDA.W DATA_05CA0C,Y       
                    STA.W $1440               
ADDR_05BDF0:        REP #$20                  ; Accum (16 bit) 
                    LDY.W $1440               
                    LDA.W $1456               
                    AND.W #$00FF              
                    BEQ ADDR_05BE00           
                    LDY.W $1441               
ADDR_05BE00:        LDA.W $1456               
                    AND.W #$00FF              
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W DATA_05CA10,Y       
                    STA.W $1442,X             
                    PHA                       
                    TYA                       
                    ASL                       
                    TAY                       
                    LDA.W DATA_05CA12,Y       
                    STA $00                   
                    PLA                       
                    TAY                       
                    LDX.W $1456               
                    LDA $00                   
                    CPY.B #$01                
                    BEQ ADDR_05BE27           
                    EOR.W #$FFFF              
                    INC A                     
ADDR_05BE27:        CLC                       
                    ADC.W $1464,X             
                    STA.W $144E,X             
                    STZ.W $1446,X             
                    STZ.W $1448,X             
                    STZ.W $1450,X             
                    SEP #$20                  ; Accum (8 bit) 
                    RTS                       ; Return 

ADDR_05BE3A:        LDA.W $1440               
                    ASL                       
                    TAY                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W DATA_05CA16,Y       
                    STA.W $143E               
                    LDA.W DATA_05CA1E,Y       
                    STA.W $1440               
ADDR_05BE4D:        REP #$20                  ; Accum (16 bit) 
                    LDY.W $1440               
                    LDA.W $1456               
                    AND.W #$00FF              
                    BEQ ADDR_05BE5D           
                    LDY.W $1441               
ADDR_05BE5D:        LDA.W $1456               
                    AND.W #$00FF              
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W DATA_05CA26,Y       
                    STA.W $1442,X             
                    TAY                       
                    LDX.W $1456               
                    LDA.W #$0F17              
                    CPY.B #$01                
                    BEQ ADDR_05BE7B           
                    EOR.W #$FFFF              
                    INC A                     
ADDR_05BE7B:        STA.W $1450,X             
                    STZ.W $1446,X             
                    STZ.W $1448,X             
                    STZ.W $144E,X             
                    SEP #$20                  ; Accum (8 bit) 
                    RTS                       ; Return 

ADDR_05BE8A:        PHB                       
                    PHK                       
                    PLB                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W DATA_05CA26         
                    STA.W $1460               
                    STZ.W $1458               
                    STZ.W $145A               
                    STZ.W $145C               
                    LDA $1C                   
                    STA $24                   
                    SEP #$20                  ; Accum (8 bit) 
                    PLB                       
                    RTL                       ; Return 

ADDR_05BEA6:        STZ.W $1411               
                    LDA.W $1440               
                    ASL                       
                    TAY                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W DATA_05CA3E,Y       
                    STA.W $143E               
                    LDA.W DATA_05CA42,Y       
                    STA.W $1440               
                    STZ $1A                   
                    STZ.W $1462               
                    STZ $1E                   
                    STZ.W $1466               
ADDR_05BEC6:        REP #$20                  ; Accum (16 bit) 
                    LDY.W $1440               
                    LDA.W $1456               
                    AND.W #$00FF              
                    BEQ ADDR_05BED6           
                    LDY.W $1441               
ADDR_05BED6:        LDA.W $1456               
                    AND.W #$00FF              
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W DATA_05CA46,Y       
                    STA.W $1442,X             
                    TAX                       
                    TYA                       
                    ASL                       
                    TAY                       
                    LDA.W DATA_05CBED,Y       
                    AND.W #$00FF              
                    CPX.B #$01                
                    BEQ ADDR_05BEF7           
                    EOR.W #$FFFF              
                    INC A                     
ADDR_05BEF7:        LDX.W $1456               
                    CLC                       
                    ADC.W $1462,X             
                    AND.W #$00FF              
                    STA.W $1450,X             
                    STZ.W $144E,X             
                    JMP.W ADDR_05BDC9         
ADDR_05BF0A:        STZ.W $1414               
                    LDA.W $1440               
                    ASL                       
                    TAY                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W DATA_05CA48,Y       
                    STA.W $143E               
                    LDA.W DATA_05CA52,Y       
                    STA.W $1440               
ADDR_05BF20:        REP #$20                  ; Accum (16 bit) 
                    LDY.W $1440               
                    LDA.W $1456               
                    AND.W #$00FF              
                    BEQ ADDR_05BF30           
                    LDY.W $1441               
ADDR_05BF30:        LDA.W $1456               
                    AND.W #$00FF              
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W DATA_05CA5C,Y       
                    STA.W $1442,X             
                    TAX                       
                    TYA                       
                    ASL                       
                    TAY                       
                    LDA.W DATA_05CBF5,Y       
                    AND.W #$00FF              
                    CPX.B #$01                
                    BEQ ADDR_05BF51           
                    EOR.W #$FFFF              
                    INC A                     
ADDR_05BF51:        LDX.W $1456               
                    CLC                       
                    ADC.W $1464,X             
                    AND.W #$00FF              
                    STA.W $144E,X             
                    STZ.W $1450,X             
                    STZ.W $1448,X             
                    STZ.W $1448,X             
                    JMP.W ADDR_05BDCF         
ADDR_05BF6A:        LDY.W $1440               ; Accum (8 bit) 
                    LDA.W DATA_05C94F,Y       
                    STA.W $1440               
                    LDA.W DATA_05C952,Y       
                    STA.W $1441               
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W #$0200              
                    JSR.W ADDR_05BFD2         
                    LDA.W $1440               ; Accum (8 bit) 
                    CLC                       
                    ADC.B #$0A                
                    TAX                       
                    LDY.B #$01                
                    JSR.W ADDR_05C95B         
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W $1468               
                    STA $20                   
                    JMP.W ADDR_05C32B         
ADDR_05BF97:        STZ.W $1411               
                    REP #$20                  ; Accum (16 bit) 
                    STZ $1A                   
                    STZ.W $1462               
                    STZ $1E                   
                    STZ.W $1466               
                    LDA.W #$0600              
                    STA.W $143E               
                    STZ.W $144C               
                    STZ.W $1454               
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.B #$60                
                    STA.W $1441               
                    RTS                       ; Return 

ADDR_05BFBA:        STZ.W $1411               
                    REP #$20                  ; Accum (16 bit) 
                    STZ $1E                   
                    STZ.W $1466               
                    LDA.W #$03C0              
                    STA $20                   
                    STA.W $1468               
                    STZ.W $1440               
                    LDA.W #$0005              
ADDR_05BFD2:        STZ.W $1444               
ADDR_05BFD5:        STZ.W $1442               
                    STA.W $143E               
                    STZ.W $1446               
                    STZ.W $1448               
                    STZ.W $144E               
                    STZ.W $1450               
                    STZ.W $144A               
                    STZ.W $144C               
                    STZ.W $1452               
                    STZ.W $1454               
                    SEP #$20                  ; Accum (8 bit) 
ADDR_05BFF5:        RTS                       ; Return 

ADDR_05BFF6:        REP #$20                  ; Accum (16 bit) 
                    LDA.W #$0B00              
                    BRA ADDR_05BFD2           

DATA_05BFFD:        .db $00,$00,$02,$00

DATA_05C001:        .db $80,$00,$00,$01

ADDR_05C005:        STZ.W $1411               
                    LDA.W $1440               
                    ASL                       
                    TAY                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W DATA_05BFFD,Y       
                    STA.W $1440               
                    LDA.W #$000C              
                    BRA ADDR_05BFD2           
ADDR_05C01A:        REP #$20                  ; Accum (16 bit) 
                    LDA.W #$0D00              
                    JSR.W ADDR_05BFD2         
ADDR_05C022:        STZ.W $1413               
                    REP #$20                  ; Accum (16 bit) 
                    STZ.W $144A               
                    STZ.W $144C               
                    STZ.W $1452               
                    STZ.W $1454               
                    SEP #$20                  ; Accum (8 bit) 
                    RTS                       ; Return 

ADDR_05C036:        LDY.W $1440               
                    LDA.W DATA_05C808,Y       
                    STA.W $1444               
                    LDA.W DATA_05C80B,Y       
                    STA.W $1445               
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W #$0E00              
                    JMP.W ADDR_05BFD5         
ADDR_05C04D:        LDA.W $1456               
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W $1444,X             
                    BNE ADDR_05C05F           
                    LDX.W $1456               
                    STZ.W $1446,X             
                    RTS                       ; Return 

ADDR_05C05F:        REP #$20                  ; Accum (16 bit) 
                    LDA.W $1442,X             
                    TAY                       
                    LDA.W DATA_05CA6E,Y       
                    AND.W #$00FF              
                    STA $04                   
                    LDA.W DATA_05CABE,Y       
                    AND.W #$00FF              
                    STA $06                   
                    LDA.W $1456               
                    AND.W #$00FF              
                    TAX                       
                    LDA.W $1462,X             
                    STA $00                   
                    LDA.W $1464,X             
                    STA $02                   
                    LDX.B #$02                
                    LDA.W DATA_05CA6F,Y       
                    AND.W #$00FF              
                    CMP $04                   
                    BNE ADDR_05C098           
                    STZ $04                   
                    STX $08                   
                    BRA ADDR_05C0AD           
ADDR_05C098:        ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    SEC                       
                    SBC $00                   
                    STA $00                   
                    BPL ADDR_05C0A9           
                    LDX.B #$00                
                    EOR.W #$FFFF              
                    INC A                     
ADDR_05C0A9:        STA $04                   
                    STX $08                   
ADDR_05C0AD:        LDX.B #$00                
                    LDA.W DATA_05CABF,Y       
                    AND.W #$00FF              
                    CMP $06                   
                    BNE ADDR_05C0BD           
                    STZ $06                   
                    BRA ADDR_05C0D0           
ADDR_05C0BD:        ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    SEC                       
                    SBC $02                   
                    STA $02                   
                    BPL ADDR_05C0CE           
                    LDX.B #$02                
                    EOR.W #$FFFF              
                    INC A                     
ADDR_05C0CE:        STA $06                   
ADDR_05C0D0:        LDA $5B                   
                    LSR                       
                    BCS ADDR_05C0D7           
                    LDX $08                   
ADDR_05C0D7:        STX $55                   
                    LDA.W #$FFFF              
                    STA $08                   
                    LDA $04                   
                    STA $0A                   
                    LDA $06                   
                    STA $0C                   
                    CMP $04                   
                    BCC ADDR_05C0F5           
                    STA $0A                   
                    LDA $04                   
                    STA $0C                   
                    LDA.W #$0001              
                    STA $08                   
ADDR_05C0F5:        LDA $0A                   
                    STA.W $4204               ; Dividend (Low Byte)
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.W DATA_05CB0F,Y       
                    STA.W $4206               ; Divisor B
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W $4214               ; Quotient of Divide Result (Low Byte)
                    BNE ADDR_05C123           
                    LDA.W $1456               
                    AND.W #$00FF              
                    LSR                       
                    LSR                       
                    TAX                       
                    INC.W $1442,X             
                    SEP #$20                  ; Accum (8 bit) 
                    DEC.W $1444,X             
                    JMP.W ADDR_05C04D         
ADDR_05C123:        STA $0A                   ; Accum (16 bit) 
                    LDA $0C                   
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    STA $0C                   
                    LDY.B #$10                
                    LDA.W #$0000              
                    STA $0E                   
ADDR_05C134:        ASL $0C                   
                    ROL                       
                    CMP $0A                   
                    BCC ADDR_05C13D           
                    SBC $0A                   
ADDR_05C13D:        ROL $0E                   
                    DEY                       
                    BNE ADDR_05C134           
                    LDA.W $1456               
                    AND.W #$00FF              
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W $1442,X             
                    TAY                       
                    LDA.W DATA_05CB0F,Y       
                    AND.W #$00FF              
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    STA $0A                   
                    LDX.B #$02                
ADDR_05C15D:        LDA $08                   
                    BMI ADDR_05C165           
                    LDA $0A                   
                    BRA ADDR_05C167           
ADDR_05C165:        LDA $0E                   
ADDR_05C167:        BIT $00,X                 
                    BPL ADDR_05C16F           
                    EOR.W #$FFFF              
                    INC A                     
ADDR_05C16F:        PHX                       
                    PHA                       
                    TXA                       
                    CLC                       
                    ADC.W $1456               
                    TAX                       
                    PLA                       
                    LDY.B #$00                
                    CMP.W $1446,X             
                    BEQ ADDR_05C18D           
                    BPL ADDR_05C183           
                    LDY.B #$02                
ADDR_05C183:        LDA.W $1446,X             
                    CLC                       
                    ADC.W DATA_05CB5F,Y       
                    STA.W $1446,X             
ADDR_05C18D:        JSR.W ADDR_05C4F9         
                    PLX                       
                    DEX                       
                    DEX                       
                    BPL ADDR_05C15D           
                    SEP #$20                  ; Accum (8 bit) 
                    RTS                       ; Return 

ADDR_05C198:        JSR.W ADDR_05C04D         
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W $1466               
                    STA.W $1462               
                    LDA $20                   
                    CLC                       
                    ADC.W $1888               
                    STA $20                   
                    SEP #$20                  ; Accum (8 bit) 
                    RTS                       ; Return 

                    LDA.W $1456               
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W $1444,X             
                    BMI ADDR_05C1D4           
                    DEC.W $1444,X             
                    LDA.W $1444,X             
                    CMP.B #$20                
                    BCC ADDR_05C1D1           
                    REP #$20                  ; Accum (16 bit) 
                    LDX.W $1456               
                    LDA.W $1464,X             
                    EOR.W #$0001              
                    STA.W $1464,X             
ADDR_05C1D1:        JMP.W ADDR_05C32B         
ADDR_05C1D4:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDY.W $1456               
                    LDA.W $144E,Y             
                    TAX                       
                    LDA.W $1464,Y             
                    CMP.W $144E,Y             
                    BCC ADDR_05C1EB           
                    STA $04                   
                    STX $02                   
                    BRA ADDR_05C1EF           
ADDR_05C1EB:        STA $02                   
                    STX $04                   
ADDR_05C1EF:        SEP #$10                  ; Index (8 bit) 
                    LDA $02                   
                    CMP $04                   
                    BCC ADDR_05C24D           
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.W $1456               
                    AND.B #$FF                
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.B #$30                
                    STA.W $1444,X             
                    REP #$20                  ; Accum (16 bit) 
                    LDX.W $1456               
                    STZ.W $1448,X             
                    STZ.W $1450,X             
                    LDY.W $1440               
                    LDA.W $1456               
                    AND.W #$00FF              
                    BEQ ADDR_05C21F           
                    LDY.W $1441               
ADDR_05C21F:        LDA.W DATA_05CBC7,Y       
                    AND.W #$00FF              
                    STA $00                   
                    TXA                       
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W $1442,X             
                    EOR.W #$0001              
                    STA.W $1442,X             
                    AND.W #$00FF              
                    BNE ADDR_05C241           
                    LDA $00                   
                    EOR.W #$FFFF              
                    INC A                     
                    STA $00                   
ADDR_05C241:        LDX.W $1456               
                    LDA $00                   
                    CLC                       
                    ADC.W $144E,X             
                    STA.W $144E,X             
ADDR_05C24D:        LDA.W $1456               
                    AND.W #$00FF              
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W $1442,Y             
                    TAX                       
                    LDA.W DATA_05CBC8,X       
                    AND.W #$00FF              
                    CPX.B #$01                
                    BEQ ADDR_05C268           
                    EOR.W #$FFFF              
                    INC A                     
ADDR_05C268:        LDX.W $1456               
                    LDY.B #$00                
                    CMP.W $1448,X             
                    BEQ ADDR_05C280           
                    BPL ADDR_05C276           
                    LDY.B #$02                
ADDR_05C276:        LDA.W $1448,X             
                    CLC                       
                    ADC.W DATA_05CB7B,Y       
                    STA.W $1448,X             
ADDR_05C280:        JMP.W ADDR_05C31D         
ADDR_05C283:        REP #$20                  ; Accum (16 bit) 
                    LDY.W $1456               
                    LDA.W $144E,Y             
                    SEC                       
                    SBC.W $1464,Y             
                    BPL ADDR_05C295           
                    EOR.W #$FFFF              
                    INC A                     
ADDR_05C295:        STA $02                   
                    LDA.W $1456               
                    AND.W #$00FF              
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W $1442,X             
                    AND.W #$00FF              
                    TAY                       
                    LSR                       
                    TAX                       
                    LDA $02                   
                    STA.W $4204               ; Dividend (Low Byte)
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.W DATA_05CBE3,X       
                    STA.W $4206               ; Divisor B
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W $4214               ; Quotient of Divide Result (Low Byte)
                    BNE ADDR_05C2E5           
                    LDA.W $1456               
                    AND.W #$00FF              
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W $1442,X             
                    TAY                       
                    LDX.W $1456               
                    LDA.W #$0200              
                    CPY.B #$01                
                    BNE ADDR_05C2DE           
                    EOR.W #$FFFF              
                    INC A                     
ADDR_05C2DE:        CLC                       
                    ADC.W $1464,X             
                    STA.W $1464,X             
ADDR_05C2E5:        LDX.W $1440               
                    LDA.W $1456               
                    AND.W #$00FF              
                    BEQ ADDR_05C2F3           
                    LDX.W $1441               
ADDR_05C2F3:        LDA.W DATA_05CBE3,X       
                    AND.W #$00FF              
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    CPY.B #$01                
                    BEQ ADDR_05C305           
                    EOR.W #$FFFF              
                    INC A                     
ADDR_05C305:        LDX.W $1456               
                    LDY.B #$00                
                    CMP.W $1448,X             
                    BEQ ADDR_05C31D           
                    BPL ADDR_05C313           
                    LDY.B #$02                
ADDR_05C313:        LDA.W $1448,X             
                    CLC                       
                    ADC.W DATA_05CB9B,Y       
                    STA.W $1448,X             
ADDR_05C31D:        LDA.W $1456               
                    AND.W #$00FF              
                    CLC                       
                    ADC.W #$0002              
                    TAX                       
ADDR_05C328:        JSR.W ADDR_05C4F9         
ADDR_05C32B:        SEP #$20                  ; Accum (8 bit) 
                    RTS                       ; Return 

ADDR_05C32E:        REP #$20                  ; Accum (16 bit) 
                    LDY.W $1456               
                    LDA.W $1450,Y             
                    SEC                       
                    SBC.W $1462,Y             
                    BPL ADDR_05C340           
                    EOR.W #$FFFF              
                    INC A                     
ADDR_05C340:        STA $02                   
                    LDA.W $1456               
                    AND.W #$00FF              
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W $1442,X             
                    AND.W #$00FF              
                    TAY                       
                    LSR                       
                    TAX                       
                    LDA $02                   
                    STA.W $4204               ; Dividend (Low Byte)
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.W DATA_05CBE5,X       
                    STA.W $4206               ; Divisor B
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W $4214               ; Quotient of Divide Result (Low Byte)
                    BNE ADDR_05C39F           
                    LDA.W $1456               
                    AND.W #$00FF              
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W $1442,X             
                    TAY                       
                    LDX.W $1456               
                    LDA.W #$0600              
                    CPY.B #$01                
                    BNE ADDR_05C389           
                    EOR.W #$FFFF              
                    INC A                     
ADDR_05C389:        CLC                       
                    ADC.W $1462,X             
                    STA.W $1462,X             
                    LDA.W #$FFF8              
                    STA.W $0045,X             
                    LDA.W #$0017              
                    STA.W $0047,X             
                    STZ.W $0095               
ADDR_05C39F:        LDA.W $1456               
                    AND.W #$00FF              
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W $1442,X             
                    AND.W #$00FF              
                    PHA                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDX.B #$02                
                    LDY.B #$00                
                    CMP.B #$01                
                    BEQ ADDR_05C3BD           
                    LDX.B #$00                
                    LDY.B #$01                
ADDR_05C3BD:        TXA                       
                    STA.W $0055,Y             
                    REP #$20                  ; Accum (16 bit) 
                    PLA                       
                    TAY                       
                    LDX.W $1440               
                    LDA.W $1456               
                    AND.W #$00FF              
                    BEQ ADDR_05C3D3           
                    LDX.W $1441               
ADDR_05C3D3:        LDA.W DATA_05CBE5,X       
                    AND.W #$00FF              
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    CPY.B #$01                
                    BEQ ADDR_05C3E5           
                    EOR.W #$FFFF              
                    INC A                     
ADDR_05C3E5:        LDX.W $1456               
                    LDY.B #$00                
                    CMP.W $1446,X             
                    BEQ ADDR_05C3FD           
                    BPL ADDR_05C3F3           
                    LDY.B #$02                
ADDR_05C3F3:        LDA.W $1446,X             
                    CLC                       
                    ADC.W DATA_05CBA3,Y       
                    STA.W $1446,X             
ADDR_05C3FD:        LDX.W $1456               
                    JSR.W ADDR_05C4F9         
                    SEP #$20                  ; Accum (8 bit) 
                    RTS                       ; Return 


DATA_05C406:        .db $FF,$01

DATA_05C408:        .db $FC,$04

DATA_05C40A:        .db $30,$A0

ADDR_05C40C:        LDA.W $1403               
                    BEQ ADDR_05C414           
                    JMP.W ADDR_05C494         
ADDR_05C414:        REP #$20                  ; Accum (16 bit) 
                    LDY.W $1931               
                    CPY.B #$01                
                    BEQ ADDR_05C421           
                    CPY.B #$03                
                    BNE ADDR_05C428           
ADDR_05C421:        LDA $1A                   
                    LSR                       
                    STA $22                   
                    BRA ADDR_05C491           
ADDR_05C428:        LDY.W $009D               
                    BNE ADDR_05C48D           
                    LDA.W $1460               
                    AND.W #$00FF              
                    TAY                       
                    LDA.W DATA_05CBEB         
                    AND.W #$00FF              
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    CPY.B #$01                
                    BEQ ADDR_05C446           
                    EOR.W #$FFFF              
                    INC A                     
ADDR_05C446:        LDY.B #$00                
                    CMP.W $1458               
                    BEQ ADDR_05C45B           
                    BPL ADDR_05C451           
                    LDY.B #$02                
ADDR_05C451:        LDA.W $1458               
                    CLC                       
                    ADC.W DATA_05CBBB,Y       
                    STA.W $1458               
ADDR_05C45B:        LDA.W $145C               
                    AND.W #$00FF              
                    CLC                       
                    ADC.W $1458               
                    STA.W $145C               
                    AND.W #$FF00              
                    BPL ADDR_05C470           
                    ORA.W #$00FF              
ADDR_05C470:        XBA                       
                    CLC                       
                    ADC $22                   
                    STA $22                   
                    LDA.W $17BD               
                    AND.W #$00FF              
                    CMP.W #$0080              
                    BCC ADDR_05C484           
                    ORA.W #$FF00              
ADDR_05C484:        STA $00                   
                    LDA $22                   
                    CLC                       
                    ADC $00                   
                    STA $22                   
ADDR_05C48D:        LDA $1C                   
                    STA $24                   
ADDR_05C491:        SEP #$20                  ; Accum (8 bit) 
                    RTS                       ; Return 

ADDR_05C494:        DEC A                     
                    BNE ADDR_05C4EC           
                    LDA.W $009D               
                    BNE ADDR_05C4EC           
                    LDY.W $1460               
                    LDA $14                   
                    AND.B #$03                
                    BNE ADDR_05C4C0           
                    LDA.W $145A               
                    BNE ADDR_05C4AF           
                    DEC.W $1B9D               
                    BNE ADDR_05C4EC           
ADDR_05C4AF:        CMP.W DATA_05C408,Y       
                    BEQ ADDR_05C4BB           
                    CLC                       
                    ADC.W DATA_05C406,Y       
                    STA.W $145A               
ADDR_05C4BB:        LDA.B #$4B                
                    STA.W $1B9D               
ADDR_05C4C0:        LDA $24                   
                    CMP.W DATA_05C40A,Y       
                    BNE ADDR_05C4CD           
                    TYA                       
                    EOR.B #$01                
                    STA.W $1460               
ADDR_05C4CD:        LDA.W $145A               
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    CLC                       
                    ADC.W $145C               
                    STA.W $145C               
                    LDA.W $145A               
                    PHP                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    PLP                       
                    BPL ADDR_05C4E8           
                    ORA.B #$F0                
ADDR_05C4E8:        ADC $24                   
                    STA $24                   
ADDR_05C4EC:        LDA $22                   
                    SEC                       
                    ADC.W $17BD               
                    STA $22                   
                    LDA.B #$01                
                    STA $23                   
                    RTS                       ; Return 

ADDR_05C4F9:        LDA.W $144E,X             ; Accum (16 bit) 
                    AND.W #$00FF              
                    CLC                       
                    ADC.W $1446,X             
                    STA.W $144E,X             
                    AND.W #$FF00              
                    BPL ADDR_05C50E           
                    ORA.W #$00FF              
ADDR_05C50E:        XBA                       
                    CLC                       
                    ADC.W $1462,X             
                    STA.W $1462,X             
                    LDA $08                   
                    EOR.W #$FFFF              
                    INC A                     
                    STA $08                   
                    RTS                       ; Return 

ADDR_05C51F:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDY.W $1456               
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.W $1450,Y             
                    TAX                       
                    LDA.W $1462,Y             
                    CMP.W $1450,Y             
                    BCC ADDR_05C538           
                    STA $04                   
                    STX $02                   
                    BRA ADDR_05C53C           
ADDR_05C538:        STA $02                   
                    STX $04                   
ADDR_05C53C:        SEP #$10                  ; Index (8 bit) 
                    LDA $02                   
                    CMP $04                   
                    BCC ADDR_05C585           
                    LDY.W $1440               
                    LDA.W $1456               
                    BEQ ADDR_05C54F           
                    LDY.W $1441               
ADDR_05C54F:        TYA                       
                    ASL                       
                    TAY                       
                    LDA.W DATA_05CBEE,Y       
                    AND.W #$00FF              
                    STA $00                   
                    LDA.W $1456               
                    AND.W #$00FF              
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W $1442,X             
                    EOR.W #$0001              
                    STA.W $1442,X             
                    AND.W #$00FF              
                    BNE ADDR_05C579           
                    LDA $00                   
                    EOR.W #$FFFF              
                    INC A                     
                    STA $00                   
ADDR_05C579:        LDX.W $1456               
                    LDA $00                   
                    CLC                       
                    ADC.W $1450,X             
                    STA.W $1450,X             
ADDR_05C585:        LDA.W $1456               
                    AND.W #$00FF              
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W $1442,X             
                    TAX                       
                    LDA.W DATA_05CBF1,X       
                    AND.W #$00FF              
                    CPX.B #$01                
                    BEQ ADDR_05C5A0           
                    EOR.W #$FFFF              
                    INC A                     
ADDR_05C5A0:        LDX.W $1456               
                    LDY.B #$00                
                    CMP.W $1446,X             
                    BEQ ADDR_05C5B8           
                    BPL ADDR_05C5AE           
                    LDY.B #$02                
ADDR_05C5AE:        LDA.W $1446,X             
                    CLC                       
                    ADC.W DATA_05CBC3,Y       
                    STA.W $1446,X             
ADDR_05C5B8:        JMP.W ADDR_05C328         
ADDR_05C5BB:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDY.W $1456               
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.W $144E,Y             
                    TAX                       
                    LDA.W $1464,Y             
                    CMP.W $144E,Y             
                    BCC ADDR_05C5D4           
                    STA $04                   
                    STX $02                   
                    BRA ADDR_05C5D8           
ADDR_05C5D4:        STA $02                   
                    STX $04                   
ADDR_05C5D8:        SEP #$10                  ; Index (8 bit) 
                    LDA $02                   
                    CMP $04                   
                    BCC ADDR_05C621           
                    LDY.W $1440               
                    LDA.W $1456               
                    BEQ ADDR_05C5EB           
                    LDY.W $1441               
ADDR_05C5EB:        TYA                       
                    ASL                       
                    TAY                       
                    LDA.W DATA_05CBF6,Y       
                    AND.W #$00FF              
                    STA $00                   
                    LDA.W $1456               
                    AND.W #$00FF              
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W $1442,X             
                    EOR.W #$0001              
                    STA.W $1442,X             
                    AND.W #$00FF              
                    BNE ADDR_05C615           
                    LDA $00                   
                    EOR.W #$FFFF              
                    INC A                     
                    STA $00                   
ADDR_05C615:        LDX.W $1456               
                    LDA $00                   
                    CLC                       
                    ADC.W $144E,X             
                    STA.W $144E,X             
ADDR_05C621:        LDA.W $1456               
                    AND.W #$00FF              
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W $1442,X             
                    TAX                       
                    LDA.W DATA_05CBF1,X       
                    AND.W #$00FF              
                    CPX.B #$01                
                    BEQ ADDR_05C63C           
                    EOR.W #$FFFF              
                    INC A                     
ADDR_05C63C:        LDX.W $1456               
                    LDY.B #$00                
                    CMP.W $1448,X             
                    BEQ ADDR_05C654           
                    BPL ADDR_05C64A           
                    LDY.B #$02                
ADDR_05C64A:        LDA.W $1448,X             
                    CLC                       
                    ADC.W DATA_05CBC3,Y       
                    STA.W $1448,X             
ADDR_05C654:        INX                       
                    INX                       
                    JMP.W ADDR_05C328         
ADDR_05C659:        LDA.W $1441               
                    BEQ ADDR_05C674           
                    DEC.W $1441               
                    CMP.W #$B020              
                    ASL.W $14A5               
                    AND.W #$D001              
                    PHP                       
                    LDA.W $1464               
                    EOR.W #$8D01              
                    STZ $14                   
                    RTS                       ; Return 

ADDR_05C674:        STZ $56                   
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W $144C               
                    CMP.W #$FFC0              
                    BEQ ADDR_05C684           
                    DEC A                     
                    STA.W $144C               
ADDR_05C684:        LDA.W $1468               
                    CMP.W #$0031              
                    BPL ADDR_05C68F           
                    STZ.W $144C               
ADDR_05C68F:        BNE ADDR_05C696           
                    LDY.B #$20                
                    STY.W $1441               
ADDR_05C696:        LDX.B #$06                
                    JSR.W ADDR_05C4F9         
                    JMP.W ADDR_05C32B         
ADDR_05C69E:        LDA.W #$8502              
                    EOR $64,X                 
                    LSR $C2,X                 
                    JSR.W $40AE               
                    TRB $D0                   
                    JSL.L $1446AD             
                    CMP.W #$0080              
                    BEQ ADDR_05C6B4           
                    INC A                     
ADDR_05C6B4:        STA.W $1446               
                    LDY $5E                   
                    DEY                       
                    CPY.W $1463               
                    BNE ADDR_05C6EC           
                    INC.W $1440               
                    STZ.W $1446               
                    LDA.W #$FCF0              
                    STA.W $1B97               
                    BRA ADDR_05C6EC           
                    LDY.B #$16                
                    STY.W $212C               ; Background and Object Enable
                    LDA.W $144C               
                    CMP.W #$FF80              
                    BEQ ADDR_05C6DB           
                    DEC A                     
ADDR_05C6DB:        STA.W $144C               
                    STA.W $1448               
                    LDA.W $1468               
                    BNE ADDR_05C6EC           
                    STZ.W $144C               
                    STZ.W $1448               
ADDR_05C6EC:        LDX.B #$06                
ADDR_05C6EE:        JSR.W ADDR_05C4F9         
                    DEX                       
                    DEX                       
                    BPL ADDR_05C6EE           
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.W $1463               
                    SEC                       
                    SBC $5E                   
                    INC A                     
                    INC A                     
                    XBA                       
                    LDA.W $1462               
                    REP #$20                  ; Accum (16 bit) 
                    LDY.B #$82                
                    CMP.W #$0000              
                    BPL ADDR_05C711           
                    LDA.W #$0000              
                    LDY.B #$02                
ADDR_05C711:        STA.W $1466               
                    STA $1E                   
                    STY $5B                   
                    JMP.W ADDR_05C32B         

DATA_05C71B:        .db $20,$00,$C1,$00

DATA_05C71F:        .db $C0,$FF,$40,$00

DATA_05C723:        .db $FF,$FF,$01,$00

ADDR_05C727:        LDX.W $14AF               ; Accum (8 bit) 
                    BEQ ADDR_05C72E           
                    LDX.B #$02                
ADDR_05C72E:        CPX.W $1443               
                    BEQ ADDR_05C74A           
                    DEC.W $1445               
                    BPL ADDR_05C73B           
                    STX.W $1443               
ADDR_05C73B:        LDA.W $1468               
                    EOR.B #$01                
                    STA.W $1468               
                    STZ.W $144C               
                    STZ.W $144D               
                    RTS                       ; Return 

ADDR_05C74A:        LDA.B #$10                
                    STA.W $1445               
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W $1468               
                    CMP.W DATA_05C71B,X       
                    BNE ADDR_05C770           
                    CPX.B #$00                
                    BNE ADDR_05C769           
                    LDA.W #$0009              
                    STA.W $1DFC               ; / Play sound effect 
                    LDA.W #$0020              
                    STA.W $1887               
ADDR_05C769:        LDX.B #$00                
                    STX.W $14AF               
                    BRA ADDR_05C784           
ADDR_05C770:        LDA.W $144C               ; Accum (8 bit) 
                    CMP.W DATA_05C71F,X       
                    BEQ ADDR_05C77F           
                    CLC                       
                    ADC.W DATA_05C723,X       
                    STA.W $144C               
ADDR_05C77F:        LDX.B #$06                
                    JSR.W ADDR_05C4F9         
ADDR_05C784:        JMP.W ADDR_05C32B         
ADDR_05C787:        LDA.B #$02                
                    STA $55                   
                    STA $56                   
                    LDA.W $1456               
                    LSR                       
                    LSR                       
                    TAX                       
                    LDY.W $1440,X             
                    LDX.W $1456               
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W $1446,X             
                    CMP.W DATA_05C001,Y       
                    BEQ ADDR_05C7A4           
                    INC A                     
ADDR_05C7A4:        STA.W $1446,X             
                    LDA $5E                   
                    DEC A                     
                    XBA                       
                    AND.W #$FF00              
                    CMP.W $1462,X             
                    BNE ADDR_05C7B6           
                    STZ.W $1446,X             
ADDR_05C7B6:        JSR.W ADDR_05C4F9         
                    JMP.W ADDR_05C32B         
ADDR_05C7BC:        LDA.W $1B9A               ; Accum (8 bit) 
                    BEQ ADDR_05C7ED           
ADDR_05C7C1:        LDA.B #$02                
                    STA $56                   
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W $144A               
                    CMP.W #$0400              
                    BEQ ADDR_05C7D0           
                    INC A                     
ADDR_05C7D0:        STA.W $144A               
                    LDX.B #$04                
                    JSR.W ADDR_05C4F9         
                    LDA.W $17BD               
                    AND.W #$00FF              
                    CMP.W #$0080              
                    BCC ADDR_05C7E6           
                    ORA.W #$FF00              
ADDR_05C7E6:        CLC                       
                    ADC.W $1466               
                    STA.W $1466               
ADDR_05C7ED:        JMP.W ADDR_05C32B         

DATA_05C7F0:        .db $00,$00,$F0,$02,$B0,$08,$00,$00
                    .db $00,$00,$70,$03

DATA_05C7FC:        .db $D0,$00,$50,$03,$30,$0A,$08,$00
                    .db $40,$00,$80,$03

DATA_05C808:        .db $00,$06,$08

DATA_05C80B:        .db $03,$01,$02

DATA_05C80E:        .db $C0,$00

DATA_05C810:        .db $00,$00,$B0,$00

DATA_05C814:        .db $80,$FF,$C0,$00

DATA_05C818:        .db $FF,$FF,$01,$00

ADDR_05C81C:        REP #$20                  ; Accum (16 bit) 
                    STZ $00                   
                    LDY.W $1445               
                    STY $00                   
                    LDY.B #$00                
                    LDX.W $1444               
                    CPX.B #$08                
                    BCC ADDR_05C830           
                    LDY.B #$02                
ADDR_05C830:        LDA.W $1466               
                    CMP.W DATA_05C7F0,X       
                    BCC ADDR_05C84C           
                    CMP.W DATA_05C7FC,X       
                    BCS ADDR_05C84C           
                    STZ.W $1442               
                    LDA.W DATA_05C80E,Y       
                    STA.W $1468               
                    STZ.W $144C               
                    STZ.W $1454               
ADDR_05C84C:        INX                       
                    INX                       
                    DEC $00                   
                    BNE ADDR_05C830           
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.W $1442               
                    ORA.W $140E               
                    STA.W $1442               
                    BEQ ADDR_05C87D           
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W $1468               
                    CMP.W DATA_05C810,Y       
                    BEQ ADDR_05C87D           
                    LDA.W $144C               
                    CMP.W DATA_05C814,Y       
                    BEQ ADDR_05C875           
                    CLC                       
                    ADC.W DATA_05C818,Y       
ADDR_05C875:        STA.W $144C               
                    LDX.B #$06                
                    JSR.W ADDR_05C4F9         
ADDR_05C87D:        SEP #$20                  ; Accum (8 bit) 
                    RTS                       ; Return 


DATA_05C880:        .db $00,$00,$C0,$01,$00,$03,$00,$08
                    .db $38,$08,$00,$0A,$00,$00,$80,$03
                    .db $50,$04,$90,$08,$60,$09,$80,$0E
                    .db $00,$40,$00,$40,$00,$40,$00,$40
                    .db $00,$40,$00,$00

DATA_05C8A4:        .db $08,$00,$00,$03,$10,$04,$38,$08
                    .db $70,$08,$00,$0B,$08,$00,$50,$04
                    .db $A0,$04,$60,$09,$40,$0A,$FF,$0F
                    .db $00,$50,$00,$50,$00,$50,$00,$50
                    .db $00,$50,$80,$00

DATA_05C8C8:        .db $C0,$00,$B0,$00,$70,$00,$C0,$00
                    .db $C0,$00,$C0,$00,$00,$00,$00,$00
                    .db $C0,$00,$B0,$00,$A0,$00,$70,$00
                    .db $B0,$00,$B0,$00,$B0,$00,$00,$00
                    .db $00,$00,$B0,$00,$20,$00,$20,$00
                    .db $20,$00,$10,$00,$10,$00,$10,$00
                    .db $00,$00,$00,$00,$10,$00

DATA_05C8FE:        .db $00,$01,$00,$01,$00,$08,$00,$01
                    .db $00,$01,$00,$08,$00,$00,$00,$00
                    .db $80,$01,$00,$FF,$00,$FF,$00,$00
                    .db $00,$FF,$00,$FF,$00,$FF,$00,$FF
                    .db $00,$FF,$00,$FF,$00,$F8,$00,$F8
                    .db $00,$F8,$00,$F8,$00,$F8,$00,$F8
                    .db $00,$00,$00,$00,$40,$FE

DATA_05C934:        .db $80,$40,$01,$80,$00,$00,$80,$00
                    .db $40,$00,$00,$20,$40,$00,$20,$00
                    .db $00,$20,$80,$80,$20,$80,$80,$20
                    .db $00,$00,$A0

DATA_05C94F:        .db $00,$0C,$18

DATA_05C952:        .db $05,$05,$05

ADDR_05C955:        LDX.W $1440               
                    LDY.W $1441               
ADDR_05C95B:        REP #$20                  ; Accum (16 bit) 
ADDR_05C95D:        LDA.W $1466               
                    CMP.W DATA_05C880,X       
                    BCC ADDR_05C97B           
                    CMP.W DATA_05C8A4,X       
                    BCS ADDR_05C97B           
                    TXA                       
                    LSR                       
                    AND.W #$00FE              
                    STA.W $1442               
                    LDA.W #$00C1              
                    STA.W $1468               
                    STZ.W $1444               
ADDR_05C97B:        INX                       
                    INX                       
                    DEY                       
                    BNE ADDR_05C95D           
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.W $1444               
                    BEQ ADDR_05C98B           
                    DEC.W $1444               
                    RTS                       ; Return 

ADDR_05C98B:        LDA.W $1442               
                    CLC                       
                    ADC.W $1443               
                    TAY                       
                    LSR                       
                    TAX                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W $1468               
                    SEC                       
                    SBC.W DATA_05C8C8,Y       
                    EOR.W DATA_05C8FE,Y       
                    BPL ADDR_05C9A9           
                    LDA.W DATA_05C8FE,Y       
                    JMP.W ADDR_05C875         
ADDR_05C9A9:        LDA.W DATA_05C8C8,Y       
                    STA.W $1468               
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.W DATA_05C934,X       
                    STA.W $1444               
                    LDA.W $1443               
                    CLC                       
                    ADC.B #$12                
                    CMP.B #$36                
                    BCC ADDR_05C9CD           
                    LDA.B #$09                
                    STA.W $1DFC               ; / Play sound effect 
                    LDA.B #$20                
                    STA.W $1887               
                    LDA.B #$00                
ADDR_05C9CD:        STA.W $1443               
                    RTS                       ; Return 


DATA_05C9D1:        .db $01,$01,$01,$00,$01,$01,$01,$00
                    .db $01,$09

DATA_05C9DB:        .db $01,$00,$02,$00,$04,$03,$05,$00
                    .db $06,$00

DATA_05C9E5:        .db $00,$01

DATA_05C9E7:        .db $00,$00

DATA_05C9E9:        .db $00,$00,$02,$02,$02,$00,$02,$05
                    .db $02,$02,$05,$00,$00,$02,$01,$00
                    .db $03,$02,$03,$04,$03,$01,$00,$01
                    .db $00,$00,$03,$00,$00,$00,$00

DATA_05CA08:        .db $00,$04,$00,$04

DATA_05CA0C:        .db $00,$00,$00,$01

DATA_05CA10:        .db $00,$01

DATA_05CA12:        .db $40,$01,$E0,$00

DATA_05CA16:        .db $05,$00,$00,$05,$05,$02,$02,$05
DATA_05CA1E:        .db $00,$00,$00,$01,$02,$03,$04,$03
DATA_05CA26:        .db $01,$00,$01,$01,$00,$06,$00,$06
                    .db $00,$00,$00,$01,$00,$01,$08,$00
                    .db $00,$08,$00,$00,$00,$01,$01,$00
DATA_05CA3E:        .db $00,$08,$00,$08

DATA_05CA42:        .db $00,$00,$00,$01

DATA_05CA46:        .db $01,$01

DATA_05CA48:        .db $00,$03,$00,$03,$00,$03,$00,$03
                    .db $00,$03

DATA_05CA52:        .db $00,$00,$00,$01,$00,$02,$00,$03
                    .db $00,$04

DATA_05CA5C:        .db $01,$00,$00,$00,$00

DATA_05CA61:        .db $01,$18,$1E,$29,$2D,$35,$47

DATA_05CA68:        .db $16,$05,$0A,$03,$07,$11

DATA_05CA6E:        .db $09

DATA_05CA6F:        .db $00,$09,$14,$1C,$24,$28,$33,$3C
                    .db $43,$4B,$54,$60,$67,$74,$77,$7B
                    .db $83,$8A,$8D,$90,$99,$A0,$B0,$00
                    .db $09,$14,$2C,$3C,$B0,$00,$09,$11
                    .db $1D,$2C,$32,$41,$48,$63,$6B,$70
                    .db $00,$27,$37,$70,$00,$07,$12,$27
                    .db $32,$48,$5B,$70,$00,$20,$28,$3A
                    .db $40,$5F,$66,$6B,$6B,$80,$80,$89
                    .db $92,$96,$9A,$9E,$A0,$B0,$00,$10
                    .db $1A,$20,$2B,$30,$3B,$40,$4B

DATA_05CABE:        .db $50

DATA_05CABF:        .db $0C,$0C,$06,$0B,$08,$0C,$03,$02
                    .db $09,$03,$09,$02,$06,$06,$07,$05
                    .db $08,$05,$0A,$04,$08,$04,$04,$0C
                    .db $0C,$07,$07,$05,$05,$0C,$0C,$08
                    .db $0C,$0C,$07,$07,$0A,$0A,$0C,$0C
                    .db $00,$00,$0A,$0A,$00,$00,$09,$09
                    .db $03,$03,$0C,$0C,$0C,$0C,$08,$08
                    .db $05,$05,$02,$02,$09,$09,$01,$01
                    .db $01,$02,$03,$07,$08,$08,$0C,$0C
                    .db $02,$02,$0A,$0A,$02,$02,$0A,$0A
DATA_05CB0F:        .db $07,$07,$07,$07,$07,$07,$07,$07
                    .db $07,$07,$07,$07,$07,$07,$07,$07
                    .db $07,$07,$07,$07,$07,$07,$07,$07
                    .db $07,$07,$07,$07,$07,$07,$07,$07
                    .db $07,$07,$07,$07,$07,$07,$07,$07
                    .db $07,$07,$07,$07,$07,$07,$07,$07
                    .db $07,$07,$07,$07,$08,$08,$08,$08
                    .db $08,$08,$10,$08,$40,$08,$04,$08
                    .db $10,$08,$08,$10,$10,$08,$08,$08
                    .db $08,$08,$08,$08,$08,$08,$08,$08
DATA_05CB5F:        .db $01,$00,$FF,$FF,$01,$00,$FF,$FF
                    .db $01,$00,$FF,$FF,$01,$00,$FF,$FF
                    .db $01,$00,$FF,$FF,$01,$00,$FF,$FF
                    .db $01,$00,$FF,$FF

DATA_05CB7B:        .db $01,$00,$FF,$FF,$01,$00,$FF,$FF
                    .db $01,$00,$FF,$FF,$01,$00,$FF,$FF
                    .db $01,$00,$FF,$FF,$01,$00,$FF,$FF
                    .db $01,$00,$FF,$FF,$04,$00,$FC,$FF
DATA_05CB9B:        .db $01,$00,$FF,$FF,$01,$00,$FF,$FF
DATA_05CBA3:        .db $04,$00,$FC,$FF,$04,$00,$FC,$FF
                    .db $04,$00,$FC,$FF,$04,$00,$FC,$FF
                    .db $01,$00,$FF,$FF,$01,$00,$FF,$FF
DATA_05CBBB:        .db $04,$00,$FC,$FF,$04,$00,$FC,$FF
DATA_05CBC3:        .db $01,$00,$FF,$FF

DATA_05CBC7:        .db $30

DATA_05CBC8:        .db $70,$80,$10,$28,$30,$30,$30,$30
                    .db $14,$02,$30,$30,$30,$30,$70,$80
                    .db $70,$80,$70,$80,$70,$80,$70,$80
                    .db $70,$80,$18

DATA_05CBE3:        .db $18,$18

DATA_05CBE5:        .db $18,$18,$08,$20,$06,$06

DATA_05CBEB:        .db $04,$04

DATA_05CBED:        .db $60

DATA_05CBEE:        .db $42,$D0,$B2

DATA_05CBF1:        .db $80,$80,$80,$80

DATA_05CBF5:        .db $90

DATA_05CBF6:        .db $72,$60,$42,$20,$10,$40,$22,$20
                    .db $10

ADDR_05CBFF:        .db $8B

                    PHK                       
                    PLB                       
                    JSR.W ADDR_05CC07         
                    PLB                       
                    RTL                       ; Return 

ADDR_05CC07:        LDA.W $13D9               
                    JSL.L ExecutePtr          

Ptrs05CC0E:         .dw ADDR_05CC66           
                    .dw ADDR_05CD76           
                    .dw ADDR_05CECA           
                    .dw ADDR_05CFE9           

DATA_05CC16:        .db $51,$0D,$00,$09,$30,$28,$31,$28
                    .db $32,$28,$33,$28,$34,$28,$51,$49
                    .db $00,$19,$0C,$38,$18,$38,$1E,$38
                    .db $1B,$38,$1C,$38,$0E,$38,$FC,$38
                    .db $0C,$38,$15,$38,$0E,$38,$0A,$38
                    .db $1B,$38,$28,$38,$51,$A9,$00,$19
                    .db $76,$38,$FC,$38,$FC,$38,$FC,$38
                    .db $26,$38,$05,$38,$00,$38,$77,$38
                    .db $FC,$38,$FC,$38,$FC,$38,$FC,$38
                    .db $FC,$38,$FF

DATA_05CC61:        .db $40,$41,$42,$43,$44

ADDR_05CC66:        LDY.B #$00                
                    LDX.W $0DB3               
                    LDA.W $0F48,X             
ADDR_05CC6E:        CMP.B #$0A                
                    BCC ADDR_05CC77           
                    SBC.B #$0A                
                    INY                       
                    BRA ADDR_05CC6E           
ADDR_05CC77:        CPY.W $0F32               
                    BNE ADDR_05CC84           
                    CPY.W $0F33               
                    BNE ADDR_05CC84           
                    INC.W $18E4               
ADDR_05CC84:        LDA.B #$01                
                    STA.W $13D5               
                    LDA.B #$08                
                    TSB $3E                   
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    STZ $22                   
                    STZ $24                   
                    LDY.W #$004A              
                    TYA                       
                    CLC                       
                    ADC.L $7F837B             
                    TAX                       
ADDR_05CC9D:        LDA.W DATA_05CC16,Y       
                    STA.L $7F837D,X           
                    DEX                       
                    DEX                       
                    DEY                       
                    DEY                       
                    BPL ADDR_05CC9D           
                    LDA.L $7F837B             
                    TAX                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.W $0DB3               
                    BEQ ADDR_05CCC8           
                    LDY.W #$0000              
ADDR_05CCB9:        LDA.W DATA_05CC61,Y       
                    STA.L $7F8381,X           
                    INX                       
                    INX                       
                    INY                       
                    CPY.W #$0005              
                    BNE ADDR_05CCB9           
ADDR_05CCC8:        LDY.W #$0002              
                    LDA.B #$04                
                    CLC                       
                    ADC.L $7F837B             
                    TAX                       
ADDR_05CCD3:        LDA.W $0F31,Y             
                    STA.L $7F83AF,X           
                    DEY                       
                    DEX                       
                    DEX                       
                    BPL ADDR_05CCD3           
                    LDA.L $7F837B             
                    TAX                       
ADDR_05CCE4:        LDA.L $7F83AF,X           
                    AND.B #$0F                
                    BNE ADDR_05CCF9           
                    LDA.B #$FC                
                    STA.L $7F83AF,X           
                    INX                       
                    INX                       
                    CPX.W #$0004              
                    BNE ADDR_05CCE4           
ADDR_05CCF9:        SEP #$10                  ; Index (8 bit) 
                    JSR.W ADDR_05CE4C         
                    REP #$20                  ; Accum (16 bit) 
                    STZ $00                   
                    LDA $02                   
                    STA.W $0F40               
                    LDX.B #$42                
                    LDY.B #$00                
                    JSR.W ADDR_05CDFD         
                    LDX.B #$00                
ADDR_05CD10:        LDA.L $7F83BD,X           
                    AND.W #$000F              
                    BNE ADDR_05CD26           
                    LDA.W #$38FC              
                    STA.L $7F83BD,X           
                    INX                       
                    INX                       
                    CPX.B #$08                
                    BNE ADDR_05CD10           
ADDR_05CD26:        SEP #$20                  ; Accum (8 bit) 
                    INC.W $13D9               
                    LDA.B #$28                
                    STA.W $1424               
                    LDA.B #$4A                
                    CLC                       
                    ADC.L $7F837B             
                    INC A                     
                    STA.L $7F837B             
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    RTS                       ; Return 


DATA_05CD3F:        .db $52,$0A,$00,$15,$0B,$38,$18,$38
                    .db $17,$38,$1E,$38,$1C,$38,$28,$38
                    .db $FC,$38,$64,$28,$26,$38,$FC,$38
                    .db $FC,$38,$51,$F3,$00,$03,$FC,$38
                    .db $FC,$38,$FF

DATA_05CD62:        .db $B7

DATA_05CD63:        .db $C3,$B8,$B9,$BA,$BB,$BA,$BF,$BC
                    .db $BD,$BE,$BF,$C0,$C3,$C1,$B9,$C2
                    .db $C4,$B7,$C5

ADDR_05CD76:        LDA.W $1900               
                    BEQ ADDR_05CDD5           
                    DEC.W $1424               
                    BPL ADDR_05CDE8           
                    LDY.B #$22                
                    TYA                       
                    CLC                       
                    ADC.L $7F837B             
                    TAX                       
ADDR_05CD89:        LDA.W DATA_05CD3F,Y       
                    STA.L $7F837D,X           
                    DEX                       
                    DEY                       
                    BPL ADDR_05CD89           
                    LDA.L $7F837B             
                    TAX                       
                    LDA.W $1900               
                    AND.B #$0F                
                    ASL                       
                    TAY                       
                    LDA.W DATA_05CD63,Y       
                    STA.L $7F8395,X           
                    LDA.W DATA_05CD62,Y       
                    STA.L $7F839D,X           
                    LDA.W $1900               
                    AND.B #$F0                
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    BEQ ADDR_05CDC9           
                    ASL                       
                    TAY                       
                    LDA.W DATA_05CD63,Y       
                    STA.L $7F8393,X           
                    LDA.W DATA_05CD62,Y       
                    STA.L $7F839B,X           
ADDR_05CDC9:        LDA.B #$22                
                    CLC                       
                    ADC.L $7F837B             
                    INC A                     
                    STA.L $7F837B             
ADDR_05CDD5:        DEC.W $13D6               
                    BPL ADDR_05CDE8           
                    LDA.W $1900               
                    STA.W $1424               
                    INC.W $13D9               
                    LDA.B #$11                
                    STA.W $1DFC               ; / Play sound effect 
ADDR_05CDE8:        RTS                       ; Return 


DATA_05CDE9:        .db $00,$00

DATA_05CDEB:        .db $10,$27,$00,$00,$E8,$03,$00,$00
                    .db $64,$00,$00,$00,$0A,$00,$00,$00
                    .db $01,$00

ADDR_05CDFD:        LDA.L $7F837B,X           ; Accum (16 bit) 
                    AND.W #$FF00              
                    STA.L $7F837B,X           
ADDR_05CE08:        PHX                       
                    TYX                       
                    LDA $02                   
                    SEC                       
                    SBC.W DATA_05CDEB,X       
                    STA $06                   
                    LDA $00                   
                    SBC.W DATA_05CDE9,X       
                    STA $04                   
                    PLX                       
                    BCC ADDR_05CE2F           
                    LDA $06                   
                    STA $02                   
                    LDA $04                   
                    STA $00                   
                    LDA.L $7F837B,X           
                    INC A                     
                    STA.L $7F837B,X           
                    BRA ADDR_05CE08           
ADDR_05CE2F:        INX                       
                    INX                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    CPY.B #$14                
                    BNE ADDR_05CDFD           
                    RTS                       ; Return 


DATA_05CE3A:        .db $00,$00,$64,$00,$C8,$00,$2C,$01
DATA_05CE42:        .db $00,$0A,$14,$1E,$28,$32,$3C,$46
                    .db $50,$5A

ADDR_05CE4C:        REP #$20                  ; Accum (16 bit) 
                    LDA.W $0F31               
                    ASL                       
                    TAX                       
                    LDA.W DATA_05CE3A,X       
                    STA $00                   
                    LDA.W $0F32               
                    TAX                       
                    LDA.W DATA_05CE42,X       
                    AND.W #$00FF              
                    CLC                       
                    ADC $00                   
                    STA $00                   
                    LDA.W $0F33               
                    AND.W #$00FF              
                    CLC                       
                    ADC $00                   
                    STA $00                   
                    SEP #$20                  ; Accum (8 bit) 
                    LDA $00                   
                    STA.W $4202               ; Multiplicand A
                    LDA.B #$32                
                    STA.W $4203               ; Multplier B
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    LDA.W $4216               ; Product/Remainder Result (Low Byte)
                    STA $02                   
                    LDA.W $4217               ; Product/Remainder Result (High Byte)
                    STA $03                   
                    LDA $01                   
                    STA.W $4202               ; Multiplicand A
                    LDA.B #$32                
                    STA.W $4203               ; Multplier B
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    LDA.W $4216               ; Product/Remainder Result (Low Byte)
                    CLC                       
                    ADC $03                   
                    STA $03                   
                    RTS                       ; Return 


DATA_05CEA3:        .db $51,$B1,$00,$09,$FC,$38,$FC,$38
                    .db $FC,$38,$FC,$38,$00,$38,$51,$F3
                    .db $00,$03,$FC,$38,$FC,$38,$52,$13
                    .db $00,$03,$FC,$38,$FC,$38,$FF

DATA_05CEC2:        .db $0A,$00,$64,$00

DATA_05CEC6:        .db $01,$00,$0A,$00

ADDR_05CECA:        PHB                       
                    PHK                       
                    PLB                       
                    REP #$20                  ; Accum (16 bit) 
                    LDX.B #$00                
                    LDA.W $0DB3               
                    AND.W #$00FF              
                    BEQ ADDR_05CEDB           
                    LDX.B #$03                
ADDR_05CEDB:        LDY.B #$02                
                    LDA.W $0F40               
                    BEQ ADDR_05CF05           
                    CMP.W #$0063              
                    BCS ADDR_05CEE9           
                    LDY.B #$00                
ADDR_05CEE9:        SEC                       
                    SBC.W DATA_05CEC2,Y       
                    STA.W $0F40               
                    STA $02                   
                    LDA.W DATA_05CEC6,Y       
                    CLC                       
                    ADC.W $0F34,X             
                    STA.W $0F34,X             
                    LDA.W $0F36,X             
                    ADC.W #$0000              
                    STA.W $0F36,X             
ADDR_05CF05:        LDX.W $1900               
                    BEQ ADDR_05CF36           
                    SEP #$20                  ; Accum (8 bit) 
                    LDA $13                   
                    AND.B #$03                
                    BNE ADDR_05CF34           
                    LDX.W $0DB3               
                    LDA.W $0F48,X             
                    CLC                       
                    ADC.B #$01                
                    STA.W $0F48,X             
                    LDA.W $1900               
                    DEC A                     
                    STA.W $1900               
                    AND.B #$0F                
                    CMP.B #$0F                
                    BNE ADDR_05CF34           
                    LDA.W $1900               
                    SEC                       
                    SBC.B #$06                
                    STA.W $1900               
ADDR_05CF34:        REP #$20                  ; Accum (16 bit) 
ADDR_05CF36:        LDA.W $0F40               
                    BNE ADDR_05CF4D           
                    LDX.W $1900               
                    BNE ADDR_05CF4D           
                    LDX.B #$30                
                    STX.W $13D6               
                    INC.W $13D9               
                    LDX.B #$12                
                    STX.W $1DFC               ; / Play sound effect 
ADDR_05CF4D:        LDY.B #$1E                
                    TYA                       
                    CLC                       
                    ADC.L $7F837B             
                    TAX                       
                    INC A                     
                    STA $0A                   
ADDR_05CF59:        LDA.W DATA_05CEA3,Y       
                    STA.L $7F837D,X           
                    DEX                       
                    DEX                       
                    DEY                       
                    DEY                       
                    BPL ADDR_05CF59           
                    LDA.W $0F40               
                    BEQ ADDR_05CFA0           
                    STZ $00                   
                    LDA.L $7F837B             
                    CLC                       
                    ADC.W #$0006              
                    TAX                       
                    LDY.B #$00                
                    JSR.W ADDR_05CDFD         
                    LDA.L $7F837B             
                    CLC                       
                    ADC.W #$0008              
                    STA $00                   
                    LDA.L $7F837B             
                    TAX                       
ADDR_05CF8A:        LDA.L $7F8381,X           
                    AND.W #$000F              
                    BNE ADDR_05CFA0           
                    LDA.W #$38FC              
                    STA.L $7F8381,X           
                    INX                       
                    INX                       
                    CPX $00                   
                    BNE ADDR_05CF8A           
ADDR_05CFA0:        SEP #$20                  ; Accum (8 bit) 
                    REP #$10                  ; Index (16 bit) 
                    LDA.W $1424               
                    BEQ ADDR_05CFDC           
                    LDA.L $7F837B             
                    TAX                       
                    LDA.W $1900               
                    AND.B #$0F                
                    ASL                       
                    TAY                       
                    LDA.W DATA_05CD62,Y       
                    STA.L $7F8391,X           
                    LDA.W DATA_05CD63,Y       
                    STA.L $7F8399,X           
                    LDA.W $1900               
                    AND.B #$F0                
                    LSR                       
                    LSR                       
                    LSR                       
                    BEQ ADDR_05CFDC           
                    TAY                       
                    LDA.W DATA_05CD62,Y       
                    STA.L $7F838F,X           
                    LDA.W DATA_05CD63,Y       
                    STA.L $7F8397,X           
ADDR_05CFDC:        REP #$20                  ; Accum (16 bit) 
                    SEP #$10                  ; Index (8 bit) 
                    LDA $0A                   
                    STA.L $7F837B             
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    PLB                       
ADDR_05CFE9:        RTS                       ; Return 


DATA_05CFEA:        .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$22,$01
                    .db $22,$01,$22,$01,$22,$01,$D8,$01
                    .db $D9,$C1,$D9,$01,$D8,$C1,$22,$01
                    .db $DF,$01,$22,$01,$DF,$01,$EE,$C1
                    .db $DE,$C1,$ED,$C1,$DD,$C1,$DA,$01
                    .db $DA,$C1,$DA,$01,$DA,$C1,$DD,$01
                    .db $ED,$01,$DE,$01,$EE,$01,$DF,$01
                    .db $22,$01,$DF,$01,$22,$01,$22,$01
                    .db $D8,$01,$22,$01,$D9,$01,$22,$01
                    .db $EB,$01,$EB,$01,$EB,$C1,$EB,$C1
                    .db $22,$01,$22,$01,$22,$01,$22,$01
                    .db $22,$01,$22,$01,$EB,$01,$EC,$C1
                    .db $DC,$C1,$DC,$01,$EC,$01,$DB,$01
                    .db $DB,$01,$22,$01,$22,$01,$22,$01
                    .db $22,$01,$EC,$C1,$DC,$C1,$DC,$01
                    .db $EC,$01,$22,$01,$22,$01,$D6,$01
                    .db $E6,$01,$D7,$01,$E7,$01,$EA,$01
                    .db $EA,$01,$EA,$C1,$EA,$C1,$D9,$C1
                    .db $22,$01,$D8,$C1,$22,$01,$E7,$C1
                    .db $D7,$C1,$E6,$C1,$D6,$C1,$22,$01
                    .db $22,$01,$DB,$01,$DB,$01,$D9,$41
                    .db $D8,$81,$D8,$41,$D9,$81,$ED,$81
                    .db $DD,$81,$EE,$81,$DE,$81,$DE,$41
                    .db $EE,$41,$DD,$41,$ED,$41,$22,$01
                    .db $D9,$41,$22,$01,$D8,$41,$EB,$41
                    .db $EB,$81,$22,$01,$EB,$41,$22,$01
                    .db $22,$01,$EB,$81,$22,$01,$22,$01
                    .db $EB,$41,$22,$01,$22,$01,$DC,$41
                    .db $EC,$41,$EC,$81,$DC,$81,$EC,$81
                    .db $DC,$81,$22,$01,$22,$01,$22,$01
                    .db $22,$01,$DC,$41,$EC,$41,$D7,$41
                    .db $E7,$41,$D6,$41,$E6,$41,$D8,$81
                    .db $22,$01,$D9,$81,$22,$01,$E6,$81
                    .db $D6,$81,$E7,$81,$D7,$81,$EB,$81
                    .db $22,$01,$EB,$41,$EB,$81,$EB,$01
                    .db $EB,$C1,$EB,$C1,$22,$01,$A8,$11
                    .db $B8,$11,$A9,$11,$B9,$11,$A6,$11
                    .db $B6,$11,$A7,$11,$B7,$11,$A6,$11
                    .db $B6,$11,$A7,$11,$B7,$11,$20,$68
                    .db $20,$68,$20,$28,$20,$28,$20,$28
                    .db $20,$28,$22,$09,$22,$09,$22,$01
                    .db $22,$01,$EC,$C1,$DC,$C1,$DC,$01
                    .db $EC,$01,$22,$01,$22,$01,$EA,$01
                    .db $EA,$01,$EA,$C1,$EA,$C1,$EE,$C1
                    .db $DE,$C1,$ED,$C1,$DD,$C1,$DD,$01
                    .db $ED,$01,$DE,$01,$EE,$01,$EB,$C1
                    .db $22,$01,$22,$01,$22,$01,$22,$01
                    .db $22,$01,$22,$01,$EB,$01,$EC,$C1
                    .db $DC,$C1,$DC,$01,$EC,$01,$DB,$01
                    .db $DB,$01,$22,$01,$22,$01,$D6,$01
                    .db $E6,$01,$D7,$01,$E7,$01,$ED,$81
                    .db $DD,$81,$EE,$81,$DE,$81,$DF,$01
                    .db $22,$01,$DF,$01,$22,$01,$D7,$41
                    .db $E7,$41,$D6,$41,$E6,$41,$22,$01
                    .db $EB,$41,$22,$01,$22,$01,$EC,$81
                    .db $DC,$81,$22,$01,$22,$01,$22,$01
                    .db $22,$01,$EB,$81,$22,$01,$D9,$41
                    .db $D8,$81,$D8,$41,$D9,$81,$EB,$C1
                    .db $EB,$C1,$EB,$C1,$22,$01,$22,$01
                    .db $22,$01,$DB,$01,$DB,$01,$E7,$C1
                    .db $D7,$C1,$E6,$C1,$D6,$C1,$22,$01
                    .db $DF,$01,$22,$01,$DF,$01,$E6,$81
                    .db $D6,$81,$E7,$81,$D7,$81,$D8,$01
                    .db $D9,$C1,$D9,$01,$D8,$C1,$EA,$01
                    .db $EA,$01,$EA,$C1,$EA,$C1,$EA,$01
                    .db $EA,$01,$EA,$C1,$EA,$C1,$D6,$01
                    .db $E6,$01,$D7,$01,$E7,$01,$DA,$01
                    .db $DA,$C1,$DA,$01,$DA,$C1,$A4,$11
                    .db $B4,$11,$A5,$11,$B5,$11,$22,$11
                    .db $90,$11,$22,$11,$91,$11,$C2,$11
                    .db $D2,$11,$C3,$11,$D3,$11,$23,$38
                    .db $71,$38,$23,$38,$71,$38,$23,$28
                    .db $71,$28,$23,$28,$71,$28,$23,$30
                    .db $71,$30,$23,$30,$71,$30,$22,$01
                    .db $22,$01,$22,$01,$EB,$01,$22,$01
                    .db $EB,$41,$22,$01,$22,$01,$22,$01
                    .db $22,$01,$EB,$81,$22,$01,$22,$15
                    .db $AC,$15,$22,$15,$AD,$15,$EA,$01
                    .db $EA,$01,$EA,$C1,$EA,$C1,$DA,$01
                    .db $DA,$C1,$DA,$01,$DA,$C1,$DA,$01
                    .db $DA,$C1,$DA,$01,$DA,$C1,$E7,$C1
                    .db $D7,$C1,$E6,$C1,$D6,$C1,$EB,$C1
                    .db $22,$01,$22,$01,$22,$01,$22,$01
                    .db $22,$01,$22,$01,$22,$01,$22,$01
                    .db $22,$01,$22,$01,$22,$01,$22,$01
                    .db $22,$01,$22,$01,$22,$01,$C9,$05
                    .db $C8,$05,$C9,$05,$C8,$05,$84,$11
                    .db $94,$11,$85,$11,$95,$11,$22,$01
                    .db $22,$01,$22,$01,$22,$01,$88,$15
                    .db $98,$15,$89,$15,$99,$15,$22,$01
                    .db $22,$01,$22,$01,$22,$01,$22,$01
                    .db $22,$01,$22,$01,$22,$01,$8C,$15
                    .db $9C,$15,$8D,$15,$9D,$15,$9E,$10
                    .db $64,$10,$9F,$10,$65,$10,$BC,$15
                    .db $AE,$15,$BD,$15,$AF,$15,$82,$19
                    .db $92,$19,$83,$19,$93,$19,$C8,$19
                    .db $F8,$19,$C9,$19,$F9,$19,$AA,$11
                    .db $BA,$11,$AA,$51,$BA,$51,$56,$19
                    .db $EA,$09,$56,$59,$EA,$C9,$A0,$11
                    .db $B0,$11,$A1,$11,$B1,$11,$A2,$11
                    .db $B2,$11,$A3,$11,$B3,$11,$CC,$15
                    .db $CE,$15,$CD,$15,$CF,$15,$22,$01
                    .db $22,$01,$22,$01,$22,$01,$86,$99
                    .db $86,$19,$86,$D9,$86,$59,$96,$99
                    .db $96,$19,$96,$D9,$96,$59,$86,$9D
                    .db $86,$1D,$86,$DD,$86,$5D,$96,$9D
                    .db $96,$1D,$96,$DD,$96,$5D,$86,$99
                    .db $86,$19,$86,$D9,$86,$59,$96,$99
                    .db $96,$19,$96,$D9,$96,$59,$86,$9D
                    .db $86,$1D,$86,$DD,$86,$5D,$96,$9D
                    .db $96,$1D,$96,$DD,$96,$5D,$22,$01
                    .db $22,$01,$22,$01,$22,$01,$22,$01
                    .db $22,$01,$22,$01,$22,$01,$22,$01
                    .db $22,$01,$22,$01,$22,$01,$22,$01
                    .db $22,$01,$22,$01,$22,$01,$22,$01
                    .db $22,$01,$22,$01,$22,$01,$22,$01
                    .db $22,$01,$22,$01,$22,$01,$22,$01
                    .db $22,$01,$22,$01,$22,$01,$22,$01
                    .db $22,$01,$22,$01,$22,$01,$22,$01
                    .db $22,$01,$22,$01,$22,$01,$80,$1C
                    .db $90,$1C,$81,$1C,$90,$5C,$22,$01
                    .db $22,$01,$22,$01,$22,$01,$80,$14
                    .db $90,$14,$81,$14,$90,$54,$22,$01
                    .db $22,$01,$22,$01,$22,$01,$22,$01
                    .db $22,$01,$22,$01,$22,$01,$82,$1D
                    .db $92,$1D,$83,$1D,$93,$1D,$22,$01
                    .db $22,$01,$22,$01,$22,$01,$86,$99
                    .db $86,$19,$86,$D9,$86,$59,$22,$01
                    .db $22,$01,$22,$01,$22,$01,$86,$99
                    .db $86,$19,$86,$D9,$86,$59,$8A,$15
                    .db $9A,$15,$8B,$15,$9B,$15,$8C,$15
                    .db $9C,$15,$8D,$15,$9D,$15,$C0,$11
                    .db $D0,$11,$C1,$11,$D1,$11,$22,$11
                    .db $22,$11,$22,$11,$22,$11,$22,$1D
                    .db $82,$1C,$22,$1D,$83,$1C,$22,$1D
                    .db $82,$14,$22,$1D,$83,$14,$80,$19
                    .db $90,$19,$81,$19,$91,$19,$8E,$19
                    .db $9E,$19,$8F,$19,$9F,$19,$A0,$19
                    .db $B0,$19,$A1,$19,$B1,$19,$A4,$19
                    .db $B4,$19,$A5,$19,$B5,$19,$A8,$19
                    .db $B8,$19,$A9,$19,$B9,$19,$BE,$19
                    .db $CE,$19,$BF,$19,$CF,$19,$C4,$19
                    .db $D4,$19,$C5,$19,$D5,$19,$22,$09
                    .db $C6,$0D,$22,$09,$C7,$0D,$22,$09
                    .db $FC,$0D,$FE,$0D,$FD,$0D,$CC,$0D
                    .db $E4,$0D,$CD,$0D,$E5,$0D,$E0,$0D
                    .db $F0,$0D,$E1,$0D,$F1,$0D,$F4,$0D
                    .db $22,$09,$F5,$0D,$22,$09,$E8,$0D
                    .db $22,$09,$22,$09,$22,$09,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$75,$3C
                    .db $75,$3C,$75,$3C,$75,$3C,$22,$09
                    .db $79,$14,$22,$09,$9D,$14,$22,$09
                    .db $78,$54,$22,$09,$22,$09,$22,$09
                    .db $22,$09,$22,$09,$79,$14,$22,$09
                    .db $9D,$14,$78,$14,$9D,$14,$9D,$14
                    .db $78,$54,$79,$54,$22,$09,$79,$14
                    .db $22,$09,$22,$09,$22,$09,$22,$09
                    .db $22,$09,$78,$54,$22,$09,$22,$09
                    .db $22,$09,$78,$14,$22,$09,$9D,$14
                    .db $22,$09,$79,$54,$22,$09,$22,$09
                    .db $9D,$14,$22,$09,$78,$54,$22,$09
                    .db $78,$14,$22,$09,$22,$09,$22,$09
                    .db $22,$09,$22,$09,$79,$54,$78,$14
                    .db $9D,$14,$9D,$14,$9D,$14,$56,$10
                    .db $9E,$10,$57,$10,$9F,$10,$9E,$10
                    .db $9E,$10,$9F,$10,$9F,$10,$22,$15
                    .db $AC,$15,$22,$15,$AD,$15,$22,$09
                    .db $22,$09,$22,$09,$48,$19,$22,$09
                    .db $39,$19,$22,$09,$22,$09,$22,$09
                    .db $22,$09,$37,$15,$47,$15,$38,$15
                    .db $48,$19,$58,$19,$49,$19,$49,$59
                    .db $59,$59,$48,$59,$58,$59,$37,$55
                    .db $47,$55,$22,$09,$22,$09,$22,$09
                    .db $22,$09,$57,$15,$5A,$1D,$58,$19
                    .db $5B,$19,$59,$19,$59,$19,$60,$19
                    .db $70,$19,$60,$59,$70,$59,$3A,$19
                    .db $4A,$19,$3B,$19,$4B,$11,$48,$19
                    .db $58,$19,$48,$59,$58,$59,$22,$09
                    .db $22,$09,$7A,$1D,$22,$09,$7B,$1D
                    .db $22,$09,$7B,$1D,$22,$09,$7B,$1D
                    .db $22,$09,$7A,$5D,$22,$09,$CA,$19
                    .db $FA,$19,$CB,$19,$FB,$19,$7E,$18
                    .db $22,$09,$22,$09,$22,$09,$7F,$10
                    .db $22,$09,$22,$09,$22,$09,$7F,$10
                    .db $22,$09,$22,$09,$7E,$18,$7E,$18
                    .db $22,$09,$22,$09,$7F,$10,$22,$09
                    .db $22,$09,$22,$09,$7E,$18,$22,$09
                    .db $22,$09,$22,$09,$7F,$10,$3F,$10
                    .db $3F,$10,$3F,$10,$3F,$10,$6F,$51
                    .db $7F,$51,$6E,$51,$7E,$51,$F3,$51
                    .db $FF,$51,$87,$51,$97,$51,$08,$00
                    .db $09,$00,$0A,$00,$0B,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00

DATA_05D608:        .db $FF,$1F,$20,$FF,$0B,$0D,$0E,$0F
                    .db $28,$09,$10,$21,$22,$23,$24,$25
                    .db $27,$60,$FF,$12,$02,$07,$FF,$FF
                    .db $4E,$FF,$4D,$4A,$4C,$4B,$36,$35
                    .db $61,$63,$62,$48,$46,$06,$05,$04
                    .db $00,$01,$03,$19,$FF,$1D,$1A,$14
                    .db $44,$45,$42,$3E,$40,$41,$43,$3D
                    .db $3B,$39,$38,$4F,$17,$1B,$15,$29
                    .db $1C,$30,$2A,$32,$2C,$37,$34,$2E
                    .db $6D,$6C,$6B,$6A,$69,$64,$65,$66
                    .db $67,$68,$56,$53,$54,$5F,$57,$59
                    .db $51,$5A,$5D,$50,$5C

Empty05D665:        .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
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
                    .db $FF,$FF,$FF

DATA_05D708:        .db $00,$60,$C0,$00

DATA_05D70C:        .db $60,$90,$C0,$00

DATA_05D710:        .db $03,$01,$01,$00,$00,$02,$02,$01
                    .db $00,$00,$00,$00,$00,$00,$00,$00
DATA_05D720:        .db $02,$02,$01,$00,$01,$02,$01,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
DATA_05D730:        .db $00,$30,$60,$80,$A0,$B0,$C0,$E0
                    .db $10,$30,$50,$60,$70,$90,$00,$00
DATA_05D740:        .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $01,$01,$01,$01,$01,$01,$01,$01
DATA_05D750:        .db $10,$80,$00,$E0,$10,$70,$00,$E0
DATA_05D758:        .db $00,$00,$00,$00,$01,$01,$01,$01
DATA_05D760:        .db $05,$01,$02,$06,$08,$01

DATA_05D766:        .db $00

DATA_05D767:        .db $80

DATA_05D768:        .db $07,$1E,$80,$07,$4E,$80,$07,$9F
                    .db $80,$07,$B1,$80,$07,$90,$80,$07
DATA_05D778:        .db $18

DATA_05D779:        .db $80

DATA_05D77A:        .db $07,$00,$D9,$FF,$00,$D9,$FF,$84
                    .db $E6,$FF,$59,$DF,$FF,$EE,$E8,$FF
DATA_05D78A:        .db $03,$00,$00,$00,$00,$00

DATA_05D790:        .db $70,$70,$60,$70,$70,$70

ADDR_05D796:        .db $8B

                    PHK                       
                    PLB                       
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    STZ.W $13CF               
                    LDA.W $1B95               
                    BNE ADDR_05D7A8           
                    LDY.W $1425               
                    BEQ ADDR_05D7AB           
ADDR_05D7A8:        JSR.W ADDR_05DBAC         
ADDR_05D7AB:        LDA.W $141A               
                    BNE ADDR_05D7B3           
                    JMP.W ADDR_05D83E         
ADDR_05D7B3:        LDX $95                   
                    LDA $5B                   
                    AND.B #$01                
                    BEQ ADDR_05D7BD           
                    LDX $97                   
ADDR_05D7BD:        LDA.W $19B8,X             
                    STA.W $17BB               
                    STA $0E                   
                    LDA.W $0DD6               
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W $1F11,Y             
                    BEQ ADDR_05D7D2           
                    LDA.B #$01                
ADDR_05D7D2:        STA $0F                   
                    LDA.W $1B93               
                    BEQ ADDR_05D83B           
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.W #$0000              
                    SEP #$20                  ; Accum (8 bit) 
                    LDY $0E                   
                    LDA.W DATA_05F800,Y       
                    STA $0E                   
                    STA.W $17BB               
                    LDA.W DATA_05FA00,Y       
                    STA $00                   
                    AND.B #$0F                
                    TAX                       
                    LDA.L DATA_05D730,X       
                    STA $96                   
                    LDA.L DATA_05D740,X       
                    STA $97                   
                    LDA $00                   
                    AND.B #$30                
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.L DATA_05D708,X       
                    STA $1C                   
                    LDA $00                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.L DATA_05D70C,X       
                    STA $20                   
                    LDA.W DATA_05FC00,Y       
                    STA $01                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.L DATA_05D750,X       
                    STA $94                   
                    LDA.L DATA_05D758,X       
                    STA $95                   
                    LDA.W DATA_05FE00,Y       
                    AND.B #$07                
                    STA.W $192A               
ADDR_05D83B:        JMP.W ADDR_05D8B7         
ADDR_05D83E:        STZ $0F                   ; Index (8 bit) 
                    LDY.B #$00                
                    LDA.W $0109               
                    BNE ADDR_05D8A2           
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    STZ $1A                   
                    STZ $1E                   
                    LDX.W $0DD6               
                    LDA.W $1F1F,X             
                    AND.W #$000F              
                    STA $00                   
                    LDA.W $1F21,X             
                    AND.W #$000F              
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    STA $02                   
                    LDA.W $1F1F,X             
                    AND.W #$0010              
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ORA $00                   
                    STA $00                   
                    LDA.W $1F21,X             
                    AND.W #$0010              
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ORA $02                   
                    ORA $00                   
                    TAX                       
                    LDA.W $0DD6               
                    AND.W #$00FF              
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W $1F11,Y             
                    AND.W #$000F              
                    BEQ ADDR_05D899           
                    TXA                       
                    CLC                       
                    ADC.W #$0400              
                    TAX                       
ADDR_05D899:        SEP #$20                  ; Accum (8 bit) 
                    LDA.L $7ED000,X           
                    STA.W $13BF               
ADDR_05D8A2:        CMP.B #$25                
                    BCC ADDR_05D8A9           
                    SEC                       
                    SBC.B #$24                
ADDR_05D8A9:        STA.W $17BB               
                    STA $0E                   
                    LDA.W $1F11,Y             
                    BEQ ADDR_05D8B5           
                    LDA.B #$01                
ADDR_05D8B5:        STA $0F                   
ADDR_05D8B7:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA $0E                   
                    ASL                       
                    CLC                       
                    ADC $0E                   
                    TAY                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.W DATA_05E000,Y       
                    STA $65                   
                    LDA.W DATA_05E001,Y       
                    STA $66                   
                    LDA.W DATA_05E002,Y       
                    STA $67                   
                    LDA.W DATA_05E600,Y       
                    STA $68                   
                    LDA.W DATA_05E601,Y       
                    STA $69                   
                    LDA.W DATA_05E602,Y       
                    STA $6A                   
                    REP #$20                  ; Accum (16 bit) 
                    LDA $0E                   
                    ASL                       
                    TAY                       
                    LDA.W #$0000              
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.W DATA_05EC00,Y       
                    STA $CE                   
                    LDA.W DATA_05EC01,Y       
                    STA $CF                   
                    LDA.B #$07                
                    STA $D0                   
                    LDA [$CE]                 
                    AND.B #$3F                
                    STA.W $1692               
                    LDA [$CE]                 
                    AND.B #$C0                
                    STA.W $190E               
                    REP #$10                  ; Index (16 bit) 
                    SEP #$20                  ; Accum (8 bit) 
                    LDY $0E                   
                    LDA.W DATA_05F000,Y       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.L DATA_05D720,X       
                    STA.W $1413               
                    LDA.L DATA_05D710,X       
                    STA.W $1414               
                    LDA.B #$01                
                    STA.W $1411               
                    LDA.W DATA_05F200,Y       
                    AND.B #$C0                
                    CLC                       
                    ASL                       
                    ROL                       
                    ROL                       
                    STA.W $1BE3               
                    STZ $1D                   
                    STZ $21                   
                    LDA.W DATA_05F600,Y       
                    AND.B #$80                
                    STA.W $141F               
                    LDA.W DATA_05F600,Y       
                    AND.B #$60                
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    STA $5B                   
                    LDA.W $1B93               
                    BNE ADDR_05D9A1           
                    LDA.W DATA_05F000,Y       
                    AND.B #$0F                
                    TAX                       
                    LDA.L DATA_05D730,X       
                    STA $96                   
                    LDA.L DATA_05D740,X       
                    STA $97                   
                    LDA.W DATA_05F200,Y       
                    STA $02                   
                    AND.B #$07                
                    TAX                       
                    LDA.L DATA_05D750,X       
                    STA $94                   
                    LDA.L DATA_05D758,X       
                    STA $95                   
                    LDA $02                   
                    AND.B #$38                
                    LSR                       
                    LSR                       
                    LSR                       
                    STA.W $192A               
                    LDA.W DATA_05F400,Y       
                    STA $02                   
                    AND.B #$03                
                    TAX                       
                    LDA.L DATA_05D70C,X       
                    STA $20                   
                    LDA $02                   
                    AND.B #$0C                
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.L DATA_05D708,X       
                    STA $1C                   
                    LDA.W DATA_05F600,Y       
                    STA $01                   
ADDR_05D9A1:        LDA $5B                   
                    AND.B #$01                
                    BEQ ADDR_05D9B8           
                    LDY.W #$0000              
                    LDA [$65],Y               
                    AND.B #$1F                
                    STA $97                   
                    INC A                     
                    STA $5F                   
                    LDA.B #$01                
                    STA.W $1412               
ADDR_05D9B8:        LDA.W $141A               
                    BNE ADDR_05D9EC           
                    LDA $02                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    STA.W $13CD               
                    STZ.W $13CE               
                    LDY.W $13BF               
                    LDA.W DATA_05D608,Y       
                    STA.W $1DEA               
                    SEP #$10                  ; Index (8 bit) 
                    LDX.W $13BF               
                    LDA.W $1EA2,X             
                    AND.B #$40                
                    BEQ ADDR_05D9EC           
                    STA.W $13CF               
                    LDA $02                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    STA $95                   
                    JMP.W ADDR_05DA17         
ADDR_05D9EC:        REP #$10                  ; Index (16 bit) 
                    LDA $01                   
                    AND.B #$1F                
                    STA $01                   
                    LDA $5B                   
                    AND.B #$01                
                    BNE ADDR_05DA01           
                    LDA $01                   
                    STA $95                   
                    JMP.W ADDR_05DA17         
ADDR_05DA01:        LDA $01                   
                    STA $97                   
                    STA $1D                   
                    SEP #$10                  ; Index (8 bit) 
                    LDY.W $1414               
                    CPY.B #$03                
                    BEQ ADDR_05DA12           
                    STA $21                   
ADDR_05DA12:        LDA.B #$01                
                    STA.W $1412               
ADDR_05DA17:        SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDA.W $13BF               
                    CMP.B #$52                
                    BCC ADDR_05DA24           
                    LDX.B #$03                
                    BRA ADDR_05DA38           
ADDR_05DA24:        LDX.B #$04                
                    LDY.B #$04                
                    LDA [$65],Y               
                    AND.B #$0F                
ADDR_05DA2C:        CMP.L DATA_05D760,X       
                    BEQ ADDR_05DA38           
                    DEX                       
                    BPL ADDR_05DA2C           
ADDR_05DA35:        JMP.W ADDR_05DAD7         
ADDR_05DA38:        LDA.W $141A               
                    BNE ADDR_05DA35           
                    LDA.W $141D               
                    BNE ADDR_05DA35           
                    LDA.W $141F               
                    BNE ADDR_05DA35           
                    LDA.W $13BF               
                    CMP.B #$31                
                    BEQ ADDR_05DA5E           
                    CMP.B #$32                
                    BEQ ADDR_05DA5E           
                    CMP.B #$34                
                    BEQ ADDR_05DA5E           
                    CMP.B #$35                
                    BEQ ADDR_05DA5E           
                    CMP.B #$40                
                    BNE ADDR_05DA60           
ADDR_05DA5E:        LDX.B #$05                
ADDR_05DA60:        LDA.W $13CF               
                    BNE ADDR_05DAD0           
                    LDA.L DATA_05D790,X       
                    STA $96                   
                    LDA.B #$01                
                    STA $97                   
                    LDA.B #$30                
                    STA $94                   
                    STZ $95                   
                    LDA.B #$C0                
                    STA $1C                   
                    STA $20                   
                    STZ.W $192A               
                    LDA.B #$EE                
                    STA $CE                   
                    LDA.B #$C3                
                    STA $CF                   
                    LDA.B #$07                
                    STA $D0                   
                    LDA [$CE]                 
                    AND.B #$3F                
                    STA.W $1692               
                    LDA [$CE]                 
                    AND.B #$C0                
                    STA.W $190E               
                    STZ.W $1413               
                    STZ.W $1414               
                    STZ.W $1411               
                    STZ $5B                   
                    LDA.L DATA_05D78A,X       
                    STA.W $1BE3               
                    STX $00                   
                    TXA                       
                    ASL                       
                    CLC                       
                    ADC $00                   
                    TAY                       
                    LDA.W DATA_05D766,Y       
                    STA $65                   
                    LDA.W DATA_05D767,Y       
                    STA $66                   
                    LDA.W DATA_05D768,Y       
                    STA $67                   
                    LDA.W DATA_05D778,Y       
                    STA $68                   
                    LDA.W DATA_05D779,Y       
                    STA $69                   
                    LDA.W DATA_05D77A,Y       
                    STA $6A                   
ADDR_05DAD0:        LDA.L DATA_05D760,X       
                    STA.W $1931               
ADDR_05DAD7:        LDA.W $141A               
                    BEQ ADDR_05DAEB           
                    LDA.W $1425               
                    BNE ADDR_05DAEB           
                    LDA.W $13BF               
                    CMP.B #$24                
                    BNE ADDR_05DAEB           
                    JSR.W ADDR_05DAEF         
ADDR_05DAEB:        PLB                       
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    RTL                       ; Return 

ADDR_05DAEF:        SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDY.B #$04                
                    LDA [$65],Y               
                    AND.B #$C0                
                    CLC                       
                    ROL                       
                    ROL                       
                    ROL                       
                    JSL.L ExecutePtrLong      

PtrsLong05DAFF:     .db $3E,$DB,$05
                    .db $6E,$DB,$05
                    .db $82,$DB,$05

DATA_05DB08:        .db $24,$EC,$7E,$EC,$7E,$EC,$85,$E9
                    .db $FB,$E9,$B0,$EA,$0B,$EB,$72,$EB
                    .db $BE,$EB

DATA_05DB1A:        .db $99,$D8,$A1,$D8,$A1,$D8,$E5,$D7
                    .db $EA,$D7,$25,$D8,$4B,$D8,$6E,$D8
                    .db $88,$D8

DATA_05DB2C:        .db $59,$DF,$59,$DF,$59,$DF,$59,$DF
                    .db $59,$DF,$59,$DF,$59,$DF,$59,$DF
                    .db $59,$DF,$A2,$00

                    LDA.W $1422               
                    CMP.B #$04                
                    BEQ ADDR_05DB49           
                    LDX.B #$02                
ADDR_05DB49:        REP #$20                  ; Accum (16 bit) 
                    LDA.L DATA_05DB08,X       
                    STA $65                   
                    LDA.L DATA_05DB1A,X       
                    STA $CE                   
                    LDA.L DATA_05DB2C,X       
                    STA $68                   
                    SEP #$20                  ; Accum (8 bit) 
                    LDA [$CE]                 
                    AND.B #$7F                
                    STA.W $1692               
                    LDA [$CE]                 
                    AND.B #$80                
                    STA.W $190E               
                    RTS                       ; Return 

                    LDX.B #$0A                
                    LDA.W $0DC0               
                    CMP.B #$16                
                    BPL ADDR_05DB7F           
                    LDX.B #$08                
                    CMP.B #$0A                
                    BPL ADDR_05DB7F           
                    LDX.B #$06                
ADDR_05DB7F:        JMP.W ADDR_05DB49         
                    LDX.B #$0C                
                    LDA.W $0F31               
                    CMP.B #$02                
                    BMI ADDR_05DBA6           
                    LDA.W $0F32               
                    CMP.B #$03                
                    BMI ADDR_05DBA6           
                    BNE ADDR_05DB9B           
                    LDA.W $0F33               
                    CMP.B #$05                
                    BMI ADDR_05DBA6           
ADDR_05DB9B:        LDX.B #$0E                
                    LDA.W $0F32               
                    CMP.B #$05                
                    BMI ADDR_05DBA6           
                    LDX.B #$10                
ADDR_05DBA6:        JMP.W ADDR_05DB49         

DATA_05DBA9:        .db $00,$C8,$00

ADDR_05DBAC:        LDY.B #$00                
                    LDA.W $1B95               
                    BEQ ADDR_05DBB5           
                    LDY.B #$01                
ADDR_05DBB5:        LDX $95                   
                    LDA $5B                   
                    AND.B #$01                
                    BEQ ADDR_05DBBF           
                    LDX $97                   
ADDR_05DBBF:        LDA.W DATA_05DBA9,Y       
                    STA.W $19B8,X             
                    INC.W $141A               
                    RTS                       ; Return 


DATA_05DBC9:        .db $50,$88,$00,$03,$FE,$38,$FE,$38
                    .db $FF,$B8,$3C,$B9,$3C,$BA,$3C,$BB
                    .db $3C,$BA,$3C,$BA,$BC,$BC,$3C,$BD
                    .db $3C,$BE,$3C,$BF,$3C,$C0,$3C,$B7
                    .db $BC,$C1,$3C,$B9,$3C,$C2,$3C,$C2
                    .db $BC

ADDR_05DBF2:        PHB                       
                    PHK                       
                    PLB                       
                    LDX.B #$08                
ADDR_05DBF7:        LDA.W DATA_05DBC9,X       
                    STA.L $7F837D,X           
                    DEX                       
                    BPL ADDR_05DBF7           
                    LDX.B #$00                
                    LDA.W $0DB3               
                    BEQ ADDR_05DC0A           
                    LDX.B #$01                
ADDR_05DC0A:        LDA.W $0DB4,X             
                    INC A                     
                    JSR.W ADDR_05DC3A         
                    CPX.B #$00                
                    BEQ ADDR_05DC23           
                    CLC                       
                    ADC.B #$22                
                    STA.L $7F8383             
                    LDA.B #$39                
                    STA.L $7F8384             
                    TXA                       
ADDR_05DC23:        CLC                       
                    ADC.B #$22                
                    STA.L $7F8381             
                    LDA.B #$39                
                    STA.L $7F8382             
                    LDA.B #$08                
                    STA.L $7F837B             
                    SEP #$20                  ; Accum (8 bit) 
                    PLB                       
                    RTL                       ; Return 

ADDR_05DC3A:        LDX.B #$00                
ADDR_05DC3C:        CMP.B #$0A                
                    BCC ADDR_05DC45           
                    SBC.B #$0A                
                    INX                       
                    BRA ADDR_05DC3C           
ADDR_05DC45:        RTS                       ; Return 


Empty05DC46:        .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
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

DATA_05E000:        .db $54

DATA_05E001:        .db $86

DATA_05E002:        .db $06,$69,$BA,$06,$33,$BC,$06,$BF
                    .db $88,$06,$07,$98,$06,$61,$99,$06
                    .db $B5,$9B,$06,$C0,$9D,$06,$6E,$87
                    .db $06,$2D,$96,$06,$34,$A1,$06,$0F
                    .db $BD,$06,$00,$D0,$06,$F4,$D0,$06
                    .db $A3,$C3,$06,$AD,$BE,$06,$C4,$C1
                    .db $06,$83,$C7,$06,$00,$80,$06,$F2
                    .db $A2,$06,$8D,$86,$06,$E5,$91,$06
                    .db $E5,$91,$06,$E5,$91,$06,$14,$8C
                    .db $07,$00,$80,$06,$CC,$89,$07,$36
                    .db $EE,$06,$E3,$86,$07,$00,$81,$07
                    .db $00,$80,$06,$0A,$E2,$06,$D9,$D9
                    .db $06,$A2,$E7,$06,$44,$E4,$06,$C9
                    .db $EC,$06,$97,$E8,$06,$00,$80,$06
                    .db $00,$80,$06,$00,$80,$06,$00,$80
                    .db $06,$00,$80,$06,$00,$80,$06,$00
                    .db $80,$06,$00,$80,$06,$00,$80,$06
                    .db $00,$80,$06,$00,$80,$06,$00,$80
                    .db $06,$00,$80,$06,$00,$80,$06,$00
                    .db $80,$06,$00,$80,$06,$00,$80,$06
                    .db $00,$80,$06,$00,$80,$06,$00,$80
                    .db $06,$00,$80,$06,$00,$80,$06,$00
                    .db $80,$06,$00,$80,$06,$00,$80,$06
                    .db $00,$80,$06,$00,$80,$06,$00,$80
                    .db $06,$00,$80,$06,$00,$80,$06,$00
                    .db $80,$06,$00,$80,$06,$00,$80,$06
                    .db $00,$80,$06,$00,$80,$06,$00,$80
                    .db $06,$00,$80,$06,$00,$80,$06,$00
                    .db $80,$06,$00,$80,$06,$00,$80,$06
                    .db $00,$80,$06,$00,$80,$06,$00,$80
                    .db $06,$00,$80,$06,$00,$80,$06,$00
                    .db $80,$06,$00,$80,$06,$00,$80,$06
                    .db $00,$80,$06,$00,$80,$06,$00,$80
                    .db $06,$00,$80,$06,$00,$80,$06,$00
                    .db $80,$06,$00,$80,$06,$00,$80,$06
                    .db $00,$80,$06,$00,$80,$06,$00,$80
                    .db $06,$00,$80,$06,$00,$80,$06,$00
                    .db $80,$06,$00,$80,$06,$00,$80,$06
                    .db $00,$80,$06,$00,$80,$06,$00,$80
                    .db $06,$00,$80,$06,$00,$80,$06,$00
                    .db $80,$06,$00,$80,$06,$00,$80,$06
                    .db $00,$80,$06,$00,$80,$06,$00,$80
                    .db $06,$00,$80,$06,$00,$80,$06,$00
                    .db $80,$06,$00,$80,$06,$00,$80,$06
                    .db $00,$80,$06,$00,$80,$06,$00,$80
                    .db $06,$00,$80,$06,$00,$80,$06,$00
                    .db $80,$06,$00,$80,$06,$00,$80,$06
                    .db $00,$80,$06,$00,$80,$06,$00,$80
                    .db $06,$00,$80,$06,$00,$80,$06,$00
                    .db $80,$06,$00,$80,$06,$00,$80,$06
                    .db $00,$80,$06,$00,$80,$06,$00,$80
                    .db $06,$00,$80,$06,$00,$80,$06,$00
                    .db $80,$06,$00,$80,$06,$00,$80,$06
                    .db $00,$80,$06,$00,$80,$06,$00,$80
                    .db $06,$00,$80,$06,$00,$80,$06,$61
                    .db $85,$06,$8B,$85,$06,$58,$82,$06
                    .db $5E,$82,$06,$5E,$82,$06,$58,$82
                    .db $06,$58,$82,$06,$58,$82,$06,$52
                    .db $82,$06,$00,$80,$06,$00,$80,$06
                    .db $00,$80,$06,$00,$80,$06,$00,$80
                    .db $06,$00,$80,$06,$00,$80,$06,$00
                    .db $80,$06,$00,$80,$06,$00,$80,$06
                    .db $00,$80,$06,$00,$80,$06,$00,$80
                    .db $06,$00,$80,$06,$00,$80,$06,$00
                    .db $80,$06,$00,$80,$06,$00,$80,$06
                    .db $00,$80,$06,$00,$80,$06,$00,$80
                    .db $06,$00,$80,$06,$00,$80,$06,$00
                    .db $80,$06,$00,$80,$06,$00,$80,$06
                    .db $00,$80,$06,$00,$80,$06,$00,$80
                    .db $06,$00,$80,$06,$00,$80,$06,$00
                    .db $80,$06,$00,$80,$06,$35,$89,$07
                    .db $6E,$E7,$06,$99,$C1,$06,$CB,$88
                    .db $07,$75,$C3,$06,$70,$A2,$06,$83
                    .db $9D,$06,$4F,$99,$06,$03,$86,$06
                    .db $49,$C9,$06,$B5,$85,$06,$7C,$97
                    .db $07,$7D,$88,$06,$AE,$87,$06,$EE
                    .db $BC,$06,$36,$86,$06,$24,$EC,$06
                    .db $0B,$EB,$06,$85,$E9,$06,$44,$E4
                    .db $06,$44,$E4,$06,$4C,$9D,$06,$EA
                    .db $8B,$07,$4A,$8B,$07,$36,$86,$06
                    .db $07,$E3,$06,$E7,$ED,$06,$C9,$BB
                    .db $06,$36,$86,$06,$EC,$C6,$06,$59
                    .db $C5,$06,$95,$C4,$06,$D6,$D1,$06
                    .db $9D,$98,$06,$36,$86,$06,$B6,$BD
                    .db $06,$B6,$BD,$06,$36,$86,$06,$73
                    .db $94,$06,$4F,$A4,$06,$36,$86,$06
                    .db $9D,$A0,$06,$64,$9F,$06,$2E,$9E
                    .db $06,$8E,$97,$06,$B4,$85,$07,$21
                    .db $86,$06,$F2,$A2,$06,$74,$A3,$06
                    .db $F2,$A2,$06,$FD,$EE,$06,$21,$86
                    .db $06,$20,$A4,$06,$74,$A3,$06,$DC
                    .db $D0,$06,$1E,$9B,$06,$D0,$E5,$06
                    .db $D0,$E5,$06,$AB,$8D,$07,$C6,$8C
                    .db $07,$9D,$98,$06,$7B,$98,$06,$21
                    .db $86,$06,$15,$E8,$06,$DC,$93,$06
                    .db $F0,$98,$06,$3C,$86,$06,$54,$86
                    .db $06,$FD,$8F,$06,$AD,$8E,$06,$DE
                    .db $8B,$06,$2D,$80,$07,$DD,$88,$06
                    .db $2F,$8A,$06,$09,$AD,$06,$C3,$80
                    .db $07,$17,$B8,$06,$7D,$AE,$06,$61
                    .db $A4,$06,$00,$80,$06,$00,$A6,$07
                    .db $F9,$AB,$07,$58,$9B,$07,$E2,$9D
                    .db $07,$28,$A0,$07,$00,$80,$06,$D6
                    .db $99,$07,$03,$98,$07,$CA,$92,$07
                    .db $A4,$8E,$07,$5D,$F0,$06,$5F,$A9
                    .db $06,$D1,$B2,$06,$00,$A6,$06,$D0
                    .db $86,$06,$E0,$B4,$06,$BE,$DA,$06
                    .db $3A,$D2,$06,$5B,$DF,$06,$0B,$D4
                    .db $06,$2B,$87,$06,$83,$E1,$06,$F3
                    .db $D6,$06,$00,$80,$06,$65,$BF,$07
                    .db $E5,$BD,$07,$11,$BC,$07,$BE,$BA
                    .db $07,$00,$80,$06,$6B,$B2,$07,$6E
                    .db $B4,$07,$40,$B5,$07,$08,$B9,$07
                    .db $00,$80,$06,$00,$80,$06,$25,$AF
                    .db $07,$00,$80,$06,$E3,$AF,$07,$00
                    .db $80,$06,$35,$AD,$07,$31,$B0,$07
                    .db $24,$B1,$07,$00,$80,$06,$00,$80
                    .db $06,$00,$80,$06,$00,$80,$06,$00
                    .db $80,$06,$00,$80,$06,$00,$80,$06
                    .db $00,$80,$06,$00,$80,$06,$00,$80
                    .db $06,$00,$80,$06,$00,$80,$06,$00
                    .db $80,$06,$00,$80,$06,$00,$80,$06
                    .db $00,$80,$06,$00,$80,$06,$00,$80
                    .db $06,$00,$80,$06,$00,$80,$06,$00
                    .db $80,$06,$00,$80,$06,$00,$80,$06
                    .db $00,$80,$06,$00,$80,$06,$00,$80
                    .db $06,$00,$80,$06,$00,$80,$06,$00
                    .db $80,$06,$00,$80,$06,$00,$80,$06
                    .db $00,$80,$06,$00,$80,$06,$00,$80
                    .db $06,$00,$80,$06,$00,$80,$06,$00
                    .db $80,$06,$00,$80,$06,$00,$80,$06
                    .db $00,$80,$06,$00,$80,$06,$00,$80
                    .db $06,$00,$80,$06,$00,$80,$06,$00
                    .db $80,$06,$00,$80,$06,$00,$80,$06
                    .db $00,$80,$06,$00,$80,$06,$00,$80
                    .db $06,$00,$80,$06,$00,$80,$06,$00
                    .db $80,$06,$00,$80,$06,$00,$80,$06
                    .db $00,$80,$06,$00,$80,$06,$00,$80
                    .db $06,$00,$80,$06,$00,$80,$06,$00
                    .db $80,$06,$00,$80,$06,$00,$80,$06
                    .db $00,$80,$06,$00,$80,$06,$00,$80
                    .db $06,$00,$80,$06,$00,$80,$06,$00
                    .db $80,$06,$00,$80,$06,$00,$80,$06
                    .db $00,$80,$06,$00,$80,$06,$00,$80
                    .db $06,$00,$80,$06,$00,$80,$06,$00
                    .db $80,$06,$00,$80,$06,$00,$80,$06
                    .db $00,$80,$06,$00,$80,$06,$00,$80
                    .db $06,$00,$80,$06,$00,$80,$06,$00
                    .db $80,$06,$00,$80,$06,$00,$80,$06
                    .db $00,$80,$06,$00,$80,$06,$00,$80
                    .db $06,$00,$80,$06,$00,$80,$06,$8B
                    .db $85,$06,$61,$85,$06,$58,$82,$06
                    .db $5E,$82,$06,$5E,$82,$06,$58,$82
                    .db $06,$58,$82,$06,$58,$82,$06,$52
                    .db $82,$06,$00,$80,$06,$00,$80,$06
                    .db $00,$80,$06,$00,$80,$06,$00,$80
                    .db $06,$00,$80,$06,$00,$80,$06,$00
                    .db $80,$06,$00,$80,$06,$00,$80,$06
                    .db $00,$80,$06,$00,$80,$06,$00,$80
                    .db $06,$00,$80,$06,$00,$80,$06,$00
                    .db $80,$06,$00,$80,$06,$00,$80,$06
                    .db $00,$80,$06,$00,$80,$06,$00,$80
                    .db $06,$00,$80,$06,$00,$80,$06,$00
                    .db $80,$06,$00,$80,$06,$00,$80,$06
                    .db $00,$80,$06,$00,$80,$06,$00,$80
                    .db $06,$00,$80,$06,$00,$80,$06,$C1
                    .db $9A,$07,$42,$D9,$06,$C9,$AA,$07
                    .db $B1,$8F,$06,$84,$9D,$07,$11,$F5
                    .db $06,$28,$E1,$06,$B5,$B1,$06,$A8
                    .db $AC,$06,$C6,$B3,$07,$C6,$B3,$07
                    .db $6D,$A5,$06,$2F,$AD,$07,$96,$B8
                    .db $07,$7D,$B8,$07,$B3,$8B,$06,$F8
                    .db $89,$06,$77,$AA,$07,$16,$AA,$07
                    .db $61,$A9,$07,$D9,$A8,$07,$3F,$A8
                    .db $07,$02,$A8,$07,$65,$A7,$07,$07
                    .db $A7,$07,$8E,$A6,$07,$CE,$AF,$07
                    .db $16,$AF,$07,$38,$88,$06,$F3,$87
                    .db $06,$03,$98,$07,$21,$86,$06,$69
                    .db $99,$07,$69,$99,$07,$67,$98,$07
                    .db $36,$86,$06,$04,$E1,$06,$8A,$BD
                    .db $07,$75,$BD,$07,$F0,$95,$07,$E2
                    .db $93,$07,$33,$92,$07,$21,$92,$07
                    .db $46,$DF,$06,$21,$86,$06,$BE,$DA
                    .db $06,$BE,$DA,$06,$18,$AE,$06,$87
                    .db $86,$06,$5D,$F3,$06,$64,$F1,$06
                    .db $FC,$F4,$06,$E9,$A8,$06,$33,$BA
                    .db $06,$06,$BA,$06,$ED,$B7,$06,$66
                    .db $B6,$06,$20,$B6,$06,$22,$B4,$06
                    .db $87,$86,$06,$3A,$B2,$06,$14,$D9
                    .db $06,$21,$86,$06,$D2,$DE,$06,$09
                    .db $AD,$06,$6F,$91,$06,$6D,$8E,$06
                    .db $22,$9F,$07,$93,$8F,$06

DATA_05E600:        .db $74

DATA_05E601:        .db $E6

DATA_05E602:        .db $FF,$44,$DD,$FF,$44,$DD,$FF,$82
                    .db $EC,$FF,$80,$EF,$FF,$82,$EC,$FF
                    .db $54,$DE,$FF,$5A,$F4,$FF,$74,$E6
                    .db $FF,$6D,$95,$06,$B9,$DA,$FF,$5A
                    .db $F4,$FF,$44,$DD,$FF,$44,$DD,$FF
                    .db $6E,$C4,$06,$44,$DD,$FF,$44,$DD
                    .db $FF,$B9,$DA,$FF,$54,$DE,$FF,$80
                    .db $EF,$FF,$74,$E6,$FF,$54,$DE,$FF
                    .db $54,$DE,$FF,$00,$D9,$FF,$B9,$DA
                    .db $FF,$00,$D9,$FF,$1D,$8B,$07,$5A
                    .db $F4,$FF,$C0,$E7,$FF,$FE,$E8,$FF
                    .db $00,$D9,$FF,$03,$E1,$FF,$5A,$F4
                    .db $FF,$80,$EF,$FF,$54,$DE,$FF,$C0
                    .db $E7,$FF,$59,$DF,$FF,$00,$D9,$FF
                    .db $00,$D9,$FF,$00,$D9,$FF,$00,$D9
                    .db $FF,$00,$D9,$FF,$00,$D9,$FF,$00
                    .db $D9,$FF,$00,$D9,$FF,$00,$D9,$FF
                    .db $00,$D9,$FF,$00,$D9,$FF,$00,$D9
                    .db $FF,$00,$D9,$FF,$00,$D9,$FF,$00
                    .db $D9,$FF,$00,$D9,$FF,$00,$D9,$FF
                    .db $00,$D9,$FF,$00,$D9,$FF,$00,$D9
                    .db $FF,$00,$D9,$FF,$00,$D9,$FF,$00
                    .db $D9,$FF,$00,$D9,$FF,$00,$D9,$FF
                    .db $00,$D9,$FF,$00,$D9,$FF,$00,$D9
                    .db $FF,$00,$D9,$FF,$00,$D9,$FF,$00
                    .db $D9,$FF,$00,$D9,$FF,$00,$D9,$FF
                    .db $00,$D9,$FF,$00,$D9,$FF,$00,$D9
                    .db $FF,$00,$D9,$FF,$00,$D9,$FF,$00
                    .db $D9,$FF,$00,$D9,$FF,$00,$D9,$FF
                    .db $00,$D9,$FF,$00,$D9,$FF,$00,$D9
                    .db $FF,$00,$D9,$FF,$00,$D9,$FF,$00
                    .db $D9,$FF,$00,$D9,$FF,$00,$D9,$FF
                    .db $00,$D9,$FF,$00,$D9,$FF,$00,$D9
                    .db $FF,$00,$D9,$FF,$00,$D9,$FF,$00
                    .db $D9,$FF,$00,$D9,$FF,$00,$D9,$FF
                    .db $00,$D9,$FF,$00,$D9,$FF,$00,$D9
                    .db $FF,$00,$D9,$FF,$00,$D9,$FF,$00
                    .db $D9,$FF,$00,$D9,$FF,$00,$D9,$FF
                    .db $00,$D9,$FF,$00,$D9,$FF,$00,$D9
                    .db $FF,$00,$D9,$FF,$00,$D9,$FF,$00
                    .db $D9,$FF,$00,$D9,$FF,$00,$D9,$FF
                    .db $00,$D9,$FF,$00,$D9,$FF,$00,$D9
                    .db $FF,$00,$D9,$FF,$00,$D9,$FF,$00
                    .db $D9,$FF,$00,$D9,$FF,$00,$D9,$FF
                    .db $00,$D9,$FF,$00,$D9,$FF,$00,$D9
                    .db $FF,$00,$D9,$FF,$00,$D9,$FF,$00
                    .db $D9,$FF,$00,$D9,$FF,$00,$D9,$FF
                    .db $00,$D9,$FF,$00,$D9,$FF,$00,$D9
                    .db $FF,$00,$D9,$FF,$00,$D9,$FF,$00
                    .db $D9,$FF,$00,$D9,$FF,$00,$D9,$FF
                    .db $00,$D9,$FF,$00,$D9,$FF,$00,$D9
                    .db $FF,$00,$D9,$FF,$00,$D9,$FF,$00
                    .db $D9,$FF,$00,$D9,$FF,$00,$D9,$FF
                    .db $00,$D9,$FF,$00,$D9,$FF,$00,$D9
                    .db $FF,$00,$D9,$FF,$00,$D9,$FF,$5A
                    .db $F4,$FF,$5A,$F4,$FF,$5A,$F4,$FF
                    .db $5A,$F4,$FF,$5A,$F4,$FF,$5A,$F4
                    .db $FF,$5A,$F4,$FF,$5A,$F4,$FF,$5A
                    .db $F4,$FF,$00,$D9,$FF,$00,$D9,$FF
                    .db $00,$D9,$FF,$00,$D9,$FF,$00,$D9
                    .db $FF,$00,$D9,$FF,$00,$D9,$FF,$00
                    .db $D9,$FF,$00,$D9,$FF,$00,$D9,$FF
                    .db $00,$D9,$FF,$00,$D9,$FF,$00,$D9
                    .db $FF,$00,$D9,$FF,$00,$D9,$FF,$00
                    .db $D9,$FF,$00,$D9,$FF,$00,$D9,$FF
                    .db $00,$D9,$FF,$00,$D9,$FF,$00,$D9
                    .db $FF,$00,$D9,$FF,$00,$D9,$FF,$00
                    .db $D9,$FF,$00,$D9,$FF,$00,$D9,$FF
                    .db $00,$D9,$FF,$00,$D9,$FF,$00,$D9
                    .db $FF,$00,$D9,$FF,$00,$D9,$FF,$00
                    .db $D9,$FF,$00,$D9,$FF,$74,$E6,$FF
                    .db $59,$DF,$FF,$44,$DD,$FF,$59,$DF
                    .db $FF,$59,$DF,$FF,$FE,$E8,$FF,$54
                    .db $DE,$FF,$1B,$86,$06,$00,$D9,$FF
                    .db $72,$E4,$FF,$59,$DF,$FF,$84,$E6
                    .db $FF,$74,$E6,$FF,$74,$E6,$FF,$44
                    .db $DD,$FF,$5A,$F4,$FF,$59,$DF,$FF
                    .db $59,$DF,$FF,$59,$DF,$FF,$54,$DE
                    .db $FF,$54,$DE,$FF,$FE,$E8,$FF,$5A
                    .db $F4,$FF,$B7,$8B,$07,$5A,$F4,$FF
                    .db $5A,$F4,$FF,$44,$DD,$FF,$FE,$E8
                    .db $FF,$5A,$F4,$FF,$74,$E6,$FF,$5A
                    .db $F4,$FF,$14,$C5,$06,$44,$DD,$FF
                    .db $80,$EF,$FF,$00,$D9,$FF,$5A,$F4
                    .db $FF,$5A,$F4,$FF,$5A,$F4,$FF,$54
                    .db $DE,$FF,$80,$EF,$FF,$5A,$F4,$FF
                    .db $74,$E6,$FF,$BF,$9E,$06,$5A,$F4
                    .db $FF,$FE,$E8,$FF,$FE,$E8,$FF,$1B
                    .db $86,$06,$80,$EF,$FF,$80,$EF,$FF
                    .db $80,$EF,$FF,$5A,$F4,$FF,$1B,$86
                    .db $06,$80,$EF,$FF,$80,$EF,$FF,$44
                    .db $DD,$FF,$74,$E6,$FF,$54,$DE,$FF
                    .db $54,$DE,$FF,$EE,$E8,$FF,$75,$F1
                    .db $FF,$80,$EF,$FF,$80,$EF,$FF,$1B
                    .db $86,$06,$80,$EF,$FF,$74,$E6,$FF
                    .db $80,$EF,$FF,$54,$DE,$FF,$74,$E6
                    .db $FF,$03,$E1,$FF,$59,$DF,$FF,$59
                    .db $DF,$FF,$00,$D9,$FF,$00,$D9,$FF
                    .db $82,$EC,$FF,$80,$EF,$FF,$C0,$E7
                    .db $FF,$FE,$E8,$FF,$FE,$E8,$FF,$FE
                    .db $E8,$FF,$00,$D9,$FF,$03,$E1,$FF
                    .db $5A,$F4,$FF,$FE,$E8,$FF,$5A,$F4
                    .db $FF,$34,$A1,$07,$00,$D9,$FF,$FE
                    .db $E8,$FF,$80,$EF,$FF,$7C,$93,$07
                    .db $FE,$E8,$FF,$FE,$E8,$FF,$FE,$E8
                    .db $FF,$84,$E6,$FF,$FE,$E8,$FF,$74
                    .db $E6,$FF,$5A,$F4,$FF,$8D,$DB,$06
                    .db $82,$EC,$FF,$82,$EC,$FF,$B9,$DA
                    .db $FF,$74,$E6,$FF,$82,$EC,$FF,$82
                    .db $EC,$FF,$00,$D9,$FF,$71,$DC,$FF
                    .db $82,$EC,$FF,$C0,$E7,$FF,$59,$DF
                    .db $FF,$00,$D9,$FF,$44,$DD,$FF,$72
                    .db $E4,$FF,$00,$D9,$FF,$59,$DF,$FF
                    .db $00,$D9,$FF,$00,$D9,$FF,$B9,$DA
                    .db $FF,$00,$D9,$FF,$84,$E6,$FF,$00
                    .db $D9,$FF,$FE,$E8,$FF,$84,$E6,$FF
                    .db $84,$E6,$FF,$00,$D9,$FF,$00,$D9
                    .db $FF,$00,$D9,$FF,$00,$D9,$FF,$00
                    .db $D9,$FF,$00,$D9,$FF,$00,$D9,$FF
                    .db $00,$D9,$FF,$00,$D9,$FF,$00,$D9
                    .db $FF,$00,$D9,$FF,$00,$D9,$FF,$00
                    .db $D9,$FF,$00,$D9,$FF,$00,$D9,$FF
                    .db $00,$D9,$FF,$00,$D9,$FF,$00,$D9
                    .db $FF,$00,$D9,$FF,$00,$D9,$FF,$00
                    .db $D9,$FF,$00,$D9,$FF,$00,$D9,$FF
                    .db $00,$D9,$FF,$00,$D9,$FF,$00,$D9
                    .db $FF,$00,$D9,$FF,$00,$D9,$FF,$00
                    .db $D9,$FF,$00,$D9,$FF,$00,$D9,$FF
                    .db $00,$D9,$FF,$00,$D9,$FF,$00,$D9
                    .db $FF,$00,$D9,$FF,$00,$D9,$FF,$00
                    .db $D9,$FF,$00,$D9,$FF,$00,$D9,$FF
                    .db $00,$D9,$FF,$00,$D9,$FF,$00,$D9
                    .db $FF,$00,$D9,$FF,$00,$D9,$FF,$00
                    .db $D9,$FF,$00,$D9,$FF,$00,$D9,$FF
                    .db $00,$D9,$FF,$00,$D9,$FF,$00,$D9
                    .db $FF,$00,$D9,$FF,$00,$D9,$FF,$00
                    .db $D9,$FF,$00,$D9,$FF,$00,$D9,$FF
                    .db $00,$D9,$FF,$00,$D9,$FF,$00,$D9
                    .db $FF,$00,$D9,$FF,$00,$D9,$FF,$00
                    .db $D9,$FF,$00,$D9,$FF,$00,$D9,$FF
                    .db $00,$D9,$FF,$00,$D9,$FF,$00,$D9
                    .db $FF,$00,$D9,$FF,$00,$D9,$FF,$00
                    .db $D9,$FF,$00,$D9,$FF,$00,$D9,$FF
                    .db $00,$D9,$FF,$00,$D9,$FF,$00,$D9
                    .db $FF,$00,$D9,$FF,$00,$D9,$FF,$00
                    .db $D9,$FF,$00,$D9,$FF,$00,$D9,$FF
                    .db $00,$D9,$FF,$00,$D9,$FF,$00,$D9
                    .db $FF,$00,$D9,$FF,$00,$D9,$FF,$00
                    .db $D9,$FF,$00,$D9,$FF,$00,$D9,$FF
                    .db $00,$D9,$FF,$00,$D9,$FF,$00,$D9
                    .db $FF,$00,$D9,$FF,$00,$D9,$FF,$5A
                    .db $F4,$FF,$5A,$F4,$FF,$5A,$F4,$FF
                    .db $5A,$F4,$FF,$5A,$F4,$FF,$5A,$F4
                    .db $FF,$5A,$F4,$FF,$5A,$F4,$FF,$5A
                    .db $F4,$FF,$00,$D9,$FF,$00,$D9,$FF
                    .db $00,$D9,$FF,$00,$D9,$FF,$00,$D9
                    .db $FF,$00,$D9,$FF,$00,$D9,$FF,$00
                    .db $D9,$FF,$00,$D9,$FF,$00,$D9,$FF
                    .db $00,$D9,$FF,$00,$D9,$FF,$00,$D9
                    .db $FF,$00,$D9,$FF,$00,$D9,$FF,$00
                    .db $D9,$FF,$00,$D9,$FF,$00,$D9,$FF
                    .db $00,$D9,$FF,$00,$D9,$FF,$00,$D9
                    .db $FF,$00,$D9,$FF,$00,$D9,$FF,$00
                    .db $D9,$FF,$00,$D9,$FF,$00,$D9,$FF
                    .db $00,$D9,$FF,$00,$D9,$FF,$00,$D9
                    .db $FF,$00,$D9,$FF,$00,$D9,$FF,$74
                    .db $E6,$FF,$74,$E6,$FF,$5A,$F4,$FF
                    .db $59,$DF,$FF,$FE,$E8,$FF,$59,$DF
                    .db $FF,$B9,$DA,$FF,$FE,$E8,$FF,$FE
                    .db $E8,$FF,$44,$DD,$FF,$44,$DD,$FF
                    .db $00,$D9,$FF,$5A,$F4,$FF,$44,$DD
                    .db $FF,$44,$DD,$FF,$FE,$E8,$FF,$FE
                    .db $E8,$FF,$5A,$F4,$FF,$03,$E1,$FF
                    .db $E3,$A9,$07,$34,$A9,$07,$03,$E1
                    .db $FF,$5A,$F4,$FF,$5A,$F4,$FF,$5A
                    .db $F4,$FF,$03,$E1,$FF,$44,$DD,$FF
                    .db $44,$DD,$FF,$74,$E6,$FF,$74,$E6
                    .db $FF,$80,$EF,$FF,$1B,$86,$06,$80
                    .db $EF,$FF,$80,$EF,$FF,$80,$EF,$FF
                    .db $5A,$F4,$FF,$FE,$E8,$FF,$44,$DD
                    .db $FF,$C0,$E7,$FF,$5E,$97,$07,$A5
                    .db $95,$07,$74,$E6,$FF,$FE,$E8,$FF
                    .db $1B,$86,$06,$1B,$86,$06,$8D,$DB
                    .db $06,$8D,$DB,$06,$80,$EF,$FF,$5A
                    .db $F4,$FF,$2A,$F4,$06,$FE,$E8,$FF
                    .db $FE,$E8,$FF,$3E,$A9,$06,$FE,$E8
                    .db $FF,$FE,$E8,$FF,$5A,$F4,$FF,$4B
                    .db $B7,$06,$5A,$F4,$FF,$FE,$E8,$FF
                    .db $5A,$F4,$FF,$74,$E6,$FF,$FE,$E8
                    .db $FF,$1B,$86,$06,$80,$EF,$FF,$80
                    .db $EF,$FF,$03,$E1,$FF,$FE,$E8,$FF
                    .db $5A,$F4,$FF,$59,$DF,$FF

DATA_05EC00:        .db $07

DATA_05EC01:        .db $C4,$1C,$CE,$BF,$CE,$C5,$C4,$B5
                    .db $C7,$D9,$C7,$44,$C8,$04,$C9,$9D
                    .db $C4,$51,$C7,$48,$C9,$06,$CF,$F5
                    .db $D1,$5A,$D2,$D7,$D0,$AF,$CF,$43
                    .db $D0,$57,$D1,$6D,$E7,$CA,$C9,$46
                    .db $C4,$D5,$C6,$D5,$C6,$D5,$C6,$2D
                    .db $DC,$6D,$E7,$BB,$DB,$5E,$D9,$0F
                    .db $DB,$93,$DA,$6D,$E7,$48,$D6,$CD
                    .db $D4,$4C,$D7,$D9,$D6,$BE,$D8,$BF
                    .db $D7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$DB,$C3,$E3
                    .db $C3,$67,$C3,$59,$C3,$54,$C3,$4F
                    .db $C3,$4A,$C3,$45,$C3,$40,$C3,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$EE,$C3,$41,$D7,$2F,$D0,$95
                    .db $DB,$CF,$D0,$AA,$C9,$EA,$C8,$F5
                    .db $C3,$41,$C4,$F0,$C3,$27,$C4,$CF
                    .db $DD,$C0,$C4,$4B,$C4,$F0,$C3,$1D
                    .db $D5,$99,$D8,$4B,$D8,$E5,$D7,$D9
                    .db $D6,$D9,$D6,$CD,$C8,$22,$DC,$F9
                    .db $DB,$14,$C4,$68,$D6,$56,$D9,$BA
                    .db $CE,$52,$D1,$EE,$C3,$11,$D1,$F4
                    .db $D0,$04,$D3,$BD,$C7,$14,$C4,$4D
                    .db $CF,$4D,$CF,$14,$C4,$49,$C7,$0C
                    .db $CA,$43,$C9,$EE,$C3,$26,$C9,$15
                    .db $C9,$A7,$C7,$DD,$DA,$0C,$C4,$CA
                    .db $C9,$DB,$C9,$CA,$C9,$B1,$D9,$F5
                    .db $C3,$F2,$C9,$DB,$C9,$F0,$C3,$EE
                    .db $C3,$D9,$D6,$D9,$D6,$61,$DC,$3B
                    .db $DC,$BD,$C7,$EE,$C3,$F5,$C3,$99
                    .db $D7,$EE,$C3,$CB,$C7,$F0,$C3,$07
                    .db $C4,$6F,$C6,$F4,$C5,$93,$C5,$59
                    .db $E7,$CA,$C4,$32,$C5,$DC,$CB,$6D
                    .db $E7,$C8,$CD,$25,$CC,$17,$CA,$6D
                    .db $E7,$22,$C4,$9D,$E1,$08,$DF,$B1
                    .db $DF,$32,$E0,$6D,$E7,$4F,$DE,$01
                    .db $DE,$7B,$DD,$14,$DD,$EF,$D9,$2A
                    .db $CB,$D4,$CC,$87,$CA,$50,$C4,$68
                    .db $CD,$22,$D5,$0C,$D3,$77,$D5,$80
                    .db $D3,$78,$C4,$F5,$D5,$45,$D4,$6D
                    .db $E7,$F4,$E6,$50,$E6,$DF,$E5,$74
                    .db $E5,$6D,$E7,$DC,$E3,$28,$E4,$66
                    .db $E4,$F1,$E4,$6D,$E7,$6D,$E7,$21
                    .db $E2,$6D,$E7,$9E,$E2,$6D,$E7,$C5
                    .db $E1,$AF,$E2,$35,$E3,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$E3,$C3,$DB
                    .db $C3,$67,$C3,$59,$C3,$54,$C3,$4F
                    .db $C3,$4A,$C3,$45,$C3,$40,$C3,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$6D,$E7,$6D
                    .db $E7,$6D,$E7,$6D,$E7,$EE,$C3,$EE
                    .db $C3,$9D,$E1,$61,$C6,$94,$DF,$7F
                    .db $DA,$CF,$D5,$BA,$CC,$C5,$CB,$02
                    .db $E4,$02,$E4,$6D,$CA,$C0,$E1,$EC
                    .db $E4,$EE,$C3,$7F,$C5,$EE,$C3,$83
                    .db $E1,$60,$E1,$31,$E1,$14,$E1,$22
                    .db $C4,$E8,$E0,$C5,$E0,$8D,$E0,$67
                    .db $E0,$F0,$C3,$F0,$C3,$98,$C4,$73
                    .db $C4,$01,$DE,$F5,$C3,$3B,$DE,$3B
                    .db $DE,$0F,$DE,$14,$C4,$C7,$D5,$EE
                    .db $C3,$F0,$C3,$B8,$DD,$B3,$DD,$EE
                    .db $C3,$76,$DD,$F5,$C3,$0C,$C4,$22
                    .db $D5,$22,$D5,$11,$CC,$24,$E0,$44
                    .db $DA,$12,$DA,$F0,$C3,$01,$CB,$14
                    .db $CE,$0C,$CE,$C0,$CD,$94,$CD,$EE
                    .db $C3,$63,$CD,$D0,$C6,$EE,$C3,$C5
                    .db $D4,$F5,$C3,$6C,$D5,$DC,$CB,$BF
                    .db $C6,$EF,$C5,$E0,$DF,$59,$C6

DATA_05F000:        .db $07,$5B,$19,$2B,$1B,$5B,$5B,$5B
                    .db $27,$37,$18,$19,$59,$5B,$29,$1B
                    .db $5B,$58,$05,$5B,$2B,$5B,$1B,$1B
                    .db $51,$0B,$4B,$1B,$07,$52,$0B,$1B
                    .db $57,$1B,$5B,$5B,$5B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$57,$57,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$0B,$0B,$6C,$18,$19
                    .db $1A,$51,$0D,$1A,$2B,$5B,$1B,$5A
                    .db $6B,$2B,$2B,$18,$0B,$1B,$1B,$5B
                    .db $59,$58,$19,$57,$49,$0B,$5B,$52
                    .db $19,$0B,$6C,$0C,$48,$18,$5A,$0B
                    .db $59,$59,$0B,$5A,$2A,$0B,$6C,$7D
                    .db $5B,$5A,$00,$2B,$5B,$5B,$5B,$17
                    .db $2B,$5B,$58,$18,$6C,$59,$58,$01
                    .db $17,$5B,$1B,$2B,$1B,$6C,$5A,$2A
                    .db $07,$1B,$18,$5B,$0B,$5B,$5B,$5B
                    .db $0B,$0D,$58,$5B,$0B,$1A,$1B,$58
                    .db $5B,$48,$0B,$1B,$0A,$4B,$5B,$57
                    .db $52,$17,$57,$2B,$17,$29,$1C,$5B
                    .db $59,$2B,$56,$1C,$0B,$5B,$1C,$1B
                    .db $1A,$0B,$05,$58,$5B,$19,$0B,$0B
                    .db $58,$0B,$5B,$0B,$01,$5B,$5B,$0B
                    .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$57,$57,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$6C,$6C,$1B,$5A,$16
                    .db $1A,$19,$16,$16,$58,$5C,$1A,$0B
                    .db $5D,$19,$19,$19,$1B,$1B,$73,$4B
                    .db $1A,$59,$59,$1B,$1B,$1B,$1B,$2B
                    .db $2B,$09,$2B,$0B,$0B,$09,$0B,$29
                    .db $52,$1B,$48,$4B,$6C,$5B,$2B,$2B
                    .db $2B,$29,$5B,$0B,$4B,$01,$5B,$49
                    .db $1B,$1B,$57,$48,$1B,$19,$0B,$6C
                    .db $28,$2B,$1B,$5A,$1B,$19,$19,$1B
DATA_05F200:        .db $20,$00,$80,$01,$00,$01,$00,$00
                    .db $00,$C0,$38,$39,$00,$00,$00,$00
                    .db $00,$F8,$00,$00,$00,$00,$00,$00
                    .db $F8,$00,$C0,$00,$00,$01,$00,$80
                    .db $01,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$01,$01,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$10,$A0,$20
                    .db $18,$A0,$18,$18,$00,$01,$18,$00
                    .db $01,$10,$10,$10,$00,$10,$10,$10
                    .db $31,$30,$20,$01,$C0,$00,$00,$18
                    .db $20,$00,$10,$01,$C1,$20,$01,$00
                    .db $39,$39,$00,$18,$00,$00,$10,$C0
                    .db $01,$18,$01,$00,$00,$03,$03,$00
                    .db $00,$01,$00,$10,$10,$31,$30,$20
                    .db $38,$00,$00,$00,$00,$10,$01,$18
                    .db $20,$00,$80,$00,$01,$00,$00,$00
                    .db $00,$01,$00,$28,$00,$00,$00,$00
                    .db $01,$C0,$00,$00,$00,$C0,$00,$00
                    .db $01,$00,$00,$00,$01,$00,$00,$00
                    .db $38,$00,$00,$00,$00,$00,$00,$40
                    .db $00,$00,$01,$01,$00,$28,$00,$00
                    .db $F8,$00,$00,$00,$01,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$01,$01,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$10,$10,$00,$18,$28
                    .db $18,$F8,$28,$28,$1B,$19,$18,$00
                    .db $00,$20,$20,$20,$00,$00,$F8,$C0
                    .db $00,$00,$00,$00,$80,$18,$10,$10
                    .db $10,$03,$00,$03,$00,$01,$00,$20
                    .db $18,$10,$D1,$D1,$10,$18,$00,$00
                    .db $01,$01,$01,$00,$D1,$10,$10,$D0
                    .db $09,$11,$01,$C0,$00,$20,$00,$10
                    .db $20,$00,$01,$01,$80,$20,$00,$10
DATA_05F400:        .db $0A,$9A,$8A,$0A,$0A,$AA,$AA,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$9A,$0A,$9A
                    .db $9A,$0A,$02,$0A,$0A,$9A,$9A,$9A
                    .db $03,$0A,$BA,$8A,$BA,$00,$0A,$0A
                    .db $0A,$0A,$9A,$9A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$00,$00,$00
                    .db $00,$00,$00,$00,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$09,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$00,$0A,$0A,$0A
                    .db $9A,$9A,$0A,$0A,$0B,$00,$0A,$03
                    .db $0A,$00,$0A,$0A,$0A,$0A,$0A,$00
                    .db $0A,$0A,$00,$0A,$0A,$00,$0A,$03
                    .db $0A,$0A,$00,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$03
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$7A,$0A,$9A,$0A,$9A,$9A,$0A
                    .db $0A,$02,$FA,$0A,$0A,$0A,$6A,$9A
                    .db $7A,$0A,$0A,$8A,$0A,$7A,$9A,$7A
                    .db $A0,$9A,$FA,$0A,$9A,$0A,$9A,$9A
                    .db $0A,$0A,$05,$9A,$0A,$0A,$9A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$03,$9A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$00,$00,$00
                    .db $00,$00,$00,$00,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$00
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$03,$0A
                    .db $0A,$09,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$00,$0A
                    .db $03,$0A,$0B,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$00,$0A,$03,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$00,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
DATA_05F600:        .db $00,$00,$80,$00,$00,$80,$00,$00
                    .db $00,$00,$00,$00,$80,$80,$00,$80
                    .db $00,$00,$64,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$80,$80,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$03,$64,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $10,$07,$00,$00,$00,$00,$00,$00
                    .db $04,$00,$00,$64,$09,$00,$01,$00
                    .db $04,$00,$00,$00,$00,$00,$00,$67
                    .db $02,$00,$60,$00,$02,$04,$04,$00
                    .db $00,$01,$00,$00,$00,$10,$07,$60
                    .db $00,$00,$00,$00,$00,$00,$01,$00
                    .db $00,$00,$80,$80,$00,$00,$00,$00
                    .db $00,$66,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$80,$00,$00,$00,$00
                    .db $00,$80,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$80,$00,$00,$00,$00,$00
                    .db $00,$00,$E4,$00,$80,$00,$00,$00
                    .db $80,$00,$80,$00,$E0,$80,$80,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$03
                    .db $00,$03,$00,$00,$01,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$64,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$03,$00,$03,$00,$03,$00,$00
                    .db $00,$00,$01,$00,$00,$00,$00,$00
                    .db $07,$06,$00,$00,$00,$60,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$05,$00,$00,$00,$00
DATA_05F800:        .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$0F
                    .db $1C,$10,$0A,$06,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$06,$00,$00,$00,$00,$23
                    .db $01,$00,$00,$00,$00,$0D,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$1D,$00,$00,$00,$00,$14
                    .db $00,$00,$00,$00,$05,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$15,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$13,$23,$00,$02,$0F
                    .db $17,$1F,$00,$18,$00,$00,$0B,$00
                    .db $00,$2C,$06,$05,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $27,$00,$00,$00,$16,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$1A
                    .db $00,$00,$00,$00,$00,$19,$00,$0A
                    .db $23,$00,$00,$00,$00,$03,$00,$00
DATA_05FA00:        .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$AB
                    .db $A9,$C2,$A6,$AA,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$AA,$02
                    .db $AA,$00,$A8,$00,$00,$00,$00,$A8
                    .db $A8,$AA,$00,$AA,$00,$AB,$A9,$00
                    .db $00,$AB,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$02,$00,$00,$00,$00,$AB
                    .db $AA,$00,$00,$00,$A9,$00,$AA,$AB
                    .db $00,$00,$00,$00,$00,$A9,$00,$AB
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$A8,$AA,$00,$AB,$A9
                    .db $A7,$AA,$00,$AA,$00,$00,$A7,$00
                    .db $00,$AB,$AB,$A9,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $AA,$00,$00,$00,$A8,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$A7
                    .db $00,$00,$00,$00,$00,$AB,$00,$AB
                    .db $AA,$00,$00,$00,$00,$A9,$00,$00
DATA_05FC00:        .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$0E
                    .db $2A,$25,$64,$04,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$21,$68
                    .db $26,$00,$08,$00,$00,$00,$00,$6D
                    .db $70,$2B,$00,$0D,$00,$2D,$27,$00
                    .db $00,$2D,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$6A,$00,$00,$00,$00,$02
                    .db $6A,$00,$00,$00,$70,$00,$0E,$21
                    .db $00,$00,$00,$00,$00,$2B,$00,$0A
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$08,$04,$00,$05,$03
                    .db $26,$68,$00,$30,$00,$00,$2A,$00
                    .db $00,$69,$70,$08,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $2A,$00,$00,$00,$29,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$2E
                    .db $00,$00,$00,$00,$00,$2F,$00,$2F
                    .db $32,$00,$00,$00,$00,$28,$00,$00
DATA_05FE00:        .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$03
                    .db $03,$03,$07,$03,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$03,$01
                    .db $03,$00,$06,$00,$00,$00,$00,$04
                    .db $06,$03,$00,$03,$00,$03,$00,$00
                    .db $00,$03,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$03,$00,$00,$00,$00,$00
                    .db $03,$00,$00,$00,$03,$00,$03,$02
                    .db $00,$00,$00,$00,$00,$04,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$04,$03,$00,$03,$03
                    .db $04,$03,$00,$03,$00,$00,$05,$00
                    .db $00,$03,$03,$06,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $03,$00,$00,$00,$03,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$02
                    .db $00,$00,$00,$00,$00,$03,$00,$02
                    .db $03,$00,$00,$00,$00,$03,$00,$00

