.INCLUDE "snes.cfg"
.BANK 1


DATA_018000:        .db $80,$40,$20,$10,$08,$04,$02,$01

ADDR_018008:        LDA.W $1588,X             ; \ Set A to lower two bits of 
                    AND.B #$03                ; / current sprite's Position Status 
                    RTS                       ; Return 

ADDR_01800E:        LDA.W $1588,X             ; \ Set A to bit 2 of 
                    AND.B #$04                ; / current sprite's Position Status 
                    RTS                       ; Return 

ADDR_018014:        LDA.W $1588,X             ; \ Set A to bit 3 of 
                    AND.B #$08                ; / current sprite's Position Status 
                    RTS                       ; Return 

ADDR_01801A:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_01ABD8         
                    PLB                       
                    RTL                       ; Return 

ADDR_018022:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_01ABCC         
                    PLB                       
                    RTL                       ; Return 

UpdateSpritePos:    PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_019032         
                    PLB                       
                    RTL                       ; Return 

SprSprInteract:     PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_01A40D         
                    PLB                       
                    RTL                       ; Return 

ADDR_01803A:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_018FC1         
                    PLB                       
                    RTL                       ; Return 

ADDR_018042:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_019CF3         
                    PLB                       
                    RTL                       ; Return 

ADDR_01804A:        EOR.B #$FF                ; \ Set A to -A 
                    INC A                     ; /  
                    RTS                       ; Return 

ADDR_01804E:        LDA.W $1588,X             
                    BEQ ADDR_018072           
                    LDA $13                   
                    AND.B #$03                
                    ORA $86                   
                    BNE ADDR_018072           
                    LDA.B #$04                
                    STA $00                   
                    LDA.B #$0A                
                    STA $01                   
ADDR_018063:        JSR.W IsSprOffscreen      
                    BNE ADDR_018072           
                    LDY.B #$03                
ADDR_01806A:        LDA.W $17C0,Y             
                    BEQ ADDR_018073           
                    DEY                       
                    BPL ADDR_01806A           
ADDR_018072:        RTS                       ; Return 

ADDR_018073:        LDA.B #$03                
                    STA.W $17C0,Y             
                    LDA $E4,X                 
                    ADC $00                   
                    STA.W $17C8,Y             
                    LDA $D8,X                 
                    ADC $01                   
                    STA.W $17C4,Y             
                    LDA.B #$13                
                    STA.W $17CC,Y             
                    RTS                       ; Return 

ADDR_01808C:        PHB                       
                    PHK                       
                    PLB                       
                    LDA.W $148F               
                    STA.W $1470               
                    STZ.W $148F               
                    STZ.W $1471               
                    STZ.W $18C2               
                    LDA.W $18DF               
                    STA.W $18E2               
                    STZ.W $18DF               
                    LDX.B #$0B                
ADDR_0180A9:        STX.W $15E9               
                    JSR.W ADDR_0180D2         
                    JSR.W HandleSprite        
                    DEX                       
                    BPL ADDR_0180A9           
                    LDA.W $18B8               
                    BEQ ADDR_0180BE           
                    JSL.L ADDR_02F808         
ADDR_0180BE:        LDA.W $18DF               
                    BNE ADDR_0180C9           
                    STZ.W $187A               
                    STZ.W $188B               
ADDR_0180C9:        PLB                       
                    RTL                       ; Return 

IsSprOffscreen:     LDA.W $15A0,X             ; \ A = Current sprite is offscreen 
                    ORA.W $186C,X             ; /  
                    RTS                       ; Return 

ADDR_0180D2:        PHX                       ; In all sprite routines, X = current sprite 
                    TXA                       
                    LDX.W $1692               ; $1692 = Current Sprite memory settings 
                    CLC                       ; \  
                    ADC.L DATA_07F0B4,X       ;  |Add $07:F0B4,$1692 to sprite index.  i.e. minimum one tile allotted to each sprite 
                    TAX                       ;  |the bytes read go straight to the OAM indexes 
                    LDA.L DATA_07F000,X       ;  | 
                    PLX                       ; /  
                    STA.W $15EA,X             ; Current sprite's OAM index 
                    LDA.W $14C8,X             ; If  (something related to current sprite) is 0 
                    BEQ ADDR_018126           ; do not decrement these counters 
                    LDA $9D                   ; Lock sprites timer 
                    BNE ADDR_018126           ; if sprites locked, do not decrement counters 
                    LDA.W $1540,X             ; \ Decrement a bunch of sprite counter tables 
                    BEQ ADDR_0180F6           ;  | 
                    DEC.W $1540,X             ;  |Do not decrement any individual counter if it's already at zero 
ADDR_0180F6:        LDA.W $154C,X             ;  | 
                    BEQ ADDR_0180FE           ;  | 
                    DEC.W $154C,X             ;  | 
ADDR_0180FE:        LDA.W $1558,X             ;  | 
                    BEQ ADDR_018106           ;  | 
                    DEC.W $1558,X             ;  | 
ADDR_018106:        LDA.W $1564,X             ;  | 
                    BEQ ADDR_01810E           ;  | 
                    DEC.W $1564,X             ;  | 
ADDR_01810E:        LDA.W $1FE2,X             ;  | 
                    BEQ ADDR_018116           ;  | 
                    DEC.W $1FE2,X             ;  | 
ADDR_018116:        LDA.W $15AC,X             ;  | 
                    BEQ ADDR_01811E           ;  | 
                    DEC.W $15AC,X             ;  | 
ADDR_01811E:        LDA.W $163E,X             ;  | 
                    BEQ ADDR_018126           ;  | 
                    DEC.W $163E,X             ;  | 
ADDR_018126:        RTS                       ; Return 

HandleSprite:       LDA.W $14C8,X             ; Call a routine based on the sprite's status 
                    BEQ EraseSprite           ; Routine for status 0 hardcoded, maybe for performance 
                    CMP.B #$08                
                    BNE ADDR_018133           ; Routine for status 8 hardcoded, maybe for preformance 
                    JMP.W CallSpriteMain      
ADDR_018133:        JSL.L ExecutePtr          

SpriteStatusRtPtr:  .dw EraseSprite           ; 0 - Non-existant (Bypassed above) 
                    .dw CallSpriteInit        ; 1 
                    .dw ADDR_019AA2           ; 2 - Falling off screen (hit by star, shell, etc) 
                    .dw ADDR_019AE4           ; 3 - Smushed 
                    .dw ADDR_019A52           ; 4 - Spin Jumped 
                    .dw ADDR_019A7B           ; 5 
                    .dw ADDR_01816D           ; 6 - End of level turn to coin 
                    .dw ADDR_018156           ; 7 - Unused 
                    .dw Return0185C2          ; 8 - Normal (Bypassed above) 
                    .dw ADDR_01953C           ; 9 - Carryable, flipped, stunned 
                    .dw ADDR_019913           ; A - Kicked 
                    .dw ADDR_019F71           ; B - Carried 
                    .dw ADDR_018157           ; C - Fleeing? 

EraseSprite:        LDA.B #$FF                
                    STA.W $161A,X             
ADDR_018156:        RTS                       ; Return 

ADDR_018157:        JSR.W CallSpriteMain      
                    JSR.W ADDR_01AC31         
                    JSR.W ADDR_019032         
                    DEC $AA,X                 
                    DEC $AA,X                 
                    JSR.W ADDR_01800E         
                    BEQ ADDR_01816C           
                    JSR.W ADDR_019A04         
ADDR_01816C:        RTS                       ; Return 

ADDR_01816D:        JSL.L ADDR_00FBAC         
                    RTS                       ; Return 

CallSpriteInit:     LDA.B #$08                
                    STA.W $14C8,X             
                    LDA $9E,X                 
                    JSL.L ExecutePtr          

SpriteInitPtr:      .dw ADDR_018575           
                    .dw ADDR_018575           
                    .dw ADDR_018575           
                    .dw ADDR_018575           
                    .dw ADDR_018575           
                    .dw ADDR_018575           
                    .dw ADDR_018575           
                    .dw ADDR_018575           
                    .dw ADDR_018575           
                    .dw ADDR_01856E           
                    .dw ADDR_018575           
                    .dw ADDR_018575           
                    .dw ADDR_018575           
                    .dw ADDR_01855D           
                    .dw ADDR_01E1B8           
                    .dw ADDR_018575           
                    .dw ADDR_018575           
                    .dw ADDR_018575           
                    .dw ADDR_01F875           
                    .dw ADDR_018575           
                    .dw ADDR_018575           
                    .dw Return01B011          
                    .dw ADDR_01B00B           
                    .dw ADDR_01B014           
                    .dw ADDR_01B014           
                    .dw ADDR_0183DA           
                    .dw PiranhaInit           
                    .dw Return0185C2          
                    .dw ADDR_0184DD           
                    .dw ADDR_018575           
                    .dw ADDR_01846B           
                    .dw ADDR_01BDB8           
                    .dw Return018583          
                    .dw FaceMario             
                    .dw ADDR_01B948           
                    .dw ADDR_01B948           
                    .dw ADDR_01B93E           
                    .dw ADDR_01B93E           
                    .dw ADDR_01AE96           
                    .dw Return01AEA2          
                    .dw ADDR_01F884           
                    .dw ADDR_01CD2F           
                    .dw ADDR_01859A           
                    .dw Return0185C2          
                    .dw ADDR_018339           
                    .dw ADDR_018435           
                    .dw ADDR_0183F2           
                    .dw Return0185C2          
                    .dw FaceMario             
                    .dw FaceMario             
                    .dw FaceMario             
                    .dw ADDR_01E050           
                    .dw Return0185C2          
                    .dw ADDR_0183E0           
                    .dw Return0185C2          
                    .dw ADDR_01F884           
                    .dw ADDR_01F87C           
                    .dw ADDR_01F87C           
                    .dw ADDR_01841B           
                    .dw ADDR_01841B           
                    .dw ADDR_018404           
                    .dw ADDR_018431           
                    .dw ADDR_01844E           
                    .dw Return0185C2          
                    .dw Return0185C2          
                    .dw Return01843D          
                    .dw Return01843D          
                    .dw Return01843D          
                    .dw Return01843D          
                    .dw Return0185C2          
                    .dw ADDR_018508           
                    .dw Return0183EE          
                    .dw Return0183EE          
                    .dw ADDR_018381           
                    .dw Return0183EE          
                    .dw PiranhaInit           
                    .dw ADDR_0183A4           
                    .dw ADDR_0184CE           
                    .dw ADDR_0184CE           
                    .dw PiranhaInit           
                    .dw PiranhaInit           
                    .dw FaceMario             
                    .dw ADDR_018890           
                    .dw Return0185C2          
                    .dw ADDR_01BA87           
                    .dw ADDR_01B25E           
                    .dw Return01B25D          
                    .dw ADDR_01B25E           
                    .dw Return01B25D          
                    .dw Return01B267          
                    .dw Return01B267          
                    .dw ADDR_01B236           
                    .dw ADDR_01B22B           
                    .dw ADDR_01B236           
                    .dw ADDR_01B22E           
                    .dw ADDR_01C74A           
                    .dw Return01AE90          
                    .dw ADDR_0187D9           
                    .dw ADDR_01D711           
                    .dw ADDR_01D6D2           
                    .dw ADDR_01D6C4           
                    .dw ADDR_01D6ED           
                    .dw ADDR_01D6ED           
                    .dw ADDR_01D6ED           
                    .dw ADDR_01D6ED           
                    .dw Return01D6C3          
                    .dw Return0185C2          
                    .dw Return01843D          
                    .dw ADDR_01843E           
                    .dw Return0185C2          
                    .dw ADDR_018558           
                    .dw ADDR_018558           
                    .dw ADDR_01854B           
                    .dw ADDR_018528           
                    .dw ADDR_018528           
                    .dw ADDR_01852E           
                    .dw ADDR_01858B           
                    .dw ADDR_01858B           
                    .dw ADDR_01858B           
                    .dw ADDR_01858B           
                    .dw ADDR_01858B           
                    .dw Return018583          
                    .dw Return018583          
                    .dw ADDR_01C075           
                    .dw Return0185C2          
                    .dw Return0185C2          
                    .dw Return0185C2          
                    .dw Return0185C2          
                    .dw ADDR_018435           
                    .dw ADDR_01843B           
                    .dw ADDR_01DDAC           
                    .dw ADDR_01AD59           
                    .dw ADDR_01AD59           
                    .dw Return0185C2          
                    .dw ADDR_018829           
                    .dw Return0185C2          
                    .dw ADDR_01886F           
                    .dw Return01843D          
                    .dw Return0185C2          
                    .dw Return0185C2          
                    .dw ADDR_0183DA           
                    .dw Return0185C2          
                    .dw Return0185C2          
                    .dw ADDR_0183B5           
                    .dw FaceMario             
                    .dw Return018869          
                    .dw ADDR_018504           
                    .dw ADDR_018504           
                    .dw ADDR_018500           
                    .dw ADDR_0184E9           
                    .dw Return018869          
                    .dw ADDR_0184FC           
                    .dw ADDR_0184ED           
                    .dw Return0183EE          
                    .dw ADDR_018373           
                    .dw ADDR_0187A7           
                    .dw Return0185C2          
                    .dw ADDR_018564           
                    .dw ADDR_018396           
                    .dw ADDR_018387           
                    .dw ADDR_01836E           
                    .dw Return0185C2          
                    .dw Return0185C2          
                    .dw ADDR_01839A           
                    .dw ADDR_01B216           
                    .dw ADDR_01840B           
                    .dw ADDR_01840B           
                    .dw Return0185C2          
                    .dw Return0185C2          
                    .dw ADDR_018789           
                    .dw ADDR_01858E           
                    .dw FaceMario             
                    .dw ADDR_01835B           
                    .dw ADDR_01836B           
                    .dw Return0185C2          
                    .dw Return0185C2          
                    .dw ADDR_01834E           
                    .dw ADDR_0184D6           
                    .dw Return0185C2          
                    .dw ADDR_018584           
                    .dw FaceMario             
                    .dw Return0185C2          
                    .dw ADDR_01834E           
                    .dw Return0185C2          
                    .dw Return0185C2          
                    .dw Return0185C2          
                    .dw ADDR_018326           
                    .dw Return0185C2          
                    .dw ADDR_018314           
                    .dw ADDR_01837D           
                    .dw Return0185C2          
                    .dw FaceMario             
                    .dw ADDR_01830F           
                    .dw ADDR_0184CE           
                    .dw FaceMario             
                    .dw FaceMario             
                    .dw Return0185C2          
                    .dw FaceMario             
                    .dw Return018313          
                    .dw Return0185C2          
                    .dw Return0185C2          

ADDR_01830F:        INC $D8,X                 
                    INC $D8,X                 
Return018313:       RTS                       

ADDR_018314:        INC.W $157C,X             
                    JSR.W ADDR_0183A4         
                    STY $C2,X                 
                    CPY.B #$02                
                    BNE ADDR_018325           
                    LDA.B #$01                
                    STA.W $15F6,X             
ADDR_018325:        RTS                       ; Return 

ADDR_018326:        LDY.B #$3F                
                    LDA $E4,X                 
                    AND.B #$10                
                    BNE ADDR_018330           
                    LDY.B #$FF                
ADDR_018330:        TYA                       
                    STA.W $1570,X             
                    RTS                       ; Return 


YoshiPal:           .db $09,$07,$05,$07

ADDR_018339:        LDA $E4,X                 
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.B #$03                
                    TAY                       
                    LDA.W YoshiPal,Y          
                    STA.W $15F6,X             
                    INC.W $187B,X             
                    RTS                       ; Return 


DATA_01834C:        .db $10,$F0

ADDR_01834E:        JSR.W FaceMario           
                    LDA.W DATA_01834C,Y       
                    STA $B6,X                 
                    LDA.B #$F0                
                    STA $AA,X                 
                    RTS                       ; Return 

ADDR_01835B:        LDA $D8,X                 
                    SEC                       
                    SBC.B #$40                
                    STA $D8,X                 
                    LDA.W $14D4,X             
                    SBC.B #$00                
                    STA.W $14D4,X             
                    RTS                       ; Return 

ADDR_01836B:        JMP.W ADDR_0184CE         
ADDR_01836E:        JSL.L ADDR_03A0F1         
                    RTS                       ; Return 

ADDR_018373:        LDA.B #$03                
                    STA $C2,X                 
                    LDA.B #$70                
ADDR_018379:        STA.W $1540,X             
                    RTS                       ; Return 

ADDR_01837D:        LDA.B #$04                
                    BRA ADDR_018379           
ADDR_018381:        LDA.B #$40                
                    STA.W $1534,X             
                    RTS                       ; Return 

ADDR_018387:        JSR.W SubHorizPos         
                    TYA                       
                    BNE ADDR_018390           
                    JMP.W OffScrEraseSprite   
ADDR_018390:        LDA.B #$09                
                    STA.W $1DFC               ; / Play sound effect 
                    RTS                       ; Return 

ADDR_018396:        LDA.B #$38                
                    BRA ADDR_01839C           
ADDR_01839A:        LDA.B #$30                
ADDR_01839C:        STA.W $187B,X             
                    RTS                       ; Return 


TurnBlockSpr:       .db $15,$0F,$00,$04

ADDR_0183A4:        LDA $E4,X                 
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.B #$03                
                    TAY                       
                    LDA.W TurnBlockSpr,Y      
                    STA $C2,X                 
                    RTS                       ; Return 


DATA_0183B3:        .db $80,$40

ADDR_0183B5:        LDA $D8,X                 
                    STA.W $1534,X             
                    LDA.W $14D4,X             
                    STA.W $151C,X             
                    LDA $E4,X                 
                    AND.B #$10                
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA $E4,X                 
                    CLC                       
                    ADC.W DATA_0183B3,Y       
                    STA $C2,X                 
                    LDA.W $14E0,X             
                    ADC.B #$00                
                    STA.W $1602,X             
                    RTS                       ; Return 

ADDR_0183DA:        LDA.B #$28                ; \ Set current sprite's "disable contact with other sprites" timer to x28 
                    STA.W $1564,X             ; /  
                    RTS                       ; Return 

ADDR_0183E0:        DEC.W $160E,X             
                    INC.W $157C,X             
                    LDA.W $0DC1               
                    BEQ Return0183EE          
                    STZ.W $14C8,X             
Return0183EE:       RTS                       


DATA_0183EF:        .db $08

DATA_0183F0:        .db $00,$08

ADDR_0183F2:        JSR.W SubHorizPos         
                    TYA                       
                    EOR.B #$01                
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    JSR.W ADDR_01841D         
                    STZ.W $164A,X             
                    BRA ADDR_01840E           
ADDR_018404:        INC $D8,X                 
                    BNE ADDR_01840B           
                    INC.W $14D4,X             
ADDR_01840B:        JSR.W ADDR_01841B         
ADDR_01840E:        LDA.W $151C,X             
                    EOR.B #$10                
                    STA.W $151C,X             
                    LSR                       
                    LSR                       
                    STA $C2,X                 
                    RTS                       ; Return 

ADDR_01841B:        LDA $E4,X                 
ADDR_01841D:        LDY.B #$00                
                    AND.B #$10                
                    STA.W $151C,X             
                    BNE ADDR_018427           
                    INY                       
ADDR_018427:        LDA.W DATA_0183EF,Y       
                    STA $B6,X                 
                    LDA.W DATA_0183F0,Y       
                    STA $AA,X                 
ADDR_018431:        INC.W $164A,X             
                    RTS                       ; Return 

ADDR_018435:        LDA.B #$09                
                    STA.W $14C8,X             
                    RTS                       ; Return 

ADDR_01843B:        INC $C2,X                 
Return01843D:       RTS                       

ADDR_01843E:        LDA $E4,X                 
                    SEC                       
                    SBC.B #$08                
                    STA $E4,X                 
                    LDA.W $14E0,X             
                    SBC.B #$00                
                    STA.W $14E0,X             
                    RTS                       ; Return 

ADDR_01844E:        LDA $E4,X                 
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.B #$01                
                    STA.W $151C,X             
                    TAY                       
                    LDA.W PSwitchPal,Y        
                    STA.W $15F6,X             
                    LDA.B #$09                
                    STA.W $14C8,X             
                    RTS                       ; Return 


PSwitchPal:         .db $06,$02

ADDR_018468:        JMP.W OffScrEraseSprite   
ADDR_01846B:        LDY.B #$09                
ADDR_01846D:        CPY.W $15E9               
                    BEQ ADDR_018484           
                    LDA.W $14C8,Y             
                    CMP.B #$08                
                    BNE ADDR_018484           
                    LDA.W $009E,Y             
                    CMP.B #$87                
                    BEQ ADDR_018468           
                    CMP.B #$1E                
                    BEQ ADDR_018468           
ADDR_018484:        DEY                       
                    BPL ADDR_01846D           
                    STZ.W $18C0               
                    STZ.W $18BF               
                    STZ.W $18B9               
                    LDA $D8,X                 
                    STA.W $18C3               
                    LDA.W $14D4,X             
                    STA.W $18C4               
                    JSL.L ADDR_02A9E4         
                    BMI ADDR_0184CE           
                    STY.W $18E1               
                    LDA.B #$87                
                    STA.W $009E,Y             
                    LDA.B #$08                
                    STA.W $14C8,Y             
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
                    PLX                       
                    STZ.W $18E0               
ADDR_0184CE:        LDA $E4,X                 
                    AND.B #$10                
                    STA.W $151C,X             
                    RTS                       ; Return 

ADDR_0184D6:        LDA.B #$FF                
                    STA.W $1909               
                    BRA ADDR_0184CE           
ADDR_0184DD:        JSR.W SubHorizPos         
                    TYA                       
                    STA $C2,X                 
                    LDA.B #$10                
                    STA.W $1540,X             
                    RTS                       ; Return 

ADDR_0184E9:        LDA.B #$08                
                    BRA ADDR_01851A           
ADDR_0184ED:        LDA $E4,X                 
                    AND.B #$30                
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    STA.W $187B,X             
                    LDA.B #$0A                
                    BRA ADDR_01851A           
ADDR_0184FC:        LDA.B #$09                
                    BRA ADDR_01851A           
ADDR_018500:        LDA.B #$0B                
                    BRA ADDR_01851A           
ADDR_018504:        LDA.B #$05                
                    BRA ADDR_01851A           
ADDR_018508:        LDA.B #$30                
                    STA.W $1540,X             
                    LDA $E4,X                 
                    AND.B #$10                
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    STA.W $157C,X             
                    LDA.B #$04                
ADDR_01851A:        STA $C2,X                 
                    JSR.W FaceMario           
                    LDA.W DATA_018526,Y       
                    STA.W $151C,X             
                    RTS                       ; Return 


DATA_018526:        .db $00,$04

ADDR_018528:        LDA.B #$28                
                    STA $AA,X                 
                    BRA FaceMario             
ADDR_01852E:        JSR.W FaceMario           
                    LDA $E4,X                 
                    AND.B #$10                
                    BEQ ADDR_018547           
                    LDA.B #$10                
                    STA.W $1656,X             
                    LDA.B #$80                
                    STA.W $1662,X             
                    LDA.B #$10                
                    STA.W $1686,X             
                    RTS                       ; Return 

ADDR_018547:        INC.W $1534,X             
                    RTS                       ; Return 

ADDR_01854B:        LDA.B #$1F                
                    LDY.W $187A               
                    BNE ADDR_018554           
                    LDA.B #$07                
ADDR_018554:        STA $C2,X                 
                    BRA FaceMario             
ADDR_018558:        LDA.B #$04                
                    STA.W $151C,X             
ADDR_01855D:        LDA.B #$FF                
                    STA.W $1540,X             
                    BRA FaceMario             
ADDR_018564:        JSR.W ADDR_0183A4         
                    STY $C2,X                 
                    DEC.W $1534,X             
                    BRA FaceMario             
ADDR_01856E:        LDA $D8,X                 
                    AND.B #$10                
                    STA.W $160E,X             
ADDR_018575:        JSL.L ADDR_01ACF9         
                    STA.W $1570,X             
FaceMario:          JSR.W SubHorizPos         
                    TYA                       
                    STA.W $157C,X             
Return018583:       RTS                       

ADDR_018584:        LDA.B #$17                
                    STA.W $1DFC               ; / Play sound effect 
                    BRA FaceMario             
ADDR_01858B:        INC $C2,X                 
                    RTS                       ; Return 

ADDR_01858E:        JSL.L ADDR_01ACF9         
                    AND.B #$1F                
                    STA.W $1540,X             
                    JMP.W FaceMario           
ADDR_01859A:        ASL.W $15F6,X             
                    SEC                       
                    ROR.W $15F6,X             
                    LDA $D8,X                 
                    SEC                       
                    SBC.B #$10                
                    STA $D8,X                 
                    LDA.W $14D4,X             
                    SBC.B #$00                
                    STA.W $14D4,X             
PiranhaInit:        LDA $E4,X                 ; \ Center sprite between two tiles 
                    CLC                       ;  | 
                    ADC.B #$08                ;  | 
                    STA $E4,X                 ; / 
                    DEC $D8,X                 
                    LDA $D8,X                 
                    CMP.B #$FF                
                    BNE Return0185C2          
                    DEC.W $14D4,X             
Return0185C2:       RTS                       

CallSpriteMain:     STZ.W $1491               ; CallSpriteMain 
                    LDA $9E,X                 
                    JSL.L ExecutePtr          

SpriteMainPtr:      .dw ADDR_018904           
                    .dw ADDR_018904           
                    .dw ADDR_018904           
                    .dw ADDR_018904           
                    .dw ADDR_018AFC           
                    .dw ADDR_018AFC           
                    .dw ADDR_018AFC           
                    .dw ADDR_018AFC           
                    .dw ADDR_018C4D           
                    .dw ADDR_018C4D           
                    .dw ADDR_018CC3           
                    .dw ADDR_018CBE           
                    .dw ADDR_018AFC           
                    .dw ADDR_018AE5           
                    .dw ADDR_01E1C8           
                    .dw ADDR_018AFC           
                    .dw ADDR_018D2E           
                    .dw ADDR_018AFC           
                    .dw ADDR_01F87B           
                    .dw ADDR_018AFC           
                    .dw ADDR_018C18           
                    .dw ADDR_01B033           
                    .dw ADDR_01B033           
                    .dw ADDR_01B192           
                    .dw ADDR_01B1B4           
                    .dw ADDR_01E75B           
                    .dw ADDR_018E76           
                    .dw Bank3SprHandler       
                    .dw ADDR_018FE7           
                    .dw ADDR_018F0D           
                    .dw ADDR_018F97           
                    .dw ADDR_01BDD6           
                    .dw ADDR_01BC38           
                    .dw PowerUpRt             
                    .dw ADDR_01B97F           
                    .dw ADDR_01B97F           
                    .dw ADDR_01B97F           
                    .dw ADDR_01B97F           
                    .dw ADDR_01AEA3           
                    .dw ADDR_01AF9F           
                    .dw ADDR_01F8D5           
                    .dw ADDR_01FAC1           
                    .dw ADDR_018E76           
                    .dw ADDR_0187B6           
                    .dw ADDR_01F764           
                    .dw Return0185C2          
                    .dw ADDR_01885E           
                    .dw ADDR_01E623           
                    .dw ADDR_01E42B           
                    .dw ADDR_01E42B           
                    .dw ADDR_01E42B           
                    .dw ADDR_01E093           
                    .dw ADDR_01D44E           
                    .dw ADDR_01EBCA           
                    .dw DATA_01E41F           
                    .dw ADDR_01F8DC           
                    .dw ADDR_01F890           
                    .dw ADDR_01F890           
                    .dw ADDR_01885E           
                    .dw ADDR_01885E           
                    .dw ADDR_01885E           
                    .dw ADDR_018853           
                    .dw ADDR_01E75B           
                    .dw ADDR_01D4FB           
                    .dw ADDR_01D4FB           
                    .dw ADDR_018885           
                    .dw ADDR_018885           
                    .dw ADDR_018885           
                    .dw ADDR_018838           
                    .dw ADDR_0187CA           
                    .dw ADDR_018806           
                    .dw ADDR_01880B           
                    .dw ADDR_018810           
                    .dw ADDR_018815           
                    .dw ADDR_018763           
                    .dw ADDR_018801           
                    .dw ADDR_0187CF           
                    .dw ADDR_01E2CF           
                    .dw ADDR_01E2CF           
                    .dw ADDR_0187BB           
                    .dw ADDR_0187BB           
                    .dw Bank3SprHandler       
                    .dw ADDR_018893           
                    .dw Return0185C2          
                    .dw ADDR_01BACD           
                    .dw ADDR_01B26C           
                    .dw ADDR_01B26C           
                    .dw ADDR_01B26C           
                    .dw ADDR_01B26C           
                    .dw ADDR_01B6A5           
                    .dw ADDR_01B6DA           
                    .dw ADDR_01B563           
                    .dw ADDR_01B563           
                    .dw ADDR_01B563           
                    .dw ADDR_01B536           
                    .dw ADDR_01C773           
                    .dw ADDR_01AE91           
                    .dw ADDR_0187DE           
                    .dw ADDR_01D74A           
                    .dw ADDR_01D74A           
                    .dw ADDR_01D719           
                    .dw ADDR_01D719           
                    .dw ADDR_01D719           
                    .dw ADDR_01D73A           
                    .dw ADDR_01D74A           
                    .dw Return01D6C3          
                    .dw ADDR_018833           
                    .dw ADDR_018848           
                    .dw ADDR_018848           
                    .dw ADDR_01875E           
                    .dw ADDR_01875E           
                    .dw ADDR_01875E           
                    .dw ADDR_0187ED           
                    .dw ADDR_0187F2           
                    .dw ADDR_0187F7           
                    .dw ADDR_0187FC           
                    .dw PowerUpRt             
                    .dw ADDR_01C349           
                    .dw PowerUpRt             
                    .dw ADDR_01C6ED           
                    .dw PowerUpRt             
                    .dw ADDR_01C183           
                    .dw Bank3SprHandler       
                    .dw ADDR_01C098           
                    .dw Bank3SprHandler       
                    .dw ADDR_01C1F2           
                    .dw ADDR_01C1F2           
                    .dw ADDR_01C1F2           
                    .dw ADDR_01C1F2           
                    .dw ADDR_01C317           
                    .dw ADDR_01DE2A           
                    .dw ADDR_01AD6E           
                    .dw ADDR_01AD6E           
                    .dw ADDR_01AD59           
                    .dw ADDR_01882E           
                    .dw ADDR_01E7A4           
                    .dw ADDR_01887A           
                    .dw ADDR_01883D           
                    .dw ADDR_01881A           
                    .dw ADDR_01881F           
                    .dw ADDR_018824           
                    .dw ADDR_0187E3           
                    .dw ADDR_0187E8           
                    .dw ADDR_0187D4           
                    .dw ADDR_0187C0           
                    .dw ADDR_01886A           
                    .dw ADDR_01886A           
                    .dw ADDR_01886A           
                    .dw ADDR_01886A           
                    .dw ADDR_01886A           
                    .dw ADDR_01886A           
                    .dw ADDR_01886A           
                    .dw ADDR_01886A           
                    .dw ADDR_0187AC           
                    .dw ADDR_0187B1           
                    .dw ADDR_01879D           
                    .dw ADDR_0187A2           
                    .dw ADDR_018798           
                    .dw ADDR_018793           
                    .dw ADDR_018793           
                    .dw Bank3SprHandler       
                    .dw Bank3SprHandler       
                    .dw Bank3SprHandler       
                    .dw ADDR_018793           
                    .dw ADDR_01B559           
                    .dw ADDR_01885E           
                    .dw ADDR_01885E           
                    .dw ADDR_01FA58           
                    .dw Bank3SprHandler       
                    .dw Bank3SprHandler       
                    .dw Bank3SprHandler       
                    .dw Bank3SprHandler       
                    .dw Bank3SprHandler       
                    .dw Bank3SprHandler       
                    .dw Bank3SprHandler       
                    .dw ADDR_01F8DC           
                    .dw Bank3SprHandler       
                    .dw Bank3SprHandler       
                    .dw Bank3SprHandler       
                    .dw Bank3SprHandler       
                    .dw ADDR_01DB5C           
                    .dw ADDR_01E093           
                    .dw Bank3SprHandler       
                    .dw Bank3SprHandler       
                    .dw Bank3SprHandler       
                    .dw Bank3SprHandler       
                    .dw Bank3SprHandler       
                    .dw Bank3SprHandler       
                    .dw Bank3SprHandler       
                    .dw Bank3SprHandler       
                    .dw Bank3SprHandler       
                    .dw Bank3SprHandler       
                    .dw Bank3SprHandler       
                    .dw Bank3SprHandler       
                    .dw Bank3SprHandler       
                    .dw Bank3SprHandler       
                    .dw Bank3SprHandler       
                    .dw Bank3SprHandler       
                    .dw Bank3SprHandler       
                    .dw Bank3SprHandler       
                    .dw Bank3SprHandler       

ADDR_01875E:        JSL.L ADDR_039C34         
                    RTS                       ; Return 

ADDR_018763:        JSR.W ADDR_019F0D         
                    LDA $9D                   
                    BNE ADDR_018788           
                    LDA $13                   
                    AND.B #$1F                
                    ORA $9D                   
                    JSR.W ADDR_01B152         
                    JSR.W ADDR_01A7E4         
                    BCC ADDR_018788           
                    STZ.W $14C8,X             
                    LDA.B #$FF                
                    STA.W $1493               
                    STA.W $0DDA               
                    LDA.B #$0B                
                    STA.W $1DFB               ; / Play sound effect 
ADDR_018788:        RTS                       ; Return 

ADDR_018789:        JSL.L ADDR_039872         
                    RTS                       ; Return 

Bank3SprHandler:    JSL.L Bnk3CallSprMain     
                    RTS                       ; Return 

ADDR_018793:        JSL.L ADDR_02D617         
                    RTS                       ; Return 

ADDR_018798:        JSL.L ADDR_02D8AD         
                    RTS                       ; Return 

ADDR_01879D:        JSL.L ADDR_02DA52         
                    RTS                       ; Return 

ADDR_0187A2:        JSL.L ADDR_02DB4C         
                    RTS                       ; Return 

ADDR_0187A7:        JSL.L ADDR_02DA59         
                    RTS                       ; Return 

ADDR_0187AC:        JSL.L ADDR_02DF8B         
                    RTS                       ; Return 

ADDR_0187B1:        JSL.L ADDR_02DCAF         
                    RTS                       ; Return 

ADDR_0187B6:        JSL.L ADDR_02DEA8         
                    RTS                       ; Return 

ADDR_0187BB:        JSL.L ADDR_02E0C5         
                    RTS                       ; Return 

ADDR_0187C0:        JSL.L ADDR_02E303         
                    RTS                       ; Return 

                    JSL.L ADDR_02DCAF         
                    RTS                       ; Return 

ADDR_0187CA:        JSL.L ADDR_02E215         
                    RTS                       ; Return 

ADDR_0187CF:        JSL.L ADDR_02E417         
                    RTS                       ; Return 

ADDR_0187D4:        JSL.L ADDR_02E495         
                    RTS                       ; Return 

ADDR_0187D9:        JSL.L ADDR_02ED82         
                    RTS                       ; Return 

ADDR_0187DE:        JSL.L ADDR_02EDD0         
                    RTS                       ; Return 

ADDR_0187E3:        JSL.L ADDR_02F594         
                    RTS                       ; Return 

ADDR_0187E8:        JSL.L ADDR_02EAD2         
                    RTS                       ; Return 

ADDR_0187ED:        JSL.L ADDR_02B636         
                    RTS                       ; Return 

ADDR_0187F2:        JSL.L ADDR_02EB27         
                    RTS                       ; Return 

ADDR_0187F7:        JSL.L ADDR_02EB27         
                    RTS                       ; Return 

ADDR_0187FC:        JSL.L ADDR_02EB27         
                    RTS                       ; Return 

ADDR_018801:        JSL.L ADDR_02E935         
                    RTS                       ; Return 

ADDR_018806:        JSL.L ADDR_02C1F5         
                    RTS                       ; Return 

ADDR_01880B:        JSL.L ADDR_02E71F         
                    RTS                       ; Return 

ADDR_018810:        JSL.L ADDR_02E7B5         
                    RTS                       ; Return 

ADDR_018815:        JSL.L ADDR_02E82D         
                    RTS                       ; Return 

ADDR_01881A:        JSL.L ADDR_02F30F         
                    RTS                       ; Return 

ADDR_01881F:        JSL.L ADDR_02F42C         
                    RTS                       ; Return 

ADDR_018824:        JSL.L ADDR_02F4CD         
                    RTS                       ; Return 

ADDR_018829:        JSL.L ADDR_02EFF2         
                    RTS                       ; Return 

ADDR_01882E:        JSL.L ADDR_02F029         
                    RTS                       ; Return 

ADDR_018833:        JSL.L ADDR_02EEA9         
                    RTS                       ; Return 

ADDR_018838:        JSL.L ADDR_02B882         
                    RTS                       ; Return 

ADDR_01883D:        PHB                       
                    LDA.B #$02                
                    PHA                       
                    PLB                       
                    JSL.L ADDR_02D3EA         
                    PLB                       
                    RTS                       ; Return 

ADDR_018848:        PHB                       
                    LDA.B #$02                
                    PHA                       
                    PLB                       
                    JSL.L ADDR_02CDCB         
                    PLB                       
                    RTS                       ; Return 

ADDR_018853:        PHB                       
                    LDA.B #$02                
                    PHA                       
                    PLB                       
                    JSL.L ADDR_02BFCD         
                    PLB                       
                    RTS                       ; Return 

ADDR_01885E:        PHB                       
                    LDA.B #$02                
                    PHA                       
                    PLB                       
                    JSL.L ADDR_02BCDB         
                    PLB                       
                    RTS                       ; Return 

Return018869:       RTS                       

ADDR_01886A:        JSL.L ADDR_02C1F5         
                    RTS                       ; Return 

ADDR_01886F:        PHB                       
                    LDA.B #$02                
                    PHA                       
                    PLB                       
                    JSL.L ADDR_02CBFD         
                    PLB                       
                    RTS                       ; Return 

ADDR_01887A:        PHB                       
                    LDA.B #$02                
                    PHA                       
                    PLB                       
                    JSL.L ADDR_02CBFE         
                    PLB                       
                    RTS                       ; Return 

ADDR_018885:        PHB                       
                    LDA.B #$02                
                    PHA                       
                    PLB                       
                    JSL.L ADDR_02BB94         
                    PLB                       
                    RTS                       ; Return 

ADDR_018890:        DEC $D8,X                 
                    RTS                       ; Return 

ADDR_018893:        JSL.L ADDR_02E5B4         
                    RTS                       ; Return 

ADDR_018898:        TXA                       
                    EOR $13                   
                    AND.B #$03                
                    BNE ADDR_0188AB           
                    LDY.B #$09                
ADDR_0188A1:        LDA.W $14C8,Y             
                    CMP.B #$0A                
                    BEQ ADDR_0188AC           
ADDR_0188A8:        DEY                       
                    BPL ADDR_0188A1           
ADDR_0188AB:        RTS                       ; Return 

ADDR_0188AC:        LDA.W $00E4,Y             
                    SEC                       
                    SBC.B #$1A                
                    STA $00                   
                    LDA.W $14E0,Y             
                    SBC.B #$00                
                    STA $08                   
                    LDA.B #$44                
                    STA $02                   
                    LDA.W $00D8,Y             
                    STA $01                   
                    LDA.W $14D4,Y             
                    STA $09                   
                    LDA.B #$10                
                    STA $03                   
                    JSL.L ADDR_03B69F         
                    JSL.L ADDR_03B72B         
                    BCC ADDR_0188A8           
                    JSR.W ADDR_01800E         
                    BEQ ADDR_0188A8           
                    LDA.W $157C,Y             
                    CMP.W $157C,X             
                    BEQ ADDR_0188EB           
                    LDA.B #$C0                
                    STA $AA,X                 
                    STZ.W $163E,X             
ADDR_0188EB:        RTS                       ; Return 


Spr0to13SpeedX:     .db $08,$F8,$0C,$F4

Spr0to13Prop:       .db $00,$02,$03,$0D,$40,$42,$43,$45
                    .db $50,$50,$50,$5C,$DD,$05,$00,$20
                    .db $20,$00,$00,$00

ADDR_018904:        LDA $9D                   ; \ If sprites aren't locked, 
                    BEQ ADDR_018952           ; / branch to $8952 
ADDR_018908:        LDA.W $163E,X             
                    CMP.B #$80                
                    BCC ADDR_01891F           
                    LDA $9D                   ; \ If sprites are locked, 
                    BNE ADDR_01891F           ; / branch to $891F 
ADDR_018913:        JSR.W ADDR_018E5F         
                    LDA.W $1602,X             ; \  
                    CLC                       ;  |Increase sprite's image by x05 
                    ADC.B #$05                ;  | 
                    STA.W $1602,X             ; /  
ADDR_01891F:        JSR.W ADDR_018931         
                    JSR.W ADDR_019032         
                    STZ $B6,X                 ; Set X speed to 0 
                    JSR.W ADDR_01800E         ; \ If sprite is on edge (on ground), 
                    BEQ ADDR_01892E           ;  |Set Y speed to 0 
                    STZ $AA,X                 ; /  
ADDR_01892E:        JMP.W ADDR_018B03         
ADDR_018931:        LDA $9E,X                 ; \  
                    CMP.B #$02                ;  |If sprite isn't Blue shelless Koopa, 
                    BNE ADDR_01893C           ; / branch to $893C 
                    JSR.W ADDR_01A7E4         
                    BRA ADDR_018951           
ADDR_01893C:        ASL.W $167A,X             
                    SEC                       
                    ROR.W $167A,X             
                    JSR.W ADDR_01A7E4         
                    BCC ADDR_01894B           
                    JSR.W ADDR_01B12A         
ADDR_01894B:        ASL.W $167A,X             
                    LSR.W $167A,X             
ADDR_018951:        RTS                       ; Return 

ADDR_018952:        LDA.W $163E,X             
                    BEQ ADDR_0189B4           
                    CMP.B #$80                
                    BNE ADDR_01896B           
                    JSR.W FaceMario           
                    LDA $9E,X                 ; \  
                    CMP.B #$02                ;  |If sprite is Blue shelless Koopa, 
                    BEQ ADDR_018968           ;  |Set Y speed to xE0 
                    LDA.B #$E0                ;  | 
                    STA $AA,X                 ; /  
ADDR_018968:        STZ.W $163E,X             
ADDR_01896B:        CMP.B #$01                
                    BNE ADDR_018908           
                    LDY.W $160E,X             
                    LDA.W $14C8,Y             
                    CMP.B #$09                
                    BNE ADDR_018908           
                    LDA $E4,X                 
                    SEC                       
                    SBC.W $00E4,Y             
                    CLC                       
                    ADC.B #$12                
                    CMP.B #$24                
                    BCS ADDR_018908           
                    JSR.W ADDR_01A728         
                    JSR.W ADDR_01A755         
                    LDY.W $157C,X             
                    LDA.W DATA_01A6D7,Y       
                    LDY.W $160E,X             
                    STA.W $00B6,Y             
                    LDA.B #$0A                
                    STA.W $14C8,Y             
                    LDA.W $1540,Y             
                    STA.W $00C2,Y             
                    LDA.B #$08                
                    STA.W $1564,Y             
                    LDA.W $167A,Y             
                    AND.B #$10                
                    BEQ ADDR_0189B4           
                    LDA.B #$E0                
                    STA.W $00AA,Y             
ADDR_0189B4:        LDA.W $1528,X             
                    BEQ ADDR_018A15           
                    JSR.W ADDR_018008         
                    BEQ ADDR_0189C0           
                    STZ $B6,X                 
ADDR_0189C0:        JSR.W ADDR_01800E         
                    BEQ ADDR_0189E6           
                    LDA $86                   
                    CMP.B #$01                
                    LDA.B #$02                
                    BCC ADDR_0189CE           
                    LSR                       
ADDR_0189CE:        STA $00                   
                    LDA $B6,X                 
                    CMP.B #$02                
                    BCC ADDR_0189FD           
                    BPL ADDR_0189DE           
                    CLC                       
                    ADC $00                   
                    CLC                       
                    ADC $00                   
ADDR_0189DE:        SEC                       
                    SBC $00                   
                    STA $B6,X                 
                    JSR.W ADDR_01804E         
ADDR_0189E6:        STZ.W $1570,X             
                    JSR.W ADDR_018B43         
                    LDA.B #$E6                
                    LDY $9E,X                 
                    CPY.B #$02                
                    BEQ ADDR_0189F6           
                    LDA.B #$86                
ADDR_0189F6:        LDY.W $15EA,X             
                    STA.W $0302,Y             
                    RTS                       ; Return 

ADDR_0189FD:        JSR.W ADDR_01800E         
                    BEQ ADDR_018A0F           
                    LDA.B #$FF                
                    LDY $9E,X                 
                    CPY.B #$02                
                    BNE ADDR_018A0C           
                    LDA.B #$A0                
ADDR_018A0C:        STA.W $163E,X             
ADDR_018A0F:        STZ.W $1528,X             
                    JMP.W ADDR_018913         
ADDR_018A15:        LDA.W $1534,X             
                    BEQ ADDR_018A88           
                    LDY.W $160E,X             
                    LDA.W $14C8,Y             
                    CMP.B #$0A                
                    BEQ ADDR_018A29           
                    STZ.W $1534,X             
                    BRA ADDR_018A62           
ADDR_018A29:        STA.W $1528,Y             
                    JSR.W ADDR_018008         
                    BEQ ADDR_018A38           
                    LDA.B #$00                
                    STA.W $00B6,Y             
                    STA $B6,X                 
ADDR_018A38:        JSR.W ADDR_01800E         
                    BEQ ADDR_018A62           
                    LDA $86                   
                    CMP.B #$01                
                    LDA.B #$02                
                    BCC ADDR_018A46           
                    LSR                       
ADDR_018A46:        STA $00                   
                    LDA.W $00B6,Y             
                    CMP.B #$02                
                    BCC ADDR_018A69           
                    BPL ADDR_018A57           
                    CLC                       
                    ADC $00                   
                    CLC                       
                    ADC $00                   
ADDR_018A57:        SEC                       
                    SBC $00                   
                    STA.W $00B6,Y             
                    STA $B6,X                 
                    JSR.W ADDR_01804E         
ADDR_018A62:        STZ.W $1570,X             
                    JSR.W ADDR_018B43         
                    RTS                       ; Return 

ADDR_018A69:        LDA.B #$00                
                    STA $B6,X                 
                    STA.W $00B6,Y             
                    STZ.W $1534,X             
                    LDA.B #$09                
                    STA.W $14C8,Y             
                    PHX                       
                    TYX                       
                    JSR.W ADDR_01AA0B         
                    LDA.W $1540,X             
                    BEQ ADDR_018A87           
                    LDA.B #$FF                
                    STA.W $1540,X             
ADDR_018A87:        PLX                       
ADDR_018A88:        LDA $C2,X                 
                    BEQ ADDR_018A9B           
                    DEC $C2,X                 
                    CMP.B #$08                
                    LDA.B #$04                
                    BCS ADDR_018A96           
                    LDA.B #$00                
ADDR_018A96:        STA.W $1602,X             
                    BRA ADDR_018B00           
ADDR_018A9B:        LDA.W $1558,X             
                    CMP.B #$01                
                    BNE ADDR_018B0A           
                    LDY.W $1594,X             
                    LDA.W $14C8,Y             
                    CMP.B #$08                
                    BCC ADDR_018AD9           
                    LDA.W $00AA,Y             
                    BMI ADDR_018AD9           
                    LDA.W $009E,Y             
                    CMP.B #$21                
                    BEQ ADDR_018AD9           
                    JSL.L ADDR_03B69F         
                    PHX                       
                    TYX                       
                    JSL.L ADDR_03B6E5         
                    PLX                       
                    JSL.L ADDR_03B72B         
                    BCC ADDR_018AD9           
                    JSR.W OffScrEraseSprite   
                    LDY.W $1594,X             
                    LDA.B #$10                
                    STA.W $1558,Y             
                    LDA $9E,X                 
                    STA.W $160E,Y             
ADDR_018AD9:        RTS                       ; Return 

ADDR_018ADA:        PHB                       
                    LDA.B #$02                
                    PHA                       
                    PLB                       
                    JSL.L ADDR_028086         ; Change bomb into explosion 
                    PLB                       
                    RTS                       ; Return 

ADDR_018AE5:        LDA.W $1534,X             
                    BNE ADDR_018ADA           
                    LDA.W $1540,X             
                    BNE ADDR_018AFC           
                    LDA.B #$09                
                    STA.W $14C8,X             
                    LDA.B #$40                
                    STA.W $1540,X             
                    JMP.W ADDR_019F0D         
ADDR_018AFC:        LDA $9D                   
                    BEQ ADDR_018B0A           
ADDR_018B00:        JSR.W ADDR_01A7E4         
ADDR_018B03:        JSR.W ADDR_01A40D         
                    JSR.W ADDR_018BC3         
                    RTS                       ; Return 

ADDR_018B0A:        JSR.W ADDR_01800E         
                    BEQ ADDR_018B2E           
                    LDY $9E,X                 
                    LDA.W Spr0to13Prop,Y      
                    LSR                       
                    LDY.W $157C,X             
                    BCC ADDR_018B1C           
                    INY                       
                    INY                       
ADDR_018B1C:        LDA.W Spr0to13SpeedX,Y    
                    EOR.W $15B8,X             
                    ASL                       
                    LDA.W Spr0to13SpeedX,Y    
                    BCC ADDR_018B2C           
                    CLC                       
                    ADC.W $15B8,X             
ADDR_018B2C:        STA $B6,X                 
ADDR_018B2E:        LDY.W $157C,X             
                    TYA                       
                    INC A                     
                    AND.W $1588,X             
                    AND.B #$03                
                    BEQ ADDR_018B3C           
                    STZ $B6,X                 
ADDR_018B3C:        JSR.W ADDR_018014         
                    BEQ ADDR_018B43           
                    STZ $AA,X                 
ADDR_018B43:        JSR.W ADDR_01AC31         
                    JSR.W ADDR_019032         
                    JSR.W ADDR_018E5F         
                    JSR.W ADDR_01800E         
                    BEQ ADDR_018B84           
                    JSR.W ADDR_019A04         
                    STZ.W $151C,X             
                    LDY $9E,X                 
                    LDA.W Spr0to13Prop,Y      
                    PHA                       
                    AND.B #$04                
                    BEQ ADDR_018B7A           
                    LDA.W $1570,X             
                    AND.B #$7F                
                    BNE ADDR_018B7A           
                    LDA.W $157C,X             
                    PHA                       
                    JSR.W FaceMario           
                    PLA                       
                    CMP.W $157C,X             
                    BEQ ADDR_018B7A           
                    LDA.B #$08                
                    STA.W $15AC,X             
ADDR_018B7A:        PLA                       
                    AND.B #$08                
                    BEQ ADDR_018B82           
                    JSR.W ADDR_018898         
ADDR_018B82:        BRA ADDR_018BB0           
ADDR_018B84:        LDY $9E,X                 
                    LDA.W Spr0to13Prop,Y      
                    BPL ADDR_018B90           
                    JSR.W ADDR_018E5F         
                    BRA ADDR_018B93           
ADDR_018B90:        STZ.W $1570,X             
ADDR_018B93:        LDA.W Spr0to13Prop,Y      
                    AND.B #$02                
                    BEQ ADDR_018BB0           
                    LDA.W $151C,X             
                    ORA.W $1558,X             
                    ORA.W $1528,X             
                    ORA.W $1534,X             
                    BNE ADDR_018BB0           
                    JSR.W ADDR_019098         
                    LDA.B #$01                
                    STA.W $151C,X             
ADDR_018BB0:        LDA.W $1528,X             
                    BEQ ADDR_018BBA           
                    JSR.W ADDR_018931         
                    BRA ADDR_018BBD           
ADDR_018BBA:        JSR.W ADDR_01A7E4         
ADDR_018BBD:        JSR.W ADDR_01A40D         
                    JSR.W ADDR_019089         
ADDR_018BC3:        LDA.W $157C,X             
                    PHA                       
                    LDY.W $15AC,X             
                    BEQ ADDR_018BDE           
                    LDA.B #$02                
                    STA.W $1602,X             
                    LDA.B #$00                
                    CPY.B #$05                
                    BCC ADDR_018BD8           
                    INC A                     
ADDR_018BD8:        EOR.W $157C,X             
                    STA.W $157C,X             
ADDR_018BDE:        LDY $9E,X                 
                    LDA.W Spr0to13Prop,Y      
                    AND.B #$40                
                    BNE ADDR_018BEC           
                    JSR.W ADDR_019F0D         
                    BRA ADDR_018C13           
ADDR_018BEC:        LDA.W $1602,X             
                    LSR                       
                    LDA $D8,X                 
                    PHA                       
                    SBC.B #$0F                
                    STA $D8,X                 
                    LDA.W $14D4,X             
                    PHA                       
                    SBC.B #$00                
                    STA.W $14D4,X             
                    JSR.W ADDR_019D67         
                    PLA                       
                    STA.W $14D4,X             
                    PLA                       
                    STA $D8,X                 
                    LDA $9E,X                 
                    CMP.B #$08                
                    BCC ADDR_018C13           
                    JSR.W ADDR_019E28         
ADDR_018C13:        PLA                       
                    STA.W $157C,X             
                    RTS                       ; Return 

ADDR_018C18:        LDA $9D                   
                    BNE ADDR_018C44           
                    LDA.W $14C8,X             
                    CMP.B #$08                
                    BNE ADDR_018C44           
                    JSR.W ADDR_018E5F         
                    JSR.W ADDR_019032         
                    DEC $AA,X                 
                    JSR.W ADDR_01800E         
                    BEQ ADDR_018C3E           
                    LDA.B #$13                
                    STA $9E,X                 
                    JSL.L ADDR_07F7D2         
                    JSR.W FaceMario           
                    JSR.W ADDR_0197D5         
ADDR_018C3E:        JSR.W ADDR_019089         
                    JSR.W ADDR_018FC1         
ADDR_018C44:        JSR.W ADDR_01AC31         
                    LDA.B #$02                
                    JSR.W ADDR_019CF3         
                    RTS                       ; Return 

ADDR_018C4D:        LDA $9D                   
                    BNE ADDR_018CB7           
                    LDY.W $157C,X             
                    LDA.W Spr0to13SpeedX,Y    
                    EOR.W $15B8,X             
                    ASL                       
                    LDA.W Spr0to13SpeedX,Y    
                    BCC ADDR_018C64           
                    CLC                       
                    ADC.W $15B8,X             
ADDR_018C64:        STA $B6,X                 
                    TYA                       
                    INC A                     
                    AND.W $1588,X             
                    AND.B #$03                
                    BEQ ADDR_018C71           
                    STZ $B6,X                 
ADDR_018C71:        LDA $9E,X                 
                    CMP.B #$08                
                    BNE ADDR_018C8C           
                    JSR.W ADDR_01ABCC         
                    LDY.B #$FC                
                    LDA.W $1570,X             
                    AND.B #$20                
                    BEQ ADDR_018C85           
                    LDY.B #$04                
ADDR_018C85:        STY $AA,X                 
                    JSR.W ADDR_01ABD8         
                    BRA ADDR_018C91           
ADDR_018C8C:        JSR.W ADDR_019032         
                    DEC $AA,X                 
ADDR_018C91:        JSR.W ADDR_018FC1         
                    JSR.W ADDR_018014         
                    BEQ ADDR_018C9B           
                    STZ $AA,X                 
ADDR_018C9B:        JSR.W ADDR_01800E         
                    BEQ ADDR_018CAE           
                    JSR.W ADDR_019A04         
                    LDA.B #$D0                
                    LDY.W $160E,X             
                    BNE ADDR_018CAC           
                    LDA.B #$B0                
ADDR_018CAC:        STA $AA,X                 
ADDR_018CAE:        JSR.W ADDR_019089         
                    JSR.W ADDR_018E5F         
                    JSR.W ADDR_01AC31         
ADDR_018CB7:        JMP.W ADDR_018BC3         

DATA_018CBA:        .db $FF,$01

DATA_018CBC:        .db $F0,$10

ADDR_018CBE:        JSR.W ADDR_01AC2B         
                    BRA ADDR_018CC6           
ADDR_018CC3:        JSR.W ADDR_01AC31         
ADDR_018CC6:        LDA $9D                   
                    BNE ADDR_018D2A           
                    LDA.W $157C,X             
                    PHA                       
                    JSR.W ADDR_019A15         
                    PLA                       
                    CMP.W $157C,X             
                    BEQ ADDR_018CDC           
                    LDA.B #$08                
                    STA.W $15AC,X             
ADDR_018CDC:        JSR.W ADDR_018E5F         
                    LDA $9E,X                 
                    CMP.B #$0A                
                    BNE ADDR_018CEA           
                    JSR.W ADDR_01ABD8         
                    BRA ADDR_018CFD           
ADDR_018CEA:        LDY.B #$FC                
                    LDA.W $1570,X             
                    AND.B #$20                
                    BEQ ADDR_018CF5           
                    LDY.B #$04                
ADDR_018CF5:        STY $AA,X                 
                    JSR.W ADDR_01ABD8         
                    JSR.W ADDR_01ABCC         
ADDR_018CFD:        LDA.W $1540,X             
                    BNE ADDR_018D27           
                    INC $C2,X                 
                    LDA $C2,X                 
                    AND.B #$03                
                    BNE ADDR_018D27           
                    LDA.W $151C,X             
                    AND.B #$01                
                    TAY                       
                    LDA $B6,X                 
                    CLC                       
                    ADC.W DATA_018CBA,Y       
                    STA $AA,X                 
                    STA $B6,X                 
                    CMP.W DATA_018CBC,Y       
                    BNE ADDR_018D27           
                    INC.W $151C,X             
                    LDA.B #$30                
                    STA.W $1540,X             
ADDR_018D27:        JSR.W ADDR_018FC1         
ADDR_018D2A:        JSR.W ADDR_018CB7         
                    RTS                       ; Return 

ADDR_018D2E:        JSR.W ADDR_01AC31         
                    LDA $9D                   
                    BEQ ADDR_018D39           
                    JSR.W ADDR_018DAC         
                    RTS                       ; Return 

ADDR_018D39:        JSR.W ADDR_018DBB         
                    JSR.W ADDR_019032         
                    DEC $AA,X                 
                    LDA $C2,X                 
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.B #$01                
                    STA.W $1602,X             
                    JSR.W ADDR_018DAC         
                    INC $C2,X                 
                    LDA.W $151C,X             
                    BNE ADDR_018D5F           
                    LDA $AA,X                 
                    BPL ADDR_018D5F           
                    INC.W $1570,X             
                    INC.W $1570,X             
ADDR_018D5F:        INC.W $1570,X             
                    JSR.W ADDR_018014         
                    BEQ ADDR_018D69           
                    STZ $AA,X                 
ADDR_018D69:        JSR.W ADDR_01800E         
                    BEQ ADDR_018DA5           
                    LDA $C2,X                 
                    AND.B #$3F                
                    BNE ADDR_018D77           
                    JSR.W FaceMario           
ADDR_018D77:        JSR.W ADDR_019A04         
                    LDA.W $151C,X             
                    BNE ADDR_018D82           
                    STZ.W $1570,X             
ADDR_018D82:        LDA.W $1540,X             
                    BNE ADDR_018DA5           
                    INC.W $151C,X             
                    LDY.B #$F0                
                    LDA.W $151C,X             
                    CMP.B #$04                
                    BNE ADDR_018DA3           
                    STZ.W $151C,X             
                    JSL.L ADDR_01ACF9         
                    AND.B #$3F                
                    ORA.B #$50                
                    STA.W $1540,X             
                    LDY.B #$D0                
ADDR_018DA3:        STY $AA,X                 
ADDR_018DA5:        JSR.W ADDR_019089         
                    JSR.W ADDR_018FC1         
                    RTS                       ; Return 

ADDR_018DAC:        JSR.W ADDR_018DE9         
                    LDA.W $15EA,X             
                    CLC                       
                    ADC.B #$04                
                    STA.W $15EA,X             
                    JMP.W ADDR_019F0D         
ADDR_018DBB:        LDA.B #$F8                
                    LDY.W $157C,X             
                    BNE ADDR_018DC4           
                    LDA.B #$08                
ADDR_018DC4:        STA $B6,X                 
                    RTS                       ; Return 


DATA_018DC7:        .db $F7,$0B,$F6,$0D,$FD,$0C,$FC,$0D
                    .db $0B,$F5,$0A,$F3,$0B,$FC,$0C,$FB
DATA_018DD7:        .db $F7,$F7,$F8,$F8,$01,$01,$02,$02
DATA_018DDF:        .db $46,$06

DATA_018DE1:        .db $C6,$C6,$5D,$5D

DATA_018DE5:        .db $02,$02,$00,$00

ADDR_018DE9:        JSR.W GetDrawInfoBnk1     
                    LDA.W $1570,X             
                    LSR                       
                    LSR                       
                    AND.B #$02                
                    CLC                       
                    ADC.W $1602,X             
                    STA $05                   
                    ASL                       
                    STA $02                   
                    LDA.W $157C,X             
                    STA $04                   
                    LDY.W $15EA,X             
                    PHX                       
                    LDX.B #$01                
ADDR_018E07:        STX $03                   
                    TXA                       
                    CLC                       
                    ADC $02                   
                    PHA                       
                    LDX $04                   
                    BNE ADDR_018E15           
                    CLC                       
                    ADC.B #$08                
ADDR_018E15:        TAX                       
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_018DC7,X       
                    STA.W $0300,Y             
                    PLX                       
                    LDA $01                   
                    CLC                       
                    ADC.W DATA_018DD7,X       
                    STA.W $0301,Y             
                    LDX $05                   
                    LDA.W DATA_018DE1,X       
                    STA.W $0302,Y             
                    PHY                       
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_018DE5,X       
                    STA.W $0460,Y             
                    PLY                       
                    LDX $03                   
                    LDA $04                   
                    LSR                       
                    LDA.W DATA_018DDF,X       
                    BCS ADDR_018E49           
                    EOR.B #$40                
ADDR_018E49:        ORA $64                   
                    STA.W $0303,Y             
                    TYA                       
                    CLC                       
                    ADC.B #$08                
                    TAY                       
                    DEX                       
                    BPL ADDR_018E07           
                    PLX                       
                    LDY.B #$FF                
                    LDA.B #$02                
                    JSR.W ADDR_01B7BB         
                    RTS                       ; Return 

ADDR_018E5F:        INC.W $1570,X             
                    LDA.W $1570,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.B #$01                
                    STA.W $1602,X             
                    RTS                       ; Return 


PiranhaSpeed:       .db $00,$F0,$00,$10

PiranhaTimeInState: .db $20,$30,$20,$30

ADDR_018E76:        LDA.W $1594,X             
                    BNE ADDR_018E9A           
                    LDA $64                   
                    PHA                       
                    LDA.W $15D0,X             
                    BNE ADDR_018E87           
                    LDA.B #$10                
                    STA $64                   
ADDR_018E87:        JSR.W ADDR_019D67         
                    LDY.W $15EA,X             
                    LDA.W $030B,Y             
                    AND.B #$F1                
                    ORA.B #$0B                
                    STA.W $030B,Y             
                    PLA                       
                    STA $64                   
ADDR_018E9A:        JSR.W ADDR_01AC31         
                    LDA $9D                   
                    BNE ADDR_018EC7           
                    JSR.W ADDR_018E5F         
                    LDA.W $1594,X             
                    BNE ADDR_018EAC           
                    JSR.W ADDR_018FC1         
ADDR_018EAC:        LDA $C2,X                 
                    AND.B #$03                
                    TAY                       
                    LDA.W $1540,X             
                    BEQ ADDR_018EC8           
                    LDA.W PiranhaSpeed,Y      
                    LDY $9E,X                 
                    CPY.B #$2A                
                    BNE ADDR_018EC2           
                    EOR.B #$FF                
                    INC A                     
ADDR_018EC2:        STA $AA,X                 
                    JSR.W ADDR_01ABD8         
ADDR_018EC7:        RTS                       ; Return 

ADDR_018EC8:        LDA $C2,X                 
                    AND.B #$03                
                    STA $00                   
                    BNE ADDR_018EE1           
                    JSR.W SubHorizPos         
                    LDA $0F                   
                    CLC                       
                    ADC.B #$1B                
                    CMP.B #$37                
                    LDA.B #$01                
                    STA.W $1594,X             
                    BCC ADDR_018EEE           
ADDR_018EE1:        STZ.W $1594,X             
                    LDY $00                   
                    LDA.W PiranhaTimeInState,Y 
                    STA.W $1540,X             
                    INC $C2,X                 
ADDR_018EEE:        RTS                       ; Return 

ADDR_018EEF:        LDY.B #$07                
ADDR_018EF1:        LDA.W $170B,Y             
                    BEQ ADDR_018F07           
                    DEY                       
                    BPL ADDR_018EF1           
                    DEC.W $18FC               
                    BPL ADDR_018F03           
                    LDA.B #$07                
                    STA.W $18FC               
ADDR_018F03:        LDY.W $18FC               
ADDR_018F06:        RTS                       ; Return 

ADDR_018F07:        LDA.W $15A0,X             
                    BNE ADDR_018F06           
                    RTS                       ; Return 

ADDR_018F0D:        LDA $9D                   
                    BNE ADDR_018F49           
                    INC.W $1602,X             
                    JSR.W ADDR_018E5F         
                    JSR.W ADDR_019032         
                    DEC $AA,X                 
                    JSR.W ADDR_018DBB         
                    ASL $B6,X                 
                    JSR.W ADDR_01800E         
                    BEQ ADDR_018F43           
                    STZ $B6,X                 
                    JSR.W ADDR_019A04         
                    LDA.W $1540,X             
                    BEQ ADDR_018F38           
                    DEC A                     
                    BNE ADDR_018F43           
                    JSR.W ADDR_018F50         
                    BRA ADDR_018F43           
ADDR_018F38:        JSL.L ADDR_01ACF9         
                    AND.B #$1F                
                    ORA.B #$20                
                    STA.W $1540,X             
ADDR_018F43:        JSR.W ADDR_019089         
                    JSR.W ADDR_01A7E4         
ADDR_018F49:        JSR.W ADDR_01AC31         
                    JSR.W ADDR_019F0D         
                    RTS                       ; Return 

ADDR_018F50:        JSL.L ADDR_01ACF9         
                    AND.B #$0F                
                    ORA.B #$D0                
                    STA $AA,X                 
                    LDA.W $148D               
                    AND.B #$03                
                    BNE ADDR_018F64           
                    JSR.W FaceMario           
ADDR_018F64:        JSR.W IsSprOffscreen      
                    BNE ADDR_018F96           
                    JSR.W ADDR_018EEF         
                    LDA $E4,X                 
                    CLC                       
                    ADC.B #$04                
                    STA.W $171F,Y             
                    LDA.W $14E0,X             
                    ADC.B #$00                
                    STA.W $1733,Y             
                    LDA $D8,X                 
                    CLC                       
                    ADC.B #$08                
                    STA.W $1715,Y             
                    LDA.W $14D4,X             
                    ADC.B #$00                
                    STA.W $1729,Y             
                    LDA.B #$03                
                    STA.W $170B,Y             
                    LDA.B #$FF                
                    STA.W $176F,Y             
ADDR_018F96:        RTS                       ; Return 

ADDR_018F97:        LDY.B #$00                
                    LDA.W $1558,X             
                    BEQ ADDR_018FA0           
                    LDY.B #$02                
ADDR_018FA0:        TYA                       
                    STA.W $1602,X             
                    JSR.W ADDR_019D67         
                    LDA.W $1558,X             
                    BEQ ADDR_018FB8           
                    LDY.W $15EA,X             
                    LDA.W $0305,Y             
                    SEC                       
                    SBC.B #$03                
                    STA.W $0305,Y             
ADDR_018FB8:        LDA.W $151C,X             
                    BEQ ADDR_018FC1           
                    JSL.L ADDR_02E672         
ADDR_018FC1:        JSR.W ADDR_01A40D         
                    JMP.W ADDR_01A7E4         

DATA_018FC7:        .db $42,$02,$03,$83,$03,$43,$03,$43
DATA_018FCF:        .db $00,$00,$01,$01,$02,$03,$03,$02
DATA_018FD7:        .db $20,$E0,$00,$00,$18,$18,$E8,$E8
DATA_018FDF:        .db $00,$00,$E0,$20,$E8,$18,$18,$E8

ADDR_018FE7:        LDA.B #$01                
                    STA.W $157C,X             
                    LDA $9D                   
                    BNE ADDR_019014           
                    LDY $C2,X                 
                    LDA.W DATA_018FC7,Y       
                    STA.W $15F6,X             
                    LDA.W DATA_018FCF,Y       
                    STA.W $1602,X             
                    LDA.W DATA_018FD7,Y       
                    STA $B6,X                 
                    LDA.W DATA_018FDF,Y       
                    STA $AA,X                 
                    JSR.W ADDR_01ABCC         
                    JSR.W ADDR_01ABD8         
                    JSR.W ADDR_019140         
                    JSR.W ADDR_018FC1         
ADDR_019014:        JSR.W ADDR_01AC31         
                    LDA $D8,X                 
                    SEC                       
                    SBC $1C                   
                    CMP.B #$F0                
                    BCC ADDR_019023           
                    STZ.W $14C8,X             
ADDR_019023:        LDA.W $1540,X             
                    BEQ ADDR_01902B           
                    JMP.W ADDR_019546         
ADDR_01902B:        JMP.W ADDR_019F0D         

DATA_01902E:        .db $40,$10

DATA_019030:        .db $03,$01

ADDR_019032:        JSR.W ADDR_01ABD8         
                    LDY.B #$00                
                    LDA.W $164A,X             
                    BEQ ADDR_019049           
                    INY                       
                    LDA $AA,X                 
                    BPL ADDR_019049           
                    CMP.B #$E8                
                    BCS ADDR_019049           
                    LDA.B #$E8                
                    STA $AA,X                 
ADDR_019049:        LDA $AA,X                 
                    CLC                       
                    ADC.W DATA_019030,Y       
                    STA $AA,X                 
                    BMI ADDR_01905D           
                    CMP.W DATA_01902E,Y       
                    BCC ADDR_01905D           
                    LDA.W DATA_01902E,Y       
                    STA $AA,X                 
ADDR_01905D:        LDA $B6,X                 
                    PHA                       
                    LDY.W $164A,X             
                    BEQ ADDR_019076           
                    ASL                       
                    ROR $B6,X                 
                    LDA $B6,X                 
                    PHA                       
                    STA $00                   
                    ASL                       
                    ROR $00                   
                    PLA                       
                    CLC                       
                    ADC $00                   
                    STA $B6,X                 
ADDR_019076:        JSR.W ADDR_01ABCC         
                    PLA                       
                    STA $B6,X                 
                    LDA.W $15DC,X             
                    BNE ADDR_019085           
                    JSR.W ADDR_019140         
                    RTS                       ; Return 

ADDR_019085:        STZ.W $1588,X             
                    RTS                       ; Return 

ADDR_019089:        LDA.W $157C,X             
                    INC A                     
                    AND.W $1588,X             
                    AND.B #$03                
                    BEQ ADDR_019097           
                    JSR.W ADDR_019098         
ADDR_019097:        RTS                       ; Return 

ADDR_019098:        LDA.W $15AC,X             
                    BNE ADDR_0190B1           
                    LDA.B #$08                
                    STA.W $15AC,X             
ADDR_0190A2:        LDA $B6,X                 
                    EOR.B #$FF                
                    INC A                     
                    STA $B6,X                 
                    LDA.W $157C,X             
                    EOR.B #$01                
                    STA.W $157C,X             
ADDR_0190B1:        RTS                       ; Return 

GenericSprGfxRt:    PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_019F0D         
                    PLB                       
                    RTL                       ; Return 


DATA_0190BA:        .db $0E,$02,$08,$08,$0E,$02,$07,$07
                    .db $07,$07,$07,$07,$0E,$02,$08,$08
                    .db $10,$00,$08,$08,$0D,$02,$08,$08
                    .db $07,$00,$04,$04,$1F,$01,$10,$10
                    .db $0F,$00,$08,$08,$10,$00,$08,$08
                    .db $0D,$02,$08,$08,$0E,$02,$08,$08
                    .db $0D,$02,$08,$08,$10,$00,$08,$08
                    .db $1F,$00,$10,$10,$08

DATA_0190F7:        .db $08,$08,$10,$02,$12,$12,$20,$02
                    .db $07,$07,$07,$07,$10,$10,$20,$0B
                    .db $12,$12,$20,$02,$18,$18,$20,$10
                    .db $04,$04,$08,$00,$10,$10,$1F,$01
                    .db $08,$08,$0F,$00,$08,$08,$10,$00
                    .db $48,$48,$50,$42,$04,$04,$08,$00
                    .db $00,$00,$00,$00,$08,$08,$10,$00
                    .db $08,$08,$10,$00,$04

DATA_019134:        .db $01,$02,$04,$08

ADDR_019138:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_019140         
                    PLB                       
                    RTL                       ; Return 

ADDR_019140:        STZ.W $1694               
                    STZ.W $1588,X             ; Set sprite's position status to 0 (in air) 
                    STZ.W $15B8,X             
                    STZ.W $185E               
                    LDA.W $164A,X             
                    STA.W $1695               
                    STZ.W $164A,X             
                    JSR.W ADDR_019211         
                    LDA $5B                   ; Vertical level flag 
                    BPL ADDR_0191BE           
                    INC.W $185E               
                    LDA $E4,X                 
                    CLC                       
                    ADC $26                   
                    STA $E4,X                 
                    LDA.W $14E0,X             
                    ADC $27                   
                    STA.W $14E0,X             
                    LDA $D8,X                 
                    CLC                       
                    ADC $28                   
                    STA $D8,X                 
                    LDA.W $14D4,X             
                    ADC $29                   
                    STA.W $14D4,X             
                    JSR.W ADDR_019211         
                    LDA $E4,X                 
                    SEC                       
                    SBC $26                   
                    STA $E4,X                 
                    LDA.W $14E0,X             
                    SBC $27                   
                    STA.W $14E0,X             
                    LDA $D8,X                 
                    SEC                       
                    SBC $28                   
                    STA $D8,X                 
                    LDA.W $14D4,X             
                    SBC $29                   
                    STA.W $14D4,X             
                    LDA.W $1588,X             
                    BPL ADDR_0191BE           
                    AND.B #$03                
                    BNE ADDR_0191BE           
                    LDY.B #$00                
                    LDA.W $17BF               
                    EOR.B #$FF                
                    INC A                     
                    BPL ADDR_0191B2           
                    DEY                       
ADDR_0191B2:        CLC                       
                    ADC $E4,X                 
                    STA $E4,X                 
                    TYA                       
                    ADC.W $14E0,X             
                    STA.W $14E0,X             
ADDR_0191BE:        LDA.W $190F,X             
                    BPL ADDR_0191ED           
                    LDA.W $1588,X             
                    AND.B #$03                
                    BEQ ADDR_0191ED           
                    TAY                       
                    LDA.W $15D0,X             
                    BNE ADDR_0191ED           
                    LDA $E4,X                 
                    CLC                       
                    ADC.W ADDR_019283,Y       
                    STA $E4,X                 
                    LDA.W $14E0,X             
                    ADC.W DATA_019285,Y       
                    STA.W $14E0,X             
                    LDA $B6,X                 
                    BNE ADDR_0191ED           
                    LDA.W $1588,X             
                    AND.B #$FC                
                    STA.W $1588,X             
ADDR_0191ED:        LDA.W $164A,X             
                    EOR.W $1695               
                    BEQ ADDR_019210           
                    ASL                       
                    LDA.W $166E,X             
                    AND.B #$40                
                    ORA.W $1FE2,X             
                    BNE ADDR_019210           
                    BCS ADDR_01920C           
                    BIT.W $0D9B               
                    BMI ADDR_01920C           
                    JSL.L ADDR_0284C0         
                    RTS                       ; Return 

ADDR_01920C:        JSL.L ADDR_028528         
ADDR_019210:        RTS                       ; Return 

ADDR_019211:        LDA.W $190E               
                    BEQ ADDR_01925B           
                    LDA $85                   
                    BNE ADDR_019258           
                    LDY.B #$3C                
                    JSR.W ADDR_01944D         
                    BEQ ADDR_019233           
                    LDA.W $1693               
                    CMP.B #$6E                
                    BCC ADDR_01925B           
                    JSL.L ADDR_00F04D         
                    LDA.W $1693               
                    BCC ADDR_01925B           
                    BCS ADDR_01923A           
ADDR_019233:        LDA.W $1693               
                    CMP.B #$06                
                    BCS ADDR_01925B           
ADDR_01923A:        TAY                       
                    LDA.W $164A,X             
                    ORA.B #$01                
                    CPY.B #$04                
                    BNE ADDR_019258           
                    PHA                       
                    LDA $9E,X                 
                    CMP.B #$35                
                    BEQ ADDR_019252           
                    LDA.W $167A,X             
                    AND.B #$02                
                    BNE ADDR_019255           
ADDR_019252:        JSR.W ADDR_019330         
ADDR_019255:        PLA                       
                    ORA.B #$80                
ADDR_019258:        STA.W $164A,X             
ADDR_01925B:        LDA.W $1686,X             
                    BMI ADDR_019210           
                    LDA.W $185E               
                    BEQ ADDR_01926F           
                    BIT.W $190E               
                    BVS ADDR_0192C0           
                    LDA.W $166E,X             
                    BMI ADDR_0192C0           
ADDR_01926F:        JSR.W ADDR_0192C9         
                    LDA.W $190F,X             
                    BPL ADDR_019288           
                    LDA $B6,X                 
                    ORA.W $15AC,X             
                    BNE ADDR_019288           
                    LDA $13                   
                    JSR.W ADDR_01928E         
ADDR_019283:        RTS                       ; Return 


DATA_019284:        .db $FC

DATA_019285:        .db $04,$FF,$00

ADDR_019288:        LDA $B6,X                 
                    BEQ ADDR_0192C0           
                    ASL                       
                    ROL                       
ADDR_01928E:        AND.B #$01                
                    TAY                       
                    JSR.W ADDR_019441         
                    STA.W $1862               
                    BEQ ADDR_0192BA           
                    LDA.W $1693               
                    CMP.B #$11                
                    BCC ADDR_0192BA           
                    CMP.B #$6E                
                    BCS ADDR_0192BA           
                    JSR.W ADDR_019425         
                    LDA.W $1693               
                    STA.W $18A7               
                    LDA.W $185E               
                    BEQ ADDR_0192BA           
                    LDA.W $1588,X             
                    ORA.B #$40                
                    STA.W $1588,X             
ADDR_0192BA:        LDA.W $1693               
                    STA.W $1860               
ADDR_0192C0:        RTS                       ; Return 


DATA_0192C1:        .db $FE,$02,$FF,$00

DATA_0192C5:        .db $01,$FF

DATA_0192C7:        .db $00,$FF

ADDR_0192C9:        LDY.B #$02                
                    LDA $AA,X                 
                    BPL ADDR_0192D0           
                    INY                       
ADDR_0192D0:        JSR.W ADDR_019441         
                    STA.W $18D7               
                    PHP                       
                    LDA.W $1693               
                    STA.W $185F               
                    PLP                       
                    BEQ ADDR_01930F           
                    LDA.W $1693               
                    CPY.B #$02                
                    BEQ ADDR_019310           
                    CMP.B #$11                
                    BCC ADDR_01930F           
                    CMP.B #$6E                
                    BCC ADDR_0192F9           
                    CMP.W $1430               
                    BCC ADDR_01930F           
                    CMP.W $1431               
                    BCS ADDR_01930F           
ADDR_0192F9:        JSR.W ADDR_019425         
                    LDA.W $1693               
                    STA.W $1868               
                    LDA.W $185E               
                    BEQ ADDR_01930F           
                    LDA.W $1588,X             
                    ORA.B #$20                
                    STA.W $1588,X             
ADDR_01930F:        RTS                       ; Return 

ADDR_019310:        CMP.B #$59                
                    BCC ADDR_01933B           
                    CMP.B #$5C                
                    BCS ADDR_01933B           
                    LDY.W $1931               
                    CPY.B #$0E                
                    BEQ ADDR_019323           
                    CPY.B #$03                
                    BNE ADDR_01933B           
ADDR_019323:        LDA $9E,X                 
                    CMP.B #$35                
                    BEQ ADDR_019330           
                    LDA.W $167A,X             
                    AND.B #$02                
                    BNE ADDR_01933B           
ADDR_019330:        LDA.B #$05                
                    STA.W $14C8,X             
                    LDA.B #$40                
                    STA.W $1558,X             
                    RTS                       ; Return 

ADDR_01933B:        CMP.B #$11                
                    BCC ADDR_0193B0           
                    CMP.B #$6E                
                    BCC ADDR_0193B8           
                    CMP.B #$D8                
                    BCS ADDR_019386           
                    JSL.L ADDR_00FA19         
                    LDA [$05],Y               
                    CMP.B #$10                
                    BEQ ADDR_0193AF           
                    BCS ADDR_019386           
                    LDA $00                   
                    CMP.B #$0C                
                    BCS ADDR_01935D           
                    CMP [$05],Y               
                    BCC ADDR_0193AF           
ADDR_01935D:        LDA [$05],Y               
                    STA.W $1694               
                    PHX                       
                    LDX $08                   
                    LDA.L DATA_00E53D,X       
                    PLX                       
                    STA.W $15B8,X             
                    CMP.B #$04                
                    BEQ ADDR_019375           
                    CMP.B #$FC                
                    BNE ADDR_019384           
ADDR_019375:        EOR $B6,X                 
                    BPL ADDR_019380           
                    LDA $B6,X                 
                    BEQ ADDR_019380           
                    JSR.W ADDR_019098         
ADDR_019380:        JSL.L ADDR_03C1CA         
ADDR_019384:        BRA ADDR_0193B8           
ADDR_019386:        LDA $0C                   
                    AND.B #$0F                
                    CMP.B #$05                
                    BCS ADDR_0193AF           
                    LDA.W $14C8,X             
                    CMP.B #$02                
                    BEQ ADDR_0193AF           
                    CMP.B #$05                
                    BEQ ADDR_0193AF           
                    CMP.B #$0B                
                    BEQ ADDR_0193AF           
                    LDA $D8,X                 
                    SEC                       
                    SBC.B #$01                
                    STA $D8,X                 
                    LDA.W $14D4,X             
                    SBC.B #$00                
                    STA.W $14D4,X             
                    JSR.W ADDR_0192C9         
ADDR_0193AF:        RTS                       ; Return 

ADDR_0193B0:        LDA $0C                   
                    AND.B #$0F                
                    CMP.B #$05                
                    BCS ADDR_019424           
ADDR_0193B8:        LDA.W $1686,X             
                    AND.B #$04                
                    BNE ADDR_019414           
                    LDA.W $14C8,X             
                    CMP.B #$02                
                    BEQ ADDR_019424           
                    CMP.B #$05                
                    BEQ ADDR_019424           
                    CMP.B #$0B                
                    BEQ ADDR_019424           
                    LDY.W $1693               
                    CPY.B #$0C                
                    BEQ ADDR_0193D9           
                    CPY.B #$0D                
                    BNE ADDR_019405           
ADDR_0193D9:        LDA $13                   
                    AND.B #$03                
                    BNE ADDR_019405           
                    JSR.W ADDR_018008         
                    BNE ADDR_019405           
                    LDA.W $1931               
                    CMP.B #$02                
                    BEQ ADDR_0193EF           
                    CMP.B #$08                
                    BNE ADDR_019405           
ADDR_0193EF:        TYA                       
                    SEC                       
                    SBC.B #$0C                
                    TAY                       
                    LDA $E4,X                 
                    CLC                       
                    ADC.W DATA_0192C5,Y       
                    STA $E4,X                 
                    LDA.W $14E0,X             
                    ADC.W DATA_0192C7,Y       
                    STA.W $14E0,X             
ADDR_019405:        LDA.W $15D0,X             
                    BNE ADDR_019414           
                    LDA $D8,X                 
                    AND.B #$F0                
                    CLC                       
                    ADC.W $1694               
                    STA $D8,X                 
ADDR_019414:        JSR.W ADDR_019435         
                    LDA.W $185E               
                    BEQ ADDR_019424           
                    LDA.W $1588,X             
                    ORA.B #$80                
                    STA.W $1588,X             
ADDR_019424:        RTS                       ; Return 

ADDR_019425:        LDA $0A                   
                    STA $9A                   
                    LDA $0B                   
                    STA $9B                   
                    LDA $0C                   
                    STA $98                   
                    LDA $0D                   
                    STA $99                   
ADDR_019435:        LDY $0F                   
                    LDA.W $1588,X             
                    ORA.W DATA_019134,Y       
                    STA.W $1588,X             
                    RTS                       ; Return 

ADDR_019441:        STY $0F                   
                    LDA.W $1656,X             
                    AND.B #$0F                
                    ASL                       
                    ASL                       
                    ADC $0F                   
                    TAY                       
ADDR_01944D:        LDA.W $185E               
                    INC A                     
                    AND $5B                   
                    BEQ ADDR_0194BF           
                    LDA $D8,X                 
                    CLC                       
                    ADC.W DATA_0190F7,Y       
                    STA $0C                   
                    AND.B #$F0                
                    STA $00                   
                    LDA.W $14D4,X             
                    ADC.B #$00                
                    CMP $5D                   
                    BCS ADDR_0194B4           
                    STA $0D                   
                    LDA $E4,X                 
                    CLC                       
                    ADC.W DATA_0190BA,Y       
                    STA $0A                   
                    STA $01                   
                    LDA.W $14E0,X             
                    ADC.B #$00                
                    CMP.B #$02                
                    BCS ADDR_0194B4           
                    STA $0B                   
                    LDA $01                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    ORA $00                   
                    STA $00                   
                    LDX $0D                   
                    LDA.L DATA_00BA80,X       
                    LDY.W $185E               
                    BEQ ADDR_01949A           
                    LDA.L DATA_00BA8E,X       
ADDR_01949A:        CLC                       
                    ADC $00                   
                    STA $05                   
                    LDA.L DATA_00BABC,X       
                    LDY.W $185E               
                    BEQ ADDR_0194AC           
                    LDA.L DATA_00BACA,X       
ADDR_0194AC:        ADC $0B                   
                    STA $06                   
                    JSR.W ADDR_019523         
                    RTS                       ; Return 

ADDR_0194B4:        LDY $0F                   
                    LDA.B #$00                
                    STA.W $1693               
                    STA.W $1694               
                    RTS                       ; Return 

ADDR_0194BF:        LDA $D8,X                 
                    CLC                       
                    ADC.W DATA_0190F7,Y       
                    STA $0C                   
                    AND.B #$F0                
                    STA $00                   
                    LDA.W $14D4,X             
                    ADC.B #$00                
                    STA $0D                   
                    REP #$20                  ; Accum (16 bit) 
                    LDA $0C                   
                    CMP.W #$01B0              
                    SEP #$20                  ; Accum (8 bit) 
                    BCS ADDR_0194B4           
                    LDA $E4,X                 
                    CLC                       
                    ADC.W DATA_0190BA,Y       
                    STA $0A                   
                    STA $01                   
                    LDA.W $14E0,X             
                    ADC.B #$00                
                    STA $0B                   
                    BMI ADDR_0194B4           
                    CMP $5D                   
                    BCS ADDR_0194B4           
                    LDA $01                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    ORA $00                   
                    STA $00                   
                    LDX $0B                   
                    LDA.L DATA_00BA60,X       
                    LDY.W $185E               
                    BEQ ADDR_01950D           
                    LDA.L DATA_00BA70,X       
ADDR_01950D:        CLC                       
                    ADC $00                   
                    STA $05                   
                    LDA.L DATA_00BA9C,X       
                    LDY.W $185E               
                    BEQ ADDR_01951F           
                    LDA.L DATA_00BAAC,X       
ADDR_01951F:        ADC $0D                   
                    STA $06                   
ADDR_019523:        LDA.B #$7E                
                    STA $07                   
                    LDX.W $15E9               
                    LDA [$05]                 
                    STA.W $1693               
                    INC $07                   
                    LDA [$05]                 
                    JSL.L ADDR_00F545         
                    LDY $0F                   
                    CMP.B #$00                
                    RTS                       ; Return 

ADDR_01953C:        LDA $9E,X                 
                    CMP.B #$2C                
                    BNE ADDR_019554           
                    LDA $C2,X                 
                    BEQ ADDR_01956A           
ADDR_019546:        LDA $64                   
                    PHA                       
                    LDA.B #$10                
                    STA $64                   
                    JSR.W ADDR_019F0D         
                    PLA                       
                    STA $64                   
                    RTS                       ; Return 

ADDR_019554:        CMP.B #$2F                
                    BEQ ADDR_019562           
                    CMP.B #$85                
                    BEQ ADDR_019562           
                    CMP.B #$7D                
                    BNE ADDR_01956A           
                    STZ $AA,X                 
ADDR_019562:        LDA.B #$08                
                    STA.W $14C8,X             
                    JMP.W ADDR_01A187         
ADDR_01956A:        LDA $9D                   
                    BEQ ADDR_019571           
                    JMP.W ADDR_0195F5         
ADDR_019571:        JSR.W ADDR_019624         
                    JSR.W ADDR_019032         
                    JSR.W ADDR_01800E         
                    BEQ ADDR_019598           
                    JSR.W ADDR_0197D5         
                    LDA $9E,X                 
                    CMP.B #$16                
                    BEQ ADDR_019589           
                    CMP.B #$15                
                    BNE ADDR_01958C           
ADDR_019589:        JMP.W ADDR_019562         
ADDR_01958C:        CMP.B #$2C                
                    BNE ADDR_019598           
                    LDA.B #$F0                
                    STA $AA,X                 
                    JSL.L ADDR_01F74C         
ADDR_019598:        JSR.W ADDR_018014         
                    BEQ ADDR_0195DB           
                    LDA.B #$10                
                    STA $AA,X                 
                    JSR.W ADDR_018008         
                    BNE ADDR_0195DB           
                    LDA $E4,X                 
                    CLC                       
                    ADC.B #$08                
                    STA $9A                   
                    LDA.W $14E0,X             
                    ADC.B #$00                
                    STA $9B                   
                    LDA $D8,X                 
                    AND.B #$F0                
                    STA $98                   
                    LDA.W $14D4,X             
                    STA $99                   
                    LDA.W $1588,X             
                    AND.B #$20                
                    ASL                       
                    ASL                       
                    ASL                       
                    ROL                       
                    AND.B #$01                
                    STA.W $1933               
                    LDY.B #$00                
                    LDA.W $1868               
                    JSL.L ADDR_00F160         
                    LDA.B #$08                
                    STA.W $1FE2,X             
ADDR_0195DB:        JSR.W ADDR_018008         
                    BEQ ADDR_0195F2           
                    LDA $9E,X                 
                    CMP.B #$0D                
                    BCC ADDR_0195E9           
                    JSR.W ADDR_01999E         
ADDR_0195E9:        LDA $B6,X                 
                    ASL                       
                    PHP                       
                    ROR $B6,X                 
                    PLP                       
                    ROR $B6,X                 
ADDR_0195F2:        JSR.W ADDR_018FC1         
ADDR_0195F5:        JSR.W ADDR_01A187         
                    JSR.W ADDR_01AC31         
                    RTS                       ; Return 


DATA_0195FC:        .db $00,$00,$00,$00,$04,$05,$06,$07
                    .db $00,$00,$00,$00,$04,$05,$06,$07
                    .db $00,$00,$00,$00,$04,$05,$06,$07
                    .db $00,$00,$00,$00,$04,$05,$06,$07
DATA_01961C:        .db $00,$00,$00,$00,$00,$01,$02,$03

ADDR_019624:        LDA $9E,X                 
                    CMP.B #$0D                
                    BNE ADDR_01965C           
                    LDA.W $1540,X             
                    CMP.B #$01                
                    BNE ADDR_01964E           
                    LDA.B #$09                ; \ Bomb sound effect 
                    STA.W $1DFC               ; / 
                    LDA.B #$01                
                    STA.W $1534,X             
                    LDA.B #$40                
                    STA.W $1540,X             
                    LDA.B #$08                
                    STA.W $14C8,X             
                    LDA.W $1686,X             
                    AND.B #$F7                
                    STA.W $1686,X             
                    RTS                       ; Return 

ADDR_01964E:        CMP.B #$40                
                    BCS ADDR_01965B           
                    ASL                       
                    AND.B #$0E                
                    EOR.W $15F6,X             
                    STA.W $15F6,X             
ADDR_01965B:        RTS                       ; Return 

ADDR_01965C:        LDA.W $1540,X             
                    ORA.W $1558,X             
                    STA $C2,X                 
                    LDA.W $1558,X             
                    BEQ ADDR_01969C           
                    CMP.B #$01                
                    BNE ADDR_01969C           
                    LDY.W $1594,X             
                    LDA.W $15D0,Y             
                    BNE ADDR_01969C           
                    JSL.L ADDR_07F78B         
                    JSR.W FaceMario           
                    ASL.W $15F6,X             
                    LSR.W $15F6,X             
                    LDY.W $160E,X             
                    LDA.B #$08                
                    CPY.B #$03                
                    BNE ADDR_019698           
                    INC.W $187B,X             
                    LDA.W $166E,X             
                    ORA.B #$30                
                    STA.W $166E,X             
                    LDA.B #$0A                
ADDR_019698:        STA.W $14C8,X             
ADDR_01969B:        RTS                       ; Return 

ADDR_01969C:        LDA.W $1540,X             
                    BEQ ADDR_01969B           
                    CMP.B #$03                
                    BEQ ADDR_0196A9           
                    CMP.B #$01                
                    BNE ADDR_0196D7           
ADDR_0196A9:        LDA $9E,X                 
                    CMP.B #$11                
                    BEQ ADDR_0196CB           
                    CMP.B #$2E                
                    BEQ ADDR_0196CB           
                    CMP.B #$2D                
                    BEQ ADDR_0196CA           
                    CMP.B #$A2                
                    BEQ ADDR_0196CB           
                    CMP.B #$0F                
                    BEQ ADDR_0196CB           
                    CMP.B #$2C                
                    BEQ ADDR_0196CA           
                    CMP.B #$53                
                    BNE ADDR_0196E1           
                    JSR.W ADDR_019ACB         
ADDR_0196CA:        RTS                       ; Return 

ADDR_0196CB:        LDA.B #$08                
                    STA.W $14C8,X             
                    ASL.W $15F6,X             
                    LSR.W $15F6,X             
                    RTS                       ; Return 

ADDR_0196D7:        LDA $13                   
                    AND.B #$01                
                    BNE ADDR_0196E0           
                    INC.W $1540,X             
ADDR_0196E0:        RTS                       ; Return 

ADDR_0196E1:        JSL.L ADDR_02A9E4         
                    BMI ADDR_0196CA           
                    LDA.B #$08                
                    STA.W $14C8,Y             
                    LDA $9E,X                 
                    TAX                       
                    LDA.W DATA_01961C,X       
                    STA.W $009E,Y             
                    TYX                       
                    JSL.L ADDR_07F7D2         
                    LDX.W $15E9               
                    LDA $E4,X                 
                    STA.W $00E4,Y             
                    LDA.W $14E0,X             
                    STA.W $14E0,Y             
                    LDA $D8,X                 
                    STA.W $00D8,Y             
                    LDA.W $14D4,X             
                    STA.W $14D4,Y             
                    LDA.B #$00                
                    STA.W $157C,Y             
                    LDA.B #$10                
                    STA.W $1564,Y             
                    LDA.W $164A,X             
                    STA.W $164A,Y             
                    LDA.W $1540,X             
                    STZ.W $1540,X             
                    CMP.B #$01                
                    BEQ ADDR_019747           
                    LDA.B #$D0                
                    STA.W $00AA,Y             
                    PHY                       
                    JSR.W SubHorizPos         
                    TYA                       
                    EOR.B #$01                
                    PLY                       
                    STA.W $157C,Y             
                    PHX                       
                    TAX                       
                    LDA.W Spr0to13SpeedX,X    
                    STA.W $00B6,Y             
                    PLX                       
                    RTS                       ; Return 

ADDR_019747:        PHY                       
                    JSR.W SubHorizPos         
                    LDA.W DATA_0197AD,Y       
                    STY $00                   
                    PLY                       
                    STA.W $00B6,Y             
                    LDA $00                   
                    EOR.B #$01                
                    STA.W $157C,Y             
                    STA $01                   
                    LDA.B #$10                
                    STA.W $154C,Y             
                    STA.W $1528,Y             
                    LDA $9E,X                 
                    CMP.B #$07                
                    BNE ADDR_019775           
                    LDY.B #$08                
ADDR_01976D:        LDA.W $14C8,Y             
                    BEQ ADDR_019776           
                    DEY                       
                    BPL ADDR_01976D           
ADDR_019775:        RTS                       ; Return 

ADDR_019776:        LDA.B #$08                
                    STA.W $14C8,Y             
                    LDA.B #$21                
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
                    PLX                       
                    LDA.B #$D0                
                    STA.W $00AA,Y             
                    LDA $01                   
                    STA.W $157C,Y             
                    LDA.B #$20                
                    STA.W $154C,Y             
                    RTS                       ; Return 


DATA_0197AD:        .db $C0,$40

DATA_0197AF:        .db $00,$00,$00,$F8,$F8,$F8,$F8,$F8
                    .db $F8,$F7,$F6,$F5,$F4,$F3,$F2,$E8
                    .db $E8,$E8,$E8,$00,$00,$00,$00,$FE
                    .db $FC,$F8,$EC,$EC,$EC,$E8,$E4,$E0
                    .db $DC,$D8,$D4,$D0,$CC,$C8

ADDR_0197D5:        LDA $B6,X                 
                    PHP                       
                    BPL ADDR_0197DD           
                    JSR.W ADDR_01804A         
ADDR_0197DD:        LSR                       
                    PLP                       
                    BPL ADDR_0197E4           
                    JSR.W ADDR_01804A         
ADDR_0197E4:        STA $B6,X                 
                    LDA $AA,X                 
                    PHA                       
                    JSR.W ADDR_019A04         
                    PLA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA $9E,X                 
                    CMP.B #$0F                
                    BNE ADDR_0197FB           
                    TYA                       
                    CLC                       
                    ADC.B #$13                
                    TAY                       
ADDR_0197FB:        LDA.W DATA_0197AF,Y       
                    LDY.W $1588,X             
                    BMI ADDR_019805           
                    STA $AA,X                 
ADDR_019805:        RTS                       ; Return 

ADDR_019806:        LDA.B #$06                
                    LDY.W $15EA,X             
                    BNE ADDR_01980F           
                    LDA.B #$08                
ADDR_01980F:        STA.W $1602,X             
                    LDA.W $15EA,X             
                    PHA                       
                    BEQ ADDR_01981B           
                    CLC                       
                    ADC.B #$08                
ADDR_01981B:        STA.W $15EA,X             
                    JSR.W ADDR_019F0D         
                    PLA                       
                    STA.W $15EA,X             
                    LDA.W $1EEB               
                    BMI ADDR_0198A6           
                    LDA.W $1602,X             
                    CMP.B #$06                
                    BNE ADDR_0198A6           
                    LDY.W $15EA,X             
                    LDA.W $1558,X             
                    BNE ADDR_019842           
                    LDA.W $1540,X             
                    BEQ ADDR_0198A6           
                    CMP.B #$30                
                    BCS ADDR_01984D           
ADDR_019842:        LSR                       
                    LDA.W $0308,Y             
                    ADC.B #$00                
                    BCS ADDR_01984D           
                    STA.W $0308,Y             
ADDR_01984D:        LDA $9E,X                 
                    CMP.B #$11                
                    BEQ ADDR_0198A6           
                    JSR.W IsSprOffscreen      
                    BNE ADDR_0198A6           
                    LDA.W $15F6,X             
                    ASL                       
                    LDA.B #$08                
                    BCC ADDR_019862           
                    LDA.B #$00                
ADDR_019862:        STA $00                   
                    LDA.W $0308,Y             
                    CLC                       
                    ADC.B #$02                
                    STA.W $0300,Y             
                    CLC                       
                    ADC.B #$04                
                    STA.W $0304,Y             
                    LDA.W $0309,Y             
                    CLC                       
                    ADC $00                   
                    STA.W $0301,Y             
                    STA.W $0305,Y             
                    PHY                       
                    LDY.B #$64                
                    LDA $14                   
                    AND.B #$F8                
                    BNE ADDR_01988A           
                    LDY.B #$4D                
ADDR_01988A:        TYA                       
                    PLY                       
                    STA.W $0302,Y             
                    STA.W $0306,Y             
                    LDA $64                   
                    STA.W $0303,Y             
                    STA.W $0307,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$00                
                    STA.W $0460,Y             
                    STA.W $0461,Y             
ADDR_0198A6:        RTS                       ; Return 


DATA_0198A7:        .db $E0,$20

ADDR_0198A9:        LDA $9D                   
                    BEQ ADDR_0198B0           
                    JMP.W ADDR_019A2A         
ADDR_0198B0:        JSR.W ADDR_019032         
                    LDA.W $151C,X             
                    AND.B #$1F                
                    BNE ADDR_0198BD           
                    JSR.W FaceMario           
ADDR_0198BD:        LDA $B6,X                 
                    LDY.W $157C,X             
                    CPY.B #$00                
                    BNE ADDR_0198D0           
                    CMP.B #$20                
                    BPL ADDR_0198D8           
                    INC $B6,X                 
                    INC $B6,X                 
                    BRA ADDR_0198D8           
ADDR_0198D0:        CMP.B #$E0                
                    BMI ADDR_0198D8           
                    DEC $B6,X                 
                    DEC $B6,X                 
ADDR_0198D8:        JSR.W ADDR_018008         
                    BEQ ADDR_0198EA           
                    PHA                       
                    JSR.W ADDR_01999E         
                    PLA                       
                    AND.B #$03                
                    TAY                       
                    LDA.W ADDR_0198A6,Y       
                    STA $B6,X                 
ADDR_0198EA:        JSR.W ADDR_01800E         
                    BEQ ADDR_0198F6           
                    JSR.W ADDR_019A04         
                    LDA.B #$10                
                    STA $AA,X                 
ADDR_0198F6:        JSR.W ADDR_018014         
                    BEQ ADDR_0198FD           
                    STZ $AA,X                 
ADDR_0198FD:        LDA $13                   
                    AND.B #$01                
                    BNE ADDR_01990D           
                    LDA.W $15F6,X             
                    INC A                     
                    INC A                     
                    AND.B #$CF                
                    STA.W $15F6,X             
ADDR_01990D:        JMP.W ADDR_01998C         

DATA_019910:        .db $F0,$EE,$EC

ADDR_019913:        LDA.W $187B,X             
                    BEQ ADDR_01991B           
                    JMP.W ADDR_0198A9         
ADDR_01991B:        LDA.W $167A,X             
                    AND.B #$10                
                    BEQ ADDR_019928           
                    JSR.W ADDR_01AA0B         
                    JMP.W ADDR_01A187         
ADDR_019928:        LDA.W $1528,X             
                    BNE ADDR_019939           
                    LDA $B6,X                 
                    CLC                       
                    ADC.B #$20                
                    CMP.B #$40                
                    BCS ADDR_019939           
                    JSR.W ADDR_01AA0B         
ADDR_019939:        STZ.W $1528,X             
                    LDA $9D                   
                    ORA.W $163E,X             
                    BEQ ADDR_019946           
                    JMP.W ADDR_01998F         
ADDR_019946:        JSR.W ADDR_019A15         
                    LDA.W $15B8,X             
                    PHA                       
                    JSR.W ADDR_019032         
                    PLA                       
                    BEQ ADDR_019969           
                    STA $00                   
                    LDY.W $164A,X             
                    BNE ADDR_019969           
                    CMP.W $15B8,X             
                    BEQ ADDR_019969           
                    EOR $B6,X                 
                    BMI ADDR_019969           
                    LDA.B #$F8                
                    STA $AA,X                 
                    BRA ADDR_019975           
ADDR_019969:        JSR.W ADDR_01800E         
                    BEQ ADDR_019984           
                    JSR.W ADDR_019A04         
                    LDA.B #$10                
                    STA $AA,X                 
ADDR_019975:        LDA.W $1860               
                    CMP.B #$B5                
                    BEQ ADDR_019980           
                    CMP.B #$B4                
                    BNE ADDR_019984           
ADDR_019980:        LDA.B #$B8                
                    STA $AA,X                 
ADDR_019984:        JSR.W ADDR_018008         
                    BEQ ADDR_01998C           
                    JSR.W ADDR_01999E         
ADDR_01998C:        JSR.W ADDR_018FC1         
ADDR_01998F:        JSR.W ADDR_01AC31         
                    LDA $9E,X                 
                    CMP.B #$53                
                    BEQ ADDR_01999B           
                    JMP.W ADDR_019A2A         
ADDR_01999B:        JMP.W ADDR_01A1D4         
ADDR_01999E:        LDA.B #$01                
                    STA.W $1DF9               ; / Play sound effect 
                    JSR.W ADDR_0190A2         
                    LDA.W $15A0,X             
                    BNE ADDR_0199D2           
                    LDA $E4,X                 
                    SEC                       
                    SBC $1A                   
                    CLC                       
                    ADC.B #$14                
                    CMP.B #$1C                
                    BCC ADDR_0199D2           
                    LDA.W $1588,X             
                    AND.B #$40                
                    ASL                       
                    ASL                       
                    ROL                       
                    AND.B #$01                
                    STA.W $1933               
                    LDY.B #$00                
                    LDA.W $18A7               
                    JSL.L ADDR_00F160         
                    LDA.B #$05                
                    STA.W $1FE2,X             
ADDR_0199D2:        LDA $9E,X                 
                    CMP.B #$53                
                    BNE ADDR_0199DB           
                    JSR.W ADDR_0199DC         
ADDR_0199DB:        RTS                       ; Return 

ADDR_0199DC:        STZ.W $14C8,X             
                    LDY.B #$FF                
ADDR_0199E1:        JSR.W IsSprOffscreen      
                    BNE ADDR_019A03           
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
                    TYA                       
                    JSL.L ShatterBlock        
                    PLB                       
ADDR_019A03:        RTS                       ; Return 

ADDR_019A04:        LDA.W $1588,X             
                    BMI ADDR_019A10           
                    LDA.B #$00                
                    LDY.W $15B8,X             
                    BEQ ADDR_019A12           
ADDR_019A10:        LDA.B #$18                
ADDR_019A12:        STA $AA,X                 
                    RTS                       ; Return 

ADDR_019A15:        LDA.B #$00                
                    LDY $B6,X                 
                    BEQ ADDR_019A21           
                    BPL ADDR_019A1E           
                    INC A                     
ADDR_019A1E:        STA.W $157C,X             
ADDR_019A21:        RTS                       ; Return 


DATA_019A22:        .db $06,$07,$08,$07

DATA_019A26:        .db $00,$00,$00,$40

ADDR_019A2A:        LDA $C2,X                 
                    STA.W $1558,X             
                    LDA $14                   
                    LSR                       
                    LSR                       
                    AND.B #$03                
                    TAY                       
                    PHY                       
                    LDA.W DATA_019A22,Y       
                    JSR.W ADDR_01980F         
                    STZ.W $1558,X             
                    PLY                       
                    LDA.W DATA_019A26,Y       
                    LDY.W $15EA,X             
                    EOR.W $030B,Y             
                    STA.W $030B,Y             
                    RTS                       ; Return 


DATA_019A4E:        .db $64,$62,$60,$62

ADDR_019A52:        LDA.W $1540,X             
                    BEQ ADDR_019A77           
                    JSR.W ADDR_019F0D         
                    LDY.W $15EA,X             
                    LDA.W $1540,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.B #$03                
                    PHX                       
                    TAX                       
                    LDA.W DATA_019A4E,X       
                    PLX                       
                    STA.W $0302,Y             
                    STA.W $0303,Y             
                    AND.B #$30                
                    STA.W $0303,Y             
                    RTS                       ; Return 

ADDR_019A77:        JSR.W OffScrEraseSprite   
                    RTS                       ; Return 

ADDR_019A7B:        LDA.W $1558,X             
                    BEQ ADDR_019A77           
                    LDA.B #$04                
                    STA $AA,X                 
                    ASL.W $190F,X             
                    LSR.W $190F,X             
                    LDA $B6,X                 
                    BEQ ADDR_019A9D           
                    BPL ADDR_019A94           
                    INC $B6,X                 
                    BRA ADDR_019A9D           
ADDR_019A94:        DEC $B6,X                 
                    JSR.W ADDR_018008         
                    BEQ ADDR_019A9D           
                    STZ $B6,X                 
ADDR_019A9D:        LDA.B #$01                
                    STA.W $1632,X             
ADDR_019AA2:        LDA $9E,X                 
                    CMP.B #$86                
                    BNE ADDR_019AAB           
                    JMP.W CallSpriteMain      
ADDR_019AAB:        CMP.B #$1E                
                    BNE ADDR_019AB4           
                    LDY.B #$FF                
                    STY.W $18E0               
ADDR_019AB4:        CMP.B #$53                
                    BNE ADDR_019ABC           
                    JSR.W ADDR_0199DC         
                    RTS                       ; Return 

ADDR_019ABC:        CMP.B #$4C                
                    BNE ADDR_019AC4           
                    JSL.L ADDR_02E463         
ADDR_019AC4:        LDA.W $1656,X             
                    AND.B #$80                
                    BEQ ADDR_019AD6           
ADDR_019ACB:        LDA.B #$04                
                    STA.W $14C8,X             
                    LDA.B #$1F                
                    STA.W $1540,X             
                    RTS                       ; Return 

ADDR_019AD6:        LDA $9D                   
                    BNE ADDR_019ADD           
                    JSR.W ADDR_019032         
ADDR_019ADD:        JSR.W ADDR_01AC31         
                    JSR.W ADDR_019B13         
                    RTS                       ; Return 

ADDR_019AE4:        LDA $9D                   
                    BNE ADDR_019AFE           
                    LDA.W $1540,X             
                    BNE ADDR_019AF1           
                    STZ.W $14C8,X             
                    RTS                       ; Return 

ADDR_019AF1:        JSR.W ADDR_019032         
                    JSR.W ADDR_01800E         
                    BEQ ADDR_019AFE           
                    JSR.W ADDR_019A04         
                    STZ $B6,X                 
ADDR_019AFE:        LDA $9E,X                 
                    CMP.B #$6F                
                    BNE ADDR_019B10           
                    JSR.W ADDR_019F0D         
                    LDY.W $15EA,X             
                    LDA.B #$AC                
                    STA.W $0302,Y             
                    RTS                       ; Return 

ADDR_019B10:        JMP.W ADDR_01E700         
ADDR_019B13:        LDA.W $167A,X             
                    AND.B #$01                
                    BEQ ADDR_019B1D           
                    JMP.W CallSpriteMain      
ADDR_019B1D:        STZ.W $1602,X             
                    LDA.W $190F,X             
                    AND.B #$20                
                    BEQ ADDR_019B64           
                    LDA.W $1662,X             
                    AND.B #$40                
                    BNE ADDR_019B5F           
                    LDA $9E,X                 
                    CMP.B #$1E                
                    BEQ ADDR_019B3D           
                    CMP.B #$4B                
                    BNE ADDR_019B44           
                    LDA.B #$01                
                    STA.W $1632,X             
ADDR_019B3D:        LDA.B #$01                
                    STA.W $1602,X             
                    BRA ADDR_019B4C           
ADDR_019B44:        LDA.W $15F6,X             
                    ORA.B #$80                
                    STA.W $15F6,X             
ADDR_019B4C:        LDA $64                   
                    PHA                       
                    LDY.W $1632,X             
                    BEQ ADDR_019B56           
                    LDA.B #$10                
ADDR_019B56:        STA $64                   
                    JSR.W ADDR_019D67         
                    PLA                       
                    STA $64                   
                    RTS                       ; Return 

ADDR_019B5F:        LDA.B #$06                
                    STA.W $1602,X             
ADDR_019B64:        LDA.B #$00                
                    CPY.B #$1C                
                    BEQ ADDR_019B6C           
                    LDA.B #$80                
ADDR_019B6C:        STA $00                   
                    LDA $64                   
                    PHA                       
                    LDY.W $1632,X             
                    BEQ ADDR_019B78           
                    LDA.B #$10                
ADDR_019B78:        STA $64                   
                    LDA $00                   
                    JSR.W ADDR_019F09         
                    PLA                       
                    STA $64                   
                    RTS                       ; Return 


SprTilemap:         .db $82

SprTilemap1:        .db $A0,$82,$A2,$84,$A4,$8C,$8A,$8E
                    .db $C8,$CA,$CA,$CE,$CC,$86,$4E,$E0
                    .db $E2,$E2,$CE,$E4,$E0,$E0,$A3,$A3
                    .db $B3,$B3,$E9,$E8,$F9,$F8,$E8,$E9
                    .db $F8,$F9,$E2,$E6,$AA,$A8,$A8,$AA
                    .db $A2,$A2,$B2,$B2,$C3,$C2,$D3,$D2
                    .db $C2,$C3,$D2,$D3,$E2,$E6,$CA,$CC
                    .db $CA,$AC,$CE,$AE,$CE,$83,$83,$C4
                    .db $C4,$83,$83,$C5,$C5,$8A,$A6,$A4
                    .db $A6,$A8,$80,$82,$80,$84,$84,$84
                    .db $84,$94,$94,$94,$94,$A0,$B0,$A0
                    .db $D0,$82,$80,$82,$00,$00,$00,$86
                    .db $84,$88,$EC,$8C,$A8,$AA,$8E,$AC
                    .db $AE,$8E,$EC,$EE,$CE,$EE,$A8,$EE
                    .db $40,$40,$A0,$C0,$A0,$C0,$A4,$C4
                    .db $A4,$C4,$A0,$C0,$A0,$C0,$40,$07
                    .db $27,$4C,$29,$4E,$2B,$82,$A0,$84
                    .db $A4,$67,$69,$88,$CE,$8E,$AE,$A2
                    .db $A2,$B2,$B2,$00,$40,$44,$42,$2C
                    .db $42,$28,$28,$28,$28,$4C,$4C,$4C
                    .db $4C,$83,$83,$6F,$6F,$AC,$BC,$AC
                    .db $A6,$8C,$AA,$86,$84,$DC,$EC,$DE
                    .db $EE,$06,$06,$16,$16,$07,$07,$17
                    .db $17,$16,$16,$06,$06,$17,$17,$07
                    .db $07,$84,$86,$00,$00,$00,$0E,$2A
                    .db $24,$02,$06,$0A,$20,$22,$28,$26
                    .db $2E,$40,$42,$0C,$04,$2B,$6A,$ED
                    .db $88,$8C,$A8,$8E,$AA,$AE,$8C,$88
                    .db $A8,$AE,$AC,$8C,$8E,$CE,$EE,$C4
                    .db $C6,$82,$84,$86,$8C,$CE,$CE,$88
                    .db $89,$CE,$CE,$89,$88,$F3,$CE,$F3
                    .db $CE,$A7,$A9

SprTilemapOffset:   .db $09,$09,$10,$09,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$37,$00,$25
                    .db $25,$5A,$00,$4B,$4E,$8A,$8A,$8A
                    .db $8A,$56,$3A,$46,$47,$69,$6B,$73
                    .db $00,$00,$80,$80,$80,$80,$8E,$90
                    .db $00,$00,$3A,$F6,$94,$95,$63,$9A
                    .db $A6,$AA,$AE,$B2,$C2,$C4,$D5,$D9
                    .db $D7,$D7,$E6,$E6,$E6,$E2,$99,$17
                    .db $29,$E6,$E6,$E6,$00,$E8,$00,$8A
                    .db $E8,$00,$ED,$EA,$7F,$EA,$EA,$3A
                    .db $3A,$FA,$71,$7F

DATA_019CD3:        .db $00,$08,$00,$08

DATA_019CD7:        .db $00,$00,$08,$08

DATA_019CDB:        .db $00,$00,$00,$00,$00,$40,$00,$40
                    .db $00,$40,$80,$C0,$40,$40,$00,$00
                    .db $40,$00,$C0,$80,$40,$40,$40,$40

ADDR_019CF3:        LDY.B #$00                
ADDR_019CF5:        STA $05                   
                    STY $0F                   
                    JSR.W GetDrawInfoBnk1     
                    LDY $0F                   
                    TYA                       
                    CLC                       
                    ADC $01                   
                    STA $01                   
                    LDY $9E,X                 
                    LDA.W $1602,X             
                    ASL                       
                    ASL                       
                    ADC.W SprTilemapOffset,Y  
                    STA $02                   
                    LDA.W $15F6,X             
                    ORA $64                   
                    STA $03                   
                    LDY.W $15EA,X             
                    LDA.B #$03                
                    STA $04                   
                    PHX                       
ADDR_019D1F:        LDX $04                   
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_019CD3,X       
                    STA.W $0300,Y             
                    LDA $01                   
                    CLC                       
                    ADC.W DATA_019CD7,X       
                    STA.W $0301,Y             
                    LDA $02                   
                    CLC                       
                    ADC $04                   
                    TAX                       
                    LDA.W SprTilemap,X        
                    STA.W $0302,Y             
                    LDA $05                   
                    ASL                       
                    ASL                       
                    ADC $04                   
                    TAX                       
                    LDA.W DATA_019CDB,X       
                    ORA $03                   
                    STA.W $0303,Y             
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEC $04                   
                    BPL ADDR_019D1F           
                    PLX                       
                    LDA.B #$03                
                    LDY.B #$00                
                    JSR.W ADDR_01B7BB         
                    RTS                       ; Return 

ADDR_019D5F:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_019D67         
                    PLB                       
                    RTL                       ; Return 

ADDR_019D67:        LDA.W $15F6,X             
                    BPL ADDR_019D70           
                    JSR.W ADDR_019DD9         
                    RTS                       ; Return 

ADDR_019D70:        JSR.W GetDrawInfoBnk1     
                    LDA.W $157C,X             
                    STA $02                   
                    TYA                       
                    LDY $9E,X                 
                    CPY.B #$0F                
                    BCS ADDR_019D81           
                    ADC.B #$04                
ADDR_019D81:        TAY                       
                    PHY                       
                    LDY $9E,X                 
                    LDA.W $1602,X             
                    ASL                       
                    CLC                       
                    ADC.W SprTilemapOffset,Y  
                    TAX                       
                    PLY                       
                    LDA.W SprTilemap,X        
                    STA.W $0302,Y             
                    LDA.W SprTilemap1,X       
                    STA.W $0306,Y             
                    LDX.W $15E9               
                    LDA $01                   
                    STA.W $0301,Y             
                    CLC                       
                    ADC.B #$10                
                    STA.W $0305,Y             
ADDR_019DA9:        LDA $00                   
                    STA.W $0300,Y             
                    STA.W $0304,Y             
                    LDA.W $157C,X             
                    LSR                       
                    LDA.B #$00                
                    ORA.W $15F6,X             
                    BCS ADDR_019DBE           
                    ORA.B #$40                
ADDR_019DBE:        ORA $64                   
                    STA.W $0303,Y             
                    STA.W $0307,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$02                
                    ORA.W $15A0,X             
                    STA.W $0460,Y             
                    STA.W $0461,Y             
                    JSR.W ADDR_01A3DF         
                    RTS                       ; Return 

ADDR_019DD9:        JSR.W GetDrawInfoBnk1     
                    LDA.W $157C,X             
                    STA $02                   
                    TYA                       
                    CLC                       
                    ADC.B #$08                
                    TAY                       
                    PHY                       
                    LDY $9E,X                 
                    LDA.W $1602,X             
                    ASL                       
                    CLC                       
                    ADC.W SprTilemapOffset,Y  
                    TAX                       
                    PLY                       
                    LDA.W SprTilemap,X        
                    STA.W $0306,Y             
                    LDA.W SprTilemap1,X       
                    STA.W $0302,Y             
                    LDX.W $15E9               
                    LDA $01                   
                    STA.W $0301,Y             
                    CLC                       
                    ADC.B #$10                
                    STA.W $0305,Y             
                    JMP.W ADDR_019DA9         

DATA_019E10:        .db $FF,$F7,$09,$09

DATA_019E14:        .db $FF,$FF,$00,$00

DATA_019E18:        .db $FC,$F4,$FC,$F4

DATA_019E1C:        .db $5D,$C6,$5D,$C6

DATA_019E20:        .db $46,$46,$06,$06

DATA_019E24:        .db $00,$02,$00,$02

ADDR_019E28:        LDY.B #$00                
                    JSR.W ADDR_01800E         
                    BNE ADDR_019E35           
                    LDA.W $1602,X             
                    AND.B #$01                
                    TAY                       
ADDR_019E35:        STY $02                   
ADDR_019E37:        LDA.W $186C,X             
                    BNE ADDR_019E94           
                    LDA $E4,X                 
                    STA $00                   
                    LDA.W $14E0,X             
                    STA $04                   
                    LDA $D8,X                 
                    STA $01                   
                    LDY.W $15EA,X             
                    PHX                       
                    LDA.W $157C,X             
                    ASL                       
                    ADC $02                   
                    TAX                       
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_019E10,X       
                    STA $00                   
                    LDA $04                   
                    ADC.W DATA_019E14,X       
                    PHA                       
                    LDA $00                   
                    SEC                       
                    SBC $1A                   
                    STA.W $0300,Y             
                    PLA                       
                    SBC $1B                   
                    BNE ADDR_019E93           
                    LDA $01                   
                    SEC                       
                    SBC $1C                   
                    CLC                       
                    ADC.W DATA_019E18,X       
                    STA.W $0301,Y             
                    LDA.W DATA_019E1C,X       
                    STA.W $0302,Y             
                    LDA $64                   
                    ORA.W DATA_019E20,X       
                    STA.W $0303,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_019E24,X       
                    STA.W $0460,Y             
ADDR_019E93:        PLX                       
ADDR_019E94:        RTS                       ; Return 

ADDR_019E95:        LDA $D8,X                 
                    PHA                       
                    CLC                       
                    ADC.B #$02                
                    STA $D8,X                 
                    LDA.W $14D4,X             
                    PHA                       
                    ADC.B #$00                
                    STA.W $14D4,X             
                    LDA $E4,X                 
                    PHA                       
                    SEC                       
                    SBC.B #$02                
                    STA $E4,X                 
                    LDA.W $14E0,X             
                    PHA                       
                    SBC.B #$00                
                    STA.W $14E0,X             
                    LDA.W $15EA,X             
                    PHA                       
                    CLC                       
                    ADC.B #$04                
                    STA.W $15EA,X             
                    LDA.W $157C,X             
                    PHA                       
                    STZ.W $157C,X             
                    LDA.W $1570,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.B #$01                
                    TAY                       
                    JSR.W ADDR_019E35         
                    LDA $E4,X                 
                    CLC                       
                    ADC.B #$04                
                    STA $E4,X                 
                    LDA.W $14E0,X             
                    ADC.B #$00                
                    STA.W $14E0,X             
                    LDA.W $15EA,X             
                    CLC                       
                    ADC.B #$04                
                    STA.W $15EA,X             
                    INC.W $157C,X             
                    JSR.W ADDR_019E37         
                    PLA                       
                    STA.W $157C,X             
                    PLA                       
                    STA.W $15EA,X             
                    PLA                       
                    STA.W $14E0,X             
                    PLA                       
                    STA $E4,X                 
                    PLA                       
                    STA.W $14D4,X             
                    PLA                       
                    STA $D8,X                 
                    RTS                       ; Return 

ADDR_019F09:        STA $04                   
                    BRA ADDR_019F0F           
ADDR_019F0D:        STZ $04                   
ADDR_019F0F:        JSR.W GetDrawInfoBnk1     
                    LDA.W $157C,X             
                    STA $02                   
                    LDY $9E,X                 
                    LDA.W $1602,X             
                    CLC                       
                    ADC.W SprTilemapOffset,Y  
                    LDY.W $15EA,X             
                    TAX                       
                    LDA.W SprTilemap,X        
                    STA.W $0302,Y             
                    LDX.W $15E9               
                    LDA $00                   
                    STA.W $0300,Y             
                    LDA $01                   
                    STA.W $0301,Y             
                    LDA.W $157C,X             
                    LSR                       
                    LDA.B #$00                
                    ORA.W $15F6,X             
                    BCS ADDR_019F44           
                    EOR.B #$40                
ADDR_019F44:        ORA $04                   
                    ORA $64                   
                    STA.W $0303,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$02                
                    ORA.W $15A0,X             
                    STA.W $0460,Y             
                    JSR.W ADDR_01A3DF         
                    RTS                       ; Return 


DATA_019F5B:        .db $0B,$F5,$04,$FC,$04,$00

DATA_019F61:        .db $00,$FF,$00,$FF,$00,$00

DATA_019F67:        .db $F3,$0D

DATA_019F69:        .db $FF,$00

DATA_019F6B:        .db $D2,$2E,$CC,$34,$00,$10

ADDR_019F71:        JSR.W ADDR_019F9B         
                    LDA.W $13DD               
                    BNE ADDR_019F83           
                    LDA.W $1419               
                    BNE ADDR_019F83           
                    LDA.W $1499               
                    BEQ ADDR_019F86           
ADDR_019F83:        STZ.W $15EA,X             
ADDR_019F86:        LDA $64                   
                    PHA                       
                    LDA.W $1419               
                    BEQ ADDR_019F92           
                    LDA.B #$10                
                    STA $64                   
ADDR_019F92:        JSR.W ADDR_01A187         
                    PLA                       
                    STA $64                   
                    RTS                       ; Return 


DATA_019F99:        .db $FC,$04

ADDR_019F9B:        LDA $9E,X                 
                    CMP.B #$7D                
                    BNE ADDR_019FE0           
                    LDA $13                   
                    AND.B #$03                
                    BNE ADDR_019FBE           
                    DEC.W $1891               
                    BEQ ADDR_019FC4           
                    LDA.W $1891               
                    CMP.B #$30                
                    BCS ADDR_019FBE           
                    LDY.B #$01                
                    AND.B #$04                
                    BEQ ADDR_019FBB           
                    LDY.B #$09                
ADDR_019FBB:        STY.W $13F3               
ADDR_019FBE:        LDA $71                   
                    CMP.B #$01                
                    BCC ADDR_019FCA           
ADDR_019FC4:        STZ.W $13F3               
                    JMP.W OffScrEraseSprite   
ADDR_019FCA:        PHB                       
                    LDA.B #$02                
                    PHA                       
                    PLB                       
                    JSL.L ADDR_02D214         
                    PLB                       
                    JSR.W ADDR_01A0B1         
                    LDY.W $15EA,X             
                    LDA.B #$F0                
                    STA.W $0301,Y             
                    RTS                       ; Return 

ADDR_019FE0:        JSR.W ADDR_019140         
                    LDA $71                   
                    CMP.B #$01                
                    BCC ADDR_019FF4           
                    LDA.W $1419               
                    BNE ADDR_019FF4           
                    LDA.B #$09                
                    STA.W $14C8,X             
                    RTS                       ; Return 

ADDR_019FF4:        LDA.W $14C8,X             
                    CMP.B #$08                
                    BEQ ADDR_01A014           
                    LDA $9D                   
                    BEQ ADDR_01A002           
                    JMP.W ADDR_01A0B1         
ADDR_01A002:        JSR.W ADDR_019624         
                    JSR.W ADDR_01A40D         
                    LDA.W $1419               
                    BNE ADDR_01A011           
                    BIT $15                   
                    BVC ADDR_01A015           
ADDR_01A011:        JSR.W ADDR_01A0B1         
ADDR_01A014:        RTS                       ; Return 

ADDR_01A015:        STZ.W $1626,X             
                    LDY.B #$00                
                    LDA $9E,X                 
                    CMP.B #$0F                
                    BNE ADDR_01A026           
                    LDA $72                   
                    BNE ADDR_01A026           
                    LDY.B #$EC                
ADDR_01A026:        STY $AA,X                 
                    LDA.B #$09                
                    STA.W $14C8,X             
                    LDA $15                   
                    AND.B #$08                
                    BNE ADDR_01A068           
                    LDA $9E,X                 
                    CMP.B #$15                
                    BCS ADDR_01A041           
                    LDA $15                   
                    AND.B #$04                
                    BEQ ADDR_01A079           
                    BRA ADDR_01A047           
ADDR_01A041:        LDA $15                   
                    AND.B #$03                
                    BNE ADDR_01A079           
ADDR_01A047:        LDY $76                   
                    LDA $D1                   
                    CLC                       
                    ADC.W DATA_019F67,Y       
                    STA $E4,X                 
                    LDA $D2                   
                    ADC.W DATA_019F69,Y       
                    STA.W $14E0,X             
                    JSR.W SubHorizPos         
                    LDA.W DATA_019F99,Y       
                    CLC                       
                    ADC $7B                   
                    STA $B6,X                 
                    STZ $AA,X                 
                    BRA ADDR_01A0A6           
ADDR_01A068:        JSL.L ADDR_01AB6F         
                    LDA.B #$90                
                    STA $AA,X                 
                    LDA $7B                   
                    STA $B6,X                 
                    ASL                       
                    ROR $B6,X                 
                    BRA ADDR_01A0A6           
ADDR_01A079:        JSL.L ADDR_01AB6F         
                    LDA.W $1540,X             
                    STA $C2,X                 
                    LDA.B #$0A                
                    STA.W $14C8,X             
                    LDY $76                   
                    LDA.W $187A               
                    BEQ ADDR_01A090           
                    INY                       
                    INY                       
ADDR_01A090:        LDA.W DATA_019F6B,Y       
                    STA $B6,X                 
                    EOR $7B                   
                    BMI ADDR_01A0A6           
                    LDA $7B                   
                    STA $00                   
                    ASL $00                   
                    ROR                       
                    CLC                       
                    ADC.W DATA_019F6B,Y       
                    STA $B6,X                 
ADDR_01A0A6:        LDA.B #$10                
                    STA.W $154C,X             
                    LDA.B #$0C                
                    STA.W $149A               
                    RTS                       ; Return 

ADDR_01A0B1:        LDY.B #$00                
                    LDA $76                   
                    BNE ADDR_01A0B8           
                    INY                       
ADDR_01A0B8:        LDA.W $1499               
                    BEQ ADDR_01A0C4           
                    INY                       
                    INY                       
                    CMP.B #$05                
                    BCC ADDR_01A0C4           
                    INY                       
ADDR_01A0C4:        LDA.W $1419               
                    BEQ ADDR_01A0CD           
                    CMP.B #$02                
                    BEQ ADDR_01A0D4           
ADDR_01A0CD:        LDA.W $13DD               
                    ORA $74                   
                    BEQ ADDR_01A0D6           
ADDR_01A0D4:        LDY.B #$05                
ADDR_01A0D6:        PHY                       
                    LDY.B #$00                
                    LDA.W $1471               
                    CMP.B #$03                
                    BEQ ADDR_01A0E2           
                    LDY.B #$3D                
ADDR_01A0E2:        LDA.W $0094,Y             
                    STA $00                   
                    LDA.W $0095,Y             
                    STA $01                   
                    LDA.W $0096,Y             
                    STA $02                   
                    LDA.W $0097,Y             
                    STA $03                   
                    PLY                       
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_019F5B,Y       
                    STA $E4,X                 
                    LDA $01                   
                    ADC.W DATA_019F61,Y       
                    STA.W $14E0,X             
                    LDA.B #$0D                
                    LDY $73                   
                    BNE ADDR_01A111           
                    LDY $19                   
                    BNE ADDR_01A113           
ADDR_01A111:        LDA.B #$0F                
ADDR_01A113:        LDY.W $1498               
                    BEQ ADDR_01A11A           
                    LDA.B #$0F                
ADDR_01A11A:        CLC                       
                    ADC $02                   
                    STA $D8,X                 
                    LDA $03                   
                    ADC.B #$00                
                    STA.W $14D4,X             
                    LDA.B #$01                
                    STA.W $148F               
                    STA.W $1470               
                    RTS                       ; Return 

ADDR_01A12F:        LDA $14                   
                    LSR                       
                    LSR                       
                    LDY.W $1540,X             
                    CPY.B #$30                
                    BCC ADDR_01A13B           
                    LSR                       
ADDR_01A13B:        AND.B #$01                
                    STA.W $1602,X             
                    CPY.B #$08                
                    BNE ADDR_01A14D           
                    JSR.W ADDR_01800E         
                    BEQ ADDR_01A14D           
                    LDA.B #$D8                
                    STA $AA,X                 
ADDR_01A14D:        LDA.B #$80                
                    JMP.W ADDR_019F09         
ADDR_01A152:        LDA $1A                   
                    PHA                       
                    LDA.W $1540,X             
                    CMP.B #$30                
                    BCS ADDR_01A162           
                    AND.B #$01                
                    EOR $1A                   
                    STA $1A                   
ADDR_01A162:        JSL.L ADDR_03B307         
                    PLA                       
                    STA $1A                   
ADDR_01A169:        LDA.W $14C8,X             
                    CMP.B #$0B                
                    BNE ADDR_01A177           
                    LDA $76                   
                    EOR.B #$01                
                    STA.W $157C,X             
ADDR_01A177:        RTS                       ; Return 

ADDR_01A178:        JSR.W ADDR_018E5F         
                    LDA.W $15F6,X             
                    ORA.B #$80                
                    STA.W $15F6,X             
                    JSR.W ADDR_019F0D         
                    RTS                       ; Return 

ADDR_01A187:        LDA.W $167A,X             
                    AND.B #$08                
                    BEQ ADDR_01A1D0           
                    LDA $9E,X                 
                    CMP.B #$A2                
                    BEQ ADDR_01A152           
                    CMP.B #$15                
                    BEQ ADDR_01A178           
                    CMP.B #$16                
                    BEQ ADDR_01A178           
                    CMP.B #$0F                
                    BEQ ADDR_01A12F           
                    CMP.B #$53                
                    BEQ ADDR_01A1D4           
                    CMP.B #$2C                
                    BEQ ADDR_01A1E8           
                    CMP.B #$80                
                    BEQ ADDR_01A1F3           
                    CMP.B #$7D                
                    BEQ ADDR_01A1D3           
                    CMP.B #$3E                
                    BEQ ADDR_01A1FD           
                    CMP.B #$2F                
                    BEQ ADDR_01A229           
                    CMP.B #$0D                
                    BEQ ADDR_01A1EC           
                    CMP.B #$2D                
                    BEQ ADDR_01A22C           
                    CMP.B #$85                
                    BNE ADDR_01A1D0           
                    JSR.W ADDR_019F0D         
                    LDY.W $15EA,X             
                    LDA.B #$47                
                    STA.W $0302,Y             
                    RTS                       ; Return 

ADDR_01A1D0:        JSR.W ADDR_019806         
ADDR_01A1D3:        RTS                       ; Return 

ADDR_01A1D4:        LDA.W $1540,X             
                    CMP.B #$40                
                    BCS ADDR_01A1DE           
                    LSR                       
                    BCS ADDR_01A1E8           
ADDR_01A1DE:        LDA.W $15F6,X             
                    INC A                     
                    INC A                     
                    AND.B #$0F                
                    STA.W $15F6,X             
ADDR_01A1E8:        JSR.W ADDR_019F0D         
                    RTS                       ; Return 

ADDR_01A1EC:        JSR.W ADDR_019F0D         
                    LDA.B #$CA                
                    BRA ADDR_01A222           
ADDR_01A1F3:        JSR.W ADDR_01A169         
                    JSR.W ADDR_019F0D         
                    LDA.B #$EC                
                    BRA ADDR_01A222           
ADDR_01A1FD:        LDY.W $163E,X             
                    BEQ ADDR_01A218           
                    CPY.B #$01                
                    BNE ADDR_01A209           
                    JMP.W ADDR_019ACB         
ADDR_01A209:        JSR.W ADDR_01E700         
                    LDY.W $15EA,X             
                    LDA.W $0303,Y             
                    AND.B #$FE                
                    STA.W $0303,Y             
                    RTS                       ; Return 

ADDR_01A218:        LDA.B #$01                
                    STA.W $157C,X             
                    JSR.W ADDR_019F0D         
                    LDA.B #$42                
ADDR_01A222:        LDY.W $15EA,X             
                    STA.W $0302,Y             
                    RTS                       ; Return 

ADDR_01A229:        JMP.W ADDR_01E6F0         
ADDR_01A22C:        LDA $9D                   
                    BNE ADDR_01A27B           
                    LDA $E4,X                 
                    CLC                       
                    ADC.B #$08                
                    STA $00                   
                    LDA.W $14E0,X             
                    ADC.B #$00                
                    STA $08                   
                    LDA $D8,X                 
                    CLC                       
                    ADC.B #$08                
                    STA $01                   
                    LDA.W $14D4,X             
                    ADC.B #$00                
                    STA $09                   
                    JSL.L ADDR_02B9FA         
                    JSL.L ADDR_02EA4E         
                    LDA.W $163E,X             
                    BNE ADDR_01A27E           
                    DEC A                     
                    STA.W $160E,X             
                    LDA.W $14C8,X             
                    CMP.B #$09                
                    BNE ADDR_01A26D           
                    JSR.W ADDR_01800E         
                    BEQ ADDR_01A26D           
                    LDA.B #$F0                
                    STA $AA,X                 
ADDR_01A26D:        LDY.B #$00                
                    LDA $14                   
                    AND.B #$18                
                    BNE ADDR_01A277           
                    LDY.B #$03                
ADDR_01A277:        TYA                       
                    STA.W $1602,X             
ADDR_01A27B:        JMP.W ADDR_01A34F         
ADDR_01A27E:        STZ.W $15EA,X             
                    CMP.B #$20                
                    BEQ ADDR_01A288           
                    JMP.W ADDR_01A30A         
ADDR_01A288:        LDY.W $160E,X             
                    LDA.B #$00                
                    STA.W $14C8,Y             
                    LDA.B #$06                
                    STA.W $1DF9               ; / Play sound effect 
                    LDA.W $160E,Y             
                    BNE ADDR_01A2F4           
                    LDA.W $009E,Y             
                    CMP.B #$81                
                    BNE ADDR_01A2AD           
                    LDA $14                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.B #$03                
                    TAY                       
                    LDA.W DATA_01C313,Y       
ADDR_01A2AD:        CMP.B #$74                
                    BCC ADDR_01A2F4           
                    CMP.B #$78                
                    BCS ADDR_01A2F4           
ADDR_01A2B5:        STZ.W $18AC               
                    STZ.W $141E               
                    LDA.B #$35                
                    STA.W $009E,X             
                    LDA.B #$08                
                    STA.W $14C8,X             
                    LDA.B #$1F                
                    STA.W $1DFC               ; / Play sound effect 
                    LDA $D8,X                 
                    SBC.B #$10                
                    STA $D8,X                 
                    LDA.W $14D4,X             
                    SBC.B #$00                
                    STA.W $14D4,X             
                    LDA.W $15F6,X             
                    PHA                       
                    JSL.L ADDR_07F7D2         
                    PLA                       
                    AND.B #$FE                
                    STA.W $15F6,X             
                    LDA.B #$0C                
                    STA.W $1602,X             
                    DEC.W $160E,X             
                    LDA.B #$40                
                    STA.W $18E8               
                    RTS                       ; Return 

ADDR_01A2F4:        INC.W $1570,X             
                    LDA.W $1570,X             
                    CMP.B #$05                
                    BNE ADDR_01A300           
                    BRA ADDR_01A2B5           
ADDR_01A300:        JSL.L ADDR_05B34A         
                    LDA.B #$01                
                    JSL.L GivePoints          
ADDR_01A30A:        LDA.W $163E,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_01A35A,Y       
                    STA.W $1602,X             
                    STZ $01                   
                    LDA.W $163E,X             
                    CMP.B #$20                
                    BCC ADDR_01A34F           
                    SBC.B #$10                
                    LSR                       
                    LSR                       
                    LDY.W $157C,X             
                    BEQ ADDR_01A32E           
                    EOR.B #$FF                
                    INC A                     
                    DEC $01                   
ADDR_01A32E:        LDY.W $160E,X             
                    CLC                       
                    ADC $E4,X                 
                    STA.W $00E4,Y             
                    LDA.W $14E0,X             
                    ADC $01                   
                    STA.W $14E0,Y             
                    LDA $D8,X                 
                    SEC                       
                    SBC.B #$02                
                    STA.W $00D8,Y             
                    LDA.W $14D4,X             
                    SBC.B #$00                
                    STA.W $14D4,Y             
ADDR_01A34F:        JSR.W ADDR_01A169         
                    JSR.W ADDR_019F0D         
                    JSL.L ADDR_02EA25         
                    RTS                       ; Return 


DATA_01A35A:        .db $00,$03,$02,$02,$01,$01,$01

DATA_01A361:        .db $10,$20

DATA_01A363:        .db $01,$02

GetDrawInfoBnk1:    STZ.W $186C,X             
                    STZ.W $15A0,X             
                    LDA $E4,X                 
                    CMP $1A                   
                    LDA.W $14E0,X             
                    SBC $1B                   
                    BEQ ADDR_01A379           
                    INC.W $15A0,X             
ADDR_01A379:        LDA.W $14E0,X             
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
                    BNE ADDR_01A3CB           
                    LDY.B #$00                
                    LDA.W $14C8,X             
                    CMP.B #$09                
                    BEQ ADDR_01A3A6           
                    LDA.W $190F,X             
                    AND.B #$20                
                    BEQ ADDR_01A3A6           
                    INY                       
ADDR_01A3A6:        LDA $D8,X                 
                    CLC                       
                    ADC.W DATA_01A361,Y       
                    PHP                       
                    CMP $1C                   
                    ROL $00                   
                    PLP                       
                    LDA.W $14D4,X             
                    ADC.B #$00                
                    LSR $00                   
                    SBC $1D                   
                    BEQ ADDR_01A3C6           
                    LDA.W $186C,X             
                    ORA.W DATA_01A363,Y       
                    STA.W $186C,X             
ADDR_01A3C6:        DEY                       
                    BPL ADDR_01A3A6           
                    BRA ADDR_01A3CD           
ADDR_01A3CB:        PLA                       
                    PLA                       
ADDR_01A3CD:        LDY.W $15EA,X             
                    LDA $E4,X                 
                    SEC                       
                    SBC $1A                   
                    STA $00                   
                    LDA $D8,X                 
                    SEC                       
                    SBC $1C                   
                    STA $01                   
                    RTS                       ; Return 

ADDR_01A3DF:        LDA.W $186C,X             
                    BEQ ADDR_01A40A           
                    PHX                       
                    LSR                       
                    BCC ADDR_01A3F8           
                    PHA                       
                    LDA.B #$01                
                    STA.W $0460,Y             
                    TYA                       
                    ASL                       
                    ASL                       
                    TAX                       
                    LDA.B #$80                
                    STA.W $0300,X             
                    PLA                       
ADDR_01A3F8:        LSR                       
                    BCC ADDR_01A409           
                    LDA.B #$01                
                    STA.W $0461,Y             
                    TYA                       
                    ASL                       
                    ASL                       
                    TAX                       
                    LDA.B #$80                
                    STA.W $0304,X             
ADDR_01A409:        PLX                       
ADDR_01A40A:        RTS                       ; Return 


DATA_01A40B:        .db $02,$0A

ADDR_01A40D:        TXA                       
                    BEQ ADDR_01A40A           
                    TAY                       
                    EOR $13                   
                    LSR                       
                    BCC ADDR_01A40A           
                    DEX                       
ADDR_01A417:        LDA.W $14C8,X             
                    CMP.B #$08                
                    BCS ADDR_01A421           
                    JMP.W ADDR_01A4B0         
ADDR_01A421:        LDA.W $1686,X             
                    ORA.W $1686,Y             
                    AND.B #$08                
                    ORA.W $1564,X             
                    ORA.W $1564,Y             
                    ORA.W $15D0,X             
                    ORA.W $1632,X             
                    EOR.W $1632,Y             
                    BNE ADDR_01A4B0           
                    STX.W $1695               
                    LDA $E4,X                 
                    STA $00                   
                    LDA.W $14E0,X             
                    STA $01                   
                    LDA.W $00E4,Y             
                    STA $02                   
                    LDA.W $14E0,Y             
                    STA $03                   
                    REP #$20                  ; Accum (16 bit) 
                    LDA $00                   
                    SEC                       
                    SBC $02                   
                    CLC                       
                    ADC.W #$0010              
                    CMP.W #$0020              
                    SEP #$20                  ; Accum (8 bit) 
                    BCS ADDR_01A4B0           
                    LDY.B #$00                
                    LDA.W $1662,X             
                    AND.B #$0F                
                    BEQ ADDR_01A46C           
                    INY                       
ADDR_01A46C:        LDA $D8,X                 
                    CLC                       
                    ADC.W DATA_01A40B,Y       
                    STA $00                   
                    LDA.W $14D4,X             
                    ADC.B #$00                
                    STA $01                   
                    LDY.W $15E9               
                    LDX.B #$00                
                    LDA.W $1662,Y             
                    AND.B #$0F                
                    BEQ ADDR_01A488           
                    INX                       
ADDR_01A488:        LDA.W $00D8,Y             
                    CLC                       
                    ADC.W DATA_01A40B,X       
                    STA $02                   
                    LDA.W $14D4,Y             
                    ADC.B #$00                
                    STA $03                   
                    LDX.W $1695               
                    REP #$20                  ; Accum (16 bit) 
                    LDA $00                   
                    SEC                       
                    SBC $02                   
                    CLC                       
                    ADC.W #$000C              
                    CMP.W #$0018              
                    SEP #$20                  ; Accum (8 bit) 
                    BCS ADDR_01A4B0           
                    JSR.W ADDR_01A4BA         
ADDR_01A4B0:        DEX                       
                    BMI ADDR_01A4B6           
                    JMP.W ADDR_01A417         
ADDR_01A4B6:        LDX.W $15E9               
                    RTS                       ; Return 

ADDR_01A4BA:        LDA.W $14C8,Y             
                    CMP.B #$08                
                    BEQ ADDR_01A4CE           
                    CMP.B #$09                
                    BEQ ADDR_01A4E2           
                    CMP.B #$0A                
                    BEQ ADDR_01A506           
                    CMP.B #$0B                
                    BEQ ADDR_01A51A           
                    RTS                       ; Return 

ADDR_01A4CE:        LDA.W $14C8,X             
                    CMP.B #$08                
                    BEQ ADDR_01A53D           
                    CMP.B #$09                
                    BEQ ADDR_01A540           
                    CMP.B #$0A                
                    BEQ ADDR_01A537           
                    CMP.B #$0B                
                    BEQ ADDR_01A534           
                    RTS                       ; Return 

ADDR_01A4E2:        LDA.W $1588,Y             
                    AND.B #$04                
                    BNE ADDR_01A4F2           
                    LDA.W $009E,Y             
                    CMP.B #$0F                
                    BEQ ADDR_01A534           
                    BRA ADDR_01A506           
ADDR_01A4F2:        LDA.W $14C8,X             
                    CMP.B #$08                
                    BEQ ADDR_01A540           
                    CMP.B #$09                
                    BEQ ADDR_01A555           
                    CMP.B #$0A                
                    BEQ ADDR_01A53A           
                    CMP.B #$0B                
                    BEQ ADDR_01A534           
                    RTS                       ; Return 

ADDR_01A506:        LDA.W $14C8,X             
                    CMP.B #$08                
                    BEQ ADDR_01A52E           
                    CMP.B #$09                
                    BEQ ADDR_01A531           
                    CMP.B #$0A                
                    BEQ ADDR_01A534           
                    CMP.B #$0B                
                    BEQ ADDR_01A534           
                    RTS                       ; Return 

ADDR_01A51A:        LDA.W $14C8,X             
                    CMP.B #$08                
                    BEQ ADDR_01A534           
                    CMP.B #$09                
                    BEQ ADDR_01A534           
                    CMP.B #$0A                
                    BEQ ADDR_01A534           
                    CMP.B #$0B                
                    BEQ ADDR_01A534           
                    RTS                       ; Return 

ADDR_01A52E:        JMP.W ADDR_01A625         
ADDR_01A531:        JMP.W ADDR_01A642         
ADDR_01A534:        JMP.W ADDR_01A685         
ADDR_01A537:        JMP.W ADDR_01A5C4         
ADDR_01A53A:        JMP.W ADDR_01A5C4         
ADDR_01A53D:        JMP.W ADDR_01A56D         
ADDR_01A540:        JSR.W ADDR_01A6D9         
                    PHX                       
                    PHY                       
                    TYA                       
                    TXY                       
                    TAX                       
                    JSR.W ADDR_01A6D9         
                    PLY                       
                    PLX                       
                    LDA.W $1558,X             
                    ORA.W $1558,Y             
                    BNE ADDR_01A5C3           
ADDR_01A555:        LDA.W $14C8,X             
                    CMP.B #$09                
                    BNE ADDR_01A56D           
                    JSR.W ADDR_01800E         
                    BNE ADDR_01A56D           
                    LDA $9E,X                 
                    CMP.B #$0F                
                    BNE ADDR_01A56A           
                    JMP.W ADDR_01A685         
ADDR_01A56A:        JMP.W ADDR_01A5C4         
ADDR_01A56D:        LDA $E4,X                 
                    SEC                       
                    SBC.W $00E4,Y             
                    LDA.W $14E0,X             
                    SBC.W $14E0,Y             
                    ROL                       
                    AND.B #$01                
                    STA $00                   
                    LDA.W $1686,Y             
                    AND.B #$10                
                    BNE ADDR_01A5A1           
                    LDY.W $15E9               
                    LDA.W $157C,Y             
                    PHA                       
                    LDA $00                   
                    STA.W $157C,Y             
                    PLA                       
                    CMP.W $157C,Y             
                    BEQ ADDR_01A5A1           
                    LDA.W $15AC,Y             
                    BNE ADDR_01A5A1           
                    LDA.B #$08                
                    STA.W $15AC,Y             
ADDR_01A5A1:        LDA.W $1686,X             
                    AND.B #$10                
                    BNE ADDR_01A5C3           
                    LDA.W $157C,X             
                    PHA                       
                    LDA $00                   
                    EOR.B #$01                
                    STA.W $157C,X             
                    PLA                       
                    CMP.W $157C,X             
                    BEQ ADDR_01A5C3           
                    LDA.W $15AC,X             
                    BNE ADDR_01A5C3           
                    LDA.B #$08                
                    STA.W $15AC,X             
ADDR_01A5C3:        RTS                       ; Return 

ADDR_01A5C4:        LDA.W $009E,Y             
                    SEC                       
                    SBC.B #$83                
                    CMP.B #$02                
                    BCS ADDR_01A5DA           
                    JSR.W ADDR_019098         
                    STZ $AA,X                 
ADDR_01A5D3:        PHX                       
                    TYX                       
                    JSR.W ADDR_01B4E2         
                    PLX                       
                    RTS                       ; Return 

ADDR_01A5DA:        LDX.W $15E9               
                    LDY.W $1695               
                    JSR.W ADDR_01A77C         
                    LDA.B #$02                
                    STA.W $14C8,Y             
                    PHX                       
                    TYX                       
                    JSL.L ADDR_01AB72         
                    PLX                       
                    LDA $B6,X                 
                    ASL                       
                    LDA.B #$10                
                    BCC ADDR_01A5F8           
                    LDA.B #$F0                
ADDR_01A5F8:        STA.W $00B6,Y             
                    LDA.B #$D0                
                    STA.W $00AA,Y             
                    PHY                       
                    INC.W $1626,X             
                    LDY.W $1626,X             
                    CPY.B #$08                
                    BCS ADDR_01A611           
                    LDA.W ADDR_01A61D,Y       
                    STA.W $1DF9               ; / Play sound effect 
ADDR_01A611:        TYA                       
                    CMP.B #$08                
                    BCC ADDR_01A618           
                    LDA.B #$08                
ADDR_01A618:        PLY                       
                    JSL.L ADDR_02ACE1         
ADDR_01A61D:        RTS                       ; Return 


DATA_01A61E:        .db $13,$14,$15,$16,$17,$18,$19

ADDR_01A625:        LDA $9E,X                 
                    SEC                       
                    SBC.B #$83                
                    CMP.B #$02                
                    BCS ADDR_01A63D           
                    PHX                       
                    TYX                       
                    JSR.W ADDR_019098         
                    PLX                       
                    LDA.B #$00                
                    STA.W $00AA,Y             
                    JSR.W ADDR_01B4E2         
                    RTS                       ; Return 

ADDR_01A63D:        JSR.W ADDR_01A77C         
                    BRA ADDR_01A64A           
ADDR_01A642:        JSR.W ADDR_01800E         
                    BNE ADDR_01A64A           
                    JMP.W ADDR_01A685         
ADDR_01A64A:        PHX                       
                    LDA.W $1626,Y             
                    INC A                     
                    STA.W $1626,Y             
                    LDX.W $1626,Y             
                    CPX.B #$08                
                    BCS ADDR_01A65F           
                    LDA.W ADDR_01A61D,X       
                    STA.W $1DF9               ; / Play sound effect 
ADDR_01A65F:        TXA                       
                    CMP.B #$08                
                    BCC ADDR_01A666           
                    LDA.B #$08                
ADDR_01A666:        PLX                       
                    JSL.L GivePoints          
                    LDA.B #$02                
                    STA.W $14C8,X             
                    JSL.L ADDR_01AB72         
                    LDA.W $00B6,Y             
                    ASL                       
                    LDA.B #$10                
                    BCC ADDR_01A67E           
                    LDA.B #$F0                
ADDR_01A67E:        STA $B6,X                 
                    LDA.B #$D0                
                    STA $AA,X                 
                    RTS                       ; Return 

ADDR_01A685:        LDA $9E,X                 
                    CMP.B #$83                
                    BEQ ADDR_01A69A           
                    CMP.B #$84                
                    BEQ ADDR_01A69A           
                    LDA.B #$02                
                    STA.W $14C8,X             
                    LDA.B #$D0                
                    STA $AA,X                 
                    BRA ADDR_01A69D           
ADDR_01A69A:        JSR.W ADDR_01B4E2         
ADDR_01A69D:        LDA.W $009E,Y             
                    CMP.B #$80                
                    BEQ ADDR_01A6BB           
                    CMP.B #$83                
                    BEQ ADDR_01A6B8           
                    CMP.B #$84                
                    BEQ ADDR_01A6B8           
                    LDA.B #$02                
                    STA.W $14C8,Y             
                    LDA.B #$D0                
                    STA.W $00AA,Y             
                    BRA ADDR_01A6BB           
ADDR_01A6B8:        JSR.W ADDR_01A5D3         
ADDR_01A6BB:        JSL.L ADDR_01AB6F         
                    LDA.B #$04                
                    JSL.L GivePoints          
                    LDA $B6,X                 
                    ASL                       
                    LDA.B #$10                
                    BCS ADDR_01A6CE           
                    LDA.B #$F0                
ADDR_01A6CE:        STA $B6,X                 
                    EOR.B #$FF                
                    INC A                     
                    STA.W $00B6,Y             
                    RTS                       ; Return 


DATA_01A6D7:        .db $30,$D0

ADDR_01A6D9:        STY $00                   
                    JSR.W ADDR_01800E         
                    BEQ ADDR_01A72D           
                    LDA.W $1588,Y             
                    AND.B #$04                
                    BEQ ADDR_01A72D           
                    LDA.W $1656,X             
                    AND.B #$40                
                    BEQ ADDR_01A72D           
                    LDA.W $1558,Y             
                    ORA.W $1558,X             
                    BNE ADDR_01A72D           
                    STZ $02                   
                    LDA $E4,X                 
                    SEC                       
                    SBC.W $00E4,Y             
                    BMI ADDR_01A702           
                    INC $02                   
ADDR_01A702:        CLC                       
                    ADC.B #$08                
                    CMP.B #$10                
                    BCC ADDR_01A72D           
                    LDA.W $157C,X             
                    CMP $02                   
                    BNE ADDR_01A72D           
                    LDA $9E,X                 
                    CMP.B #$02                
                    BNE ADDR_01A72E           
                    LDA.B #$20                
                    STA.W $163E,X             
                    STA.W $1558,X             
                    LDA.B #$23                
                    STA.W $1564,X             
                    TYA                       
                    STA.W $160E,X             
                    RTS                       ; Return 

ADDR_01A728:        LDA.B #$03                
                    STA.W $1DF9               ; / Play sound effect 
ADDR_01A72D:        RTS                       ; Return 

ADDR_01A72E:        LDA.W $1540,Y             
                    BNE ADDR_01A777           
                    LDA.W $009E,Y             
                    CMP.B #$0F                
                    BCS ADDR_01A777           
                    LDA.W $1588,Y             
                    AND.B #$04                
                    BEQ ADDR_01A777           
                    LDA.W $15F6,Y             
                    BPL ADDR_01A75D           
                    AND.B #$7F                
                    STA.W $15F6,Y             
                    LDA.B #$E0                
                    STA.W $00AA,Y             
                    LDA.B #$20                
                    STA.W $1564,Y             
ADDR_01A755:        LDA.B #$20                
                    STA $C2,X                 
                    STA.W $1558,X             
                    RTS                       ; Return 

ADDR_01A75D:        LDA.B #$E0                
                    STA $AA,X                 
                    LDA.W $164A,X             
                    CMP.B #$01                
                    LDA.B #$18                
                    BCC ADDR_01A76C           
                    LDA.B #$2C                
ADDR_01A76C:        STA.W $1558,X             
                    TXA                       
                    STA.W $1594,Y             
                    TYA                       
                    STA.W $1594,X             
ADDR_01A777:        RTS                       ; Return 


DATA_01A778:        .db $10,$F0

DATA_01A77A:        .db $00,$FF

ADDR_01A77C:        LDA $9E,X                 
                    CMP.B #$02                
                    BNE ADDR_01A7C2           
                    LDA.W $187B,Y             
                    BNE ADDR_01A7C2           
                    LDA.W $157C,X             
                    CMP.W $157C,Y             
                    BEQ ADDR_01A7C2           
                    STY $01                   
                    LDY.W $1534,X             
                    BNE ADDR_01A7C0           
                    STZ.W $1528,X             

Instr01A799:        .db $9E,$3E

ADDR_01A79B:        .db $16

                    TAY                       
                    STY $00                   
                    LDA $E4,X                 
                    CLC                       
                    ADC.W DATA_01A778,Y       
                    LDY $01                   
                    STA.W $00E4,Y             
                    LDA.W $14E0,X             
                    LDY $00                   
                    ADC.W DATA_01A77A,Y       
                    LDY $01                   
                    STA.W $14E0,Y             
                    TYA                       
                    STA.W $160E,X             
                    LDA.B #$01                
                    STA.W $1534,X             
ADDR_01A7C0:        PLA                       
                    PLA                       
ADDR_01A7C2:        LDX.W $1695               
                    LDY.W $15E9               
                    RTS                       ; Return 


DATA_01A7C9:        .db $00,$01,$02,$03,$04,$05,$06,$07
                    .db $04,$04,$05,$05,$07,$00,$00,$0F
                    .db $0F,$0F,$0D

MarioSprInteract:   PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_01A7E4         
                    PLB                       
                    RTL                       ; Return 

ADDR_01A7E4:        LDA.W $167A,X             
                    AND.B #$20                
                    BNE ADDR_01A7F7           
                    TXA                       
                    EOR $13                   
                    AND.B #$01                
                    ORA.W $15A0,X             
                    BEQ ADDR_01A7F7           
ADDR_01A7F5:        CLC                       
                    RTS                       ; Return 

ADDR_01A7F7:        JSR.W SubHorizPos         
                    LDA $0F                   
                    CLC                       
                    ADC.B #$50                
                    CMP.B #$A0                
                    BCS ADDR_01A7F5           
                    JSR.W ADDR_01AD42         
                    LDA $0E                   
                    CLC                       
                    ADC.B #$60                
                    CMP.B #$C0                
                    BCS ADDR_01A7F5           
ADDR_01A80F:        LDA $71                   
                    CMP.B #$01                
                    BCS ADDR_01A7F5           
                    LDA.B #$00                
                    BIT.W $0D9B               
                    BVS ADDR_01A822           
                    LDA.W $13F9               
                    EOR.W $1632,X             
ADDR_01A822:        BNE ADDR_01A87C           
                    JSL.L ADDR_03B664         
                    JSL.L ADDR_03B69F         
                    JSL.L ADDR_03B72B         
                    BCC ADDR_01A87C           
                    LDA.W $167A,X             
                    BPL ADDR_01A83B           
                    SEC                       
                    RTS                       ; Return 


DATA_01A839:        .db $F0,$10

ADDR_01A83B:        LDA.W $1490               
                    BEQ ADDR_01A87E           
                    LDA.W $167A,X             
                    AND.B #$02                
                    BNE ADDR_01A87E           
ADDR_01A847:        JSL.L ADDR_01AB6F         
                    INC.W $18D2               
                    LDA.W $18D2               
                    CMP.B #$08                
                    BCC ADDR_01A85A           
                    LDA.B #$08                
                    STA.W $18D2               
ADDR_01A85A:        JSL.L GivePoints          
                    LDY.W $18D2               
                    CPY.B #$08                
                    BCS ADDR_01A86B           
                    LDA.W ADDR_01A61D,Y       
                    STA.W $1DF9               ; / Play sound effect 
ADDR_01A86B:        LDA.B #$02                
                    STA.W $14C8,X             
                    LDA.B #$D0                
                    STA $AA,X                 
                    JSR.W SubHorizPos         
                    LDA.W DATA_01A839,Y       
                    STA $B6,X                 
ADDR_01A87C:        CLC                       
                    RTS                       ; Return 

ADDR_01A87E:        STZ.W $18D2               
                    LDA.W $154C,X             
                    BNE ADDR_01A895           
                    LDA.B #$08                
                    STA.W $154C,X             
                    LDA.W $14C8,X             
                    CMP.B #$09                
                    BNE ADDR_01A897           
                    JSR.W ADDR_01AA42         
ADDR_01A895:        CLC                       
                    RTS                       ; Return 

ADDR_01A897:        LDA.B #$14                
                    STA $01                   
                    LDA $05                   
                    SEC                       
                    SBC $01                   
                    ROL $00                   
                    CMP $D3                   
                    PHP                       
                    LSR $00                   
                    LDA $0B                   
                    SBC.B #$00                
                    PLP                       
                    SBC $D4                   
                    BMI ADDR_01A8E6           
                    LDA $7D                   
                    BPL ADDR_01A8C0           
                    LDA.W $190F,X             
                    AND.B #$10                
                    BNE ADDR_01A8C0           
                    LDA.W $1697               
                    BEQ ADDR_01A8E6           
ADDR_01A8C0:        JSR.W ADDR_01800E         
                    BEQ ADDR_01A8C9           
                    LDA $72                   
                    BEQ ADDR_01A8E6           
ADDR_01A8C9:        LDA.W $1656,X             
                    AND.B #$10                
                    BNE ADDR_01A91C           
                    LDA.W $140D               
                    ORA.W $187A               
                    BEQ ADDR_01A8E6           
ADDR_01A8D8:        LDA.B #$02                
                    STA.W $1DF9               ; / Play sound effect 
                    JSL.L BoostMarioSpeed     
                    JSL.L DisplayContactGfx   
                    RTS                       ; Return 

ADDR_01A8E6:        LDA.W $13ED               
                    BEQ ADDR_01A8F9           
                    LDA.W $190F,X             
                    AND.B #$04                
                    BNE ADDR_01A8F9           
                    JSR.W ADDR_01A728         
                    JSR.W ADDR_01A847         
                    RTS                       ; Return 

ADDR_01A8F9:        LDA.W $1497               
                    BNE ADDR_01A91B           
                    LDA.W $187A               
                    BNE ADDR_01A91B           
                    LDA.W $1686,X             
                    AND.B #$10                
                    BNE ADDR_01A911           
                    JSR.W SubHorizPos         
                    TYA                       
                    STA.W $157C,X             
ADDR_01A911:        LDA $9E,X                 
                    CMP.B #$53                
                    BEQ ADDR_01A91B           
                    JSL.L HurtMario           
ADDR_01A91B:        RTS                       ; Return 

ADDR_01A91C:        LDA.W $140D               
                    ORA.W $187A               
                    BEQ ADDR_01A947           
ADDR_01A924:        JSL.L DisplayContactGfx   
                    LDA.B #$F8                
                    STA $7D                   
                    LDA.W $187A               
                    BEQ ADDR_01A935           
                    JSL.L BoostMarioSpeed     
ADDR_01A935:        JSR.W ADDR_019ACB         
                    JSL.L ADDR_07FC3B         
                    JSR.W ADDR_01AB46         
                    LDA.B #$08                
                    STA.W $1DF9               ; / Play sound effect 
                    JMP.W ADDR_01A9F2         
ADDR_01A947:        JSR.W ADDR_01A8D8         
                    LDA.W $187B,X             
                    BEQ ADDR_01A95D           
                    JSR.W SubHorizPos         
                    LDA.B #$18                
                    CPY.B #$00                
                    BEQ ADDR_01A95A           
                    LDA.B #$E8                
ADDR_01A95A:        STA $7B                   
                    RTS                       ; Return 

ADDR_01A95D:        JSR.W ADDR_01AB46         
                    LDY $9E,X                 
                    LDA.W $1686,X             
                    AND.B #$40                
                    BEQ ADDR_01A9BE           
                    CPY.B #$72                
                    BCC ADDR_01A979           
                    PHX                       
                    PHY                       
                    JSL.L ADDR_02EAF2         
                    PLY                       
                    PLX                       
                    LDA.B #$02                
                    BRA ADDR_01A99B           
ADDR_01A979:        CPY.B #$6E                
                    BNE ADDR_01A98A           
                    LDA.B #$02                
                    STA $C2,X                 
                    LDA.B #$FF                
                    STA.W $1540,X             
                    LDA.B #$6F                
                    BRA ADDR_01A99B           
ADDR_01A98A:        CPY.B #$3F                
                    BCC ADDR_01A998           
                    LDA.B #$80                
                    STA.W $1540,X             
                    LDA.W ADDR_01A79B,Y       
                    BRA ADDR_01A99B           
ADDR_01A998:        LDA.W DATA_01A7C9,Y       
ADDR_01A99B:        STA $9E,X                 
                    LDA.W $15F6,X             
                    AND.B #$0E                
                    STA $0F                   
                    JSL.L ADDR_07F78B         
                    LDA.W $15F6,X             
                    AND.B #$F1                
                    ORA $0F                   
                    STA.W $15F6,X             
                    STZ $AA,X                 
                    LDA $9E,X                 
                    CMP.B #$02                
                    BNE ADDR_01A9BD           
                    INC.W $151C,X             
ADDR_01A9BD:        RTS                       ; Return 

ADDR_01A9BE:        LDA $9E,X                 
                    SEC                       
                    SBC.B #$04                
                    CMP.B #$0D                
                    BCS ADDR_01A9CC           
                    LDA.W $1407               
                    BNE ADDR_01A9D3           
ADDR_01A9CC:        LDA.W $1656,X             
                    AND.B #$20                
                    BEQ ADDR_01A9E2           
ADDR_01A9D3:        LDA.B #$03                
                    STA.W $14C8,X             
                    LDA.B #$20                
                    STA.W $1540,X             
                    STZ $B6,X                 
                    STZ $AA,X                 
                    RTS                       ; Return 

ADDR_01A9E2:        LDA.W $1662,X             
                    AND.B #$80                
                    BEQ ADDR_01AA01           
                    LDA.B #$02                
                    STA.W $14C8,X             
                    STZ $B6,X                 
                    STZ $AA,X                 
ADDR_01A9F2:        LDA $9E,X                 
                    CMP.B #$1E                
                    BNE ADDR_01AA00           
                    LDY.W $18E1               
                    LDA.B #$1F                
                    STA.W $1540,Y             
ADDR_01AA00:        RTS                       ; Return 

ADDR_01AA01:        LDY.W $14C8,X             
                    STZ.W $1626,X             
                    CPY.B #$08                
                    BEQ ADDR_01AA14           
ADDR_01AA0B:        LDA $C2,X                 
                    BNE ADDR_01AA14           
                    STZ.W $1540,X             
                    BRA ADDR_01AA2D           
ADDR_01AA14:        LDA.B #$02                
                    LDY $9E,X                 
                    CPY.B #$0F                
                    BEQ ADDR_01AA28           
                    CPY.B #$11                
                    BEQ ADDR_01AA28           
                    CPY.B #$A2                
                    BEQ ADDR_01AA28           
                    CPY.B #$0D                
                    BNE ADDR_01AA2A           
ADDR_01AA28:        LDA.B #$FF                
ADDR_01AA2A:        STA.W $1540,X             
ADDR_01AA2D:        LDA.B #$09                
                    STA.W $14C8,X             
                    RTS                       ; Return 

BoostMarioSpeed:    LDA $74                   
                    BNE ADDR_01AA41           
                    LDA.B #$D0                
                    BIT $15                   
                    BPL ADDR_01AA3F           
                    LDA.B #$A8                
ADDR_01AA3F:        STA $7D                   
ADDR_01AA41:        RTL                       ; Return 

ADDR_01AA42:        LDA.W $140D               
                    ORA.W $187A               
                    BEQ ADDR_01AA58           
                    LDA $7D                   
                    BMI ADDR_01AA58           
                    LDA.W $1656,X             
                    AND.B #$10                
                    BEQ ADDR_01AA58           
                    JMP.W ADDR_01A924         
ADDR_01AA58:        LDA $15                   
                    AND.B #$40                
                    BEQ ADDR_01AA74           
                    LDA.W $1470               
                    ORA.W $187A               
                    BNE ADDR_01AA74           
                    LDA.B #$0B                
                    STA.W $14C8,X             
                    INC.W $1470               
                    LDA.B #$08                
                    STA.W $1498               
                    RTS                       ; Return 

ADDR_01AA74:        LDA $9E,X                 
                    CMP.B #$80                
                    BEQ ADDR_01AAB7           
                    CMP.B #$3E                
                    BEQ ADDR_01AAB2           
                    CMP.B #$0D                
                    BEQ ADDR_01AA97           
                    CMP.B #$2D                
                    BEQ ADDR_01AA97           
                    CMP.B #$A2                
                    BEQ ADDR_01AA97           
                    CMP.B #$0F                
                    BNE ADDR_01AA94           
                    LDA.B #$F0                
                    STA $AA,X                 
                    BRA ADDR_01AA97           
ADDR_01AA94:        JSR.W ADDR_01AB46         
ADDR_01AA97:        JSR.W ADDR_01A728         
                    LDA.W $1540,X             
                    STA $C2,X                 
                    LDA.B #$0A                
                    STA.W $14C8,X             
                    LDA.B #$10                
                    STA.W $154C,X             
                    JSR.W SubHorizPos         
                    LDA.W DATA_019F6B,Y       
                    STA $B6,X                 
                    RTS                       ; Return 

ADDR_01AAB2:        LDA.W $163E,X             
                    BNE ADDR_01AB2C           
ADDR_01AAB7:        STZ.W $154C,X             
                    LDA $D8,X                 
                    SEC                       
                    SBC $D3                   
                    CLC                       
                    ADC.B #$08                
                    CMP.B #$20                
                    BCC ADDR_01AB31           
                    BPL ADDR_01AACD           
                    LDA.B #$10                
                    STA $7D                   
                    RTS                       ; Return 

ADDR_01AACD:        LDA $7D                   
                    BMI ADDR_01AB2C           
                    STZ $7D                   
                    STZ $72                   
                    INC.W $1471               
                    LDA.B #$1F                
                    LDY.W $187A               
                    BEQ ADDR_01AAE1           
                    LDA.B #$2F                
ADDR_01AAE1:        STA $00                   
                    LDA $D8,X                 
                    SEC                       
                    SBC $00                   
                    STA $96                   
                    LDA.W $14D4,X             
                    SBC.B #$00                
                    STA $97                   
                    LDA $9E,X                 
                    CMP.B #$3E                
                    BNE ADDR_01AB2C           
                    ASL.W $167A,X             
                    LSR.W $167A,X             
                    LDA.B #$0B                
                    STA.W $1DF9               ; / Play sound effect 
                    LDA.W $0DDA               
                    BMI ADDR_01AB0C           
                    LDA.B #$0E                
                    STA.W $1DFB               ; / Play sound effect 
ADDR_01AB0C:        LDA.B #$20                
                    STA.W $163E,X             
                    LSR.W $15F6,X             
                    ASL.W $15F6,X             
                    LDY.W $151C,X             
                    LDA.B #$B0                
                    STA.W $14AD,Y             
                    LDA.B #$20                
                    STA.W $1887               
                    CPY.B #$01                
                    BNE ADDR_01AB2C           
                    JSL.L ADDR_02B9BD         
ADDR_01AB2C:        RTS                       ; Return 


DATA_01AB2D:        .db $01,$00,$FF,$FF

ADDR_01AB31:        STZ $7B                   
                    JSR.W SubHorizPos         
                    TYA                       
                    ASL                       
                    TAY                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA $94                   
                    CLC                       
                    ADC.W DATA_01AB2D,Y       
                    STA $94                   
                    SEP #$20                  ; Accum (8 bit) 
                    RTS                       ; Return 

ADDR_01AB46:        PHY                       
                    LDA.W $1697               
                    CLC                       
                    ADC.W $1626,X             
                    INC.W $1697               
                    TAY                       
                    INY                       
                    CPY.B #$08                
                    BCS ADDR_01AB5D           
                    LDA.W ADDR_01A61D,Y       
                    STA.W $1DF9               ; / Play sound effect 
ADDR_01AB5D:        TYA                       
                    CMP.B #$08                
                    BCC ADDR_01AB64           
                    LDA.B #$08                
ADDR_01AB64:        JSL.L GivePoints          
                    PLY                       
                    RTS                       ; Return 


DATA_01AB6A:        .db $0C,$FC,$EC,$DC,$CC

ADDR_01AB6F:        JSR.W ADDR_01A728         
ADDR_01AB72:        JSR.W IsSprOffscreen      
                    BNE ADDR_01AB98           
                    PHY                       
                    LDY.B #$03                
ADDR_01AB7A:        LDA.W $17C0,Y             
                    BEQ ADDR_01AB83           
                    DEY                       
                    BPL ADDR_01AB7A           
                    INY                       
ADDR_01AB83:        LDA.B #$02                
                    STA.W $17C0,Y             
                    LDA $E4,X                 
                    STA.W $17C8,Y             
                    LDA $D8,X                 
                    STA.W $17C4,Y             
                    LDA.B #$08                
                    STA.W $17CC,Y             
                    PLY                       
ADDR_01AB98:        RTL                       ; Return 

DisplayContactGfx:  JSR.W IsSprOffscreen      
                    BNE ADDR_01ABCB           
                    PHY                       
                    LDY.B #$03                
ADDR_01ABA1:        LDA.W $17C0,Y             
                    BEQ ADDR_01ABAA           
                    DEY                       
                    BPL ADDR_01ABA1           
                    INY                       
ADDR_01ABAA:        LDA.B #$02                
                    STA.W $17C0,Y             
                    LDA $94                   
                    STA.W $17C8,Y             
                    LDA.W $187A               
                    CMP.B #$01                
                    LDA.B #$14                
                    BCC ADDR_01ABBF           
                    LDA.B #$1E                
ADDR_01ABBF:        CLC                       
                    ADC $96                   
                    STA.W $17C4,Y             
                    LDA.B #$08                
                    STA.W $17CC,Y             
                    PLY                       
ADDR_01ABCB:        RTL                       ; Return 

ADDR_01ABCC:        TXA                       
                    CLC                       
                    ADC.B #$0C                
                    TAX                       
                    JSR.W ADDR_01ABD8         
                    LDX.W $15E9               
                    RTS                       ; Return 

ADDR_01ABD8:        LDA $AA,X                 ; Load current sprite's Y speed 
                    BEQ ADDR_01AC09           ; If speed is 0, branch to $AC09 
                    ASL                       ; \  
                    ASL                       ;  |Multiply speed by 16 
                    ASL                       ;  | 
                    ASL                       ; /  
                    CLC                       ; \  
                    ADC.W $14EC,X             ;  |Increase (unknown sprite table) by that value 
                    STA.W $14EC,X             ; /  
                    PHP                       
                    PHP                       
                    LDY.B #$00                
                    LDA $AA,X                 ; Load current sprite's Y speed 
                    LSR                       ; \  
                    LSR                       ;  |Multiply speed by 16 
                    LSR                       ;  | 
                    LSR                       ; /  
                    CMP.B #$08                
                    BCC ADDR_01ABF8           
                    ORA.B #$F0                
                    DEY                       
ADDR_01ABF8:        PLP                       
                    PHA                       
                    ADC $D8,X                 ; \ Add value to current sprite's Y position 
                    STA $D8,X                 ; /  
                    TYA                       
                    ADC.W $14D4,X             
                    STA.W $14D4,X             
                    PLA                       
                    PLP                       
                    ADC.B #$00                
ADDR_01AC09:        STA.W $1491               
                    RTS                       ; Return 


DATA_01AC0D:        .db $40,$B0

DATA_01AC0F:        .db $01,$FF

DATA_01AC11:        .db $30,$C0,$A0,$C0,$A0,$F0,$60,$90
DATA_01AC19:        .db $01,$FF,$01,$FF,$01,$FF,$01,$FF

ADDR_01AC21:        LDA.B #$06                ; \ Entry point of routine determines value of $03 
                    STA $03                   ;  | 
                    BRA ADDR_01AC2D           ;  | 
ADDR_01AC27:        LDA.B #$04                ;  | 
                    BRA ADDR_01AC2D           ;  | 
ADDR_01AC2B:        LDA.B #$02                ;  | 
ADDR_01AC2D:        STA $03                   ;  | 
                    BRA ADDR_01AC33           ;  | 
ADDR_01AC31:        STZ $03                   ; / 
ADDR_01AC33:        JSR.W IsSprOffscreen      ; \ if sprite is not off screen, return                                       
                    BEQ Return01ACA4          ; /                                                                           
                    LDA $5B                   ; \  vertical level                                    
                    AND.B #$01                ; |                                                                           
                    BNE VerticalLevel         ; /                                                                           
                    LDA $D8,X                 ; \                                                                           
                    CLC                       ; |                                                                           
                    ADC.B #$50                ; | if the sprite has gone off the bottom of the level...                     
                    LDA.W $14D4,X             ; | (if adding 0x50 to the sprite y position would make the high byte >= 2)   
                    ADC.B #$00                ; |                                                                           
                    CMP.B #$02                ; |                                                                           
                    BPL OffScrEraseSprite     ; /    ...erase the sprite                                                    
                    LDA.W $167A,X             ; \ if "process offscreen" flag is set, return                                
                    AND.B #$04                ; |                                                                           
                    BNE Return01ACA4          ; /                                                                           
                    LDA $13                   
                    AND.B #$01                
                    ORA $03                   
                    STA $01                   
                    TAY                       
                    LDA $1A                   
                    CLC                       
                    ADC.W DATA_01AC11,Y       
                    ROL $00                   
                    CMP $E4,X                 
                    PHP                       
                    LDA $1B                   
                    LSR $00                   
                    ADC.W DATA_01AC19,Y       
                    PLP                       
                    SBC.W $14E0,X             
                    STA $00                   
                    LSR $01                   
                    BCC ADDR_01AC7C           
                    EOR.B #$80                
                    STA $00                   
ADDR_01AC7C:        LDA $00                   
                    BPL Return01ACA4          
OffScrEraseSprite:  LDA $9E,X                 
                    CMP.B #$1F                
                    BNE ADDR_01AC8E           
                    STA.W $18C1               
                    LDA.B #$FF                
                    STA.W $18C0               
ADDR_01AC8E:        LDA.W $14C8,X             ; \ If sprite status < 8, permanently erase sprite 
                    CMP.B #$08                ;  | 
                    BCC OffScrKillSprite      ; / 
                    LDY.W $161A,X             
                    CPY.B #$FF                
                    BEQ OffScrKillSprite      
                    LDA.B #$00                
                    STA.W $1938,Y             
OffScrKillSprite:   STZ.W $14C8,X             ; Erase sprite 
Return01ACA4:       RTS                       

VerticalLevel:      LDA.W $167A,X             ; \ If "process offscreen" flag is set, return                
                    AND.B #$04                ; |                                                           
                    BNE Return01ACA4          ; /                                                           
                    LDA $13                   ; \                                                           
                    LSR                       ; |                                                           
                    BCS Return01ACA4          ; /                                                           
                    LDA $E4,X                 ; \                                                           
                    CMP.B #$00                ;  | If the sprite has gone off the side of the level...      
                    LDA.W $14E0,X             ;  |                                                          
                    SBC.B #$00                ;  |                                                          
                    CMP.B #$02                ;  |                                                          
                    BCS OffScrEraseSprite     ; /  ...erase the sprite      
                    LDA $13                   
                    LSR                       
                    AND.B #$01                
                    STA $01                   
                    TAY                       
                    BEQ ADDR_01ACD2           
                    LDA $9E,X                 
                    CMP.B #$22                
                    BEQ Return01ACA4          
                    CMP.B #$24                
                    BEQ Return01ACA4          
ADDR_01ACD2:        LDA $1C                   
                    CLC                       
                    ADC.W DATA_01AC0D,Y       
                    ROL $00                   
                    CMP $D8,X                 
                    PHP                       
                    LDA.W $001D               
                    LSR $00                   
                    ADC.W DATA_01AC0F,Y       
                    PLP                       
                    SBC.W $14D4,X             
                    STA $00                   
                    LDY $01                   
                    BEQ ADDR_01ACF3           
                    EOR.B #$80                
                    STA $00                   
ADDR_01ACF3:        LDA $00                   
                    BPL Return01ACA4          
                    BMI OffScrEraseSprite     
ADDR_01ACF9:        PHY                       
                    LDY.B #$01                
                    JSL.L ADDR_01AD07         
                    DEY                       
                    JSL.L ADDR_01AD07         
                    PLY                       
                    RTL                       ; Return 

ADDR_01AD07:        LDA.W $148B               
                    ASL                       
                    ASL                       
                    SEC                       
                    ADC.W $148B               
                    STA.W $148B               
                    ASL.W $148C               
                    LDA.B #$20                
                    BIT.W $148C               
                    BCC ADDR_01AD21           
                    BEQ ADDR_01AD26           
                    BNE ADDR_01AD23           
ADDR_01AD21:        BNE ADDR_01AD26           
ADDR_01AD23:        INC.W $148C               
ADDR_01AD26:        LDA.W $148C               
                    EOR.W $148B               
                    STA.W $148D,Y             
                    RTL                       ; Return 

SubHorizPos:        LDY.B #$00                
                    LDA $D1                   
                    SEC                       
                    SBC $E4,X                 
                    STA $0F                   
                    LDA $D2                   
                    SBC.W $14E0,X             
                    BPL ADDR_01AD41           
                    INY                       
ADDR_01AD41:        RTS                       ; Return 

ADDR_01AD42:        LDY.B #$00                
                    LDA $D3                   
                    SEC                       
                    SBC $D8,X                 
                    STA $0E                   
                    LDA $D4                   
                    SBC.W $14D4,X             
                    BPL ADDR_01AD53           
                    INY                       
ADDR_01AD53:        RTS                       ; Return 


DATA_01AD54:        .db $FF,$FF,$FF,$FF,$FF

ADDR_01AD59:        LDA $E4,X                 
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.B #$03                
                    STA.W $151C,X             
                    INC.W $157C,X             
                    RTS                       ; Return 


DATA_01AD68:        .db $FF,$01

DATA_01AD6A:        .db $F4,$0C

DATA_01AD6C:        .db $F0,$10

ADDR_01AD6E:        LDA.W $163E,X             
                    BEQ ADDR_01AD80           
                    STZ.W $15EA,X             
                    LDA.W $187A               
                    BNE ADDR_01AD80           
                    LDA.B #$04                
                    STA.W $15EA,X             
ADDR_01AD80:        JSR.W ADDR_019F0D         
                    LDY.W $15EA,X             
                    LDA.W $0301,Y             
                    DEC A                     
                    STA.W $0301,Y             
                    STZ.W $1528,X             
                    LDA $C2,X                 
                    BNE ADDR_01ADF8           
                    JSR.W ADDR_019E95         
                    LDA $9D                   
                    BNE ADDR_01ADF8           
                    LDA $13                   
                    AND.B #$01                
                    BNE ADDR_01ADB7           
                    LDA.W $1594,X             
                    AND.B #$01                
                    TAY                       
                    LDA $AA,X                 
                    CLC                       
                    ADC.W DATA_01AD68,Y       
                    STA $AA,X                 
                    CMP.W DATA_01AD6A,Y       
                    BNE ADDR_01ADB7           
                    INC.W $1594,X             
ADDR_01ADB7:        JSR.W ADDR_01ABD8         
                    LDA $9E,X                 
                    CMP.B #$83                
                    BEQ ADDR_01ADE8           
                    LDA.W $1540,X             
                    BNE ADDR_01ADE6           
                    LDA $13                   
                    AND.B #$03                
                    BNE ADDR_01ADE6           
                    LDA.W $1534,X             
                    AND.B #$01                
                    TAY                       
                    LDA $B6,X                 
                    CLC                       
                    ADC.W DATA_01AD68,Y       
                    STA $B6,X                 
                    CMP.W DATA_01AD6C,Y       
                    BNE ADDR_01ADE6           
                    INC.W $1534,X             
                    LDA.B #$20                
                    STA.W $1540,X             
ADDR_01ADE6:        BRA ADDR_01ADEC           
ADDR_01ADE8:        LDA.B #$F4                
                    STA $B6,X                 
ADDR_01ADEC:        JSR.W ADDR_01ABCC         
                    LDA.W $1491               
                    STA.W $1528,X             
                    INC.W $1570,X             
ADDR_01ADF8:        JSR.W ADDR_01A40D         
                    JSR.W ADDR_01B457         
                    JSR.W ADDR_01AC31         
                    LDA.W $1558,X             
                    CMP.B #$08                
                    BNE ADDR_01AE5E           
                    LDY $C2,X                 
                    CPY.B #$02                
                    BEQ ADDR_01AE5E           
                    PHA                       
                    INC $C2,X                 
                    LDA.B #$50                
                    STA.W $163E,X             
                    LDA $E4,X                 
                    STA $9A                   
                    LDA.W $14E0,X             
                    STA $9B                   
                    LDA $D8,X                 
                    STA $98                   
                    LDA.W $14D4,X             
                    STA $99                   
                    LDA.B #$FF                
                    STA.W $161A,X             
                    LDY.W $151C,X             
                    LDA $19                   
                    BNE ADDR_01AE38           
                    INY                       
                    INY                       
                    INY                       
                    INY                       
ADDR_01AE38:        LDA.W DATA_01AE88,Y       
                    STA $05                   
                    PHB                       
                    LDA.B #$02                
                    PHA                       
                    PLB                       
                    PHX                       
                    JSL.L ADDR_02887D         
                    PLX                       
                    LDY.W $185E               
                    LDA.B #$01                
                    STA.W $1528,Y             
                    LDA.W $009E,Y             
                    CMP.B #$75                
                    BNE ADDR_01AE5C           
                    LDA.B #$FF                
                    STA.W $00C2,Y             
ADDR_01AE5C:        PLB                       
                    PLA                       
ADDR_01AE5E:        LSR                       
                    TAY                       
                    LDA.W DATA_01AE7F,Y       
                    STA $00                   
                    LDY.W $15EA,X             
                    LDA.W $0301,Y             
                    SEC                       
                    SBC $00                   
                    STA.W $0301,Y             
                    LDA $C2,X                 
                    CMP.B #$01                
                    LDA.B #$2A                
                    BCC ADDR_01AE7B           
                    LDA.B #$2E                
ADDR_01AE7B:        STA.W $0302,Y             
                    RTS                       ; Return 


DATA_01AE7F:        .db $00,$03,$05,$07,$08,$08,$07,$05
                    .db $03

DATA_01AE88:        .db $06,$02,$04,$05,$06,$01,$01,$05

Return01AE90:       RTS                       

ADDR_01AE91:        JSL.L ADDR_02CD2D         
                    RTS                       ; Return 

ADDR_01AE96:        LDA $D8,X                 
                    STA.W $151C,X             
                    LDA $E4,X                 
                    CLC                       
                    ADC.B #$08                
                    STA $E4,X                 
Return01AEA2:       RTS                       

ADDR_01AEA3:        JSR.W ADDR_01AF54         
                    LDA.W $14C8,X             
                    CMP.B #$08                
                    BNE Return01AEA2          
                    LDA $9D                   
                    BNE Return01AEA2          
                    JSR.W ADDR_01AC31         
                    JSR.W ADDR_01A7E4         
                    LDA $C2,X                 
                    JSL.L ExecutePtr          

Ptrs01AEBD:         .dw ADDR_01AEC3           
                    .dw ADDR_01AEFA           
                    .dw ADDR_01AF24           

ADDR_01AEC3:        LDA.W $186C,X             
                    BNE ADDR_01AEEE           
                    LDA.W $15A0,X             
                    BNE ADDR_01AEF9           
                    JSR.W SubHorizPos         
                    TYA                       
                    STA.W $157C,X             
                    STZ.W $1528,X             
                    LDA $0F                   
                    CLC                       
                    ADC.B #$40                
                    CMP.B #$80                
                    BCS ADDR_01AEE5           
                    LDA.B #$01                
                    STA.W $1528,X             
ADDR_01AEE5:        LDA $0F                   
                    CLC                       
                    ADC.B #$24                
                    CMP.B #$50                
                    BCS ADDR_01AEF9           
ADDR_01AEEE:        LDA.B #$02                
                    STA.W $1528,X             
                    INC $C2,X                 
                    LDA.B #$00                
                    STA $AA,X                 
ADDR_01AEF9:        RTS                       ; Return 

ADDR_01AEFA:        JSR.W ADDR_01ABD8         
                    LDA $AA,X                 
                    CMP.B #$3E                
                    BCS ADDR_01AF07           
                    ADC.B #$04                
                    STA $AA,X                 
ADDR_01AF07:        JSR.W ADDR_019140         
                    JSR.W ADDR_01800E         
                    BEQ ADDR_01AF23           
                    JSR.W ADDR_019A04         
                    LDA.B #$18                
                    STA.W $1887               
                    LDA.B #$09                
                    STA.W $1DFC               ; / Play sound effect 
                    LDA.B #$40                
                    STA.W $1540,X             
                    INC $C2,X                 
ADDR_01AF23:        RTS                       ; Return 

ADDR_01AF24:        LDA.W $1540,X             
                    BNE ADDR_01AF3F           
                    STZ.W $1528,X             
                    LDA $D8,X                 
                    CMP.W $151C,X             
                    BNE ADDR_01AF38           
                    LDA.B #$00                
                    STA $C2,X                 
                    RTS                       ; Return 

ADDR_01AF38:        LDA.B #$F0                
                    STA $AA,X                 
                    JSR.W ADDR_01ABD8         
ADDR_01AF3F:        RTS                       ; Return 


DATA_01AF40:        .db $FC,$04,$FC,$04,$00

DATA_01AF45:        .db $00,$00,$10,$10,$08

DATA_01AF4A:        .db $8E,$8E,$AE,$AE,$C8

DATA_01AF4F:        .db $03,$43,$03,$43,$03

ADDR_01AF54:        JSR.W GetDrawInfoBnk1     
                    LDA.W $1528,X             
                    STA $02                   
                    PHX                       
                    LDX.B #$03                
                    CMP.B #$00                
                    BEQ ADDR_01AF64           
                    INX                       
ADDR_01AF64:        LDA $00                   
                    CLC                       
                    ADC.W DATA_01AF40,X       
                    STA.W $0300,Y             
                    LDA $01                   
                    CLC                       
                    ADC.W DATA_01AF45,X       
                    STA.W $0301,Y             
                    LDA.W DATA_01AF4F,X       
                    ORA $64                   
                    STA.W $0303,Y             
                    LDA.W DATA_01AF4A,X       
                    CPX.B #$04                
                    BNE ADDR_01AF8F           
                    PHX                       
                    LDX $02                   
                    CPX.B #$02                
                    BNE ADDR_01AF8E           
                    LDA.B #$CA                
ADDR_01AF8E:        PLX                       
ADDR_01AF8F:        STA.W $0302,Y             
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_01AF64           
                    PLX                       
                    LDA.B #$04                
                    JMP.W ADDR_01B37E         
ADDR_01AF9F:        LDA.W $14C8,X             
                    CMP.B #$08                
                    BNE ADDR_01B006           
                    LDA $9D                   
                    BNE ADDR_01B006           
                    JSR.W ADDR_01AC31         
                    JSR.W ADDR_01A7E4         
                    JSR.W ADDR_01ABCC         
                    JSR.W ADDR_01ABD8         
                    JSR.W ADDR_019140         
                    LDA $AA,X                 
                    BMI ADDR_01AFC3           
                    CMP.B #$40                
                    BCS ADDR_01AFC8           
                    ADC.B #$05                
ADDR_01AFC3:        CLC                       
                    ADC.B #$03                
                    BRA ADDR_01AFCA           
ADDR_01AFC8:        LDA.B #$40                
ADDR_01AFCA:        STA $AA,X                 
                    JSR.W ADDR_018014         
                    BEQ ADDR_01AFD5           
                    LDA.B #$10                
                    STA $AA,X                 
ADDR_01AFD5:        JSR.W ADDR_01800E         
                    BEQ ADDR_01B006           
                    JSR.W ADDR_019A04         
                    STZ $B6,X                 
                    STZ $AA,X                 
                    LDA.W $1540,X             
                    BEQ ADDR_01AFFC           
                    DEC A                     
                    BNE ADDR_01B006           
                    LDA.B #$A0                
                    STA $AA,X                 
                    INC $C2,X                 
                    LDA $C2,X                 
                    LSR                       
                    LDA.B #$10                
                    BCC ADDR_01AFF8           
                    LDA.B #$F0                
ADDR_01AFF8:        STA $B6,X                 
                    BRA ADDR_01B006           
ADDR_01AFFC:        LDA.B #$01                
                    STA.W $1DF9               ; / Play sound effect 
                    LDA.B #$40                
                    STA.W $1540,X             
ADDR_01B006:        LDA.B #$01                
                    JMP.W ADDR_019CF3         
ADDR_01B00B:        JSR.W FaceMario           
                    INC.W $151C,X             
Return01B011:       RTS                       


DATA_01B012:        .db $10,$F0

ADDR_01B014:        JSR.W SubHorizPos         
                    LDA.W DATA_01B012,Y       
                    STA $B6,X                 
                    RTS                       ; Return 


DATA_01B01D:        .db $08,$F8

DATA_01B01F:        .db $00,$00,$08,$F8

DATA_01B023:        .db $F0,$10

DATA_01B025:        .db $E0,$E8,$D0,$D8

DATA_01B029:        .db $08,$F8,$10,$F0,$04,$FC,$14,$EC
DATA_01B031:        .db $03,$0C

ADDR_01B033:        LDA.W $14C8,X             
                    CMP.B #$08                
                    BNE ADDR_01B03E           
                    LDA $9D                   
                    BEQ ADDR_01B041           
ADDR_01B03E:        JMP.W ADDR_01B10A         
ADDR_01B041:        JSR.W ADDR_018E5F         
                    LDA.W $164A,X             
                    BNE ADDR_01B0A7           
                    JSR.W ADDR_019032         
                    JSR.W ADDR_018008         
                    BEQ ADDR_01B054           
                    JSR.W ADDR_019098         
ADDR_01B054:        JSR.W ADDR_01800E         
                    BEQ ADDR_01B09C           
                    LDA.W $190E               
                    BEQ ADDR_01B062           
                    JSL.L ADDR_0284BC         
ADDR_01B062:        JSL.L ADDR_01ACF9         
                    ADC $13                   
                    AND.B #$07                
                    TAY                       
                    LDA.W DATA_01B029,Y       
                    STA $B6,X                 
                    JSL.L ADDR_01ACF9         
                    LDA.W $148E               
                    AND.B #$03                
                    TAY                       
                    LDA.W DATA_01B025,Y       
                    STA $AA,X                 
                    LDA.W $148D               
                    AND.B #$40                
                    BNE ADDR_01B08E           
                    LDA.W $15F6,X             
                    EOR.B #$80                
                    STA.W $15F6,X             
ADDR_01B08E:        JSL.L ADDR_01ACF9         
                    LDA.W $148D               
                    AND.B #$80                
                    BNE ADDR_01B09C           
                    JSR.W ADDR_019A15         
ADDR_01B09C:        LDA.W $1602,X             
                    CLC                       
                    ADC.B #$02                
                    STA.W $1602,X             
                    BRA ADDR_01B0EA           
ADDR_01B0A7:        JSR.W ADDR_019140         
                    JSR.W ADDR_019A15         
                    ASL.W $15F6,X             
                    LSR.W $15F6,X             
                    LDA.W $1588,X             
                    LDY.W $151C,X             
                    AND.W DATA_01B031,Y       
                    BNE ADDR_01B0C3           
                    LDA.W $1540,X             
                    BNE ADDR_01B0CA           
ADDR_01B0C3:        LDA.B #$80                
                    STA.W $1540,X             
                    INC $C2,X                 
ADDR_01B0CA:        LDA $C2,X                 
                    AND.B #$01                
                    TAY                       
                    LDA.W $151C,X             
                    BEQ ADDR_01B0D6           
                    INY                       
                    INY                       
ADDR_01B0D6:        LDA.W DATA_01B01D,Y       
                    STA $B6,X                 
                    LDA.W DATA_01B01F,Y       
                    STA $AA,X                 
                    JSR.W ADDR_01ABCC         
                    AND.B #$0C                
                    BNE ADDR_01B0EA           
                    JSR.W ADDR_01ABD8         
ADDR_01B0EA:        JSR.W ADDR_01A40D         
                    JSR.W ADDR_01A7E4         
                    BCC ADDR_01B10A           
                    LDA.W $164A,X             
                    BEQ ADDR_01B107           
                    LDA.W $1490               
                    BNE ADDR_01B107           
                    LDA.W $187A               
                    BNE ADDR_01B10A           
                    JSL.L HurtMario           
                    BRA ADDR_01B10A           
ADDR_01B107:        JSR.W ADDR_01B12A         
ADDR_01B10A:        LDA.W $1602,X             
                    LSR                       
                    EOR.B #$01                
                    STA $00                   
                    LDA.W $15F6,X             
                    AND.B #$FE                
                    ORA $00                   
                    STA.W $15F6,X             
                    JSR.W ADDR_019F0D         
                    JSR.W ADDR_01AC31         
                    LSR.W $15F6,X             
                    SEC                       
                    ROL.W $15F6,X             
                    RTS                       ; Return 

ADDR_01B12A:        LDA.B #$10                
                    STA.W $149A               
                    LDA.B #$03                
                    STA.W $1DF9               ; / Play sound effect 
                    JSR.W SubHorizPos         
                    LDA.W DATA_01B023,Y       
                    STA $B6,X                 
                    LDA.B #$E0                
                    STA $AA,X                 
                    LDA.B #$02                
                    STA.W $14C8,X             
                    STY $76                   
                    LDA.B #$01                
                    JSL.L GivePoints          
                    RTS                       ; Return 

ADDR_01B14E:        LDA $13                   
                    AND.B #$03                
ADDR_01B152:        ORA.W $186C,X             
                    ORA $9D                   
                    BNE ADDR_01B191           
                    JSL.L ADDR_01ACF9         
                    AND.B #$0F                
                    CLC                       
                    LDY.B #$00                
                    ADC.B #$FC                
                    BPL ADDR_01B167           
                    DEY                       
ADDR_01B167:        CLC                       
                    ADC $E4,X                 
                    STA $02                   
                    TYA                       
                    ADC.W $14E0,X             
                    PHA                       
                    LDA $02                   
                    CMP $1A                   
                    PLA                       
                    SBC $1B                   
                    BNE ADDR_01B191           
                    LDA.W $148E               
                    AND.B #$0F                
                    CLC                       
                    ADC.B #$FE                
                    ADC $D8,X                 
                    STA $00                   
                    LDA.W $14D4,X             
                    ADC.B #$00                
                    STA $01                   
                    JSL.L ADDR_0285BA         
ADDR_01B191:        RTS                       ; Return 

ADDR_01B192:        JSR.W ADDR_01B209         
                    LDA $9D                   
                    BNE ADDR_01B1B0           
                    JSR.W ADDR_018E5F         
                    JSR.W ADDR_01ABCC         
                    JSR.W ADDR_01ABD8         
                    JSR.W ADDR_019140         
                    LDA $AA,X                 
                    CMP.B #$20                
                    BPL ADDR_01B1AE           
                    CLC                       
                    ADC.B #$01                
ADDR_01B1AE:        STA $AA,X                 
ADDR_01B1B0:        RTS                       ; Return 


DATA_01B1B1:        .db $D0,$D0,$B0

ADDR_01B1B4:        LDA $9D                   
                    BNE ADDR_01B209           
                    LDA.W $164A,X             
                    STA.W $151C,X             
                    JSR.W ADDR_019032         
                    LDA.W $164A,X             
                    BEQ ADDR_01B1EA           
                    LDA $C2,X                 
                    CMP.B #$03                
                    BEQ ADDR_01B1DE           
                    INC $C2,X                 
                    TAY                       
                    LDA.W DATA_01B1B1,Y       
                    STA $AA,X                 
                    LDA.B #$10                
                    STA.W $1540,X             
                    STZ.W $164A,X             
                    BRA ADDR_01B206           
ADDR_01B1DE:        DEC $AA,X                 
                    LDA $13                   
                    AND.B #$03                
                    BNE ADDR_01B1E8           
                    DEC $AA,X                 
ADDR_01B1E8:        BRA ADDR_01B206           
ADDR_01B1EA:        INC.W $1570,X             
                    INC.W $1570,X             
                    CMP.W $151C,X             
                    BEQ ADDR_01B206           
                    LDA.B #$10                
                    STA.W $1540,X             
                    LDA $C2,X                 
                    CMP.B #$03                
                    BNE ADDR_01B206           
                    STZ $C2,X                 
                    LDA.B #$D0                
                    STA $AA,X                 
ADDR_01B206:        JSR.W ADDR_018E5F         
ADDR_01B209:        JSR.W ADDR_018FC1         
                    JSR.W ADDR_019A15         
                    JMP.W ADDR_01B10A         

DATA_01B212:        .db $08,$F8,$10,$F0

ADDR_01B216:        JSR.W FaceMario           
                    LDY.W $157C,X             
                    LDA $E4,X                 
                    AND.B #$10                
                    BEQ ADDR_01B224           
                    INY                       
                    INY                       
ADDR_01B224:        LDA.W DATA_01B212,Y       
                    STA $B6,X                 
                    BRA ADDR_01B236           
ADDR_01B22B:        INC.W $1602,X             
ADDR_01B22E:        LDA.W $190E               
                    BNE ADDR_01B236           
                    INC $C2,X                 
                    RTS                       ; Return 

ADDR_01B236:        LDA.B #$03                
                    STA.W $151C,X             
ADDR_01B23B:        JSR.W ADDR_019140         
                    LDA.W $164A,X             
                    BNE Return01B25D          
                    DEC.W $151C,X             
                    BMI ADDR_01B262           
                    LDA $D8,X                 
                    CLC                       
                    ADC.B #$08                
                    STA $D8,X                 
                    LDA.W $14D4,X             
                    ADC.B #$00                
                    STA.W $14D4,X             
                    CMP.B #$02                
                    BCS Return01B25D          
                    BRA ADDR_01B23B           
Return01B25D:       RTS                       

ADDR_01B25E:        INC.W $1602,X             
                    RTS                       ; Return 

ADDR_01B262:        LDA.B #$01                
                    STA.W $14C8,X             
Return01B267:       RTS                       


DATA_01B268:        .db $FF,$01

DATA_01B26A:        .db $F0,$10

ADDR_01B26C:        JSR.W ADDR_01B2D1         
                    LDA $9D                   
                    BNE ADDR_01B2C2           
                    LDA.W $1540,X             
                    BNE ADDR_01B2A5           
                    INC $C2,X                 
                    LDA $C2,X                 
                    AND.B #$03                
                    BNE ADDR_01B2A5           
                    LDA.W $151C,X             
                    AND.B #$01                
                    TAY                       
                    LDA $AA,X                 
                    CLC                       
                    ADC.W DATA_01B268,Y       
                    STA $AA,X                 
                    STA $B6,X                 
                    CMP.W DATA_01B26A,Y       
                    BNE ADDR_01B2A5           
                    INC.W $151C,X             
                    LDA.B #$18                
                    LDY $9E,X                 
                    CPY.B #$55                
                    BNE ADDR_01B2A2           
                    LDA.B #$08                
ADDR_01B2A2:        STA.W $1540,X             
ADDR_01B2A5:        LDA $9E,X                 
                    CMP.B #$57                
                    BCS ADDR_01B2B0           
                    JSR.W ADDR_01ABCC         
                    BRA ADDR_01B2B6           
ADDR_01B2B0:        JSR.W ADDR_01ABD8         
                    STZ.W $1491               
ADDR_01B2B6:        LDA.W $1491               
                    STA.W $1528,X             
                    JSR.W ADDR_01B457         
                    JSR.W ADDR_01AC2B         
ADDR_01B2C2:        RTS                       ; Return 


DATA_01B2C3:        .db $00,$01,$00,$01,$00,$00,$00,$00
                    .db $01,$01,$00,$00,$00,$00

ADDR_01B2D1:        LDA $9E,X                 
                    SEC                       
                    SBC.B #$55                
                    TAY                       
                    LDA.W DATA_01B2C3,Y       
                    BEQ ADDR_01B2DF           
                    JMP.W ADDR_01B395         
ADDR_01B2DF:        JSR.W GetDrawInfoBnk1     
                    LDA.W $1602,X             
                    STA $01                   
                    LDA $D8,X                 
                    SEC                       
                    SBC $1C                   
                    STA.W $0301,Y             
                    STA.W $0305,Y             
                    STA.W $0309,Y             
                    LDX $01                   
                    BEQ ADDR_01B2FF           
                    STA.W $030D,Y             
                    STA.W $0311,Y             
ADDR_01B2FF:        LDX.W $15E9               
                    LDA $E4,X                 
                    SEC                       
                    SBC $1A                   
                    STA.W $0300,Y             
                    CLC                       
                    ADC.B #$10                
                    STA.W $0304,Y             
                    CLC                       
                    ADC.B #$10                
                    STA.W $0308,Y             
                    LDX $01                   
                    BEQ ADDR_01B326           
                    CLC                       
                    ADC.B #$10                
                    STA.W $030C,Y             
                    CLC                       
                    ADC.B #$10                
                    STA.W $0310,Y             
ADDR_01B326:        LDX.W $15E9               
                    LDA $01                   
                    BEQ ADDR_01B344           
                    LDA.B #$EA                
                    STA.W $0302,Y             
                    LDA.B #$EB                
                    STA.W $0306,Y             
                    STA.W $030A,Y             
                    STA.W $030E,Y             
                    LDA.B #$EC                
                    STA.W $0312,Y             
                    BRA ADDR_01B359           
ADDR_01B344:        LDA.B #$60                
                    STA.W $0302,Y             
                    LDA.B #$61                
                    STA.W $0306,Y             
                    STA.W $030A,Y             
                    STA.W $030E,Y             
                    LDA.B #$62                
                    STA.W $0312,Y             
ADDR_01B359:        LDA $64                   
                    ORA.W $15F6,X             
                    STA.W $0303,Y             
                    STA.W $0307,Y             
                    STA.W $030B,Y             
                    STA.W $030F,Y             
                    STA.W $0313,Y             
                    LDA $01                   
                    BNE ADDR_01B376           
                    LDA.B #$62                
                    STA.W $030A,Y             
ADDR_01B376:        LDA.B #$04                
                    LDY $01                   
                    BNE ADDR_01B37E           
                    LDA.B #$02                
ADDR_01B37E:        LDY.B #$02                
                    JMP.W ADDR_01B7BB         

DATA_01B383:        .db $CB,$E4,$CC,$E5,$CC,$E5,$CC,$E4
                    .db $CB

DATA_01B38C:        .db $85,$88,$86,$89,$86,$89,$86,$88
                    .db $85

ADDR_01B395:        JSR.W GetDrawInfoBnk1     
                    PHY                       
                    LDY.B #$00                
                    LDA $9E,X                 
                    CMP.B #$5E                
                    BNE ADDR_01B3A2           
                    INY                       
ADDR_01B3A2:        STY $00                   
                    PLY                       
                    LDA $D8,X                 
                    SEC                       
                    SBC $1C                   
                    STA.W $0301,Y             
                    STA.W $0309,Y             
                    STA.W $0311,Y             
                    LDX $00                   
                    BEQ ADDR_01B3BD           
                    STA.W $0319,Y             
                    STA.W $0321,Y             
ADDR_01B3BD:        CLC                       
                    ADC.B #$10                
                    STA.W $0305,Y             
                    STA.W $030D,Y             
                    LDX $00                   
                    BEQ ADDR_01B3D0           
                    STA.W $0315,Y             
                    STA.W $031D,Y             
ADDR_01B3D0:        LDA.B #$08                
                    LDX $00                   
                    BNE ADDR_01B3D8           
                    LDA.B #$04                
ADDR_01B3D8:        STA $01                   
                    DEC A                     
                    STA $02                   
                    LDX.W $15E9               
                    LDA.W $15F6,X             
                    STA $03                   
                    LDA $9E,X                 
                    CMP.B #$5B                
                    LDA.B #$00                
                    BCS ADDR_01B3EF           
                    LDA.B #$09                
ADDR_01B3EF:        PHA                       
                    LDA $E4,X                 
                    SEC                       
                    SBC $1A                   
                    PLX                       
ADDR_01B3F6:        STA.W $0300,Y             
                    CLC                       
                    ADC.B #$08                
                    PHA                       
                    LDA.W DATA_01B383,X       
                    STA.W $0302,Y             
                    LDA $64                   
                    ORA $03                   
                    PHX                       
                    LDX $01                   
                    CPX $02                   
                    PLX                       
                    BCS ADDR_01B411           
                    ORA.B #$40                
ADDR_01B411:        STA.W $0303,Y             
                    PLA                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    INX                       
                    DEC $01                   
                    BPL ADDR_01B3F6           
                    LDX.W $15E9               
                    LDY.W $15EA,X             
                    LDA $00                   
                    BNE ADDR_01B444           
                    LDA $9E,X                 
                    CMP.B #$5B                
                    BCS ADDR_01B43A           
                    LDA.B #$85                
                    STA.W $0312,Y             
                    LDA.B #$88                
                    STA.W $030E,Y             
                    BRA ADDR_01B444           
ADDR_01B43A:        LDA.B #$CB                
                    STA.W $0312,Y             
                    LDA.B #$E4                
                    STA.W $030E,Y             
ADDR_01B444:        LDA.B #$08                
                    LDY $00                   
                    BNE ADDR_01B44C           
                    LDA.B #$04                
ADDR_01B44C:        JMP.W ADDR_01B37E         
InvisBlkMainRt:     PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_01B457         
                    PLB                       
                    RTL                       ; Return 

ADDR_01B457:        JSR.W ADDR_01A7F7         
                    BCC ADDR_01B4B2           
                    LDA $D8,X                 
                    SEC                       
                    SBC $1C                   
                    STA $00                   
                    LDA $80                   
                    CLC                       
                    ADC.B #$18                
                    CMP $00                   
                    BPL ADDR_01B4B4           
                    LDA $7D                   
                    BMI ADDR_01B4B2           
                    LDA $77                   
                    AND.B #$08                
                    BNE ADDR_01B4B2           
                    LDA.B #$10                
                    STA $7D                   
                    LDA.B #$01                
                    STA.W $1471               
                    LDA.B #$1F                
                    LDY.W $187A               
                    BEQ ADDR_01B488           
                    LDA.B #$2F                
ADDR_01B488:        STA $01                   
                    LDA $D8,X                 
                    SEC                       
                    SBC $01                   
                    STA $96                   
                    LDA.W $14D4,X             
                    SBC.B #$00                
                    STA $97                   
                    LDA $77                   
                    AND.B #$03                
                    BNE ADDR_01B4B0           
                    LDY.B #$00                
                    LDA.W $1528,X             
                    BPL ADDR_01B4A6           
                    DEY                       
ADDR_01B4A6:        CLC                       
                    ADC $94                   
                    STA $94                   
                    TYA                       
                    ADC $95                   
                    STA $95                   
ADDR_01B4B0:        SEC                       
                    RTS                       ; Return 

ADDR_01B4B2:        CLC                       
                    RTS                       ; Return 

ADDR_01B4B4:        LDA.W $190F,X             
                    LSR                       
                    BCS ADDR_01B4B2           
                    LDA.B #$00                
                    LDY $73                   
                    BNE ADDR_01B4C4           
                    LDY $19                   
                    BNE ADDR_01B4C6           
ADDR_01B4C4:        LDA.B #$08                
ADDR_01B4C6:        LDY.W $187A               
                    BEQ ADDR_01B4CD           
                    ADC.B #$08                
ADDR_01B4CD:        CLC                       
                    ADC $80                   
                    CMP $00                   
                    BCC ADDR_01B505           
                    LDA $7D                   
                    BPL ADDR_01B4F7           
                    LDA.B #$10                
                    STA $7D                   
                    LDA $9E,X                 
                    CMP.B #$83                
                    BCC ADDR_01B4F2           
ADDR_01B4E2:        LDA.B #$0F                
                    STA.W $1564,X             
                    LDA $C2,X                 
                    BNE ADDR_01B4F2           
                    INC $C2,X                 
                    LDA.B #$10                
                    STA.W $1558,X             
ADDR_01B4F2:        LDA.B #$01                
                    STA.W $1DF9               ; / Play sound effect 
ADDR_01B4F7:        CLC                       
                    RTS                       ; Return 


DATA_01B4F9:        .db $0E,$F1,$10,$E0,$1F,$F1

DATA_01B4FF:        .db $00,$FF,$00,$FF,$00,$FF

ADDR_01B505:        JSR.W SubHorizPos         
                    LDA $9E,X                 
                    CMP.B #$A9                
                    BEQ ADDR_01B520           
                    CMP.B #$9C                
                    BEQ ADDR_01B51E           
                    CMP.B #$BB                
                    BEQ ADDR_01B51E           
                    CMP.B #$60                
                    BEQ ADDR_01B51E           
                    CMP.B #$49                
                    BNE ADDR_01B522           
ADDR_01B51E:        INY                       
                    INY                       
ADDR_01B520:        INY                       
                    INY                       
ADDR_01B522:        LDA.W DATA_01B4F9,Y       
                    CLC                       
                    ADC $E4,X                 
                    STA $94                   
                    LDA.W DATA_01B4FF,Y       
                    ADC.W $14E0,X             
                    STA $95                   
                    STZ $7B                   
                    CLC                       
                    RTS                       ; Return 

ADDR_01B536:        LDA $C2,X                 
                    BEQ ADDR_01B563           
                    JSR.W ADDR_01B2D1         
                    LDA $9D                   
                    BNE ADDR_01B558           
                    JSR.W ADDR_01ABCC         
                    LDA.W $1491               
                    STA.W $1528,X             
                    JSR.W ADDR_01B457         
                    BCC ADDR_01B558           
                    LDA.B #$01                
                    STA.W $1B9A               
                    LDA.B #$08                
                    STA $B6,X                 
ADDR_01B558:        RTS                       ; Return 

ADDR_01B559:        LDA.W $14C8,X             
                    CMP.B #$08                
                    BEQ ADDR_01B563           
                    JMP.W ADDR_01B666         
ADDR_01B563:        LDA $9D                   
                    BEQ ADDR_01B56A           
                    JMP.W ADDR_01B64E         
ADDR_01B56A:        LDA.W $1588,X             
                    AND.B #$0C                
                    BNE ADDR_01B574           
                    JSR.W ADDR_01ABD8         
ADDR_01B574:        STZ.W $1491               
                    LDA $9E,X                 
                    CMP.B #$A4                
                    BNE ADDR_01B580           
                    JSR.W ADDR_01ABCC         
ADDR_01B580:        LDA $AA,X                 
                    CMP.B #$40                
                    BPL ADDR_01B588           
                    INC $AA,X                 
ADDR_01B588:        LDA.W $164A,X             
                    BEQ ADDR_01B5A6           
                    LDY.B #$F8                
                    LDA $9E,X                 
                    CMP.B #$5D                
                    BCC ADDR_01B597           
                    LDY.B #$FC                
ADDR_01B597:        STY $00                   
                    LDA $AA,X                 
                    BPL ADDR_01B5A1           
                    CMP $00                   
                    BCC ADDR_01B5A6           
ADDR_01B5A1:        SEC                       
                    SBC.B #$02                
                    STA $AA,X                 
ADDR_01B5A6:        LDA $7D                   
                    PHA                       
                    LDA $9E,X                 
                    CMP.B #$A4                
                    BNE ADDR_01B5B5           
                    JSR.W ADDR_01A7E4         
                    CLC                       
                    BRA ADDR_01B5B8           
ADDR_01B5B5:        JSR.W ADDR_01B457         
ADDR_01B5B8:        PLA                       
                    STA $00                   
                    STZ.W $185E               
                    BCC ADDR_01B5E7           
                    LDA $9E,X                 
                    CMP.B #$5D                
                    BCC ADDR_01B5DA           
                    LDY.B #$03                
                    LDA $19                   
                    BNE ADDR_01B5CD           
                    DEY                       
ADDR_01B5CD:        STY $00                   
                    LDA $AA,X                 
                    CMP $00                   
                    BPL ADDR_01B5DA           
                    CLC                       
                    ADC.B #$02                
                    STA $AA,X                 
ADDR_01B5DA:        INC.W $185E               
                    LDA $00                   
                    CMP.B #$20                
                    BCC ADDR_01B5E7           
                    LSR                       
                    LSR                       
                    STA $AA,X                 
ADDR_01B5E7:        LDA.W $185E               
                    CMP.W $151C,X             
                    STA.W $151C,X             
                    BEQ ADDR_01B610           
                    LDA.W $185E               
                    BNE ADDR_01B610           
                    LDA $7D                   
                    BPL ADDR_01B610           
                    LDY.B #$08                
                    LDA $19                   
                    BNE ADDR_01B603           
                    LDY.B #$06                
ADDR_01B603:        STY $00                   
                    LDA $AA,X                 
                    CMP.B #$20                
                    BPL ADDR_01B610           
                    CLC                       
                    ADC $00                   
                    STA $AA,X                 
ADDR_01B610:        LDA.B #$01                
                    AND $13                   
                    BNE ADDR_01B64E           
                    LDA $AA,X                 
                    BEQ ADDR_01B624           
                    BPL ADDR_01B61F           
                    CLC                       
                    ADC.B #$02                
ADDR_01B61F:        SEC                       
                    SBC.B #$01                
                    STA $AA,X                 
ADDR_01B624:        LDY.W $185E               
                    BEQ ADDR_01B631           
                    LDY.B #$05                
                    LDA $19                   
                    BNE ADDR_01B631           
                    LDY.B #$02                
ADDR_01B631:        STY $00                   
                    LDA $D8,X                 
                    PHA                       
                    SEC                       
                    SBC $00                   
                    STA $D8,X                 
                    LDA.W $14D4,X             
                    PHA                       
                    SBC.B #$00                
                    STA.W $14D4,X             
                    JSR.W ADDR_019140         
                    PLA                       
                    STA.W $14D4,X             
                    PLA                       
                    STA $D8,X                 
ADDR_01B64E:        JSR.W ADDR_01AC31         
                    LDA $9E,X                 
                    CMP.B #$A4                
                    BEQ ADDR_01B666           
                    JMP.W ADDR_01B2D1         

DATA_01B65A:        .db $F8,$08,$F8,$08

DATA_01B65E:        .db $F8,$F8,$08,$08

DATA_01B662:        .db $31,$71,$A1,$F1

ADDR_01B666:        JSR.W GetDrawInfoBnk1     
                    PHX                       
                    LDX.B #$03                
ADDR_01B66C:        LDA $00                   
                    CLC                       
                    ADC.W DATA_01B65A,X       
                    STA.W $0300,Y             
                    LDA $01                   
                    CLC                       
                    ADC.W DATA_01B65E,X       
                    STA.W $0301,Y             
                    LDA $14                   
                    LSR                       
                    LSR                       
                    AND.B #$04                
                    LSR                       
                    ADC.B #$AA                
                    STA.W $0302,Y             
                    LDA.W DATA_01B662,X       
                    STA.W $0303,Y             
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_01B66C           
                    PLX                       
                    LDY.B #$02                
                    LDA.B #$03                
                    JMP.W ADDR_01B7BB         

DATA_01B69F:        .db $20,$00

DATA_01B6A1:        .db $01,$FF

DATA_01B6A3:        .db $40,$40

ADDR_01B6A5:        JSR.W ADDR_01AC31         
                    JSR.W ADDR_01B710         
                    JSR.W ADDR_01B852         
                    JSR.W ADDR_01B6B2         
                    RTS                       ; Return 

ADDR_01B6B2:        LDA $C2,X                 
                    AND.B #$01                
                    TAY                       
                    LDA.W $151C,X             
                    CMP.W DATA_01B69F,Y       
                    BEQ ADDR_01B6D1           
                    LDA.W $1540,X             
                    ORA $9D                   
                    BNE ADDR_01B6D0           
                    LDA.W $151C,X             
                    CLC                       
                    ADC.W DATA_01B6A1,Y       
                    STA.W $151C,X             
ADDR_01B6D0:        RTS                       ; Return 

ADDR_01B6D1:        LDA.W DATA_01B6A3,Y       
                    STA.W $1540,X             
                    INC $C2,X                 
                    RTS                       ; Return 

ADDR_01B6DA:        JSR.W ADDR_01AC31         
                    JSR.W ADDR_01B710         
                    JSR.W ADDR_01B852         
                    JSR.W ADDR_01B6E7         
                    RTS                       ; Return 

ADDR_01B6E7:        LDY $C2,X                 
                    LDA.W $151C,X             
                    CMP.W DATA_01B69F,Y       
                    BEQ ADDR_01B703           
                    LDA.W $1540,X             
                    ORA $9D                   
                    BNE ADDR_01B702           
                    LDA.W $151C,X             
                    CLC                       
                    ADC.W DATA_01B6A1,Y       
                    STA.W $151C,X             
ADDR_01B702:        RTS                       ; Return 

ADDR_01B703:        LDA.W DATA_01B6A3,Y       
                    STA.W $1540,X             
                    LDA $C2,X                 
                    EOR.B #$01                
                    STA $C2,X                 
                    RTS                       ; Return 

ADDR_01B710:        JSR.W GetDrawInfoBnk1     
                    STZ $00                   
                    STZ $01                   
                    STZ $02                   
                    STZ $03                   
                    LDA $C2,X                 
                    AND.B #$02                
                    TAY                       
                    LDA.W $151C,X             
                    STA.W $0000,Y             
                    LSR                       
                    STA.W $0001,Y             
                    LDY.W $15EA,X             
                    LDA $D8,X                 
                    SEC                       
                    SBC $1C                   
                    STA.W $0311,Y             
                    PHA                       
                    PHA                       
                    PHA                       
                    SEC                       
                    SBC $02                   
                    STA.W $0309,Y             
                    PLA                       
                    SEC                       
                    SBC $03                   
                    STA.W $030D,Y             
                    PLA                       
                    CLC                       
                    ADC $02                   
                    STA.W $0301,Y             
                    PLA                       
                    CLC                       
                    ADC $03                   
                    STA.W $0305,Y             
                    LDA $E4,X                 
                    SEC                       
                    SBC $1A                   
                    STA.W $0310,Y             
                    PHA                       
                    PHA                       
                    PHA                       
                    SEC                       
                    SBC $00                   
                    STA.W $0308,Y             
                    PLA                       
                    SEC                       
                    SBC $01                   
                    STA.W $030C,Y             
                    PLA                       
                    CLC                       
                    ADC $00                   
                    STA.W $0300,Y             
                    PLA                       
                    CLC                       
                    ADC $01                   
                    STA.W $0304,Y             
                    LDA $C2,X                 
                    LSR                       
                    LSR                       
                    LDA.B #$40                
                    STA.W $0306,Y             
                    STA.W $030E,Y             
                    STA.W $0312,Y             
                    STA.W $030A,Y             
                    STA.W $0302,Y             
                    LDA $64                   
                    STA.W $030F,Y             
                    STA.W $0307,Y             
                    STA.W $030B,Y             
                    STA.W $0313,Y             
                    ORA.B #$60                
                    STA.W $0303,Y             
                    LDA $00                   
                    PHA                       
                    LDA $02                   
                    PHA                       
                    LDA.B #$04                
                    JSR.W ADDR_01B37E         
                    PLA                       
                    STA $02                   
                    PLA                       
                    STA $00                   
                    RTS                       ; Return 

ADDR_01B7B3:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_01B7BB         
                    PLB                       
                    RTL                       ; Return 

ADDR_01B7BB:        STY $0B                   
                    STA $08                   
                    LDY.W $15EA,X             
                    LDA $D8,X                 
                    STA $00                   
                    SEC                       
                    SBC $1C                   
                    STA $06                   
                    LDA.W $14D4,X             
                    STA $01                   
                    LDA $E4,X                 
                    STA $02                   
                    SEC                       
                    SBC $1A                   
                    STA $07                   
                    LDA.W $14E0,X             
                    STA $03                   
ADDR_01B7DE:        TYA                       
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA $0B                   
                    BPL ADDR_01B7F0           
                    LDA.W $0460,X             
                    AND.B #$02                
                    STA.W $0460,X             
                    BRA ADDR_01B7F3           
ADDR_01B7F0:        STA.W $0460,X             
ADDR_01B7F3:        LDX.B #$00                
                    LDA.W $0300,Y             
                    SEC                       
                    SBC $07                   
                    BPL ADDR_01B7FE           
                    DEX                       
ADDR_01B7FE:        CLC                       
                    ADC $02                   
                    STA $04                   
                    TXA                       
                    ADC $03                   
                    STA $05                   
                    JSR.W ADDR_01B844         
                    BCC ADDR_01B819           
                    TYA                       
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W $0460,X             
                    ORA.B #$01                
                    STA.W $0460,X             
ADDR_01B819:        LDX.B #$00                
                    LDA.W $0301,Y             
                    SEC                       
                    SBC $06                   
                    BPL ADDR_01B824           
                    DEX                       
ADDR_01B824:        CLC                       
                    ADC $00                   
                    STA $09                   
                    TXA                       
                    ADC $01                   
                    STA $0A                   
                    JSR.W ADDR_01C9BF         
                    BCC ADDR_01B838           
                    LDA.B #$F0                
                    STA.W $0301,Y             
ADDR_01B838:        INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEC $08                   
                    BPL ADDR_01B7DE           
                    LDX.W $15E9               
                    RTS                       ; Return 

ADDR_01B844:        REP #$20                  ; Accum (16 bit) 
                    LDA $04                   
                    SEC                       
                    SBC $1A                   
                    CMP.W #$0100              
                    SEP #$20                  ; Accum (8 bit) 
                    RTS                       ; Return 

                    RTS                       

ADDR_01B852:        LDA.W $15C4,X             
                    BNE ADDR_01B8B1           
                    LDA $71                   
                    CMP.B #$01                
                    BCS ADDR_01B8B1           
                    JSR.W ADDR_01B8FF         
                    BCC ADDR_01B8B1           
                    LDA $D8,X                 
                    SEC                       
                    SBC $1C                   
                    STA $02                   
                    SEC                       
                    SBC $0D                   
                    STA $09                   
                    LDA $80                   
                    CLC                       
                    ADC.B #$18                
                    CMP $09                   
                    BCS ADDR_01B8B2           
                    LDA $7D                   
                    BMI ADDR_01B8B1           
                    STZ $7D                   
                    LDA.B #$01                
                    STA.W $1471               
                    LDA $0D                   
                    CLC                       
                    ADC.B #$1F                
                    LDY.W $187A               
                    BEQ ADDR_01B88F           
                    CLC                       
                    ADC.B #$10                
ADDR_01B88F:        STA $00                   
                    LDA $D8,X                 
                    SEC                       
                    SBC $00                   
                    STA $96                   
                    LDA.W $14D4,X             
                    SBC.B #$00                
                    STA $97                   
                    LDY.B #$00                
                    LDA.W $1491               
                    BPL ADDR_01B8A7           
                    DEY                       
ADDR_01B8A7:        CLC                       
                    ADC $94                   
                    STA $94                   
                    TYA                       
                    ADC $95                   
                    STA $95                   
ADDR_01B8B1:        RTS                       ; Return 

ADDR_01B8B2:        LDA $02                   
                    CLC                       
                    ADC $0D                   
                    STA $02                   
                    LDA.B #$FF                
                    LDY $73                   
                    BNE ADDR_01B8C3           
                    LDY $19                   
                    BNE ADDR_01B8C5           
ADDR_01B8C3:        LDA.B #$08                
ADDR_01B8C5:        CLC                       
                    ADC $80                   
                    CMP $02                   
                    BCC ADDR_01B8D5           
                    LDA $7D                   
                    BPL ADDR_01B8D4           
                    LDA.B #$10                
                    STA $7D                   
ADDR_01B8D4:        RTS                       ; Return 

ADDR_01B8D5:        LDA $0E                   
                    CLC                       
                    ADC.B #$10                
                    STA $00                   
                    LDY.B #$00                
                    LDA $E4,X                 
                    SEC                       
                    SBC $1A                   
                    CMP $7E                   
                    BCC ADDR_01B8EF           
                    LDA $00                   
                    EOR.B #$FF                
                    INC A                     
                    STA $00                   
                    DEY                       
ADDR_01B8EF:        LDA $E4,X                 
                    CLC                       
                    ADC $00                   
                    STA $94                   
                    TYA                       
                    ADC.W $14E0,X             
                    STA $95                   
                    STZ $7B                   
                    RTS                       ; Return 

ADDR_01B8FF:        LDA $00                   
                    STA $0E                   
                    LDA $02                   
                    STA $0D                   
                    LDA $E4,X                 
                    SEC                       
                    SBC $00                   
                    STA $04                   
                    LDA.W $14E0,X             
                    SBC.B #$00                
                    STA $0A                   
                    LDA $00                   
                    ASL                       
                    CLC                       
                    ADC.B #$10                
                    STA $06                   
                    LDA $D8,X                 
                    SEC                       
                    SBC $02                   
                    STA $05                   
                    LDA.W $14D4,X             
                    SBC.B #$00                
                    STA $0B                   
                    LDA $02                   
                    ASL                       
                    CLC                       
                    ADC.B #$10                
                    STA $07                   
                    JSL.L ADDR_03B664         
                    JSL.L ADDR_03B72B         
                    RTS                       ; Return 


DATA_01B93C:        .db $08,$F8

ADDR_01B93E:        JSR.W SubHorizPos         
                    LDA.W DATA_01B93C,Y       
                    STA $B6,X                 
                    BRA ADDR_01B950           
ADDR_01B948:        INC $C2,X                 
                    INC $B6,X                 
                    LDA.B #$F8                
                    STA $AA,X                 
ADDR_01B950:        LDA $E4,X                 
                    LDY.B #$00                
                    AND.B #$10                
                    BNE ADDR_01B959           
                    INY                       
ADDR_01B959:        TYA                       
                    STA.W $1632,X             
                    LDA.W $15F6,X             
                    AND.B #$02                
                    BNE ADDR_01B968           
                    ASL $B6,X                 
                    ASL $AA,X                 
ADDR_01B968:        RTS                       ; Return 


DATA_01B969:        .db $02,$02,$03,$04,$03,$02,$02,$02
                    .db $01,$02

DATA_01B973:        .db $01,$01,$00,$00,$00,$01,$01,$01
                    .db $01,$01

DATA_01B97D:        .db $03,$0C

ADDR_01B97F:        LDA.W $1540,X             
                    BEQ ADDR_01B9FB           
                    CMP.B #$30                
                    BCC ADDR_01B9A0           
                    CMP.B #$40                
                    BCC ADDR_01B9A3           
                    BNE ADDR_01B9A0           
                    LDY $9D                   
                    BNE ADDR_01B9A0           
                    LDA.W $1632,X             
                    EOR.B #$01                
                    STA.W $1632,X             
                    JSR.W ADDR_019098         
                    JSR.W ADDR_01BA7F         
ADDR_01B9A0:        JMP.W ADDR_01BA37         
ADDR_01B9A3:        LDY $D8,X                 
                    PHY                       
                    LDY.W $14D4,X             
                    PHY                       
                    LDY.B #$00                
                    CMP.B #$38                
                    BCC ADDR_01B9B1           
                    INY                       
ADDR_01B9B1:        LDA $C2,X                 
                    BEQ ADDR_01B9CC           
                    INY                       
                    INY                       
                    LDA $D8,X                 
                    SEC                       
                    SBC.B #$0C                
                    STA $D8,X                 
                    LDA.W $14D4,X             
                    SBC.B #$00                
                    STA.W $14D4,X             
                    LDA.W $1632,X             
                    BEQ ADDR_01B9CC           
                    INY                       
ADDR_01B9CC:        LDA.W $1EEB               
                    BPL ADDR_01B9D6           
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
ADDR_01B9D6:        LDA.W DATA_01B969,Y       
                    STA.W $1602,X             
                    LDA.W DATA_01B973,Y       
                    STA $00                   
                    LDA.W $15F6,X             
                    PHA                       
                    AND.B #$FE                
                    ORA $00                   
                    STA.W $15F6,X             
                    JSR.W ADDR_019D67         
                    PLA                       
                    STA.W $15F6,X             
                    PLA                       
                    STA.W $14D4,X             
                    PLA                       
                    STA $D8,X                 
                    RTS                       ; Return 

ADDR_01B9FB:        LDA $9D                   
                    BNE ADDR_01BA53           
                    JSR.W ADDR_019140         
                    LDY $C2,X                 
                    LDA.W $1588,X             
                    AND.W DATA_01B97D,Y       
                    BEQ ADDR_01BA14           
ADDR_01BA0C:        JSR.W ADDR_019098         
                    JSR.W ADDR_01BA7F         
                    BRA ADDR_01BA37           
ADDR_01BA14:        LDA.W $185F               
                    LDY $AA,X                 
                    BEQ ADDR_01BA27           
                    BPL ADDR_01BA1F           
                    BMI ADDR_01BA2A           
ADDR_01BA1F:        CMP.B #$07                
                    BCC ADDR_01BA0C           
                    CMP.B #$1D                
                    BCS ADDR_01BA0C           
ADDR_01BA27:        LDA.W $1860               
ADDR_01BA2A:        CMP.B #$07                
                    BCC ADDR_01BA32           
                    CMP.B #$1D                
                    BCC ADDR_01BA37           
ADDR_01BA32:        LDA.B #$50                
                    STA.W $1540,X             
ADDR_01BA37:        LDA $9D                   
                    BNE ADDR_01BA53           
                    INC.W $1570,X             
                    JSR.W ADDR_019A15         
                    LDA $C2,X                 
                    BNE ADDR_01BA4A           
                    JSR.W ADDR_01ABCC         
                    BRA ADDR_01BA4D           
ADDR_01BA4A:        JSR.W ADDR_01ABD8         
ADDR_01BA4D:        JSR.W ADDR_01A7E4         
                    JSR.W ADDR_01AC31         
ADDR_01BA53:        LDA.W $157C,X             
                    PHA                       
                    LDA.W $1570,X             
                    AND.B #$08                
                    LSR                       
                    LSR                       
                    LSR                       
                    STA.W $157C,X             
                    LDA $64                   
                    PHA                       
                    LDA.W $1632,X             
                    STA.W $1602,X             
                    LDA.W $1632,X             
                    BEQ ADDR_01BA74           
                    LDA.B #$10                
                    STA $64                   
ADDR_01BA74:        JSR.W ADDR_019D67         
                    PLA                       
                    STA $64                   
                    PLA                       
                    STA.W $157C,X             
                    RTS                       ; Return 

ADDR_01BA7F:        LDA $AA,X                 
                    EOR.B #$FF                
                    INC A                     
                    STA $AA,X                 
                    RTS                       ; Return 

ADDR_01BA87:        LDA $E4,X                 
                    CLC                       
                    ADC.B #$08                
                    STA $E4,X                 
                    LDA $D8,X                 
                    ADC.B #$07                
                    STA $D8,X                 
                    RTS                       ; Return 


DATA_01BA95:        .db $30,$54

DATA_01BA97:        .db $00,$01,$02,$04,$06,$09,$0C,$0D
                    .db $14,$0D,$0C,$09,$06,$04,$02,$01
DATA_01BAA7:        .db $00,$00,$00,$00,$00,$01,$01,$01
                    .db $02,$01,$01,$01,$00,$00,$00,$00
DATA_01BAB7:        .db $00,$10,$00,$00,$10,$00,$01,$11
                    .db $01,$05,$15,$05,$05,$15,$05,$00
                    .db $00,$00,$03,$13,$03

ADDR_01BACC:        RTS                       ; Return 

ADDR_01BACD:        JSR.W ADDR_01AC31         
                    LDA.W $154C,X             
                    CMP.B #$01                
                    BNE ADDR_01BAF5           
                    LDA.B #$0F                
                    STA.W $1DF9               ; / Play sound effect 
                    LDA.B #$19                
                    JSL.L ADDR_03C000         
                    LDA.B #$1F                
                    STA.W $1540,X             
                    STA.W $149D               
                    LDA $94                   
                    SEC                       
                    SBC.B #$10                
                    SEC                       
                    SBC $E4,X                 
                    STA.W $1878               
ADDR_01BAF5:        LDA.W $1540,X             
                    ORA.W $154C,X             
                    BNE ADDR_01BB16           
                    JSL.L ADDR_03B69F         
                    JSR.W ADDR_01BC1D         
                    JSL.L ADDR_03B72B         
                    BCC ADDR_01BB16           
                    LDA.W $149E               
                    CMP.B #$01                
                    BNE ADDR_01BB16           
                    LDA.B #$06                
                    STA.W $154C,X             
ADDR_01BB16:        LDA.W $1540,X             
                    BEQ ADDR_01BACC           
                    CMP.B #$01                
                    BNE ADDR_01BB27           
                    PHA                       
                    LDA.B #$1A                
                    JSL.L ADDR_03C000         
                    PLA                       
ADDR_01BB27:        CMP.B #$10                
                    BNE ADDR_01BB33           
                    LDA.W $13F9               
                    EOR.B #$01                
                    STA.W $13F9               
ADDR_01BB33:        LDA.B #$30                
                    STA.W $15EA,X             
                    STA $03                   
                    TAY                       
                    LDA $E4,X                 
                    SEC                       
                    SBC $1A                   
                    STA $00                   
                    LDA $D8,X                 
                    SEC                       
                    SBC $1C                   
                    STA $01                   
                    LDA.W $1540,X             
                    LSR                       
                    STA $02                   
                    TAX                       
                    LDA.W DATA_01BAA7,X       
                    STA $06                   
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_01BA97,X       
                    STA.W $0300,Y             
                    STA.W $0304,Y             
                    STA.W $0308,Y             
                    LDA $06                   
                    CMP.B #$02                
                    BEQ ADDR_01BB8E           
                    LDA $00                   
                    CLC                       
                    ADC.B #$20                
                    SEC                       
                    SBC.W DATA_01BA97,X       
                    STA.W $030C,Y             
                    STA.W $0310,Y             
                    STA.W $0314,Y             
                    LDA $06                   
                    BNE ADDR_01BB8E           
                    LDA $00                   
                    CLC                       
                    ADC.B #$10                
                    STA.W $0318,Y             
                    STA.W $031C,Y             
                    STA.W $0320,Y             
ADDR_01BB8E:        LDA $01                   
                    STA.W $0301,Y             
                    STA.W $030D,Y             
                    STA.W $0319,Y             
                    CLC                       
                    ADC.B #$10                
                    STA.W $0305,Y             
                    STA.W $0311,Y             
                    STA.W $031D,Y             
                    CLC                       
                    ADC.B #$10                
                    STA.W $0309,Y             
                    STA.W $0315,Y             
                    STA.W $0321,Y             
                    LDA.B #$08                
                    STA $07                   
                    LDA $06                   
                    ASL                       
                    ASL                       
                    ASL                       
                    ADC $06                   
                    TAX                       
ADDR_01BBBD:        LDA.W DATA_01BAB7,X       
                    STA.W $0302,Y             
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    INX                       
                    DEC $07                   
                    BPL ADDR_01BBBD           
                    LDY $03                   
                    LDX.B #$08                
ADDR_01BBD0:        LDA $64                   
                    ORA.B #$09                
                    CPX.B #$06                
                    BCS ADDR_01BBDA           
                    ORA.B #$40                
ADDR_01BBDA:        CPX.B #$00                
                    BEQ ADDR_01BBE6           
                    CPX.B #$03                
                    BEQ ADDR_01BBE6           
                    CPX.B #$06                
                    BNE ADDR_01BBE8           
ADDR_01BBE6:        ORA.B #$80                
ADDR_01BBE8:        STA.W $0303,Y             
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_01BBD0           
                    LDA $06                   
                    PHA                       
                    LDX.W $15E9               
                    LDA.B #$08                
                    JSR.W ADDR_01B37E         
                    LDY.B #$0C                
                    PLA                       
                    BEQ ADDR_01BC1C           
                    CMP.B #$02                
                    BNE ADDR_01BC11           
                    LDA.B #$03                
                    STA.W $0463,Y             
                    STA.W $0464,Y             
                    STA.W $0465,Y             
ADDR_01BC11:        LDA.B #$03                
                    STA.W $0466,Y             
                    STA.W $0467,Y             
                    STA.W $0468,Y             
ADDR_01BC1C:        RTS                       ; Return 

ADDR_01BC1D:        LDA $94                   
                    STA $00                   
                    LDA $96                   
                    STA $01                   
                    LDA.B #$10                
                    STA $02                   
                    STA $03                   
                    LDA $95                   
                    STA $08                   
                    LDA $97                   
                    STA $09                   
                    RTS                       ; Return 


DATA_01BC34:        .db $05,$07,$09,$0B

ADDR_01BC38:        LDA $9D                   
                    BEQ ADDR_01BC3F           
                    JMP.W ADDR_01BCBD         
ADDR_01BC3F:        JSR.W ADDR_01B14E         
                    JSR.W ADDR_01ABD8         
                    JSR.W ADDR_01ABCC         
                    LDA $AA,X                 
                    PHA                       
                    LDA.B #$FF                
                    STA $AA,X                 
                    JSR.W ADDR_019140         
                    PLA                       
                    STA $AA,X                 
                    JSR.W ADDR_018014         
                    BEQ ADDR_01BCBD           
                    LDA.W $15A0,X             
                    BNE ADDR_01BCBD           
                    LDA.B #$01                
                    STA.W $1DF9               ; / Play sound effect 
                    STZ.W $14C8,X             
                    LDA.W $185F               
                    SEC                       
                    SBC.B #$11                
                    CMP.B #$1D                
                    BCS ADDR_01BCB9           
                    JSL.L ADDR_01ACF9         
                    ADC.W $148E               
                    ADC $7B                   
                    ADC $13                   
                    LDY.B #$78                
                    CMP.B #$35                
                    BEQ ADDR_01BC90           
                    LDY.B #$21                
                    CMP.B #$08                
                    BCC ADDR_01BC90           
                    LDY.B #$27                
                    CMP.B #$F7                
                    BCS ADDR_01BC90           
                    LDY.B #$07                
ADDR_01BC90:        STY $9E,X                 
                    LDA.B #$08                
                    STA.W $14C8,X             
                    JSL.L ADDR_07F7D2         
                    LDA $9B                   
                    STA.W $14E0,X             
                    LDA $9A                   
                    AND.B #$F0                
                    STA $E4,X                 
                    LDA $99                   
                    STA.W $14D4,X             
                    LDA $98                   
                    AND.B #$F0                
                    STA $D8,X                 
                    LDA.B #$02                
                    STA $9C                   
                    JSL.L ADDR_00BEB0         
ADDR_01BCB9:        JSR.W ADDR_01BD98         
                    RTS                       ; Return 

ADDR_01BCBD:        JSR.W ADDR_018FC1         
                    LDA $13                   
                    LSR                       
                    LSR                       
                    AND.B #$03                
                    TAY                       
                    LDA.W DATA_01BC34,Y       
                    STA.W $15F6,X             
                    JSR.W ADDR_01BCF0         
                    JSR.W ADDR_01AC31         
                    LDA $D8,X                 
                    SEC                       
                    SBC $1C                   
                    CMP.B #$E0                
                    BCC ADDR_01BCDF           
                    STZ.W $14C8,X             
ADDR_01BCDF:        RTS                       ; Return 


DATA_01BCE0:        .db $00,$01,$02,$05,$08,$0B,$0E,$0F
                    .db $10,$0F,$0E,$0B,$08,$05,$02,$01

ADDR_01BCF0:        JSR.W GetDrawInfoBnk1     
                    LDA $14                   
                    LSR                       
                    AND.B #$0F                
                    STA $03                   
                    CLC                       
                    ADC.B #$0C                
                    AND.B #$0F                
                    STA $02                   
                    LDA $01                   
                    SEC                       
                    SBC.B #$04                
                    STA $01                   
                    LDA $00                   
                    SEC                       
                    SBC.B #$04                
                    STA $00                   
                    LDX $02                   
                    LDA $01                   
                    CLC                       
                    ADC.W DATA_01BCE0,X       
                    STA.W $0301,Y             
                    LDX $03                   
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_01BCE0,X       
                    STA.W $0300,Y             
                    LDA $02                   
                    CLC                       
                    ADC.B #$05                
                    AND.B #$0F                
                    STA $02                   
                    TAX                       
                    LDA $01                   
                    CLC                       
                    ADC.W DATA_01BCE0,X       
                    STA.W $0305,Y             
                    LDA $03                   
                    CLC                       
                    ADC.B #$05                
                    AND.B #$0F                
                    STA $03                   
                    TAX                       
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_01BCE0,X       
                    STA.W $0304,Y             
                    LDA $02                   
                    CLC                       
                    ADC.B #$05                
                    AND.B #$0F                
                    STA $02                   
                    TAX                       
                    LDA $01                   
                    CLC                       
                    ADC.W DATA_01BCE0,X       
                    STA.W $0309,Y             
                    LDA $03                   
                    CLC                       
                    ADC.B #$05                
                    AND.B #$0F                
                    STA $03                   
                    TAX                       
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_01BCE0,X       
                    STA.W $0308,Y             
                    LDX.W $15E9               
                    LDA.W $15F6,X             
                    ORA $64                   
                    STA.W $0303,Y             
                    STA.W $0307,Y             
                    STA.W $030B,Y             
                    LDA.B #$88                
                    STA.W $0302,Y             
                    LDA.B #$89                
                    STA.W $0306,Y             
                    LDA.B #$98                
                    STA.W $030A,Y             
                    LDY.B #$00                
                    LDA.B #$02                
                    JMP.W ADDR_01B7BB         
ADDR_01BD98:        LDY.B #$03                
ADDR_01BD9A:        LDA.W $17C0,Y             
                    BEQ ADDR_01BDA3           
                    DEY                       
                    BPL ADDR_01BD9A           
                    RTS                       ; Return 

ADDR_01BDA3:        LDA.B #$01                
                    STA.W $17C0,Y             
                    LDA $E4,X                 
                    STA.W $17C8,Y             
                    LDA $D8,X                 
                    STA.W $17C4,Y             
                    LDA.B #$1B                
                    STA.W $17CC,Y             
                    RTS                       ; Return 

ADDR_01BDB8:        LDY.B #$09                
ADDR_01BDBA:        CPY.W $15E9               
                    BEQ ADDR_01BDCF           
                    LDA.W $14C8,Y             
                    BEQ ADDR_01BDCF           
                    LDA.W $009E,Y             
                    CMP.B #$1F                
                    BNE ADDR_01BDCF           
                    STZ.W $14C8,X             
                    RTS                       ; Return 

ADDR_01BDCF:        DEY                       
                    BPL ADDR_01BDBA           
                    STZ.W $18BF               
                    RTS                       ; Return 

ADDR_01BDD6:        LDA.B #$01                
                    STA.W $15D0,X             
                    LDA.W $15A0,X             
                    BEQ ADDR_01BDE2           
                    STZ $C2,X                 
ADDR_01BDE2:        LDA $C2,X                 
                    AND.B #$03                
                    JSL.L ExecutePtr          

Ptrs01BDEA:         .dw ADDR_01BDF2           
                    .dw ADDR_01BE5F           
                    .dw ADDR_01BE6E           
                    .dw ADDR_01BF16           

ADDR_01BDF2:        LDA.W $18BF               
                    BEQ ADDR_01BDFB           
                    STZ.W $14C8,X             
                    RTS                       ; Return 

ADDR_01BDFB:        LDA $9D                   
                    BNE ADDR_01BE5E           
                    LDY.B #$24                
                    STY $40                   
                    LDA.W $1540,X             
                    BNE ADDR_01BE5E           
                    JSL.L ADDR_01ACF9         
                    CMP.B #$D1                
                    BCS ADDR_01BE5E           
                    CLC                       
                    ADC $1C                   
                    AND.B #$F0                
                    STA $D8,X                 
                    LDA $1D                   
                    ADC.B #$00                
                    STA.W $14D4,X             
                    JSL.L ADDR_01ACF9         
                    CLC                       
                    ADC $1A                   
                    AND.B #$F0                
                    STA $E4,X                 
                    LDA $1B                   
                    ADC.B #$00                
                    STA.W $14E0,X             
                    JSR.W SubHorizPos         
                    LDA $0F                   
                    CLC                       
                    ADC.B #$20                
                    CMP.B #$40                
                    BCC ADDR_01BE5E           
                    STZ $AA,X                 
                    LDA.B #$01                
                    STA $B6,X                 
                    JSR.W ADDR_019140         
                    JSR.W ADDR_01800E         
                    BEQ ADDR_01BE5E           
                    LDA.W $1862               
                    BNE ADDR_01BE5E           
                    INC $C2,X                 
                    STZ.W $1570,X             
                    JSR.W ADDR_01BE82         
                    JSR.W SubHorizPos         
                    TYA                       
                    STA.W $157C,X             
ADDR_01BE5E:        RTS                       ; Return 

ADDR_01BE5F:        JSR.W ADDR_01C004         
                    STZ.W $1602,X             
                    JSR.W ADDR_019D67         
                    RTS                       ; Return 


DATA_01BE69:        .db $04,$02,$00

DATA_01BE6C:        .db $10,$F8

ADDR_01BE6E:        STZ.W $15D0,X             
                    JSR.W ADDR_018FC1         
                    JSR.W SubHorizPos         
                    TYA                       
                    STA.W $157C,X             
                    LDA.W $1540,X             
                    BNE ADDR_01BE86           
                    INC $C2,X                 
ADDR_01BE82:        LDY.B #$34                
                    STY $40                   
ADDR_01BE86:        CMP.B #$40                
                    BNE ADDR_01BE96           
                    PHA                       
                    LDA $9D                   
                    ORA.W $15A0,X             
                    BNE ADDR_01BE95           
                    JSR.W ADDR_01BF1D         
ADDR_01BE95:        PLA                       
ADDR_01BE96:        LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    PHY                       
                    LDA.W $1540,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.B #$01                
                    ORA.W DATA_01BE69,Y       
                    STA.W $1602,X             
                    JSR.W ADDR_019D67         
                    LDA.W $1602,X             
                    SEC                       
                    SBC.B #$02                
                    CMP.B #$02                
                    BCC ADDR_01BEC6           
                    LSR                       
                    BCC ADDR_01BEC6           
                    LDA.W $15EA,X             
                    TAX                       
                    INC.W $0301,X             
                    LDX.W $15E9               
ADDR_01BEC6:        PLY                       
                    CPY.B #$01                
                    BNE ADDR_01BECE           
                    JSR.W ADDR_01B14E         
ADDR_01BECE:        LDA.W $1602,X             
                    CMP.B #$04                
                    BCC ADDR_01BF15           
                    LDY.W $157C,X             
                    LDA $E4,X                 
                    CLC                       
                    ADC.W DATA_01BE6C,Y       
                    SEC                       
                    SBC $1A                   
                    LDY.W $15EA,X             
                    STA.W $0308,Y             
                    LDA $D8,X                 
                    SEC                       
                    SBC $1C                   
                    CLC                       
                    ADC.B #$10                
                    STA.W $0309,Y             
                    LDA.W $157C,X             
                    LSR                       
                    LDA.B #$00                
                    BCS ADDR_01BEFC           
                    ORA.B #$40                
ADDR_01BEFC:        ORA $64                   
                    ORA.W $15F6,X             
                    STA.W $030B,Y             
                    LDA.B #$99                
                    STA.W $030A,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$00                
                    ORA.W $15A0,X             
                    STA.W $0462,Y             
ADDR_01BF15:        RTS                       ; Return 

ADDR_01BF16:        JSR.W ADDR_01BFE3         
                    JSR.W ADDR_019D67         
                    RTS                       ; Return 

ADDR_01BF1D:        LDY.B #$09                
ADDR_01BF1F:        LDA.W $14C8,Y             
                    BEQ ADDR_01BF28           
                    DEY                       
                    BPL ADDR_01BF1F           
                    RTS                       ; Return 

ADDR_01BF28:        LDA.B #$10                
                    STA.W $1DF9               ; / Play sound effect 
                    LDA.B #$08                
                    STA.W $14C8,Y             
                    LDA.B #$20                
                    STA.W $009E,Y             
                    LDA $E4,X                 
                    STA.W $00E4,Y             
                    LDA.W $14E0,X             
                    STA.W $14E0,Y             
                    LDA $D8,X                 
                    CLC                       
                    ADC.B #$0A                
                    STA.W $00D8,Y             
                    LDA.W $14D4,X             
                    ADC.B #$00                
                    STA.W $14D4,Y             
                    TYX                       
                    JSL.L ADDR_07F7D2         
                    LDA.B #$20                
                    JSR.W ADDR_01BF6A         
                    LDX.W $15E9               
                    LDA $00                   
                    STA.W $00AA,Y             
                    LDA $01                   
                    STA.W $00B6,Y             
                    RTS                       ; Return 

ADDR_01BF6A:        STA $01                   
                    PHX                       
                    PHY                       
                    JSR.W ADDR_01AD42         
                    STY $02                   
                    LDA $0E                   
                    BPL ADDR_01BF7C           
                    EOR.B #$FF                
                    CLC                       
                    ADC.B #$01                
ADDR_01BF7C:        STA $0C                   
                    JSR.W SubHorizPos         
                    STY $03                   
                    LDA $0F                   
                    BPL ADDR_01BF8C           
                    EOR.B #$FF                
                    CLC                       
                    ADC.B #$01                
ADDR_01BF8C:        STA $0D                   
                    LDY.B #$00                
                    LDA $0D                   
                    CMP $0C                   
                    BCS ADDR_01BF9F           
                    INY                       
                    PHA                       
                    LDA $0C                   
                    STA $0D                   
                    PLA                       
                    STA $0C                   
ADDR_01BF9F:        LDA.B #$00                
                    STA $0B                   
                    STA $00                   
                    LDX $01                   
ADDR_01BFA7:        LDA $0B                   
                    CLC                       
                    ADC $0C                   
                    CMP $0D                   
                    BCC ADDR_01BFB4           
                    SBC $0D                   
                    INC $00                   
ADDR_01BFB4:        STA $0B                   
                    DEX                       
                    BNE ADDR_01BFA7           
                    TYA                       
                    BEQ ADDR_01BFC6           
                    LDA $00                   
                    PHA                       
                    LDA $01                   
                    STA $00                   
                    PLA                       
                    STA $01                   
ADDR_01BFC6:        LDA $00                   
                    LDY $02                   
                    BEQ ADDR_01BFD3           
                    EOR.B #$FF                
                    CLC                       
                    ADC.B #$01                
                    STA $00                   
ADDR_01BFD3:        LDA $01                   
                    LDY $03                   
                    BEQ ADDR_01BFE0           
                    EOR.B #$FF                
                    CLC                       
                    ADC.B #$01                
                    STA $01                   
ADDR_01BFE0:        PLY                       
                    PLX                       
                    RTS                       ; Return 

ADDR_01BFE3:        LDA.W $1540,X             
                    BNE ADDR_01C000           
                    LDA.B #$02                
                    STA.W $1540,X             
                    DEC.W $1570,X             
                    LDA.W $1570,X             
                    CMP.B #$00                
                    BNE ADDR_01C001           
                    INC $C2,X                 
                    LDA.B #$10                
                    STA.W $1540,X             
                    PLA                       
                    PLA                       
ADDR_01C000:        RTS                       ; Return 

ADDR_01C001:        JMP.W ADDR_01C028         
ADDR_01C004:        LDA.W $1540,X             
                    BNE ADDR_01C05E           
                    LDA.B #$04                
                    STA.W $1540,X             
                    INC.W $1570,X             
                    LDA.W $1570,X             
                    CMP.B #$09                
                    BNE ADDR_01C01C           
                    LDY.B #$24                
                    STY $40                   
ADDR_01C01C:        CMP.B #$09                
                    BNE ADDR_01C028           
                    INC $C2,X                 
                    LDA.B #$70                
                    STA.W $1540,X             
                    RTS                       ; Return 

ADDR_01C028:        LDA.W $1570,X             
                    DEC A                     
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    TAX                       
                    STZ $00                   
                    LDY.W $0681               
ADDR_01C036:        LDA.L MagiKoopaPals,X     
                    STA.W $0684,Y             
                    INY                       
                    INX                       
                    INC $00                   
                    LDA $00                   
                    CMP.B #$10                
                    BNE ADDR_01C036           
                    LDX.W $0681               
                    LDA.B #$10                
                    STA.W $0682,X             
                    LDA.B #$F0                
                    STA.W $0683,X             
                    STZ.W $0694,X             
                    TXA                       
                    CLC                       
                    ADC.B #$12                
                    STA.W $0681               
ADDR_01C05E:        LDX.W $15E9               
                    RTS                       ; Return 

                    JSR.W ADDR_01C075         
                    LDA $D8,X                 
                    SEC                       
                    SBC.B #$4C                
                    STA $D8,X                 
                    LDA.W $14D4,X             
                    SBC.B #$00                
                    STA.W $14D4,X             
                    RTS                       ; Return 

ADDR_01C075:        LDA $E4,X                 
                    SEC                       
                    SBC.B #$08                
                    STA $C2,X                 
                    LDA.W $14E0,X             
                    SBC.B #$00                
                    STA.W $151C,X             
                    LDA $D8,X                 
                    STA.W $1528,X             
                    LDA.W $14D4,X             
                    STA.W $187B,X             
                    AND.B #$01                
                    STA.W $14D4,X             
                    STA.W $1534,X             
                    RTS                       ; Return 

ADDR_01C098:        JSR.W ADDR_01C12D         
                    LDA $9D                   
                    BNE ADDR_01C0A4           
                    LDA.W $1602,X             
                    BEQ ADDR_01C0A7           
ADDR_01C0A4:        RTS                       ; Return 


DATA_01C0A5:        .db $10,$F0

ADDR_01C0A7:        LDA.W $1540,X             
                    BNE ADDR_01C0B4           
                    LDA.B #$7C                
                    STA.W $1540,X             
                    INC.W $1588,X             
ADDR_01C0B4:        LDA.W $1588,X             
                    AND.B #$01                
                    TAY                       
                    LDA.W DATA_01C0A5,Y       
                    STA $AA,X                 
                    JSR.W ADDR_01ABD8         
                    LDA $C2,X                 
                    STA $00                   
                    LDA.W $151C,X             
                    STA $01                   
                    REP #$20                  ; Accum (16 bit) 
                    LDA $94                   
                    SEC                       
                    SBC $00                   
                    CMP.W #$0010              
                    SEP #$20                  ; Accum (8 bit) 
                    BCS ADDR_01C12C           
                    LDA.W $1528,X             
                    CMP $96                   
                    LDA.W $1534,X             
                    AND.B #$01                
                    SBC $97                   
                    BCC ADDR_01C12C           
                    LDA.W $187B,X             
                    LSR                       
                    LSR                       
                    STA.W $141C               
                    LDA.B #$0C                
                    STA.W $1DFB               ; / Play sound effect 
                    LDA.B #$FF                
                    STA.W $0DDA               
                    LDA.B #$FF                
                    STA.W $1493               
                    STZ.W $1490               
                    INC.W $1602,X             
                    JSR.W ADDR_01A7E4         
                    BCC ADDR_01C125           
                    LDA.B #$09                
                    STA.W $1DFC               ; / Play sound effect 
                    INC.W $160E,X             
                    LDA.W $1528,X             
                    SEC                       
                    SBC $D8,X                 
                    STA.W $1594,X             
                    LDA.B #$80                
                    STA.W $1540,X             
                    JSL.L ADDR_07F252         
                    BRA ADDR_01C128           
ADDR_01C125:        STZ.W $1686,X             
ADDR_01C128:        JSL.L ADDR_00FA80         
ADDR_01C12C:        RTS                       ; Return 

ADDR_01C12D:        LDA.W $160E,X             
                    BNE ADDR_01C175           
                    JSR.W GetDrawInfoBnk1     
                    LDA $00                   
                    SEC                       
                    SBC.B #$08                
                    STA.W $0300,Y             
                    CLC                       
                    ADC.B #$08                
                    STA.W $0304,Y             
                    CLC                       
                    ADC.B #$08                
                    STA.W $0308,Y             
                    LDA $01                   
                    CLC                       
                    ADC.B #$08                
                    STA.W $0301,Y             
                    STA.W $0305,Y             
                    STA.W $0309,Y             
                    LDA.B #$D4                
                    STA.W $0302,Y             
                    INC A                     
                    STA.W $0306,Y             
                    STA.W $030A,Y             
                    LDA.B #$32                
                    STA.W $0303,Y             
                    STA.W $0307,Y             
                    STA.W $030B,Y             
                    LDY.B #$00                
                    LDA.B #$02                
                    JMP.W ADDR_01B7BB         
ADDR_01C175:        LDA.W $1540,X             
                    BEQ ADDR_01C17F           
                    JSL.L ADDR_07F1CA         
                    RTS                       ; Return 

ADDR_01C17F:        STZ.W $14C8,X             
                    RTS                       ; Return 

ADDR_01C183:        LDA $64                   
                    PHA                       
                    LDA.W $1540,X             
                    CMP.B #$20                
                    BCC ADDR_01C191           
                    LDA.B #$10                
                    STA $64                   
ADDR_01C191:        JSR.W ADDR_019F0D         
                    LDY.W $15EA,X             
                    LDA $14                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LDA.B #$AC                
                    BCC ADDR_01C1A3           
                    LDA.B #$AE                
ADDR_01C1A3:        STA.W $0302,Y             
                    PLA                       
                    STA $64                   
                    LDA $9D                   
                    BNE ADDR_01C1ED           
                    LDA.B #$F0                
                    STA $AA,X                 
                    JSR.W ADDR_01ABD8         
                    LDA.W $1540,X             
                    CMP.B #$20                
                    BCS ADDR_01C1CB           
                    JSR.W ADDR_019140         
                    LDA.W $1588,X             
                    BNE ADDR_01C1C8           
                    LDA.W $14D4,X             
                    BPL ADDR_01C1CB           
ADDR_01C1C8:        JMP.W OffScrEraseSprite   
ADDR_01C1CB:        LDA $D8,X                 
                    AND.B #$0F                
                    CMP.B #$00                
                    BNE ADDR_01C1ED           
                    LDA $E4,X                 
                    STA $9A                   
                    LDA.W $14E0,X             
                    STA $9B                   
                    LDA $D8,X                 
                    STA $98                   
                    LDA.W $14D4,X             
                    STA $99                   
                    LDA.B #$03                
                    STA $9C                   
                    JSL.L ADDR_00BEB0         
ADDR_01C1ED:        RTS                       ; Return 


DATA_01C1EE:        .db $FF,$01

DATA_01C1F0:        .db $F0,$10

ADDR_01C1F2:        LDA.W $14C8,X             
                    CMP.B #$0C                
                    BEQ ADDR_01C255           
                    LDA $9D                   
                    BNE ADDR_01C255           
                    LDA $9E,X                 
                    CMP.B #$7D                
                    BNE ADDR_01C21D           
                    LDA.W $1540,X             
                    BEQ ADDR_01C21D           
                    LDA $64                   
                    PHA                       
                    LDA.B #$10                
                    STA $64                   
                    JSR.W ADDR_01C61A         
                    PLA                       
                    STA $64                   
                    LDA.B #$F8                
                    STA $AA,X                 
                    JSR.W ADDR_01ABD8         
                    RTS                       ; Return 

ADDR_01C21D:        LDA $13                   
                    AND.B #$01                
                    BNE ADDR_01C239           
                    LDA.W $151C,X             
                    AND.B #$01                
                    TAY                       
                    LDA $AA,X                 
                    CLC                       
                    ADC.W DATA_01C1EE,Y       
                    STA $AA,X                 
                    CMP.W DATA_01C1F0,Y       
                    BNE ADDR_01C239           
                    INC.W $151C,X             
ADDR_01C239:        LDA.B #$0C                
                    STA $B6,X                 
                    JSR.W ADDR_01ABCC         
                    LDA $AA,X                 
                    PHA                       
                    CLC                       
                    SEC                       
                    SBC.B #$02                
                    STA $AA,X                 
                    JSR.W ADDR_01ABD8         
                    PLA                       
                    STA $AA,X                 
                    JSR.W ADDR_01AC31         
                    INC.W $1570,X             
ADDR_01C255:        LDA $9E,X                 
                    CMP.B #$7D                
                    BNE ADDR_01C262           
                    LDA.B #$01                
                    STA.W $157C,X             
                    BRA ADDR_01C27F           
ADDR_01C262:        LDA $C2,X                 
                    CMP.B #$02                
                    BNE ADDR_01C27C           
                    LDA $13                   
                    AND.B #$03                
                    BNE ADDR_01C271           
                    JSR.W ADDR_01B14E         
ADDR_01C271:        LDA $14                   
                    LSR                       
                    AND.B #$0E                
                    EOR.W $15F6,X             
                    STA.W $15F6,X             
ADDR_01C27C:        JSR.W ADDR_019E95         
ADDR_01C27F:        LDA $C2,X                 
                    BEQ ADDR_01C287           
                    JSR.W GetDrawInfoBnk1     
                    RTS                       ; Return 

ADDR_01C287:        JSR.W ADDR_01C61A         
                    JSR.W ADDR_01A7E4         
                    BCC ADDR_01C2D2           
                    LDA $9E,X                 
                    CMP.B #$7E                
                    BNE ADDR_01C2A6           
                    JSR.W ADDR_01C4F0         
                    LDA.B #$05                
                    JSL.L ADDR_05B329         
                    LDA.B #$03                
                    JSL.L GivePoints          
                    BRA ADDR_01C30F           
ADDR_01C2A6:        CMP.B #$7F                
                    BNE ADDR_01C2AF           
                    JSR.W GiveMario1Up        
                    BRA ADDR_01C30F           
ADDR_01C2AF:        CMP.B #$80                
                    BNE ADDR_01C2CE           
                    LDA $7D                   
                    BMI ADDR_01C2D2           
                    LDA.B #$09                
                    STA.W $14C8,X             
                    LDA.B #$D0                
                    STA $7D                   
                    STZ $AA,X                 
                    STZ.W $1540,X             
                    LDA.W $167A,X             
                    AND.B #$7F                
                    STA.W $167A,X             
                    RTS                       ; Return 

ADDR_01C2CE:        CMP.B #$7D                
                    BEQ ADDR_01C2D3           
ADDR_01C2D2:        RTS                       ; Return 

ADDR_01C2D3:        LDY.B #$0B                
ADDR_01C2D5:        LDA.W $14C8,Y             
                    CMP.B #$0B                
                    BNE ADDR_01C2E8           
                    LDA.W $009E,Y             
                    CMP.B #$7D                
                    BEQ ADDR_01C2E8           
                    LDA.B #$09                
                    STA.W $14C8,Y             
ADDR_01C2E8:        DEY                       
                    BPL ADDR_01C2D5           
                    LDA.B #$00                
                    LDY.W $13F3               
                    BNE ADDR_01C2F4           
                    LDA.B #$0B                
ADDR_01C2F4:        STA.W $14C8,X             
                    LDA $7D                   
                    STA $AA,X                 
                    LDA $7B                   
                    STA $B6,X                 
                    LDA.B #$09                
                    STA.W $13F3               
                    LDA.B #$FF                
                    STA.W $1891               
                    LDA.B #$1E                
                    STA.W $1DF9               ; / Play sound effect 
                    RTS                       ; Return 

ADDR_01C30F:        STZ.W $14C8,X             
                    RTS                       ; Return 


DATA_01C313:        .db $74,$75,$77,$76

ADDR_01C317:        LDA.B #$01                
                    STA.W $151C,X             
                    LDA.W $15D0,X             
                    BNE ADDR_01C324           
                    INC.W $187B,X             
ADDR_01C324:        LDA.W $187B,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.B #$03                
                    TAY                       
                    LDA.W DATA_01C313,Y       
                    STA $9E,X                 
                    JSL.L ADDR_07F78B         
                    JSR.W PowerUpRt           
                    LDA.B #$81                
                    STA $9E,X                 
                    JSL.L ADDR_07F78B         
                    RTS                       ; Return 


DATA_01C345:        .db $02,$02,$04,$06

ADDR_01C349:        LDA $14                   
                    AND.B #$08                
                    LSR                       
                    LSR                       
                    LSR                       
                    STA.W $157C,X             
PowerUpRt:          LDA.W $160E,X             
                    BEQ ADDR_01C371           
                    JSR.W ADDR_019F0D         
                    LDY.W $15EA,X             
                    LDA.B #$80                
                    STA.W $0302,Y             
                    PHX                       
                    LDX.W $18D6               
                    LDA.W DATA_01C345,X       
                    ORA $64                   
                    STA.W $0303,Y             
                    PLX                       
                    RTS                       ; Return 

ADDR_01C371:        LDA $64                   
                    PHA                       
                    JSR.W ADDR_01C4AC         
                    LDA.W $1534,X             
                    BEQ ADDR_01C38F           
                    LDA $9D                   
                    BNE ADDR_01C387           
                    LDA.B #$10                
                    STA $AA,X                 
                    JSR.W ADDR_01ABD8         
ADDR_01C387:        LDA $14                   
                    AND.B #$0C                
                    BNE ADDR_01C3AB           
                    PLA                       
                    RTS                       ; Return 

ADDR_01C38F:        LDA.W $1540,X             
                    BEQ ADDR_01C3AE           
                    JSR.W ADDR_019140         
                    LDA.W $1528,X             
                    BNE ADDR_01C3A0           
                    LDA.B #$10                
                    STA $64                   
ADDR_01C3A0:        LDA $9D                   
                    BNE ADDR_01C3AB           
                    LDA.B #$FC                
                    STA $AA,X                 
                    JSR.W ADDR_01ABD8         
ADDR_01C3AB:        JMP.W ADDR_01C48D         
ADDR_01C3AE:        LDA $9D                   
                    BNE ADDR_01C3AB           
                    LDA.W $14C8,X             
                    CMP.B #$0C                
                    BEQ ADDR_01C3AB           
                    LDA $9E,X                 
                    CMP.B #$76                ; \ Useless code, branch nowhere if not a star 
                    BNE ADDR_01C3BF           ; / 
ADDR_01C3BF:        INC.W $1570,X             
                    JSR.W ADDR_018DBB         
                    LDA $9E,X                 
                    CMP.B #$75                ; flower 
                    BNE ADDR_01C3D2           
                    LDA.W $151C,X             
                    BNE ADDR_01C3D2           
                    STZ $B6,X                 
ADDR_01C3D2:        CMP.B #$76                ; star 
                    BEQ ADDR_01C3E1           
                    CMP.B #$21                ; sprite coin 
                    BEQ ADDR_01C3E1           
                    LDA.W $151C,X             
                    BNE ADDR_01C3E1           
                    ASL $B6,X                 
ADDR_01C3E1:        LDA $C2,X                 
                    BEQ ADDR_01C3F3           
                    BMI ADDR_01C3F1           
                    JSR.W ADDR_019140         
                    LDA.W $1588,X             
                    BNE ADDR_01C3F1           
                    STZ $C2,X                 
ADDR_01C3F1:        BRA ADDR_01C437           
ADDR_01C3F3:        LDA.W $0D9B               
                    CMP.B #$C1                
                    BEQ ADDR_01C42C           
                    BIT.W $0D9B               
                    BVC ADDR_01C42C           
                    STZ.W $1588,X             
                    STZ $B6,X                 
                    LDA.W $14D4,X             
                    BNE ADDR_01C41E           
                    LDA $D8,X                 
                    CMP.B #$A0                
                    BCC ADDR_01C41E           
                    AND.B #$F0                
                    STA $D8,X                 
                    LDA.W $1588,X             
                    ORA.B #$04                
                    STA.W $1588,X             
                    JSR.W ADDR_018DBB         
ADDR_01C41E:        JSR.W ADDR_01ABCC         
                    JSR.W ADDR_01ABD8         
                    INC $AA,X                 
                    INC $AA,X                 
                    INC $AA,X                 
                    BRA ADDR_01C42F           
ADDR_01C42C:        JSR.W ADDR_019032         
ADDR_01C42F:        LDA $13                   
                    AND.B #$03                
                    BEQ ADDR_01C437           
                    DEC $AA,X                 
ADDR_01C437:        JSR.W ADDR_01AC31         
                    JSR.W ADDR_018014         
                    BEQ ADDR_01C443           
                    LDA.B #$00                
                    STA $AA,X                 
ADDR_01C443:        JSR.W ADDR_01800E         
                    BNE ADDR_01C44A           
                    BRA ADDR_01C47E           
ADDR_01C44A:        LDA $9E,X                 
                    CMP.B #$21                ; sprite coin 
                    BNE ADDR_01C46C           
                    JSR.W ADDR_018DBB         
                    LDA $AA,X                 
                    INC A                     
                    PHA                       
                    JSR.W ADDR_019A04         
                    PLA                       
                    LSR                       
                    JSR.W ADDR_01CCEC         
                    CMP.B #$FC                
                    BCS ADDR_01C46A           
                    LDY.W $1588,X             
                    BMI ADDR_01C46A           
                    STA $AA,X                 
ADDR_01C46A:        BRA ADDR_01C47E           
ADDR_01C46C:        JSR.W ADDR_019A04         
                    LDA.W $151C,X             
                    BNE ADDR_01C47A           
                    LDA $9E,X                 
                    CMP.B #$76                ; star 
                    BNE ADDR_01C47E           
ADDR_01C47A:        LDA.B #$C8                
                    STA $AA,X                 
ADDR_01C47E:        LDA.W $1558,X             
                    ORA $C2,X                 
                    BNE ADDR_01C48D           
                    JSR.W ADDR_018008         
                    BEQ ADDR_01C48D           
                    JSR.W ADDR_019098         
ADDR_01C48D:        LDA.W $1540,X             
                    CMP.B #$36                
                    BCS ADDR_01C4A8           
                    LDA $C2,X                 
                    BEQ ADDR_01C49C           
                    CMP.B #$FF                
                    BNE ADDR_01C4A1           
ADDR_01C49C:        LDA.W $1632,X             
                    BEQ ADDR_01C4A5           
ADDR_01C4A1:        LDA.B #$10                
                    STA $64                   
ADDR_01C4A5:        JSR.W ADDR_01C61A         
ADDR_01C4A8:        PLA                       
                    STA $64                   
ADDR_01C4AB:        RTS                       ; Return 

ADDR_01C4AC:        JSR.W ADDR_01A80F         
                    BCC ADDR_01C4AB           
                    LDA.W $151C,X             
                    BEQ ADDR_01C4BA           
                    LDA $C2,X                 
                    BNE ADDR_01C4FA           
ADDR_01C4BA:        LDA.W $154C,X             
                    BNE ADDR_01C4FA           
ADDR_01C4BF:        LDA.W $1540,X             
                    CMP.B #$18                
                    BCS ADDR_01C4FA           
                    STZ.W $14C8,X             
                    LDA $9E,X                 
                    CMP.B #$21                
                    BNE TouchedPowerUp018AFC  
                    JSL.L ADDR_05B34A         
                    LDA.W $15F6,X             
                    AND.B #$0E                
                    CMP.B #$02                
                    BEQ ADDR_01C4E0           
                    LDA.B #$01                
                    BRA ADDR_01C4EC           
ADDR_01C4E0:        LDA.W $18DD               
                    INC.W $18DD               
                    CMP.B #$0A                
                    BCC ADDR_01C4EC           
                    LDA.B #$0A                
ADDR_01C4EC:        JSL.L GivePoints          
ADDR_01C4F0:        LDY.B #$03                
ADDR_01C4F2:        LDA.W $17C0,Y             
                    BEQ ADDR_01C4FB           
                    DEY                       
                    BPL ADDR_01C4F2           
ADDR_01C4FA:        RTS                       ; Return 

ADDR_01C4FB:        LDA.B #$05                
                    STA.W $17C0,Y             
                    LDA $E4,X                 
                    STA.W $17C8,Y             
                    LDA $D8,X                 
                    STA.W $17C4,Y             
                    LDA.B #$10                
                    STA.W $17CC,Y             
                    RTS                       ; Return 


ItemBoxSprite:      .db $00,$01,$01,$01,$00,$01,$04,$02
                    .db $00,$00,$00,$00,$00,$01,$04,$02
                    .db $00,$00,$00,$00

GivePowerPtrIndex:  .db $00,$01,$01,$01,$04,$04,$04,$01
                    .db $02,$02,$02,$02,$03,$03,$01,$03
                    .db $05,$05,$05,$05

TouchedPowerUp018AFC:SEC                       ; \ Index created from... 
                    SBC.B #$74                ;  | ... powerup touched (upper 2 bits)  
                    ASL                       ;  | 
                    ASL                       ;  | 
                    ORA $19                   ;  | ... Mario's status (lower 3 bits) 
                    TAY                       ; / 
                    LDA.W ItemBoxSprite,Y     ; \ Put appropriate item in item box 
                    BEQ NoItem                ;  | 
                    STA.W $0DC2               ; / 
                    LDA.B #$0B                ; \  
                    STA.W $1DFC               ; / Play sound effect 
NoItem:             LDA.W GivePowerPtrIndex,Y ; \ Call routine to change Mario's status 
                    JSL.L ExecutePtr          ; / 

Ptrs01C554:         .dw GiveMarioMushroom     ; 0 - Big 
                    .dw ADDR_01C56F           ; 1 - No change 
                    .dw GiveMarioStar         ; 2 - Star 
                    .dw GiveMarioCape         ; 3 - Cape 
                    .dw GiveMarioFire         ; 4 - Fire 
                    .dw GiveMario1Up          ; 5 - 1Up 

                    RTS                       

GiveMarioMushroom:  LDA.B #$02                ; \ Set growing action 
                    STA $71                   ; / 
                    LDA.B #$2F                ; \  
                    STA.W $1496,Y             ;  | Set animation timer 
                    STA $9D                   ; / Set lock sprites timer 
                    JMP.W ADDR_01C56F         ; JMP to next instruction? 
ADDR_01C56F:        LDA.B #$04                
                    LDY.W $1534,X             
                    BNE ADDR_01C57A           
                    JSL.L GivePoints          
ADDR_01C57A:        LDA.B #$0A                ; \ 
                    STA.W $1DF9               ; / 
                    RTS                       ; Return 

ADDR_01C580:        LDA.B #$FF                
                    STA.W $1490               
                    LDA.B #$0D                
                    STA.W $1DFB               ; / Play sound effect 
                    ASL.W $0DDA               
                    SEC                       
                    ROR.W $0DDA               
                    RTL                       ; Return 

GiveMarioStar:      JSL.L ADDR_01C580         
                    BRA ADDR_01C56F           
GiveMarioCape:      LDA.B #$02                
                    STA $19                   
                    LDA.B #$0D                
                    STA.W $1DF9               ; / Play sound effect 
                    LDA.B #$04                
                    JSL.L GivePoints          
                    JSL.L ADDR_01C5AE         
                    INC $9D                   
                    RTS                       ; Return 

ADDR_01C5AE:        LDA $81                   
                    ORA $7F                   
                    BNE ADDR_01C5EB           
                    LDA.B #$03                
                    STA $71                   
                    LDA.B #$18                
                    STA.W $1496               
                    LDY.B #$03                
ADDR_01C5BF:        LDA.W $17C0,Y             
                    BEQ ADDR_01C5D4           
                    DEY                       
                    BPL ADDR_01C5BF           
                    DEC.W $1863               
                    BPL ADDR_01C5D1           
                    LDA.B #$03                
                    STA.W $1863               
ADDR_01C5D1:        LDY.W $1863               
ADDR_01C5D4:        LDA.B #$81                
                    STA.W $17C0,Y             
                    LDA.B #$1B                
                    STA.W $17CC,Y             
                    LDA $96                   
                    CLC                       
                    ADC.B #$08                
                    STA.W $17C4,Y             
                    LDA $94                   
                    STA.W $17C8,Y             
ADDR_01C5EB:        RTL                       ; Return 

GiveMarioFire:      LDA.B #$20                
                    STA.W $149B               
                    STA $9D                   
                    LDA.B #$04                
                    STA $71                   
                    LDA.B #$03                
                    STA $19                   
                    JMP.W ADDR_01C56F         
GiveMario1Up:       LDA.B #$08                
                    CLC                       
                    ADC.W $1594,X             
                    JSL.L GivePoints          
                    RTS                       ; Return 


PowerUpTiles:       .db $24,$26,$48,$0E,$24,$00,$00,$00
                    .db $00,$E4,$E8,$24,$EC

StarPalValues:      .db $00,$04,$08,$04

ADDR_01C61A:        JSR.W GetDrawInfoBnk1     
                    STZ $0A                   
                    LDA.W $140F               
                    BNE ADDR_01C636           
                    LDA.W $0D9B               
                    CMP.B #$C1                
                    BEQ ADDR_01C636           
                    BIT.W $0D9B               
                    BVC ADDR_01C636           
                    LDA.B #$D8                
                    STA.W $15EA,X             
                    TAY                       
ADDR_01C636:        LDA $9E,X                 
                    CMP.B #$21                ; sprite coin 
                    BNE PowerUpGfxRt          
                    JSL.L ADDR_01C641         
                    RTS                       ; Return 

ADDR_01C641:        JSR.W ADDR_01C645         
                    RTL                       ; Return 

ADDR_01C645:        JSR.W GetDrawInfoBnk1     
                    LDA $00                   
                    STA.W $0300,Y             
                    LDA $01                   
                    STA.W $0301,Y             
                    LDA.B #$E8                
                    STA.W $0302,Y             
                    LDA.W $15F6,X             
                    ORA $64                   
                    STA.W $0303,Y             
                    TXA                       
                    CLC                       
                    ADC $14                   
                    LSR                       
                    LSR                       
                    AND.B #$03                
                    BNE ADDR_01C670           
                    LDY.B #$02                

Instr01C66B:        .db $80

ADDR_01C66C:        .db $2D

DATA_01C66D:        .db $EA,$FA,$EA

ADDR_01C670:        PHX                       
                    TAX                       
                    LDA $00                   
                    CLC                       
                    ADC.B #$04                
                    STA.W $0300,Y             
                    STA.W $0304,Y             
                    LDA $01                   
                    CLC                       
                    ADC.B #$08                
                    STA.W $0305,Y             
                    LDA.L ADDR_01C66C,X       
                    STA.W $0302,Y             
                    STA.W $0306,Y             
                    LDA.W $0303,Y             
                    ORA.B #$80                
                    STA.W $0307,Y             
                    PLX                       
                    LDY.B #$00                
                    LDA.B #$01                
                    JSL.L ADDR_01B7B3         
                    RTS                       ; Return 

PowerUpGfxRt:       CMP.B #$76                ; \ Setup flashing palette for star 
                    BNE NoFlashingPal         ;  | 
                    LDA $13                   ;  |  
                    LSR                       ;  | 
                    AND.B #$03                ;  | 
                    PHY                       ;  | 
                    TAY                       ;  | 
                    LDA.W StarPalValues,Y     ;  | 
                    PLY                       ;  | 
                    STA $0A                   ; / $0A contains palette info, will be applied later 
NoFlashingPal:      LDA $00                   
                    STA.W $0300,Y             
                    LDA $01                   
                    DEC A                     
                    STA.W $0301,Y             
                    LDA.W $157C,X             
                    LSR                       
                    LDA.B #$00                
                    BCS ADDR_01C6C7           
                    ORA.B #$40                
ADDR_01C6C7:        ORA $64                   
                    ORA.W $15F6,X             
                    EOR $0A                   
                    STA.W $0303,Y             
                    LDA $9E,X                 
                    SEC                       
                    SBC.B #$74                
                    TAX                       
                    LDA.W PowerUpTiles,X      
                    STA.W $0302,Y             
                    LDX.W $15E9               
                    LDA.B #$00                
                    JSR.W ADDR_01B37E         
                    RTS                       ; Return 


DATA_01C6E6:        .db $02,$FE

DATA_01C6E8:        .db $20,$E0

DATA_01C6EA:        .db $0A,$F6

                    PHP                       
ADDR_01C6ED:        LDA $9D                   
                    BNE ADDR_01C744           
                    LDA $C2,X                 
                    BEQ ADDR_01C701           
                    JSR.W ADDR_019140         
                    LDA.W $1588,X             
                    BNE ADDR_01C6FF           
                    STZ $C2,X                 
ADDR_01C6FF:        BRA ADDR_01C741           
ADDR_01C701:        LDA.W $14C8,X             
                    CMP.B #$0C                
                    BEQ ADDR_01C744           
                    LDA.W $154C,X             
                    BEQ ADDR_01C715           
                    JSR.W ADDR_01ABD8         
                    INC $AA,X                 
                    JMP.W ADDR_01C741         
ADDR_01C715:        LDA.W $1528,X             
                    AND.B #$01                
                    TAY                       
                    LDA $B6,X                 
                    CLC                       
                    ADC.W DATA_01C6E6,Y       
                    STA $B6,X                 
                    CMP.W DATA_01C6E8,Y       
                    BNE ADDR_01C72B           
                    INC.W $1528,X             
ADDR_01C72B:        LDA $B6,X                 
                    BPL ADDR_01C730           
                    INY                       
ADDR_01C730:        LDA.W DATA_01C6EA,Y       
                    CLC                       
                    ADC.B #$06                
                    STA $AA,X                 
                    JSR.W ADDR_01AC31         
                    JSR.W ADDR_01ABCC         
                    JSR.W ADDR_01ABD8         
ADDR_01C741:        JSR.W ADDR_019A15         
ADDR_01C744:        JSR.W ADDR_01C4AC         
                    JMP.W ADDR_01C61A         
ADDR_01C74A:        LDA.B #$80                
                    STA.W $151C,X             
                    LDA.B #$01                
                    STA.W $1528,X             
                    LDA $E4,X                 
                    CLC                       
                    ADC.B #$78                
                    STA $E4,X                 
                    LDA.W $14E0,X             
                    ADC.B #$00                
                    STA.W $14E0,X             
                    LDA $D8,X                 
                    CLC                       
                    ADC.B #$68                
                    STA $D8,X                 
                    LDA.W $14D4,X             
                    ADC.B #$00                
                    STA.W $14D4,X             
                    RTS                       ; Return 

ADDR_01C773:        JSR.W ADDR_01AC27         
                    LDA $9D                   
                    BNE ADDR_01C795           
                    LDA $13                   
                    AND.B #$03                
                    ORA.W $1602,X             
                    BNE ADDR_01C795           
                    LDA.B #$01                
                    LDY.W $1504,X             
                    BEQ ADDR_01C795           
                    BMI ADDR_01C78E           
                    LDA.B #$FF                
ADDR_01C78E:        CLC                       
                    ADC.W $1504,X             
                    STA.W $1504,X             
ADDR_01C795:        LDA.W $151C,X             
                    PHA                       
                    LDA.W $1528,X             
                    PHA                       
                    LDA.B #$00                
                    SEC                       
                    SBC.W $151C,X             
                    STA.W $151C,X             
                    LDA.B #$02                
                    SBC.W $1528,X             
                    AND.B #$01                
                    STA.W $1528,X             
                    JSR.W ADDR_01CACB         
                    JSR.W ADDR_01CB20         
                    JSR.W ADDR_01CB53         
                    PLA                       
                    STA.W $1528,X             
                    PLA                       
                    STA.W $151C,X             
                    LDA.W $14B8               
                    PHA                       
                    SEC                       
                    SBC $C2,X                 
                    STA.W $1491               
                    PLA                       
                    STA $C2,X                 
                    LDY.W $15EA,X             
                    LDA.W $14BA               
                    SEC                       
                    SBC $1C                   
                    SEC                       
                    SBC.B #$08                
                    STA.W $0301,Y             
                    LDA.W $14B8               
                    SEC                       
                    SBC $1A                   
                    SEC                       
                    SBC.B #$08                
                    STA.W $0300,Y             
                    LDA.B #$A2                
                    STA.W $0302,Y             
                    LDA.B #$31                
                    STA.W $0303,Y             
                    LDY.B #$00                
                    LDA.W $14BA               
                    SEC                       
                    SBC.W $14B2               
                    BPL ADDR_01C802           
                    EOR.B #$FF                
                    INC A                     
                    INY                       
ADDR_01C802:        STY $00                   
                    STA.W $4205               ; Dividend (High-Byte)
                    STZ.W $4204               ; Dividend (Low Byte)
                    LDA.B #$05                
                    STA.W $4206               ; Divisor B
                    JSR.W ADDR_01CC94         
                    LDA.W $4214               ; Quotient of Divide Result (Low Byte)
                    STA $02                   
                    STA $06                   
                    LDA.W $4215               ; Quotient of Divide Result (High Byte)
                    STA $03                   
                    STA $07                   
                    LDY.B #$00                
                    LDA.W $14B8               
                    SEC                       
                    SBC.W $14B0               
                    BPL ADDR_01C82F           
                    EOR.B #$FF                
                    INC A                     
                    INY                       
ADDR_01C82F:        STY $01                   
                    STA.W $4205               ; Dividend (High-Byte)
                    STZ.W $4204               ; Dividend (Low Byte)
                    LDA.B #$05                
                    STA.W $4206               ; Divisor B
                    JSR.W ADDR_01CC94         
                    LDA.W $4214               ; Quotient of Divide Result (Low Byte)
                    STA $04                   
                    STA $08                   
                    LDA.W $4215               ; Quotient of Divide Result (High Byte)
                    STA $05                   
                    STA $09                   
                    LDY.W $15EA,X             
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    LDA.W $14B2               
                    SEC                       
                    SBC $1C                   
                    SEC                       
                    SBC.B #$08                
                    STA $0A                   
                    STA.W $0301,Y             
                    LDA.W $14B0               
                    SEC                       
                    SBC $1A                   
                    SEC                       
                    SBC.B #$08                
                    STA $0B                   
                    STA.W $0300,Y             
                    LDA.B #$A2                
                    STA.W $0302,Y             
                    LDA.B #$31                
                    STA.W $0303,Y             
                    LDX.B #$03                
ADDR_01C87C:        INY                       
                    INY                       
                    INY                       
                    INY                       
                    LDA $00                   
                    BNE ADDR_01C88E           
                    LDA $0A                   
                    CLC                       
                    ADC $07                   
                    STA.W $0301,Y             
                    BRA ADDR_01C896           
ADDR_01C88E:        LDA $0A                   
                    SEC                       
                    SBC $07                   
                    STA.W $0301,Y             
ADDR_01C896:        LDA $06                   
                    CLC                       
                    ADC $02                   
                    STA $06                   
                    LDA $07                   
                    ADC $03                   
                    STA $07                   
                    LDA $01                   
                    BNE ADDR_01C8B1           
                    LDA $0B                   
                    CLC                       
                    ADC $09                   
                    STA.W $0300,Y             
                    BRA ADDR_01C8B9           
ADDR_01C8B1:        LDA $0B                   
                    SEC                       
                    SBC $09                   
                    STA.W $0300,Y             
ADDR_01C8B9:        LDA $08                   
                    CLC                       
                    ADC $04                   
                    STA $08                   
                    LDA $09                   
                    ADC $05                   
                    STA $09                   
                    LDA.B #$A2                
                    STA.W $0302,Y             
                    LDA.B #$31                
                    STA.W $0303,Y             
                    DEX                       
                    BPL ADDR_01C87C           
                    LDX.B #$03                
ADDR_01C8D5:        STX $02                   
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    LDA.W $14BA               
                    SEC                       
                    SBC $1C                   
                    SEC                       
                    SBC.B #$10                
                    STA.W $0301,Y             
                    LDA.W $14B8               
                    SEC                       
                    SBC $1A                   
                    CLC                       
                    ADC.W DATA_01C9B7,X       
                    STA.W $0300,Y             
                    LDA.W DATA_01C9BB,X       
                    STA.W $0302,Y             
                    LDA.B #$31                
                    STA.W $0303,Y             
                    DEX                       
                    BPL ADDR_01C8D5           
                    LDX.W $15E9               
                    LDA.B #$09                
                    STA $08                   
                    LDA.W $14B2               
                    SEC                       
                    SBC.B #$08                
                    STA $00                   
                    LDA.W $14B3               
                    SBC.B #$00                
                    STA $01                   
                    LDA.W $14B0               
                    SEC                       
                    SBC.B #$08                
                    STA $02                   
                    LDA.W $14B1               
                    SBC.B #$00                
                    STA $03                   
                    LDY.W $15EA,X             
                    LDA.W $0305,Y             
                    STA $06                   
                    LDA.W $0304,Y             
                    STA $07                   
ADDR_01C934:        TYA                       
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.B #$02                
                    STA.W $0460,X             
                    LDX.B #$00                
                    LDA.W $0300,Y             
                    SEC                       
                    SBC $07                   
                    BPL ADDR_01C948           
                    DEX                       
ADDR_01C948:        CLC                       
                    ADC $02                   
                    STA $04                   
                    TXA                       
                    ADC $03                   
                    STA $05                   
                    JSR.W ADDR_01B844         
                    BCC ADDR_01C960           
                    TYA                       
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.B #$03                
                    STA.W $0460,X             
ADDR_01C960:        LDX.B #$00                
                    LDA.W $0301,Y             
                    SEC                       
                    SBC $06                   
                    BPL ADDR_01C96B           
                    DEX                       
ADDR_01C96B:        CLC                       
                    ADC $00                   
                    STA $09                   
                    TXA                       
                    ADC $01                   
                    STA $0A                   
                    JSR.W ADDR_01C9BF         
                    BCC ADDR_01C97F           
                    LDA.B #$F0                
                    STA.W $0301,Y             
ADDR_01C97F:        LDA $08                   
                    CMP.B #$09                
                    BNE ADDR_01C999           
                    LDA $04                   
                    STA.W $14B8               
                    LDA $05                   
                    STA.W $14B9               
                    LDA $09                   
                    STA.W $14BA               
                    LDA $0A                   
                    STA.W $14BB               
ADDR_01C999:        INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEC $08                   
                    BPL ADDR_01C934           
                    LDX.W $15E9               
                    LDY.W $15EA,X             
                    LDA.B #$F0                
                    STA.W $0305,Y             
                    LDA $9D                   
                    BNE ADDR_01C9B6           
                    JSR.W ADDR_01CCF0         
                    JMP.W ADDR_01C9EC         
ADDR_01C9B6:        RTS                       ; Return 


DATA_01C9B7:        .db $E0,$F0,$00,$10

DATA_01C9BB:        .db $60,$61,$61,$62

ADDR_01C9BF:        REP #$20                  ; Accum (16 bit) 
                    LDA $09                   
                    PHA                       
                    CLC                       
                    ADC.W #$0010              
                    STA $09                   
                    SEC                       
                    SBC $1C                   
                    CMP.W #$0100              
                    PLA                       
                    STA $09                   
                    SEP #$20                  ; Accum (8 bit) 
ADDR_01C9D5:        RTS                       ; Return 


DATA_01C9D6:        .db $01,$FF

DATA_01C9D8:        .db $40,$C0

ADDR_01C9DA:        LDA.W $160E,X             
                    BEQ ADDR_01C9EB           
                    STZ.W $160E,X             
ADDR_01C9E2:        PHX                       
                    JSL.L ADDR_00E2BD         
                    PLX                       
                    STX.W $15E9               
ADDR_01C9EB:        RTS                       ; Return 

ADDR_01C9EC:        LDA.W $14B9               
                    XBA                       
                    LDA.W $14B8               
                    REP #$20                  ; Accum (16 bit) 
                    SEC                       
                    SBC $1A                   
                    CLC                       
                    ADC.W #$0010              
                    CMP.W #$0120              
                    SEP #$20                  ; Accum (8 bit) 
                    ROL                       
                    AND.B #$01                
                    ORA $9D                   
                    STA.W $15C4,X             
                    BNE ADDR_01C9D5           
                    JSR.W ADDR_01CA9C         
                    STZ.W $1602,X             
                    BCC ADDR_01C9DA           
                    LDA.B #$01                
                    STA.W $160E,X             
                    LDA.W $14BA               
                    SEC                       
                    SBC $1C                   
                    STA $03                   
                    SEC                       
                    SBC.B #$08                
                    STA $0E                   
                    LDA $80                   
                    CLC                       
                    ADC.B #$18                
                    CMP $0E                   
                    BCS ADDR_01CA9B           
                    LDA $7D                   
                    BMI ADDR_01C9E2           
                    STZ $7D                   
                    LDA.B #$03                
                    STA.W $1471               
                    STA.W $1602,X             
                    LDA.B #$28                
                    LDY.W $187A               
                    BEQ ADDR_01CA45           
                    LDA.B #$38                
ADDR_01CA45:        STA $0F                   
                    LDA.W $14BA               
                    SEC                       
                    SBC $0F                   
                    STA $96                   
                    LDA.W $14BB               
                    SBC.B #$00                
                    STA $97                   
                    LDA $77                   
                    AND.B #$03                
                    BNE ADDR_01CA6E           
                    LDY.B #$00                
                    LDA.W $1491               
                    BPL ADDR_01CA64           
                    DEY                       
ADDR_01CA64:        CLC                       
                    ADC $94                   
                    STA $94                   
                    TYA                       
                    ADC $95                   
                    STA $95                   
ADDR_01CA6E:        JSR.W ADDR_01C9E2         
                    LDA $16                   
                    BMI ADDR_01CA79           
                    LDA.B #$FF                
                    STA $78                   
ADDR_01CA79:        LDA $13                   
                    LSR                       
                    BCC ADDR_01CA9B           
                    LDA.W $151C,X             
                    CLC                       
                    ADC.B #$80                
                    LDA.W $1528,X             
                    ADC.B #$00                
                    AND.B #$01                
                    TAY                       
                    LDA.W $1504,X             
                    CMP.W DATA_01C9D8,Y       
                    BEQ ADDR_01CA9B           
                    CLC                       
                    ADC.W DATA_01C9D6,Y       
                    STA.W $1504,X             
ADDR_01CA9B:        RTS                       ; Return 

ADDR_01CA9C:        LDA.W $14B8               
                    SEC                       
                    SBC.B #$18                
                    STA $04                   
                    LDA.W $14B9               
                    SBC.B #$00                
                    STA $0A                   
                    LDA.B #$40                
                    STA $06                   
                    LDA.W $14BA               
                    SEC                       
                    SBC.B #$0C                
                    STA $05                   
                    LDA.W $14BB               
                    SBC.B #$00                
                    STA $0B                   
                    LDA.B #$13                
                    STA $07                   
                    JSL.L ADDR_03B664         
                    JSL.L ADDR_03B72B         
                    RTS                       ; Return 

ADDR_01CACB:        LDA.B #$50                
                    STA.W $14BC               
                    STZ.W $14BF               
                    STZ.W $14BD               
                    STZ.W $14C0               
                    LDA $E4,X                 
                    STA.W $14B4               
                    LDA.W $14E0,X             
                    STA.W $14B5               
                    LDA.W $14B4               
                    SEC                       
                    SBC.W $14BC               
                    STA.W $14B0               
                    LDA.W $14B5               
                    SBC.W $14BD               
                    STA.W $14B1               
                    LDA $D8,X                 
                    STA.W $14B6               
                    LDA.W $14D4,X             
                    STA.W $14B7               
                    LDA.W $14B6               
                    SEC                       
                    SBC.W $14BF               
                    STA.W $14B2               
                    LDA.W $14B7               
                    SBC.W $14C0               
                    STA.W $14B3               
                    LDA.W $151C,X             
                    STA $36                   
                    LDA.W $1528,X             
                    STA $37                   
                    RTS                       ; Return 

ADDR_01CB20:        LDA $37                   
                    STA.W $1866               
                    PHX                       
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA $36                   
                    ASL                       
                    AND.W #$01FF              
                    TAX                       
                    LDA.L CircleCoords,X      
                    STA.W $14C2               
                    LDA $36                   
                    CLC                       
                    ADC.W #$0080              
                    STA $00                   
                    ASL                       
                    AND.W #$01FF              
                    TAX                       
                    LDA.L CircleCoords,X      
                    STA.W $14C5               
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDA $01                   
                    STA.W $1867               
                    PLX                       
                    RTS                       ; Return 

ADDR_01CB53:        REP #$20                  ; Accum (16 bit) 
                    LDA.W $14C5               
                    STA $02                   
                    LDA.W $14BC               
                    STA $00                   
                    SEP #$20                  ; Accum (8 bit) 
                    JSR.W ADDR_01CC28         
                    LDA.W $1867               
                    LSR                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA $04                   
                    BCC ADDR_01CB72           
                    EOR.W #$FFFF              
                    INC A                     
ADDR_01CB72:        STA $08                   
                    LDA $06                   
                    BCC ADDR_01CB7C           
                    EOR.W #$FFFF              
                    INC A                     
ADDR_01CB7C:        STA $0A                   
                    LDA.W $14C2               
                    STA $02                   
                    LDA.W $14BF               
                    STA $00                   
                    SEP #$20                  ; Accum (8 bit) 
                    JSR.W ADDR_01CC28         
                    LDA.W $1866               
                    LSR                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA $04                   
                    BCC ADDR_01CB9B           
                    EOR.W #$FFFF              
                    INC A                     
ADDR_01CB9B:        STA $04                   
                    LDA $06                   
                    BCC ADDR_01CBA5           
                    EOR.W #$FFFF              
                    INC A                     
ADDR_01CBA5:        STA $06                   
                    LDA $04                   
                    CLC                       
                    ADC $08                   
                    STA $04                   
                    LDA $06                   
                    ADC $0A                   
                    STA $06                   
                    LDA $05                   
                    CLC                       
                    ADC.W $14B0               
                    STA.W $14B8               
                    LDA.W $14C5               
                    STA $02                   
                    LDA.W $14BF               
                    STA $00                   
                    SEP #$20                  ; Accum (8 bit) 
                    JSR.W ADDR_01CC28         
                    LDA.W $1867               
                    LSR                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA $04                   
                    BCC ADDR_01CBDA           
                    EOR.W #$FFFF              
                    INC A                     
ADDR_01CBDA:        STA $08                   
                    LDA $06                   
                    BCC ADDR_01CBE4           
                    EOR.W #$FFFF              
                    INC A                     
ADDR_01CBE4:        STA $0A                   
                    LDA.W $14C2               
                    STA $02                   
                    LDA.W $14BC               
                    STA $00                   
                    SEP #$20                  ; Accum (8 bit) 
                    JSR.W ADDR_01CC28         
                    LDA.W $1866               
                    LSR                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA $04                   
                    BCC ADDR_01CC03           
                    EOR.W #$FFFF              
                    INC A                     
ADDR_01CC03:        STA $04                   
                    LDA $06                   
                    BCC ADDR_01CC0D           
                    EOR.W #$FFFF              
                    INC A                     
ADDR_01CC0D:        STA $06                   
                    LDA $04                   
                    SEC                       
                    SBC $08                   
                    STA $04                   
                    LDA $06                   
                    SBC $0A                   
                    STA $06                   
                    LDA.W $14B2               
                    SEC                       
                    SBC $05                   
                    STA.W $14BA               
                    SEP #$20                  ; Accum (8 bit) 
                    RTS                       ; Return 

ADDR_01CC28:        LDA $00                   
                    STA.W $4202               ; Multiplicand A
                    LDA $02                   
                    STA.W $4203               ; Multplier B
                    JSR.W ADDR_01CC94         
                    LDA.W $4216               ; Product/Remainder Result (Low Byte)
                    STA $04                   
                    LDA.W $4217               ; Product/Remainder Result (High Byte)
                    STA $05                   
                    LDA $00                   
                    STA.W $4202               ; Multiplicand A
                    LDA $03                   
                    STA.W $4203               ; Multplier B
                    JSR.W ADDR_01CC94         
                    LDA.W $4216               ; Product/Remainder Result (Low Byte)
                    CLC                       
                    ADC $05                   
                    STA $05                   
                    LDA.W $4217               ; Product/Remainder Result (High Byte)
                    ADC.B #$00                
                    STA $06                   
                    LDA $01                   
                    STA.W $4202               ; Multiplicand A
                    LDA $02                   
                    STA.W $4203               ; Multplier B
                    JSR.W ADDR_01CC94         
                    LDA.W $4216               ; Product/Remainder Result (Low Byte)
                    CLC                       
                    ADC $05                   
                    STA $05                   
                    LDA.W $4217               ; Product/Remainder Result (High Byte)
                    ADC $06                   
                    STA $06                   
                    LDA $01                   
                    STA.W $4202               ; Multiplicand A
                    LDA $03                   
                    STA.W $4203               ; Multplier B
                    JSR.W ADDR_01CC94         
                    LDA.W $4216               ; Product/Remainder Result (Low Byte)
                    CLC                       
                    ADC $06                   
                    STA $06                   
                    LDA.W $4217               ; Product/Remainder Result (High Byte)
                    ADC.B #$00                
                    STA $07                   
                    RTS                       ; Return 

ADDR_01CC94:        NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    RTS                       ; Return 

ADDR_01CC9D:        LDA.W $14B5               
                    ORA.W $14B7               
                    BNE ADDR_01CCC5           
                    JSR.W ADDR_01CCC7         
                    JSR.W ADDR_01CB20         
                    JSR.W ADDR_01CB53         
                    LDA.W $14BA               
                    AND.B #$F0                
                    STA $00                   
                    LDA.W $14B8               
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    ORA $00                   
                    TAY                       
                    LDA.W $0AF6,Y             
                    CMP.B #$15                
                    RTL                       ; Return 

ADDR_01CCC5:        CLC                       
                    RTL                       ; Return 

ADDR_01CCC7:        REP #$20                  ; Accum (16 bit) 
                    LDA $2A                   
                    STA.W $14B0               
                    LDA $2C                   
                    STA.W $14B2               
                    LDA.W $14B4               
                    SEC                       
                    SBC.W $14B0               
                    STA.W $14BC               
                    LDA.W $14B6               
                    SEC                       
                    SBC.W $14B2               
                    STA.W $14BF               
                    SEP #$20                  ; Accum (8 bit) 
                    RTS                       ; Return 

                    RTS                       

                    RTS                       

ADDR_01CCEC:        EOR.B #$FF                
                    INC A                     
                    RTS                       ; Return 

ADDR_01CCF0:        LDA.W $1504,X             
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    CLC                       
                    ADC.W $1510,X             
                    STA.W $1510,X             
                    PHP                       
                    LDY.B #$00                
                    LDA.W $1504,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    CMP.B #$08                
                    BCC ADDR_01CD0F           
                    ORA.B #$F0                
                    DEY                       
ADDR_01CD0F:        PLP                       
                    ADC.W $151C,X             
                    STA.W $151C,X             
                    TYA                       
                    ADC.W $1528,X             
                    STA.W $1528,X             
                    RTS                       ; Return 


DATA_01CD1E:        .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF

ADDR_01CD2A:        JSL.L ADDR_03CC09         
                    RTS                       ; Return 

ADDR_01CD2F:        LDA $D8,X                 
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    STA $C2,X                 
                    CMP.B #$05                
                    BCC ADDR_01CD4E           
                    LDA.B #$78                
                    STA $E4,X                 
                    LDA.B #$40                
                    STA $D8,X                 
                    LDA.B #$01                
                    STA.W $14D4,X             
                    LDA.B #$80                
                    STA.W $1540,X             
                    RTS                       ; Return 

ADDR_01CD4E:        LDY.B #$90                
                    STY $D8,X                 
                    CMP.B #$03                
                    BCC ADDR_01CD5E           
                    JSL.L ADDR_00FCF5         
                    JSR.W FaceMario           
                    RTS                       ; Return 

ADDR_01CD5E:        LDA.B #$01                
                    STA.W $157C,X             
                    LDA.B #$20                
                    STA $38                   
                    STA $39                   
                    JSL.L ADDR_03DD7D         
                    LDY $C2,X                 
                    LDA.W DATA_01CD92,Y       
                    STA.W $187B,X             
                    CMP.B #$01                
                    BEQ ADDR_01CD87           
                    CMP.B #$00                
                    BNE ADDR_01CD81           
                    LDA.B #$70                
                    STA $E4,X                 
ADDR_01CD81:        LDA.B #$01                
                    STA.W $14E0,X             
                    RTS                       ; Return 

ADDR_01CD87:        LDA.B #$26                
                    STA.W $1534,X             
                    LDA.B #$D8                
                    STA.W $160E,X             
                    RTS                       ; Return 


DATA_01CD92:        .db $01,$01,$00,$02,$02,$03,$03

DATA_01CD99:        .db $00,$09,$12

DATA_01CD9C:        .db $00,$01,$02,$03,$04,$05,$06,$07
                    .db $08

DATA_01CDA5:        .db $00,$80

ADDR_01CDA7:        JSR.W GetDrawInfoBnk1     
                    RTS                       ; Return 

ADDR_01CDAB:        STZ.W $13FB               
                    LDA.W $1602,X             
                    CMP.B #$1B                
                    BCS ADDR_01CDD5           
                    LDA.W $15AC,X             
                    CMP.B #$08                
                    LDY.W $157C,X             
                    LDA.W DATA_01CDA5,Y       
                    BCS ADDR_01CDC4           
                    EOR.B #$80                
ADDR_01CDC4:        STA $00                   
                    LDY $C2,X                 
                    LDA.W DATA_01CD99,Y       
                    LDY.W $1602,X             
                    CLC                       
                    ADC.W DATA_01CD9C,Y       
                    CLC                       
                    ADC $00                   
ADDR_01CDD5:        STA.W $1BA2               
                    JSL.L ADDR_03DEDF         
                    JSR.W ADDR_01CDA7         
                    LDA $9D                   
                    BNE ADDR_01CE3D           
                    JSR.W ADDR_01D2A8         
                    JSR.W ADDR_01D3B1         
                    LDA.W $187B,X             
                    CMP.B #$01                
                    BEQ ADDR_01CE0B           
                    LDA.W $163E,X             
                    BNE ADDR_01CE0B           
                    LDA.W $157C,X             
                    PHA                       
                    JSR.W SubHorizPos         
                    TYA                       
                    STA.W $157C,X             
                    PLA                       
                    CMP.W $157C,X             
                    BEQ ADDR_01CE0B           
                    LDA.B #$10                
                    STA.W $15AC,X             
ADDR_01CE0B:        LDA.W $151C,X             
                    JSL.L ExecutePtr          

Ptrs01CE12:         .dw ADDR_01CE1E           
                    .dw ADDR_01CE3E           
                    .dw ADDR_01CE5F           
                    .dw ADDR_01CF7D           
                    .dw ADDR_01CFE0           
                    .dw ADDR_01D043           

ADDR_01CE1E:        LDA.W $187B,X             
                    CMP.B #$01                
                    BNE ADDR_01CE34           
                    STZ.W $1411               
                    INC.W $18A8               
                    STZ.W $18AA               
                    INC $9D                   
                    INC.W $151C,X             
                    RTS                       ; Return 

ADDR_01CE34:        LDA $1A                   
                    CMP.B #$7E                
                    BCC ADDR_01CE3D           
                    INC.W $151C,X             
ADDR_01CE3D:        RTS                       ; Return 

ADDR_01CE3E:        STZ $7B                   
                    JSR.W ADDR_01ABD8         
                    LDA $AA,X                 
                    CMP.B #$40                
                    BPL ADDR_01CE4C           
                    CLC                       
                    ADC.B #$03                
ADDR_01CE4C:        STA $AA,X                 
                    JSR.W ADDR_01D0C0         
                    BCC ADDR_01CE3D           
                    INC.W $151C,X             
                    LDA $C2,X                 
                    CMP.B #$02                
                    BCC ADDR_01CE3D           
                    JMP.W ADDR_01CEA8         
ADDR_01CE5F:        LDA $C2,X                 
                    JSL.L ExecutePtr          

Ptrs01CE65:         .dw ADDR_01D116           
                    .dw ADDR_01D116           
                    .dw ADDR_01CE6B           

ADDR_01CE6B:        LDA.W $1528,X             
                    JSL.L ExecutePtr          

Ptrs01CE72:         .dw ADDR_01CE78           
                    .dw ADDR_01CEB6           
                    .dw ADDR_01CEFD           

ADDR_01CE78:        STZ $36                   
                    STZ $37                   
                    LDA.W $1540,X             
                    BEQ ADDR_01CEA5           
                    LDY.B #$03                
                    AND.B #$30                
                    BNE ADDR_01CE88           
                    INY                       
ADDR_01CE88:        TYA                       
                    LDY.W $15AC,X             
                    BEQ ADDR_01CE90           
                    LDA.B #$05                
ADDR_01CE90:        STA.W $1602,X             
                    LDA.W $1540,X             
                    AND.B #$3F                
                    CMP.B #$2E                
                    BNE ADDR_01CEA4           
                    LDA.B #$30                
                    STA.W $163E,X             
                    JSR.W ADDR_01D059         
ADDR_01CEA4:        RTS                       ; Return 

ADDR_01CEA5:        INC.W $1528,X             
ADDR_01CEA8:        LDA.B #$FF                
                    STA.W $1540,X             
                    RTS                       ; Return 


DATA_01CEAE:        .db $30,$D0

DATA_01CEB0:        .db $1B,$1C,$1D,$1B

DATA_01CEB4:        .db $14,$EC

ADDR_01CEB6:        LDA.W $1540,X             
                    BNE ADDR_01CEDC           
                    JSR.W SubHorizPos         
                    TYA                       
                    CMP.W $14E0,X             
                    BNE ADDR_01CEDC           
                    INC.W $1528,X             
                    LDA.W DATA_01CEB4,Y       
                    STA.W $160E,X             
                    LDA.B #$30                
                    STA.W $1540,X             
                    LDA.B #$60                
                    STA.W $1558,X             
                    LDA.B #$D8                
                    STA $AA,X                 
                    RTS                       ; Return 

ADDR_01CEDC:        JSR.W SubHorizPos         
                    LDA $B6,X                 
                    CMP.W DATA_01CEAE,Y       
                    BEQ ADDR_01CEEC           
                    CLC                       
                    ADC.W DATA_01D4E7,Y       
                    STA $B6,X                 
ADDR_01CEEC:        JSR.W ADDR_01ABCC         
                    LDA $14                   
                    LSR                       
                    LSR                       
                    AND.B #$03                
                    TAY                       
                    LDA.W DATA_01CEB0,Y       
                    STA.W $1602,X             
                    RTS                       ; Return 

ADDR_01CEFD:        LDA.W $1540,X             
                    BEQ ADDR_01CF1C           
                    DEC A                     
                    BNE ADDR_01CF0F           
                    LDA.W $160E,X             
                    STA $B6,X                 
                    LDA.B #$08                
                    STA.W $1DFC               ; / Play sound effect 
ADDR_01CF0F:        LDA $B6,X                 
                    BEQ ADDR_01CF1B           
                    BPL ADDR_01CF19           
                    INC $B6,X                 
                    INC $B6,X                 
ADDR_01CF19:        DEC $B6,X                 
ADDR_01CF1B:        RTS                       ; Return 

ADDR_01CF1C:        JSR.W ADDR_01D0C0         
                    BCC ADDR_01CF2F           
                    LDA $AA,X                 
                    BMI ADDR_01CF2F           
                    STZ $B6,X                 
                    STZ $AA,X                 
                    STZ.W $1528,X             
                    JMP.W ADDR_01CEA8         
ADDR_01CF2F:        JSR.W ADDR_01ABCC         
                    JSR.W ADDR_01ABD8         
                    LDA $13                   
                    LSR                       
                    BCS ADDR_01CF44           
                    LDA $AA,X                 
                    BMI ADDR_01CF42           
                    CMP.B #$70                
                    BCS ADDR_01CF44           
ADDR_01CF42:        INC $AA,X                 
ADDR_01CF44:        LDA.W $1558,X             
                    BNE ADDR_01CF4F           
                    LDA $36                   
                    ORA $37                   
                    BEQ ADDR_01CF67           
ADDR_01CF4F:        LDA $B6,X                 
                    ASL                       
                    LDA.B #$04                
                    LDY.B #$00                
                    BCC ADDR_01CF5B           
                    LDA.B #$FC                
                    DEY                       
ADDR_01CF5B:        CLC                       
                    ADC $36                   
                    STA $36                   
                    TYA                       
                    ADC $37                   
                    AND.B #$01                
                    STA $37                   
ADDR_01CF67:        LDA.B #$06                
                    LDY $AA,X                 
                    BMI ADDR_01CF79           
                    CPY.B #$08                
                    BCC ADDR_01CF79           
                    LDA.B #$05                
                    CPY.B #$10                
                    BCC ADDR_01CF79           
                    LDA.B #$02                
ADDR_01CF79:        STA.W $1602,X             
                    RTS                       ; Return 

ADDR_01CF7D:        JSR.W ADDR_01ABD8         
                    INC $AA,X                 
                    JSR.W ADDR_01D0C0         
                    LDA.W $1540,X             
                    BEQ ADDR_01CFB7           
                    CMP.B #$40                
                    BCC ADDR_01CF9E           
                    BEQ ADDR_01CFC6           
                    LDY.B #$06                
                    LDA $14                   
                    AND.B #$04                
                    BEQ ADDR_01CF99           
                    INY                       
ADDR_01CF99:        TYA                       
                    STA.W $1602,X             
                    RTS                       ; Return 

ADDR_01CF9E:        LDY.W $18A6               
                    LDA $38                   
                    CMP.B #$20                
                    BEQ ADDR_01CFA9           
                    INC $38                   
ADDR_01CFA9:        LDA $39                   
                    CMP.B #$20                
                    BEQ ADDR_01CFB1           
                    DEC $39                   
ADDR_01CFB1:        LDA.B #$07                
                    STA.W $1602,X             
                    RTS                       ; Return 

ADDR_01CFB7:        LDA.B #$02                
                    STA.W $151C,X             
                    LDA $C2,X                 
                    BEQ ADDR_01CFC5           
                    LDA.B #$20                
                    STA.W $164A,X             
ADDR_01CFC5:        RTS                       ; Return 

ADDR_01CFC6:        INC.W $1626,X             
                    LDA.W $1626,X             
                    CMP.B #$03                
                    BCC ADDR_01CFDF           
ADDR_01CFD0:        LDA.B #$1F                
                    STA.W $1DF9               ; / Play sound effect 
                    LDA.B #$04                
                    STA.W $151C,X             
                    LDA.B #$13                
                    STA.W $1540,X             
ADDR_01CFDF:        RTS                       ; Return 

ADDR_01CFE0:        LDY.W $1540,X             
                    BEQ ADDR_01CFFC           
                    LDA $D8,X                 
                    SEC                       
                    SBC.B #$01                
                    STA $D8,X                 
                    BCS ADDR_01CFF1           
                    DEC.W $14D4,X             
ADDR_01CFF1:        DEC $39                   
                    TYA                       
                    AND.B #$03                
                    BEQ ADDR_01CFFA           
                    DEC $38                   
ADDR_01CFFA:        BRA ADDR_01D00F           
ADDR_01CFFC:        LDA $36                   
                    CLC                       
                    ADC.B #$06                
                    STA $36                   
                    LDA $37                   
                    ADC.B #$00                
                    AND.B #$01                
                    STA $37                   
                    INC $38                   
                    INC $39                   
ADDR_01D00F:        LDA $39                   
                    CMP.B #$A0                
                    BCC ADDR_01D042           
                    LDA.W $15A0,X             
                    BNE ADDR_01D032           
                    LDA.B #$01                
                    STA.W $17C0               
                    LDA $E4,X                 
                    SBC.B #$08                
                    STA.W $17C8               
                    LDA $D8,X                 
                    ADC.B #$08                
                    STA.W $17C4               
                    LDA.B #$1B                
                    STA.W $17CC               
ADDR_01D032:        LDA.B #$D0                
                    STA $D8,X                 
                    JSL.L ADDR_03DEDF         
                    INC.W $151C,X             
                    LDA.B #$30                
                    STA.W $1540,X             
ADDR_01D042:        RTS                       ; Return 

ADDR_01D043:        LDA.W $1540,X             
                    BNE ADDR_01D056           
                    INC.W $13C6               
                    DEC.W $1493               
                    LDA.B #$0B                
                    STA.W $1DFB               ; / Play sound effect 
                    STZ.W $14C8,X             
ADDR_01D056:        RTS                       ; Return 


DATA_01D057:        .db $FF,$F1

ADDR_01D059:        LDA.B #$17                
                    STA.W $1DFC               ; / Play sound effect 
                    LDY.B #$04                
ADDR_01D060:        LDA.W $14C8,Y             
                    BEQ ADDR_01D069           
                    DEY                       
                    BPL ADDR_01D060           
                    RTS                       ; Return 

ADDR_01D069:        LDA.B #$08                
                    STA.W $14C8,Y             
                    LDA.B #$34                
                    STA.W $009E,Y             
                    LDA $E4,X                 
                    STA $00                   
                    LDA.W $14E0,X             
                    STA $01                   
                    LDA $D8,X                 
                    CLC                       
                    ADC.B #$03                
                    STA.W $00D8,Y             
                    LDA.W $14D4,X             
                    ADC.B #$00                
                    STA.W $14D4,Y             
                    LDA.W $157C,X             
                    PHX                       
                    TAX                       
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_01D057,X       
                    STA.W $00E4,Y             
                    LDA $01                   
                    ADC.B #$FF                
                    STA.W $14E0,Y             
                    PLX                       
                    PHX                       
                    TYX                       
                    JSL.L ADDR_07F7D2         
                    PLX                       
                    PHX                       
                    LDA.W $157C,X             
                    STA.W $157C,Y             
                    TAX                       
                    LDA.W DATA_01D0BE,X       
                    STA.W $00B6,Y             
                    LDA.B #$30                
                    STA.W $1540,Y             
                    PLX                       
                    RTS                       ; Return 


DATA_01D0BE:        .db $20,$E0

ADDR_01D0C0:        LDA $AA,X                 
                    BMI ADDR_01D0DC           
                    LDA.W $14D4,X             
                    BNE ADDR_01D0DC           
                    LDA $39                   
                    LSR                       
                    TAY                       
                    LDA $D8,X                 
                    CMP.W ADDR_01D0D6,Y       
                    BCC ADDR_01D0DC           

Instr01D0D4:        .db $B9,$D6

ADDR_01D0D6:        .db $D0

                    STA $D8,X                 
                    STZ $AA,X                 
                    RTS                       ; Return 

ADDR_01D0DC:        CLC                       
                    RTS                       ; Return 


DATA_01D0DE:        .db $80,$83,$85,$88,$8A,$8B,$8D,$8F
                    .db $90,$91,$91,$92,$92,$93,$93,$94
                    .db $94,$95,$95,$96,$96,$97,$97,$98
                    .db $98,$98,$99,$99,$9A,$9A,$9B,$9B
                    .db $9C,$9C,$9C,$9C,$9D,$9D,$9D,$9D
                    .db $9E,$9E,$9E,$9E,$9E,$9F,$9F,$9F
                    .db $9F,$9F,$9F,$9F,$9F,$9F,$9F,$9F

ADDR_01D116:        LDA.W $1528,X             
                    JSL.L ExecutePtr          

Ptrs01D11D:         .dw ADDR_01D146           
                    .dw ADDR_01D23F           

                    RTS                       


DATA_01D122:        .db $F0,$00,$10,$00,$F0,$00,$10,$00
                    .db $E8,$00,$18,$00

DATA_01D12E:        .db $00,$F0,$00,$10,$00,$F0,$00,$10
                    .db $00,$E8,$00,$18,$26,$26,$D8,$D8
DATA_01D13E:        .db $90,$30,$30,$90

DATA_01D142:        .db $00,$01,$02,$01

ADDR_01D146:        LDA $14                   
                    LSR                       
                    LDY.W $1626,X             
                    CPY.B #$02                
                    BCS ADDR_01D151           
                    LSR                       
ADDR_01D151:        AND.B #$03                
                    TAY                       
                    LDA.W DATA_01D142,Y       
                    LDY.W $15AC,X             
                    BEQ ADDR_01D15E           
                    LDA.B #$05                
ADDR_01D15E:        STA.W $1602,X             
                    LDA.W $164A,X             
                    BEQ ADDR_01D17C           
                    LDY $E4,X                 
                    CPY.B #$50                
                    BCC ADDR_01D17C           
                    CPY.B #$80                
                    BCS ADDR_01D17C           
                    DEC.W $164A,X             
                    LSR                       
                    BCS ADDR_01D17C           
                    INC.W $1534,X             
                    DEC.W $160E,X             
ADDR_01D17C:        LDA.W $1534,X             
                    STA $05                   
                    STA $06                   
                    STA $0B                   
                    STA $0C                   
                    LDA.W $160E,X             
                    STA $07                   
                    STA $08                   
                    STA $09                   
                    STA $0A                   
                    LDA $36                   
                    ASL                       
                    BEQ ADDR_01D19A           
                    JMP.W ADDR_01D224         
ADDR_01D19A:        LDY.W $1594,X             
                    TYA                       
                    LSR                       
                    BCS ADDR_01D1B5           
                    LDA $E4,X                 
                    CPY.B #$00                
                    BNE ADDR_01D1AE           
                    CMP.W $1534,X             
                    BCC ADDR_01D215           
                    BRA ADDR_01D1D8           
ADDR_01D1AE:        CMP.W $160E,X             
                    BCS ADDR_01D215           
                    BRA ADDR_01D1D8           
ADDR_01D1B5:        LDA.W $157C,X             
                    BNE ADDR_01D1BE           
                    INY                       
                    INY                       
                    INY                       
                    INY                       
ADDR_01D1BE:        LDA.W $0005,Y             
                    STA $E4,X                 
                    LDY.W $1594,X             
                    LDA $D8,X                 
                    CPY.B #$03                
                    BEQ ADDR_01D1D3           
                    CMP.W DATA_01D13E,Y       
                    BCC ADDR_01D215           
                    BRA ADDR_01D1D8           
ADDR_01D1D3:        CMP.W DATA_01D13E,Y       
                    BCS ADDR_01D215           
ADDR_01D1D8:        LDA.W $1626,X             
                    CMP.B #$02                
                    BCC ADDR_01D1E1           
                    LDA.B #$02                
ADDR_01D1E1:        ASL                       
                    ASL                       
                    ADC.W $1594,X             
                    TAY                       
                    LDA.W DATA_01D122,Y       
                    STA $B6,X                 
                    LDA.W DATA_01D12E,Y       
                    STA $AA,X                 
                    JSR.W ADDR_01ABCC         
                    JSR.W ADDR_01ABD8         
                    LDA.W $1594,X             
                    LDY.W $157C,X             
                    BNE ADDR_01D201           
                    EOR.B #$02                
ADDR_01D201:        CMP.B #$02                
                    BNE ADDR_01D214           
                    JSR.W SubHorizPos         
                    LDA $0F                   
                    CLC                       
                    ADC.B #$10                
                    CMP.B #$20                
                    BCS ADDR_01D214           
                    INC.W $1528,X             
ADDR_01D214:        RTS                       ; Return 

ADDR_01D215:        LDY.W $157C,X             
                    LDA.W $1594,X             
                    CLC                       
                    ADC.W DATA_01D23D,Y       
                    AND.B #$03                
                    STA.W $1594,X             
ADDR_01D224:        LDY.W $157C,X             
                    LDA $36                   
                    CLC                       
                    ADC.W DATA_01D239,Y       
                    STA $36                   
                    LDA $37                   
                    ADC.W DATA_01D23B,Y       
                    AND.B #$01                
                    STA $37                   
                    RTS                       ; Return 


DATA_01D239:        .db $FC,$04

DATA_01D23B:        .db $FF,$00

DATA_01D23D:        .db $FF,$01

ADDR_01D23F:        LDA.W $1540,X             
                    BEQ ADDR_01D25E           
                    CMP.B #$01                
                    BNE ADDR_01D2A7           
                    STZ.W $1528,X             
                    JSR.W SubHorizPos         
                    TYA                       
                    STA.W $157C,X             
                    ASL                       
                    EOR.B #$02                
                    STA.W $1594,X             
                    LDA.B #$0A                
                    STA.W $15AC,X             
                    RTS                       ; Return 

ADDR_01D25E:        LDA.B #$06                
                    STA.W $1602,X             
                    JSR.W ADDR_01ABD8         
                    LDA $AA,X                 
                    CMP.B #$70                
                    BCS ADDR_01D271           
                    CLC                       
                    ADC.B #$04                
                    STA $AA,X                 
ADDR_01D271:        LDA $36                   
                    ORA $37                   
                    BEQ ADDR_01D286           
                    LDA $36                   
                    CLC                       
                    ADC.B #$08                
                    STA $36                   
                    LDA $37                   
                    ADC.B #$00                
                    AND.B #$01                
                    STA $37                   
ADDR_01D286:        JSR.W ADDR_01D0C0         
                    BCC ADDR_01D2A7           
                    LDA.B #$20                
                    STA.W $1887               
                    LDA $72                   
                    BNE ADDR_01D299           
                    LDA.B #$28                
                    STA.W $18BD               
ADDR_01D299:        LDA.B #$09                
                    STA.W $1DFC               ; / Play sound effect 
                    LDA.B #$28                
                    STA.W $1540,X             
                    STZ $36                   
                    STZ $37                   
ADDR_01D2A7:        RTS                       ; Return 

ADDR_01D2A8:        LDA.W $151C,X             
                    CMP.B #$03                
                    BCS ADDR_01D318           
                    LDA.W $187B,X             
                    CMP.B #$03                
                    BNE ADDR_01D2BD           
                    LDA.W $1528,X             
                    CMP.B #$03                
                    BCS ADDR_01D318           
ADDR_01D2BD:        JSL.L ADDR_03B664         
                    JSR.W ADDR_01D40B         
                    JSL.L ADDR_03B72B         
                    BCC ADDR_01D318           
                    LDA.W $1FE2,X             
                    BNE ADDR_01D318           
                    LDA.B #$08                
                    STA.W $1FE2,X             
                    LDA $72                   
                    BEQ ADDR_01D319           
                    LDA.W $1602,X             
                    CMP.B #$10                
                    BCS ADDR_01D2E3           
                    CMP.B #$06                
                    BCS ADDR_01D31E           
ADDR_01D2E3:        LDA $96                   
                    CLC                       
                    ADC.B #$08                
                    CMP $D8,X                 
                    BCS ADDR_01D31E           
                    LDA.W $1594,X             
                    LSR                       
                    BCS ADDR_01D334           
                    LDA $7D                   
                    BMI ADDR_01D31D           
                    JSR.W ADDR_01D351         
                    LDA.B #$D0                
                    STA $7D                   
                    LDA.B #$02                
                    STA.W $1DF9               ; / Play sound effect 
                    LDA.W $1602,X             
                    CMP.B #$1B                
                    BCC ADDR_01D379           
ADDR_01D309:        LDY.B #$20                
                    LDA $E4,X                 
                    SEC                       
                    SBC.B #$08                
                    CMP $94                   
                    BMI ADDR_01D316           
                    LDY.B #$E0                
ADDR_01D316:        STY $7B                   
ADDR_01D318:        RTS                       ; Return 

ADDR_01D319:        JSL.L HurtMario           
ADDR_01D31D:        RTS                       ; Return 

ADDR_01D31E:        LDA.B #$01                
                    STA.W $1DF9               ; / Play sound effect 
                    LDA $7D                   
                    BPL ADDR_01D32C           
                    LDA.B #$10                
                    STA $7D                   
                    RTS                       ; Return 

ADDR_01D32C:        JSR.W ADDR_01D309         
                    LDA.B #$D0                
                    STA $7D                   
                    RTS                       ; Return 

ADDR_01D334:        LDA.B #$01                
                    STA.W $1DF9               ; / Play sound effect 
                    LDA $7D                   
                    BPL ADDR_01D342           
                    LDA.B #$20                
                    STA $7D                   
                    RTS                       ; Return 

ADDR_01D342:        LDY.B #$20                
                    LDA $E4,X                 
                    BPL ADDR_01D34A           
                    LDY.B #$E0                
ADDR_01D34A:        STY $7B                   
                    LDA.B #$B0                
                    STA $7D                   
                    RTS                       ; Return 

ADDR_01D351:        LDA $E4,X                 
                    PHA                       
                    SEC                       
                    SBC.B #$08                
                    STA $E4,X                 
                    LDA.W $14E0,X             
                    PHA                       
                    SBC.B #$00                
                    STA.W $14E0,X             
                    LDA $D8,X                 
                    PHA                       
                    CLC                       
                    ADC.B #$08                
                    STA $D8,X                 
                    JSL.L DisplayContactGfx   
                    PLA                       
                    STA $D8,X                 
                    PLA                       
                    STA.W $14E0,X             
                    PLA                       
                    STA $E4,X                 
                    RTS                       ; Return 

ADDR_01D379:        LDA.B #$18                
                    STA $38                   
                    PHX                       
                    LDA $39                   
                    LSR                       
                    TAX                       
                    LDA.B #$28                
                    STA $39                   
                    LSR                       
                    TAY                       
                    LDA.W ADDR_01D0D6,Y       
                    SEC                       
                    SBC.W ADDR_01D0D6,X       
                    PLX                       
                    CLC                       
                    ADC $D8,X                 
                    STA $D8,X                 
                    LDA.W $14D4,X             
                    ADC.B #$00                
                    STA.W $14D4,X             
                    STZ $B6,X                 
                    STZ $AA,X                 
                    LDA.B #$80                
                    STA.W $1540,X             
                    LDA.B #$03                
                    STA.W $151C,X             
                    LDA.B #$28                
                    STA.W $1DFC               ; / Play sound effect 
                    RTS                       ; Return 

ADDR_01D3B1:        LDA.W $151C,X             
                    CMP.B #$03                
                    BCS ADDR_01D40A           
                    LDY.B #$0A                
ADDR_01D3BA:        STY.W $1695               
                    LDA.W $170B,Y             
                    CMP.B #$05                
                    BNE ADDR_01D405           
                    LDA.W $171F,Y             
                    STA $00                   
                    LDA.W $1733,Y             
                    STA $08                   
                    LDA.W $1715,Y             
                    STA $01                   
                    LDA.W $1729,Y             
                    STA $09                   
                    LDA.B #$08                
                    STA $02                   
                    STA $03                   
                    PHY                       
                    JSR.W ADDR_01D40B         
                    PLY                       
                    JSL.L ADDR_03B72B         
                    BCC ADDR_01D405           
                    LDA.B #$01                
                    STA.W $170B,Y             
                    LDA.B #$0F                
                    STA.W $176F,Y             
                    LDA.B #$01                
                    STA.W $1DF9               ; / Play sound effect 
                    INC.W $1626,X             
                    LDA.W $1626,X             
                    CMP.B #$0C                
                    BCC ADDR_01D405           
                    JSR.W ADDR_01CFD0         
ADDR_01D405:        DEY                       
                    CPY.B #$07                
                    BNE ADDR_01D3BA           
ADDR_01D40A:        RTS                       ; Return 

ADDR_01D40B:        LDA $E4,X                 
                    SEC                       
                    SBC.B #$08                
                    STA $04                   
                    LDA.W $14E0,X             
                    SBC.B #$00                
                    STA $0A                   
                    LDA.B #$10                
                    STA $06                   
                    LDA.B #$10                
                    STA $07                   
                    LDA.W $1602,X             
                    CMP.B #$69                
                    LDA.B #$08                
                    BCC ADDR_01D42C           
                    ADC.B #$0A                
ADDR_01D42C:        CLC                       
                    ADC $D8,X                 
                    STA $05                   
                    LDA.W $14D4,X             
                    ADC.B #$00                
                    STA $0B                   
                    RTS                       ; Return 


DATA_01D439:        .db $A8,$B0,$B8,$C0,$C8

                    STZ.W $14C8,X             
                    RTS                       ; Return 


DATA_01D442:        .db $00,$F0,$00,$10

DATA_01D446:        .db $4A,$4C,$6A,$6C

DATA_01D44A:        .db $45,$45,$05,$05

ADDR_01D44E:        LDA $9D                   
                    ORA.W $13FB               
                    BNE ADDR_01D487           
                    LDA.W $1540,X             
                    CMP.B #$10                
                    BCS ADDR_01D487           
                    TAY                       
                    BNE ADDR_01D468           
                    JSR.W ADDR_018E5F         
                    JSR.W ADDR_018E5F         
                    JSR.W ADDR_01A7E4         
ADDR_01D468:        JSR.W ADDR_01ABCC         
                    LDA $E4,X                 
                    CLC                       
                    ADC.B #$20                
                    STA $00                   
                    LDA.W $14E0,X             
                    ADC.B #$00                
                    STA $01                   
                    REP #$20                  ; Accum (16 bit) 
                    LDA $00                   
                    CMP.W #$0230              
                    SEP #$20                  ; Accum (8 bit) 
                    BCC ADDR_01D487           
                    STZ.W $14C8,X             
ADDR_01D487:        JSR.W GetDrawInfoBnk1     
                    LDA.W $1602,X             
                    ASL                       
                    STA $03                   
                    LDA.W $157C,X             
                    ASL                       
                    STA $02                   
                    LDA.W DATA_01D439,X       
                    STA.W $15EA,X             
                    TAY                       
                    PHX                       
                    LDA.W $1540,X             
                    LDX.B #$01                
                    CMP.B #$08                
                    BCC ADDR_01D4A8           
                    DEX                       
ADDR_01D4A8:        PHX                       
                    PHX                       
                    TXA                       
                    CLC                       
                    ADC $02                   
                    TAX                       
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_01D442,X       
                    STA.W $0300,Y             
                    LDA $14                   
                    LSR                       
                    LSR                       
                    ROR                       
                    AND.B #$80                
                    ORA.W DATA_01D44A,X       
                    STA.W $0303,Y             
                    LDA $01                   
                    INC A                     
                    INC A                     
                    STA.W $0301,Y             
                    PLA                       
                    CLC                       
                    ADC $03                   
                    TAX                       
                    LDA.W DATA_01D446,X       
                    STA.W $0302,Y             
                    PLX                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_01D4A8           
                    PLX                       
                    LDY.B #$02                
                    LDA.B #$01                
                    JMP.W ADDR_01B7BB         

DATA_01D4E7:        .db $01,$FF

DATA_01D4E9:        .db $0F,$00

DATA_01D4EB:        .db $00,$02,$04,$06,$08,$0A,$0C,$0E
                    .db $0E,$0C,$0A,$08,$06,$04,$02,$00

ADDR_01D4FB:        LDA.W $14C8,X             
                    CMP.B #$08                
                    BEQ ADDR_01D505           
                    JMP.W ADDR_01D671         
ADDR_01D505:        LDA $9D                   
                    BNE ADDR_01D558           
                    LDA.W $1540,X             
                    BNE ADDR_01D558           
                    LDA $13                   
                    LSR                       
                    BCC ADDR_01D51A           
                    INC $D8,X                 
                    BNE ADDR_01D51A           
                    INC.W $14D4,X             
ADDR_01D51A:        LDA.W $151C,X             
                    BNE ADDR_01D558           
                    LDA $13                   
                    LSR                       
                    BCC ADDR_01D53A           
                    LDA $C2,X                 
                    AND.B #$01                
                    TAY                       
                    LDA.W $1570,X             
                    CLC                       
                    ADC.W DATA_01D4E7,Y       
                    STA.W $1570,X             
                    CMP.W DATA_01D4E9,Y       
                    BNE ADDR_01D53A           
                    INC $C2,X                 
ADDR_01D53A:        LDA $B6,X                 
                    PHA                       
                    LDY.W $1570,X             
                    LDA $C2,X                 
                    LSR                       
                    LDA.W DATA_01D4EB,Y       
                    BCC ADDR_01D54B           
                    EOR.B #$FF                
                    INC A                     
ADDR_01D54B:        CLC                       
                    ADC $B6,X                 
                    STA $B6,X                 
                    JSR.W ADDR_01ABCC         
                    PLA                       
                    STA $B6,X                 
                    BRA ADDR_01D558           
ADDR_01D558:        JSR.W ADDR_01AC31         
                    JMP.W ADDR_01D5B3         

DATA_01D55E:        .db $0D,$0D,$0D,$0D,$0C,$0C,$0C,$0C
                    .db $0C,$0C,$0C,$0C,$0D,$0D,$0D,$0D
DATA_01D56E:        .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $01,$01,$01,$01,$01,$01,$01,$01
DATA_01D57E:        .db $F8,$F8,$FA,$FA,$FC,$FC,$FE,$FE
                    .db $02,$02,$04,$04,$06,$06,$08,$08
DATA_01D58E:        .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $00,$00,$00,$00,$00,$00,$00,$00
DATA_01D59E:        .db $0E,$0E,$0F,$0F,$10,$10,$10,$10
                    .db $10,$10,$10,$10,$0F,$0F,$0E,$0E
DATA_01D5AE:        .db $0F,$0D

DATA_01D5B0:        .db $01,$05,$00

ADDR_01D5B3:        STZ.W $185E               
                    LDY.B #$F0                
                    LDA.W $1540,X             
                    BEQ ADDR_01D5C7           
                    LSR                       
                    EOR.B #$0F                
                    STA.W $185E               
                    CLC                       
                    ADC.B #$F0                
                    TAY                       
ADDR_01D5C7:        STY $00                   
                    LDA $D8,X                 
                    PHA                       
                    CLC                       
                    ADC $00                   
                    STA $D8,X                 
                    LDA.W $14D4,X             
                    PHA                       
                    ADC.B #$FF                
                    STA.W $14D4,X             
                    LDA.W $15F6,X             
                    PHA                       
                    AND.B #$F1                
                    ORA.B #$06                
                    STA.W $15F6,X             
                    LDY.W $1570,X             
                    LDA.W DATA_01D55E,Y       
                    STA.W $1602,X             
                    LDA.W DATA_01D56E,Y       
                    STA.W $157C,X             
                    JSR.W ADDR_019F0D         
                    PLA                       
                    STA.W $15F6,X             
                    LDA.W $15EA,X             
                    CLC                       
                    ADC.B #$04                
                    STA.W $15EA,X             
                    LDY.W $1570,X             
                    LDA $E4,X                 
                    PHA                       
                    CLC                       
                    ADC.W DATA_01D57E,Y       
                    STA $E4,X                 
                    LDA.W $14E0,X             
                    PHA                       
                    ADC.W DATA_01D58E,Y       
                    STA.W $14E0,X             
                    STZ $00                   
                    LDA.W DATA_01D59E,Y       
                    SEC                       
                    SBC.W $185E               
                    BPL ADDR_01D627           
                    DEC $00                   
ADDR_01D627:        CLC                       
                    ADC $D8,X                 
                    STA $D8,X                 
                    LDA.W $14D4,X             
                    ADC $00                   
                    STA.W $14D4,X             
                    LDA.W $1602,X             
                    SEC                       
                    SBC.B #$0C                
                    CMP.B #$01                
                    BNE ADDR_01D642           
                    CLC                       
                    ADC.W $157C,X             
ADDR_01D642:        STA.W $1602,X             
                    LDA.W $1540,X             
                    BEQ ADDR_01D64D           
                    STZ.W $1602,X             
ADDR_01D64D:        LDY.W $1602,X             
                    LDA.W DATA_01D5B0,Y       
                    JSR.W ADDR_019CF3         
                    JSR.W ADDR_018FC1         
                    LDA.W $1540,X             
                    BEQ ADDR_01D693           
                    DEC A                     
                    BNE ADDR_01D681           
                    STZ $AA,X                 
                    PLA                       
                    PLA                       
                    PLA                       
                    STA.W $14D4,X             
                    PLA                       
                    STA $D8,X                 
                    LDA.B #$80                
                    STA.W $1540,X             
ADDR_01D671:        LDA $9E,X                 
                    SEC                       
                    SBC.B #$3F                
                    TAY                       
                    LDA.W DATA_01D5AE,Y       
                    STA $9E,X                 
                    JSL.L ADDR_07F78B         
                    RTS                       ; Return 

ADDR_01D681:        JSR.W ADDR_019140         
                    JSR.W ADDR_01800E         
                    BEQ ADDR_01D68C           
                    JSR.W ADDR_019A04         
ADDR_01D68C:        JSR.W ADDR_01ABD8         
                    INC $AA,X                 
                    BRA ADDR_01D6B5           
ADDR_01D693:        TXA                       
                    EOR $13                   
                    LSR                       
                    BCC ADDR_01D6B5           
                    JSR.W ADDR_019140         
                    JSR.W ADDR_018008         
                    BEQ ADDR_01D6AB           
                    LDA.B #$01                
                    STA.W $151C,X             
                    LDA.B #$07                
                    STA.W $1570,X             
ADDR_01D6AB:        JSR.W ADDR_01800E         
                    BEQ ADDR_01D6B5           
                    LDA.B #$20                
                    STA.W $1540,X             
ADDR_01D6B5:        PLA                       
                    STA.W $14E0,X             
                    PLA                       
                    STA $E4,X                 
                    PLA                       
                    STA.W $14D4,X             
                    PLA                       
                    STA $D8,X                 
Return01D6C3:       RTS                       

ADDR_01D6C4:        CPX.B #$06                
                    BCC ADDR_01D6E0           
                    LDA.W $1692               
                    BEQ ADDR_01D6E0           
                    INC.W $1662,X             
                    BRA ADDR_01D6E0           
ADDR_01D6D2:        LDA $E4,X                 
                    AND.B #$10                
                    EOR.B #$10                
                    STA.W $1602,X             
                    BEQ ADDR_01D6E0           
                    INC.W $1662,X             
ADDR_01D6E0:        INC.W $1540,X             
                    JSR.W ADDR_01D74A         
                    JSR.W ADDR_01D74A         
                    INC.W $1626,X             
ADDR_01D6EC:        RTS                       ; Return 

ADDR_01D6ED:        INC.W $187B,X             
                    LDA $E4,X                 
                    AND.B #$10                
                    BNE ADDR_01D707           
                    LDA $E4,X                 
                    SEC                       
                    SBC.B #$40                
                    STA $E4,X                 
                    LDA.W $14E0,X             
                    SBC.B #$01                
                    STA.W $14E0,X             
                    BRA ADDR_01D711           
ADDR_01D707:        INC.W $157C,X             
                    LDA $E4,X                 
                    CLC                       
                    ADC.B #$0F                
                    STA $E4,X                 
ADDR_01D711:        LDA.B #$02                
                    STA.W $1540,X             
                    RTS                       ; Return 


DATA_01D717:        .db $F8,$00

ADDR_01D719:        TXA                       
                    ASL                       
                    ASL                       
                    EOR $14                   
                    STA $02                   
                    AND.B #$07                
                    ORA $9D                   
                    BNE ADDR_01D73A           
                    LDA $02                   
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.B #$01                
                    TAY                       
                    LDA.W DATA_01D717,Y       
                    STA $00                   
                    LDA.B #$F2                
                    STA $01                   
                    JSR.W ADDR_018063         
ADDR_01D73A:        LDA $13                   
                    AND.B #$07                
                    ORA.W $1626,X             
                    ORA $9D                   
                    BNE ADDR_01D74A           
                    LDA.B #$04                
                    STA.W $1DFA               ; / Play sound effect 
ADDR_01D74A:        JMP.W ADDR_01D9A7         
ADDR_01D74D:        JSR.W ADDR_01AC2B         
                    LDA.W $1540,X             
                    BNE ADDR_01D75C           
                    LDA $9D                   
                    ORA.W $1626,X             
                    BNE ADDR_01D6EC           
ADDR_01D75C:        LDA $C2,X                 
                    JSL.L ExecutePtr          

Ptrs01D762:         .dw ADDR_01D7F4           
                    .dw ADDR_01D768           
                    .dw ADDR_01DB44           

ADDR_01D768:        LDA $9D                   
                    BNE ADDR_01D791           
                    LDA.W $157C,X             
                    BNE ADDR_01D792           
                    LDY.W $1534,X             
                    JSR.W ADDR_01D7B0         
                    INC.W $1534,X             
                    LDA.W $187B,X             
                    BEQ ADDR_01D787           
                    LDA $13                   
                    LSR                       
                    BCC ADDR_01D787           
                    INC.W $1534,X             
ADDR_01D787:        LDA.W $1534,X             
                    CMP.W $1570,X             
                    BCC ADDR_01D791           
                    STZ $C2,X                 
ADDR_01D791:        RTS                       ; Return 

ADDR_01D792:        LDY.W $1570,X             
                    DEY                       
                    JSR.W ADDR_01D7B0         
                    DEC.W $1570,X             
                    BEQ ADDR_01D7AD           
                    LDA.W $187B,X             
                    BEQ ADDR_01D7AF           
                    LDA $13                   
                    LSR                       
                    BCC ADDR_01D7AF           
                    DEC.W $1570,X             
                    BNE ADDR_01D7AF           
ADDR_01D7AD:        STZ $C2,X                 
ADDR_01D7AF:        RTS                       ; Return 

ADDR_01D7B0:        PHB                       ; Sprites calling this routine must be modified 
                    LDA.B #$07                ; to set $151C,x and $1528,x to a location in 
                    PHA                       ; LineTable instead of $07/F9DB+something 
                    PLB                       
                    LDA.W $151C,X             
                    STA $04                   
                    LDA.W $1528,X             
                    STA $05                   
                    LDA ($04),Y               
                    AND.B #$0F                
                    STA $06                   
                    LDA ($04),Y               
                    PLB                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    STA $07                   
                    LDA $D8,X                 
                    AND.B #$F0                
                    CLC                       
                    ADC $07                   
                    STA $D8,X                 
                    LDA $E4,X                 
                    AND.B #$F0                
                    CLC                       
                    ADC $06                   
                    STA $E4,X                 
                    RTS                       ; Return 


DATA_01D7E1:        .db $FC,$04,$FC,$04

DATA_01D7E5:        .db $FF,$00,$FF,$00

DATA_01D7E9:        .db $FC,$FC,$04,$04

DATA_01D7ED:        .db $FF,$FF,$00,$00

ADDR_01D7F1:        JMP.W ADDR_01D89F         
ADDR_01D7F4:        LDY.B #$03                
ADDR_01D7F6:        STY.W $1695               
                    LDA $E4,X                 
                    CLC                       
                    ADC.W DATA_01D7E1,Y       
                    STA $02                   
                    LDA.W $14E0,X             
                    ADC.W DATA_01D7E5,Y       
                    STA $03                   
                    LDA $D8,X                 
                    CLC                       
                    ADC.W DATA_01D7E9,Y       
                    STA $00                   
                    LDA.W $14D4,X             
                    ADC.W DATA_01D7ED,Y       
                    STA $01                   
                    LDA.W $1540,X             
                    BNE ADDR_01D83A           
                    LDA $00                   
                    AND.B #$F0                
                    STA $04                   
                    LDA $D8,X                 
                    AND.B #$F0                
                    CMP $04                   
                    BNE ADDR_01D83A           
                    LDA $02                   
                    AND.B #$F0                
                    STA $05                   
                    LDA $E4,X                 
                    AND.B #$F0                
                    CMP $05                   
                    BEQ ADDR_01D861           
ADDR_01D83A:        JSR.W ADDR_01D94D         
                    BNE ADDR_01D7F1           
                    LDA.W $1693               
                    CMP.B #$94                
                    BEQ ADDR_01D851           
                    CMP.B #$95                
                    BNE ADDR_01D856           
                    LDA.W $14AF               
                    BEQ ADDR_01D861           
                    BNE ADDR_01D856           
ADDR_01D851:        LDA.W $14AF               
                    BNE ADDR_01D861           
ADDR_01D856:        LDA.W $1693               
                    CMP.B #$76                
                    BCC ADDR_01D861           
                    CMP.B #$9A                
                    BCC ADDR_01D895           
ADDR_01D861:        LDY.W $1695               
                    DEY                       
                    BPL ADDR_01D7F6           
                    LDA $C2,X                 
                    CMP.B #$02                
                    BEQ ADDR_01D894           
                    LDA.B #$02                
                    STA $C2,X                 
                    LDY.W $160E,X             
                    LDA.W $157C,X             
                    BEQ ADDR_01D87E           
                    TYA                       
                    CLC                       
                    ADC.B #$20                
                    TAY                       
ADDR_01D87E:        LDA.W DATA_01DD11,Y       
                    BPL ADDR_01D884           
                    ASL                       
ADDR_01D884:        PHY                       
                    ASL                       
                    STA $AA,X                 
                    PLY                       
                    LDA.W DATA_01DD51,Y       
                    ASL                       
                    STA $B6,X                 
                    LDA.B #$10                
                    STA.W $1540,X             
ADDR_01D894:        RTS                       ; Return 

ADDR_01D895:        PHA                       
                    SEC                       
                    SBC.B #$76                
                    TAY                       
                    PLA                       
                    CMP.B #$96                
                    BCC ADDR_01D8A4           
ADDR_01D89F:        LDY.W $160E,X             
                    BRA ADDR_01D8C8           
ADDR_01D8A4:        LDA $D8,X                 
                    STA $08                   
                    LDA.W $14D4,X             
                    STA $09                   
                    LDA $E4,X                 
                    STA $0A                   
                    LDA.W $14E0,X             
                    STA $0B                   
                    LDA $00                   
                    STA $D8,X                 
                    LDA $01                   
                    STA.W $14D4,X             
                    LDA $02                   
                    STA $E4,X                 
                    LDA $03                   
                    STA.W $14E0,X             
ADDR_01D8C8:        PHB                       
                    LDA.B #$07                
                    PHA                       
                    PLB                       
                    LDA.W ADDR_01FBF3,Y       
                    STA.W $151C,X             
                    LDA.W ADDR_01FC13,Y       
                    STA.W $1528,X             
                    PLB                       
                    LDA.W DATA_01DCD1,Y       
                    STA.W $1570,X             
                    STZ.W $1534,X             
                    TYA                       
                    STA.W $160E,X             
                    LDA.W $1540,X             
                    BNE ADDR_01D933           
                    STZ.W $157C,X             
                    LDA.W DATA_01DCF1,Y       
                    BEQ ADDR_01D8FF           
                    TAY                       
                    LDA $D8,X                 
                    CPY.B #$01                
                    BNE ADDR_01D8FD           
                    EOR.B #$0F                
ADDR_01D8FD:        BRA ADDR_01D901           
ADDR_01D8FF:        LDA $E4,X                 
ADDR_01D901:        AND.B #$0F                
                    CMP.B #$0A                
                    BCC ADDR_01D910           
                    LDA $C2,X                 
                    CMP.B #$02                
                    BEQ ADDR_01D910           
                    INC.W $157C,X             
ADDR_01D910:        LDA $D8,X                 
                    STA $0C                   
                    LDA $E4,X                 
                    STA $0D                   
                    JSR.W ADDR_01D768         
                    LDA $0C                   
                    SEC                       
                    SBC $D8,X                 
                    CLC                       
                    ADC.B #$08                
                    CMP.B #$10                
                    BCS ADDR_01D938           
                    LDA $0D                   
                    SEC                       
                    SBC $E4,X                 
                    CLC                       
                    ADC.B #$08                
                    CMP.B #$10                
                    BCS ADDR_01D938           
ADDR_01D933:        LDA.B #$01                
                    STA $C2,X                 
                    RTS                       ; Return 

ADDR_01D938:        LDA $08                   
                    STA $D8,X                 
                    LDA $09                   
                    STA.W $14D4,X             
                    LDA $0A                   
                    STA $E4,X                 
                    LDA $0B                   
                    STA.W $14E0,X             
                    JMP.W ADDR_01D861         
ADDR_01D94D:        LDA $00                   
                    AND.B #$F0                
                    STA $06                   
                    LDA $02                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    PHA                       
                    ORA $06                   
                    PHA                       
                    LDA $5B                   
                    AND.B #$01                
                    BEQ ADDR_01D977           
                    PLA                       
                    LDX $01                   
                    CLC                       
                    ADC.L DATA_00BA80,X       
                    STA $05                   
                    LDA.L DATA_00BABC,X       
                    ADC $03                   
                    STA $06                   
                    BRA ADDR_01D989           
ADDR_01D977:        PLA                       
                    LDX $03                   
                    CLC                       
                    ADC.L DATA_00BA60,X       
                    STA $05                   
                    LDA.L DATA_00BA9C,X       
                    ADC $01                   
                    STA $06                   
ADDR_01D989:        LDA.B #$7E                
                    STA $07                   
                    LDX.W $15E9               
                    LDA [$05]                 
                    STA.W $1693               
                    INC $07                   
                    LDA [$05]                 
                    PLY                       
                    STY $05                   
                    PHA                       
                    LDA $05                   
                    AND.B #$07                
                    TAY                       
                    PLA                       
                    AND.W DATA_018000,Y       
                    RTS                       ; Return 

ADDR_01D9A7:        LDA $9E,X                 
                    CMP.B #$64                
                    BEQ ADDR_01D9D3           
                    CMP.B #$65                
                    BCC ADDR_01D9D0           
                    CMP.B #$68                
                    BNE ADDR_01D9BA           
                    JSR.W ADDR_01DBD4         
                    BRA ADDR_01D9C1           
ADDR_01D9BA:        CMP.B #$67                
                    BNE ADDR_01D9C6           
                    JSR.W ADDR_01DC0B         
ADDR_01D9C1:        JSR.W ADDR_01A7E4         
                    BRA ADDR_01D9CD           
ADDR_01D9C6:        JSR.W ADDR_01A7E4         
                    JSL.L ADDR_03C263         
ADDR_01D9CD:        JMP.W ADDR_01D74D         
ADDR_01D9D0:        JMP.W ADDR_01DAA2         
ADDR_01D9D3:        JSR.W ADDR_01DC54         
                    LDA $E4,X                 
                    PHA                       
                    LDA $D8,X                 
                    PHA                       
                    JSR.W ADDR_01D74D         
                    PLA                       
                    SEC                       
                    SBC $D8,X                 
                    EOR.B #$FF                
                    INC A                     
                    STA.W $185E               
                    PLA                       
                    SEC                       
                    SBC $E4,X                 
                    EOR.B #$FF                
                    INC A                     
                    STA.W $18B6               
                    LDA $77                   
                    AND.B #$03                
                    BNE ADDR_01DA09           
                    JSR.W ADDR_01A80F         
                    BCS ADDR_01DA0A           
ADDR_01D9FE:        LDA.W $163E,X             
                    BEQ ADDR_01DA09           
                    STZ.W $163E,X             
                    STZ.W $18BE               
ADDR_01DA09:        RTS                       ; Return 

ADDR_01DA0A:        LDA.W $14C8,X             
                    BEQ ADDR_01DA37           
                    LDA.W $1470               
                    ORA.W $187A               
                    BNE ADDR_01D9FE           
                    LDA.B #$03                
                    STA.W $163E,X             
                    LDA.W $154C,X             
                    BNE ADDR_01DA8F           
                    LDA.W $18BE               
                    BNE ADDR_01DA2F           
                    LDA $15                   
                    AND.B #$08                
                    BEQ ADDR_01DA8F           
                    STA.W $18BE               
ADDR_01DA2F:        BIT $16                   
                    BPL ADDR_01DA3F           
                    LDA.B #$B0                
                    STA $7D                   
ADDR_01DA37:        STZ.W $18BE               
                    LDA.B #$10                
                    STA.W $154C,X             
ADDR_01DA3F:        LDY.B #$00                
                    LDA.W $185E               
                    BPL ADDR_01DA47           
                    DEY                       
ADDR_01DA47:        CLC                       
                    ADC $96                   
                    STA $96                   
                    TYA                       
                    ADC $97                   
                    STA $97                   
                    LDA $D8,X                 
                    STA $00                   
                    LDA.W $14D4,X             
                    STA $01                   
                    REP #$20                  ; Accum (16 bit) 
                    LDA $96                   
                    SEC                       
                    SBC $00                   
                    CMP.W #$0000              
                    BPL ADDR_01DA68           
                    INC $96                   
ADDR_01DA68:        SEP #$20                  ; Accum (8 bit) 
                    LDA.W $18B6               
                    JSR.W ADDR_01DA90         
                    LDA $E4,X                 
                    SEC                       
                    SBC.B #$08                
                    CMP $94                   
                    BEQ ADDR_01DA84           
                    BPL ADDR_01DA7F           
                    LDA.B #$FF                
                    BRA ADDR_01DA81           
ADDR_01DA7F:        LDA.B #$01                
ADDR_01DA81:        JSR.W ADDR_01DA90         
ADDR_01DA84:        LDA.W $1626,X             
                    BEQ ADDR_01DA8F           
                    STZ.W $1626,X             
                    STZ.W $1540,X             
ADDR_01DA8F:        RTS                       ; Return 

ADDR_01DA90:        LDY.B #$00                
                    CMP.B #$00                
                    BPL ADDR_01DA97           
                    DEY                       
ADDR_01DA97:        CLC                       
                    ADC $94                   
                    STA $94                   
                    TYA                       
                    ADC $95                   
                    STA $95                   
                    RTS                       ; Return 

ADDR_01DAA2:        LDY.B #$18                
                    LDA.W $1602,X             
                    BEQ ADDR_01DAAB           
                    LDY.B #$28                
ADDR_01DAAB:        STY $00                   
                    LDA $E4,X                 
                    PHA                       
                    SEC                       
                    SBC $00                   
                    STA $E4,X                 
                    LDA.W $14E0,X             
                    PHA                       
                    SBC.B #$00                
                    STA.W $14E0,X             
                    LDA $D8,X                 
                    PHA                       
                    SEC                       
                    SBC.B #$08                
                    STA $D8,X                 
                    LDA.W $14D4,X             
                    PHA                       
                    SBC.B #$00                
                    STA.W $14D4,X             
                    JSR.W ADDR_01B2DF         
                    PLA                       
                    STA.W $14D4,X             
                    PLA                       
                    STA $D8,X                 
                    PLA                       
                    STA.W $14E0,X             
                    PLA                       
                    STA $E4,X                 
                    LDA $E4,X                 
                    PHA                       
                    JSR.W ADDR_01D74D         
                    PLA                       
                    SEC                       
                    SBC $E4,X                 
                    LDY.W $1528,X             
                    PHY                       
                    EOR.B #$FF                
                    INC A                     
                    STA.W $1528,X             
                    LDY.B #$18                
                    LDA.W $1602,X             
                    BEQ ADDR_01DAFD           
                    LDY.B #$28                
ADDR_01DAFD:        STY $00                   
                    LDA $E4,X                 
                    PHA                       
                    SEC                       
                    SBC $00                   
                    STA $E4,X                 
                    LDA.W $14E0,X             
                    PHA                       
                    SBC.B #$00                
                    STA.W $14E0,X             
                    LDA $D8,X                 
                    PHA                       
                    SEC                       
                    SBC.B #$08                
                    STA $D8,X                 
                    LDA.W $14D4,X             
                    PHA                       
                    SBC.B #$00                
                    STA.W $14D4,X             
                    JSR.W ADDR_01B457         
                    BCC ADDR_01DB31           
                    LDA.W $1626,X             
                    BEQ ADDR_01DB31           
                    STZ.W $1626,X             
                    STZ.W $1540,X             
ADDR_01DB31:        PLA                       
                    STA.W $14D4,X             
                    PLA                       
                    STA $D8,X                 
                    PLA                       
                    STA.W $14E0,X             
                    PLA                       
                    STA $E4,X                 
                    PLA                       
                    STA.W $1528,X             
                    RTS                       ; Return 

ADDR_01DB44:        LDA $9D                   
                    BNE ADDR_01DB59           
                    JSR.W ADDR_019032         
                    LDA.W $1540,X             
                    BNE ADDR_01DB59           
                    LDA $AA,X                 
                    CMP.B #$20                
                    BMI ADDR_01DB59           
                    JSR.W ADDR_01D7F4         
ADDR_01DB59:        RTS                       ; Return 


DATA_01DB5A:        .db $18,$E8

ADDR_01DB5C:        JSR.W ADDR_01DBA2         
                    LDA.W $14C8,X             
                    CMP.B #$08                
                    BNE ADDR_01DB95           
                    LDA $9D                   
                    BNE ADDR_01DB95           
                    LDA $13                   
                    AND.B #$03                
                    BNE ADDR_01DB75           
                    LDA.B #$04                
                    STA.W $1DFA               ; / Play sound effect 
ADDR_01DB75:        JSR.W ADDR_01AC31         
                    JSR.W ADDR_01A7E4         
                    LDY.W $157C,X             
                    LDA.W DATA_01DB5A,Y       
                    STA $B6,X                 
                    JSR.W ADDR_019032         
                    JSR.W ADDR_01800E         
                    BEQ ADDR_01DB8D           
                    STZ $AA,X                 
ADDR_01DB8D:        JSR.W ADDR_018008         
                    BEQ ADDR_01DB95           
                    JSR.W ADDR_019098         
ADDR_01DB95:        RTS                       ; Return 


DATA_01DB96:        .db $F8,$08,$F8,$08

DATA_01DB9A:        .db $00,$00,$10,$10

DATA_01DB9E:        .db $03,$43,$83,$C3

ADDR_01DBA2:        JSR.W GetDrawInfoBnk1     
                    PHX                       
                    LDX.B #$03                
ADDR_01DBA8:        LDA $00                   
                    CLC                       
                    ADC.W DATA_01DB96,X       
                    STA.W $0300,Y             
                    LDA $01                   
                    CLC                       
                    ADC.W DATA_01DB9A,X       
                    STA.W $0301,Y             
                    LDA $14                   
                    AND.B #$02                
                    ORA.B #$6C                
                    STA.W $0302,Y             
                    LDA.W DATA_01DB9E,X       
                    STA.W $0303,Y             
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_01DBA8           
ADDR_01DBD0:        LDA.B #$03                
                    BRA ADDR_01DC03           
ADDR_01DBD4:        JSR.W ADDR_019F0D         
                    LDY.W $15EA,X             
                    LDA.W $0300,Y             
                    SEC                       
                    SBC.B #$08                
                    STA.W $0300,Y             
                    LDA.W $0301,Y             
                    SEC                       
                    SBC.B #$08                
                    STA.W $0301,Y             
                    PHX                       
                    LDA $14                   
                    LSR                       
                    LSR                       
                    AND.B #$01                
                    TAX                       
                    LDA.B #$C8                
                    STA.W $0302,Y             
                    LDA.W DATA_01DC09,X       
                    ORA $64                   
                    STA.W $0303,Y             
                    LDA.B #$00                
ADDR_01DC03:        PLX                       
ADDR_01DC04:        LDY.B #$02                
                    JMP.W ADDR_01B7BB         

DATA_01DC09:        .db $05,$45

ADDR_01DC0B:        JSR.W GetDrawInfoBnk1     
                    PHX                       
                    LDX.B #$03                
ADDR_01DC11:        LDA $00                   
                    CLC                       
                    ADC.W DATA_01DC3B,X       
                    STA.W $0300,Y             
                    LDA $01                   
                    CLC                       
                    ADC.W DATA_01DC3F,X       
                    STA.W $0301,Y             
                    LDA $14                   
                    AND.B #$02                
                    ORA.B #$6C                
                    STA.W $0302,Y             
                    LDA.W DATA_01DC43,X       
                    STA.W $0303,Y             
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_01DC11           
                    BRA ADDR_01DBD0           

DATA_01DC3B:        .db $F0,$00,$F0,$00

DATA_01DC3F:        .db $F0,$F0,$00,$00

DATA_01DC43:        .db $33,$73,$B3,$F3

DATA_01DC47:        .db $C0,$C2,$E0,$C2

DATA_01DC4B:        .db $C0,$CE,$CE,$CE,$CE,$CE,$CE,$CE
                    .db $CE

ADDR_01DC54:        JSR.W GetDrawInfoBnk1     
                    LDA $00                   
                    SEC                       
                    SBC.B #$08                
                    STA $00                   
                    LDA $01                   
                    SEC                       
                    SBC.B #$08                
                    STA $01                   
                    TXA                       
                    ASL                       
                    ASL                       
                    EOR $14                   
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.B #$03                
                    STA $02                   
                    LDA.B #$05                
                    CPX.B #$06                
                    BCC ADDR_01DC7E           
                    LDY.W $1692               
                    BEQ ADDR_01DC7E           
                    LDA.B #$09                
ADDR_01DC7E:        STA $03                   
                    LDY.W $15EA,X             
                    LDX.B #$00                
ADDR_01DC85:        LDA $00                   
                    STA.W $0300,Y             
                    LDA $01                   
                    STA.W $0301,Y             
                    CLC                       
                    ADC.B #$10                
                    STA $01                   
                    LDA.W DATA_01DC4B,X       
                    CPX.B #$00                
                    BNE ADDR_01DCA2           
                    PHX                       
                    LDX $02                   
                    LDA.W DATA_01DC47,X       
                    PLX                       
ADDR_01DCA2:        STA.W $0302,Y             
                    LDA.B #$37                
                    CPX.B #$01                
                    BCC ADDR_01DCAD           
                    LDA.B #$31                
ADDR_01DCAD:        STA.W $0303,Y             
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    INX                       
                    CPX $03                   
                    BNE ADDR_01DC85           
                    LDA.B #$DE                
                    STA.W $02FE,Y             
                    LDX.W $15E9               
                    LDA.B #$04                
                    CPX.B #$06                
                    BCC ADDR_01DCCE           
                    LDY.W $1692               
                    BEQ ADDR_01DCCE           
                    LDA.B #$08                
ADDR_01DCCE:        JMP.W ADDR_01DC04         

DATA_01DCD1:        .db $15,$15,$15,$15,$0C,$10,$10,$10
                    .db $10,$0C,$0C,$10,$10,$10,$10,$0C
                    .db $15,$15,$10,$10,$10,$10,$10,$10
                    .db $10,$10,$10,$10,$10,$10,$15,$15
DATA_01DCF1:        .db $00,$00,$00,$00,$00,$00,$01,$02
                    .db $00,$00,$00,$00,$02,$01,$00,$00
                    .db $00,$00,$01,$02,$01,$02,$00,$00
                    .db $00,$00,$02,$02,$00,$00,$00,$00
DATA_01DD11:        .db $00,$10,$00,$F0,$F4,$FC,$F0,$10
                    .db $04,$0C,$0C,$00,$10,$F0,$FC,$F4
                    .db $F0,$10,$F0,$10,$F0,$10,$F8,$F8
                    .db $08,$08,$10,$10,$00,$00,$F0,$10
                    .db $10,$00,$F0,$F0,$0C,$04,$10,$F0
                    .db $00,$F4,$F4,$FC,$F0,$10,$00,$0C
                    .db $10,$F0,$10,$00,$10,$F0,$08,$08
                    .db $F8,$F8,$F0,$F0,$00,$00,$10,$F0
DATA_01DD51:        .db $10,$00,$10,$00,$0C,$10,$04,$00
                    .db $10,$0C,$0C,$10,$04,$00,$10,$0C
                    .db $10,$10,$08,$08,$08,$08,$10,$10
                    .db $10,$10,$00,$00,$10,$10,$10,$10
                    .db $00,$F0,$00,$F0,$F4,$F0,$00,$FC
                    .db $F0,$F4,$F4,$F0,$00,$FC,$F0,$F4
                    .db $F0,$F0,$F8,$F8,$F8,$F8,$F0,$F0
                    .db $F0,$F0,$00,$00,$F0,$F0,$F0

DATA_01DD90:        .db $F0

DATA_01DD91:        .db $50,$78,$A0,$A0,$A0,$78,$50,$50
DATA_01DD99:        .db $78

DATA_01DD9A:        .db $F0,$F0,$F0,$18,$40,$40,$40,$18
DATA_01DDA2:        .db $18,$03,$00,$00,$01,$01,$02,$02
                    .db $03,$FF

ADDR_01DDAC:        LDA.W $1B94               
                    BEQ ADDR_01DDB5           
                    STZ.W $14C8,X             
                    RTS                       ; Return 

ADDR_01DDB5:        LDX.B #$09                
ADDR_01DDB7:        LDA.B #$08                
                    STA.W $14C8,X             
                    LDA.B #$82                
                    STA.W $009E,X             
                    LDA.W DATA_01DD90,X       
                    STA $E4,X                 
                    LDA.B #$00                
                    STA.W $14E0,X             
                    LDA.W DATA_01DD99,X       
                    STA $D8,X                 
                    ASL                       
                    LDA.B #$00                
                    BCS ADDR_01DDD6           
                    INC A                     
ADDR_01DDD6:        STA.W $14D4,X             
                    JSL.L ADDR_07F7D2         
                    LDA.W DATA_01DDA2,X       
                    STA.W $157C,X             
                    TXA                       
                    CLC                       
                    ADC $13                   
                    AND.B #$07                
                    STA.W $1570,X             
                    DEX                       
                    BNE ADDR_01DDB7           
                    STZ.W $188F               
                    STZ.W $1890               
                    JSL.L ADDR_01ACF9         
                    EOR $13                   
                    ADC $14                   
                    AND.B #$07                
                    TAY                       
                    LDA.W DATA_01DE21,Y       
                    STA.W $1579               
                    LDA.B #$01                
                    STA $CB                   
                    INC.W $1B94               
                    LDX.W $15E9               
                    RTS                       ; Return 


DATA_01DE11:        .db $10,$00,$F0,$00

DATA_01DE15:        .db $00,$10,$00,$F0

DATA_01DE19:        .db $A0,$A0,$50,$50

DATA_01DE1D:        .db $F0,$40,$40,$F0

DATA_01DE21:        .db $01,$01,$01,$04,$04,$04,$07,$07
                    .db $07

ADDR_01DE2A:        STZ.W $15A0,X             
                    CPX.B #$01                
                    BNE ADDR_01DE34           
                    JSR.W ADDR_01E26A         
ADDR_01DE34:        JSR.W ADDR_01DF19         
                    LDA $9D                   
                    BNE ADDR_01DE40           
                    LDA.W $188F               
                    BEQ ADDR_01DE41           
ADDR_01DE40:        RTS                       ; Return 

ADDR_01DE41:        LDA $C2,X                 
                    BNE ADDR_01DE8C           
                    LDA $14                   
                    AND.B #$03                
                    BNE ADDR_01DE58           
                    INC.W $1570,X             
                    LDA.W $1570,X             
                    CMP.B #$09                
                    BNE ADDR_01DE58           
                    STZ.W $1570,X             
ADDR_01DE58:        JSR.W ADDR_01A7E4         
                    BCC ADDR_01DE8C           
                    LDA $7D                   
                    BPL ADDR_01DE8C           
                    LDA.B #$F4                
                    LDY $19                   
                    BEQ ADDR_01DE69           
                    LDA.B #$00                
ADDR_01DE69:        CLC                       
                    ADC $D8,X                 
                    SEC                       
                    SBC $1C                   
                    CMP $80                   
                    BCS ADDR_01DE8C           
                    LDA.B #$10                
                    STA $7D                   
                    LDA.B #$0B                
                    STA.W $1DF9               ; / Play sound effect 
                    INC $C2,X                 
                    LDY.W $1570,X             
                    LDA.W DATA_01DE21,Y       
                    STA.W $1570,X             
                    LDA.B #$10                
                    STA.W $1540,X             
ADDR_01DE8C:        LDY.W $157C,X             
                    BMI ADDR_01DEAF           
                    LDA $E4,X                 
                    CMP.W DATA_01DE19,Y       
                    BNE ADDR_01DE9F           
                    LDA $D8,X                 
                    CMP.W DATA_01DE1D,Y       
                    BEQ ADDR_01DEB0           
ADDR_01DE9F:        LDA.W DATA_01DE11,Y       
                    STA $B6,X                 
                    LDA.W DATA_01DE15,Y       
                    STA $AA,X                 
                    JSR.W ADDR_01ABCC         
                    JSR.W ADDR_01ABD8         
ADDR_01DEAF:        RTS                       ; Return 

ADDR_01DEB0:        LDY.B #$09                
ADDR_01DEB2:        LDA.W $00C2,Y             
                    BEQ ADDR_01DED7           
                    LDA.W $00D8,Y             
                    CLC                       
                    ADC.B #$04                
                    AND.B #$F8                
                    STA.W $00D8,Y             
                    LDA.W $00E4,Y             
                    CLC                       
                    ADC.B #$04                
                    AND.B #$F8                
                    STA.W $00E4,Y             
                    DEY                       
                    BNE ADDR_01DEB2           
                    INC.W $188F               
                    JSR.W ADDR_01DFD9         
                    RTS                       ; Return 

ADDR_01DED7:        LDA.W $157C,X             
                    INC A                     
                    AND.B #$03                
                    TAY                       
                    STA.W $157C,X             
                    BRA ADDR_01DE9F           

DATA_01DEE3:        .db $58

DATA_01DEE4:        .db $59

DATA_01DEE5:        .db $83

DATA_01DEE6:        .db $83,$48,$49,$58,$59,$83,$83,$48
                    .db $49,$34,$35,$83,$83,$24,$25,$34
                    .db $35,$83,$83,$24,$25,$36,$37,$83
                    .db $83,$26,$27,$36,$37,$83,$83,$26
                    .db $27

DATA_01DF07:        .db $04,$04,$04,$08,$08,$08,$0A,$0A
                    .db $0A

DATA_01DF10:        .db $00,$03,$05,$07,$08,$08,$07,$05
                    .db $03

ADDR_01DF19:        LDA.W $1540,X             
                    LSR                       
                    TAY                       
                    LDA.W DATA_01DF10,Y       
                    STA $00                   
                    LDY.W $15EA,X             
                    LDA $E4,X                 
                    SEC                       
                    SBC $1A                   
                    STA.W $0310,Y             
                    STA.W $0300,Y             
                    STA.W $0308,Y             
                    CLC                       
                    ADC.B #$08                
                    STA.W $0304,Y             
                    STA.W $030C,Y             
                    LDA.W $154C,X             
                    CLC                       
                    BEQ ADDR_01DF4E           
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    BRA ADDR_01DF4D           
                    CLC                       
                    ADC.W $15E9               
ADDR_01DF4D:        LSR                       
ADDR_01DF4E:        PHP                       
                    LDA $D8,X                 
                    SEC                       
                    SBC $00                   
                    SEC                       
                    SBC $1C                   
                    STA.W $0311,Y             
                    PLP                       
                    BCS ADDR_01DF6C           
                    STA.W $0301,Y             
                    STA.W $0305,Y             
                    CLC                       
                    ADC.B #$08                
                    STA.W $0309,Y             
                    STA.W $030D,Y             
ADDR_01DF6C:        LDA.W $1570,X             
                    PHX                       
                    PHA                       
                    ASL                       
                    ASL                       
                    TAX                       
                    LDA.W DATA_01DEE3,X       
                    STA.W $0302,Y             
                    LDA.W DATA_01DEE4,X       
                    STA.W $0306,Y             
                    LDA.W DATA_01DEE5,X       
                    STA.W $030A,Y             
                    LDA.W DATA_01DEE6,X       
                    STA.W $030E,Y             
                    LDA.B #$E4                
                    STA.W $0312,Y             
                    PLX                       
                    LDA $64                   
                    ORA.W DATA_01DF07,X       
                    STA.W $0303,Y             
                    STA.W $0307,Y             
                    STA.W $030B,Y             
                    STA.W $030F,Y             
                    ORA.B #$01                
                    STA.W $0313,Y             
                    PLX                       
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$00                
                    STA.W $0460,Y             
                    STA.W $0461,Y             
                    STA.W $0462,Y             
                    STA.W $0463,Y             
                    LDA.B #$02                
                    STA.W $0464,Y             
                    RTS                       ; Return 


DATA_01DFC1:        .db $00,$01,$02,$02,$03,$04,$04,$05
                    .db $06,$06,$07,$00,$00,$08,$04,$02
                    .db $08,$06,$03,$08,$07,$01,$08,$05
ADDR_01DFD9:        .db $A9,$07

                    STA $00                   
ADDR_01DFDD:        LDX.B #$02                
ADDR_01DFDF:        STX $01                   
                    LDA $00                   
                    ASL                       
                    ADC $00                   
                    CLC                       
                    ADC $01                   
                    TAY                       
                    LDA.W DATA_01DFC1,Y       
                    TAY                       
                    LDA.W DATA_01DD9A,Y       
                    STA $02                   
                    LDA.W DATA_01DD91,Y       
                    STA $03                   
                    LDY.B #$09                
ADDR_01DFFA:        LDA.W $00D8,Y             
                    CMP $02                   
                    BNE ADDR_01E008           
                    LDA.W $00E4,Y             
                    CMP $03                   
                    BEQ ADDR_01E00D           
ADDR_01E008:        DEY                       
                    CPY.B #$01                
                    BNE ADDR_01DFFA           
ADDR_01E00D:        LDA.W $1570,Y             
                    STA $04,X                 
                    STY $07,X                 
                    DEX                       
                    BPL ADDR_01DFDF           
                    LDA $04                   
                    CMP $05                   
                    BNE ADDR_01E035           
                    CMP $06                   
                    BNE ADDR_01E035           
                    INC.W $1890               
                    LDA.B #$70                
                    LDY $07                   
                    STA.W $154C,Y             
                    LDY $08                   
                    STA.W $154C,Y             
                    LDY $09                   
                    STA.W $154C,Y             
ADDR_01E035:        DEC $00                   
                    BPL ADDR_01DFDD           
                    LDX.W $15E9               
                    LDY.B #$29                
                    LDA.W $1890               
                    STA.W $1920               
                    BNE ADDR_01E04C           
                    LDA.B #$58                
                    STA.W $14AB               
                    INY                       
ADDR_01E04C:        STY.W $1DFC               ; / Play sound effect 
                    RTS                       ; Return 

ADDR_01E050:        LDA $D8,X                 
                    STA.W $1528,X             
                    LDA.W $14D4,X             
                    STA.W $151C,X             
ADDR_01E05B:        LDA $D8,X                 
                    CLC                       
                    ADC.B #$10                
                    STA $D8,X                 
                    LDA.W $14D4,X             
                    ADC.B #$00                
                    STA.W $14D4,X             
                    JSR.W ADDR_019140         
                    LDA.W $164A,X             
                    BEQ ADDR_01E05B           
                    JSR.W ADDR_01E0E2         
                    LDA.B #$20                
                    STA.W $1540,X             
                    RTS                       ; Return 


DATA_01E07B:        .db $F0,$DC,$D0,$C8,$C0,$B8,$B2,$AC
                    .db $A6,$A0,$9A,$96,$92,$8C,$88,$84
                    .db $80,$04,$08,$0C,$10,$14

DATA_01E091:        .db $70,$20

ADDR_01E093:        STZ.W $15D0,X             
                    LDA.W $1540,X             
                    BEQ ADDR_01E0A7           
                    STA.W $15D0,X             
                    DEC A                     
                    BNE ADDR_01E0A6           
                    LDA.B #$27                
                    STA.W $1DFC               ; / Play sound effect 
ADDR_01E0A6:        RTS                       ; Return 

ADDR_01E0A7:        LDA $9D                   
                    BEQ ADDR_01E0AE           
                    JMP.W ADDR_01E12D         
ADDR_01E0AE:        JSR.W ADDR_01A7E4         
                    JSR.W ADDR_018E5F         
                    JSR.W ADDR_018E5F         
                    LDA.W $15F6,X             
                    AND.B #$7F                
                    LDY $AA,X                 
                    BMI ADDR_01E0C8           
                    INC.W $1602,X             
                    INC.W $1602,X             
                    ORA.B #$80                
ADDR_01E0C8:        STA.W $15F6,X             
                    JSR.W ADDR_019140         
                    LDA.W $164A,X             
                    BEQ ADDR_01E106           
                    LDA $AA,X                 
                    BMI ADDR_01E106           
                    JSL.L ADDR_01ACF9         
                    AND.B #$3F                
                    ADC.B #$60                
                    STA.W $1540,X             
ADDR_01E0E2:        LDA $D8,X                 
                    SEC                       
                    SBC.W $1528,X             
                    STA $00                   
                    LDA.W $14D4,X             
                    SBC.W $151C,X             
                    LSR                       
                    ROR $00                   
                    LDA $00                   
                    LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_01E07B,Y       
                    BMI ADDR_01E103           
                    STA.W $1564,X             
                    LDA.B #$80                
ADDR_01E103:        STA $AA,X                 
                    RTS                       ; Return 

ADDR_01E106:        JSR.W ADDR_01ABD8         
                    LDA $14                   
                    AND.B #$07                
                    ORA $C2,X                 
                    BNE ADDR_01E115           
                    JSL.L ADDR_0285DF         
ADDR_01E115:        LDA.W $1564,X             
                    BNE ADDR_01E12A           
                    LDA $AA,X                 
                    BMI ADDR_01E125           
                    LDY $C2,X                 
                    CMP.W DATA_01E091,Y       
                    BCS ADDR_01E12A           
ADDR_01E125:        CLC                       
                    ADC.B #$02                
                    STA $AA,X                 
ADDR_01E12A:        JSR.W ADDR_01AC31         
ADDR_01E12D:        LDA $C2,X                 
                    BEQ ADDR_01E198           
                    LDY $9D                   
                    BNE ADDR_01E164           
                    LDA.W $1588,X             
                    AND.B #$04                
                    BEQ ADDR_01E151           
                    STZ $AA,X                 
                    LDA.W $1558,X             
                    BEQ ADDR_01E14A           
                    CMP.B #$01                
                    BNE ADDR_01E14F           
                    JMP.W ADDR_019ACB         
ADDR_01E14A:        LDA.B #$80                
                    STA.W $1558,X             
ADDR_01E14F:        BRA ADDR_01E164           
ADDR_01E151:        TXA                       
                    ASL                       
                    ASL                       
                    CLC                       
                    ADC $13                   
                    LDY.B #$F0                
                    AND.B #$04                
                    BEQ ADDR_01E15F           
                    LDY.B #$10                
ADDR_01E15F:        STY $B6,X                 
                    JSR.W ADDR_01ABCC         
ADDR_01E164:        LDA $D8,X                 
                    CMP.B #$F0                
                    BCC ADDR_01E16D           
                    STZ.W $14C8,X             
ADDR_01E16D:        JSR.W ADDR_019F0D         
                    LDY.W $15EA,X             
                    PHX                       
                    LDA $14                   
                    AND.B #$0C                
                    LSR                       
                    ADC.W $15E9               
                    LSR                       
                    AND.B #$03                
                    TAX                       
                    LDA.W DATA_01E190,X       
                    STA.W $0302,Y             
                    LDA.W DATA_01E194,X       
                    ORA $64                   
                    STA.W $0303,Y             
                    PLX                       
                    RTS                       ; Return 


DATA_01E190:        .db $2A,$2C,$2A,$2C

DATA_01E194:        .db $05,$05,$45,$45

ADDR_01E198:        LDA.B #$01                
                    JSR.W ADDR_019CF3         
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W #$0008              
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
                    RTS                       ; Return 

ADDR_01E1B8:        LDA $E4,X                 
                    CLC                       
                    ADC.B #$08                
                    STA $E4,X                 
                    LDA.W $14E0,X             
                    ADC.B #$00                
                    STA.W $14E0,X             
                    RTS                       ; Return 

ADDR_01E1C8:        LDY.B #$0B                
ADDR_01E1CA:        LDA.W $14C8,Y             
                    CMP.B #$08                
                    BCC ADDR_01E1D8           
                    LDA.W $009E,Y             
                    CMP.B #$80                
                    BEQ ADDR_01E1DB           
ADDR_01E1D8:        DEY                       
                    BPL ADDR_01E1CA           
ADDR_01E1DB:        LDA.W $187A               
                    BEQ ADDR_01E1E5           
                    LDA.W $191C               
                    BNE ADDR_01E1ED           
ADDR_01E1E5:        TYA                       
                    STA.W $151C,X             
                    BMI ADDR_01E23A           
                    BRA ADDR_01E1F3           
ADDR_01E1ED:        JSL.L ADDR_03B664         
                    BRA ADDR_01E201           
ADDR_01E1F3:        LDA.W $14C8,Y             
                    CMP.B #$0B                
                    BNE ADDR_01E23A           
                    PHX                       
                    TYX                       
                    JSL.L ADDR_03B6E5         
                    PLX                       
ADDR_01E201:        JSL.L ADDR_03B69F         
                    JSL.L ADDR_03B72B         
                    BCC ADDR_01E23A           
                    LDA.W $154C,X             
                    BNE ADDR_01E23A           
                    LDA.B #$30                
                    STA.W $1434               
                    LDA.B #$10                
                    STA.W $1DFB               ; / Play sound effect 
                    INC.W $13FB               
                    INC $9D                   
                    LDA.W $14E0,X             
                    STA.W $1437               
                    LDA $E4,X                 
                    STA.W $1436               
                    LDA.W $14D4,X             
                    STA.W $1439               
                    LDA $D8,X                 
                    STA.W $1438               
                    LDA.B #$30                
                    STA.W $154C,X             
ADDR_01E23A:        JSR.W GetDrawInfoBnk1     
                    LDA $00                   
                    STA.W $0300,Y             
                    STA.W $0304,Y             
                    LDA $01                   
                    STA.W $0301,Y             
                    CLC                       
                    ADC.B #$08                
                    STA.W $0305,Y             
                    LDA.B #$EB                
                    STA.W $0302,Y             
                    LDA.B #$FB                
                    STA.W $0306,Y             
                    LDA.B #$30                
                    STA.W $0303,Y             
                    STA.W $0307,Y             
                    LDY.B #$00                
                    LDA.B #$01                
                    JSR.W ADDR_01B7BB         
                    RTS                       ; Return 

ADDR_01E26A:        LDA $13                   
                    AND.B #$3F                
                    BNE ADDR_01E27B           
                    LDA.W $1890               
                    BEQ ADDR_01E27B           
                    DEC.W $1890               
                    JSR.W ADDR_01E281         
ADDR_01E27B:        LDA.B #$01                
                    STA.W $18B8               
                    RTS                       ; Return 

ADDR_01E281:        LDY.B #$07                
ADDR_01E283:        LDA.W $1892,Y             
                    BEQ ADDR_01E28C           
                    DEY                       
                    BPL ADDR_01E283           
                    RTS                       ; Return 

ADDR_01E28C:        LDA.B #$01                
                    STA.W $1892,Y             
                    LDA.B #$00                
                    STA.W $1E02,Y             
                    LDA.B #$01                
                    STA.W $1E2A,Y             
                    LDA.B #$18                
                    STA.W $1E16,Y             
                    LDA.B #$00                
                    STA.W $1E3E,Y             
                    LDA.B #$01                
                    STA.W $1E66,Y             
                    LDA.B #$10                
                    STA.W $1E52,Y             
                    RTS                       ; Return 


DATA_01E2B0:        .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $13,$14,$15,$16,$17,$18,$19

ADDR_01E2CF:        JSR.W ADDR_01AC31         
                    LDA $C2,X                 
                    JSL.L ExecutePtr          

Ptrs01E2D8:         .dw ADDR_01E2E0           
                    .dw ADDR_01E309           
                    .dw ADDR_01E37F           
                    .dw ADDR_01E393           

ADDR_01E2E0:        JSR.W SubHorizPos         
                    LDA $0F                   
                    CLC                       
                    ADC.B #$60                
                    CMP.B #$C0                
                    BCS ADDR_01E305           
                    LDA.W $15A0,X             
                    BNE ADDR_01E305           
                    INC $C2,X                 
                    LDY.W $0DB3               
                    LDA.W $1F11,Y             
                    TAY                       
                    LDA.B #$68                
                    CPY.B #$01                
                    BEQ ADDR_01E302           
                    LDA.B #$20                
ADDR_01E302:        STA.W $1540,X             
ADDR_01E305:        JSR.W GetDrawInfoBnk1     
                    RTS                       ; Return 

ADDR_01E309:        LDA.W $1540,X             
                    ORA.W $15D0,X             
                    BNE ADDR_01E343           
                    INC $C2,X                 
                    LDA.B #$B0                
                    STA $AA,X                 
                    JSR.W IsSprOffscreen      
                    BNE ADDR_01E320           
                    TAY                       
                    JSR.W ADDR_0199E1         
ADDR_01E320:        JSR.W FaceMario           
                    LDA $9E,X                 
                    CMP.B #$4E                
                    BNE ADDR_01E343           
                    LDA $E4,X                 
                    STA $9A                   
                    LDA.W $14E0,X             
                    STA $9B                   
                    LDA $D8,X                 
                    STA $98                   
                    LDA.W $14D4,X             
                    STA $99                   
                    LDA.B #$08                
                    STA $9C                   
                    JSL.L ADDR_00BEB0         
ADDR_01E343:        LDA $9E,X                 
                    CMP.B #$4D                
                    BNE ADDR_01E363           
                    LDA $14                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.B #$01                
                    TAY                       
                    LDA.W DATA_01E35F,Y       
                    STA.W $1602,X             
                    LDA.W DATA_01E361,Y       
                    JSR.W ADDR_019CF3         
                    RTS                       ; Return 


DATA_01E35F:        .db $01,$02

DATA_01E361:        .db $00,$05

ADDR_01E363:        LDA $14                   
                    ASL                       
                    ASL                       
                    AND.B #$C0                
                    ORA.B #$31                
                    STA.W $15F6,X             
                    LDA.B #$03                
                    STA.W $1602,X             
                    JSR.W ADDR_019F0D         
                    LDA.W $15F6,X             
                    AND.B #$3F                
                    STA.W $15F6,X             
                    RTS                       ; Return 

ADDR_01E37F:        JSR.W ADDR_01E3EF         
                    LDA.B #$02                
                    STA.W $1602,X             
                    JSR.W ADDR_01800E         
                    BEQ ADDR_01E38E           
                    INC $C2,X                 
ADDR_01E38E:        RTS                       ; Return 


DATA_01E38F:        .db $10,$F0

DATA_01E391:        .db $18,$E8

ADDR_01E393:        JSR.W ADDR_01E3EF         
                    LDA.W $151C,X             
                    BNE ADDR_01E3C7           
                    JSR.W ADDR_018E5F         
                    JSR.W ADDR_018E5F         
                    JSL.L ADDR_01ACF9         
                    AND.B #$01                
                    BNE ADDR_01E3C6           
                    JSR.W FaceMario           
                    LDA $B6,X                 
                    CMP.W DATA_01E391,Y       
                    BEQ ADDR_01E3C6           
                    CLC                       
                    ADC.W DATA_01EBB4,Y       
                    STA $B6,X                 
                    TYA                       
                    LSR                       
                    ROR                       
                    EOR $B6,X                 
                    BPL ADDR_01E3C6           
                    JSR.W ADDR_01804E         
                    JSR.W ADDR_018E5F         
ADDR_01E3C6:        RTS                       ; Return 

ADDR_01E3C7:        JSR.W ADDR_01800E         
                    BEQ ADDR_01E3E9           
                    JSR.W ADDR_018E5F         
                    JSR.W ADDR_018E5F         
                    LDY.W $157C,X             
                    LDA.W DATA_01E38F,Y       
                    STA $B6,X                 
                    LDA.W $1558,X             
                    BNE ADDR_01E3E8           
                    LDA.B #$50                
                    STA.W $1558,X             
                    LDA.B #$D8                
                    STA $AA,X                 
ADDR_01E3E8:        RTS                       ; Return 

ADDR_01E3E9:        LDA.B #$01                
                    STA.W $1602,X             
                    RTS                       ; Return 

ADDR_01E3EF:        LDA $64                   
                    PHA                       
                    LDA.W $1540,X             
                    BEQ ADDR_01E3FB           
                    LDA.B #$10                
                    STA $64                   
ADDR_01E3FB:        JSR.W ADDR_019F0D         
                    PLA                       
                    STA $64                   
                    LDA $9D                   
                    BNE ADDR_01E41C           
                    JSR.W ADDR_018FC1         
                    JSR.W ADDR_019032         
                    JSR.W ADDR_01800E         
                    BEQ ADDR_01E413           
                    JSR.W ADDR_019A04         
ADDR_01E413:        JSR.W ADDR_018008         
                    BEQ ADDR_01E41B           
                    JSR.W ADDR_019098         
ADDR_01E41B:        RTS                       ; Return 

ADDR_01E41C:        PLA                       
                    PLA                       
                    RTS                       ; Return 


DATA_01E41F:        .db $08,$F8,$02,$03,$04,$04,$04,$04
                    .db $04,$04,$04,$04

ADDR_01E42B:        LDA.W $14C8,X             
                    CMP.B #$08                
                    BEQ ADDR_01E43E           
                    ASL.W $15F6,X             
                    SEC                       
                    ROR.W $15F6,X             
                    JMP.W ADDR_01E5BF         

DATA_01E43C:        .db $08,$F8

ADDR_01E43E:        LDA.W $1534,X             
                    BEQ ADDR_01E4C0           
                    JSR.W ADDR_019F0D         
                    LDY.W $1540,X             
                    BNE ADDR_01E453           
                    STZ.W $1534,X             
                    PHY                       
                    JSR.W FaceMario           
                    PLY                       
ADDR_01E453:        LDA.B #$48                
                    CPY.B #$10                
                    BCC ADDR_01E45F           
                    CPY.B #$F0                
                    BCS ADDR_01E45F           
                    LDA.B #$2E                
ADDR_01E45F:        LDY.W $15EA,X             
                    STA.W $0302,Y             
                    TYA                       
                    CLC                       
                    ADC.B #$04                
                    STA.W $15EA,X             
                    PHX                       
                    LDA.W $157C,X             
                    TAX                       
                    LDA.W $0300,Y             
                    CLC                       
                    ADC.W DATA_01E43C,X       
                    PLX                       
                    STA.W $0304,Y             
                    LDA.W $0301,Y             
                    STA.W $0305,Y             
                    LDA.W $0303,Y             
                    STA.W $0307,Y             
                    LDA.W $0302,Y             
                    DEC A                     
                    STA.W $0306,Y             
                    LDA.W $1540,X             
                    BEQ ADDR_01E4AC           
                    CMP.B #$40                
                    BCS ADDR_01E4AC           
                    LSR                       
                    LSR                       
                    PHP                       
                    LDA.W $0300,Y             
                    ADC.B #$00                
                    STA.W $0300,Y             
                    PLP                       
                    LDA.W $0304,Y             
                    ADC.B #$00                
                    STA.W $0304,Y             
ADDR_01E4AC:        LDY.B #$02                
                    LDA.B #$01                
                    JSR.W ADDR_01B7BB         
                    JSR.W ADDR_019032         
                    JSR.W ADDR_01800E         
                    BEQ ADDR_01E4BF           
                    STZ $AA,X                 
                    STZ $B6,X                 
ADDR_01E4BF:        RTS                       ; Return 

ADDR_01E4C0:        LDA $9D                   
                    ORA.W $163E,X             
                    BEQ ADDR_01E4CA           
                    JMP.W ADDR_01E5B6         
ADDR_01E4CA:        LDY.W $157C,X             
                    LDA.W DATA_01E41F,Y       
                    EOR.W $15B8,X             
                    ASL                       
                    LDA.W DATA_01E41F,Y       
                    BCC ADDR_01E4DD           
                    CLC                       
                    ADC.W $15B8,X             
ADDR_01E4DD:        STA $B6,X                 
                    LDA.W $1540,X             
                    BNE ADDR_01E4ED           
                    TYA                       
                    INC A                     
                    AND.W $1588,X             
                    AND.B #$03                
                    BEQ ADDR_01E4EF           
ADDR_01E4ED:        STZ $B6,X                 
ADDR_01E4EF:        JSR.W ADDR_018014         
                    BEQ ADDR_01E4F6           
                    STZ $AA,X                 
ADDR_01E4F6:        JSR.W ADDR_01AC31         
                    JSR.W ADDR_019032         
                    LDA $9E,X                 
                    CMP.B #$31                
                    BNE ADDR_01E51E           
                    LDA.W $1540,X             
                    BEQ ADDR_01E542           
                    LDY.B #$00                
                    CMP.B #$70                
                    BCS ADDR_01E518           
                    INY                       
                    INY                       
                    CMP.B #$08                
                    BCC ADDR_01E518           
                    CMP.B #$68                
                    BCS ADDR_01E518           
                    INY                       
ADDR_01E518:        TYA                       
                    STA.W $1602,X             
                    BRA ADDR_01E563           
ADDR_01E51E:        CMP.B #$30                
                    BEQ ADDR_01E52D           
                    CMP.B #$32                
                    BNE ADDR_01E542           
                    LDA.W $13BF               
                    CMP.B #$31                
                    BNE ADDR_01E542           
ADDR_01E52D:        LDA.W $1540,X             
                    BEQ ADDR_01E542           
                    CMP.B #$01                
                    BNE ADDR_01E53A           
                    JSL.L ADDR_03C44E         
ADDR_01E53A:        LDA.B #$02                
                    STA.W $1602,X             
                    JMP.W ADDR_01E5B6         
ADDR_01E542:        JSR.W ADDR_01800E         
                    BEQ ADDR_01E563           
                    JSR.W ADDR_019A04         
                    JSR.W ADDR_018E5F         
                    LDA $9E,X                 
                    CMP.B #$32                
                    BNE ADDR_01E557           
                    STZ $C2,X                 
                    BRA ADDR_01E561           
ADDR_01E557:        LDA.W $1570,X             
                    AND.B #$7F                
                    BNE ADDR_01E561           
                    JSR.W FaceMario           
ADDR_01E561:        BRA ADDR_01E57B           
ADDR_01E563:        STZ.W $1570,X             
                    LDA $9E,X                 
                    CMP.B #$32                
                    BNE ADDR_01E57B           
                    LDA $C2,X                 
                    BNE ADDR_01E57B           
                    INC $C2,X                 
                    JSR.W ADDR_019098         
                    JSR.W ADDR_01ABCC         
                    JSR.W ADDR_01ABCC         
ADDR_01E57B:        LDA $9E,X                 
                    CMP.B #$31                
                    BNE ADDR_01E598           
                    LDA $13                   
                    LSR                       
                    BCC ADDR_01E589           
                    INC.W $1528,X             
ADDR_01E589:        LDA.W $1528,X             
                    BNE ADDR_01E5B6           
                    INC.W $1528,X             
                    LDA.B #$A0                
                    STA.W $1540,X             
                    BRA ADDR_01E5B6           
ADDR_01E598:        CMP.B #$30                
                    BEQ ADDR_01E5A7           
                    CMP.B #$32                
                    BNE ADDR_01E5B6           
                    LDA.W $13BF               
                    CMP.B #$31                
                    BNE ADDR_01E5B6           
ADDR_01E5A7:        LDA.W $1570,X             
                    CLC                       
                    ADC.B #$40                
                    AND.B #$7F                
                    BNE ADDR_01E5B6           
                    LDA.B #$3F                
                    STA.W $1540,X             
ADDR_01E5B6:        JSR.W ADDR_01E5C4         
                    JSR.W ADDR_01A40D         
                    JSR.W ADDR_019089         
ADDR_01E5BF:        JSL.L ADDR_03C390         
                    RTS                       ; Return 

ADDR_01E5C4:        JSR.W ADDR_01A7E4         
                    BCC ADDR_01E610           
                    LDA $D3                   
                    CLC                       
                    ADC.B #$14                
                    CMP $D8,X                 
                    BPL ADDR_01E604           
                    LDA.W $1697               
                    BNE ADDR_01E5DB           
                    LDA $7D                   
                    BMI ADDR_01E604           
ADDR_01E5DB:        LDA $9E,X                 
                    CMP.B #$31                
                    BNE ADDR_01E5EB           
                    LDA.W $1540,X             
                    SEC                       
                    SBC.B #$08                
                    CMP.B #$60                
                    BCC ADDR_01E604           
ADDR_01E5EB:        JSR.W ADDR_01AB46         
                    JSL.L DisplayContactGfx   
                    LDA.B #$07                
                    STA.W $1DF9               ; / Play sound effect 
                    JSL.L BoostMarioSpeed     
                    INC.W $1534,X             
                    LDA.B #$FF                
                    STA.W $1540,X             
                    RTS                       ; Return 

ADDR_01E604:        JSL.L HurtMario           
                    LDA.W $1497               
                    BNE ADDR_01E610           
                    JSR.W FaceMario           
ADDR_01E610:        RTS                       ; Return 


DATA_01E611:        .db $00,$01,$02,$02,$02,$01,$01,$00
                    .db $00

DATA_01E61A:        .db $1E,$1B,$18,$18,$18,$1A,$1C,$1D
                    .db $1E

ADDR_01E623:        LDA $9D                   
                    BEQ ADDR_01E62A           
                    JMP.W ADDR_01E6F0         
ADDR_01E62A:        JSR.W ADDR_01AC31         
                    JSR.W ADDR_019032         
                    JSR.W ADDR_01800E         
                    BEQ ADDR_01E638           
                    JSR.W ADDR_0197D5         
ADDR_01E638:        JSR.W ADDR_018008         
                    BEQ ADDR_01E649           
                    JSR.W ADDR_019098         
                    LDA $B6,X                 
                    ASL                       
                    PHP                       
                    ROR $B6,X                 
                    PLP                       
                    ROR $B6,X                 
ADDR_01E649:        JSR.W ADDR_018014         
                    BEQ ADDR_01E650           
                    STZ $AA,X                 
ADDR_01E650:        LDA.W $1540,X             
                    BEQ ADDR_01E6B0           
                    LSR                       
                    TAY                       
                    LDA.W $187A               
                    CMP.B #$01                
                    LDA.W DATA_01E61A,Y       
                    BCC ADDR_01E664           
                    CLC                       
                    ADC.B #$12                
ADDR_01E664:        STA $00                   
                    LDA.W DATA_01E611,Y       
                    STA.W $1602,X             
                    LDA $D8,X                 
                    SEC                       
                    SBC $00                   
                    STA $96                   
                    LDA.W $14D4,X             
                    SBC.B #$00                
                    STA $97                   
                    STZ $72                   
                    STZ $7B                   
                    LDA.B #$02                
                    STA.W $1471               
                    LDA.W $1540,X             
                    CMP.B #$07                
                    BCS ADDR_01E6AE           
                    STZ.W $1471               
                    LDY.B #$B0                
                    LDA $17                   
                    BPL ADDR_01E69A           
                    LDA.B #$01                
                    STA.W $140D               
                    BRA ADDR_01E69E           
ADDR_01E69A:        LDA $15                   
                    BPL ADDR_01E6A7           
ADDR_01E69E:        LDA.B #$0B                
                    STA $72                   
                    LDY.B #$80                
                    STY.W $1406               
ADDR_01E6A7:        STY $7D                   
                    LDA.B #$08                
                    STA.W $1DFC               ; / Play sound effect 
ADDR_01E6AE:        BRA ADDR_01E6F0           
ADDR_01E6B0:        JSR.W ADDR_01A7F7         
                    BCC ADDR_01E6F0           
                    STZ.W $154C,X             
                    LDA $D8,X                 
                    SEC                       
                    SBC $96                   
                    CLC                       
                    ADC.B #$04                
                    CMP.B #$1C                
                    BCC ADDR_01E6CE           
                    BPL ADDR_01E6E7           
                    LDA $7D                   
                    BPL ADDR_01E6F0           
                    STZ $7D                   
                    BRA ADDR_01E6F0           
ADDR_01E6CE:        BIT $15                   
                    BVC ADDR_01E6E2           
                    LDA.W $1470               
                    ORA.W $187A               
                    BNE ADDR_01E6E2           
                    LDA.B #$0B                
                    STA.W $14C8,X             
                    STZ.W $1602,X             
ADDR_01E6E2:        JSR.W ADDR_01AB31         
                    BRA ADDR_01E6F0           
ADDR_01E6E7:        LDA $7D                   
                    BMI ADDR_01E6F0           
                    LDA.B #$11                
                    STA.W $1540,X             
ADDR_01E6F0:        LDY.W $1602,X             
                    LDA.W DATA_01E6FD,Y       
                    TAY                       
                    LDA.B #$02                
                    JSR.W ADDR_019CF5         
                    RTS                       ; Return 


DATA_01E6FD:        .db $00,$02,$00

ADDR_01E700:        JSR.W GetDrawInfoBnk1     
                    JSR.W IsSprOffscreen      
                    BNE ADDR_01E75A           
                    LDA $00                   
                    STA.W $0300,Y             
                    CLC                       
                    ADC.B #$08                
                    STA.W $0304,Y             
                    LDA $01                   
                    CLC                       
                    ADC.B #$08                
                    STA.W $0301,Y             
                    STA.W $0305,Y             
                    PHX                       
                    LDA $9E,X                 
                    TAX                       
                    LDA.B #$FE                
                    CPX.B #$3E                
                    BEQ ADDR_01E73A           
                    LDA.B #$EE                
                    CPX.B #$BD                
                    BEQ ADDR_01E73A           
                    CPX.B #$04                
                    BCC ADDR_01E73A           
                    LDA.B #$C7                
                    CPX.B #$0F                
                    BCS ADDR_01E73A           
                    LDA.B #$4D                
ADDR_01E73A:        STA.W $0302,Y             
                    STA.W $0306,Y             
                    PLX                       
                    LDA $64                   
                    ORA.W $15F6,X             
                    STA.W $0303,Y             
                    ORA.B #$40                
                    STA.W $0307,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$00                
                    STA.W $0460,Y             
                    STA.W $0461,Y             
ADDR_01E75A:        RTS                       ; Return 

ADDR_01E75B:        LDA.W $1564,X             
                    CMP.B #$01                
                    BNE ADDR_01E76E           
                    STA.W $1F11               
                    STA.W $1FB8               
                    STZ.W $14C8,X             
                    INC.W $1426               
ADDR_01E76E:        RTS                       ; Return 


DATA_01E76F:        .db $FC,$04,$FE,$02,$FB,$05,$FD,$03
                    .db $FA,$06,$FC,$04,$FB,$05,$FD,$03
DATA_01E77F:        .db $00,$FF,$03,$04,$FF,$FE,$04,$03
                    .db $FE,$FF,$03,$03,$FF,$00,$03,$03
                    .db $F8,$FC,$00,$04

DATA_01E793:        .db $0E,$0F,$10,$11,$12,$11,$10,$0F
                    .db $1A,$1B,$1C,$1D,$1E,$1D,$1C,$1B
                    .db $1A

ADDR_01E7A4:        LDA $9D                   
                    BEQ ADDR_01E7AB           
ADDR_01E7A8:        JMP.W ADDR_01E8CA         
ADDR_01E7AB:        LDY.W $18E0               
                    BEQ ADDR_01E7C5           
                    LDA $14                   
                    AND.B #$03                
                    BNE ADDR_01E7C5           
                    LDA.W $18E0               
                    BEQ ADDR_01E7C5           
                    DEC.W $18E0               
                    BNE ADDR_01E7C5           
                    LDA.B #$1F                
                    STA.W $1540,X             
ADDR_01E7C5:        LDA.W $1540,X             
                    BEQ ADDR_01E7DB           
                    DEC A                     
                    BNE ADDR_01E7A8           
                    STZ.W $14C8,X             
                    LDA.B #$FF                
                    STA.W $18C0               
                    LDA.B #$1E                
                    STA.W $18C1               
                    RTS                       ; Return 

ADDR_01E7DB:        LDY.B #$09                
ADDR_01E7DD:        LDA.W $14C8,Y             
                    CMP.B #$08                
                    BNE ADDR_01E7F2           
                    LDA.W $009E,Y             
                    CMP.B #$1E                
                    BNE ADDR_01E7F2           
                    TYA                       
                    STA.W $160E,X             
                    JMP.W ADDR_01E898         
ADDR_01E7F2:        DEY                       
                    BPL ADDR_01E7DD           
                    LDA $C2,X                 
                    BNE ADDR_01E840           
                    LDA.W $151C,X             
                    BEQ ADDR_01E804           
                    JSR.W ADDR_01ABCC         
                    JSR.W ADDR_01ABD8         
ADDR_01E804:        LDA.W $154C,X             
                    BNE ADDR_01E83D           
                    JSR.W ADDR_01A7F7         
                    BCC ADDR_01E83D           
                    LDA $7D                   
                    BMI ADDR_01E83D           
                    INC $C2,X                 
                    LDA.B #$11                
                    LDY.W $187A               
                    BEQ ADDR_01E81D           
                    LDA.B #$22                
ADDR_01E81D:        CLC                       
                    ADC $D3                   
                    STA $D8,X                 
                    LDA $D4                   
                    ADC.B #$00                
                    STA.W $14D4,X             
                    LDA $D1                   
                    STA $E4,X                 
                    LDA $D2                   
                    STA.W $14E0,X             
                    LDA.B #$10                
                    STA $AA,X                 
                    STA.W $151C,X             
                    LDA $7B                   
                    STA $B6,X                 
ADDR_01E83D:        JMP.W ADDR_01E8CA         
ADDR_01E840:        JSR.W ADDR_01E8CA         
                    PHB                       
                    LDA.B #$02                
                    PHA                       
                    PLB                       
                    JSL.L ADDR_02D214         
                    PLB                       
                    LDA $AA,X                 
                    CLC                       
                    ADC.B #$03                
                    STA $7D                   
                    LDA $14                   
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.B #$07                
                    TAY                       
                    LDA.W $187A               
                    BEQ ADDR_01E866           
                    TYA                       
                    CLC                       
                    ADC.B #$08                
                    TAY                       
ADDR_01E866:        LDA $D1                   
                    STA $E4,X                 
                    LDA $D2                   
                    STA.W $14E0,X             
                    LDA $D3                   
                    CLC                       
                    ADC.W DATA_01E793,Y       
                    STA $D8,X                 
                    LDA $D4                   
                    ADC.B #$00                
                    STA.W $14D4,X             
                    STZ $72                   
                    INC.W $1471               
                    INC.W $18C2               
                    LDA $16                   
                    AND.B #$80                
                    BEQ ADDR_01E897           
                    LDA.B #$C0                
                    STA $7D                   
                    LDA.B #$10                
                    STA.W $154C,X             
                    STZ $C2,X                 
ADDR_01E897:        RTS                       ; Return 

ADDR_01E898:        PHY                       
                    JSR.W ADDR_01E98D         
                    LDA $14                   
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.B #$07                
                    TAY                       
                    LDA.W DATA_01E793,Y       
                    STA $00                   
                    PLY                       
                    LDA $E4,X                 
                    STA.W $00E4,Y             
                    LDA.W $14E0,X             
                    STA.W $14E0,Y             
                    LDA $D8,X                 
                    SEC                       
                    SBC $00                   
                    STA.W $00D8,Y             
                    LDA.W $14D4,X             
                    SBC.B #$00                
                    STA.W $14D4,Y             
                    LDA.B #$10                
                    STA.W $154C,X             
ADDR_01E8CA:        JSR.W GetDrawInfoBnk1     
                    LDA.W $186C,X             
                    BNE ADDR_01E897           
                    LDA.B #$F8                
                    STA $0C                   
                    LDA.B #$FC                
                    STA $0D                   
                    LDA.B #$00                
                    LDY $C2,X                 
                    BNE ADDR_01E8E2           
                    LDA.B #$30                
ADDR_01E8E2:        STA $0E                   
                    STA.W $18B6               
                    ORA.B #$04                
                    STA $0F                   
                    LDA $00                   
                    STA.W $14B0               
                    LDA $01                   
                    STA.W $14B2               
                    LDA $14                   
                    LSR                       
                    LSR                       
                    AND.B #$0C                
                    STA $02                   
                    LDA.B #$03                
                    STA $03                   
ADDR_01E901:        LDA $03                   
                    TAX                       
                    LDY $0C,X                 
                    CLC                       
                    ADC $02                   
                    TAX                       
                    LDA.W DATA_01E76F,X       
                    CLC                       
                    ADC.W $14B0               
                    STA.W $0300,Y             
                    LDA.W DATA_01E77F,X       
                    CLC                       
                    ADC.W $14B2               
                    STA.W $0301,Y             
                    LDX.W $15E9               
                    LDA.B #$60                
                    STA.W $0302,Y             
                    LDA.W $1540,X             
                    BEQ ADDR_01E935           
                    LSR                       
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W DATA_01E985,X       
                    STA.W $0302,Y             
ADDR_01E935:        LDA $64                   
                    STA.W $0303,Y             
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEC $03                   
                    BPL ADDR_01E901           
                    LDX.W $15E9               
                    LDA.B #$F8                
                    STA.W $15EA,X             
                    LDY.B #$02                
                    LDA.B #$01                
                    JSR.W ADDR_01B7BB         
                    LDA.W $18B6               
                    STA.W $15EA,X             
                    LDY.B #$02                
                    LDA.B #$01                
                    JSR.W ADDR_01B7BB         
                    LDA.W $15A0,X             
                    BNE ADDR_01E984           
                    LDA.W $14B0               
                    CLC                       
                    ADC.B #$04                
                    STA.W $0208               
                    LDA.W $14B2               
                    CLC                       
                    ADC.B #$07                
                    STA.W $0209               
                    LDA.B #$4D                
                    STA.W $020A               
                    LDA.B #$39                
                    STA.W $020B               
                    LDA.B #$00                
                    STA.W $0422               
ADDR_01E984:        RTS                       ; Return 


DATA_01E985:        .db $66,$64,$62,$60

DATA_01E989:        .db $20,$E0

DATA_01E98B:        .db $10,$F0

ADDR_01E98D:        LDA $9D                   
                    BNE ADDR_01E984           
                    JSR.W SubHorizPos         
                    TYA                       
                    LDY.W $160E,X             
                    STA.W $157C,Y             
                    STA $00                   
                    LDY $00                   
                    LDA.W $18BF               
                    BEQ ADDR_01E9BD           
                    PHY                       
                    PHX                       
                    LDA.W $160E,X             
                    TAX                       
                    JSR.W ADDR_01AC31         
                    LDA.W $14C8,X             
                    PLX                       
                    CMP.B #$00                
                    BNE ADDR_01E9B8           
                    STZ.W $14C8,X             
ADDR_01E9B8:        PLY                       
                    TYA                       
                    EOR.B #$01                
                    TAY                       
ADDR_01E9BD:        LDA $13                   
                    AND.B #$01                
                    BNE ADDR_01E9E6           
                    LDA $B6,X                 
                    CMP.W DATA_01E989,Y       
                    BEQ ADDR_01E9D0           
                    CLC                       
                    ADC.W DATA_01EBB4,Y       
                    STA $B6,X                 
ADDR_01E9D0:        LDA.W $1534,X             
                    AND.B #$01                
                    TAY                       
                    LDA $AA,X                 
                    CLC                       
                    ADC.W DATA_01EBB4,Y       
                    STA $AA,X                 
                    CMP.W DATA_01E98B,Y       
                    BNE ADDR_01E9E6           
                    INC.W $1534,X             
ADDR_01E9E6:        LDA $B6,X                 
                    PHA                       
                    LDY.W $18BF               
                    BNE ADDR_01E9F9           
                    LDA.W $17BD               
                    ASL                       
                    ASL                       
                    ASL                       
                    CLC                       
                    ADC $B6,X                 
                    STA $B6,X                 
ADDR_01E9F9:        JSR.W ADDR_01ABCC         
                    PLA                       
                    STA $B6,X                 
                    JSR.W ADDR_01ABD8         
                    LDY.W $160E,X             
                    LDA $13                   
                    AND.B #$7F                
                    ORA.W $151C,Y             
                    BNE ADDR_01EA16           
                    LDA.B #$20                
                    STA.W $1558,Y             
                    JSR.W ADDR_01EA21         
ADDR_01EA16:        RTS                       ; Return 


DATA_01EA17:        .db $10,$F0

ADDR_01EA19:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_01EA21         
                    PLB                       
                    RTL                       ; Return 

ADDR_01EA21:        JSL.L ADDR_02A9E4         
                    BMI ADDR_01EA6F           
                    LDA.B #$08                
                    STA.W $14C8,Y             
                    LDA.W $14AE               
                    CMP.B #$01                
                    LDA.B #$14                
                    BCC ADDR_01EA37           
                    LDA.B #$21                
ADDR_01EA37:        STA.W $009E,Y             
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
                    LDA.B #$D8                
                    STA $AA,X                 
                    JSR.W SubHorizPos         
                    LDA.W DATA_01EA17,Y       
                    STA $B6,X                 
                    LDA $9E,X                 
                    CMP.B #$21                
                    BNE ADDR_01EA6D           
                    LDA.B #$02                
                    STA.W $15F6,X             
ADDR_01EA6D:        TXY                       
                    PLX                       
ADDR_01EA6F:        RTS                       ; Return 

ADDR_01EA70:        LDX.W $18E2               
                    BEQ ADDR_01EA8E           
                    STZ.W $188B               
                    STZ.W $191C               
                    LDA.W $15E9               
                    PHA                       
                    DEX                       
                    STX.W $15E9               
                    PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_01EA8F         
                    PLB                       
                    PLA                       
                    STA.W $15E9               
ADDR_01EA8E:        RTL                       ; Return 

ADDR_01EA8F:        LDA.W $18E8               
                    ORA.W $13C6               
                    BEQ ADDR_01EA9A           
                    JMP.W ADDR_01EB48         
ADDR_01EA9A:        STZ.W $18DC               
                    LDA $C2,X                 
                    CMP.B #$02                
                    BCC ADDR_01EAA7           
                    LDA.B #$30                
                    BRA ADDR_01EAB2           
ADDR_01EAA7:        LDY.B #$00                
                    LDA $7B                   
                    BEQ ADDR_01EADF           
                    BPL ADDR_01EAB2           
                    EOR.B #$FF                
                    INC A                     
ADDR_01EAB2:        LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA $9D                   
                    BNE ADDR_01EAD0           
                    DEC.W $1570,X             
                    BPL ADDR_01EAD0           
                    LDA.W DATA_01EDF5,Y       
                    STA.W $1570,X             
                    DEC.W $18AD               
                    BPL ADDR_01EAD0           
                    LDA.B #$02                
                    STA.W $18AD               
ADDR_01EAD0:        LDY.W $18AD               
                    LDA.W DATA_01EDEE,Y       
                    TAY                       
                    LDA $C2,X                 
                    CMP.B #$02                
                    BCS ADDR_01EB2E           
                    BRA ADDR_01EAE2           
ADDR_01EADF:        STZ.W $1570,X             
ADDR_01EAE2:        LDA $72                   
                    BEQ ADDR_01EAF0           
                    LDY.B #$02                
                    LDA $7D                   
                    BPL ADDR_01EAF0           
                    LDY.B #$05                
                    BRA ADDR_01EAF0           
ADDR_01EAF0:        LDA.W $15AC,X             
                    BEQ ADDR_01EAF7           
                    LDY.B #$03                
ADDR_01EAF7:        LDA $72                   
                    BNE ADDR_01EB21           
                    LDA.W $151C,X             
                    BEQ ADDR_01EB0C           
                    LDY.B #$07                
                    LDA $15                   
                    AND.B #$08                
                    BEQ ADDR_01EB0A           
                    LDY.B #$06                
ADDR_01EB0A:        BRA ADDR_01EB21           
ADDR_01EB0C:        LDA.W $18AF               
                    BEQ ADDR_01EB16           
                    DEC.W $18AF               
                    BRA ADDR_01EB1C           
ADDR_01EB16:        LDA $15                   
                    AND.B #$04                
                    BEQ ADDR_01EB21           
ADDR_01EB1C:        LDY.B #$04                
                    INC.W $18DC               
ADDR_01EB21:        LDA $C2,X                 
                    CMP.B #$01                
                    BEQ ADDR_01EB2E           
                    LDA.W $151C,X             
                    BNE ADDR_01EB2E           
                    LDY.B #$04                
ADDR_01EB2E:        LDA.W $187A               
                    BEQ ADDR_01EB44           
                    LDA.W $1419               
                    CMP.B #$01                
                    BNE ADDR_01EB44           
                    LDA $13                   
                    AND.B #$08                
                    LSR                       
                    LSR                       
                    LSR                       
                    ADC.B #$08                
                    TAY                       
ADDR_01EB44:        TYA                       
                    STA.W $1602,X             
ADDR_01EB48:        LDA $C2,X                 
                    CMP.B #$01                
                    BNE ADDR_01EB97           
                    LDY.W $157C,X             
                    LDA $94                   
                    CLC                       
                    ADC.W DATA_01EDF1,Y       
                    STA $E4,X                 
                    LDA $95                   
                    ADC.W DATA_01EDF3,Y       
                    STA.W $14E0,X             
                    LDY.W $1602,X             
                    LDA $96                   
                    CLC                       
                    ADC.B #$10                
                    STA $D8,X                 
                    LDA $97                   
                    ADC.B #$00                
                    STA.W $14D4,X             
                    LDA.W DATA_01EDE4,Y       
                    STA.W $188B               
                    LDA.B #$01                
                    LDY.W $1602,X             
                    CPY.B #$03                
                    BNE ADDR_01EB82           
                    INC A                     
ADDR_01EB82:        STA.W $187A               
                    LDA.B #$01                
                    STA.W $0DC1               
                    LDA.W $15F6,X             
                    STA.W $13C7               
                    LDA.W $157C,X             
                    EOR.B #$01                
                    STA $76                   
ADDR_01EB97:        LDA $64                   
                    PHA                       
                    LDA.W $187A               
                    BEQ ADDR_01EBAD           
                    LDA.W $1419               
                    BEQ ADDR_01EBAD           
                    LDA.W $1405               
                    BNE ADDR_01EBB0           
                    LDA.B #$10                
                    STA $64                   
ADDR_01EBAD:        JSR.W ADDR_01EE61         
ADDR_01EBB0:        PLA                       
                    STA $64                   
                    RTS                       ; Return 


DATA_01EBB4:        .db $01,$FF,$01,$00,$FF,$00,$20,$E0
                    .db $0A,$0E

DATA_01EBBE:        .db $E8,$18

DATA_01EBC0:        .db $10,$F0

DATA_01EBC2:        .db $0C,$0B,$0C,$0B,$0A,$0B,$0A,$0B

ADDR_01EBCA:        STZ.W $13FB               
                    LDA.W $141E               
                    STA.W $1410               
                    STZ.W $141E               
                    STZ.W $18E7               
                    STZ.W $191B               
                    LDA.W $14C8,X             
                    CMP.B #$08                
                    BEQ ADDR_01EBE9           
                    STZ.W $0DC1               
                    JMP.W ADDR_01EE61         
ADDR_01EBE9:        TXA                       
                    INC A                     
                    STA.W $18DF               
                    LDA.W $187A               
                    BNE ADDR_01EC04           
                    JSR.W ADDR_01AC31         
                    LDA.W $14C8,X             
                    BNE ADDR_01EC04           
                    LDA.W $1B95               
                    BNE ADDR_01EC03           
                    STZ.W $0DC1               
ADDR_01EC03:        RTS                       ; Return 

ADDR_01EC04:        LDA.W $187A               
                    BEQ ADDR_01EC0E           
                    LDA.W $1419               
                    BNE ADDR_01EC61           
ADDR_01EC0E:        LDA.W $18DE               
                    BNE ADDR_01EC61           
                    LDA.W $18E8               
                    BEQ ADDR_01EC4C           
                    DEC.W $18E8               
                    STA $9D                   
                    STA.W $13FB               
                    CMP.B #$01                
                    BNE ADDR_01EC40           
                    STZ $9D                   
                    STZ.W $13FB               
                    LDY.W $0DB3               
                    LDA.W $1F11,Y             
                    DEC A                     
                    ORA.W $0EF8               
                    ORA.W $0109               
                    BNE ADDR_01EC40           
                    INC.W $0EF8               
                    LDA.B #$03                
                    STA.W $1426               
ADDR_01EC40:        DEC A                     
                    LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_01EBC2,Y       
                    STA.W $1602,X             
                    RTS                       ; Return 

ADDR_01EC4C:        LDA $9D                   
                    BEQ ADDR_01EC61           
ADDR_01EC50:        LDY.W $187A               
                    BEQ ADDR_01EC5A           
                    LDY.B #$06                
                    STY.W $188B               
ADDR_01EC5A:        RTS                       ; Return 


DATA_01EC5B:        .db $F0,$10

DATA_01EC5D:        .db $FA,$06

DATA_01EC5F:        .db $FF,$00

ADDR_01EC61:        LDA $72                   
                    BNE ADDR_01EC6A           
                    LDA.W $18DE               
                    BNE ADDR_01EC6D           
ADDR_01EC6A:        JMP.W ADDR_01ECE1         
ADDR_01EC6D:        DEC.W $18DE               
                    CMP.B #$01                
                    BNE ADDR_01EC78           
                    STZ $9D                   
                    BRA ADDR_01EC6A           
ADDR_01EC78:        INC.W $13FB               
                    JSR.W ADDR_01EC50         
                    STY $9D                   
                    CMP.B #$02                
                    BNE ADDR_01EC8A           
                    JSL.L ADDR_02A9E4         
                    BPL ADDR_01EC8B           
ADDR_01EC8A:        RTS                       ; Return 

ADDR_01EC8B:        LDA.B #$09                
                    STA.W $14C8,Y             
                    LDA.B #$2C                
                    STA.W $009E,Y             
                    PHY                       
                    PHY                       
                    LDY.W $157C,X             
                    STY $0F                   
                    LDA $E4,X                 
                    CLC                       
                    ADC.W DATA_01EC5D,Y       
                    PLY                       
                    STA.W $00E4,Y             
                    LDY.W $157C,X             
                    LDA.W $14E0,X             
                    ADC.W DATA_01EC5F,Y       
                    PLY                       
                    STA.W $14E0,Y             
                    LDA $D8,X                 
                    CLC                       
                    ADC.B #$08                
                    STA.W $00D8,Y             
                    LDA.W $14D4,X             
                    ADC.B #$00                
                    STA.W $14D4,Y             
                    PHX                       
                    TYX                       
                    JSL.L ADDR_07F7D2         
                    LDY $0F                   
                    LDA.W DATA_01EC5B,Y       
                    STA $B6,X                 
                    LDA.B #$F0                
                    STA $AA,X                 
                    LDA.B #$10                
                    STA.W $154C,X             
                    LDA.W $18DA               
                    STA.W $151C,X             
                    PLX                       
                    RTS                       ; Return 

ADDR_01ECE1:        LDA $C2,X                 
                    CMP.B #$01                
                    BNE ADDR_01ECEA           
                    JMP.W ADDR_01ED70         
ADDR_01ECEA:        JSR.W ADDR_019032         
                    JSR.W ADDR_01800E         
                    BEQ ADDR_01ED01           
                    JSR.W ADDR_019A04         
                    LDA $C2,X                 
                    CMP.B #$02                
                    BCS ADDR_01ED01           
                    STZ $B6,X                 
                    LDA.B #$F0                
                    STA $AA,X                 
ADDR_01ED01:        JSR.W ADDR_019A15         
                    JSR.W ADDR_018008         
                    BEQ ADDR_01ED0C           
                    JSR.W ADDR_0190A2         
ADDR_01ED0C:        LDA.B #$04                
                    CLC                       
                    ADC $E4,X                 
                    STA $04                   
                    LDA.W $14E0,X             
                    ADC.B #$00                
                    STA $0A                   
                    LDA.B #$13                
                    CLC                       
                    ADC $D8,X                 
                    STA $05                   
                    LDA.W $14D4,X             
                    ADC.B #$00                
                    STA $0B                   
                    LDA.B #$08                
                    STA $07                   
                    STA $06                   
                    JSL.L ADDR_03B664         
                    JSL.L ADDR_03B72B         
                    BCC ADDR_01ED70           
                    LDA $72                   
                    BEQ ADDR_01ED70           
                    LDA.W $1470               
                    ORA.W $187A               
                    BNE ADDR_01ED70           
                    LDA $7D                   
                    BMI ADDR_01ED70           
                    LDY.B #$01                
                    JSR.W ADDR_01EDCE         
                    STZ $7B                   
                    STZ $7D                   
                    LDA.B #$0C                
                    STA.W $18AF               
                    LDA.B #$01                
                    STA $C2,X                 
                    LDA.B #$02                
                    STA.W $1DFA               ; / Play sound effect 
                    LDA.B #$1F                
                    STA.W $1DFC               ; / Play sound effect 
                    JSL.L ADDR_028BB0         
                    LDA.B #$20                
                    STA.W $163E,X             
                    INC.W $1697               
ADDR_01ED70:        LDA $C2,X                 
                    CMP.B #$01                
                    BNE ADDR_01EDCB           
                    JSR.W ADDR_01F622         
                    LDA $15                   
                    AND.B #$03                
                    BEQ ADDR_01ED95           
                    DEC A                     
                    CMP.W $157C,X             
                    BEQ ADDR_01ED95           
                    LDA.W $15AC,X             
                    ORA.W $151C,X             
                    ORA.W $18DC               
                    BNE ADDR_01ED95           
                    LDA.B #$10                
                    STA.W $15AC,X             
ADDR_01ED95:        LDA.W $13F3               
                    BNE ADDR_01ED9E           
                    BIT $18                   
                    BPL ADDR_01EDCB           
ADDR_01ED9E:        LDA.B #$02                
                    STA.W $1FE2,X             
                    STZ $C2,X                 
                    LDA.B #$03                
                    STA.W $1DFA               ; / Play sound effect 
                    STZ.W $0DC1               
                    LDA $7B                   
                    STA $B6,X                 
                    LDA.B #$A0                
                    LDY $72                   
                    BNE ADDR_01EDC1           
                    JSR.W SubHorizPos         
                    LDA.W DATA_01EBC0,Y       
                    STA $7B                   
                    LDA.B #$C0                
ADDR_01EDC1:        STA $7D                   
                    STZ.W $187A               
                    STZ $AA,X                 
                    JSR.W ADDR_01EDCC         
ADDR_01EDCB:        RTS                       ; Return 

ADDR_01EDCC:        LDY.B #$00                
ADDR_01EDCE:        LDA $D8,X                 
                    SEC                       
                    SBC.W DATA_01EDE2,Y       
                    STA $96                   
                    STA $D3                   
                    LDA.W $14D4,X             
                    SBC.B #$00                
                    STA $97                   
                    STA $D4                   
                    RTS                       ; Return 


DATA_01EDE2:        .db $04,$10

DATA_01EDE4:        .db $06,$05,$05,$05,$0A,$05,$05,$0A
                    .db $0A,$0B

DATA_01EDEE:        .db $02,$01,$00

DATA_01EDF1:        .db $02,$FE

DATA_01EDF3:        .db $00,$FF

DATA_01EDF5:        .db $03,$02,$01,$00

DATA_01EDF9:        .db $00,$01,$02,$03,$02,$10,$04,$05
                    .db $00,$00,$FF,$FF,$00

DATA_01EE06:        .db $06,$07,$08,$09,$0A,$0B,$06,$0C
                    .db $0A,$0D,$0E,$0F,$0C

DATA_01EE13:        .db $0A,$09,$0A,$06,$0A,$0A,$0A,$10
                    .db $0A,$0A,$00,$00,$0A,$F6,$F7,$F6
                    .db $FA,$F6,$F6,$F6,$F0,$F6,$F6,$00
                    .db $00,$F6

DATA_01EE2D:        .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00
                    .db $00,$FF

DATA_01EE47:        .db $00,$01,$01,$00,$04,$00,$00,$04
                    .db $03,$03,$00,$00,$04

DATA_01EE54:        .db $00,$00,$01,$00,$00,$00,$00,$08
                    .db $00,$00,$00,$00,$05

ADDR_01EE61:        LDA.W $1602,X             
                    PHA                       
                    LDY.W $15AC,X             
                    CPY.B #$08                
                    BNE ADDR_01EE7D           
                    LDA.W $1419               
                    ORA $9D                   
                    BNE ADDR_01EE7D           
                    LDA.W $157C,X             
                    STA $76                   
                    EOR.B #$01                
                    STA.W $157C,X             
ADDR_01EE7D:        LDA.W $1419               
                    BMI ADDR_01EE8A           
                    CMP.B #$02                
                    BNE ADDR_01EE8A           
                    INC A                     
                    STA.W $1602,X             
ADDR_01EE8A:        JSR.W ADDR_01EF18         
                    LDY $0E                   
                    LDA.W $0302,Y             
                    STA $00                   
                    STZ $01                   
                    LDA.B #$06                
                    STA.W $0302,Y             
                    LDY.W $15EA,X             
                    LDA.W $0302,Y             
                    STA $02                   
                    STZ $03                   
                    LDA.B #$08                
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
                    LDA $02                   
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    CLC                       
                    ADC.W #$8500              
                    STA.W $0D8D               
                    CLC                       
                    ADC.W #$0200              
                    STA.W $0D97               
                    SEP #$20                  ; Accum (8 bit) 
                    PLA                       
                    STA.W $1602,X             
                    JSR.W ADDR_01F0A2         
                    LDA.W $1410               
                    CMP.B #$02                
                    BCC ADDR_01EF17           
                    LDA.W $187A               
                    BEQ ADDR_01EF13           
                    LDA $72                   
                    BNE ADDR_01EF00           
                    LDA $7B                   
                    BPL ADDR_01EEF6           
                    EOR.B #$FF                
                    INC A                     
ADDR_01EEF6:        CMP.B #$28                
                    LDA.B #$01                
                    BCS ADDR_01EF13           
                    LDA.B #$00                
                    BRA ADDR_01EF13           
ADDR_01EF00:        LDA $14                   
                    LSR                       
                    LSR                       
                    LDY $7D                   
                    BMI ADDR_01EF0A           
                    LSR                       
                    LSR                       
ADDR_01EF0A:        AND.B #$01                
                    BNE ADDR_01EF13           
                    LDY.B #$21                
                    STY.W $1DFC               ; / Play sound effect 
ADDR_01EF13:        JSL.L ADDR_02BB23         
ADDR_01EF17:        RTS                       ; Return 

ADDR_01EF18:        LDY.W $1602,X             
                    STY.W $185E               
                    LDA.W DATA_01EDF9,Y       
                    STA.W $1602,X             
                    STA $0F                   
                    LDA $D8,X                 
                    PHA                       
                    CLC                       
                    ADC.W DATA_01EE47,Y       
                    STA $D8,X                 
                    LDA.W $14D4,X             
                    PHA                       
                    ADC.B #$00                
                    STA.W $14D4,X             
                    TYA                       
                    LDY.W $157C,X             
                    BEQ ADDR_01EF41           
                    CLC                       
                    ADC.B #$0D                
ADDR_01EF41:        TAY                       
                    LDA $E4,X                 
                    PHA                       
                    CLC                       
                    ADC.W DATA_01EE13,Y       
                    STA $E4,X                 
                    LDA.W $14E0,X             
                    PHA                       
                    ADC.W DATA_01EE2D,Y       
                    STA.W $14E0,X             
                    LDA.W $15EA,X             
                    PHA                       
                    LDA.W $15AC,X             
                    ORA.W $1419               
                    BEQ ADDR_01EF66           
                    LDA.B #$04                
                    STA.W $15EA,X             
ADDR_01EF66:        LDA.W $15EA,X             
                    STA $0E                   
                    JSR.W ADDR_019F0D         
                    PHX                       
                    LDY.W $15EA,X             
                    LDX.W $185E               
                    LDA.W $0301,Y             
                    CLC                       
                    ADC.W DATA_01EE54,X       
                    STA.W $0301,Y             
                    PLX                       
                    PLA                       
                    CLC                       
                    ADC.B #$04                
                    STA.W $15EA,X             
                    PLA                       
                    STA.W $14E0,X             
                    PLA                       
                    STA $E4,X                 
                    LDY.W $185E               
                    LDA.W DATA_01EE06,Y       
                    STA.W $1602,X             
                    LDA $D8,X                 
                    CLC                       
                    ADC.B #$10                
                    STA $D8,X                 
                    BCC ADDR_01EFA3           
                    INC.W $14D4,X             
ADDR_01EFA3:        JSR.W ADDR_019F0D         
                    PLA                       
                    STA.W $14D4,X             
                    PLA                       
                    STA $D8,X                 
                    LDY $0E                   
                    LDA $0F                   
                    BPL ADDR_01EFB8           
                    LDA.B #$F0                
                    STA.W $0301,Y             
ADDR_01EFB8:        LDA $C2,X                 
                    BNE ADDR_01EFC6           
                    LDA $14                   
                    AND.B #$30                
                    BNE ADDR_01EFDB           
                    LDA.B #$2A                
                    BRA ADDR_01EFFA           
ADDR_01EFC6:        CMP.B #$02                
                    BNE ADDR_01EFDB           
                    LDA.W $151C,X             
                    ORA.W $13C6               
                    BNE ADDR_01EFDB           
                    LDA $14                   
                    AND.B #$10                
                    BEQ ADDR_01EFFD           
                    BRA ADDR_01EFF8           
ADDR_01EFDA:        RTS                       ; Return 

ADDR_01EFDB:        LDA.W $1594,X             
                    CMP.B #$03                
                    BEQ ADDR_01EFEE           
                    LDA.W $151C,X             
                    BEQ ADDR_01EFF3           
                    LDA.W $0302,Y             
                    CMP.B #$24                
                    BEQ ADDR_01EFF3           
ADDR_01EFEE:        LDA.B #$2A                
                    STA.W $0302,Y             
ADDR_01EFF3:        LDA.W $18AE               
                    BEQ ADDR_01EFFD           
ADDR_01EFF8:        LDA.B #$0C                
ADDR_01EFFA:        STA.W $0302,Y             
ADDR_01EFFD:        LDA.W $1564,X             
                    LDY.W $18AC               
                    BEQ ADDR_01F00F           
                    CPY.B #$26                
                    BCS ADDR_01F038           
                    LDA $14                   
                    AND.B #$18                
                    BNE ADDR_01F038           
ADDR_01F00F:        LDA.W $1564,X             
                    CMP.B #$00                
                    BEQ ADDR_01EFDA           
                    LDY.B #$00                
                    CMP.B #$0F                
                    BCC ADDR_01F03A           
                    CMP.B #$1C                
                    BCC ADDR_01F038           
                    BNE ADDR_01F02F           
                    LDA $0E                   
                    PHA                       
                    JSL.L ADDR_02D1F3         
                    JSR.W ADDR_01F0D3         
                    PLA                       
                    STA $0E                   
ADDR_01F02F:        INC.W $13FB               
                    LDA.B #$00                
                    LDY.B #$2A                
                    BRA ADDR_01F03A           
ADDR_01F038:        LDY.B #$04                
ADDR_01F03A:        PHA                       
                    TYA                       
                    LDY $0E                   
                    STA.W $0302,Y             
                    PLA                       
                    CMP.B #$0F                
                    BCS ADDR_01F0A0           
                    CMP.B #$05                
                    BCC ADDR_01F0A0           
                    SBC.B #$05                
                    LDY.W $157C,X             
                    BEQ ADDR_01F054           
                    CLC                       
                    ADC.B #$0A                
ADDR_01F054:        LDY.W $1602,X             
                    CPY.B #$0A                
                    BNE ADDR_01F05E           
                    CLC                       
                    ADC.B #$14                
ADDR_01F05E:        STA $02                   
                    JSR.W IsSprOffscreen      
                    BNE ADDR_01F0A0           
                    LDA $E4,X                 
                    SEC                       
                    SBC $1A                   
                    STA $00                   
                    LDA $D8,X                 
                    SEC                       
                    SBC $1C                   
                    STA $01                   
                    PHX                       
                    LDX $02                   
                    LDA $00                   
                    CLC                       
                    ADC.L DATA_03C176,X       
                    STA.W $0300               
                    LDA $01                   
                    CLC                       
                    ADC.L DATA_03C19E,X       
                    STA.W $0301               
                    LDA.B #$3F                
                    STA.W $0302               
                    PLX                       
                    LDY.W $15EA,X             
                    LDA.W $0303,Y             
                    ORA.B #$01                
                    STA.W $0303               
                    LDA.B #$00                
                    STA.W $0460               
ADDR_01F0A0:        RTS                       ; Return 

ADDR_01F0A1:        RTS                       ; Return 

ADDR_01F0A2:        LDA $C2,X                 
                    CMP.B #$01                
                    BNE ADDR_01F0AC           
                    JSL.L ADDR_02D0D4         
ADDR_01F0AC:        LDA.W $1410               
                    CMP.B #$01                
                    BEQ ADDR_01F0A1           
                    LDA.W $14A3               
                    CMP.B #$10                
                    BNE ADDR_01F0C4           
                    LDA.W $18AE               
                    BNE ADDR_01F0C4           
                    LDA.B #$06                
                    STA.W $18AE               
ADDR_01F0C4:        LDA.W $1594,X             
                    JSL.L ExecutePtr          

Ptrs01F0CB:         .dw ADDR_01F14B           
                    .dw ADDR_01F314           
                    .dw ADDR_01F332           
                    .dw ADDR_01F12E           

ADDR_01F0D3:        LDA.B #$06                
                    STA.W $1DF9               ; / Play sound effect 
                    JSL.L ADDR_05B34A         
                    LDA.W $18D6               
                    BEQ ADDR_01F12D           
                    STZ.W $18D6               
                    CMP.B #$01                
                    BNE ADDR_01F0F9           
                    INC.W $18D4               
                    LDA.W $18D4               
                    CMP.B #$0A                
                    BNE ADDR_01F12D           
                    STZ.W $18D4               
                    LDA.B #$74                
                    BRA ADDR_01F125           
ADDR_01F0F9:        CMP.B #$03                
                    BNE ADDR_01F116           
                    LDA.B #$29                
                    STA.W $1DFC               ; / Play sound effect 
                    LDA.W $0F32               
                    CLC                       
                    ADC.B #$02                
                    CMP.B #$0A                
                    BCC ADDR_01F111           
                    SBC.B #$0A                
                    INC.W $0F31               
ADDR_01F111:        STA.W $0F32               
                    BRA ADDR_01F12D           
ADDR_01F116:        INC.W $18D5               
                    LDA.W $18D5               
                    CMP.B #$02                
                    BNE ADDR_01F12D           
                    STZ.W $18D5               
                    LDA.B #$6A                
ADDR_01F125:        STA.W $18DA               
                    LDY.B #$20                
                    STY.W $18DE               
ADDR_01F12D:        RTS                       ; Return 

ADDR_01F12E:        LDA.W $1558,X             
                    BNE ADDR_01F136           
                    STZ.W $1594,X             
ADDR_01F136:        RTS                       ; Return 


DATA_01F137:        .db $00,$00,$01,$02,$00,$00,$01,$02
                    .db $01,$01,$01,$03,$02,$02

DATA_01F145:        .db $03,$02,$02,$03,$01,$00

ADDR_01F14B:        LDA.W $1B95               
                    BEQ ADDR_01F155           
                    LDA.B #$02                
                    STA.W $141E               
ADDR_01F155:        LDA.W $18AC               
                    BEQ ADDR_01F1A2           
                    LDY.W $160E,X             
                    LDA.W $009E,Y             
                    CMP.B #$80                
                    BNE ADDR_01F167           
                    INC.W $191C               
ADDR_01F167:        CMP.B #$0D                
                    BCS ADDR_01F1A2           
                    PHY                       
                    LDA.W $187B,Y             
                    CMP.B #$01                
                    LDA.B #$03                
                    BCS ADDR_01F195           
                    LDA.W $15F6,X             
                    LSR                       
                    AND.B #$07                
                    TAY                       
                    LDA.W DATA_01F145,Y       
                    ASL                       
                    ASL                       
                    STA $00                   
                    PLY                       
                    PHY                       
                    LDA.W $15F6,Y             
                    LSR                       
                    AND.B #$07                
                    TAY                       
                    LDA.W DATA_01F145,Y       
                    ORA $00                   
                    TAY                       
                    LDA.W DATA_01F137,Y       
ADDR_01F195:        PHA                       
                    AND.B #$02                
                    STA.W $141E               
                    PLA                       
                    AND.B #$01                
                    STA.W $18E7               
                    PLY                       
ADDR_01F1A2:        LDA $14                   
                    AND.B #$03                
                    BNE ADDR_01F1C6           
                    LDA.W $18AC               
                    BEQ ADDR_01F1C6           
                    DEC.W $18AC               
                    BNE ADDR_01F1C6           
                    LDY.W $160E,X             
                    LDA.B #$00                
                    STA.W $14C8,Y             
                    DEC A                     
                    STA.W $160E,X             
                    LDA.B #$1B                
                    STA.W $1564,X             
                    JMP.W ADDR_01F0D3         
ADDR_01F1C6:        LDA.W $18AE               
                    BEQ ADDR_01F1DF           
                    DEC.W $18AE               
                    BNE ADDR_01F1DE           
                    INC.W $1594,X             
                    STZ.W $151C,X             
                    LDA.B #$FF                
                    STA.W $160E,X             
                    STZ.W $1564,X             
ADDR_01F1DE:        RTS                       ; Return 

ADDR_01F1DF:        LDA $C2,X                 
                    CMP.B #$01                
                    BNE ADDR_01F1DE           
                    BIT $16                   
                    BVC ADDR_01F1DE           
                    LDA.W $18AC               
                    BNE ADDR_01F1F1           
                    JMP.W ADDR_01F309         
ADDR_01F1F1:        STZ.W $18AC               
                    LDY.W $160E,X             
                    PHY                       
                    PHY                       
                    LDY.W $157C,X             
                    LDA $E4,X                 
                    CLC                       
                    ADC.W DATA_01F305,Y       
                    PLY                       
                    STA.W $00E4,Y             
                    LDY.W $157C,X             
                    LDA.W $14E0,X             
                    ADC.W DATA_01F307,Y       
                    PLY                       
                    STA.W $14E0,Y             
                    LDA $D8,X                 
                    STA.W $00D8,Y             
                    LDA.W $14D4,X             
                    STA.W $14D4,Y             
                    LDA.B #$00                
                    STA.W $00C2,Y             
                    STA.W $15D0,Y             
                    STA.W $1626,Y             
                    LDA.W $18DC               
                    CMP.B #$01                
                    LDA.B #$0A                
                    BCC ADDR_01F234           
                    LDA.B #$09                
ADDR_01F234:        STA.W $14C8,Y             
                    PHX                       
                    LDA.W $157C,X             
                    STA.W $157C,Y             
                    TAX                       
                    BCC ADDR_01F243           
                    INX                       
                    INX                       
ADDR_01F243:        LDA.W DATA_01F301,X       
                    STA.W $00B6,Y             
                    LDA.B #$00                
                    STA.W $00AA,Y             
                    PLX                       
                    LDA.B #$10                
                    STA.W $1558,X             
                    LDA.B #$03                
                    STA.W $1594,X             
                    LDA.B #$FF                
                    STA.W $160E,X             
                    LDA.W $009E,Y             
                    CMP.B #$0D                
                    BCS ADDR_01F2DF           
                    LDA.W $187B,Y             
                    BNE ADDR_01F27C           
                    LDA.W $15F6,Y             
                    AND.B #$0E                
                    CMP.B #$08                
                    BEQ ADDR_01F27C           
                    LDA.W $15F6,X             
                    AND.B #$0E                
                    CMP.B #$08                
                    BNE ADDR_01F2DF           
ADDR_01F27C:        PHX                       
                    TYX                       
                    STZ.W $14C8,X             
                    LDA.B #$02                
                    STA $00                   
                    JSR.W ADDR_01F295         
                    JSR.W ADDR_01F295         
                    JSR.W ADDR_01F295         
                    PLX                       
                    LDA.B #$17                
                    STA.W $1DFC               ; / Play sound effect 
                    RTS                       ; Return 

ADDR_01F295:        JSR.W ADDR_018EEF         
                    LDA.B #$11                
                    STA.W $170B,Y             
                    LDA $E4,X                 
                    STA.W $171F,Y             
                    LDA.W $14E0,X             
                    STA.W $1733,Y             
                    LDA $D8,X                 
                    STA.W $1715,Y             
                    LDA.W $14D4,X             
                    STA.W $1729,Y             
                    LDA.B #$00                
                    STA.W $1779,Y             
                    PHX                       
                    LDA.W $157C,X             
                    LSR                       
                    LDX $00                   
                    LDA.W DATA_01F2D9,X       
                    BCC ADDR_01F2C7           
                    EOR.B #$FF                
                    INC A                     
ADDR_01F2C7:        STA.W $1747,Y             
                    LDA.W DATA_01F2DC,X       
                    STA.W $173D,Y             
                    LDA.B #$A0                
                    STA.W $176F,Y             
                    PLX                       
                    DEC $00                   
                    RTS                       ; Return 


DATA_01F2D9:        .db $28,$24,$24

DATA_01F2DC:        .db $00,$F8,$08

ADDR_01F2DF:        LDA.B #$20                
                    STA.W $1DF9               ; / Play sound effect 
                    LDA.W $1686,Y             
                    AND.B #$40                
                    BEQ ADDR_01F2FE           
                    PHX                       
                    LDX.W $009E,Y             
                    LDA.L DATA_01A7C9,X       
                    PLX                       
                    STA.W $009E,Y             
                    PHX                       
                    TYX                       
                    JSL.L ADDR_07F78B         
                    PLX                       
ADDR_01F2FE:        RTS                       ; Return 


DATA_01F2FF:        .db $20,$E0

DATA_01F301:        .db $30,$D0,$10,$F0

DATA_01F305:        .db $10,$F0

DATA_01F307:        .db $00,$FF

ADDR_01F309:        LDA.B #$12                
                    STA.W $14A3               
                    LDA.B #$21                
                    STA.W $1DFC               ; / Play sound effect 
                    RTS                       ; Return 

ADDR_01F314:        LDA.W $151C,X             
                    CLC                       
                    ADC.B #$03                
                    STA.W $151C,X             
                    CMP.B #$20                
                    BCS ADDR_01F328           
ADDR_01F321:        JSR.W ADDR_01F3FE         
                    JSR.W ADDR_01F4B2         
                    RTS                       ; Return 

ADDR_01F328:        LDA.B #$08                
                    STA.W $1558,X             
                    INC.W $1594,X             
                    BRA ADDR_01F321           
ADDR_01F332:        LDA.W $1558,X             
                    BNE ADDR_01F321           
                    LDA.W $151C,X             
                    SEC                       
                    SBC.B #$04                
                    BMI ADDR_01F344           
                    STA.W $151C,X             
                    BRA ADDR_01F321           
ADDR_01F344:        STZ.W $151C,X             
                    STZ.W $1594,X             
                    LDY.W $160E,X             
                    BMI ADDR_01F370           
                    LDA.W $1686,Y             
                    AND.B #$02                
                    BEQ ADDR_01F373           
                    LDA.B #$07                
                    STA.W $14C8,Y             
                    LDA.B #$FF                
                    STA.W $18AC               
                    LDA.W $009E,Y             
                    CMP.B #$0D                
                    BCS ADDR_01F370           
                    PHX                       
                    TAX                       
                    LDA.W DATA_01A7C9,X       
                    STA.W $009E,Y             
                    PLX                       
ADDR_01F370:        JMP.W ADDR_01F3FA         
ADDR_01F373:        LDA.B #$00                
                    STA.W $14C8,Y             
                    LDA.B #$1B                
                    STA.W $1564,X             
                    LDA.B #$FF                
                    STA.W $160E,X             
                    STY $00                   
                    LDA.W $009E,Y             
                    CMP.B #$9D                
                    BNE ADDR_01F39F           
                    LDA.W $00C2,Y             
                    CMP.B #$03                
                    BNE ADDR_01F39F           
                    LDA.B #$74                
                    STA.W $009E,Y             
                    LDA.W $167A,Y             
                    ORA.B #$40                
                    STA.W $167A,Y             
ADDR_01F39F:        LDA.W $009E,Y             
                    CMP.B #$81                
                    BNE ADDR_01F3BA           
                    LDA.W $187B,Y             
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.B #$03                
                    TAY                       
                    LDA.W DATA_01C313,Y       
                    LDY $00                   
                    STA.W $009E,Y             
ADDR_01F3BA:        PHA                       
                    LDY $00                   
                    LDA.W $167A,Y             
                    ASL                       
                    ASL                       
                    PLA                       
                    BCC ADDR_01F3DB           
                    PHX                       
                    TYX                       
                    STZ $C2,X                 
                    JSR.W ADDR_01C4BF         
                    PLX                       
                    LDY.W $18DC               
                    LDA.W DATA_01F3D9,Y       
                    STA.W $1602,X             
                    JMP.W ADDR_01F321         

DATA_01F3D9:        .db $00,$04

ADDR_01F3DB:        CMP.B #$7E                
                    BNE ADDR_01F3F7           
                    LDA.W $00C2,Y             
                    BEQ ADDR_01F3F7           
                    CMP.B #$02                
                    BNE ADDR_01F3F1           
                    LDA.B #$08                
                    STA $71                   
                    LDA.B #$03                
                    STA.W $1DFC               ; / Play sound effect 
ADDR_01F3F1:        JSR.W ADDR_01F6CD         
                    JMP.W ADDR_01F321         
ADDR_01F3F7:        JSR.W ADDR_01F0D3         
ADDR_01F3FA:        JMP.W ADDR_01F321         
ADDR_01F3FD:        RTS                       ; Return 

ADDR_01F3FE:        LDA.W $15A0,X             
                    ORA.W $186C,X             
                    ORA.W $1419               
                    BNE ADDR_01F3FD           
                    LDY.W $1602,X             
                    LDA.W DATA_01F61A,Y       
                    STA.W $185E               
                    CLC                       
                    ADC $D8,X                 
                    SEC                       
                    SBC $1C                   
                    STA $01                   
                    LDA.W $157C,X             
                    BNE ADDR_01F424           
                    TYA                       
                    CLC                       
                    ADC.B #$08                
                    TAY                       
ADDR_01F424:        LDA.W DATA_01F60A,Y       
                    STA $0D                   
                    LDA $E4,X                 
                    SEC                       
                    SBC $1A                   
                    CLC                       
                    ADC $0D                   
                    STA $00                   
                    LDA.W $157C,X             
                    BNE ADDR_01F43C           
                    BCS ADDR_01F3FD           
                    BRA ADDR_01F43E           
ADDR_01F43C:        BCC ADDR_01F3FD           
ADDR_01F43E:        LDA.W $151C,X             
                    STA.W $4205               ; Dividend (High-Byte)
                    STZ.W $4204               ; Dividend (Low Byte)
                    LDA.B #$04                
                    STA.W $4206               ; Divisor B
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    LDA.W $157C,X             
                    STA $07                   
                    LSR                       
                    LDA.W $4215               ; Quotient of Divide Result (High Byte)
                    BCC ADDR_01F462           
                    EOR.B #$FF                
                    INC A                     
ADDR_01F462:        STA $05                   
                    LDA.B #$04                
                    STA $06                   
                    LDY.B #$0C                
ADDR_01F46A:        LDA $00                   
                    STA.W $0200,Y             
                    CLC                       
                    ADC $05                   
                    STA $00                   
                    LDA $05                   
                    BPL ADDR_01F47C           
                    BCC ADDR_01F4B1           
                    BRA ADDR_01F47E           
ADDR_01F47C:        BCS ADDR_01F4B1           
ADDR_01F47E:        LDA $01                   
                    STA.W $0201,Y             
                    LDA $06                   
                    CMP.B #$01                
                    LDA.B #$76                
                    BCS ADDR_01F48D           
                    LDA.B #$66                
ADDR_01F48D:        STA.W $0202,Y             
                    LDA $07                   
                    LSR                       
                    LDA.B #$09                
                    BCS ADDR_01F499           
                    ORA.B #$40                
ADDR_01F499:        ORA $64                   
                    STA.W $0203,Y             
                    PHY                       
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$00                
                    STA.W $0420,Y             
                    PLY                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEC $06                   
                    BPL ADDR_01F46A           
ADDR_01F4B1:        RTS                       ; Return 

ADDR_01F4B2:        LDA.W $160E,X             
                    BMI ADDR_01F524           
                    LDY.B #$00                
                    LDA $0D                   
                    BMI ADDR_01F4C3           
                    CLC                       
                    ADC.W $151C,X             
                    BRA ADDR_01F4CC           
ADDR_01F4C3:        LDA.W $151C,X             
                    EOR.B #$FF                
                    INC A                     
                    CLC                       
                    ADC $0D                   
ADDR_01F4CC:        SEC                       
                    SBC.B #$04                
                    BPL ADDR_01F4D2           
                    DEY                       
ADDR_01F4D2:        PHY                       
                    CLC                       
                    ADC $E4,X                 
                    LDY.W $160E,X             
                    STA.W $00E4,Y             
                    PLY                       
                    TYA                       
                    ADC.W $14E0,X             
                    LDY.W $160E,X             
                    STA.W $14E0,Y             
                    LDA.B #$FC                
                    STA $00                   
                    LDA.W $1662,Y             
                    AND.B #$40                
                    BNE ADDR_01F4FD           
                    LDA.W $190F,Y             
                    AND.B #$20                
                    BEQ ADDR_01F4FD           
                    LDA.B #$F8                
                    STA $00                   
ADDR_01F4FD:        STZ $01                   
                    LDA $00                   
                    CLC                       
                    ADC.W $185E               
                    BPL ADDR_01F509           
                    DEC $01                   
ADDR_01F509:        CLC                       
                    ADC $D8,X                 
                    STA.W $00D8,Y             
                    LDA.W $14D4,X             
                    ADC $01                   
                    STA.W $14D4,Y             
                    LDA.B #$00                
                    STA.W $00AA,Y             
                    STA.W $00B6,Y             
                    INC A                     
                    STA.W $15D0,Y             
                    RTS                       ; Return 

ADDR_01F524:        PHY                       
                    LDY.B #$00                
                    LDA $0D                   
                    BMI ADDR_01F531           
                    CLC                       
                    ADC.W $151C,X             
                    BRA ADDR_01F53A           
ADDR_01F531:        LDA.W $151C,X             
                    EOR.B #$FF                
                    INC A                     
                    CLC                       
                    ADC $0D                   
ADDR_01F53A:        CLC                       
                    ADC.B #$00                
                    BPL ADDR_01F540           
                    DEY                       
ADDR_01F540:        CLC                       
                    ADC $E4,X                 
                    STA $00                   
                    TYA                       
                    ADC.W $14E0,X             
                    STA $08                   
                    PLY                       
                    LDA.W $185E               
                    CLC                       
                    ADC.B #$02                
                    CLC                       
                    ADC $D8,X                 
                    STA $01                   
                    LDA.W $14D4,X             
                    ADC.B #$00                
                    STA $09                   
                    LDA.B #$08                
                    STA $02                   
                    LDA.B #$04                
                    STA $03                   
                    LDY.B #$0B                
ADDR_01F568:        STY.W $1695               
                    CPY.W $15E9               
                    BEQ ADDR_01F586           
                    LDA.W $160E,X             
                    BPL ADDR_01F586           
                    LDA.W $14C8,Y             
                    CMP.B #$08                
                    BCC ADDR_01F586           
                    LDA.W $1632,Y             
                    BNE ADDR_01F586           
                    PHY                       
                    JSR.W ADDR_01F58E         
                    PLY                       
ADDR_01F586:        DEY                       
                    BPL ADDR_01F568           
                    JSL.L ADDR_02B9FA         
                    RTS                       ; Return 

ADDR_01F58E:        PHX                       
                    TYX                       
                    JSL.L ADDR_03B69F         
                    PLX                       
                    JSL.L ADDR_03B72B         
                    BCC ADDR_01F609           
                    LDA.W $1686,Y             
                    LSR                       
                    BCC ADDR_01F5A7           
                    LDA.B #$01                
                    STA.W $1DF9               ; / Play sound effect 
                    RTS                       ; Return 

ADDR_01F5A7:        LDA.W $009E,Y             
                    CMP.B #$70                
                    BNE ADDR_01F5FB           
                    STY.W $185E               
                    LDA $01                   
                    SEC                       
                    SBC.W $00D8,Y             
                    CLC                       
                    ADC.B #$00                
                    PHX                       
                    TYX                       
                    JSL.L ADDR_02B81C         
                    PLX                       
                    JSL.L ADDR_02A9E4         
                    BMI ADDR_01F609           
                    LDA.B #$08                
                    STA.W $14C8,Y             
                    LDA.B #$70                
                    STA.W $009E,Y             
                    LDA $00                   
                    STA.W $00E4,Y             
                    LDA $08                   
                    STA.W $14E0,Y             
                    LDA $01                   
                    STA.W $00D8,Y             
                    LDA $09                   
                    STA.W $14D4,Y             
                    PHX                       
                    TYX                       
                    JSL.L ADDR_07F7D2         
                    LDX.W $185E               
                    LDA $C2,X                 
                    AND $0D                   
                    STA.W $00C2,Y             
                    LDA.B #$01                
                    STA.W $1534,Y             
                    PLX                       
ADDR_01F5FB:        TYA                       
                    STA.W $160E,X             
                    LDA.B #$02                
                    STA.W $1594,X             
                    LDA.B #$0A                
                    STA.W $1558,X             
ADDR_01F609:        RTS                       ; Return 


DATA_01F60A:        .db $F5,$F5,$F5,$F5,$F5,$F5,$F5,$F0
                    .db $13,$13,$13,$13,$13,$13,$13,$18
DATA_01F61A:        .db $08,$08,$08,$08,$08,$08,$08,$13

ADDR_01F622:        LDA.W $163E,X             
                    ORA $9D                   
                    BNE ADDR_01F667           
                    LDY.B #$0B                
ADDR_01F62B:        STY.W $1695               
                    TYA                       
                    EOR $13                   
                    AND.B #$01                
                    BNE ADDR_01F661           
                    TYA                       
                    CMP.W $160E,X             
                    BEQ ADDR_01F661           
                    CPY.W $15E9               
                    BEQ ADDR_01F661           
                    LDA.W $14C8,Y             
                    CMP.B #$08                
                    BCC ADDR_01F661           
                    LDA.W $009E,Y             
                    LDA.W $14C8,Y             
                    CMP.B #$09                
                    BEQ ADDR_01F661           
                    LDA.W $167A,Y             
                    AND.B #$02                
                    ORA.W $15D0,Y             
                    ORA.W $1632,Y             
                    BNE ADDR_01F661           
                    JSR.W ADDR_01F668         
ADDR_01F661:        LDY.W $1695               
                    DEY                       
                    BPL ADDR_01F62B           
ADDR_01F667:        RTS                       ; Return 

ADDR_01F668:        PHX                       
                    TYX                       
                    JSL.L ADDR_03B6E5         
                    PLX                       
                    JSL.L ADDR_03B69F         
                    JSL.L ADDR_03B72B         
                    BCC ADDR_01F667           
                    LDA.W $009E,Y             
                    CMP.B #$9D                
                    BEQ ADDR_01F667           
                    CMP.B #$15                
                    BEQ ADDR_01F69E           
                    CMP.B #$16                
                    BEQ ADDR_01F69E           
                    CMP.B #$04                
                    BCS ADDR_01F6A3           
                    CMP.B #$02                
                    BEQ ADDR_01F6A3           
                    LDA.W $163E,Y             
                    BPL ADDR_01F6A3           
ADDR_01F695:        PHY                       
                    PHX                       
                    TYX                       
                    JSR.W ADDR_01B12A         
                    PLX                       
                    PLY                       
                    RTS                       ; Return 

ADDR_01F69E:        LDA.W $164A,Y             
                    BEQ ADDR_01F695           
ADDR_01F6A3:        LDA.W $009E,Y             
                    CMP.B #$BF                
                    BNE ADDR_01F6B4           
                    LDA $96                   
                    SEC                       
                    SBC.W $00D8,Y             
                    CMP.B #$E8                
                    BMI ADDR_01F6DC           
ADDR_01F6B4:        LDA.W $009E,Y             
                    CMP.B #$7E                
                    BNE ADDR_01F6DD           
                    LDA.W $00C2,Y             
                    BEQ ADDR_01F6DC           
                    CMP.B #$02                
                    BNE ADDR_01F6CD           
                    LDA.B #$08                
                    STA $71                   
                    LDA.B #$03                
                    STA.W $1DFC               ; / Play sound effect 
ADDR_01F6CD:        LDA.B #$40                
                    STA.W $14AA               
                    LDA.B #$02                
                    STA.W $141E               
                    LDA.B #$00                
                    STA.W $14C8,Y             
ADDR_01F6DC:        RTS                       ; Return 

ADDR_01F6DD:        CMP.B #$4E                
                    BEQ ADDR_01F6E5           
                    CMP.B #$4D                
                    BNE ADDR_01F6EC           
ADDR_01F6E5:        LDA.W $00C2,Y             
                    CMP.B #$02                
                    BCC ADDR_01F6DC           
ADDR_01F6EC:        LDA $05                   
                    CLC                       
                    ADC.B #$0D                
                    CMP $01                   
                    BMI ADDR_01F74B           
                    LDA.W $14C8,Y             
                    CMP.B #$0A                
                    BNE ADDR_01F70E           
                    PHX                       
                    TYX                       
                    JSR.W SubHorizPos         
                    STY $00                   
                    LDA $B6,X                 
                    PLX                       
                    ASL                       
                    ROL                       
                    AND.B #$01                
                    CMP $00                   
                    BNE ADDR_01F74B           
ADDR_01F70E:        LDA.W $1490               
                    BNE ADDR_01F74B           
                    LDA.B #$10                
                    STA.W $163E,X             
                    LDA.B #$03                
                    STA.W $1DFA               ; / Play sound effect 
                    LDA.B #$13                
                    STA.W $1DFC               ; / Play sound effect 
                    LDA.B #$02                
                    STA $C2,X                 
                    STZ.W $187A               
                    LDA.B #$C0                
                    STA $7D                   
                    STZ $7B                   
                    JSR.W SubHorizPos         
                    LDA.W DATA_01EBBE,Y       
                    STA $B6,X                 
                    STZ.W $1594,X             
                    STZ.W $151C,X             
                    STZ.W $18AE               
                    STZ.W $0DC1               
                    LDA.B #$30                
                    STA.W $1497               
                    JSR.W ADDR_01EDCC         
ADDR_01F74B:        RTS                       ; Return 

ADDR_01F74C:        LDA.B #$08                
                    STA.W $14C8,X             
ADDR_01F751:        LDA.B #$20                
                    STA.W $1540,X             
                    LDA.B #$0A                
                    STA.W $1DFC               ; / Play sound effect 
                    RTL                       ; Return 


DATA_01F75C:        .db $00,$01,$01,$01

DATA_01F760:        .db $62,$02,$02,$00

ADDR_01F764:        LDA.W $187B,X             
                    BEQ ADDR_01F799           
                    JSR.W IsSprOffscreen      
                    BNE ADDR_01F78D           
                    JSR.W SubHorizPos         
                    LDA $0F                   
                    CLC                       
                    ADC.B #$20                
                    CMP.B #$40                
                    BCS ADDR_01F78D           
                    STZ.W $187B,X             
                    JSL.L ADDR_01F751         
                    LDA.B #$2D                
                    LDY.W $18E2               
                    BEQ ADDR_01F78A           
                    LDA.B #$78                
ADDR_01F78A:        STA.W $151C,X             
ADDR_01F78D:        JSR.W ADDR_019F0D         
                    LDY.W $15EA,X             
                    LDA.B #$00                
                    STA.W $0302,Y             
                    RTS                       ; Return 

ADDR_01F799:        LDA.W $1540,X             
                    BEQ ADDR_01F7C2           
                    LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_01F760,Y       
                    PHA                       
                    LDA.W DATA_01F75C,Y       
                    PHA                       
                    JSR.W ADDR_019F0D         
                    LDY.W $15EA,X             
                    PLA                       
                    STA $00                   
                    LDA.W $0303,Y             
                    AND.B #$FE                
                    ORA $00                   
                    STA.W $0303,Y             
                    PLA                       
                    STA.W $0302,Y             
                    RTS                       ; Return 

ADDR_01F7C2:        JSR.W ADDR_01F7C8         
                    JMP.W ADDR_01F83D         
ADDR_01F7C8:        JSR.W IsSprOffscreen      
                    BNE ADDR_01F82C           
                    LDA $E4,X                 
                    STA $00                   
                    LDA $D8,X                 
                    STA $02                   
                    LDA.W $14D4,X             
                    STA $03                   
                    PHX                       
                    LDY.B #$03                
                    LDX.B #$0B                
ADDR_01F7DF:        LDA.W $17F0,X             
                    BEQ ADDR_01F7F4           
ADDR_01F7E4:        DEX                       
                    BPL ADDR_01F7DF           
                    DEC.W $185D               
                    BPL ADDR_01F7F1           
                    LDA.B #$0B                
                    STA.W $185D               
ADDR_01F7F1:        LDX.W $185D               
ADDR_01F7F4:        LDA.B #$03                
                    STA.W $17F0,X             
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_01F831,Y       
                    STA.W $1808,X             
                    LDA $02                   
                    CLC                       
                    ADC.W DATA_01F82D,Y       
                    STA.W $17FC,X             
                    LDA $03                   
                    STA.W $1814,X             
                    LDA.W DATA_01F835,Y       
                    STA.W $1820,X             
                    LDA.W DATA_01F839,Y       
                    STA.W $182C,X             
                    TYA                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ORA.B #$28                
                    STA.W $1850,X             
                    DEY                       
                    BPL ADDR_01F7E4           
                    PLX                       
ADDR_01F82C:        RTS                       ; Return 


DATA_01F82D:        .db $00,$00,$08,$08

DATA_01F831:        .db $00,$08,$00,$08

DATA_01F835:        .db $E8,$E8,$F4,$F4

DATA_01F839:        .db $FA,$06,$FD,$03

ADDR_01F83D:        LDA.W $151C,X             
                    STA $9E,X                 
                    CMP.B #$35                
                    BEQ ADDR_01F86C           
                    CMP.B #$2D                
                    BNE ADDR_01F867           
                    LDA.B #$09                
                    STA.W $14C8,X             
                    LDA.W $15F6,X             
                    AND.B #$0E                
                    PHA                       
                    JSL.L ADDR_07F7D2         
                    PLA                       
                    STA $00                   
                    LDA.W $15F6,X             
                    AND.B #$F1                
                    ORA $00                   
                    STA.W $15F6,X             
                    RTS                       ; Return 

ADDR_01F867:        JSL.L ADDR_07F7D2         
                    RTS                       ; Return 

ADDR_01F86C:        JSL.L ADDR_07F7D2         
                    JMP.W ADDR_01A2B5         

DATA_01F873:        .db $08,$F8

ADDR_01F875:        JSR.W FaceMario           
                    STA.W $1534,X             
ADDR_01F87B:        RTS                       ; Return 

ADDR_01F87C:        JSR.W SubHorizPos         
                    LDA.W DATA_01F88C,Y       
                    STA $B6,X                 
ADDR_01F884:        JSL.L ADDR_01ACF9         
                    STA.W $1570,X             
                    RTS                       ; Return 


DATA_01F88C:        .db $10,$F0

DATA_01F88E:        .db $18,$E8

ADDR_01F890:        LDA.W $14C8,X             
                    CMP.B #$08                
                    BNE ADDR_01F8C9           
                    LDA $9D                   
                    BNE ADDR_01F8C9           
                    JSR.W ADDR_01ABCC         
                    LDA $9E,X                 
                    CMP.B #$39                
                    BNE ADDR_01F8C0           
                    LDA $C2,X                 
                    AND.B #$01                
                    TAY                       
                    LDA $AA,X                 
                    CLC                       
                    ADC.W DATA_01EBB4,Y       
                    STA $AA,X                 
                    CMP.W DATA_01F88E,Y       
                    BNE ADDR_01F8B8           
                    INC $C2,X                 
ADDR_01F8B8:        JSR.W ADDR_01ABD8         
                    JSR.W ADDR_01AC21         
                    BRA ADDR_01F8C3           
ADDR_01F8C0:        JSR.W ADDR_01AC31         
ADDR_01F8C3:        JSR.W ADDR_01A7E4         
                    JSR.W ADDR_018E5F         
ADDR_01F8C9:        JSR.W ADDR_019A15         
                    JMP.W ADDR_019F0D         

DATA_01F8CF:        .db $08,$F8

DATA_01F8D1:        .db $01,$02,$02,$01

ADDR_01F8D5:        JSR.W ADDR_01AC2B         
                    LDA.B #$20                
                    BRA ADDR_01F8E1           
ADDR_01F8DC:        JSR.W ADDR_01AC31         
                    LDA.B #$10                
ADDR_01F8E1:        STA.W $18B6               
                    LDA.W $14C8,X             
                    CMP.B #$08                
                    BNE ADDR_01F8EF           
                    LDA $9D                   
                    BEQ ADDR_01F8F2           
ADDR_01F8EF:        JMP.W ADDR_01F9CE         
ADDR_01F8F2:        JSR.W SubHorizPos         
                    LDA.W $1540,X             
                    BNE ADDR_01F914           
                    LDA.B #$20                
                    STA.W $1540,X             
                    LDA $C2,X                 
                    BEQ ADDR_01F90C           
                    LDA $0F                   
                    CLC                       
                    ADC.B #$0A                
                    CMP.B #$14                
                    BCC ADDR_01F92F           
ADDR_01F90C:        STZ $C2,X                 
                    CPY $76                   
                    BNE ADDR_01F914           
                    INC $C2,X                 
ADDR_01F914:        LDA $0F                   
                    CLC                       
                    ADC.B #$0A                
                    CMP.B #$14                
                    BCC ADDR_01F92F           
                    LDA.W $15AC,X             
                    BNE ADDR_01F971           
                    TYA                       
                    CMP.W $157C,X             
                    BEQ ADDR_01F92F           
                    LDA.B #$1F                
                    STA.W $15AC,X             
                    BRA ADDR_01F971           
ADDR_01F92F:        STZ.W $1602,X             
                    LDA $C2,X                 
                    BEQ ADDR_01F989           
                    LDA.B #$03                
                    STA.W $1602,X             
                    LDY $9E,X                 
                    CPY.B #$28                
                    BEQ ADDR_01F948           
                    LDA.B #$00                
                    CPY.B #$AF                
                    BEQ ADDR_01F948           
                    INC A                     
ADDR_01F948:        AND $13                   
                    BNE ADDR_01F96F           
                    INC.W $1570,X             
                    LDA.W $1570,X             
                    BNE ADDR_01F959           
                    LDA.B #$20                
                    STA.W $1558,X             
ADDR_01F959:        LDA $B6,X                 
                    BEQ ADDR_01F962           
                    BPL ADDR_01F961           
                    INC A                     
                    INC A                     
ADDR_01F961:        DEC A                     
ADDR_01F962:        STA $B6,X                 
                    LDA $AA,X                 
                    BEQ ADDR_01F96D           
                    BPL ADDR_01F96C           
                    INC A                     
                    INC A                     
ADDR_01F96C:        DEC A                     
ADDR_01F96D:        STA $AA,X                 
ADDR_01F96F:        BRA ADDR_01F9C8           
ADDR_01F971:        CMP.B #$10                
                    BNE ADDR_01F97F           
                    PHA                       
                    LDA.W $157C,X             
                    EOR.B #$01                
                    STA.W $157C,X             
                    PLA                       
ADDR_01F97F:        LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_01F8D1,Y       
                    STA.W $1602,X             
ADDR_01F989:        STZ.W $1570,X             
                    LDA $13                   
                    AND.B #$07                
                    BNE ADDR_01F9C8           
                    JSR.W SubHorizPos         
                    LDA $B6,X                 
                    CMP.W DATA_01F8CF,Y       
                    BEQ ADDR_01F9A2           
                    CLC                       
                    ADC.W DATA_01EBB4,Y       
                    STA $B6,X                 
ADDR_01F9A2:        LDA $D3                   
                    PHA                       
                    SEC                       
                    SBC.W $18B6               
                    STA $D3                   
                    LDA $D4                   
                    PHA                       
                    SBC.B #$00                
                    STA $D4                   
                    JSR.W ADDR_01AD42         
                    PLA                       
                    STA $D4                   
                    PLA                       
                    STA $D3                   
                    LDA $AA,X                 
                    CMP.W DATA_01F8CF,Y       
                    BEQ ADDR_01F9C8           
                    CLC                       
                    ADC.W DATA_01EBB4,Y       
                    STA $AA,X                 
ADDR_01F9C8:        JSR.W ADDR_01ABCC         
                    JSR.W ADDR_01ABD8         
ADDR_01F9CE:        LDA $9E,X                 
                    CMP.B #$AF                
                    BNE ADDR_01FA3D           
                    LDA $B6,X                 
                    BPL ADDR_01F9DB           
                    EOR.B #$FF                
                    INC A                     
ADDR_01F9DB:        LDY.B #$00                
                    CMP.B #$08                
                    BCS ADDR_01FA09           
                    PHA                       
                    LDA.W $1662,X             
                    PHA                       
                    LDA.W $167A,X             
                    PHA                       
                    ORA.B #$80                
                    STA.W $167A,X             
                    LDA.B #$0C                
                    STA.W $1662,X             
                    JSR.W ADDR_01B457         
                    PLA                       
                    STA.W $167A,X             
                    PLA                       
                    STA.W $1662,X             
                    PLA                       
                    LDY.B #$01                
                    CMP.B #$04                
                    BCS ADDR_01FA15           
                    INY                       
                    BRA ADDR_01FA15           
ADDR_01FA09:        LDA.W $14C8,X             
                    CMP.B #$08                
                    BNE ADDR_01FA15           
                    PHY                       
                    JSR.W ADDR_01A7E4         
                    PLY                       
ADDR_01FA15:        TYA                       
                    STA.W $1602,X             
                    JSR.W ADDR_019F0D         
                    LDA.W $1602,X             
                    LDY.W $15EA,X             
                    PHX                       
                    TAX                       
                    LDA.W DATA_01FA37,X       
                    STA.W $0302,Y             
                    LDA.W $0303,Y             
                    AND.B #$F1                
                    ORA.W DATA_01FA3A,X       
                    STA.W $0303,Y             
                    PLX                       
                    RTS                       ; Return 


DATA_01FA37:        .db $8C,$C8,$CA

DATA_01FA3A:        .db $0E,$02,$02

ADDR_01FA3D:        LDA.W $14C8,X             
                    CMP.B #$08                
                    BNE ADDR_01FA47           
                    JSR.W ADDR_01A7E4         
ADDR_01FA47:        JSL.L ADDR_038398         
                    RTS                       ; Return 


DATA_01FA4C:        .db $40,$00

DATA_01FA4E:        .db $4A,$4C,$4A,$4C

DATA_01FA52:        .db $35,$35,$F5,$F5

DATA_01FA56:        .db $10,$F0

ADDR_01FA58:        JSR.W ADDR_019F0D         
                    LDY.W $157C,X             
                    LDA.W DATA_01FA4C,Y       
                    STA $00                   
                    LDY.W $15EA,X             
                    LDA $14                   
                    LSR                       
                    LSR                       
                    AND.B #$03                
                    PHX                       
                    TAX                       
                    LDA.W DATA_01FA4E,X       
                    STA.W $0302,Y             
                    LDA.W DATA_01FA52,X       
                    EOR $00                   
                    STA.W $0303,Y             
                    PLX                       
                    LDA $9D                   
                    BNE ADDR_01FAB3           
                    LDY.W $157C,X             
                    LDA.W DATA_01FA56,Y       
                    STA $B6,X                 
                    JSR.W ADDR_01ABCC         
                    JSR.W ADDR_01ABD8         
                    LDA $AA,X                 
                    CMP.B #$40                
                    BPL ADDR_01FA9A           
                    CLC                       
                    ADC.B #$04                
                    STA $AA,X                 
ADDR_01FA9A:        JSR.W ADDR_01FF98         
                    BCC ADDR_01FAA3           
                    LDA.B #$F0                
                    STA $AA,X                 
ADDR_01FAA3:        JSR.W ADDR_01A7E4         
                    LDA $D8,X                 
                    CMP.B #$44                
                    BCC ADDR_01FAB3           
                    CMP.B #$50                
                    BCS ADDR_01FAB3           
                    JSR.W ADDR_019ACB         
ADDR_01FAB3:        RTS                       ; Return 


DATA_01FAB4:        .db $FF,$01,$00,$80,$60,$A0,$40,$D0
                    .db $D8,$C0,$C8,$0C,$F4

ADDR_01FAC1:        LDA $C2,X                 
                    JSL.L ExecutePtr          

PowerUpRtPtr:       .dw ADDR_01CDAB           
                    .dw ADDR_01CDAB           
                    .dw ADDR_01CDAB           
                    .dw ADDR_01FAF5           
                    .dw ADDR_01FAF5           
                    .dw ADDR_01CD2A           
                    .dw ADDR_01CD2A           

DATA_01FAD5:        .db $00,$FC,$F8,$F8,$F8,$F8,$F8,$F8
DATA_01FADD:        .db $F8,$F8,$F8,$F4,$F0,$F0,$EC,$EC
DATA_01FAE5:        .db $00,$01,$02,$00,$01,$02,$00,$01
                    .db $02,$00,$01,$02,$00,$01,$02,$01

ADDR_01FAF5:        LDA $9D                   
                    ORA.W $154C,X             
                    BNE ADDR_01FB1A           
                    JSR.W SubHorizPos         
                    STY $00                   
                    LDA $36                   
                    ASL                       
                    ROL                       
                    AND.B #$01                
                    CMP $00                   
                    BNE ADDR_01FB1A           
                    INC.W $1534,X             
                    LDA.W $1534,X             
                    AND.B #$7F                
                    BNE ADDR_01FB1A           
                    LDA.B #$7F                ; \ Set time to go in shell 
                    STA.W $1564,X             ; / 
ADDR_01FB1A:        STZ.W $15A0,X             
                    LDA.W $163E,X             
                    BEQ ADDR_01FB36           
                    DEC A                     
                    BNE ADDR_01FB35           
                    INC.W $13C6               
                    LDA.B #$FF                
                    STA.W $1493               
                    LDA.B #$0B                
                    STA.W $1DFB               ; / Play sound effect 
                    STZ.W $14C8,X             
ADDR_01FB35:        RTS                       ; Return 

ADDR_01FB36:        JSL.L ADDR_07F7A0         
                    LDA $9D                   
                    BEQ ADDR_01FB41           
                    JMP.W ADDR_01FC08         
ADDR_01FB41:        LDA.W $160E,X             
                    BEQ ADDR_01FB7B           
                    JSR.W ADDR_01ABCC         
                    JSR.W ADDR_01ABD8         
                    LDA $AA,X                 
                    CMP.B #$40                
                    BPL ADDR_01FB56           
                    INC $AA,X                 
                    INC $AA,X                 
ADDR_01FB56:        LDA $D8,X                 
                    CMP.B #$58                
                    BCC ADDR_01FB6E           
                    CMP.B #$80                
                    BCS ADDR_01FB6E           
                    LDA.B #$20                
                    STA.W $1DFC               ; / Play sound effect 
                    LDA.B #$50                
                    STA.W $163E,X             
                    JSL.L ADDR_03A6C8         ; Kill all sprites 
ADDR_01FB6E:        LDA $E4,X                 
                    STA.W $14B8               
                    LDA $D8,X                 
                    STA.W $14BA               
                    JMP.W ADDR_01FC0E         
ADDR_01FB7B:        JSR.W ADDR_01ABCC         
                    LDA $13                   
                    AND.B #$1F                
                    ORA.W $1564,X             
                    BNE ADDR_01FB99           
                    LDA.W $157C,X             
                    PHA                       
                    JSR.W FaceMario           
                    PLA                       
                    CMP.W $157C,X             
                    BEQ ADDR_01FB99           
                    LDA.B #$10                
                    STA.W $15AC,X             
ADDR_01FB99:        STZ $AA,X                 
                    STZ $B6,X                 
                    LDA $36                   
                    BPL ADDR_01FBA4           
                    CLC                       
                    ADC.B #$08                
ADDR_01FBA4:        LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    STY $00                   
                    EOR.B #$FF                
                    INC A                     
                    AND.B #$0F                
                    STA $01                   
                    LDA.W $154C,X             
                    BNE ADDR_01FBD9           
                    LDA $37                   
                    BNE ADDR_01FBC9           
                    LDA $E4,X                 
                    CMP.B #$78                
                    BCC ADDR_01FBC5           
                    LDA.B #$FF                
                    BRA ADDR_01FBEE           
ADDR_01FBC5:        LDA.B #$01                
                    BRA ADDR_01FBEE           
ADDR_01FBC9:        LDY $01                   
                    LDA $E4,X                 
                    CMP.B #$78                
                    BCS ADDR_01FBD5           
                    LDA.B #$01                
                    BRA ADDR_01FBEE           
ADDR_01FBD5:        LDA.B #$FF                
                    BRA ADDR_01FBEE           
ADDR_01FBD9:        LDA $37                   
                    BNE ADDR_01FBE7           
                    LDY $00                   
                    LDA.W DATA_01FADD,Y       
                    EOR.B #$FF                
                    INC A                     
                    BRA ADDR_01FBEC           
ADDR_01FBE7:        LDY $01                   
                    LDA.W DATA_01FADD,Y       
ADDR_01FBEC:        ASL                       
                    ASL                       
ADDR_01FBEE:        STA $B6,X                 
                    INC.W $1570,X             
ADDR_01FBF3:        LDA $B6,X                 
                    BEQ ADDR_01FBFA           
                    INC.W $1570,X             
ADDR_01FBFA:        LDA.W $1570,X             
                    LSR                       
                    LSR                       
                    AND.B #$0F                
                    TAY                       
                    LDA.W DATA_01FAE5,Y       
                    STA.W $1602,X             
ADDR_01FC08:        JSR.W ADDR_01FD50         
                    JSR.W ADDR_01FC62         
ADDR_01FC0E:        LDA.W $154C,X             
                    BNE ADDR_01FC4E           
ADDR_01FC13:        LDA.W $157C,X             
                    PHA                       
                    LDY.W $15AC,X             
                    BEQ ADDR_01FC2A           
                    CPY.B #$08                
                    BCC ADDR_01FC25           
                    EOR.B #$01                
                    STA.W $157C,X             
ADDR_01FC25:        LDA.B #$06                
                    STA.W $1602,X             
ADDR_01FC2A:        LDA.W $1564,X             
                    BEQ ADDR_01FC46           
                    PHA                       
                    LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_01FD95,Y       
                    STA.W $1602,X             
                    PLA                       
                    CMP.B #$28                
                    BNE ADDR_01FC46           
                    LDA $9D                   
                    BNE ADDR_01FC46           
                    JSR.W ThrowBall           ; Throw ball 
ADDR_01FC46:        JSR.W ADDR_01FEBC         
                    PLA                       
                    STA.W $157C,X             
                    RTS                       ; Return 

ADDR_01FC4E:        CMP.B #$10                
                    BCC ADDR_01FC5A           
ADDR_01FC52:        LDA.B #$03                
                    STA.W $1602,X             
                    JMP.W ADDR_01FEBC         
ADDR_01FC5A:        CMP.B #$08                
                    BCC ADDR_01FC52           
                    JSR.W ADDR_01FF5B         
ADDR_01FC61:        RTS                       ; Return 

ADDR_01FC62:        LDA $71                   
                    CMP.B #$01                
                    BCS ADDR_01FC61           
                    LDA.W $160E,X             
                    BNE ADDR_01FC61           
                    LDA $E4,X                 
                    CMP.B #$20                
                    BCC ADDR_01FC77           
                    CMP.B #$D8                
                    BCC ADDR_01FC84           
ADDR_01FC77:        LDA.W $14B8               
                    STA $E4,X                 
                    LDA.W $14BA               
                    STA $D8,X                 
                    INC.W $160E,X             
ADDR_01FC84:        LDA.W $14B8               
                    SEC                       
                    SBC.B #$08                
                    STA $00                   
                    LDA.W $14BA               
                    CLC                       
                    ADC.B #$60                
                    STA $01                   
                    LDA.B #$0F                
                    STA $02                   
                    LDA.B #$0C                
                    STA $03                   
                    STZ $08                   
                    STZ $09                   
                    LDA $7E                   
                    CLC                       
                    ADC.B #$02                
                    STA $04                   
                    LDA $80                   
                    CLC                       
                    ADC.B #$10                
                    STA $05                   
                    LDA.B #$0C                
                    STA $06                   
                    LDA.B #$0E                
                    STA $07                   
                    STZ $0A                   
                    STZ $0B                   
                    JSL.L ADDR_03B72B         
                    BCC ADDR_01FD0A           
                    LDA.W $1558,X             
                    BNE ADDR_01FD09           
                    LDA.B #$08                
                    STA.W $1558,X             
                    LDA $72                   
                    BEQ ADDR_01FD05           
                    LDA.B #$28                
                    STA.W $1DFC               ; / Play sound effect 
                    JSL.L BoostMarioSpeed     
                    LDA $E4,X                 
                    PHA                       
                    LDA $D8,X                 
                    PHA                       
                    LDA.W $14B8               
                    SEC                       
                    SBC.B #$08                
                    STA $E4,X                 
                    LDA.W $14BA               
                    SEC                       
                    SBC.B #$10                
                    STA $D8,X                 
                    STZ.W $15A0,X             
                    JSL.L DisplayContactGfx   
                    PLA                       
                    STA $D8,X                 
                    PLA                       
                    STA $E4,X                 
                    LDA.W $154C,X             
                    BNE ADDR_01FD09           
                    LDA.B #$18                
                    STA.W $154C,X             
                    RTS                       ; Return 

ADDR_01FD05:        JSL.L HurtMario           
ADDR_01FD09:        RTS                       ; Return 

ADDR_01FD0A:        LDY.B #$0A                
ADDR_01FD0C:        STY.W $1695               
                    LDA.W $170B,Y             
                    CMP.B #$05                
                    BNE ADDR_01FD4A           
                    LDA.W $171F,Y             
                    SEC                       
                    SBC $1A                   
                    STA $04                   
                    STZ $0A                   
                    LDA.W $1715,Y             
                    SEC                       
                    SBC $1C                   
                    STA $05                   
                    STZ $0B                   
                    LDA.B #$08                
                    STA $06                   
                    STA $07                   
                    JSL.L ADDR_03B72B         
                    BCC ADDR_01FD4A           
                    LDA.B #$01                
                    STA.W $170B,Y             
                    LDA.B #$0F                
                    STA.W $176F,Y             
                    LDA.B #$01                
                    STA.W $1DF9               ; / Play sound effect 
                    LDA.B #$10                
                    STA.W $154C,X             
ADDR_01FD4A:        DEY                       
                    CPY.B #$07                
                    BNE ADDR_01FD0C           
                    RTS                       ; Return 

ADDR_01FD50:        LDA $E4,X                 
                    CLC                       
                    ADC.B #$08                
                    STA.W $14B4               
                    LDA.W $14E0,X             
                    ADC.B #$00                
                    STA.W $14B5               
                    LDA $D8,X                 
                    CLC                       
                    ADC.B #$2F                
                    STA.W $14B6               
                    LDA.W $14D4,X             
                    ADC.B #$00                
                    STA.W $14B7               
                    REP #$20                  ; Accum (16 bit) 
                    LDA $36                   
                    EOR.W #$01FF              
                    INC A                     
                    AND.W #$01FF              
                    STA $36                   
                    SEP #$20                  ; Accum (8 bit) 
                    PHX                       
                    JSL.L ADDR_01CC9D         
                    PLX                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA $36                   
                    EOR.W #$01FF              
                    INC A                     
                    AND.W #$01FF              
                    STA $36                   
                    SEP #$20                  ; Accum (8 bit) 
                    RTS                       ; Return 


DATA_01FD95:        .db $04,$0B,$0B,$0B,$0B,$0A,$0A,$09
                    .db $09,$08,$08,$07,$04,$05,$05,$05
BallPositionDispX:  .db $08,$F8

ThrowBall:          LDY.B #$05                ; \ Find an open sprite index 
ADDR_01FDA9:        LDA.W $14C8,Y             ;  | 
                    BEQ GenerateBall          ;  | 
                    DEY                       ;  | 
                    BPL ADDR_01FDA9           ; / 
                    RTS                       ; Return 

GenerateBall:       LDA.B #$20                ; \ Play sound effect 
                    STA.W $1DF9               ; / 
                    LDA.B #$08                ; \ Sprite status = normal 
                    STA.W $14C8,Y             ; / 
                    LDA.B #$A7                ; \ Sprite to throw = ball 
                    STA.W $009E,Y             ; / 
                    PHX                       ; \ Before: X must have index of sprite being generated 
                    TYX                       ;  | Routine clears *all* old sprite values... 
                    JSL.L ADDR_07F7D2         ;  | ...and loads in new values for the 6 main sprite tables 
                    PLX                       ; / 
                    PHX                       ; Push Iggy's sprite index 
                    LDA.W $157C,X             ; \ Ball's direction = Iggy'direction 
                    STA.W $157C,Y             ; / 
                    TAX                       ; X = Ball's direction 
                    LDA.W $14B8               ; \ Set Ball X position 
                    SEC                       ;  | 
                    SBC.B #$08                ;  | 
                    ADC.W BallPositionDispX,X ;  | 
                    STA.W $00E4,Y             ;  | 
                    LDA.B #$00                ;  | 
                    STA.W $14E0,Y             ; / 
                    LDA.W $14BA               ; \ Set Ball Y position 
                    SEC                       ;  | 
                    SBC.B #$18                ;  | 
                    STA.W $00D8,Y             ;  | 
                    LDA.B #$00                ;  | 
                    SBC.B #$00                ;  | 
                    STA.W $14D4,Y             ; / 
                    PLX                       ; X = Iggy's sprite index 
                    RTS                       ; Return 


DATA_01FDF3:        .db $F7,$FF,$00,$F8,$F7,$FF,$00,$F8
                    .db $F8,$00,$00,$F8,$FB,$03,$00,$F8
                    .db $F8,$00,$00,$F8,$FA,$02,$00,$F8
                    .db $00,$00,$F8,$00,$00,$F8,$00,$F8
                    .db $00,$00,$00,$00,$FB,$F8,$00,$F8
                    .db $F4,$F8,$00,$F8,$00,$F8,$00,$F8
                    .db $09,$09,$00,$10,$09,$09,$00,$10
                    .db $08,$08,$00,$10,$05,$05,$00,$10
                    .db $08,$08,$00,$10,$06,$06,$00,$10
                    .db $00,$08,$08,$08,$00,$10,$00,$10
                    .db $00,$08,$00,$08,$05,$10,$00,$10
                    .db $0C,$10,$00,$10,$00,$10,$00,$10
DATA_01FE53:        .db $FA,$F2,$00,$09,$F9,$F1,$00,$08
                    .db $F8,$F0,$00,$08,$FE,$F6,$00,$08
                    .db $FC,$F4,$00,$08,$FF,$F7,$00,$08
                    .db $00,$F0,$F8,$F0,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$FC,$00,$00,$00
                    .db $F9,$00,$00,$00,$00,$08,$00,$08
DATA_01FE83:        .db $00,$0C,$02,$0A,$00,$0C,$22,$0A
                    .db $00,$0C,$20,$0A,$00,$0C,$20,$0A
                    .db $00,$0C,$20,$0A,$00,$0C,$20,$0A
                    .db $24,$1C,$04,$1C,$0E,$0D,$0E,$0D
                    .db $0E,$1D,$0E,$1D,$4A,$0D,$0E,$0D
                    .db $4A,$0D,$0E,$0D,$20,$0A,$20,$0A
DATA_01FEB3:        .db $06,$02,$08

DATA_01FEB6:        .db $02

DATA_01FEB7:        .db $00,$02,$00,$37,$3B

ADDR_01FEBC:        LDY $C2,X                 
                    LDA.W DATA_01FEB7,Y       
                    STA $0D                   
                    STY $05                   
                    LDY.W $15EA,X             
                    LDA.W $157C,X             
                    LSR                       
                    ROR                       
                    LSR                       
                    AND.B #$40                
                    EOR.B #$40                
                    STA $02                   
                    LDA.W $1602,X             
                    ASL                       
                    ASL                       
                    STA $03                   
                    PHX                       
                    LDX.B #$03                
ADDR_01FEDE:        PHX                       
                    TXA                       
                    CLC                       
                    ADC $03                   
                    TAX                       
                    PHX                       
                    LDA $02                   
                    BEQ ADDR_01FEEE           
                    TXA                       
                    CLC                       
                    ADC.B #$30                
                    TAX                       
ADDR_01FEEE:        LDA.W $14B8               
                    SEC                       
                    SBC.B #$08                
                    CLC                       
                    ADC.W DATA_01FDF3,X       
                    STA.W $0300,Y             
                    PLX                       
                    LDA.W $14BA               
                    CLC                       
                    ADC.B #$60                
                    CLC                       
                    ADC.W DATA_01FE53,X       
                    STA.W $0301,Y             
                    LDA.W DATA_01FE83,X       
                    STA.W $0302,Y             
                    PHX                       
                    LDX $05                   
                    CPX.B #$03                
                    BNE ADDR_01FF22           
                    CMP.B #$05                
                    BCS ADDR_01FF22           
                    LSR                       
                    TAX                       
                    LDA.W DATA_01FEB3,X       
                    STA.W $0302,Y             
ADDR_01FF22:        LDA.W $0302,Y             
                    CMP.B #$4A                
                    LDA $0D                   
                    BCC ADDR_01FF2D           
                    LDA.B #$35                ;  Iggy ball palette 
ADDR_01FF2D:        ORA $02                   
                    STA.W $0303,Y             
                    PLA                       
                    AND.B #$03                
                    TAX                       
                    PHY                       
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_01FEB6,X       
                    STA.W $0460,Y             
                    PLY                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    PLX                       
                    DEX                       
                    BPL ADDR_01FEDE           
                    PLX                       
                    LDY.B #$FF                
                    LDA.B #$03                
                    JSR.W ADDR_01B7BB         
                    RTS                       ; Return 


DATA_01FF53:        .db $2C,$2E,$2C,$2E

DATA_01FF57:        .db $00,$00,$40,$00

ADDR_01FF5B:        PHX                       
                    LDY $C2,X                 
                    LDA.W DATA_01FEB7,Y       
                    STA $0D                   
                    LDY.B #$70                
                    LDA.W $14B8               
                    SEC                       
                    SBC.B #$08                
                    STA.W $0300,Y             
                    LDA.W $14BA               
                    CLC                       
                    ADC.B #$60                
                    STA.W $0301,Y             
                    LDA $14                   
                    LSR                       
                    AND.B #$03                
                    TAX                       
                    LDA.W DATA_01FF53,X       
                    STA.W $0302,Y             
                    LDA.B #$30                
                    ORA.W DATA_01FF57,X       
                    ORA $0D                   
                    STA.W $0303,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$02                
                    STA.W $0460,Y             
                    PLX                       
                    RTS                       ; Return 

ADDR_01FF98:        LDA $E4,X                 
                    CLC                       
                    ADC.B #$08                
                    STA.W $14B4               
                    LDA.W $14E0,X             
                    ADC.B #$00                
                    STA.W $14B5               
                    LDA $D8,X                 
                    CLC                       
                    ADC.B #$0F                
                    STA.W $14B6               
                    LDA.W $14D4,X             
                    ADC.B #$00                
                    STA.W $14B7               
                    PHX                       
                    JSL.L ADDR_01CC9D         
                    PLX                       
                    RTS                       ; Return 


DATA_01FFBF:        .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF
