;Ye subroutine level 1-2 ke pipes, island blocks aur pit-related objects ko draw karti hai.
draw_level2:
    ; PIT 2 
    mov ax, Pit2X
    mov bx, Pit2Width
    call DrawPitClipped
    ; Pipe 1
    mov ax, Pipe1X
    sub ax, [cameraX]
    cmp ax, -32              
    jle near .skip_p1
    cmp ax, 320
    jge near .skip_p1
    push ax
    push Pipe1Y
    call near DrawPipeSprite
.skip_p1:
    ; Pipe 2
    mov ax, Pipe2X
    sub ax, [cameraX]
    cmp ax, -32
    jle near .skip_p2
    cmp ax, 320
    jge near .skip_p2
    push ax
    push Pipe2Y
    call near DrawPipeSprite
    mov ax, Pipe2X
    sub ax, [cameraX]
    push ax
    push Pipe2Y + 32
    call near DrawPipeNeck
.skip_p2:
    ; Island Brick 1
    cmp byte [cs:islandBrick1Hit], 1
    je near .skip_ibr1
    mov ax, IslandBrick1X
    sub ax, [cameraX]
    cmp ax, 0
    jl near .skip_ibr1
    cmp ax, 304
    jg near .skip_ibr1
    push ax
    push IslandFloatY
    call near DrawBrickSprite
.skip_ibr1:
    ; Island Question Block
    mov ax, IslandBlock1X
    sub ax, [cameraX]
    cmp ax, 0
    jl near .skip_iblk
    cmp ax, 304
    jg near .skip_iblk
    push ax
    push IslandFloatY
    xor ax, ax                 
    cmp byte [cs:islandBlockHit], 0
    je near .do_iblk
    mov ax, 1
.do_iblk:
    push ax
    call near DrawBlockSprite
.skip_iblk:
; Island Brick 2
    cmp byte [cs:islandBrick2Hit], 1
    je near .skip_ibr2
    mov ax, IslandBrick2X
    sub ax, [cameraX]
    cmp ax, 0
    jl near .skip_ibr2
    cmp ax, 304
    jg near .skip_ibr2
    push ax
    push IslandFloatY
    call near DrawBrickSprite
.skip_ibr2:
    ret
;Ye subroutine pit ko screen boundaries ke andar clip karke draw karti hai.
DrawPitClipped:
    push ax
    push bx
    push dx

    sub ax, [cameraX]         
    cmp ax, 0
    jge near .left_ok
    add bx, ax                
    xor ax, ax
.left_ok:
    cmp bx, 0
    jle near .done            
    mov dx, 320
    sub dx, ax              
    jle near .done
    cmp bx, dx
    jle near .right_ok
    mov bx, dx                
.right_ok:
    push ax
    push 146
    push bx
    push 54
    push Color_Sky
    call FillRect
.done:
    pop dx
    pop bx
    pop ax
    ret

islandBlockHit db 0
islandBrick1Hit db 0
islandBrick2Hit db 0
