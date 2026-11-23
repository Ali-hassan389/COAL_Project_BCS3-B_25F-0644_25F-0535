; Ye subroutine complete level frame draw karti hai: background, ground, blocks, enemies, items, HUD aur game events.
drawlevel:
    ; 1. Draw Infinite Sky Background
    push 0
    push 0
    push ScreenWidth
    push 146
    push Color_Sky
    call FillRect
    ; 2. Draw Infinite Ground 
    mov si, groundlayers
drawlayerloop:
    cmp word [cs:si], 0
    je near draw_pit
    push 0                  
    push word [cs:si]
    push ScreenWidth         
    push word [cs:si + 2]
    push word [cs:si + 4]
    call FillRect
    add si, 6
    jmp drawlayerloop
draw_pit:
    ; Pit 1 
    mov ax, Pit1X
    mov bx, Pit1Width
    call DrawPitClipped
drawspeckles:
    ; Draw scrolling speckles across the whole level 
    mov cx, 8
speckleloop:
    cmp cx, 1280
    jge near .done_specks
    ;don't draw speckles inside a pit
    cmp cx, Pit1X
    jl near .not_pit1
    cmp cx, Pit1End
    jl near .skip_speck      
.not_pit1:
    cmp cx, Pit2X
    jl near .calc_screen_x
    cmp cx, Pit2X + Pit2Width
    jl near .skip_speck       
.calc_screen_x:
    mov ax, cx
    sub ax, [cameraX]
    cmp ax, 0
    jl near .skip_speck       
    cmp ax, 318
    jge near .skip_speck    
    push ax
    push 160
    push 2
    push 2
    push Color_DarkDirt
    call FillRect
    push ax
    push 186
    push 2
    push 2
    push Color_DarkDirt
    call FillRect
    
.skip_speck:
    add cx, 32               
    jmp speckleloop
.done_specks:
    ; Mushroom Block
    mov ax, Block1X
    sub ax, [cameraX]
    cmp ax, 0                 
    jl near .skip_b1          
    cmp ax, 304
    jg near .skip_b1          
    push ax
    push Block1Y
    xor ax, ax
    cmp byte [block1Hit], 0
    je near .draw_b1
    mov ax, 1
.draw_b1:
    push ax
    call near DrawBlockSprite
.skip_b1:
    ; Brick 1
    cmp byte [cs:brick1Hit], 1
    je near .skip_br1
    mov ax, Brick1X
    sub ax, [cameraX]
    cmp ax, 0
    jl near .skip_br1
    cmp ax, 304
    jg near .skip_br1
    push ax
    push Brick1Y
    call near DrawBrickSprite
.skip_br1:
  ; Coin Block 2
    mov ax, Block2X
    sub ax, [cameraX]
    cmp ax, 0
    jl near .skip_b2
    cmp ax, 304
    jg near .skip_b2
    push ax
    push Block2Y
    xor ax, ax
    cmp byte [block2Hit], 0
    je near .draw_b2
    mov ax, 1
.draw_b2:
    push ax
    call near DrawBlockSprite
.skip_b2:
    ; Brick 2
    cmp byte [cs:brick2Hit], 1
    je near .skip_br2
    mov ax, Brick2X
    sub ax, [cameraX]
    cmp ax, 0
    jl near .skip_br2
    cmp ax, 304
    jg near .skip_br2
    push ax
    push Brick2Y
    call near DrawBrickSprite
.skip_br2:
    ; Coin Block 3
    mov ax, Block3X
    sub ax, [cameraX]
    cmp ax, 0
    jl near .skip_b3
    cmp ax, 304
    jg near .skip_b3
    push ax
    push Block3Y
    xor ax, ax
    cmp byte [block3Hit], 0
    je near .draw_b3
    mov ax, 1
.draw_b3:
    push ax
    call near DrawBlockSprite
.skip_b3:
    ; Brick 3
    cmp byte [cs:brick3Hit], 1
    je near .skip_br3
    mov ax, Brick3X
    sub ax, [cameraX]
    cmp ax, 0
    jl near .skip_br3
    cmp ax, 304
    jg near .skip_br3
    push ax
    push Brick3Y
    call near DrawBrickSprite
.skip_br3:
    ; Upper Floating Block
    mov ax, Block4X
    sub ax, [cameraX]
    cmp ax, 0
    jl near .skip_b4
    cmp ax, 304
    jg near .skip_b4
    push ax
    push Block4Y
    xor ax, ax
    cmp byte [block4Hit], 0
    je near .draw_b4
    mov ax, 1
.draw_b4:
    push ax
    call near DrawBlockSprite
.skip_b4:
    call draw_level2
	call draw_level3          
    call update_and_draw_coin
    call update_and_draw_coin2        
    call update_and_draw_shroom
    call update_and_draw_goomba
    call update_and_draw_goomba2
    call update_and_draw_goomba3
    call update_and_draw_koopa
    call update_draw_popups           
    call draw_hud                     ; top bar: score, coins, world, time, lives, health
    call handle_game_events           ; pause, clock, death, level complete
    ret
groundlayers:
    dw 146,  4, Color_Grass
    dw 150,  2, Color_GrassDark
    dw 152, 23, Color_Dirt
    dw 175,  4, Color_Grass
    dw 179,  2, Color_GrassDark
    dw 181, 19, Color_Dirt
    dw   0,  0, 0
