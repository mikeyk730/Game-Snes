.INCLUDE "snes.cfg"
.BANK 3
DATA_038000:        .db $13,$14,$15,$16,$17,$18,$19

DATA_038007:        .db $F0,$F8,$FC,$00,$04,$08,$10

DATA_03800E:        .db $A0,$D0,$C0,$D0

Football:           JSL.L GenericSprGfxRt2    
                    LDA $9D                   
                    BNE Return038086          
                    JSR.W SubOffscreen0Bnk3   
                    JSL.L SprSpr_MarioSprRts  
                    LDA.W $1540,X             
                    BEQ ADDR_03802D           
                    DEC A                     
                    BNE ADDR_038031           
                    JSL.L ExtSub01AB6F        
ADDR_03802D:        JSL.L UpdateSpritePos     
ADDR_038031:        LDA.W $1588,X             ; \ Branch if not touching object
                    AND.B #$03                ;  |
                    BEQ ADDR_03803F           ; /
                    LDA $B6,X                 
                    EOR.B #$FF                
                    INC A                     
                    STA $B6,X                 
ADDR_03803F:        LDA.W $1588,X             
                    AND.B #$08                
                    BEQ ADDR_038048           
                    STZ $AA,X                 ; Sprite Y Speed = 0
ADDR_038048:        LDA.W $1588,X             ; \ Branch if not on ground
                    AND.B #$04                ;  |
                    BEQ Return038086          ; /
                    LDA.W $1540,X             
                    BNE Return038086          
                    LDA.W $15F6,X             
                    EOR.B #$40                
                    STA.W $15F6,X             
                    JSL.L GetRand             
                    AND.B #$03                
                    TAY                       
                    LDA.W DATA_03800E,Y       
                    STA $AA,X                 
                    LDY.W $15B8,X             
                    INY                       
                    INY                       
                    INY                       
                    LDA.W DATA_038007,Y       
                    CLC                       
                    ADC $B6,X                 
                    BPL ADDR_03807E           
                    CMP.B #$E0                
                    BCS ADDR_038084           
                    LDA.B #$E0                
                    BRA ADDR_038084           

ADDR_03807E:        CMP.B #$20                
                    BCC ADDR_038084           
                    LDA.B #$20                
ADDR_038084:        STA $B6,X                 
Return038086:       RTS                       ; Return

BigBooBoss:         JSL.L ExtSub038398        
                    JSL.L ExtSub038239        
                    LDA.W $14C8,X             
                    BNE ADDR_0380A2           
                    INC.W $13C6               
                    LDA.B #$FF                
                    STA.W $1493               
                    LDA.B #$0B                
                    STA.W $1DFB               ; / Change music
                    RTS                       ; Return

ADDR_0380A2:        CMP.B #$08                
                    BNE Return0380D4          
                    LDA $9D                   
                    BNE Return0380D4          
                    LDA $C2,X                 
                    JSL.L ExecutePtr          

BooBossPtrs:        .dw ADDR_0380BE           
                    .dw ADDR_0380D5           
                    .dw ADDR_038119           
                    .dw ADDR_03818B           
                    .dw ADDR_0381BC           
                    .dw ADDR_038106           
                    .dw ADDR_0381D3           

ADDR_0380BE:        LDA.B #$03                
                    STA.W $1602,X             
                    INC.W $1570,X             
                    LDA.W $1570,X             
                    CMP.B #$90                
                    BNE Return0380D4          
                    LDA.B #$08                
                    STA.W $1540,X             
                    INC $C2,X                 
Return0380D4:       RTS                       ; Return

ADDR_0380D5:        LDA.W $1540,X             
                    BNE Return0380F9          
                    LDA.B #$08                
                    STA.W $1540,X             
                    INC.W $190B               
                    LDA.W $190B               
                    CMP.B #$02                
                    BNE ADDR_0380EE           
                    LDY.B #$10                ; \ Play sound effect
                    STY.W $1DF9               ; /
ADDR_0380EE:        CMP.B #$07                
                    BNE Return0380F9          
                    INC $C2,X                 
                    LDA.B #$40                
                    STA.W $1540,X             
Return0380F9:       RTS                       ; Return

DATA_0380FA:        .db $FF,$01

DATA_0380FC:        .db $F0,$10

DATA_0380FE:        .db $0C,$F4

DATA_038100:        .db $01,$FF

DATA_038102:        .db $01,$02,$02,$01

ADDR_038106:        LDA.W $1540,X             
                    BNE ADDR_038112           
                    STZ $C2,X                 
                    LDA.B #$40                
                    STA.W $1570,X             
ADDR_038112:        LDA.B #$03                
                    STA.W $1602,X             
                    BRA ADDR_03811F           

ADDR_038119:        STZ.W $1602,X             
                    JSR.W ADDR_0381E4         
ADDR_03811F:        LDA.W $15AC,X             
                    BNE ADDR_038132           
                    JSR.W SubHorzPosBnk3      
                    TYA                       
                    CMP.W $157C,X             
                    BEQ ADDR_03814A           
                    LDA.B #$1F                
                    STA.W $15AC,X             
ADDR_038132:        CMP.B #$10                
                    BNE ADDR_038140           
                    PHA                       
                    LDA.W $157C,X             
                    EOR.B #$01                
                    STA.W $157C,X             
                    PLA                       
ADDR_038140:        LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_038102,Y       
                    STA.W $1602,X             
ADDR_03814A:        LDA $14                   
                    AND.B #$07                
                    BNE ADDR_038166           
                    LDA.W $151C,X             
                    AND.B #$01                
                    TAY                       
                    LDA $B6,X                 
                    CLC                       
                    ADC.W DATA_0380FA,Y       
                    STA $B6,X                 
                    CMP.W DATA_0380FC,Y       
                    BNE ADDR_038166           
                    INC.W $151C,X             
ADDR_038166:        LDA $14                   
                    AND.B #$07                
                    BNE ADDR_038182           
                    LDA.W $1528,X             
                    AND.B #$01                
                    TAY                       
                    LDA $AA,X                 
                    CLC                       
                    ADC.W DATA_038100,Y       
                    STA $AA,X                 
                    CMP.W DATA_0380FE,Y       
                    BNE ADDR_038182           
                    INC.W $1528,X             
ADDR_038182:        JSL.L UpdateXPosNoGrvty   
                    JSL.L UpdateYPosNoGrvty   
                    RTS                       ; Return

ADDR_03818B:        LDA.W $1540,X             
                    BNE ADDR_0381AE           
                    INC $C2,X                 
                    LDA.B #$08                
                    STA.W $1540,X             
                    JSL.L LoadSpriteTables    
                    INC.W $1534,X             
                    LDA.W $1534,X             
                    CMP.B #$03                
                    BNE Return0381AD          
                    LDA.B #$06                
                    STA $C2,X                 
                    JSL.L KillMostSprites     
Return0381AD:       RTS                       ; Return

ADDR_0381AE:        AND.B #$0E                
                    EOR.W $15F6,X             
                    STA.W $15F6,X             
                    LDA.B #$03                
                    STA.W $1602,X             
                    RTS                       ; Return

ADDR_0381BC:        LDA.W $1540,X             
                    BNE Return0381D2          
                    LDA.B #$08                
                    STA.W $1540,X             
                    DEC.W $190B               
                    BNE Return0381D2          
                    INC $C2,X                 
                    LDA.B #$C0                
                    STA.W $1540,X             
Return0381D2:       RTS                       ; Return

ADDR_0381D3:        LDA.B #$02                ; \ Sprite status = Killed
                    STA.W $14C8,X             ; /
                    STZ $B6,X                 ; Sprite X Speed = 0
                    LDA.B #$D0                
                    STA $AA,X                 
                    LDA.B #$23                ; \ Play sound effect
                    STA.W $1DF9               ; /
                    RTS                       ; Return

ADDR_0381E4:        LDY.B #$0B                
ADDR_0381E6:        LDA.W $14C8,Y             
                    CMP.B #$09                
                    BEQ ADDR_0381F5           
                    CMP.B #$0A                
                    BEQ ADDR_0381F5           
ADDR_0381F1:        DEY                       
                    BPL ADDR_0381E6           
                    RTS                       ; Return

ADDR_0381F5:        PHX                       
                    TYX                       
                    JSL.L GetSpriteClippingB  
                    PLX                       
                    JSL.L GetSpriteClippingA  
                    JSL.L CheckForContact     
                    BCC ADDR_0381F1           
                    LDA.B #$03                
                    STA $C2,X                 
                    LDA.B #$40                
                    STA.W $1540,X             
                    PHX                       
                    TYX                       
                    STZ.W $14C8,X             
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
                    LDA.B #$FF                
                    JSL.L ShatterBlock        
                    PLB                       
                    PLX                       
                    LDA.B #$28                ; \ Play sound effect
                    STA.W $1DFC               ; /
                    RTS                       ; Return

ExtSub038239:       LDY.B #$24                
                    STY $40                   
                    LDA.W $190B               
                    CMP.B #$08                
                    DEC A                     
                    BCS ADDR_03824A           
                    LDY.B #$34                
                    STY $40                   
                    INC A                     
ADDR_03824A:        ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    TAX                       
                    STZ $00                   
                    LDY.W $0681               
ADDR_038254:        LDA.L BooBossPals,X       
                    STA.W $0684,Y             
                    INY                       
                    INX                       
                    INC $00                   
                    LDA $00                   
                    CMP.B #$10                
                    BNE ADDR_038254           
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
                    LDX.W $15E9               ; X = Sprite index
                    RTL                       ; Return

BigBooDispX:        .db $08,$08,$20,$00,$00,$00,$00,$10
                    .db $10,$10,$10,$20,$20,$20,$20,$30
                    .db $30,$30,$30,$FD,$0C,$0C,$27,$00
                    .db $00,$00,$00,$10,$10,$10,$10,$1F
                    .db $20,$20,$1F,$2E,$2E,$2C,$2C,$FB
                    .db $12,$12,$30,$00,$00,$00,$00,$10
                    .db $10,$10,$10,$1F,$20,$20,$1F,$2E
                    .db $2E,$2E,$2E,$F8,$11,$FF,$08,$08
                    .db $00,$00,$00,$00,$10,$10,$10,$10
                    .db $20,$20,$20,$20,$30,$30,$30,$30
BigBooDispY:        .db $12,$22,$18,$00,$10,$20,$30,$00
                    .db $10,$20,$30,$00,$10,$20,$30,$00
                    .db $10,$20,$30,$18,$16,$16,$12,$22
                    .db $00,$10,$20,$30,$00,$10,$20,$30
                    .db $00,$10,$20,$30,$00,$10,$20,$30
BigBooTiles:        .db $C0,$E0,$E8,$80,$A0,$A0,$80,$82
                    .db $A2,$A2,$82,$84,$A4,$C4,$E4,$86
                    .db $A6,$C6,$E6,$E8,$C0,$E0,$E8,$80
                    .db $A0,$A0,$80,$82,$A2,$A2,$82,$84
                    .db $A4,$C4,$E4,$86,$A6,$C6,$E6,$E8
                    .db $C0,$E0,$E8,$80,$A0,$A0,$80,$82
                    .db $A2,$A2,$82,$84,$A4,$A4,$84,$86
                    .db $A6,$A6,$86,$E8,$E8,$E8,$C2,$E2
                    .db $80,$A0,$A0,$80,$82,$A2,$A2,$82
                    .db $84,$A4,$C4,$E4,$86,$A6,$C6,$E6
BigBooGfxProp:      .db $00,$00,$40,$00,$00,$80,$80,$00
                    .db $00,$80,$80,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$40,$00
                    .db $00,$80,$80,$00,$00,$80,$80,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$40,$00,$00,$80,$80,$00
                    .db $00,$80,$80,$00,$00,$80,$80,$00
                    .db $00,$80,$80,$00,$00,$40,$00,$00
                    .db $00,$00,$80,$80,$00,$00,$80,$80
                    .db $00,$00,$00,$00,$00,$00,$00,$00

ExtSub038398:       PHB                       ; Wrapper
                    PHK                       
                    PLB                       
                    JSR.W ADDR_0383A0         
                    PLB                       
                    RTL                       ; Return

ADDR_0383A0:        LDA $9E,X                 
                    CMP.B #$37                
                    BNE ADDR_0383C2           
                    LDA.B #$00                
                    LDY $C2,X                 
                    BEQ ADDR_0383BA           
                    LDA.B #$06                
                    LDY.W $1558,X             
                    BEQ ADDR_0383BA           
                    TYA                       
                    AND.B #$04                
                    LSR                       
                    LSR                       
                    ADC.B #$02                
ADDR_0383BA:        STA.W $1602,X             
                    JSL.L GenericSprGfxRt2    
                    RTS                       ; Return

ADDR_0383C2:        JSR.W GetDrawInfoBnk3     
                    LDA.W $1602,X             
                    STA $06                   
                    ASL                       
                    ASL                       
                    STA $03                   
                    ASL                       
                    ASL                       
                    ADC $03                   
                    STA $02                   
                    LDA.W $157C,X             
                    STA $04                   
                    LDA.W $15F6,X             
                    STA $05                   
                    LDX.B #$00                
ADDR_0383E0:        PHX                       
                    LDX $02                   
                    LDA.W BigBooTiles,X       
                    STA.W $0302,Y             
                    LDA $04                   
                    LSR                       
                    LDA.W BigBooGfxProp,X     
                    ORA $05                   
                    BCS ADDR_0383F5           
                    EOR.B #$40                
ADDR_0383F5:        ORA $64                   
                    STA.W $0303,Y             
                    LDA.W BigBooDispX,X       
                    BCS ADDR_038405           
                    EOR.B #$FF                
                    INC A                     
                    CLC                       
                    ADC.B #$28                
ADDR_038405:        CLC                       
                    ADC $00                   
                    STA.W $0300,Y             
                    PLX                       
                    PHX                       
                    LDA $06                   
                    CMP.B #$03                
                    BCC ADDR_038418           
                    TXA                       
                    CLC                       
                    ADC.B #$14                
                    TAX                       
ADDR_038418:        LDA $01                   
                    CLC                       
                    ADC.W BigBooDispY,X       
                    STA.W $0301,Y             
                    PLX                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    INC $02                   
                    INX                       
                    CPX.B #$14                
                    BNE ADDR_0383E0           
                    LDX.W $15E9               ; X = Sprite index
                    LDA.W $1602,X             
                    CMP.B #$03                
                    BNE ADDR_03844B           
                    LDA.W $1558,X             
                    BEQ ADDR_03844B           
                    LDY.W $15EA,X             ; Y = Index into sprite OAM
                    LDA.W $0301,Y             
                    CLC                       
                    ADC.B #$05                
                    STA.W $0301,Y             
                    STA.W $0305,Y             
ADDR_03844B:        LDA.B #$13                
                    LDY.B #$02                
                    JSL.L FinishOAMWrite      
                    RTS                       ; Return

GreyFallingPlat:    JSR.W ADDR_038492         
                    LDA $9D                   
                    BNE Return038489          
                    JSR.W SubOffscreen0Bnk3   
                    LDA $AA,X                 
                    BEQ ADDR_038476           
                    LDA.W $1540,X             
                    BNE ADDR_038472           
                    LDA $AA,X                 
                    CMP.B #$40                
                    BPL ADDR_038472           
                    CLC                       
                    ADC.B #$02                
                    STA $AA,X                 
ADDR_038472:        JSL.L UpdateYPosNoGrvty   
ADDR_038476:        JSL.L InvisBlkMainRt      
                    BCC Return038489          
                    LDA $AA,X                 
                    BNE Return038489          
                    LDA.B #$03                
                    STA $AA,X                 
                    LDA.B #$18                
                    STA.W $1540,X             
Return038489:       RTS                       ; Return

FallingPlatDispX:   .db $00,$10,$20,$30

FallingPlatTiles:   .db $60,$61,$61,$62

ADDR_038492:        JSR.W GetDrawInfoBnk3     
                    PHX                       
                    LDX.B #$03                
ADDR_038498:        LDA $00                   
                    CLC                       
                    ADC.W FallingPlatDispX,X  
                    STA.W $0300,Y             
                    LDA $01                   
                    STA.W $0301,Y             
                    LDA.W FallingPlatTiles,X  
                    STA.W $0302,Y             
                    LDA.B #$03                
                    ORA $64                   
                    STA.W $0303,Y             
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_038498           
                    PLX                       
                    LDY.B #$02                
                    LDA.B #$03                
                    JSL.L FinishOAMWrite      
                    RTS                       ; Return

BlurpMaxSpeedY:     .db $04,$FC

BlurpSpeedX:        .db $08,$F8

BlurpAccelY:        .db $01,$FF

Blurp:              JSL.L GenericSprGfxRt2    
                    LDY.W $15EA,X             ; Y = Index into sprite OAM
                    LDA.W $0014               
                    LSR                       
                    LSR                       
                    LSR                       
                    CLC                       
                    ADC.W $15E9               
                    LSR                       
                    LDA.B #$A2                
                    BCC ADDR_0384E2           
                    LDA.B #$EC                
ADDR_0384E2:        STA.W $0302,Y             
                    LDA.W $14C8,X             
                    CMP.B #$08                
                    BEQ ADDR_0384F5           
ADDR_0384EC:        LDA.W $0303,Y             
                    ORA.B #$80                
                    STA.W $0303,Y             
                    RTS                       ; Return

ADDR_0384F5:        LDA $9D                   
                    BNE Return03852A          
                    JSR.W SubOffscreen0Bnk3   
                    LDA $14                   
                    AND.B #$03                
                    BNE ADDR_038516           
                    LDA $C2,X                 
                    AND.B #$01                
                    TAY                       
                    LDA $AA,X                 
                    CLC                       
                    ADC.W BlurpAccelY,Y       
                    STA $AA,X                 
                    CMP.W BlurpMaxSpeedY,Y    
                    BNE ADDR_038516           
                    INC $C2,X                 
ADDR_038516:        LDY.W $157C,X             
                    LDA.W BlurpSpeedX,Y       
                    STA $B6,X                 
                    JSL.L UpdateXPosNoGrvty   
                    JSL.L UpdateYPosNoGrvty   
                    JSL.L SprSpr_MarioSprRts  
Return03852A:       RTS                       ; Return

PorcuPuffAccel:     .db $01,$FF

PorcuPuffMaxSpeed:  .db $10,$F0

PorcuPuffer:        JSR.W ADDR_0385A3         
                    LDA $9D                   
                    BNE Return038586          
                    LDA.W $14C8,X             
                    CMP.B #$08                
                    BNE Return038586          
                    JSR.W SubOffscreen0Bnk3   
                    JSL.L SprSpr_MarioSprRts  
                    JSR.W SubHorzPosBnk3      
                    TYA                       
                    STA.W $157C,X             
                    LDA $14                   
                    AND.B #$03                
                    BNE ADDR_03855E           
                    LDA $B6,X                 ; \ Branch if at max speed
                    CMP.W PorcuPuffMaxSpeed,Y ;  |
                    BEQ ADDR_03855E           ; /
                    CLC                       ; \ Otherwise, accelerate
                    ADC.W PorcuPuffAccel,Y    ;  |
                    STA $B6,X                 ; /
ADDR_03855E:        LDA $B6,X                 
                    PHA                       
                    LDA.W $17BD               
                    ASL                       
                    ASL                       
                    ASL                       
                    CLC                       
                    ADC $B6,X                 
                    STA $B6,X                 
                    JSL.L UpdateXPosNoGrvty   
                    PLA                       
                    STA $B6,X                 
                    JSL.L ExtSub019138        
                    LDY.B #$04                
                    LDA.W $164A,X             
                    BEQ ADDR_038580           
                    LDY.B #$FC                
ADDR_038580:        STY $AA,X                 
                    JSL.L UpdateYPosNoGrvty   
Return038586:       RTS                       ; Return

PocruPufferDispX:   .db $F8,$08,$F8,$08,$08,$F8,$08,$F8
PocruPufferDispY:   .db $F8,$F8,$08,$08

PocruPufferTiles:   .db $86,$C0,$A6,$C2,$86,$C0,$A6,$8A
PocruPufferGfxProp: .db $0D,$0D,$0D,$0D,$4D,$4D,$4D,$4D

ADDR_0385A3:        JSR.W GetDrawInfoBnk3     
                    LDA $14                   
                    AND.B #$04                
                    STA $03                   
                    LDA.W $157C,X             
                    STA $02                   
                    PHX                       
                    LDX.B #$03                
ADDR_0385B4:        LDA $01                   
                    CLC                       
                    ADC.W PocruPufferDispY,X  
                    STA.W $0301,Y             
                    PHX                       
                    LDA $02                   
                    BNE ADDR_0385C6           
                    TXA                       
                    ORA.B #$04                
                    TAX                       
ADDR_0385C6:        LDA $00                   
                    CLC                       
                    ADC.W PocruPufferDispX,X  
                    STA.W $0300,Y             
                    LDA.W PocruPufferGfxProp,X
                    ORA $64                   
                    STA.W $0303,Y             
                    PLA                       
                    PHA                       
                    ORA $03                   
                    TAX                       
                    LDA.W PocruPufferTiles,X  
                    STA.W $0302,Y             
                    PLX                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_0385B4           
                    PLX                       
                    LDY.B #$02                
                    LDA.B #$03                
                    JSL.L FinishOAMWrite      
                    RTS                       ; Return

FlyingBlockSpeedY:  .db $08,$F8

FlyingTurnBlocks:   JSR.W ADDR_0386A8         
                    LDA $9D                   
                    BNE Return038675          
                    LDA.W $1B9A               
                    BEQ ADDR_038629           
                    LDA.W $1534,X             
                    INC.W $1534,X             
                    AND.B #$01                
                    BNE ADDR_03861E           
                    DEC.W $1602,X             
                    LDA.W $1602,X             
                    CMP.B #$FF                
                    BNE ADDR_03861E           
                    LDA.B #$FF                
                    STA.W $1602,X             
                    INC.W $157C,X             
ADDR_03861E:        LDA.W $157C,X             
                    AND.B #$01                
                    TAY                       
                    LDA.W FlyingBlockSpeedY,Y 
                    STA $AA,X                 
ADDR_038629:        LDA $AA,X                 
                    PHA                       
                    LDY.W $151C,X             
                    BNE ADDR_038636           
                    EOR.B #$FF                
                    INC A                     
                    STA $AA,X                 
ADDR_038636:        JSL.L UpdateYPosNoGrvty   
                    PLA                       
                    STA $AA,X                 
                    LDA.W $1B9A               
                    STA $B6,X                 
                    JSL.L UpdateXPosNoGrvty   
                    STA.W $1528,X             
                    JSL.L InvisBlkMainRt      
                    BCC Return038675          
                    LDA.W $1B9A               
                    BNE Return038675          
                    LDA.B #$08                
                    STA.W $1B9A               
                    LDA.B #$7F                
                    STA.W $1602,X             
                    LDY.B #$09                
ADDR_038660:        CPY.W $15E9               
                    BEQ ADDR_03866C           
                    LDA.W $009E,Y             
                    CMP.B #$C1                
                    BEQ ADDR_038670           
ADDR_03866C:        DEY                       
                    BPL ADDR_038660           
                    INY                       
ADDR_038670:        LDA.B #$7F                
                    STA.W $1602,Y             
Return038675:       RTS                       ; Return

ForestPlatDispX:    .db $00,$10,$20,$F2,$2E,$00,$10,$20
                    .db $FA,$2E

ForestPlatDispY:    .db $00,$00,$00,$F6,$F6,$00,$00,$00
                    .db $FE,$FE

ForestPlatTiles:    .db $40,$40,$40,$C6,$C6,$40,$40,$40
                    .db $5D,$5D

ForestPlatGfxProp:  .db $32,$32,$32,$72,$32,$32,$32,$32
                    .db $72,$32

ForestPlatTileSize: .db $02,$02,$02,$02,$02,$02,$02,$02
                    .db $00,$00

ADDR_0386A8:        JSR.W GetDrawInfoBnk3     
                    LDY.W $15EA,X             ; Y = Index into sprite OAM
                    LDA $14                   
                    LSR                       
                    AND.B #$04                
                    BEQ ADDR_0386B6           
                    INC A                     
ADDR_0386B6:        STA $02                   
                    PHX                       
                    LDX.B #$04                
ADDR_0386BB:        STX $06                   
                    TXA                       
                    CLC                       
                    ADC $02                   
                    TAX                       
                    LDA $00                   
                    CLC                       
                    ADC.W ForestPlatDispX,X   
                    STA.W $0300,Y             
                    LDA $01                   
                    CLC                       
                    ADC.W ForestPlatDispY,X   
                    STA.W $0301,Y             
                    LDA.W ForestPlatTiles,X   
                    STA.W $0302,Y             
                    LDA.W ForestPlatGfxProp,X 
                    STA.W $0303,Y             
                    PHY                       
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W ForestPlatTileSize,X
                    STA.W $0460,Y             
                    PLY                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    LDX $06                   
                    DEX                       
                    BPL ADDR_0386BB           
                    PLX                       
                    LDY.B #$FF                
                    LDA.B #$04                
                    JSL.L FinishOAMWrite      
                    RTS                       ; Return

GrayLavaPlatform:   JSR.W ADDR_03873A         
                    LDA $9D                   
                    BNE Return038733          
                    JSR.W SubOffscreen0Bnk3   
                    LDA.W $1540,X             
                    DEC A                     
                    BNE ADDR_03871B           
                    LDY.W $161A,X             ;  \
                    LDA.B #$00                ;   | Allow sprite to be reloaded by level loading routine
                    STA.W $1938,Y             ;  /
                    STZ.W $14C8,X             
                    RTS                       ; Return

ADDR_03871B:        JSL.L UpdateYPosNoGrvty   
                    JSL.L InvisBlkMainRt      
                    BCC Return038733          
                    LDA.W $1540,X             
                    BNE Return038733          
                    LDA.B #$06                
                    STA $AA,X                 
                    LDA.B #$40                
                    STA.W $1540,X             
Return038733:       RTS                       ; Return

LavaPlatTiles:      .db $85,$86,$85

DATA_038737:        .db $43,$03,$03

ADDR_03873A:        JSR.W GetDrawInfoBnk3     
                    PHX                       
                    LDX.B #$02                
ADDR_038740:        LDA $00                   
                    STA.W $0300,Y             
                    CLC                       
                    ADC.B #$10                
                    STA $00                   
                    LDA $01                   
                    STA.W $0301,Y             
                    LDA.W LavaPlatTiles,X     
                    STA.W $0302,Y             
                    LDA.W DATA_038737,X       
                    ORA $64                   
                    STA.W $0303,Y             
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_038740           
                    PLX                       
                    LDY.B #$02                
                    LDA.B #$02                
                    JSL.L FinishOAMWrite      
                    RTS                       ; Return

MegaMoleSpeed:      .db $10,$F0

MegaMole:           JSR.W MegaMoleGfxRt       ; Graphics routine
                    LDA.W $14C8,X             ; \
                    CMP.B #$08                ;  | If status != 8, return
                    BNE Return038733          ; /
                    JSR.W SubOffscreen3Bnk3   ; Handle off screen situation
                    LDY.W $157C,X             ; \ Set x speed based on direction
                    LDA.W MegaMoleSpeed,Y     ;  |
                    STA $B6,X                 ; /
                    LDA $9D                   ; \ If sprites locked, return
                    BNE Return038733          ; /
                    LDA.W $1588,X             
                    AND.B #$04                
                    PHA                       
                    JSL.L UpdateSpritePos     ; Update position based on speed values
                    JSL.L SprSprInteract      ; Interact with other sprites
                    LDA.W $1588,X             ; \ Branch if not on ground
                    AND.B #$04                ;  |
                    BEQ MegaMoleInAir         ; /
                    STZ $AA,X                 ; Sprite Y Speed = 0
                    PLA                       
                    BRA MegaMoleOnGround      

MegaMoleInAir:      PLA                       
                    BEQ MegaMoleWasInAir      
                    LDA.B #$0A                
                    STA.W $1540,X             
MegaMoleWasInAir:   LDA.W $1540,X             
                    BEQ MegaMoleOnGround      
                    STZ $AA,X                 ; Sprite Y Speed = 0
MegaMoleOnGround:   LDY.W $15AC,X             ; \
                    LDA.W $1588,X             ; | If Mega Mole is in contact with an object...
                    AND.B #$03                ; |
                    BEQ ADDR_0387CD           ; |
                    CPY.B #$00                ; |    ... and timer hasn't been set (time until flip == 0)...
                    BNE ADDR_0387C5           ; |
                    LDA.B #$10                ; |    ... set time until flip
                    STA.W $15AC,X             ; /
ADDR_0387C5:        LDA.W $157C,X             ; \ Flip the temp direction status
                    EOR.B #$01                ; |
                    STA.W $157C,X             ; /
ADDR_0387CD:        CPY.B #$00                ; \ If time until flip == 0...
                    BNE ADDR_0387D7           ; |
                    LDA.W $157C,X             ; |    ...update the direction status used by the gfx routine
                    STA.W $151C,X             ; /
ADDR_0387D7:        JSL.L MarioSprInteract    ; Check for mario/Mega Mole contact
                    BCC Return03882A          ; (Carry set = contact)
                    JSR.W SubVertPosBnk3      
                    LDA $0E                   
                    CMP.B #$D8                
                    BPL MegaMoleContact       
                    LDA $7D                   
                    BMI Return03882A          
                    LDA.B #$01                ; \ Set "on sprite" flag
                    STA.W $1471               ; /
                    LDA.B #$06                ; \ Set riding Mega Mole
                    STA.W $154C,X             ; /
                    STZ $7D                   ; Y speed = 0
                    LDA.B #$D6                ; \
                    LDY.W $187A               ; | Mario's y position += C6 or D6 depending if on yoshi
                    BEQ MegaMoleNoYoshi       ; |
                    LDA.B #$C6                ; |
MegaMoleNoYoshi:    CLC                       ; |
                    ADC $D8,X                 ; |
                    STA $96                   ; |
                    LDA.W $14D4,X             ; |
                    ADC.B #$FF                ; |
                    STA $97                   ; /
                    LDY.B #$00                ; \
                    LDA.W $1491               ; | $1491 == 01 or FF, depending on direction
                    BPL ADDR_038813           ; | Set mario's new x position
                    DEY                       ; |
ADDR_038813:        CLC                       ; |
                    ADC $94                   ; |
                    STA $94                   ; |
                    TYA                       ; |
                    ADC $95                   ; |
                    STA $95                   ;  /
                    RTS                       ; Return

MegaMoleContact:    LDA.W $154C,X             ; \ If riding Mega Mole...
                    ORA.W $15D0,X             ; |   ...or Mega Mole being eaten...
                    BNE Return03882A          ; /   ...return
                    JSL.L HurtMario           ; Hurt mario
Return03882A:       RTS                       ; Final return

MegaMoleTileDispX:  .db $00,$10,$00,$10,$10,$00,$10,$00
MegaMoleTileDispY:  .db $F0,$F0,$00,$00

MegaMoleTiles:      .db $C6,$C8,$E6,$E8,$CA,$CC,$EA,$EC

MegaMoleGfxRt:      JSR.W GetDrawInfoBnk3     
                    LDA.W $151C,X             ; \ $02 = direction
                    STA $02                   ; /
                    LDA $14                   ; \
                    LSR                       ; |
                    LSR                       ; |
                    NOP                       ; |
                    CLC                       ; |
                    ADC.W $15E9               ; |
                    AND.B #$01                ; |
                    ASL                       ; |
                    ASL                       ; |
                    STA $03                   ; | $03 = index to frame start (0 or 4)
                    PHX                       ; /
                    LDX.B #$03                ; Run loop 4 times, cuz 4 tiles per frame
MegaMoleGfxLoopSt:  PHX                       ; Push, current tile
                    LDA $02                   ; \
                    BNE MegaMoleFaceLeft      ; | If facing right, index to frame end += 4
                    INX                       ; |
                    INX                       ; |
                    INX                       ; |
                    INX                       ; /
MegaMoleFaceLeft:   LDA $00                   ; \ Tile x position = sprite x location ($00) + tile displacement
                    CLC                       ; |
                    ADC.W MegaMoleTileDispX,X ; |
                    STA.W $0300,Y             ; /
                    PLX                       ; \ Pull, X = index to frame end
                    LDA $01                   ; |
                    CLC                       ; | Tile y position = sprite y location ($01) + tile displacement
                    ADC.W MegaMoleTileDispY,X ; |
                    STA.W $0301,Y             ; /
                    PHX                       ; \ Set current tile
                    TXA                       ; | X = index of frame start + current tile
                    CLC                       ; |
                    ADC $03                   ; |
                    TAX                       ; |
                    LDA.W MegaMoleTiles,X     ; |
                    STA.W $0302,Y             ; /
                    LDA.B #$01                ; Tile properties xyppccct, format
                    LDX $02                   ; \ If direction == 0...
                    BNE MegaMoleGfxNoFlip     ; |
                    ORA.B #$40                ; /    ...flip tile
MegaMoleGfxNoFlip:  ORA $64                   ; Add in tile priority of level
                    STA.W $0303,Y             ; Store tile properties
                    PLX                       ; \ Pull, current tile
                    INY                       ; | Increase index to sprite tile map ($300)...
                    INY                       ; |    ...we wrote 4 bytes
                    INY                       ; |    ...so increment 4 times
                    INY                       ; |
                    DEX                       ; | Go to next tile of frame and loop
                    BPL MegaMoleGfxLoopSt     ; /
                    PLX                       ; Pull, X = sprite index
                    LDY.B #$02                ; \ Will write 02 to $0460 (all 16x16 tiles)
                    LDA.B #$03                ; | A = number of tiles drawn - 1
                    JSL.L FinishOAMWrite      ; / Don't draw if offscreen
                    RTS                       ; Return

BatTiles:           .db $AE,$C0,$E8

Swooper:            JSL.L GenericSprGfxRt2    
                    LDY.W $15EA,X             ; Y = Index into sprite OAM
                    PHX                       
                    LDA.W $1602,X             
                    TAX                       
                    LDA.W BatTiles,X          
                    STA.W $0302,Y             
                    PLX                       
                    LDA.W $14C8,X             
                    CMP.B #$08                
                    BEQ ADDR_0388C0           
                    JMP.W ADDR_0384EC         

ADDR_0388C0:        LDA $9D                   
                    BNE Return0388DF          
                    JSR.W SubOffscreen0Bnk3   
                    JSL.L SprSpr_MarioSprRts  
                    JSL.L UpdateXPosNoGrvty   
                    JSL.L UpdateYPosNoGrvty   
                    LDA $C2,X                 
                    JSL.L ExecutePtr          

SwooperPtrs:        .dw ADDR_0388E4           
                    .dw ADDR_038905           
                    .dw ADDR_038936           

Return0388DF:       RTS                       ; Return

DATA_0388E0:        .db $10,$F0

DATA_0388E2:        .db $01,$FF

ADDR_0388E4:        LDA.W $15A0,X             
                    BNE Return038904          
                    JSR.W SubHorzPosBnk3      
                    LDA $0F                   
                    CLC                       
                    ADC.B #$50                
                    CMP.B #$A0                
                    BCS Return038904          
                    INC $C2,X                 
                    TYA                       
                    STA.W $157C,X             
                    LDA.B #$20                
                    STA $AA,X                 
                    LDA.B #$26                ; \ Play sound effect
                    STA.W $1DFC               ; /
Return038904:       RTS                       ; Return

ADDR_038905:        LDA $13                   
                    AND.B #$03                
                    BNE ADDR_038915           
                    LDA $AA,X                 
                    BEQ ADDR_038915           
                    DEC $AA,X                 
                    BNE ADDR_038915           
                    INC $C2,X                 
ADDR_038915:        LDA $13                   
                    AND.B #$03                
                    BNE ADDR_03892B           
                    LDY.W $157C,X             
                    LDA $B6,X                 
                    CMP.W DATA_0388E0,Y       
                    BEQ ADDR_03892B           
                    CLC                       
                    ADC.W DATA_0388E2,Y       
                    STA $B6,X                 
ADDR_03892B:        LDA $14                   
                    AND.B #$04                
                    LSR                       
                    LSR                       
                    INC A                     
                    STA.W $1602,X             
                    RTS                       ; Return

ADDR_038936:        LDA $13                   
                    AND.B #$01                
                    BNE ADDR_038952           
                    LDA.W $151C,X             
                    AND.B #$01                
                    TAY                       
                    LDA $AA,X                 
                    CLC                       
                    ADC.W BlurpAccelY,Y       
                    STA $AA,X                 
                    CMP.W BlurpMaxSpeedY,Y    
                    BNE ADDR_038952           
                    INC.W $151C,X             
ADDR_038952:        BRA ADDR_038915           

DATA_038954:        .db $20,$E0

DATA_038956:        .db $02,$FE

SlidingKoopa:       LDA.B #$00                
                    LDY $B6,X                 
                    BEQ ADDR_038964           
                    BPL ADDR_038961           
                    INC A                     
ADDR_038961:        STA.W $157C,X             
ADDR_038964:        JSL.L GenericSprGfxRt2    
                    LDY.W $15EA,X             ; Y = Index into sprite OAM
                    LDA.W $1558,X             
                    CMP.B #$01                
                    BNE ADDR_038983           
                    LDA.W $157C,X             
                    PHA                       
                    LDA.B #$02                
                    STA $9E,X                 
                    JSL.L InitSpriteTables    
                    PLA                       
                    STA.W $157C,X             
                    SEC                       
ADDR_038983:        LDA.B #$86                
                    BCC ADDR_038989           
                    LDA.B #$E0                
ADDR_038989:        STA.W $0302,Y             
                    LDA.W $14C8,X             
                    CMP.B #$08                
                    BNE Return0389FE          
                    JSR.W SubOffscreen0Bnk3   
                    JSL.L SprSpr_MarioSprRts  
                    LDA $9D                   
                    ORA.W $1540,X             
                    ORA.W $1558,X             
                    BNE Return0389FE          
                    JSL.L UpdateSpritePos     
                    LDA.W $1588,X             ; \ Branch if not on ground
                    AND.B #$04                ;  |
                    BEQ Return0389FE          ; /
                    JSR.W ADDR_0389FF         
                    LDY.B #$00                
                    LDA $B6,X                 
                    BEQ ADDR_0389CC           
                    BPL ADDR_0389BD           
                    EOR.B #$FF                
                    INC A                     
ADDR_0389BD:        STA $00                   
                    LDA.W $15B8,X             
                    BEQ ADDR_0389CC           
                    LDY $00                   
                    EOR $B6,X                 
                    BPL ADDR_0389CC           
                    LDY.B #$D0                
ADDR_0389CC:        STY $AA,X                 
                    LDA $13                   
                    AND.B #$01                
                    BNE Return0389FE          
                    LDA.W $15B8,X             
                    BNE ADDR_0389EC           
                    LDA $B6,X                 
                    BNE ADDR_0389E3           
                    LDA.B #$20                
                    STA.W $1558,X             
                    RTS                       ; Return

ADDR_0389E3:        BPL ADDR_0389E9           
                    INC $B6,X                 
                    INC $B6,X                 
ADDR_0389E9:        DEC $B6,X                 
                    RTS                       ; Return

ADDR_0389EC:        ASL                       
                    ROL                       
                    AND.B #$01                
                    TAY                       
                    LDA $B6,X                 
                    CMP.W DATA_038954,Y       
                    BEQ Return0389FE          
                    CLC                       
                    ADC.W DATA_038956,Y       
                    STA $B6,X                 
Return0389FE:       RTS                       ; Return

ADDR_0389FF:        LDA $B6,X                 
                    BEQ Return038A20          
                    LDA $13                   
                    AND.B #$03                
                    BNE Return038A20          
                    LDA.B #$04                
                    STA $00                   
                    LDA.B #$0A                
                    STA $01                   
                    JSR.W IsSprOffScreenBnk3  
                    BNE Return038A20          
                    LDY.B #$03                
ADDR_038A18:        LDA.W $17C0,Y             
                    BEQ ADDR_038A21           
                    DEY                       
                    BPL ADDR_038A18           
Return038A20:       RTS                       ; Return

ADDR_038A21:        LDA.B #$03                
                    STA.W $17C0,Y             
                    LDA $E4,X                 
                    CLC                       
                    ADC $00                   
                    STA.W $17C8,Y             
                    LDA $D8,X                 
                    CLC                       
                    ADC $01                   
                    STA.W $17C4,Y             
                    LDA.B #$13                
                    STA.W $17CC,Y             
                    RTS                       ; Return

BowserStatue:       JSR.W BowserStatueGfx     
                    LDA $9D                   
                    BNE Return038A68          
                    JSR.W SubOffscreen0Bnk3   
                    LDA $C2,X                 
                    JSL.L ExecutePtr          

BowserStatuePtrs:   .dw ADDR_038A57           
                    .dw ADDR_038A54           
                    .dw ADDR_038A69           
                    .dw ADDR_038A54           

ADDR_038A54:        JSR.W ADDR_038ACB         
ADDR_038A57:        JSL.L InvisBlkMainRt      
                    JSL.L UpdateSpritePos     
                    LDA.W $1588,X             ; \ Branch if not on ground
                    AND.B #$04                ;  |
                    BEQ Return038A68          ; /
                    STZ $AA,X                 ; Sprite Y Speed = 0
Return038A68:       RTS                       ; Return

ADDR_038A69:        ASL.W $167A,X             
                    LSR.W $167A,X             
                    JSL.L MarioSprInteract    
                    STZ.W $1602,X             
                    LDA $AA,X                 
                    CMP.B #$10                
                    BPL ADDR_038A7F           
                    INC.W $1602,X             
ADDR_038A7F:        JSL.L UpdateSpritePos     
                    LDA.W $1588,X             ; \ Branch if not touching object
                    AND.B #$03                ;  |
                    BEQ ADDR_038A99           ; /
                    LDA $B6,X                 
                    EOR.B #$FF                
                    INC A                     
                    STA $B6,X                 
                    LDA.W $157C,X             
                    EOR.B #$01                
                    STA.W $157C,X             
ADDR_038A99:        LDA.W $1588,X             ; \ Branch if not on ground
                    AND.B #$04                ;  |
                    BEQ Return038AC6          ; /
                    LDA.B #$10                
                    STA $AA,X                 
                    STZ $B6,X                 ; Sprite X Speed = 0
                    LDA.W $1540,X             
                    BEQ ADDR_038AC1           
                    DEC A                     
                    BNE Return038AC6          
                    LDA.B #$C0                
                    STA $AA,X                 
                    JSR.W SubHorzPosBnk3      
                    TYA                       
                    STA.W $157C,X             
                    LDA.W BwsrStatueSpeed,Y   
                    STA $B6,X                 
                    RTS                       ; Return

BwsrStatueSpeed:    .db $10,$F0

ADDR_038AC1:        LDA.B #$30                
                    STA.W $1540,X             
Return038AC6:       RTS                       ; Return

BwserFireDispXLo:   .db $10,$F0

BwserFireDispXHi:   .db $00,$FF

ADDR_038ACB:        TXA                       
                    ASL                       
                    ASL                       
                    ADC $13                   
                    AND.B #$7F                
                    BNE Return038B24          
                    JSL.L FindFreeSprSlot     ; \ Return if no free slots
                    BMI Return038B24          ; /
                    LDA.B #$17                ; \ Play sound effect
                    STA.W $1DFC               ; /
                    LDA.B #$08                ; \ Sprite status = Normal
                    STA.W $14C8,Y             ; /
                    LDA.B #$B3                ;  \ Sprite = Bowser Statue Fireball
                    STA.W $009E,Y             ;  /
                    LDA $E4,X                 
                    STA $00                   
                    LDA.W $14E0,X             
                    STA $01                   
                    PHX                       
                    LDA.W $157C,X             
                    TAX                       
                    LDA $00                   
                    CLC                       
                    ADC.W BwserFireDispXLo,X  
                    STA.W $00E4,Y             
                    LDA $01                   
                    ADC.W BwserFireDispXHi,X  
                    STA.W $14E0,Y             
                    TYX                       ;  \ Reset sprite tables
                    JSL.L InitSpriteTables    ;   |
                    PLX                       ;  /
                    LDA $D8,X                 
                    SEC                       
                    SBC.B #$02                
                    STA.W $00D8,Y             
                    LDA.W $14D4,X             
                    SBC.B #$00                
                    STA.W $14D4,Y             
                    LDA.W $157C,X             
                    STA.W $157C,Y             
Return038B24:       RTS                       ; Return

BwsrStatueDispX:    .db $08,$F8,$00,$00,$08,$00

BwsrStatueDispY:    .db $10,$F8,$00

BwsrStatueTiles:    .db $56,$30,$41,$56,$30,$35

BwsrStatueTileSize: .db $00,$02,$02

BwsrStatueGfxProp:  .db $00,$00,$00,$40,$40,$40

BowserStatueGfx:    JSR.W GetDrawInfoBnk3     
                    LDA.W $1602,X             
                    STA $04                   
                    EOR.B #$01                
                    DEC A                     
                    STA $03                   
                    LDA.W $15F6,X             
                    STA $05                   
                    LDA.W $157C,X             
                    STA $02                   
                    PHX                       
                    LDX.B #$02                
ADDR_038B57:        PHX                       
                    LDA $02                   
                    BNE ADDR_038B5F           
                    INX                       
                    INX                       
                    INX                       
ADDR_038B5F:        LDA $00                   
                    CLC                       
                    ADC.W BwsrStatueDispX,X   
                    STA.W $0300,Y             
                    LDA.W BwsrStatueGfxProp,X 
                    ORA $05                   
                    ORA $64                   
                    STA.W $0303,Y             
                    PLX                       
                    LDA $01                   
                    CLC                       
                    ADC.W BwsrStatueDispY,X   
                    STA.W $0301,Y             
                    PHX                       
                    LDA $04                   
                    BEQ ADDR_038B84           
                    INX                       
                    INX                       
                    INX                       
ADDR_038B84:        LDA.W BwsrStatueTiles,X   
                    STA.W $0302,Y             
                    PLX                       
                    PHY                       
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W BwsrStatueTileSize,X
                    STA.W $0460,Y             
                    PLY                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    CPX $03                   
                    BNE ADDR_038B57           
                    PLX                       
                    LDY.B #$FF                
                    LDA.B #$02                
                    JSL.L FinishOAMWrite      
                    RTS                       ; Return

DATA_038BAA:        .db $20,$20,$20,$20,$20,$20,$20,$20
                    .db $20,$20,$20,$20,$20,$20,$20,$20
                    .db $20,$1F,$1E,$1D,$1C,$1B,$1A,$19
                    .db $18,$17,$16,$15,$14,$13,$12,$11
                    .db $10,$0F,$0E,$0D,$0C,$0B,$0A,$09
                    .db $08,$07,$06,$05,$04,$03,$02,$01
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $01,$02,$03,$04,$05,$06,$07,$08
                    .db $09,$0A,$0B,$0C,$0D,$0E,$0F,$10
                    .db $11,$12,$13,$14,$15,$16,$17,$18
                    .db $19,$1A,$1B,$1C,$1D,$1E,$1F,$20
                    .db $20,$20,$20,$20,$20,$20,$20,$20
                    .db $20,$20,$20,$20,$20,$20,$20,$20
DATA_038C2A:        .db $00,$F8,$00,$08

Return038C2E:       RTS                       ; Return

CarrotTopLift:      JSR.W CarrotTopLiftGfx    
                    LDA $9D                   
                    BNE Return038C2E          
                    JSR.W SubOffscreen0Bnk3   
                    LDA.W $1540,X             
                    BNE ADDR_038C45           
                    INC $C2,X                 
                    LDA.B #$80                
                    STA.W $1540,X             
ADDR_038C45:        LDA $C2,X                 
                    AND.B #$03                
                    TAY                       
                    LDA.W DATA_038C2A,Y       
                    STA $B6,X                 
                    LDA $B6,X                 
                    LDY $9E,X                 
                    CPY.B #$B8                
                    BEQ ADDR_038C5A           
                    EOR.B #$FF                
                    INC A                     
ADDR_038C5A:        STA $AA,X                 
                    JSL.L UpdateYPosNoGrvty   
                    LDA $E4,X                 
                    STA.W $151C,X             
                    JSL.L UpdateXPosNoGrvty   
                    JSR.W ADDR_038CE4         
                    JSL.L GetSpriteClippingA  
                    JSL.L CheckForContact     
                    BCC Return038CE3          
                    LDA $7D                   
                    BMI Return038CE3          
                    LDA $94                   
                    SEC                       
                    SBC.W $151C,X             
                    CLC                       
                    ADC.B #$1C                
                    LDY $9E,X                 
                    CPY.B #$B8                
                    BNE ADDR_038C8C           
                    CLC                       
                    ADC.B #$38                
ADDR_038C8C:        TAY                       
                    LDA.W $187A               
                    CMP.B #$01                
                    LDA.B #$20                
                    BCC ADDR_038C98           
                    LDA.B #$30                
ADDR_038C98:        CLC                       
                    ADC $96                   
                    STA $00                   
                    LDA $D8,X                 
                    CLC                       
                    ADC.W DATA_038BAA,Y       
                    CMP $00                   
                    BPL Return038CE3          
                    LDA.W $187A               
                    CMP.B #$01                
                    LDA.B #$1D                
                    BCC ADDR_038CB2           
                    LDA.B #$2D                
ADDR_038CB2:        STA $00                   
                    LDA $D8,X                 
                    CLC                       
                    ADC.W DATA_038BAA,Y       
                    PHP                       
                    SEC                       
                    SBC $00                   
                    STA $96                   
                    LDA.W $14D4,X             
                    SBC.B #$00                
                    PLP                       
                    ADC.B #$00                
                    STA $97                   
                    STZ $7D                   
                    LDA.B #$01                
                    STA.W $1471               
                    LDY.B #$00                
                    LDA.W $1491               
                    BPL ADDR_038CD9           
                    DEY                       
ADDR_038CD9:        CLC                       
                    ADC $94                   
                    STA $94                   
                    TYA                       
                    ADC $95                   
                    STA $95                   
Return038CE3:       RTS                       ; Return

ADDR_038CE4:        LDA $94                   
                    CLC                       
                    ADC.B #$04                
                    STA $00                   
                    LDA $95                   
                    ADC.B #$00                
                    STA $08                   
                    LDA.B #$08                
                    STA $02                   
                    STA $03                   
                    LDA.B #$20                
                    LDY.W $187A               
                    BEQ ADDR_038D00           
                    LDA.B #$30                
ADDR_038D00:        CLC                       
                    ADC $96                   
                    STA $01                   
                    LDA $97                   
                    ADC.B #$00                
                    STA $09                   
                    RTS                       ; Return

DiagPlatDispX:      .db $10,$00,$10,$00,$10,$00

DiagPlatDispY:      .db $00,$10,$10,$00,$10,$10

DiagPlatTiles2:     .db $E4,$E0,$E2,$E4,$E0,$E2

DiagPlatGfxProp:    .db $0B,$0B,$0B,$4B,$4B,$4B

CarrotTopLiftGfx:   JSR.W GetDrawInfoBnk3     
                    PHX                       
                    LDA $9E,X                 
                    CMP.B #$B8                
                    LDX.B #$02                
                    STX $02                   
                    BCC ADDR_038D34           
                    LDX.B #$05                
ADDR_038D34:        LDA $00                   
                    CLC                       
                    ADC.W DiagPlatDispX,X     
                    STA.W $0300,Y             
                    LDA $01                   
                    CLC                       
                    ADC.W DiagPlatDispY,X     
                    STA.W $0301,Y             
                    LDA.W DiagPlatTiles2,X    
                    STA.W $0302,Y             
                    LDA.W DiagPlatGfxProp,X   
                    ORA $64                   
                    STA.W $0303,Y             
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    DEC $02                   
                    BPL ADDR_038D34           
                    PLX                       
                    LDY.B #$02                
                    TYA                       
                    JSL.L FinishOAMWrite      
                    RTS                       ; Return

DATA_038D66:        .db $00,$04,$07,$08,$08,$07,$04,$00
                    .db $00

InfoBox:            JSL.L InvisBlkMainRt      
                    JSR.W SubOffscreen0Bnk3   
                    LDA.W $1558,X             
                    CMP.B #$01                
                    BNE ADDR_038D93           
                    LDA.B #$22                ; \ Play sound effect
                    STA.W $1DFC               ; /
                    STZ.W $1558,X             
                    STZ $C2,X                 
                    LDA $E4,X                 
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.B #$01                
                    INC A                     
                    STA.W $1426               
ADDR_038D93:        LDA.W $1558,X             
                    LSR                       
                    TAY                       
                    LDA $1C                   
                    PHA                       
                    CLC                       
                    ADC.W DATA_038D66,Y       
                    STA $1C                   
                    LDA $1D                   
                    PHA                       
                    ADC.B #$00                
                    STA $1D                   
                    JSL.L GenericSprGfxRt2    
                    LDY.W $15EA,X             ; Y = Index into sprite OAM
                    LDA.B #$C0                
                    STA.W $0302,Y             
                    PLA                       
                    STA $1D                   
                    PLA                       
                    STA $1C                   
                    RTS                       ; Return

TimedLift:          JSR.W TimedPlatformGfx    
                    LDA $9D                   
                    BNE Return038DEF          
                    JSR.W SubOffscreen0Bnk3   
                    LDA $13                   
                    AND.B #$00                
                    BNE ADDR_038DD7           
                    LDA $C2,X                 
                    BEQ ADDR_038DD7           
                    LDA.W $1570,X             
                    BEQ ADDR_038DD7           
                    DEC.W $1570,X             
ADDR_038DD7:        LDA.W $1570,X             
                    BEQ ADDR_038DF0           
                    JSL.L UpdateXPosNoGrvty   
                    STA.W $1528,X             
                    JSL.L InvisBlkMainRt      
                    BCC Return038DEF          
                    LDA.B #$10                
                    STA $B6,X                 
                    STA $C2,X                 
Return038DEF:       RTS                       ; Return

ADDR_038DF0:        JSL.L UpdateSpritePos     
                    LDA.W $1491               
                    STA.W $1528,X             
                    JSL.L InvisBlkMainRt      
                    RTS                       ; Return

TimedPlatDispX:     .db $00,$10,$0C

TimedPlatDispY:     .db $00,$00,$04

TimedPlatTiles:     .db $C4,$C4,$00

TimedPlatGfxProp:   .db $0B,$4B,$0B

TimedPlatTileSize:  .db $02,$02,$00

TimedPlatNumTiles:  .db $B6,$B5,$B4,$B3

TimedPlatformGfx:   JSR.W GetDrawInfoBnk3     
                    LDA.W $1570,X             
                    PHX                       
                    PHA                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W TimedPlatNumTiles,X 
                    STA $02                   
                    LDX.B #$02                
                    PLA                       
                    CMP.B #$08                
                    BCS ADDR_038E2E           
                    DEX                       
ADDR_038E2E:        LDA $00                   
                    CLC                       
                    ADC.W TimedPlatDispX,X    
                    STA.W $0300,Y             
                    LDA $01                   
                    CLC                       
                    ADC.W TimedPlatDispY,X    
                    STA.W $0301,Y             
                    LDA.W TimedPlatTiles,X    
                    CPX.B #$02                
                    BNE ADDR_038E49           
                    LDA $02                   
ADDR_038E49:        STA.W $0302,Y             
                    LDA.W TimedPlatGfxProp,X  
                    ORA $64                   
                    STA.W $0303,Y             
                    PHY                       
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W TimedPlatTileSize,X 
                    STA.W $0460,Y             
                    PLY                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_038E2E           
                    PLX                       
                    LDY.B #$FF                
                    LDA.B #$02                
                    JSL.L FinishOAMWrite      
                    RTS                       ; Return

GreyMoveBlkSpeed:   .db $00,$F0,$00,$10

GreyMoveBlkTiming:  .db $40,$50,$40,$50

GreyCastleBlock:    JSR.W ADDR_038EB4         
                    LDA $9D                   
                    BNE Return038EA7          
                    LDA.W $1540,X             
                    BNE ADDR_038E92           
                    INC $C2,X                 
                    LDA $C2,X                 
                    AND.B #$03                
                    TAY                       
                    LDA.W GreyMoveBlkTiming,Y 
                    STA.W $1540,X             
ADDR_038E92:        LDA $C2,X                 
                    AND.B #$03                
                    TAY                       
                    LDA.W GreyMoveBlkSpeed,Y  
                    STA $B6,X                 
                    JSL.L UpdateXPosNoGrvty   
                    STA.W $1528,X             
                    JSL.L InvisBlkMainRt      
Return038EA7:       RTS                       ; Return

GreyMoveBlkDispX:   .db $00,$10,$00,$10

GreyMoveBlkDispY:   .db $00,$00,$10,$10

GreyMoveBlkTiles:   .db $CC,$CE,$EC,$EE

ADDR_038EB4:        JSR.W GetDrawInfoBnk3     
                    PHX                       
                    LDX.B #$03                
ADDR_038EBA:        LDA $00                   
                    CLC                       
                    ADC.W GreyMoveBlkDispX,X  
                    STA.W $0300,Y             
                    LDA $01                   
                    CLC                       
                    ADC.W GreyMoveBlkDispY,X  
                    STA.W $0301,Y             
                    LDA.W GreyMoveBlkTiles,X  
                    STA.W $0302,Y             
                    LDA.B #$03                
                    ORA $64                   
                    STA.W $0303,Y             
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_038EBA           
                    PLX                       
                    LDY.B #$02                
                    LDA.B #$03                
                    JSL.L FinishOAMWrite      
                    RTS                       ; Return

StatueFireSpeed:    .db $10,$F0

StatueFireball:     JSR.W StatueFireballGfx   
                    LDA $9D                   
                    BNE Return038F06          
                    JSR.W SubOffscreen0Bnk3   
                    JSL.L MarioSprInteract    
                    LDY.W $157C,X             
                    LDA.W StatueFireSpeed,Y   
                    STA $B6,X                 
                    JSL.L UpdateXPosNoGrvty   
Return038F06:       RTS                       ; Return

StatueFireDispX:    .db $08,$00,$00,$08

StatueFireTiles:    .db $32,$50,$33,$34,$32,$50,$33,$34
StatueFireGfxProp:  .db $09,$09,$09,$09,$89,$89,$89,$89

StatueFireballGfx:  JSR.W GetDrawInfoBnk3     
                    LDA.W $157C,X             
                    ASL                       
                    STA $02                   
                    LDA $14                   
                    LSR                       
                    AND.B #$03                
                    ASL                       
                    STA $03                   
                    PHX                       
                    LDX.B #$01                
ADDR_038F2F:        LDA $01                   
                    STA.W $0301,Y             
                    PHX                       
                    TXA                       
                    ORA $02                   
                    TAX                       
                    LDA $00                   
                    CLC                       
                    ADC.W StatueFireDispX,X   
                    STA.W $0300,Y             
                    PLA                       
                    PHA                       
                    ORA $03                   
                    TAX                       
                    LDA.W StatueFireTiles,X   
                    STA.W $0302,Y             
                    LDA.W StatueFireGfxProp,X 
                    LDX $02                   
                    BNE ADDR_038F56           
                    EOR.B #$40                
ADDR_038F56:        ORA $64                   
                    STA.W $0303,Y             
                    PLX                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_038F2F           
                    PLX                       
                    LDY.B #$00                
                    LDA.B #$01                
                    JSL.L FinishOAMWrite      
                    RTS                       ; Return

BooStreamFrntTiles: .db $88,$8C,$8E,$A8,$AA,$AE,$88,$8C

ReflectingFireball: JSR.W ADDR_038FF2         
                    BRA ADDR_038FA4           

BooStream:          LDA.B #$00                
                    LDY $B6,X                 
                    BPL ADDR_038F81           
                    INC A                     
ADDR_038F81:        STA.W $157C,X             
                    JSL.L GenericSprGfxRt2    
                    LDY.W $15EA,X             ; Y = Index into sprite OAM
                    LDA $14                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.B #$01                
                    STA $00                   
                    TXA                       
                    AND.B #$03                
                    ASL                       
                    ORA $00                   
                    PHX                       
                    TAX                       
                    LDA.W BooStreamFrntTiles,X
                    STA.W $0302,Y             
                    PLX                       
ADDR_038FA4:        LDA.W $14C8,X             
                    CMP.B #$08                
                    BNE Return038FF1          
                    LDA $9D                   
                    BNE Return038FF1          
                    TXA                       
                    EOR $14                   
                    AND.B #$07                
                    ORA.W $186C,X             
                    BNE ADDR_038FC2           
                    LDA $9E,X                 
                    CMP.B #$B0                
                    BNE ADDR_038FC2           
                    JSR.W ADDR_039020         
ADDR_038FC2:        JSL.L UpdateYPosNoGrvty   
                    JSL.L UpdateXPosNoGrvty   
                    JSL.L ExtSub019138        
                    LDA.W $1588,X             ; \ Branch if not touching object
                    AND.B #$03                ;  |
                    BEQ ADDR_038FDC           ; /
                    LDA $B6,X                 
                    EOR.B #$FF                
                    INC A                     
                    STA $B6,X                 
ADDR_038FDC:        LDA.W $1588,X             
                    AND.B #$0C                
                    BEQ ADDR_038FEA           
                    LDA $AA,X                 
                    EOR.B #$FF                
                    INC A                     
                    STA $AA,X                 
ADDR_038FEA:        JSL.L MarioSprInteract    
                    JSR.W SubOffscreen0Bnk3   
Return038FF1:       RTS                       ; Return

ADDR_038FF2:        JSL.L GenericSprGfxRt2    
                    LDA $14                   
                    LSR                       
                    LSR                       
                    LDA.B #$04                
                    BCC ADDR_038FFF           
                    ASL                       
ADDR_038FFF:        LDY $B6,X                 
                    BPL ADDR_039005           
                    EOR.B #$40                
ADDR_039005:        LDY $AA,X                 
                    BMI ADDR_03900B           
                    EOR.B #$80                
ADDR_03900B:        STA $00                   
                    LDY.W $15EA,X             ; Y = Index into sprite OAM
                    LDA.B #$AC                
                    STA.W $0302,Y             
                    LDA.W $0303,Y             
                    AND.B #$31                
                    ORA $00                   
                    STA.W $0303,Y             
                    RTS                       ; Return

ADDR_039020:        LDY.B #$0B                
ADDR_039022:        LDA.W $17F0,Y             
                    BEQ ADDR_039037           
                    DEY                       
                    BPL ADDR_039022           
                    DEC.W $185D               
                    BPL ADDR_039034           
                    LDA.B #$0B                
                    STA.W $185D               
ADDR_039034:        LDY.W $185D               
ADDR_039037:        LDA.B #$0A                
                    STA.W $17F0,Y             
                    LDA $E4,X                 
                    STA.W $1808,Y             
                    LDA.W $14E0,X             
                    STA.W $18EA,Y             
                    LDA $D8,X                 
                    STA.W $17FC,Y             
                    LDA.W $14D4,X             
                    STA.W $1814,Y             
                    LDA.B #$30                
                    STA.W $1850,Y             
                    LDA $B6,X                 
                    STA.W $182C,Y             
                    RTS                       ; Return

FishinBooAccelX:    .db $01,$FF

FishinBooMaxSpeedX: .db $20,$E0

FishinBooAccelY:    .db $01,$FF

FishinBooMaxSpeedY: .db $10,$F0

FishinBoo:          JSR.W FishinBooGfx        
                    LDA $9D                   
                    BNE Return0390EA          
                    JSL.L MarioSprInteract    
                    JSR.W SubHorzPosBnk3      
                    STZ.W $1602,X             
                    LDA.W $15AC,X             
                    BEQ ADDR_039086           
                    INC.W $1602,X             
                    CMP.B #$10                
                    BNE ADDR_039086           
                    TYA                       
                    STA.W $157C,X             
ADDR_039086:        TXA                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ADC $13                   
                    AND.B #$3F                
                    ORA.W $15AC,X             
                    BNE ADDR_039099           
                    LDA.B #$20                
                    STA.W $15AC,X             
ADDR_039099:        LDA.W $18BF               
                    BEQ ADDR_0390A2           
                    TYA                       
                    EOR.B #$01                
                    TAY                       
ADDR_0390A2:        LDA $B6,X                 ; \ If not at max X speed, accelerate
                    CMP.W FishinBooMaxSpeedX,Y;  |
                    BEQ ADDR_0390AF           ;  |
                    CLC                       ;  |
                    ADC.W FishinBooAccelX,Y   ;  |
                    STA $B6,X                 ; /
ADDR_0390AF:        LDA $13                   
                    AND.B #$01                
                    BNE ADDR_0390C9           
                    LDA $C2,X                 
                    AND.B #$01                
                    TAY                       
                    LDA $AA,X                 
                    CLC                       
                    ADC.W FishinBooAccelY,Y   
                    STA $AA,X                 
                    CMP.W FishinBooMaxSpeedY,Y
                    BNE ADDR_0390C9           
                    INC $C2,X                 
ADDR_0390C9:        LDA $B6,X                 
                    PHA                       
                    LDY.W $18BF               
                    BNE ADDR_0390DC           
                    LDA.W $17BD               
                    ASL                       
                    ASL                       
                    ASL                       
                    CLC                       
                    ADC $B6,X                 
                    STA $B6,X                 
ADDR_0390DC:        JSL.L UpdateXPosNoGrvty   
                    PLA                       
                    STA $B6,X                 
                    JSL.L UpdateYPosNoGrvty   
                    JSR.W ADDR_0390F3         
Return0390EA:       RTS                       ; Return

DATA_0390EB:        .db $1A,$14,$EE,$F8

DATA_0390EF:        .db $00,$00,$FF,$FF

ADDR_0390F3:        LDA.W $157C,X             
                    ASL                       
                    ADC.W $1602,X             
                    TAY                       
                    LDA $E4,X                 
                    CLC                       
                    ADC.W DATA_0390EB,Y       
                    STA $04                   
                    LDA.W $14E0,X             
                    ADC.W DATA_0390EF,Y       
                    STA $0A                   
                    LDA.B #$04                
                    STA $06                   
                    STA $07                   
                    LDA $D8,X                 
                    CLC                       
                    ADC.B #$47                
                    STA $05                   
                    LDA.W $14D4,X             
                    ADC.B #$00                
                    STA $0B                   
                    JSL.L GetMarioClipping    
                    JSL.L CheckForContact     
                    BCC Return03912D          
                    JSL.L HurtMario           
Return03912D:       RTS                       ; Return

FishinBooDispX:     .db $FB,$05,$00,$F2,$FD,$03,$EA,$EA
                    .db $EA,$EA,$FB,$05,$00,$FA,$FD,$03
                    .db $F2,$F2,$F2,$F2,$FB,$05,$00,$0E
                    .db $03,$FD,$16,$16,$16,$16,$FB,$05
                    .db $00,$06,$03,$FD,$0E,$0E,$0E,$0E
FishinBooDispY:     .db $0B,$0B,$00,$03,$0F,$0F,$13,$23
                    .db $33,$43

FishinBooTiles1:    .db $60,$60,$64,$8A,$60,$60,$AC,$AC
                    .db $AC,$CE

FishinBooGfxProp:   .db $04,$04,$0D,$09,$04,$04,$0D,$0D
                    .db $0D,$07

FishinBooTiles2:    .db $CC,$CE,$CC,$CE

DATA_039178:        .db $00,$00,$40,$40

DATA_03917C:        .db $00,$40,$C0,$80

FishinBooGfx:       JSR.W GetDrawInfoBnk3     
                    LDA.W $1602,X             
                    STA $04                   
                    LDA.W $157C,X             
                    STA $02                   
                    PHX                       
                    PHY                       
                    LDX.B #$09                
ADDR_039191:        LDA $01                   
                    CLC                       
                    ADC.W FishinBooDispY,X    
                    STA.W $0301,Y             
                    STZ $03                   
                    LDA.W FishinBooTiles1,X   
                    CPX.B #$09                
                    BNE ADDR_0391B4           
                    LDA $14                   
                    LSR                       
                    LSR                       
                    PHX                       
                    AND.B #$03                
                    TAX                       
                    LDA.W DATA_039178,X       
                    STA $03                   
                    LDA.W FishinBooTiles2,X   
                    PLX                       
ADDR_0391B4:        STA.W $0302,Y             
                    LDA $02                   
                    CMP.B #$01                
                    LDA.W FishinBooGfxProp,X  
                    EOR $03                   
                    ORA $64                   
                    BCS ADDR_0391C6           
                    EOR.B #$40                
ADDR_0391C6:        STA.W $0303,Y             
                    PHX                       
                    LDA $04                   
                    BEQ ADDR_0391D3           
                    TXA                       
                    CLC                       
                    ADC.B #$0A                
                    TAX                       
ADDR_0391D3:        LDA $02                   
                    BNE ADDR_0391DC           
                    TXA                       
                    CLC                       
                    ADC.B #$14                
                    TAX                       
ADDR_0391DC:        LDA $00                   
                    CLC                       
                    ADC.W FishinBooDispX,X    
                    STA.W $0300,Y             
                    PLX                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_039191           
                    LDA $14                   
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.B #$03                
                    TAX                       
                    PLY                       
                    LDA.W DATA_03917C,X       
                    EOR.W $0313,Y             
                    STA.W $0313,Y             
                    STA.W $0327,Y             
                    EOR.B #$C0                
                    STA.W $0317,Y             
                    STA.W $0323,Y             
                    PLX                       
                    LDY.B #$02                
                    LDA.B #$09                
                    JSL.L FinishOAMWrite      
                    RTS                       ; Return

FallingSpike:       JSL.L GenericSprGfxRt2    
                    LDY.W $15EA,X             ; Y = Index into sprite OAM
                    LDA.B #$E0                
                    STA.W $0302,Y             
                    LDA.W $0301,Y             
                    DEC A                     
                    STA.W $0301,Y             
                    LDA.W $1540,X             
                    BEQ ADDR_039237           
                    LSR                       
                    LSR                       
                    AND.B #$01                
                    CLC                       
                    ADC.W $0300,Y             
                    STA.W $0300,Y             
ADDR_039237:        LDA $9D                   
                    BNE ADDR_03926C           
                    JSR.W SubOffscreen0Bnk3   
                    JSL.L UpdateSpritePos     
                    LDA $C2,X                 
                    JSL.L ExecutePtr          

FallingSpikePtrs:   .dw ADDR_03924C           
                    .dw ADDR_039262           

ADDR_03924C:        STZ $AA,X                 ; Sprite Y Speed = 0
                    JSR.W SubHorzPosBnk3      
                    LDA $0F                   
                    CLC                       
                    ADC.B #$40                
                    CMP.B #$80                
                    BCS Return039261          
                    INC $C2,X                 
                    LDA.B #$40                
                    STA.W $1540,X             
Return039261:       RTS                       ; Return

ADDR_039262:        LDA.W $1540,X             
                    BNE ADDR_03926C           
                    JSL.L MarioSprInteract    
                    RTS                       ; Return

ADDR_03926C:        STZ $AA,X                 ; Sprite Y Speed = 0
                    RTS                       ; Return

CrtEatBlkSpeedX:    .db $10,$F0,$00,$00,$00

CrtEatBlkSpeedY:    .db $00,$00,$10,$F0,$00

DATA_039279:        .db $00,$00,$01,$00,$02,$00,$00,$00
                    .db $03,$00,$00

CreateEatBlock:     JSL.L GenericSprGfxRt2    
                    LDY.W $15EA,X             ; Y = Index into sprite OAM
                    LDA.W $0301,Y             
                    DEC A                     
                    STA.W $0301,Y             
                    LDA.B #$2E                
                    STA.W $0302,Y             
                    LDA.W $0303,Y             
                    AND.B #$3F                
                    STA.W $0303,Y             
                    LDY.B #$02                
                    LDA.B #$00                
                    JSL.L FinishOAMWrite      
                    LDY.B #$04                
                    LDA.W $1909               
                    CMP.B #$FF                
                    BEQ ADDR_0392C0           
                    LDA $13                   
                    AND.B #$03                
                    ORA $9D                   
                    BNE ADDR_0392BD           
                    LDA.B #$04                ; \ Play sound effect
                    STA.W $1DFA               ; /
ADDR_0392BD:        LDY.W $157C,X             
ADDR_0392C0:        LDA $9D                   
                    BNE Return03932B          
                    LDA.W CrtEatBlkSpeedX,Y   
                    STA $B6,X                 
                    LDA.W CrtEatBlkSpeedY,Y   
                    STA $AA,X                 
                    JSL.L UpdateYPosNoGrvty   
                    JSL.L UpdateXPosNoGrvty   
                    STZ.W $1528,X             
                    JSL.L InvisBlkMainRt      
                    LDA.W $1909               
                    CMP.B #$FF                
                    BEQ Return03932B          
                    LDA $D8,X                 
                    ORA $E4,X                 
                    AND.B #$0F                
                    BNE Return03932B          
                    LDA.W $151C,X             
                    BNE ADDR_03932C           
                    DEC.W $1570,X             
                    BMI ADDR_0392F8           
                    BNE ADDR_03931F           
ADDR_0392F8:        LDY.W $0DB3               
                    LDA.W $1F11,Y             
                    CMP.B #$01                
                    LDY.W $1534,X             
                    INC.W $1534,X             
                    LDA.W CrtEatBlkData1,Y    
                    BCS ADDR_03930E           
                    LDA.W CrtEatBlkData2,Y    
ADDR_03930E:        STA.W $1602,X             
                    PHA                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    STA.W $1570,X             
                    PLA                       
                    AND.B #$03                
                    STA.W $157C,X             
ADDR_03931F:        LDA.B #$0D                
                    JSR.W GenTileFromSpr1     
                    LDA.W $1602,X             
                    CMP.B #$FF                
                    BEQ ADDR_039387           
Return03932B:       RTS                       ; Return

ADDR_03932C:        LDA.B #$02                
                    JSR.W GenTileFromSpr1     
                    LDA.B #$01                
                    STA $B6,X                 
                    STA $AA,X                 
                    JSL.L ExtSub019138        
                    LDA.W $1588,X             
                    PHA                       
                    LDA.B #$FF                
                    STA $B6,X                 
                    STA $AA,X                 
                    LDA $E4,X                 
                    PHA                       
                    SEC                       
                    SBC.B #$01                
                    STA $E4,X                 
                    LDA.W $14E0,X             
                    PHA                       
                    SBC.B #$00                
                    STA.W $14E0,X             
                    LDA $D8,X                 
                    PHA                       
                    SEC                       
                    SBC.B #$01                
                    STA $D8,X                 
                    LDA.W $14D4,X             
                    PHA                       
                    SBC.B #$00                
                    STA.W $14D4,X             
                    JSL.L ExtSub019138        
                    PLA                       
                    STA.W $14D4,X             
                    PLA                       
                    STA $D8,X                 
                    PLA                       
                    STA.W $14E0,X             
                    PLA                       
                    STA $E4,X                 
                    PLA                       
                    ORA.W $1588,X             
                    BEQ ADDR_039387           
                    TAY                       
                    LDA.W DATA_039279,Y       
                    STA.W $157C,X             
                    RTS                       ; Return

ADDR_039387:        STZ.W $14C8,X             
                    RTS                       ; Return

GenTileFromSpr1:    STA $9C                   ; $9C = tile to generate
                    LDA $E4,X                 ; \ $9A = Sprite X position
                    STA $9A                   ;  | for block creation
                    LDA.W $14E0,X             ;  |
                    STA $9B                   ; /
                    LDA $D8,X                 ; \ $98 = Sprite Y position
                    STA $98                   ;  | for block creation
                    LDA.W $14D4,X             ;  |
                    STA $99                   ; /
                    JSL.L GenerateTile        ; Generate the tile
                    RTS                       ; Return

CrtEatBlkData1:     .db $10,$13,$10,$13,$10,$13,$10,$13
                    .db $10,$13,$10,$13,$10,$13,$10,$13
                    .db $F0,$F0,$20,$12,$10,$12,$10,$12
                    .db $10,$12,$10,$12,$10,$12,$10,$12
                    .db $D0,$C3,$F1,$21,$22,$F1,$F1,$51
                    .db $43,$10,$13,$10,$13,$10,$13,$F0
                    .db $F0,$F0,$60,$32,$60,$32,$71,$32
                    .db $60,$32,$61,$32,$70,$33,$10,$33
                    .db $10,$33,$10,$33,$10,$33,$F0,$10
                    .db $F2,$52,$FF

CrtEatBlkData2:     .db $80,$13,$10,$13,$10,$13,$10,$13
                    .db $60,$23,$20,$23,$B0,$22,$A1,$22
                    .db $A0,$22,$A1,$22,$C0,$13,$10,$13
                    .db $10,$13,$10,$13,$10,$13,$10,$13
                    .db $10,$13,$F0,$F0,$F0,$52,$50,$33
                    .db $50,$32,$50,$33,$50,$22,$50,$33
                    .db $F0,$50,$82,$FF

WoodenSpike:        JSR.W WoodSpikeGfx        
                    LDA $9D                   
                    BNE Return039440          
                    JSR.W SubOffscreen0Bnk3   
                    JSR.W ADDR_039488         
                    LDA $C2,X                 
                    AND.B #$03                
                    JSL.L ExecutePtr          

WoodenSpikePtrs:    .dw ADDR_039458           
                    .dw ADDR_03944E           
                    .dw ADDR_039441           
                    .dw ADDR_03946B           

Return039440:       RTS                       ; Return

ADDR_039441:        LDA.W $1540,X             
                    BEQ ADDR_03944A           
                    LDA.B #$20                
                    BRA ADDR_039475           

ADDR_03944A:        LDA.B #$30                
                    BRA SetTimerNextState     

ADDR_03944E:        LDA.W $1540,X             
                    BNE Return039457          
                    LDA.B #$18                
                    BRA SetTimerNextState     

Return039457:       RTS                       ; Return

ADDR_039458:        LDA.W $1540,X             
                    BEQ ADDR_039463           
                    LDA.B #$F0                
                    JSR.W ADDR_039475         
                    RTS                       ; Return

ADDR_039463:        LDA.B #$30                
SetTimerNextState:  STA.W $1540,X             
                    INC $C2,X                 ; Goto next state
                    RTS                       ; Return

ADDR_03946B:        LDA.W $1540,X             ; \ If stall timer us up,
                    BNE Return039474          ;  | reset it to #$2F...
                    LDA.B #$2F                ;  |
                    BRA SetTimerNextState     ;  | ...and goto next state

Return039474:       RTS                       ; /

ADDR_039475:        LDY.W $151C,X             
                    BEQ ADDR_03947D           
                    EOR.B #$FF                
                    INC A                     
ADDR_03947D:        STA $AA,X                 
                    JSL.L UpdateYPosNoGrvty   
                    RTS                       ; Return

DATA_039484:        .db $01,$FF

DATA_039486:        .db $00,$FF

ADDR_039488:        JSL.L MarioSprInteract    
                    BCC Return0394B0          
                    JSR.W SubHorzPosBnk3      
                    LDA $0F                   
                    CLC                       
                    ADC.B #$04                
                    CMP.B #$08                
                    BCS ADDR_03949F           
                    JSL.L HurtMario           
                    RTS                       ; Return

ADDR_03949F:        LDA $94                   
                    CLC                       
                    ADC.W DATA_039484,Y       
                    STA $94                   
                    LDA $95                   
                    ADC.W DATA_039486,Y       
                    STA $95                   
                    STZ $7B                   
Return0394B0:       RTS                       ; Return

WoodSpikeDispY:     .db $00,$10,$20,$30,$40,$40,$30,$20
                    .db $10,$00

WoodSpikeTiles:     .db $6A,$6A,$6A,$6A,$4A,$6A,$6A,$6A
                    .db $6A,$4A

WoodSpikeGfxProp:   .db $81,$81,$81,$81,$81,$01,$01,$01
                    .db $01,$01

WoodSpikeGfx:       JSR.W GetDrawInfoBnk3     
                    STZ $02                   ; \ Set $02 based on sprite number
                    LDA $9E,X                 ;  |
                    CMP.B #$AD                ;  |
                    BNE ADDR_0394DE           ;  |
                    LDA.B #$05                ;  |
                    STA $02                   ; /
ADDR_0394DE:        PHX                       
                    LDX.B #$04                ; Draw 4 tiles:
WoodSpikeGfxLoopSt: PHX                       
                    TXA                       
                    CLC                       
                    ADC $02                   
                    TAX                       
                    LDA $00                   ; \ Set X
                    STA.W $0300,Y             ; /
                    LDA $01                   ; \ Set Y
                    CLC                       ;  |
                    ADC.W WoodSpikeDispY,X    ;  |
                    STA.W $0301,Y             ; /
                    LDA.W WoodSpikeTiles,X    ; \ Set tile
                    STA.W $0302,Y             ; /
                    LDA.W WoodSpikeGfxProp,X  ; \ Set gfs properties
                    STA.W $0303,Y             ; /
                    INY                       ; \ We wrote 4 times, so increase index by 4
                    INY                       ;  |
                    INY                       ;  |
                    INY                       ; /
                    PLX                       
                    DEX                       
                    BPL WoodSpikeGfxLoopSt    
                    PLX                       
                    LDY.B #$02                ; \ Wrote 5 16x16 tiles...
                    LDA.B #$04                ;  |
                    JSL.L FinishOAMWrite      ; /
                    RTS                       ; Return

RexSpeed:           .db $08,$F8,$10,$F0

RexMainRt:          JSR.W RexGfxRt            ; Draw Rex gfx
                    LDA.W $14C8,X             ; \ If Rex status != 8...
                    CMP.B #$08                ;  |   ... not (killed with spin jump [4] or star [2])
                    BNE Return039533          ; /    ... return
                    LDA $9D                   ; \ If sprites locked...
                    BNE Return039533          ; /    ... return
                    LDA.W $1558,X             ; \ If Rex not defeated (timer to show remains > 0)...
                    BEQ RexAlive              ; /    ... goto RexAlive
                    STA.W $15D0,X             ; \
                    DEC A                     ;  |   If Rex remains don't disappear next frame...
                    BNE Return039533          ; /    ... return
                    STZ.W $14C8,X             ; This is the last frame to show remains, so set Rex status = 0
Return039533:       RTS                       ; Return

RexAlive:           JSR.W SubOffscreen0Bnk3   ; Only process Rex while on screen
                    INC.W $1570,X             ; Increment number of frames Rex has been on sc
                    LDA.W $1570,X             ; \ Calculate which frame to show:
                    LSR                       ;  |
                    LSR                       ;  |
                    LDY $C2,X                 ;  | Number of hits determines if smushed
                    BEQ ADDR_03954A           ;  |
                    AND.B #$01                ;  | Update every 8 cycles if smushed
                    CLC                       ;  |
                    ADC.B #$03                ;  | Show smushed frame
                    BRA ADDR_03954D           ;  |

ADDR_03954A:        LSR                       ;  |
                    AND.B #$01                ;  | Update every 16 cycles if normal
ADDR_03954D:        STA.W $1602,X             ; / Write frame to show
                    LDA.W $1588,X             ; \  If sprite is not on ground...
                    AND.B #$04                ;  |    ...(4 = on ground) ...
                    BEQ RexInAir              ; /     ...goto IN_AIR
                    LDA.B #$10                ; \  Y speed = 10
                    STA $AA,X                 ; /
                    LDY.W $157C,X             ; Load, y = Rex direction, as index for speed
                    LDA $C2,X                 ; \ If hits on Rex == 0...
                    BEQ RexNoAdjustSpeed      ; /    ...goto DONT_ADJUST_SPEED
                    INY                       ; \ Increment y twice...
                    INY                       ; /    ...in order to get speed for smushed Rex
RexNoAdjustSpeed:   LDA.W RexSpeed,Y          ; \ Load x speed from ROM...
                    STA $B6,X                 ; /    ...and store it
RexInAir:           LDA.W $1FE2,X             ; \ If time to show half-smushed Rex > 0...
                    BNE RexHalfSmushed        ; /    ...goto HALF_SMUSHED
                    JSL.L UpdateSpritePos     ; Update position based on speed values
RexHalfSmushed:     LDA.W $1588,X             ; \ If Rex is touching the side of an object...
                    AND.B #$03                ;  |
                    BEQ ADDR_039581           ;  |
                    LDA.W $157C,X             ;  |
                    EOR.B #$01                ;  |    ... change Rex direction
                    STA.W $157C,X             ; /
ADDR_039581:        JSL.L SprSprInteract      ; Interact with other sprites
                    JSL.L MarioSprInteract    ; Check for mario/Rex contact
                    BCC NoRexContact          ; (carry set = mario/Rex contact)
                    LDA.W $1490               ; \ If mario star timer > 0 ...
                    BNE RexStarKill           ; /    ... goto HAS_STAR
                    LDA.W $154C,X             ; \ If Rex invincibility timer > 0 ...
                    BNE NoRexContact          ; /    ... goto NO_CONTACT
                    LDA.B #$08                ; \ Rex invincibility timer = $08
                    STA.W $154C,X             ; /
                    LDA $7D                   ; \  If mario's y speed < 10 ...
                    CMP.B #$10                ;  |   ... Rex will hurt mario
                    BMI RexWins               ; /
MarioBeatsRex:      JSR.W RexPoints           ; Give mario points
                    JSL.L BoostMarioSpeed     ; Set mario speed
                    JSL.L DisplayContactGfx   ; Display contact graphic
                    LDA.W $140D               ; \  If mario is spin jumping...
                    ORA.W $187A               ;  |    ... or on yoshi ...
                    BNE RexSpinKill           ; /     ... goto SPIN_KILL
                    INC $C2,X                 ; Increment Rex hit counter
                    LDA $C2,X                 ; \  If Rex hit counter == 2
                    CMP.B #$02                ;  |
                    BNE SmushRex              ;  |
                    LDA.B #$20                ;  |    ... time to show defeated Rex = $20
                    STA.W $1558,X             ; /
                    RTS                       ; Return

SmushRex:           LDA.B #$0C                ; \ Time to show semi-squashed Rex = $0C
                    STA.W $1FE2,X             ; /
                    STZ.W $1662,X             ; Change clipping area for squashed Rex
                    RTS                       ; Return

RexWins:            LDA.W $1497               ; \ If mario is invincible...
                    ORA.W $187A               ;  |  ... or mario on yoshi...
                    BNE NoRexContact          ; /   ... return
                    JSR.W SubHorzPosBnk3      ; \  Set new Rex direction
                    TYA                       ;  |
                    STA.W $157C,X             ; /
                    JSL.L HurtMario           ; Hurt mario
NoRexContact:       RTS                       ; Return

RexSpinKill:        LDA.B #$04                ; \ Rex status = 4 (being killed by spin jump)
                    STA.W $14C8,X             ; /
                    LDA.B #$1F                ; \ Set spin jump animation timer
                    STA.W $1540,X             ; /
                    JSL.L ExtSub07FC3B        ; Show star animation
                    LDA.B #$08                ; \
                    STA.W $1DF9               ; / Play sound effect
                    RTS                       ; Return

RexStarKill:        LDA.B #$02                ; \ Rex status = 2 (being killed by star)
                    STA.W $14C8,X             ; /
                    LDA.B #$D0                ; \ Set y speed
                    STA $AA,X                 ; /
                    JSR.W SubHorzPosBnk3      ; Get new Rex direction
                    LDA.W RexKilledSpeed,Y    ; \ Set x speed based on Rex direction
                    STA $B6,X                 ; /
                    INC.W $18D2               ; Increment number consecutive enemies killed
                    LDA.W $18D2               ; \
                    CMP.B #$08                ;  | If consecutive enemies stomped >= 8, reset to 8
                    BCC ADDR_039612           ;  |
                    LDA.B #$08                ;  |
                    STA.W $18D2               ; /
ADDR_039612:        JSL.L GivePoints          ; Give mario points
                    LDY.W $18D2               ; \
                    CPY.B #$08                ;  | If consecutive enemies stomped < 8 ...
                    BCS Return039623          ;  |
                    LDA.W $7FFF,Y             ;  |    ... play sound effect
                    STA.W $1DF9               ; /
Return039623:       RTS                       ; Return

                    RTS                       

RexKilledSpeed:     .db $F0,$10

                    RTS                       

RexPoints:          PHY                       
                    LDA.W $1697               
                    CLC                       
                    ADC.W $1626,X             
                    INC.W $1697               ; Increase consecutive enemies stomped
                    TAY                       
                    INY                       
                    CPY.B #$08                ; \ If consecutive enemies stomped >= 8 ...
                    BCS ADDR_03963F           ; /    ... don't play sound
                    LDA.W $7FFF,Y             ; \
                    STA.W $1DF9               ; / Play sound effect
ADDR_03963F:        TYA                       ; \
                    CMP.B #$08                ;  | If consecutive enemies stomped >= 8, reset to 8
                    BCC ADDR_039646           ;  |
                    LDA.B #$08                ; /
ADDR_039646:        JSL.L GivePoints          ; Give mario points
                    PLY                       
                    RTS                       ; Return

RexTileDispX:       .db $FC,$00,$FC,$00,$FE,$00,$00,$00
                    .db $00,$00,$00,$08,$04,$00,$04,$00
                    .db $02,$00,$00,$00,$00,$00,$08,$00
RexTileDispY:       .db $F1,$00,$F0,$00,$F8,$00,$00,$00
                    .db $00,$00,$08,$08

RexTiles:           .db $8A,$AA,$8A,$AC,$8A,$AA,$8C,$8C
                    .db $A8,$A8,$A2,$B2

RexGfxProp:         .db $47,$07

RexGfxRt:           LDA.W $1558,X             ; \ If time to show Rex remains > 0...
                    BEQ RexGfxAlive           ;  |
                    LDA.B #$05                ;  |    ...set Rex frame = 5 (fully squashed)
                    STA.W $1602,X             ; /
RexGfxAlive:        LDA.W $1FE2,X             ; \ If time to show half smushed Rex > 0...
                    BEQ RexNotHalfSmushed     ;  |
                    LDA.B #$02                ;  |    ...set Rex frame = 2 (half smushed)
                    STA.W $1602,X             ; /
RexNotHalfSmushed:  JSR.W GetDrawInfoBnk3     ; Y = index to sprite tile map, $00 = sprite x, $01 = sprite y
                    LDA.W $1602,X             ; \
                    ASL                       ;  | $03 = index to frame start (frame to show * 2 tile per frame)
                    STA $03                   ; /
                    LDA.W $157C,X             ; \ $02 = sprite direction
                    STA $02                   ; /
                    PHX                       ; Push sprite index
                    LDX.B #$01                ; Loop counter = (number of tiles per frame) - 1
RexGfxLoopStart:    PHX                       ; Push current tile number
                    TXA                       ; \ X = index to horizontal displacement
                    ORA $03                   ; / get index of tile (index to first tile of frame + current tile number)
                    PHA                       ; Push index of current tile
                    LDX $02                   ; \ If facing right...
                    BNE RexFaceLeft           ;  |
                    CLC                       ;  |
                    ADC.B #$0C                ; /    ...use row 2 of horizontal tile displacement table
RexFaceLeft:        TAX                       ; \
                    LDA $00                   ;  | Tile x position = sprite x location ($00) + tile displacement
                    CLC                       ;  |
                    ADC.W RexTileDispX,X      ;  |
                    STA.W $0300,Y             ; /
                    PLX                       ; \ Pull, X = index to vertical displacement and tilemap
                    LDA $01                   ;  | Tile y position = sprite y location ($01) + tile displacement
                    CLC                       ;  |
                    ADC.W RexTileDispY,X      ;  |
                    STA.W $0301,Y             ; /
                    LDA.W RexTiles,X          ; \ Store tile
                    STA.W $0302,Y             ; /
                    LDX $02                   ; \
                    LDA.W RexGfxProp,X        ;  | Get tile properties using sprite direction
                    ORA $64                   ;  | Level properties
                    STA.W $0303,Y             ; / Store tile properties
                    TYA                       ; \ Get index to sprite property map ($460)...
                    LSR                       ;  |    ...we use the sprite OAM index...
                    LSR                       ;  |    ...and divide by 4 because a 16x16 tile is 4 8x8 tiles
                    LDX $03                   ;  | If index of frame start is > 0A
                    CPX.B #$0A                ;  |
                    TAX                       ;  |
                    LDA.B #$00                ;  |     ...show only an 8x8 tile
                    BCS Rex8x8Tile            ;  |
                    LDA.B #$02                ;  | Else show a full 16 x 16 tile
Rex8x8Tile:         STA.W $0460,X             ; /
                    PLX                       ; \ Pull, X = current tile of the frame we're drawing
                    INY                       ;  | Increase index to sprite tile map ($300)...
                    INY                       ;  |    ...we wrote 4 times...
                    INY                       ;  |    ...so increment 4 times
                    INY                       ;  |
                    DEX                       ;  | Go to next tile of frame and loop
                    BPL RexGfxLoopStart       ; /
                    PLX                       ; Pull, X = sprite index
                    LDY.B #$FF                ; \ FF because we already wrote size to $0460
                    LDA.B #$01                ;  | A = number of tiles drawn - 1
                    JSL.L FinishOAMWrite      ; / Don't draw if offscreen
                    RTS                       ; Return

Fishbone:           JSR.W FishboneGfx         
                    LDA $9D                   
                    BNE Return03972A          
                    JSR.W SubOffscreen0Bnk3   
                    JSL.L MarioSprInteract    
                    JSL.L UpdateXPosNoGrvty   
                    TXA                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ADC $13                   
                    AND.B #$7F                
                    BNE ADDR_039720           
                    JSL.L GetRand             
                    AND.B #$01                
                    BNE ADDR_039720           
                    LDA.B #$0C                
                    STA.W $1558,X             
ADDR_039720:        LDA $C2,X                 
                    JSL.L ExecutePtr          

FishbonePtrs:       .dw ADDR_03972F           
                    .dw ADDR_03975E           

Return03972A:       RTS                       ; Return

FishboneMaxSpeed:   .db $10,$F0

FishboneAcceler:    .db $01,$FF

ADDR_03972F:        INC.W $1570,X             
                    LDA.W $1570,X             
                    NOP                       
                    LSR                       
                    AND.B #$01                
                    STA.W $1602,X             
                    LDA.W $1540,X             
                    BEQ ADDR_039756           
                    AND.B #$01                
                    BNE Return039755          
                    LDY.W $157C,X             
                    LDA $B6,X                 
                    CMP.W FishboneMaxSpeed,Y  
                    BEQ Return039755          
                    CLC                       
                    ADC.W FishboneAcceler,Y   
                    STA $B6,X                 
Return039755:       RTS                       ; Return

ADDR_039756:        INC $C2,X                 
                    LDA.B #$30                
                    STA.W $1540,X             
                    RTS                       ; Return

ADDR_03975E:        STZ.W $1602,X             
                    LDA.W $1540,X             
                    BEQ ADDR_039776           
                    AND.B #$03                
                    BNE Return039775          
                    LDA $B6,X                 
                    BEQ Return039775          
                    BPL ADDR_039773           
                    INC $B6,X                 
                    RTS                       ; Return

ADDR_039773:        DEC $B6,X                 
Return039775:       RTS                       ; Return

ADDR_039776:        STZ $C2,X                 
                    LDA.B #$30                
                    STA.W $1540,X             
                    RTS                       ; Return

FishboneDispX:      .db $F8,$F8,$10,$10

FishboneDispY:      .db $00,$08

FishboneGfxProp:    .db $4D,$CD,$0D,$8D

FishboneTailTiles:  .db $A3,$A3,$B3,$B3

FishboneGfx:        JSL.L GenericSprGfxRt2    
                    LDY.W $15EA,X             ; Y = Index into sprite OAM
                    LDA.W $1558,X             
                    CMP.B #$01                
                    LDA.B #$A6                
                    BCC ADDR_03979E           
                    LDA.B #$A8                
ADDR_03979E:        STA.W $0302,Y             
                    JSR.W GetDrawInfoBnk3     
                    LDA.W $157C,X             
                    ASL                       
                    STA $02                   
                    LDA.W $1602,X             
                    ASL                       
                    STA $03                   
                    LDA.W $15EA,X             
                    CLC                       
                    ADC.B #$04                
                    STA.W $15EA,X             
                    TAY                       
                    PHX                       
                    LDX.B #$01                
ADDR_0397BD:        LDA $01                   
                    CLC                       
                    ADC.W FishboneDispY,X     
                    STA.W $0301,Y             
                    PHX                       
                    TXA                       
                    ORA $02                   
                    TAX                       
                    LDA $00                   
                    CLC                       
                    ADC.W FishboneDispX,X     
                    STA.W $0300,Y             
                    LDA.W FishboneGfxProp,X   
                    ORA $64                   
                    STA.W $0303,Y             
                    PLA                       
                    PHA                       
                    ORA $03                   
                    TAX                       
                    LDA.W FishboneTailTiles,X 
                    STA.W $0302,Y             
                    PLX                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_0397BD           
                    PLX                       
                    LDY.B #$00                
                    LDA.B #$02                
                    JSL.L FinishOAMWrite      
                    RTS                       ; Return

ADDR_0397F9:        STA $01                   
                    PHX                       
                    PHY                       
                    JSR.W SubVertPosBnk3      
                    STY $02                   
                    LDA $0E                   
                    BPL ADDR_03980B           
                    EOR.B #$FF                
                    CLC                       
                    ADC.B #$01                
ADDR_03980B:        STA $0C                   
                    JSR.W SubHorzPosBnk3      
                    STY $03                   
                    LDA $0F                   
                    BPL ADDR_03981B           
                    EOR.B #$FF                
                    CLC                       
                    ADC.B #$01                
ADDR_03981B:        STA $0D                   
                    LDY.B #$00                
                    LDA $0D                   
                    CMP $0C                   
                    BCS ADDR_03982E           
                    INY                       
                    PHA                       
                    LDA $0C                   
                    STA $0D                   
                    PLA                       
                    STA $0C                   
ADDR_03982E:        LDA.B #$00                
                    STA $0B                   
                    STA $00                   
                    LDX $01                   
ADDR_039836:        LDA $0B                   
                    CLC                       
                    ADC $0C                   
                    CMP $0D                   
                    BCC ADDR_039843           
                    SBC $0D                   
                    INC $00                   
ADDR_039843:        STA $0B                   
                    DEX                       
                    BNE ADDR_039836           
                    TYA                       
                    BEQ ADDR_039855           
                    LDA $00                   
                    PHA                       
                    LDA $01                   
                    STA $00                   
                    PLA                       
                    STA $01                   
ADDR_039855:        LDA $00                   
                    LDY $02                   
                    BEQ ADDR_039862           
                    EOR.B #$FF                
                    CLC                       
                    ADC.B #$01                
                    STA $00                   
ADDR_039862:        LDA $01                   
                    LDY $03                   
                    BEQ ADDR_03986F           
                    EOR.B #$FF                
                    CLC                       
                    ADC.B #$01                
                    STA $01                   
ADDR_03986F:        PLY                       
                    PLX                       
                    RTS                       ; Return

ReznorInit:         CPX.B #$07                
                    BNE ADDR_03987E           
                    LDA.B #$04                
                    STA $C2,X                 
                    JSL.L ExtSub03DD7D        
ADDR_03987E:        JSL.L GetRand             
                    STA.W $1570,X             
                    RTL                       ; Return

ReznorStartPosLo:   .db $00,$80,$00,$80     ; (0-1FF: 000 = 6 0'clock, 080 = 9 o'clock,

ReznorStartPosHi:   .db $00,$00,$01,$01     ; 100 = 12 o'clock, 180 = 3 o'clock)

ReboundSpeedX:      .db $20,$E0

Reznor:             INC.W $140F               
                    LDA $9D                   
                    BEQ ReznorNotLocked       
                    JMP.W DrawReznor          

ReznorNotLocked:    CPX.B #$07                
                    BNE ADDR_039910           
                    PHX                       
                    JSL.L ADDR_03D70C         ; Break bridge when necessary
ReznorSignCode:     LDA.B #$80                ; \ Set radius for Reznor sign rotation
                    STA $2A                   ;  |
                    STZ $2B                   ; /
                    LDX.B #$00                
                    LDA.B #$C0                ; \ X position of Reznor sign
                    STA $E4                   ;  |
                    STZ.W $14E0               ; /
                    LDA.B #$B2                ; \ Y position of Reznor sign
                    STA $D8                   ;  |
                    STZ.W $14D4               ; /
                    LDA.B #$2C                
                    STA.W $1BA2               
                    JSL.L ExtSub03DEDF        ; Applies position changes to Reznor sign
                    PLX                       ; Pull, X = sprite index
                    REP #$20                  ; Accum (16 bit) 
                    LDA $36                   ; \ Rotate 1 frame around the circle (clockwise)
                    CLC                       ;  | $37,36 = 0 to 1FF, denotes circle position
                    ADC.W #$0001              ;  |
                    AND.W #$01FF              ;  |
                    STA $36                   ; /
                    SEP #$20                  ; Accum (8 bit) 
                    CPX.B #$07                
                    BNE ADDR_039910           
                    LDA.W $163E,X             ; \ Branch if timer to trigger level isn't set
                    BEQ ReznorNoLevelEnd      ; /
                    DEC A                     
                    BNE ADDR_039910           
                    DEC.W $13C6               ; Prevent mario from walking at level end
                    LDA.B #$FF                ; \ Set time before return to overworld
                    STA.W $1493               ; /
                    LDA.B #$0B                ; \
                    STA.W $1DFB               ; / Play sound effect
                    RTS                       ; Return

ReznorNoLevelEnd:   LDA.W $1523               ; \
                    CLC                       ;  |
                    ADC.W $1522               ;  |
                    ADC.W $1521               ;  |
                    ADC.W $1520               ;  |
                    CMP.B #$04                ;  |
                    BNE ADDR_039910           ;  |
                    LDA.B #$90                ;  | Set time to trigger level if all Reznors are dead
                    STA.W $163E,X             ; /
                    JSL.L KillMostSprites     
                    LDY.B #$07                ; \ Zero out extended sprite table
                    LDA.B #$00                ;  |
ADDR_03990A:        STA.W $170B,Y             ;  |
                    DEY                       ;  |
                    BPL ADDR_03990A           ; /
ADDR_039910:        LDA.W $14C8,X             
                    CMP.B #$08                
                    BEQ ADDR_03991A           
                    JMP.W DrawReznor          

ADDR_03991A:        TXA                       ; \ Load Y with Reznor number (0-3)
                    AND.B #$03                ;  |
                    TAY                       ; /
                    LDA $36                   ; \
                    CLC                       ;  |
                    ADC.W ReznorStartPosLo,Y  ;  |
                    STA $00                   ;  | $01,00 = 0-1FF, position Reznors on the circle
                    LDA $37                   ;  |
                    ADC.W ReznorStartPosHi,Y  ;  |
                    AND.B #$01                ;  |
                    STA $01                   ; /
                    REP #$30                  ; \   Index (16 bit) Accum (16 bit) ; Index (16 bit) Accum (16 bit) 
                    LDA $00                   ;  | Make Reznors turn clockwise rather than counter clockwise
                    EOR.W #$01FF              ;  | ($01,00 = -1 * $01,00)
                    INC A                     ;  |
                    STA $00                   ; /
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
                    LDA.B #$38                
                    LDY $05                   
                    BNE ADDR_039978           
                    STA.W $4203               ; Multplier B
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    ASL.W $4216               ; Product/Remainder Result (Low Byte)
                    LDA.W $4217               ; Product/Remainder Result (High Byte)
                    ADC.B #$00                
ADDR_039978:        LSR $01                   
                    BCC ADDR_03997F           
                    EOR.B #$FF                
                    INC A                     
ADDR_03997F:        STA $04                   
                    LDA $06                   
                    STA.W $4202               ; Multiplicand A
                    LDA.B #$38                
                    LDY $07                   
                    BNE ADDR_03999B           
                    STA.W $4203               ; Multplier B
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    ASL.W $4216               ; Product/Remainder Result (Low Byte)
                    LDA.W $4217               ; Product/Remainder Result (High Byte)
                    ADC.B #$00                
ADDR_03999B:        LSR $03                   
                    BCC ADDR_0399A2           
                    EOR.B #$FF                
                    INC A                     
ADDR_0399A2:        STA $06                   
                    LDX.W $15E9               ; X = sprite index
                    LDA $E4,X                 
                    PHA                       
                    STZ $00                   
                    LDA $04                   
                    BPL ADDR_0399B2           
                    DEC $00                   
ADDR_0399B2:        CLC                       
                    ADC $2A                   
                    PHP                       
                    CLC                       
                    ADC.B #$40                
                    STA $E4,X                 
                    LDA $2B                   
                    ADC.B #$00                
                    PLP                       
                    ADC $00                   
                    STA.W $14E0,X             
                    PLA                       
                    SEC                       
                    SBC $E4,X                 
                    EOR.B #$FF                
                    INC A                     
                    STA.W $1528,X             
                    STZ $01                   
                    LDA $06                   
                    BPL ADDR_0399D7           
                    DEC $01                   
ADDR_0399D7:        CLC                       
                    ADC $2C                   
                    PHP                       
                    ADC.B #$20                
                    STA $D8,X                 
                    LDA $2D                   
                    ADC.B #$00                
                    PLP                       
                    ADC $01                   
                    STA.W $14D4,X             
                    LDA.W $151C,X             ; \ If a Reznor is dead, make it's platform standable
                    BEQ ReznorAlive           ;  |
                    JSL.L InvisBlkMainRt      ;  |
                    JMP.W DrawReznor          ; /

ReznorAlive:        LDA $13                   ; \ Don't try to spit fire if turning
                    AND.B #$00                ;  |
                    ORA.W $15AC,X             ;  |
                    BNE NoSetRznrFireTime     ; /
                    INC.W $1570,X             
                    LDA.W $1570,X             
                    CMP.B #$00                
                    BNE NoSetRznrFireTime     
                    STZ.W $1570,X             
                    LDA.B #$40                ; \ Set time to show firing graphic = 0A
                    STA.W $1558,X             ; /
NoSetRznrFireTime:  TXA                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ADC $14                   
                    AND.B #$3F                
                    ORA.W $1558,X             ; Firing
                    ORA.W $15AC,X             ; Turning
                    BNE NoSetRenrTurnTime     
                    LDA.W $157C,X             ; \ if direction has changed since last frame...
                    PHA                       ;  |
                    JSR.W SubHorzPosBnk3      ;  |
                    TYA                       ;  |
                    STA.W $157C,X             ;  |
                    PLA                       ;  |
                    CMP.W $157C,X             ;  |
                    BEQ NoSetRenrTurnTime     ;  |
                    LDA.B #$0A                ;  | ...set time to show turning graphic = 0A
                    STA.W $15AC,X             ; /
NoSetRenrTurnTime:  LDA.W $154C,X             ; \ If disable interaction timer > 0, just draw Reznor
                    BNE DrawReznor            ; /
                    JSL.L MarioSprInteract    ; \ Interact with mario
                    BCC DrawReznor            ; / If no contact, just draw Reznor
                    LDA.B #$08                ; \ Disable interaction timer = 08
                    STA.W $154C,X             ; / (eg. after hitting Reznor, or getting bounced by platform)
                    LDA $96                   ; \ Compare y positions to see if mario hit Reznor
                    SEC                       ;  |
                    SBC $D8,X                 ;  |
                    CMP.B #$ED                ;  |
                    BMI HitReznor             ; /
                    CMP.B #$F2                ; \ See if mario hit side of the platform
                    BMI HitPlatSide           ;  |
                    LDA $7D                   ;  |
                    BPL HitPlatSide           ; /
HitPlatBottom:      LDA.B #$29                ; ??Something about boosting mario on platform??
                    STA.W $1662,X             
                    LDA.B #$0F                ; \ Time to bounce platform = 0F
                    STA.W $1564,X             ; /
                    LDA.B #$10                ; \ Set mario's y speed to rebound down off platform
                    STA $7D                   ; /
                    LDA.B #$01                ; \
                    STA.W $1DF9               ; / Play sound effect
                    BRA DrawReznor            

HitPlatSide:        JSR.W SubHorzPosBnk3      ; \ Set mario to bounce back
                    LDA.W ReboundSpeedX,Y     ;  | (hit side of platform?)
                    STA $7B                   ;  |
                    BRA DrawReznor            ; /

HitReznor:          JSL.L HurtMario           ; Hurt Mario
DrawReznor:         STZ.W $1602,X             ; Set normal image
                    LDA.W $157C,X             
                    PHA                       
                    LDY.W $15AC,X             
                    BEQ ReznorNoTurning       
                    CPY.B #$05                
                    BCC ReznorTurning         
                    EOR.B #$01                
                    STA.W $157C,X             
ReznorTurning:      LDA.B #$02                ; \ Set turning image
                    STA.W $1602,X             ; /
ReznorNoTurning:    LDA.W $1558,X             ; \ Shoot fire if "time to show firing image" == 20
                    BEQ ReznorNoFiring        ;  |
                    CMP.B #$20                ;  | (shows image for 20 frames after the fireball is shot)
                    BNE ReznorFiring          ;  |
                    JSR.W ReznorFireRt        ; /
ReznorFiring:       LDA.B #$01                ; \ Set firing image
                    STA.W $1602,X             ; /
ReznorNoFiring:     JSR.W ReznorGfxRt         ; Draw Reznor
                    PLA                       
                    STA.W $157C,X             
                    LDA $9D                   ; \ If sprites locked, or mario already killed the Reznor on the platform, return
                    ORA.W $151C,X             ;  |
                    BNE Return039AF7          ; /
                    LDA.W $1564,X             ; \ If time to bounce platform != 0C, return
                    CMP.B #$0C                ;  | (causes delay between start of boucing platform and killing Reznor)
                    BNE Return039AF7          ; /
KillReznor:         LDA.B #$03                ; \
                    STA.W $1DF9               ; / Play sound effect
                    STZ.W $1558,X             ; Prevent from throwing fire after death
                    INC.W $151C,X             ; Record a hit on Reznor
                    JSL.L FindFreeSprSlot     ; \ Load Y with a free sprite index for dead Reznor
                    BMI Return039AF7          ; / Return if no free index
                    LDA.B #$02                ; \ Set status to being killed
                    STA.W $14C8,Y             ; /
                    LDA.B #$A9                ; \ Sprite to use for dead Reznor
                    STA.W $009E,Y             ; /
                    LDA $E4,X                 ; \ Transfer x position to dead Reznor
                    STA.W $00E4,Y             ;  |
                    LDA.W $14E0,X             ;  |
                    STA.W $14E0,Y             ; /
                    LDA $D8,X                 ; \ Transfer y position to dead Reznor
                    STA.W $00D8,Y             ;  |
                    LDA.W $14D4,X             ;  |
                    STA.W $14D4,Y             ; /
                    PHX                       ; \
                    TYX                       ;  | Before: X must have index of sprite being generated
                    JSL.L InitSpriteTables    ; /  Routine clears all old sprite values and loads in new values for the 6 main sprite tables
                    LDA.B #$C0                ; \ Set y speed for Reznor's bounce off the platform
                    STA $AA,X                 ; /
                    PLX                       ; pull, X = sprite index
Return039AF7:       RTS                       ; Return

ReznorFireRt:       LDY.B #$07                ; \ find a free extended sprite slot, return if all full
ADDR_039AFA:        LDA.W $170B,Y             ;  |
                    BEQ FoundRznrFireSlot     ;  |
                    DEY                       ;  |
                    BPL ADDR_039AFA           ;  |
                    RTS                       ; / Return if no free slots

FoundRznrFireSlot:  LDA.B #$10                ; \
                    STA.W $1DF9               ; / Play sound effect
                    LDA.B #$02                ; \ Extended sprite = Reznor fireball
                    STA.W $170B,Y             ; /
                    LDA $E4,X                 
                    PHA                       
                    SEC                       
                    SBC.B #$08                
                    STA.W $171F,Y             
                    STA $E4,X                 
                    LDA.W $14E0,X             
                    SBC.B #$00                
                    STA.W $1733,Y             
                    LDA $D8,X                 
                    PHA                       
                    SEC                       
                    SBC.B #$14                
                    STA $D8,X                 
                    STA.W $1715,Y             
                    LDA.W $14D4,X             
                    PHA                       
                    SBC.B #$00                
                    STA.W $1729,Y             
                    STA.W $14D4,X             
                    LDA.B #$10                
                    JSR.W ADDR_0397F9         
                    PLA                       
                    STA.W $14D4,X             
                    PLA                       
                    STA $D8,X                 
                    PLA                       
                    STA $E4,X                 
                    LDA $00                   
                    STA.W $173D,Y             
                    LDA $01                   
                    STA.W $1747,Y             
                    RTS                       ; Return

ReznorTileDispX:    .db $00,$F0,$00,$F0,$F0,$00,$F0,$00
ReznorTileDispY:    .db $E0,$E0,$F0,$F0

ReznorTiles:        .db $40,$42,$60,$62,$44,$46,$64,$66
                    .db $28,$28,$48,$48

ReznorPal:          .db $3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F
                    .db $7F,$3F,$7F,$3F

ReznorGfxRt:        LDA.W $151C,X             ; \ if the reznor is dead, only draw the platform
                    BNE DrawReznorPlats       ; /
                    JSR.W GetDrawInfoBnk3     ; after: Y = index to sprite tile map, $00 = sprite x, $01 = sprite y
                    LDA.W $1602,X             ; \ $03 = index to frame start (frame to show * 4 tiles per frame)
                    ASL                       ;  |
                    ASL                       ;  |
                    STA $03                   ; /
                    LDA.W $157C,X             ; \ $02 = direction index
                    ASL                       ;  |
                    ASL                       ;  |
                    STA $02                   ; /
                    PHX                       
                    LDX.B #$03                
RznrGfxLoopStart:   PHX                       
                    LDA $03                   
                    CMP.B #$08                
                    BCS ADDR_039B99           
                    TXA                       
                    ORA $02                   
                    TAX                       
ADDR_039B99:        LDA $00                   
                    CLC                       
                    ADC.W ReznorTileDispX,X   
                    STA.W $0300,Y             
                    PLX                       
                    LDA $01                   
                    CLC                       
                    ADC.W ReznorTileDispY,X   
                    STA.W $0301,Y             
                    PHX                       
                    TXA                       
                    ORA $03                   
                    TAX                       
                    LDA.W ReznorTiles,X       ; \ set tile
                    STA.W $0302,Y             ; /
                    LDA.W ReznorPal,X         ; \ set palette/properties
                    CPX.B #$08                ;  | if turning, don't flip
                    BCS NoReznorGfxFlip       ;  |
                    LDX $02                   ;  | if direction = 0, don't flip
                    BNE NoReznorGfxFlip       ;  |
                    EOR.B #$40                ;  |
NoReznorGfxFlip:    STA.W $0303,Y             ; /
                    PLX                       ; \ pull, X = current tile of the frame we're drawing
                    INY                       ;  | Increase index to sprite tile map ($300)...
                    INY                       ;  |    ...we wrote 4 bytes...
                    INY                       ;  |    ...so increment 4 times
                    INY                       ;  |
                    DEX                       ;  | Go to next tile of frame and loop
                    BPL RznrGfxLoopStart      ; /
                    PLX                       ; \
                    LDY.B #$02                ;  | Y = 02 (All 16x16 tiles)
                    LDA.B #$03                ;  | A = number of tiles drawn - 1
                    JSL.L FinishOAMWrite      ; / Don't draw if offscreen
                    LDA.W $14C8,X             
                    CMP.B #$02                
                    BEQ Return039BE2          
DrawReznorPlats:    JSR.W ReznorPlatGfxRt     
Return039BE2:       RTS                       ; Return

ReznorPlatDispY:    .db $00,$03,$04,$05,$05,$04,$03,$00

ReznorPlatGfxRt:    LDA.W $15EA,X             
                    CLC                       
                    ADC.B #$10                
                    STA.W $15EA,X             
                    JSR.W GetDrawInfoBnk3     
                    LDA.W $1564,X             
                    LSR                       
                    PHY                       
                    TAY                       
                    LDA.W ReznorPlatDispY,Y   
                    STA $02                   
                    PLY                       
                    LDA $00                   
                    STA.W $0304,Y             
                    SEC                       
                    SBC.B #$10                
                    STA.W $0300,Y             
                    LDA $01                   
                    SEC                       
                    SBC $02                   
                    STA.W $0301,Y             
                    STA.W $0305,Y             
                    LDA.B #$4E                ; \ Tile of reznor platform...
                    STA.W $0302,Y             ;  | ...store left side
                    STA.W $0306,Y             ; /  ...store right side
                    LDA.B #$33                ; \ Palette of reznor platform...
                    STA.W $0303,Y             ;  |
                    ORA.B #$40                ;  | ...flip right side
                    STA.W $0307,Y             ; /
                    LDY.B #$02                ; \
                    LDA.B #$01                ;  | A = number of tiles drawn - 1
                    JSL.L FinishOAMWrite      ; / Don't draw if offscreen
                    RTS                       ; Return

InvisBlk_DinosMain: LDA $9E,X                 ; \ Branch if sprite isn't "Invisible solid block"
                    CMP.B #$6D                ;  |
                    BNE DinoMainRt            ; /
                    JSL.L InvisBlkMainRt      ; \ Call "Invisible solid block" routine
                    RTL                       ; / Return

DinoMainRt:         PHB                       
                    PHK                       
                    PLB                       
                    JSR.W DinoMainSubRt       
                    PLB                       
                    RTL                       ; Return

DinoMainSubRt:      JSR.W DinoGfxRt           
                    LDA $9D                   
                    BNE Return039CA3          
                    LDA.W $14C8,X             
                    CMP.B #$08                
                    BNE Return039CA3          
                    JSR.W SubOffscreen0Bnk3   
                    JSL.L MarioSprInteract    
                    JSL.L UpdateSpritePos     
                    LDA $C2,X                 
                    JSL.L ExecutePtr          

RhinoStatePtrs:     .dw ADDR_039CA8           
                    .dw ADDR_039D41           
                    .dw ADDR_039D41           
                    .dw ADDR_039C74           

DATA_039C6E:        .db $00,$FE,$02

DATA_039C71:        .db $00,$FF,$00

ADDR_039C74:        LDA $AA,X                 
                    BMI ADDR_039C89           
                    STZ $C2,X                 
                    LDA.W $1588,X             ; \ Branch if not touching object
                    AND.B #$03                ;  |
                    BEQ ADDR_039C89           ; /
                    LDA.W $157C,X             
                    EOR.B #$01                
                    STA.W $157C,X             
ADDR_039C89:        STZ.W $1602,X             
                    LDA.W $1588,X             
                    AND.B #$03                
                    TAY                       
                    LDA $E4,X                 
                    CLC                       
                    ADC.W DATA_039C6E,Y       
                    STA $E4,X                 
                    LDA.W $14E0,X             
                    ADC.W DATA_039C71,Y       
                    STA.W $14E0,X             
Return039CA3:       RTS                       ; Return

DinoSpeed:          .db $08,$F8,$10,$F0

ADDR_039CA8:        LDA.W $1588,X             ; \ Branch if not on ground
                    AND.B #$04                ;  |
                    BEQ ADDR_039C89           ; /
                    LDA.W $1540,X             
                    BNE ADDR_039CC8           
                    LDA $9E,X                 
                    CMP.B #$6E                
                    BEQ ADDR_039CC8           
                    LDA.B #$FF                ; \ Set fire breathing timer
                    STA.W $1540,X             ; /
                    JSL.L GetRand             
                    AND.B #$01                
                    INC A                     
                    STA $C2,X                 
ADDR_039CC8:        TXA                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ADC $14                   
                    AND.B #$3F                
                    BNE ADDR_039CDA           
                    JSR.W SubHorzPosBnk3      ; \ If not facing mario, change directions
                    TYA                       ;  |
                    STA.W $157C,X             ; /
ADDR_039CDA:        LDA.B #$10                
                    STA $AA,X                 
                    LDY.W $157C,X             ; \ Set x speed for rhino based on direction and sprite number
                    LDA $9E,X                 ;  |
                    CMP.B #$6E                ;  |
                    BEQ ADDR_039CE9           ;  |
                    INY                       ;  |
                    INY                       ;  |
ADDR_039CE9:        LDA.W DinoSpeed,Y         ;  |
                    STA $B6,X                 ; /
                    JSR.W DinoSetGfxFrame     
                    LDA.W $1588,X             ; \ Branch if not touching object
                    AND.B #$03                ;  |
                    BEQ Return039D00          ; /
                    LDA.B #$C0                
                    STA $AA,X                 
                    LDA.B #$03                
                    STA $C2,X                 
Return039D00:       RTS                       ; Return

DinoFlameTable:     .db $41,$42,$42,$32,$22,$12,$02,$02
                    .db $02,$02,$02,$02,$02,$02,$02,$02
                    .db $02,$02,$02,$02,$02,$02,$02,$12
                    .db $22,$32,$42,$42,$42,$42,$41,$41
                    .db $41,$43,$43,$33,$23,$13,$03,$03
                    .db $03,$03,$03,$03,$03,$03,$03,$03
                    .db $03,$03,$03,$03,$03,$03,$03,$13
                    .db $23,$33,$43,$43,$43,$43,$41,$41

ADDR_039D41:        STZ $B6,X                 ; Sprite X Speed = 0
                    LDA.W $1540,X             
                    BNE DinoFlameTimerSet     
                    STZ $C2,X                 
                    LDA.B #$40                
                    STA.W $1540,X             
                    LDA.B #$00                
DinoFlameTimerSet:  CMP.B #$C0                
                    BNE ADDR_039D5A           
                    LDY.B #$17                ; \ Play sound effect
                    STY.W $1DFC               ; /
ADDR_039D5A:        LSR                       
                    LSR                       
                    LSR                       
                    LDY $C2,X                 
                    CPY.B #$02                
                    BNE ADDR_039D66           
                    CLC                       
                    ADC.B #$20                
ADDR_039D66:        TAY                       
                    LDA.W DinoFlameTable,Y    
                    PHA                       
                    AND.B #$0F                
                    STA.W $1602,X             
                    PLA                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    STA.W $151C,X             
                    BNE Return039D9D          
                    LDA $9E,X                 
                    CMP.B #$6E                
                    BEQ Return039D9D          
                    TXA                       
                    EOR $13                   
                    AND.B #$03                
                    BNE Return039D9D          
                    JSR.W DinoFlameClipping   
                    JSL.L GetMarioClipping    
                    JSL.L CheckForContact     
                    BCC Return039D9D          
                    LDA.W $1490               ; \ Branch if Mario has star
                    BNE Return039D9D          ; /
                    JSL.L HurtMario           
Return039D9D:       RTS                       ; Return

DinoFlame1:         .db $DC,$02,$10,$02

DinoFlame2:         .db $FF,$00,$00,$00

DinoFlame3:         .db $24,$0C,$24,$0C

DinoFlame4:         .db $02,$DC,$02,$DC

DinoFlame5:         .db $00,$FF,$00,$FF

DinoFlame6:         .db $0C,$24,$0C,$24

DinoFlameClipping:  LDA.W $1602,X             
                    SEC                       
                    SBC.B #$02                
                    TAY                       
                    LDA.W $157C,X             
                    BNE ADDR_039DC4           
                    INY                       
                    INY                       
ADDR_039DC4:        LDA $E4,X                 
                    CLC                       
                    ADC.W DinoFlame1,Y        
                    STA $04                   
                    LDA.W $14E0,X             
                    ADC.W DinoFlame2,Y        
                    STA $0A                   
                    LDA.W DinoFlame3,Y        
                    STA $06                   
                    LDA $D8,X                 
                    CLC                       
                    ADC.W DinoFlame4,Y        
                    STA $05                   
                    LDA.W $14D4,X             
                    ADC.W DinoFlame5,Y        
                    STA $0B                   
                    LDA.W DinoFlame6,Y        
                    STA $07                   
                    RTS                       ; Return

DinoSetGfxFrame:    INC.W $1570,X             
                    LDA.W $1570,X             
                    AND.B #$08                
                    LSR                       
                    LSR                       
                    LSR                       
                    STA.W $1602,X             
                    RTS                       ; Return

DinoTorchTileDispX: .db $D8,$E0,$EC,$F8,$00,$FF,$FF,$FF
                    .db $FF,$00

DinoTorchTileDispY: .db $00,$00,$00,$00,$00,$D8,$E0,$EC
                    .db $F8,$00

DinoFlameTiles:     .db $80,$82,$84,$86,$00,$88,$8A,$8C
                    .db $8E,$00

DinoTorchGfxProp:   .db $09,$05,$05,$05,$0F

DinoTorchTiles:     .db $EA,$AA,$C4,$C6

DinoRhinoTileDispX: .db $F8,$08,$F8,$08,$08,$F8,$08,$F8
DinoRhinoGfxProp:   .db $2F,$2F,$2F,$2F,$6F,$6F,$6F,$6F
DinoRhinoTileDispY: .db $F0,$F0,$00,$00

DinoRhinoTiles:     .db $C0,$C2,$E4,$E6,$C0,$C2,$E0,$E2
                    .db $C8,$CA,$E8,$E2,$CC,$CE,$EC,$EE

DinoGfxRt:          JSR.W GetDrawInfoBnk3     
                    LDA.W $157C,X             
                    STA $02                   
                    LDA.W $1602,X             
                    STA $04                   
                    LDA $9E,X                 
                    CMP.B #$6F                
                    BEQ ADDR_039EA9           
                    PHX                       
                    LDX.B #$03                
ADDR_039E5F:        STX $0F                   
                    LDA $02                   
                    CMP.B #$01                
                    BCS ADDR_039E6C           
                    TXA                       
                    CLC                       
                    ADC.B #$04                
                    TAX                       
ADDR_039E6C:        LDA.W DinoRhinoGfxProp,X  
                    STA.W $0303,Y             
                    LDA.W DinoRhinoTileDispX,X
                    CLC                       
                    ADC $00                   
                    STA.W $0300,Y             
                    LDA $04                   
                    CMP.B #$01                
                    LDX $0F                   
                    LDA.W DinoRhinoTileDispY,X
                    ADC $01                   
                    STA.W $0301,Y             
                    LDA $04                   
                    ASL                       
                    ASL                       
                    ADC $0F                   
                    TAX                       
                    LDA.W DinoRhinoTiles,X    
                    STA.W $0302,Y             
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    LDX $0F                   
                    DEX                       
                    BPL ADDR_039E5F           
                    PLX                       
                    LDA.B #$03                
                    LDY.B #$02                
                    JSL.L FinishOAMWrite      
                    RTS                       ; Return

ADDR_039EA9:        LDA.W $151C,X             
                    STA $03                   
                    LDA.W $1602,X             
                    STA $04                   
                    PHX                       
                    LDA $14                   
                    AND.B #$02                
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    LDX $04                   
                    CPX.B #$03                
                    BEQ ADDR_039EC4           
                    ASL                       
ADDR_039EC4:        STA $05                   
                    LDX.B #$04                
ADDR_039EC8:        STX $06                   
                    LDA $04                   
                    CMP.B #$03                
                    BNE ADDR_039ED5           
                    TXA                       
                    CLC                       
                    ADC.B #$05                
                    TAX                       
ADDR_039ED5:        PHX                       
                    LDA.W DinoTorchTileDispX,X
                    LDX $02                   
                    BNE ADDR_039EE0           
                    EOR.B #$FF                
                    INC A                     
ADDR_039EE0:        PLX                       
                    CLC                       
                    ADC $00                   
                    STA.W $0300,Y             
                    LDA.W DinoTorchTileDispY,X
                    CLC                       
                    ADC $01                   
                    STA.W $0301,Y             
                    LDA $06                   
                    CMP.B #$04                
                    BNE ADDR_039EFD           
                    LDX $04                   
                    LDA.W DinoTorchTiles,X    
                    BRA ADDR_039F00           

ADDR_039EFD:        LDA.W DinoFlameTiles,X    
ADDR_039F00:        STA.W $0302,Y             
                    LDA.B #$00                
                    LDX $02                   
                    BNE ADDR_039F0B           
                    ORA.B #$40                
ADDR_039F0B:        LDX $06                   
                    CPX.B #$04                
                    BEQ ADDR_039F13           
                    EOR $05                   
ADDR_039F13:        ORA.W DinoTorchGfxProp,X  
                    ORA $64                   
                    STA.W $0303,Y             
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    CPX $03                   
                    BPL ADDR_039EC8           
                    PLX                       
                    LDY.W $151C,X             
                    LDA.W DinoTilesWritten,Y  
                    LDY.B #$02                
                    JSL.L FinishOAMWrite      
                    RTS                       ; Return

DinoTilesWritten:   .db $04,$03,$02,$01,$00

                    RTS                       

Blargg:             JSR.W ADDR_03A062         
                    LDA $9D                   
                    BNE Return039F56          
                    JSL.L MarioSprInteract    
                    JSR.W SubOffscreen0Bnk3   
                    LDA $C2,X                 
                    JSL.L ExecutePtr          

BlarggPtrs:         .dw ADDR_039F57           
                    .dw ADDR_039F8B           
                    .dw ADDR_039FA4           
                    .dw ADDR_039FC8           
                    .dw ADDR_039FEF           

Return039F56:       RTS                       ; Return

ADDR_039F57:        LDA.W $15A0,X             
                    ORA.W $1540,X             
                    BNE Return039F8A          
                    JSR.W SubHorzPosBnk3      
                    LDA $0F                   
                    CLC                       
                    ADC.B #$70                
                    CMP.B #$E0                
                    BCS Return039F8A          
                    LDA.B #$E3                
                    STA $AA,X                 
                    LDA.W $14E0,X             
                    STA.W $151C,X             
                    LDA $E4,X                 
                    STA.W $1528,X             
                    LDA.W $14D4,X             
                    STA.W $1534,X             
                    LDA $D8,X                 
                    STA.W $1594,X             
                    JSR.W ADDR_039FC0         
                    INC $C2,X                 
Return039F8A:       RTS                       ; Return

ADDR_039F8B:        LDA $AA,X                 
                    CMP.B #$10                
                    BMI ADDR_039F9B           
                    LDA.B #$50                
                    STA.W $1540,X             
                    INC $C2,X                 
                    STZ $AA,X                 ; Sprite Y Speed = 0
                    RTS                       ; Return

ADDR_039F9B:        JSL.L UpdateYPosNoGrvty   
                    INC $AA,X                 
                    INC $AA,X                 
                    RTS                       ; Return

ADDR_039FA4:        LDA.W $1540,X             
                    BNE ADDR_039FB1           
                    INC $C2,X                 
                    LDA.B #$0A                
                    STA.W $1540,X             
                    RTS                       ; Return

ADDR_039FB1:        CMP.B #$20                
                    BCC ADDR_039FC0           
                    AND.B #$1F                
                    BNE Return039FC7          
                    LDA.W $157C,X             
                    EOR.B #$01                
                    BRA ADDR_039FC4           

ADDR_039FC0:        JSR.W SubHorzPosBnk3      
                    TYA                       
ADDR_039FC4:        STA.W $157C,X             
Return039FC7:       RTS                       ; Return

ADDR_039FC8:        LDA.W $1540,X             
                    BEQ ADDR_039FD6           
                    LDA.B #$20                
                    STA $AA,X                 
                    JSL.L UpdateYPosNoGrvty   
                    RTS                       ; Return

ADDR_039FD6:        LDA.B #$20                
                    STA.W $1540,X             
                    LDY.W $157C,X             
                    LDA.W DATA_039FED,Y       
                    STA $B6,X                 
                    LDA.B #$E2                
                    STA $AA,X                 
                    JSR.W ADDR_03A045         
                    INC $C2,X                 
                    RTS                       ; Return

DATA_039FED:        .db $10,$F0

ADDR_039FEF:        STZ.W $1602,X             
                    LDA.W $1540,X             
                    BEQ ADDR_03A002           
                    DEC A                     
                    BNE ADDR_03A038           
                    LDA.B #$25                ; \ Play sound effect
                    STA.W $1DF9               ; /
                    JSR.W ADDR_03A045         
ADDR_03A002:        JSL.L UpdateXPosNoGrvty   
                    JSL.L UpdateYPosNoGrvty   
                    LDA $13                   
                    AND.B #$00                
                    BNE ADDR_03A012           
                    INC $AA,X                 
ADDR_03A012:        LDA $AA,X                 
                    CMP.B #$20                
                    BMI ADDR_03A038           
                    JSR.W ADDR_03A045         
                    STZ $C2,X                 
                    LDA.W $151C,X             
                    STA.W $14E0,X             
                    LDA.W $1528,X             
                    STA $E4,X                 
                    LDA.W $1534,X             
                    STA.W $14D4,X             
                    LDA.W $1594,X             
                    STA $D8,X                 
                    LDA.B #$40                
                    STA.W $1540,X             
ADDR_03A038:        LDA $AA,X                 
                    CLC                       
                    ADC.B #$06                
                    CMP.B #$0C                
                    BCS Return03A044          
                    INC.W $1602,X             
Return03A044:       RTS                       ; Return

ADDR_03A045:        LDA $D8,X                 
                    PHA                       
                    SEC                       
                    SBC.B #$0C                
                    STA $D8,X                 
                    LDA.W $14D4,X             
                    PHA                       
                    SBC.B #$00                
                    STA.W $14D4,X             
                    JSL.L ExtSub028528        
                    PLA                       
                    STA.W $14D4,X             
                    PLA                       
                    STA $D8,X                 
                    RTS                       ; Return

ADDR_03A062:        JSR.W GetDrawInfoBnk3     
                    LDA $C2,X                 
                    BEQ ADDR_03A038           
                    CMP.B #$04                
                    BEQ ADDR_03A09D           
                    JSL.L GenericSprGfxRt2    
                    LDY.W $15EA,X             ; Y = Index into sprite OAM
                    LDA.B #$A0                
                    STA.W $0302,Y             
                    LDA.W $0303,Y             
                    AND.B #$CF                
                    STA.W $0303,Y             
                    RTS                       ; Return

DATA_03A082:        .db $F8,$08,$F8,$08,$18,$08,$F8,$08
                    .db $F8,$E8

DATA_03A08C:        .db $F8,$F8,$08,$08,$08

BlarggTilemap:      .db $A2,$A4,$C2,$C4,$A6,$A2,$A4,$E6
                    .db $C8,$A6

DATA_03A09B:        .db $45,$05

ADDR_03A09D:        LDA.W $1602,X             
                    ASL                       
                    ASL                       
                    ADC.W $1602,X             
                    STA $03                   
                    LDA.W $157C,X             
                    STA $02                   
                    PHX                       
                    LDX.B #$04                
ADDR_03A0AF:        PHX                       
                    PHX                       
                    LDA $01                   
                    CLC                       
                    ADC.W DATA_03A08C,X       
                    STA.W $0301,Y             
                    LDA $02                   
                    BNE ADDR_03A0C3           
                    TXA                       
                    CLC                       
                    ADC.B #$05                
                    TAX                       
ADDR_03A0C3:        LDA $00                   
                    CLC                       
                    ADC.W DATA_03A082,X       
                    STA.W $0300,Y             
                    PLA                       
                    CLC                       
                    ADC $03                   
                    TAX                       
                    LDA.W BlarggTilemap,X     
                    STA.W $0302,Y             
                    LDX $02                   
                    LDA.W DATA_03A09B,X       
                    STA.W $0303,Y             
                    PLX                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_03A0AF           
                    PLX                       
                    LDY.B #$02                
                    LDA.B #$04                
                    JSL.L FinishOAMWrite      
                    RTS                       ; Return

ExtSub03A0F1:       JSL.L InitSpriteTables    
                    STZ.W $15A0,X             
                    LDA.B #$80                
                    STA $D8,X                 
                    LDA.B #$FF                
                    STA.W $14D4,X             
                    LDA.B #$D0                
                    STA $E4,X                 
                    LDA.B #$00                
                    STA.W $14E0,X             
                    LDA.B #$02                
                    STA.W $187B,X             
                    LDA.B #$03                
                    STA $C2,X                 
                    JSL.L ExtSub03DD7D        
                    RTL                       ; Return

Bnk3CallSprMain:    PHB                       
                    PHK                       
                    PLB                       
                    LDA $9E,X                 
                    CMP.B #$C8                
                    BNE ADDR_03A126           
                    JSR.W LightSwitch         
                    PLB                       
                    RTL                       ; Return

ADDR_03A126:        CMP.B #$C7                
                    BNE ADDR_03A12F           
                    JSR.W InvisMushroom       
                    PLB                       
                    RTL                       ; Return

ADDR_03A12F:        CMP.B #$51                
                    BNE ADDR_03A138           
                    JSR.W Ninji               
                    PLB                       
                    RTL                       ; Return

ADDR_03A138:        CMP.B #$1B                
                    BNE ADDR_03A141           
                    JSR.W Football            
                    PLB                       
                    RTL                       ; Return

ADDR_03A141:        CMP.B #$C6                
                    BNE ADDR_03A14A           
                    JSR.W DarkRoomWithLight   
                    PLB                       
                    RTL                       ; Return

ADDR_03A14A:        CMP.B #$7A                
                    BNE ADDR_03A153           
                    JSR.W Firework            
                    PLB                       
                    RTL                       ; Return

ADDR_03A153:        CMP.B #$7C                
                    BNE ADDR_03A15C           
                    JSR.W PrincessPeach       
                    PLB                       
                    RTL                       ; Return

ADDR_03A15C:        CMP.B #$C5                
                    BNE ADDR_03A165           
                    JSR.W BigBooBoss          
                    PLB                       
                    RTL                       ; Return

ADDR_03A165:        CMP.B #$C4                
                    BNE ADDR_03A16E           
                    JSR.W GreyFallingPlat     
                    PLB                       
                    RTL                       ; Return

ADDR_03A16E:        CMP.B #$C2                
                    BNE ADDR_03A177           
                    JSR.W Blurp               
                    PLB                       
                    RTL                       ; Return

ADDR_03A177:        CMP.B #$C3                
                    BNE ADDR_03A180           
                    JSR.W PorcuPuffer         
                    PLB                       
                    RTL                       ; Return

ADDR_03A180:        CMP.B #$C1                
                    BNE ADDR_03A189           
                    JSR.W FlyingTurnBlocks    
                    PLB                       
                    RTL                       ; Return

ADDR_03A189:        CMP.B #$C0                
                    BNE ADDR_03A192           
                    JSR.W GrayLavaPlatform    
                    PLB                       
                    RTL                       ; Return

ADDR_03A192:        CMP.B #$BF                
                    BNE ADDR_03A19B           
                    JSR.W MegaMole            
                    PLB                       
                    RTL                       ; Return

ADDR_03A19B:        CMP.B #$BE                
                    BNE ADDR_03A1A4           
                    JSR.W Swooper             
                    PLB                       
                    RTL                       ; Return

ADDR_03A1A4:        CMP.B #$BD                
                    BNE ADDR_03A1AD           
                    JSR.W SlidingKoopa        
                    PLB                       
                    RTL                       ; Return

ADDR_03A1AD:        CMP.B #$BC                
                    BNE ADDR_03A1B6           
                    JSR.W BowserStatue        
                    PLB                       
                    RTL                       ; Return

ADDR_03A1B6:        CMP.B #$B8                
                    BEQ ADDR_03A1BE           
                    CMP.B #$B7                
                    BNE ADDR_03A1C3           
ADDR_03A1BE:        JSR.W CarrotTopLift       
                    PLB                       
                    RTL                       ; Return

ADDR_03A1C3:        CMP.B #$B9                
                    BNE ADDR_03A1CC           
                    JSR.W InfoBox             
                    PLB                       
                    RTL                       ; Return

ADDR_03A1CC:        CMP.B #$BA                
                    BNE ADDR_03A1D5           
                    JSR.W TimedLift           
                    PLB                       
                    RTL                       ; Return

ADDR_03A1D5:        CMP.B #$BB                
                    BNE ADDR_03A1DE           
                    JSR.W GreyCastleBlock     
                    PLB                       
                    RTL                       ; Return

ADDR_03A1DE:        CMP.B #$B3                
                    BNE ADDR_03A1E7           
                    JSR.W StatueFireball      
                    PLB                       
                    RTL                       ; Return

ADDR_03A1E7:        LDA $9E,X                 
                    CMP.B #$B2                
                    BNE ADDR_03A1F2           
                    JSR.W FallingSpike        
                    PLB                       
                    RTL                       ; Return

ADDR_03A1F2:        CMP.B #$AE                
                    BNE ADDR_03A1FB           
                    JSR.W FishinBoo           
                    PLB                       
                    RTL                       ; Return

ADDR_03A1FB:        CMP.B #$B6                
                    BNE ADDR_03A204           
                    JSR.W ReflectingFireball  
                    PLB                       
                    RTL                       ; Return

ADDR_03A204:        CMP.B #$B0                
                    BNE ADDR_03A20D           
                    JSR.W BooStream           
                    PLB                       
                    RTL                       ; Return

ADDR_03A20D:        CMP.B #$B1                
                    BNE ADDR_03A216           
                    JSR.W CreateEatBlock      
                    PLB                       
                    RTL                       ; Return

ADDR_03A216:        CMP.B #$AC                
                    BEQ ADDR_03A21E           
                    CMP.B #$AD                
                    BNE ADDR_03A223           
ADDR_03A21E:        JSR.W WoodenSpike         
                    PLB                       
                    RTL                       ; Return

ADDR_03A223:        CMP.B #$AB                
                    BNE ADDR_03A22C           
                    JSR.W RexMainRt           
                    PLB                       
                    RTL                       ; Return

ADDR_03A22C:        CMP.B #$AA                
                    BNE ADDR_03A235           
                    JSR.W Fishbone            
                    PLB                       
                    RTL                       ; Return

ADDR_03A235:        CMP.B #$A9                
                    BNE ADDR_03A23E           
                    JSR.W Reznor              
                    PLB                       
                    RTL                       ; Return

ADDR_03A23E:        CMP.B #$A8                
                    BNE ADDR_03A247           
                    JSR.W Blargg              
                    PLB                       
                    RTL                       ; Return

ADDR_03A247:        CMP.B #$A1                
                    BNE ADDR_03A250           
                    JSR.W BowserBowlingBall   
                    PLB                       
                    RTL                       ; Return

ADDR_03A250:        CMP.B #$A2                
                    BNE BowserFight           
                    JSR.W MechaKoopa          
                    PLB                       
                    RTL                       ; Return

BowserFight:        JSL.L ADDR_03DFCC         
                    JSR.W ADDR_03A279         
                    JSR.W ADDR_03B43C         
                    PLB                       
                    RTL                       ; Return

DATA_03A265:        .db $04,$03,$02,$01,$00,$01,$02,$03
                    .db $04,$05,$06,$07,$07,$07,$07,$07
                    .db $07,$07,$07,$07

ADDR_03A279:        LDA $38                   
                    LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_03A265,Y       
                    STA.W $1429               
                    LDA.W $1570,X             
                    CLC                       
                    ADC.B #$1E                
                    ORA.W $157C,X             
                    STA.W $1BA2               
                    LDA $14                   
                    LSR                       
                    AND.B #$03                
                    STA.W $1428               
                    LDA.B #$90                
                    STA $2A                   
                    LDA.B #$C8                
                    STA $2C                   
                    JSL.L ExtSub03DEDF        
                    LDA.W $14B5               
                    BEQ ADDR_03A2AD           
                    JSR.W ADDR_03AF59         
ADDR_03A2AD:        LDA.W $1564,X             
                    BEQ ADDR_03A2B5           
                    JSR.W ADDR_03A3E2         
ADDR_03A2B5:        LDA.W $1594,X             
                    BEQ ADDR_03A2CE           
                    DEC A                     
                    LSR                       
                    LSR                       
                    PHA                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_03A8BE,Y       
                    STA $02                   
                    PLA                       
                    AND.B #$03                
                    STA $03                   
                    JSR.W ADDR_03AA6E         
                    NOP                       
ADDR_03A2CE:        LDA $9D                   
                    BNE Return03A340          
                    STZ.W $1594,X             
                    LDA.B #$30                
                    STA $64                   
                    LDA $38                   
                    CMP.B #$20                
                    BCS ADDR_03A2E1           
                    STZ $64                   
ADDR_03A2E1:        JSR.W ADDR_03A661         
                    LDA.W $14B0               
                    BEQ ADDR_03A2F2           
                    LDA $13                   
                    AND.B #$03                
                    BNE ADDR_03A2F2           
                    DEC.W $14B0               
ADDR_03A2F2:        LDA $13                   
                    AND.B #$7F                
                    BNE ADDR_03A305           
                    JSL.L GetRand             
                    AND.B #$01                
                    BNE ADDR_03A305           
                    LDA.B #$0C                
                    STA.W $1558,X             
ADDR_03A305:        JSR.W ADDR_03B078         
                    LDA.W $151C,X             
                    CMP.B #$09                
                    BEQ ADDR_03A31A           
                    STZ.W $1427               
                    LDA.W $1558,X             
                    BEQ ADDR_03A31A           
                    INC.W $1427               
ADDR_03A31A:        JSR.W ADDR_03A5AD         
                    JSL.L UpdateXPosNoGrvty   
                    JSL.L UpdateYPosNoGrvty   
                    LDA.W $151C,X             
                    JSL.L ExecutePtr          

BowserFightPtrs:    .dw ADDR_03A441           
                    .dw ADDR_03A6F8           
                    .dw ADDR_03A84B           
                    .dw ADDR_03A7AD           
                    .dw ADDR_03AB9F           
                    .dw ADDR_03ABBE           
                    .dw ADDR_03AC03           
                    .dw ADDR_03A49C           
                    .dw ADDR_03AB21           
                    .dw ADDR_03AB64           

Return03A340:       RTS                       ; Return

DATA_03A341:        .db $D5,$DD,$23,$2B,$D5,$DD,$23,$2B
                    .db $D5,$DD,$23,$2B,$D5,$DD,$23,$2B
                    .db $D6,$DE,$22,$2A,$D6,$DE,$22,$2A
                    .db $D7,$DF,$21,$29,$D7,$DF,$21,$29
                    .db $D8,$E0,$20,$28,$D8,$E0,$20,$28
                    .db $DA,$E2,$1E,$26,$DA,$E2,$1E,$26
                    .db $DC,$E4,$1C,$24,$DC,$E4,$1C,$24
                    .db $E0,$E8,$18,$20,$E0,$E8,$18,$20
                    .db $E8,$F0,$10,$18,$E8,$F0,$10,$18
DATA_03A389:        .db $DD,$D5,$D5,$DD,$23,$2B,$2B,$23
                    .db $DD,$D5,$D5,$DD,$23,$2B,$2B,$23
                    .db $DE,$D6,$D6,$DE,$22,$2A,$2A,$22
                    .db $DF,$D7,$D7,$DF,$21,$29,$29,$21
                    .db $E0,$D8,$D8,$E0,$20,$28,$28,$20
                    .db $E2,$DA,$DA,$E2,$1E,$26,$26,$1E
                    .db $E4,$DC,$DC,$E4,$1C,$24,$24,$1C
                    .db $E8,$E0,$E0,$E8,$18,$20,$20,$18
                    .db $F0,$E8,$E8,$F0,$10,$18,$18,$10
DATA_03A3D1:        .db $80,$40,$00,$C0,$00,$C0,$80,$40
DATA_03A3D9:        .db $E3,$ED,$ED,$EB,$EB,$E9,$E9,$E7
                    .db $E7

ADDR_03A3E2:        JSR.W GetDrawInfoBnk3     
                    LDA.W $1564,X             
                    DEC A                     
                    LSR                       
                    STA $03                   
                    ASL                       
                    ASL                       
                    ASL                       
                    STA $02                   
                    LDA.B #$70                
                    STA.W $15EA,X             
                    TAY                       
                    PHX                       
                    LDX.B #$07                
ADDR_03A3FA:        PHX                       
                    TXA                       
                    ORA $02                   
                    TAX                       
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_03A341,X       
                    CLC                       
                    ADC.B #$08                
                    STA.W $0300,Y             
                    LDA $01                   
                    CLC                       
                    ADC.W DATA_03A389,X       
                    CLC                       
                    ADC.B #$30                
                    STA.W $0301,Y             
                    LDX $03                   
                    LDA.W DATA_03A3D9,X       
                    STA.W $0302,Y             
                    PLX                       
                    LDA.W DATA_03A3D1,X       
                    STA.W $0303,Y             
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_03A3FA           
                    PLX                       
                    LDY.B #$02                
                    LDA.B #$07                
                    JSL.L FinishOAMWrite      
                    RTS                       ; Return

DATA_03A437:        .db $00,$00,$00,$00,$02,$04,$06,$08
                    .db $0A,$0E

ADDR_03A441:        LDA.W $154C,X             
                    BNE ADDR_03A482           
                    LDA.W $1540,X             
                    BNE ADDR_03A465           
                    LDA.B #$0E                
                    STA.W $1570,X             
                    LDA.B #$04                
                    STA $AA,X                 
                    STZ $B6,X                 ; Sprite X Speed = 0
                    LDA $D8,X                 
                    SEC                       
                    SBC $1C                   
                    CMP.B #$10                
                    BNE Return03A464          
                    LDA.B #$A4                
                    STA.W $1540,X             
Return03A464:       RTS                       ; Return

ADDR_03A465:        STZ $AA,X                 ; Sprite Y Speed = 0
                    STZ $B6,X                 ; Sprite X Speed = 0
                    CMP.B #$01                
                    BEQ ADDR_03A47C           
                    CMP.B #$40                
                    BCS Return03A47B          
                    LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_03A437,Y       
                    STA.W $1570,X             
Return03A47B:       RTS                       ; Return

ADDR_03A47C:        LDA.B #$24                
                    STA.W $154C,X             
                    RTS                       ; Return

ADDR_03A482:        DEC A                     
                    BNE Return03A48F          
                    LDA.B #$07                
                    STA.W $151C,X             
                    LDA.B #$78                
                    STA.W $14B0               
Return03A48F:       RTS                       ; Return

DATA_03A490:        .db $FF,$01

DATA_03A492:        .db $C8,$38

DATA_03A494:        .db $01,$FF

DATA_03A496:        .db $1C,$E4

DATA_03A498:        .db $00,$02,$04,$02

ADDR_03A49C:        JSR.W ADDR_03A4D2         
                    JSR.W ADDR_03A4FD         
                    JSR.W ADDR_03A4ED         
                    LDA.W $1528,X             
                    AND.B #$01                
                    TAY                       
                    LDA $B6,X                 
                    CLC                       
                    ADC.W DATA_03A490,Y       
                    STA $B6,X                 
                    CMP.W DATA_03A492,Y       
                    BNE ADDR_03A4BB           
                    INC.W $1528,X             
ADDR_03A4BB:        LDA.W $1534,X             
                    AND.B #$01                
                    TAY                       
                    LDA $AA,X                 
                    CLC                       
                    ADC.W DATA_03A494,Y       
                    STA $AA,X                 
                    CMP.W DATA_03A496,Y       
                    BNE Return03A4D1          
                    INC.W $1534,X             
Return03A4D1:       RTS                       ; Return

ADDR_03A4D2:        LDY.B #$00                
                    LDA $13                   
                    AND.B #$E0                
                    BNE ADDR_03A4E6           
                    LDA $13                   
                    AND.B #$18                
                    LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_03A498,Y       
                    TAY                       
ADDR_03A4E6:        TYA                       
                    STA.W $1570,X             
                    RTS                       ; Return

DATA_03A4EB:        .db $80,$00

ADDR_03A4ED:        LDA $13                   
                    AND.B #$1F                
                    BNE Return03A4FC          
                    JSR.W SubHorzPosBnk3      
                    LDA.W DATA_03A4EB,Y       
                    STA.W $157C,X             
Return03A4FC:       RTS                       ; Return

ADDR_03A4FD:        LDA.W $14B0               
                    BNE Return03A52C          
                    LDA.W $151C,X             
                    CMP.B #$08                
                    BNE ADDR_03A51A           
                    INC.W $14B8               
                    LDA.W $14B8               
                    CMP.B #$03                
                    BEQ ADDR_03A51A           
                    LDA.B #$FF                
                    STA.W $14B6               
                    BRA Return03A52C          

ADDR_03A51A:        STZ.W $14B8               
                    LDA.W $14C8               
                    BEQ ADDR_03A527           
                    LDA.W $14C9               
                    BNE Return03A52C          
ADDR_03A527:        LDA.B #$FF                
                    STA.W $14B1               
Return03A52C:       RTS                       ; Return

DATA_03A52D:        .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$02,$04,$06,$08,$0A,$0E,$0E
                    .db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
                    .db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
                    .db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
                    .db $0E,$0E,$0A,$08,$06,$04,$02,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
DATA_03A56D:        .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$10,$20,$30,$40,$50,$60
                    .db $80,$A0,$C0,$E0,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$C0,$80,$60
                    .db $40,$30,$20,$10,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00

ADDR_03A5AD:        LDA.W $14B1               
                    BEQ ADDR_03A5D8           
                    DEC.W $14B1               
                    BNE ADDR_03A5BD           
                    LDA.B #$54                
                    STA.W $14B0               
                    RTS                       ; Return

ADDR_03A5BD:        LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_03A52D,Y       
                    STA.W $1570,X             
                    LDA.W $14B1               
                    CMP.B #$80                
                    BNE ADDR_03A5D5           
                    JSR.W ADDR_03B019         
                    LDA.B #$08                ; \ Play sound effect
                    STA.W $1DFC               ; /
ADDR_03A5D5:        PLA                       
                    PLA                       
                    RTS                       ; Return

ADDR_03A5D8:        LDA.W $14B6               
                    BEQ Return03A60D          
                    DEC.W $14B6               
                    BEQ ADDR_03A60E           
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_03A52D,Y       
                    STA.W $1570,X             
                    LDA.W DATA_03A56D,Y       
                    STA $36                   
                    STZ $37                   
                    CMP.B #$FF                
                    BNE ADDR_03A5FC           
                    STZ $36                   
                    INC $37                   
                    STZ $64                   
ADDR_03A5FC:        LDA.W $14B6               
                    CMP.B #$80                
                    BNE ADDR_03A60B           
                    LDA.B #$09                ; \ Play sound effect
                    STA.W $1DFC               ; /
                    JSR.W ADDR_03A61D         
ADDR_03A60B:        PLA                       
                    PLA                       
Return03A60D:       RTS                       ; Return

ADDR_03A60E:        LDA.B #$60                
                    LDY.W $14B8               
                    CPY.B #$02                
                    BEQ ADDR_03A619           
                    LDA.B #$20                
ADDR_03A619:        STA.W $14B0               
                    RTS                       ; Return

ADDR_03A61D:        LDA.B #$08                
                    STA.W $14D0               
                    LDA.B #$A1                
                    STA $A6                   
                    LDA $E4,X                 
                    CLC                       
                    ADC.B #$08                
                    STA $EC                   
                    LDA.W $14E0,X             
                    ADC.B #$00                
                    STA.W $14E8               
                    LDA $D8,X                 
                    CLC                       
                    ADC.B #$40                
                    STA $E0                   
                    LDA.W $14D4,X             
                    ADC.B #$00                
                    STA.W $14DC               
                    PHX                       
                    LDX.B #$08                
                    JSL.L InitSpriteTables    
                    PLX                       
                    RTS                       ; Return

DATA_03A64D:        .db $00,$00,$00,$00,$FC,$F8,$F4,$F0
                    .db $F4,$F8,$FC,$00,$04,$08,$0C,$10
                    .db $0C,$08,$04,$00

ADDR_03A661:        LDA.W $14B5               
                    BEQ Return03A6BF          
                    STZ.W $14B1               
                    STZ.W $14B6               
                    DEC.W $14B5               
                    BNE ADDR_03A691           
                    LDA.B #$50                
                    STA.W $14B0               
                    DEC.W $187B,X             
                    BNE ADDR_03A691           
                    LDA.W $151C,X             
                    CMP.B #$09                
                    BEQ ADDR_03A6C0           
                    LDA.B #$02                
                    STA.W $187B,X             
                    LDA.B #$01                
                    STA.W $151C,X             
                    LDA.B #$80                
                    STA.W $1540,X             
ADDR_03A691:        PLY                       
                    PLY                       
                    PHA                       
                    LDA.W $14B5               
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_03A64D,Y       
                    STA $36                   
                    STZ $37                   
                    BPL ADDR_03A6A5           
                    INC $37                   
ADDR_03A6A5:        PLA                       
                    LDY.B #$0C                
                    CMP.B #$40                
                    BCS ADDR_03A6B6           
ADDR_03A6AC:        LDA $13                   
                    LDY.B #$10                
                    AND.B #$04                
                    BEQ ADDR_03A6B6           
                    LDY.B #$12                
ADDR_03A6B6:        TYA                       
                    STA.W $1570,X             
                    LDA.B #$02                
                    STA.W $1427               
Return03A6BF:       RTS                       ; Return

ADDR_03A6C0:        LDA.B #$04                
                    STA.W $151C,X             
                    STZ $B6,X                 ; Sprite X Speed = 0
                    RTS                       ; Return

KillMostSprites:    LDY.B #$09                
ADDR_03A6CA:        LDA.W $14C8,Y             
                    BEQ ADDR_03A6EC           
                    LDA.W $009E,Y             
                    CMP.B #$A9                
                    BEQ ADDR_03A6EC           
                    CMP.B #$29                
                    BEQ ADDR_03A6EC           
                    CMP.B #$A0                
                    BEQ ADDR_03A6EC           
                    CMP.B #$C5                
                    BEQ ADDR_03A6EC           
                    LDA.B #$04                ; \ Sprite status = Killed by spin jump
                    STA.W $14C8,Y             ; /
                    LDA.B #$1F                ;  \ Time to show cloud of smoke = #$1F
                    STA.W $1540,Y             ;  /
ADDR_03A6EC:        DEY                       
                    BPL ADDR_03A6CA           
                    RTL                       ; Return

DATA_03A6F0:        .db $0E,$0E,$0A,$08,$06,$04,$02,$00

ADDR_03A6F8:        LDA.W $1540,X             
                    BEQ ADDR_03A731           
                    CMP.B #$01                
                    BNE ADDR_03A706           
                    LDY.B #$17                
                    STY.W $1DFB               ; / Change music
ADDR_03A706:        LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_03A6F0,Y       
                    STA.W $1570,X             
                    STZ $B6,X                 ; Sprite X Speed = 0
                    STZ $AA,X                 ; Sprite Y Speed = 0
                    STZ.W $1528,X             
                    STZ.W $1534,X             
                    STZ.W $14B2               
                    RTS                       ; Return

DATA_03A71F:        .db $01,$FF

DATA_03A721:        .db $10,$80

DATA_03A723:        .db $07,$03

DATA_03A725:        .db $FF,$01

DATA_03A727:        .db $F0,$08

DATA_03A729:        .db $01,$FF

DATA_03A72B:        .db $03,$03

DATA_03A72D:        .db $60,$02

DATA_03A72F:        .db $01,$01

ADDR_03A731:        LDY.W $1528,X             
                    CPY.B #$02                
                    BCS ADDR_03A74F           
                    LDA $13                   
                    AND.W DATA_03A723,Y       
                    BNE ADDR_03A74F           
                    LDA $B6,X                 
                    CLC                       
                    ADC.W DATA_03A71F,Y       
                    STA $B6,X                 
                    CMP.W DATA_03A721,Y       
                    BNE ADDR_03A74F           
                    INC.W $1528,X             
ADDR_03A74F:        LDY.W $1534,X             
                    CPY.B #$02                
                    BCS ADDR_03A76D           
                    LDA $13                   
                    AND.W DATA_03A72B,Y       
                    BNE ADDR_03A76D           
                    LDA $AA,X                 
                    CLC                       
                    ADC.W DATA_03A725,Y       
                    STA $AA,X                 
                    CMP.W DATA_03A727,Y       
                    BNE ADDR_03A76D           
                    INC.W $1534,X             
ADDR_03A76D:        LDY.W $14B2               
                    CPY.B #$02                
                    BEQ ADDR_03A794           
                    LDA $13                   
                    AND.W DATA_03A72F,Y       
                    BNE ADDR_03A78D           
                    LDA $38                   
                    CLC                       
                    ADC.W DATA_03A729,Y       
                    STA $38                   
                    STA $39                   
                    CMP.W DATA_03A72D,Y       
                    BNE ADDR_03A78D           
                    INC.W $14B2               
ADDR_03A78D:        LDA.W $14E0,X             
                    CMP.B #$FE                
                    BNE Return03A7AC          
ADDR_03A794:        LDA.B #$03                
                    STA.W $151C,X             
                    LDA.B #$80                
                    STA.W $14B0               
                    JSL.L GetRand             
                    AND.B #$F0                
                    STA.W $14B7               
                    LDA.B #$1D                
                    STA.W $1DFB               ; / Change music
Return03A7AC:       RTS                       ; Return

ADDR_03A7AD:        LDA.B #$60                
                    STA $38                   
                    STA $39                   
                    LDA.B #$FF                
                    STA.W $14E0,X             
                    LDA.B #$60                
                    STA $E4,X                 
                    LDA.W $14B0               
                    BNE ADDR_03A7DF           
                    LDA.B #$18                
                    STA.W $1DFB               ; / Change music
                    LDA.B #$02                
                    STA.W $151C,X             
                    LDA.B #$18                
                    STA $D8,X                 
                    LDA.B #$00                
                    STA.W $14D4,X             
                    LDA.B #$08                
                    STA $38                   
                    STA $39                   
                    LDA.B #$64                
                    STA $B6,X                 
                    RTS                       ; Return

ADDR_03A7DF:        CMP.B #$60                
                    BCS Return03A840          
                    LDA $13                   
                    AND.B #$1F                
                    BNE Return03A840          
                    LDY.B #$07                
ADDR_03A7EB:        LDA.W $14C8,Y             
                    BEQ ADDR_03A7F6           
                    DEY                       
                    CPY.B #$01                
                    BNE ADDR_03A7EB           
                    RTS                       ; Return

ADDR_03A7F6:        LDA.B #$17                ; \ Play sound effect
                    STA.W $1DFC               ; /
                    LDA.B #$08                ; \ Sprite status = Normal
                    STA.W $14C8,Y             ; /
                    LDA.B #$33                
                    STA.W $009E,Y             
                    LDA.W $14B7               
                    PHA                       
                    STA.W $00E4,Y             
                    CLC                       
                    ADC.B #$20                
                    STA.W $14B7               
                    LDA.B #$00                
                    STA.W $14E0,Y             
                    LDA.B #$00                
                    STA.W $00D8,Y             
                    STA.W $14D4,Y             
                    PHX                       
                    TYX                       
                    JSL.L InitSpriteTables    
                    INC $C2,X                 
                    ASL.W $1686,X             
                    LSR.W $1686,X             
                    LDA.B #$39                
                    STA.W $1662,X             
                    PLX                       
                    PLA                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W BowserSound,Y       
                    STA.W $1DFC               ; / Play sound effect
Return03A840:       RTS                       ; Return

BowserSound:        .db $2D

BowserSoundMusic:   .db $2E,$2F,$30,$31,$32,$33,$34,$19
                    .db $1A

ADDR_03A84B:        STZ $AA,X                 ; Sprite Y Speed = 0
                    LDA.W $1540,X             
                    BNE ADDR_03A86E           
                    LDA $B6,X                 
                    BEQ ADDR_03A858           
                    DEC $B6,X                 
ADDR_03A858:        LDA $13                   
                    AND.B #$03                
                    BNE Return03A86D          
                    INC $38                   
                    INC $39                   
                    LDA $38                   
                    CMP.B #$20                
                    BNE Return03A86D          
                    LDA.B #$FF                
                    STA.W $1540,X             
Return03A86D:       RTS                       ; Return

ADDR_03A86E:        CMP.B #$A0                
                    BNE ADDR_03A877           
                    PHA                       
                    JSR.W ADDR_03A8D6         
                    PLA                       
ADDR_03A877:        STZ $B6,X                 ; Sprite X Speed = 0
                    STZ $AA,X                 ; Sprite Y Speed = 0
                    CMP.B #$01                
                    BEQ ADDR_03A89D           
                    CMP.B #$40                
                    BCS ADDR_03A8AE           
                    CMP.B #$3F                
                    BNE ADDR_03A892           
                    PHA                       
                    LDY.W $14B4               
                    LDA.W BowserSoundMusic,Y  
                    STA.W $1DFB               ; / Change music
                    PLA                       
ADDR_03A892:        LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_03A437,Y       
                    STA.W $1570,X             
                    RTS                       ; Return

ADDR_03A89D:        LDA.W $14B4               
                    INC A                     
                    STA.W $151C,X             
                    STZ $B6,X                 ; Sprite X Speed = 0
                    STZ $AA,X                 ; Sprite Y Speed = 0
                    LDA.B #$80                
                    STA.W $14B0               
                    RTS                       ; Return

ADDR_03A8AE:        CMP.B #$E8                
                    BNE ADDR_03A8B7           
                    LDY.B #$2A                ; \ Play sound effect
                    STY.W $1DF9               ; /
ADDR_03A8B7:        SEC                       
                    SBC.B #$3F                
                    STA.W $1594,X             
                    RTS                       ; Return

DATA_03A8BE:        .db $00,$00,$00,$08,$10,$14,$14,$16
                    .db $16,$18,$18,$17,$16,$16,$17,$18
                    .db $18,$17,$14,$10,$0C,$08,$04,$00

ADDR_03A8D6:        LDY.B #$07                
ADDR_03A8D8:        LDA.W $14C8,Y             
                    BEQ ADDR_03A8E3           
                    DEY                       
                    CPY.B #$01                
                    BNE ADDR_03A8D8           
                    RTS                       ; Return

ADDR_03A8E3:        LDA.B #$10                ; \ Play sound effect
                    STA.W $1DF9               ; /
                    LDA.B #$08                ; \ Sprite status = Normal
                    STA.W $14C8,Y             ; /
                    LDA.B #$74                
                    STA.W $009E,Y             
                    LDA $E4,X                 
                    CLC                       
                    ADC.B #$04                
                    STA.W $00E4,Y             
                    LDA.W $14E0,X             
                    ADC.B #$00                
                    STA.W $14E0,Y             
                    LDA $D8,X                 
                    CLC                       
                    ADC.B #$18                
                    STA.W $00D8,Y             
                    LDA.W $14D4,X             
                    ADC.B #$00                
                    STA.W $14D4,Y             
                    PHX                       
                    TYX                       
                    JSL.L InitSpriteTables    
                    LDA.B #$C0                
                    STA $AA,X                 
                    STZ.W $157C,X             
                    LDY.B #$0C                
                    LDA $E4,X                 
                    BPL ADDR_03A92A           
                    LDY.B #$F4                
                    INC.W $157C,X             
ADDR_03A92A:        STY $B6,X                 
                    PLX                       
                    RTS                       ; Return

DATA_03A92E:        .db $00,$08,$00,$08,$00,$08,$00,$08
                    .db $00,$08,$00,$08,$00,$08,$00,$08
                    .db $00,$08,$00,$08,$00,$08,$00,$08
                    .db $00,$08,$00,$08,$00,$08,$00,$08
                    .db $00,$08,$00,$08,$00,$08,$00,$08
                    .db $00,$08,$00,$08,$00,$08,$00,$08
                    .db $08,$00,$08,$00,$08,$00,$08,$00
                    .db $08,$00,$08,$00,$08,$00,$08,$00
                    .db $08,$00,$08,$00,$08,$00,$08,$00
                    .db $08,$00,$08,$00,$08,$00,$08,$00
DATA_03A97E:        .db $00,$00,$08,$08,$00,$00,$08,$08
                    .db $00,$00,$08,$08,$00,$00,$08,$08
                    .db $00,$00,$10,$10,$00,$00,$10,$10
                    .db $00,$00,$10,$10,$00,$00,$10,$10
                    .db $00,$00,$10,$10,$00,$00,$10,$10
                    .db $00,$00,$10,$10,$00,$00,$10,$10
                    .db $00,$00,$10,$10,$00,$00,$10,$10
                    .db $00,$00,$10,$10,$00,$00,$10,$10
                    .db $00,$00,$10,$10,$00,$00,$10,$10
                    .db $00,$00,$10,$10,$00,$00,$10,$10
DATA_03A9CE:        .db $05,$06,$15,$16,$9D,$9E,$4E,$AE
                    .db $06,$05,$16,$15,$9E,$9D,$AE,$4E
                    .db $8A,$8B,$AA,$68,$83,$84,$AA,$68
                    .db $8A,$8B,$80,$81,$83,$84,$80,$81
                    .db $85,$86,$A5,$A6,$83,$84,$A5,$A6
                    .db $82,$83,$A2,$A3,$82,$83,$A2,$A3
                    .db $8A,$8B,$AA,$68,$83,$84,$AA,$68
                    .db $8A,$8B,$80,$81,$83,$84,$80,$81
                    .db $85,$86,$A5,$A6,$83,$84,$A5,$A6
                    .db $82,$83,$A2,$A3,$82,$83,$A2,$A3
DATA_03AA1E:        .db $01,$01,$01,$01,$01,$01,$01,$01
                    .db $41,$41,$41,$41,$41,$41,$41,$41
                    .db $01,$01,$01,$01,$01,$01,$01,$01
                    .db $01,$01,$01,$01,$01,$01,$01,$01
                    .db $00,$00,$00,$00,$01,$01,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $41,$41,$41,$41,$41,$41,$41,$41
                    .db $41,$41,$41,$41,$41,$41,$41,$41
                    .db $40,$40,$40,$40,$41,$41,$40,$40
                    .db $40,$40,$40,$40,$40,$40,$40,$40

ADDR_03AA6E:        LDA $E4,X                 
                    CLC                       
                    ADC.B #$04                
                    SEC                       
                    SBC $1A                   
                    STA $00                   
                    LDA $D8,X                 
                    CLC                       
                    ADC.B #$20                
                    SEC                       
                    SBC $02                   
                    SEC                       
                    SBC $1C                   
                    STA $01                   
                    CPY.B #$08                
                    BCC ADDR_03AAC6           
                    CPY.B #$10                
                    BCS ADDR_03AAC6           
                    LDA $00                   
                    SEC                       
                    SBC.B #$04                
                    STA.W $02A0               
                    CLC                       
                    ADC.B #$10                
                    STA.W $02A4               
                    LDA $01                   
                    SEC                       
                    SBC.B #$18                
                    STA.W $02A1               
                    STA.W $02A5               
                    LDA.B #$20                
                    STA.W $02A2               
                    LDA.B #$22                
                    STA.W $02A6               
                    LDA $14                   
                    LSR                       
                    AND.B #$06                
                    INC A                     
                    INC A                     
                    INC A                     
                    STA.W $02A3               
                    STA.W $02A7               
                    LDA.B #$02                
                    STA.W $0448               
                    STA.W $0449               
ADDR_03AAC6:        LDY.B #$70                
ADDR_03AAC8:        LDA $03                   
                    ASL                       
                    ASL                       
                    STA $04                   
                    PHX                       
                    LDX.B #$03                
ADDR_03AAD1:        PHX                       
                    TXA                       
                    CLC                       
                    ADC $04                   
                    TAX                       
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_03A92E,X       
                    STA.W $0300,Y             
                    LDA $01                   
                    CLC                       
                    ADC.W DATA_03A97E,X       
                    STA.W $0301,Y             
                    LDA.W DATA_03A9CE,X       
                    STA.W $0302,Y             
                    LDA.W DATA_03AA1E,X       
                    PHX                       
                    LDX.W $15E9               ; X = Sprite index
                    CPX.B #$09                
                    BEQ ADDR_03AAFC           
                    ORA.B #$30                
ADDR_03AAFC:        STA.W $0303,Y             
                    PLX                       
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
                    PLX                       
                    DEX                       
                    BPL ADDR_03AAD1           
                    PLX                       
                    RTS                       ; Return

DATA_03AB15:        .db $01,$FF

DATA_03AB17:        .db $20,$E0

DATA_03AB19:        .db $02,$FE

DATA_03AB1B:        .db $20,$E0,$01,$FF,$10,$F0

ADDR_03AB21:        JSR.W ADDR_03A4FD         
                    JSR.W ADDR_03A4D2         
                    JSR.W ADDR_03A4ED         
                    LDA $13                   
                    AND.B #$00                
                    BNE ADDR_03AB4B           
                    LDY.B #$00                
                    LDA $E4,X                 
                    CMP $94                   
                    LDA.W $14E0,X             
                    SBC $95                   
                    BMI ADDR_03AB3E           
                    INY                       
ADDR_03AB3E:        LDA $B6,X                 
                    CMP.W DATA_03AB17,Y       
                    BEQ ADDR_03AB4B           
                    CLC                       
                    ADC.W DATA_03AB15,Y       
                    STA $B6,X                 
ADDR_03AB4B:        LDY.B #$00                
                    LDA $D8,X                 
                    CMP.B #$10                
                    BMI ADDR_03AB54           
                    INY                       
ADDR_03AB54:        LDA $AA,X                 
                    CMP.W DATA_03AB1B,Y       
                    BEQ Return03AB61          
                    CLC                       
                    ADC.W DATA_03AB19,Y       
                    STA $AA,X                 
Return03AB61:       RTS                       ; Return

DATA_03AB62:        .db $10,$F0

ADDR_03AB64:        LDA.B #$03                
                    STA.W $1427               
                    JSR.W ADDR_03A4FD         
                    JSR.W ADDR_03A4D2         
                    JSR.W ADDR_03A4ED         
                    LDA $AA,X                 
                    CLC                       
                    ADC.B #$03                
                    STA $AA,X                 
                    LDA $D8,X                 
                    CMP.B #$64                
                    BCC Return03AB9E          
                    LDA.W $14D4,X             
                    BMI Return03AB9E          
                    LDA.B #$64                
                    STA $D8,X                 
                    LDA.B #$A0                
                    STA $AA,X                 
                    LDA.B #$09                ; \ Play sound effect
                    STA.W $1DFC               ; /
                    JSR.W SubHorzPosBnk3      
                    LDA.W DATA_03AB62,Y       
                    STA $B6,X                 
                    LDA.B #$20                ;  \ Set ground shake timer
                    STA.W $1887               ;  /
Return03AB9E:       RTS                       ; Return

ADDR_03AB9F:        JSR.W ADDR_03A6AC         
                    LDA.W $14D4,X             
                    BMI ADDR_03ABAF           
                    BNE ADDR_03ABB9           
                    LDA $D8,X                 
                    CMP.B #$10                
                    BCS ADDR_03ABB9           
ADDR_03ABAF:        LDA.B #$05                
                    STA.W $151C,X             
                    LDA.B #$60                
                    STA.W $1540,X             
ADDR_03ABB9:        LDA.B #$F8                
                    STA $AA,X                 
                    RTS                       ; Return

ADDR_03ABBE:        JSR.W ADDR_03A6AC         
                    STZ $B6,X                 ; Sprite X Speed = 0
                    STZ $AA,X                 ; Sprite Y Speed = 0
                    LDA.W $1540,X             
                    BNE ADDR_03ABEB           
                    LDA $36                   
                    CLC                       
                    ADC.B #$0A                
                    STA $36                   
                    LDA $37                   
                    ADC.B #$00                
                    STA $37                   
                    BEQ Return03ABEA          
                    STZ $36                   
                    LDA.B #$20                
                    STA.W $154C,X             
                    LDA.B #$60                
                    STA.W $1540,X             
                    LDA.B #$06                
                    STA.W $151C,X             
Return03ABEA:       RTS                       ; Return

ADDR_03ABEB:        CMP.B #$40                
                    BCC Return03AC02          
                    CMP.B #$5E                
                    BNE ADDR_03ABF8           
                    LDY.B #$1B                
                    STY.W $1DFB               ; / Change music
ADDR_03ABF8:        LDA.W $1564,X             
                    BNE Return03AC02          
                    LDA.B #$12                
                    STA.W $1564,X             
Return03AC02:       RTS                       ; Return

ADDR_03AC03:        JSR.W ADDR_03A6AC         
                    LDA.W $154C,X             
                    CMP.B #$01                
                    BNE ADDR_03AC22           
                    LDA.B #$0B                
                    STA $71                   
                    INC.W $190D               
                    STZ.W $0701               
                    STZ.W $0702               
                    LDA.B #$03                
                    STA.W $13F9               
                    JSR.W ADDR_03AC63         
ADDR_03AC22:        LDA.W $1540,X             
                    BNE Return03AC4C          
                    LDA.B #$FA                
                    STA $B6,X                 
                    LDA.B #$FC                
                    STA $AA,X                 
                    LDA $36                   
                    CLC                       
                    ADC.B #$05                
                    STA $36                   
                    LDA $37                   
                    ADC.B #$00                
                    STA $37                   
                    LDA $13                   
                    AND.B #$03                
                    BNE Return03AC4C          
                    LDA $38                   
                    CMP.B #$80                
                    BCS ADDR_03AC4D           
                    INC $38                   
                    INC $39                   
Return03AC4C:       RTS                       ; Return

ADDR_03AC4D:        LDA.W $164A,X             
                    BNE ADDR_03AC5A           
                    LDA.B #$1C                
                    STA.W $1DFB               ; / Change music
                    INC.W $164A,X             
ADDR_03AC5A:        LDA.B #$FE                
                    STA.W $14E0,X             
                    STA.W $14D4,X             
                    RTS                       ; Return

ADDR_03AC63:        LDA.B #$08                
                    STA.W $14D0               
                    LDA.B #$7C                
                    STA $A6                   
                    LDA $E4,X                 
                    CLC                       
                    ADC.B #$08                
                    STA $EC                   
                    LDA.W $14E0,X             
                    ADC.B #$00                
                    STA.W $14E8               
                    LDA $D8,X                 
                    CLC                       
                    ADC.B #$47                
                    STA $E0                   
                    LDA.W $14D4,X             
                    ADC.B #$00                
                    STA.W $14DC               
                    PHX                       
                    LDX.B #$08                
                    JSL.L InitSpriteTables    
                    PLX                       
                    RTS                       ; Return

BlushTileDispY:     .db $01,$11

BlushTiles:         .db $6E,$88

PrincessPeach:      LDA $E4,X                 
                    SEC                       
                    SBC $1A                   
                    STA $00                   
                    LDA $D8,X                 
                    SEC                       
                    SBC $1C                   
                    STA $01                   
                    LDA $13                   
                    AND.B #$7F                
                    BNE ADDR_03ACB8           
                    JSL.L GetRand             
                    AND.B #$07                
                    BNE ADDR_03ACB8           
                    LDA.B #$0C                
                    STA.W $154C,X             
ADDR_03ACB8:        LDY.W $1602,X             
                    LDA.W $154C,X             
                    BEQ ADDR_03ACC1           
                    INY                       
ADDR_03ACC1:        LDA.W $157C,X             
                    BNE ADDR_03ACCB           
                    TYA                       
                    CLC                       
                    ADC.B #$08                
                    TAY                       
ADDR_03ACCB:        STY $03                   
                    LDA.B #$D0                
                    STA.W $15EA,X             
                    TAY                       
                    JSR.W ADDR_03AAC8         
                    LDY.B #$02                
                    LDA.B #$03                
                    JSL.L FinishOAMWrite      
                    LDA.W $1558,X             
                    BEQ ADDR_03AD18           
                    PHX                       
                    LDX.B #$00                
                    LDA $19                   
                    BNE ADDR_03ACEB           
                    INX                       
ADDR_03ACEB:        LDY.B #$4C                
                    LDA $7E                   
                    STA.W $0300,Y             
                    LDA $80                   
                    CLC                       
                    ADC.W BlushTileDispY,X    
                    STA.W $0301,Y             
                    LDA.W BlushTiles,X        
                    STA.W $0302,Y             
                    PLX                       
                    LDA $76                   
                    CMP.B #$01                
                    LDA.B #$31                
                    BCC ADDR_03AD0C           
                    ORA.B #$40                
ADDR_03AD0C:        STA.W $0303,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$02                
                    STA.W $0460,Y             
ADDR_03AD18:        STZ $B6,X                 ; Sprite X Speed = 0
                    STZ $7B                   
                    LDA.B #$04                
                    STA.W $1602,X             
                    LDA $C2,X                 
                    JSL.L ExecutePtr          

PeachPtrs:          .dw ADDR_03AD37           
                    .dw ADDR_03ADB3           
                    .dw ADDR_03ADDD           
                    .dw ADDR_03AE25           
                    .dw ADDR_03AE32           
                    .dw ADDR_03AEAF           
                    .dw ADDR_03AEE8           
                    .dw ADDR_03C796           

ADDR_03AD37:        LDA.B #$06                
                    STA.W $1602,X             
                    JSL.L UpdateYPosNoGrvty   
                    LDA $AA,X                 
                    CMP.B #$08                
                    BCS ADDR_03AD4B           
                    CLC                       
                    ADC.B #$01                
                    STA $AA,X                 
ADDR_03AD4B:        LDA.W $14D4,X             
                    BMI ADDR_03AD63           
                    LDA $D8,X                 
                    CMP.B #$A0                
                    BCC ADDR_03AD63           
                    LDA.B #$A0                
                    STA $D8,X                 
                    STZ $AA,X                 ; Sprite Y Speed = 0
                    LDA.B #$A0                
                    STA.W $1540,X             
                    INC $C2,X                 
ADDR_03AD63:        LDA $13                   
                    AND.B #$07                
                    BNE Return03AD73          
                    LDY.B #$0B                
ADDR_03AD6B:        LDA.W $17F0,Y             
                    BEQ ADDR_03AD74           
                    DEY                       
                    BPL ADDR_03AD6B           
Return03AD73:       RTS                       ; Return

ADDR_03AD74:        LDA.B #$05                
                    STA.W $17F0,Y             
                    JSL.L GetRand             
                    STZ $00                   
                    AND.B #$1F                
                    CLC                       
                    ADC.B #$F8                
                    BPL ADDR_03AD88           
                    DEC $00                   
ADDR_03AD88:        CLC                       
                    ADC $E4,X                 
                    STA.W $1808,Y             
                    LDA.W $14E0,X             
                    ADC $00                   
                    STA.W $18EA,Y             
                    LDA.W $148E               
                    AND.B #$1F                
                    ADC $D8,X                 
                    STA.W $17FC,Y             
                    LDA.W $14D4,X             
                    ADC.B #$00                
                    STA.W $1814,Y             
                    LDA.B #$00                
                    STA.W $1820,Y             
                    LDA.B #$17                
                    STA.W $1850,Y             
                    RTS                       ; Return

ADDR_03ADB3:        LDA.W $1540,X             
                    BNE ADDR_03ADC2           
                    INC $C2,X                 
                    JSR.W ADDR_03ADCC         
                    BCC ADDR_03ADC2           
                    INC.W $151C,X             
ADDR_03ADC2:        JSR.W SubHorzPosBnk3      
                    TYA                       
                    STA.W $157C,X             
                    STA $76                   
                    RTS                       ; Return

ADDR_03ADCC:        JSL.L GetSpriteClippingA  
                    JSL.L GetMarioClipping    
                    JSL.L CheckForContact     
                    RTS                       ; Return

DATA_03ADD9:        .db $08,$F8,$F8,$08

ADDR_03ADDD:        LDA $14                   
                    AND.B #$08                
                    BNE ADDR_03ADE8           
                    LDA.B #$08                
                    STA.W $1602,X             
ADDR_03ADE8:        JSR.W ADDR_03ADCC         
                    PHP                       
                    JSR.W SubHorzPosBnk3      
                    PLP                       
                    LDA.W $151C,X             
                    BNE ADDR_03ADF9           
                    BCS ADDR_03AE14           
                    BRA ADDR_03ADFF           

ADDR_03ADF9:        BCC ADDR_03AE14           
                    TYA                       
                    EOR.B #$01                
                    TAY                       
ADDR_03ADFF:        LDA.W DATA_03ADD9,Y       
                    STA $B6,X                 
                    EOR.B #$FF                
                    INC A                     
                    STA $7B                   
                    TYA                       
                    STA.W $157C,X             
                    STA $76                   
                    JSL.L UpdateXPosNoGrvty   
                    RTS                       ; Return

ADDR_03AE14:        JSR.W SubHorzPosBnk3      
                    TYA                       
                    STA.W $157C,X             
                    STA $76                   
                    INC $C2,X                 
                    LDA.B #$60                
                    STA.W $1540,X             
                    RTS                       ; Return

ADDR_03AE25:        LDA.W $1540,X             
                    BNE Return03AE31          
                    INC $C2,X                 
                    LDA.B #$A0                
                    STA.W $1540,X             
Return03AE31:       RTS                       ; Return

ADDR_03AE32:        LDA.W $1540,X             
                    BNE ADDR_03AE3F           
                    INC $C2,X                 
                    STZ.W $188A               
                    STZ.W $188B               
ADDR_03AE3F:        CMP.B #$50                
                    BCC Return03AE5A          
                    PHA                       
                    BNE ADDR_03AE4B           
                    LDA.B #$14                
                    STA.W $154C,X             
ADDR_03AE4B:        LDA.B #$0A                
                    STA.W $1602,X             
                    PLA                       
                    CMP.B #$68                
                    BNE Return03AE5A          
                    LDA.B #$80                
                    STA.W $1558,X             
Return03AE5A:       RTS                       ; Return

DATA_03AE5B:        .db $08,$08,$08,$08,$08,$08,$18,$08
                    .db $08,$08,$08,$08,$08,$08,$08,$08
                    .db $08,$08,$08,$08,$08,$08,$20,$08
                    .db $08,$08,$08,$08,$20,$08,$08,$10
                    .db $08,$08,$08,$08,$08,$08,$08,$08
                    .db $20,$08,$08,$08,$08,$08,$20,$08
                    .db $04,$20,$08,$08,$08,$08,$08,$08
                    .db $08,$08,$08,$08,$08,$08,$10,$08
                    .db $08,$08,$08,$08,$08,$08,$08,$08
                    .db $08,$08,$10,$08,$08,$08,$08,$08
                    .db $08,$08,$08,$40

ADDR_03AEAF:        JSR.W ADDR_03D674         
                    LDA.W $1540,X             
                    BNE Return03AEC7          
                    LDY.W $1921               
                    CPY.B #$54                
                    BEQ ADDR_03AEC8           
                    INC.W $1921               
                    LDA.W DATA_03AE5B,Y       
                    STA.W $1540,X             
Return03AEC7:       RTS                       ; Return

ADDR_03AEC8:        INC $C2,X                 
                    LDA.B #$40                
                    STA.W $1540,X             
                    RTS                       ; Return

ADDR_03AED0:        INC $C2,X                 
                    LDA.B #$80                
                    STA.W $1FEB               
                    RTS                       ; Return

DATA_03AED8:        .db $00,$00,$94,$18,$18,$9C,$9C,$FF
                    .db $00,$00,$52,$63,$63,$73,$73,$7F

ADDR_03AEE8:        LDA.W $1540,X             
                    BEQ ADDR_03AED0           
                    LSR                       
                    STA $00                   
                    STZ $01                   
                    REP #$20                  ; Accum (16 bit) 
                    LDA $00                   
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ORA $00                   
                    STA $00                   
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ORA $00                   
                    STA $00                   
                    SEP #$20                  ; Accum (8 bit) 
                    PHX                       
                    TAX                       
                    LDY.W $0681               
                    LDA.B #$02                
                    STA.W $0682,Y             
                    LDA.B #$F1                
                    STA.W $0683,Y             
                    LDA $00                   
                    STA.W $0684,Y             
                    LDA $01                   
                    STA.W $0685,Y             
                    LDA.B #$00                
                    STA.W $0686,Y             
                    TYA                       
                    CLC                       
                    ADC.B #$04                
                    STA.W $0681               
                    PLX                       
                    JSR.W ADDR_03D674         
                    RTS                       ; Return

DATA_03AF34:        .db $F4,$FF,$0C,$19,$24,$19,$0C,$FF
DATA_03AF3C:        .db $FC,$F6,$F4,$F6,$FC,$02,$04,$02
DATA_03AF44:        .db $05,$05,$05,$05,$45,$45,$45,$45
DATA_03AF4C:        .db $34,$34,$34,$35,$35,$36,$36,$37
                    .db $38,$3A,$3E,$46,$54

ADDR_03AF59:        JSR.W GetDrawInfoBnk3     
                    LDA.W $157C,X             
                    STA $04                   
                    LDA $14                   
                    LSR                       
                    LSR                       
                    AND.B #$07                
                    STA $02                   
                    LDA.B #$EC                
                    STA.W $15EA,X             
                    TAY                       
                    PHX                       
                    LDX.B #$03                
ADDR_03AF72:        PHX                       
                    TXA                       
                    ASL                       
                    ASL                       
                    ADC $02                   
                    AND.B #$07                
                    TAX                       
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_03AF34,X       
                    STA.W $0300,Y             
                    LDA $01                   
                    CLC                       
                    ADC.W DATA_03AF3C,X       
                    STA.W $0301,Y             
                    LDA.B #$59                
                    STA.W $0302,Y             
                    LDA.W DATA_03AF44,X       
                    ORA $64                   
                    STA.W $0303,Y             
                    PLX                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_03AF72           
                    LDA.W $14B3               
                    INC.W $14B3               
                    LSR                       
                    LSR                       
                    LSR                       
                    CMP.B #$0D                
                    BCS ADDR_03AFD7           
                    TAX                       
                    LDY.B #$FC                
                    LDA $04                   
                    ASL                       
                    ROL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ADC $00                   
                    CLC                       
                    ADC.B #$15                
                    STA.W $0300,Y             
                    LDA $01                   
                    CLC                       
                    ADC.L DATA_03AF4C,X       
                    STA.W $0301,Y             
                    LDA.B #$49                
                    STA.W $0302,Y             
                    LDA.B #$07                
                    ORA $64                   
                    STA.W $0303,Y             
ADDR_03AFD7:        PLX                       
                    LDY.B #$00                
                    LDA.B #$04                
                    JSL.L FinishOAMWrite      
                    LDY.W $15EA,X             ; Y = Index into sprite OAM
                    PHX                       
                    LDX.B #$04                
ADDR_03AFE6:        LDA.W $0300,Y             
                    STA.W $0200,Y             
                    LDA.W $0301,Y             
                    STA.W $0201,Y             
                    LDA.W $0302,Y             
                    STA.W $0202,Y             
                    LDA.W $0303,Y             
                    STA.W $0203,Y             
                    PHY                       
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W $0460,Y             
                    STA.W $0420,Y             
                    PLY                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_03AFE6           
                    PLX                       
                    RTS                       ; Return

DATA_03B013:        .db $00,$10

DATA_03B015:        .db $00,$00

DATA_03B017:        .db $F8,$08

ADDR_03B019:        STZ $02                   
                    JSR.W ADDR_03B020         
                    INC $02                   
ADDR_03B020:        LDY.B #$01                
ADDR_03B022:        LDA.W $14C8,Y             
                    BEQ ADDR_03B02B           
                    DEY                       
                    BPL ADDR_03B022           
                    RTS                       ; Return

ADDR_03B02B:        LDA.B #$08                ; \ Sprite status = Normal
                    STA.W $14C8,Y             ; /
                    LDA.B #$A2                
                    STA.W $009E,Y             
                    LDA $D8,X                 
                    CLC                       
                    ADC.B #$10                
                    STA.W $00D8,Y             
                    LDA.W $14D4,X             
                    ADC.B #$00                
                    STA.W $14D4,Y             
                    LDA $E4,X                 
                    STA $00                   
                    LDA.W $14E0,X             
                    STA $01                   
                    PHX                       
                    LDX $02                   
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_03B013,X       
                    STA.W $00E4,Y             
                    LDA $01                   
                    ADC.W DATA_03B015,X       
                    STA.W $14E0,Y             
                    TYX                       
                    JSL.L InitSpriteTables    
                    LDY $02                   
                    LDA.W DATA_03B017,Y       
                    STA $B6,X                 
                    LDA.B #$C0                
                    STA $AA,X                 
                    PLX                       
                    RTS                       ; Return

DATA_03B074:        .db $40,$C0

DATA_03B076:        .db $10,$F0

ADDR_03B078:        LDA $38                   
                    CMP.B #$20                
                    BNE Return03B0DB          
                    LDA.W $151C,X             
                    CMP.B #$07                
                    BCC Return03B0F2          
                    LDA $36                   
                    ORA $37                   
                    BNE Return03B0F2          
                    JSR.W ADDR_03B0DC         
                    LDA.W $154C,X             
                    BNE Return03B0DB          
                    LDA.B #$24                
                    STA.W $1662,X             
                    JSL.L MarioSprInteract    
                    BCC ADDR_03B0BD           
                    JSR.W ADDR_03B0D6         
                    STZ $7D                   
                    JSR.W SubHorzPosBnk3      
                    LDA.W $14B1               
                    ORA.W $14B6               
                    BEQ ADDR_03B0B3           
                    LDA.W DATA_03B076,Y       
                    BRA ADDR_03B0B6           

ADDR_03B0B3:        LDA.W DATA_03B074,Y       
ADDR_03B0B6:        STA $7B                   
                    LDA.B #$01                ; \ Play sound effect
                    STA.W $1DF9               ; /
ADDR_03B0BD:        INC.W $1662,X             
                    JSL.L MarioSprInteract    
                    BCC ADDR_03B0C9           
                    JSR.W ADDR_03B0D2         
ADDR_03B0C9:        INC.W $1662,X             
                    JSL.L MarioSprInteract    
                    BCC Return03B0DB          
ADDR_03B0D2:        JSL.L HurtMario           
ADDR_03B0D6:        LDA.B #$20                
                    STA.W $154C,X             
Return03B0DB:       RTS                       ; Return

ADDR_03B0DC:        LDY.B #$01                
ADDR_03B0DE:        PHY                       
                    LDA.W $14C8,Y             
                    CMP.B #$09                
                    BNE ADDR_03B0EE           
                    LDA.W $15A0,Y             
                    BNE ADDR_03B0EE           
                    JSR.W ADDR_03B0F3         
ADDR_03B0EE:        PLY                       
                    DEY                       
                    BPL ADDR_03B0DE           
Return03B0F2:       RTS                       ; Return

ADDR_03B0F3:        PHX                       
                    TYX                       
                    JSL.L GetSpriteClippingB  
                    PLX                       
                    LDA.B #$24                
                    STA.W $1662,X             
                    JSL.L GetSpriteClippingA  
                    JSL.L CheckForContact     
                    BCS ADDR_03B142           
                    INC.W $1662,X             
                    JSL.L GetSpriteClippingA  
                    JSL.L CheckForContact     
                    BCC Return03B160          
                    LDA.W $14B5               
                    BNE Return03B160          
                    LDA.B #$4C                
                    STA.W $14B5               
                    STZ.W $14B3               
                    LDA.W $151C,X             
                    STA.W $14B4               
                    LDA.B #$28                ; \ Play sound effect
                    STA.W $1DFC               ; /
                    LDA.W $151C,X             
                    CMP.B #$09                
                    BNE ADDR_03B142           
                    LDA.W $187B,X             
                    CMP.B #$01                
                    BNE ADDR_03B142           
                    PHY                       
                    JSL.L KillMostSprites     
                    PLY                       
ADDR_03B142:        LDA.B #$00                
                    STA.W $00B6,Y             
                    PHX                       
                    LDX.B #$10                
                    LDA.W $00AA,Y             
                    BMI ADDR_03B151           
                    LDX.B #$D0                
ADDR_03B151:        TXA                       
                    STA.W $00AA,Y             
                    LDA.B #$02                ; \ Sprite status = Killed
                    STA.W $14C8,Y             ; /
                    TYX                       
                    JSL.L ExtSub01AB6F        
                    PLX                       
Return03B160:       RTS                       ; Return

BowserBallSpeed:    .db $10,$F0

BowserBowlingBall:  JSR.W BowserBallGfx       
                    LDA $9D                   
                    BNE Return03B1D4          
                    JSR.W SubOffscreen0Bnk3   
                    JSL.L MarioSprInteract    
                    JSL.L UpdateXPosNoGrvty   
                    JSL.L UpdateYPosNoGrvty   
                    LDA $AA,X                 
                    CMP.B #$40                
                    BPL ADDR_03B186           
                    CLC                       
                    ADC.B #$03                
                    STA $AA,X                 
                    BRA ADDR_03B18A           

ADDR_03B186:        LDA.B #$40                
                    STA $AA,X                 
ADDR_03B18A:        LDA $AA,X                 
                    BMI ADDR_03B1C5           
                    LDA.W $14D4,X             
                    BMI ADDR_03B1C5           
                    LDA $D8,X                 
                    CMP.B #$B0                
                    BCC ADDR_03B1C5           
                    LDA.B #$B0                
                    STA $D8,X                 
                    LDA $AA,X                 
                    CMP.B #$3E                
                    BCC ADDR_03B1AD           
                    LDY.B #$25                ; \ Play sound effect
                    STY.W $1DFC               ; /
                    LDY.B #$20                ;  \ Set ground shake timer
                    STY.W $1887               ;  /
ADDR_03B1AD:        CMP.B #$08                
                    BCC ADDR_03B1B6           
                    LDA.B #$01                ; \ Play sound effect
                    STA.W $1DF9               ; /
ADDR_03B1B6:        JSR.W ADDR_03B7F8         
                    LDA $B6,X                 
                    BNE ADDR_03B1C5           
                    JSR.W SubHorzPosBnk3      
                    LDA.W BowserBallSpeed,Y   
                    STA $B6,X                 
ADDR_03B1C5:        LDA $B6,X                 
                    BEQ Return03B1D4          
                    BMI ADDR_03B1D1           
                    DEC.W $1570,X             
                    DEC.W $1570,X             
ADDR_03B1D1:        INC.W $1570,X             
Return03B1D4:       RTS                       ; Return

BowserBallDispX:    .db $F0,$00,$10,$F0,$00,$10,$F0,$00
                    .db $10,$00,$00,$F8

BowserBallDispY:    .db $E2,$E2,$E2,$F2,$F2,$F2,$02,$02
                    .db $02,$02,$02,$EA

BowserBallTiles:    .db $45,$47,$45,$65,$66,$65,$45,$47
                    .db $45,$39,$38,$63

BowserBallGfxProp:  .db $0D,$0D,$4D,$0D,$0D,$4D,$8D,$8D
                    .db $CD,$0D,$0D,$0D

BowserBallTileSize: .db $02,$02,$02,$02,$02,$02,$02,$02
                    .db $02,$00,$00,$02

BowserBallDispX2:   .db $04,$0D,$10,$0D,$04,$FB,$F8,$FB
BowserBallDispY2:   .db $00,$FD,$F4,$EB,$E8,$EB,$F4,$FD

BowserBallGfx:      LDA.B #$70                
                    STA.W $15EA,X             
                    JSR.W GetDrawInfoBnk3     
                    PHX                       
                    LDX.B #$0B                
ADDR_03B22C:        LDA $00                   
                    CLC                       
                    ADC.W BowserBallDispX,X   
                    STA.W $0300,Y             
                    LDA $01                   
                    CLC                       
                    ADC.W BowserBallDispY,X   
                    STA.W $0301,Y             
                    LDA.W BowserBallTiles,X   
                    STA.W $0302,Y             
                    LDA.W BowserBallGfxProp,X 
                    ORA $64                   
                    STA.W $0303,Y             
                    PHY                       
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W BowserBallTileSize,X
                    STA.W $0460,Y             
                    PLY                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_03B22C           
                    PLX                       
                    PHX                       
                    LDY.W $15EA,X             ; Y = Index into sprite OAM
                    LDA.W $1570,X             
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.B #$07                
                    PHA                       
                    TAX                       
                    LDA.W $0304,Y             
                    CLC                       
                    ADC.W BowserBallDispX2,X  
                    STA.W $0304,Y             
                    LDA.W $0305,Y             
                    CLC                       
                    ADC.W BowserBallDispY2,X  
                    STA.W $0305,Y             
                    PLA                       
                    CLC                       
                    ADC.B #$02                
                    AND.B #$07                
                    TAX                       
                    LDA.W $0308,Y             
                    CLC                       
                    ADC.W BowserBallDispX2,X  
                    STA.W $0308,Y             
                    LDA.W $0309,Y             
                    CLC                       
                    ADC.W BowserBallDispY2,X  
                    STA.W $0309,Y             
                    PLX                       
                    LDA.B #$0B                
                    LDY.B #$FF                
                    JSL.L FinishOAMWrite      
                    RTS                       ; Return

MechakoopaSpeed:    .db $08,$F8

MechaKoopa:         JSL.L ExtSub03B307        
                    LDA.W $14C8,X             
                    CMP.B #$08                
                    BNE Return03B306          
                    LDA $9D                   
                    BNE Return03B306          
                    JSR.W SubOffscreen0Bnk3   
                    JSL.L SprSpr_MarioSprRts  
                    JSL.L UpdateSpritePos     
                    LDA.W $1588,X             ; \ Branch if not on ground
                    AND.B #$04                ;  |
                    BEQ ADDR_03B2E3           ; /
                    STZ $AA,X                 ; Sprite Y Speed = 0
                    LDY.W $157C,X             
                    LDA.W MechakoopaSpeed,Y   
                    STA $B6,X                 
                    LDA $C2,X                 
                    INC $C2,X                 
                    AND.B #$3F                
                    BNE ADDR_03B2E3           
                    JSR.W SubHorzPosBnk3      
                    TYA                       
                    STA.W $157C,X             
ADDR_03B2E3:        LDA.W $1588,X             ; \ Branch if not touching object
                    AND.B #$03                ;  |
                    BEQ ADDR_03B2F9           ; /
                    LDA $B6,X                 
                    EOR.B #$FF                
                    INC A                     
                    STA $B6,X                 
                    LDA.W $157C,X             
                    EOR.B #$01                
                    STA.W $157C,X             
ADDR_03B2F9:        INC.W $1570,X             
                    LDA.W $1570,X             
                    AND.B #$0C                
                    LSR                       
                    LSR                       
                    STA.W $1602,X             
Return03B306:       RTS                       ; Return

ExtSub03B307:       PHB                       ; Wrapper
                    PHK                       
                    PLB                       
                    JSR.W MechaKoopaGfx       
                    PLB                       
                    RTL                       ; Return

MechakoopaDispX:    .db $F8,$08,$F8,$00,$08,$00,$10,$00
MechakoopaDispY:    .db $F8,$F8,$08,$00,$F9,$F9,$09,$00
                    .db $F8,$F8,$08,$00,$F9,$F9,$09,$00
                    .db $FD,$00,$05,$00,$00,$00,$08,$00
MechakoopaTiles:    .db $40,$42,$60,$51,$40,$42,$60,$0A
                    .db $40,$42,$60,$0C,$40,$42,$60,$0E
                    .db $00,$02,$10,$01,$00,$02,$10,$01
MechakoopaGfxProp:  .db $00,$00,$00,$00,$40,$40,$40,$40
MechakoopaTileSize: .db $02,$00,$00,$02

MechakoopaPalette:  .db $0B,$05

MechaKoopaGfx:      LDA.B #$0B                
                    STA.W $15F6,X             
                    LDA.W $1540,X             
                    BEQ ADDR_03B37F           
                    LDY.B #$05                
                    CMP.B #$05                
                    BCC ADDR_03B369           
                    CMP.B #$FA                
                    BCC ADDR_03B36B           
ADDR_03B369:        LDY.B #$04                
ADDR_03B36B:        TYA                       
                    STA.W $1602,X             
                    LDA.W $1540,X             
                    CMP.B #$30                
                    BCS ADDR_03B37F           
                    AND.B #$01                
                    TAY                       
                    LDA.W MechakoopaPalette,Y 
                    STA.W $15F6,X             
ADDR_03B37F:        JSR.W GetDrawInfoBnk3     
                    LDA.W $15F6,X             
                    STA $04                   
                    TYA                       
                    CLC                       
                    ADC.B #$0C                
                    TAY                       
                    LDA.W $1602,X             
                    ASL                       
                    ASL                       
                    STA $03                   
                    LDA.W $157C,X             
                    ASL                       
                    ASL                       
                    EOR.B #$04                
                    STA $02                   
                    PHX                       
                    LDX.B #$03                
ADDR_03B39F:        PHX                       
                    PHY                       
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W MechakoopaTileSize,X
                    STA.W $0460,Y             
                    PLY                       
                    PLA                       
                    PHA                       
                    CLC                       
                    ADC $02                   
                    TAX                       
                    LDA $00                   
                    CLC                       
                    ADC.W MechakoopaDispX,X   
                    STA.W $0300,Y             
                    LDA.W MechakoopaGfxProp,X 
                    ORA $04                   
                    ORA $64                   
                    STA.W $0303,Y             
                    PLA                       
                    PHA                       
                    CLC                       
                    ADC $03                   
                    TAX                       
                    LDA.W MechakoopaTiles,X   
                    STA.W $0302,Y             
                    LDA $01                   
                    CLC                       
                    ADC.W MechakoopaDispY,X   
                    STA.W $0301,Y             
                    PLX                       
                    DEY                       
                    DEY                       
                    DEY                       
                    DEY                       
                    DEX                       
                    BPL ADDR_03B39F           
                    PLX                       
                    LDY.B #$FF                
                    LDA.B #$03                
                    JSL.L FinishOAMWrite      
                    JSR.W MechaKoopaKeyGfx    
                    RTS                       ; Return

MechaKeyDispX:      .db $F9,$0F

MechaKeyGfxProp:    .db $4D,$0D

MechaKeyTiles:      .db $70,$71,$72,$71

MechaKoopaKeyGfx:   LDA.W $15EA,X             
                    CLC                       
                    ADC.B #$10                
                    STA.W $15EA,X             
                    JSR.W GetDrawInfoBnk3     
                    PHX                       
                    LDA.W $1570,X             
                    LSR                       
                    LSR                       
                    AND.B #$03                
                    STA $02                   
                    LDA.W $157C,X             
                    TAX                       
                    LDA $00                   
                    CLC                       
                    ADC.W MechaKeyDispX,X     
                    STA.W $0300,Y             
                    LDA $01                   
                    SEC                       
                    SBC.B #$00                
                    STA.W $0301,Y             
                    LDA.W MechaKeyGfxProp,X   
                    ORA $64                   
                    STA.W $0303,Y             
                    LDX $02                   
                    LDA.W MechaKeyTiles,X     
                    STA.W $0302,Y             
                    PLX                       
                    LDY.B #$00                
                    LDA.B #$00                
                    JSL.L FinishOAMWrite      
                    RTS                       ; Return

ADDR_03B43C:        JSR.W BowserItemBoxGfx    
                    JSR.W BowserSceneGfx      
                    RTS                       ; Return

BowserItemBoxPosX:  .db $70,$80,$70,$80

BowserItemBoxPosY:  .db $07,$07,$17,$17

BowserItemBoxProp:  .db $37,$77,$B7,$F7

BowserItemBoxGfx:   LDA.W $190D               
                    BEQ ADDR_03B457           
                    STZ.W $0DC2               
ADDR_03B457:        LDA.W $0DC2               
                    BEQ Return03B48B          
                    PHX                       
                    LDX.B #$03                
                    LDY.B #$04                
ADDR_03B461:        LDA.W BowserItemBoxPosX,X 
                    STA.W $0200,Y             
                    LDA.W BowserItemBoxPosY,X 
                    STA.W $0201,Y             
                    LDA.B #$43                
                    STA.W $0202,Y             
                    LDA.W BowserItemBoxProp,X 
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
                    BPL ADDR_03B461           
                    PLX                       
Return03B48B:       RTS                       ; Return

BowserRoofPosX:     .db $00,$30,$60,$90,$C0,$F0,$00,$30
                    .db $40,$50,$60,$90,$A0,$B0,$C0,$F0
BowserRoofPosY:     .db $B0,$B0,$B0,$B0,$B0,$B0,$D0,$D0
                    .db $D0,$D0,$D0,$D0,$D0,$D0,$D0,$D0

BowserSceneGfx:     PHX                       
                    LDY.B #$BC                
                    STZ $01                   
                    LDA.W $190D               
                    STA $0F                   
                    CMP.B #$01                
                    LDX.B #$10                
                    BCC ADDR_03B4BF           
                    LDY.B #$90                
                    DEX                       
ADDR_03B4BF:        LDA.B #$C0                
                    SEC                       
                    SBC $1C                   
                    STA.W $0301,Y             
                    LDA $01                   
                    SEC                       
                    SBC $1A                   
                    STA.W $0300,Y             
                    CLC                       
                    ADC.B #$10                
                    STA $01                   
                    LDA.B #$08                
                    STA.W $0302,Y             
                    LDA.B #$0D                
                    ORA $64                   
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
                    BPL ADDR_03B4BF           
                    LDX.B #$0F                
                    LDA $0F                   
                    BNE ADDR_03B532           
                    LDY.B #$14                
ADDR_03B4FA:        LDA.W BowserRoofPosX,X    
                    SEC                       
                    SBC $1A                   
                    STA.W $0200,Y             
                    LDA.W BowserRoofPosY,X    
                    SEC                       
                    SBC $1C                   
                    STA.W $0201,Y             
                    LDA.B #$08                
                    CPX.B #$06                
                    BCS ADDR_03B514           
                    LDA.B #$03                
ADDR_03B514:        STA.W $0202,Y             
                    LDA.B #$0D                
                    ORA $64                   
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
                    BPL ADDR_03B4FA           
                    BRA ADDR_03B56A           

ADDR_03B532:        LDY.B #$50                
ADDR_03B534:        LDA.W BowserRoofPosX,X    
                    SEC                       
                    SBC $1A                   
                    STA.W $0300,Y             
                    LDA.W BowserRoofPosY,X    
                    SEC                       
                    SBC $1C                   
                    STA.W $0301,Y             
                    LDA.B #$08                
                    CPX.B #$06                
                    BCS ADDR_03B54E           
                    LDA.B #$03                
ADDR_03B54E:        STA.W $0302,Y             
                    LDA.B #$0D                
                    ORA $64                   
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
                    BPL ADDR_03B534           
ADDR_03B56A:        PLX                       
                    RTS                       ; Return

SprClippingDispX:   .db $02,$02,$10,$14,$00,$00,$01,$08
                    .db $F8,$FE,$03,$06,$01,$00,$06,$02
                    .db $00,$E8,$FC,$FC,$04,$00,$FC,$02
                    .db $02,$02,$02,$02,$00,$02,$E0,$F0
                    .db $FC,$FC,$00,$F8,$F4,$F2,$00,$FC
                    .db $F2,$F0,$02,$00,$F8,$04,$02,$02
                    .db $08,$00,$00,$00,$FC,$03,$08,$00
                    .db $08,$04,$F8,$00

SprClippingWidth:   .db $0C,$0C,$10,$08,$30,$50,$0E,$28
                    .db $20,$14,$01,$03,$0D,$0F,$14,$24
                    .db $0F,$40,$08,$08,$18,$0F,$18,$0C
                    .db $0C,$0C,$0C,$0C,$0A,$1C,$30,$30
                    .db $08,$08,$10,$20,$38,$3C,$20,$18
                    .db $1C,$20,$0C,$10,$10,$08,$1C,$1C
                    .db $10,$30,$30,$40,$08,$12,$34,$0F
                    .db $20,$08,$20,$10

SprClippingDispY:   .db $03,$03,$FE,$08,$FE,$FE,$02,$08
                    .db $FE,$08,$07,$06,$FE,$FC,$06,$FE
                    .db $FE,$E8,$10,$10,$02,$FE,$F4,$08
                    .db $13,$23,$33,$43,$0A,$FD,$F8,$FC
                    .db $E8,$10,$00,$E8,$20,$04,$58,$FC
                    .db $E8,$FC,$F8,$02,$F8,$04,$FE,$FE
                    .db $F2,$FE,$FE,$FE,$FC,$00,$08,$F8
                    .db $10,$03,$10,$00

SprClippingHeight:  .db $0A,$15,$12,$08,$0E,$0E,$18,$30
                    .db $10,$1E,$02,$03,$16,$10,$14,$12
                    .db $20,$40,$34,$74,$0C,$0E,$18,$45
                    .db $3A,$2A,$1A,$0A,$30,$1B,$20,$12
                    .db $18,$18,$10,$20,$38,$14,$08,$18
                    .db $28,$1B,$13,$4C,$10,$04,$22,$20
                    .db $1C,$12,$12,$12,$08,$20,$2E,$14
                    .db $28,$0A,$10,$0D

MairoClipDispY:     .db $06,$14,$10,$18

MarioClippingHeight:.db $1A,$0C,$20,$18

GetMarioClipping:   PHX                       
                    LDA $94                   ; \
                    CLC                       ;  |
                    ADC.B #$02                ;  |
                    STA $00                   ;  | $00 = (Mario X position + #$02) Low byte
                    LDA $95                   ;  |
                    ADC.B #$00                ;  |
                    STA $08                   ; / $08 = (Mario X position + #$02) High byte
                    LDA.B #$0C                ; \ $06 = Clipping width X (#$0C)
                    STA $02                   ; /
                    LDX.B #$00                ; \ If mario small or ducking, X = #$01
                    LDA $73                   ;  | else, X = #$00
                    BNE ADDR_03B680           ;  |
                    LDA $19                   ;  |
                    BNE ADDR_03B681           ;  |
ADDR_03B680:        INX                       ; /
ADDR_03B681:        LDA.W $187A               ; \ If on Yoshi, X += #$02
                    BEQ ADDR_03B688           ;  |
                    INX                       ;  |
                    INX                       ; /
ADDR_03B688:        LDA.L MarioClippingHeight,X; \ $03 = Clipping height
                    STA $03                   ; /
                    LDA $96                   ; \
                    CLC                       ;  |
                    ADC.L MairoClipDispY,X    ;  |
                    STA $01                   ;  | $01 = (Mario Y position + displacement) Low byte
                    LDA $97                   ;  |
                    ADC.B #$00                ;  |
                    STA $09                   ; / $09 = (Mario Y position + displacement) High byte
                    PLX                       
                    RTL                       ; Return

GetSpriteClippingA: PHY                       
                    PHX                       
                    TXY                       ; Y = Sprite index
                    LDA.W $1662,X             ; \ X = Clipping table index
                    AND.B #$3F                ;  |
                    TAX                       ; /
                    STZ $0F                   ; \
                    LDA.L SprClippingDispX,X  ;  | Load low byte of X displacement
                    BPL ADDR_03B6B2           ;  |
                    DEC $0F                   ;  | $0F = High byte of X displacement
ADDR_03B6B2:        CLC                       ;  |
                    ADC.W $00E4,Y             ;  |
                    STA $04                   ;  | $04 = (Sprite X position + displacement) Low byte
                    LDA.W $14E0,Y             ;  |
                    ADC $0F                   ;  |
                    STA $0A                   ; / $0A = (Sprite X position + displacement) High byte
                    LDA.L SprClippingWidth,X  ; \ $06 = Clipping width
                    STA $06                   ; /
                    STZ $0F                   ; \
                    LDA.L SprClippingDispY,X  ;  | Load low byte of Y displacement
                    BPL ADDR_03B6CF           ;  |
                    DEC $0F                   ;  | $0F = High byte of Y displacement
ADDR_03B6CF:        CLC                       ;  |
                    ADC.W $00D8,Y             ;  |
                    STA $05                   ;  | $05 = (Sprite Y position + displacement) Low byte
                    LDA.W $14D4,Y             ;  |
                    ADC $0F                   ;  |
                    STA $0B                   ; / $0B = (Sprite Y position + displacement) High byte
                    LDA.L SprClippingHeight,X ; \ $07 = Clipping height
                    STA $07                   ; /
                    PLX                       ; X = Sprite index
                    PLY                       
                    RTL                       ; Return

GetSpriteClippingB: PHY                       
                    PHX                       
                    TXY                       ; Y = Sprite index
                    LDA.W $1662,X             ; \ X = Clipping table index
                    AND.B #$3F                ;  |
                    TAX                       ; /
                    STZ $0F                   ; \
                    LDA.L SprClippingDispX,X  ;  | Load low byte of X displacement
                    BPL ADDR_03B6F8           ;  |
                    DEC $0F                   ;  | $0F = High byte of X displacement
ADDR_03B6F8:        CLC                       ;  |
                    ADC.W $00E4,Y             ;  |
                    STA $00                   ;  | $00 = (Sprite X position + displacement) Low byte
                    LDA.W $14E0,Y             ;  |
                    ADC $0F                   ;  |
                    STA $08                   ; / $08 = (Sprite X position + displacement) High byte
                    LDA.L SprClippingWidth,X  ; \ $02 = Clipping width
                    STA $02                   ; /
                    STZ $0F                   ; \
                    LDA.L SprClippingDispY,X  ;  | Load low byte of Y displacement
                    BPL ADDR_03B715           ;  |
                    DEC $0F                   ;  | $0F = High byte of Y displacement
ADDR_03B715:        CLC                       ;  |
                    ADC.W $00D8,Y             ;  |
                    STA $01                   ;  | $01 = (Sprite Y position + displacement) Low byte
                    LDA.W $14D4,Y             ;  |
                    ADC $0F                   ;  |
                    STA $09                   ; / $09 = (Sprite Y position + displacement) High byte
                    LDA.L SprClippingHeight,X ; \ $03 = Clipping height
                    STA $03                   ; /
                    PLX                       ; X = Sprite index
                    PLY                       
                    RTL                       ; Return

CheckForContact:    PHX                       
                    LDX.B #$01                
ADDR_03B72E:        LDA $00,X                 
                    SEC                       
                    SBC $04,X                 
                    PHA                       
                    LDA $08,X                 
                    SBC $0A,X                 
                    STA $0C                   
                    PLA                       
                    CLC                       
                    ADC.B #$80                
                    LDA $0C                   
                    ADC.B #$00                
                    BNE ADDR_03B75A           
                    LDA $04,X                 
                    SEC                       
                    SBC $00,X                 
                    CLC                       
                    ADC $06,X                 
                    STA $0F                   
                    LDA $02,X                 
                    CLC                       
                    ADC $06,X                 
                    CMP $0F                   
                    BCC ADDR_03B75A           
                    DEX                       
                    BPL ADDR_03B72E           
ADDR_03B75A:        PLX                       
                    RTL                       ; Return

DATA_03B75C:        .db $0C,$1C

DATA_03B75E:        .db $01,$02

GetDrawInfoBnk3:    STZ.W $186C,X             ; Reset sprite offscreen flag, vertical
                    STZ.W $15A0,X             ; Reset sprite offscreen flag, horizontal
                    LDA $E4,X                 ; \
                    CMP $1A                   ;  | Set horizontal offscreen if necessary
                    LDA.W $14E0,X             ;  |
                    SBC $1B                   ;  |
                    BEQ ADDR_03B774           ;  |
                    INC.W $15A0,X             ; /
ADDR_03B774:        LDA.W $14E0,X             ; \
                    XBA                       ;  | Mark sprite invalid if far enough off screen
                    LDA $E4,X                 ;  |
                    REP #$20                  ; Accum (16 bit) 
                    SEC                       ;  |
                    SBC $1A                   ;  |
                    CLC                       ;  |
                    ADC.W #$0040              ;  |
                    CMP.W #$0180              ;  |
                    SEP #$20                  ; Accum (8 bit) 
                    ROL                       ;  |
                    AND.B #$01                ;  |
                    STA.W $15C4,X             ;  |
                    BNE ADDR_03B7CF           ; /
                    LDY.B #$00                ; \ set up loop:
                    LDA.W $1662,X             ;  |
                    AND.B #$20                ;  | if not smushed (1662 & 0x20), go through loop twice
                    BEQ ADDR_03B79A           ;  | else, go through loop once
                    INY                       ; /
ADDR_03B79A:        LDA $D8,X                 ; \
                    CLC                       ;  | set vertical offscree
                    ADC.W DATA_03B75C,Y       ;  |
                    PHP                       ;  |
                    CMP $1C                   ;  | (vert screen boundry)
                    ROL $00                   ;  |
                    PLP                       ;  |
                    LDA.W $14D4,X             ;  |
                    ADC.B #$00                ;  |
                    LSR $00                   ;  |
                    SBC $1D                   ;  |
                    BEQ ADDR_03B7BA           ;  |
                    LDA.W $186C,X             ;  | (vert offscreen)
                    ORA.W DATA_03B75E,Y       ;  |
                    STA.W $186C,X             ;  |
ADDR_03B7BA:        DEY                       ;  |
                    BPL ADDR_03B79A           ; /
                    LDY.W $15EA,X             ; get offset to sprite OAM
                    LDA $E4,X                 ; \
                    SEC                       ;  |
                    SBC $1A                   ;  |
                    STA $00                   ; / $00 = sprite x position relative to screen boarder
                    LDA $D8,X                 ; \
                    SEC                       ;  |
                    SBC $1C                   ;  |
                    STA $01                   ; / $01 = sprite y position relative to screen boarder
                    RTS                       ; Return

ADDR_03B7CF:        PLA                       ; \ Return from *main gfx routine* subroutine...
                    PLA                       ;  |    ...(not just this subroutine)
                    RTS                       ; /

DATA_03B7D2:        .db $00,$00,$00,$F8,$F8,$F8,$F8,$F8
                    .db $F8,$F7,$F6,$F5,$F4,$F3,$F2,$E8
                    .db $E8,$E8,$E8,$00,$00,$00,$00,$FE
                    .db $FC,$F8,$EC,$EC,$EC,$E8,$E4,$E0
                    .db $DC,$D8,$D4,$D0,$CC,$C8

ADDR_03B7F8:        LDA $AA,X                 
                    PHA                       
                    STZ $AA,X                 ; Sprite Y Speed = 0
                    PLA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA $9E,X                 
                    CMP.B #$A1                
                    BNE ADDR_03B80C           
                    TYA                       
                    CLC                       
                    ADC.B #$13                
                    TAY                       
ADDR_03B80C:        LDA.W DATA_03B7D2,Y       
                    LDY.W $1588,X             
                    BMI Return03B816          
                    STA $AA,X                 
Return03B816:       RTS                       ; Return

SubHorzPosBnk3:     LDY.B #$00                
                    LDA $94                   
                    SEC                       
                    SBC $E4,X                 
                    STA $0F                   
                    LDA $95                   
                    SBC.W $14E0,X             
                    BPL Return03B828          
                    INY                       
Return03B828:       RTS                       ; Return

SubVertPosBnk3:     LDY.B #$00                
                    LDA $96                   
                    SEC                       
                    SBC $D8,X                 
                    STA $0F                   
                    LDA $97                   
                    SBC.W $14D4,X             
                    BPL Return03B83A          
                    INY                       
Return03B83A:       RTS                       ; Return

DATA_03B83B:        .db $40,$B0

DATA_03B83D:        .db $01,$FF

DATA_03B83F:        .db $30,$C0,$A0,$80,$A0,$40,$60,$B0
DATA_03B847:        .db $01,$FF,$01,$FF,$01,$00,$01,$FF

SubOffscreen3Bnk3:  LDA.B #$06                ; \ Entry point of routine determines value of $03
                    BRA ADDR_03B859           ;  |

SubOffscreen2Bnk3:  LDA.B #$04                ;  |
                    BRA ADDR_03B859           ;  |

SubOffscreen1Bnk3:  LDA.B #$02                ;  |
ADDR_03B859:        STA $03                   ;  |
                    BRA ADDR_03B85F           ;  |

SubOffscreen0Bnk3:  STZ $03                   ; /
ADDR_03B85F:        JSR.W IsSprOffScreenBnk3  ; \ if sprite is not off screen, return
                    BEQ Return03B8C2          ; /
                    LDA $5B                   ; \  vertical level
                    AND.B #$01                ;  |
                    BNE VerticalLevelBnk3     ; /
                    LDA $D8,X                 ; \
                    CLC                       ;  |
                    ADC.B #$50                ;  | if the sprite has gone off the bottom of the level...
                    LDA.W $14D4,X             ;  | (if adding 0x50 to the sprite y position would make the high byte >= 2)
                    ADC.B #$00                ;  |
                    CMP.B #$02                ;  |
                    BPL OffScrEraseSprBnk3    ; /    ...erase the sprite
                    LDA.W $167A,X             ; \ if "process offscreen" flag is set, return
                    AND.B #$04                ;  |
                    BNE Return03B8C2          ; /
                    LDA $13                   
                    AND.B #$01                
                    ORA $03                   
                    STA $01                   
                    TAY                       
                    LDA $1A                   
                    CLC                       
                    ADC.W DATA_03B83F,Y       
                    ROL $00                   
                    CMP $E4,X                 
                    PHP                       
                    LDA $1B                   
                    LSR $00                   
                    ADC.W DATA_03B847,Y       
                    PLP                       
                    SBC.W $14E0,X             
                    STA $00                   
                    LSR $01                   
                    BCC ADDR_03B8A8           
                    EOR.B #$80                
                    STA $00                   
ADDR_03B8A8:        LDA $00                   
                    BPL Return03B8C2          
OffScrEraseSprBnk3: LDA.W $14C8,X             ; \ If sprite status < 8, permanently erase sprite
                    CMP.B #$08                ;  |
                    BCC OffScrKillSprBnk3     ; /
                    LDY.W $161A,X             ;  \ Branch if should permanently erase sprite
                    CPY.B #$FF                ;   |
                    BEQ OffScrKillSprBnk3     ;  /
                    LDA.B #$00                ;  \ Allow sprite to be reloaded by level loading routine
                    STA.W $1938,Y             ;  /
OffScrKillSprBnk3:  STZ.W $14C8,X             
Return03B8C2:       RTS                       ; Return

VerticalLevelBnk3:  LDA.W $167A,X             ; \ If "process offscreen" flag is set, return
                    AND.B #$04                ;  |
                    BNE Return03B8C2          ; /
                    LDA $13                   ; \ Return every other frame
                    LSR                       ;  |
                    BCS Return03B8C2          ; /
                    AND.B #$01                
                    STA $01                   
                    TAY                       
                    LDA $1C                   
                    CLC                       
                    ADC.W DATA_03B83B,Y       
                    ROL $00                   
                    CMP $D8,X                 
                    PHP                       
                    LDA.W $001D               
                    LSR $00                   
                    ADC.W DATA_03B83D,Y       
                    PLP                       
                    SBC.W $14D4,X             
                    STA $00                   
                    LDY $01                   
                    BEQ ADDR_03B8F5           
                    EOR.B #$80                
                    STA $00                   
ADDR_03B8F5:        LDA $00                   
                    BPL Return03B8C2          
                    BMI OffScrEraseSprBnk3    
IsSprOffScreenBnk3: LDA.W $15A0,X             ; \ If sprite is on screen, A = 0
                    ORA.W $186C,X             ;  |
                    RTS                       ; / Return

MagiKoopaPals:      .db $FF,$7F,$4A,$29,$00,$00,$00,$14
                    .db $00,$20,$92,$7E,$0A,$00,$2A,$00
                    .db $FF,$7F,$AD,$35,$00,$00,$00,$24
                    .db $00,$2C,$2F,$72,$0D,$00,$AD,$00
                    .db $FF,$7F,$10,$42,$00,$00,$00,$30
                    .db $00,$38,$CC,$65,$50,$00,$10,$01
                    .db $FF,$7F,$73,$4E,$00,$00,$00,$3C
                    .db $41,$44,$69,$59,$B3,$00,$73,$01
                    .db $FF,$7F,$D6,$5A,$00,$00,$00,$48
                    .db $A4,$50,$06,$4D,$16,$01,$D6,$01
                    .db $FF,$7F,$39,$67,$00,$00,$42,$54
                    .db $07,$5D,$A3,$40,$79,$01,$39,$02
                    .db $FF,$7F,$9C,$73,$00,$00,$A5,$60
                    .db $6A,$69,$40,$34,$DC,$01,$9C,$02
                    .db $FF,$7F,$FF,$7F,$00,$00,$08,$6D
                    .db $CD,$75,$00,$28,$3F,$02,$FF,$02
BooBossPals:        .db $FF,$7F,$63,$0C,$00,$00,$00,$0C
                    .db $00,$0C,$00,$0C,$00,$0C,$03,$00
                    .db $FF,$7F,$E7,$1C,$00,$00,$00,$1C
                    .db $00,$1C,$20,$1C,$81,$1C,$07,$00
                    .db $FF,$7F,$6B,$2D,$00,$00,$00,$2C
                    .db $40,$2C,$A2,$2C,$05,$2D,$0B,$00
                    .db $FF,$7F,$EF,$3D,$00,$00,$60,$3C
                    .db $C3,$3C,$26,$3D,$89,$3D,$0F,$00
                    .db $FF,$7F,$73,$4E,$00,$00,$E4,$4C
                    .db $47,$4D,$AA,$4D,$0D,$4E,$13,$10
                    .db $FF,$7F,$F7,$5E,$00,$00,$68,$5D
                    .db $CB,$5D,$2E,$5E,$91,$5E,$17,$20
                    .db $FF,$7F,$7B,$6F,$00,$00,$EC,$6D
                    .db $4F,$6E,$B2,$6E,$15,$6F,$1B,$30
                    .db $FF,$7F,$FF,$7F,$00,$00,$70,$7E
                    .db $D3,$7E,$36,$7F,$99,$7F,$1F,$40
Empty03BA02:        .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF

GenTileFromSpr2:    STA $9C                   ; $9C = tile to generate
                    LDA $E4,X                 ; \ $9A = Sprite X position + #$08
                    SEC                       ;  | for block creation
                    SBC.B #$08                ;  |
                    STA $9A                   ;  |
                    LDA.W $14E0,X             ;  |
                    SBC.B #$00                ;  |
                    STA $9B                   ; /
                    LDA $D8,X                 ; \ $98 = Sprite Y position + #$08
                    CLC                       ;  | for block creation
                    ADC.B #$08                ;  |
                    STA $98                   ;  |
                    LDA.W $14D4,X             ;  |
                    ADC.B #$00                ;  |
                    STA $99                   ; /
                    JSL.L GenerateTile        ; Generate the tile
                    RTL                       ; Return

ExtSub03C023:       PHB                       ; Wrapper
                    PHK                       
                    PLB                       
                    JSR.W ADDR_03C02F         
                    PLB                       
                    RTL                       ; Return

DATA_03C02B:        .db $74,$75,$77,$76

ADDR_03C02F:        LDY.W $160E,X             
                    LDA.B #$00                
                    STA.W $14C8,Y             
                    LDA.B #$06                ; \ Play sound effect
                    STA.W $1DF9               ; /
                    LDA.W $160E,Y             
                    BNE ADDR_03C09B           
                    LDA.W $009E,Y             
                    CMP.B #$81                
                    BNE ADDR_03C054           
                    LDA $14                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.B #$03                
                    TAY                       
                    LDA.W DATA_03C02B,Y       
ADDR_03C054:        CMP.B #$74                
                    BCC ADDR_03C09B           
                    CMP.B #$78                
                    BCS ADDR_03C09B           
ADDR_03C05C:        STZ.W $18AC               
                    STZ.W $141E               ; No Yoshi wing ability
                    LDA.B #$35                
                    STA.W $009E,X             
                    LDA.B #$08                ; \ Sprite status = Normal
                    STA.W $14C8,X             ; /
                    LDA.B #$1F                ; \ Play sound effect
                    STA.W $1DFC               ; /
                    LDA $D8,X                 
                    SBC.B #$10                
                    STA $D8,X                 
                    LDA.W $14D4,X             
                    SBC.B #$00                
                    STA.W $14D4,X             
                    LDA.W $15F6,X             
                    PHA                       
                    JSL.L InitSpriteTables    
                    PLA                       
                    AND.B #$FE                
                    STA.W $15F6,X             
                    LDA.B #$0C                
                    STA.W $1602,X             
                    DEC.W $160E,X             
                    LDA.B #$40                
                    STA.W $18E8               
                    RTS                       ; Return

ADDR_03C09B:        INC.W $1570,X             
                    LDA.W $1570,X             
                    CMP.B #$05                
                    BNE ADDR_03C0A7           
                    BRA ADDR_03C05C           

ADDR_03C0A7:        JSL.L ExtSub05B34A        
                    LDA.B #$01                
                    JSL.L GivePoints          
                    RTS                       ; Return

DATA_03C0B2:        .db $68,$6A,$6C,$6E

DATA_03C0B6:        .db $00,$03,$01,$02,$04,$02,$00,$01
                    .db $00,$04,$00,$02,$00,$03,$04,$01

ExtSub03C0C6:       LDA $9D                   
                    BNE ADDR_03C0CD           
                    JSR.W ADDR_03C11E         
ADDR_03C0CD:        STZ $00                   
                    LDX.B #$13                
                    LDY.B #$B0                
ADDR_03C0D3:        STX $02                   
                    LDA $00                   
                    STA.W $0300,Y             
                    CLC                       
                    ADC.B #$10                
                    STA $00                   
                    LDA.B #$C4                
                    STA.W $0301,Y             
                    LDA $64                   
                    ORA.B #$09                
                    STA.W $0303,Y             
                    PHX                       
                    LDA $14                   
                    LSR                       
                    LSR                       
                    LSR                       
                    CLC                       
                    ADC.L DATA_03C0B6,X       
                    AND.B #$03                
                    TAX                       
                    LDA.L DATA_03C0B2,X       
                    STA.W $0302,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.B #$02                
                    STA.W $0460,X             
                    PLX                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_03C0D3           
                    RTL                       ; Return

IggyPlatSpeed:      .db $FF,$01,$FF,$01

DATA_03C116:        .db $FF,$00,$FF,$00

IggyPlatBounds:     .db $E7,$18,$D7,$28

ADDR_03C11E:        LDA $9D                   ; \ If sprites locked...
                    ORA.W $1493               ;  | ...or battle is over (set to FF when over)...
                    BNE Return03C175          ; / ...return
                    LDA.W $1906               ; \ If platform at a maximum tilt, (stationary timer > 0)
                    BEQ ADDR_03C12D           ;  |
                    DEC.W $1906               ; / decrement stationary timer
ADDR_03C12D:        LDA $13                   ; \ Return every other time through...
                    AND.B #$01                ;  |
                    ORA.W $1906               ;  | ...return if stationary
                    BNE Return03C175          ; /
                    LDA.W $1905               ; $1907 holds the total number of tilts made
                    AND.B #$01                ; \ X=1 if platform tilted up to the right (/)...
                    TAX                       ; / ...else X=0
                    LDA.W $1907               ; $1907 holds the current phase: 0/ 1\ 2/ 3\ 4// 5\\
                    CMP.B #$04                ; \ If this is phase 4 or 5...
                    BCC ADDR_03C145           ;  | ...cause a steep tilt by setting X=X+2
                    INX                       ;  |
                    INX                       ; /
ADDR_03C145:        LDA $36                   ; $36 is tilt of platform: //D8 /E8 -0- 18\ 28\\
                    CLC                       ; \ Get new tilt of platform by adding value
                    ADC.L IggyPlatSpeed,X     ;  |
                    STA $36                   ; /
                    PHA                       
                    LDA $37                   ; $37 is boolean tilt of platform: 0\ /1
                    ADC.L DATA_03C116,X       ; \ if tilted up to left,  $37=0
                    AND.B #$01                ;  | if tilted up to right, $37=1
                    STA $37                   ; /
                    PLA                       
                    CMP.L IggyPlatBounds,X    ; \ Return if platform not at a maximum tilt
                    BNE Return03C175          ; /
                    INC.W $1905               ; Increment total number of tilts made
                    LDA.B #$40                ; \ Set timer to stay stationary
                    STA.W $1906               ; /
                    INC.W $1907               ; Increment phase
                    LDA.W $1907               ; \ If phase > 5, phase = 0
                    CMP.B #$06                ;  |
                    BNE Return03C175          ;  |
                    STZ.W $1907               ; /
Return03C175:       RTS                       ; Return

DATA_03C176:        .db $0C,$0C,$0C,$0C,$0C,$0C,$0D,$0D
                    .db $0D,$0D,$FC,$FC,$FC,$FC,$FC,$FC
                    .db $FB,$FB,$FB,$FB,$0C,$0C,$0C,$0C
                    .db $0C,$0C,$0D,$0D,$0D,$0D,$FC,$FC
                    .db $FC,$FC,$FC,$FC,$FB,$FB,$FB,$FB
DATA_03C19E:        .db $0E,$0E,$0E,$0D,$0D,$0D,$0C,$0C
                    .db $0B,$0B,$0E,$0E,$0E,$0D,$0D,$0D
                    .db $0C,$0C,$0B,$0B,$12,$12,$12,$11
                    .db $11,$11,$10,$10,$0F,$0F,$12,$12
                    .db $12,$11,$11,$11,$10,$10,$0F,$0F
DATA_03C1C6:        .db $02,$FE

DATA_03C1C8:        .db $00,$FF

ExtSub03C1CA:       PHB                       
                    PHK                       
                    PLB                       
                    LDY.B #$00                
                    LDA.W $15B8,X             
                    BPL ADDR_03C1D5           
                    INY                       
ADDR_03C1D5:        LDA $E4,X                 
                    CLC                       
                    ADC.W DATA_03C1C6,Y       
                    STA $E4,X                 
                    LDA.W $14E0,X             
                    ADC.W DATA_03C1C8,Y       
                    STA.W $14E0,X             
                    LDA.B #$18                
                    STA $AA,X                 
                    PLB                       
                    RTL                       ; Return

DATA_03C1EC:        .db $00,$04,$07,$08,$08,$07,$04,$00
                    .db $00

LightSwitch:        LDA $9D                   
                    BNE ADDR_03C22B           
                    JSL.L InvisBlkMainRt      
                    JSR.W SubOffscreen0Bnk3   
                    LDA.W $1558,X             
                    CMP.B #$05                
                    BNE ADDR_03C22B           
                    STZ $C2,X                 
                    LDY.B #$0B                ; \ Play sound effect
                    STY.W $1DF9               ; /
                    PHA                       
                    LDY.B #$09                
ADDR_03C211:        LDA.W $14C8,Y             
                    CMP.B #$08                
                    BNE ADDR_03C227           
                    LDA.W $009E,Y             
                    CMP.B #$C6                
                    BNE ADDR_03C227           
                    LDA.W $00C2,Y             
                    EOR.B #$01                
                    STA.W $00C2,Y             
ADDR_03C227:        DEY                       
                    BPL ADDR_03C211           
                    PLA                       
ADDR_03C22B:        LDA.W $1558,X             
                    LSR                       
                    TAY                       
                    LDA $1C                   
                    PHA                       
                    CLC                       
                    ADC.W DATA_03C1EC,Y       
                    STA $1C                   
                    LDA $1D                   
                    PHA                       
                    ADC.B #$00                
                    STA $1D                   
                    JSL.L GenericSprGfxRt2    
                    LDY.W $15EA,X             ; Y = Index into sprite OAM
                    LDA.B #$2A                
                    STA.W $0302,Y             
                    LDA.W $0303,Y             
                    AND.B #$BF                
                    STA.W $0303,Y             
                    PLA                       
                    STA $1D                   
                    PLA                       
                    STA $1C                   
                    RTS                       ; Return

ChainsawMotorTiles: .db $E0,$C2,$C0,$C2

DATA_03C25F:        .db $F2,$0E

DATA_03C261:        .db $33,$B3

ExtSub03C263:       PHB                       ; Wrapper
                    PHK                       
                    PLB                       
                    JSR.W ChainsawGfx         
                    PLB                       
                    RTL                       ; Return

ChainsawGfx:        JSR.W GetDrawInfoBnk3     
                    PHX                       
                    LDA $9E,X                 
                    SEC                       
                    SBC.B #$65                
                    TAX                       
                    LDA.W DATA_03C25F,X       
                    STA $03                   
                    LDA.W DATA_03C261,X       
                    STA $04                   
                    PLX                       
                    LDA $14                   
                    AND.B #$02                
                    STA $02                   
                    LDA $00                   
                    SEC                       
                    SBC.B #$08                
                    STA.W $0300,Y             
                    STA.W $0304,Y             
                    STA.W $0308,Y             
                    LDA $01                   
                    SEC                       
                    SBC.B #$08                
                    STA.W $0301,Y             
                    CLC                       
                    ADC $03                   
                    CLC                       
                    ADC $02                   
                    STA.W $0305,Y             
                    CLC                       
                    ADC $03                   
                    STA.W $0309,Y             
                    LDA $14                   
                    LSR                       
                    LSR                       
                    AND.B #$03                
                    PHX                       
                    TAX                       
                    LDA.W ChainsawMotorTiles,X
                    STA.W $0302,Y             
                    PLX                       
                    LDA.B #$AE                
                    STA.W $0306,Y             
                    LDA.B #$8E                
                    STA.W $030A,Y             
                    LDA.B #$37                
                    STA.W $0303,Y             
                    LDA $04                   
                    STA.W $0307,Y             
                    STA.W $030B,Y             
                    LDY.B #$02                
                    TYA                       
                    JSL.L FinishOAMWrite      
                    RTS                       ; Return

TriggerInivis1Up:   PHX                       ; \ Find free sprite slot (#$0B-#$00)
                    LDX.B #$0B                ;  |
ADDR_03C2DC:        LDA.W $14C8,X             ;  |
                    BEQ Generate1Up           ;  |
                    DEX                       ;  |
                    BPL ADDR_03C2DC           ;  |
                    PLX                       ;  |
                    RTL                       ; /

Generate1Up:        LDA.B #$08                ; \ Sprite status = Normal
                    STA.W $14C8,X             ; /
                    LDA.B #$78                ; \ Sprite = 1Up
                    STA $9E,X                 ; /
                    LDA $94                   ; \ Sprite X position = Mario X position
                    STA $E4,X                 ;  |
                    LDA $95                   ;  |
                    STA.W $14E0,X             ; /
                    LDA $96                   ; \ Sprite Y position = Matio Y position
                    STA $D8,X                 ;  |
                    LDA $97                   ;  |
                    STA.W $14D4,X             ; /
                    JSL.L InitSpriteTables    ; Load sprite tables
                    LDA.B #$10                ; \ Disable interaction timer = #$10
                    STA.W $154C,X             ; /
                    JSR.W PopupMushroom       
                    PLX                       
                    RTL                       ; Return

InvisMushroom:      JSR.W GetDrawInfoBnk3     
                    JSL.L MarioSprInteract    ; \ Return if no interaction
                    BCC Return03C347          ; /
                    LDA.B #$74                ; \ Replace, Sprite = Mushroom
                    STA $9E,X                 ; /
                    JSL.L InitSpriteTables    ; Reset sprite tables
                    LDA.B #$20                ; \ Disable interaction timer = #$20
                    STA.W $154C,X             ; /
                    LDA $D8,X                 ; \ Sprite Y position = Mario Y position - $000F
                    SEC                       ;  |
                    SBC.B #$0F                ;  |
                    STA $D8,X                 ;  |
                    LDA.W $14D4,X             ;  |
                    SBC.B #$00                ;  |
                    STA.W $14D4,X             ; /
PopupMushroom:      LDA.B #$00                ; \ Sprite direction = dirction of Mario's X speed
                    LDY $7B                   ;  |
                    BPL ADDR_03C33B           ;  |
                    INC A                     ;  |
ADDR_03C33B:        STA.W $157C,X             ; /
                    LDA.B #$C0                ; \ Set upward speed
                    STA $AA,X                 ; /
                    LDA.B #$02                ; \ Play sound effect
                    STA.W $1DFC               ; /
Return03C347:       RTS                       ; Return

NinjiSpeedY:        .db $D0,$C0,$B0,$D0

Ninji:              JSL.L GenericSprGfxRt2    ;  Draw sprite using the routine for sprites <= 53
                    LDA $9D                   ; \ Return if sprites locked
                    BNE Return03C38F          ; /
                    JSR.W SubHorzPosBnk3      ; \ Always face mario
                    TYA                       ;  |
                    STA.W $157C,X             ; /
                    JSR.W SubOffscreen0Bnk3   ; Only process while onscreen
                    JSL.L SprSpr_MarioSprRts  ; Interact with mario
                    JSL.L UpdateSpritePos     ; Update position based on speed values
                    LDA.W $1588,X             ; \ Branch if not on ground
                    AND.B #$04                ;   | Bug: Ninji can jump through ceiling.  See NinjiFix.asm
                    BEQ ADDR_03C385           ;  /       Should set Y Speed = 0 if ($1588,x & #$08)
                    STZ $AA,X                 ; Sprite Y Speed = 0
                    LDA.W $1540,X             
                    BNE ADDR_03C385           
                    LDA.B #$60                
                    STA.W $1540,X             
                    INC $C2,X                 
                    LDA $C2,X                 
                    AND.B #$03                
                    TAY                       
                    LDA.W NinjiSpeedY,Y       
                    STA $AA,X                 
ADDR_03C385:        LDA.B #$00                
                    LDY $AA,X                 
                    BMI ADDR_03C38C           
                    INC A                     
ADDR_03C38C:        STA.W $1602,X             
Return03C38F:       RTS                       ; Return

ExtSub03C390:       PHB                       
                    PHK                       
                    PLB                       
                    LDA.W $157C,X             
                    PHA                       
                    LDY.W $15AC,X             
                    BEQ ADDR_03C3A5           
                    CPY.B #$05                
                    BCC ADDR_03C3A5           
                    EOR.B #$01                
                    STA.W $157C,X             
ADDR_03C3A5:        JSR.W ADDR_03C3DA         
                    PLA                       
                    STA.W $157C,X             
                    PLB                       
                    RTL                       ; Return

ADDR_03C3AE:        JSL.L GenericSprGfxRt2    
                    RTS                       ; Return

DryBonesTileDispX:  .db $00,$08,$00,$00,$F8,$00,$00,$04
                    .db $00,$00,$FC,$00

DryBonesGfxProp:    .db $43,$43,$43,$03,$03,$03

DryBonesTileDispY:  .db $F4,$F0,$00,$F4,$F1,$00,$F4,$F0
                    .db $00

DryBonesTiles:      .db $00,$64,$66,$00,$64,$68,$82,$64
                    .db $E6

DATA_03C3D7:        .db $00,$00,$FF

ADDR_03C3DA:        LDA $9E,X                 
                    CMP.B #$31                
                    BEQ ADDR_03C3AE           
                    JSR.W GetDrawInfoBnk3     
                    LDA.W $15AC,X             
                    STA $05                   
                    LDA.W $157C,X             
                    ASL                       
                    ADC.W $157C,X             
                    STA $02                   
                    PHX                       
                    LDA.W $1602,X             
                    PHA                       
                    ASL                       
                    ADC.W $1602,X             
                    STA $03                   
                    PLX                       
                    LDA.W DATA_03C3D7,X       
                    STA $04                   
                    LDX.B #$02                
ADDR_03C404:        PHX                       
                    TXA                       
                    CLC                       
                    ADC $02                   
                    TAX                       
                    PHX                       
                    LDA $05                   
                    BEQ ADDR_03C414           
                    TXA                       
                    CLC                       
                    ADC.B #$06                
                    TAX                       
ADDR_03C414:        LDA $00                   
                    CLC                       
                    ADC.W DryBonesTileDispX,X 
                    STA.W $0300,Y             
                    PLX                       
                    LDA.W DryBonesGfxProp,X   
                    ORA $64                   
                    STA.W $0303,Y             
                    PLA                       
                    PHA                       
                    CLC                       
                    ADC $03                   
                    TAX                       
                    LDA $01                   
                    CLC                       
                    ADC.W DryBonesTileDispY,X 
                    STA.W $0301,Y             
                    LDA.W DryBonesTiles,X     
                    STA.W $0302,Y             
                    PLX                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    CPX $04                   
                    BNE ADDR_03C404           
                    PLX                       
                    LDY.B #$02                
                    TYA                       
                    JSL.L FinishOAMWrite      
                    RTS                       ; Return

ExtSub03C44E:       LDA.W $15A0,X             
                    ORA.W $186C,X             
                    BNE Return03C460          
                    LDY.B #$07                ; \ Find a free extended sprite slot
ADDR_03C458:        LDA.W $170B,Y             ;  |
                    BEQ ADDR_03C461           ;  |
                    DEY                       ;  |
                    BPL ADDR_03C458           ;  |
Return03C460:       RTL                       ; / Return if no free slots

ADDR_03C461:        LDA.B #$06                ; \ Extended sprite = Bone
                    STA.W $170B,Y             ; /
                    LDA $D8,X                 
                    SEC                       
                    SBC.B #$10                
                    STA.W $1715,Y             
                    LDA.W $14D4,X             
                    SBC.B #$00                
                    STA.W $1729,Y             
                    LDA $E4,X                 
                    STA.W $171F,Y             
                    LDA.W $14E0,X             
                    STA.W $1733,Y             
                    LDA.W $157C,X             
                    LSR                       
                    LDA.B #$18                
                    BCC ADDR_03C48B           
                    LDA.B #$E8                
ADDR_03C48B:        STA.W $1747,Y             
                    RTL                       ; Return

DATA_03C48F:        .db $01,$FF

DATA_03C491:        .db $FF,$90

DiscoBallTiles:     .db $80,$82,$84,$86,$88,$8C,$C0,$C2
                    .db $C2

DATA_03C49C:        .db $31,$33,$35,$37,$31,$33,$35,$37
                    .db $39

ADDR_03C4A5:        LDY.W $15EA,X             ; Y = Index into sprite OAM
                    LDA.B #$78                
                    STA.W $0300,Y             
                    LDA.B #$28                
                    STA.W $0301,Y             
                    PHX                       
                    LDA $C2,X                 
                    LDX.B #$08                
                    AND.B #$01                
                    BEQ ADDR_03C4C1           
                    LDA $13                   
                    LSR                       
                    AND.B #$07                
                    TAX                       
ADDR_03C4C1:        LDA.W DiscoBallTiles,X    
                    STA.W $0302,Y             
                    LDA.W DATA_03C49C,X       
                    STA.W $0303,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$02                
                    STA.W $0460,Y             
                    PLX                       
                    RTS                       ; Return

DATA_03C4D8:        .db $10,$8C

DATA_03C4DA:        .db $42,$31

DarkRoomWithLight:  LDA.W $1534,X             
                    BNE ADDR_03C500           
                    LDY.B #$09                
ADDR_03C4E3:        CPY.W $15E9               
                    BEQ ADDR_03C4FA           
                    LDA.W $14C8,Y             
                    CMP.B #$08                
                    BNE ADDR_03C4FA           
                    LDA.W $009E,Y             
                    CMP.B #$C6                
                    BNE ADDR_03C4FA           
                    STZ.W $14C8,X             
Return03C4F9:       RTS                       ; Return

ADDR_03C4FA:        DEY                       
                    BPL ADDR_03C4E3           
                    INC.W $1534,X             
ADDR_03C500:        JSR.W ADDR_03C4A5         
                    LDA.B #$FF                
                    STA $40                   
                    LDA.B #$20                
                    STA $44                   
                    LDA.B #$20                
                    STA $43                   
                    LDA.B #$80                
                    STA.W $0D9F               
                    LDA $C2,X                 
                    AND.B #$01                
                    TAY                       
                    LDA.W DATA_03C4D8,Y       
                    STA.W $0701               
                    LDA.W DATA_03C4DA,Y       
                    STA.W $0702               
                    LDA $9D                   
                    BNE Return03C4F9          
                    LDA.W $1482               
                    BNE ADDR_03C54D           
                    LDA.B #$00                
                    STA.W $1476               
                    LDA.B #$90                
                    STA.W $1478               
                    LDA.B #$78                
                    STA.W $1472               
                    LDA.B #$87                
                    STA.W $1474               
                    LDA.B #$01                
                    STA.W $1486               
                    STZ.W $1483               
                    INC.W $1482               
ADDR_03C54D:        LDY.W $1483               
                    LDA.W $1476               
                    CLC                       
                    ADC.W DATA_03C48F,Y       
                    STA.W $1476               
                    LDA.W $1478               
                    CLC                       
                    ADC.W DATA_03C48F,Y       
                    STA.W $1478               
                    CMP.W DATA_03C491,Y       
                    BNE ADDR_03C572           
                    LDA.W $1483               
                    INC A                     
                    AND.B #$01                
                    STA.W $1483               
ADDR_03C572:        LDA $13                   
                    AND.B #$03                
                    BNE Return03C4F9          
                    LDY.B #$00                
                    LDA.W $1472               
                    STA.W $147A               
                    SEC                       
                    SBC.W $1476               
                    BCS ADDR_03C58A           
                    INY                       
                    EOR.B #$FF                
                    INC A                     
ADDR_03C58A:        STA.W $1480               
                    STY.W $1484               
                    STZ.W $147E               
                    LDY.B #$00                
                    LDA.W $1474               
                    STA.W $147C               
                    SEC                       
                    SBC.W $1478               
                    BCS ADDR_03C5A5           
                    INY                       
                    EOR.B #$FF                
                    INC A                     
ADDR_03C5A5:        STA.W $1481               
                    STY.W $1485               
                    STZ.W $147F               
                    LDA $C2,X                 
                    STA $0F                   
                    PHX                       
                    REP #$10                  ; Index (16 bit) 
                    LDX.W #$0000              
ADDR_03C5B8:        CPX.W #$005F              
                    BCC ADDR_03C607           
                    LDA.W $147E               
                    CLC                       
                    ADC.W $1480               
                    STA.W $147E               
                    BCS ADDR_03C5CD           
                    CMP.B #$CF                
                    BCC ADDR_03C5E0           
ADDR_03C5CD:        SBC.B #$CF                
                    STA.W $147E               
                    INC.W $147A               
                    LDA.W $1484               
                    BNE ADDR_03C5E0           
                    DEC.W $147A               
                    DEC.W $147A               
ADDR_03C5E0:        LDA.W $147F               
                    CLC                       
                    ADC.W $1481               
                    STA.W $147F               
                    BCS ADDR_03C5F0           
                    CMP.B #$CF                
                    BCC ADDR_03C603           
ADDR_03C5F0:        SBC.B #$CF                
                    STA.W $147F               
                    INC.W $147C               
                    LDA.W $1485               
                    BNE ADDR_03C603           
                    DEC.W $147C               
                    DEC.W $147C               
ADDR_03C603:        LDA $0F                   
                    BNE ADDR_03C60F           
ADDR_03C607:        LDA.B #$01                
                    STA.W $04A0,X             
                    DEC A                     
                    BRA ADDR_03C618           

ADDR_03C60F:        LDA.W $147A               
                    STA.W $04A0,X             
                    LDA.W $147C               
ADDR_03C618:        STA.W $04A1,X             
                    INX                       
                    INX                       
                    CPX.W #$01C0              
                    BNE ADDR_03C5B8           
                    SEP #$10                  ; Index (8 bit) 
                    PLX                       
                    RTS                       ; Return

DATA_03C626:        .db $14,$28,$38,$20,$30,$4C,$40,$34
                    .db $2C,$1C,$08,$0C,$04,$0C,$1C,$24
                    .db $2C,$38,$40,$48,$50,$5C,$5C,$6C
                    .db $4C,$58,$24,$78,$64,$70,$78,$7C
                    .db $70,$68,$58,$4C,$40,$34,$24,$04
                    .db $18,$2C,$0C,$0C,$14,$18,$1C,$24
                    .db $2C,$28,$24,$30,$30,$34,$38,$3C
                    .db $44,$54,$48,$5C,$68,$40,$4C,$40
                    .db $3C,$40,$50,$54,$60,$54,$4C,$5C
                    .db $5C,$68,$74,$6C,$7C,$78,$68,$80
                    .db $18,$48,$2C,$1C

DATA_03C67A:        .db $1C,$0C,$08,$1C,$14,$08,$14,$24
                    .db $28,$2C,$30,$3C,$44,$4C,$44,$34
                    .db $40,$34,$24,$1C,$10,$0C,$18,$18
                    .db $2C,$28,$68,$28,$34,$34,$38,$40
                    .db $44,$44,$38,$3C,$44,$48,$4C,$5C
                    .db $5C,$54,$64,$74,$74,$88,$80,$94
                    .db $8C,$78,$6C,$64,$70,$7C,$8C,$98
                    .db $90,$98,$84,$84,$88,$78,$78,$6C
                    .db $5C,$50,$50,$48,$50,$5C,$64,$64
                    .db $74,$78,$74,$64,$60,$58,$54,$50
                    .db $50,$58,$30,$34

DATA_03C6CE:        .db $20,$30,$39,$47,$50,$60,$70,$7C
                    .db $7B,$80,$7D,$78,$6E,$60,$4F,$47
                    .db $41,$38,$30,$2A,$20,$10,$04,$00
                    .db $00,$08,$10,$20,$1A,$10,$0A,$06
                    .db $0F,$17,$16,$1C,$1F,$21,$10,$18
                    .db $20,$2C,$2E,$3B,$30,$30,$2D,$2A
                    .db $34,$36,$3A,$3F,$45,$4D,$5F,$54
                    .db $4E,$67,$70,$67,$70,$5C,$4E,$40
                    .db $48,$56,$57,$5F,$68,$72,$77,$6F
                    .db $66,$60,$67,$5C,$57,$4B,$4D,$54
                    .db $48,$43,$3D,$3C

DATA_03C722:        .db $18,$1E,$25,$22,$1A,$17,$20,$30
                    .db $41,$4F,$61,$70,$7F,$8C,$94,$92
                    .db $A0,$86,$93,$88,$88,$78,$66,$50
                    .db $40,$30,$22,$20,$2C,$30,$40,$4F
                    .db $59,$51,$3F,$39,$4C,$5F,$6A,$6F
                    .db $77,$7E,$6C,$60,$58,$48,$3D,$2F
                    .db $28,$38,$44,$30,$36,$27,$21,$2F
                    .db $39,$2A,$2F,$39,$40,$3F,$49,$50
                    .db $60,$59,$4C,$51,$48,$4F,$56,$67
                    .db $5B,$68,$75,$7D,$87,$8A,$7A,$6B
                    .db $70,$82,$73,$92

DATA_03C776:        .db $60,$B0,$40,$80

FireworkSfx1:       .db $26,$00,$26,$28

FireworkSfx2:       .db $00,$2B,$00,$00

FireworkSfx3:       .db $27,$00,$27,$29

FireworkSfx4:       .db $00,$2C,$00,$00

DATA_03C78A:        .db $00,$AA,$FF,$AA

DATA_03C78E:        .db $00,$7E,$27,$7E

DATA_03C792:        .db $C0,$C0,$FF,$C0

ADDR_03C796:        LDA.W $1564,X             
                    BEQ ADDR_03C7A7           
                    DEC A                     
                    BNE Return03C7A6          
                    INC.W $13C6               
                    LDA.B #$FF                
                    STA.W $1493               
Return03C7A6:       RTS                       ; Return

ADDR_03C7A7:        LDA.W $156D               
                    AND.B #$03                
                    TAY                       
                    LDA.W DATA_03C78A,Y       
                    STA.W $0701               
                    LDA.W DATA_03C78E,Y       
                    STA.W $0702               
                    LDA.W $1FEB               
                    BNE Return03C80F          
                    LDA.W $1534,X             
                    CMP.B #$04                
                    BEQ ADDR_03C810           
                    LDY.B #$01                
ADDR_03C7C7:        LDA.W $14C8,Y             
                    BEQ ADDR_03C7D0           
                    DEY                       
                    BPL ADDR_03C7C7           
                    RTS                       ; Return

ADDR_03C7D0:        LDA.B #$08                ; \ Sprite status = Normal
                    STA.W $14C8,Y             ; /
                    LDA.B #$7A                
                    STA.W $009E,Y             
                    LDA.B #$00                
                    STA.W $14E0,Y             
                    LDA.B #$A8                
                    CLC                       
                    ADC $1C                   
                    STA.W $00D8,Y             
                    LDA $1D                   
                    ADC.B #$00                
                    STA.W $14D4,Y             
                    PHX                       
                    TYX                       
                    JSL.L InitSpriteTables    
                    PLX                       
                    PHX                       
                    LDA.W $1534,X             
                    AND.B #$03                
                    STA.W $1534,Y             
                    TAX                       
                    LDA.W DATA_03C792,X       
                    STA.W $1FEB               
                    LDA.W DATA_03C776,X       
                    STA.W $00E4,Y             
                    PLX                       
                    INC.W $1534,X             
Return03C80F:       RTS                       ; Return

ADDR_03C810:        LDA.B #$70                
                    STA.W $1564,X             
                    RTS                       ; Return

Firework:           LDA $C2,X                 
                    JSL.L ExecutePtr          

FireworkPtrs:       .dw ADDR_03C828           
                    .dw ADDR_03C845           
                    .dw ADDR_03C88D           
                    .dw ADDR_03C941           

FireworkSpeedY:     .db $E4,$E6,$E4,$E2

ADDR_03C828:        LDY.W $1534,X             
                    LDA.W FireworkSpeedY,Y    
                    STA $AA,X                 
                    LDA.B #$25                ; \ Play sound effect
                    STA.W $1DFC               ; /
                    LDA.B #$10                
                    STA.W $1564,X             
                    INC $C2,X                 
                    RTS                       ; Return

DATA_03C83D:        .db $14,$0C,$10,$15

DATA_03C841:        .db $08,$10,$0C,$05

ADDR_03C845:        LDA.W $1564,X             
                    CMP.B #$01                
                    BNE ADDR_03C85B           
                    LDY.W $1534,X             
                    LDA.W FireworkSfx1,Y      ;  \ Play sound effect
                    STA.W $1DF9               ;  /
                    LDA.W FireworkSfx2,Y      ;  \ Play sound effect
                    STA.W $1DFC               ;  /
ADDR_03C85B:        JSL.L UpdateYPosNoGrvty   
                    INC $B6,X                 
                    LDA $B6,X                 
                    AND.B #$03                
                    BNE ADDR_03C869           
                    INC $AA,X                 
ADDR_03C869:        LDA $AA,X                 
                    CMP.B #$FC                
                    BNE ADDR_03C885           
                    INC $C2,X                 
                    LDY.W $1534,X             
                    LDA.W DATA_03C83D,Y       
                    STA.W $151C,X             
                    LDA.W DATA_03C841,Y       
                    STA.W $15AC,X             
                    LDA.B #$08                
                    STA.W $156D               
ADDR_03C885:        JSR.W ADDR_03C96D         
                    RTS                       ; Return

DATA_03C889:        .db $FF,$80,$C0,$FF

ADDR_03C88D:        LDA.W $15AC,X             
                    DEC A                     
                    BNE ADDR_03C8A2           
                    LDY.W $1534,X             
                    LDA.W FireworkSfx3,Y      ;  \ Play sound effect
                    STA.W $1DF9               ;  /
                    LDA.W FireworkSfx4,Y      ;  \ Play sound effect
                    STA.W $1DFC               ;  /
ADDR_03C8A2:        JSR.W ADDR_03C8B1         
                    LDA $C2,X                 
                    CMP.B #$02                
                    BNE ADDR_03C8AE           
                    JSR.W ADDR_03C8B1         
ADDR_03C8AE:        JMP.W ADDR_03C9E9         

ADDR_03C8B1:        LDY.W $1534,X             
                    LDA.W $1570,X             
                    CLC                       
                    ADC.W $151C,X             
                    STA.W $1570,X             
                    BCS ADDR_03C8DB           
                    CMP.W DATA_03C889,Y       
                    BCS ADDR_03C8E0           
                    LDA.W $151C,X             
                    CMP.B #$02                
                    BCC ADDR_03C8D4           
                    SEC                       
                    SBC.B #$01                
                    STA.W $151C,X             
                    BCS ADDR_03C8E4           
ADDR_03C8D4:        LDA.B #$01                
                    STA.W $151C,X             
                    BRA ADDR_03C8E4           

ADDR_03C8DB:        LDA.B #$FF                
                    STA.W $1570,X             
ADDR_03C8E0:        INC $C2,X                 
                    STZ $AA,X                 ; Sprite Y Speed = 0
ADDR_03C8E4:        LDA.W $151C,X             
                    AND.B #$FF                
                    TAY                       
                    LDA.W DATA_03C8F1,Y       
                    STA.W $1602,X             
                    RTS                       ; Return

DATA_03C8F1:        .db $06,$05,$04,$03,$03,$03,$03,$02
                    .db $02,$02,$02,$02,$02,$02,$01,$01
                    .db $01,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $03,$03,$03,$03,$03,$03,$03,$03
                    .db $03,$03,$02,$02,$02,$02,$02,$02
                    .db $02,$02,$02,$02,$02,$02,$02,$02
                    .db $02,$02,$02,$02,$02,$02,$02,$02

ADDR_03C941:        LDA $13                   
                    AND.B #$07                
                    BNE ADDR_03C949           
                    INC $AA,X                 
ADDR_03C949:        JSL.L UpdateYPosNoGrvty   
                    LDA.B #$07                
                    LDY $AA,X                 
                    CPY.B #$08                
                    BNE ADDR_03C958           
                    STZ.W $14C8,X             
ADDR_03C958:        CPY.B #$03                
                    BCC ADDR_03C962           
                    INC A                     
                    CPY.B #$05                
                    BCC ADDR_03C962           
                    INC A                     
ADDR_03C962:        STA.W $1602,X             
                    JSR.W ADDR_03C9E9         
                    RTS                       ; Return

DATA_03C969:        .db $EC,$8E,$EC,$EC

ADDR_03C96D:        TXA                       
                    EOR $13                   
                    AND.B #$03                
                    BNE Return03C9B8          
                    JSR.W GetDrawInfoBnk3     
                    LDY.B #$00                
                    LDA $00                   
                    STA.W $0300,Y             
                    STA.W $0304,Y             
                    LDA $01                   
                    STA.W $0301,Y             
                    PHX                       
                    LDA.W $1534,X             
                    TAX                       
                    LDA $13                   
                    LSR                       
                    LSR                       
                    AND.B #$02                
                    LSR                       
                    ADC.W DATA_03C969,X       
                    STA.W $0302,Y             
                    PLX                       
                    LDA $13                   
                    ASL                       
                    AND.B #$0E                
                    STA $02                   
                    LDA $13                   
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    AND.B #$40                
                    ORA $02                   
                    ORA.B #$31                
                    STA.W $0303,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$00                
                    STA.W $0460,Y             
Return03C9B8:       RTS                       ; Return

DATA_03C9B9:        .db $36,$35,$C7,$34,$34,$34,$34,$24
                    .db $03,$03,$36,$35,$C7,$34,$34,$24
                    .db $24,$24,$24,$03,$36,$35,$C7,$34
                    .db $34,$34,$24,$24,$03,$24,$36,$35
                    .db $C7,$34,$24,$24,$24,$24,$24,$03
DATA_03C9E1:        .db $00,$01,$01,$00,$00,$FF,$FF,$00

ADDR_03C9E9:        TXA                       
                    EOR $13                   
                    STA $05                   
                    LDA.W $1570,X             
                    STA $06                   
                    LDA.W $1602,X             
                    STA $07                   
                    LDA $E4,X                 
                    STA $08                   
                    LDA $D8,X                 
                    SEC                       
                    SBC $1C                   
                    STA $09                   
                    LDA.W $1534,X             
                    STA $0A                   
                    PHX                       
                    LDX.B #$3F                
                    LDY.B #$00                
ADDR_03CA0D:        STX $04                   
                    LDA $0A                   
                    CMP.B #$03                
                    LDA.W DATA_03C626,X       
                    BCC ADDR_03CA1B           
                    LDA.W DATA_03C6CE,X       
ADDR_03CA1B:        SEC                       
                    SBC.B #$40                
                    STA $00                   
                    PHY                       
                    LDA $0A                   
                    CMP.B #$03                
                    LDA.W DATA_03C67A,X       
                    BCC ADDR_03CA2D           
                    LDA.W DATA_03C722,X       
ADDR_03CA2D:        SEC                       
                    SBC.B #$50                
                    STA $01                   
                    LDA $00                   
                    BPL ADDR_03CA39           
                    EOR.B #$FF                
                    INC A                     
ADDR_03CA39:        STA.W $4202               ; Multiplicand A
                    LDA $06                   
                    STA.W $4203               ; Multplier B
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    LDA.W $4217               ; Product/Remainder Result (High Byte)
                    LDY $00                   
                    BPL ADDR_03CA4F           
                    EOR.B #$FF                
                    INC A                     
ADDR_03CA4F:        STA $02                   
                    LDA $01                   
                    BPL ADDR_03CA58           
                    EOR.B #$FF                
                    INC A                     
ADDR_03CA58:        STA.W $4202               ; Multiplicand A
                    LDA $06                   
                    STA.W $4203               ; Multplier B
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    LDA.W $4217               ; Product/Remainder Result (High Byte)
                    LDY $01                   
                    BPL ADDR_03CA6E           
                    EOR.B #$FF                
                    INC A                     
ADDR_03CA6E:        STA $03                   
                    LDY.B #$00                
                    LDA $07                   
                    CMP.B #$06                
                    BCC ADDR_03CA82           
                    LDA $05                   
                    CLC                       
                    ADC $04                   
                    LSR                       
                    LSR                       
                    AND.B #$07                
                    TAY                       
ADDR_03CA82:        LDA.W DATA_03C9E1,Y       
                    PLY                       
                    CLC                       
                    ADC $02                   
                    CLC                       
                    ADC $08                   
                    STA.W $0200,Y             
                    LDA $03                   
                    CLC                       
                    ADC $09                   
                    STA.W $0201,Y             
                    PHX                       
                    LDA $05                   
                    AND.B #$03                
                    STA $0F                   
                    ASL                       
                    ASL                       
                    ASL                       
                    ADC $0F                   
                    ADC $0F                   
                    ADC $07                   
                    TAX                       
                    LDA.W DATA_03C9B9,X       
                    STA.W $0202,Y             
                    PLX                       
                    LDA $05                   
                    LSR                       
                    NOP                       
                    NOP                       
                    PHX                       
                    LDX $0A                   
                    CPX.B #$03                
                    BEQ ADDR_03CABD           
                    EOR $04                   
ADDR_03CABD:        AND.B #$0E                
                    ORA.B #$31                
                    STA.W $0203,Y             
                    PLX                       
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
                    DEX                       
                    BMI ADDR_03CADA           
                    JMP.W ADDR_03CA0D         

ADDR_03CADA:        LDX.B #$53                
ADDR_03CADC:        STX $04                   
                    LDA $0A                   
                    CMP.B #$03                
                    LDA.W DATA_03C626,X       
                    BCC ADDR_03CAEA           
                    LDA.W DATA_03C6CE,X       
ADDR_03CAEA:        SEC                       
                    SBC.B #$40                
                    STA $00                   
                    LDA $0A                   
                    CMP.B #$03                
                    LDA.W DATA_03C67A,X       
                    BCC ADDR_03CAFB           
                    LDA.W DATA_03C722,X       
ADDR_03CAFB:        SEC                       
                    SBC.B #$50                
                    STA $01                   
                    PHY                       
                    LDA $00                   
                    BPL ADDR_03CB08           
                    EOR.B #$FF                
                    INC A                     
ADDR_03CB08:        STA.W $4202               ; Multiplicand A
                    LDA $06                   
                    STA.W $4203               ; Multplier B
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    LDA.W $4217               ; Product/Remainder Result (High Byte)
                    LDY $00                   
                    BPL ADDR_03CB1E           
                    EOR.B #$FF                
                    INC A                     
ADDR_03CB1E:        STA $02                   
                    LDA $01                   
                    BPL ADDR_03CB27           
                    EOR.B #$FF                
                    INC A                     
ADDR_03CB27:        STA.W $4202               ; Multiplicand A
                    LDA $06                   
                    STA.W $4203               ; Multplier B
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    LDA.W $4217               ; Product/Remainder Result (High Byte)
                    LDY $01                   
                    BPL ADDR_03CB3D           
                    EOR.B #$FF                
                    INC A                     
ADDR_03CB3D:        STA $03                   
                    LDY.B #$00                
                    LDA $07                   
                    CMP.B #$06                
                    BCC ADDR_03CB51           
                    LDA $05                   
                    CLC                       
                    ADC $04                   
                    LSR                       
                    LSR                       
                    AND.B #$07                
                    TAY                       
ADDR_03CB51:        LDA.W DATA_03C9E1,Y       
                    PLY                       
                    CLC                       
                    ADC $02                   
                    CLC                       
                    ADC $08                   
                    STA.W $0300,Y             
                    LDA $03                   
                    CLC                       
                    ADC $09                   
                    STA.W $0301,Y             
                    PHX                       
                    LDA $05                   
                    AND.B #$03                
                    STA $0F                   
                    ASL                       
                    ASL                       
                    ASL                       
                    ADC $0F                   
                    ADC $0F                   
                    ADC $07                   
                    TAX                       
                    LDA.W DATA_03C9B9,X       
                    STA.W $0302,Y             
                    PLX                       
                    LDA $05                   
                    LSR                       
                    NOP                       
                    NOP                       
                    PHX                       
                    LDX $0A                   
                    CPX.B #$03                
                    BEQ ADDR_03CB8C           
                    EOR $04                   
ADDR_03CB8C:        AND.B #$0E                
                    ORA.B #$31                
                    STA.W $0303,Y             
                    PLX                       
                    PHY                       
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$00                
                    STA.W $0460,Y             
                    PLY                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    CPX.B #$3F                
                    BEQ ADDR_03CBAB           
                    JMP.W ADDR_03CADC         

ADDR_03CBAB:        PLX                       
                    RTS                       ; Return

ChuckSprGenDispX:   .db $14,$EC

ChuckSprGenSpeedHi: .db $00,$FF

ChuckSprGenSpeedLo: .db $18,$E8

ExtSub03CBB3:       JSL.L FindFreeSprSlot     ; \ Return if no free slots
                    BMI Return03CC08          ; /
                    LDA.B #$1B                ; \ Sprite = Football
                    STA.W $009E,Y             ; /
                    PHX                       
                    TYX                       
                    JSL.L InitSpriteTables    
                    PLX                       
                    LDA.B #$08                ; \ Sprite status = Normal
                    STA.W $14C8,Y             ; /
                    LDA $D8,X                 
                    STA.W $00D8,Y             
                    LDA.W $14D4,X             
                    STA.W $14D4,Y             
                    LDA $E4,X                 
                    STA $01                   
                    LDA.W $14E0,X             
                    STA $00                   
                    PHX                       
                    LDA.W $157C,X             
                    TAX                       
                    LDA $01                   
                    CLC                       
                    ADC.L ChuckSprGenDispX,X  
                    STA.W $00E4,Y             
                    LDA $00                   
                    ADC.L ChuckSprGenSpeedHi,X
                    STA.W $14E0,Y             
                    LDA.L ChuckSprGenSpeedLo,X
                    STA.W $00B6,Y             
                    LDA.B #$E0                
                    STA.W $00AA,Y             
                    LDA.B #$10                
                    STA.W $1540,Y             
                    PLX                       
Return03CC08:       RTL                       ; Return

ExtSub03CC09:       PHB                       ; Wrapper
                    PHK                       
                    PLB                       
                    STZ.W $1662,X             
                    JSR.W ADDR_03CC14         
                    PLB                       
                    RTL                       ; Return

ADDR_03CC14:        JSR.W ADDR_03D484         
                    LDA.W $14C8,X             
                    CMP.B #$08                
                    BNE Return03CC37          
                    LDA $9D                   
                    BNE Return03CC37          
                    LDA.W $151C,X             
                    JSL.L ExecutePtr          

PipeKoopaPtrs:      .dw ADDR_03CC8A           
                    .dw ADDR_03CD21           
                    .dw ADDR_03CDC7           
                    .dw ADDR_03CDEF           
                    .dw ADDR_03CE0E           
                    .dw ADDR_03CE5A           
                    .dw ADDR_03CE89           

Return03CC37:       RTS                       ; Return

DATA_03CC38:        .db $18,$38,$58,$78,$98,$B8,$D8,$78
DATA_03CC40:        .db $40,$50,$50,$40,$30,$40,$50,$40
DATA_03CC48:        .db $50,$4A,$50,$4A,$4A,$40,$4A,$48
                    .db $4A

DATA_03CC51:        .db $02,$04,$06,$08,$0B,$0C,$0E,$10
                    .db $13

DATA_03CC5A:        .db $00,$01,$02,$03,$04,$05,$06,$00
                    .db $01,$02,$03,$04,$05,$06,$00,$01
                    .db $02,$03,$04,$05,$06,$00,$01,$02
                    .db $03,$04,$05,$06,$00,$01,$02,$03
                    .db $04,$05,$06,$00,$01,$02,$03,$04
                    .db $05,$06,$00,$01,$02,$03,$04,$05

ADDR_03CC8A:        LDA.W $1540,X             
                    BNE Return03CCDF          
                    LDA.W $1570,X             
                    BNE ADDR_03CC9D           
                    JSL.L GetRand             
                    AND.B #$0F                
                    STA.W $160E,X             
ADDR_03CC9D:        LDA.W $160E,X             
                    ORA.W $1570,X             
                    TAY                       
                    LDA.W DATA_03CC5A,Y       
                    TAY                       
                    LDA.W DATA_03CC38,Y       
                    STA $E4,X                 
                    LDA $C2,X                 
                    CMP.B #$06                
                    LDA.W DATA_03CC40,Y       
                    BCC ADDR_03CCB8           
                    LDA.B #$50                
ADDR_03CCB8:        STA $D8,X                 
                    LDA.B #$08                
                    LDY.W $1570,X             
                    BNE ADDR_03CCCC           
                    JSR.W ADDR_03CCE2         
                    JSL.L GetRand             
                    LSR                       
                    LSR                       
                    AND.B #$07                
ADDR_03CCCC:        STA.W $1528,X             
                    TAY                       
                    LDA.W DATA_03CC48,Y       
                    STA.W $1540,X             
                    INC.W $151C,X             
                    LDA.W DATA_03CC51,Y       
                    STA.W $1602,X             
Return03CCDF:       RTS                       ; Return

DATA_03CCE0:        .db $10,$20

ADDR_03CCE2:        LDY.B #$01                
                    JSR.W ADDR_03CCE8         
                    DEY                       
ADDR_03CCE8:        LDA.B #$08                ; \ Sprite status = Normal
                    STA.W $14C8,Y             ; /
                    LDA.B #$29                
                    STA.W $009E,Y             
                    PHX                       
                    TYX                       
                    JSL.L InitSpriteTables    
                    PLX                       
                    LDA.W DATA_03CCE0,Y       
                    STA.W $1570,Y             
                    LDA $C2,X                 
                    STA.W $00C2,Y             
                    LDA.W $160E,X             
                    STA.W $160E,Y             
                    LDA $E4,X                 
                    STA.W $00E4,Y             
                    LDA.W $14E0,X             
                    STA.W $14E0,Y             
                    LDA $D8,X                 
                    STA.W $00D8,Y             
                    LDA.W $14D4,X             
                    STA.W $14D4,Y             
                    RTS                       ; Return

ADDR_03CD21:        LDA.W $1540,X             
                    BNE ADDR_03CD2E           
                    LDA.B #$40                
                    STA.W $1540,X             
                    INC.W $151C,X             
ADDR_03CD2E:        LDA.B #$F8                
                    STA $AA,X                 
                    JSL.L UpdateYPosNoGrvty   
                    RTS                       ; Return

DATA_03CD37:        .db $02,$02,$02,$02,$03,$03,$03,$03
                    .db $03,$03,$03,$03,$02,$02,$02,$02
                    .db $04,$04,$04,$04,$05,$05,$04,$05
                    .db $05,$04,$05,$05,$04,$04,$04,$04
                    .db $06,$06,$06,$06,$07,$07,$07,$07
                    .db $07,$07,$07,$07,$06,$06,$06,$06
                    .db $08,$08,$08,$08,$08,$09,$09,$08
                    .db $08,$09,$09,$08,$08,$08,$08,$08
                    .db $0B,$0B,$0B,$0B,$0B,$0A,$0B,$0A
                    .db $0B,$0A,$0B,$0A,$0B,$0B,$0B,$0B
                    .db $0C,$0C,$0C,$0C,$0D,$0C,$0D,$0C
                    .db $0D,$0C,$0D,$0C,$0D,$0D,$0D,$0D
                    .db $0E,$0E,$0E,$0E,$0E,$0F,$0E,$0F
                    .db $0E,$0F,$0E,$0F,$0E,$0E,$0E,$0E
                    .db $10,$10,$10,$10,$11,$12,$11,$10
                    .db $11,$12,$11,$10,$11,$11,$11,$11
                    .db $13,$13,$13,$13,$13,$13,$13,$13
                    .db $13,$13,$13,$13,$13,$13,$13,$13

ADDR_03CDC7:        JSR.W ADDR_03CEA7         
                    LDA.W $1540,X             
                    BNE ADDR_03CDDA           
ADDR_03CDCF:        LDA.B #$24                
                    STA.W $1540,X             
                    LDA.B #$03                
                    STA.W $151C,X             
                    RTS                       ; Return

ADDR_03CDDA:        LSR                       
                    LSR                       
                    STA $00                   
                    LDA.W $1528,X             
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ORA $00                   
                    TAY                       
                    LDA.W DATA_03CD37,Y       
                    STA.W $1602,X             
                    RTS                       ; Return

ADDR_03CDEF:        LDA.W $1540,X             
                    BNE ADDR_03CE05           
                    LDA.W $1570,X             
                    BEQ ADDR_03CDFD           
                    STZ.W $14C8,X             
                    RTS                       ; Return

ADDR_03CDFD:        STZ.W $151C,X             
                    LDA.B #$30                
                    STA.W $1540,X             
ADDR_03CE05:        LDA.B #$10                
                    STA $AA,X                 
                    JSL.L UpdateYPosNoGrvty   
                    RTS                       ; Return

ADDR_03CE0E:        LDA.W $1540,X             
                    BNE ADDR_03CE2A           
                    INC.W $1534,X             
                    LDA.W $1534,X             
                    CMP.B #$03                
                    BNE ADDR_03CDCF           
                    LDA.B #$05                
                    STA.W $151C,X             
                    STZ $AA,X                 ; Sprite Y Speed = 0
                    LDA.B #$23                
                    STA.W $1DF9               ; / Play sound effect
                    RTS                       ; Return

ADDR_03CE2A:        LDY.W $1570,X             
                    BNE ADDR_03CE42           
ADDR_03CE2F:        CMP.B #$24                
                    BNE ADDR_03CE38           
                    LDY.B #$29                
                    STY.W $1DFC               ; / Play sound effect
ADDR_03CE38:        LDA $14                   
                    LSR                       
                    LSR                       
                    AND.B #$01                
                    STA.W $1602,X             
                    RTS                       ; Return

ADDR_03CE42:        CMP.B #$10                
                    BNE ADDR_03CE4B           
                    LDY.B #$2A                
                    STY.W $1DFC               ; / Play sound effect
ADDR_03CE4B:        LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_03CE56,Y       
                    STA.W $1602,X             
                    RTS                       ; Return

DATA_03CE56:        .db $16,$16,$15,$14

ADDR_03CE5A:        JSL.L UpdateYPosNoGrvty   
                    LDA $AA,X                 
                    CMP.B #$40                
                    BPL ADDR_03CE69           
                    CLC                       
                    ADC.B #$03                
                    STA $AA,X                 
ADDR_03CE69:        LDA.W $14D4,X             
                    BEQ ADDR_03CE87           
                    LDA $D8,X                 
                    CMP.B #$85                
                    BCC ADDR_03CE87           
                    LDA.B #$06                
                    STA.W $151C,X             
                    LDA.B #$80                
                    STA.W $1540,X             
                    LDA.B #$20                
                    STA.W $1DFC               ; / Play sound effect
                    JSL.L ExtSub028528        
ADDR_03CE87:        BRA ADDR_03CE2F           

ADDR_03CE89:        LDA.W $1540,X             
                    BNE ADDR_03CE9E           
                    STZ.W $14C8,X             
                    INC.W $13C6               
                    LDA.B #$FF                
                    STA.W $1493               
                    LDA.B #$0B                
                    STA.W $1DFB               ; / Change music
ADDR_03CE9E:        LDA.B #$04                
                    STA $AA,X                 
                    JSL.L UpdateYPosNoGrvty   
                    RTS                       ; Return

ADDR_03CEA7:        JSL.L MarioSprInteract    
                    BCC Return03CEF1          
                    LDA $7D                   
                    CMP.B #$10                
                    BMI ADDR_03CEED           
                    JSL.L DisplayContactGfx   
                    LDA.B #$02                
                    JSL.L GivePoints          
                    JSL.L BoostMarioSpeed     
                    LDA.B #$02                
                    STA.W $1DF9               ; / Play sound effect
                    LDA.W $1570,X             
                    BNE ADDR_03CEDB           
                    LDA.B #$28                
                    STA.W $1DFC               ; / Play sound effect
                    LDA.W $1534,X             
                    CMP.B #$02                
                    BNE ADDR_03CEDB           
                    JSL.L KillMostSprites     
ADDR_03CEDB:        LDA.B #$04                
                    STA.W $151C,X             
                    LDA.B #$50                
                    LDY.W $1570,X             
                    BEQ ADDR_03CEE9           
                    LDA.B #$1F                
ADDR_03CEE9:        STA.W $1540,X             
                    RTS                       ; Return

ADDR_03CEED:        JSL.L HurtMario           
Return03CEF1:       RTS                       ; Return

DATA_03CEF2:        .db $F8,$08,$F8,$08,$00,$00,$F8,$08
                    .db $F8,$08,$00,$00,$F8,$00,$00,$00
                    .db $00,$00,$FB,$00,$FB,$03,$00,$00
                    .db $F8,$08,$00,$00,$08,$00,$F8,$08
                    .db $00,$00,$00,$00,$F8,$00,$00,$00
                    .db $00,$00,$F8,$00,$08,$00,$00,$00
                    .db $F8,$08,$00,$06,$00,$00,$F8,$08
                    .db $00,$02,$00,$00,$F8,$08,$00,$04
                    .db $00,$08,$F8,$08,$00,$00,$08,$00
                    .db $F8,$08,$00,$00,$00,$00,$F8,$08
                    .db $00,$00,$00,$00,$F8,$08,$00,$00
                    .db $08,$00,$F8,$08,$00,$00,$08,$00
                    .db $F8,$08,$00,$00,$00,$00,$F8,$08
                    .db $00,$00,$00,$00,$F8,$08,$00,$00
                    .db $00,$00,$F8,$08,$00,$00,$08,$00
                    .db $F8,$08,$00,$00,$00,$00,$F8,$08
                    .db $00,$00,$00,$00,$F8,$08,$00,$00
                    .db $00,$00

DATA_03CF7C:        .db $F8,$08,$F8,$08,$00,$00,$F8,$08
                    .db $F8,$08,$00,$00,$F8,$00,$08,$00
                    .db $00,$00,$FB,$00,$FB,$03,$00,$00
                    .db $F8,$08,$00,$00,$08,$00,$F8,$08
                    .db $00,$00,$00,$00,$F8,$00,$08,$00
                    .db $00,$00,$F8,$00,$08,$00,$00,$00
                    .db $F8,$08,$00,$06,$00,$08,$F8,$08
                    .db $00,$02,$00,$08,$F8,$08,$00,$04
                    .db $00,$08,$F8,$08,$00,$00,$08,$00
                    .db $F8,$08,$00,$00,$00,$00,$F8,$08
                    .db $00,$00,$00,$00,$F8,$08,$00,$00
                    .db $08,$00,$F8,$08,$00,$00,$08,$00
                    .db $F8,$08,$00,$00,$00,$00,$F8,$08
                    .db $00,$00,$00,$00,$F8,$08,$00,$00
                    .db $00,$00,$F8,$08,$00,$00,$08,$00
                    .db $F8,$08,$00,$00,$00,$00,$F8,$08
                    .db $00,$00,$00,$00,$F8,$08,$00,$00
                    .db $00,$00

DATA_03D006:        .db $04,$04,$14,$14,$00,$00,$04,$04
                    .db $14,$14,$00,$00,$00,$08,$F8,$00
                    .db $00,$00,$00,$08,$F8,$F8,$00,$00
                    .db $05,$05,$00,$F8,$F8,$00,$05,$05
                    .db $00,$00,$00,$00,$00,$08,$F8,$00
                    .db $00,$00,$00,$08,$00,$00,$00,$00
                    .db $05,$05,$00,$F8,$00,$00,$05,$05
                    .db $00,$F8,$00,$00,$05,$05,$00,$0F
                    .db $F8,$F8,$05,$05,$00,$F8,$F8,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$05,$05,$00,$F8
                    .db $F8,$00,$05,$05,$00,$F8,$F8,$00
                    .db $04,$04,$02,$00,$00,$00,$04,$04
                    .db $01,$00,$00,$00,$04,$04,$00,$00
                    .db $00,$00,$05,$05,$00,$F8,$F8,$00
                    .db $05,$05,$00,$00,$00,$00,$05,$05
                    .db $03,$00,$00,$00,$05,$05,$04,$00
                    .db $00,$00

DATA_03D090:        .db $04,$04,$14,$14,$00,$00,$04,$04
                    .db $14,$14,$00,$00,$00,$08,$00,$00
                    .db $00,$00,$00,$08,$F8,$F8,$00,$00
                    .db $05,$05,$00,$F8,$F8,$00,$05,$05
                    .db $00,$00,$00,$00,$00,$08,$00,$00
                    .db $00,$00,$00,$08,$08,$00,$00,$00
                    .db $05,$05,$00,$F8,$F8,$00,$05,$05
                    .db $00,$F8,$F8,$00,$05,$05,$00,$0F
                    .db $F8,$F8,$05,$05,$00,$F8,$F8,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$05,$05,$00,$F8
                    .db $F8,$00,$05,$05,$00,$F8,$F8,$00
                    .db $04,$04,$02,$00,$00,$00,$04,$04
                    .db $01,$00,$00,$00,$04,$04,$00,$00
                    .db $00,$00,$05,$05,$00,$F8,$F8,$00
                    .db $05,$05,$00,$00,$00,$00,$05,$05
                    .db $03,$00,$00,$00,$05,$05,$04,$00
                    .db $00,$00

DATA_03D11A:        .db $20,$20,$26,$26,$08,$00,$2E,$2E
                    .db $24,$24,$08,$00,$00,$28,$02,$00
                    .db $00,$00,$04,$28,$12,$12,$00,$00
                    .db $22,$22,$04,$12,$12,$00,$20,$20
                    .db $08,$00,$00,$00,$00,$28,$02,$00
                    .db $00,$00,$0A,$28,$13,$00,$00,$00
                    .db $20,$20,$0C,$02,$00,$00,$20,$20
                    .db $0C,$02,$00,$00,$22,$22,$06,$03
                    .db $12,$12,$20,$20,$06,$12,$12,$00
                    .db $2A,$2A,$00,$00,$00,$00,$2C,$2C
                    .db $00,$00,$00,$00,$20,$20,$06,$12
                    .db $12,$00,$20,$20,$06,$12,$12,$00
                    .db $22,$22,$08,$00,$00,$00,$20,$20
                    .db $08,$00,$00,$00,$2E,$2E,$08,$00
                    .db $00,$00,$4E,$4E,$60,$43,$43,$00
                    .db $4E,$4E,$64,$00,$00,$00,$62,$62
                    .db $64,$00,$00,$00,$62,$62,$64,$00
                    .db $00,$00

DATA_03D1A4:        .db $20,$20,$26,$26,$48,$00,$2E,$2E
                    .db $24,$24,$48,$00,$40,$28,$42,$00
                    .db $00,$00,$44,$28,$52,$52,$00,$00
                    .db $22,$22,$44,$52,$52,$00,$20,$20
                    .db $48,$00,$00,$00,$40,$28,$42,$00
                    .db $00,$00,$4A,$28,$53,$00,$00,$00
                    .db $20,$20,$4C,$1E,$1F,$00,$20,$20
                    .db $4C,$1F,$1E,$00,$22,$22,$44,$03
                    .db $52,$52,$20,$20,$44,$52,$52,$00
                    .db $2A,$2A,$00,$00,$00,$00,$2C,$2C
                    .db $00,$00,$00,$00,$20,$20,$46,$52
                    .db $52,$00,$20,$20,$46,$52,$52,$00
                    .db $22,$22,$48,$00,$00,$00,$20,$20
                    .db $48,$00,$00,$00,$2E,$2E,$48,$00
                    .db $00,$00,$4E,$4E,$66,$68,$68,$00
                    .db $4E,$4E,$6A,$00,$00,$00,$62,$62
                    .db $6A,$00,$00,$00,$62,$62,$6A,$00
                    .db $00,$00

LemmyGfxProp:       .db $05,$45,$05,$45,$05,$00,$05,$45
                    .db $05,$45,$05,$00,$05,$05,$05,$00
                    .db $00,$00,$05,$05,$05,$45,$00,$00
                    .db $05,$45,$05,$05,$45,$00,$05,$45
                    .db $05,$00,$00,$00,$05,$05,$05,$00
                    .db $00,$00,$05,$05,$05,$00,$00,$00
                    .db $05,$45,$05,$05,$00,$00,$05,$45
                    .db $45,$45,$00,$00,$05,$45,$05,$05
                    .db $05,$45,$05,$45,$45,$05,$45,$00
                    .db $05,$45,$00,$00,$00,$00,$05,$45
                    .db $00,$00,$00,$00,$05,$45,$45,$05
                    .db $45,$00,$05,$45,$05,$05,$45,$00
                    .db $05,$45,$05,$00,$00,$00,$05,$45
                    .db $05,$00,$00,$00,$05,$45,$05,$00
                    .db $00,$00,$07,$47,$07,$07,$47,$00
                    .db $07,$47,$07,$00,$00,$00,$07,$47
                    .db $07,$00,$00,$00,$07,$47,$07,$00
                    .db $00,$00

WendyGfxProp:       .db $09,$49,$09,$49,$09,$00,$09,$49
                    .db $09,$49,$09,$00,$09,$09,$09,$00
                    .db $00,$00,$09,$09,$09,$49,$00,$00
                    .db $09,$49,$09,$09,$49,$00,$09,$49
                    .db $09,$00,$00,$00,$09,$09,$09,$00
                    .db $00,$00,$09,$09,$09,$00,$00,$00
                    .db $09,$49,$09,$09,$09,$00,$09,$49
                    .db $49,$49,$49,$00,$09,$49,$09,$09
                    .db $09,$49,$09,$49,$49,$09,$49,$00
                    .db $09,$49,$00,$00,$00,$00,$09,$49
                    .db $00,$00,$00,$00,$09,$49,$49,$09
                    .db $49,$00,$09,$49,$09,$09,$49,$00
                    .db $09,$49,$09,$00,$00,$00,$09,$49
                    .db $09,$00,$00,$00,$09,$49,$09,$00
                    .db $00,$00,$05,$45,$05,$05,$45,$00
                    .db $05,$45,$05,$00,$00,$00,$05,$45
                    .db $05,$00,$00,$00,$05,$45,$05,$00
                    .db $00,$00

DATA_03D342:        .db $02,$02,$02,$02,$02,$04,$02,$02
                    .db $02,$02,$02,$04,$02,$02,$00,$04
                    .db $04,$04,$02,$02,$00,$00,$04,$04
                    .db $02,$02,$02,$00,$00,$04,$02,$02
                    .db $02,$04,$04,$04,$02,$02,$00,$04
                    .db $04,$04,$02,$02,$00,$04,$04,$04
                    .db $02,$02,$02,$00,$04,$04,$02,$02
                    .db $02,$00,$04,$04,$02,$02,$02,$00
                    .db $00,$00,$02,$02,$02,$00,$00,$04
                    .db $02,$02,$04,$04,$04,$04,$02,$02
                    .db $04,$04,$04,$04,$02,$02,$02,$00
                    .db $00,$04,$02,$02,$02,$00,$00,$04
                    .db $02,$02,$02,$04,$04,$04,$02,$02
                    .db $02,$04,$04,$04,$02,$02,$02,$04
                    .db $04,$04,$02,$02,$02,$00,$00,$04
                    .db $02,$02,$02,$04,$04,$04,$02,$02
                    .db $02,$04,$04,$04,$02,$02,$02,$04
                    .db $04,$04

DATA_03D3CC:        .db $02,$02,$02,$02,$02,$04,$02,$02
                    .db $02,$02,$02,$04,$02,$02,$00,$04
                    .db $04,$04,$02,$02,$00,$00,$04,$04
                    .db $02,$02,$02,$00,$00,$04,$02,$02
                    .db $02,$04,$04,$04,$02,$02,$00,$04
                    .db $04,$04,$02,$02,$00,$04,$04,$04
                    .db $02,$02,$02,$00,$00,$04,$02,$02
                    .db $02,$00,$00,$04,$02,$02,$02,$00
                    .db $00,$00,$02,$02,$02,$00,$00,$04
                    .db $02,$02,$04,$04,$04,$04,$02,$02
                    .db $04,$04,$04,$04,$02,$02,$02,$00
                    .db $00,$04,$02,$02,$02,$00,$00,$04
                    .db $02,$02,$02,$04,$04,$04,$02,$02
                    .db $02,$04,$04,$04,$02,$02,$02,$04
                    .db $04,$04,$02,$02,$02,$00,$00,$04
                    .db $02,$02,$02,$04,$04,$04,$02,$02
                    .db $02,$04,$04,$04,$02,$02,$02,$04
                    .db $04,$04

DATA_03D456:        .db $04,$04,$02,$03,$04,$02,$02,$02
                    .db $03,$03,$05,$04,$01,$01,$04,$04
                    .db $02,$02,$02,$04,$02,$02,$02

DATA_03D46D:        .db $04,$04,$02,$03,$04,$02,$02,$02
                    .db $04,$04,$05,$04,$01,$01,$04,$04
                    .db $02,$02,$02,$04,$02,$02,$02

ADDR_03D484:        JSR.W GetDrawInfoBnk3     
                    LDA.W $1602,X             
                    ASL                       
                    ASL                       
                    ADC.W $1602,X             
                    ADC.W $1602,X             
                    STA $02                   
                    LDA $C2,X                 
                    CMP.B #$06                
                    BEQ ADDR_03D4DF           
                    PHX                       
                    LDA.W $1602,X             
                    TAX                       
                    LDA.W DATA_03D456,X       
                    TAX                       
ADDR_03D4A3:        PHX                       
                    TXA                       
                    CLC                       
                    ADC $02                   
                    TAX                       
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_03CEF2,X       
                    STA.W $0300,Y             
                    LDA $01                   
                    CLC                       
                    ADC.W DATA_03D006,X       
                    STA.W $0301,Y             
                    LDA.W DATA_03D11A,X       
                    STA.W $0302,Y             
                    LDA.W LemmyGfxProp,X      
                    ORA.B #$10                
                    STA.W $0303,Y             
                    PHY                       
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_03D342,X       
                    STA.W $0460,Y             
                    PLY                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    PLX                       
                    DEX                       
                    BPL ADDR_03D4A3           
ADDR_03D4DD:        PLX                       
                    RTS                       ; Return

ADDR_03D4DF:        PHX                       
                    LDA.W $1602,X             
                    TAX                       
                    LDA.W DATA_03D46D,X       
                    TAX                       
ADDR_03D4E8:        PHX                       
                    TXA                       
                    CLC                       
                    ADC $02                   
                    TAX                       
                    LDA $00                   
                    CLC                       
                    ADC.W DATA_03CF7C,X       
                    STA.W $0300,Y             
                    LDA $01                   
                    CLC                       
                    ADC.W DATA_03D090,X       
                    STA.W $0301,Y             
                    LDA.W DATA_03D1A4,X       
                    STA.W $0302,Y             
                    LDA.W WendyGfxProp,X      
                    ORA.B #$10                
                    STA.W $0303,Y             
                    PHY                       
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_03D3CC,X       
                    STA.W $0460,Y             
                    PLY                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    PLX                       
                    DEX                       
                    BPL ADDR_03D4E8           
                    BRA ADDR_03D4DD           

DATA_03D524:        .db $18,$20

DATA_03D526:        .db $A1,$0E,$20,$20,$88,$0E,$28,$20
                    .db $AB,$0E,$30,$20,$99,$0E,$38,$20
                    .db $A8,$0E,$40,$20,$BF,$0E,$48,$20
                    .db $AC,$0E,$58,$20,$88,$0E,$60,$20
                    .db $8B,$0E,$68,$20,$AF,$0E,$70,$20
                    .db $8C,$0E,$78,$20,$9E,$0E,$80,$20
                    .db $AD,$0E,$88,$20,$AE,$0E,$90,$20
                    .db $AB,$0E,$98,$20,$8C,$0E,$A8,$20
                    .db $99,$0E,$B0,$20,$AC,$0E,$C0,$20
                    .db $A8,$0E,$C8,$20,$AF,$0E,$D0,$20
                    .db $8C,$0E,$D8,$20,$AB,$0E,$E0,$20
                    .db $BD,$0E,$18,$30,$A1,$0E,$20,$30
                    .db $88,$0E,$28,$30,$AB,$0E,$30,$30
                    .db $99,$0E,$38,$30,$A8,$0E,$40,$30
                    .db $BE,$0E,$48,$30,$AD,$0E,$50,$30
                    .db $98,$0E,$58,$30,$8C,$0E,$68,$30
                    .db $A0,$0E,$70,$30,$AB,$0E,$78,$30
                    .db $99,$0E,$80,$30,$9E,$0E,$88,$30
                    .db $8A,$0E,$90,$30,$8C,$0E,$98,$30
                    .db $AC,$0E,$A0,$30,$AC,$0E,$A8,$30
                    .db $BE,$0E,$B0,$30,$B0,$0E,$B8,$30
                    .db $A8,$0E,$C0,$30,$AC,$0E,$C8,$30
                    .db $98,$0E,$D0,$30,$99,$0E,$D8,$30
                    .db $BE,$0E,$18,$40,$88,$0E,$20,$40
                    .db $9E,$0E,$28,$40,$8B,$0E,$38,$40
                    .db $98,$0E,$40,$40,$99,$0E,$48,$40
                    .db $AC,$0E,$58,$40,$8D,$0E,$60,$40
                    .db $AB,$0E,$68,$40,$99,$0E,$70,$40
                    .db $8C,$0E,$78,$40,$9E,$0E,$80,$40
                    .db $8B,$0E,$88,$40,$AC,$0E,$98,$40
                    .db $88,$0E,$A0,$40,$AB,$0E,$A8,$40
                    .db $8C,$0E,$B8,$40,$8E,$0E,$C0,$40
                    .db $A8,$0E,$C8,$40,$99,$0E,$D0,$40
                    .db $9E,$0E,$D8,$40,$8E,$0E,$18,$50
                    .db $AD,$0E,$20,$50,$A8,$0E,$30,$50
                    .db $AD,$0E,$38,$50,$88,$0E,$40,$50
                    .db $9B,$0E,$48,$50,$8C,$0E,$58,$50
                    .db $88,$0E,$68,$50,$AF,$0E,$70,$50
                    .db $88,$0E,$78,$50,$8A,$0E,$80,$50
                    .db $88,$0E,$88,$50,$AD,$0E,$90,$50
                    .db $99,$0E,$98,$50,$A8,$0E,$A0,$50
                    .db $9E,$0E,$A8,$50,$BD,$0E

ADDR_03D674:        PHX                       
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDX.W $1921               
                    BEQ ADDR_03D6A8           
                    DEX                       
                    LDY.W #$0000              
ADDR_03D680:        PHX                       
                    TXA                       
                    ASL                       
                    ASL                       
                    TAX                       
                    LDA.W DATA_03D524,X       
                    STA.W $0200,Y             
                    LDA.W DATA_03D526,X       
                    STA.W $0202,Y             
                    PHY                       
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.B #$00                
                    STA.W $0420,Y             
                    REP #$20                  ; Accum (16 bit) 
                    PLY                       
                    PLX                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_03D680           
ADDR_03D6A8:        SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    PLX                       
                    RTS                       ; Return

Empty03D6AC:        .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF

DATA_03D700:        .db $B0,$A0,$90,$80,$70,$60,$50,$40
                    .db $30,$20,$10,$00

ADDR_03D70C:        PHX                       
                    LDA.W $1520               ; \ Return if less than 2 reznors killed
                    CLC                       ;  |
                    ADC.W $1521               ;  |
                    ADC.W $1522               ;  |
                    ADC.W $1523               ;  |
                    CMP.B #$02                ;  |
                    BCC ADDR_03D757           ; /
BreakBridge:        LDX.W $1B9F               
                    CPX.B #$0C                
                    BCS ADDR_03D757           
                    LDA.L DATA_03D700,X       
                    STA $9A                   
                    STZ $9B                   
                    LDA.B #$B0                
                    STA $98                   
                    STZ $99                   
                    LDA.W $14A7               
                    BEQ ADDR_03D74A           
                    CMP.B #$3C                
                    BNE ADDR_03D757           
                    JSR.W ADDR_03D77F         
                    JSR.W ADDR_03D759         
                    JSR.W ADDR_03D77F         
                    INC.W $1B9F               
                    BRA ADDR_03D757           

ADDR_03D74A:        JSR.W ADDR_03D766         
                    LDA.B #$40                
                    STA.W $14A7               
                    LDA.B #$07                
                    STA.W $1DFC               ; / Play sound effect
ADDR_03D757:        PLX                       
                    RTL                       ; Return

ADDR_03D759:        REP #$20                  ; Accum (16 bit) 
                    LDA.W #$0170              
                    SEC                       
                    SBC $9A                   
                    STA $9A                   
                    SEP #$20                  ; Accum (8 bit) 
                    RTS                       ; Return

ADDR_03D766:        JSR.W ADDR_03D76C         
                    JSR.W ADDR_03D759         
ADDR_03D76C:        REP #$20                  ; Accum (16 bit) 
                    LDA $9A                   
                    SEC                       
                    SBC $1A                   
                    CMP.W #$0100              
                    SEP #$20                  ; Accum (8 bit) 
                    BCS Return03D77E          
                    JSL.L ExtSub028A44        
Return03D77E:       RTS                       ; Return

ADDR_03D77F:        LDA $9A                   
                    LSR                       
                    LSR                       
                    LSR                       
                    STA $01                   
                    LSR                       
                    ORA $98                   
                    REP #$20                  ; Accum (16 bit) 
                    AND.W #$00FF              
                    LDX $9B                   
                    BEQ ADDR_03D798           
                    CLC                       
                    ADC.W #$01B0              
                    LDX.B #$04                
ADDR_03D798:        STX $00                   
                    REP #$10                  ; Index (16 bit) 
                    TAX                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.B #$25                
                    STA.L $7EC800,X           
                    LDA.B #$00                
                    STA.L $7FC800,X           
                    REP #$20                  ; Accum (16 bit) 
                    LDA.L $7F837B             
                    TAX                       
                    LDA.W #$C05A              
                    CLC                       
                    ADC $00                   
                    STA.L $7F837D,X           
                    ORA.W #$2000              
                    STA.L $7F8383,X           
                    LDA.W #$0240              
                    STA.L $7F837F,X           
                    STA.L $7F8385,X           
                    LDA.W #$38FC              
                    STA.L $7F8381,X           
                    STA.L $7F8387,X           
                    LDA.W #$00FF              
                    STA.L $7F8389,X           
                    TXA                       
                    CLC                       
                    ADC.W #$000C              
                    STA.L $7F837B             
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    RTS                       ; Return

IggyPlatform:       .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$15,$16,$17,$18,$17,$18
                    .db $17,$18,$17,$18,$19,$1A,$00,$00
                    .db $00,$00,$01,$02,$03,$04,$03,$04
                    .db $03,$04,$03,$04,$05,$12,$00,$00
                    .db $00,$00,$00,$07,$04,$03,$04,$03
                    .db $04,$03,$04,$03,$08,$00,$00,$00
                    .db $00,$00,$00,$09,$0A,$04,$03,$04
                    .db $03,$04,$03,$0B,$0C,$00,$00,$00
                    .db $00,$00,$00,$00,$0D,$0E,$04,$03
                    .db $04,$03,$0F,$10,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$11,$02,$03,$04
                    .db $03,$04,$05,$12,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$07,$04,$03
                    .db $04,$03,$08,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$09,$0A,$04
                    .db $03,$0B,$0C,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$13,$03
                    .db $04,$14,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$13
                    .db $14,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
DATA_03D8EC:        .db $FF,$FF

DATA_03D8EE:        .db $FF,$FF,$FF,$FF,$24,$34,$25,$0B
                    .db $26,$36,$0E,$1B,$0C,$1C,$0D,$1D
                    .db $0E,$1E,$29,$39,$2A,$3A,$2B,$3B
                    .db $26,$38,$20,$30,$21,$31,$27,$37
                    .db $28,$38,$FF,$FF,$22,$32,$0E,$33
                    .db $0C,$1C,$0D,$1D,$0E,$3C,$2D,$3D
                    .db $FF,$FF,$07,$17,$0E,$23,$0E,$04
                    .db $0C,$1C,$0D,$1D,$0E,$09,$0E,$2C
                    .db $0A,$1A,$FF,$FF,$24,$34,$2B,$3B
                    .db $FF,$FF,$07,$17,$0E,$18,$0E,$19
                    .db $0A,$1A,$02,$12,$03,$13,$03,$08
                    .db $03,$05,$03,$05,$03,$14,$03,$15
                    .db $03,$05,$03,$05,$03,$08,$03,$06
                    .db $0F,$1F

ExtSub03D958:       REP #$10                  ; Index (16 bit) 
                    STZ.W $2115               ; VRAM Address Increment Value
                    STZ.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    STZ.W $2117               ; Address for VRAM Read/Write (High Byte)
                    LDX.W #$4000              
                    LDA.B #$FF                
ADDR_03D968:        STA.W $2118               ; Data for VRAM Write (Low Byte)
                    DEX                       
                    BNE ADDR_03D968           
                    SEP #$10                  ; Index (8 bit) 
                    BIT.W $0D9B               
                    BVS Return03D990          
                    PHB                       
                    PHK                       
                    PLB                       
                    LDA.B #$EC                
                    STA $05                   
                    LDA.B #$D7                
                    STA $06                   
                    LDA.B #$03                
                    STA $07                   
                    LDA.B #$10                
                    STA $00                   
                    LDA.B #$08                
                    STA $01                   
                    JSR.W ADDR_03D991         
                    PLB                       
Return03D990:       RTL                       ; Return

ADDR_03D991:        STZ.W $2115               ; VRAM Address Increment Value
                    LDY.B #$00                
ADDR_03D996:        STY $02                   
                    LDA.B #$00                
ADDR_03D99A:        STA $03                   
                    LDA $00                   
                    STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDA $01                   
                    STA.W $2117               ; Address for VRAM Read/Write (High Byte)
                    LDY $02                   
                    LDA.B #$10                
                    STA $04                   
ADDR_03D9AC:        LDA [$05],Y               
                    STA.W $0AF6,Y             
                    ASL                       
                    ASL                       
                    ORA $03                   
                    TAX                       
                    LDA.L DATA_03D8EC,X       
                    STA.W $2118               ; Data for VRAM Write (Low Byte)
                    LDA.L DATA_03D8EE,X       
                    STA.W $2118               ; Data for VRAM Write (Low Byte)
                    INY                       
                    DEC $04                   
                    BNE ADDR_03D9AC           
                    LDA $00                   
                    CLC                       
                    ADC.B #$80                
                    STA $00                   
                    BCC ADDR_03D9D4           
                    INC $01                   
ADDR_03D9D4:        LDA $03                   
                    EOR.B #$01                
                    BNE ADDR_03D99A           
                    TYA                       
                    BNE ADDR_03D996           
                    RTS                       ; Return

DATA_03D9DE:        .db $FF,$00,$FF,$FF,$02,$04,$06,$FF
                    .db $08,$0A,$0C,$FF,$0E,$10,$12,$FF
                    .db $FF,$00,$FF,$FF,$02,$04,$06,$FF
                    .db $08,$0A,$0C,$FF,$0E,$14,$16,$FF
                    .db $FF,$00,$FF,$FF,$02,$04,$06,$FF
                    .db $08,$0A,$0C,$FF,$0E,$18,$1A,$FF
                    .db $46,$48,$4A,$FF,$4C,$4E,$50,$FF
                    .db $52,$54,$0C,$FF,$0E,$18,$1A,$FF
                    .db $FF,$FF,$FF,$FF,$B2,$B4,$06,$FF
                    .db $D2,$D4,$0C,$FF,$0E,$18,$1A,$FF
                    .db $FF,$1C,$FF,$FF,$1E,$20,$22,$FF
                    .db $24,$26,$28,$FF,$FF,$2A,$2C,$FF
                    .db $FF,$2E,$30,$FF,$32,$34,$35,$33
                    .db $36,$38,$39,$37,$42,$44,$45,$43
                    .db $FF,$2E,$30,$FF,$32,$34,$35,$33
                    .db $36,$38,$39,$37,$42,$44,$45,$43
                    .db $FF,$2E,$30,$FF,$32,$34,$35,$33
                    .db $36,$38,$39,$37,$3E,$40,$41,$3F
                    .db $5A,$FF,$FF,$FF,$5C,$5E,$06,$FF
                    .db $08,$0A,$0C,$FF,$0E,$10,$12,$FF
                    .db $5A,$FF,$FF,$FF,$5C,$5E,$06,$FF
                    .db $08,$0A,$0C,$FF,$0E,$14,$16,$FF
                    .db $5A,$FF,$FF,$FF,$5C,$5E,$06,$FF
                    .db $08,$0A,$0C,$FF,$0E,$18,$1A,$FF
                    .db $6C,$6E,$FF,$FF,$72,$74,$50,$FF
                    .db $52,$54,$0C,$FF,$0E,$18,$1A,$FF
                    .db $FF,$BE,$FF,$FF,$DC,$DE,$06,$FF
                    .db $D2,$D4,$0C,$FF,$0E,$18,$1A,$FF
                    .db $60,$62,$FF,$FF,$64,$66,$22,$FF
                    .db $24,$26,$28,$FF,$FF,$2A,$2C,$FF
                    .db $FF,$68,$69,$FF,$32,$6A,$6B,$33
                    .db $36,$38,$39,$37,$42,$44,$45,$43
                    .db $FF,$68,$69,$FF,$32,$6A,$6B,$33
                    .db $36,$38,$39,$37,$42,$44,$45,$43
                    .db $FF,$68,$69,$FF,$32,$6A,$6B,$33
                    .db $36,$38,$39,$37,$3E,$40,$41,$3F
                    .db $7A,$7C,$FF,$FF,$7E,$80,$82,$FF
                    .db $84,$86,$0C,$FF,$0E,$10,$12,$FF
                    .db $7A,$7C,$FF,$FF,$7E,$80,$06,$FF
                    .db $84,$86,$0C,$FF,$0E,$14,$16,$FF
                    .db $7A,$7C,$FF,$FF,$7E,$80,$06,$FF
                    .db $84,$86,$0C,$FF,$0E,$18,$1A,$FF
                    .db $A0,$A2,$A4,$FF,$A6,$A8,$AA,$FF
                    .db $52,$54,$0C,$FF,$0E,$18,$1A,$FF
                    .db $FF,$B8,$FF,$FF,$D6,$D8,$DA,$FF
                    .db $D2,$D4,$0C,$FF,$0E,$18,$1A,$FF
                    .db $88,$8A,$8C,$FF,$8E,$90,$92,$FF
                    .db $94,$96,$28,$FF,$FF,$2A,$2C,$FF
                    .db $98,$9A,$9B,$99,$9C,$9E,$9F,$9D
                    .db $36,$38,$39,$37,$42,$44,$45,$43
                    .db $98,$9A,$9B,$99,$9C,$9E,$9F,$9D
                    .db $36,$38,$39,$37,$42,$44,$45,$43
                    .db $98,$9A,$9B,$99,$9C,$9E,$9F,$9D
                    .db $36,$38,$39,$37,$3E,$40,$41,$3F
                    .db $FF,$FF,$FF,$FF,$FF,$CC,$FF,$FF
                    .db $C0,$C2,$C4,$FF,$E0,$E2,$E4,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$CC,$FF,$FF
                    .db $C6,$C8,$CA,$FF,$E6,$E8,$EA,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$CD,$FF,$FF
                    .db $C5,$C3,$C1,$FF,$E5,$E3,$E1,$FF
                    .db $FF,$90,$92,$94,$96,$FF,$FF,$FF
                    .db $FF,$B0,$B2,$B4,$B6,$38,$FF,$FF
                    .db $FF,$D0,$D2,$D4,$D6,$58,$5A,$FF
                    .db $FF,$F0,$F2,$F4,$F6,$78,$7A,$FF
                    .db $FF,$90,$92,$94,$96,$FF,$FF,$FF
                    .db $FF,$98,$9A,$9C,$B6,$38,$FF,$FF
                    .db $FF,$D0,$D2,$D4,$D6,$58,$5A,$FF
                    .db $FF,$F0,$F2,$F4,$F6,$78,$7A,$FF
                    .db $FF,$90,$92,$94,$96,$FF,$FF,$FF
                    .db $FF,$98,$BA,$BC,$B6,$38,$FF,$FF
                    .db $FF,$D8,$DA,$DC,$D6,$58,$5A,$FF
                    .db $FF,$F8,$FA,$FC,$F6,$78,$7A,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$90,$92,$94,$96,$FF,$FF
                    .db $FF,$FF,$98,$BA,$BC,$B6,$38,$FF
                    .db $FF,$FF,$D8,$DA,$DC,$D6,$58,$5A
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$90,$92,$94,$96,$FF,$FF
                    .db $FF,$FF,$98,$BA,$BC,$B6,$38,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$90,$92,$94,$96,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$90,$92,$94,$96,$FF,$FF,$FF
                    .db $FF,$98,$BA,$BC,$B6,$38,$FF,$FF
                    .db $FF,$D8,$DA,$DC,$D6,$58,$5A,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $04,$06,$08,$0A,$0B,$09,$07,$05
                    .db $24,$26,$28,$2A,$2C,$29,$27,$25
                    .db $FF,$84,$86,$88,$89,$87,$85,$FF
                    .db $FF,$A4,$A6,$A8,$A9,$A7,$A5,$FF
                    .db $04,$06,$08,$0A,$0B,$09,$07,$05
                    .db $24,$26,$28,$2D,$2B,$29,$27,$25
                    .db $FF,$84,$86,$88,$89,$87,$85,$FF
                    .db $FF,$A4,$A6,$0C,$0D,$A7,$A5,$FF
                    .db $80,$82,$83,$8A,$82,$83,$8C,$8E
                    .db $A0,$A2,$A3,$C4,$A2,$A3,$AC,$AE
                    .db $80,$8A,$8A,$8A,$8A,$8A,$8C,$8E
                    .db $A0,$60,$61,$C4,$60,$61,$AC,$AE
                    .db $80,$03,$01,$8A,$00,$02,$8C,$8E
                    .db $A0,$23,$21,$C4,$20,$22,$AC,$AE
                    .db $80,$00,$02,$8A,$03,$01,$AA,$8E
                    .db $A0,$20,$22,$C4,$23,$21,$AC,$AE
                    .db $C0,$C2,$C4,$C4,$C4,$CA,$CC,$CE
                    .db $E0,$E2,$E4,$E6,$E8,$EA,$EC,$EE
                    .db $40,$42,$44,$46,$48,$4A,$4C,$4E
                    .db $FF,$62,$64,$66,$68,$6A,$6C,$FF
                    .db $10,$12,$14,$16,$18,$1A,$1C,$1E
                    .db $10,$30,$32,$34,$36,$1A,$1C,$1E
KoopaPalPtrLo:      .db $BC,$A4,$98,$78,$6C

KoopaPalPtrHi:      .db $B2,$B2,$B2,$B3,$B3

DATA_03DD78:        .db $0B,$0B,$0B,$21,$00

ExtSub03DD7D:       PHX                       
                    PHB                       
                    PHK                       
                    PLB                       
                    LDY $C2,X                 
                    STY.W $13FC               
                    CPY.B #$04                
                    BNE ADDR_03DD97           
                    JSR.W ADDR_03DE8E         
                    LDA.B #$48                
                    STA $2C                   
                    LDA.B #$14                
                    STA $38                   
                    STA $39                   
ADDR_03DD97:        LDA.B #$FF                
                    STA $5D                   
                    INC A                     
                    STA $5E                   
                    LDY.W $13FC               
                    LDX.W DATA_03DD78,Y       
                    LDA.W KoopaPalPtrLo,Y     ;  \ $00 = Pointer in bank 0 (from above tables)
                    STA $00                   ;   |
                    LDA.W KoopaPalPtrHi,Y     ;   |
                    STA $01                   ;   |
                    STZ $02                   ;  /
                    LDY.B #$0B                ;  \ Read 0B bytes and put them in $0707
ADDR_03DDB2:        LDA [$00],Y               ;   |
                    STA.W $0707,Y             ;   |
                    DEY                       ;   |
                    BPL ADDR_03DDB2           ;  /
                    LDA.B #$80                
                    STA.W $2115               ; VRAM Address Increment Value
                    STZ.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    STZ.W $2117               ; Address for VRAM Read/Write (High Byte)
                    TXY                       
                    BEQ ADDR_03DDD7           
                    JSL.L ExtSub00BA28        
                    LDA.B #$80                
                    STA $03                   
ADDR_03DDD0:        JSR.W ADDR_03DDE5         
                    DEC $03                   
                    BNE ADDR_03DDD0           
ADDR_03DDD7:        LDX.B #$5F                
ADDR_03DDD9:        LDA.B #$FF                
                    STA.L $7EC680,X           
                    DEX                       
                    BPL ADDR_03DDD9           
                    PLB                       
                    PLX                       
                    RTL                       ; Return

ADDR_03DDE5:        LDX.B #$00                
                    TXY                       
                    LDA.B #$08                
                    STA $05                   
ADDR_03DDEC:        JSR.W ADDR_03DE39         
                    PHY                       
                    TYA                       
                    LSR                       
                    CLC                       
                    ADC.B #$0F                
                    TAY                       
                    JSR.W ADDR_03DE3C         
                    LDY.B #$08                
ADDR_03DDFB:        LDA.W $1BA3,X             
                    ASL                       
                    ROL                       
                    ROL                       
                    ROL                       
                    AND.B #$07                
                    STA.W $1BA3,X             
                    STA.W $2119               ; Data for VRAM Write (High Byte)
                    INX                       
                    DEY                       
                    BNE ADDR_03DDFB           
                    PLY                       
                    DEC $05                   
                    BNE ADDR_03DDEC           
                    LDA.B #$07                
ADDR_03DE15:        TAX                       
                    LDY.B #$08                
                    STY $05                   
ADDR_03DE1A:        LDY.W $1BA3,X             
                    STY.W $2119               ; Data for VRAM Write (High Byte)
                    DEX                       
                    DEC $05                   
                    BNE ADDR_03DE1A           
                    CLC                       
                    ADC.B #$08                
                    CMP.B #$40                
                    BCC ADDR_03DE15           
                    REP #$20                  ; Accum (16 bit) 
                    LDA $00                   
                    CLC                       
                    ADC.W #$0018              
                    STA $00                   
                    SEP #$20                  ; Accum (8 bit) 
                    RTS                       ; Return

ADDR_03DE39:        JSR.W ADDR_03DE3C         
ADDR_03DE3C:        PHX                       
                    LDA [$00],Y               
                    PHY                       
                    LDY.B #$08                
ADDR_03DE42:        ASL                       
                    ROR.W $1BA3,X             
                    INX                       
                    DEY                       
                    BNE ADDR_03DE42           
                    PLY                       
                    INY                       
                    PLX                       
                    RTS                       ; Return

DATA_03DE4E:        .db $40,$41,$42,$43,$44,$45,$46,$47
                    .db $50,$51,$52,$53,$54,$55,$56,$57
                    .db $60,$61,$62,$63,$64,$65,$66,$67
                    .db $70,$71,$72,$73,$74,$75,$76,$77
                    .db $48,$49,$4A,$4B,$4C,$4D,$4E,$4F
                    .db $58,$59,$5A,$5B,$5C,$5D,$5E,$5F
                    .db $68,$69,$6A,$6B,$6C,$6D,$6E,$6F
                    .db $78,$79,$7A,$7B,$7C,$7D,$7E,$3F

ADDR_03DE8E:        STZ.W $2115               ; VRAM Address Increment Value
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W #$0A1C              
                    STA $00                   
                    LDX.B #$00                
ADDR_03DE9A:        REP #$20                  ; Accum (16 bit) 
                    LDA $00                   
                    CLC                       
                    ADC.W #$0080              
                    STA $00                   
                    STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    SEP #$20                  ; Accum (8 bit) 
                    LDY.B #$08                
ADDR_03DEAB:        LDA.L DATA_03DE4E,X       
                    STA.W $2118               ; Data for VRAM Write (Low Byte)
                    INX                       
                    DEY                       
                    BNE ADDR_03DEAB           
                    CPX.B #$40                
                    BCC ADDR_03DE9A           
                    RTS                       ; Return

DATA_03DEBB:        .db $00,$01,$10,$01

DATA_03DEBF:        .db $6E,$70,$FF,$50,$FE,$FE,$FF,$57
DATA_03DEC7:        .db $72,$74,$52,$54,$3C,$3E,$55,$53
DATA_03DECF:        .db $76,$56,$56,$FF,$FF,$FF,$51,$FF
DATA_03DED7:        .db $20,$03,$30,$03,$40,$03,$50,$03

ExtSub03DEDF:       PHB                       
                    PHK                       
                    PLB                       
                    LDA.W $14E0,X             
                    XBA                       
                    LDA $E4,X                 
                    LDY.B #$00                
                    JSR.W ADDR_03DFAE         
                    LDA.W $14D4,X             
                    XBA                       
                    LDA $D8,X                 
                    LDY.B #$02                
                    JSR.W ADDR_03DFAE         
                    PHX                       
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    STZ $06                   
                    LDY.W #$0003              
                    LDA.W $0D9B               
                    LSR                       
                    BCC ADDR_03DF44           
                    LDA.W $1428               
                    AND.W #$0003              
                    ASL                       
                    TAX                       
                    LDA.L DATA_03DEBF,X       
                    STA.L $7EC681             
                    LDA.L DATA_03DEC7,X       
                    STA.L $7EC683             
                    LDA.L DATA_03DECF,X       
                    STA.L $7EC685             
                    LDA.W #$0008              
                    STA $06                   
                    LDX.W #$0380              
                    LDA.W $1BA2               
                    AND.W #$007F              
                    CMP.W #$002C              
                    BCC ADDR_03DF3C           
                    LDX.W #$0388              
ADDR_03DF3C:        TXA                       
                    LDX.W #$000A              
                    LDY.W #$0007              
                    SEC                       
ADDR_03DF44:        STY $00                   
                    BCS ADDR_03DF55           
ADDR_03DF48:        LDA.W $1BA2               
                    AND.W #$007F              
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    LDX.W #$0003              
ADDR_03DF55:        STX $02                   
                    PHA                       
                    LDY.W $1BA1               
                    BPL ADDR_03DF60           
                    CLC                       
                    ADC $00                   
ADDR_03DF60:        TAY                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDX $06                   
                    LDA $00                   
                    STA $04                   
ADDR_03DF69:        LDA.W DATA_03D9DE,Y       
                    INY                       
                    BIT.W $1BA2               
                    BPL ADDR_03DF76           
                    EOR.B #$01                
                    DEY                       
                    DEY                       
ADDR_03DF76:        STA.L $7EC680,X           
                    INX                       
                    DEC $04                   
                    BPL ADDR_03DF69           
                    STX $06                   
                    REP #$20                  ; Accum (16 bit) 
                    PLA                       
                    SEC                       
                    ADC $00                   
                    LDX $02                   
                    CPX.W #$0004              
                    BEQ ADDR_03DF48           
                    CPX.W #$0008              
                    BNE ADDR_03DF96           
                    LDA.W #$0360              
ADDR_03DF96:        CPX.W #$000A              
                    BNE ADDR_03DFA6           
                    LDA.W $1427               
                    AND.W #$0003              
                    ASL                       
                    TAY                       
                    LDA.W DATA_03DED7,Y       
ADDR_03DFA6:        DEX                       
                    BPL ADDR_03DF55           
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    PLX                       
                    PLB                       
                    RTL                       ; Return

ADDR_03DFAE:        PHX                       
                    TYX                       
                    REP #$20                  ; Accum (16 bit) 
                    EOR.W #$FFFF              
                    INC A                     
                    CLC                       
                    ADC.L DATA_03DEBB,X       
                    CLC                       
                    ADC $1A,X                 
                    STA $3A,X                 
                    SEP #$20                  ; Accum (8 bit) 
                    PLX                       
                    RTS                       ; Return

DATA_03DFC4:        .db $00,$0E,$1C,$2A,$38,$46,$54,$62

ADDR_03DFCC:        PHX                       
                    LDX.W $0681               
                    LDA.B #$10                
                    STA.W $0682,X             
                    STZ.W $0683,X             
                    STZ.W $0684,X             
                    STZ.W $0685,X             
                    TXY                       
                    LDX.W $1FFB               
                    BNE ADDR_03E01B           
                    LDA.W $190D               
                    BEQ ADDR_03DFF0           
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W $0701               
                    BRA ADDR_03E031           

ADDR_03DFF0:        LDA $14                   ; Accum (8 bit) 
                    LSR                       
                    BCC ADDR_03E036           
                    DEC.W $1FFC               
                    BNE ADDR_03E036           
                    TAX                       
                    LDA.L DATA_04F700+8,X     
                    AND.B #$07                
                    TAX                       
                    LDA.L DATA_04F6F8,X       
                    STA.W $1FFC               
                    LDA.L DATA_04F700,X       
                    STA.W $1FFB               
                    TAX                       
                    LDA.B #$08                
                    STA.W $1FFD               
                    LDA.B #$18                
                    STA.W $1DFC               ; / Play sound effect
ADDR_03E01B:        DEC.W $1FFD               
                    BPL ADDR_03E028           
                    DEC.W $1FFB               
                    LDA.B #$04                
                    STA.W $1FFD               
ADDR_03E028:        TXA                       
                    ASL                       
                    TAX                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA.L DATA_00B5DE,X       
ADDR_03E031:        STA.W $0684,Y             
                    SEP #$20                  ; Accum (8 bit) 
ADDR_03E036:        LDX.W $1429               
                    LDA.L DATA_03DFC4,X       
                    TAX                       
                    LDA.B #$0E                
                    STA $00                   
ADDR_03E042:        LDA.L DATA_00B69E,X       
                    STA.W $0686,Y             
                    INX                       
                    INY                       
                    DEC $00                   
                    BNE ADDR_03E042           
                    TYX                       
                    STZ.W $0686,X             
                    INX                       
                    INX                       
                    INX                       
                    INX                       
                    STX.W $0681               
                    PLX                       
                    RTL                       ; Return

Empty03E05C:        .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF

                    DEC $19                   ; \ Unreachable
                    RTS                       ; / Decrease Mario's Status

DATA_03E403:        .db $13,$78,$13,$BE,$14,$F2,$14,$1C
                    .db $16,$78,$13,$BE,$14,$F2,$14,$1C
                    .db $16,$78,$13,$BE,$14,$F2,$14,$1C
                    .db $16,$9E,$13,$AE,$13,$BE,$13,$DE
                    .db $13,$CE,$13,$EE,$13,$FE,$13,$0E
                    .db $14,$1E,$14,$2E,$14,$3E,$14,$4E
                    .db $14,$5E,$14,$6E,$14,$7E,$14,$8E
                    .db $14,$9E,$14,$AE,$14,$00,$00,$94
                    .db $21,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$97
                    .db $21,$BB,$21,$51,$22,$F7,$21,$33
                    .db $22,$15,$22,$D9,$21,$73,$22,$92
                    .db $22,$B4,$23,$E2,$23,$00,$00,$00
                    .db $00,$00,$00,$CC,$23,$0F,$24,$C9
                    .db $22,$B4,$23,$E2,$23,$00,$23,$00
                    .db $00,$1A,$23,$CC,$23,$0F,$24,$44
                    .db $24,$6B,$24,$AF,$24,$00,$00,$00
                    .db $00,$00,$00,$8E,$24,$DF,$24,$35
                    .db $25,$6E,$25,$B2,$25,$5C,$25,$00
                    .db $00,$0F,$25,$91,$25,$E2,$25,$12
                    .db $26,$8D,$26,$B1,$26,$61,$26,$00
                    .db $00,$3A,$26,$A0,$26,$E1,$26,$11
                    .db $27,$7E,$27,$A8,$27,$54,$27,$00
                    .db $00,$33,$27,$94,$27,$0F,$24,$D1
                    .db $22,$B4,$23,$E2,$23,$00,$23,$7E
                    .db $23,$50,$23,$CC,$23,$0F,$24,$14
                    .db $28,$54,$28,$80,$28,$4C,$28,$2C
                    .db $28,$FD,$27,$6B,$28,$A4,$28,$C8
                    .db $28,$E7,$28,$7D,$29,$23,$29,$5F
                    .db $29,$41,$29,$05,$29,$9F,$29,$D1
                    .db $22,$BE,$29,$E2,$23,$00,$23,$7E
                    .db $23,$50,$23,$CC,$23,$0F,$24,$14
                    .db $28,$F5,$29,$0D,$2A,$4C,$28,$2C
                    .db $28,$FD,$27,$6B,$28,$A4,$28,$47
                    .db $2A,$66,$2A,$00,$2B,$A2,$2A,$E0
                    .db $2A,$C0,$2A,$84,$2A,$24,$2B,$79
                    .db $2B,$43,$2B,$E2,$23,$00,$23,$E2
                    .db $2B,$AE,$2B,$CC,$23,$0F,$24,$47
                    .db $2C,$18,$2C,$0D,$2A,$4C,$28,$5F
                    .db $2C,$30,$2C,$6B,$28,$A4,$28,$25
                    .db $2A,$66,$2A,$00,$2B,$A2,$2A,$E0
                    .db $2A,$C0,$2A,$84,$2A,$24,$2B,$7F
                    .db $2C,$98,$2C,$0C,$2D,$C8,$2C,$F6
                    .db $2C,$E0,$2C,$B0,$2C,$00,$00,$C2
                    .db $14,$00,$00,$76,$1E,$C5,$1E,$F0
                    .db $1E,$A2,$1E,$03,$1F,$2A,$1F,$49
                    .db $1F,$68,$1F,$A4,$1F,$0A,$20,$4C
                    .db $20,$E9,$1F,$C8,$1F,$83,$1F,$2C
                    .db $20,$7B,$20,$A6,$20,$C8,$20,$5A
                    .db $21,$04,$21,$3E,$21,$22,$21,$E6
                    .db $20,$7A,$21,$D2,$14,$E2,$14,$2C
                    .db $15,$4C,$15,$3C,$15,$5C,$15,$6C
                    .db $15,$7C,$15,$8C,$15,$9C,$15,$AC
                    .db $15,$CC,$15,$BC,$15,$DC,$15,$EC
                    .db $15,$AE,$13,$4E,$14,$5E,$14,$6E
                    .db $14,$7E,$14,$8E,$14,$6E,$14,$FC
                    .db $15,$6E,$14,$7E,$14,$8E,$14,$9E
                    .db $14,$0C,$16,$00,$00,$3D,$16,$93
                    .db $17,$BD,$17,$1B,$17,$57,$17,$99
                    .db $16,$00,$00,$E7,$17,$3D,$16,$93
                    .db $17,$BD,$17,$1B,$17,$57,$17,$DE
                    .db $16,$00,$00,$E7,$17,$00,$18,$EF
                    .db $18,$10,$19,$89,$18,$BC,$18,$55
                    .db $18,$00,$00,$E7,$17,$31,$19,$E4
                    .db $19,$05,$1A,$8A,$19,$B7,$19,$5F
                    .db $19,$00,$00,$E7,$17,$C8,$1A,$AB
                    .db $1B,$CC,$1B,$3F,$1B,$77,$1B,$91
                    .db $1B,$00,$00,$E7,$17,$ED,$1B,$6E
                    .db $1C,$8F,$1C,$1B,$1C,$48,$1C,$5B
                    .db $1C,$00,$00,$E7,$17,$C8,$1A,$AB
                    .db $1B,$CC,$1B,$3F,$1B,$77,$1B,$91
                    .db $1B,$01,$1B,$E7,$17,$B0,$1C,$70
                    .db $1D,$90,$1D,$19,$1D,$4A,$1D,$5D
                    .db $1D,$E2,$1C,$AE,$1D,$3D,$16,$93
                    .db $17,$BD,$17,$1B,$17,$57,$17,$99
                    .db $16,$7C,$16,$E7,$17,$3D,$16,$93
                    .db $17,$BD,$17,$1B,$17,$57,$17,$DE
                    .db $16,$7C,$16,$E7,$17,$00,$18,$EF
                    .db $18,$10,$19,$89,$18,$BC,$18,$55
                    .db $18,$34,$18,$E7,$17,$26,$1A,$A6
                    .db $1A,$B7,$1A,$4E,$1A,$67,$1A,$80
                    .db $1A,$40,$1A,$E7,$17,$32,$16,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$3A,$16,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$C1,$1D,$D4
                    .db $1D,$58,$1E,$F8,$1D,$3E,$1E,$0A
                    .db $1E,$E6,$1D,$24,$1E,$2C,$15,$4C
                    .db $15,$2C,$15,$5C,$15,$6C,$15,$7C
                    .db $15,$6C,$15,$9C,$15,$FF,$00,$1C
                    .db $16,$00,$00,$DA,$04,$E2,$16,$E3
                    .db $90,$1B,$00,$E4,$01,$00,$DA,$12
                    .db $E2,$1E,$DB,$0A,$DE,$14,$19,$27
                    .db $0C,$6D,$B4,$0C,$2E,$B7,$B9,$30
                    .db $6E,$B7,$0C,$2D,$B9,$0C,$6E,$BB
                    .db $C6,$0C,$2D,$BB,$30,$6E,$B9,$0C
                    .db $2D,$B3,$0C,$6E,$B4,$0C,$2D,$B7
                    .db $B9,$30,$6E,$B7,$0C,$2D,$B8,$0C
                    .db $6E,$B9,$C6,$0C,$2D,$B9,$30,$6E
                    .db $B7,$0C,$2D,$B8,$00,$DA,$12,$DB
                    .db $0F,$DE,$14,$14,$20,$48,$6D,$B7
                    .db $18,$B9,$48,$B7,$0C,$B4,$B5,$30
                    .db $B7,$0C,$C6,$B9,$B7,$B9,$48,$B7
                    .db $18,$B4,$DA,$00,$DB,$05,$DE,$14
                    .db $19,$27,$30,$6B,$C7,$0C,$C7,$B7
                    .db $0C,$2C,$B9,$BC,$06,$7B,$BB,$BC
                    .db $0C,$69,$BB,$18,$C6,$0C,$C7,$B3
                    .db $0C,$2C,$B7,$BB,$06,$7B,$B9,$BB
                    .db $0C,$69,$B9,$18,$C6,$0C,$C7,$B2
                    .db $0C,$2C,$B4,$B9,$06,$7B,$B7,$B9
                    .db $0C,$69,$B7,$18,$C6,$0C,$C7,$06
                    .db $4B,$AD,$AF,$B0,$B2,$B4,$B5,$30
                    .db $6B,$B4,$0C,$C7,$B7,$0C,$2C,$B9
                    .db $BC,$06,$7B,$BB,$BC,$0C,$69,$BB
                    .db $18,$C6,$0C,$C7,$B3,$0C,$2C,$B7
                    .db $BB,$06,$7B,$B9,$BB,$0C,$69,$B9
                    .db $18,$C6,$0C,$C7,$B2,$0C,$2C,$B4
                    .db $B9,$06,$7B,$B7,$B9,$0C,$69,$B7
                    .db $18,$C6,$0C,$C7,$06,$4B,$AD,$AF
                    .db $B0,$B2,$B4,$B5,$DA,$12,$DB,$08
                    .db $DE,$14,$1F,$25,$0C,$6D,$B0,$0C
                    .db $2E,$B4,$B4,$30,$6E,$B4,$0C,$2D
                    .db $B4,$0C,$6E,$B7,$C6,$0C,$2D,$B7
                    .db $30,$6E,$B3,$0C,$2D,$AF,$0C,$6E
                    .db $AE,$0C,$2D,$B2,$B2,$30,$6E,$B2
                    .db $0C,$2D,$B2,$0C,$6E,$B4,$C6,$0C
                    .db $2D,$B4,$30,$6E,$B4,$0C,$2D,$B4
                    .db $DA,$12,$DB,$0C,$DE,$14,$1B,$26
                    .db $0C,$6D,$AB,$0C,$2E,$B0,$B0,$30
                    .db $6E,$B0,$0C,$2D,$B0,$0C,$6E,$B3
                    .db $C6,$0C,$2D,$B3,$30,$6E,$AF,$0C
                    .db $2D,$AB,$0C,$6E,$AB,$0C,$2E,$AE
                    .db $AE,$30,$6E,$AE,$0C,$2D,$AE,$0C
                    .db $6E,$B1,$C6,$0C,$2D,$B1,$30,$6E
                    .db $B1,$0C,$2D,$B1,$DA,$04,$DB,$08
                    .db $DE,$14,$19,$28,$0C,$3B,$C7,$9C
                    .db $C7,$9C,$C7,$9C,$C7,$9C,$C7,$9B
                    .db $C7,$9B,$C7,$9B,$C7,$9B,$C7,$9A
                    .db $C7,$9A,$C7,$9A,$C7,$9A,$C7,$99
                    .db $C7,$99,$C7,$99,$C7,$99,$DA,$08
                    .db $DB,$0C,$DE,$14,$19,$28,$0C,$6E
                    .db $98,$9F,$93,$9F,$98,$9F,$93,$9F
                    .db $97,$9F,$93,$9F,$97,$9F,$93,$9F
                    .db $96,$9F,$93,$9F,$96,$9F,$93,$9F
                    .db $95,$9C,$90,$9C,$95,$9C,$90,$9C
                    .db $DA,$05,$DB,$14,$DE,$00,$00,$00
                    .db $E9,$F3,$17,$08,$0C,$4B,$D1,$0C
                    .db $4C,$D2,$0C,$49,$D1,$0C,$4B,$D2
                    .db $00,$0C,$6E,$B9,$0C,$2D,$BB,$BC
                    .db $30,$6E,$B9,$0C,$2D,$B8,$0C,$6E
                    .db $B7,$0C,$2D,$B8,$B9,$30,$6E,$B4
                    .db $0C,$C7,$12,$6E,$B4,$06,$6D,$B3
                    .db $0C,$2C,$B2,$12,$6E,$B4,$06,$6D
                    .db $B3,$0C,$2C,$B2,$0C,$2E,$B4,$B2
                    .db $30,$4E,$B7,$C6,$00,$30,$6D,$B0
                    .db $0C,$C6,$AF,$C6,$AD,$AB,$AC,$AD
                    .db $B4,$30,$C6,$24,$B4,$18,$B0,$0C
                    .db $AF,$B0,$B1,$30,$B2,$06,$C7,$AB
                    .db $AD,$AF,$B0,$B2,$B4,$B5,$06,$7B
                    .db $B4,$B5,$0C,$69,$B4,$18,$C6,$0C
                    .db $C7,$06,$4B,$AF,$B0,$B2,$B4,$B5
                    .db $B6,$06,$7B,$B7,$B9,$0C,$69,$B7
                    .db $18,$C6,$0C,$C7,$06,$4B,$B2,$B4
                    .db $B5,$B7,$B9,$BB,$30,$BC,$C6,$BB
                    .db $0C,$C7,$06,$4B,$BB,$BC,$BB,$B9
                    .db $B7,$B5,$0C,$6E,$B5,$0C,$2D,$B5
                    .db $B9,$30,$6E,$B6,$0C,$2D,$B6,$0C
                    .db $6E,$B4,$0C,$2D,$B4,$B4,$30,$6E
                    .db $B1,$0C,$C7,$12,$6E,$AD,$06,$6D
                    .db $AD,$0C,$2C,$AD,$12,$6E,$AD,$06
                    .db $6D,$AD,$0C,$2C,$AD,$0C,$2E,$AD
                    .db $AD,$30,$4E,$B2,$C6,$0C,$6E,$B0
                    .db $0C,$2D,$B0,$B5,$30,$6E,$B0,$0C
                    .db $2D,$B0,$0C,$6E,$B0,$0C,$2D,$B0
                    .db $B0,$30,$6E,$AB,$0C,$C7,$12,$6E
                    .db $A9,$06,$6D,$A9,$0C,$2C,$A9,$12
                    .db $6E,$A9,$06,$6D,$A9,$0C,$2C,$A9
                    .db $0C,$2E,$A9,$A9,$30,$4E,$AF,$C6
                    .db $0C,$C7,$9D,$C7,$9D,$C7,$9E,$C7
                    .db $9E,$C7,$9C,$C7,$9C,$C7,$99,$C7
                    .db $99,$C7,$9A,$C7,$9A,$C7,$9A,$C7
                    .db $9A,$C7,$97,$C7,$97,$C7,$97,$C7
                    .db $97,$0C,$91,$A1,$98,$A1,$92,$A1
                    .db $98,$A1,$93,$9F,$98,$9F,$95,$9F
                    .db $90,$9F,$8E,$9D,$95,$9D,$8E,$9D
                    .db $90,$91,$93,$9D,$8E,$9D,$93,$9D
                    .db $8E,$9D,$0C,$6E,$B9,$0C,$2D,$BB
                    .db $BC,$30,$6E,$B9,$0C,$2D,$B8,$0C
                    .db $6E,$B7,$0C,$2D,$B8,$B9,$30,$6E
                    .db $C0,$0C,$C7,$0C,$6E,$C0,$0C,$2D
                    .db $BF,$C0,$18,$6E,$BC,$0C,$2E,$BC
                    .db $18,$6E,$B9,$30,$4E,$BC,$C6,$00
                    .db $06,$7B,$B4,$B5,$0C,$69,$B4,$18
                    .db $C6,$0C,$C7,$06,$4B,$AF,$B0,$B2
                    .db $B4,$B5,$B6,$06,$7B,$B7,$B9,$0C
                    .db $69,$B7,$18,$C6,$0C,$C7,$06,$4B
                    .db $B2,$B4,$B5,$B7,$B9,$BB,$30,$BC
                    .db $BB,$60,$BC,$0C,$6E,$B5,$0C,$2D
                    .db $B5,$B9,$30,$6E,$B6,$0C,$2D,$B6
                    .db $0C,$6E,$B4,$0C,$2D,$B4,$B4,$30
                    .db $6E,$BD,$0C,$C7,$0C,$6E,$B9,$0C
                    .db $2D,$B9,$B9,$18,$6E,$B9,$0C,$2E
                    .db $B5,$18,$6E,$B5,$30,$4E,$B7,$C6
                    .db $0C,$6E,$B0,$0C,$2D,$B0,$B5,$30
                    .db $6E,$B0,$0C,$2D,$B0,$0C,$6E,$B0
                    .db $0C,$2D,$B0,$B0,$30,$6E,$B7,$0C
                    .db $C7,$0C,$6E,$B5,$0C,$2D,$B5,$B5
                    .db $18,$6E,$B5,$0C,$2E,$B2,$18,$6E
                    .db $B2,$30,$4E,$B4,$C6,$0C,$C7,$98
                    .db $C7,$98,$C7,$98,$C7,$98,$C7,$9C
                    .db $C7,$9C,$C7,$99,$C7,$99,$C7,$95
                    .db $C7,$95,$C7,$97,$C7,$97,$C7,$9C
                    .db $C7,$9C,$C7,$9C,$C7,$9C,$0C,$91
                    .db $9D,$98,$9D,$92,$9E,$98,$9E,$93
                    .db $9F,$9A,$9F,$95,$A1,$9C,$A1,$8E
                    .db $9A,$95,$9A,$93,$9F,$9A,$9F,$98
                    .db $9F,$93,$9F,$98,$98,$97,$96,$0C
                    .db $6E,$B9,$0C,$2D,$BB,$BC,$30,$6E
                    .db $B9,$0C,$2D,$B8,$0C,$6E,$B7,$0C
                    .db $2D,$B8,$B9,$30,$6E,$C0,$0C,$C7
                    .db $00,$30,$6D,$B0,$0C,$C6,$AF,$C6
                    .db $AD,$AB,$AC,$AD,$B4,$30,$C6,$0C
                    .db $6E,$B5,$0C,$2D,$B5,$B9,$30,$6E
                    .db $B6,$0C,$2D,$B6,$0C,$6E,$B4,$0C
                    .db $2D,$B4,$B4,$30,$6E,$BD,$0C,$C7
                    .db $0C,$6E,$B0,$0C,$2D,$B0,$B5,$30
                    .db $6E,$B0,$0C,$2D,$B0,$0C,$6E,$B0
                    .db $0C,$2D,$B0,$B0,$30,$6E,$B7,$0C
                    .db $C7,$06,$7B,$B4,$B5,$0C,$69,$B4
                    .db $18,$C6,$0C,$C7,$06,$4B,$AF,$B0
                    .db $B2,$B4,$B5,$B6,$06,$7B,$B7,$B9
                    .db $0C,$69,$B7,$18,$C6,$0C,$C7,$06
                    .db $4B,$B2,$B4,$B5,$B7,$B9,$BB,$0C
                    .db $C7,$98,$C7,$98,$C7,$98,$C7,$98
                    .db $C7,$9C,$C7,$9C,$C7,$99,$C7,$99
                    .db $0C,$91,$9D,$98,$9D,$92,$9E,$98
                    .db $9E,$93,$9F,$9A,$9F,$95,$A1,$9C
                    .db $A1,$DA,$12,$18,$6D,$AD,$0C,$B4
                    .db $C7,$C7,$0C,$2D,$B4,$0C,$6E,$B3
                    .db $0C,$2D,$B4,$0C,$6E,$B5,$0C,$2D
                    .db $B4,$B1,$30,$6E,$AD,$0C,$2D,$AD
                    .db $0C,$6E,$B4,$0C,$2D,$B2,$0C,$6D
                    .db $B4,$0C,$2D,$B2,$0C,$6E,$B4,$0C
                    .db $2D,$B2,$C7,$0C,$6D,$AD,$30,$C6
                    .db $C7,$00,$DB,$0F,$DE,$14,$14,$20
                    .db $DA,$12,$18,$6D,$B9,$0C,$C0,$C7
                    .db $C7,$0C,$2D,$C0,$0C,$6E,$BF,$0C
                    .db $2D,$C0,$0C,$6E,$C1,$0C,$2D,$C0
                    .db $BD,$30,$6E,$B9,$0C,$2D,$B9,$0C
                    .db $6E,$C0,$0C,$2D,$BE,$0C,$6D,$C0
                    .db $0C,$2D,$BE,$0C,$6E,$C0,$0C,$2D
                    .db $BE,$C7,$0C,$6D,$B9,$30,$C6,$C7
                    .db $DA,$12,$18,$6D,$A8,$0C,$AB,$C7
                    .db $C7,$0C,$2D,$AB,$0C,$6E,$AA,$0C
                    .db $2D,$AB,$0C,$6E,$AD,$0C,$2D,$AB
                    .db $A8,$30,$6E,$A5,$0C,$2D,$A5,$0C
                    .db $6E,$AB,$0C,$2D,$AA,$0C,$6D,$AB
                    .db $0C,$2D,$AA,$0C,$6E,$AB,$0C,$2D
                    .db $AA,$C7,$0C,$6D,$A4,$30,$C6,$C7
                    .db $DB,$05,$DE,$19,$19,$35,$DA,$00
                    .db $30,$6B,$A8,$0C,$C6,$A7,$A8,$AD
                    .db $48,$B4,$0C,$B3,$B4,$30,$B9,$B4
                    .db $60,$B2,$DB,$08,$DE,$19,$18,$34
                    .db $DA,$00,$30,$6B,$9F,$0C,$C6,$9E
                    .db $9F,$A5,$48,$AB,$0C,$AA,$AB,$30
                    .db $B4,$AB,$60,$AA,$0C,$C7,$99,$C7
                    .db $99,$C7,$99,$C7,$99,$C7,$99,$C7
                    .db $99,$C7,$99,$C7,$99,$C7,$98,$C7
                    .db $98,$C7,$98,$C7,$98,$C7,$98,$C7
                    .db $98,$C7,$98,$C7,$98,$0C,$95,$9F
                    .db $90,$9F,$95,$9F,$90,$9F,$95,$9F
                    .db $90,$9F,$95,$9F,$90,$8F,$8E,$9E
                    .db $95,$9E,$8E,$9E,$95,$9E,$8E,$9E
                    .db $95,$9E,$8E,$9E,$90,$92,$18,$6D
                    .db $AB,$0C,$B2,$C7,$C7,$0C,$2D,$B2
                    .db $0C,$6E,$B1,$0C,$2D,$B2,$0C,$6E
                    .db $B4,$0C,$2D,$B2,$AF,$30,$6E,$AB
                    .db $0C,$2D,$B2,$18,$4E,$B0,$B0,$10
                    .db $6D,$B0,$10,$6E,$B2,$10,$6E,$B3
                    .db $30,$B4,$C7,$00,$18,$6D,$A3,$0C
                    .db $A9,$C7,$C7,$0C,$2D,$A9,$0C,$6E
                    .db $A8,$0C,$2D,$A9,$0C,$6E,$AB,$0C
                    .db $2D,$A9,$A6,$30,$6E,$A3,$0C,$2D
                    .db $A9,$18,$4E,$A8,$A8,$10,$6D,$A8
                    .db $10,$6E,$A9,$10,$6E,$AA,$30,$AC
                    .db $C7,$30,$69,$AB,$0C,$C6,$A9,$AB
                    .db $AF,$48,$B2,$0C,$B0,$B2,$48,$B0
                    .db $18,$B2,$60,$B4,$30,$69,$A3,$0C
                    .db $C6,$A3,$A6,$A9,$48,$AB,$0C,$A9
                    .db $AB,$48,$A8,$18,$AB,$60,$AC,$0C
                    .db $C7,$97,$C7,$97,$C7,$97,$C7,$97
                    .db $C7,$97,$C7,$97,$C7,$97,$C7,$97
                    .db $C7,$9C,$C7,$9C,$C7,$9C,$C7,$9C
                    .db $C7,$97,$C7,$97,$C7,$97,$C7,$97
                    .db $0C,$93,$9D,$8E,$9D,$93,$9D,$8E
                    .db $9D,$93,$9D,$8E,$9D,$93,$9D,$95
                    .db $97,$98,$9F,$93,$9F,$98,$9F,$93
                    .db $9F,$90,$A0,$97,$A0,$90,$A0,$92
                    .db $94,$18,$6D,$AB,$0C,$B2,$C7,$C7
                    .db $0C,$2D,$B2,$0C,$6E,$B1,$0C,$2D
                    .db $B2,$0C,$6E,$B4,$0C,$2D,$B2,$C7
                    .db $30,$6E,$AB,$0C,$2D,$B2,$18,$4E
                    .db $B0,$B0,$10,$6D,$B0,$10,$6E,$B2
                    .db $10,$6E,$B3,$18,$2E,$B4,$C7,$30
                    .db $4E,$B7,$00,$18,$6D,$B7,$0C,$BE
                    .db $C7,$C7,$0C,$2D,$BE,$0C,$6E,$BD
                    .db $0C,$2D,$BE,$0C,$6E,$C0,$0C,$2D
                    .db $BE,$C7,$30,$6E,$B7,$0C,$2D,$BE
                    .db $18,$4E,$BC,$BC,$10,$6D,$BC,$10
                    .db $6E,$BE,$10,$6E,$BF,$18,$2E,$C0
                    .db $C7,$06,$C7,$AB,$AD,$AF,$B0,$B2
                    .db $B4,$B5,$18,$6D,$A3,$0C,$A9,$C7
                    .db $C7,$0C,$2D,$A9,$0C,$6E,$A8,$0C
                    .db $2D,$A9,$0C,$6E,$AB,$0C,$2D,$A9
                    .db $C7,$30,$6E,$A3,$0C,$2D,$A9,$18
                    .db $4E,$A8,$A8,$10,$6D,$A8,$10,$6E
                    .db $A9,$10,$6E,$AA,$18,$2E,$AB,$C7
                    .db $30,$4E,$AF,$30,$69,$AB,$0C,$C6
                    .db $A9,$AB,$AF,$48,$B2,$0C,$B0,$B2
                    .db $30,$B0,$B2,$30,$B4,$B3,$30,$69
                    .db $A3,$0C,$C6,$A3,$A6,$A9,$48,$AB
                    .db $0C,$A9,$AB,$30,$A8,$AB,$30,$AB
                    .db $AF,$0C,$C7,$97,$C7,$97,$C7,$97
                    .db $C7,$97,$C7,$97,$C7,$97,$C7,$97
                    .db $C7,$97,$C7,$9C,$C7,$9C,$C7,$9C
                    .db $C7,$9C,$DA,$01,$18,$AF,$C7,$A7
                    .db $C6,$0C,$93,$9D,$8E,$9D,$93,$9D
                    .db $8E,$9D,$93,$9D,$8E,$9D,$93,$9D
                    .db $95,$97,$98,$9F,$93,$9F,$98,$9F
                    .db $93,$9F,$18,$8C,$C7,$93,$C6,$DA
                    .db $05,$DB,$14,$DE,$00,$00,$00,$E9
                    .db $F3,$17,$06,$18,$4C,$D1,$C7,$30
                    .db $6D,$D2,$DA,$04,$DB,$0A,$DE,$22
                    .db $19,$38,$60,$5E,$BC,$C6,$DA,$01
                    .db $60,$C6,$C6,$C6,$00,$DA,$04,$DB
                    .db $08,$DE,$20,$18,$36,$60,$5D,$B4
                    .db $C6,$DA,$01,$60,$C6,$C6,$C6,$DA
                    .db $04,$DB,$0C,$DE,$21,$1A,$37,$60
                    .db $5D,$AB,$C6,$DA,$01,$60,$C6,$C6
                    .db $C6,$DA,$04,$DB,$0A,$DE,$22,$18
                    .db $36,$60,$5D,$A4,$C6,$DA,$01,$60
                    .db $C6,$C6,$C6,$DA,$04,$DB,$0F,$10
                    .db $5D,$B0,$C7,$B0,$AE,$C7,$AE,$AD
                    .db $C7,$AD,$AC,$C7,$AC,$30,$AB,$24
                    .db $A7,$6C,$A6,$60,$C6,$DA,$04,$DB
                    .db $0F,$10,$5D,$AB,$C7,$AB,$A8,$C7
                    .db $A8,$A9,$C7,$A9,$A9,$C7,$A9,$30
                    .db $A6,$24,$A3,$6C,$A2,$60,$C6,$DA
                    .db $04,$DB,$0F,$10,$5D,$A8,$C7,$A8
                    .db $A4,$C7,$A4,$A4,$C7,$A4,$A4,$C7
                    .db $A4,$30,$A3,$24,$9D,$6C,$9C,$60
                    .db $C6,$DA,$08,$DB,$0A,$DE,$22,$19
                    .db $38,$10,$5D,$8C,$8C,$8C,$90,$90
                    .db $90,$91,$91,$91,$92,$92,$92,$30
                    .db $93,$24,$93,$6C,$8C,$60,$C6,$DA
                    .db $01,$E2,$12,$DB,$0A,$DE,$14,$19
                    .db $28,$18,$7C,$A7,$0C,$A8,$AB,$AD
                    .db $30,$AB,$0C,$AD,$AF,$C6,$AF,$30
                    .db $AD,$0C,$A7,$A8,$AB,$AD,$30,$AB
                    .db $0C,$AC,$AD,$C6,$AD,$60,$AB,$60
                    .db $77,$C6,$00,$DA,$02,$DB,$0A,$18
                    .db $79,$A7,$0C,$A8,$AB,$AD,$30,$AB
                    .db $0C,$AD,$AF,$C6,$AF,$30,$AD,$0C
                    .db $A7,$A8,$AB,$AD,$30,$AB,$0C,$AC
                    .db $AD,$C6,$AD,$60,$AB,$C6,$DA,$01
                    .db $DB,$0C,$DE,$14,$19,$28,$06,$C6
                    .db $18,$79,$A7,$0C,$A8,$AB,$AD,$30
                    .db $AB,$0C,$AD,$AF,$C6,$AF,$30,$AD
                    .db $0C,$A7,$A8,$AB,$AD,$30,$AB,$0C
                    .db $AC,$AD,$C6,$AD,$60,$AB,$60,$75
                    .db $C6,$DA,$01,$DB,$0A,$DE,$14,$19
                    .db $28,$18,$7B,$C7,$60,$98,$97,$96
                    .db $95,$C6,$C6,$C6,$DA,$01,$DB,$0A
                    .db $DE,$14,$19,$28,$18,$7B,$C7,$0C
                    .db $C7,$24,$9F,$30,$B0,$0C,$C7,$24
                    .db $9F,$30,$AF,$0C,$C7,$24,$9F,$30
                    .db $AE,$0C,$C7,$24,$9F,$30,$B1,$60
                    .db $C6,$C6,$C6,$DA,$01,$DB,$0A,$DE
                    .db $14,$19,$28,$18,$7B,$C7,$18,$C7
                    .db $48,$A8,$18,$C7,$48,$A7,$18,$C7
                    .db $48,$A6,$18,$C7,$48,$A5,$60,$C6
                    .db $C6,$C6,$DA,$01,$DB,$0A,$DE,$14
                    .db $19,$28,$18,$7B,$C7,$24,$C7,$3C
                    .db $AB,$24,$C7,$3C,$AB,$24,$C7,$3C
                    .db $AB,$24,$C7,$3C,$AB,$60,$C6,$C6
                    .db $C6,$DA,$01,$DB,$0A,$DE,$14,$19
                    .db $28,$18,$7B,$C7,$30,$C7,$B4,$30
                    .db $C7,$B3,$30,$C7,$B2,$30,$C7,$B4
                    .db $60,$C6,$C6,$C6,$DA,$04,$DB,$08
                    .db $DE,$22,$18,$14,$08,$5C,$C7,$A9
                    .db $C7,$A9,$AD,$C7,$24,$AA,$0C,$C7
                    .db $08,$A9,$A8,$C7,$A8,$A8,$C7,$24
                    .db $AB,$0C,$C7,$08,$C7,$E2,$1C,$DA
                    .db $04,$DB,$0A,$DE,$22,$18,$14,$08
                    .db $5D,$AC,$AD,$C7,$AF,$B0,$C7,$24
                    .db $AD,$0C,$C7,$08,$AC,$AB,$C7,$AC
                    .db $AD,$C7,$24,$B4,$0C,$C7,$08,$C7
                    .db $00,$DA,$04,$DB,$0C,$DE,$22,$18
                    .db $14,$08,$5C,$C7,$A4,$C7,$A4,$A9
                    .db $C7,$24,$A4,$0C,$C7,$08,$A4,$A4
                    .db $C7,$A4,$A4,$C7,$24,$A5,$0C,$C7
                    .db $08,$C7,$DA,$06,$DB,$0A,$DE,$22
                    .db $18,$14,$08,$5D,$B8,$B9,$C7,$BB
                    .db $BC,$C7,$24,$B9,$0C,$C7,$08,$B8
                    .db $B7,$C7,$B8,$B9,$C7,$24,$C0,$0C
                    .db $C7,$08,$C7,$DA,$0D,$DB,$0F,$DE
                    .db $22,$18,$14,$01,$C7,$08,$C7,$18
                    .db $4E,$C7,$9D,$C7,$9E,$C7,$9F,$C7
                    .db $9F,$18,$9E,$08,$C7,$C7,$9D,$18
                    .db $C6,$08,$C7,$C7,$AB,$DA,$0D,$DB
                    .db $0F,$DE,$22,$18,$14,$08,$C7,$18
                    .db $4E,$C7,$98,$C7,$98,$C7,$9A,$C7
                    .db $99,$18,$A1,$08,$C7,$C7,$A3,$18
                    .db $C6,$08,$C7,$C7,$A4,$DA,$08,$DB
                    .db $0A,$DE,$22,$18,$14,$08,$C7,$18
                    .db $5F,$91,$08,$C7,$C7,$91,$18,$92
                    .db $08,$C7,$C7,$92,$18,$93,$08,$C7
                    .db $C7,$93,$18,$95,$08,$95,$90,$8F
                    .db $18,$8E,$08,$C6,$C7,$93,$18,$C6
                    .db $08,$C7,$C7,$98,$DA,$04,$DB,$14
                    .db $08,$C7,$18,$6C,$D1,$08,$D2,$C7
                    .db $D1,$18,$D1,$08,$D2,$C7,$D1,$18
                    .db $D1,$08,$D2,$C7,$D1,$D1,$C7,$D1
                    .db $D2,$D1,$D1,$18,$D2,$08,$C6,$C7
                    .db $D2,$18,$C6,$08,$C7,$C7,$D2,$DA
                    .db $04,$DB,$0A,$DE,$22,$19,$38,$18
                    .db $4D,$B4,$08,$C7,$C7,$B4,$E3,$60
                    .db $18,$18,$B4,$08,$C7,$C7,$B7,$18
                    .db $B7,$08,$C7,$C7,$B7,$18,$B7,$C7
                    .db $00,$DA,$04,$DB,$08,$DE,$20,$18
                    .db $36,$18,$4D,$A4,$08,$C7,$C7,$A4
                    .db $18,$A4,$08,$C7,$C7,$A7,$18,$A7
                    .db $08,$C7,$C7,$A7,$18,$A7,$C7,$DA
                    .db $04,$DB,$0C,$DE,$21,$1A,$37,$18
                    .db $4D,$AD,$08,$C7,$C7,$AD,$18,$AD
                    .db $08,$C7,$C7,$AF,$18,$AF,$08,$C7
                    .db $C7,$AF,$18,$AF,$C7,$DA,$04,$DB
                    .db $0A,$DE,$22,$18,$36,$18,$4D,$A9
                    .db $08,$C7,$C7,$A9,$18,$A9,$08,$C7
                    .db $C7,$AB,$18,$AB,$08,$C7,$C7,$AB
                    .db $18,$AB,$C7,$DA,$04,$DB,$0F,$08
                    .db $4D,$C7,$C7,$9A,$18,$9A,$08,$C7
                    .db $C7,$9A,$18,$9A,$08,$C7,$C7,$9F
                    .db $18,$9F,$18,$C7,$18,$7D,$9F,$DA
                    .db $04,$DB,$0F,$08,$4C,$C7,$C7,$8E
                    .db $18,$8E,$08,$C7,$C7,$8E,$18,$8E
                    .db $08,$C7,$C7,$93,$18,$93,$18,$C7
                    .db $18,$7E,$93,$DA,$08,$DB,$0A,$DE
                    .db $22,$19,$38,$08,$5F,$C7,$C7,$8E
                    .db $18,$8E,$08,$C7,$C7,$8E,$18,$8E
                    .db $08,$C7,$C7,$93,$18,$93,$18,$C7
                    .db $18,$7F,$93,$DA,$00,$DB,$0A,$08
                    .db $6C,$C7,$C7,$D0,$18,$D0,$08,$C7
                    .db $C7,$D0,$18,$D0,$08,$C7,$C7,$D0
                    .db $18,$D0,$18,$C7,$D0,$24,$C7,$00
                    .db $DA,$04,$E2,$16,$E3,$90,$1C,$DB
                    .db $0A,$DE,$22,$19,$38,$18,$4C,$B4
                    .db $08,$C7,$C7,$B4,$18,$B4,$08,$C7
                    .db $C7,$B7,$18,$B7,$08,$C7,$C7,$B7
                    .db $18,$B7,$C7,$00,$DA,$04,$DB,$08
                    .db $DE,$20,$18,$36,$18,$4C,$A4,$08
                    .db $C7,$C7,$A4,$18,$A4,$08,$C7,$C7
                    .db $A7,$18,$A7,$08,$C7,$C7,$A7,$18
                    .db $A7,$C7,$DA,$04,$DB,$0C,$DE,$21
                    .db $1A,$37,$18,$4C,$AD,$08,$C7,$C7
                    .db $AD,$18,$AD,$08,$C7,$C7,$AF,$18
                    .db $AF,$08,$C7,$C7,$AF,$18,$AF,$C7
                    .db $DA,$04,$DB,$0A,$DE,$22,$18,$36
                    .db $18,$4C,$A9,$08,$C7,$C7,$A9,$18
                    .db $A9,$08,$C7,$C7,$AB,$18,$AB,$08
                    .db $C7,$C7,$AB,$18,$AB,$C7,$DA,$04
                    .db $DB,$0F,$08,$4C,$C7,$C7,$9A,$18
                    .db $9A,$08,$C7,$C7,$9A,$18,$9A,$08
                    .db $C7,$C7,$9F,$18,$9F,$08,$C7,$C7
                    .db $C7,$18,$7D,$9F,$DA,$04,$DB,$0F
                    .db $08,$4B,$C7,$C7,$8E,$18,$8E,$08
                    .db $C7,$C7,$8E,$18,$8E,$08,$C7,$C7
                    .db $93,$18,$93,$08,$C7,$C7,$C7,$18
                    .db $7E,$93,$DA,$08,$DB,$0A,$DE,$22
                    .db $19,$38,$08,$5E,$C7,$C7,$8E,$18
                    .db $8E,$08,$C7,$C7,$8E,$18,$8E,$08
                    .db $C7,$C7,$93,$18,$93,$08,$C7,$C7
                    .db $C7,$18,$7F,$93,$DA,$00,$DB,$0A
                    .db $08,$6B,$C7,$C7,$D0,$18,$D0,$08
                    .db $C7,$C7,$D0,$18,$D0,$08,$C7,$C7
                    .db $D0,$18,$D0,$C7,$08,$D0,$DB,$14
                    .db $08,$D1,$D1,$DA,$00,$DB,$0A,$DE
                    .db $22,$19,$38,$08,$5D,$A8,$C7,$AB
                    .db $AD,$C7,$24,$AB,$0C,$C7,$08,$AD
                    .db $AF,$C7,$B0,$AF,$AE,$24,$AD,$0C
                    .db $C7,$08,$A7,$A8,$C7,$AB,$AD,$C7
                    .db $24,$AB,$0C,$C7,$08,$AC,$AD,$C7
                    .db $AE,$AD,$AC,$24,$AB,$0C,$C7,$08
                    .db $AC,$00,$DA,$06,$DB,$0A,$DE,$22
                    .db $19,$38,$08,$5D,$A8,$C7,$AB,$AD
                    .db $C7,$24,$AB,$0C,$C7,$08,$AD,$AF
                    .db $C7,$B0,$AF,$AE,$24,$AD,$0C,$C7
                    .db $08,$A7,$A8,$C7,$AB,$AD,$C7,$24
                    .db $AB,$0C,$C7,$08,$AC,$AD,$C7,$AE
                    .db $AD,$AC,$24,$AB,$0C,$C7,$08,$AC
                    .db $00,$DA,$12,$DB,$05,$DE,$22,$19
                    .db $28,$60,$6B,$B4,$30,$B3,$08,$C6
                    .db $C6,$B3,$BB,$C6,$B9,$48,$B7,$18
                    .db $B2,$60,$B1,$DA,$06,$DB,$08,$DE
                    .db $14,$1F,$30,$08,$6B,$A4,$C7,$A4
                    .db $A8,$C7,$24,$A4,$0C,$C7,$08,$A8
                    .db $AB,$C7,$AB,$A7,$A7,$24,$A7,$0C
                    .db $C7,$08,$A3,$A2,$C7,$A6,$A6,$C7
                    .db $24,$A6,$0C,$C7,$08,$A6,$A8,$C7
                    .db $AB,$A8,$A8,$24,$A8,$0C,$C7,$08
                    .db $A8,$08,$6D,$A4,$C7,$A4,$A8,$C7
                    .db $24,$A4,$0C,$C7,$08,$A8,$AB,$C7
                    .db $AB,$A7,$A7,$24,$A7,$0C,$C7,$08
                    .db $A3,$A2,$C7,$A6,$A6,$C7,$24,$A6
                    .db $0C,$C7,$08,$A6,$A8,$C7,$AB,$A8
                    .db $A8,$24,$A8,$0C,$C7,$08,$A8,$DA
                    .db $06,$DB,$0C,$DE,$14,$1F,$30,$08
                    .db $6D,$9F,$C7,$A8,$A4,$C7,$24,$A8
                    .db $0C,$C7,$08,$A4,$A7,$C7,$A7,$AB
                    .db $AB,$24,$A3,$0C,$C7,$08,$9F,$9F
                    .db $C7,$A2,$A2,$C7,$24,$A2,$0C,$C7
                    .db $08,$A2,$A5,$C7,$A8,$A5,$A5,$24
                    .db $A5,$0C,$C7,$08,$A5,$DA,$0D,$DB
                    .db $0F,$01,$C7,$18,$4E,$C7,$9F,$C7
                    .db $9F,$C7,$9F,$C7,$9F,$C7,$9F,$C7
                    .db $9F,$C7,$9F,$C7,$9F,$DA,$0D,$DB
                    .db $0F,$18,$4E,$C7,$9C,$C7,$9C,$C7
                    .db $9B,$C7,$9B,$C7,$9A,$C7,$9A,$C7
                    .db $99,$C7,$99,$DA,$08,$DB,$0A,$DE
                    .db $14,$1F,$30,$18,$6F,$98,$C7,$18
                    .db $93,$08,$C7,$C7,$93,$18,$97,$C7
                    .db $18,$93,$08,$C7,$C7,$93,$18,$96
                    .db $C7,$18,$93,$08,$C7,$C7,$93,$18
                    .db $95,$C7,$18,$90,$08,$C7,$C7,$90
                    .db $DA,$00,$DB,$14,$18,$6B,$D1,$08
                    .db $D2,$C7,$D1,$18,$D1,$08,$D2,$C7
                    .db $D1,$18,$D1,$08,$D2,$C7,$D1,$D1
                    .db $C7,$D1,$D2,$D1,$D1,$18,$D1,$08
                    .db $D2,$C7,$D1,$18,$D1,$08,$D2,$C7
                    .db $D1,$18,$D1,$08,$D2,$C7,$D1,$D1
                    .db $C7,$D1,$D2,$D1,$D1,$08,$AD,$C7
                    .db $AF,$B0,$C7,$24,$AD,$0C,$C7,$08
                    .db $AC,$AB,$C7,$AC,$AD,$C7,$24,$A8
                    .db $0C,$C7,$08,$C7,$A8,$C7,$A4,$A1
                    .db $C7,$A8,$A4,$C7,$A1,$A4,$C7,$AB
                    .db $30,$C6,$C7,$00,$01,$C7,$18,$C7
                    .db $9D,$C7,$9E,$C7,$9F,$C7,$9F,$18
                    .db $9E,$08,$C7,$C7,$9E,$18,$C6,$08
                    .db $9E,$C7,$9F,$18,$C6,$08,$C7,$C7
                    .db $A3,$A4,$C7,$A4,$A6,$C7,$A6,$18
                    .db $C7,$98,$C7,$98,$C7,$9A,$C7,$99
                    .db $18,$A1,$08,$C7,$C7,$A1,$18,$C6
                    .db $08,$A1,$C7,$A3,$18,$C6,$08,$C7
                    .db $C7,$9A,$9C,$C7,$9C,$9D,$C7,$9D
                    .db $18,$91,$08,$C7,$C7,$91,$18,$92
                    .db $08,$C7,$C7,$92,$18,$93,$08,$C7
                    .db $C7,$93,$18,$95,$08,$95,$90,$8F
                    .db $18,$8E,$08,$C6,$C7,$8E,$18,$C6
                    .db $08,$8E,$C7,$93,$18,$C6,$08,$C7
                    .db $C7,$93,$95,$C7,$95,$97,$C7,$97
                    .db $18,$D1,$08,$D2,$C7,$D1,$18,$D1
                    .db $08,$D2,$C7,$D1,$18,$D1,$08,$D2
                    .db $C7,$D1,$D1,$C7,$D1,$D2,$D1,$D1
                    .db $18,$D2,$08,$C6,$C7,$D2,$18,$C6
                    .db $08,$D2,$C7,$D2,$18,$C6,$08,$C6
                    .db $C7,$D1,$D2,$C7,$D1,$D2,$D1,$D1
                    .db $08,$A9,$C7,$A9,$AD,$C7,$24,$AA
                    .db $0C,$C7,$08,$A9,$A8,$C7,$A8,$A8
                    .db $C7,$24,$AB,$0C,$C7,$08,$C7,$AD
                    .db $C7,$AD,$AD,$C7,$A9,$C7,$C7,$A9
                    .db $A9,$C7,$A8,$30,$C6,$C7,$08,$AD
                    .db $C7,$AF,$B0,$C7,$24,$AD,$0C,$C7
                    .db $08,$AC,$AB,$C7,$AC,$AD,$C7,$24
                    .db $B4,$0C,$C7,$08,$C7,$B4,$C7,$B3
                    .db $B4,$C7,$B0,$C7,$C7,$B0,$AD,$C7
                    .db $B0,$30,$C6,$C7,$00,$48,$B0,$08
                    .db $AD,$C6,$B0,$48,$B4,$08,$B3,$C6
                    .db $B4,$30,$B9,$30,$B4,$60,$B0,$01
                    .db $C7,$18,$C7,$9D,$C7,$9E,$C7,$9F
                    .db $C7,$9F,$18,$9E,$08,$C7,$C7,$9D
                    .db $18,$C6,$08,$C7,$C7,$AB,$18,$C6
                    .db $08,$B0,$C7,$B0,$AF,$C7,$AF,$AE
                    .db $C7,$AE,$18,$C7,$98,$C7,$98,$C7
                    .db $9A,$C7,$99,$18,$A1,$08,$C7,$C7
                    .db $A3,$18,$C6,$08,$C7,$C7,$A4,$18
                    .db $C6,$08,$A8,$C7,$A8,$A7,$C7,$A7
                    .db $A6,$C7,$A6,$18,$91,$08,$C7,$C7
                    .db $91,$18,$92,$08,$C7,$C7,$92,$18
                    .db $93,$08,$C7,$C7,$93,$18,$95,$08
                    .db $95,$90,$8F,$18,$8E,$08,$C6,$C7
                    .db $93,$18,$C6,$08,$C7,$C7,$98,$18
                    .db $C6,$08,$98,$C7,$98,$97,$C7,$97
                    .db $96,$C7,$96,$18,$D1,$08,$D2,$C7
                    .db $D1,$18,$D1,$08,$D2,$C7,$D1,$18
                    .db $D1,$08,$D2,$C7,$D1,$D1,$C7,$D1
                    .db $D2,$D1,$D1,$18,$D2,$08,$C6,$C7
                    .db $D2,$18,$C6,$08,$C7,$C7,$D2,$18
                    .db $C6,$08,$D2,$C7,$D1,$D2,$C7,$D1
                    .db $D2,$C7,$D1,$DA,$04,$18,$6C,$AD
                    .db $B4,$08,$B4,$C7,$B4,$B3,$C7,$B4
                    .db $B5,$C6,$B4,$B1,$C7,$24,$AD,$0C
                    .db $C7,$08,$AD,$B4,$C6,$B2,$B4,$C6
                    .db $B2,$B4,$C6,$B2,$B0,$C7,$AD,$30
                    .db $C6,$C7,$00,$DA,$04,$18,$6B,$A8
                    .db $AB,$08,$AB,$C7,$AB,$AA,$C7,$AB
                    .db $AD,$C6,$AB,$A8,$C7,$24,$A5,$0C
                    .db $C7,$08,$A5,$AB,$C6,$AA,$AB,$C6
                    .db $AA,$AB,$C6,$AA,$A8,$C7,$A4,$30
                    .db $C6,$C7,$18,$C7,$08,$AD,$C6,$AC
                    .db $AD,$C6,$B4,$C6,$C6,$AD,$AD,$C6
                    .db $AC,$AD,$C6,$B4,$C6,$C6,$AD,$AF
                    .db $C6,$B1,$18,$C7,$08,$AD,$C6,$AC
                    .db $AD,$C6,$B2,$C6,$C6,$AD,$AD,$C6
                    .db $AC,$AD,$C6,$B2,$30,$C6,$01,$C7
                    .db $18,$C7,$9F,$C7,$9F,$C7,$9F,$C7
                    .db $9F,$C7,$9E,$C7,$9E,$C7,$9E,$C7
                    .db $9E,$18,$C7,$99,$C7,$99,$C7,$99
                    .db $C7,$99,$C7,$98,$C7,$98,$C7,$98
                    .db $C7,$98,$18,$95,$08,$C7,$C7,$95
                    .db $18,$90,$08,$C7,$C7,$90,$18,$95
                    .db $08,$C7,$C7,$95,$18,$95,$08,$95
                    .db $90,$8F,$18,$8E,$08,$C7,$C7,$8E
                    .db $18,$95,$08,$C7,$C7,$95,$18,$8E
                    .db $08,$C7,$C7,$8E,$8E,$C7,$8E,$90
                    .db $C7,$92,$18,$D1,$08,$D2,$C7,$D1
                    .db $18,$D1,$08,$D2,$C7,$D1,$18,$D1
                    .db $08,$D2,$C7,$D1,$D1,$C7,$D1,$D2
                    .db $D1,$D1,$18,$D1,$08,$D2,$C7,$D1
                    .db $18,$D1,$08,$D2,$C7,$D1,$18,$D1
                    .db $08,$D2,$C7,$D1,$D2,$C7,$D1,$D2
                    .db $C7,$D1,$18,$AB,$B2,$08,$B2,$C7
                    .db $B2,$B1,$C7,$B2,$B4,$C6,$B2,$AF
                    .db $C7,$24,$AB,$0C,$C7,$08,$B2,$18
                    .db $B0,$B0,$10,$B0,$B2,$B3,$18,$B4
                    .db $C7,$AB,$C6,$00,$18,$A3,$A9,$08
                    .db $A9,$C7,$A9,$A8,$C7,$A9,$AB,$C6
                    .db $A9,$A6,$C7,$24,$A3,$0C,$C7,$08
                    .db $A9,$18,$A8,$A8,$10,$A8,$A9,$AA
                    .db $18,$AB,$C7,$A3,$C6,$18,$C7,$08
                    .db $AB,$C6,$AA,$AB,$C6,$B2,$C6,$C6
                    .db $AB,$AB,$C6,$AA,$AB,$C6,$B2,$C6
                    .db $C6,$AB,$AD,$C6,$AF,$30,$B0,$10
                    .db $B0,$AF,$AD,$AB,$06,$AD,$AF,$B0
                    .db $B2,$B3,$B4,$B5,$B6,$30,$B7,$01
                    .db $C7,$18,$C7,$9D,$C7,$9D,$C7,$9D
                    .db $C7,$9D,$C7,$9C,$10,$9C,$9D,$9E
                    .db $18,$9F,$C7,$9B,$C6,$18,$C7,$97
                    .db $C7,$97,$C7,$97,$C7,$97,$C7,$9F
                    .db $10,$9F,$A0,$A1,$18,$A3,$C7,$A3
                    .db $C6,$18,$93,$08,$C7,$C7,$93,$18
                    .db $8E,$08,$C7,$C7,$8E,$18,$93,$08
                    .db $C7,$C7,$93,$18,$93,$08,$93,$95
                    .db $97,$18,$98,$08,$C7,$C7,$98,$10
                    .db $98,$9A,$9B,$18,$9C,$C7,$93,$C6
                    .db $18,$D1,$08,$D2,$C7,$D1,$18,$D1
                    .db $08,$D2,$C7,$D1,$18,$D1,$08,$D2
                    .db $C7,$D1,$D1,$C7,$D1,$D2,$D1,$D1
                    .db $18,$D1,$08,$D2,$C7,$D1,$10,$D2
                    .db $D2,$D2,$18,$D1,$08,$D2,$C7,$D1
                    .db $D2,$C7,$D1,$D2,$D1,$D1,$08,$A9
                    .db $C7,$A9,$AD,$C7,$24,$AA,$0C,$C7
                    .db $08,$A9,$A8,$C7,$A8,$A8,$C7,$24
                    .db $AB,$0C,$C7,$08,$C7,$08,$AD,$C7
                    .db $AF,$B0,$C7,$24,$AD,$0C,$C7,$08
                    .db $AC,$AB,$C7,$AC,$AD,$C7,$24,$B4
                    .db $0C,$C7,$08,$C7,$00,$DA,$04,$DB
                    .db $0C,$DE,$22,$18,$14,$08,$5C,$A4
                    .db $C7,$A4,$A9,$C7,$24,$A4,$0C,$C7
                    .db $08,$A4,$A4,$C7,$A4,$A4,$C7,$24
                    .db $A5,$0C,$C7,$08,$C7,$48,$B0,$08
                    .db $AD,$C6,$B0,$60,$B4,$01,$C7,$18
                    .db $C7,$9D,$C7,$9E,$C7,$9F,$C7,$9F
                    .db $18,$9E,$08,$C7,$C7,$9D,$18,$C6
                    .db $08,$C7,$C7,$AB,$18,$C7,$98,$C7
                    .db $98,$C7,$9A,$C7,$99,$18,$A1,$08
                    .db $C7,$C7,$A3,$18,$C6,$08,$C7,$C7
                    .db $A4,$18,$91,$08,$C7,$C7,$91,$18
                    .db $92,$08,$C7,$C7,$92,$18,$93,$08
                    .db $C7,$C7,$93,$18,$95,$08,$95,$90
                    .db $8F,$18,$8E,$08,$C6,$C7,$93,$18
                    .db $C6,$08,$C7,$C7,$98,$18,$D1,$08
                    .db $D2,$C7,$D1,$18,$D1,$08,$D2,$C7
                    .db $D1,$18,$D1,$08,$D2,$C7,$D1,$D1
                    .db $C7,$D1,$D2,$D1,$D1,$18,$D2,$08
                    .db $C6,$C7,$D2,$18,$C6,$08,$C7,$C7
                    .db $D2,$DA,$04,$DB,$0A,$DE,$22,$19
                    .db $38,$18,$4D,$B4,$08,$C7,$C7,$B4
                    .db $18,$B4,$08,$C7,$C7,$B7,$18,$B7
                    .db $08,$C7,$C7,$B7,$18,$B7,$C7,$00
                    .db $DA,$04,$DB,$08,$DE,$20,$18,$36
                    .db $18,$4D,$A4,$08,$C7,$C7,$A4,$18
                    .db $A4,$08,$C7,$C7,$A7,$18,$A7,$08
                    .db $C7,$C7,$A7,$18,$A7,$C7,$DA,$04
                    .db $DB,$0C,$DE,$21,$1A,$37,$18,$4D
                    .db $AD,$08,$C7,$C7,$AD,$18,$AD,$08
                    .db $C7,$C7,$AF,$18,$AF,$08,$C7,$C7
                    .db $AF,$18,$AF,$C7,$DA,$04,$DB,$0A
                    .db $DE,$22,$18,$36,$18,$4D,$A9,$08
                    .db $C7,$C7,$A9,$18,$A9,$08,$C7,$C7
                    .db $AB,$18,$AB,$08,$C7,$C7,$AB,$18
                    .db $AB,$C7,$DA,$04,$DB,$0F,$08,$4D
                    .db $C7,$C7,$9A,$18,$9A,$08,$C7,$C7
                    .db $9A,$18,$9A,$08,$C7,$C7,$9F,$18
                    .db $9F,$08,$C7,$C7,$C7,$18,$7D,$9F
                    .db $DA,$04,$DB,$0F,$08,$4C,$C7,$C7
                    .db $8E,$18,$8E,$08,$C7,$C7,$8E,$18
                    .db $8E,$08,$C7,$C7,$93,$18,$93,$08
                    .db $C7,$C7,$C7,$18,$7E,$93,$DA,$08
                    .db $DB,$0A,$DE,$22,$19,$38,$08,$5F
                    .db $C7,$C7,$8E,$18,$8E,$08,$C7,$C7
                    .db $8E,$18,$8E,$08,$C7,$C7,$93,$18
                    .db $93,$08,$C7,$C7,$C7,$18,$7F,$93
                    .db $DA,$00,$DB,$0A,$08,$6C,$C7,$C7
                    .db $D0,$18,$D0,$08,$C7,$C7,$D0,$18
                    .db $D0,$08,$C7,$C7,$D0,$18,$D0,$C7
                    .db $08,$D0,$DB,$14,$08,$D1,$D1,$DA
                    .db $06,$DB,$0A,$DE,$22,$19,$38,$08
                    .db $6F,$B4,$C7,$B7,$B9,$C7,$24,$B7
                    .db $0C,$C7,$08,$B9,$BB,$C7,$BC,$BB
                    .db $BA,$24,$B9,$0C,$C7,$08,$B3,$B4
                    .db $C7,$B7,$B9,$C7,$24,$B7,$0C,$C7
                    .db $08,$B8,$B9,$C7,$BA,$B9,$B8,$24
                    .db $B7,$0C,$C7,$08,$B8,$00,$08,$B9
                    .db $C7,$BB,$BC,$C7,$24,$B9,$0C,$C7
                    .db $08,$B8,$B7,$C7,$B8,$B9,$C7,$24
                    .db $C0,$0C,$C7,$08,$C7,$00,$18,$91
                    .db $08,$C7,$C7,$91,$18,$92,$08,$C7
                    .db $C7,$92,$18,$93,$08,$C7,$C7,$93
                    .db $18,$95,$08,$C7,$C7,$95,$DA,$04
                    .db $DB,$0A,$DE,$22,$19,$38,$18,$5D
                    .db $C0,$08,$C7,$C7,$C0,$E3,$78,$18
                    .db $18,$C0,$08,$C7,$C7,$C3,$18,$C3
                    .db $08,$C7,$C7,$C3,$18,$C3,$C3,$00
                    .db $DA,$04,$DB,$0A,$DE,$22,$19,$38
                    .db $18,$5D,$C0,$08,$C7,$C7,$C0,$18
                    .db $C0,$08,$C7,$C7,$C3,$18,$C3,$08
                    .db $C7,$C7,$C3,$18,$C3,$C3,$00,$DA
                    .db $04,$DB,$08,$DE,$20,$18,$36,$18
                    .db $5D,$A4,$08,$C7,$C7,$A4,$18,$A4
                    .db $08,$C7,$C7,$A7,$18,$A7,$08,$C7
                    .db $C7,$A7,$18,$A7,$A7,$DA,$04,$DB
                    .db $0C,$DE,$21,$1A,$37,$18,$5D,$B9
                    .db $08,$C7,$C7,$B9,$18,$B9,$08,$C7
                    .db $C7,$BB,$18,$BB,$08,$C7,$C7,$BB
                    .db $18,$BB,$BB,$DA,$04,$DB,$0A,$DE
                    .db $22,$18,$36,$18,$5D,$A9,$08,$C7
                    .db $C7,$A9,$18,$A9,$08,$C7,$C7,$AB
                    .db $18,$AB,$08,$C7,$C7,$AB,$18,$AB
                    .db $AB,$DA,$04,$DB,$0F,$08,$5D,$C7
                    .db $C7,$9A,$18,$9A,$08,$C7,$C7,$9A
                    .db $18,$9A,$08,$C7,$C7,$9F,$18,$9F
                    .db $08,$C7,$C7,$9F,$08,$7D,$C7,$C7
                    .db $9F,$DA,$04,$DB,$0F,$08,$5C,$C7
                    .db $C7,$8E,$18,$8E,$08,$C7,$C7,$8E
                    .db $18,$8E,$08,$C7,$C7,$93,$18,$93
                    .db $08,$C7,$C7,$93,$08,$7E,$C7,$C7
                    .db $93,$DA,$08,$DB,$0A,$DE,$22,$19
                    .db $38,$08,$5F,$C7,$C7,$8E,$18,$8E
                    .db $08,$C7,$C7,$8E,$18,$8E,$08,$C7
                    .db $C7,$93,$18,$93,$08,$C7,$C7,$C7
                    .db $08,$7F,$C7,$C7,$93,$DA,$00,$DB
                    .db $0A,$08,$6C,$C7,$C7,$D0,$18,$D0
                    .db $08,$C7,$C7,$D0,$18,$D0,$08,$C7
                    .db $C7,$D0,$18,$D0,$C7,$08,$D0,$DB
                    .db $14,$08,$D1,$D1,$DA,$04,$DE,$14
                    .db $19,$30,$DB,$0A,$08,$4F,$B9,$C6
                    .db $B7,$B9,$C6,$24,$B7,$0C,$C6,$08
                    .db $B9,$BB,$C6,$C7,$BB,$C6,$24,$B9
                    .db $0C,$C6,$08,$C6,$B9,$C6,$B7,$B9
                    .db $C6,$24,$B7,$0C,$C6,$08,$B8,$B9
                    .db $C6,$C7,$B9,$C6,$24,$B7,$0C,$C6
                    .db $08,$B8,$DE,$16,$18,$30,$DB,$0A
                    .db $08,$4E,$AD,$C6,$AB,$AD,$C6,$24
                    .db $AB,$0C,$C6,$08,$AD,$AF,$C6,$C7
                    .db $AF,$C6,$24,$AD,$0C,$C6,$08,$C6
                    .db $AD,$C6,$AB,$AD,$C6,$24,$AB,$0C
                    .db $C7,$08,$AC,$AD,$C6,$C7,$AD,$C6
                    .db $24,$AB,$0C,$C6,$08,$AC,$00,$DE
                    .db $15,$19,$31,$DB,$08,$08,$4E,$A8
                    .db $C6,$A4,$A8,$C6,$24,$A8,$0C,$C6
                    .db $08,$A8,$AB,$C6,$C7,$AB,$C6,$24
                    .db $A7,$0C,$C6,$08,$C6,$A6,$C6,$A6
                    .db $A6,$C6,$24,$A6,$0C,$C6,$08,$A6
                    .db $A8,$C6,$C7,$A8,$C6,$24,$A8,$0C
                    .db $C6,$08,$A8,$DA,$06,$DB,$0C,$DE
                    .db $14,$1A,$30,$08,$4E,$A4,$C6,$A4
                    .db $A4,$C6,$24,$A4,$0C,$C6,$08,$A4
                    .db $A7,$C6,$C7,$A7,$C6,$24,$A3,$0C
                    .db $C6,$08,$C6,$A2,$C6,$A2,$A2,$C6
                    .db $24,$A2,$0C,$C6,$08,$A2,$A5,$C6
                    .db $C7,$A5,$C6,$24,$A5,$0C,$C6,$08
                    .db $A5,$08,$B9,$C6,$BB,$BC,$C6,$24
                    .db $B9,$0C,$C6,$08,$B8,$B7,$C6,$B8
                    .db $B9,$C6,$24,$C0,$0C,$C6,$08,$C6
                    .db $00,$08,$A9,$C6,$A9,$AD,$C6,$24
                    .db $AA,$0C,$C6,$08,$A9,$A8,$C6,$A8
                    .db $A8,$C6,$24,$AB,$0C,$C6,$08,$C6
                    .db $08,$AD,$C6,$AF,$B0,$C6,$24,$AD
                    .db $0C,$C6,$08,$AC,$AB,$C6,$AC,$AD
                    .db $C6,$24,$B4,$0C,$C6,$08,$C6,$00
                    .db $DA,$04,$DB,$0C,$DE,$22,$18,$14
                    .db $08,$5C,$A4,$C6,$A4,$A9,$C6,$24
                    .db $A4,$0C,$C6,$08,$A4,$A4,$C6,$A4
                    .db $A4,$C6,$24,$A5,$0C,$C6,$08,$C6
                    .db $DA,$04,$DB,$0A,$DE,$22,$19,$38
                    .db $60,$5E,$BC,$C6,$DA,$01,$10,$9F
                    .db $C6,$C6,$C6,$AF,$C6,$60,$C6,$C6
                    .db $00,$DA,$04,$DB,$08,$DE,$20,$18
                    .db $36,$60,$5D,$B4,$C6,$DA,$01,$10
                    .db $C7,$A3,$C6,$C6,$C6,$B3,$60,$C6
                    .db $C6,$DA,$04,$DB,$0C,$DE,$21,$1A
                    .db $37,$60,$5D,$AB,$C6,$DA,$01,$10
                    .db $C7,$C7,$A7,$C6,$C6,$C6,$60,$B7
                    .db $C6,$DA,$04,$DB,$0A,$DE,$22,$18
                    .db $36,$60,$5D,$A4,$C6,$DA,$01,$10
                    .db $C7,$C7,$C7,$AB,$C6,$C6,$60,$C6
                    .db $C6,$DA,$04,$DB,$0F,$10,$5D,$A4
                    .db $C7,$A4,$A2,$C7,$A2,$A1,$C7,$A1
                    .db $A0,$C7,$A0,$60,$9F,$9B,$C6,$DA
                    .db $0D,$DB,$0F,$10,$5D,$9C,$C7,$9C
                    .db $9C,$C7,$9C,$98,$C7,$98,$98,$C7
                    .db $98,$60,$97,$97,$C6,$DA,$08,$DB
                    .db $0A,$DE,$22,$19,$38,$10,$5D,$98
                    .db $C7,$98,$96,$C7,$96,$95,$C7,$95
                    .db $94,$C7,$94,$60,$93,$93,$C6,$00
                    .db $00,$00,$05,$E8,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00

Empty03FDE0:        .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF


