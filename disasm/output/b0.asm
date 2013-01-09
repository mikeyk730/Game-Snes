.INCLUDE "snes.cfg"
.BANK 0
ResetStart:         SEI                       ; Disable interrupts 
                    STZ.W $4200               ; Clear NMI and V/H Count, disable joypad ; NMI, V/H Count, and Joypad Enable
                    STZ.W $420C               ; Disable HDMA ; H-DMA Channel Enable
                    STZ.W $420B               ; Disable DMA ; Regular DMA Channel Enable
                    STZ.W $2140               ; \  ; APU I/O Port
                    STZ.W $2141               ;  |Clear APU I/O ports 1-4 ; APU I/O Port
                    STZ.W $2142               ;  | ; APU I/O Port
                    STZ.W $2143               ; /  ; APU I/O Port
                    LDA.B #$80                ; \ Turn off screen 
                    STA.W $2100               ; /  ; Screen Display Register
                    CLC                       ; \ Turn off emulation mode 
                    XCE                       ; /  
                    REP #$38                  ; 16 bit A,X,Y, Decimal mode off ; Index (16 bit) Accum (16 bit) 
                    LDA.W #$0000              ; \ Set direct page 
                    TCD                       ; /  
                    LDA.W #$01FF              ; \ Set stack location 
                    TCS                       ; /  
                    LDA.W #$F0A9              ; \  
                    STA.L $7F8000             ;  | 
                    LDX.W #$017D              ;  | 
                    LDY.W #$03FD              ;  | 
ADDR_008034:        LDA.W #$008D              ;  | 
                    STA.L $7F8002,X           ;  | 
                    TYA                       ;  | 
                    STA.L $7F8003,X           ;  |Create routine in RAM 
                    SEC                       ;  | 
                    SBC.W #$0004              ;  | 
                    TAY                       ;  | 
                    DEX                       ;  | 
                    DEX                       ;  | 
                    DEX                       ;  | 
                    BPL ADDR_008034           ;  | 
                    SEP #$30                  ;  | ; Index (8 bit) Accum (8 bit) 
                    LDA.B #$6B                ;  | 
                    STA.L $7F8182             ; /  
                    JSR.W ADDR_0080E8         ; SPC700 Bank 02 + Main code upload handler 
                    STZ.W $0100               ; Set game mode to 0 
                    STZ.W $0109               ; Set secondary game mode to 0 
                    JSR.W ClearStack          
                    JSR.W UploadMusicBank1    
                    JSR.W ADDR_009250         
                    LDA.B #$03                ; \ Set OAM Size and Data Area Designation to x03 
                    STA.W $2101               ; /  ; OAM Size and Data Area Designation
                    INC $10                   ; Skip the following loop 
ADDR_00806B:        LDA $10                   ;  |Loop until the interrupt routine sets $10 
                    BEQ ADDR_00806B           ; / to a non-zero value. 
                    CLI                       ; Enable interrupts 
                    INC $13                   ; Increase frame number 
                    JSR.W GetGameMode         ; The actual game 
                    STZ $10                   ; \ Wait for interrupt 
                    BRA ADDR_00806B           ; /  
SPC700UploadLoop:   PHP                       
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDY.W #$0000              
                    LDA.W #$BBAA              
ADDR_008082:        CMP.W $2140               ; APU I/O Port
                    BNE ADDR_008082           
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.B #$CC                ; Load byte to start transfer 
                    BRA ADDR_0080B3           
ADDR_00808D:        LDA [$00],Y               
                    INY                       
                    XBA                       
                    LDA.B #$00                
                    BRA ADDR_0080A0           
ADDR_008095:        XBA                       
                    LDA [$00],Y               
                    INY                       
                    XBA                       
ADDR_00809A:        CMP.W $2140               ; APU I/O Port
                    BNE ADDR_00809A           
                    INC A                     
ADDR_0080A0:        REP #$20                  ; Accum (16 bit) 
                    STA.W $2140               ; APU I/O Port
                    SEP #$20                  ; Accum (8 bit) 
                    DEX                       
                    BNE ADDR_008095           
ADDR_0080AA:        CMP.W $2140               ; APU I/O Port
                    BNE ADDR_0080AA           
ADDR_0080AF:        ADC.B #$03                
                    BEQ ADDR_0080AF           
ADDR_0080B3:        PHA                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA [$00],Y               
                    INY                       
                    INY                       
                    TAX                       
                    LDA [$00],Y               
                    INY                       
                    INY                       
                    STA.W $2142               ; APU I/O Port
                    SEP #$20                  ; Accum (8 bit) 
                    CPX.W #$0001              
                    LDA.B #$00                
                    ROL                       
                    STA.W $2141               ; APU I/O Port
                    ADC.B #$7F                
                    PLA                       
                    STA.W $2140               ; APU I/O Port
ADDR_0080D3:        CMP.W $2140               ; APU I/O Port
                    BNE ADDR_0080D3           
                    BVS ADDR_00808D           
                    STZ.W $2140               ; APU I/O Port
                    STZ.W $2141               ; APU I/O Port
                    STZ.W $2142               ; APU I/O Port
                    STZ.W $2143               ; APU I/O Port
                    PLP                       
                    RTS                       

ADDR_0080E8:        LDA.B #$00                ; \ this address (0E:8000) is the start of the OW music bank 
                    STA.W $0000               ;  |AND the code for both music banks. 
                    LDA.B #$80                ;  | 
                    STA.W $0001               ;  | 
                    LDA.B #$0E                ;  | 
                    STA.W $0002               ; /  
UploadDataToSPC:    SEI                       
                    JSR.W SPC700UploadLoop    
                    CLI                       
                    RTS                       

UploadMusicBank1:   LDA.B #$00                ; \  ; Index (8 bit) 
                    STA.W $0000               ;  | 
                    LDA.B #$80                ;  |Loads The Address 0F:8000 to 00-02 
                    STA.W $0001               ;  |[SPC700 Bank 1 (level) music ROM Address, this is] 
                    LDA.B #$0F                ;  | 
                    STA.W $0002               ; /  
                    BRA StrtSPCMscUpld        
UploadMusicBank2:   LDA.B #$B1                ; \  
                    STA.W $0000               ;  | 
                    LDA.B #$98                ;  |Same as above, but for the Bank 2 music data 
                    STA.W $0001               ;  | ($0E:B198) 
                    LDA.B #$0E                ;  | 
                    STA.W $0002               ; /  
StrtSPCMscUpld:     LDA.B #$FF                
                    STA.W $2141               ; APU I/O Port
                    JSR.W UploadDataToSPC     
                    LDX.B #$03                
SPC700ZeroLoop:     STZ.W $2140,X             
                    STZ.W $1DF9,X             
                    STZ.W $1DFD,X             
                    DEX                       
                    BPL SPC700ZeroLoop        
ADDR_008133:        RTS                       

ADDR_008134:        LDA.W $1425               
                    BNE ADDR_008148           
                    LDA.W $0109               
                    CMP.B #$E9                
                    BEQ ADDR_008148           
                    ORA.W $141A               
                    ORA.W $141D               
                    BNE ADDR_008133           
ADDR_008148:        LDA.B #$D6                
                    STA.W $0000               
                    LDA.B #$AE                
                    STA.W $0001               
                    LDA.B #$0E                
                    STA.W $0002               
                    BRA StrtSPCMscUpld        
ADDR_008159:        LDA.B #$00                
                    STA.W $0000               
                    LDA.B #$E4                
                    STA.W $0001               
                    LDA.B #$03                
                    STA.W $0002               
                    BRA StrtSPCMscUpld        
NMIStart:           SEI                       ; Looks like this might be the NMI routine here. That is correct. 
                    PHP                       ; I thought it was, just from the address, but I wasn't too sure. 
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    PHA                       
                    PHX                       
                    PHY                       
                    PHB                       
                    PHK                       
                    PLB                       
                    SEP #$30                  ; 8 bit A,X,Y ; Index (8 bit) Accum (8 bit) 
                    LDA.W $4210               ; Load "NMI Enable."  This has the effect of clearing the Interrupt, so that ; NMI Enable
                    LDA.W $1DFB               ; \  
                    BNE ADDR_008186           ;  | 
                    LDY.W $2142               ;  | ; APU I/O Port
                    CPY.W $1DFF               ;  |Update SPC700 I/O port 2 
                    BNE ADDR_00818F           ;  | 
ADDR_008186:        STA.W $2142               ;  | ; APU I/O Port
                    STA.W $1DFF               ;  | 
                    STZ.W $1DFB               ;  | 
ADDR_00818F:        LDA.W $1DF9               ; \  
                    STA.W $2140               ;  | ; APU I/O Port
                    LDA.W $1DFA               ;  | 
                    STA.W $2141               ;  |Update SPC700 I/O ports 0, 1 and 3 ; APU I/O Port
                    LDA.W $1DFC               ;  | 
                    STA.W $2143               ;  | ; APU I/O Port
                    STZ.W $1DF9               ;  | 
                    STZ.W $1DFA               ;  | 
                    STZ.W $1DFC               ; /  
                    LDA.B #$80                ; \ Screen off, brightness=0 
                    STA.W $2100               ; /  ; Screen Display Register
                    STZ.W $420C               ; Zero The HDMA reg ; H-DMA Channel Enable
                    LDA $41                   
                    STA.W $2123               ; BG 1 and 2 Window Mask Settings
                    LDA $42                   
                    STA.W $2124               ; BG 3 and 4 Window Mask Settings
                    LDA $43                   
                    STA.W $2125               ; OBJ and Color Window Settings
                    LDA $44                   
                    STA.W $2130               ; Initial Settings for Color Addition
                    LDA.W $0D9B               ; \  
                    BPL ADDR_0081CE           ;  |If in a "Special level", 
                    JMP.W ADDR_0082C4         ;  |jump to $82C4 
ADDR_0081CE:        LDA $40                   ; \ Get the CGADSUB byte... 
                    AND.B #$FB                ;  |Get the Add/Subtract Select and Enable part... 
                    STA.W $2131               ; / ...and store it to the A/SSaE register... ; Add/Subtract Select and Enable
                    LDA.B #$09                ; \ 8x8 tiles, Graphics mode 1 
                    STA.W $2105               ; /  ; BG Mode and Tile Size Setting
                    LDA $10                   ; \ If there isn't any lag, 
                    BEQ ADDR_0081E7           ; / branch to $81E7 
                    LDA.W $0D9B               ; \  
                    LSR                       ;  |If not on a special level, branch to NMINotSpecialLv 
                    BEQ NMINotSpecialLv       ; /  
                    JMP.W ADDR_00827A         
ADDR_0081E7:        INC $10                   
                    JSR.W ADDR_00A488         
                    LDA.W $0D9B               
                    LSR                       
                    BNE ADDR_008222           
                    BCS ADDR_0081F7           
                    JSR.W DrawStatusBar       
ADDR_0081F7:        LDA.W $13C6               ; \  
                    CMP.B #$08                ;  |If the current cutscene isn't the ending, 
                    BNE ADDR_008209           ; / branch to $8209 
                    LDA.W $1FFE               ; \  
                    BEQ ADDR_00821A           ;  |Related to reloading the palettes when switching 
                    JSL.L ADDR_0C9567         ;  |to another background during the credits. 
                    BRA ADDR_00821A           ; /  
ADDR_008209:        JSL.L ADDR_0087AD         
                    LDA.W $143A               
                    BEQ ADDR_008217           
                    JSR.W ADDR_00A7C2         
                    BRA ADDR_00823D           
ADDR_008217:        JSR.W ADDR_00A390         
ADDR_00821A:        JSR.W ADDR_00A436         
                    JSR.W MarioGFXDMA         
                    BRA ADDR_00823D           
ADDR_008222:        LDA.W $13D9               
                    CMP.B #$0A                
                    BNE ADDR_008237           
                    LDY.W $1DE8               
                    DEY                       
                    DEY                       
                    CPY.B #$04                
                    BCS ADDR_008237           
                    JSR.W ADDR_00A529         
                    BRA ADDR_008243           
ADDR_008237:        JSR.W ADDR_00A4E3         
                    JSR.W MarioGFXDMA         
ADDR_00823D:        JSR.W LoadScrnImage       
                    JSR.W DoSomeSpriteDMA     
ADDR_008243:        JSR.W ControllerUpdate    
NMINotSpecialLv:    LDA $1A                   ; \  
                    STA.W $210D               ;  |Set BG 1 Horizontal Scroll Offset ; BG 1 Horizontal Scroll Offset
                    LDA $1B                   ;  |to X position of screen boundry  
                    STA.W $210D               ; /  ; BG 1 Horizontal Scroll Offset
                    LDA $1C                   ; \  
                    CLC                       ;  | 
                    ADC.W $1888               ;  |Set BG 1 Vertical Scroll Offset 
                    STA.W $210E               ;  |to Y position of screen boundry + Layer 1 disposition ; BG 1 Vertical Scroll Offset
                    LDA $1D                   ;  | 
                    ADC.W $1889               ;  | 
                    STA.W $210E               ; /  ; BG 1 Vertical Scroll Offset
                    LDA $1E                   ; \  
                    STA.W $210F               ;  |Set BG 2 Horizontal Scroll Offset ; BG 2 Horizontal Scroll Offset
                    LDA $1F                   ;  |to X position of Layer 2 
                    STA.W $210F               ; /  ; BG 2 Horizontal Scroll Offset
                    LDA $20                   ; \  
                    STA.W $2110               ;  |Set BG 2 Vertical Scroll Offset ; BG 2 Vertical Scroll Offset
                    LDA $21                   ;  |to Y position of Layer 2 
                    STA.W $2110               ; /  ; BG 2 Vertical Scroll Offset
                    LDA.W $0D9B               ; \ If in a normal (not special) level, branch 
                    BEQ ADDR_008292           ; /  
ADDR_00827A:        LDA.B #$81                
                    LDY.W $13C6               ; \  
                    CPY.B #$08                ;  |If not playing ending movie, branch to $82A1 
                    BNE ADDR_0082A1           ; /  
                    LDY.W $0DAE               ; \  
                    STY.W $2100               ; / Set brightness to $0DAE ; Screen Display Register
                    LDY.W $0D9F               ; \  
                    STY.W $420C               ; / Set HDMA channel enable to $0D9F ; H-DMA Channel Enable
                    JMP.W IRQNMIEnding        
ADDR_008292:        LDY.B #$24                ; \  
ADDR_008294:        LDA.W $4211               ;  |(i.e. below the status bar) ; IRQ Flag By H/V Count Timer
                    STY.W $4209               ;  | ; V-Count Timer (Upper 8 Bits)
                    STZ.W $420A               ; /  ; V-Count Timer MSB (Bit 0)
                    STZ $11                   
                    LDA.B #$A1                
ADDR_0082A1:        STA.W $4200               ; NMI, V/H Count, and Joypad Enable
                    STZ.W $2111               ; \  ; BG 3 Horizontal Scroll Offset
                    STZ.W $2111               ;  |Set Layer 3 horizontal and vertical ; BG 3 Horizontal Scroll Offset
                    STZ.W $2112               ;  |scroll to x00 ; BG 3 Vertical Scroll Offset
                    STZ.W $2112               ; /  ; BG 3 Vertical Scroll Offset
                    LDA.W $0DAE               ; \  
                    STA.W $2100               ; / Set brightness to $0DAE ; Screen Display Register
                    LDA.W $0D9F               ; \  
                    STA.W $420C               ; / Set HDMA channel enable to $0D9F ; H-DMA Channel Enable
                    REP #$30                  ; \ Pull all ; Index (16 bit) Accum (16 bit) 
                    PLB                       ;  | 
                    PLY                       ;  | 
                    PLX                       ;  | 
                    PLA                       ;  | 
                    PLP                       ; /  
                    RTI                       ; And return 

ADDR_0082C4:        LDA $10                   ; \ If there is lag, ; Index (8 bit) Accum (8 bit) 
                    BNE ADDR_0082F7           ; / branch to $82F7 
                    INC $10                   
                    LDA.W $143A               ; \ If Mario Start! graphics shouldn't be loaded, 
                    BEQ ADDR_0082D4           ; / branch to $82D4 
                    JSR.W ADDR_00A7C2         
                    BRA ADDR_0082E8           
ADDR_0082D4:        JSR.W ADDR_00A436         
                    JSR.W MarioGFXDMA         
                    BIT.W $0D9B               
                    BVC ADDR_0082E8           
                    JSR.W ADDR_0098A9         
                    LDA.W $0D9B               
                    LSR                       
                    BCS ADDR_0082EB           
ADDR_0082E8:        JSR.W DrawStatusBar       
ADDR_0082EB:        JSR.W ADDR_00A488         
                    JSR.W LoadScrnImage       
                    JSR.W DoSomeSpriteDMA     
                    JSR.W ControllerUpdate    
ADDR_0082F7:        LDA.B #$09                
                    STA.W $2105               ; BG Mode and Tile Size Setting
                    LDA $2A                   
                    CLC                       
                    ADC.B #$80                
                    STA.W $211F               ; Mode 7 Center Position X
                    LDA $2B                   
                    ADC.B #$00                
                    STA.W $211F               ; Mode 7 Center Position X
                    LDA $2C                   
                    CLC                       
                    ADC.B #$80                
                    STA.W $2120               ; Mode 7 Center Position Y
                    LDA $2D                   
                    ADC.B #$00                
                    STA.W $2120               ; Mode 7 Center Position Y
                    LDA $2E                   
                    STA.W $211B               ; Mode 7 Matrix Parameter A
                    LDA $2F                   
                    STA.W $211B               ; Mode 7 Matrix Parameter A
                    LDA $30                   
                    STA.W $211C               ; Mode 7 Matrix Parameter B
                    LDA $31                   
                    STA.W $211C               ; Mode 7 Matrix Parameter B
                    LDA $32                   
                    STA.W $211D               ; Mode 7 Matrix Parameter C
                    LDA $33                   
                    STA.W $211D               ; Mode 7 Matrix Parameter C
                    LDA $34                   
                    STA.W $211E               ; Mode 7 Matrix Parameter D
                    LDA $35                   
                    STA.W $211E               ; Mode 7 Matrix Parameter D
                    JSR.W SETL1SCROLL         
                    LDA.W $0D9B               
                    LSR                       
                    BCC ADDR_00835C           
                    LDA.W $0DAE               
                    STA.W $2100               ; Screen Display Register
                    LDA.W $0D9F               
                    STA.W $420C               ; H-DMA Channel Enable
                    LDA.B #$81                
                    JMP.W ADDR_0083F3         
ADDR_00835C:        LDY.B #$24                
                    BIT.W $0D9B               
                    BVC ADDR_008371           
                    LDA.W $13FC               
                    ASL                       
                    TAX                       
                    LDA.W DATA_00F8E8,X       
                    CMP.B #$2A                
                    BNE ADDR_008371           
                    LDY.B #$2D                
ADDR_008371:        JMP.W ADDR_008294         
IRQHandler:         SEI                       ; Set Interrupt flag so routine can start 
IRQStart:           PHP                       ; \ Save A/X/Y/P/B 
                    REP #$30                  ;  |P = Processor Flags, B = bank number for all $xxxx operations ; Index (16 bit) Accum (16 bit) 
                    PHA                       ;  |Set B to 0$0 
                    PHX                       ;  | 
                    PHY                       ;  | 
                    PHB                       ;  | 
                    PHK                       ;  | 
                    PLB                       ; /  
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDA.W $4211               ; Read the IRQ register, 'unapply' the interrupt ; IRQ Flag By H/V Count Timer
                    BPL ADDR_0083B2           ; If "Timer IRQ" is clear, skip the next code block 
                    LDA.B #$81                
                    LDY.W $0D9B               
                    BMI ADDR_0083BA           ; If Bit 7 (negative flag) is set, branch to a different IRQ mode 
IRQNMIEnding:       STA.W $4200               ; Enable NMI Interrupt and Automatic Joypad reading ; NMI, V/H Count, and Joypad Enable
                    LDY.B #$1F                
                    JSR.W WaitForHBlank       
                    LDA $22                   ; \ Adjust scroll settings for layer 3 
                    STA.W $2111               ;  | ; BG 3 Horizontal Scroll Offset
                    LDA $23                   ;  | 
                    STA.W $2111               ;  | ; BG 3 Horizontal Scroll Offset
                    LDA $24                   ;  | 
                    STA.W $2112               ;  | ; BG 3 Vertical Scroll Offset
                    LDA $25                   ;  | 
                    STA.W $2112               ; /  ; BG 3 Vertical Scroll Offset
ADDR_0083A8:        LDA $3E                   ; \Set the layer BG sizes, L3 priority, and BG mode 
                    STA.W $2105               ; /(Effectively, this is the screen mode) ; BG Mode and Tile Size Setting
                    LDA $40                   ; \Write CGADSUB 
                    STA.W $2131               ; / ; Add/Subtract Select and Enable
ADDR_0083B2:        REP #$30                  ; \ Pull everything back ; Index (16 bit) Accum (16 bit) 
                    PLB                       ;  | 
                    PLY                       ;  | 
                    PLX                       ;  | 
                    PLA                       ;  | 
                    PLP                       ; / 
EmptyHandler:       RTI                       ; And Return 

ADDR_0083BA:        BIT.W $0D9B               ; Get bit 6 of $0D9B ; Index (8 bit) Accum (8 bit) 
                    BVC ADDR_0083E3           ; If clear, skip the next code section 
                    LDY $11                   ; \Skip if $11 = 0 
                    BEQ ADDR_0083D0           ; / 
                    STA.W $4200               ; #$81 -> NMI / Controller Enable reg ; NMI, V/H Count, and Joypad Enable
                    LDY.B #$14                
                    JSR.W WaitForHBlank       
                    JSR.W SETL1SCROLL         
                    BRA ADDR_0083A8           
ADDR_0083D0:        INC $11                   ; $11++ 
                    LDA.W $4211               ; \ Set up the IRQ routine for layer 3 ; IRQ Flag By H/V Count Timer
                    LDA.B #$AE                ;  |-\  
                    SEC                       ;  |  |Vertical Counter trigger at 174 - $1888 
                    SBC.W $1888               ;  |-/ Oddly enough, $1888 seems to be 16-bit, but the 
                    STA.W $4209               ;  |Store to Vertical Counter Timer ; V-Count Timer (Upper 8 Bits)
                    STZ.W $420A               ; / Make the high byte of said timer 0 ; V-Count Timer MSB (Bit 0)
                    LDA.B #$A1                ; A = NMI enable, V count enable, joypad automatic read enable, H count disable 
ADDR_0083E3:        LDY.W $1493               ; if $1493 = 0 skip down 
                    BEQ ADDR_0083F3           
                    LDY.W $1495               ; \ If $1495 is <#$40 
                    CPY.B #$40                ;  | 
                    BCC ADDR_0083F3           ; / Skip down 
                    LDA.B #$81                
                    BRA IRQNMIEnding          ; Jump up to IRQNMIEnding 
ADDR_0083F3:        STA.W $4200               ; A -> NMI/Joypad Auto-Read/HV-Count Control Register ; NMI, V/H Count, and Joypad Enable
                    JSR.W ADDR_008439         
                    NOP                       ; \Not often you see NOP, I think there was a JSL here at one point maybe 
                    NOP                       ; / 
                    LDA.B #$07                ; \Write Screen register 
                    STA.W $2105               ; / ; BG Mode and Tile Size Setting
                    LDA $3A                   ; \ Write L1 Horizontal scroll 
                    STA.W $210D               ;  | ; BG 1 Horizontal Scroll Offset
                    LDA $3B                   ;  | 
                    STA.W $210D               ; /  ; BG 1 Horizontal Scroll Offset
                    LDA $3C                   ; \ Write L1 Vertical Scroll 
                    STA.W $210E               ;  | ; BG 1 Vertical Scroll Offset
                    LDA $3D                   ;  | 
                    STA.W $210E               ; /  ; BG 1 Vertical Scroll Offset
                    BRA ADDR_0083B2           ; And exit IRQ 
SETL1SCROLL:        LDA.B #$59                ; \ 
                    STA.W $2107               ; /Write L1 GFX source address ; BG 1 Address and Size
                    LDA.B #$07                ; \Write L1/L2 Tilemap address 
                    STA.W $210B               ; / ; BG 1 & 2 Tile Data Designation
                    LDA $1A                   ; \ Write L1 Horizontal scroll 
                    STA.W $210D               ;  | ; BG 1 Horizontal Scroll Offset
                    LDA $1B                   ;  | 
                    STA.W $210D               ; / ; BG 1 Horizontal Scroll Offset
                    LDA $1C                   ; \ $1C + $1888 -> L1 Vert scroll 
                    CLC                       ;  |$1888 = Some sort of vertioffset 
                    ADC.W $1888               ;  | 
                    STA.W $210E               ; / ; BG 1 Vertical Scroll Offset
                    LDA $1D                   ; \Other half of L1 vert scroll 
                    STA.W $210E               ; / ; BG 1 Vertical Scroll Offset
                    RTS                       ; Return 

ADDR_008439:        LDY.B #$20                ; <<- Could this be just to waste time? 
WaitForHBlank:      BIT.W $4212               ; So... LDY gets set with 20 if there is a H-Blank...? ; H/V Blank Flags and Joypad Status
                    BVS ADDR_008439           ; if in H-Blank, make Y #$20 and try again 
ADDR_008440:        BIT.W $4212               ; Now wait until not in H-Blank ; H/V Blank Flags and Joypad Status
                    BVC ADDR_008440           
ADDR_008445:        DEY                       ;  |Y = 0 
                    BNE ADDR_008445           ; / ...wait a second... why didn't they just do LDY #$00? ...waste more time? 
                    RTS                       ; return 

DoSomeSpriteDMA:    STZ.W $4300               ; Parameters for DMA Transfer
                    REP #$20                  ; Accum (16 bit) 
                    STZ.W $2102               ; OAM address ; Address for Accessing OAM
                    LDA.W #$0004              
                    STA.W $4301               ; Dest. address = $2104 (data write to OAM) ; B Address
                    LDA.W #$0002              
                    STA.W $4303               ; Source address = $00:0200 ; A Address (High Byte)
                    LDA.W #$0220              
                    STA.W $4305               ; $0220 bytes to transfer ; Number Bytes to Transfer (Low Byte) (DMA)
                    LDY.B #$01                
                    STY.W $420B               ; Start DMA ; Regular DMA Channel Enable
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.B #$80                ; \  
                    STA.W $2103               ;  | 
                    LDA $3F                   ;  |Change the OAM read/write address to #$8000 + $3F 
                    STA.W $2102               ; /  ; Address for Accessing OAM
                    RTS                       ; Return 


DATA_008475:        .db $00,$00,$08,$00,$10,$00,$18,$00
                    .db $20,$00,$28,$00,$30,$00,$38,$00
                    .db $40,$00,$48,$00,$50,$00,$58,$00
                    .db $60,$00,$68,$00,$70,$00,$78

ADDR_008494:        LDY.B #$1E                
ADDR_008496:        LDX.W DATA_008475,Y       
                    LDA.W $0423,X             
                    ASL                       
                    ASL                       
                    ORA.W $0422,X             
                    ASL                       
                    ASL                       
                    ORA.W $0421,X             
                    ASL                       
                    ASL                       
                    ORA.W $0420,X             
                    STA.W $0400,Y             
                    LDA.W $0427,X             
                    ASL                       
                    ASL                       
                    ORA.W $0426,X             
                    ASL                       
                    ASL                       
                    ORA.W $0425,X             
                    ASL                       
                    ASL                       
                    ORA.W $0424,X             
                    STA.W $0401,Y             
                    DEY                       
                    DEY                       
                    BPL ADDR_008496           
                    RTS                       

ADDR_0084C8:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W LoadScrnImage       
                    PLB                       
                    RTL                       


ImagePointers:      .db $7D

DATA_0084D1:        .db $83

DATA_0084D2:        .db $7F,$75,$B3,$05,$00,$A4,$04,$FF
                    .db $B0,$05,$1C,$B9,$05,$00,$B8,$0C
                    .db $72,$B8,$05,$9F,$81,$04,$E0,$81
                    .db $04,$99,$F4,$04,$C7,$B8,$05,$F1
                    .db $BF,$0C,$C3,$BF,$0C,$8E,$BF,$0C
                    .db $59,$BF,$0C,$24,$BF,$0C,$EF,$BE
                    .db $0C,$BA,$BE,$0C,$85,$BE,$0C,$65
                    .db $C1,$0C,$30,$C1,$0C,$FB,$C0,$0C
                    .db $C6,$C0,$0C,$91,$C0,$0C,$5C,$C0
                    .db $0C,$27,$C0,$0C,$F2,$BF,$0C,$F1
                    .db $BF,$0C,$CE,$C2,$0C,$99,$C2,$0C
                    .db $64,$C2,$0C,$2F,$C2,$0C,$FA,$C1
                    .db $0C,$C5,$C1,$0C,$90,$C1,$0C,$6C
                    .db $C4,$0C,$37,$C4,$0C,$02,$C4,$0C
                    .db $CD,$C3,$0C,$98,$C3,$0C,$63,$C3
                    .db $0C,$2E,$C3,$0C,$F9,$C2,$0C,$F1
                    .db $BF,$0C,$DD,$C5,$0C,$A8,$C5,$0C
                    .db $73,$C5,$0C,$3E,$C5,$0C,$09,$C5
                    .db $0C,$D4,$C4,$0C,$9F,$C4,$0C,$85
                    .db $C7,$0C,$50,$C7,$0C,$1B,$C7,$0C
                    .db $E6,$C6,$0C,$B1,$C6,$0C,$7C,$C6
                    .db $0C,$47,$C6,$0C,$12,$C6,$0C,$2D
                    .db $C9,$0C,$F8,$C8,$0C,$C3,$C8,$0C
                    .db $8E,$C8,$0C,$59,$C8,$0C,$24,$C8
                    .db $0C,$EF,$C7,$0C,$BA,$C7,$0C,$56
                    .db $BA,$0C,$B9,$BB,$0C,$BF,$B9,$0C
                    .db $80,$93,$0C,$36,$B6,$0C,$00,$F3
                    .db $0D,$2D,$F4,$0D,$72,$F5,$0D,$6B
                    .db $F6,$0D,$42,$F7,$0D,$37,$F8,$0D
                    .db $FA,$F8,$0D,$CD,$F9,$0D,$98,$FA
                    .db $0D,$73,$FB,$0D,$58,$FC,$0D,$D5
                    .db $FC,$0D,$5C,$FD,$0D,$02,$BD,$0C

LoadScrnImage:      LDY $12                   ; 12 = Image loader 
                    LDA.W ImagePointers,Y     ; \  
                    STA $00                   ;  | 
                    LDA.W DATA_0084D1,Y       ;  |Load pointer 
                    STA $01                   ;  | 
                    LDA.W DATA_0084D2,Y       ;  | 
                    STA $02                   ; /  
                    JSR.W ADDR_00871E         
                    LDA $12                   
                    BNE ADDR_0085F7           
                    STA.L $7F837B             
                    STA.L $7F837C             
                    DEC A                     
                    STA.L $7F837D             
ADDR_0085F7:        STZ $12                   ; Do not reload the same thing next frame 
                    RTS                       

ADDR_0085FA:        JSR.W TurnOffIO           
                    LDA.B #$FC                
                    STA $00                   
                    STZ.W $2115               ; Set "VRAM Address Increment Value" to x00 ; VRAM Address Increment Value
                    STZ.W $2116               ; Set "Address for VRAM Read/Write (Low Byte)" to x00 ; Address for VRAM Read/Write (Low Byte)
                    LDA.B #$50                ; \ Set "Address for VRAM Read/Write (High Byte)" to x50 
                    STA.W $2117               ; /  ; Address for VRAM Read/Write (High Byte)
                    LDX.B #$06                
ADDR_00860E:        LDA.W DATA_008649,X       
                    STA.W $4310,X             
                    DEX                       
                    BPL ADDR_00860E           
                    LDY.B #$02                ; DMA something to VRAM, my guess is a tilemap... 
                    STY.W $420B               ; Regular DMA Channel Enable
                    LDA.B #$38                
                    STA $00                   
                    LDA.B #$80                
                    STA.W $2115               ; VRAM Address Increment Value
                    STZ.W $2116               ; \Change CRAM address ; Address for VRAM Read/Write (Low Byte)
                    LDA.B #$50                ;  | 
                    STA.W $2117               ; / ; Address for VRAM Read/Write (High Byte)
                    LDX.B #$06                ; And Repeat the DMA 
ADDR_00862F:        LDA.W DATA_008649,X       
                    STA.W $4310,X             
                    DEX                       
                    BPL ADDR_00862F           
                    LDA.B #$19                ; \but change desination address to $2119 
                    STA.W $4311               ; / ; B Address
                    STY.W $420B               ; Start DMA ; Regular DMA Channel Enable
                    STZ $3F                   ; $3B = 0 (not sure what $3B is) 
                    JSL.L $7F8000             ; and JSL to a RAM routine 
                    JMP.W DoSomeSpriteDMA     ; Jump to the next part of this routine 

DATA_008649:        .db $08,$18,$00,$00,$00,$00,$10

ControllerUpdate:   LDA.W $4218               ; \  ; Joypad 1Data (Low Byte)
                    AND.B #$F0                ;  | 
                    STA.W $0DA4               ;  | 
                    TAY                       ;  | 
                    EOR.W $0DAC               ;  | 
                    AND.W $0DA4               ;  | 
                    STA.W $0DA8               ;  | 
                    STY.W $0DAC               ;  | 
                    LDA.W $4219               ;  | ; Joypad 1Data (High Byte)
                    STA.W $0DA2               ;  | 
                    TAY                       ;  | 
                    EOR.W $0DAA               ;  | 
                    AND.W $0DA2               ;  | 
                    STA.W $0DA6               ;  | 
                    STY.W $0DAA               ;  |Read controller data 
                    LDA.W $421A               ;  | ; Joypad 2Data (Low Byte)
                    AND.B #$F0                ;  | 
                    STA.W $0DA5               ;  | 
                    TAY                       ;  | 
                    EOR.W $0DAD               ;  | 
                    AND.W $0DA5               ;  | 
                    STA.W $0DA9               ;  | 
                    STY.W $0DAD               ;  | 
                    LDA.W $421B               ;  | ; Joypad 2Data (High Byte)
                    STA.W $0DA3               ;  | 
                    TAY                       ;  | 
                    EOR.W $0DAB               ;  | 
                    AND.W $0DA3               ;  | 
                    STA.W $0DA7               ;  | 
                    STY.W $0DAB               ; /  
                    LDX.W $0DA0               ; \  
                    BPL ADDR_0086A8           ;  |If $0DA0 is positive, set X to $0DA0 
                    LDX.W $0DB3               ;  |Otherwise, set X to current character 
ADDR_0086A8:        LDA.W $0DA4,X             ; \  
                    AND.B #$C0                ;  | 
                    ORA.W $0DA2,X             ;  | 
                    STA $15                   ;  | 
                    LDA.W $0DA4,X             ;  | 
                    STA $17                   ;  |Update controller data bytes 
                    LDA.W $0DA8,X             ;  | 
                    AND.B #$40                ;  | 
                    ORA.W $0DA6,X             ;  | 
                    STA $16                   ;  | 
                    LDA.W $0DA8,X             ;  | 
                    STA $18                   ; /  
                    RTS                       ; Return 

ADDR_0086C7:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDX.W #$0062              
                    LDA.W #$0202              
ADDR_0086CF:        STA.W $0420,X             
                    DEX                       
                    DEX                       
                    BPL ADDR_0086CF           
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDA.B #$F0                
                    JSL.L $7F812E             
                    RTS                       

ExecutePtr:         STY $03                   ; "Push" Y 
                    PLY                       
                    STY $00                   
                    REP #$30                  ; 16 bit A ; Index (16 bit) Accum (16 bit) 
                    AND.W #$00FF              ; A = Game mode 
                    ASL                       ; Multiply game mode by 2 
                    TAY                       
                    PLA                       
                    STA $01                   
                    INY                       
                    LDA [$00],Y               
                    STA $00                   ; A is 16-bit 
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDY $03                   ; "Pull" Y 
                    JMP [$0000]               ; Jump to the game mode's routine, which has been loaded into $00-02 
ExecutePtrLong:     STY $05                   
                    PLY                       
                    STY $02                   
                    REP #$30                  ; 16 bit A,X,Y ; Index (16 bit) Accum (16 bit) 
                    AND.W #$00FF              ; \ A = Tileset/byte 3 (TB3) 
                    STA $03                   ; / Store A in $03 
                    ASL                       ; \ Multiply A by 2 
                    ADC $03                   ;  |Add TB3 to A 
                    TAY                       ; / Set Y to A 
                    PLA                       
                    STA $03                   
                    INY                       
                    LDA [$02],Y               
                    STA $00                   
                    INY                       
                    LDA [$02],Y               
                    STA $01                   
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDY $05                   
                    JMP [$0000]               
ADDR_00871E:        REP #$10                  ; 16 bit X,Y ; Index (16 bit) 
                    STA.W $4314               ; A Address Bank
                    LDY.W #$0000              ; Set index to 0 
ADDR_008726:        LDA [$00],Y               ; \ Read line header byte 1 
                    BPL ADDR_00872D           ;  |If the byte & %10000000 is true, 
                    SEP #$30                  ;  |Set A,X,Y to 8 bit and return ; Index (8 bit) Accum (8 bit) 
                    RTS                       ;  | 

ADDR_00872D:        STA $04                   ; Store byte in $04 ; Index (16 bit) 
                    INY                       ; Move onto the next byte 
                    LDA [$00],Y               ; Read line header byte 2 
                    STA $03                   ; Store byte in $03 
                    INY                       ; Move onto the next byte 
                    LDA [$00],Y               ; Read line header byte 3 
                    STZ $07                   ; \  
                    ASL                       ;  |Store direction bit in $07 
                    ROL $07                   ; /  
                    LDA.B #$18                ; \ Set B address (DMA) to x18 
                    STA.W $4311               ; /  ; B Address
                    LDA [$00],Y               ; Re-read line header byte 3 
                    AND.B #$40                ; \  
                    LSR                       ;  | 
                    LSR                       ;  |Store RLE bit << 3 in $05 
                    LSR                       ;  | 
                    STA $05                   ; /  
                    STZ $06                   
                    ORA.B #$01                
                    STA.W $4310               ; Parameters for DMA Transfer
                    REP #$20                  ; 16 bit A ; Accum (16 bit) 
                    LDA $03                   
                    STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDA [$00],Y               
                    XBA                       
                    AND.W #$3FFF              
                    TAX                       
                    INX                       
                    INY                       
                    INY                       
                    TYA                       
                    CLC                       
                    ADC $00                   
                    STA.W $4312               ; A Address (Low Byte)
                    STX.W $4315               ; Number Bytes to Transfer (Low Byte) (DMA)
                    LDA $05                   
                    BEQ ADDR_008795           
                    SEP #$20                  ; 8 bit A ; Accum (8 bit) 
                    LDA $07                   
                    STA.W $2115               ; VRAM Address Increment Value
                    LDA.B #$02                
                    STA.W $420B               ; Regular DMA Channel Enable
                    LDA.B #$19                
                    STA.W $4311               ; B Address
                    REP #$21                  ; Accum (16 bit) 
                    LDA $03                   
                    STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    TYA                       
                    ADC $00                   
                    INC A                     
                    STA.W $4312               ; A Address (Low Byte)
                    STX.W $4315               ; Number Bytes to Transfer (Low Byte) (DMA)
                    LDX.W #$0002              
ADDR_008795:        STX $03                   
                    TYA                       
                    CLC                       
                    ADC $03                   
                    TAY                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDA $07                   
                    ORA.B #$80                
                    STA.W $2115               ; VRAM Address Increment Value
                    LDA.B #$02                
                    STA.W $420B               ; Regular DMA Channel Enable
                    JMP.W ADDR_008726         
ADDR_0087AD:        SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDA.W $1BE4               ; \  
                    BNE ADDR_0087B7           ;  |If Layer 1 has to be updated, 
                    JMP.W ADDR_0088DD         ;  |jump to $88DD 
ADDR_0087B7:        LDA $5B                   ; \  
                    AND.B #$01                ;  | 
                    BEQ ADDR_0087C0           ;  |If on a vertical level, 
                    JMP.W ADDR_008849         ;  |jump to $8849 
ADDR_0087C0:        LDY.B #$81                ; \ Set "VRAM Address Increment Value" to x81 
                    STY.W $2115               ; /  ; VRAM Address Increment Value
                    LDA.W $1BE5               
                    STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDA.W $1BE4               
                    STA.W $2117               ; Address for VRAM Read/Write (High Byte)
                    LDX.B #$06                
ADDR_0087D3:        LDA.W DATA_008A16,X       
                    STA.W $4310,X             
                    DEX                       
                    BPL ADDR_0087D3           
                    LDA.B #$02                ; \ Enable DMA channel 1 
                    STA.W $420B               ; /  ; Regular DMA Channel Enable
                    STY.W $2115               ; VRAM Address Increment Value
                    LDA.W $1BE5               
                    STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDA.W $1BE4               
                    CLC                       
                    ADC.B #$08                
                    STA.W $2117               ; Address for VRAM Read/Write (High Byte)
                    LDX.B #$06                
ADDR_0087F5:        LDA.W DATA_008A1D,X       
                    STA.W $4310,X             
                    DEX                       
                    BPL ADDR_0087F5           
                    LDA.B #$02                
                    STA.W $420B               ; \ Enable DMA channel 1 ; Regular DMA Channel Enable
                    STY.W $2115               ; /  ; VRAM Address Increment Value
                    LDA.W $1BE5               
                    INC A                     
                    STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDA.W $1BE4               
                    STA.W $2117               ; Address for VRAM Read/Write (High Byte)
                    LDX.B #$06                
ADDR_008815:        LDA.W DATA_008A24,X       
                    STA.W $4310,X             
                    DEX                       
                    BPL ADDR_008815           
                    LDA.B #$02                ; \ Enable DMA channel 1 
                    STA.W $420B               ; /  ; Regular DMA Channel Enable
                    STY.W $2115               ; VRAM Address Increment Value
                    LDA.W $1BE5               
                    INC A                     
                    STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDA.W $1BE4               
                    CLC                       
                    ADC.B #$08                
                    STA.W $2117               ; Address for VRAM Read/Write (High Byte)
                    LDX.B #$06                
ADDR_008838:        LDA.W DATA_008A2B,X       
                    STA.W $4310,X             
                    DEX                       
                    BPL ADDR_008838           
                    LDA.B #$02                ; \ Enable DMA channel 1 
                    STA.W $420B               ; /  ; Regular DMA Channel Enable
                    JMP.W ADDR_0088DD         
ADDR_008849:        LDY.B #$80                
                    STY.W $2115               ; VRAM Address Increment Value
                    LDA.W $1BE5               
                    STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDA.W $1BE4               
                    STA.W $2117               ; Address for VRAM Read/Write (High Byte)
                    LDX.B #$06                
ADDR_00885C:        LDA.W DATA_008A16,X       
                    STA.W $4310,X             
                    DEX                       
                    BPL ADDR_00885C           
                    LDA.B #$02                
                    STA.W $420B               ; Regular DMA Channel Enable
                    STY.W $2115               ; VRAM Address Increment Value
                    LDA.W $1BE5               
                    STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDA.W $1BE4               
                    CLC                       
                    ADC.B #$04                
                    STA.W $2117               ; Address for VRAM Read/Write (High Byte)
                    LDX.B #$06                
ADDR_00887E:        LDA.W DATA_008A1D,X       
                    STA.W $4310,X             
                    DEX                       
                    BPL ADDR_00887E           
                    LDA.B #$40                
                    STA.W $4315               ; Number Bytes to Transfer (Low Byte) (DMA)
                    LDA.B #$02                
                    STA.W $420B               ; Regular DMA Channel Enable
                    STY.W $2115               ; VRAM Address Increment Value
                    LDA.W $1BE5               
                    CLC                       
                    ADC.B #$20                
                    STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDA.W $1BE4               
                    STA.W $2117               ; Address for VRAM Read/Write (High Byte)
                    LDX.B #$06                
ADDR_0088A5:        LDA.W DATA_008A24,X       
                    STA.W $4310,X             
                    DEX                       
                    BPL ADDR_0088A5           
                    LDA.B #$02                
                    STA.W $420B               ; Regular DMA Channel Enable
                    STY.W $2115               ; VRAM Address Increment Value
                    LDA.W $1BE5               
                    CLC                       
                    ADC.B #$20                
                    STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDA.W $1BE4               
                    CLC                       
                    ADC.B #$04                
                    STA.W $2117               ; Address for VRAM Read/Write (High Byte)
                    LDX.B #$06                
ADDR_0088CA:        LDA.W DATA_008A2B,X       
                    STA.W $4310,X             
                    DEX                       
                    BPL ADDR_0088CA           
                    LDA.B #$40                
                    STA.W $4315               ; Number Bytes to Transfer (Low Byte) (DMA)
                    LDA.B #$02                
                    STA.W $420B               ; Regular DMA Channel Enable
ADDR_0088DD:        LDA.B #$00                
                    STA.W $1BE4               
                    LDA.W $1CE6               
                    BNE ADDR_0088EA           
                    JMP.W ADDR_008A10         
ADDR_0088EA:        LDA $5B                   
                    AND.B #$02                
                    BEQ ADDR_0088F3           
                    JMP.W ADDR_00897C         
ADDR_0088F3:        LDY.B #$81                
                    STY.W $2115               ; VRAM Address Increment Value
                    LDA.W $1CE7               
                    STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDA.W $1CE6               
                    STA.W $2117               ; Address for VRAM Read/Write (High Byte)
                    LDX.B #$06                
ADDR_008906:        LDA.W DATA_008A32,X       
                    STA.W $4310,X             
                    DEX                       
                    BPL ADDR_008906           
                    LDA.B #$02                
                    STA.W $420B               ; Regular DMA Channel Enable
                    STY.W $2115               ; VRAM Address Increment Value
                    LDA.W $1CE7               
                    STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDA.W $1CE6               
                    CLC                       
                    ADC.B #$08                
                    STA.W $2117               ; Address for VRAM Read/Write (High Byte)
                    LDX.B #$06                
ADDR_008928:        LDA.W DATA_008A39,X       
                    STA.W $4310,X             
                    DEX                       
                    BPL ADDR_008928           
                    LDA.B #$02                
                    STA.W $420B               ; Regular DMA Channel Enable
                    STY.W $2115               ; VRAM Address Increment Value
                    LDA.W $1CE7               
                    INC A                     
                    STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDA.W $1CE6               
                    STA.W $2117               ; Address for VRAM Read/Write (High Byte)
                    LDX.B #$06                
ADDR_008948:        LDA.W DATA_008A40,X       
                    STA.W $4310,X             
                    DEX                       
                    BPL ADDR_008948           
                    LDA.B #$02                
                    STA.W $420B               ; Regular DMA Channel Enable
                    STY.W $2115               ; VRAM Address Increment Value
                    LDA.W $1CE7               
                    INC A                     
                    STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDA.W $1CE6               
                    CLC                       
                    ADC.B #$08                
                    STA.W $2117               ; Address for VRAM Read/Write (High Byte)
                    LDX.B #$06                
ADDR_00896B:        LDA.W DATA_008A47,X       
                    STA.W $4310,X             
                    DEX                       
                    BPL ADDR_00896B           
                    LDA.B #$02                
                    STA.W $420B               ; Regular DMA Channel Enable
                    JMP.W ADDR_008A10         
ADDR_00897C:        LDY.B #$80                
                    STY.W $2115               ; VRAM Address Increment Value
                    LDA.W $1CE7               
                    STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDA.W $1CE6               
                    STA.W $2117               ; Address for VRAM Read/Write (High Byte)
                    LDX.B #$06                
ADDR_00898F:        LDA.W DATA_008A32,X       
                    STA.W $4310,X             
                    DEX                       
                    BPL ADDR_00898F           
                    LDA.B #$02                
                    STA.W $420B               ; Regular DMA Channel Enable
                    STY.W $2115               ; VRAM Address Increment Value
                    LDA.W $1CE7               
                    STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDA.W $1CE6               
                    CLC                       
                    ADC.B #$04                
                    STA.W $2117               ; Address for VRAM Read/Write (High Byte)
                    LDX.B #$06                
ADDR_0089B1:        LDA.W DATA_008A39,X       
                    STA.W $4310,X             
                    DEX                       
                    BPL ADDR_0089B1           
                    LDA.B #$40                
                    STA.W $4315               ; Number Bytes to Transfer (Low Byte) (DMA)
                    LDA.B #$02                
                    STA.W $420B               ; Regular DMA Channel Enable
                    STY.W $2115               ; VRAM Address Increment Value
                    LDA.W $1CE7               
                    CLC                       
                    ADC.B #$20                
                    STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDA.W $1CE6               
                    STA.W $2117               ; Address for VRAM Read/Write (High Byte)
                    LDX.B #$06                
ADDR_0089D8:        LDA.W DATA_008A40,X       
                    STA.W $4310,X             
                    DEX                       
                    BPL ADDR_0089D8           
                    LDA.B #$02                
                    STA.W $420B               ; Regular DMA Channel Enable
                    STY.W $2115               ; VRAM Address Increment Value
                    LDA.W $1CE7               
                    CLC                       
                    ADC.B #$20                
                    STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDA.W $1CE6               
                    CLC                       
                    ADC.B #$04                
                    STA.W $2117               ; Address for VRAM Read/Write (High Byte)
                    LDX.B #$06                
ADDR_0089FD:        LDA.W DATA_008A47,X       
                    STA.W $4310,X             
                    DEX                       
                    BPL ADDR_0089FD           
                    LDA.B #$40                
                    STA.W $4315               ; Number Bytes to Transfer (Low Byte) (DMA)
                    LDA.B #$02                
                    STA.W $420B               ; Regular DMA Channel Enable
ADDR_008A10:        LDA.B #$00                
                    STA.W $1CE6               
                    RTL                       


DATA_008A16:        .db $01,$18,$E6,$1B,$00,$40,$00

DATA_008A1D:        .db $01,$18,$26,$1C,$00,$2C,$00

DATA_008A24:        .db $01,$18,$66,$1C,$00,$40,$00

DATA_008A2B:        .db $01,$18,$A6,$1C,$00,$2C,$00

DATA_008A32:        .db $01,$18,$E8,$1C,$00,$40,$00

DATA_008A39:        .db $01,$18,$28,$1D,$00,$2C,$00

DATA_008A40:        .db $01,$18,$68,$1D,$00,$40,$00

DATA_008A47:        .db $01,$18,$A8,$1D,$00,$2C,$00

ClearStack:         REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDX.W #$1FFE              
ADDR_008A53:        STZ $00,X                 
ADDR_008A55:        DEX                       
                    DEX                       
                    CPX.W #$01FF              
                    BPL ADDR_008A61           
                    CPX.W #$0100              
                    BPL ADDR_008A55           
ADDR_008A61:        CPX.W #$FFFE              
                    BNE ADDR_008A53           
                    LDA.W #$0000              
                    STA.L $7F837B             
                    STZ.W $0681               
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDA.B #$FF                
                    STA.L $7F837D             
                    RTS                       

SetUpScreen:        STZ.W $2133               ; Set "Screen Initial Settings" to x00 ; Screen Initial Settings
                    STZ.W $2106               ; Turn off mosaic ; Mosaic Size and BG Enable
                    LDA.B #$23                
                    STA.W $2107               ; BG 1 Address and Size
                    LDA.B #$33                
                    STA.W $2108               ; ; BG 2 Address and Size
                    LDA.B #$53                
                    STA.W $2109               ; BG 3 Address and Size
                    LDA.B #$00                
                    STA.W $210B               ; BG 1 & 2 Tile Data Designation
                    LDA.B #$04                
                    STA.W $210C               ; BG 3 & 4 Tile Data Designation
                    STZ $41                   
                    STZ $42                   
                    STZ $43                   
                    STZ.W $212A               ; BG 1, 2, 3 and 4 Window Logic Settings
                    STZ.W $212B               ; Color and OBJ Window Logic Settings
                    STZ.W $212E               ; Window Mask Designation for Main Screen
                    STZ.W $212F               ; Window Mask Designation for Sub Screen
                    LDA.B #$02                
                    STA $44                   
                    LDA.B #$80                ; \ Set Mode7 "Screen Over" to %10000000, disable Mode7 flipping 
                    STA.W $211A               ; /  ; Initial Setting for Mode 7
                    RTS                       ; Return 


DATA_008AB4:        .db $00,$00,$FE,$00,$00,$00,$FE,$00
DATA_008ABC:        .db $00,$00,$02,$00,$00,$00,$02,$00
                    .db $00,$00,$00,$01,$FF,$FF,$00,$10
                    .db $F0

ADDR_008ACD:        LDA $39                   
                    STA $00                   
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    JSR.W ADDR_008AE8         
                    LDA $38                   
                    STA $00                   
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA $2E                   
                    STA $34                   
                    LDA $30                   
                    EOR.W #$FFFF              
                    INC A                     
                    STA $32                   
ADDR_008AE8:        LDA $36                   
                    ASL                       
                    PHA                       
                    XBA                       
                    AND.W #$0003              
                    ASL                       
                    TAY                       
                    PLA                       
                    AND.W #$00FE              
                    EOR.W DATA_008AB4,Y       
                    CLC                       
                    ADC.W DATA_008ABC,Y       
                    TAX                       
                    JSR.W ADDR_008B2B         
                    CPY.W #$0004              
                    BCC ADDR_008B0A           
                    EOR.W #$FFFF              
                    INC A                     
ADDR_008B0A:        STA $30                   
                    TXA                       
                    EOR.W #$00FE              
                    CLC                       
                    ADC.W #$0002              
                    AND.W #$01FF              
                    TAX                       
                    JSR.W ADDR_008B2B         
                    DEY                       
                    DEY                       
                    CPY.W #$0004              
                    BCS ADDR_008B26           
                    EOR.W #$FFFF              
                    INC A                     
ADDR_008B26:        STA $2E                   
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    RTS                       

ADDR_008B2B:        SEP #$20                  ; Accum (8 bit) 
                    LDA.W DATA_008B58,X       
                    BEQ ADDR_008B34           
                    LDA $00                   
ADDR_008B34:        STA $01                   
                    LDA.W DATA_008B57,X       
                    STA.W $4202               ; Multiplicand A
                    LDA $00                   
                    STA.W $4203               ; Multplier B
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    LDA.W $4217               ; Product/Remainder Result (High Byte)
                    CLC                       
                    ADC $01                   
                    XBA                       
                    LDA.W $4216               ; Product/Remainder Result (Low Byte)
                    REP #$20                  ; Accum (16 bit) 
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    RTS                       


DATA_008B57:        .db $00

DATA_008B58:        .db $00,$03,$00,$06,$00,$09,$00,$0C
                    .db $00,$0F,$00,$12,$00,$15,$00,$19
                    .db $00,$1C,$00,$1F,$00,$22,$00,$25
                    .db $00,$28,$00,$2B,$00,$2E,$00,$31
                    .db $00,$35,$00,$38,$00,$3B,$00,$3E
                    .db $00,$41,$00,$44,$00,$47,$00,$4A
                    .db $00,$4D,$00,$50,$00,$53,$00,$56
                    .db $00,$59,$00,$5C,$00,$5F,$00,$61
                    .db $00,$64,$00,$67,$00,$6A,$00,$6D
                    .db $00,$70,$00,$73,$00,$75,$00,$78
                    .db $00,$7B,$00,$7E,$00,$80,$00,$83
                    .db $00,$86,$00,$88,$00,$8B,$00,$8E
                    .db $00,$90,$00,$93,$00,$95,$00,$98
                    .db $00,$9B,$00,$9D,$00,$9F,$00,$A2
                    .db $00,$A4,$00,$A7,$00,$A9,$00,$AB
                    .db $00,$AE,$00,$B0,$00,$B2,$00,$B5
                    .db $00,$B7,$00,$B9,$00,$BB,$00,$BD
                    .db $00,$BF,$00,$C1,$00,$C3,$00,$C5
                    .db $00,$C7,$00,$C9,$00,$CB,$00,$CD
                    .db $00,$CF,$00,$D1,$00,$D3,$00,$D4
                    .db $00,$D6,$00,$D8,$00,$D9,$00,$DB
                    .db $00,$DD,$00,$DE,$00,$E0,$00,$E1
                    .db $00,$E3,$00,$E4,$00,$E6,$00,$E7
                    .db $00,$E8,$00,$EA,$00,$EB,$00,$EC
                    .db $00,$ED,$00,$EE,$00,$EF,$00,$F1
                    .db $00,$F2,$00,$F3,$00,$F4,$00,$F4
                    .db $00,$F5,$00,$F6,$00,$F7,$00,$F8
                    .db $00,$F9,$00,$F9,$00,$FA,$00,$FB
                    .db $00,$FB,$00,$FC,$00,$FC,$00,$FD
                    .db $00,$FD,$00,$FE,$00,$FE,$00,$FE
                    .db $00,$FF,$00,$FF,$00,$FF,$00,$FF
                    .db $00,$FF,$00,$FF,$00,$FF,$00,$00
                    .db $01,$B7,$3C,$B7,$BC,$B8,$3C,$B9
                    .db $3C,$BA,$3C,$BB,$3C,$BA,$3C,$BA
                    .db $BC,$BC,$3C,$BD,$3C,$BE,$3C,$BF
                    .db $3C,$C0,$3C,$B7,$BC,$C1,$3C,$B9
                    .db $3C,$C2,$3C,$C2,$BC,$B7,$3C,$C0
                    .db $FC,$3A,$38,$3B,$38,$3B,$38,$3A
                    .db $78

DATA_008C89:        .db $30,$28,$31,$28,$32,$28,$33,$28
                    .db $34,$28,$FC,$38,$FC,$3C,$FC,$3C
                    .db $FC,$3C,$FC,$3C,$FC,$38,$FC,$38
                    .db $4A,$38,$FC,$38,$FC,$38,$4A,$78
                    .db $FC,$38,$3D,$3C,$3E,$3C,$3F,$3C
                    .db $FC,$38,$FC,$38,$FC,$38,$2E,$3C
                    .db $26,$38,$FC,$38,$FC,$38,$00,$38
                    .db $26,$38,$FC,$38,$00,$38,$FC,$38
                    .db $FC,$38,$FC,$38,$64,$28,$26,$38
                    .db $FC,$38,$FC,$38,$FC,$38,$4A,$38
                    .db $FC,$38,$FC,$38,$4A,$78,$FC,$38
                    .db $FE,$3C,$FE,$3C,$00,$3C,$FC,$38
                    .db $FC,$38,$FC,$38,$FC,$38,$FC,$38
                    .db $FC,$38,$FC,$38,$00,$38,$3A,$B8
                    .db $3B,$B8,$3B,$B8,$3A,$F8

GM04DoDMA:          LDA.B #$80                ; More DMA ; Accum (8 bit) 
                    STA.W $2115               ; Increment when $2119 accessed ; VRAM Address Increment Value
                    LDA.B #$2E                ; \VRAM address = #$502E 
                    STA.W $2116               ;  | ; Address for VRAM Read/Write (Low Byte)
                    LDA.B #$50                ;  | 
                    STA.W $2117               ; / ; Address for VRAM Read/Write (High Byte)
                    LDX.B #$06                
ADDR_008D10:        LDA.W DATA_008D90,X       
                    STA.W $4310,X             ; Load up the DMA regs 
                    DEX                       ; DMA Source = 8C:8118 (...) 
                    BPL ADDR_008D10           ; Dest = $2118, Transfer: #$08 bytes 
                    LDA.B #$02                
                    STA.W $420B               ; Do the DMA ; Regular DMA Channel Enable
                    LDA.B #$80                ; \ Set VRAM mode = same as above 
                    STA.W $2115               ;  |Address = #$5042 ; VRAM Address Increment Value
                    LDA.B #$42                ;  | 
                    STA.W $2116               ;  | ; Address for VRAM Read/Write (Low Byte)
                    LDA.B #$50                ;  | 
                    STA.W $2117               ; /  ; Address for VRAM Read/Write (High Byte)
                    LDX.B #$06                ; \ Set up more DMA 
ADDR_008D2F:        LDA.W DATA_008D97,X       ;  |Dest = $2100 
                    STA.W $4310,X             ;  |Fixed source address = $89:1801 (Lunar Address: 7E:1801) 
                    DEX                       ;  |#$808C bytes to transfer 
                    BPL ADDR_008D2F           ; /Type = One reg write once 
                    LDA.B #$02                
                    STA.W $420B               ; Start DMA ; Regular DMA Channel Enable
                    LDA.B #$80                ; \prep VRAM for another write 
                    STA.W $2115               ;  | ; VRAM Address Increment Value
                    LDA.B #$63                ;  | 
                    STA.W $2116               ;  | ; Address for VRAM Read/Write (Low Byte)
                    LDA.B #$50                ;  | 
                    STA.W $2117               ; / ; Address for VRAM Read/Write (High Byte)
                    LDX.B #$06                ; \ Load up DMA again 
ADDR_008D4E:        LDA.W DATA_008D9E,X       ;  |Dest = $2118 
                    STA.W $4310,X             ;  |Source Address = $39:8CC1 
                    DEX                       ;  |Size = #$0100 bytes 
                    BPL ADDR_008D4E           ; /Type = Two reg write once 
                    LDA.B #$02                ; \Start Transfer 
                    STA.W $420B               ; / ; Regular DMA Channel Enable
                    LDA.B #$80                ; \ 
                    STA.W $2115               ;  |Set up VRAM once more ; VRAM Address Increment Value
                    LDA.B #$8E                ;  | 
                    STA.W $2116               ;  | ; Address for VRAM Read/Write (Low Byte)
                    LDA.B #$50                ;  | 
                    STA.W $2117               ; / ; Address for VRAM Read/Write (High Byte)
                    LDX.B #$06                ; \Last DMA... 
ADDR_008D6D:        LDA.W DATA_008DA5,X       ;  |Reg = $2118 Type = Two reg write once 
                    STA.W $4310,X             ;  |Source Address = $08:8CF7 
                    DEX                       ;  |Size = #$9C00 bytes (o_o) 
                    BPL ADDR_008D6D           ; / 
                    LDA.B #$02                ; \Transfer 
                    STA.W $420B               ; / ; Regular DMA Channel Enable
                    LDX.B #$36                ; \Copy some data into RAM 
                    LDY.B #$6C                ;  | 
ADDR_008D7F:        LDA.W DATA_008C89,Y       ;  | 
                    STA.W $0EF9,X             ;  | 
                    DEY                       ;  | 
                    DEY                       ;  | 
                    DEX                       ;  | 
                    BPL ADDR_008D7F           ; / 
                    LDA.B #$28                
                    STA.W $0F30               ; #$28 -> Timer frame counter 
                    RTS                       ; Return 


DATA_008D90:        .db $01,$18,$81,$8C,$00,$08,$00

DATA_008D97:        .db $01,$18,$89,$8C,$00,$38,$00

DATA_008D9E:        .db $01,$18,$C1,$8C,$00,$36,$00

DATA_008DA5:        .db $01,$18,$F7,$8C,$00,$08,$00

DrawStatusBar:      STZ.W $2115               ; Set VRAM Address Increment Value to x00 ; VRAM Address Increment Value
                    LDA.B #$42                ; \  
                    STA.W $2116               ;  |Set Address for VRAM Read/Write to x5042 ; Address for VRAM Read/Write (Low Byte)
                    LDA.B #$50                ;  | 
                    STA.W $2117               ; /  ; Address for VRAM Read/Write (High Byte)
                    LDX.B #$06                ; \  
ADDR_008DBB:        LDA.W DMAdata_StBr1,X     ;  |Load settings from DMAdata_StBr1 into DMA channel 1 
                    STA.W $4310,X             ;  | 
                    DEX                       ;  | 
                    BPL ADDR_008DBB           ; /  
                    LDA.B #$02                ; \ Activate DMA channel 1 
                    STA.W $420B               ; /  ; Regular DMA Channel Enable
                    STZ.W $2115               ; Set VRAM Address Increment Value to x00 ; VRAM Address Increment Value
                    LDA.B #$63                ; \  
                    STA.W $2116               ;  |Set Address for VRAM Read/Write to x5063 ; Address for VRAM Read/Write (Low Byte)
                    LDA.B #$50                ;  | 
                    STA.W $2117               ; /  ; Address for VRAM Read/Write (High Byte)
                    LDX.B #$06                ; \  
ADDR_008DD8:        LDA.W DMAdata_StBr2,X     ;  |Load settings from DMAdata_StBr2 into DMA channel 1 
                    STA.W $4310,X             ;  | 
                    DEX                       ;  | 
                    BPL ADDR_008DD8           ; /  
                    LDA.B #$02                ; \ Activate DMA channel 1 
                    STA.W $420B               ; /  ; Regular DMA Channel Enable
                    RTS                       ; Return 


DMAdata_StBr1:      .db $00,$18,$F9,$0E,$00,$1C,$00

DMAdata_StBr2:      .db $00,$18,$15,$0F,$00,$1B,$00

DATA_008DF5:        .db $40,$41,$42,$43

DATA_008DF9:        .db $44,$24,$26,$48,$0E

DATA_008DFE:        .db $00,$02,$04

DATA_008E01:        .db $02,$08,$0A,$00,$04

DATA_008E06:        .db $B7

DATA_008E07:        .db $C3,$B8,$B9,$BA,$BB,$BA,$BF,$BC
                    .db $BD,$BE,$BF,$C0,$C3,$C1,$B9,$C2
                    .db $C4,$B7,$C5

ADDR_008E1A:        LDA.W $1493               ; \  
                    ORA $9D                   ;  |If level is ending or sprites are locked, 
                    BNE ADDR_008E6F           ; / branch to $8E6F 
                    LDA.W $0D9B               
                    CMP.B #$C1                
                    BEQ ADDR_008E6F           
                    DEC.W $0F30               
                    BPL ADDR_008E6F           
                    LDA.B #$28                
                    STA.W $0F30               
                    LDA.W $0F31               ; \  
                    ORA.W $0F32               ;  |If time is 0, 
                    ORA.W $0F33               ;  |branch to $8E6F 
                    BEQ ADDR_008E6F           ; /  
                    LDX.B #$02                
ADDR_008E3F:        DEC.W $0F31,X             
                    BPL ADDR_008E4C           
                    LDA.B #$09                
                    STA.W $0F31,X             
                    DEX                       
                    BPL ADDR_008E3F           
ADDR_008E4C:        LDA.W $0F31               ; \  
                    BNE ADDR_008E60           ;  | 
                    LDA.W $0F32               ;  | 
                    AND.W $0F33               ;  |If time is 99, 
                    CMP.B #$09                ;  |speed up the music 
                    BNE ADDR_008E60           ;  | 
                    LDA.B #$FF                ;  | 
                    STA.W $1DF9               ;  | 
ADDR_008E60:        LDA.W $0F31               ; \  
                    ORA.W $0F32               ;  | 
                    ORA.W $0F33               ;  |If time is 0, 
                    BNE ADDR_008E6F           ;  |JSL to $00F606 
                    JSL.L KillMario           ;  | 
ADDR_008E6F:        LDA.W $0F31               ; \  
                    STA.W $0F25               ;  | 
                    LDA.W $0F32               ;  |Copy time to $0F25-$0F27 
                    STA.W $0F26               ;  | 
                    LDA.W $0F33               ;  | 
                    STA.W $0F27               ; /  
                    LDX.B #$10                
                    LDY.B #$00                
ADDR_008E85:        LDA.W $0F31,Y             
                    BNE ADDR_008E95           
                    LDA.B #$FC                
                    STA.W $0F15,X             
                    INY                       
                    INX                       
                    CPY.B #$02                
                    BNE ADDR_008E85           
ADDR_008E95:        LDX.B #$03                
ADDR_008E97:        LDA.W $0F36,X             
                    STA $00                   
                    STZ $01                   
                    REP #$20                  ; 16 bit A ; Accum (16 bit) 
                    LDA.W $0F34,X             
                    SEC                       
                    SBC.W #$423F              
                    LDA $00                   
                    SBC.W #$000F              
                    BCC ADDR_008EBF           
                    SEP #$20                  ; 8 bit A ; Accum (8 bit) 
                    LDA.B #$0F                
                    STA.W $0F36,X             
                    LDA.B #$42                
                    STA.W $0F35,X             
                    LDA.B #$3F                
                    STA.W $0F34,X             
ADDR_008EBF:        SEP #$20                  ; 8 bit A ; Accum (8 bit) 
                    DEX                       
                    DEX                       
                    DEX                       
                    BPL ADDR_008E97           
                    LDA.W $0F36               ; \ Store high byte of Mario's score in $00 
                    STA $00                   ; /  
                    STZ $01                   ; Store x00 in $01 
                    LDA.W $0F35               ; \ Store mid byte of Mario's score in $03 
                    STA $03                   ; / 
                    LDA.W $0F34               ; \ Store low byte of Mario's score in $02 
                    STA $02                   ; / 
                    LDX.B #$14                
                    LDY.B #$00                
                    JSR.W ADDR_009012         
                    LDX.B #$00                ; \  
ADDR_008EE0:        LDA.W $0F29,X             ;  | 
                    BNE ADDR_008EEF           ;  | 
                    LDA.B #$FC                ;  |Replace all leading zeroes in the score with spaces 
                    STA.W $0F29,X             ;  | 
                    INX                       ;  | 
                    CPX.B #$06                ;  | 
                    BNE ADDR_008EE0           ;  | 
ADDR_008EEF:        LDA.W $0DB3               ; Get current player 
                    BEQ ADDR_008F1D           ; If player is Mario, branch to $8F1D 
                    LDA.W $0F39               ; \ Store high byte of Luigi's score in $00 
                    STA $00                   ; /  
                    STZ $01                   ; Store x00 in $01 
                    LDA.W $0F38               ; \ Store mid byte of Luigi's score in $03 
                    STA $03                   ; /  
                    LDA.W $0F37               ; \ Store low byte of Luigi's score in $02 
                    STA $02                   ; /  
                    LDX.B #$14                
                    LDY.B #$00                
                    JSR.W ADDR_009012         
                    LDX.B #$00                ; \  
ADDR_008F0E:        LDA.W $0F29,X             ;  | 
                    BNE ADDR_008F1D           ;  | 
                    LDA.B #$FC                ;  |Replace all leading zeroes in the score with spaces 
                    STA.W $0F29,X             ;  | 
                    INX                       ;  | 
                    CPX.B #$06                ;  | 
                    BNE ADDR_008F0E           ; /  
ADDR_008F1D:        LDA.W $13CC               ; \ If Coin increase isn't x00, 
                    BEQ ADDR_008F3B           ; / branch to $8F3B 
                    DEC.W $13CC               ; Decrease "Coin increase" 
                    INC.W $0DBF               ; Increase coins by 1 
                    LDA.W $0DBF               ; \  
                    CMP.B #$64                ;  |If coins<100, branch to $8F3B 
                    BCC ADDR_008F3B           ; /  
                    INC.W $18E4               ; Increase lives by 1 
                    LDA.W $0DBF               ; \  
                    SEC                       ;  |Decrease coins by 100 
                    SBC.B #$64                ;  | 
                    STA.W $0DBF               ; /  
ADDR_008F3B:        LDA.W $0DBE               ; \ If amount of lives is negative, 
                    BMI ADDR_008F49           ; / branch to $8F49 
                    CMP.B #$62                ; \ If amount of lives is less than 98, 
                    BCC ADDR_008F49           ; / branch to $8F49 
                    LDA.B #$62                ; \ Set amount of lives to 98 
                    STA.W $0DBE               ; /  
ADDR_008F49:        LDA.W $0DBE               ; \  
                    INC A                     ;  |Get amount of lives in decimal 
                    JSR.W HexToDec            ; /  
                    TXY                       ; \  
                    BNE ADDR_008F55           ;  |If 10s is 0, replace with space 
                    LDX.B #$FC                ;  | 
ADDR_008F55:        STX.W $0F16               ; \ Write lives to status bar 
                    STA.W $0F17               ; /  
                    LDX.W $0DB3               ; \ Get bonus stars 
                    LDA.W $0F48,X             ; /  
                    CMP.B #$64                ; \ If bonus stars is less than 100, 
                    BCC ADDR_008F73           ; / branch to $8F73 
                    LDA.B #$FF                ; \ Start bonus game when the level ends 
                    STA.W $1425               ; /  
                    LDA.W $0F48,X             ; \  
                    SEC                       ;  |Subtract bonus stars by 100 
                    SBC.B #$64                ;  | 
                    STA.W $0F48,X             ; /  
ADDR_008F73:        LDA.W $0DBF               ; \ Get amount of coins in decimal 
                    JSR.W HexToDec            ; /  
                    TXY                       ; \ 
                    BNE ADDR_008F7E           ;  |If 10s is 0, replace with space 
                    LDX.B #$FC                ;  | 
ADDR_008F7E:        STA.W $0F14               ; \ Write coins to status bar 
                    STX.W $0F13               ; /  
                    SEP #$20                  ; 8 bit A ; Accum (8 bit) 
                    LDX.W $0DB3               ; Load Character into X 
                    STZ $00                   
                    STZ $01                   
                    STZ $03                   
                    LDA.W $0F48,X             
                    STA $02                   
                    LDX.B #$09                
                    LDY.B #$10                
                    JSR.W ADDR_009051         
                    LDX.B #$00                
ADDR_008F9D:        LDA.W $0F1E,X             
                    BNE ADDR_008FAF           
                    LDA.B #$FC                
                    STA.W $0F1E,X             
                    STA.W $0F03,X             
                    INX                       
                    CPX.B #$01                
                    BNE ADDR_008F9D           
ADDR_008FAF:        LDA.W $0F1E,X             
                    ASL                       
                    TAY                       
                    LDA.W DATA_008E06,Y       
                    STA.W $0F03,X             
                    LDA.W DATA_008E07,Y       
                    STA.W $0F1E,X             
                    INX                       
                    CPX.B #$02                
                    BNE ADDR_008FAF           
                    JSR.W ADDR_009079         
                    LDA.W $0DB3               
                    BEQ ADDR_008FD8           
                    LDX.B #$04                
ADDR_008FCF:        LDA.W DATA_008DF5,X       
                    STA.W $0EF9,X             
                    DEX                       
                    BPL ADDR_008FCF           
ADDR_008FD8:        LDA.W $1422               
                    CMP.B #$05                
                    BCC ADDR_008FE1           
                    LDA.B #$00                
ADDR_008FE1:        DEC A                     
                    STA $00                   
                    LDX.B #$00                
ADDR_008FE6:        LDY.B #$FC                
                    LDA $00                   
                    BMI ADDR_008FEE           
                    LDY.B #$2E                
ADDR_008FEE:        TYA                       
                    STA.W $0EFF,X             
                    DEC $00                   
                    INX                       
                    CPX.B #$04                
                    BNE ADDR_008FE6           
                    RTS                       


DATA_008FFA:        .db $01,$00

DATA_008FFC:        .db $A0,$86,$00,$00,$10,$27,$00,$00
                    .db $E8,$03,$00,$00,$64,$00,$00,$00
                    .db $0A,$00,$00,$00,$01,$00

ADDR_009012:        SEP #$20                  ; 8 bit A ; Accum (8 bit) 
                    STZ.W $0F15,X             
ADDR_009017:        REP #$20                  ; 16 bit A ; Accum (16 bit) 
                    LDA $02                   
                    SEC                       
                    SBC.W DATA_008FFC,Y       
                    STA $06                   
                    LDA $00                   
                    SBC.W DATA_008FFA,Y       
                    STA $04                   
                    BCC ADDR_009039           
                    LDA $06                   
                    STA $02                   
                    LDA $04                   
                    STA $00                   
                    SEP #$20                  ; 8 bit A ; Accum (8 bit) 
                    INC.W $0F15,X             
                    BRA ADDR_009017           
ADDR_009039:        INX                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    CPY.B #$18                
                    BNE ADDR_009012           
                    SEP #$20                  ; 8 bit A ; Accum (8 bit) 
                    RTS                       

HexToDec:           LDX.B #$00                ;  | 
ADDR_009047:        CMP.B #$0A                ;  | 
                    BCC ADDR_009050           ;  |Sets A to 10s of original A 
                    SBC.B #$0A                ;  |Sets X to 1s of original A 
                    INX                       ;  | 
                    BRA ADDR_009047           ;  | 
ADDR_009050:        RTS                       ; /  

ADDR_009051:        SEP #$20                  ; Accum (8 bit) 
                    STZ.W $0F15,X             
ADDR_009056:        REP #$20                  ; Accum (16 bit) 
                    LDA $02                   
                    SEC                       
                    SBC.W DATA_008FFC,Y       
                    STA $06                   
                    BCC ADDR_00906D           
                    LDA $06                   
                    STA $02                   
                    SEP #$20                  ; Accum (8 bit) 
                    INC.W $0F15,X             
                    BRA ADDR_009056           
ADDR_00906D:        INX                       
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    CPY.B #$18                
                    BNE ADDR_009051           
                    SEP #$20                  ; Accum (8 bit) 
                    RTS                       

ADDR_009079:        LDY.B #$E0                
                    BIT.W $0D9B               
                    BVC ADDR_00908E           
                    LDY.B #$00                
                    LDA.W $0D9B               
                    CMP.B #$C1                
                    BEQ ADDR_00908E           
                    LDA.B #$F0                
                    STA.W $0201,Y             
ADDR_00908E:        STY $01                   
                    LDY.W $0DC2               
                    BEQ ADDR_0090D0           
                    LDA.W DATA_008E01,Y       
                    STA $00                   
                    CPY.B #$03                
                    BNE ADDR_0090AB           
                    LDA $13                   
                    LSR                       
                    AND.B #$03                
                    PHY                       
                    TAY                       
                    LDA.W DATA_008DFE,Y       
                    PLY                       
                    STA $00                   
ADDR_0090AB:        LDY $01                   
                    LDA.B #$78                
                    STA.W $0200,Y             
                    LDA.B #$0F                
                    STA.W $0201,Y             
                    LDA.B #$30                
                    ORA $00                   
                    STA.W $0203,Y             
                    LDX.W $0DC2               
                    LDA.W DATA_008DF9,X       
                    STA.W $0202,Y             
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.B #$02                
                    STA.W $0420,Y             
ADDR_0090D0:        RTS                       


DATA_0090D1:        .db $00,$FF,$4D,$4C,$03,$4D,$5D,$FF
                    .db $03,$00,$4C,$03,$04,$15,$00,$02
                    .db $00,$4A,$4E,$FF,$4C,$4B,$4A,$03
                    .db $5F,$05,$04,$03,$02,$00,$FF,$01
                    .db $4A,$5F,$05,$04,$00,$4D,$5D,$03
                    .db $02,$01,$00,$FF,$5B,$14,$5F,$01
                    .db $5E,$FF,$FF,$FF

DATA_009105:        .db $10,$FF,$00,$5C,$13,$00,$5D,$FF
                    .db $03,$00,$5C,$13,$14,$15,$00,$12
                    .db $00,$03,$5E,$FF,$5C,$4B,$5A,$03
                    .db $5F,$05,$14,$13,$12,$10,$FF,$11
                    .db $03,$5F,$05,$14,$00,$00,$5D,$03
                    .db $12,$11,$10,$FF,$5B,$01,$5F,$01
                    .db $5E,$FF,$FF,$FF

DATA_009139:        .db $34,$00,$34,$34,$34,$34,$30,$00
                    .db $34,$34,$34,$34,$74,$34,$34,$34
                    .db $34,$34,$34,$00,$34,$34,$34,$34
                    .db $34,$34,$34,$34,$34,$34,$00,$34
                    .db $34,$34,$34,$34,$34,$34,$34,$34
                    .db $34,$34,$34,$34,$34,$34,$34,$34
                    .db $34

DATA_00916A:        .db $34,$00,$B4,$34,$34,$B4,$F0,$00
                    .db $B4,$B4,$34,$34,$74,$B4,$B4,$34
                    .db $B4,$B4,$34,$00,$34,$B4,$34,$B4
                    .db $B4,$B4,$34,$34,$34,$34,$00,$34
                    .db $B4,$B4,$B4,$34,$B4,$B4,$B4,$B4
                    .db $34,$34,$34,$34,$F4,$B4,$F4,$B4
                    .db $B4

ADDR_00919B:        LDA $71                   
                    CMP.B #$0A                
                    BNE ADDR_0091A6           
                    JSR.W ADDR_00C593         
                    BRA ADDR_0091B0           
ADDR_0091A6:        LDA.W $141A               
                    BNE ADDR_0091B0           
                    LDA.B #$1E                
                    STA.W $0DC0               
ADDR_0091B0:        RTS                       

ADDR_0091B1:        JSR.W ADDR_00A82D         
                    LDX.B #$00                
                    LDA.B #$B0                
                    LDY.W $1425               
                    BEQ ADDR_0091CA           
                    STZ.W $0F31               ; \  
                    STZ.W $0F32               ;  |Set timer to 000 
                    STZ.W $0F33               ; /  
                    LDX.B #$26                
                    LDA.B #$A4                
ADDR_0091CA:        STA $00                   
                    STZ $01                   
                    LDY.B #$70                
ADDR_0091D0:        JSR.W ADDR_0091E9         
                    INX                       
                    CPX.B #$08                
                    BNE ADDR_0091DF           
                    LDA.W $0DB3               
                    BEQ ADDR_0091DF           
                    LDX.B #$0E                
ADDR_0091DF:        TYA                       
                    SEC                       
                    SBC.B #$08                
                    TAY                       
                    BNE ADDR_0091D0           
                    JMP.W ADDR_008494         
ADDR_0091E9:        LDA.W DATA_009139,X       
                    STA.W $030B,Y             
                    LDA.W DATA_00916A,X       
                    STA.W $030F,Y             
                    LDA $00                   
                    STA.W $0308,Y             
                    STA.W $030C,Y             
                    SEC                       
                    SBC.B #$08                
                    STA $00                   
                    BCS ADDR_009206           
                    DEC $01                   
ADDR_009206:        PHY                       
                    TYA                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA $01                   
                    AND.B #$01                
                    STA.W $0462,Y             
                    STA.W $0463,Y             
                    PLY                       
                    LDA.W DATA_0090D1,X       
                    BMI ADDR_00922E           
                    STA.W $030A,Y             
                    LDA.W DATA_009105,X       
                    STA.W $030E,Y             
                    LDA.B #$68                
                    STA.W $0309,Y             
                    LDA.B #$70                
                    STA.W $030D,Y             
ADDR_00922E:        RTS                       

ADDR_00922F:        STZ.W $0703               
                    STZ.W $0704               
                    STZ.W $2121               ; Set "Address for CG-RAM Write" to 0 ; Address for CG-RAM Write
                    LDX.B #$06                
ADDR_00923A:        LDA.W DATA_009249,X       
                    STA.W $4320,X             
                    DEX                       
                    BPL ADDR_00923A           
                    LDA.B #$04                
                    STA.W $420B               ; Regular DMA Channel Enable
                    RTS                       


DATA_009249:        .db $00,$22,$03,$07,$00,$00,$02

ADDR_009250:        LDX.B #$04                
ADDR_009252:        LDA.W DATA_009277,X       
                    STA.W $4370,X             
                    DEX                       
                    BPL ADDR_009252           
                    LDA.B #$00                
                    STA.W $4377               ; Data Bank (H-DMA)
ADDR_009260:        STZ.W $0D9F               ; Disable all HDMA channels 
ADDR_009263:        REP #$10                  ; 16 bit A ; Index (16 bit) 
                    LDX.W #$01BE              ; \  
                    LDA.B #$FF                ;  | 
ADDR_00926A:        STA.W $04A0,X             ;  |Clear "HDMA table for windowing effects" 
                    STZ.W $04A1,X             ;  |...hang on again.  It clears one set of RAM here, but not the same 
                    DEX                       ;  | 
                    DEX                       ;  | 
                    BPL ADDR_00926A           ; /  
                    SEP #$10                  ; \ Set A to 8bit and return ; Index (8 bit) 
                    RTS                       ; /  


DATA_009277:        .db $41,$26,$7C,$92,$00,$F0,$A0,$04
                    .db $F0,$80,$05,$00

ADDR_009283:        JSR.W ADDR_009263         
                    LDA.W $0D9B               
                    LSR                       
                    BCS ADDR_0092A0           
                    REP #$10                  ; Index (16 bit) 
                    LDX.W #$01BE              
WindowHDMAenable:   STZ.W $04A0,X             ; out? 
                    LDA.B #$FF                ; *note to self: ctrl+insert, not shift+insert* 
                    STA.W $04A1,X             ; ...  This is, uh, strange.  It pastes $00FF into the $04A0,x table 
                    INX                       ; instead of $FF00 o_O 
                    INX                       
                    CPX.W #$01C0              
                    BCC WindowHDMAenable      
ADDR_0092A0:        LDA.B #$80                ;  Enable channel 7 in HDMA, disable all other HDMA channels 
                    STA.W $0D9F               ;  $7E:0D9F - H-DMA Channel Enable RAM Mirror 
                    SEP #$10                  ; Index (8 bit) 
                    RTS                       

ADDR_0092A8:        JSR.W ADDR_009263         ; these are somewhat the same subroutine, but also not >_> 
                    REP #$10                  ; Index (16 bit) 
                    LDX.W #$0198              
                    BRA WindowHDMAenable      
ADDR_0092B2:        LDA.B #$58                ; Index (8 bit) 
                    STA.W $04A0               
                    STA.W $04AA               
                    STA.W $04B4               
                    STZ.W $04A9               
                    STZ.W $04B3               
                    STZ.W $04BD               
                    LDX.B #$04                
ADDR_0092C8:        LDA.W DATA_009313,X       
                    STA.W $4350,X             
                    LDA.W DATA_009318,X       
                    STA.W $4360,X             
                    LDA.W DATA_00931D,X       
                    STA.W $4370,X             
                    DEX                       
                    BPL ADDR_0092C8           
                    LDA.B #$00                
                    STA.W $4357               ; Data Bank (H-DMA)
                    STA.W $4367               ; Data Bank (H-DMA)
                    STA.W $4377               ; Data Bank (H-DMA)
                    LDA.B #$E0                
                    STA.W $0D9F               
ADDR_0092ED:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDY.W #$0008              
                    LDX.W #$0014              
ADDR_0092F5:        LDA.W $001A,Y             
                    STA.W $04A1,X             
                    STA.W $04A4,X             
                    LDA.W $1462,Y             
                    STA.W $04A7,X             
                    TXA                       
                    SEC                       
                    SBC.W #$000A              
                    TAX                       
                    DEY                       
                    DEY                       
                    DEY                       
                    DEY                       
                    BPL ADDR_0092F5           
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    RTS                       


DATA_009313:        .db $02,$0D,$A0,$04,$00

DATA_009318:        .db $02,$0F,$AA,$04,$00

DATA_00931D:        .db $02,$11,$B4,$04,$00

GetGameMode:        LDA.W $0100               ; Load game mode 
                    JSL.L ExecutePtr          

Ptrs009329:         .dw ADDR_009391           
                    .dw ADDR_00940F           
                    .dw ADDR_009F6F           
                    .dw ADDR_0096AE           
                    .dw ADDR_009A8B           
                    .dw ADDR_009F6F           
                    .dw ADDR_00941B           
                    .dw GAMEMODE_07           
                    .dw ADDR_009CD1           
                    .dw ADDR_009B1A           
                    .dw ADDR_009DFA           
                    .dw ADDR_009F6F           
                    .dw ADDR_00A087           
                    .dw ADDR_009F6F           
                    .dw ADDR_00A1BE           
                    .dw TmpFade               
                    .dw ADDR_00968E           
                    .dw ADDR_0096D5           
                    .dw GM04Load              
                    .dw TmpFade               
                    .dw ADDR_00A1DA           
                    .dw ADDR_009F6F           
                    .dw ADDR_009750           
                    .dw ADDR_009759           
                    .dw ADDR_009F6F           
                    .dw ADDR_009468           
                    .dw ADDR_009F6F           
                    .dw ADDR_0094FD           
                    .dw ADDR_009F6F           
                    .dw ADDR_009583           
                    .dw ADDR_009F6F           
                    .dw ADDR_0095AB           
                    .dw ADDR_009F6F           
                    .dw ADDR_0095BC           
                    .dw ADDR_009F6F           
                    .dw ADDR_0095C1           
                    .dw ADDR_009F6F           
                    .dw ADDR_00962C           
                    .dw ADDR_009F6F           
                    .dw ADDR_00963D           
                    .dw ADDR_009F7C           
                    .dw ADDR_00968D           

TurnOffIO:          STZ.W $4200               ; Disable NMI ,VIRQ, HIRQ, Joypads ; NMI, V/H Count, and Joypad Enable
                    STZ.W $420C               ; Turn off all HDMA ; H-DMA Channel Enable
                    LDA.B #$80                ; \ 
                    STA.W $2100               ; /Disable Screen ; Screen Display Register
                    RTS                       ; And return 


NintendoPos:        .db $60,$70,$80,$90

NintendoTile:       .db $02,$04,$06,$08

ADDR_009391:        JSR.W ADDR_0085FA         
                    JSR.W SetUpScreen         
                    JSR.W ADDR_00A993         
                    LDY.B #$0C                ; \ Load Nintendo Presents logo 
                    LDX.B #$03                ;  | 
ADDR_00939E:        LDA.W NintendoPos,X       ;  | 
                    STA.W $0200,Y             ;  | 
                    LDA.B #$70                ;  |   <-Y position of logo 
                    STA.W $0201,Y             ;  | 
                    LDA.W NintendoTile,X      ;  | 
                    STA.W $0202,Y             ;  | 
                    LDA.B #$30                ;  | 
                    STA.W $0203,Y             ;  | 
                    DEY                       ;  | 
                    DEY                       ;  | 
                    DEY                       ;  | 
                    DEY                       ;  | 
                    DEX                       ;  | 
                    BPL ADDR_00939E           ; /  
                    LDA.B #$AA                ; \ Related to making the sprites 16x16? 
                    STA.W $0400               ; /  
                    LDA.B #$01                ; \ Play "Bing" sound? 
                    STA.W $1DFC               ; /  
                    LDA.B #$40                ; \ Set timer to x40 
                    STA.W $1DF5               ; /  
ADDR_0093CA:        LDA.B #$0F                ; \ Set brightness to max 
                    STA.W $0DAE               ; /  
                    LDA.B #$01                
                    STA.W $0DAF               
                    STZ.W $192E               ; Sprite palette setting = 0 
                    JSR.W LoadPalette         ; Load the palette 
                    STZ.W $0701               ; \ Black background 
                    STZ.W $0702               ; / 
                    JSR.W ADDR_00922F         
                    STZ.W $1B92               ; Set menu pointer position to 0 
                    LDX.B #$10                ; Enable sprites, disable layers 
                    LDY.B #$04                ; Set Layer 3 to subscreen 
ADDR_0093EA:        LDA.B #$01                
                    STA.W $0D9B               
                    LDA.B #$20                ; CGADSUB = 20 
                    JSR.W ScreenSettings      ; Apply above settings 
ADDR_0093F4:        INC.W $0100               ; Move on to Game Mode 01 
Mode04Finish:       LDA.B #$81                ; \ Enable NMI and joypad, Disable V-count and H-cout 
                    STA.W $4200               ; /  ; NMI, V/H Count, and Joypad Enable
                    RTS                       

ScreenSettings:     STA.W $2131               ; \ Set CGADSUB settings to A ; Add/Subtract Select and Enable
                    STA $40                   ; /  
                    STX.W $212C               ; Set "Background and Object Enable" to X ; Background and Object Enable
                    STY.W $212D               ; Set "Sub Screen Designation" Y ; Sub Screen Designation
                    STZ.W $212E               ; \ Set "Window Mask Designation" for main and sub screen to x00 ; Window Mask Designation for Main Screen
                    STZ.W $212F               ; /  ; Window Mask Designation for Sub Screen
                    RTS                       ; Return 

ADDR_00940F:        DEC.W $1DF5               ; Decrease timer 
                    BNE ADDR_00941A           ; \ If timer is 0: 
                    JSR.W ADDR_00B888         ;  |Jump to sub $B888 
ADDR_009417:        INC.W $0100               ;  |Move on to Game Mode 02 
ADDR_00941A:        RTS                       ; Return 

ADDR_00941B:        JSR.W SetUp0DA0GM4        
                    JSR.W ADDR_009CBE         
                    BEQ ADDR_00942E           
                    LDA.B #$EC                
                    JSR.W ADDR_009440         
                    INC.W $0100               
                    JMP.W ADDR_009C9F         
ADDR_00942E:        DEC.W $1DF5               
                    BNE ADDR_00941A           
                    INC.W $1DF5               
                    LDA.W $1433               
                    CLC                       
                    ADC.B #$04                
                    CMP.B #$F0                
                    BCS ADDR_009417           
ADDR_009440:        STA.W $1433               
ADDR_009443:        JSR.W ADDR_00CA61         
                    LDA.B #$80                ; \  
                    STA $00                   ;  |Store x80 in $00, 
                    LDA.B #$70                ;  |Store x70 in $01 
                    STA $01                   ; /  

Instr00944E:        .db $4C,$88

CutsceneBGCol:      .db $CA

DATA_009451:        .db $02,$00,$04,$01,$00,$06,$04

CutsceneCsPal:      .db $03,$06,$05,$06,$03,$03,$06,$06
DATA_009460:        .db $03,$FF,$FF,$C9,$0F,$FF,$CC,$C9

ADDR_009468:        JSR.W ADDR_0085FA         
                    JSR.W Clear_1A_13D3       
                    JSR.W SetUpScreen         
                    LDX.W $13C6               ; Cutscene number 
                    LDA.B #$18                
                    STA.W $1931               
                    LDA.B #$14                
                    STA.W $192B               
                    LDA.W CutsceneBGCol,X     
                    STA.W $192F               
                    LDA.W CutsceneCsPal,X     
                    STA.W $1930               
                    STZ.W $192E               
                    LDA.B #$01                
                    STA.W $192D               
                    CPX.B #$08                
                    BNE ADDR_0094B2           
                    JSR.W ADDR_00955E         
                    LDA.B #$D2                
                    STA $12                   
                    JSR.W LoadScrnImage       
                    JSR.W ADDR_008159         
                    JSL.L ADDR_0C93DD         
                    JSR.W ADDR_009260         
                    INC.W $1931               
                    INC.W $192B               
                    BRA ADDR_0094D7           
ADDR_0094B2:        LDA.B #$15                
                    STA.W $1DFB               
                    LDA.W DATA_009460,X       
                    STA $12                   
                    JSR.W LoadScrnImage       
                    LDA.B #$CF                
                    STA $12                   
                    JSR.W LoadScrnImage       
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W #$0090              
                    STA $94                   
                    LDA.W #$0058              
                    STA $96                   
                    SEP #$20                  ; Accum (8 bit) 
                    INC.W $148F               
ADDR_0094D7:        JSR.W UploadSpriteGFX     
                    JSR.W LoadPalette         
                    JSR.W ADDR_00922F         
                    LDX.B #$0B                
ADDR_0094E2:        STZ $1A,X                 
                    DEX                       
                    BPL ADDR_0094E2           
                    LDA.B #$20                
                    STA $64                   
                    JSR.W ADDR_00A635         
                    STZ $76                   
                    STZ $72                   
                    JSL.L ADDR_00CEB1         
                    LDX.B #$17                
                    LDY.B #$00                
                    JSR.W ADDR_009622         
ADDR_0094FD:        JSL.L $7F8000             
                    LDA.W $13C6               
                    CMP.B #$08                
                    BEQ ADDR_009557           
                    LDA $17                   
                    AND.B #$00                
                    CMP.B #$30                
                    BNE ADDR_009529           
                    LDA $15                   
                    AND.B #$08                
                    BEQ ADDR_009523           
                    LDA.W $13C6               
                    INC A                     
                    CMP.B #$09                
                    BCC ADDR_009520           
                    LDA.B #$01                
ADDR_009520:        STA.W $13C6               
ADDR_009523:        LDA.B #$18                
                    STA.W $0100               
                    RTS                       

ADDR_009529:        JSL.L ADDR_0CC97E         
                    REP #$20                  ; Accum (16 bit) 
                    LDA $1A                   
                    PHA                       
                    LDA $1C                   
                    PHA                       
                    LDA $1E                   
                    STA $1A                   
                    LDA $20                   
                    STA $1C                   
                    SEP #$20                  ; Accum (8 bit) 
                    JSL.L ADDR_00E2BD         
                    REP #$20                  ; Accum (16 bit) 
                    PLA                       
                    STA $1C                   
                    PLA                       
                    STA $1A                   
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.B #$0C                
                    STA $71                   
                    JSR.W ADDR_00C47E         
                    JMP.W ADDR_008494         
ADDR_009557:        JSL.L ADDR_0C938D         
                    JMP.W ADDR_008494         
ADDR_00955E:        LDY.B #$2F                
                    JSL.L ADDR_00BA28         
                    LDA.B #$80                
                    STA.W $2115               ; VRAM Address Increment Value
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.W #$4600              
                    STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDX.W #$0200              
ADDR_009574:        LDA [$00]                 
                    STA.W $2118               ; Data for VRAM Write (Low Byte)
                    INC $00                   
                    INC $00                   
                    DEX                       
                    BNE ADDR_009574           
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    RTS                       

ADDR_009583:        INC.W $13C6               
                    LDA.B #$28                
                    LDY.B #$01                
                    JSR.W ADDR_0096CF         
                    DEC.W $0100               
                    LDA.B #$16                
                    STA.W $192B               
                    JSR.W GM04Load            
                    DEC.W $0100               
                    JSR.W TurnOffIO           
                    JSR.W ADDR_0085FA         
                    JSR.W ADDR_00A993         
                    JSL.L ADDR_0CA3C9         
                    JSR.W ADDR_00961E         
ADDR_0095AB:        JSL.L $7F8000             
                    JSL.L ADDR_0C939A         
                    INC $14                   
                    JSL.L ADDR_05BB39         
                    JMP.W ADDR_008494         
ADDR_0095BC:        JSL.L ADDR_0C93AD         
                    RTS                       

ADDR_0095C1:        JSR.W ADDR_0085FA         
                    JSR.W Clear_1A_13D3       
                    JSR.W SetUpScreen         
                    JSL.L ADDR_0CAD8C         
                    JSL.L ADDR_05801E         
                    LDA.W $1DE9               
                    CMP.B #$0A                
                    BNE ADDR_0095E0           
                    LDA.B #$13                
                    STA.W $192B               
                    BRA ADDR_0095E9           
ADDR_0095E0:        CMP.B #$0C                
                    BNE ADDR_0095E9           
                    LDA.B #$17                
                    STA.W $192B               
ADDR_0095E9:        JSR.W UploadSpriteGFX     
                    JSR.W LoadPalette         
                    JSL.L ADDR_05809E         
                    JSR.W ADDR_00A5F9         
                    JSL.L ADDR_0CADF6         
                    LDA.W $1DE9               
                    CMP.B #$0C                
                    BNE ADDR_009612           
                    LDX.B #$0B                
ADDR_009603:        LDA.W DATA_00B3C0,X       
                    STA.W $0807,X             
                    LDA.W DATA_00B3CC,X       
                    STA.W $0827,X             
                    DEX                       
                    BPL ADDR_009603           
ADDR_009612:        JSR.W ADDR_00922F         
                    JSR.W ADDR_0092B2         
                    JSR.W LoadScrnImage       
                    JSR.W ADDR_00962C         
ADDR_00961E:        LDX.B #$15                
                    LDY.B #$02                
ADDR_009622:        JSR.W KeepModeActive      
                    LDA.B #$09                
                    STA $3E                   
                    JMP.W ADDR_0093EA         
ADDR_00962C:        STZ.W $0D84               
                    JSR.W ADDR_0092ED         
                    JSL.L $7F8000             
                    JSL.L ADDR_0C93A5         
                    JMP.W ADDR_008494         
ADDR_00963D:        JSR.W ADDR_0085FA         
                    JSR.W Clear_1A_13D3       
                    JSR.W SetUpScreen         
                    JSR.W ADDR_00955E         
                    LDA.B #$19                
                    STA.W $192B               
                    LDA.B #$03                
                    STA.W $192F               
                    LDA.B #$03                
                    STA.W $1930               
                    JSR.W UploadSpriteGFX     
                    JSR.W LoadPalette         
                    LDX.B #$0B                
ADDR_009660:        LDA.W DATA_00B70E,X       
                    STA.W $08A7,X             
                    LDA.W DATA_00B71A,X       
                    STA.W $08C7,X             
                    LDA.W DATA_00B726,X       
                    STA.W $08E7,X             
                    DEX                       
                    BPL ADDR_009660           
                    JSR.W ADDR_00922F         
                    LDA.B #$D5                
                    STA $12                   
                    JSR.W LoadScrnImage       
                    JSL.L ADDR_0CAADF         
                    JSR.W ADDR_008494         
                    LDX.B #$14                
                    LDY.B #$00                
                    JMP.W ADDR_009622         
ADDR_00968D:        RTS                       

ADDR_00968E:        JSR.W ADDR_0085FA         
                    LDA.W $1425               
                    BNE ADDR_0096A8           
                    LDA.W $141A               
                    ORA.W $141D               
                    ORA.W $0109               
                    BNE ADDR_0096AB           
                    LDA.W $13C1               
                    CMP.B #$56                
                    BEQ ADDR_0096AB           
ADDR_0096A8:        JSR.W ADDR_0091B1         
ADDR_0096AB:        JMP.W ADDR_0093CA         
ADDR_0096AE:        STZ.W $4200               ; NMI, V/H Count, and Joypad Enable
                    JSR.W ClearStack          
                    LDX.B #$07                
                    LDA.B #$FF                
ADDR_0096B8:        STA.W $0101,X             
                    DEX                       
                    BPL ADDR_0096B8           
                    LDA.W $0109               
                    BNE ADDR_0096CB           
                    JSR.W UploadMusicBank2    
                    LDA.B #$01                
                    STA.W $1DFB               
ADDR_0096CB:        LDA.B #$EB                
                    LDY.B #$00                
ADDR_0096CF:        STA.W $0109               
                    STY.W $1F11               
ADDR_0096D5:        STZ.W $4200               ; NMI, V/H Count, and Joypad Enable
                    JSR.W NoButtons           
                    LDA.W $141A               
                    BNE ADDR_0096E9           
                    LDA.W $141D               
                    BEQ ADDR_0096E9           
                    JSL.L ADDR_04DC09         
ADDR_0096E9:        STZ.W $13D5               
                    STZ.W $13D9               
                    LDA.B #$50                
                    STA.W $13D6               
                    JSL.L ADDR_05D796         
                    LDX.B #$07                
ADDR_0096FA:        LDA $1A,X                 
                    STA.W $1462,X             
                    DEX                       
                    BPL ADDR_0096FA           
                    JSR.W ADDR_008134         
                    JSR.W ADDR_00A635         
                    LDA.B #$20                
                    STA $5E                   
                    JSR.W ADDR_00A796         
                    INC.W $1404               
                    JSL.L ADDR_00F6DB         
                    JSL.L ADDR_05801E         
                    LDA.W $0109               
                    BEQ ADDR_009728           
                    CMP.B #$E9                
                    BNE ADDR_009740           
                    LDA.B #$13                
                    STA.W $0DDA               
ADDR_009728:        LDA.W $0DDA               
                    CMP.B #$40                
                    BCS ADDR_00973B           
                    LDY.W $0D9B               
                    CPY.B #$C1                
                    BNE ADDR_009738           
                    LDA.B #$16                
ADDR_009738:        STA.W $1DFB               
ADDR_00973B:        AND.B #$BF                
                    STA.W $0DDA               
ADDR_009740:        STZ.W $0DAE               
                    STZ.W $0DAF               
                    INC.W $0100               
                    JMP.W Mode04Finish        
ADDR_00974C:        JSR.W HexToDec            
                    RTL                       

ADDR_009750:        JSR.W ADDR_0085FA         
                    JSR.W ADDR_00A82D         
                    JMP.W ADDR_0093CA         
ADDR_009759:        JSL.L $7F8000             
                    LDA.W $143C               
                    BNE ADDR_00978B           
                    DEC.W $143D               
                    BNE ADDR_00978E           
                    LDA.W $0DBE               
                    BPL ADDR_009788           
                    STZ.W $0DC1               
                    LDA.W $0DB4               
                    ORA.W $0DB5               
                    BPL ADDR_009788           
                    LDX.B #$0C                
ADDR_009779:        STZ.W $1F2F,X             
                    STZ.W $0006,X             
                    STZ.W $1FEE,X             
                    DEX                       
                    BPL ADDR_009779           
                    INC.W $13C9               
ADDR_009788:        JMP.W ADDR_009E62         
ADDR_00978B:        SEC                       
                    SBC.B #$04                
ADDR_00978E:        STA.W $143C               
                    CLC                       
                    ADC.B #$A0                
                    STA $00                   
                    ROL $01                   
                    LDX.W $143B               
                    LDY.B #$48                
ADDR_00979D:        CPY.B #$28                
                    BNE ADDR_0097AE           
                    LDA.B #$78                
                    SEC                       
                    SBC.W $143C               
                    STA $00                   
                    ROL                       
                    EOR.B #$01                
                    STA $01                   
ADDR_0097AE:        JSR.W ADDR_0091E9         
                    INX                       
                    TYA                       
                    SEC                       
                    SBC.B #$08                
                    TAY                       
                    BNE ADDR_00979D           
                    JMP.W ADDR_008494         
ADDR_0097BC:        LDA.B #$0F                
                    STA.W $0DAE               ; Set brightness to full (RAM mirror) 
                    STZ.W $0DB0               
                    JSR.W GM++Mosaic          
                    LDA.B #$20                ; \ 
                    STA $38                   ; |Not sure what these bytes are used for yet, unless they're just more  
                    STA $39                   ; /scratch (I find that unlikely) 
                    STZ.W $1888               
                    JSR.W ADDR_0085FA         
                    LDA.B #$FF                
                    STA.W $1931               
                    JSL.L ADDR_03D958         
                    BIT.W $0D9B               
                    BVC ADDR_009801           
                    JSR.W ADDR_009925         
                    LDY.W $13FC               
                    CPY.B #$03                
                    BCC ADDR_0097F1           
                    BNE ADDR_00983B           
                    LDA.B #$18                
                    BRA ADDR_0097FC           
ADDR_0097F1:        LDA.B #$03                
                    STA.W $13F9               
                    LDA.B #$C8                
                    STA $3F                   
                    LDA.B #$12                
ADDR_0097FC:        DEC.W $1931               
                    BRA ADDR_00983D           
ADDR_009801:        JSR.W ADDR_00ADD9         
                    JSR.W ADDR_0092A8         
                    LDX.B #$50                
                    JSR.W ADDR_009A3D         
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W #$0050              
                    STA $94                   
                    LDA.W #$FFD0              
                    STA $96                   
                    STZ $1A                   
                    STZ.W $1462               
                    LDA.W #$FF90              
                    STA $1C                   
                    STA.W $1464               
                    LDA.W #$0080              
                    STA $2A                   
                    LDA.W #$0050              
                    STA $2C                   
                    LDA.W #$0080              
                    STA $3A                   
                    LDA.W #$0010              
                    STA $3C                   
                    SEP #$20                  ; Accum (8 bit) 
ADDR_00983B:        LDA.B #$13                
ADDR_00983D:        STA.W $192B               
                    JSR.W UploadSpriteGFX     
                    LDA.B #$11                
                    STA.W $212E               ; Window Mask Designation for Main Screen
                    STZ.W $212D               ; Sub Screen Designation
                    STZ.W $212F               ; Window Mask Designation for Sub Screen
                    LDA.B #$02                
                    STA $41                   
                    LDA.B #$32                
                    STA $43                   
                    LDA.B #$20                
                    STA $44                   
                    JSR.W GM04DoDMA           
                    JSR.W ADDR_008ACD         
ADDR_009860:        JSL.L ADDR_00E2BD         
                    JSR.W ADDR_00A2F3         
                    JSR.W ADDR_00C593         
                    STZ $7D                   
                    JSL.L ADDR_01808C         
                    JSL.L $7F8000             
                    RTS                       


DATA_009875:        .db $01,$00,$FF,$FF,$40,$00,$C0,$01

ADDR_00987D:        JSR.W ADDR_008ACD         
                    BIT.W $0D9B               
                    BVC ADDR_009888           
                    JMP.W ADDR_009A52         
ADDR_009888:        JSL.L $7F8000             
                    JSL.L ADDR_03C0C6         
                    RTS                       


DATA_009891:        .db $9E,$12,$1E,$12,$9E,$11,$1E,$11
                    .db $1E,$16,$9E,$15,$1E,$15,$9E,$14
                    .db $1E,$14,$9E,$13,$1E,$13,$9E,$16

ADDR_0098A9:        LDA.W $0D9B               ; \  
                    LSR                       ;  |If "Special level" is even, 
                    BCS ADDR_0098E1           ; / branch to $98E1 
                    LDA $14                   
                    LSR                       
                    LSR                       
                    AND.B #$06                
                    TAX                       
                    REP #$20                  ; 16 bit A ; Accum (16 bit) 
                    LDY.B #$80                
                    STY.W $2115               ; VRAM Address Increment Value
                    LDA.W #$1801              
                    STA.W $4320               ; Parameters for DMA Transfer
                    LDA.W #$7800              
                    STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDA.L DATA_05BA39,X       
                    STA.W $4322               ; A Address (Low Byte)
                    LDY.B #$7E                
                    STY.W $4324               ; A Address Bank
                    LDA.W #$0080              
                    STA.W $4325               ; Number Bytes to Transfer (Low Byte) (DMA)
                    LDY.B #$04                
                    STY.W $420B               ; Regular DMA Channel Enable
                    CLC                       
ADDR_0098E1:        REP #$20                  ; 16 bit A ; Accum (16 bit) 
                    LDA.W #$0004              
                    LDY.B #$06                
                    BCC ADDR_0098EF           
                    LDA.W #$0008              
                    LDY.B #$16                
ADDR_0098EF:        STA $00                   
                    LDA.W #$C680              
                    STA $02                   
                    STZ.W $2115               ; VRAM Address Increment Value
                    LDA.W #$1800              
                    STA.W $4320               ; Parameters for DMA Transfer
                    LDX.B #$7E                
                    STX.W $4324               ; A Address Bank
                    LDX.B #$04                
ADDR_009906:        LDA.W DATA_009891,Y       
                    STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDA $02                   
                    STA.W $4322               ; A Address (Low Byte)
                    CLC                       
                    ADC $00                   
                    STA $02                   
                    LDA $00                   
                    STA.W $4325               ; Number Bytes to Transfer (Low Byte) (DMA)
                    STX.W $420B               ; Regular DMA Channel Enable
                    DEY                       
                    DEY                       
                    BPL ADDR_009906           
                    SEP #$20                  ; 8 bit A ; Accum (8 bit) 
                    RTS                       

ADDR_009925:        STZ $97                   
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W #$0020              
                    STA $94                   
                    STZ $1A                   
                    STZ.W $1462               
                    STZ $1C                   
                    STZ.W $1464               
                    LDA.W #$0080              
                    STA $2A                   
                    LDA.W #$00A0              
                    STA $2C                   
                    SEP #$20                  ; Accum (8 bit) 
                    JSR.W ADDR_00AE15         
                    JSL.L ADDR_01808C         
                    LDA.W $0D9B               
                    LSR                       
                    LDX.B #$C0                
                    LDA.B #$A0                
                    BCC ADDR_00995B           
                    STZ.W $1411               
                    JMP.W ADDR_009A17         
ADDR_00995B:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.W $13FC               
                    AND.W #$00FF              
                    ASL                       
                    TAX                       
                    LDY.W #$02C0              
                    LDA.W DATA_00F8E8,X       
                    BPL ADDR_009970           
                    LDY.W #$FB80              
ADDR_009970:        CMP.W #$0012              
                    BNE ADDR_009978           
                    LDY.W #$0320              
ADDR_009978:        STY $00                   
                    LDX.W #$0000              
                    LDA.W #$C05A              
ADDR_009980:        STA.L $7F837D,X           
                    XBA                       
                    CLC                       
                    ADC.W #$0080              
                    XBA                       
                    STA.L $7F8401,X           
                    XBA                       
                    SEC                       
                    SBC $00                   
                    XBA                       
                    STA.L $7F8485,X           
                    LDA.W #$7F00              
                    STA.L $7F837F,X           
                    STA.L $7F8403,X           
                    STA.L $7F8487,X           
                    LDY.W #$0010              
ADDR_0099A9:        LDA.W #$38A2              
                    STA.L $7F8381,X           
                    INC A                     
                    STA.L $7F8383,X           
                    LDA.W #$38B2              
                    STA.L $7F83C1,X           
                    INC A                     
                    STA.L $7F83C3,X           
                    LDA.W #$2C80              
                    STA.L $7F8405,X           
                    INC A                     
                    STA.L $7F8407,X           
                    INC A                     
                    STA.L $7F8445,X           
                    INC A                     
                    STA.L $7F8447,X           
                    LDA.W #$28A0              
                    STA.L $7F8489,X           
                    INC A                     
                    STA.L $7F848B,X           
                    LDA.W #$28B0              
                    STA.L $7F84C9,X           
                    INC A                     
                    STA.L $7F84CB,X           
                    INX                       
                    INX                       
                    INX                       
                    INX                       
                    DEY                       
                    BNE ADDR_0099A9           
                    TXA                       
                    CLC                       
                    ADC.W #$014C              
                    TAX                       
                    LDA.W #$C05E              
                    CPX.W #$0318              
                    BCS ADDR_009A07           
                    JMP.W ADDR_009980         
ADDR_009A07:        LDA.W #$00FF              
                    STA.L $7F837D,X           
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    JSR.W LoadScrnImage       
                    LDX.B #$B0                
                    LDA.B #$90                
ADDR_009A17:        STA $96                   
                    JSR.W ADDR_009A1F         
                    JMP.W ADDR_009283         
ADDR_009A1F:        LDY.B #$10                
                    LDA.B #$32                
ADDR_009A23:        STA.L $7EC800,X           
                    STA.L $7EC9B0,X           
                    STA.L $7FC800,X           
                    STA.L $7FC9B0,X           
                    INX                       
                    DEY                       
                    BNE ADDR_009A23           
                    CPX.B #$C0                
                    BNE ADDR_009A4D           
                    LDX.B #$D0                
ADDR_009A3D:        LDY.B #$10                
                    LDA.B #$05                
ADDR_009A41:        STA.L $7EC800,X           
                    STA.L $7EC9B0,X           
                    INX                       
                    DEY                       
                    BNE ADDR_009A41           
ADDR_009A4D:        RTS                       


DATA_009A4E:        .db $FF,$01,$18,$30

ADDR_009A52:        LDA.W $0D9B               
                    LSR                       
                    BCS ADDR_009A6F           
                    JSL.L ADDR_00F6DB         
                    JSL.L ADDR_05BC00         
                    LDA.W $13FC               
                    CMP.B #$04                
                    BEQ ADDR_009A6F           
                    JSR.W ADDR_0086C7         
                    JSL.L ADDR_02827D         
                    RTS                       

ADDR_009A6F:        JSL.L $7F8000             
                    RTS                       

SetUp0DA0GM4:       LDA.W $4016               ; \Read old-style controller register for player 1 
                    LSR                       ; /LSR A, but then discard (Is this for carry flag or something?) 
                    LDA.W $4017               ; \Load And Rotate left A (player 2 old-style controller regs) 
                    ROL                       ; / 
                    AND.B #$03                ; AND A with #$03 
                    BEQ ADDR_009A87           ; If A AND #$03 = 0 Then STA $0DA0 (A=0) 
                    CMP.B #$03                
                    BNE ADDR_009A86           
                    ORA.B #$80                
ADDR_009A86:        DEC A                     
ADDR_009A87:        STA.W $0DA0               
                    RTS                       ; *yawn* 

ADDR_009A8B:        JSR.W SetUp0DA0GM4        
                    JSR.W GM04Load            
                    STZ.W $0F31               ; Zero the timer 
                    JSR.W ADDR_0085FA         
                    LDA.B #$03                ; \ Load title screen Layer 3 image 
                    STA $12                   ;  | 
                    JSR.W LoadScrnImage       ; /  
                    JSR.W ADDR_00ADA6         
                    JSR.W ADDR_00922F         
                    JSL.L ADDR_04F675         ; todo: NOTE TO SELF: Check this routine out after making Bank4.asm 
                    LDA.B #$01                ; \ Set special level to x01 
                    STA.W $0D9B               ; /  
                    LDA.B #$33                
                    STA $41                   
                    LDA.B #$00                
                    STA $42                   
                    LDA.B #$23                
                    STA $43                   
                    LDA.B #$12                
                    STA $44                   
                    JSR.W ADDR_009443         
                    LDA.B #$10                
                    STA.W $1DF5               

Instr009AC5:        .db $4C,$F7

ADDR_009AC7:        .db $93

DATA_009AC8:        .db $01,$FF,$FF

ADDR_009ACB:        PHY                       
                    JSR.W SetUp0DA0GM4        
                    PLY                       
ADDR_009AD0:        INC.W $1B91               ; Blinking cursor frame counter (file select, save prompt, etc) 
                    JSR.W ADDR_009E82         
                    LDX.W $1B92               
                    LDA $16                   
                    AND.B #$90                
                    BNE ADDR_009AE3           
                    LDA $18                   
                    BPL ADDR_009AEA           
ADDR_009AE3:        LDA.B #$01                
                    STA.W $1DFC               
                    BRA ADDR_009B11           
ADDR_009AEA:        PLA                       
                    PLA                       
                    LDA $16                   
                    AND.B #$20                
                    LSR                       
                    LSR                       
                    LSR                       
                    ORA $16                   
                    AND.B #$0C                
                    BEQ ADDR_009B16           
                    LDY.B #$06                
                    STY.W $1DFC               
                    STZ.W $1B91               
                    LSR                       
                    LSR                       
                    TAY                       
                    TXA                       
                    ADC.W ADDR_009AC7,Y       
                    BPL ADDR_009B0D           
                    LDA $8A                   
                    DEC A                     
ADDR_009B0D:        CMP $8A                   
                    BCC ADDR_009B13           
ADDR_009B11:        LDA.B #$00                
ADDR_009B13:        STA.W $1B92               
ADDR_009B16:        RTS                       


DATA_009B17:        .db $04,$02,$01

ADDR_009B1A:        REP #$20                  ; Accum (16 bit) 
                    LDA.W #$39C9              
                    LDY.B #$60                
                    JSR.W ADDR_009D30         
                    LDA $16                   ; Accum (8 bit) 
                    ORA $18                   
                    AND.B #$40                
                    BEQ ADDR_009B38           
ADDR_009B2C:        DEC.W $0100               
                    DEC.W $0100               
                    JSR.W ADDR_009B11         
                    JMP.W ADDR_009CB0         
ADDR_009B38:        LDY.B #$08                
                    JSR.W ADDR_009AD0         
                    CPX.B #$03                
                    BNE ADDR_009B6D           
                    LDY.B #$02                
ADDR_009B43:        LSR.W $0DDE               
                    BCC ADDR_009B67           
                    PHY                       
                    LDA.W DATA_009CCB,Y       
                    XBA                       
                    LDA.W DATA_009CCE,Y       
                    REP #$10                  ; Index (16 bit) 
                    TAX                       
                    LDY.W #$008F              
                    LDA.B #$00                
ADDR_009B58:        STA.L $700000,X           
                    STA.L $7001AD,X           
                    INX                       
                    DEY                       
                    BNE ADDR_009B58           
                    SEP #$10                  ; Index (8 bit) 
                    PLY                       
ADDR_009B67:        DEY                       
                    BPL ADDR_009B43           
                    JMP.W ADDR_009C89         
ADDR_009B6D:        STX.W $1B92               
                    LDA.W DATA_009B17,X       
                    ORA.W $0DDE               
                    STA.W $0DDE               
                    STA $05                   
                    LDX.B #$00                
                    JMP.W ADDR_009D3C         
ADDR_009B80:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_009B88         
                    PLB                       
                    RTL                       

ADDR_009B88:        DEC A                     
                    JSL.L ExecutePtr          

Ptrs009B8D:         .dw ADDR_009B91           
                    .dw ADDR_009B9A           

ADDR_009B91:        LDY.B #$0C                
                    JSR.W ADDR_009D29         
                    INC.W $13C9               
                    RTS                       

ADDR_009B9A:        LDY.B #$00                
                    JSR.W ADDR_009AD0         
                    TXA                       
                    BNE ADDR_009BA5           
                    JMP.W ADDR_009E17         
ADDR_009BA5:        JMP.W ADDR_009C89         
ADDR_009BA8:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_009BB0         
                    PLB                       
                    RTL                       

ADDR_009BB0:        LDY.B #$06                
                    JSR.W ADDR_009AD0         
                    TXA                       
                    BNE ADDR_009BC4           
                    STZ.W $1DFC               
                    LDA.B #$05                
                    STA.W $1DF9               
                    JSL.L ADDR_009BC9         
ADDR_009BC4:        JSL.L ADDR_009C13         
                    RTS                       

ADDR_009BC9:        PHB                       
                    PHK                       
                    PLB                       
                    LDX.W $010A               
                    LDA.W DATA_009CCB,X       
                    XBA                       
                    LDA.W DATA_009CCE,X       
                    REP #$10                  ; Index (16 bit) 
                    TAX                       
ADDR_009BD9:        LDY.W #$0000              
                    STY $8A                   
ADDR_009BDE:        LDA.W $1F49,Y             
                    STA.L $700000,X           
                    CLC                       
                    ADC $8A                   
                    STA $8A                   
                    BCC ADDR_009BEE           
                    INC $8B                   
ADDR_009BEE:        INX                       
                    INY                       
                    CPY.W #$008D              
                    BCC ADDR_009BDE           
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W #$5A5A              
                    SEC                       
                    SBC $8A                   
                    STA.L $700000,X           
                    CPX.W #$01AD              
                    BCS ADDR_009C0F           
                    TXA                       
                    ADC.W #$0120              
                    TAX                       
                    SEP #$20                  ; Accum (8 bit) 
                    BRA ADDR_009BD9           
ADDR_009C0F:        SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    PLB                       
                    RTL                       

ADDR_009C13:        INC.W $1B87               
                    INC.W $1B88               
                    LDY.B #$1B                

Instr009C1B:        .db $20,$29

ADDR_009C1D:        .db $9D

                    RTL                       


DATA_009C1F:        .db $41

ItrCntrlrSqnc:      .db $0F,$C1,$30,$00,$10,$42,$20,$41
                    .db $70,$81,$11,$00,$80,$82,$0C,$00
                    .db $30,$C1,$30,$41,$60,$C1,$10,$00
                    .db $40,$01,$30,$E1,$01,$00,$60,$41
                    .db $4E,$80,$10,$00,$30,$41,$58,$00
                    .db $20,$60,$01,$00,$30,$60,$01,$00
                    .db $30,$60,$01,$00,$30,$60,$01,$00
                    .db $30,$60,$01,$00,$30,$41,$1A,$C1
                    .db $30,$00,$30,$FF

GAMEMODE_07:        JSR.W SetUp0DA0GM4        
                    JSR.W ADDR_009CBE         
                    BNE ADDR_009C9F           
                    JSR.W NoButtons           ; Zero controller RAM mirror 
                    LDX.W $1DF4               ; (Unknown byte) -> X 
                    DEC.W $1DF5               ; Decrement $1DF5 (unknown byte) 
                    BNE ADDR_009C82           ; if !=  0 branch forward 
                    LDA.W ItrCntrlrSqnc,X     ; Load $00/9C20,$1DF4 
                    STA.W $1DF5               ; And store to $1DF5 
                    INX                       
                    INX                       ; $1DF4+=2 
                    STX.W $1DF4               
ADDR_009C82:        LDA.W ADDR_009C1D,X       ; With the +=2 above, this is effectively LDA $9C20,$1DF4 
                    CMP.B #$FF                
                    BNE ADDR_009C8F           
ADDR_009C89:        LDY.B #$02                ; If = #$FF, switch to game mode #$02... 
ADDR_009C8B:        STY.W $0100               
                    RTS                       ; ...And finish 

ADDR_009C8F:        AND.B #$DF                
                    STA $15                   ; Write to controller RAM byte 01 
                    CMP.W ADDR_009C1D,X       
                    BNE ADDR_009C9A           
                    AND.B #$9F                
ADDR_009C9A:        STA $16                   ; Write to byte 01, Just-pressed variant 
                    JMP.W ADDR_00A1DA         ; Jump to another section of this routine 
ADDR_009C9F:        JSL.L $7F8000             ; IIRC, this contains a lot of STZ instructions 
                    LDA.B #$04                
                    STA.W $212C               ; Zero something related to PPU ; Background and Object Enable
                    LDA.B #$13                
                    STA.W $212D               ; Sub Screen Designation
                    STZ.W $0D9F               ; Disable all HDMA 
ADDR_009CB0:        LDA.B #$E9                
                    STA.W $0109               ; #$E9 -> Uknown RAM byte 
                    JSR.W CODE_WRITEOW        
                    JSR.W ADDR_009D38         ; -> here 
                    JMP.W ADDR_009417         ; Increase the Game mode and return (at jump point) 
ADDR_009CBE:        LDA $17                   
                    AND.B #$C0                
                    BNE ADDR_009CCA           
                    LDA $15                   
                    AND.B #$F0                
                    BNE ADDR_009CCA           
ADDR_009CCA:        RTS                       


DATA_009CCB:        .db $00,$00,$01

DATA_009CCE:        .db $00,$8F,$1E

ADDR_009CD1:        REP #$20                  ; 16 bit A ; Accum (16 bit) 
                    LDA.W #$7393              
                    LDY.B #$20                
                    JSR.W ADDR_009D30         
                    LDY.B #$02                
                    JSR.W ADDR_009ACB         
                    INC.W $0100               
                    CPX.B #$03                
                    BNE ADDR_009CEF           
                    STZ.W $0DDE               
                    LDX.B #$00                
                    JMP.W ADDR_009D3A         
ADDR_009CEF:        STX.W $010A               ; Index (16 bit) Accum (8 bit) 
                    JSR.W ADDR_009DB5         
                    BNE ADDR_009D22           
                    PHX                       
                    STZ.W $0109               
                    LDA.B #$8F                
                    STA $00                   
ADDR_009CFF:        LDA.L $700000,X           
                    PHX                       
                    TYX                       
                    STA.L $700000,X           
                    PLX                       
                    INX                       
                    INY                       
                    DEC $00                   
                    BNE ADDR_009CFF           
                    PLX                       
                    LDY.W #$0000              
ADDR_009D14:        LDA.L $700000,X           
                    STA.W $1F49,Y             
                    INX                       
                    INY                       
                    CPY.W #$008D              
                    BCC ADDR_009D14           
ADDR_009D22:        SEP #$10                  ; Index (8 bit) 
                    LDY.B #$12                ; \ Draw 1 PLAYER GAME/2 PLAYER GAME text 
                    INC.W $0100               ;  |Increase Game Mode 
ADDR_009D29:        STY $12                   ; /  
                    LDX.B #$00                
                    JMP.W ADDR_009ED4         
ADDR_009D30:        STA.W $0701               ; Store A in BG color 
                    STY $40                   ; Store Y in CGADSUB 
                    SEP #$20                  ; 8 bit A ; Accum (8 bit) 
                    RTS                       

ADDR_009D38:        LDX.B #$CB                
ADDR_009D3A:        STZ $05                   
ADDR_009D3C:        REP #$10                  ; Index (16 bit) 
                    LDY.W #$0000              
ADDR_009D41:        LDA.L DATA_05B6FE,X       ; X =  read index 
                    PHX                       ; Y = write index 
                    TYX                       
                    STA.L $7F837D,X           ; Layer 3-related table 
                    PLX                       
                    INX                       
                    INY                       
                    CPY.W #$00CC              ; If not at end of loop, continue 
                    BNE ADDR_009D41           
                    SEP #$10                  ; Index (8 bit) 
                    LDA.B #$84                
                    STA $00                   
                    LDX.B #$02                
ADDR_009D5B:        STX $04                   
                    LSR $05                   ;  $05 = $05 / 2 
                    BCS ADDR_009DA6           
                    JSR.W ADDR_009DB5         
                    BNE ADDR_009DA6           
                    LDA.L $70008C,X           
                    SEP #$10                  ; Index (8 bit) 
                    CMP.B #$60                
                    BCC ADDR_009D76           
                    LDY.B #$87                
                    LDA.B #$88                
                    BRA ADDR_009D7A           
ADDR_009D76:        JSR.W HexToDec            
                    TXY                       
ADDR_009D7A:        LDX $00                   
                    STA.L $7F8381,X           
                    TYA                       
                    BNE ADDR_009D85           
                    LDY.B #$FC                
ADDR_009D85:        TYA                       
                    STA.L $7F837F,X           
                    LDA.B #$38                
                    STA.L $7F8380,X           
                    STA.L $7F8382,X           
                    REP #$20                  ; Accum (16 bit) 
                    LDY.B #$03                
ADDR_009D98:        LDA.W #$38FC              
                    STA.L $7F8383,X           
                    INX                       
                    INX                       
                    DEY                       
                    BNE ADDR_009D98           
                    SEP #$20                  ; Accum (8 bit) 
ADDR_009DA6:        SEP #$10                  ; Index (8 bit) 
                    LDA $00                   
                    SEC                       
                    SBC.B #$24                
                    STA $00                   
                    LDX $04                   
                    DEX                       
                    BPL ADDR_009D5B           
                    RTS                       

ADDR_009DB5:        LDA.W DATA_009CCB,X       
                    XBA                       
                    LDA.W DATA_009CCE,X       
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    TAX                       
                    CLC                       
                    ADC.W #$01AD              
                    TAY                       
ADDR_009DC4:        PHX                       
                    PHY                       
                    LDA.L $70008D,X           
                    STA $8A                   
                    SEP #$20                  ; Accum (8 bit) 
                    LDY.W #$008D              
ADDR_009DD1:        LDA.L $700000,X           
                    CLC                       
                    ADC $8A                   
                    STA $8A                   
                    BCC ADDR_009DDE           
                    INC $8B                   
ADDR_009DDE:        INX                       
                    DEY                       
                    BNE ADDR_009DD1           
                    REP #$20                  ; Accum (16 bit) 
                    PLY                       
                    PLX                       
                    LDA $8A                   
                    CMP.W #$5A5A              
                    BEQ ADDR_009DF7           
                    CPX.W #$01AC              
                    BCS ADDR_009DF7           
                    PHX                       
                    TYX                       
                    PLY                       
                    BRA ADDR_009DC4           
ADDR_009DF7:        SEP #$20                  ; Accum (8 bit) 
                    RTS                       

ADDR_009DFA:        LDA $16                   ; Index (8 bit) 
                    ORA $18                   
                    AND.B #$40                
                    BEQ ADDR_009E08           
                    DEC.W $0100               
                    JMP.W ADDR_009B2C         
ADDR_009E08:        LDY.B #$04                
                    JSR.W ADDR_009ACB         
                    STX.W $0DB2               
                    JSR.W ADDR_00A195         
                    JSL.L ADDR_04DAAD         
ADDR_009E17:        LDA.B #$80                
                    STA.W $1DFB               
                    LDA.B #$FF                
                    STA.W $0DB5               
                    LDX.W $0DB2               
                    LDA.B #$04                
ADDR_009E26:        STA.W $0DB4,X             
                    DEX                       
                    BPL ADDR_009E26           
                    STA.W $0DBE               
                    STZ.W $0DBF               
                    STZ.W $0DC1               
                    STZ $19                   
                    STZ.W $0DC2               
                    STZ.W $13C9               
                    REP #$20                  ; Accum (16 bit) 
                    STZ.W $0DB6               
                    STZ.W $0DB8               
                    STZ.W $0DBA               
                    STZ.W $0DC2               
                    STZ.W $0F48               
                    STZ.W $0F34               
                    STZ.W $0F37               
                    SEP #$20                  ; Accum (8 bit) 
                    STZ.W $0F36               
                    STZ.W $0F39               
                    STZ.W $0DD5               
                    STZ.W $0DB3               
ADDR_009E62:        JSR.W KeepModeActive      
                    LDY.B #$0B                
                    JMP.W ADDR_009C8B         

DATA_009E6A:        .db $02,$00,$04,$00,$02,$00,$02,$00
                    .db $04,$00

DATA_009E74:        .db $CB,$51,$E8,$51,$08,$52,$C4,$51
                    .db $E5,$51

DATA_009E7E:        .db $01,$02,$04,$08

ADDR_009E82:        LDX.W $1B92               
                    LDA.W DATA_009E7E,X       
                    TAX                       
                    LDA.W $1B91               
                    EOR.B #$1F                
                    AND.B #$18                
                    BNE ADDR_009E94           
                    LDX.B #$00                
ADDR_009E94:        STX $00                   
                    LDA.L $7F837B             
                    TAX                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W DATA_009E6A,Y       
                    STA $8A                   
                    STA $02                   
                    LDA.W DATA_009E74,Y       
ADDR_009EA7:        XBA                       
                    STA.L $7F837D,X           
                    XBA                       
                    CLC                       
                    ADC.W #$0040              
                    PHA                       
                    LDA.W #$0100              
                    STA.L $7F837F,X           
                    LDA.W #$38FC              
                    LSR $00                   
                    BCC ADDR_009EC3           
                    LDA.W #$3D2E              
ADDR_009EC3:        STA.L $7F8381,X           
                    PLA                       
                    INX                       
                    INX                       
                    INX                       
                    INX                       
                    INX                       
                    INX                       
                    DEC $02                   
                    BNE ADDR_009EA7           
                    SEP #$20                  ; Accum (8 bit) 
ADDR_009ED4:        TXA                       
                    STA.L $7F837B             
                    LDA.B #$FF                
                    STA.L $7F837D,X           
                    RTS                       


TBL_009EE0:         .db $28

DATA_009EE1:        .db $03,$4D,$01,$52,$01,$53,$01,$5B
                    .db $08,$5C,$02,$57,$04,$30,$01

TBL_009EF0:         .db $01,$01,$02,$00,$02,$00,$68,$00
                    .db $78,$00,$68,$00,$78,$00,$06,$00
                    .db $07,$00,$06,$00,$07,$00

CODE_WRITEOW:       LDX.B #$8D                ; Index (8 bit) 
ADDR_009F08:        STZ.W $1F48,X             
                    DEX                       
                    BNE ADDR_009F08           
                    LDX.B #$0E                
ADDR_009F10:        LDY.W TBL_009EE0,X        ; \ 
                    LDA.W DATA_009EE1,X       ; |Write overworld settings to OW L1 table 
                    STA.W $1F49,Y             ; / 
                    DEX                       
                    DEX                       
                    BPL ADDR_009F10           
                    LDX.B #$15                
ADDR_009F1F:        LDA.W TBL_009EF0,X        
                    STA.W $1FB8,X             ; <- This probably means that the table above ends at 1FB7 
                    DEX                       
                    BPL ADDR_009F1F           
                    RTS                       

KeepModeActive:     LDA.B #$01                
ADDR_009F2B:        STA.W $0DB1               
                    RTS                       


DATA_009F2F:        .db $01,$FF

DATA_009F31:        .db $F0,$10

DATA_009F33:        .db $0F,$00,$00,$F0

TmpFade:            DEC.W $0DB1               ; \If 0DB1 = 0 Then Exit Ssub 
                    BPL ADDR_009F6E           ; /Decrease it either way. 
                    JSR.W KeepModeActive      ; #$01 -> $0DB1 
                    LDY.W $0DAF               
                    LDA.W $0DB0               ; \  
                    CLC                       ;  |Increase $0DB0 (mosaic size) by $9F31,y 
                    ADC.W DATA_009F31,Y       ;  | 
                    STA.W $0DB0               ; /  
ADDR_009F4C:        LDA.W $0DAE               ; Load Brightness byte from RAM 
                    CLC                       ; \Add $9F2F,Y 
                    ADC.W DATA_009F2F,Y       ; / 
                    STA.W $0DAE               ; Store back to brightness RAM byte 
                    CMP.W DATA_009F33,Y       
                    BNE ADDR_009F66           
GM++Mosaic:         INC.W $0100               ; Game Mode += 1 
                    LDA.W $0DAF               ; \  
                    EOR.B #$01                ;  |$0DAF = $0DAF XOR 1 
                    STA.W $0DAF               ; /  
ADDR_009F66:        LDA.B #$03                ; \  
                    ORA.W $0DB0               ;  |Set mosaic size to $0DB0, enable mosaic on Layer 1 and 2. 
                    STA.W $2106               ; /  ; Mosaic Size and BG Enable
ADDR_009F6E:        RTS                       ; I think we're done here 

ADDR_009F6F:        DEC.W $0DB1               ; Decrement something...  Seems like it might be a timing counter ; Index (8 bit) 
                    BPL ADDR_009F6E           ; If positive, return from subroutine. 
                    JSR.W KeepModeActive      ; Remain in this mode 
ADDR_009F77:        LDY.W $0DAF               ; $0DAF -> Y, 
                    BRA ADDR_009F4C           ; BRA to the fade control routine 
ADDR_009F7C:        DEC.W $0DB1               
                    BPL ADDR_009F6E           
                    LDA.B #$08                
                    JSR.W ADDR_009F2B         
                    BRA ADDR_009F77           

DATA_009F88:        .db $01,$02,$C0,$01,$80,$81,$01,$02
                    .db $C0,$01,$02,$81,$01,$02,$80,$01
                    .db $02,$81,$01,$02,$81,$01,$02,$C0
                    .db $01,$02,$C0,$01,$02,$81,$01,$02
                    .db $80,$01,$02,$80,$01,$02,$80,$01
                    .db $02,$81,$01,$02,$81,$01,$02,$80

ADDR_009FB8:        LDA.W $1931               ; \  
                    ASL                       ;  |Get (Tileset*3), store in $00 
                    CLC                       ;  | 
                    ADC.W $1931               ;  | 
                    STA $00                   ; /  
                    LDA.W $1BE3               
                    BEQ ADDR_00A012           
                    DEC A                     
                    CLC                       
                    ADC $00                   
                    TAX                       
                    LDA.W DATA_009F88,X       
                    BMI ADDR_009FEA           
                    STA.W $1403               
                    LSR                       
                    PHP                       
                    JSR.W ADDR_00A045         
                    LDA.B #$70                
                    PLP                       
                    BEQ ADDR_009FE0           
                    LDA.B #$40                
ADDR_009FE0:        STA $24                   
                    STZ $25                   
                    JSL.L ADDR_05BC72         
                    BRA ADDR_00A01B           
ADDR_009FEA:        ASL                       
                    BMI ADDR_00A012           
                    BEQ ADDR_00A007           
                    LDA.W $1931               
                    CMP.B #$01                
                    BEQ ADDR_009FFA           
                    CMP.B #$03                
                    BNE ADDR_00A01F           
ADDR_009FFA:        REP #$20                  ; Accum (16 bit) 
                    LDA $1A                   
                    LSR                       
                    STA $22                   
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.B #$C0                
                    BRA ADDR_00A017           
ADDR_00A007:        LDX.B #$07                
ADDR_00A009:        LDA.W DATA_00B66C,X       
                    STA.W $071B,X             
                    DEX                       
                    BPL ADDR_00A009           
ADDR_00A012:        INC.W $13D5               
                    LDA.B #$D0                
ADDR_00A017:        STA $24                   
                    STZ $25                   
ADDR_00A01B:        LDA.B #$04                
                    TRB $40                   
ADDR_00A01F:        LDA.W $1BE3               
                    BEQ ADDR_00A044           
                    DEC A                     
                    CLC                       
                    ADC $00                   
                    STA $01                   
                    ASL                       
                    CLC                       
                    ADC $01                   
                    TAX                       
                    LDA.L DATA_059000,X       
                    STA $00                   
                    LDA.L DATA_059001,X       
                    STA $01                   
                    LDA.L DATA_059002,X       
                    STA $02                   
                    JSR.W ADDR_00871E         
ADDR_00A044:        RTS                       

ADDR_00A045:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDX.W #$0100              
ADDR_00A04A:        LDY.W #$0058              
                    LDA.W #$0000              
ADDR_00A050:        STA.L $7EE300,X           
                    INX                       
                    INX                       
                    DEY                       
                    BNE ADDR_00A050           
                    TXA                       
                    CLC                       
                    ADC.W #$0100              
                    TAX                       
                    CPX.W #$1B00              
                    BCC ADDR_00A04A           
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDA.B #$80                
                    TSB $5B                   
                    RTS                       


DATA_00A06B:        .db $00,$00,$EF,$FF,$EF,$FF,$EF,$FF
                    .db $F0,$00,$F0,$00,$F0,$00

DATA_00A079:        .db $00,$00,$D8,$FF,$80,$00,$28,$01
                    .db $D8,$FF,$80,$00,$28,$01

ADDR_00A087:        JSR.W TurnOffIO           
                    LDA.W $1B9C               
                    BEQ ADDR_00A093           
                    JSL.L ADDR_04853B         
ADDR_00A093:        JSR.W Clear_1A_13D3       
                    LDA.W $0109               
                    BEQ ADDR_00A0B0           
                    LDA.B #$B0                
                    STA.W $1DF5               
                    STZ.W $1F11               
                    LDA.B #$F0                
                    STA.W $0DB0               
                    LDA.B #$10                
                    STA.W $0100               
                    JMP.W Mode04Finish        
ADDR_00A0B0:        JSR.W ADDR_0085FA         
                    JSR.W UploadMusicBank2    
                    JSR.W SetUpScreen         
                    STZ.W $0DDA               
                    LDX.W $0DB3               
                    LDA.W $0DBE               
                    BPL ADDR_00A0C7           
                    INC.W $1B87               
ADDR_00A0C7:        STA.W $0DB4,X             
                    LDA $19                   
                    STA.W $0DB8,X             
                    LDA.W $0DBF               
                    STA.W $0DB6,X             
                    LDA.W $0DC1               
                    BEQ ADDR_00A0DD           
                    LDA.W $13C7               
ADDR_00A0DD:        STA.W $0DBA,X             
                    LDA.W $0DC2               
                    STA.W $0DBC,X             
                    LDA.B #$03                
                    STA $44                   
                    LDA.B #$30                
                    LDX.B #$15                
                    LDY.W $13C9               
                    BEQ ADDR_00A11B           
                    JSR.W ADDR_00A195         
                    LDA.W $1F2E               
                    BNE ADDR_00A101           
                    JSR.W ADDR_009C89         
                    JMP.W ADDR_0093F4         
ADDR_00A101:        JSL.L ADDR_04DAAD         
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W #$318C              
                    STA.W $0701               
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.B #$30                
                    STA $43                   
                    LDA.B #$20                
                    STA $44                   
                    LDA.B #$B3                
                    LDX.B #$17                
ADDR_00A11B:        LDY.B #$02                
                    JSR.W ScreenSettings      
                    STX.W $212E               ; Window Mask Designation for Main Screen
                    STY.W $212F               ; Window Mask Designation for Sub Screen
                    JSL.L ADDR_04DC09         
                    LDX.W $0DB3               
                    LDA.W $1F11,X             
                    ASL                       
                    TAX                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W DATA_00A06B,X       
                    STA $1A                   
                    STA $1E                   
                    LDA.W DATA_00A079,X       
                    STA $1C                   
                    STA $20                   
                    SEP #$20                  ; Accum (8 bit) 
                    JSR.W UploadSpriteGFX     
                    LDY.B #$14                
                    JSL.L ADDR_00BA28         
                    JSR.W ADDR_00AD25         
                    JSR.W ADDR_00922F         
                    LDA.B #$06                ; \ Load overworld border 
                    STA $12                   ;  | 
                    JSR.W LoadScrnImage       ; /  
                    JSL.L ADDR_05DBF2         
                    JSR.W LoadScrnImage       
                    JSL.L ADDR_048D91         
                    JSL.L ADDR_04D6E9         
                    LDA.B #$F0                
                    STA $3F                   
                    JSR.W ADDR_008494         
                    JSR.W LoadScrnImage       
                    STZ.W $13D9               
                    JSR.W KeepModeActive      
                    LDA.B #$02                
                    STA.W $0D9B               
                    REP #$10                  ; Index (16 bit) 
                    LDX.W #$01BE              
                    LDA.B #$FF                
ADDR_00A185:        STZ.W $04A0,X             
                    STA.W $04A1,X             
                    DEX                       
                    DEX                       
                    BPL ADDR_00A185           
                    JSR.W ADDR_0092A0         
                    JMP.W ADDR_0093F4         
ADDR_00A195:        REP #$10                  ; Index (16 bit) 
                    LDX.W #$008C              
ADDR_00A19A:        LDA.W $1F49,X             
                    STA.W $1EA2,X             
                    DEX                       
                    BPL ADDR_00A19A           
                    SEP #$10                  ; Index (8 bit) 
                    RTS                       

Clear_1A_13D3:      REP #$10                  ; 16 bit X,Y ; Index (16 bit) 
                    SEP #$20                  ; 8 bit A ; Accum (8 bit) 
                    LDX.W #$00BD              ; \  
ADDR_00A1AD:        STZ $1A,X                 ;  |Clear RAM addresses $1A-$D7 
                    DEX                       ;  | 
                    BPL ADDR_00A1AD           ; /  
                    LDX.W #$07CE              ; \  
ADDR_00A1B5:        STZ.W $13D3,X             ;  |Clear RAM addresses $13D3-$1BA1 
                    DEX                       ;  | 
                    BPL ADDR_00A1B5           ; /  
                    SEP #$10                  ; 16 bit X,Y ; Index (8 bit) 
                    RTS                       ; Return 

ADDR_00A1BE:        JSR.W SetUp0DA0GM4        
                    INC $14                   ; Increase alternate frame counter 
                    JSL.L $7F8000             
                    JSL.L ADDR_048241         ; (Bank 4.asm) 
                    JMP.W ADDR_008494         

DATA_00A1CE:        .db $FE,$00,$02,$00

DATA_00A1D2:        .db $FF,$00,$00,$00,$12,$22,$12,$02

ADDR_00A1DA:        LDA.W $1426               
                    BEQ ADDR_00A1E4           
                    JSL.L ADDR_05B10C         
                    RTS                       

ADDR_00A1E4:        LDA.W $1425               
                    BEQ ADDR_00A200           
                    LDA.W $14AB               
                    BEQ ADDR_00A200           
                    CMP.B #$40                
                    BCS ADDR_00A200           
                    JSR.W NoButtons           
                    CMP.B #$1C                
                    BCS ADDR_00A200           
                    JSR.W ADDR_00CA31         
                    LDA.B #$0D                
                    STA $71                   
ADDR_00A200:        ORA $71                   
                    ORA.W $1493               
                    BEQ ADDR_00A211           
                    LDA.B #$04                
                    TRB $15                   
                    LDA.B #$40                
                    TRB $16                   
                    TRB $18                   
ADDR_00A211:        LDA.W $13D3               
                    BEQ ADDR_00A21B           
                    DEC.W $13D3               
                    BRA ADDR_00A242           
ADDR_00A21B:        LDA $16                   
                    AND.B #$10                
                    BEQ ADDR_00A242           
                    LDA.W $1493               
                    BNE ADDR_00A242           
                    LDA $71                   
                    CMP.B #$09                
                    BCS ADDR_00A242           
                    LDA.B #$3C                
                    STA.W $13D3               
                    LDY.B #$12                
                    LDA.W $13D4               
                    EOR.B #$01                
                    STA.W $13D4               
                    BEQ ADDR_00A23F           
                    LDY.B #$11                
ADDR_00A23F:        STY.W $1DF9               
ADDR_00A242:        LDA.W $13D4               
                    BEQ ADDR_00A28A           
                    BRA ADDR_00A25B           
                    BIT.W $0DA7               
                    BVS ADDR_00A259           
                    LDA.W $0DA3               
                    BPL ADDR_00A25B           
                    LDA $13                   
                    AND.B #$0F                
                    BNE ADDR_00A25B           
ADDR_00A259:        BRA ADDR_00A28A           
ADDR_00A25B:        LDA $15                   
                    AND.B #$20                
                    BEQ ADDR_00A289           
                    LDY.W $13BF               
                    LDA.W $1EA2,Y             
                    BPL ADDR_00A289           
                    LDA.W $0DD5               
                    BEQ ADDR_00A270           
                    BPL ADDR_00A289           
ADDR_00A270:        LDA.B #$80                
                    BRA ADDR_00A27E           
                    LDA.B #$01                
                    BIT $15                   
                    BPL ADDR_00A27B           
                    INC A                     
ADDR_00A27B:        STA.W $13CE               
ADDR_00A27E:        STA.W $0DD5               
                    INC.W $1DE9               
                    LDA.B #$0B                
                    STA.W $0100               
ADDR_00A289:        RTS                       

ADDR_00A28A:        LDA.W $0D9B               
                    BPL ADDR_00A295           
                    JSR.W ADDR_00987D         
                    JMP.W ADDR_00A2A9         
ADDR_00A295:        JSL.L $7F8000             
                    JSL.L ADDR_00F6DB         
                    JSL.L ADDR_05BC00         
                    JSL.L ADDR_0586F1         
                    JSL.L ADDR_05BB39         
ADDR_00A2A9:        LDA $1C                   
                    PHA                       
                    LDA $1D                   
                    PHA                       
                    STZ.W $1888               
                    STZ.W $1889               
                    LDA.W $1887               
                    BEQ ADDR_00A2D5           
                    DEC.W $1887               
                    AND.B #$03                
                    TAY                       
                    LDA.W DATA_00A1CE,Y       
                    STA.W $1888               
                    CLC                       
                    ADC $1C                   
                    STA $1C                   
                    LDA.W DATA_00A1D2,Y       
                    STA.W $1889               
                    ADC $1D                   
                    STA $1D                   
ADDR_00A2D5:        JSR.W ADDR_008E1A         
                    JSL.L ADDR_00E2BD         
                    JSR.W ADDR_00A2F3         
                    JSR.W ADDR_00C47E         
                    JSL.L ADDR_01808C         
                    JSL.L ADDR_028AB1         
                    PLA                       
                    STA $1D                   
                    PLA                       
                    STA $1C                   
                    JMP.W ADDR_008494         
ADDR_00A2F3:        REP #$20                  ; Accum (16 bit) 
                    LDA $94                   
                    STA $D1                   
                    LDA $96                   
                    STA $D3                   
                    SEP #$20                  ; Accum (8 bit) 
                    RTS                       

MarioGFXDMA:        REP #$20                  ; 16 bit A ; Accum (16 bit) 
                    LDX.B #$04                ; We're using DMA channel 2 
                    LDY.W $0D84               
                    BEQ ADDR_00A328           
                    LDY.B #$86                ; \ Set Address for CG-RAM Write to x86 
                    STY.W $2121               ; /  ; Address for CG-RAM Write
                    LDA.W #$2200              
                    STA.W $4320               ; Parameters for DMA Transfer
                    LDA.W $0D82               ; \ Get location of palette from $0D82-$0D83 
                    STA.W $4322               ; /  ; A Address (Low Byte)
                    LDY.B #$00                ; \ Palette is stored in bank x00 
                    STY.W $4324               ; /  ; A Address Bank
                    LDA.W #$0014              ; \ x14 bytes will be transferred 
                    STA.W $4325               ; /  ; Number Bytes to Transfer (Low Byte) (DMA)
                    STX.W $420B               ; Transfer the colors ; Regular DMA Channel Enable
ADDR_00A328:        LDY.B #$80                ; \ Set VRAM Address Increment Value to x80 
                    STY.W $2115               ; /  ; VRAM Address Increment Value
                    LDA.W #$1801              
                    STA.W $4320               ; Parameters for DMA Transfer
                    LDA.W #$67F0              
                    STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDA.W $0D99               
                    STA.W $4322               ; A Address (Low Byte)
                    LDY.B #$7E                ; \ Set bank to x7E 
                    STY.W $4324               ; /  ; A Address Bank
                    LDA.W #$0020              ; \ x20 bytes will be transferred 
                    STA.W $4325               ; /  ; Number Bytes to Transfer (Low Byte) (DMA)
                    STX.W $420B               ; Transfer ; Regular DMA Channel Enable
                    LDA.W #$6000              ; \ Set Address for VRAM Read/Write to x6000 
                    STA.W $2116               ; /  ; Address for VRAM Read/Write (Low Byte)
                    LDX.B #$00                
ADDR_00A355:        LDA.W $0D85,X             ; \ Get address of graphics to copy 
                    STA.W $4322               ; /  ; A Address (Low Byte)
                    LDA.W #$0040              ; \ x40 bytes will be transferred 
                    STA.W $4325               ; /  ; Number Bytes to Transfer (Low Byte) (DMA)
                    LDY.B #$04                ; \ Transfer 
                    STY.W $420B               ; /  ; Regular DMA Channel Enable
                    INX                       ; \ Move to next address 
                    INX                       ; /  
                    CPX.W $0D84               ; \ Repeat last segment while X<$0D84 
                    BCC ADDR_00A355           ; /  
                    LDA.W #$6100              ; \ Set Address for VRAM Read/Write to x6100 
                    STA.W $2116               ; /  ; Address for VRAM Read/Write (Low Byte)
                    LDX.B #$00                
ADDR_00A375:        LDA.W $0D8F,X             ; \ Get address of graphics to copy 
                    STA.W $4322               ; /  ; A Address (Low Byte)
                    LDA.W #$0040              ; \ x40 bytes will be transferred 
                    STA.W $4325               ; /  ; Number Bytes to Transfer (Low Byte) (DMA)
                    LDY.B #$04                ; \ Transfer 
                    STY.W $420B               ; /  ; Regular DMA Channel Enable
                    INX                       ; \ Move to next address 
                    INX                       ; /  
                    CPX.W $0D84               ; \ Repeat last segment while X<$0D84 
                    BCC ADDR_00A375           ; /  
                    SEP #$20                  ; 8 bit A ; Accum (8 bit) 
                    RTS                       ; Return 

ADDR_00A390:        REP #$20                  ; Accum (16 bit) 
                    LDY.B #$80                
                    STY.W $2115               ; VRAM Address Increment Value
                    LDA.W #$1801              
                    STA.W $4320               ; Parameters for DMA Transfer
                    LDY.B #$7E                
                    STY.W $4324               ; A Address Bank
                    LDX.B #$04                
                    LDA.W $0D80               
                    BEQ ADDR_00A3BB           
                    STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDA.W $0D7A               
                    STA.W $4322               ; A Address (Low Byte)
                    LDA.W #$0080              
                    STA.W $4325               ; Number Bytes to Transfer (Low Byte) (DMA)
                    STX.W $420B               ; Regular DMA Channel Enable
ADDR_00A3BB:        LDA.W $0D7E               
                    BEQ ADDR_00A3D2           
                    STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDA.W $0D78               
                    STA.W $4322               ; A Address (Low Byte)
                    LDA.W #$0080              
                    STA.W $4325               ; Number Bytes to Transfer (Low Byte) (DMA)
                    STX.W $420B               ; Regular DMA Channel Enable
ADDR_00A3D2:        LDA.W $0D7C               
                    BEQ ADDR_00A418           
                    STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    CMP.W #$0800              
                    BEQ ADDR_00A3F0           
                    LDA.W $0D76               
                    STA.W $4322               ; A Address (Low Byte)
                    LDA.W #$0080              
                    STA.W $4325               ; Number Bytes to Transfer (Low Byte) (DMA)
                    STX.W $420B               ; Regular DMA Channel Enable
                    BRA ADDR_00A418           
ADDR_00A3F0:        LDA.W $0D76               
                    STA.W $4322               ; A Address (Low Byte)
                    LDA.W #$0040              
                    STA.W $4325               ; Number Bytes to Transfer (Low Byte) (DMA)
                    STX.W $420B               ; Regular DMA Channel Enable
                    LDA.W #$0900              
                    STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDA.W $0D76               
                    CLC                       
                    ADC.W #$0040              
                    STA.W $4322               ; A Address (Low Byte)
                    LDA.W #$0040              
                    STA.W $4325               ; Number Bytes to Transfer (Low Byte) (DMA)
                    STX.W $420B               ; Regular DMA Channel Enable
ADDR_00A418:        SEP #$20                  ; Accum (8 bit) 
                    LDA.B #$64                
ADDR_00A41C:        STZ $00                   
ADDR_00A41E:        STA.W $2121               ; Address for CG-RAM Write
                    LDA $14                   
                    AND.B #$1C                
                    LSR                       
                    ADC $00                   
                    TAY                       
                    LDA.W DATA_00B60C,Y       
                    STA.W $2122               ; Data for CG-RAM Write
                    LDA.W DATA_00B60D,Y       
                    STA.W $2122               ; Data for CG-RAM Write
                    RTS                       

ADDR_00A436:        LDA.W $1935               
                    BEQ ADDR_00A47E           
                    STZ.W $1935               
                    REP #$20                  ; 16 bit A ; Accum (16 bit) 
                    LDY.B #$80                
                    STY.W $2115               ; VRAM Address Increment Value
                    LDA.W #$64A0              
                    STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDA.W #$1801              
                    STA.W $4320               ; Parameters for DMA Transfer
                    LDA.W #$0BF6              
                    STA.W $4322               ; A Address (Low Byte)
                    LDY.B #$00                
                    STY.W $4324               ; A Address Bank
                    LDA.W #$00C0              
                    STA.W $4325               ; Number Bytes to Transfer (Low Byte) (DMA)
                    LDX.B #$04                
                    STX.W $420B               ; Regular DMA Channel Enable
                    LDA.W #$65A0              
                    STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDA.W #$0CB6              
                    STA.W $4322               ; A Address (Low Byte)
                    LDA.W #$00C0              
                    STA.W $4325               ; Number Bytes to Transfer (Low Byte) (DMA)
                    STX.W $420B               ; Regular DMA Channel Enable
                    SEP #$20                  ; 8 bit A ; Accum (8 bit) 
ADDR_00A47E:        RTS                       


DATA_00A47F:        .db $82

DATA_00A480:        .db $06

DATA_00A481:        .db $00,$05,$09,$00,$03,$07,$00

ADDR_00A488:        LDY.W $0680               
                    LDX.W DATA_00A481,Y       
                    STX $02                   
                    STZ $01                   
                    STZ $00                   
                    STZ $04                   
                    LDA.W DATA_00A480,Y       
                    XBA                       
                    LDA.W DATA_00A47F,Y       
                    REP #$10                  ; Index (16 bit) 
                    TAY                       
ADDR_00A4A0:        LDA [$00],Y               
                    BEQ ADDR_00A4CF           
                    STX.W $4324               ; A Address Bank
                    STA.W $4325               ; Number Bytes to Transfer (Low Byte) (DMA)
                    STA $03                   
                    STZ.W $4326               ; Number Bytes to Transfer (High Byte) (DMA)
                    INY                       
                    LDA [$00],Y               
                    STA.W $2121               ; Address for CG-RAM Write
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W #$2200              
                    STA.W $4320               ; Parameters for DMA Transfer
                    INY                       
                    TYA                       
                    STA.W $4322               ; A Address (Low Byte)
                    CLC                       
                    ADC $03                   
                    TAY                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.B #$04                
                    STA.W $420B               ; Regular DMA Channel Enable
                    BRA ADDR_00A4A0           
ADDR_00A4CF:        SEP #$10                  ; Index (8 bit) 
                    JSR.W ADDR_00AE47         
                    LDA.W $0680               
                    BNE ADDR_00A4DF           
                    STZ.W $0681               
                    STZ.W $0682               
ADDR_00A4DF:        STZ.W $0680               
ADDR_00A4E2:        RTS                       

ADDR_00A4E3:        REP #$10                  ; Index (16 bit) 
                    LDA.B #$80                
                    STA.W $2115               ; VRAM Address Increment Value
                    LDY.W #$0750              
                    STY.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDY.W #$1801              
                    STY.W $4320               ; Parameters for DMA Transfer
                    LDY.W #$0AF6              
                    STY.W $4322               ; A Address (Low Byte)
                    STZ.W $4324               ; A Address Bank
                    LDY.W #$0160              
                    STY.W $4325               ; Number Bytes to Transfer (Low Byte) (DMA)
                    LDA.B #$04                
                    STA.W $420B               ; Regular DMA Channel Enable
                    SEP #$10                  ; Index (8 bit) 
                    LDA.W $13D9               
                    CMP.B #$0A                
                    BEQ ADDR_00A4E2           
                    LDA.B #$6D                
                    JSR.W ADDR_00A41C         
                    LDA.B #$10                
                    STA $00                   
                    LDA.B #$7D                
                    JMP.W ADDR_00A41E         

DATA_00A521:        .db $00,$04,$08,$0C

DATA_00A525:        .db $00,$08,$10,$18

ADDR_00A529:        LDA.B #$80                
                    STA.W $2115               ; VRAM Address Increment Value
                    STZ.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDA.B #$30                
                    CLC                       
                    ADC.W DATA_00A521,Y       
                    STA.W $2117               ; Address for VRAM Read/Write (High Byte)
                    LDX.B #$06                
ADDR_00A53C:        LDA.W DATA_00A586,X       
                    STA.W $4310,X             
                    DEX                       
                    BPL ADDR_00A53C           
                    LDA.W $0DD6               
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W $1F11,X             
                    BEQ ADDR_00A555           
                    LDA.B #$60                
                    STA.W $4313               ; A Address (High Byte)
ADDR_00A555:        LDA.W $4313               ; A Address (High Byte)
                    CLC                       
                    ADC.W DATA_00A525,Y       
                    STA.W $4313               ; A Address (High Byte)
                    LDA.B #$02                
                    STA.W $420B               ; Regular DMA Channel Enable
                    LDA.B #$80                
                    STA.W $2115               ; VRAM Address Increment Value
                    STZ.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDA.B #$20                
                    CLC                       
                    ADC.W DATA_00A521,Y       
                    STA.W $2117               ; Address for VRAM Read/Write (High Byte)
                    LDX.B #$06                
ADDR_00A577:        LDA.W DATA_00A58D,X       
                    STA.W $4310,X             
                    DEX                       
                    BPL ADDR_00A577           
                    LDA.B #$02                
                    STA.W $420B               ; Regular DMA Channel Enable
                    RTS                       


DATA_00A586:        .db $01,$18,$00,$40,$7F,$00,$08

DATA_00A58D:        .db $01,$18,$00,$E4,$7E,$00,$08

ADDR_00A594:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_00AD25         
                    PLB                       
                    RTL                       

GM04Load:           JSR.W ADDR_0085FA         ; gah, stupid keyboard >_< 
                    JSR.W NoButtons           
                    STZ.W $143A               
                    JSR.W SetUpScreen         
                    JSR.W GM04DoDMA           
                    JSL.L ADDR_05809E         ; ->here 
                    LDA.W $0D9B               
                    BPL ADDR_00A5B9           
                    JSR.W ADDR_0097BC         ; Working on this routine 
                    BRA ADDR_00A5CF           
ADDR_00A5B9:        JSR.W UploadSpriteGFX     
                    JSR.W LoadPalette         
                    JSL.L ADDR_05BE8A         
                    JSR.W ADDR_009FB8         
                    JSR.W ADDR_00A5F9         
                    JSR.W ADDR_009260         
                    JSR.W ADDR_009860         
ADDR_00A5CF:        JSR.W ADDR_00922F         
                    JSR.W KeepModeActive      
                    JSR.W ADDR_008E1A         
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    PHB                       
                    LDX.W #$0703              
                    LDY.W #$0905              
                    LDA.W #$01EF              
                    MVN $00,$00               
                    PLB                       
                    LDX.W $0701               
                    STX.W $0903               
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    JSR.W ADDR_00919B         
                    JSR.W ADDR_008494         
                    JMP.W ADDR_0093F4         
ADDR_00A5F9:        LDA.B #$E7                
                    TRB $14                   
ADDR_00A5FD:        JSL.L ADDR_05BB39         
                    JSR.W ADDR_00A390         
                    INC $14                   
                    LDA $14                   

Instr00A608:        .db $29

ADDR_00A609:        .db $07

                    BNE ADDR_00A5FD           
                    RTS                       


DATA_00A60D:        .db $00,$01,$01,$01

DATA_00A611:        .db $0D,$00,$F3,$FF,$FE,$FF,$FE,$FF
                    .db $00,$00,$00,$00

DATA_00A61D:        .db $0A,$00,$00,$00,$1A,$1A,$0A,$0A
DATA_00A625:        .db $00,$80,$40,$00,$01,$02,$40,$00
                    .db $40,$00,$00,$00,$00,$02,$00,$00

ADDR_00A635:        LDA.W $14AD               
                    ORA.W $14AE               
                    ORA.W $190C               
                    BNE ADDR_00A64A           
                    LDA.W $1490               
                    BEQ ADDR_00A660           
                    LDA.W $0DDA               
                    BPL ADDR_00A64F           
ADDR_00A64A:        LDA.W $0DDA               
                    AND.B #$7F                
ADDR_00A64F:        ORA.B #$40                
                    STA.W $0DDA               
                    STZ.W $14AD               
                    STZ.W $14AE               
                    STZ.W $190C               
                    STZ.W $1490               
ADDR_00A660:        LDA.W $13F4               
                    ORA.W $13F5               
                    ORA.W $13F6               
                    ORA.W $13F7               
                    ORA.W $13F8               
                    BEQ ADDR_00A674           
                    STA.W $141B               
ADDR_00A674:        LDX.B #$23                
ADDR_00A676:        STZ $70,X                 
                    DEX                       
                    BNE ADDR_00A676           
                    LDX.B #$37                
ADDR_00A67D:        STZ.W $13D9,X             
                    DEX                       
                    BNE ADDR_00A67D           
                    ASL.W $13CB               
                    STZ.W $149A               
                    STZ.W $1498               
                    STZ.W $1495               
                    STZ.W $1419               
                    LDY.B #$01                
                    LDX.W $1931               
                    CPX.B #$10                
                    BCS ADDR_00A6CC           
                    LDA.W DATA_00A625,X       
                    LSR                       
                    BEQ ADDR_00A6CC           
                    LDA.W $141D               
                    ORA.W $141A               
                    ORA.W $141F               
                    BNE ADDR_00A6CC           
                    LDA.W $13CF               
                    BEQ ADDR_00A6B6           
                    JSR.W ADDR_00C90A         
                    BRA ADDR_00A6CC           
ADDR_00A6B6:        STZ $72                   
                    STY $76                   
                    STY $89                   
                    LDX.B #$0A                
                    LDY.B #$00                
                    LDA.W $0DC1               
                    BEQ ADDR_00A6C7           
                    LDY.B #$0F                
ADDR_00A6C7:        STX $71                   
                    STY $88                   
                    RTS                       

ADDR_00A6CC:        LDA $1C                   
                    CMP.B #$C0                
                    BEQ ADDR_00A6D5           
                    INC.W $13F1               
ADDR_00A6D5:        LDA.W $192A               
                    BEQ ADDR_00A6E0           
                    CMP.B #$05                
                    BNE ADDR_00A716           
                    ROR $86                   
ADDR_00A6E0:        STY $76                   
                    LDA.B #$24                
                    STA $72                   
                    STZ $9D                   
                    LDA.W $1434               
                    BEQ ADDR_00A704           
                    LDA.W $0DDA               
                    ORA.B #$7F                
                    STA.W $0DDA               
                    LDA $94                   
                    ORA.B #$04                
                    STA.W $1436               
                    LDA $96                   
                    CLC                       
                    ADC.B #$10                
                    STA.W $1438               
ADDR_00A704:        LDA.W $1B95               
                    BEQ ADDR_00A715           
                    LDA.B #$08                
                    STA $71                   
                    LDA.B #$A0                
                    STA $96                   
                    LDA.B #$90                
                    STA $7D                   
ADDR_00A715:        RTS                       

ADDR_00A716:        CMP.B #$06                
                    BCC ADDR_00A740           
                    BNE ADDR_00A734           
                    STY $76                   
                    STY.W $13DF               
                    LDA.B #$FF                
                    STA.W $1419               
                    LDA.B #$08                
                    TSB $94                   
                    LDA.B #$02                
                    TSB $96                   
                    LDX.B #$07                
                    LDY.B #$20                
                    BRA ADDR_00A6C7           
ADDR_00A734:        STY $85                   
                    LDA.W $13CF               
                    ORA.W $1434               
                    BNE ADDR_00A6E0           
                    LDA.B #$04                
ADDR_00A740:        CLC                       
                    ADC.B #$03                
                    STA $89                   
                    TAY                       
                    LSR                       
                    DEC A                     
                    STA.W $1419               
                    LDA.W ADDR_00A609,Y       
                    STA $76                   
                    LDX.B #$05                
                    CPY.B #$06                
                    BCC ADDR_00A768           
                    LDA.B #$08                
                    TSB $94                   
                    LDX.B #$06                
                    CPY.B #$07                
                    LDY.B #$1E                
                    BCC ADDR_00A76A           
                    LDY.B #$0F                
                    LDA $19                   
                    BEQ ADDR_00A76A           
ADDR_00A768:        LDY.B #$1C                
ADDR_00A76A:        STY $7D                   
                    JSR.W ADDR_00A6C7         
                    LDA.W $187A               
                    BEQ ADDR_00A795           
                    LDX $89                   
                    LDA $88                   
                    CLC                       
                    ADC.W DATA_00A61D,X       
                    STA $88                   
                    TXA                       
                    ASL                       
                    TAX                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA $94                   
                    CLC                       
                    ADC.W ADDR_00A609,X       
                    STA $94                   
                    LDA $96                   
                    CLC                       
                    ADC.W DATA_00A611,X       
                    STA $96                   
                    SEP #$20                  ; Accum (8 bit) 
ADDR_00A795:        RTS                       

ADDR_00A796:        REP #$20                  ; Accum (16 bit) 
                    LDY.W $1414               
                    BEQ ADDR_00A7B9           
                    DEY                       
                    BNE ADDR_00A7A7           
                    LDA $20                   
                    SEC                       
                    SBC $1C                   
                    BRA ADDR_00A7B6           
ADDR_00A7A7:        LDA $1C                   
                    LSR                       
                    DEY                       
                    BEQ ADDR_00A7AF           
                    LSR                       
                    LSR                       
ADDR_00A7AF:        EOR.W #$FFFF              
                    INC A                     
                    CLC                       
                    ADC $20                   
ADDR_00A7B6:        STA.W $1417               
ADDR_00A7B9:        LDA.W #$0080              
                    STA.W $142A               
                    SEP #$20                  ; Accum (8 bit) 
                    RTS                       

ADDR_00A7C2:        REP #$20                  ; 16 bit A ; Accum (16 bit) 
                    LDX.B #$80                
                    STX.W $2115               ; VRAM Address Increment Value
                    LDA.W #$6000              
                    STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDA.W #$1801              
                    STA.W $4320               ; Parameters for DMA Transfer
                    LDA.W #$977B              
                    STA.W $4322               ; A Address (Low Byte)
                    LDX.B #$7F                
                    STX.W $4324               ; A Address Bank
                    LDA.W #$00C0              
                    STA.W $4325               ; Number Bytes to Transfer (Low Byte) (DMA)
                    LDX.B #$04                
                    STX.W $420B               ; Regular DMA Channel Enable
                    LDA.W #$6100              
                    STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDA.W #$983B              
                    STA.W $4322               ; A Address (Low Byte)
                    LDA.W #$00C0              
                    STA.W $4325               ; Number Bytes to Transfer (Low Byte) (DMA)
                    STX.W $420B               ; Regular DMA Channel Enable
                    LDA.W #$64A0              
                    STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDA.W #$98FB              
                    STA.W $4322               ; A Address (Low Byte)
                    LDA.W #$00C0              
                    STA.W $4325               ; Number Bytes to Transfer (Low Byte) (DMA)
                    STX.W $420B               ; Regular DMA Channel Enable
                    LDA.W #$65A0              
                    STA.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDA.W #$99BB              
                    STA.W $4322               ; A Address (Low Byte)
                    LDA.W #$00C0              
                    STA.W $4325               ; Number Bytes to Transfer (Low Byte) (DMA)
                    STX.W $420B               ; Regular DMA Channel Enable
                    SEP #$20                  ; 8 bit A ; Accum (8 bit) 
                    RTS                       

ADDR_00A82D:        LDY.B #$0F                
                    JSL.L ADDR_00BA28         
                    LDA.W $1425               
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    BEQ ADDR_00A842           
                    LDA $00                   
                    CLC                       
                    ADC.W #$0030              
                    STA $00                   
ADDR_00A842:        LDX.W #$0000              
ADDR_00A845:        LDY.W #$0008              
ADDR_00A848:        LDA [$00]                 
                    STA.L $7F977B,X           
                    INX                       
                    INX                       
                    INC $00                   
                    INC $00                   
                    DEY                       
                    BNE ADDR_00A848           
                    LDY.W #$0008              
ADDR_00A85A:        LDA [$00]                 
                    AND.W #$00FF              
                    STA.L $7F977B,X           
                    INX                       
                    INX                       
                    INC $00                   
                    DEY                       
                    BNE ADDR_00A85A           
                    CPX.W #$0300              
                    BCC ADDR_00A845           
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDY.B #$00                
                    JSL.L ADDR_00BA28         
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.W #$B3F0              
                    STA $00                   
                    LDA.W #$7EB3              
                    STA $01                   
                    LDX.W #$0000              
ADDR_00A886:        LDY.W #$0008              
ADDR_00A889:        LDA [$00]                 
                    STA.W $0BF6,X             
                    INX                       
                    INX                       
                    INC $00                   
                    INC $00                   
                    DEY                       
                    BNE ADDR_00A889           
                    LDY.W #$0008              
ADDR_00A89A:        LDA [$00]                 
                    AND.W #$00FF              
                    STA.W $0BF6,X             
                    INX                       
                    INX                       
                    INC $00                   
                    DEY                       
                    BNE ADDR_00A89A           
                    CPX.W #$00C0              
                    BNE ADDR_00A8B3           
                    LDA.W #$B570              
                    STA $00                   
ADDR_00A8B3:        CPX.W #$0180              
                    BCC ADDR_00A886           
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDA.B #$01                
                    STA.W $143A               
                    STA.W $1935               
                    RTS                       


SPRITEGFXLIST:      .db $00,$01,$13,$02,$00,$01,$12,$03
                    .db $00,$01,$13,$05,$00,$01,$13,$04
                    .db $00,$01,$13,$06,$00,$01,$13,$09
                    .db $00,$01,$13,$04,$00,$01,$06,$11
                    .db $00,$01,$13,$20,$00,$01,$13,$0F
                    .db $00,$01,$13,$23,$00,$01,$0D,$14
                    .db $00,$01,$24,$0E,$00,$01,$0A,$22
                    .db $00,$01,$13,$0E,$00,$01,$13,$14
                    .db $00,$00,$00,$08,$10,$0F,$1C,$1D
                    .db $00,$01,$24,$22,$00,$01,$25,$22
                    .db $00,$22,$13,$2D,$00,$01,$0F,$22
                    .db $00,$26,$2E,$22,$21,$0B,$25,$0A
                    .db $00,$0D,$24,$22,$2C,$30,$2D,$0E
OBJECTGFXLIST:      .db $14,$17,$19,$15,$14,$17,$1B,$18
                    .db $14,$17,$1B,$16,$14,$17,$0C,$1A
                    .db $14,$17,$1B,$08,$14,$17,$0C,$07
                    .db $14,$17,$0C,$16,$14,$17,$1B,$15
                    .db $14,$17,$19,$16,$14,$17,$0D,$1A
                    .db $14,$17,$1B,$08,$14,$17,$1B,$18
                    .db $14,$17,$19,$1F,$14,$17,$0D,$07
                    .db $14,$17,$19,$1A,$14,$17,$14,$14
                    .db $0E,$0F,$17,$17,$1C,$1D,$08,$1E
                    .db $1C,$1D,$08,$1E,$1C,$1D,$08,$1E
                    .db $1C,$1D,$08,$1E,$1C,$1D,$08,$1E
                    .db $1C,$1D,$08,$1E,$1C,$1D,$08,$1E
                    .db $14,$17,$19,$2C,$19,$17,$1B,$18

ADDR_00A993:        STZ.W $2116               ; \  ; Address for VRAM Read/Write (Low Byte)
                    LDA.B #$40                ;  |Set "Address for VRAM Read/Write" to x4000 
                    STA.W $2117               ; /  ; Address for VRAM Read/Write (High Byte)
                    LDA.B #$03                
                    STA $0F                   
                    LDA.B #$28                
                    STA $0E                   
ADDR_00A9A3:        LDA $0E                   
                    TAY                       
                    JSL.L ADDR_00BA28         
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDX.W #$03FF              
                    LDY.W #$0000              
ADDR_00A9B2:        LDA [$00],Y               
                    STA.W $2118               ; Data for VRAM Write (Low Byte)
                    INY                       
                    INY                       
                    DEX                       
                    BPL ADDR_00A9B2           
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    INC $0E                   
                    DEC $0F                   
                    BPL ADDR_00A9A3           
                    STZ.W $2116               ; \  ; Address for VRAM Read/Write (Low Byte)
                    LDA.B #$60                ;  |Set "Address for VRAM Read/Write" to x6000 
                    STA.W $2117               ; /  ; Address for VRAM Read/Write (High Byte)
                    LDY.B #$00                
                    JSR.W UploadGFXFile       
                    RTS                       


DATA_00A9D2:        .db $78,$70,$68,$60

DATA_00A9D6:        .db $18,$10,$08,$00

UploadSpriteGFX:    LDA.B #$80                ; Decompression as well? 
                    STA.W $2115               ; VRAM transfer control port ; VRAM Address Increment Value
                    LDX.B #$03                
                    LDA.W $192B               ; $192B = current sprite GFX list index 
                    ASL                       ; \ 
                    ASL                       ;  }4A -> Y 
                    TAY                       ; / 
ADDR_00A9E7:        LDA.W SPRITEGFXLIST,Y     ;  | 
                    STA $04,X                 ;  | 
                    INY                       ;  | 
                    DEX                       ;  | 
                    BPL ADDR_00A9E7           ; / 
                    LDA.B #$03                ; #$03 -> A -> $0F 
                    STA $0F                   
GFXTransferLoop:    LDX $0F                   ; $0F -> X 
                    STZ.W $2116               ; #$00 -> $2116 ; Address for VRAM Read/Write (Low Byte)
                    LDA.W DATA_00A9D2,X       ; My guess: Locations in VRAM to upload GFX to 
                    STA.W $2117               ; Set VRAM address to $??00 ; Address for VRAM Read/Write (High Byte)
                    LDY $04,X                 ; Y is possibly which GFX file 
                    LDA.W $0101,X             ; to upload to a section in VRAM, used in 
                    CMP $04,X                 ; the subroutine $00:BA28 
                    BEQ Don'tUploadSpr        ; don't upload when it''s not needed 
                    JSR.W UploadGFXFile       ; JSR to a JSL... 
Don'tUploadSpr:     DEC $0F                   ; Decrement $0F 
                    BPL GFXTransferLoop       ; if >= #$00, continue transfer 
                    LDX.B #$03                ; \ 
UpdtCrrntSpritGFX:  LDA $04,X                 ;  |Update $0101-$0104 to reflect the new sprite GFX 
                    STA.W $0101,X             ;  |That's loaded now. 
                    DEX                       ;  | 
                    BPL UpdtCrrntSpritGFX     ; / 
                    LDA.W $1931               ; LDA Tileset 
                    CMP.B #$FE                
                    BCS SetallFGBG80          ; Branch to a routine that uploads file #$80 to every slot in FG/BG 
                    LDX.B #$03                
                    LDA.W $1931               ; this routine is pretty close to the above 
                    ASL                       ; one, I'm guessing this does 
                    ASL                       ; object/BG GFX. 
                    TAY                       ; 4A -> Y 
PrepLoadFGBG:       LDA.W OBJECTGFXLIST,Y     ; FG/BG GFX table 
                    STA $04,X                 
                    INY                       
                    DEX                       
                    BPL PrepLoadFGBG          ; FG/Bg to upload -> $04 - $07 
                    LDA.B #$03                
                    STA $0F                   ; #$03 -> $0F 
ADDR_00AA35:        LDX $0F                   ; $0F -> X 
                    STZ.W $2116               ; Address for VRAM Read/Write (Low Byte)
                    LDA.W DATA_00A9D6,X       ; Load + Store VRAM upload positions 
                    STA.W $2117               ; Address for VRAM Read/Write (High Byte)
                    LDY $04,X                 
                    LDA.W $0105,X             ; Check to see if the file to be uploaded already 
                    CMP $04,X                 ; exists in the slot in VRAM - if so, 
                    BEQ NoUploadFGBG          ; don't bother uploading it again. 
                    JSR.W UploadGFXFile       ; Upload the GFX file 
NoUploadFGBG:       DEC $0F                   ; Next GFX file 
                    BPL ADDR_00AA35           
                    LDX.B #$03                
UpdateCurrentFGBG:  LDA $04,X                 
                    STA.W $0105,X             
                    DEX                       
                    BPL UpdateCurrentFGBG     
                    RTS                       ; Return from uploading the GFX 

SetallFGBG80:       BEQ NoUpdateVRAM80        ; If zero flag set, don't update the tileset 
                    JSR.W ADDR_00AB42         
NoUpdateVRAM80:     LDX.B #$03                
                    LDA.B #$80                ; my guess is that it gets called in the same set of routines 
Store80:            STA.W $0105,X             
                    DEX                       
                    BPL Store80               
                    RTS                       ; Return 

UploadGFXFile:      JSL.L ADDR_00BA28         
                    CPY.B #$01                
                    BNE SkipSpecial           
                    LDA.W $1EEB               
                    BPL SkipSpecial           ; handle the post-special world graphics and koopa color swap. 
                    LDY.B #$31                
                    JSL.L ADDR_00BA28         
                    LDY.B #$01                
SkipSpecial:        REP #$20                  ; A = 16bit ; Accum (16 bit) 
                    LDA.W #$0000              
                    LDX.W $1931               ; LDX Tileset 
                    CPX.B #$11                ; CPX #$11 
                    BCC ADDR_00AA90           ; If Tileset < #$11 skip to lower area 
                    CPY.B #$08                ; if Y = #$08 skip to JSR 
                    BEQ JumpTo_____           
ADDR_00AA90:        CPY.B #$1E                ; If Y = #$1E then 
                    BEQ JumpTo_____           ; JMP otherwise 
                    BNE ADDR_00AA99           ; don't JMP 
JumpTo_____:        JMP.W FilterSomeRAM       
ADDR_00AA99:        STA $0A                   
                    LDA.W #$FFFF              
                    CPY.B #$01                
                    BEQ ADDR_00AAA9           
                    CPY.B #$17                
                    BEQ ADDR_00AAA9           
                    LDA.W #$0000              
ADDR_00AAA9:        STA.W $1BBC               
                    LDY.B #$7F                
ADDR_00AAAE:        LDA.W $1BBC               
                    BEQ ADDR_00AACD           
                    CPY.B #$7E                
                    BCC ADDR_00AABE           
ADDR_00AAB7:        LDA.W #$FF00              
                    STA $0A                   
                    BNE ADDR_00AACD           
ADDR_00AABE:        CPY.B #$6E                
                    BCC ADDR_00AAC8           
                    CPY.B #$70                
                    BCS ADDR_00AAC8           
                    BCC ADDR_00AAB7           
ADDR_00AAC8:        LDA.W #$0000              
                    STA $0A                   
ADDR_00AACD:        LDX.B #$07                
ADDR_00AACF:        LDA [$00]                 
                    STA.W $2118               ; Data for VRAM Write (Low Byte)
                    XBA                       
                    ORA [$00]                 
                    STA.W $1BB2,X             
                    INC $00                   
                    INC $00                   
                    DEX                       
                    BPL ADDR_00AACF           
                    LDX.B #$07                
ADDR_00AAE3:        LDA [$00]                 
                    AND.W #$00FF              
                    STA $0C                   
                    LDA [$00]                 
                    XBA                       
                    ORA.W $1BB2,X             
                    AND $0A                   
                    ORA $0C                   
                    STA.W $2118               ; Data for VRAM Write (Low Byte)
                    INC $00                   
                    DEX                       
                    BPL ADDR_00AAE3           
                    DEY                       
                    BPL ADDR_00AAAE           
                    SEP #$20                  ; Accum (8 bit) 
                    RTS                       ; Return 

FilterSomeRAM:      LDA.W #$FF00              ; Accum (16 bit) 
                    STA $0A                   
                    LDY.B #$7F                
Upload????ToVRAM:   CPY.B #$08                ; \Completely pointless code. 
                    BCS ADDR_00AB0D           ; /(Why not just NOPing it out, Nintendo?) 
ADDR_00AB0D:        LDX.B #$07                
AddressWrite1:      LDA [$00]                 ; \ Okay, so take [$00], store 
                    STA.W $2118               ;  |it to VRAM, then bitwise ; Data for VRAM Write (Low Byte)
                    XBA                       ;  |OR the high and low bytes together 
                    ORA [$00]                 ;  |store in both bytes of A 
                    STA.W $1BB2,X             ; /and store to $1BB2,x 
                    INC $00                   ; \Increment $7E:0000 by 2 
                    INC $00                   ; / 
                    DEX                       ; \And continue on another 7 times (or 8 times total) 
                    BPL AddressWrite1         ; / 
                    LDX.B #$07                ; hm..  It's like a FOR Y{FOR X{ } } thing ...yeah... 
AddressWrite2:      LDA [$00]                 
                    AND.W #$00FF              ; A normal byte becomes 2 anti-compressed bytes. 
                    STA $0C                   ; I'm going up, to try and find out what's supposed to set $00-$02 for this routine. 
                    LDA [$00]                 ; AHA, check $00/BA28.  It writes a RAM address to $00-$02, $7EAD00 
                    XBA                       ; So...  Now to find otu what sets *That* 
                    ORA.W $1BB2,X             ; ...this place gives me headaches... Can't we work on some other code? :( 
                    AND $0A                   ; Sure, go ahead.  anyways, this seems to upload the decompressed GFX 
                    ORA $0C                   ; while scrambling it afterwards (o_O). 
                    STA.W $2118               ; Okay... WHAT THE HELL? ; Data for VRAM Write (Low Byte)
                    INC $00                   ; I'll have nightmares about this routine for a few years. :( 
                    DEX                       
                    BPL AddressWrite2         ; Ouch. 
                    DEY                       
                    BPL Upload????ToVRAM      
                    SEP #$20                  ; Accum (8 bit) 
                    RTS                       ; Return 

ADDR_00AB42:        LDY.B #$27                
                    JSL.L ADDR_00BA28         
                    REP #$10                  ; Index (16 bit) 
                    LDY.W #$0000              
                    LDX.W #$03FF              
ADDR_00AB50:        LDA [$00],Y               
                    STA $0F                   
                    JSR.W ADDR_00ABC4         
                    LDA $04                   
                    STA.W $2119               ; Data for VRAM Write (High Byte)
                    JSR.W ADDR_00ABC4         
                    LDA $04                   
                    STA.W $2119               ; Data for VRAM Write (High Byte)
                    STZ $04                   
                    ROL $0F                   
                    ROL $04                   
                    ROL $0F                   
                    ROL $04                   
                    INY                       
                    LDA [$00],Y               
                    STA $0F                   
                    ROL $0F                   
                    ROL $04                   
                    LDA $04                   
                    STA.W $2119               ; Data for VRAM Write (High Byte)
                    JSR.W ADDR_00ABC4         
                    LDA $04                   
                    STA.W $2119               ; Data for VRAM Write (High Byte)
                    JSR.W ADDR_00ABC4         
                    LDA $04                   
                    STA.W $2119               ; Data for VRAM Write (High Byte)
                    STZ $04                   
                    ROL $0F                   
                    ROL $04                   
                    INY                       
                    LDA [$00],Y               
                    STA $0F                   
                    ROL $0F                   
                    ROL $04                   
                    ROL $0F                   
                    ROL $04                   
                    LDA $04                   
                    STA.W $2119               ; Data for VRAM Write (High Byte)
                    JSR.W ADDR_00ABC4         
                    LDA $04                   
                    STA.W $2119               ; Data for VRAM Write (High Byte)
                    JSR.W ADDR_00ABC4         
                    LDA $04                   
                    STA.W $2119               ; Data for VRAM Write (High Byte)
                    INY                       
                    DEX                       
                    BPL ADDR_00AB50           
                    LDX.W #$2000              
ADDR_00ABBB:        STZ.W $2119               ; Data for VRAM Write (High Byte)
                    DEX                       
                    BNE ADDR_00ABBB           
                    SEP #$10                  ; Index (8 bit) 
                    RTS                       ; Return 

ADDR_00ABC4:        STZ $04                   
                    ROL $0F                   
                    ROL $04                   
                    ROL $0F                   
                    ROL $04                   
                    ROL $0F                   
                    ROL $04                   
                    RTS                       ; Return 


DATA_00ABD3:        .db $00,$18,$30,$48,$60,$78,$90,$A8
                    .db $00,$14,$28,$3C

DATA_00ABDF:        .db $00,$00,$38,$00,$70,$00,$A8,$00
                    .db $E0,$00,$18,$01,$50,$01

LoadPalette:        REP #$30                  ; 16 bit A, X and Y ; Index (16 bit) Accum (16 bit) 
                    LDA.W #$7FDD              ; \  
                    STA $04                   ;  |Set color 1 in all object palettes to white 
                    LDX.W #$0002              ;  | 
                    JSR.W LoadCol8Pal         ; /  
                    LDA.W #$7FFF              ; \  
                    STA $04                   ;  |Set color 1 in all sprite palettes to white 
                    LDX.W #$0102              ;  | 
                    JSR.W LoadCol8Pal         ; /  
                    LDA.W #$B170              ; \  
                    STA $00                   ;  | 
                    LDA.W #$0010              ;  |Load colors 8-16 in the first two object palettes from 00/B170 
                    STA $04                   ;  |(Layer 3 palettes) 
                    LDA.W #$0007              ;  | 
                    STA $06                   ;  | 
                    LDA.W #$0001              ;  | 
                    STA $08                   ;  | 
                    JSR.W LoadColors          ; /  
                    LDA.W #$B250              ; \  
                    STA $00                   ;  | 
                    LDA.W #$0084              ;  |Load colors 2-7 in palettes 4-D from 00/B250 
                    STA $04                   ;  |(Object and sprite palettes) 
                    LDA.W #$0005              ;  | 
                    STA $06                   ;  | 
                    LDA.W #$0009              ;  | 
                    STA $08                   ;  | 
                    JSR.W LoadColors          ; /  
                    LDA.W $192F               ; \  
                    AND.W #$000F              ;  | 
                    ASL                       ;  |Load background color 
                    TAY                       ;  | 
                    LDA.W DATA_00B0A0,Y       ;  | 
                    STA.W $0701               ; /  
                    LDA.W #$B190              ; \Store base address in $00, ... 
                    STA $00                   ; / 
                    LDA.W $192D               ; \...get current object palette, ... 
                    AND.W #$000F              ; / 
                    TAY                       ; \  
                    LDA.W DATA_00ABD3,Y       ;  | 
                    AND.W #$00FF              ;  |...use it to figure out where to load from, ... 
                    CLC                       ;  | 
                    ADC $00                   ;  |...add it to the base address... 
                    STA $00                   ; / ...and store it in $00 
                    LDA.W #$0044              ; \  
                    STA $04                   ;  | 
                    LDA.W #$0005              ;  | 
                    STA $06                   ;  |Load colors 2-7 in object palettes 2 and 3 from the address in $00 
                    LDA.W #$0001              ;  | 
                    STA $08                   ;  | 
                    JSR.W LoadColors          ; /  
                    LDA.W #$B318              ; \Store base address in $00, ... 
                    STA $00                   ; / 
                    LDA.W $192E               ; \...get current sprite palette, ... 
                    AND.W #$000F              ; / 
                    TAY                       ; \  
                    LDA.W DATA_00ABD3,Y       ;  | 
                    AND.W #$00FF              ;  |...use it to figure out where to load from, ... 
                    CLC                       ;  | 
                    ADC $00                   ;  |...add it to the base address... 
                    STA $00                   ; / ...and store it in $00 
                    LDA.W #$01C4              ; \  
                    STA $04                   ;  | 
                    LDA.W #$0005              ;  | 
                    STA $06                   ;  |Load colors 2-7 in sprite palettes 6 and 7 from the address in $00 
                    LDA.W #$0001              ;  | 
                    STA $08                   ;  | 
                    JSR.W LoadColors          ; /  
                    LDA.W #$B0B0              ; \Store bade address in $00, ... 
                    STA $00                   ; / 
                    LDA.W $1930               ; \...get current background palette, ... 
                    AND.W #$000F              ; / 
                    TAY                       ; \  
                    LDA.W DATA_00ABD3,Y       ;  | 
                    AND.W #$00FF              ;  |...use it to figure out where to load from, ... 
                    CLC                       ;  | 
                    ADC $00                   ;  |...add it to the base address... 
                    STA $00                   ; / ...and store it in $00 
                    LDA.W #$0004              ; \  
                    STA $04                   ;  | 
                    LDA.W #$0005              ;  | 
                    STA $06                   ;  |Load colors 2-7 in object palettes 0 and 1 from the address in $00 
                    LDA.W #$0001              ;  | 
                    STA $08                   ;  | 
                    JSR.W LoadColors          ; /  
                    LDA.W #$B674              ; \  
                    STA $00                   ;  | 
                    LDA.W #$0052              ;  | 
                    STA $04                   ;  | 
                    LDA.W #$0006              ;  |Load colors 9-F in object palettes 2-4 from 00/B674 
                    STA $06                   ;  | 
                    LDA.W #$0002              ;  | 
                    STA $08                   ;  | 
                    JSR.W LoadColors          ; /  
                    LDA.W #$B674              ; \  
                    STA $00                   ;  | 
                    LDA.W #$0132              ;  | 
                    STA $04                   ;  | 
                    LDA.W #$0006              ;  |Load colors 9-F in sprite palettes 1-3 from 00/B674 
                    STA $06                   ;  | 
                    LDA.W #$0002              ;  | 
                    STA $08                   ;  | 
                    JSR.W LoadColors          ; /  
                    SEP #$30                  ; 8 bit A, X and Y ; Index (8 bit) Accum (8 bit) 
                    RTS                       ; Return 

LoadCol8Pal:        LDY.W #$0007              ; Index (16 bit) Accum (16 bit) 
ADDR_00ACF0:        LDA $04                   
                    STA.W $0703,X             
                    TXA                       
                    CLC                       
                    ADC.W #$0020              
                    TAX                       
                    DEY                       
                    BPL ADDR_00ACF0           
                    RTS                       ; Return 

LoadColors:         LDX $04                   
                    LDY $06                   
ADDR_00AD03:        LDA ($00)                 
                    STA.W $0703,X             
                    INC $00                   
                    INC $00                   
                    INX                       
                    INX                       
                    DEY                       
                    BPL ADDR_00AD03           
                    LDA $04                   
                    CLC                       
                    ADC.W #$0020              
                    STA $04                   
                    DEC $08                   
                    BPL LoadColors            
                    RTS                       ; Return 


DATA_00AD1E:        .db $01,$00,$03,$04,$03,$05,$02

ADDR_00AD25:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDY.W #$B3D8              
                    LDA.W $1EEA               
                    BPL ADDR_00AD32           
                    LDY.W #$B732              
ADDR_00AD32:        STY $00                   
                    LDA.W $1931               
                    AND.W #$000F              
                    DEC A                     
                    TAY                       
                    LDA.W DATA_00AD1E,Y       
                    AND.W #$00FF              
                    ASL                       
                    TAY                       
                    LDA.W DATA_00ABDF,Y       
                    CLC                       
                    ADC $00                   
                    STA $00                   
                    LDA.W #$0082              
                    STA $04                   
                    LDA.W #$0006              
                    STA $06                   
                    LDA.W #$0003              
                    STA $08                   
                    JSR.W LoadColors          
                    LDA.W #$B528              
                    STA $00                   
                    LDA.W #$0052              
                    STA $04                   
                    LDA.W #$0006              
                    STA $06                   
                    LDA.W #$0005              
                    STA $08                   
                    JSR.W LoadColors          
                    LDA.W #$B57C              
                    STA $00                   
                    LDA.W #$0102              
                    STA $04                   
                    LDA.W #$0006              
                    STA $06                   
                    LDA.W #$0007              
                    STA $08                   
                    JSR.W LoadColors          
                    LDA.W #$B5EC              
                    STA $00                   
                    LDA.W #$0010              
                    STA $04                   
                    LDA.W #$0007              
                    STA $06                   
                    LDA.W #$0001              
                    STA $08                   
                    JSR.W LoadColors          
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    RTS                       ; Return 

ADDR_00ADA6:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.W #$B63C              
                    STA $00                   
                    LDA.W #$0010              
                    STA $04                   
                    LDA.W #$0007              
                    STA $06                   
                    LDA.W #$0000              
                    STA $08                   
                    JSR.W LoadColors          
                    LDA.W #$B62C              
                    STA $00                   
                    LDA.W #$0030              
                    STA $04                   
                    LDA.W #$0007              
                    STA $06                   
                    LDA.W #$0000              
                    STA $08                   
                    JSR.W LoadColors          
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    RTS                       ; Return 

ADDR_00ADD9:        JSR.W LoadPalette         
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.W #$0017              
                    STA.W $0701               
                    LDA.W #$B170              
                    STA $00                   
                    LDA.W #$0010              
                    STA $04                   
                    LDA.W #$0007              
                    STA $06                   
                    LDA.W #$0001              
                    STA $08                   
                    JSR.W LoadColors          
                    LDA.W #$B65C              
                    STA $00                   
                    LDA.W #$0000              
                    STA $04                   
                    LDA.W #$0007              
                    STA $06                   
                    LDA.W #$0000              
                    STA $08                   
                    JSR.W LoadColors          
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    RTS                       ; Return 

ADDR_00AE15:        LDA.B #$02                
                    STA.W $192E               
                    LDA.B #$07                
                    STA.W $192D               
                    JSR.W LoadPalette         
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.W #$0017              
                    STA.W $0701               
                    LDA.W #$B5F4              
                    STA $00                   
                    LDA.W #$0018              
                    STA $04                   
                    LDA.W #$0003              
                    STA $06                   
                    STZ $08                   
                    JSR.W LoadColors          
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    RTS                       ; Return 


DATA_00AE41:        .db $00,$05,$0A

DATA_00AE44:        .db $20,$40,$80

ADDR_00AE47:        LDX.B #$02                
ADDR_00AE49:        REP #$20                  ; Accum (16 bit) 
                    LDA.W $0701               
                    LDY.W DATA_00AE41,X       
ADDR_00AE51:        DEY                       
                    BMI ADDR_00AE57           
                    LSR                       
                    BRA ADDR_00AE51           
ADDR_00AE57:        SEP #$20                  ; Accum (8 bit) 
                    AND.B #$1F                
                    ORA.W DATA_00AE44,X       
                    STA.W $2132               ; Fixed Color Data
                    DEX                       
                    BPL ADDR_00AE49           
                    RTS                       ; Return 


DATA_00AE65:        .db $1F,$00,$E0,$03,$00,$7C

DATA_00AE6B:        .db $FF,$FF,$E0,$FF,$00,$FC

DATA_00AE71:        .db $01,$00,$20,$00,$00,$04

DATA_00AE77:        .db $00,$00,$00,$00,$01,$00,$00,$00
                    .db $00,$80,$00,$80,$20,$80,$00,$04
                    .db $80,$80,$80,$80,$08,$82,$40,$10
                    .db $20,$84,$20,$84,$44,$88,$10,$22
                    .db $88,$88,$88,$88,$22,$91,$88,$44
                    .db $48,$92,$48,$92,$92,$A4,$24,$49
                    .db $A4,$A4,$A4,$A4,$49,$A9,$94,$52
                    .db $AA,$AA,$94,$52,$AA,$AA,$54,$55
                    .db $AA,$AA,$AA,$AA,$AA,$D5,$AA,$AA
                    .db $AA,$D5,$AA,$D5,$B5,$D6,$6A,$AD
                    .db $DA,$DA,$DA,$DA,$6D,$DB,$DA,$B6
                    .db $B6,$ED,$B6,$ED,$DD,$EE,$76,$BB
                    .db $EE,$EE,$EE,$EE,$BB,$F7,$EE,$DD
                    .db $DE,$FB,$DE,$FB,$F7,$FD,$BE,$EF
                    .db $FE,$FE,$FE,$FE,$DF,$FF,$FE,$FB
                    .db $FE,$FF,$FE,$FF,$FF,$FF,$FE,$FF
DATA_00AEF7:        .db $00,$80,$00,$40,$00,$20,$00,$10
                    .db $00,$08,$00,$04,$00,$02,$00,$01
                    .db $80,$00,$40,$00,$20,$00,$10,$00
                    .db $08,$00,$04,$00,$02,$00,$01,$00

ADDR_00AF17:        LDY.W $1493               
                    LDA $13                   
                    LSR                       
                    BCC ADDR_00AF25           
                    DEY                       
                    BEQ ADDR_00AF25           
                    STY.W $1493               
ADDR_00AF25:        CPY.B #$A0                
                    BCS ADDR_00AF35           
                    LDA.B #$04                
                    TRB $40                   
                    LDA.B #$09                
                    STA $3E                   
                    JSL.L ADDR_05CBFF         
ADDR_00AF35:        LDA $13                   
                    AND.B #$03                
                    BNE ADDR_00AFA2           
                    LDA.W $1495               
                    CMP.B #$40                
                    BCS ADDR_00AFA2           
                    JSR.W ADDR_00AFA3         ; Index (16 bit) Accum (16 bit) 
                    LDA.W #$01FE              
                    STA.W $0905               
                    LDX.W #$00EE              
ADDR_00AF4E:        LDA.W #$0007              
                    STA $00                   
ADDR_00AF53:        LDA.W $0905,X             
                    STA $02                   
                    LDA.W $0703,X             
                    JSR.W ADDR_00AFC0         
                    LDA $04                   
                    STA.W $0905,X             
                    DEX                       
                    DEX                       
                    DEC $00                   
                    BNE ADDR_00AF53           
                    TXA                       
                    SEC                       
                    SBC.W #$0012              
                    TAX                       
                    BPL ADDR_00AF4E           
                    LDX.W #$0004              
ADDR_00AF74:        LDA.W $091F,X             
                    STA $02                   
                    LDA.W $071D,X             
                    JSR.W ADDR_00AFC0         
                    LDA $04                   
                    STA.W $091F,X             
                    DEX                       
                    DEX                       
                    BPL ADDR_00AF74           
                    LDA.W $0701               
                    STA $02                   
                    LDA.W $0903               
                    JSR.W ADDR_00AFC0         
                    LDA $04                   
                    STA.W $0701               
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    STZ.W $0A05               
                    LDA.B #$03                
                    STA.W $0680               
ADDR_00AFA2:        RTS                       ; Return 

ADDR_00AFA3:        TAY                       
                    INC A                     
                    INC A                     
                    STA.W $1495               
                    TYA                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    AND.W #$0002              
                    STA $0C                   
                    TYA                       
                    AND.W #$001E              
                    TAY                       
                    LDA.W DATA_00AEF7,Y       
                    STA $0E                   
                    RTS                       ; Return 

ADDR_00AFC0:        STA $0A                   
                    AND.W #$001F              
                    ASL                       
                    ASL                       
                    STA $06                   
                    LDA $0A                   
                    AND.W #$03E0              
                    LSR                       
                    LSR                       
                    LSR                       
                    STA $08                   
                    LDA $0B                   
                    AND.W #$007C              
                    STA $0A                   
                    STZ $04                   
                    LDY.W #$0004              
ADDR_00AFDF:        PHY                       
                    LDA.W $0006,Y             
                    ORA $0C                   
                    TAY                       
                    LDA.W DATA_00AE77,Y       
                    PLY                       
                    AND $0E                   
                    BEQ ADDR_00AFF9           
                    LDA.W DATA_00AE6B,Y       
                    BIT.W $1493               
                    BPL ADDR_00AFF9           
                    LDA.W DATA_00AE71,Y       
ADDR_00AFF9:        CLC                       
                    ADC $02                   
                    AND.W DATA_00AE65,Y       
                    TSB $04                   
                    DEY                       
                    DEY                       
                    BPL ADDR_00AFDF           
                    RTS                       ; Return 

ADDR_00B006:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_00AFA3         
                    LDX.W #$006E              
ADDR_00B00F:        LDY.W #$0008              
ADDR_00B012:        LDA.W $0907,X             
                    STA $02                   
                    LDA.W $0783,X             
                    PHY                       
                    JSR.W ADDR_00AFC0         
                    PLY                       
                    LDA $04                   
                    STA.W $0907,X             
                    LDA.W $0783,X             
                    SEC                       
                    SBC $04                   
                    STA.W $0979,X             
                    DEX                       
                    DEX                       
                    DEY                       
                    BNE ADDR_00B012           
                    TXA                       
                    SEC                       
                    SBC.W #$0010              
                    TAX                       
                    BPL ADDR_00B00F           
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    PLB                       
                    RTL                       ; Return 

ADDR_00B03E:        JSR.W ADDR_00AF35         
                    LDA.W $0680               
                    CMP.B #$03                
                    BNE ADDR_00B090           
                    LDA.B #$00                
                    STA $02                   
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.W $0D82               
                    STA $00                   
                    LDY.W #$0014              
ADDR_00B056:        LDA [$00],Y               
                    STA.W $0A11,Y             
                    DEY                       
                    DEY                       
                    BPL ADDR_00B056           
                    LDA.W #$81EE              
                    STA.W $0A05               
                    LDX.W #$00CE              
ADDR_00B068:        LDA.W #$0007              
                    STA $00                   
ADDR_00B06D:        LDA.W $0A25,X             
                    STA $02                   
                    LDA.W $0823,X             
                    JSR.W ADDR_00AFC0         
                    LDA $04                   
                    STA.W $0A25,X             
                    DEX                       
                    DEX                       
                    DEC $00                   
                    BNE ADDR_00B06D           
                    TXA                       
                    SEC                       
                    SBC.W #$0012              
                    TAX                       
                    BPL ADDR_00B068           
                    SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    STZ.W $0AF5               
ADDR_00B090:        RTS                       ; Return 


DATA_00B091:        .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF

DATA_00B0A0:        .db $9F,$5B,$FB,$6F,$80,$5D,$00,$00
                    .db $22,$1D,$C3,$24,$93,$73,$FF,$7F
                    .db $49,$3A,$8B,$42,$CD,$4A,$0F,$53
                    .db $51,$5B,$93,$63,$FF,$7F,$00,$00
                    .db $20,$7F,$80,$7F,$E0,$7F,$E0,$7F
                    .db $42,$39,$08,$52,$CE,$6A,$12,$63
                    .db $55,$6B,$98,$73,$42,$39,$08,$52
                    .db $CE,$6A,$42,$39,$08,$52,$CE,$6A
                    .db $D6,$4E,$18,$57,$5A,$5F,$9C,$67
                    .db $DE,$6F,$FF,$77,$FF,$7F,$00,$00
                    .db $20,$7F,$80,$7F,$E0,$7F,$E0,$7F
                    .db $A3,$20,$48,$31,$AC,$3D,$CE,$39
                    .db $32,$3E,$B6,$4A,$A2,$20,$25,$2D
                    .db $68,$35,$8A,$35,$E4,$24,$52,$4A
                    .db $C8,$50,$CC,$59,$6D,$52,$EB,$58
                    .db $4C,$65,$D0,$5A,$80,$5D,$39,$7F
                    .db $93,$7E,$A8,$65,$48,$56,$28,$57
                    .db $62,$14,$46,$35,$A9,$45,$0D,$52
                    .db $B1,$62,$77,$7B,$00,$00,$1E,$7B
                    .db $9F,$7B,$99,$7F,$F6,$7F,$FC,$7F
                    .db $00,$00,$C5,$24,$49,$2D,$AD,$2D
                    .db $53,$22,$18,$3F,$60,$10,$81,$18
                    .db $A3,$1C,$E4,$1C,$09,$29,$4B,$25
                    .db $60,$09,$A4,$01,$E8,$01,$2C,$02
                    .db $91,$02,$F5,$02,$FF,$7F,$00,$00
                    .db $E0,$7E,$20,$7F,$80,$7F,$E0,$7F
                    .db $93,$73,$00,$00,$FB,$0C,$EB,$2F
                    .db $93,$73,$00,$00,$DD,$7F,$7F,$2D
                    .db $93,$73,$00,$00,$AB,$7A,$FF,$7F
                    .db $93,$73,$00,$00,$9B,$1E,$7F,$3B
                    .db $00,$00,$AF,$0D,$79,$2E,$E0,$25
                    .db $1C,$2B,$20,$03,$00,$00,$6B,$2D
                    .db $EF,$3D,$73,$4E,$18,$63,$9C,$73
                    .db $00,$00,$E9,$00,$0D,$22,$8E,$05
                    .db $33,$1A,$B7,$32,$00,$00,$E0,$2D
                    .db $E0,$52,$7F,$15,$5F,$32,$3F,$4B
                    .db $00,$00,$C8,$59,$CE,$72,$CB,$39
                    .db $30,$3E,$B3,$4A,$00,$00,$16,$00
                    .db $1B,$00,$5F,$01,$1F,$02,$1F,$03
                    .db $00,$00,$EC,$49,$4F,$52,$B2,$5A
                    .db $15,$67,$DB,$7F,$00,$00,$16,$00
                    .db $1B,$00,$5F,$01,$1F,$02,$1F,$03
                    .db $00,$00,$C9,$08,$4E,$19,$D3,$29
                    .db $78,$3E,$1D,$53,$00,$00,$C8,$14
                    .db $09,$1D,$6C,$29,$CF,$35,$32,$42
                    .db $EF,$55,$B5,$6E,$F7,$76,$39,$7F
                    .db $7B,$7F,$BD,$7F,$00,$00,$C9,$2C
                    .db $4E,$41,$D3,$55,$78,$6E,$1D,$7F
                    .db $00,$00,$E9,$01,$AC,$02,$2F,$03
                    .db $99,$03,$FE,$53,$00,$00,$00,$00
                    .db $00,$00,$8F,$3C,$D8,$61,$7F,$7E
                    .db $00,$00,$C5,$24,$49,$2D,$AD,$2D
                    .db $53,$22,$18,$3F,$00,$00,$16,$00
                    .db $1B,$00,$5F,$01,$1F,$02,$1F,$03
                    .db $CE,$39,$00,$00,$18,$63,$34,$7F
                    .db $95,$7F,$F8,$7F,$00,$00,$B7,$32
                    .db $FB,$67,$00,$02,$20,$03,$E0,$03
                    .db $00,$00,$71,$0D,$3F,$7C,$9B,$1E
                    .db $7F,$13,$FF,$03,$00,$00,$17,$28
                    .db $1F,$40,$29,$45,$AD,$59,$10,$66
                    .db $00,$00,$71,$0D,$9B,$1E,$7F,$3B
                    .db $FF,$7F,$FF,$7F,$00,$00,$CE,$39
                    .db $94,$52,$18,$63,$9C,$73,$5F,$2C
                    .db $00,$00,$FF,$01,$1F,$03,$FF,$03
                    .db $B7,$00,$3F,$02,$00,$00,$08,$6D
                    .db $AD,$6D,$31,$7E,$B7,$00,$3F,$02
                    .db $00,$00,$11,$00,$17,$00,$1F,$00
                    .db $B7,$00,$3F,$02,$00,$00,$E0,$01
                    .db $E0,$02,$E0,$03,$B7,$00,$3F,$02
                    .db $5F,$63,$1D,$58,$0A,$00,$1F,$39
                    .db $C4,$44,$08,$4E,$70,$67,$B6,$30
                    .db $DF,$35,$FF,$03,$3F,$4F,$1D,$58
                    .db $40,$11,$E0,$3F,$07,$3C,$AE,$7C
                    .db $B3,$7D,$00,$2F,$5F,$16,$FF,$03
                    .db $5F,$63,$1D,$58,$29,$25,$FF,$7F
                    .db $08,$00,$17,$00,$1F,$00,$7B,$57
                    .db $DF,$0D,$FF,$03,$1F,$3B,$1D,$58
                    .db $29,$25,$FF,$7F,$40,$11,$E0,$01
                    .db $E0,$02,$7B,$57,$DF,$0D,$FF,$03
                    .db $00,$00,$C5,$24,$49,$2D,$AD,$2D
                    .db $53,$22,$18,$3F,$23,$25,$C4,$35
                    .db $25,$3E,$86,$46,$E7,$4E,$1F,$40
                    .db $00,$00,$C6,$41,$54,$73,$FA,$7F
                    .db $FD,$7F,$08,$6D,$00,$00,$34,$34
                    .db $3A,$44,$9F,$65,$16,$01,$7F,$02
                    .db $00,$00,$C5,$24,$49,$2D,$AD,$2D
                    .db $53,$22,$18,$3F,$00,$00,$AE,$2D
                    .db $32,$3E,$B6,$4A,$F9,$52,$F3,$2C
                    .db $00,$00,$6B,$51,$6D,$4E,$B3,$4F
                    .db $BF,$30,$1D,$37,$32,$2E,$0D,$4A
                    .db $88,$10,$4A,$21,$6D,$29,$CF,$3D
                    .db $00,$00,$40,$29,$E0,$3D,$80,$52
                    .db $B7,$00,$3F,$02,$00,$00,$CE,$39
                    .db $94,$52,$18,$63,$B7,$00,$3F,$02
                    .db $00,$00,$70,$7E,$D3,$7E,$36,$7F
                    .db $99,$7F,$1F,$40,$00,$00,$CE,$39
                    .db $94,$52,$18,$63,$9C,$73,$5F,$2C
                    .db $00,$00,$DF,$4E,$DE,$5A,$BD,$66
                    .db $7C,$72,$1F,$40,$00,$00,$F5,$7F
                    .db $F7,$7F,$F9,$7F,$FC,$7F,$FF,$7F
DATA_00B3C0:        .db $00,$00,$FB,$63,$0C,$03,$0B,$02
                    .db $35,$15,$5F,$1A

DATA_00B3CC:        .db $00,$00,$34,$34,$3A,$44,$9F,$65
                    .db $16,$01,$7F,$02,$00,$00,$28,$12
                    .db $A8,$12,$48,$13,$7B,$32,$BF,$5B
                    .db $60,$7D,$00,$00,$DE,$7B,$48,$13
                    .db $60,$7D,$7B,$32,$BF,$37,$7F,$2D
                    .db $00,$00,$68,$32,$E8,$32,$48,$13
                    .db $FF,$5E,$7F,$6F,$60,$7D,$00,$00
                    .db $DE,$7B,$3B,$57,$A0,$7E,$F6,$01
                    .db $A8,$12,$48,$13,$00,$00,$28,$12
                    .db $A8,$12,$48,$13,$7B,$32,$BF,$5B
                    .db $28,$7E,$00,$00,$DE,$7B,$48,$13
                    .db $28,$7E,$7B,$32,$BF,$37,$FF,$03
                    .db $00,$00,$12,$32,$75,$3E,$3B,$57
                    .db $7B,$32,$BF,$5B,$28,$7E,$00,$00
                    .db $DE,$7B,$3B,$57,$28,$7E,$7B,$32
                    .db $C4,$38,$48,$13,$C7,$2C,$F0,$69
                    .db $B2,$66,$D5,$67,$34,$66,$DE,$53
                    .db $FF,$7F,$C7,$2C,$60,$45,$80,$66
                    .db $F7,$7F,$1F,$03,$7F,$03,$FF,$47
                    .db $2C,$41,$F0,$69,$B2,$66,$D5,$67
                    .db $1F,$00,$FF,$7F,$C7,$2C,$C7,$2C
                    .db $F0,$69,$B2,$66,$D5,$67,$2C,$41
                    .db $D5,$3A,$9C,$5B,$00,$00,$EC,$49
                    .db $2E,$56,$F1,$62,$26,$31,$BF,$5B
                    .db $00,$00,$00,$00,$DE,$7B,$95,$57
                    .db $28,$7E,$26,$31,$BF,$37,$7F,$2D
                    .db $00,$00,$26,$31,$89,$3D,$EC,$49
                    .db $26,$31,$BF,$5B,$28,$7E,$00,$00
                    .db $DE,$7B,$3B,$57,$C6,$32,$26,$31
                    .db $7F,$03,$7F,$03,$00,$00,$05,$1A
                    .db $C5,$0A,$EF,$22,$75,$1A,$59,$43
                    .db $60,$7D,$00,$00,$39,$77,$EF,$22
                    .db $60,$7D,$18,$1E,$5C,$37,$09,$7E
                    .db $00,$00,$60,$36,$20,$4B,$EF,$22
                    .db $5A,$4E,$3A,$53,$60,$7D,$00,$00
                    .db $7B,$32,$EF,$22,$19,$21,$F6,$01
                    .db $E6,$2D,$A8,$36,$C7,$2C,$F0,$69
                    .db $00,$00,$00,$00,$34,$66,$F9,$7F
                    .db $FF,$7F,$00,$00,$60,$45,$80,$66
                    .db $F7,$7F,$1F,$03,$7F,$03,$FF,$47
                    .db $2C,$41,$F0,$69,$B2,$66,$D5,$67
                    .db $1F,$00,$FF,$7F,$C7,$2C,$C7,$2C
                    .db $F0,$69,$B2,$66,$D5,$67,$2C,$41
                    .db $D5,$3A,$9C,$5B,$00,$00,$E7,$2C
                    .db $6B,$3D,$EF,$4D,$73,$5E,$F7,$6E
                    .db $FF,$7F,$F1,$7F,$BF,$01,$00,$7E
                    .db $BF,$03,$E0,$03,$FC,$7F,$FF,$7F
                    .db $00,$00,$4F,$19,$78,$3E,$3E,$57
                    .db $20,$7E,$E0,$7E,$E0,$7F,$00,$00
                    .db $31,$52,$F6,$66,$9C,$7B,$85,$16
                    .db $4B,$2F,$F1,$47,$00,$00,$4F,$19
                    .db $78,$3E,$3E,$57,$FF,$03,$DE,$7B
                    .db $1F,$7C,$00,$00,$4F,$19,$78,$3E
                    .db $3E,$57,$7F,$2D,$4B,$2F,$F1,$47
                    .db $FF,$7F,$00,$00,$71,$0D,$7F,$03
                    .db $FF,$4F,$3F,$4F,$E0,$7F,$FF,$7F
                    .db $00,$00,$E0,$01,$AD,$7D,$80,$03
                    .db $B7,$00,$3F,$02,$FF,$7F,$00,$00
                    .db $16,$00,$1F,$00,$08,$6D,$DD,$2D
                    .db $5F,$63,$FF,$7F,$00,$00,$80,$02
                    .db $E0,$03,$08,$6D,$1A,$26,$3B,$57
                    .db $FF,$7F,$00,$00,$E0,$7E,$20,$7F
                    .db $80,$7F,$E0,$7F,$E0,$7F,$FF,$7F
                    .db $00,$00,$E0,$7E,$20,$7F,$80,$7F
                    .db $E0,$7F,$E0,$7F,$00,$00,$1B,$00
                    .db $2D,$46,$F3,$5E,$85,$16,$4B,$2F
                    .db $F1,$47

DATA_00B5DE:        .db $00,$00,$E7,$2C,$6B,$3D,$EF,$4D
                    .db $73,$5E,$F7,$6E,$FF,$7F,$93,$73
                    .db $00,$00,$FF,$03,$3B,$57,$93,$73
                    .db $75,$3E,$12,$32,$AF,$25,$93,$73
                    .db $3B,$57,$FF,$7F,$00,$00,$93,$73
                    .db $00,$00,$3B,$57,$6C,$7E

DATA_00B60C:        .db $DF

DATA_00B60D:        .db $02,$5F,$03,$FF,$27,$FF,$5F,$FF
                    .db $73,$FF,$5F,$FF,$27,$5F,$03,$BF
                    .db $01,$1F,$00,$1B,$00,$18,$00,$18
                    .db $00,$1B,$00,$1F,$00,$BF,$01,$7F
                    .db $43,$00,$00,$60,$7F,$3F,$17,$7F
                    .db $43,$00,$00,$FF,$1C,$20,$03,$7F
                    .db $43,$00,$00,$20,$03,$60,$7F,$7F
                    .db $43,$BF,$5B,$7B,$32,$E7,$08,$00
                    .db $7E,$20,$7E,$A0,$7E,$E0,$7E,$20
                    .db $7F,$80,$7F,$E0,$7F,$E0,$7F,$00
                    .db $00,$E0,$1C,$E8,$3D,$F0,$5E,$F8
                    .db $7F,$FF,$7F,$85,$16,$4B,$2F

DATA_00B66C:        .db $93,$73,$00,$00,$71,$0D,$9B,$1E
                    .db $FF,$7F,$00,$00,$20,$03,$16,$00
                    .db $1F,$00,$7F,$01,$9F,$02,$FF,$7F
                    .db $00,$00,$20,$03,$7D,$34,$1E,$55
                    .db $FF,$65,$1F,$7B,$FF,$7F,$00,$00
                    .db $20,$03,$80,$03,$F1,$1F,$F9,$03
                    .db $FF,$4F

DATA_00B69E:        .db $FF,$7F,$C0,$18,$FB,$63,$0C,$03
                    .db $0B,$02,$35,$15,$5F,$1A,$9B,$77
                    .db $60,$18,$97,$5B,$A8,$02,$A7,$01
                    .db $D1,$0C,$FB,$11,$37,$6F,$00,$18
                    .db $33,$53,$45,$02,$43,$01,$6E,$04
                    .db $97,$09,$D3,$66,$00,$10,$CF,$4A
                    .db $E1,$01,$E0,$00,$0A,$00,$33,$01
                    .db $6F,$5E,$00,$00,$6B,$42,$80,$01
                    .db $80,$00,$06,$00,$CF,$00,$0B,$56
                    .db $00,$00,$07,$3A,$20,$01,$20,$00
                    .db $02,$00,$6B,$00,$A7,$4D,$00,$00
                    .db $A3,$31,$C0,$00,$00,$00,$00,$00
                    .db $07,$00,$43,$45,$00,$00,$40,$29
                    .db $60,$00,$00,$00,$00,$00,$03,$00
DATA_00B70E:        .db $C4,$44,$20,$03,$DF,$4A,$00,$02
                    .db $3B,$01,$08,$4E

DATA_00B71A:        .db $C4,$44,$1F,$39,$DF,$4A,$74,$28
                    .db $3F,$01,$08,$4E

DATA_00B726:        .db $D2,$28,$1E,$55,$5F,$63,$1F,$7B
                    .db $FB,$01,$DE,$02,$00,$00,$33,$15
                    .db $B7,$25,$3B,$36,$AF,$25,$BF,$5B
                    .db $C6,$5A,$00,$00,$DE,$7B,$3B,$36
                    .db $C6,$5A,$AF,$25,$BF,$37,$7F,$2D
                    .db $00,$00,$33,$15,$B7,$25,$3B,$36
                    .db $FF,$5E,$7F,$6F,$C6,$5A,$00,$00
                    .db $DE,$7B,$3B,$57,$C6,$5A,$AF,$25
                    .db $A8,$12,$48,$13,$00,$00,$B7,$25
                    .db $3B,$36,$BF,$46,$AF,$25,$5F,$5B
                    .db $C6,$5A,$00,$00,$DE,$7B,$BF,$46
                    .db $C6,$5A,$AF,$25,$BF,$37,$FF,$03
                    .db $00,$00,$85,$16,$4B,$2F,$F1,$47
                    .db $AF,$25,$5F,$5B,$C6,$5A,$00,$00
                    .db $DE,$7B,$3B,$57,$C6,$5A,$AF,$25
                    .db $C4,$38,$48,$13,$E7,$1C,$F3,$19
                    .db $B9,$32,$7F,$4B,$10,$76,$B9,$2E
                    .db $FF,$7F,$E7,$1C,$60,$45,$80,$66
                    .db $F7,$7F,$1F,$03,$7F,$03,$FF,$47
                    .db $E7,$1C,$F3,$19,$B9,$32,$7F,$4B
                    .db $1F,$00,$FF,$7F,$E7,$1C,$E7,$1C
                    .db $F3,$19,$B9,$32,$7F,$4B,$C6,$58
                    .db $D5,$3A,$9C,$5B,$00,$00,$6D,$1D
                    .db $D0,$29,$33,$36,$6B,$2D,$F9,$4E
                    .db $00,$00,$00,$00,$DE,$7B,$33,$36
                    .db $82,$30,$6B,$2D,$BF,$37,$7F,$2D
                    .db $00,$00,$A7,$00,$2B,$15,$8E,$21
                    .db $6B,$2D,$F9,$4E,$82,$30,$00,$00
                    .db $DE,$7B,$F9,$4E,$82,$30,$6B,$2D
                    .db $82,$30,$48,$13,$00,$00,$71,$21
                    .db $F5,$31,$79,$32,$F6,$41,$3B,$57
                    .db $60,$7D,$00,$00,$39,$77,$79,$32
                    .db $60,$7D,$18,$1E,$5C,$37,$09,$7E
                    .db $00,$00,$60,$36,$20,$4B,$EF,$22
                    .db $7A,$52,$3A,$53,$60,$7D,$00,$00
                    .db $8E,$21,$79,$32,$19,$21,$75,$3E
                    .db $35,$11,$98,$1D,$C7,$2C,$F0,$69
                    .db $00,$00,$00,$00,$34,$66,$F9,$7F
                    .db $FF,$7F,$00,$00,$60,$45,$80,$66
                    .db $F7,$7F,$1F,$03,$7F,$03,$FF,$47
                    .db $2C,$41,$F0,$69,$B2,$66,$D5,$67
                    .db $1F,$00,$FF,$7F,$C7,$2C,$C7,$2C
                    .db $F0,$69,$B2,$66,$D5,$67,$2C,$41
                    .db $D5,$3A,$9C,$5B,$C0,$BF,$08,$00
                    .db $80,$08

ADDR_00B888:        REP #$10                  ; Index (16 bit) 
                    LDY.W #$BFC0              ; \  
                    STY $8A                   ;  |Store the address 08/BFC0 at $8A-$8C 
                    LDA.B #$08                ;  | 
                    STA $8C                   ; /  
                    LDY.W #$2000              ; \  
                    STY $00                   ;  |Store the address 7E/2000 at $00-$02 
                    LDA.B #$7E                ;  | 
                    STA $02                   ; /  
                    JSR.W ADDR_00B8DE         
                    LDA.B #$7E                ; \  
                    STA $8F                   ;  | 
                    REP #$30                  ;  |Store the address 7E/ACFE at $8D-$8F ; Index (16 bit) Accum (16 bit) 
                    LDA.W #$ACFE              ;  | 
                    STA $8D                   ; /  
                    LDX.W #$23FF              
ADDR_00B8AD:        LDY.W #$0008              
ADDR_00B8B0:        LDA.L $7E2000,X           
                    AND.W #$00FF              
                    STA [$8D]                 
                    DEX                       
                    DEC $8D                   
                    DEC $8D                   
                    DEY                       
                    BNE ADDR_00B8B0           
                    LDY.W #$0008              
ADDR_00B8C4:        DEX                       
                    LDA.L $7E2000,X           
                    STA [$8D]                 
                    DEX                       
                    BMI ADDR_00B8D7           
                    DEC $8D                   
                    DEC $8D                   
                    DEY                       
                    BNE ADDR_00B8C4           
                    BRA ADDR_00B8AD           
ADDR_00B8D7:        LDA.W #$8000              
                    STA $8A                   
                    SEP #$20                  ; Accum (8 bit) 
ADDR_00B8DE:        REP #$10                  ; Index (16 bit) 
                    LDY.W #$0000              ; \  
ADDR_00B8E3:        JSR.W ReadByte            ;  | 
                    CMP.B #$FF                ;  |If the next byte is xFF, return. 
                    BNE ADDR_00B8ED           ;  |Compressed graphics files ends with xFF IIRC 
                    SEP #$10                  ;  | ; Index (8 bit) 
                    RTS                       ; /  

ADDR_00B8ED:        STA $8F                   
                    AND.B #$E0                
                    CMP.B #$E0                
                    BEQ ADDR_00B8FF           
                    PHA                       
                    LDA $8F                   
                    REP #$20                  ; Accum (16 bit) 
                    AND.W #$001F              
                    BRA ADDR_00B911           
ADDR_00B8FF:        LDA $8F                   ; Accum (8 bit) 
                    ASL                       
                    ASL                       
                    ASL                       
                    AND.B #$E0                
                    PHA                       
                    LDA $8F                   
                    AND.B #$03                
                    XBA                       
                    JSR.W ReadByte            
                    REP #$20                  ; Accum (16 bit) 
ADDR_00B911:        INC A                     
                    STA $8D                   
                    SEP #$20                  ; Accum (8 bit) 
                    PLA                       
                    BEQ ADDR_00B930           
                    BMI ADDR_00B966           
                    ASL                       
                    BPL ADDR_00B93F           
                    ASL                       
                    BPL ADDR_00B94C           
                    JSR.W ReadByte            
                    LDX $8D                   
ADDR_00B926:        STA [$00],Y               
                    INC A                     
                    INY                       
                    DEX                       
                    BNE ADDR_00B926           
                    JMP.W ADDR_00B8E3         
ADDR_00B930:        JSR.W ReadByte            
                    STA [$00],Y               
                    INY                       
                    LDX $8D                   
                    DEX                       
                    STX $8D                   
                    BNE ADDR_00B930           
                    BRA ADDR_00B8E3           
ADDR_00B93F:        JSR.W ReadByte            
                    LDX $8D                   
ADDR_00B944:        STA [$00],Y               
                    INY                       
                    DEX                       
                    BNE ADDR_00B944           
                    BRA ADDR_00B8E3           
ADDR_00B94C:        JSR.W ReadByte            
                    XBA                       
                    JSR.W ReadByte            
                    LDX $8D                   
ADDR_00B955:        XBA                       
                    STA [$00],Y               
                    INY                       
                    DEX                       
                    BEQ ADDR_00B963           
                    XBA                       
                    STA [$00],Y               
                    INY                       
                    DEX                       
                    BNE ADDR_00B955           
ADDR_00B963:        JMP.W ADDR_00B8E3         
ADDR_00B966:        JSR.W ReadByte            
                    XBA                       
                    JSR.W ReadByte            
                    TAX                       
ADDR_00B96E:        PHY                       
                    TXY                       
                    LDA [$00],Y               
                    TYX                       
                    PLY                       
                    STA [$00],Y               
                    INY                       
                    INX                       
                    REP #$20                  ; Accum (16 bit) 
                    DEC $8D                   
                    SEP #$20                  ; Accum (8 bit) 
                    BNE ADDR_00B96E           
                    JMP.W ADDR_00B8E3         
ReadByte:           LDA [$8A]                 ; Read the byte ; Index (16 bit) 
                    LDX $8A                   ; \ Go to next byte 
                    INX                       ;  | 
                    BNE ADDR_00B98F           ;  |   \  
                    LDX.W #$8000              ;  |    |Handle bank crossing 
                    INC $8C                   ;  |   /  
ADDR_00B98F:        STX $8A                   ; /  
                    RTS                       ; Return 


DATA_00B992:        .db $F9,$31,$BB,$52,$7D,$63,$6C,$10
                    .db $57,$A1,$15,$9C,$63,$D2,$CB,$E5
                    .db $1E,$AF,$BD,$10,$48,$E8,$74,$B4
                    .db $AD,$E4,$80,$66,$7E,$88,$7F,$43
                    .db $A1,$65,$CD,$CA,$E5,$B5,$21,$44
                    .db $6C,$A3,$7B,$F0,$B9,$06,$36,$85
                    .db $BB,$00

DATA_00B9C4:        .db $D9,$E2,$EC,$F5,$FF,$89,$93,$9D
                    .db $A6,$AF,$BA,$C3,$CD,$D5,$DD,$E6
                    .db $EF,$F7,$FF,$89,$93,$9A,$A3,$A9
                    .db $B2,$BB,$C3,$CC,$D4,$DC,$E6,$EE
                    .db $F6,$FF,$88,$91,$9A,$A3,$AE,$B7
                    .db $C0,$C6,$CB,$D0,$D7,$E0,$E9,$F1
                    .db $F3,$F8

DATA_00B9F6:        .db $08,$08,$08,$08,$08,$09,$09,$09
                    .db $09,$09,$09,$09,$09,$09,$09,$09
                    .db $09,$09,$09,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
                    .db $0A,$0A,$0B,$0B,$0B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
                    .db $0B,$0B

ADDR_00BA28:        PHB                       ; Accum (8 bit) 
                    PHY                       
                    PHK                       
                    PLB                       
                    LDA.W DATA_00B992,Y       
                    STA $8A                   
                    LDA.W DATA_00B9C4,Y       
                    STA $8B                   
                    LDA.W DATA_00B9F6,Y       
                    STA $8C                   
                    LDA.B #$00                
                    STA $00                   
                    LDA.B #$AD                
                    STA $01                   
                    LDA.B #$7E                
                    STA $02                   
                    JSR.W ADDR_00B8DE         
                    PLY                       
                    PLB                       
                    RTL                       ; Return 


DATA_00BA4D:        .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF

DATA_00BA60:        .db $00,$B0,$60,$10,$C0,$70,$20,$D0
                    .db $80,$30,$E0,$90,$40,$F0,$A0,$50
DATA_00BA70:        .db $00,$B0,$60,$10,$C0,$70,$20,$D0
                    .db $80,$30,$E0,$90,$40,$F0,$A0,$50
DATA_00BA80:        .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00

DATA_00BA8E:        .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00

DATA_00BA9C:        .db $C8,$C9,$CB,$CD,$CE,$D0,$D2,$D3
                    .db $D5,$D7,$D8,$DA,$DC,$DD,$DF,$E1
DATA_00BAAC:        .db $E3,$E4,$E6,$E8,$E9,$EB,$ED,$EE
                    .db $F0,$F2,$F3,$F5,$F7,$F8,$FA,$FC
DATA_00BABC:        .db $C8,$CA,$CC,$CE,$D0,$D2,$D4,$D6
                    .db $D8,$DA,$DC,$DE,$E0,$E2

DATA_00BACA:        .db $E4,$E6,$E8,$EA,$EC,$EE,$F0,$F2
                    .db $F4,$F6,$F8,$FA,$FC,$FE,$00,$C8
                    .db $7E,$B0,$C9,$7E,$60,$CB,$7E,$10
                    .db $CD,$7E,$C0,$CE,$7E,$70,$D0,$7E
                    .db $20,$D2,$7E,$D0,$D3,$7E,$80,$D5
                    .db $7E,$30,$D7,$7E,$E0,$D8,$7E,$90
                    .db $DA,$7E,$40,$DC,$7E,$F0,$DD,$7E
                    .db $A0,$DF,$7E,$50,$E1,$7E,$00,$E3
                    .db $7E,$B0,$E4,$7E,$60,$E6,$7E,$10
                    .db $E8,$7E,$C0,$E9,$7E,$70,$EB,$7E
                    .db $20,$ED,$7E,$D0,$EE,$7E,$80,$F0
                    .db $7E,$30,$F2,$7E,$E0,$F3,$7E,$90
                    .db $F5,$7E,$40,$F7,$7E,$F0,$F8,$7E
                    .db $A0,$FA,$7E,$50,$FC,$7E,$00,$C8
                    .db $7E,$00,$CA,$7E,$00,$CC,$7E,$00
                    .db $CE,$7E,$00,$D0,$7E,$00,$D2,$7E
                    .db $00,$D4,$7E,$00,$D6,$7E,$00,$D8
                    .db $7E,$00,$DA,$7E,$00,$DC,$7E,$00
                    .db $DE,$7E,$00,$E0,$7E,$00,$E2,$7E
                    .db $00,$E3,$7E,$B0,$E4,$7E,$60,$E6
                    .db $7E,$10,$E8,$7E,$C0,$E9,$7E,$70
                    .db $EB,$7E,$20,$ED,$7E,$D0,$EE,$7E
                    .db $80,$F0,$7E,$30,$F2,$7E,$E0,$F3
                    .db $7E,$90,$F5,$7E,$40,$F7,$7E,$F0
                    .db $F8,$7E,$A0,$FA,$7E,$50,$FC,$7E
                    .db $00,$C8,$7E,$B0,$C9,$7E,$60,$CB
                    .db $7E,$10,$CD,$7E,$C0,$CE,$7E,$70
                    .db $D0,$7E,$20,$D2,$7E,$D0,$D3,$7E
                    .db $80,$D5,$7E,$30,$D7,$7E,$E0,$D8
                    .db $7E,$90,$DA,$7E,$40,$DC,$7E,$F0
                    .db $DD,$7E,$A0,$DF,$7E,$50,$E1,$7E
                    .db $00,$E4,$7E,$00,$E6,$7E,$00,$E8
                    .db $7E,$00,$EA,$7E,$00,$EC,$7E,$00
                    .db $EE,$7E,$00,$F0,$7E,$00,$F2,$7E
                    .db $00,$F4,$7E,$00,$F6,$7E,$00,$F8
                    .db $7E,$00,$FA,$7E,$00,$FC,$7E,$00
                    .db $FE,$7E,$00,$C8,$7E,$00,$CA,$7E
                    .db $00,$CC,$7E,$00,$CE,$7E,$00,$D0
                    .db $7E,$00,$D2,$7E,$00,$D4,$7E,$00
                    .db $D6,$7E,$00,$D8,$7E,$00,$DA,$7E
                    .db $00,$DC,$7E,$00,$DE,$7E,$00,$E0
                    .db $7E,$00,$E2,$7E,$00,$E4,$7E,$00
                    .db $E6,$7E,$00,$E8,$7E,$00,$EA,$7E
                    .db $00,$EC,$7E,$00,$EE,$7E,$00,$F0
                    .db $7E,$00,$F2,$7E,$00,$F4,$7E,$00
                    .db $F6,$7E,$00,$F8,$7E,$00,$FA,$7E
                    .db $00,$FC,$7E,$00,$FE,$7E,$00,$C8
                    .db $7F,$B0,$C9,$7F,$60,$CB,$7F,$10
                    .db $CD,$7F,$C0,$CE,$7F,$70,$D0,$7F
                    .db $20,$D2,$7F,$D0,$D3,$7F,$80,$D5
                    .db $7F,$30,$D7,$7F,$E0,$D8,$7F,$90
                    .db $DA,$7F,$40,$DC,$7F,$F0,$DD,$7F
                    .db $A0,$DF,$7F,$50,$E1,$7F,$00,$E3
                    .db $7F,$B0,$E4,$7F,$60,$E6,$7F,$10
                    .db $E8,$7F,$C0,$E9,$7F,$70,$EB,$7F
                    .db $20,$ED,$7F,$D0,$EE,$7F,$80,$F0
                    .db $7F,$30,$F2,$7F,$E0,$F3,$7F,$90
                    .db $F5,$7F,$40,$F7,$7F,$F0,$F8,$7F
                    .db $A0,$FA,$7F,$50,$FC,$7F,$00,$C8
                    .db $7F,$00,$CA,$7F,$00,$CC,$7F,$00
                    .db $CE,$7F,$00,$D0,$7F,$00,$D2,$7F
                    .db $00,$D4,$7F,$00,$D6,$7F,$00,$D8
                    .db $7F,$00,$DA,$7F,$00,$DC,$7F,$00
                    .db $DE,$7F,$00,$E0,$7F,$00,$E2,$7F
                    .db $00,$E3,$7F,$B0,$E4,$7F,$60,$E6
                    .db $7F,$10,$E8,$7F,$C0,$E9,$7F,$70
                    .db $EB,$7F,$20,$ED,$7F,$D0,$EE,$7F
                    .db $80,$F0,$7F,$30,$F2,$7F,$E0,$F3
                    .db $7F,$90,$F5,$7F,$40,$F7,$7F,$F0
                    .db $F8,$7F,$A0,$FA,$7F,$50,$FC,$7F
                    .db $00,$C8,$7F,$B0,$C9,$7F,$60,$CB
                    .db $7F,$10,$CD,$7F,$C0,$CE,$7F,$70
                    .db $D0,$7F,$20,$D2,$7F,$D0,$D3,$7F
                    .db $80,$D5,$7F,$30,$D7,$7F,$E0,$D8
                    .db $7F,$90,$DA,$7F,$40,$DC,$7F,$F0
                    .db $DD,$7F,$A0,$DF,$7F,$50,$E1,$7F
                    .db $00,$E4,$7F,$00,$E6,$7F,$00,$E8
                    .db $7F,$00,$EA,$7F,$00,$EC,$7F,$00
                    .db $EE,$7F,$00,$F0,$7F,$00,$F2,$7F
                    .db $00,$F4,$7F,$00,$F6,$7F,$00,$F8
                    .db $7F,$00,$FA,$7F,$00,$FC,$7F,$00
                    .db $FE,$7F,$00,$C8,$7F,$00,$CA,$7F
                    .db $00,$CC,$7F,$00,$CE,$7F,$00,$D0
                    .db $7F,$00,$D2,$7F,$00,$D4,$7F,$00
                    .db $D6,$7F,$00,$D8,$7F,$00,$DA,$7F
                    .db $00,$DC,$7F,$00,$DE,$7F,$00,$E0
                    .db $7F,$00,$E2,$7F,$00,$E4,$7F,$00
                    .db $E6,$7F,$00,$E8,$7F,$00,$EA,$7F
                    .db $00,$EC,$7F,$00,$EE,$7F,$00,$F0
                    .db $7F,$00,$F2,$7F,$00,$F4,$7F,$00
                    .db $F6,$7F,$00,$F8,$7F,$00,$FA,$7F
                    .db $00,$FC,$7F,$00,$FE,$7F

DATA_00BDA8:        .db $D8

DATA_00BDA9:        .db $BA,$D8,$BA,$D8,$BA,$38,$BB,$38
                    .db $BB,$92,$BB,$92,$BB,$EC,$BB,$EC
                    .db $BB,$00,$00,$EC,$BB,$00,$00,$D8
                    .db $BA,$EC,$BB,$D8,$BA,$D8,$BA,$00
                    .db $00,$D8,$BA,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$D8,$BA,$D8,$BA

DATA_00BDE8:        .db $08

DATA_00BDE9:        .db $BB,$08,$BB,$08,$BB,$62,$BB,$62
                    .db $BB,$C2,$BB,$C2,$BB,$16,$BC,$16
                    .db $BC,$00,$00,$16,$BC,$00,$00,$08
                    .db $BB,$16,$BC,$08,$BB,$08,$BB,$00
                    .db $00,$08,$BB,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$08,$BB,$08,$BB

DATA_00BE28:        .db $40

DATA_00BE29:        .db $BC,$40,$BC,$40,$BC,$A0,$BC,$A0
                    .db $BC,$FA,$BC,$FA,$BC,$54,$BD,$54
                    .db $BD,$00,$00,$54,$BD,$00,$00,$40
                    .db $BC,$54,$BD,$40,$BC,$40,$BC,$00
                    .db $00,$40,$BC,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$40,$BC,$40,$BC

DATA_00BE68:        .db $70

DATA_00BE69:        .db $BC,$70,$BC,$70,$BC,$CA,$BC,$CA
                    .db $BC,$2A,$BD,$2A,$BD,$7E,$BD,$7E
                    .db $BD,$00,$00,$7E,$BD,$00,$00,$70
                    .db $BC,$7E,$BD,$70,$BC,$70,$BC,$00
                    .db $00,$70,$BC,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$70,$BC,$70,$BC

LoadBlkTable1:      .db $A8

DATA_00BEA9:        .db $BD,$E8,$BD

LoadBlkTable2:      .db $28,$BE,$68,$BE

ADDR_00BEB0:        PHP                       
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    PHX                       
                    LDA $9C                   
                    AND.W #$00FF              
                    BNE ADDR_00BEBE           
ADDR_00BEBB:        JMP.W ADDR_00BFB9         
ADDR_00BEBE:        LDA $9A                   
                    STA $0C                   
                    LDA $98                   
                    STA $0E                   
                    LDA.W #$0000              
                    SEP #$20                  ; Accum (8 bit) 
                    LDA $5B                   
                    STA $09                   
                    LDA.W $1933               
                    BEQ ADDR_00BED6           
                    LSR $09                   
ADDR_00BED6:        LDY $0E                   
                    LDA $09                   
                    AND.B #$01                
                    BEQ ADDR_00BEEC           
                    LDA $9B                   
                    STA $00                   
                    LDA $99                   
                    STA $9B                   
                    LDA $00                   
                    STA $99                   
                    LDY $0C                   
ADDR_00BEEC:        CPY.W #$0200              
                    BCS ADDR_00BEBB           
                    LDA.W $1933               
                    ASL                       
                    TAX                       
                    LDA.L LoadBlkTable1,X     
                    STA $65                   
                    LDA.L DATA_00BEA9,X       
                    STA $66                   
                    STZ $67                   
                    LDA.W $1925               
                    ASL                       
                    TAY                       
                    LDA [$65],Y               
                    STA $04                   
                    INY                       
                    LDA [$65],Y               
                    STA $05                   
                    STZ $06                   
                    LDA $9B                   
                    STA $07                   
                    ASL                       
                    CLC                       
                    ADC $07                   
                    TAY                       
                    LDA [$04],Y               
                    STA $6B                   
                    STA $6E                   
                    INY                       
                    LDA [$04],Y               
                    STA $6C                   
                    STA $6F                   
                    LDA.B #$7E                
                    STA $6D                   
                    INC A                     
                    STA $70                   
                    LDA $09                   
                    AND.B #$01                
                    BEQ ADDR_00BF41           
                    LDA $99                   
                    LSR                       
                    LDA $9B                   
                    AND.B #$01                
                    JMP.W ADDR_00BF46         
ADDR_00BF41:        LDA $9B                   
                    LSR                       
                    LDA $99                   
ADDR_00BF46:        ROL                       
                    ASL                       
                    ASL                       
                    ORA.B #$20                
                    STA $04                   
                    CPX.W #$0000              
                    BEQ ADDR_00BF57           
                    CLC                       
                    ADC.B #$10                
                    STA $04                   
ADDR_00BF57:        LDA $98                   
                    AND.B #$F0                
                    CLC                       
                    ASL                       
                    ROL                       
                    STA $05                   
                    ROL                       
                    AND.B #$03                
                    ORA $04                   
                    STA $06                   
                    LDA $9A                   
                    AND.B #$F0                
                    LSR                       
                    LSR                       
                    LSR                       
                    STA $04                   
                    LDA $05                   
                    AND.B #$C0                
                    ORA $04                   
                    STA $07                   
                    REP #$20                  ; Accum (16 bit) 
                    LDA $09                   
                    AND.W #$0001              
                    BNE ADDR_00BF9B           
                    LDA $1A                   
                    SEC                       
                    SBC.W #$0080              
                    TAX                       
                    LDY $1C                   
                    LDA.W $1933               
                    BEQ ADDR_00BFB2           
                    LDX $1E                   
                    LDA $20                   
                    SEC                       
                    SBC.W #$0080              
                    TAY                       
                    JMP.W ADDR_00BFB2         
ADDR_00BF9B:        LDX $1A                   
                    LDA $1C                   
                    SEC                       
                    SBC.W #$0080              
                    TAY                       
                    LDA.W $1933               
                    BEQ ADDR_00BFB2           
                    LDA $1E                   
                    SEC                       
                    SBC.W #$0080              
                    TAX                       
                    LDY $20                   
ADDR_00BFB2:        STX $08                   
                    STY $0A                   
                    JSR.W ADDR_00BFBC         
ADDR_00BFB9:        PLX                       
                    PLP                       
                    RTL                       ; Return 

ADDR_00BFBC:        SEP #$30                  ; Index (8 bit) Accum (8 bit) 
                    LDA $9C                   
                    DEC A                     
                    PHK                       
                    PER $0003                 
                    JMP.L ExecutePtr          

Ptrs00BFC9:         .dw ADDR_00C074           
                    .dw ADDR_00C077           
                    .dw ADDR_00C077           
                    .dw ADDR_00C077           
                    .dw ADDR_00C077           
                    .dw ADDR_00C077           
                    .dw ADDR_00C077           
                    .dw ADDR_00C077           
                    .dw ADDR_00C0C4           
                    .dw ADDR_00C0C4           
                    .dw ADDR_00C0C4           
                    .dw ADDR_00C0C4           
                    .dw ADDR_00C0C4           
                    .dw ADDR_00C0C4           
                    .dw ADDR_00C0C4           
                    .dw ADDR_00C0C4           
                    .dw ADDR_00C0C4           
                    .dw ADDR_00C0C4           
                    .dw ADDR_00C0C4           
                    .dw ADDR_00C0C4           
                    .dw ADDR_00C0C4           
                    .dw ADDR_00C0C1           
                    .dw ADDR_00C0C1           
                    .dw ADDR_00C1AC           
                    .dw ADDR_00C334           
                    .dw ADDR_00C334           
                    .dw ADDR_00C3D1           

DATA_00BFFF:        .db $00,$00,$80,$00,$00,$01

DATA_00C005:        .db $80,$40,$20,$10,$08,$04,$02,$01

ADDR_00C00D:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA $9A                   
                    AND.W #$FF00              
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    STA $04                   
                    LDA $9A                   
                    AND.W #$0080              
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    ORA $04                   
                    STA $04                   
                    LDA $98                   
                    AND.W #$0100              
                    BEQ ADDR_00C03A           
                    LDA $04                   
                    ORA.W #$0002              
                    STA $04                   
ADDR_00C03A:        LDA.W $13BE               
                    AND.W #$000F              
                    ASL                       
                    TAX                       
                    LDA.L DATA_00BFFF,X       
                    CLC                       
                    ADC $04                   
                    STA $04                   
                    TAY                       
                    LDA $9A                   
                    AND.W #$0070              
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    TAX                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.W $19F8,Y             
                    ORA.L DATA_00C005,X       
                    STA.W $19F8,Y             
                    RTS                       ; Return 


DATA_00C063:        .db $7F,$BF,$DF,$EF,$F7,$FB,$FD,$FE
DATA_00C06B:        .db $25,$25,$25,$06,$49

                    PHA                       ; Index (8 bit) 
                    PLD                       
                    LDX.B #$C6                
ADDR_00C074:        JSR.W ADDR_00C00D         
ADDR_00C077:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA $98                   
                    AND.W #$01F0              
                    STA $04                   
                    LDA $9A                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.W #$000F              
                    ORA $04                   
                    TAY                       
                    LDA $9C                   
                    AND.W #$00FF              
                    TAX                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDA [$6E],Y               
                    AND.B #$FE                
                    STA [$6E],Y               
                    LDA.L DATA_00C06B,X       
                    STA [$6B],Y               
                    REP #$20                  ; Accum (16 bit) 
                    AND.W #$00FF              
                    ASL                       
                    TAY                       
                    JMP.W ADDR_00C0FB         

DATA_00C0AA:        .db $80,$40,$20,$10,$08,$04,$02,$01
DATA_00C0B2:        .db $52,$1B,$23,$1E,$32,$13,$15,$16
                    .db $2B,$2C,$12,$68,$69,$32,$5E

ADDR_00C0C1:        JSR.W ADDR_00C00D         
ADDR_00C0C4:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA $98                   
                    AND.W #$01F0              
                    STA $04                   
                    LDA $9A                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.W #$000F              
                    ORA $04                   
                    TAY                       
                    LDA $9C                   
                    SEC                       
                    SBC.W #$0009              
                    AND.W #$00FF              
                    TAX                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDA [$6E],Y               
                    ORA.B #$01                
                    STA [$6E],Y               
                    LDA.L DATA_00C0B2,X       
                    STA [$6B],Y               
                    REP #$20                  ; Accum (16 bit) 
                    AND.W #$00FF              
                    ORA.W #$0100              
                    ASL                       
                    TAY                       
ADDR_00C0FB:        LDA $5B                   
                    STA $00                   
                    LDA.W $1933               
                    BEQ ADDR_00C106           
                    LSR $00                   
ADDR_00C106:        LDA $00                   
                    AND.W #$0001              
                    BNE ADDR_00C127           
                    LDA $08                   
                    AND.W #$FFF0              
                    BMI ADDR_00C11A           
                    CMP $0C                   
                    BEQ ADDR_00C13E           
                    BCS ADDR_00C124           
ADDR_00C11A:        CLC                       
                    ADC.W #$0200              
                    CMP $0C                   
                    BEQ ADDR_00C124           
                    BCS ADDR_00C13E           
ADDR_00C124:        JMP.W ADDR_00C1AB         
ADDR_00C127:        LDA $0A                   
                    AND.W #$FFF0              
                    BMI ADDR_00C134           
                    CMP $0E                   
                    BEQ ADDR_00C13E           
                    BCS ADDR_00C1AB           
ADDR_00C134:        CLC                       
                    ADC.W #$0200              
                    CMP $0E                   
                    BEQ ADDR_00C1AB           
                    BCC ADDR_00C1AB           
ADDR_00C13E:        LDA.L $7F837B             
                    TAX                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDA $06                   
                    STA.L $7F837D,X           
                    STA.L $7F8385,X           
                    LDA $07                   
                    STA.L $7F837E,X           
                    CLC                       
                    ADC.B #$20                
                    STA.L $7F8386,X           
                    LDA.B #$00                
                    STA.L $7F837F,X           
                    STA.L $7F8387,X           
                    LDA.B #$03                
                    STA.L $7F8380,X           
                    STA.L $7F8388,X           
                    LDA.B #$FF                
                    STA.L $7F838D,X           
                    LDA.B #$0D                
                    STA $06                   
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W $0FBE,Y             
                    STA $04                   
                    LDY.W #$0000              
                    LDA [$04],Y               
                    STA.L $7F8381,X           
                    INY                       
                    INY                       
                    LDA [$04],Y               
                    STA.L $7F8389,X           
                    INY                       
                    INY                       
                    LDA [$04],Y               
                    STA.L $7F8383,X           
                    INY                       
                    INY                       
                    LDA [$04],Y               
                    STA.L $7F838B,X           
                    TXA                       
                    CLC                       
                    ADC.W #$0010              
                    STA.L $7F837B             
ADDR_00C1AB:        RTS                       ; Return 

ADDR_00C1AC:        JSR.W ADDR_00C00D         
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA $98                   
                    AND.W #$01F0              
                    STA $04                   
                    LDA $9A                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.W #$000F              
                    ORA $04                   
                    TAY                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.B #$25                
                    STA [$6B],Y               
                    REP #$20                  ; Accum (16 bit) 
                    TYA                       
                    CLC                       
                    ADC.W #$0010              
                    TAY                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.B #$25                
                    STA [$6B],Y               
                    REP #$20                  ; Accum (16 bit) 
                    AND.W #$00FF              
                    ASL                       
                    TAY                       
                    LDA $5B                   
                    STA $00                   
                    LDA.W $1933               
                    BEQ ADDR_00C1EA           
                    LSR $00                   
ADDR_00C1EA:        LDA $00                   
                    AND.W #$0001              
                    BNE ADDR_00C20B           
                    LDA $08                   
                    AND.W #$FFF0              
                    BMI ADDR_00C1FE           
                    CMP $0C                   
                    BEQ ADDR_00C222           
                    BCS ADDR_00C1AB           
ADDR_00C1FE:        CLC                       
                    ADC.W #$0200              
                    CMP $0C                   
                    BCC ADDR_00C1AB           
                    BEQ ADDR_00C1AB           
                    JMP.W ADDR_00C222         
ADDR_00C20B:        LDA $0A                   
                    AND.W #$FFF0              
                    BMI ADDR_00C218           
                    CMP $0E                   
                    BEQ ADDR_00C222           
                    BCS ADDR_00C1AB           
ADDR_00C218:        CLC                       
                    ADC.W #$0200              
                    CMP $0E                   
                    BEQ ADDR_00C1AB           
                    BCC ADDR_00C1AB           
ADDR_00C222:        LDA.L $7F837B             
                    TAX                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDA $06                   
                    STA.L $7F837D,X           
                    STA.L $7F8389,X           
                    LDA $07                   
                    STA.L $7F837E,X           
                    INC A                     
                    STA.L $7F838A,X           
                    LDA.B #$80                
                    STA.L $7F837F,X           
                    STA.L $7F838B,X           
                    LDA.B #$07                
                    STA.L $7F8380,X           
                    STA.L $7F838C,X           
                    LDA.B #$FF                
                    STA.L $7F8395,X           
                    LDA.B #$0D                
                    STA $06                   
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W $0FBE,Y             
                    STA $04                   
                    LDY.W #$0000              
                    LDA [$04],Y               
                    STA.L $7F8381,X           
                    STA.L $7F8385,X           
                    INY                       
                    INY                       
                    LDA [$04],Y               
                    STA.L $7F838D,X           
                    STA.L $7F8391,X           
                    INY                       
                    INY                       
                    LDA [$04],Y               
                    STA.L $7F8383,X           
                    STA.L $7F8387,X           
                    INY                       
                    INY                       
                    LDA [$04],Y               
                    STA.L $7F838F,X           
                    STA.L $7F8393,X           
                    TXA                       
                    CLC                       
                    ADC.W #$0018              
                    STA.L $7F837B             
                    RTS                       ; Return 


DATA_00C29E:        .db $99,$9C,$8B,$1C,$8B,$1C,$8B,$1C
                    .db $8B,$1C,$99,$DC,$9B,$1C,$F8,$1C
                    .db $F8,$1C,$F8,$1C,$F8,$1C,$9B,$5C
                    .db $9B,$1C,$F8,$1C,$F8,$1C,$F8,$1C
                    .db $F8,$1C,$9B,$5C,$9B,$1C,$F8,$1C
                    .db $F8,$1C,$F8,$1C,$F8,$1C,$9B,$5C
                    .db $9B,$1C,$F8,$1C,$F8,$1C,$F8,$1C
                    .db $F8,$1C,$9B,$5C,$99,$1C,$8B,$9C
                    .db $8B,$9C,$8B,$9C,$8B,$9C,$99,$5C
                    .db $BA,$9C,$AB,$1C,$AB,$1C,$AB,$1C
                    .db $AB,$1C,$BA,$DC,$AA,$1C,$82,$1C
                    .db $82,$1C,$82,$1C,$82,$1C,$AA,$5C
                    .db $AA,$1C,$82,$1C,$82,$1C,$82,$1C
                    .db $82,$1C,$AA,$5C,$AA,$1C,$82,$1C
                    .db $82,$1C,$82,$1C,$82,$1C,$AA,$5C
                    .db $AA,$1C,$82,$1C,$82,$1C,$82,$1C
                    .db $82,$1C,$AA,$5C,$BA,$1C,$AB,$9C
                    .db $AB,$9C,$AB,$9C,$AB,$9C,$BA,$5C
DATA_00C32E:        .db $9E,$C2

DATA_00C330:        .db $00,$E6,$C2,$00

ADDR_00C334:        INC $07                   ; Accum (8 bit) 
                    LDA $07                   
                    CLC                       
                    ADC.B #$20                
                    STA $07                   
                    LDA $06                   
                    ADC.B #$00                
                    STA $06                   
                    LDA $9C                   
                    SEC                       
                    SBC.B #$19                
                    STA $00                   
                    ASL                       
                    CLC                       
                    ADC $00                   
                    TAX                       
                    LDA.L DATA_00C330,X       
                    STA $04                   
                    REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA.L DATA_00C32E,X       
                    STA $02                   
                    LDA.L $7F837B             
                    TAX                       
                    LDY.W #$0005              
ADDR_00C365:        SEP #$20                  ; Accum (8 bit) 
                    LDA $06                   
                    STA.L $7F837D,X           
                    LDA $07                   
                    STA.L $7F837E,X           
                    LDA.B #$00                
                    STA.L $7F837F,X           
                    LDA.B #$0B                
                    STA.L $7F8380,X           
                    LDA $07                   
                    CLC                       
                    ADC.B #$20                
                    STA $07                   
                    LDA $06                   
                    ADC.B #$00                
                    STA $06                   
                    REP #$20                  ; Accum (16 bit) 
                    TXA                       
                    CLC                       
                    ADC.W #$0010              
                    TAX                       
                    DEY                       
                    BPL ADDR_00C365           
                    LDA.L $7F837B             
                    TAX                       
                    LDY.W #$0000              
ADDR_00C39F:        LDA.W #$0005              
                    STA $00                   
ADDR_00C3A4:        LDA [$02],Y               
                    STA.L $7F8381,X           
                    INY                       
                    INY                       
                    INX                       
                    INX                       
                    DEC $00                   
                    BPL ADDR_00C3A4           
                    TXA                       
                    CLC                       
                    ADC.W #$0004              
                    TAX                       
                    CPY.W #$0048              
                    BNE ADDR_00C39F           
                    LDA.W #$00FF              
                    STA.L $7F837D,X           
                    LDA.L $7F837B             
                    CLC                       
                    ADC.W #$0060              
                    STA.L $7F837B             
                    RTS                       ; Return 

ADDR_00C3D1:        REP #$30                  ; Index (16 bit) Accum (16 bit) 
                    LDA $98                   
                    AND.W #$01F0              
                    STA $04                   
                    LDA $9A                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.W #$000F              
                    ORA $04                   
                    TAY                       
                    LDA.L $7F837B             
                    TAX                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.B #$25                
                    STA [$6B],Y               
                    INY                       
                    LDA.B #$25                
                    STA [$6B],Y               
                    REP #$20                  ; Accum (16 bit) 
                    TYA                       
                    CLC                       
                    ADC.W #$0010              
                    TAY                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.B #$25                
                    STA [$6B],Y               
                    DEY                       
                    LDA.B #$25                
                    STA [$6B],Y               
                    LDY.W #$0003              
ADDR_00C40C:        LDA $06                   
                    STA.L $7F837D,X           
                    LDA $07                   
                    STA.L $7F837E,X           
                    LDA.B #$40                
                    STA.L $7F837F,X           
                    LDA.B #$06                
                    STA.L $7F8380,X           
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W #$18F8              
                    STA.L $7F8381,X           
                    TXA                       
                    CLC                       
                    ADC.W #$0006              
                    TAX                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDA $07                   
                    CLC                       
                    ADC.B #$20                
                    STA $07                   
                    LDA $06                   
                    ADC.B #$00                
                    STA $06                   
                    DEY                       
                    BPL ADDR_00C40C           
                    LDA.B #$FF                
                    STA.L $7F837D,X           
                    REP #$20                  ; Accum (16 bit) 
                    TXA                       
                    STA.L $7F837B             
                    RTS                       ; Return 


DATA_00C453:        .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$80,$40,$20
                    .db $10,$08,$04,$02,$01,$80,$40,$20
                    .db $10,$08,$04,$02,$01

DATA_00C470:        .db $90,$00,$90,$00

DATA_00C474:        .db $04,$FC,$04,$FC

DATA_00C478:        .db $30,$33,$33,$30,$01,$00

ADDR_00C47E:        STZ $78                   ; Index (8 bit) Accum (8 bit) 
                    LDA.W $13CB               
                    BPL ADDR_00C48C           
                    JSL.L ADDR_01C580         
                    STZ.W $13CB               
ADDR_00C48C:        LDY.W $1434               
                    BEQ ADDR_00C4BA           
                    STY.W $13FB               
                    STY $9D                   
                    LDX.W $1435               
                    LDA.W $1433               
                    CMP.W DATA_00C470,X       
                    BNE ADDR_00C4BC           
                    DEY                       
                    BNE ADDR_00C4B7           
                    INC.W $1435               
                    TXA                       
                    LSR                       
                    BCC ADDR_00C4F8           
                    JSR.W ADDR_00FCEC         
                    LDA.B #$02                
                    LDY.B #$0B                
                    JSR.W ADDR_00C9FE         
                    LDY.B #$00                
ADDR_00C4B7:        STY.W $1434               
ADDR_00C4BA:        BRA ADDR_00C4F8           
ADDR_00C4BC:        CLC                       
                    ADC.W DATA_00C474,X       
                    STA.W $1433               
                    LDA.B #$22                
                    STA $41                   
                    LDA.B #$02                
                    STA $42                   
                    LDA.W DATA_00C478,X       
                    STA $43                   
                    LDA.B #$12                
                    STA $44                   
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W #$CB93              
                    STA $04                   
                    STZ $06                   
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.W $1436               
                    SEC                       
                    SBC $1A                   
                    CLC                       
                    ADC.B #$04                
                    STA $00                   
                    LDA.W $1438               
                    SEC                       
                    SBC $1C                   
                    CLC                       
                    ADC.B #$10                
                    STA $01                   
                    JSR.W ADDR_00CA88         
ADDR_00C4F8:        LDA.W $13FB               
                    BEQ ADDR_00C500           
                    JMP.W ADDR_00C58F         
ADDR_00C500:        LDA $9D                   
                    BNE ADDR_00C569           
                    INC $14                   
                    LDX.B #$13                
ADDR_00C508:        LDA.W $1495,X             
                    BEQ ADDR_00C510           
                    DEC.W $1495,X             
ADDR_00C510:        DEX                       
                    BNE ADDR_00C508           
                    LDA $14                   
                    AND.B #$03                
                    BNE ADDR_00C569           
                    LDA.W $1425               
                    BEQ ADDR_00C533           
                    LDA.W $14AB               
                    CMP.B #$44                
                    BNE ADDR_00C52A           
                    LDY.B #$14                
                    STY.W $1DFB               ; / Play sound effect 
ADDR_00C52A:        CMP.B #$01                
                    BNE ADDR_00C533           
                    LDY.B #$0B                
                    STY.W $0100               
ADDR_00C533:        LDY.W $14AD               
                    CPY.W $14AE               
                    BCS ADDR_00C53E           
                    LDY.W $14AE               
ADDR_00C53E:        LDA.W $0DDA               
                    BMI ADDR_00C54F           
                    CPY.B #$01                
                    BNE ADDR_00C54F           
                    LDY.W $190C               
                    BNE ADDR_00C54F           
                    STA.W $1DFB               ; / Play sound effect 
ADDR_00C54F:        CMP.B #$FF                
                    BEQ ADDR_00C55C           
                    CPY.B #$1E                
                    BNE ADDR_00C55C           
                    LDA.B #$24                
                    STA.W $1DFC               ; / Play sound effect 
ADDR_00C55C:        LDX.B #$06                
ADDR_00C55E:        LDA.W $14A8,X             
                    BEQ ADDR_00C566           
                    DEC.W $14A8,X             
ADDR_00C566:        DEX                       
                    BNE ADDR_00C55E           
ADDR_00C569:        JSR.W ADDR_00C593         
                    LDA $16                   
                    AND.B #$20                
                    BEQ ADDR_00C58F           
                    LDA $15                   
                    AND.B #$08                
                    BRA ADDR_00C585           
                    LDA $19                   
                    INC A                     
                    CMP.B #$04                
                    BCC ADDR_00C581           
                    LDA.B #$00                
ADDR_00C581:        STA $19                   
                    BRA ADDR_00C58F           
ADDR_00C585:        PHB                       
                    LDA.B #$02                
                    PHA                       
                    PLB                       
                    JSL.L ADDR_028008         
                    PLB                       
ADDR_00C58F:        STZ.W $1402               
ADDR_00C592:        RTS                       ; Return 

ADDR_00C593:        LDA $71                   
                    JSL.L ExecutePtr          

Ptrs00C599:         .dw ADDR_00CC68           
                    .dw ADDR_00D129           
                    .dw ADDR_00D147           
                    .dw ADDR_00D15F           
                    .dw ADDR_00D16F           
                    .dw ADDR_00D197           
                    .dw ADDR_00D203           
                    .dw ADDR_00D287           
                    .dw ADDR_00C7FD           
                    .dw MarioDeath            
                    .dw ADDR_00C870           
                    .dw ADDR_00C5B5           
                    .dw ADDR_00C6E7           
                    .dw ADDR_00C592           

ADDR_00C5B5:        STZ.W $13DE               
                    STZ.W $13ED               
                    LDA.W $1493               
                    BEQ ADDR_00C5CE           
                    JSL.L ADDR_0CAB13         
                    LDA.W $0100               
                    CMP.B #$14                
                    BEQ ADDR_00C5D1           
                    JMP.W ADDR_00C95B         
ADDR_00C5CE:        STZ.W $0D9F               
ADDR_00C5D1:        LDA.B #$01                
                    STA.W $1B88               
                    LDA.B #$07                

Instr00C5D8:        .db $8D,$28

ADDR_00C5DA:        .db $19

                    JSR.W NoButtons           
                    JMP.W ADDR_00CD24         

DATA_00C5E1:        .db $10,$30,$31,$32,$33,$34,$0E

DATA_00C5E8:        .db $26

DATA_00C5E9:        .db $11,$02,$48,$00,$60,$01,$09,$80
                    .db $08,$00,$20,$04,$60,$00,$01,$FF
                    .db $01,$02,$48,$00,$60,$41,$2C,$C1
                    .db $04,$27,$04,$2F,$08,$25,$01,$2F
                    .db $04,$27,$04,$00,$08,$41,$1B,$C1
                    .db $04,$27,$04,$2F,$08,$25,$01,$2F
                    .db $04,$27,$04,$00,$04,$01,$08,$20
                    .db $01,$01,$10,$00,$08,$41,$12,$81
                    .db $0A,$00,$40,$82,$10,$02,$20,$00
                    .db $30,$01,$01,$00,$50,$22,$01,$FF
                    .db $01,$02,$48,$00,$60,$01,$09,$80
                    .db $08,$00,$20,$04,$60,$00,$20,$10
                    .db $20,$01,$58,$00,$2C,$31,$01,$3A
                    .db $10,$31,$01,$3A,$10,$31,$01,$3A
                    .db $20,$28,$A0,$28,$40,$29,$04,$28
                    .db $04,$29,$04,$28,$04,$29,$04,$28
                    .db $40,$22,$01,$FF,$01,$02,$48,$00
                    .db $60,$01,$09,$80,$08,$00,$20,$04
                    .db $60,$10,$20,$31,$01,$18,$60,$31
                    .db $01,$3B,$80,$31,$01,$3C,$40,$FF
                    .db $01,$02,$48,$00,$60,$02,$30,$01
                    .db $84,$00,$20,$23,$01,$01,$16,$02
                    .db $20,$20,$01,$01,$20,$02,$20,$01
                    .db $02,$00,$80,$FF,$01,$02,$48,$00
                    .db $60,$02,$28,$01,$83,$00,$28,$24
                    .db $01,$02,$01,$00,$FF,$00,$40,$20
                    .db $01,$00,$40,$02,$60,$00,$30,$FF
                    .db $01,$02,$48,$00,$60,$01,$4E,$00
                    .db $40,$26,$01,$00,$1E,$20,$01,$00
                    .db $20,$08,$10,$20,$01,$2D,$18,$00
                    .db $A0,$20,$01,$2E,$01,$FF

DATA_00C6DF:        .db $01,$00,$10,$A0,$84,$50,$BC,$D8

ADDR_00C6E7:        JSR.W NoButtons           
                    STZ.W $13DE               
                    JSR.W ADDR_00DC2D         
                    LDA $7D                   
                    BMI ADDR_00C73F           
                    LDA $96                   
                    CMP.B #$58                
                    BCS ADDR_00C739           
                    LDY $94                   
                    CPY.B #$40                
                    BCC ADDR_00C73F           
                    CPY.B #$60                
                    BCC ADDR_00C71C           
                    LDY $1C                   
                    BEQ ADDR_00C73F           
                    CLC                       
                    ADC $1C                   
                    CMP.B #$1C                
                    BMI ADDR_00C73F           
                    SEC                       
                    SBC $1C                   
                    LDX.B #$D0                
                    LDY $76                   
                    BEQ ADDR_00C730           
                    LDY.B #$00                
                    BRA ADDR_00C72E           
ADDR_00C71C:        CMP.B #$4C                
                    BCC ADDR_00C73F           
                    LDA.B #$1B                
                    STA.W $1DFC               ; / Play sound effect 
                    INC.W $143E               
                    LDA.B #$4C                
                    LDY.B #$F4                
                    LDX.B #$C0                
ADDR_00C72E:        STY $7B                   
ADDR_00C730:        STX $7D                   
                    LDX.B #$01                
                    STX.W $1DF9               ; / Play sound effect 
                    BRA ADDR_00C73D           
ADDR_00C739:        STZ $72                   
                    LDA.B #$58                
ADDR_00C73D:        STA $96                   
ADDR_00C73F:        LDX.W $13C6               
                    LDA $8F                   
                    CLC                       
                    ADC.W DATA_00C6DF,X       
                    TAX                       
                    LDA $88                   
                    BNE ADDR_00C764           
                    INC $8F                   
                    INC $8F                   
                    INX                       
                    INX                       
                    LDA.W DATA_00C5E9,X       
                    STA $88                   
                    LDA.W DATA_00C5E8,X       
                    CMP.B #$2D                
                    BNE ADDR_00C764           
                    LDA.B #$1E                
                    STA.W $1DF9               ; / Play sound effect 
ADDR_00C764:        LDA.W DATA_00C5E8,X       
                    CMP.B #$FF                
                    BNE ADDR_00C76E           
                    JMP.W ADDR_00C7F8         
ADDR_00C76E:        PHA                       
                    AND.B #$10                
                    BEQ ADDR_00C777           
                    JSL.L ADDR_0CD4A4         
ADDR_00C777:        PLA                       
                    TAY                       
                    AND.B #$20                
                    BNE ADDR_00C789           
                    STY $15                   
                    TYA                       
                    AND.B #$BF                
                    STA $16                   
                    JSR.W ADDR_00CD39         
                    BRA ADDR_00C7F6           
ADDR_00C789:        TYA                       
                    AND.B #$0F                
                    CMP.B #$07                
                    BCS ADDR_00C7E9           
                    DEC A                     
                    BPL ADDR_00C7A2           
                    LDA.W $1498               
                    BEQ ADDR_00C79D           
                    LDA.B #$09                
                    STA.W $1DF9               ; / Play sound effect 
ADDR_00C79D:        INC.W $143E               
                    BRA ADDR_00C7F6           
ADDR_00C7A2:        BNE ADDR_00C7A9           
                    INC.W $1445               
                    BRA ADDR_00C7F6           
ADDR_00C7A9:        DEC A                     
                    BNE ADDR_00C7B6           
                    LDA.B #$0E                
                    STA.W $1DF9               ; / Play sound effect 
                    INC.W $1446               
                    BRA ADDR_00C7F6           
ADDR_00C7B6:        DEC A                     
                    BNE ADDR_00C7C0           
                    LDY.B #$88                
                    STY.W $1445               
                    BRA ADDR_00C7F6           
ADDR_00C7C0:        DEC A                     
                    BNE ADDR_00C7CE           
                    LDA.B #$38                
                    STA.W $1446               
                    LDA.B #$07                
                    TRB $94                   
                    BRA ADDR_00C7F6           
ADDR_00C7CE:        DEC A                     
                    BNE ADDR_00C7DF           
                    LDA.B #$09                
                    STA.W $1DFC               ; / Play sound effect 
                    LDA.B #$D8                
                    STA $7B                   
                    INC.W $143E               
                    BRA ADDR_00C79D           
ADDR_00C7DF:        LDA.B #$20                
                    STA.W $1498               
                    INC.W $148F               
                    BRA ADDR_00C7F6           
ADDR_00C7E9:        TAY                       
                    LDA.W ADDR_00C5DA,Y       
                    STA.W $13E0               
                    STZ.W $148F               
                    JSR.W ADDR_00D7E4         
ADDR_00C7F6:        DEC $88                   
ADDR_00C7F8:        RTS                       ; Return 


DATA_00C7F9:        .db $C0,$FF

                    LDY.B #$00                
ADDR_00C7FD:        JSR.W NoButtons           
                    LDA.B #$0B                
                    STA $72                   
                    JSR.W ADDR_00D7E4         
                    LDA $7D                   
                    BPL ADDR_00C80F           
                    CMP.B #$90                
                    BCC ADDR_00C814           
ADDR_00C80F:        SEC                       
                    SBC.B #$0D                
                    STA $7D                   
ADDR_00C814:        LDA.B #$02                
                    LDY $7B                   
                    BEQ ADDR_00C827           
                    BMI ADDR_00C81E           
                    LDA.B #$FE                
ADDR_00C81E:        CLC                       
                    ADC $7B                   
                    STA $7B                   
                    BVC ADDR_00C827           
                    STZ $7B                   
ADDR_00C827:        JSR.W ADDR_00DC2D         
                    REP #$20                  ; Accum (16 bit) 
                    LDY.W $1B95               
                    LDA $80                   
                    CMP.W DATA_00C7F9,Y       
                    SEP #$20                  ; Accum (8 bit) 
                    BPL Instr00C845           
                    STZ $71                   
                    TYA                       
                    BNE Instr00C845           
                    INY                       
                    INY                       
                    STY.W $1B95               
                    JSR.W ADDR_00D273         

Instr00C845:        .db $4C

ADDR_00C846:        .db $8F

ADDR_00C847:        .db $CD

DATA_00C848:        .db $01,$5F,$00,$30,$08,$30,$00,$20
                    .db $40,$01,$00,$30,$01,$80,$FF,$01
                    .db $3F,$00,$30,$20,$01,$80,$06,$00
                    .db $3A,$01,$38,$00,$30,$08,$30,$00
                    .db $20,$40,$01,$00,$30,$01,$80,$FF

ADDR_00C870:        STZ.W $13E2               
                    LDX.W $1931               
                    BIT.W DATA_00A625,X       
                    BMI ADDR_00C889           
                    BVS ADDR_00C883           
                    JSL.L ADDR_02F57C         
                    BRA ADDR_00C88D           
ADDR_00C883:        JSL.L ADDR_02F58C         
                    BRA ADDR_00C88D           
ADDR_00C889:        JSL.L ADDR_02F584         
ADDR_00C88D:        LDX $88                   
                    LDA $16                   
                    ORA $18                   
                    JSR.W NoButtons           
                    BMI ADDR_00C8FB           
                    STZ.W $13DE               
                    DEC $89                   
                    BNE ADDR_00C8A8           
                    INX                       
                    INX                       
                    STX $88                   
                    LDA.W ADDR_00C847,X       
                    STA $89                   
ADDR_00C8A8:        LDA.W ADDR_00C846,X       
                    CMP.B #$FF                
                    BEQ ADDR_00C8FB           
                    AND.B #$DF                
                    STA $15                   
                    CMP.W ADDR_00C846,X       
                    BEQ ADDR_00C8BC           
                    LDY.B #$80                
                    STY $18                   
ADDR_00C8BC:        ASL                       
                    BPL ADDR_00C8D1           
                    JSR.W NoButtons           
                    LDY.B #$B0                
                    LDX.W $1931               
                    BIT.W DATA_00A625,X       
                    BMI ADDR_00C8CE           
                    LDY.B #$7F                
ADDR_00C8CE:        STY.W $18D9               
ADDR_00C8D1:        JSR.W ADDR_00DC2D         
                    LDA.B #$24                
                    STA $72                   
                    LDA.B #$6F                
                    LDY.W $187A               
                    BEQ ADDR_00C8E1           
                    LDA.B #$5F                
ADDR_00C8E1:        LDX.W $1931               
                    BIT.W DATA_00A625,X       
                    BVC ADDR_00C8EC           
                    SEC                       
                    SBC.B #$10                
ADDR_00C8EC:        CMP $96                   
                    BCS ADDR_00C8F8           
                    INC A                     
                    STA $96                   
                    STZ $72                   
                    STZ.W $140D               
ADDR_00C8F8:        JMP.W ADDR_00CD82         
ADDR_00C8FB:        INC.W $141D               
                    LDA.B #$0F                
                    STA.W $0100               
                    CPX.B #$11                
                    BCC ADDR_00C90A           
                    INC.W $0DC1               
ADDR_00C90A:        LDA.B #$01                
                    STA.W $1B9B               
                    LDA.B #$03                
                    STA.W $1DFA               ; / Play sound effect 
                    RTS                       ; Return 

ADDR_00C915:        JSR.W NoButtons           
                    STZ.W $18C2               
                    STZ.W $13DE               
                    STZ.W $13ED               
                    LDA $5B                   
                    LSR                       
                    BCS ADDR_00C944           
                    LDA.W $13C6               
                    ORA.W $13D2               
                    BEQ ADDR_00C96B           
                    LDA $72                   
                    BEQ ADDR_00C935           
                    JSR.W ADDR_00CCE0         
ADDR_00C935:        LDA.W $13D2               
                    BNE ADDR_00C948           
                    JSR.W ADDR_00B03E         
                    LDA.W $1495               
                    CMP.B #$40                
                    BCC ADDR_00C96A           
ADDR_00C944:        JSL.L ADDR_05CBFF         
ADDR_00C948:        LDY.B #$01                
                    STY $9D                   
                    LDA $13                   
                    LSR                       
                    BCC ADDR_00C96A           
                    DEC.W $1493               
                    BNE ADDR_00C96A           
                    LDA.W $13D2               
                    BNE ADDR_00C962           
ADDR_00C95B:        LDY.B #$0B                
                    LDA.B #$01                
                    JMP.W ADDR_00C9FE         
ADDR_00C962:        LDA.B #$A0                
                    STA.W $1DF5               
                    INC.W $1426               
ADDR_00C96A:        RTS                       ; Return 

ADDR_00C96B:        JSR.W ADDR_00AF17         
                    LDA.W $1B99               
                    BNE ADDR_00C9AF           
                    LDA.W $1493               
                    CMP.B #$28                
                    BCC ADDR_00C984           
                    LDA.B #$01                
                    STA $76                   
                    STA $15                   
                    LDA.B #$05                
                    STA $7B                   
ADDR_00C984:        LDA $72                   
                    BEQ ADDR_00C98B           
                    JSR.W ADDR_00D76B         
ADDR_00C98B:        LDA $7B                   
                    BNE Instr00C9A4           
                    STZ.W $1411               
                    JSR.W ADDR_00CA3E         
                    INC.W $1B99               
                    LDA.B #$40                
                    STA.W $1492               
                    ASL                       
                    STA.W $1494               
                    STZ.W $1495               

Instr00C9A4:        .db $4C,$24

ADDR_00C9A6:        .db $CD

DATA_00C9A7:        .db $25,$07,$40,$0E,$20,$1A,$34,$32

ADDR_00C9AF:        JSR.W ADDR_00CA31         
                    LDA.W $1492               
                    BEQ ADDR_00C9C2           
                    DEC.W $1492               
                    BNE ADDR_00C9C1           
                    LDA.B #$11                
                    STA.W $1DFB               ; / Play sound effect 
ADDR_00C9C1:        RTS                       ; Return 

ADDR_00C9C2:        JSR.W ADDR_00CA44         
                    LDA.B #$01                
                    STA $15                   
                    JSR.W ADDR_00CD24         
                    LDA.W $1433               
                    BNE ADDR_00CA30           
                    LDA.W $141C               
                    INC A                     
                    CMP.B #$03                
                    BNE ADDR_00C9DF           
                    LDA.B #$01                
                    STA.W $1F11               
                    LSR                       
ADDR_00C9DF:        LDY.B #$0C                
                    LDX.W $1425               
                    BEQ ADDR_00C9F8           
                    LDX.B #$FF                
                    STX.W $1425               
                    LDX.B #$F0                
                    STX.W $0DB0               
                    STZ.W $1493               
                    STZ.W $0DDA               
                    LDY.B #$10                
ADDR_00C9F8:        STZ.W $0DAE               
                    STZ.W $0DAF               
ADDR_00C9FE:        STA.W $0DD5               
                    LDA.W $13C6               
                    BEQ ADDR_00CA25           
                    LDX.B #$08                
                    LDA.W $13BF               
                    CMP.B #$13                
                    BNE ADDR_00CA12           
                    INC.W $0DD5               
ADDR_00CA12:        CMP.B #$31                
                    BEQ ADDR_00CA20           
ADDR_00CA16:        CMP.W ADDR_00C9A6,X       
                    BEQ ADDR_00CA20           
                    DEX                       
                    BNE ADDR_00CA16           
                    BRA ADDR_00CA25           
ADDR_00CA20:        STX.W $13C6               
                    LDY.B #$18                
ADDR_00CA25:        STY.W $0100               
                    INC.W $1DE9               
ADDR_00CA2B:        LDA.B #$01                
                    STA.W $13CE               
ADDR_00CA30:        RTS                       ; Return 

ADDR_00CA31:        LDA.B #$26                
                    LDY.W $187A               
                    BEQ ADDR_00CA3A           
                    LDA.B #$14                
ADDR_00CA3A:        STA.W $13E0               
                    RTS                       ; Return 

ADDR_00CA3E:        LDA.B #$F0                
                    STA.W $1433               
                    RTS                       ; Return 

ADDR_00CA44:        LDA.W $1433               
                    BNE ADDR_00CA4A           
                    RTS                       ; Return 

ADDR_00CA4A:        JSR.W ADDR_00CA61         
                    LDA.B #$FC                
                    JSR.W ADDR_00CA6D         
                    LDA.B #$33                
                    STA $41                   
                    STA $43                   
                    LDA.B #$03                
                    STA $42                   
                    LDA.B #$22                
                    STA $44                   
                    RTS                       ; Return 

ADDR_00CA61:        REP #$20                  ; 16 bit A ; Accum (16 bit) 
                    LDA.W #$CB12              ; \  
                    STA $04                   ;  |Load xCB12 into $04 and $06 
                    STA $06                   ; /  
                    SEP #$20                  ; 8 bit A ; Accum (8 bit) 
                    RTS                       ; Return 

ADDR_00CA6D:        CLC                       
                    ADC.W $1433               
                    STA.W $1433               
                    LDA $7E                   
                    CLC                       
                    ADC.B #$08                
                    STA $00                   
                    LDA.B #$18                
                    LDY $19                   
                    BEQ ADDR_00CA83           
                    LDA.B #$10                
ADDR_00CA83:        CLC                       
                    ADC $80                   
                    STA $01                   
ADDR_00CA88:        REP #$30                  ; 16 bit A ; Index (16 bit) Accum (16 bit) 
                    AND.W #$00FF              ; Keep lower byte of A 
                    ASL                       ; \  
                    DEC A                     ;  |Set Y to ((2A-1)*2) 
                    ASL                       ;  | 
                    TAY                       ; /  
                    SEP #$20                  ; 8 bit A ; Accum (8 bit) 
                    LDX.W #$0000              
ADDR_00CA96:        LDA $01                   
                    CMP.W $1433               
                    BCC ADDR_00CABD           
                    LDA.B #$FF                
                    STA.W $04A0,X             
                    STZ.W $04A1,X             
                    CPY.W #$01C0              
                    BCS ADDR_00CAB1           
                    STA.W $04A0,Y             
                    INC A                     
                    STA.W $04A1,Y             
ADDR_00CAB1:        INX                       
                    INX                       
                    DEY                       
                    DEY                       
                    LDA $01                   
                    BEQ ADDR_00CB0A           
                    DEC $01                   
                    BRA ADDR_00CA96           
ADDR_00CABD:        JSR.W ADDR_00CC14         
                    CLC                       
                    ADC $00                   
                    BCC ADDR_00CAC7           
                    LDA.B #$FF                
ADDR_00CAC7:        STA.W $04A1,X             
                    LDA $00                   
                    SEC                       
                    SBC $02                   
                    BCS ADDR_00CAD3           
                    LDA.B #$00                
ADDR_00CAD3:        STA.W $04A0,X             
                    CPY.W #$01E0              
                    BCS ADDR_00CAFE           
                    LDA $07                   
                    BNE ADDR_00CAE7           
                    LDA.B #$00                
                    STA.W $04A1,Y             
                    DEC A                     
                    BRA ADDR_00CAFB           
ADDR_00CAE7:        LDA $03                   
                    ADC $00                   
                    BCC ADDR_00CAEF           
                    LDA.B #$FF                
ADDR_00CAEF:        STA.W $04A1,Y             
                    LDA $00                   
                    SEC                       
                    SBC $03                   
                    BCS ADDR_00CAFB           
                    LDA.B #$00                
ADDR_00CAFB:        STA.W $04A0,Y             
ADDR_00CAFE:        INX                       
                    INX                       
                    DEY                       
                    DEY                       
                    LDA $01                   
                    BEQ ADDR_00CB0A           
                    DEC $01                   
                    BNE ADDR_00CABD           
ADDR_00CB0A:        LDA.B #$80                
                    STA.W $0D9F               
                    SEP #$10                  ; Index (8 bit) 
                    RTS                       ; Return 


DATA_00CB12:        .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FE,$FE,$FE,$FE
                    .db $FD,$FD,$FD,$FD,$FC,$FC,$FC,$FB
                    .db $FB,$FB,$FA,$FA,$F9,$F9,$F8,$F8
                    .db $F7,$F7,$F6,$F6,$F5,$F5,$F4,$F3
                    .db $F3,$F2,$F1,$F1,$F0,$EF,$EE,$EE
                    .db $ED,$EC,$EB,$EA,$E9,$E9,$E8,$E7
                    .db $E6,$E5,$E4,$E3,$E2,$E1,$DF,$DE
                    .db $DD,$DC,$DB,$DA,$D8,$D7,$D6,$D5
                    .db $D3,$D2,$D0,$CF,$CD,$CC,$CA,$C9
                    .db $C7,$C6,$C4,$C2,$C1,$BF,$BD,$BB
                    .db $B9,$B7,$B6,$B4,$B1,$AF,$AD,$AB
                    .db $A9,$A7,$A4,$A2,$9F,$9D,$9A,$97
                    .db $95,$92,$8F,$8C,$89,$86,$82,$7F
                    .db $7B,$78,$74,$70,$6C,$67,$63,$5E
                    .db $59,$53,$4D,$46,$3F,$37,$2D,$1F
                    .db $00,$54,$53,$52,$52,$51,$50,$50
                    .db $4F,$4E,$4E,$4D,$4C,$4C,$4B,$4A
                    .db $4A,$4B,$48,$48,$47,$46,$46,$45
                    .db $44,$44,$43,$42,$42,$41,$40,$40
                    .db $3F,$3E,$3E,$3D,$3C,$3C,$3B,$3A
                    .db $3A,$39,$38,$38,$37,$36,$36,$35
                    .db $34,$34,$33,$32,$32,$31,$33,$35
                    .db $38,$3A,$3C,$3E,$3F,$41,$43,$44
                    .db $45,$47,$48,$49,$4A,$4B,$4C,$4D
                    .db $4E,$4E,$4F,$50,$50,$51,$51,$52
                    .db $52,$53,$53,$53,$53,$53,$53,$53
                    .db $53,$53,$53,$53,$53,$53,$52,$52
                    .db $51,$51,$50,$50,$4F,$4E,$4E,$4D
                    .db $4C,$4B,$4A,$49,$48,$47,$45,$44
                    .db $43,$41,$3F,$3E,$3C,$3A,$38,$35
                    .db $33,$30,$2D,$2A,$26,$23,$1E,$18
                    .db $11,$00

ADDR_00CC14:        PHY                       
                    LDA $01                   
                    STA.W $4205               ; Dividend (High-Byte)
                    STZ.W $4204               ; Dividend (Low Byte)
                    LDA.W $1433               
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
                    TAY                       
                    SEP #$20                  ; Accum (8 bit) 
                    LDA ($06),Y               
                    STA.W $4202               ; Multiplicand A
                    LDA.W $1433               
                    STA.W $4203               ; Multplier B
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    LDA.W $4217               ; Product/Remainder Result (High Byte)
                    STA $03                   
                    LDA ($04),Y               
                    STA.W $4202               ; Multiplicand A
                    LDA.W $1433               
                    STA.W $4203               ; Multplier B
                    NOP                       
                    NOP                       
                    NOP                       
                    NOP                       
                    LDA.W $4217               ; Product/Remainder Result (High Byte)
                    STA $02                   
                    PLY                       
                    RTS                       ; Return 


DATA_00CC5C:        .db $00,$00,$00,$00,$02,$00,$06,$00
                    .db $FE,$FF,$FA,$FF

ADDR_00CC68:        LDA $17                   
                    AND.B #$20                
                    BEQ ADDR_00CC81           
                    LDA $18                   
                    CMP.B #$80                
                    BNE ADDR_00CC81           
                    INC.W $1E01               
                    LDA.W $1E01               
                    CMP.B #$03                
                    BCC ADDR_00CC81           
                    STZ.W $1E01               
ADDR_00CC81:        LDA.W $1E01               
                    BRA ADDR_00CCBB           
                    LSR                       
                    BEQ ADDR_00CCB3           
                    LDA.B #$FF                
                    STA.W $1497               
                    LDA $15                   
                    AND.B #$03                
                    ASL                       
                    ASL                       
                    LDX.B #$00                
                    JSR.W ADDR_00CC9F         
                    LDA $15                   
                    AND.B #$0C                
                    LDX.B #$02                
ADDR_00CC9F:        BIT $15                   
                    BVC ADDR_00CCA5           
                    ORA.B #$02                
ADDR_00CCA5:        TAY                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA $94,X                 
                    CLC                       
                    ADC.W DATA_00CC5C,Y       
                    STA $94,X                 
                    SEP #$20                  ; Accum (8 bit) 
                    RTS                       ; Return 

ADDR_00CCB3:        LDA.B #$70                
                    STA.W $13E4               
                    STA.W $149F               
ADDR_00CCBB:        LDA.W $1493               
                    BEQ ADDR_00CCC3           
                    JMP.W ADDR_00C915         
ADDR_00CCC3:        JSR.W ADDR_00CDDD         
                    LDA $9D                   
                    BNE ADDR_00CCDF           
                    STZ.W $13E8               
                    STZ.W $13DE               
                    LDA.W $18BD               
                    BEQ ADDR_00CCE0           
                    DEC.W $18BD               
                    STZ $7B                   
                    LDA.B #$0F                
                    STA.W $13E0               
ADDR_00CCDF:        RTS                       ; Return 

ADDR_00CCE0:        LDA.W $0D9B               
                    BPL ADDR_00CD24           
                    LSR                       
                    BCS ADDR_00CD24           
                    BIT.W $0D9B               
                    BVS ADDR_00CD1C           
                    LDA $72                   
                    BNE ADDR_00CD1C           
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W $1436               
                    STA $94                   
                    LDA.W $1438               
                    STA $96                   
                    SEP #$20                  ; Accum (8 bit) 
                    JSR.W ADDR_00DC2D         
                    REP #$20                  ; Accum (16 bit) 
                    LDA $94                   
                    STA.W $1436               
                    STA.W $14B4               
                    LDA $96                   
                    AND.W #$FFF0              
                    STA.W $1438               
                    STA.W $14B6               
                    JSR.W ADDR_00F9C9         
                    BRA ADDR_00CD1F           
ADDR_00CD1C:        JSR.W ADDR_00DC2D         ; Accum (8 bit) 
ADDR_00CD1F:        JSR.W ADDR_00F8F2         
                    BRA ADDR_00CD36           
ADDR_00CD24:        LDA $7D                   
                    BPL ADDR_00CD30           
                    LDA $77                   
                    AND.B #$08                
                    BEQ ADDR_00CD30           
                    STZ $7D                   
ADDR_00CD30:        JSR.W ADDR_00DC2D         
                    JSR.W ADDR_00E92B         
ADDR_00CD36:        JSR.W ADDR_00F595         
ADDR_00CD39:        STZ.W $13DD               
                    LDY.W $13F3               
                    BNE ADDR_00CD95           
                    LDA.W $18BE               
                    BEQ ADDR_00CD4A           
                    LDA.B #$1F                
                    STA $8B                   
ADDR_00CD4A:        LDA $74                   
                    BNE ADDR_00CD72           
                    LDA.W $148F               
                    ORA.W $187A               
                    BNE ADDR_00CD79           
                    LDA $8B                   
                    AND.B #$1B                
                    CMP.B #$1B                
                    BNE ADDR_00CD79           
                    LDA $15                   
                    AND.B #$0C                
                    BEQ ADDR_00CD79           
                    LDY $72                   
                    BNE ADDR_00CD72           
                    AND.B #$08                
                    BNE ADDR_00CD72           
                    LDA $8B                   
                    AND.B #$04                
                    BEQ ADDR_00CD79           
ADDR_00CD72:        LDA $8B                   
                    STA $74                   
                    JMP.W ADDR_00DB17         
ADDR_00CD79:        LDA $75                   
                    BEQ ADDR_00CD82           
                    JSR.W ADDR_00D988         
                    BRA ADDR_00CD8F           
ADDR_00CD82:        JSR.W ADDR_00D5F2         
                    JSR.W ADDR_00D062         
                    JSR.W ADDR_00D7E4         
ADDR_00CD8B:        JSL.L ADDR_00CEB1         
ADDR_00CD8F:        LDY.W $187A               
                    BNE ADDR_00CDAD           
                    RTS                       ; Return 

ADDR_00CD95:        LDA.B #$42                
                    LDX $19                   
                    BEQ ADDR_00CD9D           
                    LDA.B #$43                
ADDR_00CD9D:        DEY                       
                    BEQ ADDR_00CDA5           
                    STY.W $13F3               
                    LDA.B #$0F                
ADDR_00CDA5:        STA.W $13E0               

Instr00CDA8:        .db $60

DATA_00CDA9:        .db $20,$21,$27,$28

ADDR_00CDAD:        LDX.W $14A3               
                    BEQ ADDR_00CDBA           
                    LDY.B #$03                
                    CPX.B #$0C                
                    BCS ADDR_00CDBA           
                    LDY.B #$04                
ADDR_00CDBA:        LDA.W Instr00CDA8,Y       
                    DEY                       
                    BNE ADDR_00CDC6           
                    LDY $73                   
                    BEQ ADDR_00CDC6           
                    LDA.B #$1D                
ADDR_00CDC6:        STA.W $13E0               
                    LDA.W $141E               
                    CMP.B #$01                
                    BNE ADDR_00CDDC           
                    BIT $16                   
                    BVC ADDR_00CDDC           
                    LDA.B #$08                
                    STA.W $18DB               
                    JSR.W ADDR_00FEA8         
ADDR_00CDDC:        RTS                       ; Return 

ADDR_00CDDD:        LDA.W $1411               
                    BEQ ADDR_00CDDC           
                    LDY.W $13FE               
                    LDA.W $13FD               
                    STA $9D                   
                    BNE ADDR_00CE4C           
                    LDA.W $1400               
                    BEQ ADDR_00CDF6           
                    STZ.W $13FE               
                    BRA ADDR_00CE48           
ADDR_00CDF6:        LDA $17                   
                    AND.B #$CF                
                    ORA $15                   
                    BNE ADDR_00CE49           
                    LDA $17                   
                    AND.B #$30                
                    BEQ ADDR_00CE49           
                    CMP.B #$30                
                    BEQ ADDR_00CE49           
                    LSR                       
                    LSR                       
                    LSR                       
                    INC.W $1401               
                    LDX.W $1401               
                    CPX.B #$10                
                    BCC ADDR_00CE4C           
                    TAX                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W $142A               
                    CMP.W DATA_00F6CB,X       
                    SEP #$20                  ; Accum (8 bit) 
                    BEQ ADDR_00CE4C           
                    LDA.B #$01                
                    TRB.W $142A               
                    INC.W $13FD               
                    LDA.B #$00                
                    CPX.B #$02                
                    BNE ADDR_00CE33           
                    LDA $5E                   
                    DEC A                     
ADDR_00CE33:        REP #$20                  ; Accum (16 bit) 
                    XBA                       
                    AND.W #$FF00              
                    CMP $1A                   
                    SEP #$20                  ; Accum (8 bit) 
                    BEQ ADDR_00CE44           
                    LDY.B #$0E                
                    STY.W $1DFC               ; / Play sound effect 
ADDR_00CE44:        TXA                       
                    STA.W $13FE               
ADDR_00CE48:        TAY                       
ADDR_00CE49:        STZ.W $1401               
ADDR_00CE4C:        LDX.B #$00                
                    LDA $76                   
                    ASL                       
                    STA.W $13FF               
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W $142A               
                    CMP.W DATA_00F6CB,Y       
                    BEQ ADDR_00CE6D           
                    CLC                       
                    ADC.W DATA_00F6BF,Y       
                    LDY.W $13FF               
                    CMP.W DATA_00F6B3,Y       
                    BNE ADDR_00CE70           
                    STX.W $13FE               
ADDR_00CE6D:        STX.W $13FD               
ADDR_00CE70:        STA.W $142A               
                    STX.W $1400               
                    SEP #$20                  ; Accum (8 bit) 

Instr00CE78:        .db $60

DATA_00CE79:        .db $2A,$2B,$2C,$2D,$2E,$2F

DATA_00CE7F:        .db $2C,$2C,$2C,$2B,$2B,$2C,$2C,$2B
                    .db $2B,$2C,$2D,$2A,$2A,$2D,$2D,$2A
                    .db $2A,$2D,$2D,$2A,$2A,$2D,$2E,$2A
                    .db $2A,$2E

DATA_00CE99:        .db $00,$00,$25,$44,$00,$00,$0F,$45
DATA_00CEA1:        .db $00,$00,$00,$00,$01,$01,$01,$01
DATA_00CEA9:        .db $02,$07,$06,$09,$02,$07,$06,$09

ADDR_00CEB1:        LDA.W $14A2               ; Related to cape animation? 
                    BNE lbl14A2Not0           
                    LDX.W $13DF               ; Cape image 
                    LDA $72                   ; If Mario isn't in air, branch to $CEDE 
                    BEQ MarioAnimAir          ; branch to $CEDE 
                    LDY.B #$04                
                    BIT $7D                   ; \ If Mario is falling (and thus not on ground) 
                    BPL ADDR_00CECD           ; / branch down 
                    CMP.B #$0C                ; \ If making a "run jump", 
                    BEQ ADDR_00CEFD           ; / branch to $CEFD 
                    LDA $75                   ; \ If Mario is in water, 
                    BNE ADDR_00CEFD           ;  |branch to $CEFD 
                    BRA MrioNtInWtr           ; / otherwise, branch to $CEE4 
ADDR_00CECD:        INX                       ; \  
                    CPX.B #$05                ;  |if X >= #$04 and != #$FF then jump down <- counting the INX 
                    BCS ADDR_00CED6           ; /  
                    LDX.B #$05                ; X = #$05 
                    BRA ADDR_00CF0A           ; Branch to $CF04 
ADDR_00CED6:        CPX.B #$0B                ; \ If X is less than #$0B, 
                    BCC ADDR_00CF0A           ; / branch to $CF0A 
                    LDX.B #$07                ; X = #$07 
                    BRA ADDR_00CF0A           ; Mario is not in the air, branch to $CF0A 
MarioAnimAir:       LDA $7B                   ; \ If Mario X speed isn't 0, 
                    BNE ADDR_00CEF0           ; / branch to $CEF0 
                    LDY.B #$08                ; Otherwise Y = #$08 
MrioNtInWtr:        TXA                       ; A = X = #13DF 
                    BEQ ADDR_00CF0A           ; If $13DF (now A) = 0 branch to $CF04 
                    DEX                       ; \  
                    CPX.B #$03                ;  |If X - 1 < #$03 Then Branch $CF04 
                    BCC ADDR_00CF0A           ; /  
                    LDX.B #$02                ; X = #$02 
                    BRA ADDR_00CF0A           ; Branch to $CF04 
ADDR_00CEF0:        BPL ADDR_00CEF5           ; \  
                    EOR.B #$FF                ;  |A = abs(A) 
                    INC A                     ;  | 
ADDR_00CEF5:        LSR                       ; \  
                    LSR                       ;  |Divide a by 8 
                    LSR                       ; /  
                    TAY                       ; Y = A 
                    LDA.W DATA_00DC7C,Y       ; A = Mario animation speed? (I didn't know it was a table...) 
                    TAY                       ; Load Y with this table 
ADDR_00CEFD:        INX                       ; \  
                    CPX.B #$03                ;  | 
                    BCS ADDR_00CF04           ;  |If X is < #$02 and != #$FF <- counting the INX 
                    LDX.B #$05                ;  |then X = #$05 
ADDR_00CF04:        CPX.B #$07                ; \  
                    BCC ADDR_00CF0A           ;  |If X is greater than or equal to #$07 then X = #$03 
                    LDX.B #$03                ;  | 
ADDR_00CF0A:        STX.W $13DF               ; And X goes right back into $13DF (cape image) after being modified 
                    TYA                       ; Now Y goes back into A 
                    LDY $75                   ; \  
                    BEQ ADDR_00CF13           ;  |If mario is in water then A = 2A 
                    ASL                       ;  | 
ADDR_00CF13:        STA.W $14A2               ; A -> $14A2 (do we know this byte yet?) no. 
lbl14A2Not0:        LDA.W $140D               ; A = Spin Jump Flag 
                    ORA.W $14A6               
                    BEQ ADDR_00CF4E           ; If $140D OR $14A6 = 0 then branch to $CF4E 
                    STZ $73                   ; 0 -> Ducking while jumping flag 
                    LDA $14                   ; \  
                    AND.B #$06                ;  |X = Y = Alternate frame counter AND #$06 
                    TAX                       ;  | 
                    TAY                       ; /  
                    LDA $72                   ; \ If on ground branch down 
                    BEQ ADDR_00CF2F           ; /  
                    LDA $7D                   ; \ If Mario moving upwards branch down 
                    BMI ADDR_00CF2F           ; /  
                    INY                       ; Y = Y + 1 
ADDR_00CF2F:        LDA.W DATA_00CEA9,Y       ; \ After loading from this table, 
                    STA.W $13DF               ; / Store A in cape image 
                    LDA $19                   ; A = Mario's powerup status 
                    BEQ ADDR_00CF3A           ; \  
                    INX                       ;  |If not small, increase X 
ADDR_00CF3A:        LDA.W DATA_00CEA1,X       ; \ Load from another table 
                    STA $76                   ; / store to Mario's Direction 
                    LDY $19                   ; \  
                    CPY.B #$02                ;  | 
                    BNE ADDR_00CF48           ;  |If Mario has cape, JSR 
                    JSR.W ADDR_00D044         ;  |to possibly the graphics handler 
ADDR_00CF48:        LDA.W DATA_00CE99,X       ; \ Load from a table again 
                    JMP.W ADDR_00D01A         ; / And jump 
ADDR_00CF4E:        LDA.W $13ED               ; \ If $13ED is #$01 - #$7F then 
                    BEQ ADDR_00CF62           ;  |branch to $CF85 
                    BPL ADDR_00CF85           ;  | 
                    LDA.W $13E1               
                    LSR                       
                    LSR                       
                    ORA $76                   
                    TAY                       
                    LDA.W DATA_00CE7F,Y       
                    BRA ADDR_00CF85           
ADDR_00CF62:        LDA.B #$3C                ; \ Select Case $148F 
                    LDY.W $148F               ;  |Case 0:A = #$3C 
                    BEQ ADDR_00CF6B           ;  |Case Else: A = #$1D 
                    LDA.B #$1D                ;  |End Select 
ADDR_00CF6B:        LDY $73                   ; \ If Ducking while jumping 
                    BNE ADDR_00CF85           ; / Branch to $CF85 
                    LDA.W $149C               ; \ If (Unknown) = 0 
                    BEQ ADDR_00CF7E           ; / Branch to $CF7E 
                    LDA.B #$3F                ; A = #$3F 
                    LDY $72                   ; \ If Mario isn't in air,  
                    BEQ ADDR_00CF85           ;  |branch to $CF85 
                    LDA.B #$16                ;  |Otherwise, set A to #$16 and 
                    BRA ADDR_00CF85           ; / branch to $CF85 
ADDR_00CF7E:        LDA.B #$0E                ; A = #$0E 
                    LDY.W $149A               ; \ If Time to show Mario's current pose is 00, 
                    BEQ ADDR_00CF88           ;  | Don't jump to $D01A 
ADDR_00CF85:        JMP.W ADDR_00D01A         ;  | 
ADDR_00CF88:        LDA.B #$1D                ; A = #$1D 
                    LDY.W $1498               ; \ If $1499 != 0 then Jump to $D01A 
                    BNE ADDR_00CF85           ; /  
                    LDA.B #$0F                ; A = #$0F 
                    LDY.W $1499               ; \ If $1499 != 0 then Jump to $D01A 
                    BNE ADDR_00CF85           ; /  
                    LDA.B #$00                ; A = #$00 
                    LDX.W $18C2               ; X = $18C2 (Unknown) 
                    BNE MarioAnimNoAbs1       ; If X != 0 then branch down 
                    LDA $72                   ; \ If Mario is flying branch down 
                    BEQ ADDR_00CFB7           ; /  
                    LDY.W $14A0               ; \ If $14A0 != 0 then 
                    BNE ADDR_00CFBC           ; / Skip down 
                    LDY.W $1407               ; Spaghetticode(tm) 
                    BEQ ADDR_00CFAE           
                    LDA.W Instr00CE78,Y       
ADDR_00CFAE:        LDY.W $148F               ; \ If Mario isn't holding something, 
                    BEQ ADDR_00D01A           ;  |branch to $D01A 
                    LDA.B #$09                ;  |Otherwise, set A to #$09 and 
                    BRA ADDR_00D01A           ; / branch to $D01A 
ADDR_00CFB7:        LDA.W $13DD               
                    BNE ADDR_00D01A           
ADDR_00CFBC:        LDA $7B                   ; \  
                    BPL MarioAnimNoAbs1       ;  | 
                    EOR.B #$FF                ;  |Set A to absolute value of Mario's X speed 
                    INC A                     ;  | 
MarioAnimNoAbs1:    TAX                       ; Copy A to X 
                    BNE ADDR_00CFD4           ; If Mario isn't standing still, branch to $CFD4 
                    XBA                       ; "Push" A 
                    LDA $15                   ; \  
                    AND.B #$08                ;  |If player isn't pressing up, 
                    BEQ ADDR_00D002           ;  |branch to $D002 
                    LDA.B #$03                ;  |Otherwise, store x03 in $13DE and 
                    STA.W $13DE               ;  |branch to $D002 
                    BRA ADDR_00D002           ; /  
ADDR_00CFD4:        LDA $86                   ; \ If level isn't slippery, 
                    BEQ ADDR_00CFE3           ; / branch to $CFE3 
                    LDA $15                   
                    AND.B #$03                
                    BEQ ADDR_00D003           
                    LDA.B #$68                
                    STA.W $13E5               
ADDR_00CFE3:        LDA.W $13DB               ; A = $13DB 
                    LDY.W $1496               ; \ If Mario is hurt (flashing), 
                    BNE ADDR_00D003           ; / branch to $D003 
                    DEC A                     ; A = A - 1 
                    BPL ADDR_00CFF3           ; \If bit 7 is clear, 
                    LDY $19                   ;  | Load amount of walking frames 
                    LDA.W DATA_00DC78,Y       ;  | for current powerup 
ADDR_00CFF3:        XBA                       ; \ >>-This code puts together an index to a table further down-<< 
                    TXA                       ;  |-\ Above Line: "Push" frame amount 
                    LSR                       ;  |  |A = X / 8 
                    LSR                       ;  |  | 
                    LSR                       ;  |-/  
                    ORA.W $13E5               ;  |ORA with $13E5 
                    TAY                       ;  |And store A to Y 
                    LDA.W DATA_00DC7C,Y       ;  | 
                    STA.W $1496               ; /  
ADDR_00D002:        XBA                       ; \ Switch in frame amount and store it to $13DB 
ADDR_00D003:        STA.W $13DB               ; /  
                    CLC                       ; \ Add walking animation type 
                    ADC.W $13DE               ; / (Walking, running...) 
                    LDY.W $148F               ; \  
                    BEQ ADDR_00D014           ;  | 
                    CLC                       ;  |If Mario is carrying something, add #$07 
                    ADC.B #$07                ;  | 
                    BRA ADDR_00D01A           ;  | 
ADDR_00D014:        CPX.B #$2F                ; \  
                    BCC ADDR_00D01A           ;  |If X is greater than #$2F, add #$04 
                    ADC.B #$03                ; / <-Carry is always set here, adding #$01 to (#$03 + A) 
ADDR_00D01A:        LDY.W $13E3               ; \ If Mario isn't rotated 45 degrees (triangle 
                    BEQ MarioAnimNo45         ; / block), branch to $D030 
                    TYA                       ; \ Y AND #$01 -> Mario's Direction RAM Byte 
                    AND.B #$01                ;  | 
                    STA $76                   ; /  
                    LDA.B #$10                ; \  
                    CPY.B #$06                ;  |If Y < 6 then 
                    BCC MarioAnimNo45         ;  |    A = #13DB + $11 
                    LDA.W $13DB               ;  |Else 
                    CLC                       ;  |    A = #$10 
                    ADC.B #$11                ;  |End If 
MarioAnimNo45:      STA.W $13E0               ; Store in Current animation frame 
                    RTL                       ; And Finish 


DATA_00D034:        .db $0C,$00,$F4,$FF,$08,$00,$F8,$FF
DATA_00D03C:        .db $10,$00,$10,$00,$02,$00,$02,$00

ADDR_00D044:        LDY.B #$01                
                    STY.W $13E8               
                    ASL                       
                    TAY                       
                    REP #$20                  ; 16 bit A ; Accum (16 bit) 
                    LDA $94                   ; \  
                    CLC                       ;  | 
                    ADC.W DATA_00D034,Y       ;  | 
                    STA.W $13E9               ;  |Set cape<->sprite collision coordinates 
                    LDA $96                   ;  | 
                    CLC                       ;  | 
                    ADC.W DATA_00D03C,Y       ;  | 
                    STA.W $13EB               ; /  
                    SEP #$20                  ; 8 bit A ; Accum (8 bit) 
                    RTS                       ; Return 

ADDR_00D062:        LDA $19                   
                    CMP.B #$02                
                    BNE ADDR_00D081           
                    BIT $16                   
                    BVC ADDR_00D0AD           
                    LDA $73                   
                    ORA.W $187A               
                    ORA.W $140D               
                    BNE ADDR_00D0AD           
                    LDA.B #$12                
                    STA.W $14A6               
                    LDA.B #$04                
                    STA.W $1DFC               ; / Play sound effect 
                    RTS                       ; Return 

ADDR_00D081:        CMP.B #$03                
                    BNE ADDR_00D0AD           
                    LDA $73                   
                    ORA.W $187A               
                    BNE ADDR_00D0AD           
                    BIT $16                   
                    BVS ADDR_00D0AA           
                    LDA.W $140D               
                    BEQ ADDR_00D0AD           
                    INC.W $13E2               
                    LDA.W $13E2               
                    AND.B #$0F                
                    BNE ADDR_00D0AD           
                    TAY                       
                    LDA.W $13E2               
                    AND.B #$10                
                    BEQ ADDR_00D0A8           
                    INY                       
ADDR_00D0A8:        STY $76                   
ADDR_00D0AA:        JSR.W ADDR_00FEA8         ; haha, I read this as "FEAR" at first 
ADDR_00D0AD:        RTS                       ; Return 


DATA_00D0AE:        .db $7C,$00,$80,$00,$00,$06,$00,$01

MarioDeath:         STZ $19                   ; Set powerup to 0 
                    LDA.B #$3E                ; \  
                    STA.W $13E0               ; / Set Mario image to death image 
                    LDA $13                   ; \  
                    AND.B #$03                ;  |Decrease "Death fall timer" every four frames 
                    BNE ADDR_00D0C6           ;  | 
                    DEC.W $1496               ;  | 
ADDR_00D0C6:        LDA.W $1496               ; \ If Death fall timer isn't #$00, 
                    BNE DeathNotDone          ; / branch to $D108 
                    LDA.B #$80                
                    STA.W $0DD5               
                    LDA.W $1B9B               
                    BNE ADDR_00D0D8           
                    STZ.W $0DC1               ; Set reserve item to 0 
ADDR_00D0D8:        DEC.W $0DBE               ; Decrease amount of lifes 
                    BPL DeathNotGameOver      ; If not Game Over, branch to $D0E6 
                    LDA.B #$0A                
                    STA.W $1DFB               ; / Play sound effect 
                    LDX.B #$14                ; Set X (Death message) to x14 (Game Over) 
                    BRA DeathShowMessage      
DeathNotGameOver:   LDY.B #$0B                ; Set Y (game mode) to x0B (Fade to overworld) 
                    LDA.W $0F31               ; \  
                    ORA.W $0F32               ;  |If time isn't zero, 
                    ORA.W $0F33               ;  |branch to $D104 
                    BNE DeathNotTimeUp        ; /  
                    LDX.B #$1D                ; Set X (Death message) to x1D (Time Up) 
DeathShowMessage:   STX.W $143B               ; Store X in Death message 
                    LDA.B #$C0                ; \ Set Death message animation to xC0 
                    STA.W $143C               ; /(Must be divisable by 4) 
                    LDA.B #$FF                ; \ Set Death message timer to xFF 
                    STA.W $143D               ; / 
                    LDY.B #$15                ; Set Y (game mode) to x15 (Fade to Game Over) 
DeathNotTimeUp:     STY.W $0100               ; Store Y in Game Mode 
                    RTS                       ; Return 

DeathNotDone:       CMP.B #$26                ; \ If Death fall timer >= x26, 
                    BCS DeathNotDoneEnd       ; / return 
                    STZ $7B                   ; Set Mario X speed to 0 
                    JSR.W ADDR_00DC2D         
                    JSR.W ADDR_00D92E         
                    LDA $13                   ; \  
                    LSR                       ;  | 
                    LSR                       ;  |Flip death image every four frames 
                    AND.B #$01                ;  | 
                    STA $76                   ; /  
DeathNotDoneEnd:    RTS                       


DATA_00D11D:        .db $00,$3D,$00,$3D,$00,$3D,$46,$3D
                    .db $46,$3D,$46,$3D

ADDR_00D129:        LDA.W $1496               
                    BEQ ADDR_00D140           
                    LSR                       
                    LSR                       
ADDR_00D130:        TAY                       
                    LDA.W DATA_00D11D,Y       
                    STA.W $13E0               
ADDR_00D137:        LDA.W $1496               
                    BEQ ADDR_00D13F           
                    DEC.W $1496               
ADDR_00D13F:        RTS                       ; Return 

ADDR_00D140:        LDA.B #$7F                
                    STA.W $1497               
                    BRA ADDR_00D158           
ADDR_00D147:        LDA.W $1496               
                    BEQ ADDR_00D156           
                    LSR                       
                    LSR                       
                    EOR.B #$FF                
                    INC A                     
                    CLC                       
                    ADC.B #$0B                
                    BRA ADDR_00D130           
ADDR_00D156:        INC $19                   
ADDR_00D158:        LDA.B #$00                
                    STA $71                   
                    STZ $9D                   
ADDR_00D15E:        RTS                       ; Return 

ADDR_00D15F:        LDA.B #$7F                
                    STA $78                   
                    DEC.W $1496               
                    BNE ADDR_00D15E           
                    LDA $19                   
                    LSR                       
                    BEQ ADDR_00D140           
                    BNE ADDR_00D158           
ADDR_00D16F:        LDA.W $13ED               
                    AND.B #$80                
                    ORA.W $1407               
                    BEQ ADDR_00D187           
                    STZ.W $1407               
                    LDA.W $13ED               
                    AND.B #$7F                
                    STA.W $13ED               
                    STZ.W $13E0               
ADDR_00D187:        DEC.W $149B               
                    BEQ ADDR_00D158           
                    RTS                       ; Return 


DATA_00D18D:        .db $F8,$08

DATA_00D18F:        .db $00,$00,$F0

DATA_00D192:        .db $10

DATA_00D193:        .db $00,$63,$1C,$00

ADDR_00D197:        JSR.W NoButtons           
                    STZ.W $13DE               
                    JSL.L ADDR_00CEB1         
                    JSL.L ADDR_00CFBC         
                    JSR.W ADDR_00D1F4         
                    LDA.W $187A               
                    BEQ ADDR_00D1B2           
                    LDA.B #$29                
                    STA.W $13E0               
ADDR_00D1B2:        REP #$20                  ; Accum (16 bit) 
                    LDA $96                   
                    SEC                       
                    SBC.W #$0008              
                    AND.W #$FFF0              
                    ORA.W #$000E              
                    STA $96                   
                    SEP #$20                  ; Accum (8 bit) 
                    LDA $89                   
                    LSR                       
                    TAY                       
                    INY                       
                    LDA.W DATA_00D192,Y       
                    LDX.W $148F               
                    BEQ ADDR_00D1DB           
                    EOR.B #$1C                
                    DEC.W $1499               
                    BPL ADDR_00D1DB           
                    INC.W $1499               
ADDR_00D1DB:        LDX $88                   
                    CPX.B #$1D                
                    BCS ADDR_00D1F0           
                    CPY.B #$03                
                    BCC ADDR_00D1ED           
                    REP #$20                  ; Accum (16 bit) 
                    INC $96                   
                    INC $96                   
                    SEP #$20                  ; Accum (8 bit) 
ADDR_00D1ED:        LDA.W DATA_00D193,Y       
ADDR_00D1F0:        STA $78                   
                    BRA ADDR_00D22D           
ADDR_00D1F4:        LDA.W $14A2               
                    BEQ ADDR_00D1FC           
                    DEC.W $14A2               
ADDR_00D1FC:        JMP.W ADDR_00D137         

DATA_00D1FF:        .db $0A,$06

DATA_00D201:        .db $FF,$01

ADDR_00D203:        JSR.W NoButtons           
                    STZ.W $13DF               
                    LDA.B #$0F                
                    LDY.W $187A               
                    BEQ ADDR_00D22A           
                    LDX.B #$00                
                    LDY $76                   
                    LDA $94                   
                    AND.B #$0F                
                    CMP.W DATA_00D1FF,Y       
                    BEQ ADDR_00D228           
                    BPL ADDR_00D220           
                    INX                       
ADDR_00D220:        LDA $94                   
                    CLC                       
                    ADC.W DATA_00D201,X       
                    STA $94                   
ADDR_00D228:        LDA.B #$21                
ADDR_00D22A:        STA.W $13E0               
ADDR_00D22D:        LDA.B #$40                
                    STA $15                   
                    LDA.B #$02                
                    STA.W $13F9               
                    LDA $89                   
                    CMP.B #$04                
                    LDY $88                   
                    BEQ ADDR_00D268           
                    AND.B #$03                
                    TAY                       
                    DEC $88                   
                    BNE ADDR_00D24E           
                    BCS ADDR_00D24E           
                    LDA.B #$7F                
                    STA $78                   
                    INC.W $1405               
ADDR_00D24E:        LDA $7B                   
                    ORA $7D                   
                    BNE ADDR_00D259           
                    LDA.B #$04                
                    STA.W $1DF9               ; / Play sound effect 
ADDR_00D259:        LDA.W DATA_00D18D,Y       
                    STA $7B                   
                    LDA.W DATA_00D18F,Y       
                    STA $7D                   
                    STZ $72                   
                    JMP.W ADDR_00DC2D         
ADDR_00D268:        BCC ADDR_00D273           
ADDR_00D26A:        STZ.W $13F9               
                    STZ.W $1419               
                    JMP.W ADDR_00D158         
ADDR_00D273:        INC.W $141A               
                    LDA.B #$0F                
                    STA.W $0100               
                    RTS                       ; Return 

                    LDA $96                   
                    SEC                       
                    SBC $D3                   
                    CLC                       
                    ADC $88                   
                    STA $88                   
                    RTS                       ; Return 

ADDR_00D287:        JSR.W NoButtons           
                    LDA.B #$02                
                    STA.W $13F9               
                    LDA.B #$0C                
                    STA $72                   
                    JSR.W ADDR_00CD8B         
                    DEC $88                   
                    BNE ADDR_00D29D           
                    JMP.W ADDR_00D26A         
ADDR_00D29D:        LDA $88                   
                    CMP.B #$18                
                    BCC ADDR_00D2AA           
                    BNE ADDR_00D2B2           
                    LDA.B #$09                
                    STA.W $1DFC               ; / Play sound effect 
ADDR_00D2AA:        STZ.W $13F9               
                    STZ.W $1419               
                    STZ $9D                   
ADDR_00D2B2:        LDA.B #$40                
                    STA $7B                   
                    LDA.B #$C0                
                    STA $7D                   
                    JMP.W ADDR_00DC2D         

DATA_00D2BD:        .db $B0,$B6,$AE,$B4,$AB,$B2,$A9,$B0
                    .db $A6,$AE,$A4,$AB,$A1,$A9,$9F,$A6
DATA_00D2CD:        .db $00,$FF,$00,$01,$00,$FF,$00,$01
                    .db $00,$FF,$00,$01,$80,$FE,$C0,$00
                    .db $40,$FF,$80,$01,$00,$FE,$40,$00
                    .db $C0,$FF,$00,$02,$00,$FE,$40,$00
                    .db $00,$FE,$40,$00,$C0,$FF,$00,$02
                    .db $C0,$FF,$00,$02,$00,$FC,$00,$FF
                    .db $00,$01,$00,$04,$00,$FF,$00,$01
                    .db $00,$FF,$00,$01

DATA_00D309:        .db $E0,$FF,$20,$00,$E0,$FF,$20,$00
                    .db $E0,$FF,$20,$00,$C0,$FF,$20,$00
                    .db $E0,$FF,$40,$00,$80,$FF,$20,$00
                    .db $E0,$FF,$80,$00,$80,$FF,$20,$00
                    .db $80,$FF,$20,$00,$E0,$FF,$80,$00
                    .db $E0,$FF,$80,$00,$00,$FE,$80,$FF
                    .db $80,$00,$00,$02,$00,$FF,$00,$01
                    .db $00,$FF,$00,$01

DATA_00D345:        .db $80

DATA_00D346:        .db $FE,$80,$FE,$80,$01,$80,$01,$80
                    .db $FE,$80,$FE,$80,$01,$80,$01,$80
                    .db $FE,$80,$FE,$80,$01,$80,$01,$80
                    .db $FE,$80,$FE,$40,$01,$40,$01,$C0
                    .db $FE,$C0,$FE,$80,$01,$80,$01,$80
                    .db $FE,$80,$FE,$00,$01,$00,$01,$00
                    .db $FF,$00,$FF,$80,$01,$80,$01,$80
                    .db $FE,$80,$FE,$00,$01,$00,$01,$80
                    .db $FE,$80,$FE,$00,$01,$00,$01,$00
                    .db $FF,$00,$FF,$80,$01,$80,$01,$00
                    .db $FF,$00,$FF,$80,$01,$80,$01,$00
                    .db $FC,$00,$FC,$00,$FD,$00,$FD,$00
                    .db $03,$00,$03,$00,$04,$00,$04,$00
                    .db $FC,$00,$FC,$00,$06,$00,$06,$00
                    .db $FA,$00,$FA,$00,$04,$00,$04,$80
                    .db $FF,$80,$00,$00,$FF,$00,$01,$80
                    .db $FE,$80,$01,$80,$FE,$80,$FE,$80
                    .db $01,$80,$01,$80,$FE,$80,$02,$80
                    .db $FD,$00,$FB,$80,$02,$00,$05,$80
                    .db $FD,$00,$FB,$80,$02,$00,$05,$80
                    .db $FD,$00,$FB,$80,$02,$00,$05,$40
                    .db $FD,$80,$FA,$40,$02,$80,$04,$C0
                    .db $FD,$80,$FB,$C0,$02,$80,$05,$00
                    .db $FD,$00,$FA,$00,$02,$00,$04,$00
                    .db $FE,$00,$FC,$00,$03,$00,$06,$00
                    .db $FD,$00,$FA,$00,$02,$00,$04,$00
                    .db $FD,$00,$FA,$00,$02,$00,$04,$00
                    .db $FE,$00,$FC,$00,$03,$00,$06,$00
                    .db $FE,$00,$FC,$00,$03,$00,$06,$00
                    .db $FD,$00,$FA,$00,$FD,$00,$FA,$00
                    .db $03,$00,$06,$00,$03,$00,$06

DATA_00D43D:        .db $80,$FF,$80,$FE,$80,$00,$80,$01
                    .db $80,$FF,$80,$FE,$80,$00,$80,$01
                    .db $80,$FF,$80,$FE,$80,$00,$80,$01
                    .db $80,$FE,$80,$FE,$80,$00,$40,$01
                    .db $80,$FF,$C0,$FE,$80,$01,$80,$01
                    .db $80,$FE,$80,$FE,$80,$00,$00,$01
                    .db $80,$FF,$00,$FF,$80,$01,$80,$01
                    .db $80,$FE,$80,$FE,$80,$00,$00,$01
                    .db $80,$FE,$80,$FE,$80,$00,$00,$01
                    .db $80,$FF,$00,$FF,$80,$01,$80,$01
                    .db $80,$FF,$00,$FF,$80,$01,$80,$01
                    .db $00,$FC,$00,$FC,$00,$FE,$00,$FD
                    .db $00,$03,$00,$03,$00,$04,$00,$04
                    .db $00,$FC,$00,$FC,$80,$00,$80,$00
                    .db $80,$FF,$80,$FF,$00,$04,$00,$04
                    .db $80,$FF,$80,$00,$00,$FF,$00,$01
                    .db $80,$FE,$80,$01,$80,$FE,$80,$FE
                    .db $80,$01,$80,$01,$80,$FE,$80,$02
                    .db $C0,$FF,$80,$FD,$40,$00,$80,$02
                    .db $C0,$FF,$80,$FD,$40,$00,$80,$02
                    .db $C0,$FF,$80,$FD,$40,$00,$80,$02
                    .db $80,$FF,$40,$FD,$40,$00,$40,$02
                    .db $C0,$FF,$C0,$FD,$80,$00,$C0,$02
                    .db $00,$FD,$00,$FD,$40,$00,$00,$02
                    .db $C0,$FF,$00,$FE,$00,$03,$00,$03
                    .db $00,$FD,$00,$FD,$40,$00,$00,$02
                    .db $00,$FD,$00,$FD,$40,$00,$00,$02
                    .db $C0,$FF,$00,$FE,$00,$03,$00,$03
                    .db $C0,$FF,$00,$FE,$00,$03,$00,$03
                    .db $00,$FD,$00,$FD,$00,$FD,$00,$FD
                    .db $00,$03,$00,$03,$00,$03,$00,$03
DATA_00D535:        .db $EC,$14,$DC,$24,$DC,$24,$D0,$30
                    .db $EC,$14,$DC,$24,$DC,$24,$D0,$30
                    .db $EC,$14,$DC,$24,$DC,$24,$D0,$30
                    .db $E8,$12,$DC,$20,$DC,$20,$D0,$2C
                    .db $EE,$18,$E0,$24,$E0,$24,$D4,$30
                    .db $DC,$10,$DC,$1C,$DC,$1C,$D0,$28
                    .db $F0,$24,$E4,$24,$E4,$24,$D8,$30
                    .db $DC,$10,$DC,$1C,$DC,$1C,$D0,$28
                    .db $DC,$10,$DC,$1C,$DC,$1C,$D0,$28
                    .db $F0,$24,$E4,$24,$E4,$24,$D8,$30
                    .db $F0,$24,$E4,$24,$E4,$24,$D8,$30
                    .db $DC,$F0,$DC,$F8,$DC,$F8,$D0,$FC
                    .db $10,$24,$08,$24,$08,$24,$04,$30
                    .db $D0,$08,$D0,$08,$D0,$08,$D0,$08
                    .db $F8,$30,$F8,$30,$F8,$30,$F8,$30
                    .db $F8,$08,$F0,$10,$F4,$04,$E8,$08
                    .db $F0,$10,$E0,$20,$EC,$0C,$D8,$18
                    .db $D8,$28,$D4,$2C,$D0,$30,$D0,$D0
                    .db $30,$30,$E0,$20

DATA_00D5C9:        .db $00

DATA_00D5CA:        .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$F0,$00,$10,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$E0,$00
                    .db $20,$00,$00,$00,$00,$00,$F0,$00
                    .db $F8

DATA_00D5EB:        .db $FF,$FF,$02

DATA_00D5EE:        .db $68,$70

DATA_00D5F0:        .db $1C,$0C

ADDR_00D5F2:        LDA $72                   
                    BEQ ADDR_00D5F9           
                    JMP.W ADDR_00D682         
ADDR_00D5F9:        STZ $73                   
                    LDA.W $13ED               
                    BNE ADDR_00D60B           
                    LDA $15                   
                    AND.B #$04                
                    BEQ ADDR_00D60B           
                    STA $73                   
                    STZ.W $13E8               
ADDR_00D60B:        LDA.W $1471               
                    CMP.B #$02                
                    BEQ ADDR_00D61E           
                    LDA $77                   
                    AND.B #$08                
                    BNE ADDR_00D61E           
                    LDA $16                   
                    ORA $18                   
                    BMI ADDR_00D630           
ADDR_00D61E:        LDA $73                   
                    BEQ ADDR_00D682           
                    LDA $7B                   
                    BEQ ADDR_00D62D           
                    LDA $86                   
                    BNE ADDR_00D62D           
                    JSR.W ADDR_00FE4A         
ADDR_00D62D:        JMP.W ADDR_00D764         
ADDR_00D630:        LDA $7B                   
                    BPL ADDR_00D637           
                    EOR.B #$FF                
                    INC A                     
ADDR_00D637:        LSR                       
                    LSR                       
                    AND.B #$FE                
                    TAX                       
                    LDA $18                   
                    BPL ADDR_00D65E           
                    LDA.W $148F               
                    BNE ADDR_00D65E           
                    INC A                     
                    STA.W $140D               
                    LDA.B #$04                
                    STA.W $1DFC               ; / Play sound effect 
                    LDY $76                   
                    LDA.W DATA_00D5F0,Y       
                    STA.W $13E2               
                    LDA.W $187A               
                    BNE ADDR_00D682           
                    INX                       
                    BRA ADDR_00D663           
ADDR_00D65E:        LDA.B #$01                
                    STA.W $1DFA               ; / Play sound effect 
ADDR_00D663:        LDA.W DATA_00D2BD,X       
                    STA $7D                   
                    LDA.B #$0B                
                    LDY.W $13E4               
                    CPY.B #$70                
                    BCC ADDR_00D67D           
                    LDA.W $149F               
                    BNE ADDR_00D67B           
                    LDA.B #$50                
                    STA.W $149F               
ADDR_00D67B:        LDA.B #$0C                
ADDR_00D67D:        STA $72                   
                    STZ.W $13ED               
ADDR_00D682:        LDA.W $13ED               
                    BMI ADDR_00D692           
                    LDA $15                   
                    AND.B #$03                
                    BNE ADDR_00D6B1           
ADDR_00D68D:        LDA.W $13ED               
                    BEQ ADDR_00D6AE           
ADDR_00D692:        JSR.W ADDR_00FE4A         
                    LDA.W $13EE               
                    BEQ ADDR_00D6AE           
                    JSR.W ADDR_00D968         
                    LDA.W $13E1               
                    LSR                       
                    LSR                       
                    TAY                       
                    ADC.B #$76                
                    TAX                       
                    TYA                       
                    LSR                       
                    ADC.B #$87                
                    TAY                       
                    JMP.W ADDR_00D742         
ADDR_00D6AE:        JMP.W ADDR_00D764         
ADDR_00D6B1:        STZ.W $13ED               
                    AND.B #$01                
                    LDY.W $1407               
                    BEQ ADDR_00D6D5           
                    CMP $76                   
                    BEQ ADDR_00D6C3           
                    LDY $16                   
                    BPL ADDR_00D68D           
ADDR_00D6C3:        LDX $76                   
                    LDY.W DATA_00D5EE,X       
                    STY.W $13E1               
                    STA $01                   
                    ASL                       
                    ASL                       
                    ORA.W $13E1               
                    TAX                       
                    BRA ADDR_00D713           
ADDR_00D6D5:        LDY $76                   
                    CMP $76                   
                    BEQ ADDR_00D6EC           
                    LDY.W $148F               
                    BEQ ADDR_00D6EA           
                    LDY.W $1499               
                    BNE ADDR_00D6EC           
                    LDY.B #$08                
                    STY.W $1499               
ADDR_00D6EA:        STA $76                   
ADDR_00D6EC:        STA $01                   
                    ASL                       
                    ASL                       
                    ORA.W $13E1               
                    TAX                       
                    LDA $7B                   
                    BEQ ADDR_00D713           
                    EOR.W DATA_00D346,X       
                    BPL ADDR_00D713           
                    LDA.W $14A1               
                    BNE ADDR_00D713           
                    LDA $86                   
                    BNE ADDR_00D70E           
                    LDA.B #$0D                
                    STA.W $13DD               
                    JSR.W ADDR_00FE4A         
ADDR_00D70E:        TXA                       
                    CLC                       
                    ADC.B #$90                
                    TAX                       
ADDR_00D713:        LDY.B #$00                
                    BIT $15                   
                    BVC ADDR_00D737           
                    INX                       
                    INX                       
                    INY                       
                    LDA $7B                   
                    BPL ADDR_00D723           
                    EOR.B #$FF                
                    INC A                     
ADDR_00D723:        CMP.B #$23                
                    BMI ADDR_00D737           
                    LDA $72                   
                    BNE ADDR_00D732           
                    LDA.B #$10                
                    STA.W $14A0               
                    BRA ADDR_00D736           
ADDR_00D732:        CMP.B #$0C                
                    BNE ADDR_00D737           
ADDR_00D736:        INY                       
ADDR_00D737:        JSR.W ADDR_00D96A         
                    TYA                       
                    ASL                       
                    ORA.W $13E1               
                    ORA $01                   
                    TAY                       
ADDR_00D742:        LDA $7B                   
                    SEC                       
                    SBC.W DATA_00D535,Y       
                    BEQ ADDR_00D76B           
                    EOR.W DATA_00D535,Y       
                    BPL ADDR_00D76B           
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W DATA_00D345,X       
                    LDY $86                   
                    BEQ ADDR_00D75F           
                    LDY $72                   
                    BNE ADDR_00D75F           
                    LDA.W DATA_00D43D,X       
ADDR_00D75F:        CLC                       
                    ADC $7A                   
                    BRA ADDR_00D7A0           
ADDR_00D764:        JSR.W ADDR_00D968         
                    LDA $72                   
                    BNE ADDR_00D7A4           
ADDR_00D76B:        LDA.W $13E1               
                    LSR                       
                    TAY                       
                    LSR                       
                    TAX                       
ADDR_00D772:        LDA $7B                   
                    SEC                       
                    SBC.W DATA_00D5CA,X       
                    BPL ADDR_00D77C           
                    INY                       
                    INY                       
ADDR_00D77C:        LDA.W $1493               
                    ORA $72                   
                    REP #$20                  ; Accum (16 bit) 
                    BNE ADDR_00D78C           
                    LDA.W DATA_00D309,Y       
                    BIT $85                   
                    BMI ADDR_00D78F           
ADDR_00D78C:        LDA.W DATA_00D2CD,Y       
ADDR_00D78F:        CLC                       
                    ADC $7A                   
                    STA $7A                   
                    SEC                       
                    SBC.W DATA_00D5C9,X       
                    EOR.W DATA_00D2CD,Y       
                    BMI ADDR_00D7A2           
                    LDA.W DATA_00D5C9,X       
ADDR_00D7A0:        STA $7A                   
ADDR_00D7A2:        SEP #$20                  ; Accum (8 bit) 
ADDR_00D7A4:        RTS                       ; Return 


DATA_00D7A5:        .db $06,$03,$04,$10,$F4,$01,$03,$04
                    .db $05,$06

DATA_00D7AF:        .db $40,$40,$20,$40,$40,$40,$40,$40
                    .db $40,$40

DATA_00D7B9:        .db $10,$C8,$E0,$02,$03,$03,$04,$03
                    .db $02,$00,$01,$00,$00,$00,$00

DATA_00D7C8:        .db $01,$10,$30,$30,$38,$38,$40

DATA_00D7CF:        .db $FF,$01,$01,$FF,$FF

DATA_00D7D4:        .db $01,$06,$03,$01,$00

DATA_00D7D9:        .db $00,$00,$00,$F8,$F8,$F8,$F4,$F0
                    .db $C8,$02,$01

ADDR_00D7E4:        LDY.W $1407               
                    BNE ADDR_00D824           
                    LDA $72                   
                    BEQ ADDR_00D811           
                    LDA.W $148F               
                    ORA.W $187A               
                    ORA.W $140D               
                    BNE ADDR_00D811           
                    LDA.W $13ED               
                    BMI ADDR_00D7FF           
                    BNE ADDR_00D811           
ADDR_00D7FF:        STZ.W $13ED               
                    LDX $19                   
                    CPX.B #$02                
                    BNE ADDR_00D811           
                    LDA $7D                   
                    BMI ADDR_00D811           
                    LDA.W $149F               
                    BNE ADDR_00D814           
ADDR_00D811:        JMP.W ADDR_00D8CD         
ADDR_00D814:        STZ $73                   
                    LDA.B #$0B                
                    STA $72                   
                    STZ.W $1409               
                    JSR.W ADDR_00D94F         
                    LDX.B #$02                
                    BRA ADDR_00D85B           
ADDR_00D824:        CPY.B #$02                
                    BCC ADDR_00D82B           
                    JSR.W ADDR_00D94F         
ADDR_00D82B:        LDX.W $1408               
                    CPX.B #$04                
                    BEQ ADDR_00D856           
                    LDX.B #$03                
                    LDY $7D                   
                    BMI ADDR_00D856           
                    LDA $15                   
                    AND.B #$03                
                    TAY                       
                    BNE ADDR_00D849           
                    LDA.W $1407               
                    CMP.B #$04                
                    BCS ADDR_00D856           
                    DEX                       
                    BRA ADDR_00D856           
ADDR_00D849:        LSR                       
                    LDY $76                   
                    BEQ ADDR_00D850           
                    EOR.B #$01                
ADDR_00D850:        TAX                       
                    CPX.W $1408               
                    BNE ADDR_00D85B           
ADDR_00D856:        LDA.W $14A4               
                    BNE ADDR_00D87E           
ADDR_00D85B:        BIT $15                   
                    BVS ADDR_00D861           
                    LDX.B #$04                
ADDR_00D861:        LDA.W $1407               
                    CMP.W DATA_00D7D4,X       
                    BEQ ADDR_00D87E           
                    CLC                       
                    ADC.W DATA_00D7CF,X       
                    STA.W $1407               
                    LDA.B #$08                
                    LDY.W $1409               
                    CPY.B #$C8                
                    BNE ADDR_00D87B           
                    LDA.B #$02                
ADDR_00D87B:        STA.W $14A4               
ADDR_00D87E:        STX.W $1408               
                    LDY.W $1407               
                    BEQ ADDR_00D8CD           
                    LDA $7D                   
                    BPL ADDR_00D892           
                    CMP.B #$C8                
                    BCS ADDR_00D89A           
                    LDA.B #$C8                
                    BRA ADDR_00D89A           
ADDR_00D892:        CMP.W DATA_00D7C8,Y       
                    BCC ADDR_00D89A           
                    LDA.W DATA_00D7C8,Y       
ADDR_00D89A:        PHA                       
                    CPY.B #$01                
                    BNE ADDR_00D8C6           
                    LDX.W $1409               
                    BEQ ADDR_00D8C4           
                    LDA $7D                   
                    BMI ADDR_00D8AF           
                    LDA.B #$09                
                    STA.W $1DF9               ; / Play sound effect 
                    BRA ADDR_00D8B9           
ADDR_00D8AF:        CMP.W $1409               
                    BCS ADDR_00D8B9           
                    STX $7D                   
                    STZ.W $1409               
ADDR_00D8B9:        LDX $76                   
                    LDA $7B                   
                    BEQ ADDR_00D8C4           
                    EOR.W DATA_00D535,X       
                    BPL ADDR_00D8C6           
ADDR_00D8C4:        LDY.B #$02                
ADDR_00D8C6:        PLA                       
                    INY                       
                    INY                       
                    INY                       
                    JMP.W ADDR_00D948         
ADDR_00D8CD:        LDA $72                   
                    BEQ ADDR_00D928           
                    LDX.B #$00                
                    LDA.W $187A               
                    BEQ ADDR_00D8E7           
                    LDA.W $141E               
                    LSR                       
                    BEQ ADDR_00D8E7           
                    LDY.B #$02                
                    CPY $19                   
                    BEQ ADDR_00D8E5           
                    INX                       
ADDR_00D8E5:        BRA ADDR_00D8FF           
ADDR_00D8E7:        LDA $19                   
                    CMP.B #$02                
                    BNE ADDR_00D928           
                    LDA $72                   
                    CMP.B #$0C                
                    BNE ADDR_00D8FD           
                    LDY.B #$01                
                    CPY.W $149F               
                    BCC ADDR_00D8FF           
                    INC.W $149F               
ADDR_00D8FD:        LDY.B #$00                
ADDR_00D8FF:        LDA.W $14A5               
                    BNE ADDR_00D90D           
                    LDA $15,X                 
                    BPL ADDR_00D924           
                    LDA.B #$10                
                    STA.W $14A5               
ADDR_00D90D:        LDA $7D                   
                    BPL ADDR_00D91B           
                    LDX.W DATA_00D7B9,Y       
                    BPL ADDR_00D924           
                    CMP.W DATA_00D7B9,Y       
                    BCC ADDR_00D924           
ADDR_00D91B:        LDA.W DATA_00D7B9,Y       
                    CMP $7D                   
                    BEQ ADDR_00D94C           
                    BMI ADDR_00D94C           
ADDR_00D924:        CPY.B #$02                
                    BEQ ADDR_00D930           
ADDR_00D928:        LDY.B #$01                
                    LDA $15                   
                    BMI ADDR_00D930           
ADDR_00D92E:        LDY.B #$00                
ADDR_00D930:        LDA $7D                   ; \ If Mario's Y speed is negative (up), 
                    BMI ADDR_00D948           ; / branch to $D948 
                    CMP.W DATA_00D7AF,Y       
                    BCC ADDR_00D93C           
                    LDA.W DATA_00D7AF,Y       
ADDR_00D93C:        LDX $72                   
                    BEQ ADDR_00D948           
                    CPX.B #$0B                
                    BNE ADDR_00D948           
                    LDX.B #$24                
                    STX $72                   
ADDR_00D948:        CLC                       
                    ADC.W DATA_00D7A5,Y       
ADDR_00D94C:        STA $7D                   
                    RTS                       ; Return 

ADDR_00D94F:        STZ.W $140A               
                    LDA $7D                   
                    BPL ADDR_00D958           
                    LDA.B #$00                
ADDR_00D958:        LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_00D7D9,Y       
                    CMP.W $1409               
                    BPL ADDR_00D967           
                    STA.W $1409               
ADDR_00D967:        RTS                       ; Return 

ADDR_00D968:        LDY.B #$00                
ADDR_00D96A:        LDA.W $13E4               
                    CLC                       
                    ADC.W DATA_00D5EB,Y       
                    BPL ADDR_00D975           
                    LDA.B #$00                
ADDR_00D975:        CMP.B #$70                
                    BCC ADDR_00D97C           
                    INY                       
                    LDA.B #$70                
ADDR_00D97C:        STA.W $13E4               
                    RTS                       ; Return 


DATA_00D980:        .db $16,$1A,$1A,$18

DATA_00D984:        .db $E8,$F8,$D0,$D0

ADDR_00D988:        STZ.W $13ED               
                    STZ $73                   
                    STZ.W $1407               
                    STZ.W $140D               
                    LDY $7D                   
                    LDA.W $148F               
                    BEQ ADDR_00D9EB           
                    LDA $72                   
                    BNE ADDR_00D9AF           
                    LDA $16                   
                    ORA $18                   
                    BPL ADDR_00D9AF           
                    LDA.B #$0B                
                    STA $72                   
                    STZ.W $13ED               
                    LDY.B #$F0                
                    BRA ADDR_00D9B5           
ADDR_00D9AF:        LDA $15                   
                    AND.B #$04                
                    BEQ ADDR_00D9BD           
ADDR_00D9B5:        JSR.W ADDR_00DAA9         
                    TYA                       
                    CLC                       
                    ADC.B #$08                
                    TAY                       
ADDR_00D9BD:        INY                       
                    LDA.W $13FA               
                    BNE ADDR_00D9CC           
                    DEY                       
                    LDA $14                   
                    AND.B #$03                
                    BNE ADDR_00D9CC           
                    DEY                       
                    DEY                       
ADDR_00D9CC:        TYA                       
                    BMI ADDR_00D9D7           
                    CMP.B #$10                
                    BCC ADDR_00D9DD           
                    LDA.B #$10                
                    BRA ADDR_00D9DD           
ADDR_00D9D7:        CMP.B #$F0                
                    BCS ADDR_00D9DD           
                    LDA.B #$F0                
ADDR_00D9DD:        STA $7D                   
                    LDY.B #$80                
                    LDA $15                   
                    AND.B #$03                
                    BNE ADDR_00DA48           
                    LDA $76                   
                    BRA ADDR_00DA46           
ADDR_00D9EB:        LDA $16                   
                    ORA $18                   
                    BPL ADDR_00DA0B           
                    LDA.W $13FA               
                    BNE ADDR_00DA0B           
                    JSR.W ADDR_00DAA9         
                    LDA $72                   
                    BNE ADDR_00DA06           
                    LDA.B #$0B                
                    STA $72                   
                    STZ.W $13ED               
                    LDY.B #$F0                
ADDR_00DA06:        TYA                       
                    SEC                       
                    SBC.B #$20                
                    TAY                       
ADDR_00DA0B:        LDA $14                   
                    AND.B #$03                
                    BNE ADDR_00DA13           
                    INY                       
                    INY                       
ADDR_00DA13:        LDA $15                   
                    AND.B #$0C                
                    LSR                       
                    LSR                       
                    TAX                       
                    TYA                       
                    BMI ADDR_00DA25           
                    CMP.B #$40                
                    BCC ADDR_00DA2D           
                    LDA.B #$40                
                    BRA ADDR_00DA2D           
ADDR_00DA25:        CMP.W DATA_00D984,X       
                    BCS ADDR_00DA2D           
                    LDA.W DATA_00D984,X       
ADDR_00DA2D:        STA $7D                   
                    LDA $72                   
                    BNE ADDR_00DA40           
                    LDA $15                   
                    AND.B #$04                
                    BEQ ADDR_00DA40           
                    STZ.W $13E8               
                    INC $73                   
                    BRA ADDR_00DA69           
ADDR_00DA40:        LDA $15                   
                    AND.B #$03                
                    BEQ ADDR_00DA69           
ADDR_00DA46:        LDY.B #$78                
ADDR_00DA48:        STY $00                   
                    AND.B #$01                
                    STA $76                   
                    PHA                       
                    ASL                       
                    ASL                       
                    TAX                       
                    PLA                       
                    ORA $00                   
                    LDY.W $1403               
                    BEQ ADDR_00DA5D           
                    CLC                       
                    ADC.B #$04                
ADDR_00DA5D:        TAY                       
                    LDA $72                   
                    BEQ ADDR_00DA64           
                    INY                       
                    INY                       
ADDR_00DA64:        JSR.W ADDR_00D742         
                    BRA ADDR_00DA7C           
ADDR_00DA69:        LDY.B #$00                
                    TYX                       
                    LDA.W $1403               
                    BEQ ADDR_00DA79           
                    LDX.B #$1E                
                    LDA $72                   
                    BNE ADDR_00DA79           
                    INX                       
                    INX                       
ADDR_00DA79:        JSR.W ADDR_00D772         
ADDR_00DA7C:        JSR.W ADDR_00D062         
                    JSL.L ADDR_00CEB1         
                    LDA.W $14A6               
                    BNE ADDR_00DA8C           
                    LDA $72                   
                    BNE ADDR_00DA8D           
ADDR_00DA8C:        RTS                       ; Return 

ADDR_00DA8D:        LDA.B #$18                
                    LDY.W $149C               
                    BNE ADDR_00DA9F           
                    LDA.W $1496               
                    LSR                       
                    LSR                       
                    AND.B #$03                
                    TAY                       
                    LDA.W DATA_00D980,Y       
ADDR_00DA9F:        LDY.W $148F               
                    BEQ ADDR_00DAA5           
                    INC A                     
ADDR_00DAA5:        STA.W $13E0               
                    RTS                       ; Return 

ADDR_00DAA9:        LDA.B #$0E                
                    STA.W $1DF9               ; / Play sound effect 
                    LDA.W $1496               
                    ORA.B #$10                
                    STA.W $1496               
                    RTS                       ; Return 


DATA_00DAB7:        .db $10,$08,$F0,$F8

DATA_00DABB:        .db $B0,$F0

DATA_00DABD:        .db $00,$01,$00,$01,$01,$01,$01,$01
                    .db $01,$01,$01,$01,$01,$01,$01,$01
DATA_00DACD:        .db $22,$15,$22,$15,$21,$1F,$20,$20
                    .db $20,$20,$1F,$21,$1F,$21

DATA_00DADB:        .db $15,$22

DATA_00DADD:        .db $1E,$23

DATA_00DADF:        .db $10,$0F,$0E,$0D,$0C,$0B,$0A,$09
                    .db $08,$07,$06,$05,$05,$05,$05,$05
                    .db $05,$05

DATA_00DAF1:        .db $20,$01,$40,$01,$2A,$01,$2A,$01
                    .db $30,$01,$33,$01,$32,$01,$34,$01
                    .db $36,$01,$38,$01,$3A,$01,$3B,$01
                    .db $45,$01,$45,$01,$45,$01,$45,$01
                    .db $45,$01,$45,$01,$08,$F8

ADDR_00DB17:        STZ $72                   
                    STZ $7D                   
                    STZ.W $13DF               
                    STZ.W $140D               
                    LDY.W $149D               
                    BEQ ADDR_00DB7D           
                    LDA.W $1878               
                    BPL ADDR_00DB2E           
                    EOR.B #$FF                
                    INC A                     
ADDR_00DB2E:        TAX                       
                    CPY.B #$1E                
                    BCC ADDR_00DB45           
                    LDA.W DATA_00DADF,X       
                    BIT.W $1878               
                    BPL ADDR_00DB3E           
                    EOR.B #$FF                
                    INC A                     
ADDR_00DB3E:        STA $7B                   
                    STZ $7A                   
                    STZ.W $13DA               
ADDR_00DB45:        TXA                       
                    ASL                       
                    TAX                       
                    LDA.W $1878               
                    CPY.B #$08                
                    BCS ADDR_00DB51           
                    EOR.B #$80                
ADDR_00DB51:        ASL                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W DATA_00DAF1,X       
                    BCS ADDR_00DB5D           
                    EOR.W #$FFFF              
                    INC A                     
ADDR_00DB5D:        CLC                       
                    ADC $7A                   
                    STA $7A                   
                    SEP #$20                  ; Accum (8 bit) 
                    TYA                       
                    LSR                       
                    AND.B #$0E                
                    ORA.W $13F0               
                    TAY                       
                    LDA.W DATA_00DABD,Y       
                    BIT.W $1878               
                    BMI ADDR_00DB76           
                    EOR.B #$01                
ADDR_00DB76:        STA $76                   
                    LDA.W DATA_00DACD,Y       
                    BRA ADDR_00DB92           
ADDR_00DB7D:        STZ $7B                   
                    STZ $7A                   
                    LDX.W $13F9               
                    LDA.W $149E               
                    BEQ ADDR_00DB96           
                    TXA                       
                    INC A                     
                    INC A                     
                    JSR.W ADDR_00D044         
                    LDA.W DATA_00DADD,X       
ADDR_00DB92:        STA.W $13E0               
                    RTS                       ; Return 

ADDR_00DB96:        LDY $75                   
                    BIT $16                   
                    BPL ADDR_00DBAC           
                    LDA.B #$0B                
                    STA $72                   
                    LDA.W DATA_00DABB,Y       
                    STA $7D                   
                    LDA.B #$01                
                    STA.W $1DFA               ; / Play sound effect 
                    BRA ADDR_00DC00           
ADDR_00DBAC:        BVC ADDR_00DBCA           
                    LDA $74                   
                    BPL ADDR_00DBCA           
                    LDA.B #$01                
                    STA.W $1DF9               ; / Play sound effect 
                    STX.W $13F0               
                    LDA $94                   
                    AND.B #$08                
                    LSR                       
                    LSR                       
                    LSR                       
                    EOR.B #$01                
                    STA $76                   
                    LDA.B #$08                
                    STA.W $149E               
ADDR_00DBCA:        LDA.W DATA_00DADB,X       
                    STA.W $13E0               
                    LDA $15                   
                    AND.B #$03                
                    BEQ ADDR_00DBF2           
                    LSR                       
                    TAX                       
                    LDA $8B                   
                    AND.B #$18                
                    CMP.B #$18                
                    BEQ ADDR_00DBE8           
                    LDA $74                   
                    BPL ADDR_00DC00           
                    CPX $8C                   
                    BEQ ADDR_00DBF2           
ADDR_00DBE8:        TXA                       
                    ASL                       
                    ORA $75                   
                    TAX                       
                    LDA.W DATA_00DAB7,X       
                    STA $7B                   
ADDR_00DBF2:        LDA $15                   
                    AND.B #$0C                
                    BEQ ADDR_00DC16           
                    AND.B #$08                
                    BNE ADDR_00DC03           
                    LSR $8B                   
                    BCS ADDR_00DC0B           
ADDR_00DC00:        STZ $74                   
                    RTS                       ; Return 

ADDR_00DC03:        INY                       
                    INY                       
                    LDA $8B                   
                    AND.B #$02                
                    BEQ ADDR_00DC16           
ADDR_00DC0B:        LDA $74                   
                    BMI ADDR_00DC11           
                    STZ $7B                   
ADDR_00DC11:        LDA.W DATA_00DAB7,Y       
                    STA $7D                   
ADDR_00DC16:        ORA $7B                   
                    BEQ ADDR_00DC2C           
                    LDA.W $1496               
                    ORA.B #$08                
                    STA.W $1496               
                    AND.B #$07                
                    BNE ADDR_00DC2C           
                    LDA $76                   
                    EOR.B #$01                
                    STA $76                   
ADDR_00DC2C:        RTS                       ; Return 

ADDR_00DC2D:        LDA $7D                   ; \ Store Mario's Y speed in $8A 
                    STA $8A                   ; /  
                    LDA.W $13E3               
                    BEQ ADDR_00DC40           
                    LSR                       
                    LDA $7B                   
                    BCC ADDR_00DC3E           
                    EOR.B #$FF                
                    INC A                     
ADDR_00DC3E:        STA $7D                   
ADDR_00DC40:        LDX.B #$00                
                    JSR.W ADDR_00DC4F         
                    LDX.B #$02                
                    JSR.W ADDR_00DC4F         
                    LDA $8A                   
                    STA $7D                   
                    RTS                       ; Return 

ADDR_00DC4F:        LDA $7B,X                 
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    CLC                       
                    ADC.W $13DA,X             
                    STA.W $13DA,X             
                    REP #$20                  ; Accum (16 bit) 
                    PHP                       
                    LDA $7B,X                 
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    AND.W #$000F              
                    CMP.W #$0008              
                    BCC ADDR_00DC70           
                    ORA.W #$FFF0              
ADDR_00DC70:        PLP                       
                    ADC $94,X                 
                    STA $94,X                 
                    SEP #$20                  ; Accum (8 bit) 
                    RTS                       ; Return 


DATA_00DC78:        .db $01,$02,$02,$02

DATA_00DC7C:        .db $0A,$08,$06,$04,$03,$02,$01,$01
                    .db $0A,$08,$06,$04,$03,$02,$01,$01
                    .db $0A,$08,$06,$04,$03,$02,$01,$01
                    .db $08,$06,$04,$03,$02,$01,$01,$01
                    .db $08,$06,$04,$03,$02,$01,$01,$01
                    .db $05,$04,$03,$02,$01,$01,$01,$01
                    .db $05,$04,$03,$02,$01,$01,$01,$01
                    .db $05,$04,$03,$02,$01,$01,$01,$01
                    .db $05,$04,$03,$02,$01,$01,$01,$01
                    .db $05,$04,$03,$02,$01,$01,$01,$01
                    .db $05,$04,$03,$02,$01,$01,$01,$01
                    .db $04,$03,$02,$01,$01,$01,$01,$01
                    .db $04,$03,$02,$01,$01,$01,$01,$01
                    .db $02,$02,$02,$02,$02,$02,$02,$02
DATA_00DCEC:        .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $02,$04,$04,$04,$0E,$08,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$08,$08
                    .db $08,$08,$08,$08,$00,$00,$00,$00
                    .db $0C,$10,$12,$14,$16,$18,$1A,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$06,$00,$00
                    .db $00,$00,$00,$0A,$00,$00

DATA_00DD32:        .db $00,$08,$10,$14,$18,$1E,$24,$24
                    .db $28,$30,$38,$3E,$44,$4A,$50,$54
                    .db $58,$58,$5C,$60,$64,$68,$6C,$70
                    .db $74,$78,$7C,$80

DATA_00DD4E:        .db $00,$00,$00,$00,$10,$00,$10,$00
                    .db $00,$00,$00,$00,$F8,$FF,$F8,$FF
                    .db $0E,$00,$06,$00,$F2,$FF,$FA,$FF
                    .db $17,$00,$07,$00,$0F,$00,$EA,$FF
                    .db $FA,$FF,$FA,$FF,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$10,$00,$10,$00
                    .db $00,$00,$00,$00,$F8,$FF,$F8,$FF
                    .db $00,$00,$F8,$FF,$08,$00,$00,$00
                    .db $08,$00,$F8,$FF,$00,$00,$00,$00
                    .db $F8,$FF,$00,$00,$00,$00,$10,$00
                    .db $02,$00,$00,$00,$FE,$FF,$00,$00
                    .db $00,$00,$00,$00,$FC,$FF,$05,$00
                    .db $04,$00,$FB,$FF,$FB,$FF,$06,$00
                    .db $05,$00,$FA,$FF,$F9,$FF,$09,$00
                    .db $07,$00,$F7,$FF,$FD,$FF,$FD,$FF
                    .db $03,$00,$03,$00,$FF,$FF,$07,$00
                    .db $01,$00,$F9,$FF,$0A,$00,$F6,$FF
                    .db $08,$00,$F8,$FF,$08,$00,$F8,$FF
                    .db $00,$00,$04,$00,$FC,$FF,$FE,$FF
                    .db $02,$00,$0B,$00,$F5,$FF,$14,$00
                    .db $EC,$FF,$0E,$00,$F3,$FF,$08,$00
                    .db $F8,$FF,$0C,$00,$14,$00,$FD,$FF
                    .db $F4,$FF,$F4,$FF,$0B,$00,$0B,$00
                    .db $03,$00,$13,$00,$F5,$FF,$05,$00
                    .db $F5,$FF,$09,$00,$01,$00,$01,$00
                    .db $F7,$FF,$07,$00,$07,$00,$05,$00
                    .db $0D,$00,$0D,$00,$FB,$FF,$FB,$FF
                    .db $FB,$FF,$FF,$FF,$0F,$00,$01,$00
                    .db $F9,$FF,$00,$00

DATA_00DE32:        .db $01,$00,$11,$00,$11,$00,$19,$00
                    .db $01,$00,$11,$00,$11,$00,$19,$00
                    .db $0C,$00,$14,$00,$0C,$00,$14,$00
                    .db $18,$00,$18,$00,$28,$00,$18,$00
                    .db $18,$00,$28,$00,$06,$00,$16,$00
                    .db $01,$00,$11,$00,$09,$00,$11,$00
                    .db $01,$00,$11,$00,$09,$00,$11,$00
                    .db $01,$00,$11,$00,$11,$00,$01,$00
                    .db $11,$00,$11,$00,$01,$00,$11,$00
                    .db $11,$00,$01,$00,$11,$00,$11,$00
                    .db $01,$00,$11,$00,$01,$00,$11,$00
                    .db $11,$00,$05,$00,$04,$00,$14,$00
                    .db $04,$00,$14,$00,$0C,$00,$14,$00
                    .db $0C,$00,$14,$00,$10,$00,$10,$00
                    .db $10,$00,$10,$00,$10,$00,$00,$00
                    .db $10,$00,$00,$00,$10,$00,$00,$00
                    .db $10,$00,$00,$00,$0B,$00,$0B,$00
                    .db $11,$00,$11,$00,$FF,$FF,$FF,$FF
                    .db $10,$00,$10,$00,$10,$00,$10,$00
                    .db $10,$00,$10,$00,$10,$00,$15,$00
                    .db $15,$00,$25,$00,$25,$00,$04,$00
                    .db $04,$00,$04,$00,$14,$00,$14,$00
                    .db $04,$00,$14,$00,$14,$00,$04,$00
                    .db $04,$00,$14,$00,$04,$00,$04,$00
                    .db $14,$00,$00,$00,$08,$00,$00,$00
                    .db $00,$00,$08,$00,$00,$00,$00,$00
                    .db $10,$00,$18,$00,$00,$00,$10,$00
                    .db $18,$00,$00,$00,$10,$00,$00,$00
                    .db $10,$00,$F8,$FF

DATA_00DF16:        .db $00,$46,$83,$46

DATA_00DF1A:        .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$28,$00,$00,$00,$00
                    .db $00,$00,$04,$04,$04,$00,$00,$00
                    .db $00,$00,$08,$00,$00,$00,$00,$0C
                    .db $0C,$0C,$00,$00,$10,$10,$14,$14
                    .db $18,$18,$00,$00,$1C,$00,$00,$00
                    .db $00,$20,$00,$00,$00,$00,$24,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$04
                    .db $04,$04,$00,$00,$00,$00,$00,$08
                    .db $00,$00,$00,$00,$0C,$0C,$0C,$00
                    .db $00,$10,$10,$14,$14,$18,$18,$00
                    .db $00,$1C,$00,$00,$00,$00,$20,$00
                    .db $00,$00,$00,$24,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
DATA_00DFDA:        .db $00,$02,$80,$80,$00,$02,$0C,$80
                    .db $00,$02,$1A,$1B,$00,$02,$0D,$80
                    .db $00,$02,$22,$23,$00,$02,$32,$33
                    .db $00,$02,$0A,$0B,$00,$02,$30,$31
                    .db $00,$02,$20,$21,$00,$02,$7E,$80
                    .db $00,$02,$02,$80,$04,$7F,$4A,$5B
                    .db $4B,$5A

DATA_00E00C:        .db $50,$50,$50,$09,$50,$50,$50,$50
                    .db $50,$50,$09,$2B,$50,$2D,$50,$D5
                    .db $2E,$C4,$C4,$C4,$D6,$B6,$50,$50
                    .db $50,$50,$50,$50,$50,$C5,$D7,$2A
                    .db $E0,$50,$D5,$29,$2C,$B6,$D6,$28
                    .db $E0,$E0,$C5,$C5,$C5,$C5,$C5,$C5
                    .db $5C,$5C,$50,$5A,$B6,$50,$28,$28
                    .db $C5,$D7,$28,$70,$C5,$70,$1C,$93
                    .db $C5,$C5,$0B,$85,$90,$84,$70,$70
                    .db $70,$A0,$70,$70,$70,$70,$70,$70
                    .db $A0,$74,$70,$80,$70,$84,$17,$A4
                    .db $A4,$A4,$B3,$B0,$70,$70,$70,$70
                    .db $70,$70,$70,$E2,$72,$0F,$61,$70
                    .db $63,$82,$C7,$90,$B3,$D4,$A5,$C0
                    .db $08,$54,$0C,$0E,$1B,$51,$49,$4A
                    .db $48,$4B,$4C,$5D,$5E,$5F,$E3,$90
                    .db $5F,$5F,$C5,$70,$70,$70,$A0,$70
                    .db $70,$70,$70,$70,$70,$A0,$74,$70
                    .db $80,$70,$84,$17,$A4,$A4,$A4,$B3
                    .db $B0,$70,$70,$70,$70,$70,$70,$70
                    .db $E2,$72,$0F,$61,$70,$63,$82,$C7
                    .db $90,$B3,$D4,$A5,$C0,$08,$64,$0C
                    .db $0E,$1B,$51,$49,$4A,$48,$4B,$4C
                    .db $5D,$5E,$5F,$E3,$90,$5F,$5F,$C5
DATA_00E0CC:        .db $71,$60,$60,$19,$94,$96,$96,$A2
                    .db $97,$97,$18,$3B,$B4,$3D,$A7,$E5
                    .db $2F,$D3,$C3,$C3,$F6,$D0,$B1,$81
                    .db $B2,$86,$B4,$87,$A6,$D1,$F7,$3A
                    .db $F0,$F4,$F5,$39,$3C,$C6,$E6,$38
                    .db $F1,$F0,$C5,$C5,$C5,$C5,$C5,$C5
                    .db $6C,$4D,$71,$6A,$6B,$60,$38,$F1
                    .db $5B,$69,$F1,$F1,$4E,$E1,$1D,$A3
                    .db $C5,$C5,$1A,$95,$10,$07,$02,$01
                    .db $00,$02,$14,$13,$12,$30,$27,$26
                    .db $30,$03,$15,$04,$31,$07,$E7,$25
                    .db $24,$23,$62,$36,$33,$91,$34,$92
                    .db $35,$A1,$32,$F2,$73,$1F,$C0,$C1
                    .db $C2,$83,$D2,$10,$B7,$E4,$B5,$61
                    .db $0A,$55,$0D,$75,$77,$1E,$59,$59
                    .db $58,$02,$02,$6D,$6E,$6F,$F3,$68
                    .db $6F,$6F,$06,$02,$01,$00,$02,$14
                    .db $13,$12,$30,$27,$26,$30,$03,$15
                    .db $04,$31,$07,$E7,$25,$24,$23,$62
                    .db $36,$33,$91,$34,$92,$35,$A1,$32
                    .db $F2,$73,$1F,$C0,$C1,$C2,$83,$D2
                    .db $10,$B7,$E4,$B5,$61,$0A,$55,$0D
                    .db $75,$77,$1E,$59,$59,$58,$02,$02
                    .db $6D,$6E,$6F,$F3,$68,$6F,$6F,$06
DATA_00E18C:        .db $00,$40

DATA_00E18E:        .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$0D,$00,$10
                    .db $13,$22,$25,$28,$00,$16,$00,$00
                    .db $00,$00,$00,$00,$00,$08,$19,$1C
                    .db $04,$1F,$10,$10,$00,$16,$10,$06
                    .db $04,$08,$2B,$30,$35,$3A,$3F,$43
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $16,$16,$00,$00,$08,$00,$00,$00
                    .db $00,$00,$00,$10,$04,$00

DATA_00E1D4:        .db $06

DATA_00E1D5:        .db $00

DATA_00E1D6:        .db $06

DATA_00E1D7:        .db $00

DATA_00E1D8:        .db $86,$02,$06,$03,$06,$01,$06,$CE
                    .db $06,$06,$40,$00,$06,$2C,$06,$06
                    .db $44,$0E,$86,$2C,$06,$86,$2C,$0A
                    .db $86,$84,$08,$06,$0A,$02,$06,$AC
                    .db $10,$06,$CC,$10,$06,$AE,$10,$00
                    .db $8C,$14,$80,$2E,$00,$CA,$16,$91
                    .db $2F,$00,$8E,$18,$81,$30,$00,$EB
                    .db $1A,$90,$31,$04,$ED,$1C,$82,$06
                    .db $92,$1E

DATA_00E21A:        .db $84,$86,$88,$8A,$8C,$8E,$90,$90
                    .db $92,$94,$96,$98,$9A,$9C,$9E,$A0
                    .db $A2,$A4,$A6,$A8,$AA,$B0,$B6,$BC
                    .db $C2,$C8,$CE,$D4,$DA,$DE,$E2,$E2
DATA_00E23A:        .db $0A,$0A,$84,$0A,$88,$88,$88,$88
                    .db $8A,$8A,$8A,$8A,$44,$44,$44,$44
                    .db $42,$42,$42,$42,$40,$40,$40,$40
                    .db $22,$22,$22,$22,$A4,$A4,$A4,$A4
                    .db $A6,$A6,$A6,$A6,$86,$86,$86,$86
                    .db $6E,$6E,$6E,$6E

DATA_00E266:        .db $02,$02,$02,$0C,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$04,$12,$04,$04
                    .db $04,$12,$04,$04,$04,$12,$04,$04
                    .db $04,$12,$04,$04

DATA_00E292:        .db $01,$01,$01,$01,$02,$02,$02,$02
                    .db $04,$04,$04,$04,$08,$08,$08,$08
DATA_00E2A2:        .db $C8,$B2,$DC,$B2,$C8,$B2,$DC,$B2
                    .db $C8,$B2,$DC,$B2,$F0,$B2,$04,$B3
DATA_00E2B2:        .db $10,$D4,$10,$E8

DATA_00E2B6:        .db $08,$CC,$08

DATA_00E2B9:        .db $E0,$10,$10,$30

ADDR_00E2BD:        PHB                       
                    PHK                       
                    PLB                       
                    LDA $78                   
                    CMP.B #$FF                
                    BEQ ADDR_00E2CA           
                    JSL.L ADDR_01EA70         
ADDR_00E2CA:        LDY.W $149B               
                    BNE ADDR_00E308           
                    LDY.W $1490               
                    BEQ ADDR_00E314           
                    LDA $78                   
                    CMP.B #$FF                
                    BEQ ADDR_00E2E3           
                    LDA $14                   
                    AND.B #$03                
                    BNE ADDR_00E2E3           
                    DEC.W $1490               
ADDR_00E2E3:        LDA $13                   
                    CPY.B #$1E                
                    BCC ADDR_00E30A           
                    BNE ADDR_00E30C           
                    LDA.W $0DDA               
                    CMP.B #$FF                
                    BEQ ADDR_00E308           
                    AND.B #$7F                
                    STA.W $0DDA               
                    TAX                       
                    LDA.W $14AD               
                    ORA.W $14AE               
                    ORA.W $190C               
                    BEQ ADDR_00E305           
                    LDX.B #$0E                
ADDR_00E305:        STX.W $1DFB               ; / Play sound effect 
ADDR_00E308:        LDA $13                   
ADDR_00E30A:        LSR                       
                    LSR                       
ADDR_00E30C:        AND.B #$03                
                    INC A                     
                    INC A                     
                    INC A                     
                    INC A                     
                    BRA ADDR_00E31A           
ADDR_00E314:        LDA $19                   
                    ASL                       
                    ORA.W $0DB3               
ADDR_00E31A:        ASL                       
                    TAY                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W DATA_00E2A2,Y       
                    STA.W $0D82               
                    SEP #$20                  ; Accum (8 bit) 
                    LDX.W $13E0               
                    LDA.B #$05                
                    CMP.W $13E3               
                    BCS ADDR_00E33E           
                    LDA.W $13E3               
                    LDY $19                   
                    BEQ ADDR_00E33B           
                    CPX.B #$13                
                    BNE ADDR_00E33D           
ADDR_00E33B:        EOR.B #$01                
ADDR_00E33D:        LSR                       
ADDR_00E33E:        REP #$20                  ; Accum (16 bit) 
                    LDA $94                   
                    SBC $1A                   
                    STA $7E                   
                    LDA.W $188B               
                    AND.W #$00FF              
                    CLC                       
                    ADC $96                   
                    LDY $19                   
                    CPY.B #$01                
                    LDY.B #$01                
                    BCS ADDR_00E359           
                    DEC A                     
                    DEY                       
ADDR_00E359:        CPX.B #$0A                
                    BCS ADDR_00E360           
                    CPY.W $13DB               
ADDR_00E360:        SBC $1C                   
                    CPX.B #$1C                
                    BNE ADDR_00E369           
                    ADC.W #$0001              
ADDR_00E369:        STA $80                   
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.W $1497               
                    BEQ ADDR_00E385           
                    LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W DATA_00E292,Y       
                    AND.W $1497               
                    ORA $9D                   
                    ORA.W $13FB               
                    BNE ADDR_00E385           
                    PLB                       
                    RTL                       ; Return 

ADDR_00E385:        LDA.B #$C8                
                    CPX.B #$43                
                    BNE ADDR_00E38D           
                    LDA.B #$E8                
ADDR_00E38D:        STA $04                   
                    CPX.B #$29                
                    BNE ADDR_00E399           
                    LDA $19                   
                    BNE ADDR_00E399           
                    LDX.B #$20                
ADDR_00E399:        LDA.W DATA_00DCEC,X       
                    ORA $76                   
                    TAY                       
                    LDA.W DATA_00DD32,Y       
                    STA $05                   
                    LDY $19                   
                    LDA.W $13E0               
                    CMP.B #$3D                
                    BCS ADDR_00E3B0           
                    ADC.W DATA_00DF16,Y       
ADDR_00E3B0:        TAY                       
                    LDA.W DATA_00DF1A,Y       
                    STA $06                   
                    LDA.W DATA_00E00C,Y       
                    STA $0A                   
                    LDA.W DATA_00E0CC,Y       
                    STA $0B                   
                    LDA $64                   
                    LDX.W $13F9               
                    BEQ ADDR_00E3CA           
                    LDA.W DATA_00E2B9,X       
ADDR_00E3CA:        LDY.W DATA_00E2B2,X       
                    LDX $76                   
                    ORA.W DATA_00E18C,X       
                    STA.W $0303,Y             
                    STA.W $0307,Y             
                    STA.W $030F,Y             
                    STA.W $0313,Y             
                    STA.W $02FB,Y             
                    STA.W $02FF,Y             
                    LDX $04                   
                    CPX.B #$E8                
                    BNE ADDR_00E3EC           
                    EOR.B #$40                
ADDR_00E3EC:        STA.W $030B,Y             
                    JSR.W ADDR_00E45D         
                    JSR.W ADDR_00E45D         
                    JSR.W ADDR_00E45D         
                    JSR.W ADDR_00E45D         
                    LDA $19                   
                    CMP.B #$02                
                    BNE ADDR_00E458           
                    PHY                       
                    LDA.B #$2C                
                    STA $06                   
                    LDX.W $13E0               
                    LDA.W DATA_00E18E,X       
                    TAX                       
                    LDA.W DATA_00E1D7,X       
                    STA $0D                   
                    LDA.W DATA_00E1D8,X       
                    STA $0E                   
                    LDA.W DATA_00E1D5,X       
                    STA $0C                   
                    CMP.B #$04                
                    BCS ADDR_00E432           
                    LDA.W $13DF               
                    ASL                       
                    ASL                       
                    ORA $0C                   
                    TAY                       
                    LDA.W DATA_00E23A,Y       
                    STA $0C                   
                    LDA.W DATA_00E266,Y       
                    BRA ADDR_00E435           
ADDR_00E432:        LDA.W DATA_00E1D6,X       
ADDR_00E435:        ORA $76                   
                    TAY                       
                    LDA.W DATA_00E21A,Y       
                    STA $05                   
                    PLY                       
                    LDA.W DATA_00E1D4,X       
                    TSB $78                   
                    BMI ADDR_00E448           
                    JSR.W ADDR_00E45D         
ADDR_00E448:        LDX.W $13F9               
                    LDY.W DATA_00E2B6,X       
                    JSR.W ADDR_00E45D         
                    LDA $0E                   
                    STA $06                   
                    JSR.W ADDR_00E45D         
ADDR_00E458:        JSR.W ADDR_00F636         
                    PLB                       
                    RTL                       ; Return 

ADDR_00E45D:        LSR $78                   
                    BCS ADDR_00E49F           
                    LDX $06                   
                    LDA.W DATA_00DFDA,X       
                    BMI ADDR_00E49F           
                    STA.W $0302,Y             
                    LDX $05                   
                    REP #$20                  ; Accum (16 bit) 
                    LDA $80                   
                    CLC                       
                    ADC.W DATA_00DE32,X       
                    PHA                       
                    CLC                       
                    ADC.W #$0010              
                    CMP.W #$0100              
                    PLA                       
                    SEP #$20                  ; Accum (8 bit) 
                    BCS ADDR_00E49F           
                    STA.W $0301,Y             
                    REP #$20                  ; Accum (16 bit) 
                    LDA $7E                   
                    CLC                       
                    ADC.W DATA_00DD4E,X       
                    PHA                       
                    CLC                       
                    ADC.W #$0080              
                    CMP.W #$0200              
                    PLA                       
                    SEP #$20                  ; Accum (8 bit) 
                    BCS ADDR_00E49F           
                    STA.W $0300,Y             
                    XBA                       
                    LSR                       
ADDR_00E49F:        PHP                       
                    TYA                       
                    LSR                       
                    LSR                       
                    TAX                       
                    ASL $04                   
                    ROL                       
                    PLP                       
                    ROL                       
                    AND.B #$03                
                    STA.W $0460,X             
                    INY                       
                    INY                       
                    INY                       
                    INY                       
                    INC $05                   
                    INC $05                   
                    INC $06                   
                    RTS                       ; Return 


DATA_00E4B9:        .db $08,$08,$08,$08,$10,$10,$10,$10
                    .db $18,$18,$20,$20,$28,$30,$08,$10
                    .db $00,$00,$28,$00,$00,$00,$00,$00
                    .db $38,$50,$48,$40,$58,$58,$60,$60
                    .db $00

DATA_00E4DA:        .db $10,$10,$10,$10,$10,$10,$10,$10
                    .db $20,$20,$20,$20,$30,$30,$40,$30
                    .db $30,$30,$30,$00,$00,$00,$00,$00
                    .db $30,$30,$30,$30,$40,$40,$40,$40
                    .db $00

DATA_00E4FB:        .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $EC,$EC,$EE,$EE,$DA,$DA,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $DA,$DA,$DA,$DA,$00,$00,$00,$00
                    .db $00

DATA_00E51C:        .db $08,$08,$08,$08,$08,$08,$08,$08
                    .db $09,$09,$09,$09,$0B,$0B,$0B,$0B
                    .db $0B,$0B,$0B,$00,$00,$00,$00,$00
                    .db $0B,$0B,$0B,$0B,$14,$14,$14,$14
                    .db $06

DATA_00E53D:        .db $FF,$FF,$FF,$FF,$01,$01,$01,$01
                    .db $FE,$FE,$02,$02,$FD,$03,$FD,$03
                    .db $FD,$03,$FD,$00,$00,$00,$00,$00
                    .db $08,$08,$F8,$F8,$FC,$FC,$04,$04
                    .db $00,$00,$00,$00,$00,$00,$01,$01
                    .db $01,$01,$01,$02,$02,$02,$02,$02
                    .db $03,$03,$03,$03,$03,$04,$04,$04
                    .db $04,$04,$05,$05,$05,$05,$05,$06
                    .db $06,$06,$06,$06,$07,$07,$07,$07
                    .db $07,$08,$08,$08,$08,$08,$09,$09
                    .db $09,$09,$09,$0A,$0A,$0A,$0A,$0A
                    .db $0B,$0B,$0B,$0B,$0B,$0C,$0C,$0C
                    .db $0C,$0C,$0D,$0D,$0D,$0D,$0D,$0E
                    .db $0F,$10,$11,$03,$03,$04,$04,$09
                    .db $09,$0A,$0A,$0C,$0C,$0D,$0D,$12
                    .db $13,$14,$15,$16,$17,$1C,$1D,$1E
                    .db $1F,$18,$19,$1A,$1B,$08,$09,$0A
                    .db $0B,$0C,$0D,$00,$00,$00,$00,$00
                    .db $01,$01,$01,$01,$01,$02,$02,$02
                    .db $02,$02,$03,$03,$03,$03,$03,$04
                    .db $04,$04,$04,$04,$05,$05,$05,$05
                    .db $05,$06,$06,$06,$06,$06,$07,$07
                    .db $07,$07,$07,$08,$08,$08,$08,$08
                    .db $09,$09,$09,$09,$09,$0A,$0A,$0A
                    .db $0A,$0A,$0B,$0B,$0B,$0B,$0B,$0C
                    .db $0C,$0C,$0C,$0C,$0D,$0D,$0D,$0D
                    .db $0D,$0E,$0F,$10,$11,$03,$03,$04
                    .db $04,$09,$09,$0A,$0A,$0C,$0C,$0D
                    .db $0D,$0C,$0D,$0D,$0C,$16,$17,$1C
                    .db $1D,$1E,$1F,$18,$19,$1A,$1B,$08
                    .db $09,$0A,$0B,$0C,$0D

DATA_00E632:        .db $0F,$0F,$0F,$0F,$0E,$0E,$0E,$0E
                    .db $0D,$0D,$0D,$0D,$0C,$0C,$0C,$0C
                    .db $0B,$0B,$0B,$0B,$0A,$0A,$0A,$0A
                    .db $09,$09,$09,$09,$08,$08,$08,$08
                    .db $07,$07,$07,$07,$06,$06,$06,$06
                    .db $05,$05,$05,$05,$04,$04,$04,$04
                    .db $03,$03,$03,$03,$02,$02,$02,$02
                    .db $01,$01,$01,$01,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$01,$01,$01,$01
                    .db $02,$02,$02,$02,$03,$03,$03,$03
                    .db $04,$04,$04,$04,$05,$05,$05,$05
                    .db $06,$06,$06,$06,$07,$07,$07,$07
                    .db $08,$08,$08,$08,$09,$09,$09,$09
                    .db $0A,$0A,$0A,$0A,$0B,$0B,$0B,$0B
                    .db $0C,$0C,$0C,$0C,$0D,$0D,$0D,$0D
                    .db $0E,$0E,$0E,$0E,$0F,$0F,$0F,$0F
                    .db $0F,$0F,$0E,$0E,$0D,$0D,$0C,$0C
                    .db $0B,$0B,$0A,$0A,$09,$09,$08,$08
                    .db $07,$07,$06,$06,$05,$05,$04,$04
                    .db $03,$03,$02,$02,$01,$01,$00,$00
                    .db $00,$00,$01,$01,$02,$02,$03,$03
                    .db $04,$04,$05,$05,$06,$06,$07,$07
                    .db $08,$08,$09,$09,$0A,$0A,$0B,$0B
                    .db $0C,$0C,$0D,$0D,$0E,$0E,$0F,$0F
                    .db $0F,$0E,$0D,$0C,$0B,$0A,$09,$08
                    .db $07,$06,$05,$04,$03,$02,$01,$00
                    .db $00,$01,$02,$03,$04,$05,$06,$07
                    .db $08,$09,$0A,$0B,$0C,$0D,$0E,$0F
                    .db $0F,$0E,$0D,$0C,$0B,$0A,$09,$08
                    .db $07,$06,$05,$04,$03,$02,$01,$00
                    .db $00,$01,$02,$03,$04,$05,$06,$07
                    .db $08,$09,$0A,$0B,$0C,$0D,$0E,$0F
                    .db $08,$06,$04,$03,$02,$02,$01,$01
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00,$00,$00,$00,$00
                    .db $01,$01,$02,$02,$03,$04,$06,$08
                    .db $FF,$FE,$FD,$FC,$FB,$FA,$F9,$F8
                    .db $F7,$F6,$F5,$F4,$F3,$F2,$F1,$F0
                    .db $F0,$F1,$F2,$F3,$F4,$F5,$F6,$F7
                    .db $F8,$F9,$FA,$FB,$FC,$FD,$FE,$FF
                    .db $FF,$FF,$FE,$FE,$FD,$FD,$FC,$FC
                    .db $FB,$FB,$FA,$FA,$F9,$F9,$F8,$F8
                    .db $F7,$F7,$F6,$F6,$F5,$F5,$F4,$F4
                    .db $F3,$F3,$F2,$F2,$F1,$F1,$F0,$F0
                    .db $F0,$F0,$F1,$F1,$F2,$F2,$F3,$F3
                    .db $F4,$F4,$F5,$F5,$F6,$F6,$F7,$F7
                    .db $F8,$F8,$F9,$F9,$FA,$FA,$FB,$FB
                    .db $FC,$FC,$FD,$FD,$FE,$FE,$FF,$FF
                    .db $0F,$0E,$0D,$0C,$0B,$0A,$09,$08
                    .db $07,$06,$05,$04,$03,$02,$01,$00
                    .db $00,$01,$02,$03,$04,$05,$06,$07
                    .db $08,$09,$0A,$0B,$0C,$0D,$0E,$0F
                    .db $00,$01,$02,$03,$04,$05,$06,$07
                    .db $08,$09,$0A,$0B,$0C,$0D,$0E,$0F
                    .db $0F,$0E,$0D,$0C,$0B,$0A,$09,$08
                    .db $07,$06,$05,$04,$03,$02,$01,$00
                    .db $10,$10,$10,$10,$10,$10,$10,$10
                    .db $0E,$0C,$0A,$08,$06,$04,$02,$00
                    .db $0E,$0C,$0A,$08,$06,$04,$02,$00
                    .db $FE,$FC,$FA,$F8,$F6,$F4,$F2,$F0
                    .db $00,$02,$04,$06,$08,$0A,$0C,$0E
                    .db $10,$10,$10,$10,$10,$10,$10,$10
                    .db $F0,$F2,$F4,$F6,$F8,$FA,$FC,$FE
                    .db $00,$02,$04,$06,$08,$0A

DATA_00E830:        .db $0C,$0E,$08,$00,$0E,$00,$0E,$00
                    .db $08,$00,$05,$00,$0B,$00,$08,$00
                    .db $02,$00,$02,$00,$08,$00,$0B,$00
                    .db $05,$00,$08,$00,$0E,$00,$0E,$00
                    .db $08,$00,$05,$00,$0B,$00,$08,$00
                    .db $02,$00,$02,$00,$08,$00,$0B,$00
                    .db $05,$00,$08,$00,$0E,$00,$0E,$00
                    .db $08,$00,$05,$00,$0B,$00,$08,$00
                    .db $02,$00,$02,$00,$08,$00,$0B,$00
                    .db $05,$00,$08,$00,$0E,$00,$0E,$00
                    .db $08,$00,$05,$00,$0B,$00,$08,$00
                    .db $02,$00,$02,$00,$08,$00,$0B,$00
                    .db $05,$00,$10,$00,$20,$00,$07,$00
                    .db $00,$00,$F0,$FF

DATA_00E89C:        .db $08,$00,$18,$00,$1A,$00,$16,$00
DATA_00E8A4:        .db $10,$00,$20,$00,$20,$00,$18,$00
                    .db $1A,$00,$16,$00,$10,$00,$20,$00
                    .db $20,$00,$12,$00,$1A,$00,$0F,$00
                    .db $08,$00,$20,$00,$20,$00,$12,$00
                    .db $1A,$00,$0F,$00,$08,$00,$20,$00
                    .db $20,$00,$1D,$00,$28,$00,$19,$00
                    .db $13,$00,$30,$00,$30,$00,$1D,$00
                    .db $28,$00,$19,$00,$13,$00,$30,$00
                    .db $30,$00,$1A,$00,$28,$00,$16,$00
                    .db $10,$00,$30,$00,$30,$00,$1A,$00
                    .db $28,$00,$16,$00,$10,$00,$30,$00
                    .db $30,$00,$18,$00,$18,$00,$18,$00
                    .db $18,$00,$18,$00,$18,$00

DATA_00E90A:        .db $01,$02,$11

DATA_00E90D:        .db $FF

DATA_00E90E:        .db $FF,$01,$00

DATA_00E911:        .db $02,$0D

DATA_00E913:        .db $01,$00,$FF,$FF,$01,$00,$01,$00
                    .db $FF,$FF,$FF,$FF

DATA_00E91F:        .db $00,$00,$00,$00,$FF,$FF,$01,$00
                    .db $FF,$FF,$01,$00

ADDR_00E92B:        JSR.W ADDR_00EAA6         
                    LDA.W $185C               
                    BEQ ADDR_00E938           
                    JSR.W ADDR_00EE1D         
                    BRA ADDR_00E98C           
ADDR_00E938:        LDA.W $13EF               
                    STA $8D                   
                    STZ.W $13EF               
                    LDA $72                   
                    STA $8F                   
                    LDA $5B                   
                    BPL ADDR_00E978           
                    AND.B #$82                
                    STA $8E                   
                    LDA.B #$01                
                    STA.W $1933               
                    REP #$20                  ; Accum (16 bit) 
                    LDA $94                   
                    CLC                       
                    ADC $26                   
                    STA $94                   
                    LDA $96                   
                    CLC                       
                    ADC $28                   
                    STA $96                   
                    SEP #$20                  ; Accum (8 bit) 
                    JSR.W ADDR_00EADB         
                    REP #$20                  ; Accum (16 bit) 
                    LDA $94                   
                    SEC                       
                    SBC $26                   
                    STA $94                   
                    LDA $96                   
                    SEC                       
                    SBC $28                   
                    STA $96                   
                    SEP #$20                  ; Accum (8 bit) 
ADDR_00E978:        ASL.W $13EF               
                    LDA $5B                   
                    AND.B #$41                
                    STA $8E                   
                    ASL                       
                    BMI ADDR_00E98C           
                    STZ.W $1933               
                    ASL $8D                   
                    JSR.W ADDR_00EADB         
ADDR_00E98C:        LDA.W $1B96               
                    BEQ ADDR_00E9A1           
                    REP #$20                  ; Accum (16 bit) 
                    LDA $7E                   
                    CMP.W #$00FA              
                    SEP #$20                  ; Accum (8 bit) 
                    BCC ADDR_00E9FB           
                    JSL.L SubSideExit         
                    RTS                       ; Return 

ADDR_00E9A1:        LDA $7E                   
                    CMP.B #$F0                
                    BCS ADDR_00EA08           
                    LDA $77                   
                    AND.B #$03                
                    BNE ADDR_00E9FB           
                    REP #$20                  ; Accum (16 bit) 
                    LDY.B #$00                
                    LDA.W $1462               
                    CLC                       
                    ADC.W #$00E8              
                    CMP $94                   
                    BEQ ADDR_00E9C8           
                    BMI ADDR_00E9C8           
                    INY                       
                    LDA $94                   
                    SEC                       
                    SBC.W #$0008              
                    CMP.W $1462               
ADDR_00E9C8:        SEP #$20                  ; Accum (8 bit) 
                    BEQ ADDR_00E9FB           
                    BPL ADDR_00E9FB           
                    LDA.W $1411               
                    BNE ADDR_00E9F6           
                    LDA.B #$80                
                    TSB $77                   
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W $1446               
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    SEP #$20                  ; Accum (8 bit) 
                    STA $00                   
                    SEC                       
                    SBC $7B                   
                    EOR.W DATA_00E90E,Y       
                    BMI ADDR_00E9F6           
                    LDA $00                   
                    STA $7B                   
                    LDA.W $144E               
                    STA.W $13DA               
ADDR_00E9F6:        LDA.W DATA_00E90A,Y       
                    TSB $77                   
ADDR_00E9FB:        LDA $77                   
                    AND.B #$1C                
                    CMP.B #$1C                
                    BNE ADDR_00EA0D           
                    LDA.W $1471               
                    BNE ADDR_00EA0D           
ADDR_00EA08:        JSR.W ADDR_00F629         
                    BRA ADDR_00EA32           
ADDR_00EA0D:        LDA $77                   
                    AND.B #$03                
                    BEQ ADDR_00EA34           
                    AND.B #$02                
                    TAY                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA $94                   
                    CLC                       
                    ADC.W DATA_00E90D,Y       
                    STA $94                   
                    SEP #$20                  ; Accum (8 bit) 
                    LDA $77                   
                    BMI ADDR_00EA34           
                    LDA.B #$03                
                    STA.W $13E5               
                    LDA $7B                   
                    EOR.W DATA_00E90D,Y       
                    BPL ADDR_00EA34           
ADDR_00EA32:        STZ $7B                   
ADDR_00EA34:        LDA.W $13F9               
                    CMP.B #$01                
                    BNE ADDR_00EA42           
                    LDA $8B                   
                    BNE ADDR_00EA42           
                    STZ.W $13F9               
ADDR_00EA42:        STZ.W $13FA               
                    LDA $85                   
                    BNE ADDR_00EA5E           
                    LSR $8A                   
                    BCC ADDR_00EAA3           
                    LDA $75                   
                    BNE ADDR_00EA65           
                    LDA $7D                   
                    BMI ADDR_00EA65           
                    LSR $8A                   
                    BCC ADDR_00EAA5           
                    JSR.W ADDR_00FDA5         
                    STZ $7D                   
ADDR_00EA5E:        LDA.B #$01                
                    STA $75                   
ADDR_00EA62:        JMP.W ADDR_00FD08         
ADDR_00EA65:        LSR $8A                   
                    BCS ADDR_00EA5E           
                    LDA $75                   
                    BEQ ADDR_00EAA5           
                    LDA.B #$FC                
                    CMP $7D                   
                    BMI ADDR_00EA75           
                    STA $7D                   
ADDR_00EA75:        INC.W $13FA               
                    LDA $15                   
                    AND.B #$88                
                    CMP.B #$88                
                    BNE ADDR_00EA62           
                    LDA $17                   
                    BPL ADDR_00EA92           
                    LDA.W $148F               
                    BNE ADDR_00EA92           
                    INC A                     
                    STA.W $140D               
                    LDA.B #$04                
                    STA.W $1DFC               ; / Play sound effect 
ADDR_00EA92:        LDA $77                   
                    AND.B #$08                
                    BNE ADDR_00EA62           
                    JSR.W ADDR_00FDA5         
                    LDA.B #$0B                
                    STA $72                   
                    LDA.B #$AA                
                    STA $7D                   
ADDR_00EAA3:        STZ $75                   
ADDR_00EAA5:        RTS                       ; Return 

ADDR_00EAA6:        STZ.W $13E5               
                    STZ $77                   
                    STZ.W $13E1               
                    STZ.W $13EE               
                    STZ $8A                   
                    STZ $8B                   
                    STZ.W $140E               
                    RTS                       ; Return 


DATA_00EAB9:        .db $DE,$23

DATA_00EABB:        .db $20,$E0

DATA_00EABD:        .db $08,$00,$F8,$FF

DATA_00EAC1:        .db $71,$72,$76,$77,$7B,$7C,$81,$86
                    .db $8A,$8B,$8F,$90,$94,$95,$99,$9A
                    .db $9E,$9F,$A3,$A4,$A8,$A9,$AD,$AE
                    .db $B2,$B3

ADDR_00EADB:        LDA $96                   
                    AND.B #$0F                
                    STA $90                   
                    LDA.W $13E3               
                    BNE ADDR_00EAE9           
                    JMP.W ADDR_00EB77         
ADDR_00EAE9:        AND.B #$01                
                    TAY                       
                    LDA $7B                   
                    SEC                       
                    SBC.W DATA_00EAB9,Y       
                    EOR.W DATA_00EAB9,Y       
                    BMI ADDR_00EB48           
                    LDA $72                   
                    ORA.W $148F               
                    ORA $73                   
                    ORA.W $187A               
                    BNE ADDR_00EB48           
                    LDA.W $13E3               
                    CMP.B #$06                
                    BCS ADDR_00EB22           
                    LDX $90                   
                    CPX.B #$08                
                    BCC ADDR_00EB76           
                    CMP.B #$04                
                    BCS ADDR_00EB73           
                    ORA.B #$04                
                    STA.W $13E3               
ADDR_00EB19:        LDA $94                   
                    AND.B #$F0                
                    ORA.B #$08                
                    STA $94                   
                    RTS                       ; Return 

ADDR_00EB22:        LDX.B #$60                
                    TYA                       
                    BEQ ADDR_00EB29           
                    LDX.B #$66                
ADDR_00EB29:        JSR.W ADDR_00EFE8         
                    LDA $19                   
                    BNE ADDR_00EB34           
                    INX                       
                    INX                       
                    BRA ADDR_00EB37           
ADDR_00EB34:        JSR.W ADDR_00EFE8         
ADDR_00EB37:        JSR.W ADDR_00F44D         
                    BNE ADDR_00EB19           
                    LDA.B #$02                
                    TRB.W $13E3               
                    RTS                       ; Return 

ADDR_00EB42:        LDA.W $13E3               
                    AND.B #$01                
                    TAY                       
ADDR_00EB48:        LDA.W DATA_00EABB,Y       
                    STA $7B                   
                    TYA                       
                    ASL                       
                    TAY                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA $94                   
                    CLC                       
                    ADC.W DATA_00EABD,Y       
                    STA $94                   
                    LDA.W #$0008              
                    LDY $19                   
                    BEQ ADDR_00EB64           
                    LDA.W #$0010              
ADDR_00EB64:        CLC                       
                    ADC $96                   
                    STA $96                   
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.B #$24                
                    STA $72                   
                    LDA.B #$E0                
                    STA $7D                   
ADDR_00EB73:        STZ.W $13E3               
ADDR_00EB76:        RTS                       ; Return 

ADDR_00EB77:        LDX.B #$00                
                    LDA $19                   
                    BEQ ADDR_00EB83           
                    LDA $73                   
                    BNE ADDR_00EB83           
                    LDX.B #$18                
ADDR_00EB83:        LDA.W $187A               
                    BEQ ADDR_00EB8D           
                    TXA                       
                    CLC                       
                    ADC.B #$30                
                    TAX                       
ADDR_00EB8D:        LDA $94                   
                    AND.B #$0F                
                    TAY                       
                    CLC                       
                    ADC.B #$08                
                    AND.B #$0F                
                    STA $92                   
                    STZ $93                   
                    CPY.B #$08                
                    BCC ADDR_00EBA5           
                    TXA                       
                    ADC.B #$0B                
                    TAX                       
                    INC $93                   
ADDR_00EBA5:        LDA $90                   
                    CLC                       
                    ADC.W DATA_00E8A4,X       
                    AND.B #$0F                
                    STA $91                   
                    JSR.W ADDR_00F44D         
                    BEQ ADDR_00EBDD           
                    CPY.B #$11                
                    BCC ADDR_00EC24           
                    CPY.B #$6E                
                    BCC ADDR_00EBC9           
                    TYA                       
                    JSL.L ADDR_00F04D         
                    BCC ADDR_00EC24           
                    LDA.B #$01                
                    TSB $8A                   
                    BRA ADDR_00EC24           
ADDR_00EBC9:        INX                       
                    INX                       
                    INX                       
                    INX                       
                    TYA                       
                    LDY.B #$00                
                    CMP.B #$1E                
                    BEQ ADDR_00EBDA           
                    CMP.B #$52                
                    BEQ ADDR_00EBDA           
                    LDY.B #$02                
ADDR_00EBDA:        JMP.W ADDR_00EC6F         
ADDR_00EBDD:        CPY.B #$9C                
                    BNE ADDR_00EBE8           
                    LDA.W $1931               
                    CMP.B #$01                
                    BEQ ADDR_00EC06           
ADDR_00EBE8:        CPY.B #$20                
                    BEQ ADDR_00EC01           
                    CPY.B #$1F                
                    BEQ ADDR_00EBFD           
                    LDA.W $14AD               
                    BEQ ADDR_00EC21           
                    CPY.B #$28                
                    BEQ ADDR_00EC01           
                    CPY.B #$27                
                    BNE ADDR_00EC21           
ADDR_00EBFD:        LDA $19                   
                    BNE ADDR_00EC24           
ADDR_00EC01:        JSR.W ADDR_00F443         
                    BCS ADDR_00EC24           
ADDR_00EC06:        LDA $8F                   
                    BNE ADDR_00EC24           
                    LDA $16                   
                    AND.B #$08                
                    BEQ ADDR_00EC24           
                    LDA.B #$0F                
                    STA.W $1DFC               ; / Play sound effect 
                    JSR.W ADDR_00D273         
                    LDA.B #$0D                
                    STA $71                   
                    JSR.W NoButtons           
                    BRA ADDR_00EC24           
ADDR_00EC21:        JSR.W ADDR_00F28C         
ADDR_00EC24:        JSR.W ADDR_00F44D         
                    BEQ ADDR_00EC35           
                    CPY.B #$11                
                    BCC ADDR_00EC3A           
                    CPY.B #$6E                
                    BCS ADDR_00EC3A           
                    INX                       
                    INX                       
                    BRA ADDR_00EC4E           
ADDR_00EC35:        LDA.B #$10                
                    JSR.W ADDR_00F2C9         
ADDR_00EC3A:        JSR.W ADDR_00F44D         
                    BNE ADDR_00EC46           
                    LDA.B #$08                
                    JSR.W ADDR_00F2C9         
                    BRA ADDR_00EC8A           
ADDR_00EC46:        CPY.B #$11                
                    BCC ADDR_00EC8A           
                    CPY.B #$6E                
                    BCS ADDR_00EC8A           
ADDR_00EC4E:        LDA $76                   
                    CMP $93                   
                    BEQ ADDR_00EC5F           
                    JSR.W ADDR_00F3C4         
                    PHX                       
                    JSR.W ADDR_00F267         
                    LDY.W $1693               ; Current MAP16 tile number 
                    PLX                       
ADDR_00EC5F:        LDA.B #$03                
                    STA.W $13E5               
                    LDY $93                   
                    LDA $94                   
                    AND.B #$0F                
                    CMP.W DATA_00E911,Y       
                    BEQ ADDR_00EC8A           
ADDR_00EC6F:        LDA.W $1402               
                    BEQ ADDR_00EC7B           
                    LDA.W $1693               
                    CMP.B #$52                
                    BEQ ADDR_00EC8A           
ADDR_00EC7B:        LDA.W DATA_00E90A,Y       
                    TSB $77                   
                    AND.B #$03                
                    TAY                       
                    LDA.W $1693               ; Current MAP16 tile number 
                    JSL.L ADDR_00F127         
ADDR_00EC8A:        JSR.W ADDR_00F44D         
                    BNE ADDR_00ECB1           
                    LDA.B #$02                
                    JSR.W ADDR_00F2C2         
                    LDY $7D                   
                    BPL ADDR_00ECA3           
                    LDA.W $1693               ; Current MAP16 tile number 
                    CMP.B #$21                
                    BCC ADDR_00ECA3           
                    CMP.B #$25                
                    BCC ADDR_00ECA6           
ADDR_00ECA3:        JMP.W ADDR_00ED4A         
ADDR_00ECA6:        SEC                       
                    SBC.B #$04                
                    LDY.B #$00                
                    JSL.L ADDR_00F17F         
                    BRA ADDR_00ED0D           
ADDR_00ECB1:        CPY.B #$11                
                    BCC ADDR_00ECA3           
                    CPY.B #$6E                
                    BCC ADDR_00ECFA           
                    CPY.B #$D8                
                    BCC ADDR_00ECDA           
                    REP #$20                  ; Accum (16 bit) 
                    LDA $98                   
                    CLC                       
                    ADC.W #$0010              
                    STA $98                   
                    JSR.W ADDR_00F461         
                    BEQ ADDR_00ECF8           
                    CPY.B #$6E                
                    BCC ADDR_00ED4A           
                    CPY.B #$D8                
                    BCS ADDR_00ED4A           
                    LDA $91                   ; Accum (8 bit) 
                    SBC.B #$0F                
                    STA $91                   
ADDR_00ECDA:        TYA                       
                    SEC                       
                    SBC.B #$6E                
                    TAY                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA [$82],Y               
                    AND.W #$00FF              
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    SEP #$20                  ; Accum (8 bit) 
                    ORA $92                   
                    REP #$10                  ; Index (16 bit) 
                    TAY                       
                    LDA.W DATA_00E632,Y       
                    SEP #$10                  ; Index (8 bit) 
                    BMI ADDR_00ED0F           
ADDR_00ECF8:        BRA ADDR_00ED4A           
ADDR_00ECFA:        LDA.B #$02                
                    JSR.W ADDR_00F3E9         
                    TYA                       
                    LDY.B #$00                
                    JSL.L ADDR_00F127         
                    LDA.W $1693               ; Current MAP16 tile number 
                    CMP.B #$1E                ; \ If block is turn block, branch to $ED3B 
                    BEQ ADDR_00ED3B           ; /  
ADDR_00ED0D:        LDA.B #$F0                
ADDR_00ED0F:        CLC                       
                    ADC $91                   
                    BPL ADDR_00ED4A           
                    CMP.B #$F9                
                    BCS ADDR_00ED28           
                    LDY $72                   
                    BNE ADDR_00ED28           
                    LDA $77                   
                    AND.B #$FC                
                    ORA.B #$09                
                    STA $77                   
                    STZ $7B                   
                    BRA ADDR_00ED3B           
ADDR_00ED28:        LDY $72                   
                    BEQ ADDR_00ED37           
                    EOR.B #$FF                
                    CLC                       
                    ADC $96                   
                    STA $96                   
                    BCC ADDR_00ED37           
                    INC $97                   
ADDR_00ED37:        LDA.B #$08                
                    TSB $77                   
ADDR_00ED3B:        LDA $7D                   
                    BPL ADDR_00ED4A           
                    STZ $7D                   
                    LDA.W $1DF9               ; / Play sound effect 
                    BNE ADDR_00ED4A           
                    INC A                     
                    STA.W $1DF9               ; / Play sound effect 
ADDR_00ED4A:        JSR.W ADDR_00F44D         
                    BNE ADDR_00ED52           
                    JMP.W ADDR_00EDDB         
ADDR_00ED52:        CPY.B #$6E                
                    BCS ADDR_00ED5E           
                    LDA.B #$03                
                    JSR.W ADDR_00F3E9         
                    JMP.W ADDR_00EDF7         
ADDR_00ED5E:        CPY.B #$D8                
                    BCC ADDR_00ED86           
                    CPY.B #$FB                
                    BCC ADDR_00ED69           
                    JMP.W ADDR_00F629         
ADDR_00ED69:        REP #$20                  ; Accum (16 bit) 
                    LDA $98                   
                    SEC                       
                    SBC.W #$0010              
                    STA $98                   
                    JSR.W ADDR_00F461         
                    BEQ ADDR_00EDE9           
                    CPY.B #$6E                
                    BCC ADDR_00EDE9           
                    CPY.B #$D8                
                    BCS ADDR_00EDE9           
                    LDA $90                   ; Accum (8 bit) 
                    ADC.B #$10                
                    STA $90                   
ADDR_00ED86:        LDA.W $1931               
                    CMP.B #$03                
                    BEQ ADDR_00ED91           
                    CMP.B #$0E                
                    BNE ADDR_00ED95           
ADDR_00ED91:        CPY.B #$D2                
                    BCS ADDR_00EDE9           
ADDR_00ED95:        TYA                       
                    SEC                       
                    SBC.B #$6E                
                    TAY                       
                    LDA [$82],Y               
                    PHA                       
                    REP #$20                  ; Accum (16 bit) 
                    AND.W #$00FF              
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    SEP #$20                  ; Accum (8 bit) 
                    ORA $92                   
                    PHX                       
                    REP #$10                  ; Index (16 bit) 
                    TAX                       
                    LDA $90                   
                    SEC                       
                    SBC.W DATA_00E632,X       
                    BPL ADDR_00EDB9           
                    INC.W $13EF               
ADDR_00EDB9:        SEP #$10                  ; Index (8 bit) 
                    PLX                       
                    PLY                       
                    CMP.W DATA_00E51C,Y       
                    BCS ADDR_00EDE9           
                    STA $91                   
                    STZ $90                   
                    JSR.W ADDR_00F005         
                    CPY.B #$1C                
                    BCC ADDR_00EDD5           
                    LDA.B #$08                
                    STA.W $14A1               
                    JMP.W ADDR_00EED1         
ADDR_00EDD5:        JSR.W ADDR_00EFBC         
                    JMP.W ADDR_00EE85         
ADDR_00EDDB:        CPY.B #$05                
                    BNE ADDR_00EDE4           
                    JSR.W ADDR_00F629         
                    BRA ADDR_00EDE9           
ADDR_00EDE4:        LDA.B #$04                
                    JSR.W ADDR_00F2C2         
ADDR_00EDE9:        JSR.W ADDR_00F44D         
                    BNE ADDR_00EDF3           
                    JSR.W ADDR_00F309         
                    BRA ADDR_00EE1D           
ADDR_00EDF3:        CPY.B #$6E                
                    BCS ADDR_00EE1D           
ADDR_00EDF7:        LDA $7D                   
                    BMI ADDR_00EE39           
                    LDA.W $1931               
                    CMP.B #$03                
                    BEQ ADDR_00EE06           
                    CMP.B #$0E                
                    BNE ADDR_00EE11           
ADDR_00EE06:        LDY.W $1693               ; $ED3B 
                    CPY.B #$59                
                    BCC ADDR_00EE11           
                    CPY.B #$5C                
                    BCC ADDR_00EE1D           
ADDR_00EE11:        LDA $90                   
                    AND.B #$0F                
                    STZ $90                   
                    CMP.B #$08                
                    STA $91                   
                    BCC ADDR_00EE3A           
ADDR_00EE1D:        LDA.W $1471               ; \ If Mario isn't on a sprite platform, 
                    BEQ ADDR_00EE2D           ; / branch to $EE2D 
                    LDA $7D                   ; \ If Mario is moving up, 
                    BMI ADDR_00EE2D           ; / branch to $EE2D 
                    STZ $8E                   
                    LDY.B #$20                
                    JMP.W ADDR_00EEE1         
ADDR_00EE2D:        LDA $77                   ; \  
                    AND.B #$04                ;  |If Mario is on an edge or in air, 
                    ORA $72                   ;  |branch to $EE39 
                    BNE ADDR_00EE39           ; /  
ADDR_00EE35:        LDA.B #$24                ; \ Set "In air" to x24 (falling) 
                    STA $72                   ; /  
ADDR_00EE39:        RTS                       ; Return 

ADDR_00EE3A:        LDY.W $1693               ; Current MAP16 tile number 
                    LDA.W $1931               ; Tileset 
                    CMP.B #$02                ; \ If tileset is "Rope 1", 
                    BEQ ADDR_00EE48           ; / branch to $EE48 
                    CMP.B #$08                ; \ If tileset isn't "Rope 3", 
                    BNE ADDR_00EE57           ; / branch to $EE57 
ADDR_00EE48:        TYA                       ; \  
                    SEC                       ;  |If the current tile isn't Rope 3's "Conveyor rope", 
                    SBC.B #$0C                ;  |branch to $EE57 
                    CMP.B #$02                ;  | 
                    BCS ADDR_00EE57           ; /  
                    ASL                       
                    TAX                       
                    JSR.W ADDR_00EFCD         
                    BRA ADDR_00EE83           
ADDR_00EE57:        JSR.W ADDR_00F267         
                    LDY.B #$03                
                    LDA.W $1693               ; Current MAP16 tile number 
                    CMP.B #$1E                ; \ If block isn't "Turn block", 
                    BNE ADDR_00EE78           ; / branch to $EE78 
                    LDX $8F                   
                    BEQ ADDR_00EE83           
                    LDX $19                   
                    BEQ ADDR_00EE83           
                    LDX.W $140D               
                    BEQ ADDR_00EE83           
                    LDA.B #$21                
                    JSL.L ADDR_00F17F         
                    BRA ADDR_00EE1D           
ADDR_00EE78:        CMP.B #$32                ; \ If block isn't "Brown block", 
                    BNE ADDR_00EE7F           ; / branch to $EE7F 
                    STZ.W $1909               
ADDR_00EE7F:        JSL.L ADDR_00F120         
ADDR_00EE83:        LDY.B #$20                
ADDR_00EE85:        LDA $7D                   ; \ If Mario isn't moving up, 
                    BPL ADDR_00EE8F           ; / branch to $EE8F 
                    LDA $8D                   
                    CMP.B #$02                
                    BCC ADDR_00EE39           
ADDR_00EE8F:        LDX.W $1423               
                    BEQ ADDR_00EED1           
                    DEX                       
                    TXA                       
                    AND.B #$03                
                    BEQ ADDR_00EEAA           
                    CMP.B #$02                
                    BCS ADDR_00EED1           
                    REP #$20                  ; Accum (16 bit) 
                    LDA $9A                   
                    SEC                       
                    SBC.W #$0010              
                    STA $9A                   
                    SEP #$20                  ; Accum (8 bit) 
ADDR_00EEAA:        TXA                       
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W $1F27,X             ; \ If switch block is already active, 
                    BNE ADDR_00EED1           ; / branch to $EED1 
                    INC A                     ; \ Activate switch block 
                    STA.W $1F27,X             ; /  
                    STA.W $13D2               
                    PHY                       
                    STX.W $191E               
                    JSR.W FlatPalaceSwitch    
                    PLY                       
                    LDA.B #$0C                
                    STA.W $1DFB               ; / Play sound effect 
                    LDA.B #$FF                ; \  
                    STA.W $0DDA               ; / Set music to xFF 
                    LDA.B #$08                
                    STA.W $1493               
ADDR_00EED1:        INC.W $13EF               
                    LDA $96                   
                    SEC                       
                    SBC $91                   
                    STA $96                   
                    LDA $97                   
                    SBC $90                   
                    STA $97                   
ADDR_00EEE1:        LDA.W DATA_00E53D,Y       
                    BNE ADDR_00EEEF           
                    LDX.W $13ED               
                    BEQ ADDR_00EF05           
                    LDX $7B                   
                    BEQ ADDR_00EF02           
ADDR_00EEEF:        STA.W $13EE               
                    LDA $15                   
                    AND.B #$04                
                    BEQ ADDR_00EF05           
                    LDA.W $148F               
                    ORA.W $13ED               
                    BNE ADDR_00EF05           
                    LDX.B #$1C                
ADDR_00EF02:        STX.W $13ED               
ADDR_00EF05:        LDX.W DATA_00E4B9,Y       
                    STX.W $13E1               
                    CPY.B #$1C                
                    BCS ADDR_00EF38           
                    LDA $7B                   
                    BEQ ADDR_00EF31           
                    LDA.W DATA_00E53D,Y       
                    BEQ ADDR_00EF31           
                    EOR $7B                   
                    BPL ADDR_00EF31           
                    STX.W $13E5               
                    LDA $7B                   
                    BPL ADDR_00EF26           
                    EOR.B #$FF                
                    INC A                     
ADDR_00EF26:        CMP.B #$28                
                    BCC ADDR_00EF2F           
                    LDA.W DATA_00E4FB,Y       
                    BRA ADDR_00EF60           
ADDR_00EF2F:        LDY.B #$20                
ADDR_00EF31:        LDA $7D                   
                    CMP.W DATA_00E4DA,Y       
                    BCC ADDR_00EF3B           
ADDR_00EF38:        LDA.W DATA_00E4DA,Y       
ADDR_00EF3B:        LDX $8E                   
                    BPL ADDR_00EF60           
                    INC.W $140E               
                    PHA                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W $17BE               
                    AND.W #$FF00              
                    BPL ADDR_00EF50           
                    ORA.W #$00FF              
ADDR_00EF50:        XBA                       
                    EOR.W #$FFFF              
                    INC A                     
                    CLC                       
                    ADC $94                   
                    STA $94                   
                    SEP #$20                  ; Accum (8 bit) 
                    PLA                       
                    CLC                       
                    ADC.B #$28                
ADDR_00EF60:        STA $7D                   
                    TAX                       
                    BPL ADDR_00EF68           
                    INC.W $13EF               
ADDR_00EF68:        STZ.W $18B5               
                    STZ $72                   
                    STZ $74                   
                    STZ.W $1406               
                    STZ.W $140D               
                    LDA.B #$04                
                    TSB $77                   
                    LDY.W $1407               
                    BNE ADDR_00EF99           
                    LDA.W $187A               
                    BEQ ADDR_00EF95           
                    LDA $8F                   
                    BEQ ADDR_00EF95           
                    LDA.W $18E7               
                    BEQ ADDR_00EF95           
                    JSL.L ADDR_0286BF         
                    LDA.B #$25                
                    STA.W $1DFC               ; / Play sound effect 
ADDR_00EF95:        STZ.W $1697               
                    RTS                       ; Return 

ADDR_00EF99:        STZ.W $1697               
                    STZ.W $1407               
                    CPY.B #$05                
                    BCS ADDR_00EFAE           
                    LDA $19                   
                    CMP.B #$02                
                    BNE ADDR_00EFAD           
                    SEC                       
                    ROR.W $13ED               
ADDR_00EFAD:        RTS                       ; Return 

ADDR_00EFAE:        LDA $8F                   
                    BEQ ADDR_00EFBB           
                    JSL.L ADDR_0294C1         
                    LDA.B #$09                
                    STA.W $1DFC               ; / Play sound effect 
ADDR_00EFBB:        RTS                       ; Return 

ADDR_00EFBC:        LDX.W $1693               
                    CPX.B #$CE                
                    BCC ADDR_00EFE7           
                    CPX.B #$D2                
                    BCS ADDR_00EFE7           
                    TXA                       
                    SEC                       
                    SBC.B #$CC                
                    ASL                       
                    TAX                       
ADDR_00EFCD:        LDA $13                   
                    AND.B #$03                
                    BNE ADDR_00EFE7           
                    REP #$20                  ; Accum (16 bit) 
                    LDA $94                   
                    CLC                       
                    ADC.W DATA_00E913,X       
                    STA $94                   
                    LDA $96                   
                    CLC                       
                    ADC.W DATA_00E91F,X       
                    STA $96                   
                    SEP #$20                  ; Accum (8 bit) 
ADDR_00EFE7:        RTS                       ; Return 

ADDR_00EFE8:        JSR.W ADDR_00F44D         
                    BNE ADDR_00EFF0           
                    JMP.W ADDR_00F309         
ADDR_00EFF0:        CPY.B #$11                
                    BCC ADDR_00F004           
                    CPY.B #$6E                
                    BCS ADDR_00F004           
                    TYA                       
                    LDY.B #$00                
                    JSL.L ADDR_00F160         
                    PLA                       
                    PLA                       
                    JMP.W ADDR_00EB42         
ADDR_00F004:        RTS                       ; Return 

ADDR_00F005:        TYA                       
                    SEC                       
                    SBC.B #$0E                
                    CMP.B #$02                
                    BCS ADDR_00F04C           
                    EOR.B #$01                
                    CMP $76                   
                    BNE ADDR_00F04C           
                    TAX                       
                    LSR                       
                    LDA $92                   
                    BCC ADDR_00F01B           
                    EOR.B #$0F                
ADDR_00F01B:        CMP.B #$08                
                    BCS ADDR_00F04C           
                    LDA.W $187A               
                    BEQ ADDR_00F035           
                    LDA.B #$08                
                    STA.W $1DFC               ; / Play sound effect 
                    LDA.B #$80                
                    STA $7D                   
                    STA.W $1406               
                    PLA                       
                    PLA                       
                    JMP.W ADDR_00EE35         
ADDR_00F035:        LDA $7B                   
                    SEC                       
                    SBC.W DATA_00EAB9,X       
                    EOR.W DATA_00EAB9,X       
                    BMI ADDR_00F04C           
                    LDA.W $148F               
                    ORA $73                   
                    BNE ADDR_00F04C           
                    INX                       
                    INX                       
                    STX.W $13E3               
ADDR_00F04C:        RTS                       ; Return 

ADDR_00F04D:        PHX                       
                    LDX.B #$19                
ADDR_00F050:        CMP.L DATA_00EAC1,X       
                    BEQ ADDR_00F05A           
                    DEX                       
                    BPL ADDR_00F050           
                    CLC                       
ADDR_00F05A:        PLX                       
                    RTL                       ; Return 


DATA_00F05C:        .db $01,$05,$01,$02,$01,$01,$00,$00
                    .db $00,$00,$00,$00,$00,$06,$02,$02
                    .db $02,$02,$02,$02,$02,$02,$02,$02
                    .db $02,$03,$03,$04,$02,$02,$02,$01
                    .db $01,$07,$11,$10

DATA_00F080:        .db $80,$00,$00,$1E,$00,$00,$05,$09
                    .db $06,$81,$0E,$0C,$14,$00,$05,$09
                    .db $06,$07,$0E,$0C,$16,$18,$1A,$1A
                    .db $00,$09,$00,$00,$FF,$0C,$0A,$00
                    .db $00,$00,$08,$02

DATA_00F0A4:        .db $0C,$08,$0C,$08,$0C,$0F,$08,$08
                    .db $08,$08,$08,$08,$08,$08,$08,$08
                    .db $08,$08,$08,$08,$08,$08,$08,$08
                    .db $08,$03,$03,$08,$08,$08,$08,$08
                    .db $08,$04,$08,$08

DATA_00F0C8:        .db $0E,$13,$0E,$0D,$0E,$10,$0D,$0D
                    .db $0D,$0D,$0A,$0D,$0D,$0C,$0D,$0D
                    .db $0D,$0D,$0B,$0D,$0D,$16,$0D,$0D
                    .db $0D,$11,$11,$12,$0D,$0D,$0D,$0E
                    .db $0F,$0C,$0D,$0D

DATA_00F0EC:        .db $08,$01,$02,$04,$ED,$F6,$00,$7D
                    .db $BE,$00,$6F,$B7

DATA_00F0F8:        .db $40,$50,$00,$70,$80,$00,$A0,$B0
DATA_00F100:        .db $05,$09,$06,$05,$09,$06,$05,$09
                    .db $06,$05,$09,$06,$05,$09,$06,$05
                    .db $07,$0A,$10,$07,$0A,$10,$07,$0A
                    .db $10,$07,$0A,$10,$07,$0A,$10,$07

ADDR_00F120:        XBA                       
                    LDA.W $187A               
                    BNE ADDR_00F15F           
                    XBA                       
ADDR_00F127:        CMP.B #$2F                
                    BEQ ADDR_00F154           
                    CMP.B #$59                
                    BCC ADDR_00F144           
                    CMP.B #$5C                
                    BCS ADDR_00F140           
                    XBA                       
                    LDA.W $1931               
                    CMP.B #$05                
                    BEQ ADDR_00F154           
                    CMP.B #$0D                
                    BEQ ADDR_00F154           
                    XBA                       
ADDR_00F140:        CMP.B #$5D                
                    BCC ADDR_00F14C           
ADDR_00F144:        CMP.B #$66                
                    BCC ADDR_00F160           
                    CMP.B #$6A                
                    BCS ADDR_00F160           
ADDR_00F14C:        XBA                       
                    LDA.W $1931               
                    CMP.B #$01                
                    BNE ADDR_00F15F           
ADDR_00F154:        PHB                       
                    LDA.B #$01                
                    PHA                       
                    PLB                       
                    JSL.L HurtMario           
                    PLB                       
                    RTL                       ; Return 

ADDR_00F15F:        XBA                       
ADDR_00F160:        SEC                       
                    SBC.B #$11                
                    CMP.B #$1D                
                    BCC ADDR_00F17F           
                    XBA                       
                    PHX                       
                    LDX.W $1931               
                    LDA.L DATA_00A625,X       
                    PLX                       
                    AND.B #$03                
                    BEQ ADDR_00F176           
                    RTL                       ; Return 

ADDR_00F176:        XBA                       
                    SBC.B #$59                
                    CMP.B #$02                
                    BCS ADDR_00F1F8           
                    ADC.B #$22                
ADDR_00F17F:        PHX                       
                    PHA                       
                    TYX                       
                    LDA.L DATA_00F0EC,X       
                    PLX                       
                    AND.L DATA_00F0A4,X       
                    BEQ ADDR_00F1F6           
                    STY $06                   
                    LDA.L DATA_00F0C8,X       
                    STA $07                   
                    LDA.L DATA_00F05C,X       
                    STA $04                   
                    LDA.L DATA_00F080,X       
                    BPL ADDR_00F1BA           
                    CMP.B #$FF                
                    BNE ADDR_00F1AE           
                    LDA.B #$05                
                    LDY.W $0DC0               
                    BEQ ADDR_00F1D0           
                    BRA ADDR_00F1CE           
ADDR_00F1AE:        LSR                       
                    LDA $9A                   
                    ROR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.L DATA_00F100,X       
ADDR_00F1BA:        LSR                       
                    BCC ADDR_00F1D0           
                    CMP.B #$03                
                    BEQ ADDR_00F1C9           
                    LDY $19                   
                    BNE ADDR_00F1D0           
                    LDA.B #$01                
                    BRA ADDR_00F1D0           
ADDR_00F1C9:        LDY.W $1490               
                    BNE ADDR_00F1D0           
ADDR_00F1CE:        LDA.B #$06                
ADDR_00F1D0:        STA $05                   
                    CMP.B #$05                
                    BNE ADDR_00F1DA           
                    LDA.B #$16                
                    STA $07                   
ADDR_00F1DA:        TAY                       
                    LDA.B #$0F                
                    TRB $9A                   
                    TRB $98                   
                    CPY.B #$06                
                    BNE ADDR_00F1EC           
                    LDY.W $1931               
                    CPY.B #$04                
                    BEQ ADDR_00F1F9           
ADDR_00F1EC:        PHB                       
                    LDA.B #$02                
                    PHA                       
                    PLB                       
                    JSL.L ADDR_028752         
                    PLB                       
ADDR_00F1F6:        PLX                       
                    CLC                       
ADDR_00F1F8:        RTL                       ; Return 

ADDR_00F1F9:        LDA $99                   
                    LSR                       
                    LDA $98                   
                    AND.B #$C0                
                    ROL                       
                    ROL                       
                    ROL                       
                    TAY                       
                    LDA $9A                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    TAX                       
                    LDA.W $13F3,Y             
                    ORA.L DATA_00F0EC,X       
                    LDX.W $13F3,Y             
                    STA.W $13F3,Y             
                    CMP.B #$FF                
                    BNE ADDR_00F226           
                    LDA.B #$05                
                    STA $05                   
ADDR_00F220:        LDA.B #$17                
                    STA $07                   
                    BRA ADDR_00F1EC           
ADDR_00F226:        LDA.W $141B               
                    BNE ADDR_00F236           
                    TXA                       
                    BEQ ADDR_00F230           
                    LDA.B #$02                
ADDR_00F230:        EOR.B #$03                
                    AND $13                   
                    BNE ADDR_00F220           
ADDR_00F236:        LDA.B #$2A                
                    STA.W $1DFC               ; / Play sound effect 
                    PHY                       
                    STZ $05                   
                    PHB                       
                    LDA.B #$02                
                    PHA                       
                    PLB                       
                    JSL.L ADDR_028752         
                    PLB                       
                    PLY                       
                    LDX.B #$07                
                    LDA.W $13F3,Y             
ADDR_00F24E:        LSR                       
                    BCS ADDR_00F261           
                    PHA                       
                    LDA.B #$0D                
                    STA $9C                   
                    LDA.L DATA_00F0F8,X       
                    STA $9A                   
                    JSL.L ADDR_00BEB0         
                    PLA                       
ADDR_00F261:        DEX                       
                    BPL ADDR_00F24E           
                    JMP.W ADDR_00F1F6         
ADDR_00F267:        CPY.B #$2E                
                    BNE ADDR_00F28B           
                    BIT $16                   
                    BVC ADDR_00F28B           
                    LDA.W $148F               
                    ORA.W $187A               
                    BNE ADDR_00F28B           
                    LDA.B #$02                
                    PHA                       
                    PLB                       
                    JSL.L ADDR_02862F         
                    BMI ADDR_00F289           
                    LDA.B #$02                
                    STA $9C                   
                    JSL.L ADDR_00BEB0         
ADDR_00F289:        PHK                       
                    PLB                       
ADDR_00F28B:        RTS                       ; Return 

ADDR_00F28C:        TYA                       
                    SEC                       
                    SBC.B #$6F                
                    CMP.B #$04                
                    BCS ADDR_00F2C0           
                    CMP.W $1421               
                    BEQ ADDR_00F2A8           
                    INC A                     
                    CMP.W $1421               
                    BEQ ADDR_00F2BF           
                    LDA.W $1421               
                    CMP.B #$04                
                    BCS ADDR_00F2BF           
                    LDA.B #$FF                
ADDR_00F2A8:        INC A                     
                    STA.W $1421               
                    CMP.B #$04                
                    BNE ADDR_00F2BF           
                    PHX                       
                    JSL.L ADDR_03C2D9         
                    JSR.W ADDR_00F3B2         
                    ORA.W $1F3C,Y             
                    STA.W $1F3C,Y             
                    PLX                       
ADDR_00F2BF:        RTS                       ; Return 

ADDR_00F2C0:        LDA.B #$01                
ADDR_00F2C2:        CPY.B #$06                
                    BCS ADDR_00F2C9           
                    TSB $8A                   
                    RTS                       ; Return 

ADDR_00F2C9:        CPY.B #$38                
                    BNE ADDR_00F2EE           
                    LDA.B #$02                
                    STA $9C                   
                    JSL.L ADDR_00BEB0         
                    JSR.W ADDR_00FD5A         
                    LDA.W $13CD               
                    BEQ ADDR_00F2E0           
                    JSR.W ADDR_00CA2B         
ADDR_00F2E0:        LDA $19                   
                    BNE ADDR_00F2E8           
                    LDA.B #$01                
                    STA $19                   
ADDR_00F2E8:        LDA.B #$05                
                    STA.W $1DF9               ; / Play sound effect 
                    RTS                       ; Return 

ADDR_00F2EE:        CPY.B #$06                
                    BEQ ADDR_00F2FC           
                    CPY.B #$07                
                    BCC ADDR_00F309           
                    CPY.B #$1D                
                    BCS ADDR_00F309           
                    ORA.B #$80                
ADDR_00F2FC:        CMP.B #$01                
                    BNE ADDR_00F302           
                    ORA.B #$18                
ADDR_00F302:        TSB $8B                   
                    LDA $93                   
                    STA $8C                   
                    RTS                       ; Return 

ADDR_00F309:        CPY.B #$2F                
                    BCS ADDR_00F311           
                    CPY.B #$2A                
                    BCS ADDR_00F32B           
ADDR_00F311:        CPY.B #$6E                
                    BNE ADDR_00F376           
                    LDA.B #$0F                
                    JSL.L ADDR_00F38A         
                    INC.W $13C5               
                    PHX                       
                    JSR.W ADDR_00F3B2         
                    ORA.W $1FEE,Y             
                    STA.W $1FEE,Y             
                    PLX                       
                    BRA ADDR_00F36B           
ADDR_00F32B:        BNE ADDR_00F332           
                    LDA.W $14AD               
                    BEQ ADDR_00F376           
ADDR_00F332:        CPY.B #$2D                
                    BEQ ADDR_00F33F           
                    BCC ADDR_00F367           
                    LDA $98                   
                    SEC                       
                    SBC.B #$10                
                    STA $98                   
ADDR_00F33F:        JSL.L ADDR_00F377         
                    INC.W $1422               
                    LDA.W $1422               
                    CMP.B #$05                
                    BCC ADDR_00F358           
                    PHX                       
                    JSR.W ADDR_00F3B2         
                    ORA.W $1F2F,Y             
                    STA.W $1F2F,Y             
                    PLX                       
ADDR_00F358:        LDA.B #$1C                
                    STA.W $1DF9               ; / Play sound effect 
                    LDA.B #$01                
                    JSL.L ADDR_05B330         
                    LDY.B #$18                
                    BRA ADDR_00F36D           
ADDR_00F367:        JSL.L ADDR_05B34A         
ADDR_00F36B:        LDY.B #$01                
ADDR_00F36D:        STY $9C                   
                    JSL.L ADDR_00BEB0         
                    JSR.W ADDR_00FD5A         
ADDR_00F376:        RTS                       ; Return 

ADDR_00F377:        LDA.W $1420               
                    INC.W $1420               
                    CLC                       
                    ADC.B #$09                
                    CMP.B #$0D                
                    BCC ADDR_00F386           
                    LDA.B #$0D                
ADDR_00F386:        BRA ADDR_00F38A           
ADDR_00F388:        LDA.B #$0D                
ADDR_00F38A:        PHA                       
                    JSL.L ADDR_02AD34         
                    PLA                       
                    STA.W $16E1,Y             
                    LDA $94                   
                    STA.W $16ED,Y             
                    LDA $95                   
                    STA.W $16F3,Y             
                    LDA $96                   
                    STA.W $16E7,Y             
                    LDA $97                   
                    STA.W $16F9,Y             
                    LDA.B #$30                
                    STA.W $16FF,Y             
                    LDA.B #$00                
                    STA.W $1705,Y             
                    RTL                       ; Return 

ADDR_00F3B2:        LDA.W $13BF               
                    LSR                       
                    LSR                       
                    LSR                       
                    TAY                       
                    LDA.W $13BF               
                    AND.B #$07                
                    TAX                       
                    LDA.L DATA_05B35B,X       
                    RTS                       ; Return 

ADDR_00F3C4:        CPY.B #$3F                
                    BNE ADDR_00F376           
                    LDY $8F                   
                    BEQ ADDR_00F3CF           
                    JMP.W ADDR_00F43F         
ADDR_00F3CF:        PHX                       
                    TAX                       
                    LDA $94                   
                    TXY                       
                    BEQ ADDR_00F3D9           
                    EOR.B #$FF                
                    INC A                     
ADDR_00F3D9:        AND.B #$0F                
                    ASL                       
                    CLC                       
                    ADC.B #$20                
                    LDY.B #$05                
                    BRA ADDR_00F40A           

DATA_00F3E3:        .db $0A,$FF

DATA_00F3E5:        .db $02,$01,$08,$04

ADDR_00F3E9:        XBA                       
                    TYA                       
                    SEC                       
                    SBC.B #$37                
                    CMP.B #$02                
                    BCS ADDR_00F442           
                    TAY                       
                    LDA $92                   
                    SBC.W DATA_00F3E3,Y       
                    CMP.B #$05                
                    BCS ADDR_00F43F           
                    PHX                       
                    XBA                       
                    TAX                       
                    LDA.B #$20                
                    LDY.W $187A               
                    BEQ ADDR_00F408           
                    LDA.B #$30                
ADDR_00F408:        LDY.B #$06                
ADDR_00F40A:        STA $88                   
                    LDA $15                   
                    AND.W DATA_00F3E5,X       
                    BEQ ADDR_00F43E           
                    STA $9D                   
                    AND.B #$01                
                    STA $76                   
                    STX $89                   
                    TXA                       
                    LSR                       
                    TAX                       
                    BNE ADDR_00F430           
                    LDA.W $148F               
                    BEQ ADDR_00F430           
                    LDA $76                   
                    EOR.B #$01                
                    STA $76                   
                    LDA.B #$08                
                    STA.W $1499               
ADDR_00F430:        INX                       
                    STX.W $1419               
                    STY $71                   
                    JSR.W NoButtons           
                    LDA.B #$04                
                    STA.W $1DF9               ; / Play sound effect 
ADDR_00F43E:        PLX                       
ADDR_00F43F:        LDY.W $1693               
ADDR_00F442:        RTS                       ; Return 

ADDR_00F443:        LDA $94                   
                    CLC                       
                    ADC.B #$04                
                    AND.B #$0F                
                    CMP.B #$08                
                    RTS                       ; Return 

ADDR_00F44D:        INX                       
                    INX                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA $94                   
                    CLC                       
                    ADC.W DATA_00E830,X       
                    STA $9A                   
                    LDA $96                   
                    CLC                       
                    ADC.W DATA_00E89C,X       
                    STA $98                   
ADDR_00F461:        JSR.W ADDR_00F465         
                    RTS                       ; Return 

ADDR_00F465:        SEP #$20                  ; Accum (8 bit) 
                    STZ.W $1423               
                    PHX                       
                    LDA $8E                   
                    BPL ADDR_00F472           
                    JMP.W ADDR_00F4EC         
ADDR_00F472:        BNE ADDR_00F4A6           
                    REP #$20                  ; Accum (16 bit) 
                    LDA $98                   
                    CMP.W #$01B0              
                    SEP #$20                  ; Accum (8 bit) 
                    BCS ADDR_00F4A0           
                    AND.B #$F0                
                    STA $00                   
                    LDX $9B                   
                    CPX $5D                   
                    BCS ADDR_00F4A0           
                    LDA $9A                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    ORA $00                   
                    CLC                       
                    ADC.L DATA_00BA60,X       
                    STA $00                   
                    LDA $99                   
                    ADC.L DATA_00BA9C,X       
                    BRA ADDR_00F4CD           
ADDR_00F4A0:        PLX                       
                    LDY.B #$25                
ADDR_00F4A3:        LDA.B #$00                
                    RTS                       ; Return 

ADDR_00F4A6:        LDA $9B                   
                    CMP.B #$02                
                    BCS ADDR_00F4E7           
                    LDX $99                   
                    CPX $5D                   
                    BCS ADDR_00F4E7           
                    LDA $98                   
                    AND.B #$F0                
                    STA $00                   
                    LDA $9A                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    ORA $00                   
                    CLC                       
                    ADC.L DATA_00BA80,X       
                    STA $00                   
                    LDA $9B                   
                    ADC.L DATA_00BABC,X       
ADDR_00F4CD:        STA $01                   
                    LDA.B #$7E                
                    STA $02                   
                    LDA [$00]                 
                    STA.W $1693               
                    INC $02                   
                    PLX                       
                    LDA [$00]                 
                    JSL.L ADDR_00F545         
                    LDY.W $1693               
                    CMP.B #$00                
                    RTS                       ; Return 

ADDR_00F4E7:        PLX                       
                    LDY.B #$25                
                    BRA ADDR_00F4A3           
ADDR_00F4EC:        ASL                       
                    BNE ADDR_00F51B           
                    REP #$20                  ; Accum (16 bit) 
                    LDA $98                   
                    CMP.W #$01B0              
                    SEP #$20                  ; Accum (8 bit) 
                    BCS ADDR_00F4E7           
                    AND.B #$F0                
                    STA $00                   
                    LDX $9B                   
                    CPX.B #$10                
                    BCS ADDR_00F4E7           
                    LDA $9A                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    ORA $00                   
                    CLC                       
                    ADC.L DATA_00BA70,X       
                    STA $00                   
                    LDA $99                   
                    ADC.L DATA_00BAAC,X       
                    BRA ADDR_00F4CD           
ADDR_00F51B:        LDA $9B                   
                    CMP.B #$02                
                    BCS ADDR_00F4E7           
                    LDX $99                   
                    CPX.B #$0E                
                    BCS ADDR_00F4E7           
                    LDA $98                   
                    AND.B #$F0                
                    STA $00                   
                    LDA $9A                   
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    ORA $00                   
                    CLC                       
                    ADC.L DATA_00BA8E,X       
                    STA $00                   
                    LDA $9B                   
                    ADC.L DATA_00BACA,X       
                    JMP.W ADDR_00F4CD         
ADDR_00F545:        TAY                       
                    BNE ADDR_00F577           
                    LDY.W $1693               ; Load MAP16 tile number 
                    CPY.B #$29                ; \ If block isn't "Invisible POW ? block", 
                    BNE PSwitchNotInvQBlk     ; / branch to PSwitchNotInvQBlk 
                    LDY.W $14AD               
                    BEQ ADDR_00F594           
                    LDA.B #$24                
                    STA.W $1693               
                    RTL                       ; Return 

PSwitchNotInvQBlk:  CPY.B #$2B                ; \ If block is "Coin", 
                    BEQ PSwitchCoinBrown      ; / branch to PSwitchCoinBrown 
                    TYA                       
                    SEC                       
                    SBC.B #$EC                
                    CMP.B #$10                
                    BCS ADDR_00F592           
                    INC A                     
                    STA.W $1423               
                    BRA ADDR_00F571           
PSwitchCoinBrown:   LDY.W $14AD               
                    BEQ ADDR_00F594           
ADDR_00F571:        LDA.B #$32                
                    STA.W $1693               
                    RTL                       ; Return 

ADDR_00F577:        LDY.W $1693               
                    CPY.B #$32                
                    BNE ADDR_00F584           
                    LDY.W $14AD               
                    BNE ADDR_00F58D           
                    RTL                       ; Return 

ADDR_00F584:        CPY.B #$2F                
                    BNE ADDR_00F594           
                    LDY.W $14AE               
                    BEQ ADDR_00F594           
ADDR_00F58D:        LDY.B #$2B                
                    STY.W $1693               
ADDR_00F592:        LDA.B #$00                
ADDR_00F594:        RTL                       ; Return 

ADDR_00F595:        REP #$20                  ; Accum (16 bit) 
                    LDA.W #$FF80              
                    CLC                       
                    ADC $1C                   
                    CMP $96                   
                    BMI ADDR_00F5A3           
                    STA $96                   
ADDR_00F5A3:        SEP #$20                  ; Accum (8 bit) 
                    LDA $81                   
                    DEC A                     
                    BMI ADDR_00F5B6           
                    LDA.W $1B95               
                    BEQ ADDR_00F5B2           
                    JMP.W ADDR_00C95B         
ADDR_00F5B2:        JSL.L ADDR_00F60A         
ADDR_00F5B6:        RTS                       ; Return 

HurtMario:          LDA $71                   
                    BNE ADDR_00F628           
                    LDA.W $1497               
                    ORA.W $1490               
                    ORA.W $1493               
                    BNE ADDR_00F628           
                    STZ.W $18E3               
                    LDA.W $13E3               
                    BEQ ADDR_00F5D5           
                    PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_00EB42         
                    PLB                       
ADDR_00F5D5:        LDA $19                   
                    BEQ KillMario             
                    CMP.B #$02                
                    BNE ADDR_00F5F3           
                    LDA.W $1407               
                    BEQ ADDR_00F5F3           
                    LDY.B #$0F                
                    STY.W $1DF9               ; / Play sound effect 
                    LDA.B #$01                
                    STA.W $140D               
                    LDA.B #$30                
                    STA.W $1497               
                    BRA ADDR_00F622           
ADDR_00F5F3:        LDY.B #$04                
                    STY.W $1DF9               ; / Play sound effect 
                    JSL.L ADDR_028008         
                    LDA.B #$01                
                    STA $71                   
                    STZ $19                   
                    LDA.B #$2F                
                    BRA ADDR_00F61D           
KillMario:          LDA.B #$90                
                    STA $7D                   
ADDR_00F60A:        LDA.B #$09                
                    STA.W $1DFB               ; / Play sound effect 
                    LDA.B #$FF                
                    STA.W $0DDA               
                    LDA.B #$09                
                    STA $71                   
                    STZ.W $140D               
                    LDA.B #$30                
ADDR_00F61D:        STA.W $1496               
                    STA $9D                   
ADDR_00F622:        STZ.W $1407               
                    STZ.W $188A               
ADDR_00F628:        RTL                       ; Return 

ADDR_00F629:        JSL.L KillMario           
NoButtons:          STZ $15                   ; Zero RAM mirrors for controller Input 
                    STZ $16                   
                    STZ $17                   
                    STZ $18                   
                    RTS                       ; Return 

ADDR_00F636:        REP #$20                  ; Accum (16 bit) 
                    LDX.B #$00                
                    LDA $09                   
                    ORA.W #$0800              
                    CMP $09                   
                    BEQ ADDR_00F644           
                    CLC                       
ADDR_00F644:        AND.W #$F700              
                    ROR                       
                    LSR                       
                    ADC.W #$2000              
                    STA.W $0D85               
                    CLC                       
                    ADC.W #$0200              
                    STA.W $0D8F               
                    LDX.B #$00                
                    LDA $0A                   
                    ORA.W #$0800              
                    CMP $0A                   
                    BEQ ADDR_00F662           
                    CLC                       
ADDR_00F662:        AND.W #$F700              
                    ROR                       
                    LSR                       
                    ADC.W #$2000              
                    STA.W $0D87               
                    CLC                       
                    ADC.W #$0200              
                    STA.W $0D91               
                    LDA $0B                   
                    AND.W #$FF00              
                    LSR                       
                    LSR                       
                    LSR                       
                    ADC.W #$2000              
                    STA.W $0D89               
                    CLC                       
                    ADC.W #$0200              
                    STA.W $0D93               
                    LDA $0C                   
                    AND.W #$FF00              
                    LSR                       
                    LSR                       
                    LSR                       
                    ADC.W #$2000              
                    STA.W $0D99               
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.B #$0A                
                    STA.W $0D84               
                    RTS                       ; Return 


DATA_00F69F:        .db $64,$00,$7C,$00

DATA_00F6A3:        .db $00,$00,$FF,$FF

DATA_00F6A7:        .db $FD,$FF,$05,$00,$FA,$FF

DATA_00F6AD:        .db $00,$00,$00,$00,$C0,$00

DATA_00F6B3:        .db $90,$00,$60,$00,$00,$00,$00,$00
                    .db $00,$00,$00,$00

DATA_00F6BF:        .db $00,$00,$FE,$FF,$02,$00,$00,$00
                    .db $FE,$FF,$02,$00

DATA_00F6CB:        .db $00,$00,$20,$00

DATA_00F6CF:        .db $D0,$00,$00,$00,$20,$00,$D0,$00
                    .db $01,$00,$FF,$FF

ADDR_00F6DB:        PHB                       
                    PHK                       
                    PLB                       
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W $142A               
                    SEC                       
                    SBC.W #$000C              
                    STA.W $142C               
                    CLC                       
                    ADC.W #$0018              
                    STA.W $142E               
                    LDA.W $1462               
                    STA $1A                   
                    LDA.W $1464               
                    STA $1C                   
                    LDA.W $1466               
                    STA $1E                   
                    LDA.W $1468               
                    STA $20                   
                    LDA $5B                   
                    LSR                       
                    BCC ADDR_00F70D           
                    JMP.W ADDR_00F75C         
ADDR_00F70D:        LDA.W #$00C0              
                    JSR.W ADDR_00F7F4         
                    LDY.W $1411               
                    BEQ ADDR_00F75A           
                    LDY.B #$02                
                    LDA $94                   
                    SEC                       
                    SBC $1A                   
                    STA $00                   
                    CMP.W $142A               
                    BPL ADDR_00F728           
                    LDY.B #$00                
ADDR_00F728:        STY $55                   
                    STY $56                   
                    SEC                       
                    SBC.W $142C,Y             
                    BEQ ADDR_00F75A           
                    STA $02                   
                    EOR.W DATA_00F6A3,Y       
                    BPL ADDR_00F75A           
                    JSR.W ADDR_00F8AB         
                    LDA $02                   
                    CLC                       
                    ADC $1A                   
                    BPL ADDR_00F746           
                    LDA.W #$0000              
ADDR_00F746:        STA $1A                   
                    LDA $5E                   
                    DEC A                     
                    XBA                       
                    AND.W #$FF00              
                    BPL ADDR_00F754           
                    LDA.W #$0080              
ADDR_00F754:        CMP $1A                   
                    BPL ADDR_00F75A           
                    STA $1A                   
ADDR_00F75A:        BRA ADDR_00F79D           
ADDR_00F75C:        LDA $5F                   
                    DEC A                     
                    XBA                       
                    AND.W #$FF00              
                    JSR.W ADDR_00F7F4         
                    LDY.W $1411               
                    BEQ ADDR_00F79D           
                    LDY.B #$00                
                    LDA $94                   
                    SEC                       
                    SBC $1A                   
                    STA $00                   
                    CMP.W $142A               
                    BMI ADDR_00F77B           
                    LDY.B #$02                
ADDR_00F77B:        SEC                       
                    SBC.W $142C,Y             
                    STA $02                   
                    EOR.W DATA_00F6A3,Y       
                    BPL ADDR_00F79D           
                    JSR.W ADDR_00F8AB         
                    LDA $02                   
                    CLC                       
                    ADC $1A                   
                    BPL ADDR_00F793           
                    LDA.W #$0000              
ADDR_00F793:        CMP.W #$0101              
                    BMI ADDR_00F79B           
                    LDA.W #$0100              
ADDR_00F79B:        STA $1A                   
ADDR_00F79D:        LDY.W $1413               
                    BEQ ADDR_00F7AA           
                    LDA $1A                   
                    DEY                       
                    BEQ ADDR_00F7A8           
                    LSR                       
ADDR_00F7A8:        STA $1E                   
ADDR_00F7AA:        LDY.W $1414               
                    BEQ ADDR_00F7C2           
                    LDA $1C                   
                    DEY                       
                    BEQ ADDR_00F7BC           
                    LSR                       
                    DEY                       
                    BEQ ADDR_00F7BC           
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
ADDR_00F7BC:        CLC                       
                    ADC.W $1417               
                    STA $20                   
ADDR_00F7C2:        SEP #$20                  ; Accum (8 bit) 
                    LDA $1A                   
                    SEC                       
                    SBC.W $1462               
                    STA.W $17BD               
                    LDA $1C                   
                    SEC                       
                    SBC.W $1464               
                    STA.W $17BC               
                    LDA $1E                   
                    SEC                       
                    SBC.W $1466               
                    STA.W $17BF               
                    LDA $20                   
                    SEC                       
                    SBC.W $1468               
                    STA.W $17BE               
                    LDX.B #$07                
ADDR_00F7EA:        LDA $1A,X                 
                    STA.W $1462,X             
                    DEX                       
                    BPL ADDR_00F7EA           
                    PLB                       
                    RTL                       ; Return 

ADDR_00F7F4:        LDX.W $1412               
                    BNE ADDR_00F7FA           
                    RTS                       ; Return 

ADDR_00F7FA:        STA $04                   ; Accum (16 bit) 
                    LDY.B #$00                
                    LDA $96                   
                    SEC                       
                    SBC $1C                   
                    STA $00                   
                    CMP.W #$0070              
                    BMI ADDR_00F80C           
                    LDY.B #$02                
ADDR_00F80C:        STY $55                   
                    STY $56                   
                    SEC                       
                    SBC.W DATA_00F69F,Y       
                    STA $02                   
                    EOR.W DATA_00F6A3,Y       
                    BMI ADDR_00F81F           
                    LDY.B #$02                
                    STZ $02                   
ADDR_00F81F:        LDA $02                   
                    BMI ADDR_00F82A           
                    LDX.B #$00                
                    STX.W $1404               
                    BRA ADDR_00F883           
ADDR_00F82A:        SEP #$20                  ; Accum (8 bit) 
                    LDA.W $13E3               
                    CMP.B #$06                
                    BCS ADDR_00F845           
                    LDA.W $1410               
                    LSR                       
                    ORA.W $149F               
                    ORA $74                   
                    ORA.W $13F3               
                    ORA.W $18C2               
                    ORA.W $1406               
ADDR_00F845:        TAX                       
                    REP #$20                  ; Accum (16 bit) 
                    BNE ADDR_00F869           
                    LDX.W $187A               
                    BEQ ADDR_00F856           
                    LDX.W $141E               
                    CPX.B #$02                
                    BCS ADDR_00F869           
ADDR_00F856:        LDX $75                   
                    BEQ ADDR_00F85E           
                    LDX $72                   
                    BNE ADDR_00F869           
ADDR_00F85E:        LDX.W $1412               
                    DEX                       
                    BEQ ADDR_00F875           
                    LDX.W $13F1               
                    BNE ADDR_00F875           
ADDR_00F869:        STX.W $13F1               
                    LDX.W $13F1               
                    BNE ADDR_00F881           
                    LDY.B #$04                
                    BRA ADDR_00F881           
ADDR_00F875:        LDX.W $1404               
                    BNE ADDR_00F881           
                    LDX $72                   
                    BNE ADDR_00F8AA           
                    INC.W $1404               
ADDR_00F881:        LDA $02                   
ADDR_00F883:        SEC                       
                    SBC.W DATA_00F6A7,Y       
                    EOR.W DATA_00F6A7,Y       
                    ASL                       
                    LDA $02                   
                    BCS ADDR_00F892           
                    LDA.W DATA_00F6A7,Y       
ADDR_00F892:        CLC                       
                    ADC $1C                   
                    CMP.W DATA_00F6AD,Y       
                    BPL ADDR_00F89D           
                    LDA.W DATA_00F6AD,Y       
ADDR_00F89D:        STA $1C                   
                    LDA $04                   
                    CMP $1C                   
                    BPL ADDR_00F8AA           
                    STA $1C                   
                    STZ.W $13F1               
ADDR_00F8AA:        RTS                       ; Return 

ADDR_00F8AB:        LDY.W $13FD               
                    BNE ADDR_00F8DE           
                    SEP #$20                  ; Accum (8 bit) 
                    LDX.W $13FF               
                    REP #$20                  ; Accum (16 bit) 
                    LDY.B #$08                
                    LDA.W $142A               
                    CMP.W DATA_00F6B3,X       
                    BPL ADDR_00F8C3           
                    LDY.B #$0A                
ADDR_00F8C3:        LDA.W DATA_00F6BF,Y       
                    EOR $02                   
                    BPL ADDR_00F8DE           
                    LDA.W DATA_00F6BF,X       
                    EOR $02                   
                    BPL ADDR_00F8DE           
                    LDA $02                   
                    CLC                       
                    ADC.W DATA_00F6CF,Y       
                    BEQ ADDR_00F8DE           
                    STA $02                   
                    STY.W $1400               
ADDR_00F8DE:        RTS                       ; Return 


DATA_00F8DF:        .db $0C,$0C,$08,$00,$20,$04,$0A,$0D
                    .db $0D

DATA_00F8E8:        .db $2A,$00,$2A,$00,$12,$00,$00,$00
                    .db $ED,$FF

ADDR_00F8F2:        JSR.W ADDR_00EAA6         
                    BIT.W $0D9B               
                    BVC ADDR_00F94E           
                    JSR.W ADDR_00E92B         
                    LDA.W $13FC               
                    ASL                       
                    TAX                       
                    PHX                       
                    LDY $7D                   
                    BPL ADDR_00F91E           
                    REP #$20                  ; Accum (16 bit) 
                    LDA $96                   
                    CMP.W DATA_00F8E8,X       
                    BPL ADDR_00F91E           
                    LDA.W DATA_00F8E8,X       
                    STA $96                   
                    SEP #$20                  ; Accum (8 bit) 
                    STZ $7D                   
                    LDA.B #$01                
                    STA.W $1DF9               ; / Play sound effect 
ADDR_00F91E:        SEP #$20                  ; Accum (8 bit) 
                    PLX                       
                    LDA.W DATA_00F8E8,X       
                    CMP.B #$2A                
                    BNE ADDR_00F94D           
                    REP #$20                  ; Accum (16 bit) 
                    LDY.B #$00                
                    LDA.W $1617               
                    AND.W #$00FF              
                    INC A                     
                    CMP $94                   
                    BEQ ADDR_00F94A           
                    BMI ADDR_00F94A           
                    LDA.W $153D               
                    AND.W #$00FF              
                    STA $00                   
                    INY                       
                    LDA $94                   
                    CLC                       
                    ADC.W #$000F              
                    CMP $00                   
ADDR_00F94A:        JMP.W ADDR_00E9C8         
ADDR_00F94D:        RTS                       ; Return 

ADDR_00F94E:        LDY.B #$00                
                    LDA $7D                   
                    BPL ADDR_00F957           
                    JMP.W ADDR_00F997         
ADDR_00F957:        JSR.W ADDR_00F9A8         
                    BCS ADDR_00F962           
                    JSR.W ADDR_00EE1D         
                    JMP.W ADDR_00F997         
ADDR_00F962:        LDA $72                   
                    BEQ ADDR_00F983           
                    REP #$20                  ; Accum (16 bit) 
                    LDA.W $14B8               
                    AND.W #$00FF              
                    STA.W $14B4               
                    STA.W $1436               
                    LDA.W $14BA               
                    AND.W #$00F0              
                    STA.W $14B6               
                    STA.W $1438               
                    JSR.W ADDR_00F9C9         
ADDR_00F983:        LDA $36                   ; Accum (8 bit) 
                    CLC                       
                    ADC.B #$48                
                    LSR                       
                    LSR                       
                    LSR                       
                    LSR                       
                    TAX                       
                    LDY.W DATA_00F8DF,X       
                    LDA.B #$80                
                    STA $8E                   
                    JSR.W ADDR_00EEE1         
ADDR_00F997:        REP #$20                  ; Accum (16 bit) 
                    LDA $80                   
                    CMP.W #$00AE              
                    SEP #$20                  ; Accum (8 bit) 
                    BMI ADDR_00F9A5           
                    JSR.W ADDR_00F629         
ADDR_00F9A5:        JMP.W ADDR_00E98C         
ADDR_00F9A8:        REP #$20                  ; Accum (16 bit) 
                    LDA $94                   
                    CLC                       
                    ADC.W #$0008              
                    STA.W $14B4               
                    LDA $96                   
                    CLC                       
                    ADC.W #$0020              
                    STA.W $14B6               
ADDR_00F9BC:        SEP #$20                  ; Accum (8 bit) 
                    PHB                       
                    LDA.B #$01                
                    PHA                       
                    PLB                       
                    JSL.L ADDR_01CC9D         
                    PLB                       
                    RTS                       ; Return 

ADDR_00F9C9:        LDA $36                   ; Accum (16 bit) 
                    PHA                       
                    EOR.W #$FFFF              
                    INC A                     
                    STA $36                   
                    JSR.W ADDR_00F9BC         
                    REP #$20                  ; Accum (16 bit) 
                    PLA                       
                    STA $36                   
                    LDA.W $14B8               
                    AND.W #$00FF              
                    SEC                       
                    SBC.W #$0008              
                    STA $94                   
                    LDA.W $14BA               
                    AND.W #$00FF              
                    SEC                       
                    SBC.W #$0020              
                    STA $96                   
                    SEP #$20                  ; Accum (8 bit) 
                    RTS                       ; Return 


DATA_00F9F5:        .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$A2,$0B

ADDR_00FA12:        STZ.W $14C8,X             
                    DEX                       
                    BPL ADDR_00FA12           
                    RTL                       ; Return 

ADDR_00FA19:        LDY.B #$32                
                    STY $05                   
                    LDY.B #$E6                
                    STY $06                   
                    LDY.B #$00                
                    STY $07                   
                    SEC                       
                    SBC.B #$6E                
                    TAY                       
                    LDA [$82],Y               
                    STA $08                   
                    ASL                       
                    ASL                       
                    ASL                       
                    ASL                       
                    STA $01                   
                    BCC ADDR_00FA37           
                    INC $06                   
ADDR_00FA37:        LDA $0C                   
                    AND.B #$0F                
                    STA $00                   
                    LDA $0A                   
                    AND.B #$0F                
                    ORA $01                   
                    TAY                       
                    RTL                       ; Return 

FlatPalaceSwitch:   LDA.B #$20                ; \ Set "Time to shake ground" to x20 
                    STA.W $1887               ; /  
                    LDY.B #$02                ; \  
                    LDA.B #$60                ;  |Set sprite x02 to x60 (Flat palace switch) 
                    STA.W $009E,Y             ; /  
                    LDA.B #$08                ; \ Set sprite's status to x08 
                    STA.W $14C8,Y             ; /  
                    LDA $9A                   ; \  
                    AND.B #$F0                ;  |Set sprite X (low) to $9A & 0xF0 
                    STA.W $00E4,Y             ; /  
                    LDA $9B                   ; \ Set sprite X (high) to $9B 
                    STA.W $14E0,Y             ; /  
                    LDA $98                   ; \  
                    AND.B #$F0                ;  | 
                    CLC                       ;  |Set sprite Y (low) to ($98 & 0xF0) + 0x10 
                    ADC.B #$10                ;  | 
                    STA.W $00D8,Y             ; /  
                    LDA $99                   ; \  
                    ADC.B #$00                ;  |Set sprite Y (high) to $99 + carry 
                    STA.W $14D4,Y             ; / (Carry carried over from previous addition) 
                    PHX                       
                    TYX                       
                    JSL.L ADDR_07F7D2         
                    PLX                       
                    LDA.B #$5F                ; \ Set sprite's "Spin Jump Death Frame Counter" to x5F 
                    STA.W $1540,Y             ; /  
                    RTS                       ; Return 

ADDR_00FA80:        STZ.W $13F3               
                    STZ.W $1891               
                    STZ.W $18C0               
                    STZ.W $18B9               
                    STZ.W $18DD               
                    LDY.B #$0B                
ADDR_00FA91:        LDA.W $14C8,Y             
                    CMP.B #$08                
                    BCC ADDR_00FAD1           
                    CMP.B #$0B                
                    BNE ADDR_00FAA3           
                    PHX                       
                    JSR.W ADDR_00FB00         
                    PLX                       
                    BRA ADDR_00FAD1           
ADDR_00FAA3:        LDA.W $009E,Y             
                    CMP.B #$7B                
                    BEQ ADDR_00FAB2           
                    LDA.W $15A0,Y             
                    ORA.W $186C,Y             
                    BNE ADDR_00FAC5           
ADDR_00FAB2:        LDA.W $1686,Y             
                    AND.B #$20                
                    BNE ADDR_00FAC5           
                    LDA.B #$10                
                    STA.W $1540,Y             
                    LDA.B #$06                
                    STA.W $14C8,Y             
                    BRA ADDR_00FAD1           
ADDR_00FAC5:        LDA.W $190F,Y             
                    AND.B #$02                
                    BNE ADDR_00FAD1           
                    LDA.B #$00                
                    STA.W $14C8,Y             
ADDR_00FAD1:        DEY                       
                    BPL ADDR_00FA91           
                    LDY.B #$07                
                    LDA.B #$00                
ADDR_00FAD8:        STA.W $170B,Y             
                    DEY                       
                    BPL ADDR_00FAD8           
                    RTL                       ; Return 


DATA_00FADF:        .db $74,$74,$77,$75,$76,$E0,$F0,$74
                    .db $74,$77,$75,$76,$E0,$F1,$F0,$F0
                    .db $F0,$F0,$F1,$E0,$F2,$E0,$E0,$E0
                    .db $E0,$F1,$E0,$E4

DATA_00FAFB:        .db $FF,$74,$75,$76,$77

ADDR_00FB00:        LDX $19                   
                    LDA.W $1490               
                    BEQ ADDR_00FB09           
                    LDX.B #$04                
ADDR_00FB09:        LDA.W $187A               
                    BEQ ADDR_00FB10           
                    LDX.B #$05                
ADDR_00FB10:        LDA.W $009E,Y             
                    CMP.B #$2F                
                    BEQ ADDR_00FB2D           
                    CMP.B #$3E                
                    BEQ ADDR_00FB2D           
                    CMP.B #$80                
                    BEQ ADDR_00FB28           
                    CMP.B #$2D                
                    BNE ADDR_00FB32           
                    TXA                       
                    CLC                       
                    ADC.B #$07                
                    TAX                       
ADDR_00FB28:        TXA                       
                    CLC                       
                    ADC.B #$07                
                    TAX                       
ADDR_00FB2D:        TXA                       
                    CLC                       
                    ADC.B #$07                
                    TAX                       
ADDR_00FB32:        LDA.L DATA_00FADF,X       
                    LDX.W $0DC2               
                    CMP.L DATA_00FAFB,X       
                    BNE ADDR_00FB41           
                    LDA.B #$78                
ADDR_00FB41:        STZ $0F                   
                    CMP.B #$E0                
                    BCC ADDR_00FB55           
                    PHA                       
                    AND.B #$0F                
                    STA $0F                   
                    PLA                       
                    CMP.B #$F0                
                    LDA.B #$78                
                    BCS ADDR_00FB55           
                    LDA.B #$78                
ADDR_00FB55:        STA.W $009E,Y             
                    CMP.B #$76                
                    BNE ADDR_00FB5F           
                    INC.W $13CB               
ADDR_00FB5F:        TYX                       
                    JSL.L ADDR_07F7D2         
                    LDA $0F                   
                    STA.W $1594,Y             
                    LDA.B #$0C                
                    STA.W $14C8,Y             
                    LDA.B #$D0                
                    STA.W $00AA,Y             
                    LDA.B #$05                
                    STA.W $00B6,Y             
                    LDA.B #$20                
                    STA.W $154C,Y             
                    LDA.B #$0C                
                    STA.W $1DF9               ; / Play sound effect 
                    LDX.B #$03                
ADDR_00FB84:        LDA.W $17C0,X             
                    BEQ ADDR_00FB8D           
                    DEX                       
                    BPL ADDR_00FB84           
                    RTS                       ; Return 

ADDR_00FB8D:        LDA.B #$01                
                    STA.W $17C0,X             
                    LDA.W $00D8,Y             
                    STA.W $17C4,X             
                    LDA.W $00E4,Y             
                    STA.W $17C8,X             
                    LDA.B #$1B                
                    STA.W $17CC,X             
                    RTS                       ; Return 


DATA_00FBA4:        .db $66,$64,$62,$60,$E8,$EA,$EC,$EA

ADDR_00FBAC:        PHB                       
                    PHK                       
                    PLB                       
                    JSR.W ADDR_00FBB4         
                    PLB                       
                    RTL                       ; Return 

ADDR_00FBB4:        LDY.B #$00                
                    LDA.W $17BD               
                    BPL ADDR_00FBBC           
                    DEY                       
ADDR_00FBBC:        CLC                       
                    ADC $E4,X                 
                    STA $E4,X                 
                    TYA                       
                    ADC.W $14E0,X             
                    STA.W $14E0,X             
                    LDA.W $1540,X             
                    BEQ ADDR_00FBF0           
                    CMP.B #$01                
                    BNE ADDR_00FBD5           
                    LDA.B #$D0                
                    STA $AA,X                 
ADDR_00FBD5:        PHX                       
                    LDA.B #$04                
                    STA.W $15F6,X             
                    JSL.L GenericSprGfxRt     
                    LDA.W $1540,X             
                    LSR                       
                    LSR                       
                    LDY.W $15EA,X             
                    TAX                       
                    LDA.W DATA_00FBA4,X       
                    STA.W $0302,Y             
                    PLX                       
                    RTS                       ; Return 

ADDR_00FBF0:        INC.W $1570,X             
                    JSL.L ADDR_01801A         
                    INC $AA,X                 
                    INC $AA,X                 
                    LDA $AA,X                 
                    CMP.B #$20                
                    BMI ADDR_00FC1E           
                    JSL.L ADDR_05B34A         
                    LDA.W $18DD               
                    CMP.B #$0D                
                    BCC ADDR_00FC0E           
                    LDA.B #$0D                
ADDR_00FC0E:        JSL.L GivePoints          
                    LDA.W $18DD               
                    CLC                       
                    ADC.B #$02                
                    STA.W $18DD               
                    STZ.W $14C8,X             
ADDR_00FC1E:        JSL.L ADDR_01C641         
                    RTS                       ; Return 

                    LDY.B #$0B                
ADDR_00FC25:        LDA.W $14C8,Y             
                    CMP.B #$08                
                    BNE ADDR_00FC73           
                    LDA.W $009E,Y             
                    CMP.B #$35                
                    BNE ADDR_00FC73           
                    LDA.B #$01                
                    STA.W $0DC1               
                    STZ.W $141E               
                    LDA.W $15F6,Y             
                    AND.B #$F1                
                    ORA.B #$0A                
                    STA.W $15F6,Y             
                    LDA.W $187A               
                    BNE ADDR_00FC72           
                    LDA $1A                   
                    SEC                       
                    SBC.B #$10                
                    STA.W $00E4,Y             
                    LDA $1B                   
                    SBC.B #$00                
                    STA.W $14E0,Y             
                    LDA $96                   
                    STA.W $00D8,Y             
                    LDA $97                   
                    STA.W $14D4,Y             
                    LDA.B #$03                
                    STA.W $00C2,Y             
                    LDA.B #$00                
                    STA.W $157C,Y             
                    LDA.B #$10                
                    STA.W $00B6,Y             
ADDR_00FC72:        RTL                       ; Return 

ADDR_00FC73:        DEY                       
                    BPL ADDR_00FC25           
                    STZ.W $0DC1               
                    RTL                       ; Return 

ADDR_00FC7A:        LDA.B #$02                
                    STA.W $1DFA               ; / Play sound effect 
                    LDX.B #$00                
                    LDA.W $1B94               
                    BNE ADDR_00FC98           
                    LDX.B #$05                
                    LDA.W $1692               
                    CMP.B #$0A                
                    BEQ ADDR_00FC98           
                    JSL.L ADDR_02A9E4         
                    TYX                       
                    BPL ADDR_00FC98           
                    LDX.B #$03                
ADDR_00FC98:        LDA.B #$08                
                    STA.W $14C8,X             
                    LDA.B #$35                
                    STA $9E,X                 
                    LDA $94                   
                    STA $E4,X                 
                    LDA $95                   
                    STA.W $14E0,X             
                    LDA $96                   
                    SEC                       
                    SBC.B #$10                
                    STA $96                   
                    STA $D8,X                 
                    LDA $97                   
                    SBC.B #$00                
                    STA $97                   
                    STA.W $14D4,X             
                    JSL.L ADDR_07F7D2         
                    LDA.B #$04                
                    STA.W $1FE2,X             
                    LDA.W $13C7               
                    STA.W $15F6,X             
                    LDA.W $1B95               
                    BEQ ADDR_00FCD5           
                    LDA.B #$06                
                    STA.W $15F6,X             
ADDR_00FCD5:        INC.W $187A               
                    INC $C2,X                 
                    LDA $76                   
                    EOR.B #$01                
                    STA.W $157C,X             
                    DEC.W $160E,X             
                    INX                       
                    STX.W $18DF               
                    STX.W $18E2               
                    RTL                       ; Return 

ADDR_00FCEC:        LDX.B #$0B                
ADDR_00FCEE:        STZ.W $14C8,X             
                    DEX                       
                    BPL ADDR_00FCEE           
                    RTS                       ; Return 

ADDR_00FCF5:        LDA.B #$A0                
                    STA $E4,X                 
                    LDA.B #$00                
                    STA.W $14E0,X             
                    LDA.B #$00                
                    STA $D8,X                 
                    LDA.B #$00                
                    STA.W $14D4,X             
                    RTL                       ; Return 

ADDR_00FD08:        LDY.B #$3F                
                    LDA $15                   
                    AND.B #$83                
                    BNE ADDR_00FD12           
                    LDY.B #$7F                
ADDR_00FD12:        TYA                       
                    AND $14                   
                    ORA $9D                   
                    BNE ADDR_00FD23           
                    LDX.B #$07                
ADDR_00FD1B:        LDA.W $170B,X             
                    BEQ ADDR_00FD26           
                    DEX                       
                    BPL ADDR_00FD1B           
ADDR_00FD23:        RTS                       ; Return 


DATA_00FD24:        .db $02,$0A

ADDR_00FD26:        LDA.B #$12                
                    STA.W $170B,X             
                    LDY $76                   
                    LDA $94                   
                    CLC                       
                    ADC.W DATA_00FD24,Y       
                    STA.W $171F,X             
                    LDA $95                   
                    ADC.B #$00                
                    STA.W $1733,X             
                    LDA $19                   
                    BEQ ADDR_00FD47           
                    LDA.B #$04                
                    LDY $73                   
                    BEQ ADDR_00FD49           
ADDR_00FD47:        LDA.B #$0C                
ADDR_00FD49:        CLC                       
                    ADC $96                   
                    STA.W $1715,X             
                    LDA $97                   
                    ADC.B #$00                
                    STA.W $1729,X             
                    STZ.W $176F,X             
                    RTS                       ; Return 

ADDR_00FD5A:        LDA $7F                   
                    ORA $81                   
                    BNE ADDR_00FD6A           
                    LDY.B #$03                
ADDR_00FD62:        LDA.W $17C0,Y             
                    BEQ ADDR_00FD6B           
                    DEY                       
                    BPL ADDR_00FD62           
ADDR_00FD6A:        RTS                       ; Return 

ADDR_00FD6B:        LDA.B #$05                
                    STA.W $17C0,Y             
                    LDA $9A                   
                    AND.B #$F0                
                    STA.W $17C8,Y             
                    LDA $98                   
                    AND.B #$F0                
                    STA.W $17C4,Y             
                    LDA.W $1933               
                    BEQ ADDR_00FD97           
                    LDA $9A                   
                    SEC                       
                    SBC $26                   
                    AND.B #$F0                
                    STA.W $17C8,Y             
                    LDA $98                   
                    SEC                       
                    SBC $28                   
                    AND.B #$F0                
                    STA.W $17C4,Y             
ADDR_00FD97:        LDA.B #$10                
                    STA.W $17CC,Y             
                    RTS                       ; Return 


DATA_00FD9D:        .db $08,$FC,$10,$04

DATA_00FDA1:        .db $00,$FF,$00,$00

ADDR_00FDA5:        LDA $72                   
                    BEQ ADDR_00FDB3           
                    LDY.B #$0B                
ADDR_00FDAB:        LDA.W $17F0,Y             
                    BEQ ADDR_00FDB4           
                    DEY                       
                    BPL ADDR_00FDAB           
ADDR_00FDB3:        INY                       
ADDR_00FDB4:        PHX                       
                    LDX.B #$00                
                    LDA $19                   
                    BEQ ADDR_00FDBC           
                    INX                       
ADDR_00FDBC:        LDA.W $187A               
                    BEQ ADDR_00FDC3           
                    INX                       
                    INX                       
ADDR_00FDC3:        LDA $96                   
                    CLC                       
                    ADC.W DATA_00FD9D,X       
                    PHP                       
                    AND.B #$F0                
                    CLC                       
                    ADC.B #$03                
                    STA.W $17FC,Y             
                    LDA $97                   
                    ADC.B #$00                
                    PLP                       
                    ADC.W DATA_00FDA1,X       
                    STA.W $1814,Y             
                    PLX                       
                    LDA $94                   
                    STA.W $1808,Y             
                    LDA $95                   
                    STA.W $18EA,Y             
                    LDA.B #$07                
                    STA.W $17F0,Y             
                    LDA.B #$00                
                    STA.W $1850,Y             
                    LDA $7D                   
                    BMI ADDR_00FE0D           
                    STZ $7D                   
                    LDY $72                   
                    BEQ ADDR_00FDFE           
                    STZ $7B                   
ADDR_00FDFE:        LDY.B #$03                
                    LDA $19                   
                    BNE ADDR_00FE05           
                    DEY                       
ADDR_00FE05:        LDA.W $170B,Y             
                    BEQ ADDR_00FE16           
ADDR_00FE0A:        DEY                       
                    BPL ADDR_00FE05           
ADDR_00FE0D:        RTS                       ; Return 


DATA_00FE0E:        .db $10,$16,$13,$1C

DATA_00FE12:        .db $00,$04,$0A,$07

ADDR_00FE16:        LDA.B #$12                
                    STA.W $170B,Y             
                    TYA                       
                    ASL                       
                    ASL                       
                    ASL                       
                    ADC.B #$F7                
                    STA.W $1765,Y             
                    LDA $96                   
                    ADC.W DATA_00FE0E,Y       
                    STA.W $1715,Y             
                    LDA $97                   
                    ADC.B #$00                
                    STA.W $1729,Y             
                    LDA $94                   
                    ADC.W DATA_00FE12,Y       
                    STA.W $171F,Y             
                    LDA $95                   
                    ADC.B #$00                
                    STA.W $1733,Y             
                    LDA.B #$00                
                    STA.W $176F,Y             
                    JMP.W ADDR_00FE0A         
ADDR_00FE4A:        LDA $13                   
                    AND.B #$03                
                    ORA $72                   
                    ORA $7F                   
                    ORA $81                   
                    ORA $9D                   
                    BNE ADDR_00FE71           
                    LDA $15                   
                    AND.B #$04                
                    BEQ ADDR_00FE67           
                    LDA $7B                   
                    CLC                       
                    ADC.B #$08                
                    CMP.B #$10                
                    BCC ADDR_00FE71           
ADDR_00FE67:        LDY.B #$03                
ADDR_00FE69:        LDA.W $17C0,Y             
                    BEQ ADDR_00FE72           
                    DEY                       
                    BNE ADDR_00FE69           
ADDR_00FE71:        RTS                       ; Return 

ADDR_00FE72:        LDA.B #$03                
                    STA.W $17C0,Y             
                    LDA $94                   
                    ADC.B #$04                
                    STA.W $17C8,Y             
                    LDA $96                   
                    ADC.B #$1A                
                    PHX                       
                    LDX.W $187A               
                    BEQ ADDR_00FE8A           
                    ADC.B #$10                
ADDR_00FE8A:        STA.W $17C4,Y             
                    PLX                       
                    LDA.B #$13                
                    STA.W $17CC,Y             
                    RTS                       ; Return 


DATA_00FE94:        .db $FD,$03

DATA_00FE96:        .db $00,$08,$F8,$10,$F8,$10

DATA_00FE9C:        .db $00,$00,$FF,$00,$FF,$00

DATA_00FEA2:        .db $08,$08,$0C,$0C,$14,$14

ADDR_00FEA8:        LDX.B #$09                
ADDR_00FEAA:        LDA.W $170B,X             
                    BEQ ADDR_00FEB5           
                    DEX                       
                    CPX.B #$07                
                    BNE ADDR_00FEAA           
                    RTS                       ; Return 

ADDR_00FEB5:        LDA.B #$06                
                    STA.W $1DFC               ; / Play sound effect 
                    LDA.B #$0A                
                    STA.W $149C               
                    LDA.B #$05                
                    STA.W $170B,X             
                    LDA.B #$30                
                    STA.W $173D,X             
                    LDY $76                   
                    LDA.W DATA_00FE94,Y       
                    STA.W $1747,X             
                    LDA.W $187A               
                    BEQ ADDR_00FEDF           
                    INY                       
                    INY                       
                    LDA.W $18DC               
                    BEQ ADDR_00FEDF           
                    INY                       
                    INY                       
ADDR_00FEDF:        LDA $94                   
                    CLC                       
                    ADC.W DATA_00FE96,Y       
                    STA.W $171F,X             
                    LDA $95                   
                    ADC.W DATA_00FE9C,Y       
                    STA.W $1733,X             
                    LDA $96                   
                    CLC                       
                    ADC.W DATA_00FEA2,Y       
                    STA.W $1715,X             
                    LDA $97                   
                    ADC.B #$00                
                    STA.W $1729,X             
                    LDA.W $13F9               
                    STA.W $1779,X             
                    RTS                       ; Return 

ADDR_00FF07:        REP #$20                  ; Accum (16 bit) 
                    LDA.W $17BC               
                    AND.W #$FF00              
                    BPL ADDR_00FF14           
                    ORA.W #$00FF              
ADDR_00FF14:        XBA                       
                    CLC                       
                    ADC $94                   
                    STA $94                   
                    LDA.W $17BB               
                    AND.W #$FF00              
                    BPL ADDR_00FF25           
                    ORA.W #$00FF              
ADDR_00FF25:        XBA                       
                    EOR.W #$FFFF              
                    INC A                     
                    CLC                       
                    ADC $96                   
                    STA $96                   
                    SEP #$20                  ; Accum (8 bit) 
                    RTL                       ; Return 

ADDR_00FF32:        LDA.W $14E0,X             
                    XBA                       
                    LDA $E4,X                 
                    REP #$20                  ; Accum (16 bit) 
                    SEC                       
                    SBC $1A                   
                    STA $00                   
                    LDA.W #$0030              
                    SEC                       
                    SBC $00                   
                    STA $22                   
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.W $14D4,X             
                    XBA                       
                    LDA $D8,X                 
                    REP #$20                  ; Accum (16 bit) 
                    SEC                       
                    SBC $1C                   
                    STA $00                   
                    LDA.W #$0100              
                    SEC                       
                    SBC $00                   
                    STA $24                   
                    SEP #$20                  ; Accum (8 bit) 
                    RTL                       ; Return 

ADDR_00FF61:        LDA.W $14E0,X             
                    XBA                       
                    LDA $E4,X                 
                    REP #$20                  ; Accum (16 bit) 
                    CMP.W #$FF00              
                    BMI ADDR_00FF73           
                    CMP.W #$0100              
                    BMI ADDR_00FF76           
ADDR_00FF73:        LDA.W #$0100              
ADDR_00FF76:        STA $22                   
                    SEP #$20                  ; Accum (8 bit) 
                    LDA.W $14D4,X             
                    XBA                       
                    LDA $D8,X                 
                    REP #$20                  ; Accum (16 bit) 
                    STA $00                   
                    LDA.W #$00A0              
                    SEC                       
                    SBC $00                   
                    CLC                       
                    ADC.W $1888               
                    STA $24                   
                    SEP #$20                  ; Accum (8 bit) 
                    RTL                       ; Return 


DATA_00FF93:        .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                    .db $FF,$FF,$FF,$FF,$FF,$53,$55,$50
                    .db $45,$52,$20,$4D,$41,$52,$49,$4F
                    .db $57,$4F,$52,$4C,$44,$20,$20,$20
                    .db $20,$20,$20,$02,$09,$01,$01,$01
                    .db $00,$25,$5F,$DA,$A0,$FF,$FF,$FF
                    .db $FF,$C3,$82,$FF,$FF,$C3,$82,$6A
                    .db $81,$00,$80,$74,$83,$FF,$FF,$FF
                    .db $FF,$C3,$82,$C3,$82,$C3,$82,$C3
                    .db $82,$00,$80,$C3,$82
