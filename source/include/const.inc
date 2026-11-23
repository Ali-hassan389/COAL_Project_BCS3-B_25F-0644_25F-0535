; --- COLOR PALETTE INDEXES ---
Color_Trans       equ 0           
Color_Black       equ 0
Color_Blue        equ 1           
Color_Green       equ 2           
Color_Red         equ 4           
Color_Dirt        equ 06h         
Color_Grey        equ 8           
Color_Grass       equ 0Ah         
Color_GrassDark   equ 02h         
Color_Sky         equ 47         
Color_LightRed    equ 12          
Color_Yellow      equ 0Eh         
Color_White       equ 15          
Color_Skin        equ 40          
Color_DarkDirt    equ 41          

; --- COIN PALETTE CONSTANTS ---
Color_CoinOrange  equ 42          
Color_CoinGold    equ 43          
Color_CoinCream   equ 44          

; --- TITLE SCREEN PALETTE CONSTANTS ---
Color_Brick       equ 45          
Color_Mortar      equ 46          
Color_TSky        equ 47          
Color_TGrass      equ 48          
Color_TDirt       equ 49          

Color_GoombaBrown equ 50
Color_GoombaSkin  equ 51
Color_GoombaBlack equ 52

Color_ShroomRed   equ 53          
Color_ShroomStem  equ 54          
Color_BlockDark   equ 55          
Color_BlockOrange equ 56          
Color_UsedBrown   equ 57          
Color_BrickHighlight equ 58 
Color_PipeDark   equ 59
Color_PipeMid    equ 60
Color_PipeLight  equ 61
Color_PipeShadow equ 62       
Color_KoopaYellow equ 63

; --- DISPLAY & SPRITE DIMENSIONS ---
ScreenWidth       equ 320
ScreenHeight      equ 200
VGASegment        equ 0A000h
TileSize          equ 16

; =========================================================
; EXACT LEVEL 1-1 LAYOUT COORDINATES
; =========================================================
Block1X           equ 80          
Block1Y           equ 98

; The Connected Row
Brick1X           equ 144        
Brick1Y           equ 98
Block2X           equ 160       
Block2Y           equ 98
Brick2X           equ 176         
Brick2Y           equ 98
Block3X           equ 192         
Block3Y           equ 98
Brick3X           equ 208        
Brick3Y           equ 98

; Upper Floating Lucky Block
Block4X           equ 160         
Block4Y           equ 48          

; =========================================================
; EXACT LEVEL 1-2 LAYOUT COORDINATES 
; =========================================================
Pipe1X           equ 360
Pipe1Y           equ 114    

Pipe2X           equ 460
Pipe2Y           equ 98     
Pipe2Height      equ 48
PipeSize         equ 32     

IslandBrick1X    equ 390
IslandBlock1X    equ 406
IslandBrick2X    equ 422
IslandFloatY     equ 50     

Pit1X            equ 256    
Pit1Width        equ 48
Pit1End          equ Pit1X + Pit1Width
Pit2X            equ 540    
Pit2Width        equ 48
DIR_RIGHT         equ 0
DIR_LEFT          equ 1

; =========================================================
; EXACT LEVEL 1-3 LAYOUT COORDINATES 
; =========================================================

; Column 1 (Height 1)
Stair1X equ 816
Stair1Y equ 130    

; Column 2 (Height 2)
Stair2X equ 832
Stair2Y equ 114   

; Column 3 (Height 3)
Stair3X equ 848
Stair3Y equ 98    

; Column 4 (Height 4)
Stair4X equ 864
Stair4Y equ 82     

; =========================================================
; FLAGPOLE 
; =========================================================
FlagPoleX   equ 915     
FlagTopY    equ 40      
FlagBaseX   equ 908    
FlagBaseY   equ 130     
FlagStartY  equ 44     
FlagEndY    equ 112     

; =========================================================
; BLOCK ROW AFTER PIT 2 
; =========================================================
RowY      equ 98
RowB1X    equ 656
RowB2X    equ 672
RowLX     equ 688    
RowB3X    equ 704
RowB4X    equ 720
RowMinX   equ 612     
RowMaxX   equ 734

Pit3X     equ 752
Pit3Width equ 48

Key_ESC           equ 01h
Key_Left          equ 4Bh
Key_Right         equ 4Dh
Key_Space         equ 39h
Key_P             equ 19h
Key_Enter         equ 1Ch
Key_LShift        equ 2Ah

HudHeight         equ 24      
StartTime         equ 300    

; =========================================================
; PHYSICS 
; =========================================================
AccelWalk         equ 0100h   
FrictionSpeed     equ 0080h   
MaxWalkSpeed      equ 0400h   
MaxRunSpeed       equ 0600h  
GravityFP         equ 0090h   
JumpStartSpeed    equ 0F7C0h  
JumpCutSpeed      equ 0FD00h  
MaxFallSpeed      equ 0600h   
StompBounceSpeed  equ 0FB80h  
TimerHz           equ 30      
PitDivisor        equ 39773   


ST_TITLE          equ 0
ST_PLAYING        equ 1
ST_PAUSED         equ 2
ST_DYING          equ 3
ST_LIFELOST       equ 4
ST_WIN            equ 5
ST_COMPLETE       equ 6
ST_GAMEOVER       equ 7
ST_EXIT           equ 8
